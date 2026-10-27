CREATE   PROCEDURE [dbo].[PR_SCM_IF_PLAN_GROUP_RELEASE_PSI_AMEND]
@p_instance_id nvarchar(MAX) = '-', @p_plan_date nvarchar(MAX) = '-', @p_release_id nvarchar(MAX) = '-', @p_plan_group_id nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_IF_PLAN_GROUP_RELEASE_PSI_AMEND                                    **/
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
/** 2017.11.15    JHHA           최초 작성                                                    **/
/** 2020.12.21    CYS            VD 공정 Plan Group 별 릴리즈 일 경우는 라인을 보지않는다. (D20201221~R1221.01)   **/
/** 2021.04.27    CYS			활성화 Plan Group 적용 및 통합 인계요청 적용	(D.20210427~R.0427.01)			**/
/** 2024.05.09    CYS          PDS-4MCC 버전 대응 **/ -- (D20240509~R0509.01) 
/** 2026.06.11    CYS		   [E20260610-001092]  PDS 적용된 인스턴스 중 전체 라인이 적용에 대한 수정 **/
/***********************************************************************************************/
/*
  EXEC PR_SCM_IF_PLAN_GROUP_RELEASE_PSI_AMEND
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
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_IF_PLAN_GROUP_RELEASE_PSI_AMEND'
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
  DECLARE @v_release_term_limit_flag nvarchar(5)   = 'N'
  DECLARE @v_release_term_limit_date date
  
  DECLARE @n_include_line_cnt Integer
        , @n_exclude_line_cnt Integer

  DECLARE @sysdate          DATETIME2 = GETDATE()
  DECLARE @v_insert_dttm    date
  
  DECLARE @n_count              integer = 0
        , @v_sqltext            nvarchar(MAX)
        , @v_sqltable           nvarchar(50)
        , @v_reltable           nvarchar(50)
        , @v_lgc_site           nvarchar(10)
        , @n_wo_create_check    integer = 0
        , @n_wo_create_loop     integer = 0
  

  DECLARE @v_temp1          nvarchar(1000)
  DECLARE @v_temp2          nvarchar(1000)
  
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
      FROM   FP_INSTANCE_FACTORY_M  A WITH (NOLOCK)
           , SCM_FACTORY_M          B WITH (NOLOCK)
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
              , @v_plan_id AS PLAN_ID
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
 , @p_release_id				  AS INSERT_ID	
              , dbo.FN_SITE_TIME(@v_lgc_site) AS INSERT_TIME
              --, MAX(UPDATE_ID)                AS UPDATE_ID
              , @p_release_id				  AS UPDATE_ID	
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
         --@@@ release 일자 제약하기 위해서
         
        SELECT  @v_release_term = ISNULL(MAX(CONVERT(INT, SEGMENT3)), 7)
        	   ,@v_release_term_limit_flag = ISNULL(MAX(ATTRIBUTE7), 'N')	
      		   ,@v_release_term_limit_date = CONVERT(DATE,ISNULL(MAX(ATTRIBUTE8), '29990101'))
        FROM   SCM_SYS_LOOKUP_VALUE WITH (NOLOCK)
        WHERE  LOOKUP_TYPE_CODE = 'INSTANCE_PLANNING_GROUP'
        AND    SEGMENT1 = @v_master_id        -- INSTANCE_ID
        AND    SEGMENT2 = @v_plan_group_id    -- PLAN_GROUP_ID
        AND    SEGMENT4 = 'DAY'

        --LOG 생성
        SET @v_message = '@v_release_term : ' + convert(nvarchar, @v_release_term, 23)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
		
        --LOG 생성
      SET @v_message = '@v_release_term_limit_flag : ' + @v_release_term_limit_flag
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
      
      --LOG 생성
      SET @v_message = '@v_release_term_limit_date : ' + convert(nvarchar, @v_release_term_limit_date, 23)
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

		-- @@@ Cell Product/Assy 코드 분리 때문에 특정 일자까지만 릴리즈 제한하기 위해 추가함 release term 구간 내에서 제한. by cys 20230621 
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
      
      END

      ----------------------------------------------------------------------------
      -- 2018.11.12 : WORK ORDER 채번 시 동시에 생성할 경우 WO 중복발생 가능
      --              LOOKUP 의 정보를 보고 아무도 안건들면, 먼저 할 수 있도록 함
      ----------------------------------------------------------------------------
      BEGIN
      
        SET @v_table_name = 'SCM_SYS_LOOKUP_VALUE'

        SET @n_wo_create_loop = 0
        
        WHILE 1=1
        BEGIN
        
          SET @n_wo_create_loop = @n_wo_create_loop + 1

          SELECT @n_wo_create_check = COUNT(1)
          FROM   SCM_SYS_LOOKUP_VALUE A
          WHERE  A.LOOKUP_TYPE_CODE = 'RELEASE_WO_CREATE_CHECK'
          AND    A.SEGMENT1         = 'N'
          
          IF    @n_wo_create_check > 0    -- lock 이 안잡혀 있거나
            or  @n_wo_create_loop  > 5    -- 10초가 넘을 경우
            BREAK
          ELSE
            WAITFOR DELAY '00:00:02'
          
        END

        UPDATE A
        SET    A.SEGMENT1         = 'Y'                               -- IS_LOCK 
             , A.SEGMENT2         = @v_master_id                      -- INSTANCE_ID
             , A.SEGMENT3         = '-'                               -- FACTORY_ID
             , A.SEGMENT4         = @v_plan_group_id                  -- PLAN_GROUP_ID
             , A.SEGMENT5         = CONVERT(NVARCHAR, GETDATE(), 21)  -- CHECK_TIME
             , A.MODIFY_USER_ID   = SUBSTRING(@v_release_id, 1, 30)   -- USER_ID
             , A.MODIFY_DATE      = GETDATE()
        FROM   SCM_SYS_LOOKUP_VALUE A 
        WHERE  A.LOOKUP_TYPE_CODE = 'RELEASE_WO_CREATE_CHECK'
        --AND    A.SEGMENT1         = 'N'
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = 'RELEASE_WO_CREATE_CHECK : ' + CONVERT(NVARCHAR, @n_row_count)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

      END

      BEGIN
      
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
             , SITE_ID
             , PLAN_DATE
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
             --, CASE WHEN @v_fix_count > 0 or @v_master_id = 'KR_E_PRE_A' THEN
             , 
               CASE WHEN A.FIX_TYPE = 'F' AND A.SEQ_SPLIT = 1 THEN A.ORG_WORK_ORDER_ID
                    WHEN A.FIX_TYPE = 'F' AND A.SEQ_SPLIT > 1 THEN A.NEW_PLAN_ORDER_ID
                    WHEN A.FIX_TYPE = 'N'                     THEN A.NEW_PLAN_ORDER_ID
                    ELSE ( CASE WHEN A.WO_HEAD = '-' THEN 'W' ELSE A.WO_HEAD END) + A.NEW_PLAN_ORDER_ID
               END  AS NEW_ORDER_ID
             , A.SITE_ID
             , A.PLAN_DATE
             , A.ERP_OPERATION_ID
             , A.SEQ
             , A.DEMAND_ID
             , @v_proc_name AS INSERT_ID
             , GETDATE()    AS INSERT_TIME
        FROM   (
                SELECT A.INSTANCE_ID
                     , A.SITE_ID
                     , A.WORK_ORDER_SPL_ID
                     , A.WORK_ORDER_ID
                     , CASE WHEN A.INSTANCE_CODE = '-' THEN 'W'
                            ELSE A.INSTANCE_CODE
                       END   
                           + DATE_CODE
                           + ERP_OPERATION_ID
           + '0'              -- RESERVE 값
                           + ORDER_ID
                         AS NEW_PLAN_ORDER_ID
                     , A.DEMAND_ID
                     , A.INSTANCE_CODE
                     , A.WO_HEAD
                     , A.PLAN_DATE
                     , A.ERP_OPERATION_ID
                     , A.SEQ
                     , A.ORG_WORK_ORDER_ID
                     , A.FIX_TYPE
                     , A.SEQ_SPLIT
                     , B.ORDER_ID
                FROM   (
                        SELECT A.INSTANCE_ID
                             , A.SITE_ID
                             , A.WORK_ORDER_SPL_ID
                             , A.WORK_ORDER_ID
                             , A.DEMAND_ID
                             , A.PRODUCTION_TYPE
                             , A.PLAN_DATE
                             , A.ERP_OPERATION_ID
                             , A.INSTANCE_CODE
                             , A.WO_HEAD
                             , A.ORG_WORK_ORDER_ID
                             , A.FIX_TYPE
                             , SUM(NEW_WORK_CHECK) OVER (PARTITION BY A.PLAN_DATE, A.ERP_OPERATION_ID  ORDER BY A.WORK_ORDER_SPL_ID) + ISNULL(B.MAX_ORDER_SEQ, 0) SEQ
                             , 1  AS SEQ_SPLIT
                             , SUBSTRING(A.PLAN_DATE, 3,2)    -- 년도
                                 + CASE SUBSTRING(A.PLAN_DATE, 5,2) WHEN '10' THEN 'A'
                                                                    WHEN '11' THEN 'B'
                                                                    WHEN '12' THEN 'C'
                                                                              ELSE SUBSTRING(A.PLAN_DATE, 6,1)
                                   END                                  -- 월
                                + SUBSTRING(A.PLAN_DATE, 7,2)    -- 일
                                 AS DATE_CODE
                        FROM   (
                                SELECT DISTINCT
                                       A.INSTANCE_ID
                                     , A.SITE_ID
                                     , A.WORK_ORDER_SPL_ID
                                     , A.WORK_ORDER_ID
                                     , A.DEMAND_ID
                                     , A.PRODUCTION_TYPE
                                     , A.PLAN_DATE
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
                                     , A.FIX_TYPE
                                     , A.NEW_WORK_CHECK
                                FROM   (
                                        SELECT A.INSTANCE_ID
                                             , A.SITE_ID
                                             , A.WORK_ORDER_SPL_ID
                                             , A.WORK_ORDER_ID
                                             , A.DEMAND_ID
                                             , A.PRODUCTION_TYPE
                                             , CONVERT(NVARCHAR, A.PLAN_DATE, 112) AS PLAN_DATE
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
                                             , CASE WHEN FIX_TYPE = 'F'               THEN 0
                                                                                      ELSE 1
                                               END  AS NEW_WORK_CHECK                                           
                                        FROM   FP_PRODUCTION_PLAN_GROUP_R A
                                             , FP_INSTANCE_CONFIG_M B WITH (NOLOCK)
                                             , SCM_OPERATION_M C WITH (NOLOCK)
                                        WHERE  A.INSTANCE_ID    = @v_master_id
                                        AND    A.PLAN_GROUP_ID  = @v_plan_group_id
                                        AND    A.EQUIPMENT_ID  <> 'NULL'            -- 2018.07.13 : 미등록설비는 RELEASE 되지 않도록..
                                        AND     EXISTS (  
                                SELECT  1 
                                                        FROM    (
										-- 라인을 보지않고 Group 별로 체크 (D20201221~R1221.01)
		                                                                  SELECT A.INSTANCE_ID, A.PLAN_ID
		                                                                       , B.FACTORY_ID, B.LINE_ID, B.OPERATION_ID, B.ELECTRODE_TYPE
		                                                                  FROM   SCM_FP_PLAN_GROUP_DETAIL_H A,
		                                                                         SCM_LINE_M                 B WITH (NOLOCK)
		                                                                  WHERE  A.INSTANCE_ID    = @v_master_id
		                                                                  AND    A.PLAN_DATE      = @v_plan_date
		                                                                  AND    A.PLAN_GROUP_ID  = @v_plan_group_id
		                                                                  AND    A.PLAN_GROUP_ID  = B.MODEL_TYPE
		                                                                  AND	  	B.OPERATION_ID != 'A6000'
		                                                                  UNION ALL
		                                                                  SELECT 	A.INSTANCE_ID, A.PLAN_ID
		                                                                      		 , B.FACTORY_ID, B.LINE_ID, B.OPERATION_ID, B.ELECTRODE_TYPE
		                                                                  FROM   SCM_FP_PLAN_GROUP_DETAIL_H A,
		                                                                         	SCM_LINE_M                 B WITH (NOLOCK)
		                                                                  WHERE  A.INSTANCE_ID    = @v_master_id
		                                                                  AND    A.PLAN_DATE      = @v_plan_date
		                                                                  AND    A.PLAN_GROUP_ID  = @v_plan_group_id
		                                                                  AND	  	B.OPERATION_ID = 'A6000'
  ) X
                                                        WHERE   X.INSTANCE_ID   = A.INSTANCE_ID 
                                                        AND     X.PLAN_ID       = A.FP_PLAN_ID 
                                                        AND     X.FACTORY_ID    = A.FACTORY_ID    -- A6000 의 경우 PLAN GROUP 별 LINE 지정이 불가능
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
                                WHERE  FIX_TYPE != 'P'
                               ) A
                               LEFT OUTER JOIN (-- 기존 발생된 ORDER SEQ 를 찾음.
                                                -- 2017.05.30 : INSTANCE 분리에 따라 INSTANCE_ID 를 빼고, SITE_ID 를 추가함
                                                SELECT A.SITE_ID, A.PLAN_DATE, A.ERP_OPERATION_ID, MAX(A.ORDER_SEQ) AS MAX_ORDER_SEQ
                                                FROM   FP_DAILY_PLAN_ORDER_SEQ_R A
                                                WHERE  SITE_ID    = @v_lgc_site
                                                AND    PLAN_DATE >= @v_plan_date
                                                GROUP  BY A.SITE_ID, A.PLAN_DATE, A.ERP_OPERATION_ID
                                                ) B
                                    ON    A.SITE_ID           = B.SITE_ID
                                    AND   A.PLAN_DATE         = B.PLAN_DATE
                                    AND   A.ERP_OPERATION_ID  = B.ERP_OPERATION_ID
                       ) A
                       INNER HASH JOIN FP_ORDER_SEQ B
                             ON   A.SEQ = B.ORDER_NO
               ) A
        /*
        SELECT DISTINCT
               A.INSTANCE_ID
             , @v_plan_id AS FP_PLAN_ID
             , A.WORK_ORDER_SPL_ID
             , A.WORK_ORDER_ID
             -- 확정 계획 첫번째꺼는 그걸 유지하고, 아니면 신규로 채번한다.
             --, CASE WHEN @v_fix_count > 0 or @v_master_id = 'KR_E_PRE_A' THEN
             , 
               CASE WHEN A.FIX_TYPE = 'F' AND A.SEQ_SPLIT = 1 THEN A.ORG_WORK_ORDER_ID
                    WHEN A.FIX_TYPE = 'F' AND A.SEQ_SPLIT > 1 THEN A.NEW_PLAN_ORDER_ID
                    WHEN A.FIX_TYPE = 'N'                     THEN A.NEW_PLAN_ORDER_ID
                    ELSE ( CASE WHEN A.WO_HEAD = '-' THEN 'W' ELSE A.WO_HEAD END) + A.NEW_PLAN_ORDER_ID
               END  AS NEW_ORDER_ID
             , A.SITE_ID
             , A.PLAN_DATE
             , A.ERP_OPERATION_ID
             , A.SEQ
             , A.DEMAND_ID
             , @v_proc_name AS INSERT_ID
             , GETDATE()    AS INSERT_TIME
        FROM   (
                SELECT A.INSTANCE_ID
                     , A.SITE_ID
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
                     , A.PLAN_DATE
  , A.ERP_OPERATION_ID
                     , A.SEQ
                     , A.ORG_WORK_ORDER_ID
               , A.FIX_TYPE
                     , A.SEQ_SPLIT
                     , B.ORDER_ID
                FROM   (
                        SELECT A.INSTANCE_ID
                             , A.SITE_ID
                             , A.WORK_ORDER_SPL_ID
                             , A.WORK_ORDER_ID
                             , A.DEMAND_ID
                             , A.PRODUCTION_TYPE
                             , A.PLAN_DATE
                             , A.ERP_OPERATION_ID
                             , A.INSTANCE_CODE
                             , A.WO_HEAD
                             , A.ORG_WORK_ORDER_ID
                             , A.FIX_TYPE
                             , SUM(NEW_WORK_CHECK) OVER (PARTITION BY A.ERP_OPERATION_ID  ORDER BY A.WORK_ORDER_SPL_ID) + ISNULL(B.MAX_ORDER_SEQ, 0) SEQ
                             , 1  AS SEQ_SPLIT
                        FROM   (
                                SELECT DISTINCT
                                       A.INSTANCE_ID
                                     , A.SITE_ID
                                     , A.WORK_ORDER_SPL_ID
                                     , A.WORK_ORDER_ID
                                     , A.DEMAND_ID
                                     , A.PRODUCTION_TYPE
                                     , A.PLAN_DATE
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
                                     , A.FIX_TYPE
                                     , A.NEW_WORK_CHECK
                                FROM   (
                                        SELECT A.INSTANCE_ID
                                             , A.SITE_ID
                                             , A.WORK_ORDER_SPL_ID
                                             , A.WORK_ORDER_ID
                                             , A.DEMAND_ID
                                             , A.PRODUCTION_TYPE
                                             , CONVERT(NVARCHAR, A.PLAN_DATE, 112) AS PLAN_DATE
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
                                             , CASE WHEN FIX_TYPE = 'F'               THEN 0
                                                                               ELSE 1
            END  AS NEW_WORK_CHECK                                           
                                        FROM   FP_PRODUCTION_PLAN_GROUP_R A
                                             , FP_INSTANCE_CONFIG_M B
                                             , SCM_OPERATION_M C
                                        WHERE  A.INSTANCE_ID    = @v_master_id
                                        AND    A.PLAN_GROUP_ID  = @v_plan_group_id
                                        AND     EXISTS (  
                                                        SELECT  1 
                                                        FROM    (
                                                                  SELECT A.INSTANCE_ID, A.PLAN_ID
                                                                       , B.FACTORY_ID, B.LINE_ID, B.OPERATION_ID, B.ELECTRODE_TYPE
                                                                  FROM   SCM_FP_PLAN_GROUP_DETAIL_H A,
                                                                         SCM_LINE_M                 B
                                                                  WHERE  A.INSTANCE_ID    = @v_master_id
                                                                  AND    A.PLAN_DATE      = @v_plan_date
                                                                  AND    A.PLAN_GROUP_ID  = @v_plan_group_id
                                                                  AND    A.PLAN_GROUP_ID  = B.MODEL_TYPE
         ) X
                        WHERE   X.INSTANCE_ID   = A.INSTANCE_ID 
                                                        AND     X.PLAN_ID       = A.FP_PLAN_ID 
                                                        --AND     X.FACTORY_ID    = A.FACTORY_ID    -- A6000 의 경우 PLAN GROUP 별 LINE 지정이 불가능
                                                        --AND     X.LINE_ID       = A.LINE_ID     
                                                        --AND     X.OPERATION_ID  = A.OPERATION_ID
                                                       )
                                        AND    A.INSTANCE_ID = B.INSTANCE_ID
                                        AND    B.CATEGORY_ID = 'EXPORT' 
                                        AND    B.KEY_ID = 'INSTANCE_CODE'
                                        AND    A.COMPANY_ID = C.COMPANY_ID
                                        AND    A.DIVISION_ID = C.DIVISION_ID
                                        AND    A.SITE_ID = C.SITE_ID
                                        AND    A.OPERATION_ID = C.OPERATION_ID
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
        */
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        SET @v_table_name = 'FP_DAILY_PLAN_ORDER_SEQ_R'

        UPDATE A
        SET    A.ORDER_SEQ = B.ORDER_SEQ
        FROM   FP_DAILY_PLAN_ORDER_SEQ_R A
             , (
                SELECT A.SITE_ID, A.PLAN_DATE, A.ERP_OPERATION_ID, MAX(ORDER_SEQ) AS ORDER_SEQ
                FROM   FP_DAILY_PLAN_ORDER_R A
                WHERE  INSTANCE_ID = @v_master_id
                AND    FP_PLAN_ID  = @v_plan_id
                GROUP  BY A.SITE_ID, A.PLAN_DATE, A.ERP_OPERATION_ID
               ) B
        WHERE  A.SITE_ID          = B.SITE_ID
        AND    A.PLAN_DATE        = B.PLAN_DATE
        AND    A.ERP_OPERATION_ID = B.ERP_OPERATION_ID
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        INSERT INTO FP_DAILY_PLAN_ORDER_SEQ_R
             (
               SITE_ID
             , PLAN_DATE
             , ERP_OPERATION_ID
             , ORDER_SEQ
             , INSERT_ID
             , INSERT_TIME
             )
        SELECT A.SITE_ID, A.PLAN_DATE, A.ERP_OPERATION_ID, A.ORDER_SEQ
             , @v_proc_name INSERT_ID, GETDATE() AS INSERT_TIME
        FROM   (
                SELECT A.SITE_ID, A.PLAN_DATE, A.ERP_OPERATION_ID, MAX(ORDER_SEQ) AS ORDER_SEQ
                FROM   FP_DAILY_PLAN_ORDER_R A
                WHERE  INSTANCE_ID = @v_master_id
                AND    FP_PLAN_ID  = @v_plan_id
                GROUP  BY A.SITE_ID, A.PLAN_DATE, A.ERP_OPERATION_ID
               ) A
  WHERE  NOT EXISTS (
                            SELECT 1
                            FROM   FP_DAILY_PLAN_ORDER_SEQ_R X
                            WHERE  X.SITE_ID          = A.SITE_ID
                            AND    X.PLAN_DATE        = A.PLAN_DATE
                            AND    X.ERP_OPERATION_ID = A.ERP_OPERATION_ID
                          )
                          
        SET @n_row_count = @@ROWCOUNT

        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      END

      SET @v_table_name = 'SCM_SYS_LOOKUP_VALUE'

      UPDATE A
      SET    A.SEGMENT1         = 'N'
           , A.ATTRIBUTE1       = CONVERT(NVARCHAR, GETDATE(), 21)  -- UNLOCK_TIME
      FROM   SCM_SYS_LOOKUP_VALUE A WITH (NOLOCK)
      WHERE  A.LOOKUP_TYPE_CODE = 'RELEASE_WO_CREATE_CHECK'
      AND    A.SEGMENT1         = 'Y'
      AND    A.SEGMENT2         = @v_master_id
      AND    A.SEGMENT3         = '-'
      AND    A.SEGMENT4         = @v_plan_group_id
      
      SET @n_row_count = @@ROWCOUNT
            
      --LOG 생성
      SET @v_message = 'RELEASE_WO_CREATE_CHECK : ' + CONVERT(NVARCHAR, @n_row_count)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

    END
    
    BEGIN
    
      -- FP_DAILY_PRODUCTION_PLAN_R
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
              , MARKET
              , FP_PRODUCTION_TYPE
              , INSERT_ID
              , INSERT_DTTM
              , SETUP_COLOR_CODE
              , VERSION		-- (D20240509~R0509.01) 
              , PLM_EC_NO	-- (D20240509~R0509.01) 
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
              , ISNULL(X.NEW_ORDER_ID, A.WORK_ORDER_SPL_ID) AS WORK_ORDER_SPL_ID
              --, A.WORK_ORDER_ID
              , ISNULL(X.NEW_ORDER_ID, A.WORK_ORDER_ID) AS WORK_ORDER_ID              
              , A.DEMAND_ID AS ORG_DEMAND_ID
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
              , 0     AS     BATCH_IN_QTY
              , 0     AS     BATCH_OUT_QTY
              , CASE  WHEN A.FIX_TYPE = 'F'               THEN 'F'
                      WHEN A.PLAN_DATE > @v_confirm_date  THEN 'P'
                      ELSE 'N'
                END   AS FIX_TYPE
              , A.PRODUCTION_TYPE
              , 86400   AS TOTAL_WORKING_TIME
              , 1       AS LINE_ITEM_SEQ
              , 1       AS OPERATION_ITEM_SEQ   
              , A.BATCH_ORDER_ID
              , A.MFG_WEEK
              , A.DEMAND_DIVISION_ID
              , A.MARKET
              , A.FP_PRODUCTION_TYPE
              , @v_proc_name    AS INSERT_ID
              , GETDATE()       AS INSERT_TIME
              , A.SETUP_COLOR_CODE
              , A.VERSION 		-- (D20240509~R0509.01) 
              , A.PLM_EC_NO		-- (D20240509~R0509.01) 
        FROM    FP_PRODUCTION_PLAN_GROUP_R A
                INNER JOIN FP_DAILY_PLAN_ORDER_R X
                     ON    X.INSTANCE_ID = @v_master_id
                     AND   X.FP_PLAN_ID = @v_plan_id
                     AND   A.WORK_ORDER_SPL_ID = X.WORK_ORDER_SPL_ID
        WHERE   A.INSTANCE_ID   = @v_master_id
        AND     A.PLAN_GROUP_ID = @v_plan_group_id
        AND     EXISTS (  
                        SELECT  1 
                        FROM    (
				 -- 라인을 보지않고 Group 별로 체크 (D20201221~R1221.01)
                                  SELECT A.INSTANCE_ID, A.PLAN_ID
                                       , B.FACTORY_ID, B.LINE_ID, B.OPERATION_ID, B.ELECTRODE_TYPE
                                  FROM   SCM_FP_PLAN_GROUP_DETAIL_H A WITH(NOLOCK),
                                         SCM_LINE_M                 B WITH(NOLOCK)
                                  WHERE  A.INSTANCE_ID    = @v_master_id
                                  AND    A.PLAN_DATE      = @v_plan_date
                                  AND    A.PLAN_GROUP_ID  = @v_plan_group_id
                                  AND    A.PLAN_GROUP_ID  = B.MODEL_TYPE
                                  AND	  	B.OPERATION_ID != 'A6000'
                                  UNION ALL
                                  SELECT 	A.INSTANCE_ID, A.PLAN_ID
                                      		 , B.FACTORY_ID, B.LINE_ID, B.OPERATION_ID, B.ELECTRODE_TYPE
                                  FROM   SCM_FP_PLAN_GROUP_DETAIL_H A WITH(NOLOCK),
                                         	SCM_LINE_M                 B WITH (NOLOCK)
                                  WHERE  A.INSTANCE_ID    = @v_master_id
                                  AND    A.PLAN_DATE      = @v_plan_date
                    AND    A.PLAN_GROUP_ID  = @v_plan_group_id
              AND	  	B.OPERATION_ID = 'A6000'
    ) X
                        WHERE   X.INSTANCE_ID   = A.INSTANCE_ID 
                        AND     X.PLAN_ID       = A.FP_PLAN_ID 
                        AND     X.FACTORY_ID    = A.FACTORY_ID          -- A6000 의 경우 PLAN GROUP 별 LINE 지정이 불가능
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
      
      -- FP_PRODUCTION_PLAN_EQUIPMENT_R
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
              , FP_PRODUCTION_TYPE
              , INSERT_ID
              , INSERT_TIME
              , VERSION		-- (D20240509~R0509.01) 
              , PLM_EC_NO	-- (D20240509~R0509.01) 
              )
        SELECT  DISTINCT
                A.INSTANCE_ID
              , @v_plan_id AS FP_PLAN_ID
              , A.COMPANY_ID
              , A.DIVISION_ID
              , A.SITE_ID
              , A.PLANT_ID
              , A.FACTORY_ID
              , ISNULL(X.NEW_ORDER_ID, A.WORK_ORDER_SPL_ID) AS WORK_ORDER_SPL_ID
              , ISNULL(X.NEW_ORDER_ID, A.WORK_ORDER_ID) AS WORK_ORDER_ID
              , '-' AS BATCH_ORDER_ID
              , '-' AS BIN_ORDER_ID
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
                      WHEN A.ITEM_UOM = 'EA'  THEN CEILING(A.PLAN_IN_QTY)
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
              , A.FP_PRODUCTION_TYPE
