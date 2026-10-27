
CREATE PROCEDURE [dbo].[PR_SCM_CAPA_SYNC_E_PRE]
@p_instance_id nvarchar(MAX) = '-', @p_plan_id nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS
/*************************************************************************************************/  
/** 프로그램 ID	: PR_SCM_CAPA_SYNC_E_PRE														**/
/** 프로그램 명	: 전극 Line별 Capa Sync Plan 수행												**/
/** 설 명		: 전극 Line별 Capa Sync Plan 수행												**/
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
/** 2020.11.02    CGJ			전극 Capa Sync Plan용으로 생성									**/
/*************************************************************************************************/

BEGIN
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
  SET XACT_ABORT ON

  -- LOG 용 변수 설정
  DECLARE @v_proc_name nvarchar(100) = 'PR_SCM_CAPA_SYNC_E_PRE'
  DECLARE @v_descr     nvarchar(250)
  DECLARE @v_flag  nvarchar(1) = 'N'
  DECLARE @v_run_flag  nvarchar(1) = 'N'
  DECLARE @v_run_step  nvarchar(1) = '0'
  DECLARE @v_plan_flag  nvarchar(1) = 'C'
  DECLARE @v_run_step2  nvarchar(1) = '0'
  DECLARE @n_loop_date nvarchar(250)
  DECLARE @n_loop_count INTEGER    = 0
  
  DECLARE @n_log_count INTEGER    = 0
  DECLARE @sysdate     DATETIME     = GETDATE()
  DECLARE @v_log_code   nvarchar(10)
  DECLARE @v_isfinished nvarchar(20)
  
  -- ERROR_LINE
  DECLARE @v_temp1     nvarchar(1000)
  DECLARE @v_temp2     nvarchar(1000)

  -- ================================================
    -- Declare start
  -- ================================================
  DECLARE @v_instance_id  nvarchar(1000)  
  DECLARE @v_plan_id      nvarchar(1000)
  
  DECLARE @sqltext          nvarchar(1000)
        , @v_lgc_site       nvarchar(10)
        , @n_synm_count     INTEGER       = 0
        , @v_plan_run_flag  nvarchar(10)  = 'RUN'   -- first plan 수행되기 전에 다른 plan 이 수동으로 수행할 때는 skip 처리
		, @v_scp_plan_id     nvarchar(30)
  -- ================================================
    -- Declare end
  -- ================================================
  SET @v_instance_id  = @p_instance_id
  SET @v_plan_id    = @p_plan_id
  
  SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))

  -- Start 로그는 무조건 남김
  SET @n_log_count = @n_log_count + 1
  EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', @n_log_count, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate
  
  EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', null
  
  BEGIN TRY        

    BEGIN

      SELECT @v_lgc_site = ISNULL(MAX(B.SITE_ID), 'A001' )
      FROM   FP_INSTANCE_FACTORY_M  A
           , SCM_FACTORY_M          B
      WHERE  A.INSTANCE_ID  = @v_instance_id
      AND    A.FACTORY_ID   = B.FACTORY_ID
      AND    A.ACTIVE_FLAG  = 'Y'
      AND    B.ACTIVE_FLAG  = 'Y'
    
      --LOG 생성
      SET @v_descr = '@v_lgc_site : ' + @v_lgc_site
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'SET', @n_log_count, NULL, @v_descr, null

      -- 필수 synonyms 검사
      SELECT @n_synm_count = COUNT(1)
      FROM   SYS.OBJECTS A WITH(NOLOCK)
      WHERE  type = 'SN'
      AND    (
                A.NAME = @v_instance_id + '_SY_' + 'PR_SCM_IF_CAPA_SYNC_ELEC'
             OR A.NAME = @v_instance_id + '_SY_' + 'PR_SCM_RUN_ENGINE'
             OR A.NAME = @v_instance_id + '_SY_' + 'PR_SCM_OF_RESULT_CAPA_SYNC'
             OR A.NAME = @v_instance_id + '_SY_' + 'TH_MST_ENG_PLAN_FLAG'
             OR A.NAME = @v_instance_id + '_SY_' + 'TH_ENG_PLAN_STATUS'
             )
             
      --LOG 생성
      SET @v_descr = 'SYNM_YN : ' + CASE WHEN @n_synm_count = 5 THEN 'Y' ELSE 'N' END
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'SET', @n_log_count, NULL, @v_descr, null             

    END

    -- ================================================
    -- 로직 추가 start
    -- ================================================    

    BEGIN

	  UPDATE 	scm_fp_plan_h
	  SET 	CAPA_SYNC_SEQ = CASE WHEN CAPA_SYNC_SEQ IS NULL THEN 101 ELSE CAPA_SYNC_SEQ + 1 END
	  WHERE INSTANCE_ID = @v_instance_id
      AND PLAN_ID = @v_plan_id
        
      SET @n_log_count = @n_log_count + 1
      SET @v_descr = 'Update Plan Info : ' + @v_plan_id
      EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'SET', @n_log_count, NULL, @v_descr, null
    
      -- 혹, ACTIVE_FLAG 가 0 일 경우 1로 설정을 바꾼다..
      UPDATE FP_PLAN_STATUS_H
      SET    ACTIVE_FLAG    = 1
           , INBOUND_FLAG   = 'P'
           , INBOUND_STEP   = NULL
           , INBOUND_START  = sysdatetime()
           , INBOUND_END    = NULL
           , ENGINE_FLAG    = 'R'
           , ENGINE_STEP    = NULL
           , ENGINE_START   = NULL
           , ENGINE_END     = NULL
           , OUTBOUND_FLAG  = 'R'
           , OUTBOUND_STEP  = NULL
           , OUTBOUND_START = NULL
           , OUTBOUND_END   = NULL
           , DB_TRANS_FLAG  = 'R'
           , DB_TRANS_STEP  = NULL
           , DB_TRANS_START = NULL
           , DB_TRANS_END   = NULL
      WHERE  INSTANCE_ID    = @V_INSTANCE_ID
      AND    PLAN_ID        = @V_PLAN_ID
      AND    ACTIVE_FLAG    = 0

      --LOG 생성
      SET @v_descr = 'Update Plan Status : ' + @v_scp_plan_id
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'SET', @n_log_count, NULL, @v_descr, null


      IF @n_synm_count = 5    -- 필수 SYNONYMS 이 5개 존재해야 실행되도록 함
        BEGIN
          SET @n_log_count = @n_log_count + 1
          SET @v_descr = @v_instance_id + ' PR_SCM_IF_CAPA_SYNC_ELEC Start'
          EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'CALL', @n_log_count, NULL, @v_descr, null
          
          EXEC(@v_instance_id+'_SY_PR_SCM_IF_CAPA_SYNC_ELEC '''+@v_instance_id+''','''+@v_plan_id+'''')

          SET @n_log_count = @n_log_count + 1
          SET @v_descr = @v_instance_id + ' PR_SCM_IF_CAPA_SYNC_ELEC End'
          EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'CALL', @n_log_count, NULL, @v_descr, null

          SET @n_log_count = @n_log_count + 1
          SET @v_descr = @v_instance_id + ' PR_SCM_RUN_ENGINE Start'
          EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'CALL', @n_log_count, NULL, @v_descr, null
          
          EXEC(@v_instance_id+'_SY_PR_SCM_RUN_ENGINE '''+@v_instance_id+''','''+@v_plan_id+'''')

          SET @n_log_count = @n_log_count + 1
          SET @v_descr = @v_instance_id + ' PR_SCM_RUN_ENGINE End'
          EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'CALL', @n_log_count, NULL, @v_descr, null
          
          -- ENGINE 실행완료 대기
          SET @n_loop_date = CONVERT(nvarchar,GETDATE(),120)
          SET @n_loop_count = 0
          
          WHILE 1 = 1
            BEGIN
              SET @sqltext='SELECT @v_return=CASE WHEN (b.PLAN_STATUS IS NULL) THEN ''P'' ELSE ''C'' END
              FROM 
                (
                  SELECT a.MASTER_ID, a.PLAN_ID, a.OUT_VERSION_ID
                  FROM '+@v_instance_id+'_SY_TH_MST_ENG_PLAN_FLAG  AS a
                  WHERE a.MASTER_ID = '''+@v_instance_id+''' AND 
                        a.PLAN_ID = '''+@v_plan_id+''' AND 
                        a.ACTIVE_FLAG = 1
                )  AS a 
                 LEFT OUTER JOIN '+@v_instance_id+'_SY_TH_ENG_PLAN_STATUS  AS b 
                 ON 
                    a.MASTER_ID = b.MASTER_ID AND 
                    a.PLAN_ID = b.PLAN_ID AND 
                    a.OUT_VERSION_ID = b.OUT_VERSION_ID AND 
                    b.PLAN_STATUS = ''DONE'''
              EXEC sp_executesql @sqltext,N'@v_return AS NVARCHAR OUTPUT', @v_return=@v_isfinished OUTPUT
              
              -- Engine의 실행이 종료되거나 대기시간 600초가 넘으면 종료
              IF @v_isfinished = 'C' OR @n_loop_count >= 600
                BEGIN
                  IF @v_isfinished = 'C'
                    SET @v_run_flag = 'Y'
                  BREAK
                END
              
              -- 초가 변경되면  체크
              IF @n_loop_date <> CONVERT(nvarchar,GETDATE(),120)
                BEGIN
                  SET @n_loop_count = @n_loop_count + 1
                  SET @n_loop_date = CONVERT(nvarchar,GETDATE(),120)
                  
                  IF @n_loop_count/5 = @n_loop_count/5.0
                    BEGIN
                      SET @n_log_count = @n_log_count + 1
                      SET @v_descr = CONVERT(nvarchar,@n_loop_count) + ' Count'
                      EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'COUNT', @n_log_count, NULL, @v_descr, null
                    END
                  
                  --Engine실행 STEP 확인
                  SET @sqltext='
                  SELECT @v_return = ISNULL(MAX(PLAN_STEP),''0'') FROM (
                  select TOP 1 MASTER_ID,PLAN_ID,PLAN_STATUS
                    ,CASE WHEN PLAN_STATUS=''LOADING'' THEN ''1''
                    WHEN PLAN_STATUS=''PLANNING'' THEN ''2''
                    WHEN PLAN_STATUS=''SAVING'' THEN ''3''
                    WHEN PLAN_STATUS=''DONE'' THEN ''4'' END AS PLAN_STEP
                  from '+@v_instance_id+'_SY_TH_ENG_PLAN_STATUS
                  where MASTER_ID = '''+@v_instance_id+''' AND plan_id = '''+@v_plan_id+'''
                  order by 
                    CASE WHEN PLAN_STATUS=''LOADING'' THEN ''1''
                    WHEN PLAN_STATUS=''PLANNING'' THEN ''2''
                    WHEN PLAN_STATUS=''SAVING'' THEN ''3''
                    WHEN PLAN_STATUS=''DONE'' THEN ''4'' END DESC
                  ) A'
                  
                  EXEC sp_executesql @sqltext,N'@v_return AS NVARCHAR OUTPUT', @v_return=@v_run_step2 OUTPUT
                  
                  IF @v_run_step < @v_run_step2
                    BEGIN
                      SET @v_run_step=@v_run_step2
                      
                      UPDATE FP_PLAN_STATUS_H
                      SET ENGINE_STEP = @v_run_step
                      FROM FP_PLAN_STATUS_H A
                      WHERE A.INSTANCE_ID = @v_instance_id AND A.plan_id = @v_plan_id
                      
                      SET @n_log_count = @n_log_count + 1
                      SET @v_descr = ' Engine STATUS UPDATE : ' + @v_run_step + '/4'
                      EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'COUNT', @n_log_count, NULL, @v_descr, null
                    END
                END
            END
            
          EXEC('UPDATE FP_PLAN_STATUS_H
          SET ENGINE_START=B.ENGINE_START
          FROM FP_PLAN_STATUS_H A, '+@v_instance_id+'_SY_TH_MST_ENG_PLAN_FLAG B
          WHERE A.INSTANCE_ID=B.MASTER_ID
          AND A.PLAN_ID=B.PLAN_ID
          AND A.PLAN_ID=B.OUT_VERSION_ID
          AND A.INSTANCE_ID = '''+@v_instance_id+''' 
      AND A.PLAN_ID = '''+@v_plan_id+'''') 

          IF @v_run_flag = 'Y'
            BEGIN
              BEGIN
                EXEC('UPDATE '+@v_instance_id+'_SY_TH_MST_ENG_PLAN_FLAG
                SET ENGINE_FLAG=''C'',ENGINE_END=GETDATE()
                FROM '+@v_instance_id+'_SY_TH_MST_ENG_PLAN_FLAG A
                WHERE A.MASTER_ID = '''+@v_instance_id+''' 
                  AND A.PLAN_ID = '''+@v_plan_id +'''
                  AND A.OUT_VERSION_ID = '''+@v_plan_id+'''')
                
                  EXEC('UPDATE FP_PLAN_STATUS_H
                      SET 
                         ENGINE_FLAG=''C'',
                         ENGINE_STEP = ''4'',
                         ENGINE_END = B.EVENT_TIME, 
                         UPDATE_ID = '''+@v_proc_name+''', 
                         UPDATE_TIME = sysdatetime()
                   FROM FP_PLAN_STATUS_H  A,
                           '+@v_instance_id+'_SY_TH_ENG_PLAN_STATUS B
                   WHERE A.INSTANCE_ID = B.MASTER_ID
                    AND    A.PLAN_ID = B.PLAN_ID
                    AND    A.PLAN_ID = B.OUT_VERSION_ID
                    AND    B.PLAN_STATUS = ''SAVING''
                    AND    a.INSTANCE_ID = '''+@v_instance_id+''' 
                    AND    a.PLAN_ID = '''+@v_plan_id+'''')

                
                SET @n_log_count = @n_log_count + 1
                SET @v_descr = @v_plan_id  + ':TH_MST_ENG_PLAN_FLAG UPDATE'
                EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'UPDATE', @n_log_count, NULL, @v_descr, null
              END
              
              SET @n_log_count = @n_log_count + 1
              SET @v_descr = @v_instance_id + ':ENGINE Finised'
              EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'ENGINE', @n_log_count, NULL, @v_descr, null
              
              SELECT @v_plan_flag=DB_TRANS_FLAG
              FROM FP_PLAN_STATUS_H
              WHERE INSTANCE_ID = @v_instance_id
                AND PLAN_ID = @v_plan_id
              
              IF @v_plan_flag = 'S'
                BEGIN
                     EXEC('UPDATE FP_PLAN_STATUS_H
                        SET 
                           OUTBOUND_FLAG = ''C'',
                           OUTBOUND_STEP = ''4'',
                           OUTBOUND_END = B.EVENT_TIME, 
                           ACTIVE_FLAG = 0,
                           UPDATE_ID = '''+@v_proc_name+''', 
                           UPDATE_TIME = sysdatetime()
                     FROM FP_PLAN_STATUS_H  A,
                             '+@v_instance_id+'_SY_TH_ENG_PLAN_STATUS B
                     WHERE A.INSTANCE_ID = B.MASTER_ID
                      AND    A.PLAN_ID = B.PLAN_ID
                      AND   A.PLAN_ID = B.OUT_VERSION_ID
                      AND    B.PLAN_STATUS = ''DONE''
                      AND    a.INSTANCE_ID = '''+@v_instance_id+''' 
                      AND    a.PLAN_ID = '''+@v_plan_id+'''')

                  
                  SET @n_log_count = @n_log_count + 1
                  SET @v_descr = @v_plan_id + ' USER Stop'
                  EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'STOP', @n_log_count, NULL, @v_descr, null
                END
              ELSE
                BEGIN
                  --엔진실행후 OUtbound 프로시져 실행
                  SET @n_log_count = @n_log_count + 1
                  SET @v_descr = @v_instance_id + ' PR_SCM_OF_RESULT_CAPA_SYNC Start'
                  EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'CALL', @n_log_count, NULL, @v_descr, null
                  
                  EXEC(@v_instance_id+'_SY_PR_SCM_OF_RESULT_CAPA_SYNC '''+@v_instance_id+''', '''+@v_plan_id+'''')
        
                  SET @n_log_count = @n_log_count + 1
                  SET @v_descr = @v_instance_id + ' PR_SCM_OF_RESULT_CAPA_SYNC End'
                  EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'CALL', @n_log_count, NULL, @v_descr, null
                END

            END
          ELSE -- 비정상적인 엔진수행으로 오류처리후 종료
            BEGIN
                 UPDATE FP_PLAN_STATUS_H
                    SET 
                       ACTIVE_FLAG=0,
                       ENGINE_FLAG='E',
                       UPDATE_ID = @v_proc_name, 
                       UPDATE_TIME = sysdatetime()
                 FROM FP_PLAN_STATUS_H  A
                 WHERE a.INSTANCE_ID = @v_instance_id  
                  AND  a.PLAN_ID = @v_plan_id

              SET @n_log_count = @n_log_count + 1
              SET @v_descr = @v_instance_id + ':ENGINE Not Finised. Time Out'
              EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'ENGINE', @n_log_count, NULL, @v_descr, null
            END
        END
      ELSE
        BEGIN

          SET @n_log_count = @n_log_count + 1
          EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'WARRING', @n_log_count, NULL, '############### SYNONYMS CHECKING ERROR !!! ###############', null

          UPDATE FP_PLAN_STATUS_H
            SET
              ACTIVE_FLAG=0,
              INBOUND_FLAG='E',
              UPDATE_ID = @v_proc_name, 
              UPDATE_TIME = sysdatetime()
          FROM FP_PLAN_STATUS_H  A
          WHERE a.INSTANCE_ID = @v_instance_id  
          AND  a.PLAN_ID = @v_plan_id

          SET @n_log_count = @n_log_count + 1
          EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'WARRING', @n_log_count, NULL, '############### INSTANCE ID NOT FOUND !!! ###############', null
        END

/*        
      BEGIN 
        DELETE FROM SCM_LOSS_CALENDAR_M
        WHERE INSTANCE_ID = @v_instance_id
        AND PLAN_ID = @v_plan_id
        
        SET @v_descr = 'SCM_LOSS_CALENDAR_M DELETE :'+CONVERT(nvarchar,@@ROWCOUNT)
        SET @n_log_count = @n_log_count + 1
        EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'DELETE', @n_log_count, NULL, @v_descr, null
        
        INSERT INTO SCM_LOSS_CALENDAR_M
             (
               INSTANCE_ID
             , PLAN_ID
             , COMPANY_ID
             , DIVISION_ID
             , SITE_ID
             , PLANT_ID
             , FACTORY_ID
             , OPERATION_ID
             , LINE_ID
             , EQUIPMENT_ID
             , OFF_TYPE_ID
             , OFF_START_TIME
             , OFF_END_TIME
             , REPEAT_ID
             , REPEAT_FLAG
             , WORK_CENTER_ID
             , DESCRIPTION
             , INSERT_ID
             , INSERT_TIME
             , UPDATE_ID
             , UPDATE_TIME
             )
        SELECT B.INSTANCE_ID
             , B.PLAN_ID
             , A.COMPANY_ID
             , A.DIVISION_ID
             , A.SITE_ID
             , A.PLANT_ID
             , A.FACTORY_ID
             , A.OPERATION_ID
             , A.LINE_ID
             , A.EQUIPMENT_ID
             , A.OFF_TYPE_ID
             , A.OFF_START_TIME
             , A.OFF_END_TIME
             , A.REPEAT_ID
             , A.REPEAT_FLAG
             , A.WORK_CENTER_ID
             , A.DESCRIPTION
             , @v_proc_name   AS INSERT_ID
             , GETDATE()      AS INSERT_TIME
             , @v_proc_name   AS UPDATE_ID
             , GETDATE()      AS UPDATE_TIME
        FROM   SCM_OFF_CALENDAR_M A
             , SCM_FP_PLAN_H B
        WHERE  A.OFF_START_TIME >= B.PLAN_START_TIME
        AND    A.OFF_END_TIME   < (B.PLAN_START_TIME+B.PLAN_HORIZON)
        AND    B.INSTANCE_ID    = @v_instance_id
        AND    B.PLAN_ID        = @v_plan_id
        
        SET @v_descr = 'SCM_LOSS_CALENDAR_M INSERT :'+CONVERT(nvarchar,@@ROWCOUNT)
        SET @n_log_count = @n_log_count + 1
        EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'INSERT', @n_log_count, NULL, @v_descr, null
      END
*/
		--------------------------------------------------------------------------------
		--- 20200310 DEMAND PEGGING의 NETJOB 실행을 위해 등록함. 
		--------------------------------------------------------------------------------
		insert into FP_NETJOB_QUEUE
		(
			INSTANCE_DATE
			,INSTANCE_ID
			,FP_PLAN_ID
			,PROC_NAME
			,JOB_SEQ
			,JOB_TYPE
			,ACTIVE_FLAG
			,PARAMETER1
			,PARAMETER2
			,INSERT_ID
			,INSERT_DTTM
			,UPDATE_ID
			,UPDATE_DTTM
		)
		SELECT	  CONVERT(nvarchar,dbo.FN_SITE_TIME(@v_lgc_site),112)
				, @v_instance_id
				, @v_plan_id
				, 'PR_SCM_OF_DEMAND_ORDER_TRACKING'
				, NEXT VALUE FOR SEQ_FP_NETJOB
				, 'R'
				, 'Y'
				, @v_instance_id
				, '-'
				, 'PR_SCM_ENGINE_RUN'
				, GETDATE()
				, 'PR_SCM_ENGINE_RUN'
				, GETDATE()
			
		SET @n_log_count = @n_log_count + 1
		SET @v_descr     = @v_instance_id + ' FP_NETJOB_QUEUE ADD'
		EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'INSERT', @n_log_count, NULL, @v_descr, null




    -- ================================================
    -- 로직 추가 end
    -- ================================================
    END

  END TRY

  BEGIN CATCH
       UPDATE FP_PLAN_STATUS_H
          SET 
             ACTIVE_FLAG = 0,
             INBOUND_FLAG=CASE WHEN INBOUND_FLAG='P' THEN 'E' ELSE INBOUND_FLAG END,
             ENGINE_FLAG=CASE WHEN ENGINE_FLAG='P' THEN 'E' ELSE ENGINE_FLAG END,
             OUTBOUND_FLAG=CASE WHEN OUTBOUND_FLAG='P' THEN 'E' ELSE OUTBOUND_FLAG END,
             DB_TRANS_FLAG=CASE WHEN DB_TRANS_FLAG='P' THEN 'E' ELSE DB_TRANS_FLAG END,
             UPDATE_ID = @v_proc_name, 
             UPDATE_TIME = sysdatetime()
       FROM FP_PLAN_STATUS_H  A
       WHERE a.INSTANCE_ID = @v_instance_id  
        AND  a.PLAN_ID = @v_plan_id

    -- 에러나도 로그는 인서트
    SET @v_log_code = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
    SET @v_descr = ERROR_MESSAGE()
    EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate
    
    EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'ERROR', null, @v_log_code, null, @v_descr

      IF @@TRANCOUNT > 0
         COMMIT WORK 
  END CATCH
  
  EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   999999, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
  
  EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null

END
