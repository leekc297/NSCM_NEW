
CREATE       PROCEDURE [dbo].[PR_SCM_RF_RESCHEDULE_FP_AMEND]
@p_master_id nvarchar(MAX) = '-', @p_plan_id nvarchar(MAX) = '-', @p_factory_id nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS
/*************************************************************************************************/
/** 프로그램 ID	: PR_SCM_RF_RESCHEDULE_FP_AMEND													**/
/** 프로그램 명	:																				**/
/** 설 명		:																				**/
/** Version		: 1.0.0																			**/
/**																								**/
/** Argument																					**/
/**																								**/
/** [검색 조건]																					**/
/**																								**/
/** [Biz Logic]																					**/
/**																								**/
/**---------------------------------------------------------------------------------------------**/
/** 작 성 일 자    작 성 자      사     유														**/
/**=============================================================================================**/
/** 2016.01.01    COCHO          최초 작성														**/
/** 2017.06.08    HAJH           KR-CELL  A6000 공정 특화로직 반영 전 원본 소스					**/ 
/** 2020.01.10    LHS		전극 S-TEST 타입 추가												**/  -- (D20200110-R0120.01)
/** 2023.02.19    CYS          전극 버전별 생산계획 수립 및 확정 	**/	-- (D221117~R230219.01)
/** 2025-10-19 	  CYS    	   [E20251019-001993] FP 시스템의 W/O 과실적 방지를 위한 기능변경 건 - 과실적 Flag, next W/O 추가 	**/ 
/** 2025-11-07 	  CYS    	   [E20251022-001010] Slurry ITEM Top Item ID Pancake Item 표시 	**/	
/** 2025.12.05    CYS   		E20251127-001535 / Version 유지 옵션 시 WO 별 버전을 유지 못하는 오류 수정  **/
/** 2026-03-30 	  CYS    	   [E20260313-002101] 과실적 W/O 처리 반영 시 과실적 처리 된(Rolling) W/O 만 사용 	**/
/*************************************************************************************************/
/*
  EXEC PR_SCM_RF_RESCHEDULE_FP_AMEND
  

*/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- 필수 칼럼
  DECLARE @v_master_id      nvarchar(30)
  DECLARE @v_plan_id        nvarchar(30)
  DECLARE @v_factory_id     nvarchar(30)

  -- LOG 용 변수 설정
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_RF_RESCHEDULE_FP_AMEND'
  DECLARE @v_table_name     nvarchar(100)
  DECLARE @v_message        nvarchar(250)
  DECLARE @v_descr          nvarchar(250)
  DECLARE @n_row_count      Integer  = 0
  DECLARE @n_log_count      Integer  = 0
  DECLARE @v_log_code        nvarchar(10)
  DECLARE @sysdate          DATETIME2 = GETDATE()

  -- 사용자 변수 설정
  DECLARE @v_confirm_date   date
        , @v_plan_date      datetime
  DECLARE @v_release_term   Int
  DECLARE @v_release_term_limit_flag nvarchar(5)   = 'N'	
  DECLARE @v_release_term_limit_date date	
  DECLARE @v_next_wo_flag 		nvarchar(5)   = 'N'	-- [E20251019-001993] ADD
  DECLARE @v_max_version_flag   nvarchar(10)	-- [E20251127-001535]	
  

  DECLARE @v_temp1        nvarchar(1000)
  DECLARE @v_temp2        nvarchar(1000)
  
  -------------------------------------------------------------------------------------------

  SET @v_master_id  = @p_master_id
  SET @v_plan_id    = @p_plan_id
  SET @v_factory_id = @p_factory_id

  SET @n_log_count = @n_log_count + 1
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', null

  BEGIN TRY
    
    BEGIN
    
      SET @v_table_name = ''

      --LOG 생성
      SET @v_message = 'FACTORY_ID : ' + @v_factory_id
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, @v_log_code, @v_message, null

      SET @v_table_name = 'SCM_SYS_LOOKUP_VALUE'
      
      -- DEFAULT 값
      SET @v_release_term = 7
      
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

      
      SET @v_table_name = 'SCM_FP_PLAN_H'
      
      SELECT @v_confirm_date  = DATEADD(DAY, @v_release_term, CONVERT(DATE, A.PLAN_START_TIME))
           , @v_plan_date     = CONVERT(DATETIME, CONVERT(DATE, PLAN_START_TIME))
      FROM   SCM_FP_PLAN_H A WITH(NOLOCK)
      WHERE  A.INSTANCE_ID  = @v_master_id
      AND    A.PLAN_ID      = @v_plan_id
      
      --LOG 생성
      SET @v_message = '@v_confirm_date : ' + convert(nvarchar, @v_confirm_date, 23)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

    END
    
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
  		
  		-- [E20251127-001535] 버전 옵션 가져옴
	    SELECT  @v_max_version_flag =  ISNULL(ATTRIBUTE1,'N') 
        FROM   	SCM_SYS_LOOKUP_VALUE WITH(NOLOCK)
        WHERE  	LOOKUP_TYPE_CODE LIKE 'ELEC_INSTANCE_OPTION'
        AND    	active_flag = 'Y'
        AND		SEGMENT1 = @v_master_id
        
		SET @v_message = '@v_v_max_version_flag : ' + @v_max_version_flag
		SET @n_log_count = @n_log_count + 1
		SET @sysdate = GETDATE()
		EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

	END
	
    -------------------------------------------------------------------------------
    -- 2019.03.07 : OPEN W/O 처리 부분 ( TARGET_ELEC 에서 이 곳으로 이관 )
    -------------------------------------------------------------------------------
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
           , ATTRIBUTE12			-- [E20251019-001993]  과실적 대상 Flag ADD
           , ATTRIBUTE13			-- [E20251019-001993]  과실적 대상 WO ADD
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
           , GETDATE()                  AS INSERT_TIME
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
           , GETDATE()                  AS INSERT_TIME
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
      SET    A.WO_STATUS    = ( CASE WHEN B.ATTRIBUTE9 = 'Y'  OR  ( @v_next_wo_flag = 'Y' AND B.ATTRIBUTE12 = 'Y')  THEN 'CANCEL'	-- [E20251019-001993]  과실적 대상 Flag 도 close 추가, 0으로 보내더라도 MES_WO 에서 실적 수량 맞춰줌
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
                   , CASE WHEN @v_max_version_flag = 'Y' THEN		-- [E20251127-001535] Version 유지
							                    DENSE_RANK() OVER (PARTITION BY A.PLAN_DATE          -- 동일 일자
							                                                   , A.FACTORY_ID         -- 동일 동
							                                                   , A.LINE_ID            -- 동일 라인
							                                                   , A.OPERATION_ID       -- 동일 OPERATION
							                                                   , A.ELECTRODE_TYPE     -- 동일 TYPE
							                                    			   , A.EQUIPMENT_ID       -- 동일 설비
							                                                   , A.TOP_ITEM_ID        -- 동일 TOP_ITEM
							                                                   , A.ITEM_ID            -- 동일 ITEM
							                                                   , A.PRODUCTION_TYPE    -- 동일 PRODUCTION_TYPE
							                                                   , A.MARKET             -- 동일 MARKET
							                                                   , A.WORK_REQUEST_MODEL_ID		-- [E20251127-001535]
							                                                   , A.VERSION						-- [E20251127-001535]	
							                                        ORDER     BY A.WORK_ORDER_ID DESC
							                                       )           -- 가장 최근 WORK 이 1번
							              ELSE
						                      	DENSE_RANK() OVER (PARTITION BY A.PLAN_DATE          -- 동일 일자
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
							                                       ) 
	                 END AS DESC_SEQ                    -- 가장 최근 WORK 이 1번
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
      -- 2019.01.04 : RELEASE 구간 밖의 OPEN WO 취소 로직
      ------------------------------------------------------------------------------------
      UPDATE A
      SET    A.WO_STATUS    = 'CANCEL'
      FROM   FP_DAILY_INSTANCE_ORDER_STATUS A
      WHERE  A.INSTANCE_ID  = @v_master_id
      AND    A.FP_PLAN_ID   = @v_plan_id
      AND    A.FACTORY_ID   = @v_factory_id
      AND    A.PLAN_DATE    > @v_confirm_date
      AND    A.WO_STATUS IN ( 'OPEN', 'RUN' )

      --LOG 생성
      SET @v_message = 'WO_STATUS = CANCEL / PLAN_DATE > @v_confirm_date : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
      
      /*
        임시 0314 외수 E0500 소형전극 선분산 취소 ( 이미배포해서 )
      */
      /*UPDATE A
      SET    A.WO_STATUS    = 'CANCEL'
      FROM   FP_DAILY_INSTANCE_ORDER_STATUS A
      WHERE  A.INSTANCE_ID  = @v_master_id
      AND    A.FP_PLAN_ID   = @v_plan_id
      AND    A.FACTORY_ID   = @v_factory_id
      AND    A.PLAN_DATE    > @v_confirm_date
      AND    A.WO_STATUS IN ( 'OPEN', 'RUN' )
      AND    A.INSTANCE_ID = 'CN_E_PRE_M'
      --AND    A.MARKET = 'E'
      AND    A.OPERATION_ID = 'E0500' */

    END
    

    BEGIN
    
      -- Coat / Mix 머지를 
      -- Coat 생성 후 이를 기반으로 1 : 1 로 Mix를 생성함
      
      SET @v_table_name = 'PR_SCM_OF_COAT_WO_PEGGING'

      ---------------------------------------------------------------------------------------
      -- 2018.06.27 : FACTORY 에 MIXER 설비가 1대인 LINE 과
      --                                      2대인 LINE 이 동일한 FACTORY 에 존재함. ( E7 )
      --              그레서 프로시저 통합함
      ---------------------------------------------------------------------------------------
      
      EXEC PR_SCM_OF_COAT_WO_PEGGING  @v_master_id, @v_plan_id, @v_factory_id
      
      /*
      IF CHARINDEX('E_PRE', @v_master_id) > 0 or --1
         CHARINDEX('SRS',   @v_master_id) > 0
         
        begin
          -- @v_factory_id 에 따라 로직 분리 함
          IF @v_factory_id = 'E4' or
             @v_factory_id = 'EA'    -- 20170713 add
            BEGIN
              EXEC PR_SCM_OF_COAT_WO_MERGE_ONETWO_E4_ALLNEW  @v_master_id, @v_plan_id, @v_factory_id
            END
          ELSE
            BEGIN
              EXEC PR_SCM_OF_COAT_WO_MERGE_ONEONE_ETC_ALLNEW  @v_master_id, @v_plan_id, @v_factory_id
            END
        end
      else
        begin
          EXEC PR_SCM_OF_COAT_WO_MERGE__ALLNEW  @v_master_id, @v_plan_id, @v_factory_id
        end  
      */
      
    END
  
    BEGIN
      
	 	-- 환산자별 PROD_SEQ 를 일괄 UPDATE 해준다. -- (D221117~R230219.01)
		UPDATE	A
		SET		A.PROD_SEQ = B.PROD_SEQ
		FROM    FP_AMEND_PRODUCTION_PLAN_R A
			  , ( 
					  SELECT A.FACTORY_ID, A.ITEM_ID, A.MODEL_ID, A.VERSION, MAX(A.PROD_SEQ) AS PROD_SEQ
					  FROM	SCM_ITEM_CONV_CALC_M A WITH(NOLOCK)
							,(
								SELECT *
								FROM FP_INSTANCE_INFO_V
								WHERE 1=1
								AND INSTANCE_ID = @v_master_id
							) B
					  WHERE 1=1
					  AND  A.COMPANY_ID = B.COMPANY_ID
					  AND  A.DIVISION_ID = B.DIVISION_ID
					  AND  A.SITE_ID = B.SITE_ID
					  AND  A.PLANT_ID = B.PLANT_ID
					  AND  A.FACTORY_ID = B.RELEASE_GROUP
					  AND  A.CATEGORY = 'LANE NUMBER'
					  GROUP BY A.FACTORY_ID, A.ITEM_ID, A.MODEL_ID, A.VERSION
				) B
		WHERE	1=1
		AND		A.MASTER_ID = @v_master_id
		AND		A.PLAN_ID = @v_plan_id
		AND		A.AFTER_SITE_ID = B.FACTORY_ID
		AND		A.TOP_ITEM_ID = B.ITEM_ID
		AND		A.WORK_REQUEST_MODEL_ID = B.MODEL_ID
		AND		A.VERSION = B.VERSION
		
	  SET @v_message = 'PROD_SEQ_1 : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
      SET @n_log_count += 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null 
     
      -- 환산자별 PROD_SEQ 를 동구분 없이 일괄 UPDATE 해준다. -- (D221117~R230219.01)
		UPDATE	A
		SET		A.PROD_SEQ = B.PROD_SEQ
		FROM    FP_AMEND_PRODUCTION_PLAN_R A
			  , ( 
					  SELECT A.ITEM_ID, A.MODEL_ID, A.VERSION, MAX(A.PROD_SEQ) AS PROD_SEQ
					  FROM	SCM_ITEM_CONV_CALC_M A WITH(NOLOCK)
							,(
								SELECT *
								FROM FP_INSTANCE_INFO_V
								WHERE 1=1
								AND INSTANCE_ID = @v_master_id
							) B
					  WHERE 1=1
					  AND  A.COMPANY_ID = B.COMPANY_ID
					  AND  A.DIVISION_ID = B.DIVISION_ID
					  AND  A.SITE_ID = B.SITE_ID
					  AND  A.PLANT_ID = B.PLANT_ID
					  AND  A.FACTORY_ID = B.RELEASE_GROUP
					  AND  A.CATEGORY = 'LANE NUMBER'
					  GROUP BY A.ITEM_ID, A.MODEL_ID, A.VERSION
				) B
		WHERE	1=1
		AND		A.MASTER_ID = @v_master_id
		AND		A.PLAN_ID = @v_plan_id
		AND		A.TOP_ITEM_ID = B.ITEM_ID
		AND		A.WORK_REQUEST_MODEL_ID = B.MODEL_ID
		AND		A.VERSION = B.VERSION
		AND     A.PROD_SEQ IS NULL
		
	  SET @v_message = 'PROD_SEQ_2 : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
      SET @n_log_count += 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null 
      
     -- FP_AMEND_PRODUCTION_PLAN_R
      -- S-TEST - TEST 변환
      UPDATE A
      SET    A.DEMAND_TYPE  = B.SCP_PRODUCTION_TYPE
      FROM   FP_AMEND_PRODUCTION_PLAN_R A
           , (
              SELECT B.SEGMENT1         AS DIVISION_ID
                   , B.ATTRIBUTE1       AS SCP_PRODUCTION_TYPE   ---+ 'TEST' 
                   , MAX(B.ATTRIBUTE2)  AS FP_PRODUCTION_TYPE    ---+ 'S-TEST' 
              FROM   SCM_SYS_LOOKUP_TYPE_M A WITH(NOLOCK)
                   , SCM_SYS_LOOKUP_VALUE  B WITH(NOLOCK)
              WHERE  A.LOOKUP_TYPE_CODE = 'DIVISION_DEMAND_TYPE'
              AND    A.LOOKUP_TYPE_CODE = B.LOOKUP_TYPE_CODE
              AND    B.ATTRIBUTE3       = 'Y'                 -- SCP TARGET FLAG
              AND    A.ACTIVE_FLAG      = 'Y'
              AND    B.ACTIVE_FLAG      = 'Y'
              GROUP  BY B.SEGMENT1, B.ATTRIBUTE1
              HAVING B.ATTRIBUTE1 <> MAX(B.ATTRIBUTE2)
            ) B
      WHERE  A.MASTER_ID      = @v_master_id 
      AND    A.PLAN_ID        = @v_plan_id
      AND    A.AFTER_SITE_ID  = @v_factory_id
      AND    A.DEMAND_TYPE    = B.FP_PRODUCTION_TYPE
      
      SET @v_message = @@ROWCOUNT
      SET @n_log_count += 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null 

      ---------------------------------------------------------------------------------------
      -- FP_DAILY_PRODUCTION_PLAN_R 
      ---------------------------------------------------------------------------------------
      SET @v_table_name = 'FP_DAILY_PRODUCTION_PLAN_R'
      
      -- DAILY_PRODUCTION_PLAN_R
      DELETE FROM FP_DAILY_PRODUCTION_PLAN_R
      WHERE  INSTANCE_ID  = @v_master_id
      AND    FP_PLAN_ID   = @v_plan_id
      AND    FACTORY_ID   = @v_factory_id

      SET @v_message = @@ROWCOUNT
      SET @n_log_count += 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null 

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
           , CELL_IN_QTY
           , CELL_OUT_QTY
           , BATCH_IN_QTY
           , BATCH_OUT_QTY
           , FIX_TYPE
           , PRODUCTION_TYPE
           , TOTAL_WORKING_TIME
           , LINE_ITEM_SEQ
           , OPERATION_ITEM_SEQ
           , LANE_QTY
           , LANE_TACT_QTY
           , BATCH_ORDER_ID
           , BIN_ORDER_ID
         , MFG_WEEK
           , DEMAND_DIVISION_ID
           , MARKET
           , FP_PRODUCTION_TYPE
           , FULL_CLEANING_FLAG
           , MODEL_TYPE_CHANGE_FLAG
           , SEQ
           , INSERT_ID
           , INSERT_DTTM
           , CALC_TYPE
           , CALC_VERSION
           , TOTAL_BATCH
           , PIG_CLEANING_FLAG
      , SETUP_COLOR_CODE
           , WORK_REQUEST_MODEL_ID    -- (D221117~R230219.01)
           , VERSION    -- (D221117~R230219.01)
           , PROD_SEQ    -- (D221117~R230219.01)
           , PLM_EC_NO    -- (D221117~R230219.01)
           )          
      SELECT 
             A.MASTER_ID
           , A.PLAN_ID
           , C.COMPANY_ID
           , C.DIVISION_ID
           , C.SITE_ID
           , C.PLANT_ID
           , A.AFTER_SITE_ID            AS FACTORY_ID
           , A.WORK_ORDER_ID            AS WORK_ORDER_SPL_ID
           , A.WORK_ORDER_ID
           , ISNULL(B.SCP_TARGET_ID, A.DEMAND_ID) AS SCP_TARGET_ID
           , A.DEMAND_ID
           , A.ITEM_ID
           , ISNULL(B.ITEM_ID, ISNULL(A.TOP_ITEM_ID, A.ITEM_ID) )         AS TOP_ITEM_ID		-- [E20251022-001010] A.Item_id 를 top_item_id 로 변경 (TEST Target 제외)
           , A.AFTER_OPERATION_ID             AS OPERATION_ID
           , A.AFTER_ROUTE_ID                 AS LINE_ID
           , ISNULL(D.ELECTRODE_TYPE, E.ELECTRODE_TYPE) AS ELECTRODE_TYPE
           , A.AFTER_RESOURCE_ID              AS EQUIPMENT_ID
           , CONVERT(DATETIME, A.AFTER_PLAN_DATE)                             AS PLAN_DATE
           , CONVERT(DATETIME, SUBSTRING(A.AFTER_START_TIME, 1, 4) 
                               + '-' + SUBSTRING(A.AFTER_START_TIME, 5, 2)
                               + '-' + SUBSTRING(A.AFTER_START_TIME, 7, 2)
                               + ' ' + SUBSTRING(A.AFTER_START_TIME, 9, 2)
                               + ':' + SUBSTRING(A.AFTER_START_TIME, 11, 2)
                               + ':' + SUBSTRING(A.AFTER_START_TIME, 13, 2))  AS START_TIME
           , CONVERT(DATETIME, SUBSTRING(A.AFTER_END_TIME, 1, 4) 
                               + '-' + SUBSTRING(A.AFTER_END_TIME, 5, 2)
                               + '-' + SUBSTRING(A.AFTER_END_TIME, 7, 2)
                               + ' ' + SUBSTRING(A.AFTER_END_TIME, 9, 2)
                               + ':' + SUBSTRING(A.AFTER_END_TIME, 11, 2)
                               + ':' + SUBSTRING(A.AFTER_END_TIME, 13, 2))    AS AFTER_END_TIME
           , A.AFTER_QTY
           , A.AFTER_IN_QTY
           , A.ITEM_UOM
           , A.ROLL_IN_QTY
   , A.ROLL_QTY                 AS ROLL_OUT_QTY
           , A.JR_IN_QTY
           , A.JR_QTY                   AS JR_OUT_QTY
           , A.CELL_IN_QTY
           , A.CELL_QTY                 AS CELL_OUT_QTY
           , A.BATCH_IN_QTY
           , A.BATCH_QTY                AS BATCH_OUT_QTY
           , CASE WHEN A.FIXED_YN = 'Y' THEN 'F' ELSE 'P' END AS FIX_TYPE
           , A.DEMAND_TYPE              AS PRODUCTION_TYPE
           , 0 TOTAL_WORKING_TIME
           , 1 LINE_ITEM_SEQ
           , 1 OPERATION_ITEM_SEQ
           , A.LANE_QTY
           , A.LANE_TACT_QTY
           , A.BATCH_ORDER_ID
           , '-'                        AS BIN_ORDER_ID
           , A.MFG_WEEK
           , C.DIVISION_ID              AS DEMAND_DIVISION_ID
           , A.MARKET
           , A.FP_PRODUCTION_TYPE       AS FP_PRODUCTION_TYPE  ---(20200110) DEMAND_TYPE에서 FP_PRODUCTION_TYPE로 변경.
           , A.FULL_CLEANING_FLAG
           , A.MODEL_TYPE_CHANGE_FLAG
           , A.AFTER_SEQ
           , @v_proc_name               AS INSERT_ID
           , GETDATE()                  AS INSERT_DATE
           , A.CALC_TYPE
           , A.CALC_VERSION
           , A.TOTAL_BATCH
           , A.PIG_CLEANING_FLAG
           , A.SETUP_COLOR_CODE
           , A.WORK_REQUEST_MODEL_ID    -- (D221117~R230219.01)
           , A.VERSION    -- (D221117~R230219.01)
           , A.PROD_SEQ    -- (D221117~R230219.01)
           , A.PLM_EC_NO    -- (D221117~R230219.01)
      FROM   FP_AMEND_PRODUCTION_PLAN_R A WITH(NOLOCK)
             LEFT OUTER JOIN FP_DAILY_NET_DEMAND_H B WITH(NOLOCK)
                  ON    1=1
                  AND   A.MASTER_ID      = B.INSTANCE_ID
                  AND   A.PLAN_ID        = B.DPP_PLAN_ID
                 AND   A.DEMAND_ID      = B.FP_DEMAND_ID
             LEFT OUTER JOIN (
                              SELECT 
									 --DISTINCT
                                     COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, 
                                     MIN(WORK_CENTER_ID) AS WORK_CENTER_ID,
                                     LINE_ID +'_'+OPERATION_ID
                                               +CASE ELECTRODE_TYPE 
                                                    WHEN NULL   THEN '' 
                                                    WHEN ''     THEN '' 
                                                    WHEN '-'    THEN '' 
                                                    ELSE '_'+ELECTRODE_TYPE 
                                                END  AS RESOURCE_ID
                              FROM   SCM_EQUIPMENT_M WITH(NOLOCK)
                              WHERE  EQUIPMENT_TYPE = 'M'
							  AND	 ACTIVE_FLAG = 'Y'
                              GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE
                             ) D
                  ON    A.AFTER_SITE_ID       = D.FACTORY_ID
                  AND   A.AFTER_ROUTE_ID      = D.LINE_ID
                  AND   A.AFTER_OPERATION_ID  = D.OPERATION_ID
                  AND   A.AFTER_RESOURCE_ID   = D.RESOURCE_ID
             LEFT OUTER JOIN (
                              SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, 
                                     WORK_CENTER_ID, 
                                     EQUIPMENT_ID AS RESOURCE_ID
                              FROM   SCM_EQUIPMENT_M WITH(NOLOCK)
                              WHERE  EQUIPMENT_TYPE = 'M'
							  AND	 ACTIVE_FLAG = 'Y'
                             ) E
                  ON    A.AFTER_SITE_ID       = E.FACTORY_ID
                  AND   A.AFTER_ROUTE_ID      = E.LINE_ID
                  AND   A.AFTER_OPERATION_ID  = E.OPERATION_ID
                  AND   A.AFTER_RESOURCE_ID   = E.RESOURCE_ID
           , SCM_FACTORY_M C WITH(NOLOCK)
      WHERE  A.MASTER_ID      = @v_master_id
      AND    A.PLAN_ID        = @v_plan_id
      AND    A.AFTER_SITE_ID  = @v_factory_id
      AND    A.AFTER_SITE_ID  = C.FACTORY_ID

      SET @n_row_count = @@ROWCOUNT
      
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null


      ---------------------------------------------------------------------------------------
      -- FP_PRODUCTION_PLAN_R 
      ---------------------------------------------------------------------------------------

      SET @v_table_name = 'FP_PRODUCTION_PLAN_R'

      -- FP_PRODUCTION_PLAN_R
      DELETE FROM FP_PRODUCTION_PLAN_R
      WHERE  INSTANCE_ID = @v_master_id
      AND    FP_PLAN_ID = @v_plan_id
      AND    FACTORY_ID = @v_factory_id

      SET @v_message = @@ROWCOUNT
      SET @n_log_count += 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null 

      INSERT INTO FP_PRODUCTION_PLAN_R
           (
             INSTANCE_ID
           , FP_PLAN_ID
           , COMPANY_ID
           , DIVISION_ID
           , SITE_ID
           , PLANT_ID
           , FACTORY_ID
           --, WORK_ORDER_SPL_ID
           , WORK_ORDER_ID
           , BATCH_ORDER_ID
           , BIN_ORDER_ID
           , ORDER_TYPE
           , SCP_TARGET_ID
           , DEMAND_ID
           , ITEM_ID
           , LANE_QTY
           , TOP_ITEM_ID
           , LINE_ID
           , OPERATION_ID
           , ELECTRODE_TYPE
           , WORK_CENTER_ID
           --, EQUIPMENT_ID
           , PLAN_DATE
           , START_TIME
           , END_TIME
           , PLAN_QTY
           , PLAN_IN_QTY
           , ROLL_IN_QTY
           , ROLL_OUT_QTY
           , JR_IN_QTY
           , JR_OUT_QTY
           , BATCH_QTY
           , FIX_TYPE
           , PRODUCTION_TYPE
           , MARKET
           , LANE_TACT_QTY
           , MFG_WEEK
           , DEMAND_DIVISION_ID
		   , FP_PRODUCTION_TYPE   ---(20200110) ADD
           , INSERT_ID
           , INSERT_TIME
           , WORK_REQUEST_MODEL_ID    -- (D221117~R230219.01)
           , VERSION    -- (D221117~R230219.01)
           , PROD_SEQ    -- (D221117~R230219.01)
           , PLM_EC_NO    -- (D221117~R230219.01)
           )
      SELECT       
             A.MASTER_ID
           , A.PLAN_ID
           , C.COMPANY_ID
           , C.DIVISION_ID
           , C.SITE_ID
           , C.PLANT_ID
           , A.AFTER_SITE_ID         AS FACTORY_ID
           , A.WORK_ORDER_ID
           , A.BATCH_ORDER_ID
           , '-' BIN_ORDER_ID
           , A.ORDER_TYPE
           , ISNULL(B.SCP_TARGET_ID, A.DEMAND_ID) AS SCP_TARGET_ID
           , A.DEMAND_ID
           , A.ITEM_ID
           , A.LANE_QTY
           , A.TOP_ITEM_ID
           , A.AFTER_ROUTE_ID        AS LINE_ID
           , A.AFTER_OPERATION_ID
           , ISNULL(D.ELECTRODE_TYPE, E.ELECTRODE_TYPE) AS ELECTRODE_TYPE
           , ISNULL(D.WORK_CENTER_ID, E.WORK_CENTER_ID) AS WORK_CENTER_ID
           , CONVERT(DATETIME, A.AFTER_PLAN_DATE)                             AS PLAN_DATE
           , CONVERT(DATETIME, SUBSTRING(A.AFTER_START_TIME, 1, 4) 
                               + '-' + SUBSTRING(A.AFTER_START_TIME, 5, 2)
                               + '-' + SUBSTRING(A.AFTER_START_TIME, 7, 2)
                               + ' ' + SUBSTRING(A.AFTER_START_TIME, 9, 2)
                               + ':' + SUBSTRING(A.AFTER_START_TIME, 11, 2)
                               + ':' + SUBSTRING(A.AFTER_START_TIME, 13, 2))  AS START_TIME
           , CONVERT(DATETIME, SUBSTRING(A.AFTER_END_TIME, 1, 4) 
                               + '-' + SUBSTRING(A.AFTER_END_TIME, 5, 2)
                               + '-' + SUBSTRING(A.AFTER_END_TIME, 7, 2)
                          + ' ' + SUBSTRING(A.AFTER_END_TIME, 9, 2)
                               + ':' + SUBSTRING(A.AFTER_END_TIME, 11, 2)
                               + ':' + SUBSTRING(A.AFTER_END_TIME, 13, 2))    AS AFTER_END_TIME
           , A.AFTER_QTY
           , A.AFTER_IN_QTY
           , A.ROLL_IN_QTY
           , A.ROLL_QTY       AS ROLL_OUT_QTY
           , A.JR_IN_QTY
           , A.JR_QTY         AS JR_OUT_QTY
           , A.BATCH_QTY
           , CASE WHEN A.FIXED_YN = 'Y' THEN 'F' ELSE 'P' END AS FIX_TYPE
           , A.DEMAND_TYPE       AS PRODUCTION_TYPE
           , A.MARKET
           , A.LANE_TACT_QTY
           , A.MFG_WEEK
           , C.DIVISION_ID   AS DEMAND_DIVISION_ID
		   , A.FP_PRODUCTION_TYPE    ---(20200110) ADD 
           , @v_proc_name    AS INSERT_ID
           , GETDATE()       AS INSERT_TIME
           , A.WORK_REQUEST_MODEL_ID    -- (D221117~R230219.01)
           , A.VERSION    -- (D221117~R230219.01)
           , A.PROD_SEQ    -- (D221117~R230219.01)
           , A.PLM_EC_NO    -- (D221117~R230219.01)
      FROM   FP_AMEND_PRODUCTION_PLAN_R A WITH(NOLOCK)
             LEFT OUTER JOIN FP_DAILY_NET_DEMAND_H B WITH(NOLOCK)
                  ON    1=1
                  AND   A.MASTER_ID      = B.INSTANCE_ID
                  AND   A.PLAN_ID        = B.DPP_PLAN_ID
                  AND   A.DEMAND_ID      = B.FP_DEMAND_ID
             LEFT OUTER JOIN (
                              SELECT 
									 --DISTINCT
                                     COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, 
                                     MIN(WORK_CENTER_ID) AS WORK_CENTER_ID,
                                     LINE_ID +'_'+OPERATION_ID
                                               +CASE ELECTRODE_TYPE 
                                                    WHEN NULL   THEN '' 
                                                    WHEN ''     THEN '' 
                                                    WHEN '-'    THEN '' 
                                                    ELSE '_'+ELECTRODE_TYPE 
                                                END  AS RESOURCE_ID
                              FROM   SCM_EQUIPMENT_M WITH(NOLOCK)
                              WHERE  1=1
							  AND	 ACTIVE_FLAG = 'Y'
							  AND	 EQUIPMENT_TYPE = 'M'
                              GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE
                             ) D
                  ON    A.AFTER_SITE_ID       = D.FACTORY_ID
                  AND   A.AFTER_ROUTE_ID      = D.LINE_ID
                  AND   A.AFTER_OPERATION_ID  = D.OPERATION_ID
                  AND   A.AFTER_RESOURCE_ID   = D.RESOURCE_ID
             LEFT OUTER JOIN (
                              SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, 
                                     WORK_CENTER_ID, 
                                     EQUIPMENT_ID AS RESOURCE_ID
                              FROM   SCM_EQUIPMENT_M WITH(NOLOCK)
                              WHERE  1=1
							  AND	 ACTIVE_FLAG = 'Y'
							  AND	 EQUIPMENT_TYPE = 'M'
                             ) E
                  ON    A.AFTER_SITE_ID       = E.FACTORY_ID
                  AND   A.AFTER_ROUTE_ID      = E.LINE_ID
                  AND   A.AFTER_OPERATION_ID  = E.OPERATION_ID
                  AND   A.AFTER_RESOURCE_ID   = E.RESOURCE_ID
           , SCM_FACTORY_M C WITH(NOLOCK)
      WHERE  A.MASTER_ID      = @v_master_id
      AND    A.PLAN_ID        = @v_plan_id
      AND    A.AFTER_SITE_ID  = @v_factory_id
      AND    A.AFTER_SITE_ID  = C.FACTORY_ID

      SET @n_row_count = @@ROWCOUNT
      
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null


      ---------------------------------------------------------------------------------------
      -- FP_PRODUCTION_PLAN_EQUIPMENT_R 
      ---------------------------------------------------------------------------------------
      SET @v_table_name = 'FP_PRODUCTION_PLAN_EQUIPMENT_R'

      -- FP_PRODUCTION_PLAN_R
      DELETE FROM FP_PRODUCTION_PLAN_EQUIPMENT_R
      WHERE  INSTANCE_ID  = @v_master_id
      AND    FP_PLAN_ID   = @v_plan_id
      AND    FACTORY_ID   = @v_factory_id
      
      SET @v_message = @@ROWCOUNT
      SET @n_log_count += 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null 

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
           , ROLL_IN_QTY
           , ROLL_OUT_QTY
       , JR_IN_QTY
           , JR_OUT_QTY
           , BATCH_QTY
           , FIX_TYPE         
           , PRODUCTION_TYPE  
           , BOM_VERSION_ID   
           , MARKET
           , MFG_WEEK
           , DEMAND_DIVISION_ID
		   , FP_PRODUCTION_TYPE   ---(20200110) ADD 
           , INSERT_ID        
           , INSERT_TIME   
           , WORK_REQUEST_MODEL_ID    -- (D221117~R230219.01)
           , VERSION    -- (D221117~R230219.01)
           , PROD_SEQ    -- (D221117~R230219.01)
           , PLM_EC_NO    -- (D221117~R230219.01)
           )
      SELECT  
             A.MASTER_ID
           , A.PLAN_ID
           , C.COMPANY_ID
           , C.DIVISION_ID
           , C.SITE_ID
           , C.PLANT_ID
           , A.AFTER_SITE_ID      AS FACTORY_ID
           , A.WORK_ORDER_ID      AS WORK_ORDER_SPL_ID
           , A.WORK_ORDER_ID
           , A.BATCH_ORDER_ID
           , '-' BIN_ORDER_ID
           , A.ORDER_TYPE     ---+ 'W'
           , ISNULL(B.SCP_TARGET_ID, A.DEMAND_ID) AS SCP_TARGET_ID
           , A.DEMAND_ID
           , A.ITEM_ID
           , A.LANE_QTY
           , A.TOP_ITEM_ID         AS TOP_ITEM_ID
           , A.WORK_ORDER_ID       AS TOP_WORK_ORDER_ID
           , A.AFTER_ROUTE_ID      AS LINE_ID
           , A.AFTER_OPERATION_ID  AS OPERATION_ID
           , ISNULL(D.ELECTRODE_TYPE, E.ELECTRODE_TYPE) AS ELECTRODE_TYPE
           , ISNULL(D.WORK_CENTER_ID, E.WORK_CENTER_ID) AS WORK_CENTER_ID
           , A.AFTER_RESOURCE_ID   AS EQUIPMENT_ID
           , CONVERT(DATETIME, A.AFTER_PLAN_DATE)                             AS PLAN_DATE
           , CONVERT(DATETIME, SUBSTRING(A.AFTER_START_TIME, 1, 4) 
                               + '-' + SUBSTRING(A.AFTER_START_TIME, 5, 2)
                               + '-' + SUBSTRING(A.AFTER_START_TIME, 7, 2)
                               + ' ' + SUBSTRING(A.AFTER_START_TIME, 9, 2)
                               + ':' + SUBSTRING(A.AFTER_START_TIME, 11, 2)
                               + ':' + SUBSTRING(A.AFTER_START_TIME, 13, 2))  AS START_TIME
           , CONVERT(DATETIME, SUBSTRING(A.AFTER_END_TIME, 1, 4) 
                               + '-' + SUBSTRING(A.AFTER_END_TIME, 5, 2)
                               + '-' + SUBSTRING(A.AFTER_END_TIME, 7, 2)
                               + ' ' + SUBSTRING(A.AFTER_END_TIME, 9, 2)
                               + ':' + SUBSTRING(A.AFTER_END_TIME, 11, 2)
                               + ':' + SUBSTRING(A.AFTER_END_TIME, 13, 2))    AS AFTER_END_TIME
           , A.AFTER_QTY     AS PLAN_QTY
           , A.AFTER_IN_QTY  AS PLAN_IN_QTY
           , A.ROLL_IN_QTY
           , A.ROLL_QTY       AS ROLL_OUT_QTY
           , A.JR_IN_QTY
           , A.JR_QTY         AS JR_OUT_QTY
           , A.BATCH_QTY
           , CASE WHEN A.FIXED_YN = 'Y' THEN 'F' ELSE 'P' END AS FIX_TYPE
           , A.DEMAND_TYPE      AS PRODUCTION_TYPE
           , NULL AS BOM_VERSION_ID
           , A.MARKET
           , A.MFG_WEEK
           , C.DIVISION_ID   AS DEMAND_DIVISION_ID
		   , A.FP_PRODUCTION_TYPE                  ---(20200110) ADD 
           , @v_proc_name    AS INSERT_ID
           , GETDATE()       AS INSERT_TIME
           , A.WORK_REQUEST_MODEL_ID    -- (D221117~R230219.01)
           , A.VERSION    -- (D221117~R230219.01)
           , A.PROD_SEQ    -- (D221117~R230219.01)
           , A.PLM_EC_NO    -- (D221117~R230219.01)
      FROM   FP_AMEND_PRODUCTION_PLAN_R A WITH(NOLOCK)
             LEFT OUTER JOIN FP_DAILY_NET_DEMAND_H B WITH(NOLOCK)
                  ON    1=1
                  AND   A.MASTER_ID      = B.INSTANCE_ID
                  AND   A.PLAN_ID        = B.DPP_PLAN_ID
                  AND   A.DEMAND_ID      = B.FP_DEMAND_ID
             LEFT OUTER JOIN (
                              SELECT 
									 --DISTINCT
                                     COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, 
                                     MIN(WORK_CENTER_ID) AS WORK_CENTER_ID,
                                     LINE_ID +'_'+OPERATION_ID
                                               +CASE ELECTRODE_TYPE 
                                                    WHEN NULL   THEN '' 
                                                    WHEN ''     THEN '' 
                                                    WHEN '-'    THEN '' 
                                                    ELSE '_'+ELECTRODE_TYPE 
                                                END  AS RESOURCE_ID
                              FROM   SCM_EQUIPMENT_M WITH(NOLOCK)
                              WHERE  1=1
							  AND	 ACTIVE_FLAG = 'Y'
							  AND	 EQUIPMENT_TYPE = 'M'
                              GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE
                             ) D
                  ON    A.AFTER_SITE_ID       = D.FACTORY_ID
                  AND   A.AFTER_ROUTE_ID      = D.LINE_ID
                  AND   A.AFTER_OPERATION_ID  = D.OPERATION_ID
                  AND   A.AFTER_RESOURCE_ID   = D.RESOURCE_ID
             LEFT OUTER JOIN (
                              SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, 
                                     WORK_CENTER_ID, 
                                     EQUIPMENT_ID AS RESOURCE_ID
                              FROM   SCM_EQUIPMENT_M WITH(NOLOCK)
                              WHERE  1=1
							  AND	 ACTIVE_FLAG = 'Y'
							  AND	 EQUIPMENT_TYPE = 'M'
                             ) E
                  ON    A.AFTER_SITE_ID       = E.FACTORY_ID
                  AND   A.AFTER_ROUTE_ID      = E.LINE_ID
                  AND   A.AFTER_OPERATION_ID  = E.OPERATION_ID
                  AND   A.AFTER_RESOURCE_ID   = E.RESOURCE_ID
           , SCM_FACTORY_M C WITH(NOLOCK)
      WHERE  A.MASTER_ID      = @v_master_id
      AND    A.PLAN_ID        = @v_plan_id
      AND    A.AFTER_SITE_ID  = @v_factory_id
      AND    A.AFTER_SITE_ID  = C.FACTORY_ID

      SET @n_row_count = @@ROWCOUNT
      
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        

      ------------------------------------------------------------------------------------------------------------------------------
      -- 환산자 적용부분    
      ------------------------------------------------------------------------------------------------------------------------------
      BEGIN
      
        /*
        -- JR/PANCAKE_QTY UPDATE
        BEGIN
        
          UPDATE FP_PRODUCTION_PLAN_R
          SET    FP_PRODUCTION_PLAN_R.ROLL_IN_QTY = (CASE WHEN UPPER(B.ITEM_UOM) = 'M'
                                                             THEN A.PLAN_IN_QTY -- Pancake
                                                             WHEN UPPER(B.ITEM_UOM) != 'M'
                                                             THEN A.PLAN_IN_QTY -- Pancake
                                                                  / ISNULL(D.PATTERN_QTY,1) * (CASE WHEN (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) = 0 THEN 1
                                                                                                    ELSE (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) END )
               / (CASE UPPER(B.LENGTH_UOM) WHEN 'M'  THEN 1
                                                                                              WHEN 'CM' THEN 100
                                                                                              WHEN 'MM' THEN 1000
                                                                                                        ELSE 1 END)
                                              ELSE NULL END),
                 FP_PRODUCTION_PLAN_R.ROLL_OUT_QTY = (CASE WHEN UPPER(B.ITEM_UOM) = 'M' 
                                                              THEN A.PLAN_QTY -- Pancake
                                                              WHEN UPPER(B.ITEM_UOM) != 'M'
                                                              THEN A.PLAN_QTY -- Pancake
                                                                  / ISNULL(D.PATTERN_QTY,1) * (CASE WHEN (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) = 0 THEN 1
                                                                                                    ELSE (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) END)
                                                                  / (CASE UPPER(B.LENGTH_UOM) WHEN 'M'  THEN 1
                                                                                              WHEN 'CM' THEN 100
                                                                                              WHEN 'MM' THEN 1000
                                                                                                        ELSE 1 END)
                                                         ELSE NULL END),
                 FP_PRODUCTION_PLAN_R.JR_IN_QTY = (CASE WHEN UPPER(B.ITEM_UOM) = 'M'
                                                             THEN A.PLAN_IN_QTY / CASE WHEN A.LANE_QTY IS NULL  THEN 1
                                                                                       WHEN A.LANE_QTY = 0      THEN 1
                                                                                       ELSE A.LANE_QTY
                                                                                  END  -- Roll
                                                             WHEN UPPER(B.ITEM_UOM) != 'M'
                                                             THEN A.PLAN_IN_QTY / CASE WHEN A.LANE_QTY IS NULL  THEN 1
                                                                                       WHEN A.LANE_QTY = 0      THEN 1
                                                                    ELSE A.LANE_QTY
                                                                                  END  -- Roll
                                                                  / ISNULL(D.PATTERN_QTY,1) * (CASE WHEN (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) = 0 THEN 1
                                                                                                    ELSE (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) END )
                                                                  / (CASE UPPER(B.LENGTH_UOM) WHEN 'M'  THEN 1
                                                                                              WHEN 'CM' THEN 100
                                                                                              WHEN 'MM' THEN 1000
                                                                                                        ELSE 1 END)
                                                        ELSE NULL END),
                 FP_PRODUCTION_PLAN_R.JR_OUT_QTY = (CASE WHEN UPPER(B.ITEM_UOM) = 'M'
                                                             THEN A.PLAN_QTY / CASE WHEN A.LANE_QTY IS NULL  THEN 1
                                                                                       WHEN A.LANE_QTY = 0      THEN 1
                                                 ELSE A.LANE_QTY
                                                                                  END  -- Roll
                                                             WHEN UPPER(B.ITEM_UOM) != 'M'
                                                             THEN A.PLAN_QTY / CASE WHEN A.LANE_QTY IS NULL  THEN 1
   WHEN A.LANE_QTY = 0      THEN 1
                                                                                       ELSE A.LANE_QTY
                                                                                  END  -- Roll
                                                                  / ISNULL(D.PATTERN_QTY,1) * (CASE WHEN (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) = 0 THEN 1
                                                                                                    ELSE (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) END)
                                                                  / (CASE UPPER(B.LENGTH_UOM) WHEN 'M'  THEN 1
                                                                                              WHEN 'CM' THEN 100
                                                                                              WHEN 'MM' THEN 1000
                                                                                                        ELSE 1 END)
                                                         ELSE NULL END)                                                       
          FROM FP_PRODUCTION_PLAN_R A,
               SCM_ITEM_M B,
               SCM_ITEM_CLASS_M C,
               SCM_ITEM_LANE__M D
          WHERE 1=1
          AND   A.INSTANCE_ID = @v_master_id
          AND   A.FP_PLAN_ID = @v_plan_id
          AND   A.FACTORY_ID       = @v_factory_id
          AND A.ITEM_ID = B.ITEM_ID
          AND A.DIVISION_ID = B.DIVISION_ID
          AND A.SITE_ID = B.SITE_ID
          AND B.ITEM_CLASS = C.CLASS_ID
          AND C.LEVEL_2_CODE = 'APC'
          AND A.DIVISION_ID = D.DIVISION_ID
          AND A.SITE_ID = D.SITE_ID
          AND A.PLANT_ID = D.PLANT_ID
          AND A.FACTORY_ID = D.FACTORY_ID
          AND A.ITEM_ID = D.ITEM_ID
          
          SET @v_message = 'ROLL_QTY - UPDATE : ' + CONVERT(nvarchar, @@ROWCOUNT)
          SET @n_log_count += 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'FP_PRODUCTION_PLAN_R', 'UPDATE', @n_log_count, null, @v_message, null 
          
          
          UPDATE FP_PRODUCTION_PLAN_EQUIPMENT_R
          SET    FP_PRODUCTION_PLAN_EQUIPMENT_R.ROLL_IN_QTY = (CASE WHEN UPPER(B.ITEM_UOM) = 'M'
                                                                       THEN A.PLAN_IN_QTY -- Pancake
                                                                       WHEN UPPER(B.ITEM_UOM) != 'M'
                                                                       THEN A.PLAN_IN_QTY -- Pancake
                                                                            / ISNULL(D.PATTERN_QTY,1) * (CASE WHEN (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) = 0 THEN 1
                                                                                                              ELSE (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) END )
                                                                            / (CASE UPPER(B.LENGTH_UOM) WHEN 'M'  THEN 1
                                                                                                        WHEN 'CM' THEN 100
                                                                                                        WHEN 'MM' THEN 1000
                                                                                                                  ELSE 1 END)
              ELSE NULL END),
                 FP_PRODUCTION_PLAN_EQUIPMENT_R.ROLL_OUT_QTY = (CASE WHEN UPPER(B.ITEM_UOM) = 'M'
                                                                        THEN A.PLAN_QTY -- Pancake
                                                                        WHEN UPPER(B.ITEM_UOM) != 'M'
                                                                        THEN A.PLAN_QTY -- Pancake
  / ISNULL(D.PATTERN_QTY,1) * (CASE WHEN (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) = 0 THEN 1
                                                                                                              ELSE (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) END)
                                                                            / (CASE UPPER(B.LENGTH_UOM) WHEN 'M'  THEN 1
                                                                                                        WHEN 'CM' THEN 100
                                                                                                        WHEN 'MM' THEN 1000
                                                                                                                  ELSE 1 END)
                                                                   ELSE NULL END),
                 FP_PRODUCTION_PLAN_EQUIPMENT_R.JR_IN_QTY = (CASE WHEN UPPER(B.ITEM_UOM) = 'M'
                                                                       THEN A.PLAN_IN_QTY / CASE WHEN A.LANE_QTY IS NULL  THEN 1
                                                                                                 WHEN A.LANE_QTY = 0      THEN 1
                                                                                                 ELSE A.LANE_QTY
                                                                                            END  -- Roll
                                                                       WHEN UPPER(B.ITEM_UOM) != 'M'
                                                                       THEN A.PLAN_IN_QTY / CASE WHEN A.LANE_QTY IS NULL  THEN 1
                                                                                                 WHEN A.LANE_QTY = 0      THEN 1
                                                                                                 ELSE A.LANE_QTY
                                                                                            END  -- Roll
                                    / ISNULL(D.PATTERN_QTY,1) * (CASE WHEN (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) = 0 THEN 1
                                                                                                              ELSE (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) END )
                                                                            / (CASE UPPER(B.LENGTH_UOM) WHEN 'M'  THEN 1
                                                                                                        WHEN 'CM' THEN 100
                                                                                                        WHEN 'MM' THEN 1000
                                                                                                                  ELSE 1 END)
                                                                  ELSE NULL END),
                 FP_PRODUCTION_PLAN_EQUIPMENT_R.JR_OUT_QTY = (CASE WHEN UPPER(B.ITEM_UOM) = 'M'
                                                                        THEN A.PLAN_QTY / CASE WHEN A.LANE_QTY IS NULL  THEN 1
                                                                                               WHEN A.LANE_QTY = 0      THEN 1
                                                                                               ELSE A.LANE_QTY
  END  -- Roll
                                                                        WHEN UPPER(B.ITEM_UOM) != 'M'
                                                                        THEN A.PLAN_QTY / CASE WHEN A.LANE_QTY IS NULL  THEN 1
                                                                                               WHEN A.LANE_QTY = 0      THEN 1
                                                                                               ELSE A.LANE_QTY
                                                                                          END  -- Roll
                                                                        / ISNULL(D.PATTERN_QTY,1) * (CASE WHEN (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) = 0 THEN 1
                                                                                                              ELSE (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) END)
                                                                            / (CASE UPPER(B.LENGTH_UOM) WHEN 'M'  THEN 1
                                                                                                        WHEN 'CM' THEN 100
                                                                                                        WHEN 'MM' THEN 1000
                                                                                                                  ELSE 1 END)
                                                                   ELSE NULL END)                                                                                              
          FROM FP_PRODUCTION_PLAN_EQUIPMENT_R A,
               SCM_ITEM_M B,
               SCM_ITEM_CLASS_M C,
               SCM_ITEM_LANE__M D
          WHERE 1=1
          AND   A.INSTANCE_ID = @v_master_id
          AND   A.FP_PLAN_ID = @v_plan_id
          AND   A.FACTORY_ID       = @v_factory_id
          AND A.ITEM_ID = B.ITEM_ID
          AND A.DIVISION_ID = B.DIVISION_ID
          AND A.SITE_ID = B.SITE_ID
          AND B.ITEM_CLASS = C.CLASS_ID
          AND C.LEVEL_2_CODE = 'APC'
          AND A.DIVISION_ID = D.DIVISION_ID
          AND A.SITE_ID = D.SITE_ID
          AND A.PLANT_ID = D.PLANT_ID
          AND A.FACTORY_ID = D.FACTORY_ID
          AND A.ITEM_ID = D.ITEM_ID
          
          SET @v_message = 'ROLL_QTY - UPDATE : ' + CONVERT(nvarchar, @@ROWCOUNT)
          SET @n_log_count += 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'FP_PRODUCTION_PLAN_EQUIPMENT_R', 'UPDATE', @n_log_count, null, @v_message, null 

          
          UPDATE FP_DAILY_PRODUCTION_PLAN_R
          SET    FP_DAILY_PRODUCTION_PLAN_R.ROLL_IN_QTY = (CASE WHEN UPPER(B.ITEM_UOM) = 'M'
                                                                   --THEN A.PLAN_IN_QTY / A.LANE_QTY -- Roll 
                                                                   THEN A.PLAN_IN_QTY -- Pancake
                                                                   WHEN UPPER(B.ITEM_UOM) != 'M'
                                                                   --THEN A.PLAN_QTY / A.LANE_QTY -- Roll
                                                                   THEN A.PLAN_IN_QTY -- Pancake
                                                                        / ISNULL(D.PATTERN_QTY,1) * (CASE WHEN (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) = 0 THEN 1
                                                                                                          ELSE (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) END )
                                                                        / (CASE UPPER(B.LENGTH_UOM) WHEN 'M'  THEN 1
                                                                                                    WHEN 'CM' THEN 100
                                                                                                    WHEN 'MM' THEN 1000
                                                                                                              ELSE 1 END)
                                                              ELSE NULL END),
                 FP_DAILY_PRODUCTION_PLAN_R.ROLL_OUT_QTY = (CASE WHEN UPPER(B.ITEM_UOM) = 'M'
                                                                    THEN A.PLAN_QTY -- Pancake
                                                                    WHEN UPPER(B.ITEM_UOM) != 'M'
                                                                    THEN A.PLAN_QTY -- Pancake
                                                                        / ISNULL(D.PATTERN_QTY,1) * (CASE WHEN (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) = 0 THEN 1
                                                                                                          ELSE (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) END)
                                                                        / (CASE UPPER(B.LENGTH_UOM) WHEN 'M'  THEN 1
                                                                                                    WHEN 'CM' THEN 100
                                                                                                    WHEN 'MM' THEN 1000
                                                                                                              ELSE 1 END)
                                                               ELSE NULL END),
                 FP_DAILY_PRODUCTION_PLAN_R.JR_IN_QTY = (CASE WHEN UPPER(B.ITEM_UOM) = 'M'
                                                                 THEN A.PLAN_IN_QTY / CASE WHEN D.LANE_QTY IS NULL  THEN 1
                                                                                           WHEN D.LANE_QTY = 0      THEN 1
                                                                                           ELSE D.LANE_QTY
                                                                                      END  -- RollD.LANE_QTY -- Roll 
                                                                 WHEN UPPER(B.ITEM_UOM) != 'M'
                                                                 THEN A.PLAN_IN_QTY / CASE WHEN E.LANE_QTY IS NULL  THEN 1
                                                                                           WHEN E.LANE_QTY = 0      THEN 1
                                                                                           ELSE E.LANE_QTY
                                                                                      END  -- Roll
                                                                        / ISNULL(D.PATTERN_QTY,1) * (CASE WHEN (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) = 0 THEN 1
                                                                                                          ELSE (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) END )
                                                                        / (CASE UPPER(B.LENGTH_UOM) WHEN 'M'  THEN 1
                                                                                                    WHEN 'CM' THEN 100
                                                                                                    WHEN 'MM' THEN 1000
                                                                                                              ELSE 1 END)
                                                              ELSE NULL END),
                 FP_DAILY_PRODUCTION_PLAN_R.JR_OUT_QTY = (CASE WHEN UPPER(B.ITEM_UOM) = 'M'
                                                                  THEN A.PLAN_QTY / CASE WHEN E.LANE_QTY IS NULL  THEN 1
                                                                                         WHEN E.LANE_QTY = 0      THEN 1
                                                                                         ELSE E.LANE_QTY
                                                                                      END  -- Roll
                                                                  WHEN UPPER(B.ITEM_UOM) != 'M'
                                                                  THEN A.PLAN_QTY / CASE WHEN D.LANE_QTY IS NULL  THEN 1
                                                                                         WHEN D.LANE_QTY = 0      THEN 1
                                                                                         ELSE D.LANE_QTY
                                            END  -- Roll
                                                                        / ISNULL(D.PATTERN_QTY,1) * (CASE WHEN (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) = 0 THEN 1
                                                                                                          ELSE (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) END)
                                                                        / (CASE UPPER(B.LENGTH_UOM) WHEN 'M'  THEN 1
                                                                                                    WHEN 'CM' THEN 100
                                                                                                    WHEN 'MM' THEN 1000
                                                                                                              ELSE 1 END)
                                                               ELSE NULL END)
          FROM FP_DAILY_PRODUCTION_PLAN_R A,
               SCM_ITEM_M B,
               SCM_ITEM_CLASS_M C,
               SCM_ITEM_LANE__M D,
               FP_PRODUCTION_PLAN_R E
          WHERE 1=1
          AND   A.INSTANCE_ID = @v_master_id
          AND   A.FP_PLAN_ID = @v_plan_id
          AND   A.FACTORY_ID       = @v_factory_id
          AND   A.ITEM_ID = B.ITEM_ID
          AND   A.DIVISION_ID = B.DIVISION_ID
          AND   A.SITE_ID = B.SITE_ID
          AND   B.ITEM_CLASS = C.CLASS_ID
          AND   C.LEVEL_2_CODE = 'APC'
          AND   A.DIVISION_ID = D.DIVISION_ID
          AND   A.SITE_ID = D.SITE_ID
          AND   A.PLANT_ID = D.PLANT_ID
          AND   A.FACTORY_ID = D.FACTORY_ID
          AND   A.ITEM_ID = D.ITEM_ID
          AND   A.INSTANCE_ID = E.INSTANCE_ID
          AND   A.FP_PLAN_ID = E.FP_PLAN_ID
          AND   A.WORK_ORDER_ID = E.WORK_ORDER_ID
          AND   A.PLAN_QTY > 0
          
          SET @v_message = 'ROLL_QTY - UPDATE : ' + CONVERT(nvarchar, @@ROWCOUNT)
          SET @n_log_count += 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'FP_DAILY_PRODUCTION_PLAN_R', 'UPDATE', @n_log_count, null, @v_message, null 
          
        END
        */

        -- BATCH_QTY UPDATE
        BEGIN
     
          -- BATCH_SUM_QTY UPDATE
          BEGIN
          
            UPDATE FP_PRODUCTION_PLAN_R
            SET    FP_PRODUCTION_PLAN_R.BATCH_SUM_QTY = B.BATCH_SUM_QTY
            FROM   FP_PRODUCTION_PLAN_R A,
                   (SELECT BATCH_ORDER_ID, SUM(BATCH_QTY) AS BATCH_SUM_QTY
                    FROM   FP_PRODUCTION_PLAN_R
                    WHERE  1=1
                    AND    INSTANCE_ID     = @v_master_id
                    AND    FP_PLAN_ID      = @v_plan_id
                    AND    FACTORY_ID      = @v_factory_id
                    AND    BATCH_ORDER_ID != '-'
                    GROUP BY BATCH_ORDER_ID) B
            WHERE  1=1
            AND    A.INSTANCE_ID    = @v_master_id
            AND    A.FP_PLAN_ID     = @v_plan_id
            AND    A.FACTORY_ID     = @v_factory_id
            AND    A.BATCH_ORDER_ID = B.BATCH_ORDER_ID
            
            SET @v_message = 'BATCH_QTY - UPDATE : ' + CONVERT(nvarchar, @@ROWCOUNT)
            SET @n_log_count += 1
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'FP_PRODUCTION_PLAN_R', 'UPDATE', @n_log_count, null, @v_message, null 
            
          END   
          
          BEGIN
          
            UPDATE FP_PRODUCTION_PLAN_EQUIPMENT_R
            SET    FP_PRODUCTION_PLAN_EQUIPMENT_R.BATCH_SUM_QTY = B.BATCH_SUM_QTY
            FROM   FP_PRODUCTION_PLAN_EQUIPMENT_R A,
                   (SELECT BATCH_ORDER_ID, SUM(BATCH_QTY) AS BATCH_SUM_QTY
                    FROM   FP_PRODUCTION_PLAN_EQUIPMENT_R
                    WHERE  1=1
                    AND    INSTANCE_ID     = @v_master_id
                    AND    FP_PLAN_ID      = @v_plan_id
                    AND    FACTORY_ID      = @v_factory_id
                    AND    BATCH_ORDER_ID != '-'
                    GROUP BY BATCH_ORDER_ID) B
            WHERE  1=1
            AND    A.INSTANCE_ID    = @v_master_id
            AND    A.FP_PLAN_ID     = @v_plan_id
            AND    A.FACTORY_ID     = @v_factory_id
            AND    A.BATCH_ORDER_ID = B.BATCH_ORDER_ID
            
            SET @v_message = 'BATCH_QTY - UPDATE : ' + CONVERT(nvarchar, @@ROWCOUNT)
            SET @n_log_count += 1
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'FP_PRODUCTION_PLAN_EQUIPMENT_R', 'UPDATE', @n_log_count, null, @v_message, null 
            
          END         
        
        END
        
      END

    END
    
    IF @@TRANCOUNT > 0
      COMMIT WORK 
    
  END TRY

  BEGIN CATCH
    --ROLLBACK

    SET @v_log_code = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
    SET @v_descr = ERROR_MESSAGE()

    EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'ERROR', null, @v_log_code, null, @v_descr
    commit;
  END CATCH

  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null

END