, @v_proc_name    AS INSERT_ID
              , GETDATE()       AS INSERT_TIME   
              , A.VERSION		-- (D20240509~R0509.01) 
              , A.PLM_EC_NO		-- (D20240509~R0509.01) 
        FROM    FP_PRODUCTION_PLAN_GROUP_R A
                INNER JOIN FP_DAILY_PLAN_ORDER_R X
                     ON    X.INSTANCE_ID = @v_master_id
                     AND   X.FP_PLAN_ID = @v_plan_id
                     AND   A.WORK_ORDER_SPL_ID = X.WORK_ORDER_SPL_ID
        WHERE   A.INSTANCE_ID   = @v_master_id
        AND     A.PLAN_GROUP_ID = @v_plan_group_id
        AND     EXISTS (  
                        SELECT  1 
                        FROM    (
					-- 라인을 보지않고 Group 별로 체크 (D20201221~R1221.01)
		                                  SELECT A.INSTANCE_ID, A.PLAN_ID
		                                       , B.FACTORY_ID, B.LINE_ID, B.OPERATION_ID, B.ELECTRODE_TYPE
		                                  FROM   SCM_FP_PLAN_GROUP_DETAIL_H A WITH(NOLOCK),
		                                         SCM_LINE_M                 B WITH (NOLOCK)
		                                  WHERE  A.INSTANCE_ID    = @v_master_id
		                                  AND    A.PLAN_DATE      = @v_plan_date
		                                  AND    A.PLAN_GROUP_ID  = @v_plan_group_id
		                                  AND    A.PLAN_GROUP_ID  = B.MODEL_TYPE
		                                  AND	  	B.OPERATION_ID != 'A6000'
                                          UNION ALL
                                          SELECT 	A.INSTANCE_ID, A.PLAN_ID
                                              		 , B.FACTORY_ID, B.LINE_ID, B.OPERATION_ID, B.ELECTRODE_TYPE
                                          FROM   SCM_FP_PLAN_GROUP_DETAIL_H A WITH(NOLOCK),
                                                 	SCM_LINE_M                 B WITH (NOLOCK)
                                          WHERE  A.INSTANCE_ID    = @v_master_id
                                          AND    A.PLAN_DATE      = @v_plan_date
                                          AND    A.PLAN_GROUP_ID  = @v_plan_group_id
                                          AND	  	B.OPERATION_ID = 'A6000'
                                ) X
                        WHERE   X.INSTANCE_ID   = A.INSTANCE_ID 
                        AND     X.PLAN_ID       = A.FP_PLAN_ID      
                        AND     X.FACTORY_ID    = A.FACTORY_ID      -- A6000 의 경우 PLAN GROUP 별 LINE 지정이 불가능
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

      -- FP_PRODUCTION_PLAN_R
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
              , FP_PRODUCTION_TYPE
              , INSERT_ID
              , INSERT_TIME        
              , VERSION		-- (D20240509~R0509.01) 
              , PLM_EC_NO	-- (D20240509~R0509.01) 
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
              , ISNULL(X.NEW_ORDER_ID, A.WORK_ORDER_ID) AS WORK_ORDER_ID
              --, A.BATCH_ORDER_ID
              , '-' AS BATCH_ORDER_ID
              --, A.BIN_ORDER_ID
              , '-' AS BIN_ORDER_ID
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
              , A.FP_PRODUCTION_TYPE
              , @v_proc_name    AS INSERT_ID
              , GETDATE()       AS INSERT_TIME  
              , A.VERSION		-- (D20240509~R0509.01) 
              , A.PLM_EC_NO		-- (D20240509~R0509.01) 
        FROM    FP_PRODUCTION_PLAN_GROUP_R A
                INNER JOIN FP_DAILY_PLAN_ORDER_R X
                     ON    X.INSTANCE_ID = @v_master_id
                     AND   X.FP_PLAN_ID = @v_plan_id
                     AND   A.WORK_ORDER_SPL_ID = X.WORK_ORDER_SPL_ID
        WHERE   A.INSTANCE_ID   = @v_master_id
        AND     A.PLAN_GROUP_ID = @v_plan_group_id
        AND     EXISTS (  
                        SELECT  1 
                        FROM    (
					-- 라인을 보지않고 Group 별로 체크 (D20201221~R1221.01)
		                    SELECT A.INSTANCE_ID, A.PLAN_ID
		                                       , B.FACTORY_ID, B.LINE_ID, B.OPERATION_ID, B.ELECTRODE_TYPE
		                                  FROM   SCM_FP_PLAN_GROUP_DETAIL_H A WITH(NOLOCK),
		                                         SCM_LINE_M                 B WITH (NOLOCK)
		                                  WHERE  A.INSTANCE_ID    = @v_master_id
		                                  AND    A.PLAN_DATE      = @v_plan_date
		                                  AND    A.PLAN_GROUP_ID  = @v_plan_group_id
		                                  AND    A.PLAN_GROUP_ID  = B.MODEL_TYPE
                                  			AND	  	B.OPERATION_ID != 'A6000'
	                                      UNION ALL
	                                      SELECT 	A.INSTANCE_ID, A.PLAN_ID
	                                          		 , B.FACTORY_ID, B.LINE_ID, B.OPERATION_ID, B.ELECTRODE_TYPE
	                                      FROM   SCM_FP_PLAN_GROUP_DETAIL_H A WITH(NOLOCK),
	                                             	SCM_LINE_M                 B WITH (NOLOCK)
	                                      WHERE  A.INSTANCE_ID    = @v_master_id
	                                      AND    A.PLAN_DATE      = @v_plan_date
	                                      AND    A.PLAN_GROUP_ID  = @v_plan_group_id
	                                      AND	  	B.OPERATION_ID = 'A6000'
                                ) X
                        WHERE   X.INSTANCE_ID   = A.INSTANCE_ID 
                        AND     X.PLAN_ID       = A.FP_PLAN_ID 
                        AND     X.FACTORY_ID    = A.FACTORY_ID      -- A6000 의 경우 PLAN GROUP 별 LINE 지정이 불가능
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
             , FP_PRODUCTION_TYPE
             , INSERT_ID
             , INSERT_TIME
             , VERSION		-- (D20240509~R0509.01) 
             , PLM_EC_NO	-- (D20240509~R0509.01) 
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
             , A.PRODUCTION_TYPE          AS FP_PRODUCTION_TYPE
             , A.INSERT_ID
             , A.INSERT_TIME
             , A.VERSION	-- (D20240509~R0509.01) 
             , A.PLM_EC_NO	-- (D20240509~R0509.01) 
        FROM   FP_DAILY_INSTANCE_ORDER_STATUS A
               LEFT OUTER JOIN SCM_ITEM_M       C WITH(NOLOCK)
                    ON    A.COMPANY_ID = C.COMPANY_ID
                    AND   A.DIVISION_ID = C.DIVISION_ID
                    AND   A.SITE_ID = C.SITE_ID
                    AND   A.ITEM_ID = C.ITEM_ID
               LEFT OUTER JOIN SCM_EQUIPMENT_M  D WITH(NOLOCK)
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
                                        FROM   SCM_EQUIPMENT_M  WITH(NOLOCK)
                                        WHERE  ACTIVE_FLAG = 'Y'
                                        AND    EQUIPMENT_TYPE = 'M'
                                       ) A
                                WHERE  SEQ = 1    -- ## 대표설비만...                      
                               ) E
                    ON   A.EQUIPMENT_ID = E.RESOURCE_ID                    
        WHERE  A.INSTANCE_ID  = @v_master_id
        AND    A.ORDER_TYPE   = 'WO'
        AND    A.WO_STATUS    NOT IN ('AMEND')    -- AMEND 는 대상에서 제외해야 함..
        AND     EXISTS (  
                        SELECT  1 
   FROM    (
                                  SELECT A.INSTANCE_ID, A.PLAN_ID
                                       , B.FACTORY_ID, B.LINE_ID, B.OPERATION_ID, B.ELECTRODE_TYPE
                                  FROM   SCM_FP_PLAN_GROUP_DETAIL_H A WITH(NOLOCK),
                                         SCM_LINE_M                 B WITH (NOLOCK)
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
        AND     NOT EXISTS (-- PEGGING 안된 확정 WO 찾기
                            SELECT  1 
                            FROM   (
                                    SELECT  WORK_ORDER_ID
                                    FROM    FP_PRODUCTION_PLAN_EQUIPMENT_R B 
                                    WHERE   B.INSTANCE_ID = @v_master_id
                                    AND     B.FP_PLAN_ID  = @v_plan_id
                                   ) B
                            WHERE  B.WORK_ORDER_ID = A.WORK_ORDER_SPL_ID
                           )
                         
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = 'PLAN_QTY = 0 : ' + CONVERT(NVARCHAR, @n_row_count)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
		
        -- (D20240509~R0509.01) 
        IF 'Y' = (	SELECT	ISNULL(MAX(SEGMENT2),'N') FROM	SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
					WHERE 1=1
					AND	   LOOKUP_TYPE_CODE	= 'PDS_INSTANCE'
					AND	   SEGMENT1			= @v_master_id
					AND    ACTIVE_FLAG		= 'Y'
				 )
		 BEGIN	-- 확정계획에 넘어가지 않아야 하기때문에 mes wo 전송(PR_XIF_MES_WO_S) 관련 테이블에만 update 해준다. (이후 생성되는 모든 정보가 더블로 보임) 

	      	UPDATE  A
			--SET		A.PLM_EC_NO = ISNULL(B.MAX_VERSION,'-')
			SET		A.VERSION = ISNULL(B.MAX_VERSION,'-')
			FROM	FP_PRODUCTION_PLAN_EQUIPMENT_R A
					INNER JOIN (
--										SELECT 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.SHOP_GROUP_ID, A.FACTORY_ID, A.MODEL_ID, B.PRODUCTION_TYPE
--												, MAX(VERSION) OVER (PARTITION BY A.FACTORY_ID, A.MODEL_ID, A.VERSION_TYPE ORDER BY A.APPLY_DATE DESC, VERSION) AS MAX_VERSION
--										FROM 	FP_PDS_VERSION_M A WITH(NOLOCK)
--												INNER JOIN (
--									
--																SELECT DISTINCT SEGMENT3 AS PRODUCTION_TYPE, ATTRIBUTE1 AS VERSION_TYPE
--																FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
--																WHERE  1=1
--																AND	   LOOKUP_TYPE_CODE	= 'INSTANCE_CONV_PRIORITY'
--																AND	   SEGMENT1			= @v_master_id
--																AND    ACTIVE_FLAG		= 'Y'
--																AND    ATTRIBUTE11		= 'Y'
--															) B
--												ON	1=1
--												AND A.VERSION_TYPE = B.VERSION_TYPE
--										WHERE 	1=1	
										--AND 	A.VERSION_TYPE = 'MASS'
										SELECT 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.SHOP_GROUP_ID, A.FACTORY_ID, A.MODEL_ID, B.PRODUCTION_TYPE, A.VERSION_TYPE, A.VERSION AS MAX_VERSION
												, DENSE_RANK() OVER (PARTITION BY A.FACTORY_ID, A.MODEL_ID, A.VERSION_TYPE ORDER BY A.APPLY_DATE DESC, VERSION) AS MAX_SEQ
										FROM 	FP_PDS_VERSION_M A WITH(NOLOCK)
												INNER JOIN (
												
																SELECT DISTINCT SEGMENT3 AS PRODUCTION_TYPE, ATTRIBUTE1 AS VERSION_TYPE
																FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
																WHERE  1=1
																AND	   LOOKUP_TYPE_CODE	= 'INSTANCE_CONV_PRIORITY'
																AND	   SEGMENT1			= @v_master_id
																AND    ACTIVE_FLAG		= 'Y'
																AND    ATTRIBUTE11		= 'Y'
															) B
												ON	1=1
												AND A.VERSION_TYPE = B.VERSION_TYPE
										WHERE 	1=1	
					) B
					ON 1=1
					AND A.COMPANY_ID	=	B.COMPANY_ID	   
					AND	A.DIVISION_ID	=	B.DIVISION_ID	  
					AND	A.SITE_ID		=	B.SITE_ID		 
					AND	A.PLANT_ID		=	B.PLANT_ID		 
					AND	A.FACTORY_ID	=	B.FACTORY_ID	 
					AND	A.TOP_ITEM_ID	=	B.MODEL_ID		
					AND A.PRODUCTION_TYPE = B.PRODUCTION_TYPE
					AND B.MAX_SEQ		= 1
			WHERE	1=1
			AND		A.INSTANCE_ID		= @v_master_id
			AND		A.FP_PLAN_ID		= @v_plan_id
			-- 추가
			AND 	( EXISTS (	-- PDS 오픈지원, 해당 라인만 전송 20240605
								SELECT 1
								FROM (
										SELECT	SEGMENT1 AS INSTANCE_ID, SEGMENT2 AS PLANT_ID, SEGMENT3 AS FACTORY_ID, SEGMENT4 AS LINE_ID
										FROM	SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
										WHERE 1=1
										AND	   LOOKUP_TYPE_CODE	= 'PDS_APPLY_LINE'
										AND	   SEGMENT1			= @v_master_id
										AND    ACTIVE_FLAG		= 'Y'
									) X
								WHERE 1=1
								AND A.INSTANCE_ID = X.INSTANCE_ID
								AND A.PLANT_ID = X.PLANT_ID
								AND A.FACTORY_ID = X.FACTORY_ID
								AND A.LINE_ID = X.LINE_ID
							)
					  	OR EXISTS (	-- [E20260610-001092]  PDS 적용된 인스턴스 중 전체 라인이 적용되면 active N 처리하여 전체 적용되도록 수정 by cys 20260513
									SELECT 1 
									WHERE 1= (
												SELECT	'1'
												FROM	SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
												WHERE 1=1
												AND	   LOOKUP_TYPE_CODE	= 'PDS_APPLY_LINE'
												AND	   SEGMENT1			= @v_master_id
												AND    ACTIVE_FLAG		= 'Y'	
												HAVING COUNT(1) = 0
											  )
									 )
					) -- AND end
			
	      --LOG 생성
	      SET @v_message = 'PDS MAX_VERSION : ' + CONVERT(NVARCHAR, @n_row_count)
	      SET @n_log_count = @n_log_count + 1
	      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
	
	    END
	    
	    
        UPDATE A
        SET    A.PRODUCTION_TYPE  = B.SCP_PRODUCTION_TYPE
        FROM   FP_PRODUCTION_PLAN_EQUIPMENT_R A
             , (
                SELECT B.SEGMENT1         AS DIVISION_ID
                     , B.ATTRIBUTE1       AS SCP_PRODUCTION_TYPE
                     , MAX(B.ATTRIBUTE2)  AS FP_PRODUCTION_TYPE
                FROM   SCM_SYS_LOOKUP_TYPE_M A WITH (NOLOCK)
                     , SCM_SYS_LOOKUP_VALUE  B WITH (NOLOCK)
     WHERE  A.LOOKUP_TYPE_CODE = 'DIVISION_DEMAND_TYPE'
                AND    A.LOOKUP_TYPE_CODE = B.LOOKUP_TYPE_CODE
                AND    B.ATTRIBUTE3       = 'Y'                 -- SCP TARGET FLAG
                AND    A.ACTIVE_FLAG      = 'Y'
                AND    B.ACTIVE_FLAG      = 'Y'
                GROUP  BY B.SEGMENT1, B.ATTRIBUTE1
                HAVING B.ATTRIBUTE1 <> MAX(B.ATTRIBUTE2)
              ) B
        WHERE  A.INSTANCE_ID      = @v_master_id
        AND    A.FP_PLAN_ID       = @v_plan_id
        AND    A.DIVISION_ID      = B.DIVISION_ID
        AND    A.PRODUCTION_TYPE  = B.FP_PRODUCTION_TYPE
        
        --LOG 생성
        SET @v_message = 'SCP_PRODUCTION_TYPE : ' + CONVERT(NVARCHAR, @n_row_count)
        SET @n_log_count = @n_log_count + 1
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

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
             , FP_PRODUCTION_TYPE
             , INSERT_ID
             , INSERT_TIME
             , VERSION		-- (D20240509~R0509.01) 
             , PLM_EC_NO	-- (D20240509~R0509.01) 
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
             , A.PRODUCTION_TYPE    AS FP_PRODUCTION_TYPE
             , A.INSERT_ID
             , A.INSERT_TIME
             , A.VERSION	-- (D20240509~R0509.01) 
             , A.PLM_EC_NO	-- (D20240509~R0509.01) 
        FROM   FP_DAILY_INSTANCE_ORDER_STATUS A
         LEFT OUTER JOIN SCM_ITEM_M       C WITH(NOLOCK)
                    ON    A.COMPANY_ID = C.COMPANY_ID
                    AND   A.DIVISION_ID = C.DIVISION_ID
                    AND   A.SITE_ID = C.SITE_ID
                    AND   A.ITEM_ID = C.ITEM_ID
               LEFT OUTER JOIN SCM_EQUIPMENT_M  D WITH(NOLOCK)
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
                                        FROM   SCM_EQUIPMENT_M  WITH(NOLOCK)
                                        WHERE  ACTIVE_FLAG = 'Y'
                                        AND    EQUIPMENT_TYPE = 'M'
                                       ) A
                                WHERE  SEQ = 1    -- ## 대표설비만...                      
                               ) E
                    ON   A.EQUIPMENT_ID = E.RESOURCE_ID                    
        WHERE  A.INSTANCE_ID  = @v_master_id
        AND    A.ORDER_TYPE   = 'WO'
        AND    A.WO_STATUS    NOT IN ('AMEND')    -- AMEND 는 대상에서 제외해야 함..
        AND     EXISTS (  
                        SELECT  1 
                        FROM    (
                                  SELECT A.INSTANCE_ID, A.PLAN_ID
                                       , B.FACTORY_ID, B.LINE_ID, B.OPERATION_ID, B.ELECTRODE_TYPE
                                  FROM   SCM_FP_PLAN_GROUP_DETAIL_H A WITH(NOLOCK),
                                         SCM_LINE_M                 B WITH (NOLOCK)
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
        AND     NOT EXISTS (-- PEGGING 안된 확정 WO 찾기
                            SELECT  1 
                            FROM   (
                                    SELECT  WORK_ORDER_ID
                                    FROM    FP_PRODUCTION_PLAN_R B 
                                    WHERE   B.INSTANCE_ID = @v_master_id
                                   AND     B.FP_PLAN_ID  = @v_plan_id
              ) B
                            WHERE   B.WORK_ORDER_ID = A.WORK_ORDER_SPL_ID
                           )

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = 'PLAN_QTY = 0 : ' + CONVERT(NVARCHAR, @n_row_count)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        UPDATE A
        SET    A.PRODUCTION_TYPE  = B.SCP_PRODUCTION_TYPE
        FROM   FP_PRODUCTION_PLAN_R A
             , (
                SELECT B.SEGMENT1         AS DIVISION_ID
                     , B.ATTRIBUTE1       AS SCP_PRODUCTION_TYPE
                     , MAX(B.ATTRIBUTE2)  AS FP_PRODUCTION_TYPE
                FROM   SCM_SYS_LOOKUP_TYPE_M A WITH (NOLOCK)
                     , SCM_SYS_LOOKUP_VALUE  B WITH (NOLOCK)
                WHERE  A.LOOKUP_TYPE_CODE = 'DIVISION_DEMAND_TYPE'
                AND    A.LOOKUP_TYPE_CODE = B.LOOKUP_TYPE_CODE
                AND    B.ATTRIBUTE3       = 'Y'                 -- SCP TARGET FLAG
                AND    A.ACTIVE_FLAG      = 'Y'
                AND    B.ACTIVE_FLAG      = 'Y'
                GROUP  BY B.SEGMENT1, B.ATTRIBUTE1
                HAVING B.ATTRIBUTE1 <> MAX(B.ATTRIBUTE2)
              ) B
        WHERE  A.INSTANCE_ID      = @v_master_id
        AND    A.FP_PLAN_ID       = @v_plan_id
        AND    A.DIVISION_ID      = B.DIVISION_ID
        AND    A.PRODUCTION_TYPE  = B.FP_PRODUCTION_TYPE
        
        --LOG 생성
        SET @v_message = 'SCP_PRODUCTION_TYPE : ' + CONVERT(NVARCHAR, @n_row_count)
        SET @n_log_count = @n_log_count + 1
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
      
      END

      -- RELEASE PLAN INFO 정보 생성 및 RELEASE FIX PLAN, RELEASE FULL PLAN 삭제
      BEGIN
      
        SET @v_table_name = 'FP_RELEASE_PLAN_INFO_H'
        
        DELETE FROM A
        FROM   FP_RELEASE_PLAN_INFO_H A
        WHERE  A.INSTANCE_ID      = @v_master_id
        AND    A.RELEASE_PLAN_ID  = @v_plan_id
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = CONVERT(NVARCHAR, @n_row_count)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

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

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = CONVERT(NVARCHAR, @n_row_count)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null


        SET @v_table_name = 'FP_RELEASE_FIX_PLAN_H'

        DELETE FROM A
        FROM FP_RELEASE_FIX_PLAN_H  A
        WHERE  A.INSTANCE_ID      = @v_master_id
        AND    A.RELEASE_PLAN_ID  = @v_plan_id

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = CONVERT(NVARCHAR, @n_row_count)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

        SET @v_table_name = 'FP_RELEASE_FULL_PLAN_H'

        DELETE FROM A
        FROM   FP_RELEASE_FULL_PLAN_H A
        WHERE  A.INSTANCE_ID      = @v_master_id
        AND    A.RELEASE_PLAN_ID  = @v_plan_id

        SET @n_row_count = @@ROWCOUNT
   
        --LOG 생성
        SET @v_message = CONVERT(NVARCHAR, @n_row_count)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null
      
      END

      -- 2018.01.10 : 확정 이외의 계획에 대해 DAILY PP 를 생성한다.
      -- 2018.03.19 : 주의 >> FP_RELEASE_PLAN_INFO_H 생성 후에 실행되어야 한다.
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
              , MARKET
              , FP_PRODUCTION_TYPE
              , INSERT_ID
              , INSERT_DTTM
              , SETUP_COLOR_CODE
              , VERSION		-- (D20240509~R0509.01) 
              , PLM_EC_NO	-- (D20240509~R0509.01) 
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
              , A.DEMAND_ID AS ORG_DEMAND_ID
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
              , CASE  WHEN A.ITEM_UOM = 'EA' THEN CEILING(A.PLAN_QTY)
                      ELSE A.PLAN_QTY
                END   AS PLAN_QTY
              , CASE  WHEN A.ITEM_UOM = 'EA' THEN CEILING(A.PLAN_IN_QTY)
                      ELSE A.PLAN_IN_QTY
                END   AS PLAN_IN_QTY
              , A.ITEM_UOM
              , A.ROLL_IN_QTY
              , A.ROLL_OUT_QTY
              , A.JR_IN_QTY
              , A.JR_OUT_QTY
              , 0     AS     BATCH_IN_QTY
              , 0     AS     BATCH_OUT_QTY
              , 'P'   AS FIX_TYPE
        , A.PRODUCTION_TYPE
              , 86400   AS TOTAL_WORKING_TIME
              , 1  AS LINE_ITEM_SEQ
              , 1       AS OPERATION_ITEM_SEQ   
              , A.BATCH_ORDER_ID
              , A.MFG_WEEK
              , A.DEMAND_DIVISION_ID
              , A.MARKET
              , A.FP_PRODUCTION_TYPE
              , @v_proc_name    AS INSERT_ID
              , GETDATE()       AS INSERT_TIME
              , A.SETUP_COLOR_CODE
              , A.VERSION		-- (D20240509~R0509.01) 
              , A.PLM_EC_NO		-- (D20240509~R0509.01) 
        FROM   FP_PRODUCTION_PLAN_GROUP_R A,
               FP_RELEASE_PLAN_INFO_H B
        WHERE  A.INSTANCE_ID      = @v_master_id
        AND    B.RELEASE_PLAN_ID  = @v_plan_id
        AND    A.INSTANCE_ID      = B.INSTANCE_ID
        AND    A.FP_PLAN_ID       = B.AMEND_PLAN_ID
        AND    A.PLAN_GROUP_ID    = B.PLAN_GROUP_ID
        AND    A.PLAN_GROUP_ID    = @v_plan_group_id    -- PLAN_GROUP_ID별로 RELEASE
        AND    A.PLAN_QTY         > 0
        AND    NOT EXISTS (
                            SELECT 1
                            FROM   (
                                    SELECT A.WORK_ORDER_ID
                                    FROM   FP_DAILY_PLAN_ORDER_R          A,
                                          FP_PRODUCTION_PLAN_EQUIPMENT_R B WITH (NOLOCK)
                                    WHERE  A.INSTANCE_ID  = @v_master_id
                                    AND    A.FP_PLAN_ID   = @v_plan_id
                                    AND    A.INSTANCE_ID  = B.INSTANCE_ID
                                    AND    A.FP_PLAN_ID   = B.FP_PLAN_ID
                                    AND    A.NEW_ORDER_ID = B.WORK_ORDER_ID
                                   ) X
               WHERE  X.WORK_ORDER_ID = A.WORK_ORDER_ID
                          )

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = CONVERT(NVARCHAR, @n_row_count)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

		--20200522~20200522 BOM 대치모델이 있는 경우 소요량이 잘 못나와 FN_GET_REQ_QTY_MODEL 으로 변경
		-- amend 는 floor 인데 release 는 floor 가 없어 넣지 않음
		UPDATE A
        SET    A.CELL_IN_QTY =   A.PLAN_IN_QTY / ISNULL(dbo.FN_GET_REQ_QTY_MODEL(A.PLANT_ID, A.TOP_ITEM_ID, A.ITEM_ID, A.PLAN_DATE), 1) 
             , A.CELL_OUT_QTY =  A.PLAN_QTY / ISNULL(dbo.FN_GET_REQ_QTY_MODEL(A.PLANT_ID, A.TOP_ITEM_ID, A.ITEM_ID, A.PLAN_DATE), 1) 
        FROM   FP_DAILY_PRODUCTION_PLAN_R A
        WHERE  A.INSTANCE_ID  = @v_master_id
        AND    A.FP_PLAN_ID   = @v_plan_id
		/*
        UPDATE A
        SET    A.CELL_IN_QTY =   ( CASE WHEN ISNULL(ACCUMULATED_CHILD_QTY, 0) = 0 THEN 0
                                        ELSE A.PLAN_IN_QTY / B.ACCUMULATED_CHILD_QTY
                                   END  )
             , A.CELL_OUT_QTY =  ( CASE WHEN ISNULL(ACCUMULATED_CHILD_QTY, 0) = 0 THEN 0
                                        ELSE A.PLAN_QTY / B.ACCUMULATED_CHILD_QTY
                                   END  )
        FROM   FP_DAILY_PRODUCTION_PLAN_R A
               LEFT OUTER JOIN (
                                SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, MODEL_ID, CHILD_ITEM_ID
                                     , SUM(ACCUMULATED_CHILD_QTY) AS ACCUMULATED_CHILD_QTY
                                FROM   (                               
                                        SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, MODEL_ID, PARENT_ITEM_ID, CHILD_ITEM_ID
                                             , MAX(ISNULL(ACCUMULATED_CHILD_QTY, 0)) AS ACCUMULATED_CHILD_QTY
                                        FROM   SCM_MODEL_COMP_TEMP WITH (NOLOCK)
                                        GROUP  BY 
                                               COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, MODEL_ID, PARENT_ITEM_ID, CHILD_ITEM_ID
                                       ) B
                                GROUP  BY 
                                      COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, MODEL_ID, CHILD_ITEM_ID
                   ) B
                    ON    A.COMPANY_ID  = B.COMPANY_ID
                    AND   A.DIVISION_ID = B.DIVISION_ID
                    AND   A.SITE_ID     = B.SITE_ID
                    AND   A.PLANT_ID    = B.PLANT_ID
                    AND   A.TOP_ITEM_ID = B.MODEL_ID
                    AND   A.ITEM_ID     = B.CHILD_ITEM_ID
        WHERE  A.INSTANCE_ID  = @v_master_id
        AND    A.FP_PLAN_ID   = @v_plan_id
		*/
        --LOG 생성
        SET @v_message = CONVERT(NVARCHAR, @n_row_count)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        UPDATE A
        SET    A.PRODUCTION_TYPE  = B.SCP_PRODUCTION_TYPE
        FROM   FP_DAILY_PRODUCTION_PLAN_R A
             , (
                SELECT B.SEGMENT1         AS DIVISION_ID
                     , B.ATTRIBUTE1       AS SCP_PRODUCTION_TYPE
                     , MAX(B.ATTRIBUTE2)  AS FP_PRODUCTION_TYPE
                FROM   SCM_SYS_LOOKUP_TYPE_M A WITH (NOLOCK)
                     , SCM_SYS_LOOKUP_VALUE  B WITH (NOLOCK)
                WHERE  A.LOOKUP_TYPE_CODE = 'DIVISION_DEMAND_TYPE'
                AND    A.LOOKUP_TYPE_CODE = B.LOOKUP_TYPE_CODE
                AND    B.ATTRIBUTE3       = 'Y'                 -- SCP TARGET FLAG
                AND    A.ACTIVE_FLAG      = 'Y'
 AND    B.ACTIVE_FLAG      = 'Y'
                GROUP  BY B.SEGMENT1, B.ATTRIBUTE1
                HAVING B.ATTRIBUTE1 <> MAX(B.ATTRIBUTE2)
              ) B
        WHERE  A.INSTANCE_ID      = @v_master_id
        AND    A.FP_PLAN_ID       = @v_plan_id
        AND    A.DIVISION_ID      = B.DIVISION_ID
        AND    A.PRODUCTION_TYPE  = B.FP_PRODUCTION_TYPE
        
        --LOG 생성
        SET @v_message = 'SCP_PRODUCTION_TYPE : ' + CONVERT(NVARCHAR, @n_row_count)
        SET @n_log_count = @n_log_count + 1
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

		IF CHARINDEX('FORM', @v_master_id) > 0    -- 활성화 DW/FCS 전송시 Order Type 변경하여 전송 20200130 by cys
		BEGIN
				
			UPDATE A
			SET    A.PRODUCTION_TYPE  = ISNULL(B.PRODUCTION_TYPE, A.PRODUCTION_TYPE)
			FROM   FP_DAILY_PRODUCTION_PLAN_R A
					, (
							SELECT B.SEGMENT1 AS DIVISION_ID, B.SEGMENT2 AS SITE_ID, B.SEGMENT3 AS PLANT_ID, B.SEGMENT4 AS ITEM_ID, MAX(B.ATTRIBUTE1) AS PRODUCTION_TYPE
							FROM   SCM_SYS_LOOKUP_TYPE_M A WITH (NOLOCK)
									, SCM_SYS_LOOKUP_VALUE  B WITH (NOLOCK)
							WHERE  A.LOOKUP_TYPE_CODE = 'FORMATION_EXCEPTION_TYPE'
							AND    A.LOOKUP_TYPE_CODE = B.LOOKUP_TYPE_CODE
							AND    A.ACTIVE_FLAG      = 'Y'
							AND    B.ACTIVE_FLAG      = 'Y'
							group by B.SEGMENT1, B.SEGMENT2, B.SEGMENT3, B.SEGMENT4
					) B
			WHERE  A.INSTANCE_ID  = @v_master_id
			AND    A.FP_PLAN_ID   = @v_plan_id
			AND    A.DIVISION_ID  = B.DIVISION_ID
			AND    A.SITE_ID      = B.SITE_ID
			AND    A.PLANT_ID     = B.PLANT_ID
			AND    A.ITEM_ID	  = B.ITEM_ID

			--LOG 생성
			SET @v_message = 'FORMATION PRODUCTION_TYPE CHANGE : ' + CONVERT(NVARCHAR, @n_row_count)
			SET @n_log_count = @n_log_count + 1
			EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
			
		END

      END

      -- RELEASE 버전이 저장되기 전에 ERP 로 전송한 거 같아서 충분한 시간을 부여한다.
      WAITFOR DELAY '0:0:2'

      
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
        
        --WAITFOR DELAY '0:0:2'

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
            
--  					SET @n_log_count = @n_log_count + 1
--  					SET @v_message = @v_master_id + ' PR_XIF_PDS_WO_S Start'
--  					EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'CALL', @n_log_count, NULL, @v_message, null
--  					
--  					EXEC PR_XIF_PDS_WO_S @v_plan_id
--
--  					SET @n_log_count = @n_log_count + 1
--  					SET @v_message = @v_master_id + ' PR_XIF_PDS_WO_S End'
--  					EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'CALL', @n_log_count, NULL, @v_message, null
  					
  					SET @n_log_count = @n_log_count + 1
  					SET @v_message = @v_master_id + ' PR_XIF_MES_DAILY_PP_S Start'
  					EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'CALL', @n_log_count, NULL, @v_message, null
  					
  					EXEC PR_XIF_MES_DAILY_PP_S @v_plan_id

  					SET @n_log_count = @n_log_count + 1
  					SET @v_message = @v_master_id + ' PR_XIF_MES_DAILY_PP_S End'
  					EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'CALL', @n_log_count, NULL, @v_message, null
        END
      
      END
    ELSE IF CHARINDEX('FORM', @v_master_id) > 0
      BEGIN
      
        -- 20180427 특성 	FP_DAILY_PRODUCTIOIN_PLAN_H 추가 
        
        SET @v_table_name = 'FP_DAILY_PRODUCTIOIN_PLAN_H'
        
  			-- 20191127 김춘동책임님 요청 - DELETE / INERT - > 과거구간 0 DELETE  미수립계획 0  UPDATE  INSERT

			DELETE A
			  FROM FP_DAILY_PRODUCTIOIN_PLAN_H A -- WITH(NOLOCK) 2018-05-15 kimcd lock waiting함
				   ,(
					  SELECT A.PLAN_GROUP_ID
							 ,B.INSTANCE_TYPE
							 ,CONVERT(DATETIME, A.PLAN_DATE, 112) AS INSTANCE_DATE
							 ,B.FACTORY_ID
							 ,A.DIVISION_ID  -- 2019-02-14 kimcd 라인 정보 추출을 위해 구분자 추가
							 ,A.INSTANCE_ID  -- 2019-02-14 kimcd 라인 정보 추출을 위해 구분자 추가
						FROM (SELECT PLAN_DATE
								     , INSTANCE_ID
								     , DIVISION_ID
								     , FACTORY_ID
								     , '-' AS PLAN_GROUP_ID
								     , RELEASE_PLAN_ID
							    FROM DBO.SCM_FP_PLAN_DETAIL_H C(NOLOCK)
						       WHERE RELEASE_FLAG IN ( 'P', 'Y')
						         AND RELEASE_PLAN_ID = @v_plan_id
						       UNION ALL
						      SELECT PLAN_DATE
								     , INSTANCE_ID
								     ,'-' AS DIVISION_ID
								     ,'-' AS FACTORY_ID
								     , PLAN_GROUP_ID
								     , RELEASE_PLAN_ID
							    FROM DBO.SCM_FP_PLAN_GROUP_DETAIL_H D WITH(NOLOCK)
						       WHERE RELEASE_FLAG IN ( 'P', 'Y')
						         AND RELEASE_PLAN_ID = @v_plan_id
						      ) A
							 ,( SELECT A.[INSTANCE_ID]
										,INSTANCE_TYPE
										,B.SITE_ID
										,B.FACTORY_ID
										,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
										,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
								   FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
									    ,DBO.SCM_FACTORY_M B WITH(NOLOCK)
									    ,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
									    LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
													 ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
													AND MP.SEGMENT1 = SLV.SEGMENT1
													AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
								  WHERE A.FACTORY_ID = B.FACTORY_ID     
									AND A.ACTIVE_FLAG = 'Y'     
									AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
									AND A.INSTANCE_ID != 'KR_CELL_M_P'
									AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
									AND SLV.SEGMENT1 = A.INSTANCE_ID
								UNION ALL
								 SELECT A.[INSTANCE_ID]  AS INSTANCE_ID
										,INSTANCE_TYPE+'_P' AS INSTANCE_TYPE
										,B.SITE_ID
										,B.FACTORY_ID
										,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
										,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
								   FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
										,DBO.SCM_FACTORY_M B WITH(NOLOCK)
										,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
										LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
													 ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
													AND MP.SEGMENT1 = SLV.SEGMENT1
													AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
								  WHERE A.FACTORY_ID = B.FACTORY_ID     
									AND A.ACTIVE_FLAG = 'Y'     
									AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
									AND A.INSTANCE_ID = 'KR_CELL_M_P'
									AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
									AND SLV.SEGMENT1 = A.INSTANCE_ID
							 ) B      
					   WHERE A.INSTANCE_ID = B.INSTANCE_ID
						 AND A.FACTORY_ID = B.LINK_FACTORY_ID
						 AND A.PLAN_GROUP_ID = B.PLAN_GROUP_ID
						 AND A.RELEASE_PLAN_ID = @v_plan_id
				   ) B
			 WHERE A.FACTORY_ID = B.FACTORY_ID
			   -- AND A.PLAN_GROUP_ID = B.PLAN_GROUP_ID 2019-02-18 kimcd PLAN GROUP ID 조건을 제거하고 라인 기준으로 함
			   AND A.INSTANCE_TYPE = B.INSTANCE_TYPE
			   AND A.PLAN_DATE >= DATEADD( D, -15, B.INSTANCE_DATE) -- 2019-01-17 kimcd 계획 숫자 0인 계획 삭제 조건 추가
			   AND A.PLAN_TYPE  = 'RELEASE' -- 2018-02-23 kimcd 조건 추가
			   AND A.PLAN_QTY   = 0 -- 2019-01-17 kimcd 계획 숫자 0인 계획 삭제 조건 추가
			   AND A.UPDATE_TIME <= DATEADD( D, -1, GETDATE()) -- 2019-01-17 kimcd 계획 숫자 0인 계획 삭제 조건 추가
			   -- 2019-02-14 kimcd 라인 조건 추가 시작
			   AND A.LINE_ID IN ( SELECT DISTINCT LINE_ID
								  FROM   SCM_LINE_M L WITH(NOLOCK)
								  WHERE  L.FACTORY_ID  = B.FACTORY_ID
								  AND    CASE WHEN B.PLAN_GROUP_ID = '-' THEN B.PLAN_GROUP_ID ELSE L.MODEL_TYPE END = B.PLAN_GROUP_ID
								  AND    NOT EXISTS (SELECT 1
													 FROM   SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
													 WHERE  SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_SPLIT_LINE_DEFINITION'
													 AND    SLV.ACTIVE_FLAG       = 'Y'
													 AND    SLV.SEGMENT2          = B.INSTANCE_ID
													 AND    SLV.SEGMENT3          = L.LINE_ID )
								  AND    NOT EXISTS (SELECT 1
													 FROM   SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
													 WHERE  SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_SPLIT_LINE_DEFINITION'
													 AND    SLV.ACTIVE_FLAG       = 'Y'
													 AND    SLV.SEGMENT1          = B.INSTANCE_ID)
								  UNION ALL
								  SELECT SLV.SEGMENT3
								  FROM   SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
								  WHERE  SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_SPLIT_LINE_DEFINITION'
								  AND    SLV.ACTIVE_FLAG       = 'Y'
								  AND    SLV.SEGMENT1          = B.INSTANCE_ID
								  )
				-- 2019-02-14 kimcd 라인 조건 추가 끝

			-- 2018-10-02 kimcd 임시 적용
			-- 일자별 계획을 0으로 갱신 시작
			UPDATE A 
			SET  [PLAN_QTY]                = 0
			    ,[PLAN_IN_QTY]             = 0
			    ,[ROLL_IN_QTY]             = 0
				,[ROLL_OUT_QTY]            = 0
				,[JR_IN_QTY]               = 0
				,[JR_OUT_QTY]              = 0
				,[BATCH_IN_QTY]            = 0
				,[BATCH_OUT_QTY]           = 0
				,[CELL_IN_QTY]             = 0
				,[CELL_OUT_QTY]            = 0
				,[FULL_CLEANING_FLAG]      = NULL		
				,[PIG_CLEANING_FLAG]	   = NULL		--2018-12-20 PIYONG ADD  PIG 세정 여부	
				,[MODEL_TYPE_CHANGE_FLAG]  = NULL		
				,[SEQ]					   = 0			--2018-10-16 PIYONG ADD  전극 생산 우선 순위를 관리하기 위한 SEQ 초기화
				,[CELL_MATERIAL_ID]        = NULL       --2018-11-06 kimcd 활성화 후 공정 Cell Material ID 초기화
				,[TOTAL_BATCH]             = NULL       --2018-12-11 kimcd 주별 계획 BATCH 합 추가
				,[SETUP_COLOR_CODE]		   = '-'        --2019-01-09 PIYONG full, pig세정 강화 관련 색 지정
				,[UPDATE_ID]               = 'PR_XIF_MES_DAILY_PP_S'
			    ,[UPDATE_TIME]             = GETDATE()
			  FROM FP_DAILY_PRODUCTIOIN_PLAN_H A -- WITH(NOLOCK) 2018-05-15 kimcd lock waiting함
				   ,(
					  SELECT A.PLAN_GROUP_ID
							 ,B.INSTANCE_TYPE
							 ,CONVERT(DATETIME, A.PLAN_DATE, 112) AS INSTANCE_DATE
							 ,B.FACTORY_ID
							 ,A.DIVISION_ID  -- 2019-02-14 kimcd 라인 정보 추출을 위해 구분자 추가
							 ,A.INSTANCE_ID  -- 2019-02-14 kimcd 라인 정보 추출을 위해 구분자 추가
						FROM (SELECT PLAN_DATE
								     , INSTANCE_ID
								     , DIVISION_ID
								     , FACTORY_ID
								     , '-' AS PLAN_GROUP_ID
								     , RELEASE_PLAN_ID
							    FROM DBO.SCM_FP_PLAN_DETAIL_H C(NOLOCK)
						       WHERE RELEASE_FLAG IN ( 'P', 'Y')
						         AND RELEASE_PLAN_ID = @v_plan_id
						       UNION ALL
						      SELECT PLAN_DATE
								     , INSTANCE_ID
								     ,'-' AS DIVISION_ID
								     ,'-' AS FACTORY_ID
								     , PLAN_GROUP_ID
								     , RELEASE_PLAN_ID
							    FROM DBO.SCM_FP_PLAN_GROUP_DETAIL_H D WITH(NOLOCK)
						       WHERE RELEASE_FLAG IN ( 'P', 'Y')
						         AND RELEASE_PLAN_ID = @v_plan_id
						      ) A
							 ,( SELECT A.[INSTANCE_ID]
										,INSTANCE_TYPE
										,B.SITE_ID
										,B.FACTORY_ID
										,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
										,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
								   FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
									    ,DBO.SCM_FACTORY_M B WITH(NOLOCK)
									    ,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
									    LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
													 ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
													AND MP.SEGMENT1 = SLV.SEGMENT1
													AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
								  WHERE A.FACTORY_ID = B.FACTORY_ID     
									AND A.ACTIVE_FLAG = 'Y'     
									AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
									AND A.INSTANCE_ID != 'KR_CELL_M_P'
									AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
									AND SLV.SEGMENT1 = A.INSTANCE_ID
								UNION ALL
								 SELECT A.[INSTANCE_ID]  AS INSTANCE_ID
										,INSTANCE_TYPE+'_P' AS INSTANCE_TYPE
										,B.SITE_ID
										,B.FACTORY_ID
										,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
										,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
								   FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)    
										,DBO.SCM_FACTORY_M B WITH(NOLOCK)
										,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
										LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
													 ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
													AND MP.SEGMENT1 = SLV.SEGMENT1
													AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
								  WHERE A.FACTORY_ID = B.FACTORY_ID     
									AND A.ACTIVE_FLAG = 'Y'     
									AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
									AND A.INSTANCE_ID = 'KR_CELL_M_P'
									AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
									AND SLV.SEGMENT1 = A.INSTANCE_ID
							 ) B      
					   WHERE A.INSTANCE_ID = B.INSTANCE_ID
						 AND A.FACTORY_ID = B.LINK_FACTORY_ID
						 AND A.PLAN_GROUP_ID = B.PLAN_GROUP_ID
						 AND A.RELEASE_PLAN_ID = @v_plan_id
				   ) B
			 WHERE A.FACTORY_ID = B.FACTORY_ID
			   -- AND A.PLAN_GROUP_ID = B.PLAN_GROUP_ID 2019-02-18 kimcd PLAN GROUP ID 조건을 제거하고 라인 기준으로 함
			   AND A.INSTANCE_TYPE = B.INSTANCE_TYPE
			   AND A.PLAN_DATE >= B.INSTANCE_DATE
			   AND A.PLAN_TYPE  = 'RELEASE' -- 2018-02-23 kimcd 조건 추가
			   -- 2019-02-14 kimcd 라인 조건 추가 시작
			   AND A.LINE_ID IN ( SELECT DISTINCT LINE_ID
								  FROM   SCM_LINE_M L WITH(NOLOCK)
								  WHERE  L.FACTORY_ID  = B.FACTORY_ID
								  AND    CASE WHEN B.PLAN_GROUP_ID = '-' THEN B.PLAN_GROUP_ID ELSE L.MODEL_TYPE END = B.PLAN_GROUP_ID
								  AND    NOT EXISTS (SELECT 1
													 FROM   SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
													 WHERE  SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_SPLIT_LINE_DEFINITION'
													 AND    SLV.ACTIVE_FLAG       = 'Y'
													 AND    SLV.SEGMENT2          = B.INSTANCE_ID
													 AND    SLV.SEGMENT3          = L.LINE_ID )
								  AND    NOT EXISTS (SELECT 1
													 FROM   SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
													 WHERE  SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_SPLIT_LINE_DEFINITION'
													 AND    SLV.ACTIVE_FLAG       = 'Y'
													 AND    SLV.SEGMENT1          = B.INSTANCE_ID)
								  UNION ALL
								  SELECT SLV.SEGMENT3
								  FROM   SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
								  WHERE  SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_SPLIT_LINE_DEFINITION'
								  AND    SLV.ACTIVE_FLAG       = 'Y'
								  AND    SLV.SEGMENT1          = B.INSTANCE_ID
								  )
				-- 2019-02-14 kimcd 라인 조건 추가 끝

			MERGE INTO FP_DAILY_PRODUCTIOIN_PLAN_H DP
   USING ( SELECT  B.COMPANY_ID
         ,B.DIVISION_ID
         ,B.SITE_ID
         ,B.PLANT_ID
         ,A.FACTORY_ID
         ,A.PLAN_GROUP_ID
         ,(SELECT TOP 1 INSTANCE_TYPE
         FROM ( SELECT FF.INSTANCE_TYPE
            FROM DBO.[FP_INSTANCE_FACTORY_M] FF WITH(NOLOCK)
           WHERE FF.ACTIVE_FLAG = 'Y'     
             AND FF.INSTANCE_ID != 'KR_CELL_M_P'
             AND FF.INSTANCE_ID = A.INSTANCE_ID
          UNION ALL
          SELECT FF.INSTANCE_TYPE+'_P' AS INSTANCE_TYPE
            FROM DBO.[FP_INSTANCE_FACTORY_M] FF WITH(NOLOCK)
           WHERE FF.ACTIVE_FLAG = 'Y'     
             AND FF.INSTANCE_ID = 'KR_CELL_M_P'
             AND FF.INSTANCE_ID = A.INSTANCE_ID ) FF)  INSTANCE_TYPE
         ,A.TOP_ITEM_ID
         ,A.ITEM_ID
         ,A.OPERATION_ID
         ,ISNULL((SELECT LOCATION 
  FROM SCM_LINE_M WITH(NOLOCK)
          WHERE LINE_ID = A.LINE_ID
            AND OPERATION_ID = A.OPERATION_ID
            AND FACTORY_ID = A.FACTORY_ID
            AND ELECTRODE_TYPE = A.ELECTRODE_TYPE), '-') AS LOCATION
         ,A.PRODUCTION_TYPE
         ,A.MARKET
         ,A.LINE_ID
         ,A.ELECTRODE_TYPE
         ,A.PLAN_DATE
         ,A.PLAN_QTY
         ,A.PLAN_IN_QTY
         ,'PR_XIF_MES_DAILY_PP_S'  AS INSERT_ID  
         ,GETDATE()                AS INSERT_TIME
         ,'PR_XIF_MES_DAILY_PP_S'  AS UPDATE_ID
         ,GETDATE()                AS UPDATE_TIME
         ,'RELEASE'                AS PLAN_TYPE -- 2018-02-23 kimcd 계획 유형 추가
         ,A.EQUIPMENT_ID    -- 2018-02-23 kimcd 설비 정보 추가
   -- 2018-04-09 kimcd 일자별 계획에 FP_PRODUCTION_TYPE 컬럼. 전극 환산 계획 수량 추가 시작
         ,A.FP_PRODUCTION_TYPE
      ,A.ROLL_IN_QTY
   ,A.ROLL_OUT_QTY
         ,A.JR_IN_QTY
         ,A.JR_OUT_QTY
         ,A.BATCH_IN_QTY
         ,A.BATCH_OUT_QTY
         ,A.CELL_IN_QTY
         ,A.CELL_OUT_QTY
       -- 2018-04-09 kimcd 일자별 계획에 FP_PRODUCTION_TYPE 컬럼. 전극 환산 계획 수량 추가 시작
         ,A.FULL_CLEANING_FLAG      -- 2018-09-14 kimcd 추가 풀 세척     
 ,A.PIG_CLEANING_FLAG    -- 2018-12-20 PIYONG 추가 PIG 세정     
         ,A.MODEL_TYPE_CHANGE_FLAG  -- 2018-09-14 kimcd 추가 파우치->원각 모델 변경 
            ,A.SEQ      -- 2018-10-16 PIYONG ADD  전극 생산 우선 순위를 관리하기 위한 SEQ
         ,A.CELL_MATERIAL_ID        --2018-11-06 kimcd 활성화 후 공정 Cell Material ID 값 추가
         ,A.TOTAL_BATCH             --2018-12-11 kimcd  주별 계획 BATCH 합 추가
         ,A.SETUP_COLOR_CODE    --2019-01-09 PIYONG full, pig세정 강화 관련 색 지정
       FROM (
       SELECT PP.FACTORY_ID
           ,A.PLAN_GROUP_ID
           ,TOP_ITEM_ID
           ,ITEM_ID
           ,OPERATION_ID
           ,MAX(PRODUCTION_TYPE) AS PRODUCTION_TYPE        -- 2018-04-09 kimcd FP PRODUCTION TYPE 추가에 따른 GROUP BY에서 제외
           ,ISNULL(FP_PRODUCTION_TYPE, PRODUCTION_TYPE) AS FP_PRODUCTION_TYPE -- 2018-04-09 kimcd FP PRODUCTION TYPE 추가
           ,ISNULL(MARKET,'D') AS MARKET
           ,LINE_ID
           ,MAX(ELECTRODE_TYPE) AS ELECTRODE_TYPE -- 2018-02-23 kimcd group by 조건에서 제외
           ,PP.PLAN_DATE
           ,SUM(PLAN_QTY) AS PLAN_QTY
           ,SUM(PLAN_IN_QTY) AS PLAN_IN_QTY
           ,MAX(A.INSTANCE_ID) AS INSTANCE_ID
           ,PP.EQUIPMENT_ID   -- 2018-02-23 kimcd 설비 정보 추가
           -- 2018-04-09 kimcd 일자별 계획에 전극 환산 계획 수량 추가 시작
           ,SUM(PP.ROLL_IN_QTY)    AS ROLL_IN_QTY
           ,SUM(PP.ROLL_OUT_QTY)   AS ROLL_OUT_QTY
           ,SUM(PP.JR_IN_QTY)      AS JR_IN_QTY
           ,SUM(PP.JR_OUT_QTY)     AS JR_OUT_QTY
           ,SUM(PP.BATCH_IN_QTY)   AS BATCH_IN_QTY
           ,SUM(PP.BATCH_OUT_QTY)  AS BATCH_OUT_QTY
           ,SUM(PP.CELL_IN_QTY)    AS CELL_IN_QTY
           ,SUM(PP.CELL_OUT_QTY)   AS CELL_OUT_QTY
           -- 2018-04-09 kimcd 일자별 계획에 전극 환산 계획 수량 추가 끝
           ,MAX(PP.FULL_CLEANING_FLAG)      AS  FULL_CLEANING_FLAG       -- 2018-09-14 kimcd 추가 풀 세척     
           ,MAX(PP.PIG_CLEANING_FLAG)  AS  PIG_CLEANING_FLAG   -- 2018-12-20 PIYONG 추가 PIG 세정     
           ,MAX(PP.MODEL_TYPE_CHANGE_FLAG)  AS  MODEL_TYPE_CHANGE_FLAG   -- 2018-09-14 kimcd 추가 파우치->원각 모델 변경  
           ,MAX(PP.SEQ) AS SEQ            -- 2018-10-16 PIYONG ADD  전극 생산 우선 순위를 관리하기 위한 SEQ
           ,MAX(PP.CELL_MATERIAL_ID)        AS  CELL_MATERIAL_ID         -- 2018-11-06 kimcd 활성화 후 공정 Cell Material ID 값 추가
           ,MAX(PP.TOTAL_BATCH)             AS TOTAL_BATCH               --2018-12-11 kimcd  주별 계획 BATCH 합 추가
           ,MAX(PP.SETUP_COLOR_CODE)  AS SETUP_COLOR_CODE     --2019-01-09 PIYONG full, pig세정 강화 관련 색 지정
         FROM FP_DAILY_PRODUCTION_PLAN_R PP WITH(NOLOCK),
           (SELECT PLAN_DATE
             , INSTANCE_ID
             , DIVISION_ID
             , FACTORY_ID
             , '-' AS PLAN_GROUP_ID
             , RELEASE_PLAN_ID
           FROM DBO.SCM_FP_PLAN_DETAIL_H C(NOLOCK)
          WHERE RELEASE_FLAG IN ( 'P', 'Y')
            AND RELEASE_PLAN_ID = @v_plan_id
          UNION ALL
 SELECT PLAN_DATE
             , INSTANCE_ID
             ,'-' AS DIVISION_ID
             ,'-' AS FACTORY_ID
             , PLAN_GROUP_ID
             , RELEASE_PLAN_ID
           FROM DBO.SCM_FP_PLAN_GROUP_DETAIL_H D WITH(NOLOCK)
          WHERE D.RELEASE_FLAG IN ( 'P', 'Y')
            AND RELEASE_PLAN_ID = @v_plan_id
           ) A
        WHERE A.RELEASE_PLAN_ID = @v_plan_id--'KR_CELL-20171125-99' --'CN_CELL_M2-20171121-98'
          AND A.RELEASE_PLAN_ID = PP.FP_PLAN_ID
          AND A.INSTANCE_ID     = PP.INSTANCE_ID -- 2018-03-30 kimcd add instance_id
          AND A.PLAN_DATE < = (SELECT TOP 1 DATEADD(D,-1,SC.WEEKSTART_DATE)
               FROM   SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
                     ,SCM_SYS_CALENDAR_M   SC WITH(NOLOCK)
WHERE  SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
               AND    SLV.SEGMENT1 = A.INSTANCE_ID
               AND    SC.DATE_ID   = DATEADD(D, 7*CONVERT(NUMERIC(3), SLV.ATTRIBUTE15), A.PLAN_DATE) ) -- 2019-01-17 kimcd 계획 형성 구간 제한
        GROUP BY PP.FACTORY_ID
           ,A.PLAN_GROUP_ID
           ,TOP_ITEM_ID
           ,ITEM_ID
           ,OPERATION_ID
           ,ISNULL(FP_PRODUCTION_TYPE, PRODUCTION_TYPE) -- 2018-04-09 kimcd FP PRODUCTION TYPE 추가에 따른 GROUP BY 조건 조정
           ,ISNULL(MARKET,'D')
           ,LINE_ID
           --,ELECTRODE_TYPE -- 2018-02-23 kimcd group by 조건에서 제외
           ,PP.PLAN_DATE
           ,PP.EQUIPMENT_ID  -- 2018-02-23 kimcd group by 조건 추가
         )A
         , SCM_FACTORY_M B WITH(NOLOCK)
       WHERE A.FACTORY_ID = B.FACTORY_ID ) B

     ON ( DP.[FACTORY_ID]        = B.[FACTORY_ID]
     -- AND DP.[PLAN_GROUP_ID] = B.[PLAN_GROUP_ID] 2019-02-18 kimcd PLAN GROUP ID 조건을 제거하고 라인 기준으로 함
     AND DP.[INSTANCE_TYPE] = B.[INSTANCE_TYPE]
     AND DP.[PLAN_TYPE]     = B.[PLAN_TYPE]
     AND DP.[ITEM_ID]       = B.[ITEM_ID]
     AND DP.[LINE_ID]       = B.[LINE_ID]
     AND DP.[PLAN_DATE]     = B.[PLAN_DATE]
     AND DP.[TOP_ITEM_ID]   = B.[TOP_ITEM_ID]
     AND DP.[OPERATION_ID]  = B.[OPERATION_ID]
     AND DP.[FP_PRODUCTION_TYPE] = B.[FP_PRODUCTION_TYPE]
     AND DP.[MARKET]        = B.[MARKET]
     AND DP.[EQUIPMENT_ID]  = B.[EQUIPMENT_ID] )
     WHEN MATCHED THEN
     UPDATE SET   DP.[PRODUCTION_TYPE]         = B.[PRODUCTION_TYPE]
        ,DP.[ELECTRODE_TYPE]          = B.[ELECTRODE_TYPE]
        ,DP.[PLAN_QTY]                = B.[PLAN_QTY]
        ,DP.[PLAN_IN_QTY]             = B.[PLAN_IN_QTY]
        ,DP.[ROLL_IN_QTY]             = B.[ROLL_IN_QTY]
        ,DP.[ROLL_OUT_QTY]            = B.[ROLL_OUT_QTY]
        ,DP.[JR_IN_QTY]               = B.[JR_IN_QTY]
        ,DP.[JR_OUT_QTY]              = B.[JR_OUT_QTY]
        ,DP.[BATCH_IN_QTY]            = B.[BATCH_IN_QTY]
        ,DP.[BATCH_OUT_QTY]           = B.[BATCH_OUT_QTY]
        ,DP.[CELL_IN_QTY]             = B.[CELL_IN_QTY]
        ,DP.[CELL_OUT_QTY]            = B.[CELL_OUT_QTY]
        ,DP.[FULL_CLEANING_FLAG]      = B.[FULL_CLEANING_FLAG]  -- 2018-09-14 kimcd 추가 풀 세척     
        ,DP.[PIG_CLEANING_FLAG]    = B.[PIG_CLEANING_FLAG]  -- 2018-12-20 PIYONG 추가 PIG 세정    
        ,DP.[MODEL_TYPE_CHANGE_FLAG]  = B.[MODEL_TYPE_CHANGE_FLAG] -- 2018-09-14 kimcd 추가 파우치->원각 모델 변경 
        ,DP.[SEQ]       = B.[SEQ]      -- 2018-10-16 PIYONG ADD  전극 생산 우선 순위를 관리하기 위한 SEQ
        ,DP.[CELL_MATERIAL_ID]        = B.[CELL_MATERIAL_ID]  -- 2018-11-06 kimcd 활성화 후 공정 Cell Material ID 값 추가
        ,DP.[TOTAL_BATCH]             = B.[TOTAL_BATCH]       -- 2018-12-11 kimcd  주별 계획 BATCH 합 추가
        ,DP.[SETUP_COLOR_CODE]    = B.SETUP_COLOR_CODE   --2019-01-09 PIYONG full, pig세정 강화 관련 색 지정
        ,DP.[PLAN_GROUP_ID]           = B.[PLAN_GROUP_ID] -- 2019-02-18 kimcd PLAN GROUP ID 조건을 제거하고 갱신하도록 함
        ,DP.[UPDATE_ID]               = B.[UPDATE_ID]
        ,DP.[UPDATE_TIME]             = B.[UPDATE_TIME]
     WHEN NOT MATCHED THEN
     INSERT ( [COMPANY_ID]
       ,[DIVISION_ID]
       ,[SITE_ID]
       ,[PLANT_ID]
       ,[FACTORY_ID]
       ,[PLAN_GROUP_ID]
       ,[INSTANCE_TYPE]
       ,[TOP_ITEM_ID]
       ,[ITEM_ID]
       ,[OPERATION_ID]
       ,[LOCATION]
       ,[PRODUCTION_TYPE]
       ,[MARKET]
       ,[LINE_ID]
       ,[ELECTRODE_TYPE]
       ,[PLAN_DATE]
       ,[PLAN_QTY]
       ,[PLAN_IN_QTY]
       ,[INSERT_ID]
       ,[INSERT_TIME]
       ,[UPDATE_ID]
       ,[UPDATE_TIME]
       ,[PLAN_TYPE]       -- 2018-02-23 kimcd 계획 유형 추가 - RELEASE
       ,[EQUIPMENT_ID]    -- 2018-02-23 kimcd 설비 정보 추가
       -- 2018-04-09 kimcd 일자별 계획에 FP_PRODUCTION_TYPE 컬럼. 전극 환산 계획 수량 추가 시작
       ,[FP_PRODUCTION_TYPE]
       ,[ROLL_IN_QTY]
   ,[ROLL_OUT_QTY]
       ,[JR_IN_QTY]
       ,[JR_OUT_QTY]
       ,[BATCH_IN_QTY]
       ,[BATCH_OUT_QTY]
       ,[CELL_IN_QTY]
       ,[CELL_OUT_QTY]
       -- 2018-04-09 kimcd 일자별 계획에 FP_PRODUCTION_TYPE 컬럼. 전극 환산 계획 수량 추가 시작
       ,[FULL_CLEANING_FLAG]      -- 2018-09-14 kimcd 추가 풀 세척     
       ,[PIG_CLEANING_FLAG]  -- 2018-12-20 PIYONG 추가 PIG 세정    
       ,[MODEL_TYPE_CHANGE_FLAG] -- 2018-09-14 kimcd 추가 파우치->원각 모델 변경 
          ,[SEQ]      -- 2018-10-16 PIYONG ADD 전극 생산 우선 순위를 관리하기 위한 SEQ
       ,[CELL_MATERIAL_ID]        --2018-11-06 kimcd 활성화 후 공정 Cell Material ID 값 추가
       ,[TOTAL_BATCH]             --2018-12-11 kimcd  주별 계획 BATCH 합 추가
       ,[SETUP_COLOR_CODE]     --2019-01-09 PIYONG full, pig세정 강화 관련 색 지정
     ) VALUES ( B.[COMPANY_ID]
       ,B.[DIVISION_ID]
       ,B.[SITE_ID]
       ,B.[PLANT_ID]
       ,B.[FACTORY_ID]
       ,B.[PLAN_GROUP_ID]
       ,B.[INSTANCE_TYPE]
       ,B.[TOP_ITEM_ID]
       ,B.[ITEM_ID]
       ,B.[OPERATION_ID]
       ,B.[LOCATION]
       ,B.[PRODUCTION_TYPE]
       ,B.[MARKET]
       ,B.[LINE_ID]
       ,B.[ELECTRODE_TYPE]
       ,B.[PLAN_DATE]
       ,B.[PLAN_QTY]
       ,B.[PLAN_IN_QTY]
       ,B.[INSERT_ID]
       ,B.[INSERT_TIME]
       ,B.[UPDATE_ID]
       ,B.[UPDATE_TIME]
       ,B.[PLAN_TYPE]       -- 2018-02-23 kimcd 계획 유형 추가 - RELEASE
       ,B.[EQUIPMENT_ID]    -- 2018-02-23 kimcd 설비 정보 추가
       -- 2018-04-09 kimcd 일자별 계획에 FP_PRODUCTION_TYPE 컬럼. 전극 환산 계획 수량 추가 시작
       ,B.[FP_PRODUCTION_TYPE]
       ,B.[ROLL_IN_QTY]
       ,B.[ROLL_OUT_QTY]
       ,B.[JR_IN_QTY]
       ,B.[JR_OUT_QTY]
       ,B.[BATCH_IN_QTY]
       ,B.[BATCH_OUT_QTY]
       ,B.[CELL_IN_QTY]
       ,B.[CELL_OUT_QTY]
       -- 2018-04-09 kimcd 일자별 계획에 FP_PRODUCTION_TYPE 컬럼. 전극 환산 계획 수량 추가 시작
       ,B.[FULL_CLEANING_FLAG]      -- 2018-09-14 kimcd 추가 풀 세척      
       ,B.[PIG_CLEANING_FLAG]   -- 2018-12-20 PIYONG 추가 PIG 세정     
       ,B.[MODEL_TYPE_CHANGE_FLAG]  -- 2018-09-14 kimcd 추가 파우치->원각 모델 변경  
       ,B.[SEQ]      -- 2018-10-16 PIYONG ADD 전극 생산 우선 순위를 관리하기 위한 SEQ
       ,B.[CELL_MATERIAL_ID]        --2018-11-06 kimcd 활성화 후 공정 Cell Material ID 값 추가
       ,B.[TOTAL_BATCH]             --2018-12-11 kimcd  주별 계획 BATCH 합 추가
       ,B.[SETUP_COLOR_CODE]   --2019-01-09 PIYONG full, pig세정 강화 관련 색 지정
     );

			/*MERGE FP_DAILY_PRODUCTIOIN_PLAN_H AS DPP
			USING (
					
					)
  			-- 데이터 생성
  			INSERT INTO FP_DAILY_PRODUCTIOIN_PLAN_H
  			(
  				[COMPANY_ID]
  			    ,[DIVISION_ID]
  			    ,[SITE_ID]
  			    ,[PLANT_ID]
  			    ,[FACTORY_ID]
  			    ,[PLAN_GROUP_ID]
  			    ,[INSTANCE_TYPE]
  			    ,[TOP_ITEM_ID]
  			    ,[ITEM_ID]
  			    ,[OPERATION_ID]
  			    ,[LOCATION]
  			    ,[PRODUCTION_TYPE]
  			    ,[MARKET]
  			    ,[LINE_ID]
  			    ,[ELECTRODE_TYPE]
  			    ,[PLAN_DATE]
  			    ,[PLAN_QTY]
  			    ,[PLAN_IN_QTY]
  			    ,[INSERT_ID]
  			    ,[INSERT_TIME]
  			    ,[UPDATE_ID]
  			    ,[UPDATE_TIME]
  				,[PLAN_TYPE]       -- 2018-02-23 kimcd 계획 유형 추가 - RELEASE
  				,[EQUIPMENT_ID]    -- 2018-02-23 kimcd 설비 정보 추가
  				-- 2018-04-09 kimcd 일자별 계획에 FP_PRODUCTION_TYPE 컬럼. 전극 환산 계획 수량 추가 시작
  				,[FP_PRODUCTION_TYPE]
  				,[ROLL_IN_QTY]
  				,[ROLL_OUT_QTY]
  				,[JR_IN_QTY]
  				,[JR_OUT_QTY]
  				,[BATCH_IN_QTY]
  				,[BATCH_OUT_QTY]
  				,[CELL_IN_QTY]
  				,[CELL_OUT_QTY]
          ,[CELL_MATERIAL_ID]
  				-- 2018-04-09 kimcd 일자별 계획에 FP_PRODUCTION_TYPE 컬럼. 전극 환산 계획 수량 추가 시작
  			)
  			SELECT B.COMPANY_ID
  				   ,B.DIVISION_ID
  				   ,B.SITE_ID
  				   ,B.PLANT_ID
  				   ,A.FACTORY_ID
  				   ,A.PLAN_GROUP_ID
  				   ,(SELECT TOP 1 INSTANCE_TYPE
  				      FROM ( SELECT FF.INSTANCE_TYPE
  								  FROM DBO.[FP_INSTANCE_FACTORY_M] FF WITH(NOLOCK)
  								 WHERE FF.ACTIVE_FLAG = 'Y'     
  								   AND FF.INSTANCE_ID != 'KR_CELL_M_P'
  								   AND FF.INSTANCE_ID = A.INSTANCE_ID
  								UNION ALL
  								SELECT FF.INSTANCE_TYPE+'_P' AS INSTANCE_TYPE
  								  FROM DBO.[FP_INSTANCE_FACTORY_M] FF WITH(NOLOCK)
  								 WHERE FF.ACTIVE_FLAG = 'Y'     
  								   AND FF.INSTANCE_ID = 'KR_CELL_M_P'
  								   AND FF.INSTANCE_ID = A.INSTANCE_ID ) FF)  INSTANCE_TYPE
  				   ,A.TOP_ITEM_ID
  				   ,A.ITEM_ID
  				   ,A.OPERATION_ID
  				   ,ISNULL((SELECT LOCATION 
  							  FROM SCM_LINE_M WITH(NOLOCK)
  						     WHERE LINE_ID = A.LINE_ID
  							   AND OPERATION_ID = A.OPERATION_ID
  							   AND FACTORY_ID = A.FACTORY_ID
  							   AND ELECTRODE_TYPE = A.ELECTRODE_TYPE), '-') AS LOCATION
  				   ,A.PRODUCTION_TYPE
  				   ,A.MARKET
  				   ,A.LINE_ID
  				   ,A.ELECTRODE_TYPE
  				   ,A.PLAN_DATE
  				   ,A.PLAN_QTY
  				   ,A.PLAN_IN_QTY
  				   ,'PR_XIF_MES_DAILY_PP_S'
  				   ,GETDATE()
  				   ,'PR_XIF_MES_DAILY_PP_S'
  				   ,GETDATE()
  				   ,'RELEASE'         -- [PLAN_TYPE] 2018-02-23 kimcd 계획 유형 추가
  				   ,A.EQUIPMENT_ID    -- 2018-02-23 kimcd 설비 정보 추가
  					-- 2018-04-09 kimcd 일자별 계획에 FP_PRODUCTION_TYPE 컬럼. 전극 환산 계획 수량 추가 시작
  				   ,A.FP_PRODUCTION_TYPE
  				   ,A.ROLL_IN_QTY
  				   ,A.ROLL_OUT_QTY
  				   ,A.JR_IN_QTY
  				   ,A.JR_OUT_QTY
  				   ,A.BATCH_IN_QTY
  				   ,A.BATCH_OUT_QTY
  				   ,A.CELL_IN_QTY
  				   ,A.CELL_OUT_QTY
             ,A.CELL_MATERIAL_ID  
  					-- 2018-04-09 kimcd 일자별 계획에 FP_PRODUCTION_TYPE 컬럼. 전극 환산 계획 수량 추가 시작
  			  FROM (
  					SELECT PP.FACTORY_ID
  						   ,A.PLAN_GROUP_ID
  						   ,TOP_ITEM_ID
  						   ,ITEM_ID
  						   ,OPERATION_ID
  						   ,MAX(PRODUCTION_TYPE) AS PRODUCTION_TYPE        -- 2018-04-09 kimcd FP PRODUCTION TYPE 추가에 따른 GROUP BY에서 제외
  						   ,ISNULL(FP_PRODUCTION_TYPE, PRODUCTION_TYPE) AS FP_PRODUCTION_TYPE -- 2018-04-09 kimcd FP PRODUCTION TYPE 추가
  						   ,ISNULL(MARKET,'D') AS MARKET
  						   ,LINE_ID
  						   ,MAX(ELECTRODE_TYPE) AS ELECTRODE_TYPE -- 2018-02-23 kimcd group by 조건에서 제외
  						   ,PP.PLAN_DATE
  						   ,SUM(PLAN_QTY) AS PLAN_QTY
  						   ,SUM(PLAN_IN_QTY) AS PLAN_IN_QTY
  						   ,MAX(A.INSTANCE_ID) AS INSTANCE_ID
  						   ,PP.EQUIPMENT_ID   -- 2018-02-23 kimcd 설비 정보 추가
  						   -- 2018-04-09 kimcd 일자별 계획에 전극 환산 계획 수량 추가 시작
  						   ,SUM(PP.ROLL_IN_QTY)    AS ROLL_IN_QTY
  						   ,SUM(PP.ROLL_OUT_QTY)   AS ROLL_OUT_QTY
  						   ,SUM(PP.JR_IN_QTY)      AS JR_IN_QTY
  						   ,SUM(PP.JR_OUT_QTY)     AS JR_OUT_QTY
  						   ,SUM(PP.BATCH_IN_QTY)   AS BATCH_IN_QTY
  						   ,SUM(PP.BATCH_OUT_QTY)  AS BATCH_OUT_QTY
  						   ,SUM(PP.CELL_IN_QTY)    AS CELL_IN_QTY
  						   ,SUM(PP.CELL_OUT_QTY)   AS CELL_OUT_QTY
                 ,PP.CELL_MATERIAL_ID    AS CELL_MATERIAL_ID
  						   -- 2018-04-09 kimcd 일자별 계획에 전극 환산 계획 수량 추가 끝
  					  FROM FP_DAILY_PRODUCTION_PLAN_R PP WITH(NOLOCK),
  						   (SELECT PLAN_DATE
  								   , INSTANCE_ID
  								   , DIVISION_ID
  								   , FACTORY_ID
  								   , '-' AS PLAN_GROUP_ID
  								   , RELEASE_PLAN_ID
  							  FROM DBO.SCM_FP_PLAN_DETAIL_H C(NOLOCK)
  						     WHERE RELEASE_FLAG IN ( 'P', 'Y')
  						       AND RELEASE_PLAN_ID = @v_plan_id
  						     UNION ALL
  						    SELECT PLAN_DATE
  								   , INSTANCE_ID
  								   ,'-' AS DIVISION_ID
  								   ,'-' AS FACTORY_ID
  								   , PLAN_GROUP_ID
  								   , RELEASE_PLAN_ID
  							  FROM DBO.SCM_FP_PLAN_GROUP_DETAIL_H D WITH(NOLOCK)
  						     WHERE D.RELEASE_FLAG IN ( 'P', 'Y')
  							   AND RELEASE_PLAN_ID = @v_plan_id
  						   ) A
                       WHERE A.RELEASE_PLAN_ID = @v_plan_id--'KR_CELL-20171125-99' --'CN_CELL_M2-20171121-98'
                         AND A.RELEASE_PLAN_ID = PP.FP_PLAN_ID
  					 GROUP BY PP.FACTORY_ID
  						   ,A.PLAN_GROUP_ID
  						   ,TOP_ITEM_ID
  						   ,ITEM_ID
  						   ,OPERATION_ID
  						   ,ISNULL(FP_PRODUCTION_TYPE, PRODUCTION_TYPE) -- 2018-04-09 kimcd FP PRODUCTION TYPE 추가에 따른 GROUP BY 조건 조정
  						   ,ISNULL(MARKET,'D')
  						   ,LINE_ID
  						   --,ELECTRODE_TYPE -- 2018-02-23 kimcd group by 조건에서 제외
  						   ,PP.PLAN_DATE
  						   ,PP.EQUIPMENT_ID  -- 2018-02-23 kimcd group by 조건 추가
                 ,PP.CELL_MATERIAL_ID  --20181105 songhs 조건추가
  				   )A
  				   , SCM_FACTORY_M B WITH(NOLOCK)
  			  WHERE A.FACTORY_ID = B.FACTORY_ID*/
          
           --LOG 생성
        SET @v_message = CONVERT(NVARCHAR, @n_row_count)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
      END

      WAITFOR DELAY '0:0:1'

      -----------------------------------------------------------------------------------------------------------
      -----------------------------------------------------------------------------------------------------------
      -----------------------------------------------------------------------------------------------------------
      -- ERP 배포 : END
      -----------------------------------------------------------------------------------------------------------
      -----------------------------------------------------------------------------------------------------------
      -----------------------------------------------------------------------------------------------------------


      BEGIN
      
        BEGIN 
     
          SET @v_table_name = 'FP_RELEASE_FIX_PLAN_H'

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
               , ACTUAL_FLAG
               , INSERT_ID
               , INSERT_TIME        
               , TOP_ITEM_ID
               , FP_PRODUCTION_TYPE
               , VERSION		-- (D20240509~R0509.01) 
               , PLM_EC_NO		-- (D20240509~R0509.01) 
                )
          SELECT B.INSTANCE_ID
               , B.INSTANCE_DATE
               , A.FP_PLAN_ID AS RELEASE_PLAN_ID
               , B.AMEND_PLAN_ID
               , A.DIVISION_ID
               , A.FACTORY_ID
               , B.PLAN_GROUP_ID
               , A.WORK_ORDER_ID    AS WORK_ORDER_ID
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
       , ( CASE WHEN C.ACTUAL_FLAG = 'Y' THEN 'Y' ELSE 'N' END ) AS ACTUAL_FLAG
               , @v_proc_name AS INSERT_ID
               , GETDATE()    AS INSERT_TIME       
               , A.TOP_ITEM_ID
               , A.FP_PRODUCTION_TYPE
               , A.VERSION		-- (D20240509~R0509.01) 
               , A.PLM_EC_NO	-- (D20240509~R0509.01) 
          FROM   FP_DAILY_PRODUCTION_PLAN_R A
                 LEFT OUTER JOIN FP_DAILY_INSTANCE_ORDER_STATUS C
                      ON    A.INSTANCE_ID = C.INSTANCE_ID
                      AND   A.FP_PLAN_ID  = C.FP_PLAN_ID
                      AND   A.WORK_ORDER_ID = C.WORK_ORDER_ID
               , FP_RELEASE_PLAN_INFO_H B WITH (NOLOCK)
          WHERE  A.INSTANCE_ID    = @v_master_id
          AND    A.FP_PLAN_ID     = @v_plan_id
          AND    A.INSTANCE_ID    = B.INSTANCE_ID
