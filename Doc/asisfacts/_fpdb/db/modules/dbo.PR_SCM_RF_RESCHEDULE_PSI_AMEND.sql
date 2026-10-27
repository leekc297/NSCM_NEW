CREATE     PROCEDURE [dbo].[PR_SCM_RF_RESCHEDULE_PSI_AMEND]
@p_master_id nvarchar(MAX) = '-', @p_plan_id nvarchar(MAX) = '-', @p_factory_id nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_RF_RESCHEDULE_PSI_AMEND                                            **/
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
/** 2016.01.01    COCHO          최초 작성                                                    **/
/** 2017.06.08    HAJH           KR-CELL  A6000 공정 특화로직 반영 전 원본 소스               **/
/** 2022.08.24    CYS            CELL/PACK 설비정보 없는 경우도 릴리즈 가능하도록 수정 '-' 로 보내줌 -- (D.20220824~R.0824.01)             **/
/** 2024.05.09    CYS          PDS-4MCC 버전 대응 **/ -- (D20240509~R0509.01) 
/** 2025.03.19    CYS          PDS-4MCC 고도화(PDS Target, Equipment, 작업지시서)  **/ -- (D20250319~R0319.01)
/** 2025-10-19 	  CYS    	   [E20251019-001993] FP 시스템의 W/O 과실적 방지를 위한 기능변경 건 - 과실적 Flag, next W/O 추가 	**/ 
/** 2026-03-30 	  CYS    	   [E20260313-002101] 과실적 W/O 처리 반영 시 과실적 처리 된(Rolling) W/O 만 사용 	**/
/***********************************************************************************************/
/*
  EXEC PR_SCM_RF_RESCHEDULE_PSI_AMEND
  

*/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- 필수 칼럼
  DECLARE @v_master_id      nvarchar(30)
  DECLARE @v_plan_id        nvarchar(30)


  -- LOG 용 변수 설정
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_RF_RESCHEDULE_PSI_AMEND'
  DECLARE @v_table_name     nvarchar(100)
  DECLARE @v_message        nvarchar(250)
  DECLARE @v_descr          nvarchar(250)
  DECLARE @n_row_count      Integer  = 0
  DECLARE @n_log_count      Integer  = 0
  DECLARE @v_log_code        nvarchar(10)
  
  DECLARE @sysdate          DATETIME2 = GETDATE()

  DECLARE @v_temp1        nvarchar(1000)
  DECLARE @v_temp2        nvarchar(1000)
  
  -- 사용자 변수 설정
  DECLARE @key_date             nvarchar(8)
        , @n_count              integer = 0
        , @v_plan_date          datetime
        , @v_daydiff            Integer
        , @v_factory_id         nvarchar(30)
        , @v_plan_group_id      nvarchar(30)
        , @v_instance_code      nvarchar(10)
        , @v_order_date_code    nvarchar(10)
        , @v_plan_group_seq     nvarchar(30)
        , @v_create_vd_mo       nvarchar(5)   = 'N'
        , @v_sqltext            nvarchar(MAX)
        , @v_sqltable           nvarchar(30)        
        , @v_release_term       Int
        , @v_confirm_date       date
		, @v_release_term_limit_flag nvarchar(5)   = 'N'
		, @v_release_term_limit_date date
		
		, @v_next_wo_flag 		nvarchar(5)   = 'N'	-- [E20251019-001993] ADD
  -------------------------------------------------------------------------------------------
  -- LINE 인지 EQUIPMENT 인지 설정하는 변수... 아주 중요
  -------------------------------------------------------------------------------------------
   DECLARE @res_category      nvarchar(10)
  -------------------------------------------------------------------------------------------

  SET @v_master_id      = @p_master_id
  SET @v_plan_id        = @p_plan_id
  SET @v_factory_id     = @p_factory_id

  SET @n_log_count = @n_log_count + 1
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', null

  BEGIN TRY
    -- RESCHEDULE 커서 메모리 해제
    BEGIN
    
      IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'C_PSI_AMEND_FACTORY_FIX')
      BEGIN
          CLOSE C_PSI_AMEND_FACTORY_FIX
          DEALLOCATE C_PSI_AMEND_FACTORY_FIX
      END
      
    END
    
    -- 필수 DATA 쿼리.. 반듯이 있어야 함.
    BEGIN

      SET @v_table_name = 'SCM_FP_PLAN_H'

      SELECT @key_date    = CONVERT(NVARCHAR, PLAN_START_TIME, 112)
           , @v_plan_date = CONVERT(DATETIME, CONVERT(DATE, PLAN_START_TIME))
           , @v_daydiff   = DATEDIFF(MINUTE,CONVERT(DATE,PLAN_START_TIME), PLAN_START_TIME)
      FROM   SCM_FP_PLAN_H WITH(NOLOCK)
      WHERE  INSTANCE_ID = @v_master_id
      AND    PLAN_ID = @v_plan_id
      
      --LOG 생성
      SET @v_message = 'FACTORY_ID : ' + ISNULL(@v_factory_id, '')
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null


      SET @v_table_name = 'FP_INSTANCE_CONFIG_M'

      SELECT @v_instance_code = ISNULL(MAX(A.KEY_VALUE), '-')
      FROM   FP_INSTANCE_CONFIG_M  AS A WITH(NOLOCK)
      WHERE  A.INSTANCE_ID = @V_MASTER_ID
      AND    A.CATEGORY_ID = 'EXPORT' 
      AND    A.KEY_ID = 'INSTANCE_CODE'

      --LOG 생성
      SET @v_message = '@v_instance_code : ' + ISNULL(@v_instance_code, '')
      SET @n_log_count = @n_log_count + 1
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

      SET @v_table_name = 'SCM_SYS_LOOKUP_VALUE'

      SELECT @v_create_vd_mo = ISNULL(MAX(B.ATTRIBUTE4), 'N')
      FROM   SCM_SYS_LOOKUP_TYPE_M A WITH(NOLOCK)
           , SCM_SYS_LOOKUP_VALUE  B WITH(NOLOCK)
      WHERE  A.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
      AND    A.ATTRIBUTE4       = 'CREATE_VD_MO'
      AND    A.LOOKUP_TYPE_CODE = B.LOOKUP_TYPE_CODE
      AND    B.SEGMENT1         = @v_master_id

      --LOG 생성
      SET @v_message = '@v_create_vd_mo : ' +  ISNULL(@v_create_vd_mo, '')
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

      SET @v_table_name = 'SCM_SYS_LOOKUP_VALUE'
      
      -- DEFAULT 값
      SET @v_release_term = 7
      --@@@ release 일자 제약하기 위해서
      
      SELECT @v_release_term = ISNULL(MAX(CONVERT(INT, SEGMENT3)), 7)
      		,@v_release_term_limit_flag = ISNULL(MAX(ATTRIBUTE7), 'N')	
      		,@v_release_term_limit_date = CONVERT(DATE,ISNULL(MAX(ATTRIBUTE8), '29990101'))
      FROM   SCM_SYS_LOOKUP_VALUE WITH(NOLOCK)
      WHERE  LOOKUP_TYPE_CODE = 'INSTANCE_FACTORY_RELEASE_TERM'
      AND    SEGMENT1 = @v_master_id        -- INSTANCE_ID
      AND    SEGMENT2 = @v_factory_id       -- FACTORY_ID
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
      FROM   SCM_FP_PLAN_H A WITH(NOLOCK)
      WHERE  A.INSTANCE_ID  = @v_master_id
      AND    A.PLAN_ID      = @v_plan_id
      
      --LOG 생성
      SET @v_message = '@v_confirm_date : ' + convert(nvarchar, @v_confirm_date, 23)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

    END;
      
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
    
     -- [E20251019-001993] Instance NEXT WO 처리 Flag  ADD
	BEGIN
		SET @v_table_name = 'SCM_SYS_LOOKUP_VALUE'
		
		SELECT @v_next_wo_flag = ISNULL(MAX(ATTRIBUTE2),'N')
      	FROM   SCM_SYS_LOOKUP_VALUE WITH(NOLOCK)
      	WHERE  LOOKUP_TYPE_CODE = 'INSTANCE_OPTION'
      	AND    ACTIVE_FLAG	= 'Y'
      	AND    ATTRIBUTE2	= 'Y'	-- WO_BALANCE
      	AND    SEGMENT1 = @v_master_id        -- INSTANCE_ID
  
  		--LOG 생성
  		SET @v_message = '@v_next_wo_flag : ' + @v_next_wo_flag
  		SET @n_log_count = @n_log_count + 1
  		SET @sysdate = GETDATE()
  		EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

	END
     
    -------------------------------------------------------------------------------
    -- 2019.03.07 : OPEN W/O 처리 부분 ( TARGET_LINE 에서 이 곳으로 이관 )
    -------------------------------------------------------------------------------
    IF CHARINDEX('FORM', @v_master_id) = 0   -- 활성화 제외
    BEGIN
    
      SET @v_table_name = 'TH_BUF_SCM_ACTUAL_WORK_ORDER'

      ------------------------------------------------------------------------------------
      -- 실시간 W/O 상태를 BUFFER 에 저장한다. - 시간단축을 위해
      ------------------------------------------------------------------------------------
      DELETE FROM TH_BUF_SCM_ACTUAL_WORK_ORDER
      WHERE  INSTANCE_ID      = @v_master_id
      AND    FP_PLAN_ID       = @v_plan_id
      AND    FACTORY_ID       = @v_factory_id
      
      DELETE FROM TH_BUF_SCM_ACTUAL_WORK_ORDER WHERE INSERT_TIME < GETDATE() - 7
      
      INSERT INTO TH_BUF_SCM_ACTUAL_WORK_ORDER 
           (
             INSTANCE_ID
           , FP_PLAN_ID
           , FACTORY_ID
           , PLAN_GROUP_ID
           , WORK_ORDER_ID
           , ATTRIBUTE8
           , ATTRIBUTE9
           , INSERT_TIME
           , ATTRIBUTE12			 -- [E20251019-001993]  과실적 대상 Flag ADD
           , ATTRIBUTE13			 -- [E20251019-001993]  과실적 대상 WO ADD
           )
      -- [E20260313-002101] 과실적 처리 된 (Rolling) W/O 만 close 대상으로 본다. START
/*
      SELECT @v_master_id               AS INSTANCE_ID
           , @v_plan_id                 AS FP_PLAN_ID
           , @v_factory_id              AS FACTORY_ID
           , '-'                        AS PLAN_GROUP_ID
           , A.WORK_ORDER_ID
           , A.ATTRIBUTE8
           , ISNULL(A.ATTRIBUTE9, 'N')  AS ATTRIBUTE9
           , GETDATE()       AS INSERT_TIME
           , ATTRIBUTE12				AS NEXT_WO_FLAG		-- [E20251019-001993]  과실적 대상 Flag ADD
           , ATTRIBUTE13				AS NEXT_WO			-- [E20251019-001993]  과실적 대상 WO ADD
      FROM   FP_MES_PRODUCTION_PLAN_M A WITH(NOLOCK)
      WHERE  1=1
      AND    (
                A.ATTRIBUTE8 IS NOT NULL              -- 투입 시간
                OR
                ISNULL(A.ATTRIBUTE9, 'N') = 'Y'       -- CLOSE FLAG
                OR
                ISNULL(A.ATTRIBUTE12, 'N') = 'Y'       -- [E20251019-001993]  과실적  next wo flag (close 해야 할 )
             )
      AND    A.FACTORY_ID = @v_factory_id
 */     

     SELECT @v_master_id               AS INSTANCE_ID
           , @v_plan_id                 AS FP_PLAN_ID
           , @v_factory_id              AS FACTORY_ID
           , '-'                        AS PLAN_GROUP_ID
           , A.WORK_ORDER_ID
           , A.ATTRIBUTE8
           , ISNULL(A.ATTRIBUTE9, 'N')  AS ATTRIBUTE9
           , GETDATE()       AS INSERT_TIME
           , CASE WHEN B.WORK_ORDER_ID IS NOT NULL THEN ATTRIBUTE12 ELSE 'N' END	AS NEXT_WO_FLAG		-- [E20251019-001993]  과실적 대상 Flag ADD
		   , CASE WHEN B.WORK_ORDER_ID IS NOT NULL THEN ATTRIBUTE13 ELSE NULL END	AS NEXT_WO			-- [E20251019-001993]  과실적 대상 WO ADD
      FROM   FP_MES_PRODUCTION_PLAN_M A WITH(NOLOCK)
      		LEFT OUTER JOIN (
								SELECT 	DISTINCT WORK_ORDER_ID
								FROM 	FP_WO_BALANCE_M B WITH(NOLOCK)
								WHERE 	1=1
								AND 	ATTR_01 = 'C'		-- 과실적 처리 된 W/O
							) B
			ON 1=1
			AND A.WORK_ORDER_ID = B.WORK_ORDER_ID
      WHERE  1=1
      AND    (
                A.ATTRIBUTE8 IS NOT NULL              -- 투입 시간
                OR
                ISNULL(A.ATTRIBUTE9, 'N') = 'Y'       -- CLOSE FLAG
                OR
                ISNULL(A.ATTRIBUTE12, 'N') = 'Y'       -- [E20251019-001993]  과실적  next wo flag (close 해야 할 )
             )
      AND    A.FACTORY_ID = @v_factory_id
   
      -- [E20260313-002101] 과실적 처리 된 (Rolling) W/O 만 close 대상으로 본다. END
      
      --LOG 생성
      SET @v_message = 'ATTRIBUTE8 IS NOT NULL : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null


      ------------------------------------------------------------------------------------
      ------------------------------------------------------------------------------------
      ------------------------------------------------------------------------------------
      
      SET @v_table_name = 'FP_DAILY_INSTANCE_ORDER_STATUS'
      
      ------------------------------------------------------------------------------------
      -- 실시간 W/O 상태를 UPDATE 한다.
      ------------------------------------------------------------------------------------
      UPDATE A
      SET    A.WO_STATUS    = ( CASE WHEN B.ATTRIBUTE9 = 'Y' OR  ( @v_next_wo_flag = 'Y' AND B.ATTRIBUTE12 = 'Y')	THEN 'CANCEL'	-- [E20251019-001993]  과실적 대상 Flag 도 close 추가, 0으로 보내더라도 MES_WO 에서 실적 수량 맞춰줌
                                                                            ELSE 'OPEN'
                                END  )
           , A.ACTUAL_FLAG  = ( CASE WHEN B.ATTRIBUTE8 IS NOT NULL          THEN 'Y'
                                     WHEN ISNULL(A.ACTUAL_GOOD_QTY, 0) > 0  THEN 'Y'
                                                                            ELSE 'N'
                                END  )
      FROM   FP_DAILY_INSTANCE_ORDER_STATUS A
        LEFT OUTER JOIN TH_BUF_SCM_ACTUAL_WORK_ORDER B WITH(NOLOCK)
                  ON    B.INSTANCE_ID   = A.INSTANCE_ID
                  AND   B.FP_PLAN_ID    = A.FP_PLAN_ID
                  AND   B.WORK_ORDER_ID = A.WORK_ORDER_ID
      WHERE  A.INSTANCE_ID      = @v_master_id
      AND    A.FP_PLAN_ID       = @v_plan_id
      AND    A.FACTORY_ID       = @v_factory_id
      AND    A.WO_STATUS        IN ( 'OPEN', 'RUN', 'CANCEL' )

      --LOG 생성
      SET @v_message = 'WO_STATUS = OPEN / ACTUAL_FLAG = Y/N : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
      
      ------------------------------------------------------------------------------------
      -- TOP ITEM ID 가 존재하지 않으면 CANCEL 시킨다.
      ------------------------------------------------------------------------------------
      UPDATE A
      SET    A.WO_STATUS = 'CANCEL'
      FROM   FP_DAILY_INSTANCE_ORDER_STATUS A
      WHERE  A.INSTANCE_ID      = @v_master_id
      AND    A.FP_PLAN_ID       = @v_plan_id
      AND    A.FACTORY_ID       = @v_factory_id
      AND    A.WO_STATUS        IN ( 'OPEN', 'RUN' )
      AND    ISNULL(A.TOP_ITEM_ID, '-') = '-'

      --LOG 생성
      SET @v_message = 'WO_STATUS = CANCEL / TOP_ITEM_ID = - : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

      ------------------------------------------------------------------------------------
      -- 잔여 수량이 0 이하 일 경우도 CANCEL 시킨다.
      ------------------------------------------------------------------------------------
      UPDATE A
      SET    A.WO_STATUS = 'CANCEL'
      FROM   FP_DAILY_INSTANCE_ORDER_STATUS A
      WHERE  A.INSTANCE_ID      = @v_master_id
      AND    A.FP_PLAN_ID       = @v_plan_id
      AND    A.FACTORY_ID       = @v_factory_id
      AND    A.WO_STATUS        IN ( 'OPEN', 'RUN' )
      AND    A.PLAN_QTY - ISNULL(A.ACTUAL_GOOD_QTY, 0) <= 0
    
      --LOG 생성
      SET @v_message = 'WO_STATUS = CANCEL / PLAN_QTY <= 0 : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

      ------------------------------------------------------------------------------------
      -- 2일 이전 WORK ORDER 는 CANCEL
      ------------------------------------------------------------------------------------
      UPDATE A
      SET    A.WO_STATUS    = 'CANCEL'
      FROM   FP_DAILY_INSTANCE_ORDER_STATUS A
           , (
              SELECT A.WORK_ORDER_ID, MIN(B.PLAN_DATE) AS PLAN_DATE
              FROM   FP_DAILY_INSTANCE_ORDER_STATUS A
            LEFT OUTER JOIN FP_RELEASE_FIX_PLAN_H B WITH(NOLOCK)
                          ON    B.INSTANCE_ID     = A.INSTANCE_ID
                          AND   B.INSTANCE_DATE  <= CONVERT(NVARCHAR, @v_plan_date, 112)
                          AND   B.WORK_ORDER_ID   = A.WORK_ORDER_ID
              WHERE  A.INSTANCE_ID  = @v_master_id
              AND    A.FP_PLAN_ID   = @v_plan_id
              AND    A.FACTORY_ID   = @v_factory_id
              AND    A.WO_STATUS    IN ('RUN','OPEN')
              GROUP  BY A.WORK_ORDER_ID
              HAVING MIN(B.PLAN_DATE) < DATEADD(DAY, -2, @v_plan_date)
             ) B
      WHERE  A.INSTANCE_ID    = @v_master_id
      AND    A.FP_PLAN_ID     = @v_plan_id
      AND    A.WORK_ORDER_ID  = B.WORK_ORDER_ID

      --LOG 생성
      SET @v_message = 'WO_STATUS = CANCEL / OPEN WORK (D-3) : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

      ------------------------------------------------------------------------------------
      -- ACTUAL 이 아니면서 동일일자에 동일 유형이 2개이상이면 1개는 남기고 나머진 CANCEL
      ------------------------------------------------------------------------------------
      UPDATE A
      SET    A.WO_STATUS    = 'CANCEL'
      FROM   (
              SELECT A.WORK_ORDER_ID
                   , A.FACTORY_ID
                   , A.LINE_ID
                   , A.OPERATION_ID
                   , A.ELECTRODE_TYPE
                   , A.EQUIPMENT_ID
                   , A.ITEM_ID
                   , A.PRODUCTION_TYPE
                   , A.MARKET
                   , A.PLAN_DATE
                   , A.WO_STATUS
                   , DENSE_RANK() OVER (PARTITION BY A.PLAN_DATE          -- 동일 일자
                                                   , A.FACTORY_ID         -- 동일 동
                                                   , A.LINE_ID            -- 동일 라인
                                                   , A.OPERATION_ID       -- 동일 OPERATION
                                                   , A.ELECTRODE_TYPE     -- 동일 TYPE
                                                   , A.EQUIPMENT_ID       -- 동일 설비
                                                   , A.TOP_ITEM_ID        -- 동일 TOP_ITEM
                                                   , A.ITEM_ID            -- 동일 ITEM
                                                   , A.PRODUCTION_TYPE    -- 동일 PRODUCTION_TYPE
                                                   , A.MARKET             -- 동일 MARKET
                                        ORDER     BY A.WORK_ORDER_ID DESC
                                       ) AS DESC_SEQ                    -- 가장 최근 WORK 이 1번
              FROM   FP_DAILY_INSTANCE_ORDER_STATUS A
              WHERE  A.INSTANCE_ID  = @v_master_id
              AND    A.FP_PLAN_ID   = @v_plan_id
              AND    A.FACTORY_ID   = @v_factory_id
              AND    A.ACTUAL_FLAG  = 'N'
              AND    A.WO_STATUS    IN ('RUN','OPEN')
             ) A
      WHERE  A.DESC_SEQ > 1

      --LOG 생성
      SET @v_message = 'WO_STATUS = CANCEL / NOT ACTUAL WORK : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

      ------------------------------------------------------------------------------------
      -- PILOT LINE : 전일 실적 기준 Carry Over 없음
      ------------------------------------------------------------------------------------
      UPDATE A
      SET    A.WO_STATUS    = 'CANCEL'
      FROM   FP_DAILY_INSTANCE_ORDER_STATUS A
           , (
              SELECT SEGMENT1 AS FACTORY_ID
                   , SEGMENT2 AS LINE_ID
                   , SEGMENT3 AS OPERATION_ID
              FROM   SCM_SYS_LOOKUP_VALUE WITH(NOLOCK)
              WHERE  LOOKUP_TYPE_CODE = 'PILOT_LINE'    -- 개발 라인 LOOKUP 정의
              AND    ACTIVE_FLAG      = 'Y'
              AND    ATTRIBUTE2       = 'Y'             -- SCP 생산 Target 일별 수신
              AND    ATTRIBUTE4       = 'Y'             -- SCP 생산일 당일 계획 수립
             ) B
      WHERE  A.INSTANCE_ID      = @v_master_id
      AND    A.FP_PLAN_ID       = @v_plan_id
      AND    A.FACTORY_ID       = @v_factory_id
      AND    A.WO_STATUS        IN ( 'OPEN', 'RUN' )
      AND    A.LINE_ID          = B.LINE_ID
      AND    A.OPERATION_ID     = B.OPERATION_ID
      AND    CONVERT(DATE, A.PLAN_START_TIME) < CONVERT(DATE, @v_plan_date)
    
      --LOG 생성
      SET @v_message = 'WO_STATUS = CANCEL / PILOT_LINE (D-1) : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

      ------------------------------------------------------------------------------------
      -- 2019.01.04 : RELEASE 구간 밖의 OPEN WO 취소 로직
      ------------------------------------------------------------------------------------
      UPDATE A
      SET    A.WO_STATUS    = 'CANCEL'
      FROM   FP_DAILY_INSTANCE_ORDER_STATUS A
      WHERE  A.INSTANCE_ID  = @v_master_id
      AND    A.FP_PLAN_ID   = @v_plan_id
      AND    A.FACTORY_ID   = @v_factory_id
      AND    A.PLAN_DATE    > @v_confirm_date
      AND    A.WO_STATUS    IN ( 'OPEN', 'RUN' )

      --LOG 생성
      SET @v_message = 'WO_STATUS = CANCEL / PLAN_DATE > @v_confirm_date : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

    END
    
    -------------------------------------------------------------------------
    -- 자동차 활성화만 실행되도록..
    IF CHARINDEX('FORM', @v_master_id) > 0 AND @v_master_id != 'CN_FORM_T' 
    BEGIN
    
      SET @v_table_name = 'PR_SCM_OF_PSI_AMEND_UI_CALCULATION_FORM'

      --LOG 생성
      SET @v_message = 'PROC START...'
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
      
	  -- UI 단에서 실행시키고 있어 중복 실행되어 제외함 20230804 by cys
      --EXEC PR_SCM_OF_PSI_AMEND_UI_CALCULATION_FORM @v_master_id, @v_plan_id
    
      --LOG 생성
      SET @v_message = 'PROC END...'
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

    END
    -------------------------------------------------------------------------

    BEGIN
    
      SET @v_table_name = 'FP_AMEND_PLAN_R'
      
      DELETE FROM A
      FROM   FP_AMEND_PLAN_R A
      WHERE  A.INSTANCE_ID    = @v_master_id
      AND    A.FP_PLAN_ID     = @v_plan_id
      AND    A.FACTORY_ID     = @v_factory_id
      
      IF CHARINDEX('FORM', @v_master_id) > 0 AND CHARINDEX('FORM_T', @v_master_id) = 0 
      BEGIN 
        
        INSERT INTO FP_AMEND_PLAN_R
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
             --, BOH_QTY
   , IN_QTY
             , OUT_QTY
             --, SALES_QTY
             --, EOH_QTY
             --, YIELD
             , DATE_SEQ
             --, ACTUAL_FLAG
             , PLAN_GROUP_ID
             , INSERT_ID
             , INSERT_TIME
             , UPDATE_ID
             , UPDATE_TIME      
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
             , A.ITEM_TYPE
             --, A.BOH_QTY
             , A.IN_QTY
             , A.OUT_QTY
             --, A.SALES_QTY
             --, A.EOH_QTY
             --, A.YIELD
             , A.DATE_SEQ
             --, A.ACTUAL_FLAG
             , '-'              AS PLAN_GROUP_ID
             , A.INSERT_ID
             , A.INSERT_TIME
             , A.UPDATE_ID
             , A.UPDATE_TIME      
        FROM   FP_AMEND_PLAN_FORM_R A
        WHERE  A.INSTANCE_ID    = @v_master_id
        AND    A.FP_PLAN_ID     = @v_plan_id
        AND    A.FACTORY_ID     = @v_factory_id
        AND    A.PLAN_DATE     >= @v_plan_date
      
        SET @n_row_count = @@ROWCOUNT
        
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
      END

      ELSE
      BEGIN

        -- INSTANCE 별로 구분할 경우를 대비하여,, CASE 문으로 설정..
        SELECT @v_sqltable = (CASE  WHEN charindex('CELL', @v_master_id) > 0  THEN 'FP_AMEND_PLAN_CELL_R'
                                    WHEN charindex('CN_FORM_T' , @v_master_id)  > 0  THEN 'FP_AMEND_PLAN_POST_FORM_R' 
                                                                              ELSE 'FP_AMEND_PLAN_PACK_R'
                              END  )
        
        --LOG 생성
        SET @v_message = 'DYNAMIC TABLE : ' + @v_sqltable
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, '', 'SELECT', @n_log_count, null, @v_message, null
        
        IF @v_master_id = 'CN_FORM_T'
        BEGIN
        
          DECLARE @v_sqlInsert nvarchar(MAX),
                  @v_sqlSelect nvarchar(MAX),
                  @v_sqlGroup nvarchar(MAX)
           
          set @v_sqlInsert = '       INSTANCE_ID, FP_PLAN_ID '
                           + '     , COMPANY_ID, DIVISION_ID, CATEGORY_ID, SITE_ID, PLANT_ID, ITEM_ID '
                           + '     , OPERATION_ID, FACTORY_ID, LOCATION, PRODUCTION_TYPE, MARKET, LINE_ID, ELECTRODE_TYPE '
                           + '     , PLAN_DATE, TOP_ITEM_ID, ITEM_TYPE '
                           + '     , IN_QTY, OUT_QTY '
                           + '     , CELL_IN_QTY, CELL_OUT_QTY '
                           + '     , DATE_SEQ '
                           + '     , PLAN_GROUP_ID '
                           + '     , INSERT_ID, INSERT_TIME '
                           + '     , UPDATE_ID, UPDATE_TIME , CELL_MATERIAL_ID'
          
          set @v_sqlSelect =       ' A.INSTANCE_ID, A.FP_PLAN_ID '
                           + '     , A.COMPANY_ID, A.DIVISION_ID, A.CATEGORY_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID '
                           + '     , A.OPERATION_ID, A.FACTORY_ID, ''-'' AS LOCATION, A.PRODUCTION_TYPE, A.MARKET, A.LINE_ID, ''-'' AS ELECTRODE_TYPE '
                           + '     , A.PLAN_DATE, A.TOP_ITEM_ID, A.ITEM_TYPE '
                           --+ '     , A.IN_QTY, A.OUT_QTY, A.PUSH_TARGET_QTY AS SALES_QTY '
                           + '     , A.IN_QTY, A.OUT_QTY '
                           + '     , NULL AS CELL_IN_QTY, NULL AS CELL_OUT_QTY '
                           + '     , A.DATE_SEQ '
                           + '     , ''-''              AS PLAN_GROUP_ID '
                           + '     , A.INSERT_ID, A.INSERT_TIME '
                           + '     , '''+@v_sqltable+''' AS UPDATE_ID '
                           + '     , A.UPDATE_TIME , A.CELL_MATERIAL_ID'    
                                       
          set @v_sqltext   =  'INSERT INTO FP_AMEND_PLAN_R'
                           +  '(' + @v_sqlInsert + ')'
                           +  'SELECT ' + @v_sqlSelect + ' '
                           +  'FROM   '+@v_sqltable +' A '
                           +  'WHERE  A.INSTANCE_ID  = '''+@v_master_id+''' '
                           +  'AND    A.FP_PLAN_ID   = '''+@v_plan_id+''' '
                     +  'AND    A.FACTORY_ID   = '''+@v_factory_id+''' '
                           +  'AND    CONVERT(NVARCHAR, A.PLAN_DATE, 112) >= '''+CONVERT(NVARCHAR,@v_plan_date, 112) +''' '
                           
                           
          
          EXEC sp_executesql @v_sqltext, N'@v_return AS INTEGER OUTPUT', @v_return=@n_row_count OUTPUT

          -- 신규 데이터 생성 수량 COUNT
          SET @v_sqltext  = 'SELECT @v_return = COUNT(1) '
                          + 'FROM   FP_AMEND_PLAN_R A '
                          + 'where  1=1 '
                          + 'and    a.instance_id  = '''+@v_master_id+''' '
                          + 'and    a.fp_plan_id            = '''+@v_plan_id+''' '

          EXEC sp_executesql @v_sqltext, N'@v_return AS INTEGER OUTPUT', @v_return=@n_row_count OUTPUT
          
          --LOG 생성
          SET @v_message   = 'DYNAMIC SQL - ' +@v_sqltable+ ' : ' + CONVERT(NVARCHAR, @n_row_count)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate     = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null                 
    
      
        END
        
        ELSE
        BEGIN
        
          set @v_sqltext = 'INSERT INTO FP_AMEND_PLAN_R '
                         + '     ( '
                         + '       INSTANCE_ID, FP_PLAN_ID '
                         + '     , COMPANY_ID, DIVISION_ID, CATEGORY_ID, SITE_ID, PLANT_ID, ITEM_ID '
                         + '     , OPERATION_ID, FACTORY_ID, LOCATION, PRODUCTION_TYPE, MARKET, LINE_ID, ELECTRODE_TYPE '
                         + '     , PLAN_DATE, TOP_ITEM_ID, ITEM_TYPE '
                         + '     , IN_QTY, OUT_QTY '
                         + '     , CELL_IN_QTY, CELL_OUT_QTY '
                         + '     , DATE_SEQ '
                         + '     , PLAN_GROUP_ID '
                         + '     , INSERT_ID, INSERT_TIME '
                         + '     , UPDATE_ID, UPDATE_TIME '
                         + '     , SETUP_COLOR_CODE '
                         + '     , RESULT_IN_QTY, RESULT_OUT_QTY, RESULT_CELL_IN_QTY, RESULT_CELL_OUT_QTY '
                         + '     , WPP_IN_QTY, WPP_OUT_QTY, WPP_CELL_IN_QTY, WPP_CELL_OUT_QTY '
                         + '     , MPP_IN_QTY, MPP_OUT_QTY, MPP_CELL_IN_QTY, MPP_CELL_OUT_QTY '
                         + '     , VERSION, PLM_EC_NO '	-- (D20240509~R0509.01) 
                         + '     ) '
                         + 'SELECT '
                         + '       A.INSTANCE_ID, A.FP_PLAN_ID '
                         + '     , A.COMPANY_ID, A.DIVISION_ID, A.CATEGORY_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID '
                         + '     , A.OPERATION_ID, A.FACTORY_ID, A.LOCATION, A.PRODUCTION_TYPE, A.MARKET, A.LINE_ID, A.ELECTRODE_TYPE '
                         + '     , A.PLAN_DATE, A.TOP_ITEM_ID, A.ITEM_TYPE '
                         + ' , A.IN_QTY, A.OUT_QTY '
                         + '     , A.CELL_IN_QTY, A.CELL_OUT_QTY '
                         + '     , A.DATE_SEQ '
                         + '     , ''-''              AS PLAN_GROUP_ID '
                         + '     , A.INSERT_ID, A.INSERT_TIME '
                         + '     , '''+@v_sqltable+''' AS UPDATE_ID '
                         + '     , A.UPDATE_TIME '
                         + '     , A.SETUP_COLOR_CODE '
                         + '     , A.RESULT_IN_QTY, A.RESULT_OUT_QTY, A.RESULT_CELL_IN_QTY, A.RESULT_CELL_OUT_QTY '
                         + '     , A.WPP_IN_QTY, A.WPP_OUT_QTY, A.WPP_CELL_IN_QTY, A.WPP_CELL_OUT_QTY '
                         + '     , A.MPP_IN_QTY, A.MPP_OUT_QTY, A.MPP_CELL_IN_QTY, A.MPP_CELL_OUT_QTY '
                         + '     , A.VERSION, A.PLM_EC_NO '	-- (D20240509~R0509.01) 
                         + 'FROM   '+@v_sqltable+' A '
                         + 'WHERE  A.INSTANCE_ID    = '''+@v_master_id+''' '
                         + 'AND    A.FP_PLAN_ID     = '''+@v_plan_id+''' '
                         + 'AND    A.FACTORY_ID     = '''+@v_factory_id+''' '
                         + 'AND    CONVERT(NVARCHAR, A.PLAN_DATE, 112) >= '''+CONVERT(NVARCHAR,@v_plan_date, 112) +''' '
          --               + 'AND    A.OUT_QTY        > 0 '
          

        EXEC sp_executesql @v_sqltext, N'@v_return AS INTEGER OUTPUT', @v_return=@n_row_count OUTPUT

        -- 신규 데이터 생성 수량 COUNT
        SET @v_sqltext  = 'SELECT @v_return = COUNT(1) '
                        + 'FROM  FP_AMEND_PLAN_R a '
                        + 'where  1=1 '
                        + 'and    a.instance_id           = '''+@v_master_id+''' '
                        + 'and    a.fp_plan_id            = '''+@v_plan_id+''' '

          EXEC sp_executesql @v_sqltext, N'@v_return AS INTEGER OUTPUT', @v_return=@n_row_count OUTPUT
          
          --LOG 생성
          SET @v_message   = 'DYNAMIC SQL - ' +@v_sqltable+ ' : ' + CONVERT(NVARCHAR, @n_row_count)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate     = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
        END
        
      END
    

      IF @v_create_vd_mo = 'Y'      -- MO 생성 여부에 따라 실행
      BEGIN
      
        INSERT INTO FP_AMEND_PLAN_R
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
             --, BOH_QTY
             , IN_QTY
             , OUT_QTY
             --, SALES_QTY
             --, EOH_QTY
             --, YIELD
             , DATE_SEQ
             --, ACTUAL_FLAG
             , PLAN_GROUP_ID
             , INSERT_ID
             , INSERT_TIME
             , UPDATE_ID
             , UPDATE_TIME 
			 , VERSION		-- (D20240509~R0509.01) 
    		 , PLM_EC_NO	-- (D20240509~R0509.01) 
       )
        SELECT A.INSTANCE_ID
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
             , MAX(A.ITEM_TYPE)   AS ITEM_TYPE
             --, SUM(BOH_QTY)       AS BOH_QTY
             , SUM(IN_QTY)        AS IN_QTY
             , SUM(OUT_QTY)       AS OUT_QTY 
             --, SUM(SALES_QTY)     AS SALES_QTY
             --, SUM(EOH_QTY)       AS EOH_QTY
             --, 1                  AS YIELD
             , MIN(DATE_SEQ)      AS DATE_SEQ
             --, MIN(ACTUAL_FLAG)   AS ACTUAL_FLAG  
             , '-'                AS PLAN_GROUP_ID
             , @v_proc_name       AS INSERT_ID
             , GETDATE()          AS INSERT_TIME
             , @v_proc_name       AS UPDATE_ID
             , GETDATE()          AS UPDATE_TIME   
			 , A.VERSION		-- (D20240509~R0509.01) 
             , A.PLM_EC_NO		-- (D20240509~R0509.01) 
        FROM   (
                SELECT A.INSTANCE_ID
                     , A.FP_PLAN_ID
                     , A.COMPANY_ID
                     , A.DIVISION_ID
                     , A.CATEGORY_ID
                     , A.SITE_ID
                     , A.PLANT_ID
                     , A.CHILD_ITEM_ID                AS ITEM_ID
                     , B.OPERATION_ID
                     , B.FACTORY_ID
                     , A.LOCATION
                     , A.PRODUCTION_TYPE
                     , A.MARKET
                     , B.LINE_ID
                     , B.ELECTRODE_TYPE
                     , CASE WHEN A.NEW_PLAN_DATE < @v_plan_date THEN @v_plan_date 
                                                                ELSE A.NEW_PLAN_DATE
                       END  AS PLAN_DATE
                     , A.TOP_ITEM_ID
                     , ISNULL(F.LEVEL_3_NAME, '-')    AS ITEM_TYPE
               --, 0                  AS BOH_QTY
                     , CEILING(A.OUT_QTY / A.IN_RATE * ( A.CHILD_QTY / A.PARENT_QTY )) AS IN_QTY
                     , CEILING(A.OUT_QTY / A.IN_RATE * ( A.CHILD_QTY / A.PARENT_QTY )) AS OUT_QTY
                     --, 0                  AS SALES_QTY
                     --, 0                  AS EOH_QTY
                     , A.DATE_SEQ
                     --, 'N'                AS ACTUAL_FLAG
                     , DENSE_RANK() OVER (PARTITION BY A.TOP_ITEM_ID
                                                     , A.CHILD_ITEM_ID
                                                     , B.FACTORY_ID
                                                     , B.OPERATION_ID 
                                                     , A.PRODUCTION_TYPE
                                                     , A.MARKET
                                          ORDER     BY (  CASE WHEN CHARINDEX('AV', B.LINE_ID) > 0 THEN 1
                                                               WHEN CHARINDEX('EV', B.LINE_ID) > 0 THEN 2
                                                               WHEN A.LINE_ID = B.LINE_ID          THEN 3
                                                                                                   ELSE 9 
                                                          END )
                                                     , B.LINE_ID) AS SEQ
						, A.VERSION		-- (D20240509~R0509.01) 
						, A.PLM_EC_NO	-- (D20240509~R0509.01)                  
                FROM   (
                        SELECT A.*
                             , DATEADD(DAY, -1, A.PLAN_DATE) AS NEW_PLAN_DATE
                             , C.CHILD_ITEM_ID
                             , CASE WHEN B.YIELD IS NULL  THEN 1
                                    WHEN B.YIELD = 0      THEN 1
                                                          ELSE B.YIELD
                               END  AS IN_RATE
                             , C.PARENT_QTY
                             , C.CHILD_QTY
                             , D.FLOW_ID
                        FROM   FP_AMEND_PLAN_R A
                               LEFT OUTER JOIN SCM_YIELD_M B WITH(NOLOCK)
                                    ON    A.COMPANY_ID    = B.COMPANY_ID
                                    AND   A.DIVISION_ID   = B.DIVISION_ID
               AND   A.SITE_ID       = B.SITE_ID
                                    AND   A.PLANT_ID      = B.PLANT_ID
                                    AND   A.FACTORY_ID    = B.FACTORY_ID
                                    AND   A.OPERATION_ID  = B.OPERATION_ID
                                    AND   A.LINE_ID       = B.LINE_ID
                                    AND   A.ITEM_ID       = B.ITEM_ID
                                    AND   CONVERT(NVARCHAR(6), PLAN_DATE, 112) = B.MONTH
                               LEFT OUTER JOIN SCM_BOM_M C WITH(NOLOCK)
                                    ON    A.COMPANY_ID    = C.COMPANY_ID
                                    AND   A.DIVISION_ID   = C.DIVISION_ID
                                    AND   A.SITE_ID       = C.SITE_ID
                                    AND   A.PLANT_ID      = C.PLANT_ID
                                    AND   A.ITEM_ID       = C.PARENT_ITEM_ID
                                    AND   A.PLAN_DATE     >= C.EFF_START_DATE
                                    AND   A.PLAN_DATE     <  C.EFF_END_DATE
                               LEFT OUTER JOIN SCM_ITEM_M D WITH(NOLOCK)
                                    ON     C.COMPANY_ID     = D.COMPANY_ID
                                    AND    C.DIVISION_ID    = D.DIVISION_ID
                                    AND    C.SITE_ID        = D.SITE_ID
                                    AND    C.CHILD_ITEM_ID  = D.ITEM_ID  
                                    AND    D.ACTIVE_FLAG    = 'Y'
  AND    D.ITEM_TYPE      = 'H'
                               LEFT OUTER JOIN SCM_ITEM_CLASS_M E WITH(NOLOCK)
                                    ON     D.ITEM_CLASS     = E.CLASS_ID  
                                    AND    E.USE_FLAG       = 'Y'                    
                        WHERE  A.INSTANCE_ID  = @v_master_id
                        AND    A.FP_PLAN_ID   = @v_plan_id
                        AND    A.FACTORY_ID   = @v_factory_id                       -- FACTORY 별
                        AND    A.OPERATION_ID IN ( 'A7000', 'A8200' )                             -- ## A7000
                        AND    A.OUT_QTY      > 0
                        AND    E.USE_FLAG     = 'Y'
                       ) A
                       LEFT OUTER JOIN SCM_ITEM_LINE_ASSIGN_M B WITH(NOLOCK)
                            ON    A.COMPANY_ID    = B.COMPANY_ID
                            AND   A.DIVISION_ID   = B.DIVISION_ID
                            AND   A.SITE_ID       = B.SITE_ID
                            AND   A.PLANT_ID      = B.PLANT_ID
                            AND   A.FACTORY_ID    = B.FACTORY_ID
                            AND   A.CHILD_ITEM_ID = B.ITEM_ID
                            AND   CONVERT(NVARCHAR(6), PLAN_DATE, 112) = B.MONTH
                            AND   B.OPERATION_ID  = 'A6000'                         -- ## A6000
                       LEFT OUTER JOIN SCM_ITEM_M       D   WITH(NOLOCK)
                            ON    B.COMPANY_ID    = D.COMPANY_ID
                            AND   B.DIVISION_ID   = D.DIVISION_ID
                            AND   B.SITE_ID       = D.SITE_ID
                            AND   B.ITEM_ID       = D.ITEM_ID        
                       LEFT OUTER JOIN SCM_ITEM_CLASS_M F   WITH(NOLOCK)
                            ON    D.ITEM_CLASS    = F.CLASS_ID
                       LEFT OUTER JOIN SCM_EQUIPMENT_M   G  WITH(NOLOCK)
                       		  ON     A.COMPANY_ID    = G.COMPANY_ID
                            AND    A.DIVISION_ID   = G.DIVISION_ID
                            AND    A.SITE_ID       = G.SITE_ID
                            AND    A.PLANT_ID      = G.PLANT_ID
                            AND    A.FACTORY_ID    = G.FACTORY_ID
                            AND    B.OPERATION_ID  = G.OPERATION_ID
                            AND    B.LINE_ID       = G.LINE_ID
                  WHERE		B.OPERATION_ID IS NOT NULL
                 AND		G.ACTIVE_FLAG = 'Y'
                  --AND		G.EQUIPMENT_ID IS NOT NULL     -- (D.20220824~R.0824.01)
               ) A
        WHERE  SEQ = 1
        GROUP  BY 
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
             --, A.ITEM_TYPE
			 , A.VERSION	-- (D20240509~R0509.01) 
             , A.PLM_EC_NO	-- (D20240509~R0509.01) 

        SET @n_row_count = @@ROWCOUNT
        
        --LOG 생성
        SET @v_message = 'A6000 : ' + CONVERT(NVARCHAR, @n_row_count)
        SET @n_log_count = @n_log_count + 1
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        UPDATE FP_AMEND_PLAN_R
        SET    FP_AMEND_PLAN_R.IN_QTY = CEILING(
                                                A.OUT_QTY / ( CASE  WHEN B.YIELD IS NULL  THEN 1
                                                                    WHEN B.YIELD = 0      THEN 1
       ELSE B.YIELD
                                                              END  )
    )
        FROM   FP_AMEND_PLAN_R A
               LEFT OUTER JOIN SCM_YIELD_M B WITH(NOLOCK)
                    ON    A.COMPANY_ID    = B.COMPANY_ID
                    AND   A.DIVISION_ID   = B.DIVISION_ID
                    AND   A.SITE_ID       = B.SITE_ID
                    AND   A.PLANT_ID      = B.PLANT_ID
                    AND   A.FACTORY_ID    = B.FACTORY_ID
                    AND   A.OPERATION_ID  = B.OPERATION_ID
                    AND   A.LINE_ID       = B.LINE_ID
                    AND   A.ITEM_ID       = B.ITEM_ID
                    AND   CONVERT(NVARCHAR(6), PLAN_DATE, 112) = B.MONTH
        WHERE  A.INSTANCE_ID    = @v_master_id
        AND    A.FP_PLAN_ID     = @v_plan_id
        AND    A.FACTORY_ID     = @v_factory_id                       -- FACTORY 별
        AND    A.OPERATION_ID   = 'A6000'
      
        SET @n_row_count = @@ROWCOUNT
        
        --LOG 생성
        SET @v_message = 'A6000 - IN_QTY / YIELD : ' + CONVERT(NVARCHAR, @n_row_count)
        SET @n_log_count = @n_log_count + 1
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

      END
      
    END
    

    -- 1일 1 WORK 계획 먼저 수립함.
    BEGIN
    
      SET @v_table_name = 'TH_BUF_SCM_PLAN_FACTORY'

      DELETE FROM TH_BUF_SCM_PLAN_FACTORY WHERE INSERT_TIME < DATEADD(DAY, -7, GETDATE())   -- 이전 데이터 삭제
    
      DELETE FROM A
      FROM   TH_BUF_SCM_PLAN_FACTORY A
      WHERE  A.INSTANCE_ID  = @v_master_id
      AND    A.FP_PLAN_ID   = @v_plan_id
      AND    A.FACTORY_ID   = @v_factory_id
      
      INSERT INTO TH_BUF_SCM_PLAN_FACTORY
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
           , ORG_PLAN_QTY
           , PLAN_QTY
           , PLAN_IN_QTY
           , ITEM_UOM
           , PRODUCTION_TYPE
           , BOM_VERSION_ID
           , SLIT_PLANT_ID
           , MARKET
           , MFG_WEEK
           , DEMAND_DIVISION_ID
           , PLAN_GROUP_ID
           , INSERT_ID
           , INSERT_TIME           
           , CELL_MATERIAL_ID
           , SETUP_COLOR_CODE
		   , VERSION	-- (D20240509~R0509.01) 
           , PLM_EC_NO	-- (D20240509~R0509.01) 
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
          /*
           -- 2018.07.13 : 무등록 설비일 경우 CONFIRM 구간 밖은 NULL 오류 나지 않도록 ISNULL 처리함. 
           --              CELL / PACK 만 대상
           , CASE WHEN A.PLAN_DATE > @v_confirm_date THEN ISNULL(D.WORK_CENTER_ID,  'NULL')
                                                     ELSE ISNULL(D.WORK_CENTER_ID,  'NULL')
             END  AS WORK_CENTER_ID
           , CASE WHEN A.PLAN_DATE > @v_confirm_date THEN ISNULL(D.EQUIPMENT_ID,    'NULL')
                                                     ELSE ISNULL(D.EQUIPMENT_ID,    'NULL')
	     END  AS EQUIPMENT_ID
	   */
	   -- (D.20220824~R.0824.01)
           , CASE WHEN A.PLAN_DATE > @v_confirm_date THEN ISNULL(E.WORK_CENTER_ID, ISNULL(D.WORK_CENTER_ID,  '-'))	-- (D20250319~R0319.01) PDS2
                                                     ELSE ISNULL(E.WORK_CENTER_ID, ISNULL(D.WORK_CENTER_ID,  '-'))	-- (D20250319~R0319.01) PDS2
             END  AS WORK_CENTER_ID
           , CASE WHEN A.PLAN_DATE > @v_confirm_date THEN ISNULL(E.EQUIPMENT_ID, ISNULL(D.EQUIPMENT_ID,    '-'))	-- (D20250319~R0319.01) PDS2
                                                     ELSE ISNULL(E.EQUIPMENT_ID, ISNULL(D.EQUIPMENT_ID,    '-'))	-- (D20250319~R0319.01) PDS2
	     END  AS EQUIPMENT_ID
	     
           , A.PLAN_DATE
           , DATEADD(MINUTE, @v_daydiff,        A.PLAN_DATE) AS START_TIME
           , DATEADD(MINUTE, @v_daydiff + 1440, A.PLAN_DATE) AS END_TIME
           , A.PLAN_QTY         AS ORG_PLAN_QTY
           , A.PLAN_QTY
           , A.PLAN_IN_QTY
           , B.ITEM_UOM
           , A.PRODUCTION_TYPE
           , ''                 AS BOM_VERSION_ID
           , A.PLANT_ID         AS SLIT_PLANT_ID
           , A.MARKET
           , C.WEEK             AS MFG_WEEK
           , A.DIVISION_ID      AS DEMAND_DIVISION_ID
           , A.PLAN_GROUP_ID
           , @v_proc_name       AS INSERT_ID
           , GETDATE()          AS INSERT_TIME
           , A.CELL_MATERIAL_ID
           , A.SETUP_COLOR_CODE
		   , A.VERSION		-- (D20240509~R0509.01) 
           , A.PLM_EC_NO	-- (D20240509~R0509.01) 
      FROM   (
              SELECT A.*
                   , ORDER_TYPE + @v_instance_code
                                + @v_order_date_code
                                + A.ERP_OPERATION_ID
                                + '#'
                                + C.SEGMENT3
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
                           , CASE WHEN WO_FLAG = 'Y' THEN 'W' ELSE 'M' END AS ORDER_TYPE
                           , A.ITEM_ID
                           , A.TOP_ITEM_ID
                           , A.LINE_ID
                           , A.OPERATION_ID
                           , A.ELECTRODE_TYPE
                           , A.PLAN_DATE
                           , A.OUT_QTY            AS PLAN_QTY
                           , A.IN_QTY             AS PLAN_IN_QTY
                           , A.PRODUCTION_TYPE
                           , A.MARKET
                           , B.ERP_OPERATION_ID
                           , D.MODEL_TYPE AS PLAN_GROUP_ID
                           , DENSE_RANK() OVER (PARTITION BY B.ERP_OPERATION_ID
                                                ORDER     BY A.PLAN_DATE
                                                         , A.FACTORY_ID
                                                           , A.LINE_ID
                                                           , A.LOCATION
          , A.OPERATION_ID
                                                           , A.ELECTRODE_TYPE
                                                           , A.ITEM_ID
                                                           , A.TOP_ITEM_ID
                                                           , A.PRODUCTION_TYPE
                                                           , A.MARKET
														   , A.VERSION		-- (D20240509~R0509.01) 
                                                           , A.PLM_EC_NO	-- (D20240509~R0509.01) 
                                                           ) AS ORDER_SEQ
                           , A.CELL_MATERIAL_ID
                           , A.SETUP_COLOR_CODE
						   , A.VERSION		-- (D20240509~R0509.01) 
                           , A.PLM_EC_NO	-- (D20240509~R0509.01) 
                      FROM   FP_AMEND_PLAN_R A WITH (NOLOCK)
                           , SCM_OPERATION_M B WITH (NOLOCK)
                           , SCM_LINE_M      D WITH (NOLOCK)
                      WHERE  A.INSTANCE_ID    = @v_master_id
                      AND    A.FP_PLAN_ID     = @v_plan_id
                      AND    A.FACTORY_ID     = @v_factory_id
                      AND    A.OUT_QTY        > 0
                      AND    A.COMPANY_ID     = B.COMPANY_ID
                      AND    A.DIVISION_ID    = B.DIVISION_ID
                      AND    A.SITE_ID        = B.SITE_ID
                      AND    A.OPERATION_ID   = B.OPERATION_ID
                      AND    A.FACTORY_ID     = D.FACTORY_ID
                      AND    A.LINE_ID        = D.LINE_ID
                      AND    A.OPERATION_ID   = D.OPERATION_ID
                      AND    A.ELECTRODE_TYPE = D.ELECTRODE_TYPE
                     ) A
                   , SCM_SYS_LOOKUP_VALUE C WITH (NOLOCK)
              WHERE  1=1
              AND    A.INSTANCE_ID = C.SEGMENT1
              AND    C.LOOKUP_TYPE_CODE = 'INSTANCE_ID'              
             ) A
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
                                                                  ORDER     BY FACTORY_ID
                                                                             , CASE WHEN LINE_ID = 'A1A08' AND MES_LINE_ID = 'A1A08' THEN 1 ELSE 9 END
                                                                             , EQUIPMENT_ID) AS SEQ
                                        FROM   SCM_EQUIPMENT_M WITH (NOLOCK)
                                        WHERE  ACTIVE_FLAG = 'Y'
                                        AND    EQUIPMENT_TYPE = 'M'
                                       ) A
       WHERE  SEQ = 1    -- ## 대표설비만...                      
                               ) D
                    ON   A.FACTORY_ID = D.FACTORY_ID
                    AND  A.LINE_ID    = D.LINE_ID
                    AND  A.OPERATION_ID = D.OPERATION_ID
                    AND  A.ELECTRODE_TYPE = D.ELECTRODE_TYPE 
             LEFT OUTER JOIN (		-- (D20250319~R0319.01) PDS2
             					SELECT A.COMPANY_ID, A.DIVISION_ID, A.PLANT_ID,  A.FACTORY_ID, A.LINE_ID, A.OPERATION_ID, A.PLM_EC_NO, A.PDS_EQUIPMENT_ID
										, C.EQUIPMENT_ID, C.WORK_CENTER_ID
								FROM FP_WEEKLY_DEMAND_PRODUCT_PDS_H A WITH(NOLOCK)
									, (
										SELECT 	DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.PLANT_ID,  A.FACTORY_ID, A.LINE_ID, A.OPERATION_ID 
										FROM 	FP_INSTANCE_LINE_V A WITH(NOLOCK)
										WHERE 	A.INSTANCE_ID 	= @v_master_id
										AND 	A.FACTORY_ID	= @v_factory_id
									  ) B 
									, SCM_EQUIPMENT_M C WITH (NOLOCK)
								 WHERE  1=1
								AND A.COMPANY_ID = B.COMPANY_ID
								AND A.DIVISION_ID= B.DIVISION_ID
								AND A.PLANT_ID = B.PLANT_ID
								AND A.FACTORY_ID = B.FACTORY_ID
								AND A.OPERATION_ID = B.OPERATION_ID
								AND A.LINE_ID = B.LINE_ID
								AND A.COMPANY_ID	= C.COMPANY_ID
								AND A.DIVISION_ID	= C.DIVISION_ID
								AND A.PLANT_ID		= C.PLANT_ID
								AND A.FACTORY_ID	= C.FACTORY_ID
								AND A.OPERATION_ID	= C.OPERATION_ID
								AND A.LINE_ID		= C.LINE_ID
								AND A.PDS_EQUIPMENT_ID = C.EQUIPMENT_ID
                                AND A.ACTIVE_FLAG = 'Y' --E20260316-000249 FP 계획 수립시 PDS Target 계획 반영 유무 기능 추가 건
             )	E
            ON   1=1
            AND  A.COMPANY_ID 		= E.COMPANY_ID
            AND  A.DIVISION_ID 		= E.DIVISION_ID
            AND  A.PLANT_ID 		= E.PLANT_ID
            AND  A.FACTORY_ID 		= E.FACTORY_ID
            AND  A.LINE_ID    		= E.LINE_ID
            AND  A.OPERATION_ID 	= E.OPERATION_ID
            AND  A.PLM_EC_NO 		= E.PLM_EC_NO 
           , SCM_ITEM_M B WITH (NOLOCK)
           , SCM_SYS_CALENDAR_M C WITH (NOLOCK)
      WHERE  A.COMPANY_ID = B.COMPANY_ID
      AND    A.DIVISION_ID = B.DIVISION_ID
      AND    A.SITE_ID = B.SITE_ID
      AND    A.ITEM_ID = B.ITEM_ID
      AND    A.PLAN_DATE = C.DATE_ID
      
      SET @n_row_count = @@ROWCOUNT
      
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
    
    END
    
    -- 확정 WORK ORDER 가 존재할 경우 MAPPING 처리함
    BEGIN
    
      SET @n_row_count = 0
      
      DECLARE 							-- 커서로 받을 변수
        @C_WORK_ORDER_ID      nvarchar(150),
        @C_FACTORY_ID         nvarchar(30),
        @C_LINE_ID            nvarchar(30),
        @C_OPERATION_ID       nvarchar(30),
        @C_ITEM_ID            nvarchar(150),
        @C_PLAN_DATE          datetime,
        @C_PLAN_QTY           numeric(20,10),
        @C_WO_STATUS          nvarchar(30),
        @C_PRODUCTION_TYPE    nvarchar(30),
        @C_MARKET             nvarchar(30),
        @C_ACTUAL_FLAG        nvarchar(5),
        @C_TOP_ITEM_ID        nvarchar(150)

      DECLARE 							-- SELECT 로 받을 변수
        @S_WORK_ORDER_ID      nvarchar(150),
        @S_FACTORY_ID         nvarchar(30),
        @S_LINE_ID            nvarchar(30),
        @S_OPERATION_ID       nvarchar(30),
        @S_ITEM_ID            nvarchar(150),
        @S_PLAN_DATE          datetime,
        @S_PLAN_IN_QTY        numeric(20,10),
        @S_PLAN_QTY           numeric(20,10)

      DECLARE C_PSI_AMEND_FACTORY_FIX CURSOR FOR
        SELECT WORK_ORDER_ID
             , FACTORY_ID
             , LINE_ID
             , OPERATION_ID
             , ITEM_ID
             , PLAN_DATE
             , PLAN_QTY
             , WO_STATUS
             , PRODUCTION_TYPE
             , MARKET
     , ACTUAL_FLAG
             , TOP_ITEM_ID
        FROM   (
                SELECT WORK_ORDER_ID
                     , FACTORY_ID
                     , LINE_ID
                     , OPERATION_ID
                     , ITEM_ID
                     , CASE WHEN PLAN_DATE < @v_plan_date THEN @v_plan_date 
                                                          ELSE PLAN_DATE 
                       END  AS PLAN_DATE
                     , ORG_QTY                              AS PLAN_QTY
                     , WO_STATUS
                     , PRODUCTION_TYPE
                     , MARKET
                     , ACTUAL_FLAG
                     , TOP_ITEM_ID
                     , DENSE_RANK() OVER (PARTITION BY FACTORY_ID
                                                     , LINE_ID
                                                     , OPERATION_ID
                                                     , ITEM_ID
                                                     , CASE WHEN PLAN_DATE < @v_plan_date THEN @v_plan_date 
                                                                                          ELSE PLAN_DATE 
                                                       END 
                                          ORDER     BY WORK_ORDER_ID) AS WO_ASC
                     , DENSE_RANK() OVER (PARTITION BY FACTORY_ID
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
        AND    A.WO_STATUS    IN ('OPEN','RUN')
               ) A
        ORDER  BY
               FACTORY_ID, LINE_ID, OPERATION_ID, ITEM_ID, PLAN_DATE
             , CASE WHEN ACTUAL_FLAG = 'Y' THEN 1       ELSE 9        END
             , CASE WHEN ACTUAL_FLAG = 'Y' THEN WO_DESC  ELSE WO_DESC  END  -- 기확정 최근 WORK 부터 MAPPING 
        
      OPEN C_PSI_AMEND_FACTORY_FIX
      
      WHILE 1 = 1
      BEGIN
        
        FETCH C_PSI_AMEND_FACTORY_FIX
        INTO  @C_WORK_ORDER_ID
            , @C_FACTORY_ID
            , @C_LINE_ID
            , @C_OPERATION_ID
            , @C_ITEM_ID
            , @C_PLAN_DATE
            , @C_PLAN_QTY
            , @C_WO_STATUS
            , @C_PRODUCTION_TYPE
            , @C_MARKET
            , @C_ACTUAL_FLAG
            , @C_TOP_ITEM_ID
    
        IF @@FETCH_STATUS <> 0					-- FETCH 레코드 없으면 LOOP 탈출
          BREAK
        
        
        WHILE 1 = 1
        BEGIN

            SET @S_WORK_ORDER_ID = 'NULL'

            SELECT TOP 1 
                   @S_WORK_ORDER_ID = A.WORK_ORDER_ID
                 , @S_PLAN_QTY      = A.NEW_PLAN_QTY
                 , @S_PLAN_IN_QTY   = ( CASE WHEN CEILING(A.NEW_PLAN_QTY / A.YIELD) > A.PLAN_IN_QTY THEN A.PLAN_IN_QTY
                                             ELSE CEILING(A.NEW_PLAN_QTY / A.YIELD)
                                        END  )
            FROM   (
                    SELECT A.*
                         , CASE WHEN PLAN_QTY > @C_PLAN_QTY THEN @C_PLAN_QTY 
                                                            ELSE PLAN_QTY 
                           END  AS NEW_PLAN_QTY
                         , CASE WHEN B.YIELD IS NULL  THEN 1
                                WHEN B.YIELD = 0      THEN 1
                                                      ELSE B.YIELD
                           END  AS YIELD
                    FROM   TH_BUF_SCM_PLAN_FACTORY A WITH(NOLOCK)
                           LEFT OUTER JOIN SCM_YIELD_M B WITH(NOLOCK)
                                ON    A.COMPANY_ID    = B.COMPANY_ID
                                AND   A.DIVISION_ID   = B.DIVISION_ID
                                AND   A.SITE_ID       = B.SITE_ID
                                AND   A.PLANT_ID      = B.PLANT_ID
                                AND   A.FACTORY_ID    = B.FACTORY_ID
                                AND   A.OPERATION_ID  = B.OPERATION_ID
                                AND   A.LINE_ID       = B.LINE_ID
                                AND   A.ITEM_ID       = B.ITEM_ID
                                AND   CONVERT(NVARCHAR(6), PLAN_DATE, 112) = B.MONTH
                    WHERE  A.INSTANCE_ID        = @v_master_id
                    AND    A.FP_PLAN_ID         = @v_plan_id
                    AND    A.FACTORY_ID         = @C_FACTORY_ID
                    AND    A.LINE_ID            = @C_LINE_ID
                    AND    A.OPERATION_ID       = @C_OPERATION_ID
                    AND    A.ITEM_ID            = @C_ITEM_ID
                    AND    A.PRODUCTION_TYPE    = @C_PRODUCTION_TYPE
                    AND    A.MARKET             = @C_MARKET
                    AND    A.TOP_ITEM_ID        = ISNULL(@C_TOP_ITEM_ID, A.TOP_ITEM_ID)
                    AND    A.PLAN_DATE          = @C_PLAN_DATE          -- 동일 일자 유지
                    AND    A.FIX_WORK_ORDER_ID  IS NULL
                    AND    A.FACTORY_ID         = @v_factory_id
                    AND    A.PLAN_QTY           > 0
                   ) A
            ORDER  BY PLAN_DATE

            IF @S_WORK_ORDER_ID = 'NULL'
              BREAK

            IF    @C_WO_STATUS IN ('OPEN','RUN')              -- OPEN WORK ORDER 중에서 ( AMEND 는 제외 )
              AND @C_ACTUAL_FLAG  = 'Y'                   -- 진행중인 WORK
              BEGIN
              
                INSERT INTO TH_BUF_SCM_PLAN_FACTORY
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
                     , START_TIME
                     , END_TIME
                     , ORG_PLAN_QTY
                     , PLAN_QTY
                     , PLAN_IN_QTY
                     , ITEM_UOM
                     , FIX_TYPE
                     , PRODUCTION_TYPE
                     , BOM_VERSION_ID
                     , SLIT_PLANT_ID
                     , MARKET
                     , MFG_WEEK
                     , DEMAND_DIVISION_ID
                     , PLAN_GROUP_ID
                     , INSERT_ID
                     , INSERT_TIME    
					 , VERSION		-- (D20240509~R0509.01) 
                     , PLM_EC_NO	-- (D20240509~R0509.01) 
                     )
                SELECT
                       INSTANCE_ID
                     , FP_PLAN_ID
                     , COMPANY_ID
                     , DIVISION_ID
                     , SITE_ID
                     , PLANT_ID
                     , FACTORY_ID
, WORK_ORDER_SPL_ID
                     , WORK_ORDER_ID
                     , @C_WORK_ORDER_ID   AS FIX_WORK_ORDER_ID
                     , BATCH_ORDER_ID
                     , BIN_ORDER_ID
                     , ORDER_TYPE
                     , @C_WORK_ORDER_ID   AS SCP_TARGET_ID
                     , @C_WORK_ORDER_ID   AS DEMAND_ID
                     , ITEM_ID
                     , LANE_QTY
                     , TOP_ITEM_ID
                     , @C_WORK_ORDER_ID   AS TOP_WORK_ORDER_ID
                     , LINE_ID
                     , OPERATION_ID
                     , ELECTRODE_TYPE
                     , WORK_CENTER_ID
                     , EQUIPMENT_ID
                     , PLAN_DATE
                     --, DATEADD(MINUTE, 90, START_TIME)   AS START_TIME    -- ACTUAL 은 90분 뒤로 시작시간 생성
                     , START_TIME                                           -- 시업시간으로 설정해 달라는 요청 ( 2018.01.17 : 장현석 D )
                     , END_TIME
                     , ORG_PLAN_QTY
                     , @S_PLAN_QTY        AS PLAN_QTY
                     , @S_PLAN_IN_QTY     AS PLAN_IN_QTY
                     , ITEM_UOM
                     , CASE WHEN @C_WO_STATUS IN ('OPEN','RUN') THEN 'F' ELSE FIX_TYPE END AS FIX_TYPE
                     , PRODUCTION_TYPE
                     , BOM_VERSION_ID
                     , SLIT_PLANT_ID
                     , MARKET
                     , MFG_WEEK
                     , DEMAND_DIVISION_ID
                     , PLAN_GROUP_ID
                     , INSERT_ID
                     , INSERT_TIME  
					 , VERSION		-- (D20240509~R0509.01) 
                     , PLM_EC_NO	-- (D20240509~R0509.01) 
                FROM   TH_BUF_SCM_PLAN_FACTORY A
                WHERE  A.INSTANCE_ID        = @v_master_id
                AND    A.FP_PLAN_ID         = @v_plan_id
                AND    A.WORK_ORDER_ID      = @S_WORK_ORDER_ID
                AND    A.FIX_WORK_ORDER_ID  IS NULL
                
                SET @n_row_count = @n_row_count + @@ROWCOUNT
                
              
                UPDATE TH_BUF_SCM_PLAN_FACTORY
                SET    TH_BUF_SCM_PLAN_FACTORY.PLAN_QTY     = A.PLAN_QTY    - @S_PLAN_QTY
                     , TH_BUF_SCM_PLAN_FACTORY.PLAN_IN_QTY  = A.PLAN_IN_QTY - @S_PLAN_IN_QTY
      FROM   TH_BUF_SCM_PLAN_FACTORY A
                WHERE  A.INSTANCE_ID        = @v_master_id
                AND    A.FP_PLAN_ID         = @v_plan_id
                AND    A.WORK_ORDER_ID      = @S_WORK_ORDER_ID
                AND    A.FIX_WORK_ORDER_ID  IS NULL

                SET @C_PLAN_QTY = @C_PLAN_QTY - @S_PLAN_QTY
                
                -- 1. ACTUAL_FLAG = Y 이면서 DAILY CAPA 를 맞추려면  ( 2일 연속 할당 방지 )
                --    SET @C_PLAN_QTY = 0  으로 설정
                -- 2. 2일에 걸치더라도 ACTUAL_FLAG = Y 인 수량을 유지하려면 아래 주석처리 할것
                SET @C_PLAN_QTY = 0

              END
            ELSE
              BEGIN
                
                -- 수량에 관계없이 순차적으로 확정 WORK ORDER 채번함
                
                UPDATE TH_BUF_SCM_PLAN_FACTORY
                SET    TH_BUF_SCM_PLAN_FACTORY.FIX_WORK_ORDER_ID = @C_WORK_ORDER_ID
                     , TH_BUF_SCM_PLAN_FACTORY.SCP_TARGET_ID     = @C_WORK_ORDER_ID
                     , TH_BUF_SCM_PLAN_FACTORY.DEMAND_ID         = @C_WORK_ORDER_ID
                     , TH_BUF_SCM_PLAN_FACTORY.TOP_WORK_ORDER_ID = @C_WORK_ORDER_ID
                     , TH_BUF_SCM_PLAN_FACTORY.FIX_TYPE          = CASE WHEN @C_WO_STATUS IN ('OPEN','RUN') THEN 'F' 
                                                                        ELSE A.FIX_TYPE 
                                                                   END
                FROM   TH_BUF_SCM_PLAN_FACTORY A
                WHERE  A.INSTANCE_ID        = @v_master_id
                AND    A.FP_PLAN_ID         = @v_plan_id
                AND    A.WORK_ORDER_ID      = @S_WORK_ORDER_ID
     AND    A.FIX_WORK_ORDER_ID  IS NULL
                
                SET @n_row_count = @n_row_count + @@ROWCOUNT

                SET @C_PLAN_QTY = 0

              END
              
          IF @C_PLAN_QTY <= 0
            BREAK

        END
      
      END
      CLOSE C_PSI_AMEND_FACTORY_FIX	
      
      DEALLOCATE C_PSI_AMEND_FACTORY_FIX
      
      --LOG 생성
      SET @v_message = 'C_PSI_AMEND_FACTORY_FIX : ' + CONVERT(NVARCHAR, @n_row_count)
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

      
    END
    
    /*
    BEGIN
    
      UPDATE TH_BUF_SCM_PLAN_FACTORY
      SET    TH_BUF_SCM_PLAN_FACTORY.PLAN_IN_QTY =  CEILING(
                                                            PLAN_QTY / ( CASE WHEN B.YIELD IS NULL  THEN 1
                                                                              WHEN B.YIELD = 0      THEN 1
                                                                                                    ELSE B.YIELD
                                                                         END )
                                                           )
      FROM   TH_BUF_SCM_PLAN_FACTORY A
             LEFT OUTER JOIN SCM_YIELD_M B
                  ON    A.COMPANY_ID    = B.COMPANY_ID
                  AND   A.DIVISION_ID   = B.DIVISION_ID
                  AND   A.SITE_ID       = B.SITE_ID
                  AND   A.PLANT_ID      = B.PLANT_ID
                  AND   A.FACTORY_ID    = B.FACTORY_ID
                  AND   A.OPERATION_ID  = B.OPERATION_ID
                  AND   A.LINE_ID       = B.LINE_ID
                  AND   A.ITEM_ID       = B.ITEM_ID
                  AND   CONVERT(NVARCHAR(6), PLAN_DATE, 112) = B.MONTH
      WHERE  A.INSTANCE_ID    = @v_master_id
      AND    A.FP_PLAN_ID     = @v_plan_id
      AND    A.FACTORY_ID     = @v_factory_id

      SET @n_row_count = @@ROWCOUNT

      --LOG 생성
      SET @v_message = 'PLAN_QTY / YIELD : ' + CONVERT(NVARCHAR, @n_row_count)
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

      /*
      UPDATE TH_BUF_SCM_PLAN_FACTORY
      SET    TH_BUF_SCM_PLAN_FACTORY.PLAN_IN_QTY =  ( CASE WHEN B.INSTANCE_ID IS NULL THEN A.PLAN_IN_QTY
                                                         ELSE ROUND(A.PLAN_IN_QTY / B.ROUND_QTY_UNIT, 0) * B.ROUND_QTY_UNIT
                                                    END
                                                  )
      FROM   TH_BUF_SCM_PLAN_FACTORY A
             LEFT OUTER JOIN (
                              SELECT INSTANCE_ID
                                   , ISNULL(CONVERT(NUMERIC, KEY_VALUE), 1) AS ROUND_QTY_UNIT
                              FROM   FP_INSTANCE_CONFIG_M
                              WHERE  CATEGORY_ID = 'PLAN_CATEGORY'
                              AND    KEY_ID      = 'ROUND_QTY_UNIT'
                             )B
                  ON    A.INSTANCE_ID = B.INSTANCE_ID
      WHERE  A.INSTANCE_ID  = @v_master_id
      AND    A.FP_PLAN_ID   = @v_plan_id
      AND    A.FACTORY_ID     = @v_factory_id
    
      SET @n_row_count = @@ROWCOUNT

      --LOG 생성
      SET @v_message = 'ROUND_QTY_UNIT : ' + CONVERT(NVARCHAR, @n_row_count)
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
      */
      
    END
    */
    
    BEGIN
    
      SET @v_table_name = 'FP_PRODUCTION_PLAN_FACTORY_R'
      
      DELETE FROM FP_PRODUCTION_PLAN_FACTORY_R WHERE INSERT_TIME < DATEADD(DAY, -7, GETDATE())
    
      DELETE FROM FP_PRODUCTION_PLAN_FACTORY_R
      WHERE  INSTANCE_ID    = @v_master_id
      AND    FP_PLAN_ID     = @v_plan_id
      AND    FACTORY_ID     = @v_factory_id      
      
      INSERT INTO FP_PRODUCTION_PLAN_FACTORY_R
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
           , PLAN_GROUP_ID
           , INSERT_ID
           , INSERT_TIME
           , CELL_MATERIAL_ID
           , SETUP_COLOR_CODE
		   , VERSION		-- (D20240509~R0509.01) 
           , PLM_EC_NO		-- (D20240509~R0509.01) 
           )
      SELECT 
             A.INSTANCE_ID
           , A.FP_PLAN_ID
           , A.COMPANY_ID
           , A.DIVISION_ID
           , A.SITE_ID
           , A.PLANT_ID
           , A.FACTORY_ID
           , ISNULL(A.FIX_WORK_ORDER_ID, A.WORK_ORDER_SPL_ID) AS WORK_ORDER_SPL_ID
           , ISNULL(A.FIX_WORK_ORDER_ID, A.WORK_ORDER_ID)     AS WORK_ORDER_ID
           , A.BATCH_ORDER_ID
           , A.BIN_ORDER_ID
           , A.ORDER_TYPE
           , A.SCP_TARGET_ID
           , A.DEMAND_ID
           , A.ITEM_ID
           , MAX(A.LANE_QTY)            AS LANE_QTY
           , A.TOP_ITEM_ID
           , MAX(A.TOP_WORK_ORDER_ID)   AS TOP_WORK_ORDER_ID
           , A.LINE_ID
           , A.OPERATION_ID
           , A.ELECTRODE_TYPE
           , A.WORK_CENTER_ID
           , A.EQUIPMENT_ID
           , MIN(A.PLAN_DATE)           AS PLAN_DATE
           , MIN(A.START_TIME)      AS START_TIME
           , MIN(A.END_TIME)            AS END_TIME
           , SUM(A.PLAN_QTY)            AS PLAN_QTY
      , SUM(A.PLAN_IN_QTY)         AS PLAN_IN_QTY
           , MIN(A.ITEM_UOM)            AS ITEM_UOM
           , SUM(A.ROLL_IN_QTY)         AS ROLL_IN_QTY
           , SUM(A.ROLL_OUT_QTY)        AS ROLL_OUT_QTY
           , SUM(A.JR_IN_QTY)           AS JR_IN_QTY
           , SUM(A.JR_OUT_QTY)          AS JR_OUT_QTY
           , SUM(A.BATCH_QTY)           AS BATCH_QTY
           , SUM(A.BATCH_SUM_QTY)       AS BATCH_SUM_QTY
           , MAX(A.FIX_TYPE)            AS FIX_TYPE
           , A.PRODUCTION_TYPE
           , MIN(A.BOM_VERSION_ID)      AS BOM_VERSION_ID
           , MIN(A.SLIT_PLANT_ID)       AS SLIT_PLANT_ID
           , A.MARKET
           , MIN(A.MFG_WEEK)            AS MFG_WEEK
           , A.DEMAND_DIVISION_ID
           , A.PRODUCTION_TYPE          AS FP_PRODUCTION_TYPE
           , A.PLAN_GROUP_ID
           , @v_proc_name               AS INSERT_ID
           , GETDATE()                  AS INSERT_TIME
           , A.CELL_MATERIAL_ID
           , MAX(A.SETUP_COLOR_CODE)    AS SETUP_COLOR_CODE
		   , A.VERSION		-- (D20240509~R0509.01) 
           , A.PLM_EC_NO	-- (D20240509~R0509.01) 
      FROM   TH_BUF_SCM_PLAN_FACTORY A
      WHERE  A.INSTANCE_ID    = @v_master_id
      AND    A.FP_PLAN_ID     = @v_plan_id
      AND    A.FACTORY_ID     = @v_factory_id
      AND    A.PLAN_QTY       > 0
      GROUP  BY
             A.INSTANCE_ID
           , A.FP_PLAN_ID
   , A.COMPANY_ID
           , A.DIVISION_ID
           , A.SITE_ID
           , A.PLANT_ID
           , A.FACTORY_ID
           , ISNULL(A.FIX_WORK_ORDER_ID, A.WORK_ORDER_SPL_ID)
           , ISNULL(A.FIX_WORK_ORDER_ID, A.WORK_ORDER_ID)
           , A.BATCH_ORDER_ID
           , A.BIN_ORDER_ID
           , A.ORDER_TYPE
           , A.SCP_TARGET_ID
           , A.DEMAND_ID
           , A.ITEM_ID
           , A.TOP_ITEM_ID
           , A.LINE_ID
           , A.OPERATION_ID
           , A.ELECTRODE_TYPE
           , A.WORK_CENTER_ID
           , A.EQUIPMENT_ID
           , A.PRODUCTION_TYPE
           , A.MARKET
           , A.DEMAND_DIVISION_ID
           , A.PLAN_GROUP_ID
           , A.CELL_MATERIAL_ID
		   , A.VERSION		-- (D20240509~R0509.01) 
           , A.PLM_EC_NO	-- (D20240509~R0509.01) 
    
      SET @n_row_count = @@ROWCOUNT
      
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

    END

    BEGIN

      UPDATE A
      SET    A.PRODUCTION_TYPE  = B.SCP_PRODUCTION_TYPE
      FROM   FP_PRODUCTION_PLAN_FACTORY_R A
           , (
              SELECT B.SEGMENT1         AS DIVISION_ID
                   , B.ATTRIBUTE1       AS SCP_PRODUCTION_TYPE
                   , MAX(B.ATTRIBUTE2)  AS FP_PRODUCTION_TYPE
              FROM   SCM_SYS_LOOKUP_TYPE_M A
                   , SCM_SYS_LOOKUP_VALUE  B
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
      AND    A.FACTORY_ID       = @v_factory_id
      AND    A.DIVISION_ID      = B.DIVISION_ID
      AND    A.PRODUCTION_TYPE  = B.FP_PRODUCTION_TYPE
    
      --LOG 생성
      SET @v_message = 'SCP_PRODUCTION_TYPE : ' + CONVERT(NVARCHAR, @n_row_count)
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

    END
    
    IF @@TRANCOUNT > 0
      COMMIT WORK 
    
  END TRY

  BEGIN CATCH
    --ROLLBACK
      IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'C_PSI_AMEND_FACTORY_FIX')
      BEGIN
          CLOSE C_PSI_AMEND_FACTORY_FIX
          DEALLOCATE C_PSI_AMEND_FACTORY_FIX
      END
      
    SET @v_log_code = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
    SET @v_descr = ERROR_MESSAGE()

    EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'ERROR', null, @v_log_code, null, @v_descr
    commit;
  END CATCH

  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null

END