AND    A.FP_PLAN_ID     = B.RELEASE_PLAN_ID
          AND    A.PLAN_QTY       > 0
      AND    A.FIX_TYPE       IN ('F','N')            -- 확정과 신규확정
          
          SET @n_row_count = @@ROWCOUNT
                
          --LOG 생성
          SET @v_message = CONVERT(NVARCHAR, @n_row_count)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
          
          -- full data
          
          SET @v_table_name = 'FP_RELEASE_FULL_PLAN_H'

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
               , ACTUAL_FLAG
               , INSERT_ID
           , INSERT_TIME        
               , TOP_ITEM_ID
               , FP_PRODUCTION_TYPE
               , VERSION	-- (D20240509~R0509.01) 
               , PLM_EC_NO	-- (D20240509~R0509.01) 
                )
 SELECT B.INSTANCE_ID
               , B.INSTANCE_DATE
               , A.FP_PLAN_ID   AS RELEASE_PLAN_ID
               , B.AMEND_PLAN_ID
               , A.DIVISION_ID
               , A.FACTORY_ID
               , B.PLAN_GROUP_ID
               , A.WORK_ORDER_ID    AS WORK_ORDER_ID
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
               , ( CASE WHEN C.ACTUAL_FLAG = 'Y' THEN 'Y' ELSE 'N' END ) AS ACTUAL_FLAG
               , @v_proc_name AS INSERT_ID
               , GETDATE()    AS INSERT_TIME       
               , A.TOP_ITEM_ID
               , A.FP_PRODUCTION_TYPE
               , A.VERSION		-- (D20240509~R0509.01) 
               , A.PLM_EC_NO	-- (D20240509~R0509.01) 
          FROM   FP_DAILY_PRODUCTION_PLAN_R A
                 LEFT OUTER JOIN FP_DAILY_INSTANCE_ORDER_STATUS C 
                      ON    A.INSTANCE_ID = C.INSTANCE_ID
                      AND   A.FP_PLAN_ID  = C.FP_PLAN_ID
                      AND   A.WORK_ORDER_ID = C.WORK_ORDER_ID
               , FP_RELEASE_PLAN_INFO_H B WITH (NOLOCK)
          WHERE  A.INSTANCE_ID    = @v_master_id
          AND    A.FP_PLAN_ID     = @v_plan_id
          AND    A.INSTANCE_ID    = B.INSTANCE_ID
          AND    A.FP_PLAN_ID     = B.RELEASE_PLAN_ID
       AND    A.PLAN_QTY       > 0

          SET @n_row_count = @@ROWCOUNT
                
 --LOG 생성
          SET @v_message = CONVERT(NVARCHAR, @n_row_count)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        END
        
        -- ACTUAL_FLAG, CLOSE_FLAG 상속받기
        /*
        BEGIN

          -- FP_RELEASE_FIX_PLAN_H
          SET @v_table_name = 'FP_RELEASE_FIX_PLAN_H'

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

          SET @n_row_count = @@ROWCOUNT
                
          --LOG 생성
          SET @v_message = 'ACTUAL_FLAG : ' + CONVERT(NVARCHAR, @n_row_count)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

          -- FP_RELEASE_FULL_PLAN_H
          SET @v_table_name = 'FP_RELEASE_FULL_PLAN_H'

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

          SET @n_row_count = @@ROWCOUNT
                
          --LOG 생성
          SET @v_message = 'ACTUAL_FLAG : ' + CONVERT(NVARCHAR, @n_row_count)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        END        
          
        -- Multi Release 를 위해 RELEASE 당시 ACTUAL 인지 아닌지를 UPDATE 함
        BEGIN

          SET @v_table_name = 'FP_RELEASE_FIX_PLAN_H'

          UPDATE A
          SET    A.ACTUAL_FLAG = ( CASE WHEN B.ACTUAL_FLAG = 'Y' THEN 'Y' ELSE 'N' END )
          FROM   FP_RELEASE_FIX_PLAN_H A
LEFT OUTER JOIN FP_DAILY_INSTANCE_ORDER_STATUS B
                      ON    A.INSTANCE_ID   = B.INSTANCE_ID
                      AND   A.AMEND_PLAN_ID = B.FP_PLAN_ID
                      AND   A.WORK_ORDER_ID = B.WORK_ORDER_SPL_ID
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
          SET    A.ACTUAL_FLAG = ( CASE WHEN B.ACTUAL_FLAG = 'Y' THEN 'Y' ELSE 'N' END )
          FROM   FP_RELEASE_FULL_PLAN_H A
                 LEFT OUTER JOIN FP_DAILY_INSTANCE_ORDER_STATUS B
                      ON    A.INSTANCE_ID  = B.INSTANCE_ID
                      AND   A.AMEND_PLAN_ID = B.FP_PLAN_ID
                      AND   A.WORK_ORDER_ID = B.WORK_ORDER_SPL_ID
          WHERE  A.INSTANCE_ID      = @v_master_id
          AND    A.RELEASE_PLAN_ID  = @v_plan_id
          
          SET @n_row_count = @@ROWCOUNT
                
          --LOG 생성
          SET @v_message = 'ACTUAL_FLAG : ' + CONVERT(NVARCHAR, @n_row_count)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        END
        */

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
      

      -- PSI AMEND 정보 생성
      IF CHARINDEX('FORM', @v_master_id) = 0    -- 활성화 제외
      BEGIN

        -- AMEND PLAN 테이블 정보 생성
        BEGIN

        -- INSTANCE 별로 구분할 경우를 대비하여,, CASE 문으로 설정..
          SELECT @v_sqltable = (CASE WHEN charindex('CELL', @v_master_id) > 0 THEN 'FP_AMEND_PLAN_CELL_R'
                                                                              ELSE 'FP_AMEND_PLAN_PACK_R'
                                END  )
               , @v_reltable = (CASE WHEN charindex('CELL', @v_master_id) > 0 THEN 'FP_AMEND_PLAN_CELL_H'
                                                                              ELSE 'FP_AMEND_PLAN_PACK_H'
                                END  )

          -- 기존 데이터  삭제
          SET @v_sqltext  = 'delete from ' + @v_reltable + ' '          -- RELEASE 용 테이블
                          + 'where  1=1 '
                          + 'and    instance_id = '''+@v_master_id+''' '
                          + 'and    fp_plan_id  = '''+@v_plan_id+''' '

          EXEC sp_executesql @v_sqltext, N'@v_return AS INTEGER OUTPUT', @v_return=@n_row_count OUTPUT

          -- 신규 데이터 생성
          SET @v_sqltext  = 'insert into ' + @v_reltable + ' '          -- RELEASE 용 테이블
                          + '     ( '
                          + '       INSTANCE_ID '
                          + '     , FP_PLAN_ID '
                          + '     , COMPANY_ID, DIVISION_ID, CATEGORY_ID, SITE_ID, PLANT_ID, ITEM_ID '
                          + '     , OPERATION_ID, FACTORY_ID, LOCATION, PRODUCTION_TYPE, MARKET, LINE_ID, ELECTRODE_TYPE '
                          + '     , PLAN_DATE, TOP_ITEM_ID, ITEM_TYPE '
                          + '     , IN_QTY, OUT_QTY, CELL_IN_QTY, CELL_OUT_QTY '
                          + '     , DATE_SEQ '
                          + '     , INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME '
                          + '     , SETUP_COLOR_CODE '
                          + '     , RESULT_IN_QTY, RESULT_OUT_QTY, RESULT_CELL_IN_QTY, RESULT_CELL_OUT_QTY '
                          + '     , WPP_IN_QTY, WPP_OUT_QTY, WPP_CELL_IN_QTY, WPP_CELL_OUT_QTY '
                          + '     , MPP_IN_QTY, MPP_OUT_QTY, MPP_CELL_IN_QTY, MPP_CELL_OUT_QTY '
                          + '     , VERSION, PLM_EC_NO '	-- (D20240509~R0509.01) 
                          + '     ) '
                          + 'SELECT '
                          + '       INSTANCE_ID '
                          + '     , '''+@v_plan_id+'''     AS FP_PLAN_ID '
                          + '     , COMPANY_ID, DIVISION_ID, CATEGORY_ID, SITE_ID, PLANT_ID, ITEM_ID '
                          + '     , OPERATION_ID, FACTORY_ID, LOCATION, PRODUCTION_TYPE, MARKET, LINE_ID, ELECTRODE_TYPE '
                          + '     , PLAN_DATE, TOP_ITEM_ID, ITEM_TYPE '
                          + '     , IN_QTY, OUT_QTY, CELL_IN_QTY, CELL_OUT_QTY '
                          + '     , DATE_SEQ '
                          + '     , INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME '
                          + '     , SETUP_COLOR_CODE '
                          + '     , RESULT_IN_QTY, RESULT_OUT_QTY, RESULT_CELL_IN_QTY, RESULT_CELL_OUT_QTY '
                          + '     , WPP_IN_QTY, WPP_OUT_QTY, WPP_CELL_IN_QTY, WPP_CELL_OUT_QTY '
                          + '     , MPP_IN_QTY, MPP_OUT_QTY, MPP_CELL_IN_QTY, MPP_CELL_OUT_QTY '
                          + '     , VERSION, PLM_EC_NO '	-- (D20240509~R0509.01) 
                          + 'FROM   ' + @v_sqltable + ' A '
                          + 'WHERE  A.INSTANCE_ID = '''+@v_master_id+''' '
                          + 'AND    EXISTS (   '
                          + '                SELECT  1  '
                          + '                FROM    ( '
                          + '                          SELECT A.INSTANCE_ID, A.PLAN_ID '
                          + '                               , B.FACTORY_ID, B.LINE_ID, B.OPERATION_ID, B.ELECTRODE_TYPE '
                          + '                          FROM   SCM_FP_PLAN_GROUP_DETAIL_H A WITH(NOLOCK), '
                          + '                                 SCM_LINE_M     B WITH(NOLOCK)'
                          + '                          WHERE  A.PLAN_DATE      = '''+@v_plan_date+''' '
                          + '                          AND    A.INSTANCE_ID    = '''+@v_master_id+''' '
                          + '                          AND    A.PLAN_GROUP_ID  = '''+@v_plan_group_id+''' '
                          + '                          AND    A.PLAN_GROUP_ID  = B.MODEL_TYPE '
                          + '                        ) X '
                          + '                WHERE   X.INSTANCE_ID   = A.INSTANCE_ID  '
                          + '                AND     X.PLAN_ID       = A.FP_PLAN_ID  '
                          + '                AND     X.FACTORY_ID    = A.FACTORY_ID '
                          + '                AND     X.LINE_ID       = A.LINE_ID '
                          + '                AND     X.OPERATION_ID  = A.OPERATION_ID '
+ '               ) '
                          + 'AND    EXISTS (  '
                          + '               SELECT 1 '
                          + '               FROM   SCM_OPERATION_M Y WITH(NOLOCK) '
                          + '               WHERE  Y.COMPANY_ID =  A.COMPANY_ID '
                 + '               AND    Y.DIVISION_ID   = A.DIVISION_ID '
                          + '               AND    Y.SITE_ID       = A.SITE_ID '
                          + '               AND    Y.OPERATION_ID  = A.OPERATION_ID '
                          + '               AND    Y.WO_FLAG = '''+'Y'+''' '
                          + '               UNION  ALL '
                          + '               SELECT 1 '
                          + '               FROM   (SELECT ''' + 'F6000' + ''' AS OPERATION_ID) Z '
                          + '               WHERE  Z.OPERATION_ID = A.OPERATION_ID '
                          + '              ) '

          EXEC sp_executesql @v_sqltext, N'@v_return AS INTEGER OUTPUT', @v_return=@n_row_count OUTPUT


          -- 신규 데이터 생성 수량 COUNT
          SET @v_sqltext  = 'SELECT @v_return = COUNT(1) '
                          + 'FROM   ' + @v_reltable + ' a '
                          + 'where  1=1 '
                          + 'and    a.instance_id           = '''+@v_master_id+''' '
                          + 'and    a.fp_plan_id            = '''+@v_plan_id+''' '

          EXEC sp_executesql @v_sqltext, N'@v_return AS INTEGER OUTPUT', @v_return=@n_row_count OUTPUT

          --LOG 생성
          SET @v_message   = 'DYNAMIC SQL : ' + CONVERT(NVARCHAR, @n_row_count)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate     = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_reltable, 'INSERT', @n_log_count, null, @v_message, null

        END

        -- AMEND BOR 테이블 정보 생성
        BEGIN
        
          SELECT @v_sqltable = (CASE WHEN charindex('CELL', @v_master_id) > 0 THEN 'FP_AMEND_PLAN_CELL_BOR_R'
                                                                              ELSE 'FP_AMEND_PLAN_PACK_BOR_R'
                                END  )
               , @v_reltable = (CASE WHEN charindex('CELL', @v_master_id) > 0 THEN 'FP_AMEND_PLAN_CELL_BOR_H'
                                                                              ELSE 'FP_AMEND_PLAN_PACK_BOR_H'
                                END  )

          -- 기존 데이터  삭제
          SET @v_sqltext  = 'delete from ' + @v_reltable + ' '        -- RELEASE 용 테이블
                          + 'where  1=1 '
                          + 'and    instance_id = '''+@v_master_id+''' '
                          + 'and    fp_plan_id  = '''+@v_plan_id+''' '

          EXEC sp_executesql @v_sqltext, N'@v_return AS INTEGER OUTPUT', @v_return=@n_row_count OUTPUT

          -- 신규 데이터 생성
          SET @v_sqltext  = 'insert into ' + @v_reltable + ' '        -- RELEASE 용 테이블
                          + '     ( '
             + '       INSTANCE_ID '
                          + '     , FP_PLAN_ID '
                          + '     , COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID '
                          + '     , FACTORY_ID, LOCATION, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID, CAPA_TYPE '
                          + '     , ITEM_ID, ITEM_UOM, MONTH, START_DATE, END_DATE '
                          + '     , PRIORITY, TACT_TIME, TACT_TIME_UOM, YIELD, CHILD_YIELD, UTILIZATION, CHILD_UTILIZATION '
                          + '     , INSERT_ID '
                          + '     , INSERT_TIME '
                          + '     ) '
                          + 'SELECT '
                          + '       INSTANCE_ID '
                          + '     , '''+@v_plan_id+'''     AS FP_PLAN_ID '
                          + '     , COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID '
                          + '     , FACTORY_ID, LOCATION, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID, CAPA_TYPE '
                          + '     , ITEM_ID, ITEM_UOM, MONTH, START_DATE, END_DATE '
                          + '     , PRIORITY, TACT_TIME, TACT_TIME_UOM, YIELD, CHILD_YIELD, UTILIZATION, CHILD_UTILIZATION '
   + '     , INSERT_ID '
                          + '     , INSERT_TIME '
                          + 'FROM   ' + @v_sqltable + ' A '
                          + 'WHERE  A.INSTANCE_ID = '''+@v_master_id+''' '
                          + 'AND    EXISTS (   '
                          + '                SELECT  1  '
                          + '                FROM    ( '
                          + '                          SELECT A.INSTANCE_ID, A.PLAN_ID '
                          + '                               , B.FACTORY_ID, B.LINE_ID, B.OPERATION_ID, B.ELECTRODE_TYPE '
                          + '                          FROM   SCM_FP_PLAN_GROUP_DETAIL_H A, '
                          + '                                 SCM_LINE_M                 B '
                          + '                          WHERE  A.PLAN_DATE      = '''+@v_plan_date+''' '
                          + '                          AND    A.INSTANCE_ID    = '''+@v_master_id+''' '
                          + '                          AND    A.PLAN_GROUP_ID  = '''+@v_plan_group_id+''' '
                          + '                          AND    A.PLAN_GROUP_ID  = B.MODEL_TYPE '
                          + '                        ) X '
                        + '                WHERE   X.INSTANCE_ID   = A.INSTANCE_ID  '
                          + '                AND     X.PLAN_ID       = A.FP_PLAN_ID  '
                          + '                AND     X.FACTORY_ID    = A.FACTORY_ID '
                          + '                AND     X.LINE_ID       = A.LINE_ID '
                          + '                AND     X.OPERATION_ID  = A.OPERATION_ID '
                          + '               ) '
                          + 'AND    EXISTS (  '
                          + '               SELECT 1 '
                          + '               FROM   SCM_OPERATION_M Y '
                          + '               WHERE  Y.COMPANY_ID =  A.COMPANY_ID '
                          + '               AND    Y.DIVISION_ID   = A.DIVISION_ID '
                          + '               AND    Y.SITE_ID       = A.SITE_ID '
                          + '               AND    Y.OPERATION_ID  = A.OPERATION_ID '
                          + '               AND    Y.WO_FLAG = '''+'Y'+''' '
                          + '               UNION  ALL '
                          + '               SELECT 1 '
                          + '               FROM   (SELECT ''' + 'F6000' + ''' AS OPERATION_ID) Z '
                          + '               WHERE  Z.OPERATION_ID = A.OPERATION_ID '
                          + '              ) '

          EXEC sp_executesql @v_sqltext, N'@v_return AS INTEGER OUTPUT', @v_return=@n_row_count OUTPUT


          -- 신규 데이터 생성 수량 COUNT
          SET @v_sqltext  = 'SELECT @v_return = COUNT(1) '
                          + 'FROM   ' + @v_reltable + ' a '
                          + 'where  1=1 '
                          + 'and    a.instance_id           = '''+@v_master_id+''' '
                          + 'and    a.fp_plan_id            = '''+@v_plan_id+''' '

          EXEC sp_executesql @v_sqltext, N'@v_return AS INTEGER OUTPUT', @v_return=@n_row_count OUTPUT

          --LOG 생성
          SET @v_message   = 'DYNAMIC SQL : ' + CONVERT(NVARCHAR, @n_row_count)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate     = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_reltable, 'INSERT', @n_log_count, null, @v_message, null

        END
        
        -- AMEND UTIL 테이블 정보 생성
        BEGIN
        
          SELECT @v_sqltable = (CASE WHEN charindex('CELL', @v_master_id) > 0 THEN 'FP_AMEND_PLAN_CELL_UTIL_R'
                                     WHEN charindex('FORM', @v_master_id) > 0 THEN 'FP_AMEND_PLAN_FORM_UTIL_R'
                                                                              ELSE 'FP_AMEND_PLAN_PACK_UTIL_R'
                                END  )
               , @v_reltable = (CASE WHEN charindex('CELL', @v_master_id) > 0 THEN 'FP_AMEND_PLAN_CELL_UTIL_H'
                                     WHEN charindex('FORM', @v_master_id) > 0 THEN 'FP_AMEND_PLAN_FORM_UTIL_H'
                                                                              ELSE 'FP_AMEND_PLAN_PACK_UTIL_H'
                                END  )

          -- 기존 데이터  삭제
          SET @v_sqltext  = 'delete from ' + @v_reltable + ' '        -- RELEASE 용 테이블
                          + 'where  1=1 '
                          + 'and    instance_id = '''+@v_master_id+''' '
                          + 'and    fp_plan_id  = '''+@v_plan_id+''' '

          EXEC sp_executesql @v_sqltext, N'@v_return AS INTEGER OUTPUT', @v_return=@n_row_count OUTPUT

          -- 신규 데이터 생성
          SET @v_sqltext  = 'insert into ' + @v_reltable + ' '        -- RELEASE 용 테이블
                          + '     ( '
                          + '       INSTANCE_ID '
                          + '     , FP_PLAN_ID '
                          + '    , COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID '
                          + '     , FACTORY_ID, LOCATION, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID '
                          + '     , PLAN_DATE, RUN_TIME, OFF_TIME, SETUP_TIME, UTILIZATION '
                          + '     , INSERT_ID '
                          + '     , INSERT_TIME '
                          + '     ) '
                          + 'SELECT '
                          + '       INSTANCE_ID '
                          + '     , '''+@v_plan_id+'''     AS FP_PLAN_ID '
                          + '     , COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID '
                          + '     , FACTORY_ID, LOCATION, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID '
                          + '     , PLAN_DATE, RUN_TIME, OFF_TIME, SETUP_TIME, UTILIZATION '
                          + '     , INSERT_ID '
                          + '     , INSERT_TIME '
                          + 'FROM   ' + @v_sqltable + ' A '
                          + 'WHERE  A.INSTANCE_ID = '''+@v_master_id+''' '
                          + 'AND    EXISTS (   '
                          + '                SELECT  1  '
                          + '                FROM    ( '
                          + '                          SELECT A.INSTANCE_ID, A.PLAN_ID '
                          + '                               , B.FACTORY_ID, B.LINE_ID, B.OPERATION_ID, B.ELECTRODE_TYPE '
                          + '                          FROM   SCM_FP_PLAN_GROUP_DETAIL_H A, '
                          + '       SCM_LINE_M                 B '
                          + '                          WHERE  A.PLAN_DATE      = '''+@v_plan_date+''' '
          + '                          AND    A.INSTANCE_ID    = '''+@v_master_id+''' '
                          + '                          AND    A.PLAN_GROUP_ID  = '''+@v_plan_group_id+''' '
                          + '                          AND    A.PLAN_GROUP_ID  = B.MODEL_TYPE '
                          + '                        ) X '
                          + '                WHERE   X.INSTANCE_ID   = A.INSTANCE_ID  '
                          + '                AND     X.PLAN_ID       = A.FP_PLAN_ID  '
                          + '                AND     X.FACTORY_ID    = A.FACTORY_ID '
                          + '                AND     X.LINE_ID       = A.LINE_ID '
                          + '    AND     X.OPERATION_ID  = A.OPERATION_ID '
                          + '               ) '
                          + 'AND    EXISTS (  '
                          + '               SELECT 1 '
                          + '               FROM   SCM_OPERATION_M Y '
                          + '               WHERE  Y.COMPANY_ID =  A.COMPANY_ID '
                          + '           AND    Y.DIVISION_ID   = A.DIVISION_ID '
                          + '               AND    Y.SITE_ID       = A.SITE_ID '
                          + '               AND    Y.OPERATION_ID  = A.OPERATION_ID '
                          + '               AND    Y.WO_FLAG = '''+'Y'+''' '
                          + '               UNION  ALL '
                          + '               SELECT 1 '
                          + '               FROM   (SELECT ''' + 'F6000' + ''' AS OPERATION_ID) Z '
                          + '               WHERE  Z.OPERATION_ID = A.OPERATION_ID '
                          + '              ) '

          EXEC sp_executesql @v_sqltext, N'@v_return AS INTEGER OUTPUT', @v_return=@n_row_count OUTPUT


          -- 신규 데이터 생성 수량 COUNT
          SET @v_sqltext  = 'SELECT @v_return = COUNT(1) '
                          + 'FROM   ' + @v_reltable + ' a '
                          + 'where  1=1 '
                          + 'and    a.instance_id           = '''+@v_master_id+''' '
                          + 'and    a.fp_plan_id            = '''+@v_plan_id+''' '

          EXEC sp_executesql @v_sqltext, N'@v_return AS INTEGER OUTPUT', @v_return=@n_row_count OUTPUT

          --LOG 생성
          SET @v_message   = 'DYNAMIC SQL : ' + CONVERT(NVARCHAR, @n_row_count)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate     = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_reltable, 'INSERT', @n_log_count, null, @v_message, null

        END
        
        -- AMEND SALES 테이블 정보 생성
        BEGIN
        
          SELECT @v_sqltable = (CASE WHEN charindex('CELL', @v_master_id) > 0 THEN 'FP_AMEND_PLAN_CELL_SALES_R'
                                                                              ELSE 'FP_AMEND_PLAN_PACK_SALES_R'
                                END  )
               , @v_reltable = (CASE WHEN charindex('CELL', @v_master_id) > 0 THEN 'FP_AMEND_PLAN_CELL_SALES_H'
                                                                              ELSE 'FP_AMEND_PLAN_PACK_SALES_H'
                                END  )

          -- 기존 데이터  삭제
          SET @v_sqltext  = 'delete from ' + @v_reltable + ' '        -- RELEASE 용 테이블
                          + 'where  1=1 '
                          + 'and    instance_id = '''+@v_master_id+''' '
                          + 'and    fp_plan_id  = '''+@v_plan_id+''' '

          EXEC sp_executesql @v_sqltext, N'@v_return AS INTEGER OUTPUT', @v_return=@n_row_count OUTPUT

          -- 신규 데이터 생성
          SET @v_sqltext  = 'insert into ' + @v_reltable + ' '        -- RELEASE 용 테이블
                      + '     ( '
                          + '       INSTANCE_ID '
                          + '     , FP_PLAN_ID '
                          + '     , COMPANY_ID, DIVISION_ID, CATEGORY_ID, SITE_ID, PLANT_ID '
                          + '     , ITEM_ID, OPERATION_ID, FACTORY_ID, LOCATION, PRODUCTION_TYPE, MARKET '
                          + '     , LINE_ID, ELECTRODE_TYPE, PLAN_DATE, TOP_ITEM_ID, ITEM_TYPE '
                          + '     , SALES_QTY, SALES_CUMULATIVE_QTY, CELL_SALES_QTY, CELL_SALES_CUMULATIVE_QTY '
                          + '     , ORG_SALES_QTY, ORG_SALES_CUMULATIVE_QTY, ORG_CELL_SALES_QTY, ORG_CELL_SALES_CUMULATIVE_QTY '
                          + '     , INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME, VERSION, PLM_EC_NO '	-- (D20240509~R0509.01) 
                          + '     ) '
                          + 'SELECT '
                          + '       INSTANCE_ID '
                          + '     , '''+@v_plan_id+'''     AS FP_PLAN_ID '
    + '     , COMPANY_ID, DIVISION_ID, CATEGORY_ID, SITE_ID, PLANT_ID '
                          + '     , ITEM_ID, OPERATION_ID, FACTORY_ID, LOCATION, PRODUCTION_TYPE, MARKET '
                          + '     , LINE_ID, ELECTRODE_TYPE, PLAN_DATE, TOP_ITEM_ID, ITEM_TYPE '
            + '     , SALES_QTY, SALES_CUMULATIVE_QTY, CELL_SALES_QTY, CELL_SALES_CUMULATIVE_QTY '
                          + '     , ORG_SALES_QTY, ORG_SALES_CUMULATIVE_QTY, ORG_CELL_SALES_QTY, ORG_CELL_SALES_CUMULATIVE_QTY '
                          + '     , INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME, VERSION, PLM_EC_NO '	-- (D20240509~R0509.01) 
                          + 'FROM   ' + @v_sqltable + ' A '
                          + 'WHERE  A.INSTANCE_ID = '''+@v_master_id+''' '
                          + 'AND    EXISTS (   '
                          + '                SELECT  1  '
                          + '                FROM    ( '
                          + '                          SELECT A.INSTANCE_ID, A.PLAN_ID '
                          + '                               , B.FACTORY_ID, B.LINE_ID, B.OPERATION_ID, B.ELECTRODE_TYPE '
                          + '                          FROM   SCM_FP_PLAN_GROUP_DETAIL_H A WITH(NOLOCK), '
                          + '                                 SCM_LINE_M                 B WITH(NOLOCK) '
                          + '                          WHERE  A.PLAN_DATE      = '''+@v_plan_date+''' '
                          + '                          AND    A.INSTANCE_ID    = '''+@v_master_id+''' '
                          + '                          AND    A.PLAN_GROUP_ID  = '''+@v_plan_group_id+''' '
                          + '                          AND    A.PLAN_GROUP_ID  = B.MODEL_TYPE '
                          + '                        ) X '
                          + '                WHERE   X.INSTANCE_ID   = A.INSTANCE_ID  '
                          + '                AND     X.PLAN_ID       = A.FP_PLAN_ID  '
                          + '                AND     X.FACTORY_ID    = A.FACTORY_ID '
                          + '                AND     X.LINE_ID       = A.LINE_ID '
                          + '                AND     X.OPERATION_ID  = A.OPERATION_ID '
                          + '               ) '
                          + 'AND    EXISTS (  '
                          + '               SELECT 1 '
                          + '               FROM   SCM_OPERATION_M Y WITH(NOLOCK) '
                          + '               WHERE  Y.COMPANY_ID =  A.COMPANY_ID '
                          + '               AND    Y.DIVISION_ID   = A.DIVISION_ID '
                          + '               AND    Y.SITE_ID       = A.SITE_ID '
                          + '               AND    Y.OPERATION_ID  = A.OPERATION_ID '
                          + '               AND    Y.WO_FLAG = '''+'Y'+''' '
                          + '               UNION  ALL '
         + '               SELECT 1 '
                          + '               FROM   (SELECT ''' + 'F6000' + ''' AS OPERATION_ID) Z '
                          + '     WHERE  Z.OPERATION_ID = A.OPERATION_ID '
                          + '              ) '

          EXEC sp_executesql @v_sqltext, N'@v_return AS INTEGER OUTPUT', @v_return=@n_row_count OUTPUT


          -- 신규 데이터 생성 수량 COUNT
          SET @v_sqltext  = 'SELECT @v_return = COUNT(1) '
                          + 'FROM   ' + @v_reltable + ' a '
                          + 'where  1=1 '
                          + 'and    a.instance_id           = '''+@v_master_id+''' '
                          + 'and    a.fp_plan_id            = '''+@v_plan_id+''' '

          EXEC sp_executesql @v_sqltext, N'@v_return AS INTEGER OUTPUT', @v_return=@n_row_count OUTPUT

          --LOG 생성
          SET @v_message   = 'DYNAMIC SQL : ' + CONVERT(NVARCHAR, @n_row_count)
          SET @n_log_count = @n_log_count + 1
         SET @sysdate     = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_reltable, 'INSERT', @n_log_count, null, @v_message, null

        END

        ------------------------------------------------------------------------------------------------------------

       SET @v_table_name = 'FP_AMEND_CUTOFF_BOH_H'
        
        DELETE  FROM FP_AMEND_CUTOFF_BOH_H
        WHERE   INSTANCE_ID   = @v_master_id
        AND     FP_PLAN_ID    = @v_plan_id

        INSERT INTO FP_AMEND_CUTOFF_BOH_H           -- RELEASE 용 테이블
             (
               INSTANCE_ID
             , FP_PLAN_ID
             , COMPANY_ID
             , DIVISION_ID
             , SITE_ID
             , PLANT_ID
             , ITEM_ID
             , OPERATION_ID
             , FACTORY_ID
             , LINE_ID
             , LOCATION
             , QTY
             , MODIFY_QTY
             , INSERT_ID
             , INSERT_TIME
             , UPDATE_ID
             , UPDATE_TIME
             , TOP_ITEM_ID
             , RNK
             , ELECTRODE_TYPE
             , VERSION		-- (D20240509~R0509.01) 
             , PLM_EC_NO	-- (D20240509~R0509.01) 
             )
        SELECT             
               INSTANCE_ID
             , @v_plan_id       AS FP_PLAN_ID
             , COMPANY_ID
             , DIVISION_ID
             , SITE_ID
             , PLANT_ID
             , ITEM_ID
             , OPERATION_ID
             , FACTORY_ID
        , LINE_ID
             , LOCATION
             , QTY
             , MODIFY_QTY
             , @v_proc_name     AS INSERT_ID
             , GETDATE()        AS INSERT_TIME
             , @v_proc_name     AS UPDATE_ID
             , GETDATE()        AS UPDATE_TIME
             , TOP_ITEM_ID
             , RNK
             , ELECTRODE_TYPE
             , VERSION		-- (D20240509~R0509.01) 
             , PLM_EC_NO	-- (D20240509~R0509.01) 
        FROM   FP_AMEND_CUTOFF_BOH_R A        -- AMEND 용 테이블
        WHERE  A.INSTANCE_ID = @v_master_id
        AND    EXISTS (  
                        SELECT  1 
                        FROM    (
                                  SELECT A.INSTANCE_ID, A.PLAN_ID
                                       , B.FACTORY_ID, B.LINE_ID, B.OPERATION_ID, B.ELECTRODE_TYPE
                                  FROM   SCM_FP_PLAN_GROUP_DETAIL_H A WITH(NOLOCK),
                                         SCM_LINE_M                 B WITH(NOLOCK)
                                  WHERE  A.PLAN_DATE      = @v_plan_date
                                  AND    A.INSTANCE_ID    = @v_master_id
                                  AND    A.PLAN_GROUP_ID  = @v_plan_group_id
                                  AND    A.PLAN_GROUP_ID  = B.MODEL_TYPE
                                ) X
                        WHERE   X.INSTANCE_ID   = A.INSTANCE_ID 
                        AND     X.PLAN_ID       = A.FP_PLAN_ID 
                        AND     X.FACTORY_ID    = A.FACTORY_ID
                        --AND     X.LINE_ID       = A.LINE_ID
     AND     X.OPERATION_ID  = A.OPERATION_ID
                       )

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        ------------------------------------------------------------------------------------------------------------

        SET @v_table_name = 'FP_AMEND_PLAN_R'

        DELETE FROM A
        FROM   FP_AMEND_PLAN_R A
        WHERE  A.INSTANCE_ID = @v_master_id
        AND    A.OUT_QTY     = 0
        AND    EXISTS (  
                        SELECT  1 
                        FROM    (
                                  SELECT A.INSTANCE_ID, A.PLAN_ID
                                       , B.FACTORY_ID, B.LINE_ID, B.OPERATION_ID, B.ELECTRODE_TYPE
                                  FROM   SCM_FP_PLAN_GROUP_DETAIL_H A WITH(NOLOCK),
     SCM_LINE_M                 B WITH (NOLOCK)
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
        SET @v_message = 'OUT_QTY = 0 : ' + CONVERT(NVARCHAR, @n_row_count)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null


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
             , COLOR_ATTRIBUTE
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
             , A.COLOR_ATTRIBUTE
        FROM FP_AMEND_ITEM A
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

      END
      -- ADD (D.20210427~R.0427.01)
      	-------------------------------------------------------------------------------------------------------
        -- FORMATION 전용 : START
        -------------------------------------------------------------------------------------------------------
        IF CHARINDEX('FORM', @v_master_id) > 0 AND @v_master_id <> 'CN_FORM_T'
        BEGIN
          
          SET @v_table_name = 'FP_AMEND_CUTOFF_BOH_H'
        
          DELETE  FROM FP_AMEND_CUTOFF_BOH_H
          WHERE   INSTANCE_ID   = @v_master_id
          AND     FP_PLAN_ID    = @v_plan_id

          INSERT INTO FP_AMEND_CUTOFF_BOH_H         -- RELEASE 용 테이블
               (
                 INSTANCE_ID
               , FP_PLAN_ID
               , COMPANY_ID
               , DIVISION_ID
               , SITE_ID
               , PLANT_ID
               , ITEM_ID
               , OPERATION_ID
               , FACTORY_ID
               , LINE_ID
               , LOCATION
               , QTY
               , MODIFY_QTY
               , INSERT_ID
               , INSERT_TIME
               , UPDATE_ID
               , UPDATE_TIME
               , TOP_ITEM_ID
               , RNK
               , ELECTRODE_TYPE
               , HOLD_QTY
               )
          SELECT 
                 A.INSTANCE_ID
               , @v_plan_id     AS FP_PLAN_ID
 , A.COMPANY_ID
               , A.DIVISION_ID
               , A.SITE_ID
               , A.PLANT_ID
               , A.ITEM_ID
               , A.OPERATION_ID
               , A.FACTORY_ID
               , A.LINE_ID
               , A.LOCATION
               , A.QTY
               , A.MODIFY_QTY
               , A.INSERT_ID
               , A.INSERT_TIME
               , A.UPDATE_ID
               , A.UPDATE_TIME
               , A.TOP_ITEM_ID
               , A.RNK
               , A.ELECTRODE_TYPE
               , A.HOLD_QTY
          FROM   FP_AMEND_CUTOFF_BOH_R A
          WHERE  A.INSTANCE_ID = @v_master_id
          AND    EXISTS (   
							SELECT  1  
							FROM    ( -- factory, line 정보가 없어 division, operation 만 건다.
										SELECT 	DISTINCT A.INSTANCE_ID, A.PLAN_ID, B.OPERATION_ID 
										FROM   	SCM_FP_PLAN_GROUP_DETAIL_H A, 
												SCM_LINE_M                 B 
										WHERE  	A.PLAN_DATE    	= @v_plan_date 
										AND    	A.INSTANCE_ID  	= @v_master_id 
										AND    	A.PLAN_GROUP_ID	= @v_plan_group_id 
										AND    	A.PLAN_GROUP_ID	= B.MODEL_TYPE 
									) X 
							WHERE   X.INSTANCE_ID	= A.INSTANCE_ID  
							AND     X.PLAN_ID       = A.FP_PLAN_ID  
							--AND     X.FACTORY_ID    = A.FACTORY_ID 
							--AND     X.LINE_ID       = A.LINE_ID 
							AND     X.OPERATION_ID  = A.OPERATION_ID 
						) 
          AND    EXISTS (  
	                         SELECT 1
	                         FROM   SCM_OPERATION_M Y WITH(NOLOCK)
	                         WHERE  Y.COMPANY_ID    = A.COMPANY_ID
	                         AND    Y.DIVISION_ID   = A.DIVISION_ID
	                         AND    Y.SITE_ID       = A.SITE_ID
	                         AND    Y.OPERATION_ID  = A.OPERATION_ID
	                         AND    Y.WO_FLAG       = 'Y'
	                         UNION  ALL
	                         SELECT 1
	                         FROM   (SELECT 'F6000' AS OPERATION_ID) Z      -- 활성화
	                         WHERE  Z.OPERATION_ID = A.OPERATION_ID
                        )
                      
          SET @v_table_name = 'FP_AMEND_CUTOFF_BOH_R'
          
          DELETE FROM FP_AMEND_CUTOFF_BOH_R
          WHERE  INSTANCE_ID  = @v_master_id
          AND    FP_PLAN_ID   = @v_plan_id
 
          -- RELEASE  Plan ID 로 입력
          INSERT INTO FP_AMEND_CUTOFF_BOH_R
              (
                INSTANCE_ID ,
             FP_PLAN_ID ,
                COMPANY_ID ,
                DIVISION_ID ,
                SITE_ID ,
                PLANT_ID ,
                ITEM_ID ,
                OPERATION_ID ,
                FACTORY_ID ,
                LINE_ID  ,
 LOCATION ,
                QTY ,
                MODIFY_QTY ,
                INSERT_ID ,
                INSERT_TIME ,
                UPDATE_ID ,
                UPDATE_TIME ,
                TOP_ITEM_ID ,
                RNK ,
                ELECTRODE_TYPE ,
                ORG_QTY ,
                ORG_MODIFY_QTY ,
                CUMULATIVE_QTY ,
                CUMULATIVE_MODIFY_QTY
              )
          SELECT  DISTINCT INSTANCE_ID ,
                  @v_plan_id AS FP_PLAN_ID ,
                  COMPANY_ID ,
                  DIVISION_ID ,
                  SITE_ID ,
                  PLANT_ID ,
                 ITEM_ID ,
                  OPERATION_ID ,
                  FACTORY_ID ,
                  LINE_ID  ,
                  LOCATION ,
                  QTY ,
                  MODIFY_QTY ,
                  @v_proc_name as INSERT_ID ,
                  getdate() as INSERT_TIME ,
                  @v_proc_name as UPDATE_ID ,
                  getdate() as  UPDATE_TIME ,
                  TOP_ITEM_ID ,
                  RNK ,
                  ELECTRODE_TYPE ,
                  ORG_QTY ,
                  ORG_MODIFY_QTY ,
                  CUMULATIVE_QTY ,
                  CUMULATIVE_MODIFY_QTY
          FROM   FP_AMEND_CUTOFF_BOH_R A
          WHERE 1=1  
          AND   A.INSTANCE_ID = @V_MASTER_ID
          AND    EXISTS (   
							SELECT  1  
							FROM    ( 
										-- factory, line 정보가 없어 division, operation 만 건다.
										SELECT 	DISTINCT A.INSTANCE_ID, A.PLAN_ID, B.OPERATION_ID 
										FROM   	SCM_FP_PLAN_GROUP_DETAIL_H A, 
												SCM_LINE_M                 B 
										WHERE  	A.PLAN_DATE    	= @v_plan_date 
										AND    	A.INSTANCE_ID  	= @v_master_id 
										AND    	A.PLAN_GROUP_ID	= @v_plan_group_id 
										AND    	A.PLAN_GROUP_ID	= B.MODEL_TYPE 
									) X 
							WHERE   X.INSTANCE_ID	= A.INSTANCE_ID  
							AND     X.PLAN_ID       = A.FP_PLAN_ID  
							--AND     X.FACTORY_ID    = A.FACTORY_ID 
							--AND     X.LINE_ID       = A.LINE_ID 
							AND     X.OPERATION_ID  = A.OPERATION_ID 
						)
                    
          SET @n_row_count = @@ROWCOUNT
                
          --LOG 생성
          SET @v_message = CONVERT(NVARCHAR, @n_row_count)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
          SET @v_table_name = 'FP_AMEND_PLAN_FORM_R'
          
          DELETE FROM FP_AMEND_PLAN_FORM_R
          WHERE  INSTANCE_ID  = @v_master_id
          AND    FP_PLAN_ID   = @v_plan_id

          INSERT INTO FP_AMEND_PLAN_FORM_R
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
               , CUSTOMER_ID
               , PLAN_DATE
               , TOP_ITEM_ID
               , ITEM_TYPE
               , BOH_QTY
               , SHIPPING_QTY
               , IN_QTY
               , OUT_QTY
               , SALES_QTY
               , NET_QTY
               , CARRYOVER_QTY
               , EOH_QTY 
               , AVAILABILITY
        , AGING_WIP
               , FORMATION_TOTAL
               , SHIP_EOH 
       , YIELD
               , DATE_SEQ
         , ACTUAL_FLAG
               , ORG_BOH_QTY
               , ORG_SHIPPING_QTY
               , ORG_IN_QTY
               , ORG_OUT_QTY
               , ORG_SALES_QTY
               , ORG_NET_QTY
               , ORG_CARRYOVER_QTY
 , ORG_EOH_QTY
               , ORG_AVAILABILITY
               , ORG_AGING_WIP
               , ORG_FORMATION_TOTAL
               , INSERT_ID
               , INSERT_TIME
               , UPDATE_ID
               , UPDATE_TIME
               , SALES_CELL_QTY
               , SALES_PACK_QTY
			   , AGING_LEAD_TIME  -- Add 2020-01-10 by cys
			   , CAL_AGING_QTY	  -- Add 2020-01-10 by cys	
               , CELL_GROUP_CODE
               , AGING_WIP_BD															
               , AGING_WIP_AD															
               , AGING_WIP_SIM															
               , AGING_WIP_SIM_BD															
               , AGING_WIP_SIM_AD															
               , PKG_PLAN_DATE															
               , ACTIVATED_SIM															
               , SALES_REQUEST_QTY															
  			   , ORG_SALES_REQUEST_QTY	
               , SETUP_FLAG
               , SETUP_TIME
               , RESULT_QTY
               , SHIPPING_RESULT_QTY
               , WPP_IN_QTY
               , WPP_OUT_QTY
               , MPP_IN_QTY
               , MPP_OUT_QTY
			  , PKG_QTY  -- Add 2020-01-10 by cys
			   , PAST_SALES_QTY	  -- Add 2020-01-10 by cys	
               , EOL_ACTIVATED_STOCK
      , SALES_SIMUL_QTY	-- (D20201229~R0105.01)
               )
          SELECT
                 A.INSTANCE_ID
               , @v_plan_id AS FP_PLAN_ID
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
               , A.CUSTOMER_ID
               , A.PLAN_DATE
               , A.TOP_ITEM_ID
               , A.ITEM_TYPE
               , A.BOH_QTY
               , A.SHIPPING_QTY
               , A.IN_QTY
               , A.OUT_QTY
               , A.SALES_QTY
               , A.NET_QTY
               , A.CARRYOVER_QTY
               , A.EOH_QTY 
               , A.AVAILABILITY
               , A.AGING_WIP
               , A.FORMATION_TOTAL
               , A.SHIP_EOH 
               , A.YIELD
               , A.DATE_SEQ
               , A.ACTUAL_FLAG
               , A.ORG_BOH_QTY
               , A.ORG_SHIPPING_QTY
               , A.ORG_IN_QTY
               , A.ORG_OUT_QTY
               , A.ORG_SALES_QTY
               , A.ORG_NET_QTY
               , A.ORG_CARRYOVER_QTY
               , A.ORG_EOH_QTY
          , A.ORG_AVAILABILITY
               , A.ORG_AGING_WIP
               , A.ORG_FORMATION_TOTAL
               , A.INSERT_ID
               , A.INSERT_TIME
               , A.UPDATE_ID
       , A.UPDATE_TIME
               , A.SALES_CELL_QTY
               , A.SALES_PACK_QTY
			   , AGING_LEAD_TIME  -- Add 2020-01-10 by cys
			   , CAL_AGING_QTY	  -- Add 2020-01-10 by cys	
               , A.CELL_GROUP_CODE
               , A.AGING_WIP_BD															
               , A.AGING_WIP_AD															
               , A.AGING_WIP_SIM															
               , A.AGING_WIP_SIM_BD															
               , A.AGING_WIP_SIM_AD															
               , A.PKG_PLAN_DATE															
               , A.ACTIVATED_SIM															
               , A.SALES_REQUEST_QTY															
               , A.ORG_SALES_REQUEST_QTY
               , SETUP_FLAG
               , SETUP_TIME
               , RESULT_QTY
               , SHIPPING_RESULT_QTY
               , WPP_IN_QTY
               , WPP_OUT_QTY
               , MPP_IN_QTY
               , MPP_OUT_QTY
			   , PKG_QTY  -- Add 2020-01-10 by cys
			   , PAST_SALES_QTY	  -- Add 2020-01-10 by cys	
               , EOL_ACTIVATED_STOCK
               , SALES_SIMUL_QTY	-- (D20201229~R0105.01)
          FROM   FP_AMEND_PLAN_FORM_R A
          WHERE 1=1  
          AND A.INSTANCE_ID = @v_master_id
          AND    EXISTS (   
							SELECT  1  
							FROM    ( 
										SELECT 	A.INSTANCE_ID, A.PLAN_ID 
												, B.FACTORY_ID, B.LINE_ID, B.OPERATION_ID, B.ELECTRODE_TYPE 
										FROM   	SCM_FP_PLAN_GROUP_DETAIL_H A, 
												SCM_LINE_M                 B 
										WHERE  	A.PLAN_DATE    	= @v_plan_date 
										AND    	A.INSTANCE_ID  	= @v_master_id 
										AND    	A.PLAN_GROUP_ID	= @v_plan_group_id 
										AND    	A.PLAN_GROUP_ID	= B.MODEL_TYPE 
									) X 
							WHERE   X.INSTANCE_ID	= A.INSTANCE_ID  
							AND     X.PLAN_ID       = A.FP_PLAN_ID  
							AND     X.FACTORY_ID    = A.FACTORY_ID 
							AND     X.LINE_ID       = A.LINE_ID 
							AND     X.OPERATION_ID  = A.OPERATION_ID 
						)
         

          SET @n_row_count = @@ROWCOUNT
                
          --LOG 생성
          SET @v_message = CONVERT(NVARCHAR, @n_row_count)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
          
          /*
          MPP WPP 갱신
          */
          
          SET @v_table_name = 'FP_AMEND_PLAN_FORM_R - MPP/WPP Modify'
           
          UPDATE  FP_AMEND_PLAN_FORM_R
          SET     WPP_IN_QTY = 0 ,
                  WPP_OUT_QTY = 0 ,
                  MPP_IN_QTY = 0 ,
                  MPP_OUT_QTY = 0
          WHERE   INSTANCE_ID = @v_master_id
          AND     FP_PLAN_ID  = @v_plan_id
          --AND     PLAN_DATE   >= 
          
          UPDATE  FP_AMEND_PLAN_FORM_R
          SET     WPP_OUT_QTY = A.PLAN_QTY , 
                  WPP_IN_QTY = A.PLAN_IN_QTY
          FROM    FP_DAILY_PRODUCTIOIN_PLAN_H A
          WHERE   FP_AMEND_PLAN_FORM_R.INSTANCE_ID = @v_master_id
          AND     FP_AMEND_PLAN_FORM_R.FP_PLAN_ID  = @v_plan_id
          AND     A.PLAN_TYPE     =  'WPP'
          AND     FP_AMEND_PLAN_FORM_R.COMPANY_ID   = A.COMPANY_ID
          AND     FP_AMEND_PLAN_FORM_R.DIVISION_ID  = A.DIVISION_ID
          AND     FP_AMEND_PLAN_FORM_R.SITE_ID      = A.SITE_ID
          AND     FP_AMEND_PLAN_FORM_R.PLANT_ID     = A.PLANT_ID
          AND     FP_AMEND_PLAN_FORM_R.FACTORY_ID   = A.FACTORY_ID
          AND     FP_AMEND_PLAN_FORM_R.OPERATION_ID = A.OPERATION_ID     
          AND     FP_AMEND_PLAN_FORM_R.PLAN_DATE    = A.PLAN_DATE
          AND     FP_AMEND_PLAN_FORM_R.LINE_ID      = A.LINE_ID
          AND     FP_AMEND_PLAN_FORM_R.ITEM_ID      = A.ITEM_ID
          
          UPDATE  FP_AMEND_PLAN_FORM_R
          SET     MPP_OUT_QTY = A.PLAN_QTY , 
                  MPP_IN_QTY = A.PLAN_IN_QTY
          FROM    FP_DAILY_PRODUCTIOIN_PLAN_H A
          WHERE   FP_AMEND_PLAN_FORM_R.INSTANCE_ID = @v_master_id
          AND     FP_AMEND_PLAN_FORM_R.FP_PLAN_ID  = @v_plan_id
          AND     A.PLAN_TYPE     =  'MPP'
          AND     FP_AMEND_PLAN_FORM_R.COMPANY_ID   = A.COMPANY_ID
          AND     FP_AMEND_PLAN_FORM_R.DIVISION_ID  = A.DIVISION_ID
          AND     FP_AMEND_PLAN_FORM_R.SITE_ID      = A.SITE_ID
          AND     FP_AMEND_PLAN_FORM_R.PLANT_ID     = A.PLANT_ID
          AND     FP_AMEND_PLAN_FORM_R.FACTORY_ID   = A.FACTORY_ID
          AND     FP_AMEND_PLAN_FORM_R.OPERATION_ID = A.OPERATION_ID     
          AND     FP_AMEND_PLAN_FORM_R.PLAN_DATE    = A.PLAN_DATE
          AND     FP_AMEND_PLAN_FORM_R.LINE_ID      = A.LINE_ID
          AND     FP_AMEND_PLAN_FORM_R.ITEM_ID      = A.ITEM_ID
          
--LOG 생성
          SET @v_message = CONVERT(NVARCHAR, @n_row_count)
          SET @n_log_count = @n_log_count + 1
 SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null


          SET @v_table_name = 'FP_FORMATION_PSI_UI'
          
   DELETE FROM FP_FORMATION_PSI_UI
          WHERE  INSTANCE_ID  = @v_master_id
          AND    FP_PLAN_ID   = @v_plan_id

          INSERT INTO FP_FORMATION_PSI_UI
               (
                 INSTANCE_ID
               , FP_PLAN_ID
               , COMPANY_ID
               , DIVISION_ID
               , SITE_ID
               , PLANT_ID
               , ITEM_ID
               , FACTORY_ID
               , EQUIPMENT_ID
               , CATEGORY_ID
               , PLAN_DATE
               , QTY
               , INSERT_ID
               , INSERT_TIME
               )
          SELECT INSTANCE_ID
               , @v_plan_id     AS FP_PLAN_ID
               , COMPANY_ID
               , DIVISION_ID
               , SITE_ID
               , PLANT_ID
               , ITEM_ID
               , FACTORY_ID
               , EQUIPMENT_ID
               , CATEGORY_ID
               , PLAN_DATE
               , QTY
    		   , INSERT_ID
               , INSERT_TIME        
          FROM   FP_FORMATION_PSI_UI A
          WHERE  A.INSTANCE_ID = @v_master_id
          AND    EXISTS (   
							SELECT  1  
							FROM    ( 
										SELECT 	A.INSTANCE_ID, A.PLAN_ID 
												, B.FACTORY_ID, B.LINE_ID, B.OPERATION_ID, B.ELECTRODE_TYPE 
										FROM   	SCM_FP_PLAN_GROUP_DETAIL_H A, 
												SCM_LINE_M                 B 
										WHERE  	A.PLAN_DATE    	= @v_plan_date 
										AND    	A.INSTANCE_ID  	= @v_master_id 
										AND    	A.PLAN_GROUP_ID	= @v_plan_group_id 
										AND    	A.PLAN_GROUP_ID	= B.MODEL_TYPE 
									) X 
							WHERE   X.INSTANCE_ID	= A.INSTANCE_ID  
							AND     X.PLAN_ID       = A.FP_PLAN_ID  
							AND     X.FACTORY_ID    = A.FACTORY_ID 
							--AND     X.LINE_ID       = A.LINE_ID 
							AND     X.LINE_ID       = A.EQUIPMENT_ID
							--AND     X.OPERATION_ID  = A.OPERATION_ID 
						)
          
          SET @n_row_count = @@ROWCOUNT
                
          --LOG 생성
          SET @v_message = CONVERT(NVARCHAR, @n_row_count)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
          
          SET @v_table_name = 'FP_AMEND_PLAN_FORM_H'
          
          DELETE FP_AMEND_PLAN_FORM_H
          WHERE  INSTANCE_ID = @v_master_id
          AND    FP_PLAN_ID  = @v_plan_id
          
          --LOG 생성
          SET @v_message = CONVERT(NVARCHAR, @n_row_count)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null
          
          INSERT INTO FP_AMEND_PLAN_FORM_H
              (
               INSTANCE_ID, 
               FP_PLAN_ID, 
               COMPANY_ID, 
               DIVISION_ID, 
               CATEGORY_ID, 
               SITE_ID, 
               PLANT_ID, 
               ITEM_ID, 
               OPERATION_ID, 
               FACTORY_ID,
               LOCATION,
               PRODUCTION_TYPE, 
               CUSTOMER_ID , 
               MARKET, 
               LINE_ID, 
               ELECTRODE_TYPE, 
               PLAN_DATE,
               TOP_ITEM_ID, 
               ITEM_TYPE, 
               BOH_QTY, 
               SHIPPING_QTY , 
               IN_QTY, 
               OUT_QTY, 
               SALES_QTY, 
               NET_QTY, 
               CARRYOVER_QTY , 
               EOH_QTY, 
               AVAILABILITY,
               AGING_WIP,
               FORMATION_TOTAL,
               YIELD, 
               DATE_SEQ, 
               ACTUAL_FLAG, 
               ORG_BOH_QTY, 
               ORG_SHIPPING_QTY , 
               ORG_IN_QTY, 
               ORG_OUT_QTY, 
               ORG_SALES_QTY, 
               ORG_NET_QTY, 
               ORG_CARRYOVER_QTY , 
               ORG_EOH_QTY, 
               ORG_AVAILABILITY,
               ORG_AGING_WIP,
               ORG_FORMATION_TOTAL,
               INSERT_ID, 
               INSERT_TIME, 
               UPDATE_ID, 
               UPDATE_TIME ,
               SALES_CELL_QTY,
               SALES_PACK_QTY,
			   AGING_LEAD_TIME,
			   CAL_AGING_QTY,	  -- Add 2020-01-10 by cys
               CELL_GROUP_CODE, 
               AGING_WIP_BD,
               AGING_WIP_AD , 
               AGING_WIP_SIM ,															
               AGING_WIP_SIM_BD ,															
               AGING_WIP_SIM_AD	, 														
               PKG_PLAN_DATE ,															
               ACTIVATED_SIM ,															
               SALES_REQUEST_QTY ,															
               ORG_SALES_REQUEST_QTY ,	
               SETUP_FLAG ,
               SETUP_TIME ,
               RESULT_QTY ,
               SHIPPING_RESULT_QTY ,
               WPP_IN_QTY,
               WPP_OUT_QTY ,
               MPP_IN_QTY ,
     MPP_OUT_QTY , 
               PKG_QTY , 
               PAST_SALES_QTY ,
               EOL_ACTIVATED_STOCK, 
               SALES_SIMUL_QTY	-- (D20201229~R0105.01)
              )
          SELECT	INSTANCE_ID, 
                  FP_PLAN_ID, 
                  COMPANY_ID, 
                  DIVISION_ID, 
                  CATEGORY_ID, 
                  SITE_ID, 
                  PLANT_ID, 
                  ITEM_ID, 
                  OPERATION_ID, 
                  FACTORY_ID, 
                  LOCATION,
                  PRODUCTION_TYPE,
                  CUSTOMER_ID , 
                  MARKET, 
                  LINE_ID, 
                  ELECTRODE_TYPE, 
                  PLAN_DATE,
                  TOP_ITEM_ID, 
                  ITEM_TYPE, 
                  BOH_QTY, 
                  SHIPPING_QTY , 
                  IN_QTY, 
                  OUT_QTY, 
                  SALES_QTY, 
                  NET_QTY,
                  CARRYOVER_QTY,
                  EOH_QTY, 
                  AVAILABILITY,
                  AGING_WIP,
                  FORMATION_TOTAL,
                  YIELD, 
                  DATE_SEQ, 
                  ACTUAL_FLAG, 
                  ORG_BOH_QTY, 
                  ORG_SHIPPING_QTY , 
                  ORG_IN_QTY, 
                  ORG_OUT_QTY, 
                  ORG_SALES_QTY, 
                  ORG_NET_QTY, 
                  ORG_CARRYOVER_QTY , 
                  ORG_EOH_QTY, 
                  ORG_AVAILABILITY,
   ORG_AGING_WIP,
                  ORG_FORMATION_TOTAL,
                  INSERT_ID, 
                  INSERT_TIME, 
                  UPDATE_ID, 
                  UPDATE_TIME  ,
                  SALES_CELL_QTY,
                  SALES_PACK_QTY,
				  AGING_LEAD_TIME,
				  CAL_AGING_QTY,	  -- Add 2020-01-10 by cys	
                  CELL_GROUP_CODE,
                  AGING_WIP_BD,
                  AGING_WIP_AD ,
                  AGING_WIP_SIM ,															
                  AGING_WIP_SIM_BD ,															
                  AGING_WIP_SIM_AD ,	 														
                  PKG_PLAN_DATE ,															
                  ACTIVATED_SIM ,															
                  SALES_REQUEST_QTY ,															
                  ORG_SALES_REQUEST_QTY ,	
                  SETUP_FLAG ,
                  SETUP_TIME ,
                  RESULT_QTY ,
  		            SHIPPING_RESULT_QTY ,
                  WPP_IN_QTY,
                  WPP_OUT_QTY ,
                  MPP_IN_QTY ,
        MPP_OUT_QTY , 
                  PKG_QTY , 
                  PAST_SALES_QTY , 
                  EOL_ACTIVATED_STOCK ,
                  SALES_SIMUL_QTY	-- (D20201229~R0105.01)
          FROM    FP_AMEND_PLAN_FORM_R
          WHERE   INSTANCE_ID = @v_master_id
          AND     FP_PLAN_ID  = @v_plan_id 
          
          --LOG 생성
        SET @v_message = CONVERT(NVARCHAR, @n_row_count)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
          
          -- AMEND UTIL 테이블 정보 생성
          BEGIN
          
            SELECT @v_sqltable = 'FP_AMEND_PLAN_FORM_UTIL_R'
                 , @v_reltable = 'FP_AMEND_PLAN_FORM_UTIL_H'

            -- 기존 데이터  삭제
            SET @v_sqltext  = 'delete from ' + @v_reltable + ' '          -- RELEASE 용 테이블
                            + 'where  1=1 '
                            + 'and    instance_id = '''+@v_master_id+''' '
                            + 'and    fp_plan_id  = '''+@v_plan_id+''' '

            EXEC sp_executesql @v_sqltext, N'@v_return AS INTEGER OUTPUT', @v_return=@n_row_count OUTPUT

            -- 신규 데이터 생성
            SET @v_sqltext  = 'insert into ' + @v_reltable + ' '          -- RELEASE 용 테이블
                            + '     ( '
                            + '       INSTANCE_ID '
                            + '     , FP_PLAN_ID '
                            + '     , COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID '
                            + '     , FACTORY_ID, LOCATION, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID '
                            + '     , PLAN_DATE, RUN_TIME, OFF_TIME, SETUP_TIME, UTILIZATION '
                            + '     , INSERT_ID '
                            + '     , INSERT_TIME '
                            + '     ) '
                            + 'SELECT '
                            + '       INSTANCE_ID '
                            + '     , '''+@v_plan_id+'''     AS FP_PLAN_ID '
                            + '     , COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID '
                            + '     , FACTORY_ID, LOCATION, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID '
                            + '     , PLAN_DATE, RUN_TIME, OFF_TIME, SETUP_TIME, UTILIZATION '
                            + '     , INSERT_ID '
                            + '     , INSERT_TIME '
                            + 'FROM   ' + @v_sqltable + ' A '
                            + 'WHERE  A.INSTANCE_ID = '''+@v_master_id+''' '
                            + 'AND    EXISTS (   '
						    + '                SELECT  1  '
						  	+ '                FROM    ( '
						  	+ '                          SELECT A.INSTANCE_ID, A.PLAN_ID '
						  	+ '                               , B.FACTORY_ID, B.LINE_ID, B.OPERATION_ID, B.ELECTRODE_TYPE '
						  	+ '                          FROM   SCM_FP_PLAN_GROUP_DETAIL_H A, '
						  	+ '                                 SCM_LINE_M                 B '
						  	+ ' WHERE  A.PLAN_DATE      = '''+@v_plan_date+''' '
						  	+ '     					 AND    A.INSTANCE_ID    = '''+@v_master_id+''' '
						  	+ '                          AND    A.PLAN_GROUP_ID  = '''+@v_plan_group_id+''' '
						  	+ '                     	 AND    A.PLAN_GROUP_ID  = B.MODEL_TYPE '
						  	+ '                        ) X '
						  	+ '                WHERE   X.INSTANCE_ID   = A.INSTANCE_ID  '
						  	+ '                AND     X.PLAN_ID       = A.FP_PLAN_ID  '
						  	+ '                AND     X.FACTORY_ID    = A.FACTORY_ID '
						  	+ '                AND     X.LINE_ID       = A.LINE_ID '
						  	+ '                AND     X.OPERATION_ID  = A.OPERATION_ID '
						  	+ '              ) '
                            + 'AND    EXISTS (  '
                            + '               SELECT 1 '
                + '               FROM   SCM_OPERATION_M Y '
                            + '               WHERE  Y.COMPANY_ID    = A.COMPANY_ID '
                            + '               AND    Y.DIVISION_ID   = A.DIVISION_ID '
                            + '               AND    Y.SITE_ID       = A.SITE_ID '
                            + '              AND    Y.OPERATION_ID  = A.OPERATION_ID '
                            + '               AND    Y.WO_FLAG       = '''+'Y'+''' '
                            + '               UNION  ALL '
                            + '               SELECT 1 '
                            + '               FROM   (SELECT '''+'F6000'+''' AS OPERATION_ID) Z '
                            + '               WHERE  Z.OPERATION_ID = A.OPERATION_ID '
                            + '              ) '

            EXEC sp_executesql @v_sqltext, N'@v_return AS INTEGER OUTPUT', @v_return=@n_row_count OUTPUT


            -- 신규 데이터 생성 수량 COUNT
            SET @v_sqltext  = 'SELECT @v_return = COUNT(1) '
                            + 'FROM   ' + @v_reltable + ' a '
                            + 'where  1=1 '
                            + 'and    a.instance_id           = '''+@v_master_id+''' '
                            + 'and    a.fp_plan_id            = '''+@v_plan_id+''' '

            EXEC sp_executesql @v_sqltext, N'@v_return AS INTEGER OUTPUT', @v_return=@n_row_count OUTPUT

            --LOG 생성
            SET @v_message   = 'DYNAMIC SQL : ' + CONVERT(NVARCHAR, @n_row_count)
            SET @n_log_count = @n_log_count + 1
            SET @sysdate     = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_reltable, 'INSERT', @n_log_count, null, @v_message, null
            
			

          END

        END
        -------------------------------------------------------------------------------------------------------
        -- FORMATION 전용 : END
        -------------------------------------------------------------------------------------------------------
        
      BEGIN
      
        SELECT @n_include_line_cnt = COUNT(1)
        FROM   SCM_SYS_LOOKUP_VALUE WITH(NOLOCK)
        WHERE  LOOKUP_TYPE_CODE = 'INSTANCE_SPLIT_LINE_DEFINITION'
        AND    SEGMENT1         = @v_master_id        -- 계획 수립할 라인이 있는 INSTANCE_ID
        AND    ACTIVE_FLAG      = 'Y'

        SELECT @n_exclude_line_cnt = COUNT(1)
        FROM   SCM_SYS_LOOKUP_VALUE WITH(NOLOCK)
        WHERE  LOOKUP_TYPE_CODE = 'INSTANCE_SPLIT_LINE_DEFINITION'
        AND    SEGMENT2         = @v_master_id        -- 계획 제외할 라인이 있는 INSTANCE_ID
        AND    ACTIVE_FLAG      = 'Y'
        
        -------------------------------------------------------------------------------------------------

        SET @v_table_name = 'FP_RELEASE_PLAN_LINE_INFO_H'

        DELETE FROM FP_RELEASE_PLAN_LINE_INFO_H
   WHERE  INSTANCE_ID      = @v_master_id
        AND    RELEASE_PLAN_ID  = @v_plan_id

        INSERT INTO FP_RELEASE_PLAN_LINE_INFO_H
             (
               INSTANCE_ID, INSTANCE_DATE, RELEASE_PLAN_ID, AMEND_PLAN_ID
             , FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE
             , PLAN_GROUP_ID
             , INSERT_ID, INSERT_TIME
             )
        SELECT DISTINCT
               A.INSTANCE_ID, A.INSTANCE_DATE, A.RELEASE_PLAN_ID, A.AMEND_PLAN_ID
             , A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.PLAN_GROUP_ID
             , @v_proc_name AS INSERT_ID
             , GETDATE()    AS INSERT_TIME
        FROM   (
                SELECT DISTINCT
                       A.INSTANCE_ID, A.INSTANCE_DATE, A.RELEASE_PLAN_ID, A.AMEND_PLAN_ID
                     , B.FACTORY_ID, B.OPERATION_ID, B.LINE_ID, B.ELECTRODE_TYPE, B.MODEL_TYPE AS PLAN_GROUP_ID
                FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)
                     , SCM_LINE_M             B WITH(NOLOCK)
   , (
                        SELECT DISTINCT
                               B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, B.FACTORY_ID, C.OPERATION_ID
                        FROM   FP_INSTANCE_FACTORY_M  A WITH (NOLOCK)
                             , SCM_FACTORY_M          B WITH (NOLOCK)
                             , SCM_OPERATION_M      C WITH (NOLOCK)
                        WHERE  A.INSTANCE_ID    = @v_master_id
                        AND    A.FACTORY_ID     = B.FACTORY_ID
                        AND    B.COMPANY_ID     = C.COMPANY_ID
                        AND    B.DIVISION_ID    = C.DIVISION_ID
                        AND    B.SITE_ID        = C.SITE_ID
                        AND    A.INSTANCE_TYPE  = C.INSTANCE_TYPE
                        AND    A.ACTIVE_FLAG    = 'Y'
                        AND    B.ACTIVE_FLAG    = 'Y'
                        AND    C.ACTIVE_FLAG    = 'Y'
                       ) C
                WHERE  A.INSTANCE_ID      = @v_master_id
                AND    A.RELEASE_PLAN_ID  = @v_plan_id
                AND    A.DIVISION_ID      = B.DIVISION_ID
                AND    A.FACTORY_ID       = B.FACTORY_ID
                AND    A.PLAN_GROUP_ID    = '-'
                AND    B.ACTIVE_FLAG      = 'Y'
                AND    B.FACTORY_ID       = C.FACTORY_ID
                AND    B.OPERATION_ID     = C.OPERATION_ID
                UNION  ALL
              SELECT A.INSTANCE_ID, A.INSTANCE_DATE, A.RELEASE_PLAN_ID, A.AMEND_PLAN_ID
                     , B.FACTORY_ID, B.OPERATION_ID, B.LINE_ID, B.ELECTRODE_TYPE, B.MODEL_TYPE
                FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)
                     , SCM_LINE_M B WITH(NOLOCK)
                     , (
                        SELECT DISTINCT
                               B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, B.FACTORY_ID, C.OPERATION_ID
                        FROM   FP_INSTANCE_FACTORY_M  A WITH (NOLOCK)
                             , SCM_FACTORY_M          B WITH (NOLOCK)
                             , SCM_OPERATION_M        C WITH (NOLOCK)
                        WHERE  A.INSTANCE_ID    = @v_master_id
                        AND    A.FACTORY_ID     = B.FACTORY_ID
                        AND    B.COMPANY_ID     = C.COMPANY_ID
                        AND    B.DIVISION_ID    = C.DIVISION_ID
                        AND    B.SITE_ID        = C.SITE_ID
                        AND    A.INSTANCE_TYPE  = C.INSTANCE_TYPE
                        AND    A.ACTIVE_FLAG    = 'Y'
                        AND    B.ACTIVE_FLAG    = 'Y'
                        AND    C.ACTIVE_FLAG    = 'Y'
                       ) C
                WHERE  A.INSTANCE_ID      = @v_master_id
                AND    A.RELEASE_PLAN_ID  = @v_plan_id
                AND    A.FACTORY_ID       = '-'
                AND    A.PLAN_GROUP_ID    = B.MODEL_TYPE
                AND    B.ACTIVE_FLAG      = 'Y'
                AND    B.FACTORY_ID       = C.FACTORY_ID
                AND    B.OPERATION_ID     = C.OPERATION_ID
               ) A
               LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE E WITH (NOLOCK)
                    ON    E.LOOKUP_TYPE_CODE = 'INSTANCE_SPLIT_LINE_DEFINITION'
                    AND   E.SEGMENT1         = @v_master_id        -- 계획 수립할 라인이 있는 INSTANCE_ID
                    AND   E.ACTIVE_FLAG      = 'Y'
                    AND   E.SEGMENT3         = A.LINE_ID
               LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE F WITH (NOLOCK)
                    ON    F.LOOKUP_TYPE_CODE = 'INSTANCE_SPLIT_LINE_DEFINITION'
                    AND   F.SEGMENT2         = @v_master_id        -- 계획 제외할 라인이 있는 INSTANCE_ID
                    AND   F.ACTIVE_FLAG      = 'Y'
                    AND   F.SEGMENT3         = A.LINE_ID
        WHERE  1=1
        AND    (
                  (@n_include_line_cnt > 0   AND E.SEGMENT1 IS NOT NULL)
                  OR
                  (@n_exclude_line_cnt > 0   AND F.SEGMENT1 IS NULL)
                  OR
(@n_include_line_cnt = 0   AND @n_exclude_line_cnt = 0)
               )
               
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
        WHERE  INSTANCE_ID    = @v_master_id
        AND    PLAN_DATE        = @v_plan_date
        AND    PLAN_GROUP_ID    = @v_plan_group_id
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

      END

	  /* 후처리로 변경 20200113 by cys
	  --------==== 셀가시성 UI 데이터 생성용 (20190920) ====--------
	  IF  @v_master_id IN ( 'PL_PACK' , 'US_PACK' , 'KR_PACK', 'CN_PACK') 
		BEGIN 	  
			EXEC PR_SCM_OF_PACK_TO_CELL  @v_master_id , @v_plan_id 

			--LOG생성 
			SET @n_log_count = @n_log_count + 1
			SET @v_message   = @v_master_id + ' PR_SCM_OF_PACK_TO_CELL End'
			SET @sysdate = GETDATE()
			EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'CALL', @n_log_count, NULL, @v_message, null
	    END 
      -------------------------------------------------------------
	*/

      -- RELEASE 버전이 저장되기 수량 검증 POPUP 이 뜬다...
      WAITFOR DELAY '0:0:1'
      
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
