--CREATE PROCEDURE [dbo].[PR_MK_SCM_MODEL_COMP]
CREATE PROCEDURE [dbo].[PR_SCM_UI_OFF_MERGE]
@p_user_id nvarchar(50) = null
WITH EXEC AS CALLER
AS
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  DECLARE
    @v_proc_name        nvarchar(150) = 'PR_SCM_UI_OFF_MERGE', 
    @v_table_name       nvarchar(150) = 'SCM_OFF_CALENDAR_M', 
    @v_master_id        nvarchar(150) = '-', 
    @v_plan_id          nvarchar(150) = '-', 
    @v_user_id          nvarchar(150) = @p_user_id
    
  DECLARE
    @v_descr            nvarchar(250),
    @n_count            Integer  = 0,
    @n_log_count        Integer  = 0,
    @sysdate            DATETIME2 = GETDATE(),
    @v_message          nvarchar(200),
    @v_description      nvarchar(200),
    @n_row_count        int,
    @n_loop             int                 -- 무한 loop 방지

  DECLARE
    @v_check            Integer  = 0,
    @v_ref_instance_id  nvarchar(150) = NULL
  
  
  BEGIN TRY
    --LOG 생성
    SET @n_log_count = @n_log_count + 1
    SET @sysdate = GETDATE()
    EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, '###############', 'START', @n_log_count, null, '############### Start of procedure ###############', null

    BEGIN
      
      DECLARE C_BUF_OFF CURSOR FOR
        SELECT A._DUP
              ,A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID
              ,A.OPERATION_ID, A.LINE_ID, A.EQUIPMENT_ID
              ,A.OFF_TYPE_ID, A.OFF_START_TIME, A.OFF_END_TIME
              ,A.REPEAT_ID, A.REPEAT_FLAG
              ,A.DB_START_TIME, A.DB_END_TIME
              ,A.YYYYMMDD, A.EDITSTATUS, A.DESCRIPTION, A.PATTERN_ID
              ,A.JOB_SEQ
        FROM   BUF_OFF_CALENDAR_MERGE_M A
        WHERE  A.JOB_USER_ID = @v_user_id
        ORDER BY A.JOB_SEQ
        
      DECLARE 							-- 커서로 받을 변수
        @__DUP            nvarchar(1),
        @_COMPANY_ID      nvarchar(30),
        @_DIVISION_ID     nvarchar(30),
        @_SITE_ID         nvarchar(30),
        @_PLANT_ID        nvarchar(30),
        @_FACTORY_ID      nvarchar(30),
        @_OPERATION_ID    nvarchar(30),
        @_LINE_ID         nvarchar(30),
        @_EQUIPMENT_ID    nvarchar(30),
        @_OFF_TYPE_ID     nvarchar(30),
        @_OFF_START_TIME  nvarchar(30),
        @_OFF_END_TIME    nvarchar(30),
        @_REPEAT_ID       nvarchar(30),
        @_REPEAT_FLAG     nvarchar(1),
        @_DB_START_TIME   datetime,
        @_DB_END_TIME     datetime,
        @_YYYYMMDD        nvarchar(8),
        @_EDITSTATUS      nvarchar(30),
        @_DESCRIPTION     nvarchar(200),
        @_PATTERN_ID      nvarchar(30),
        @_JOB_SEQ         int
      
      OPEN C_BUF_OFF
      
      WHILE 1 = 1
      BEGIN
        
        FETCH C_BUF_OFF
        INTO  @__DUP
             ,@_COMPANY_ID
             ,@_DIVISION_ID
             ,@_SITE_ID
             ,@_PLANT_ID
             ,@_FACTORY_ID
             ,@_OPERATION_ID
             ,@_LINE_ID
             ,@_EQUIPMENT_ID
             ,@_OFF_TYPE_ID
             ,@_OFF_START_TIME
             ,@_OFF_END_TIME
             ,@_REPEAT_ID
             ,@_REPEAT_FLAG
             ,@_DB_START_TIME
             ,@_DB_END_TIME
             ,@_YYYYMMDD
             ,@_EDITSTATUS
             ,@_DESCRIPTION
             ,@_PATTERN_ID
             ,@_JOB_SEQ
        
        IF @@FETCH_STATUS <> 0					-- FETCH 레코드 없으면 LOOP 탈출
          BREAK
        
        -- 기존 OFF 시간과 중복됨
        IF @__DUP = 'Y'
        BEGIN
          DECLARE  
            @tmp_COMPANY_ID      nvarchar(30),
            @tmp_DIVISION_ID     nvarchar(30),
            @tmp_SITE_ID         nvarchar(30),
            @tmp_PLANT_ID        nvarchar(30),
            @tmp_FACTORY_ID      nvarchar(30),
            @tmp_OPERATION_ID    nvarchar(30),
            @tmp_LINE_ID         nvarchar(30),
            @tmp_EQUIPMENT_ID    nvarchar(30),
            @tmp_OFF_TYPE_ID     nvarchar(30),
            @tmp_OFF_START_TIME  datetime,
            @tmp_OFF_END_TIME    datetime
          
          
          DECLARE @PASS_PATERN NUMERIC(20,0)
          SET @PASS_PATERN = 
          (
            SELECT COUNT(A.COMPANY_ID) AS CNT
            FROM   SCM_OFF_CALENDAR_M A
            WHERE  A.COMPANY_ID   = @_COMPANY_ID
            AND    A.DIVISION_ID  = @_DIVISION_ID
            AND    A.SITE_ID      = @_SITE_ID
            AND    A.PLANT_ID     = @_PLANT_ID
            AND    A.FACTORY_ID   = @_FACTORY_ID
            AND    A.OPERATION_ID = @_OPERATION_ID
            AND    A.LINE_ID      = @_LINE_ID
            AND    A.EQUIPMENT_ID = @_EQUIPMENT_ID
            AND    EXISTS (
                SELECT 1
                FROM   BUF_OFF_CALENDAR_MERGE_M B
                WHERE  A.COMPANY_ID   = B.COMPANY_ID
                AND    A.DIVISION_ID  = B.DIVISION_ID
                AND    A.SITE_ID      = B.SITE_ID
                AND    A.PLANT_ID     = B.PLANT_ID
                AND    A.FACTORY_ID   = B.FACTORY_ID
                AND    A.OPERATION_ID = B.OPERATION_ID
                AND    A.LINE_ID      = B.LINE_ID
                AND    A.EQUIPMENT_ID = B.EQUIPMENT_ID
                AND    B.DB_START_TIME >= A.OFF_START_TIME
                AND    B.DB_END_TIME   <= A.OFF_END_TIME
                AND    B.JOB_USER_ID   = @v_user_id
                AND    B.DB_START_TIME = @_DB_START_TIME
                AND    B.DB_END_TIME   = @_DB_END_TIME
            )
          )
          
          -- 0.무시 : 기존 off 에 시간이 완전히 들어가면 신규 off를 발생시키지 않음
          if @PASS_PATERN <> 0
            continue;
          
          
          -- 1.기존 off 삭제
          DECLARE C_DETAIL CURSOR FOR
            SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID
                 , A.OPERATION_ID, A.LINE_ID, A.EQUIPMENT_ID
                 , A.OFF_TYPE_ID, A.OFF_START_TIME, A.OFF_END_TIME
            FROM   SCM_OFF_CALENDAR_M A
            WHERE  A.COMPANY_ID   = @_COMPANY_ID
            AND    A.DIVISION_ID  = @_DIVISION_ID
            AND    A.SITE_ID      = @_SITE_ID
            AND    A.PLANT_ID     = @_PLANT_ID
            AND    A.FACTORY_ID   = @_FACTORY_ID
            AND    A.OPERATION_ID = @_OPERATION_ID
            AND    A.LINE_ID      = @_LINE_ID
            AND    A.EQUIPMENT_ID = @_EQUIPMENT_ID
            AND    EXISTS (
                SELECT 1
                FROM   BUF_OFF_CALENDAR_MERGE_M B
                WHERE  A.COMPANY_ID   = B.COMPANY_ID
                AND    A.DIVISION_ID  = B.DIVISION_ID
                AND    A.SITE_ID      = B.SITE_ID
                AND    A.PLANT_ID     = B.PLANT_ID
                AND    A.FACTORY_ID   = B.FACTORY_ID
                AND    A.OPERATION_ID = B.OPERATION_ID
                AND    A.LINE_ID      = B.LINE_ID
                AND    A.EQUIPMENT_ID = B.EQUIPMENT_ID
                AND    B.DB_START_TIME <= A.OFF_START_TIME
                AND    B.DB_END_TIME   >= A.OFF_END_TIME   -- = 추가.. 20170328 LJS
                AND    B.JOB_USER_ID   = @v_user_id
                AND    B.DB_START_TIME = @_DB_START_TIME
                AND    B.DB_END_TIME   = @_DB_END_TIME
            )
            
            OPEN C_DETAIL
            
            WHILE 1=1
            BEGIN
              FETCH C_DETAIL INTO  
                    @tmp_COMPANY_ID
                   ,@tmp_DIVISION_ID
                   ,@tmp_SITE_ID
                   ,@tmp_PLANT_ID
                   ,@tmp_FACTORY_ID
                   ,@tmp_OPERATION_ID
                   ,@tmp_LINE_ID
                   ,@tmp_EQUIPMENT_ID
                   ,@tmp_OFF_TYPE_ID
                   ,@tmp_OFF_START_TIME
                   ,@tmp_OFF_END_TIME
               
               IF @@FETCH_STATUS <> 0
                BREAK;
               
               -- history
               INSERT INTO HIS_OFF_CALENDAR_M (
                       COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID
                     , OPERATION_ID, LINE_ID, EQUIPMENT_ID
                     , OFF_TYPE_ID
                     , OFF_START_TIME, OFF_END_TIME
                     , REPEAT_ID, REPEAT_FLAG, WORK_CENTER_ID, [DESCRIPTION], PATTERN_ID
                     , INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME
                     , JOB_USER_ID, JOB_TIME, JOB_TYPE
               ) 
               SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID
                    , OPERATION_ID, LINE_ID, EQUIPMENT_ID
                    , OFF_TYPE_ID
                    , OFF_START_TIME, OFF_END_TIME
                    , REPEAT_ID, REPEAT_FLAG, WORK_CENTER_ID, [DESCRIPTION], PATTERN_ID
                    , INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME
                    , @v_user_id, @sysdate, 'DELETE'
               FROM   SCM_OFF_CALENDAR_M
               WHERE  COMPANY_ID     = @tmp_COMPANY_ID
               AND    DIVISION_ID    = @tmp_DIVISION_ID
               AND    SITE_ID        = @tmp_SITE_ID
               AND    PLANT_ID       = @tmp_PLANT_ID
               AND    FACTORY_ID     = @tmp_FACTORY_ID
               AND    OPERATION_ID   = @tmp_OPERATION_ID
               AND    LINE_ID        = @tmp_LINE_ID
               AND    EQUIPMENT_ID   = @tmp_EQUIPMENT_ID
               AND    OFF_TYPE_ID    = @tmp_OFF_TYPE_ID
               AND    OFF_START_TIME = @tmp_OFF_START_TIME
               
               
               DELETE FROM SCM_OFF_CALENDAR_M
               WHERE  COMPANY_ID     = @tmp_COMPANY_ID
               AND    DIVISION_ID    = @tmp_DIVISION_ID
               AND    SITE_ID        = @tmp_SITE_ID
               AND    PLANT_ID       = @tmp_PLANT_ID
               AND    FACTORY_ID     = @tmp_FACTORY_ID
               AND    OPERATION_ID   = @tmp_OPERATION_ID
               AND    LINE_ID        = @tmp_LINE_ID
               AND    EQUIPMENT_ID   = @tmp_EQUIPMENT_ID
               AND    OFF_TYPE_ID    = @tmp_OFF_TYPE_ID
               AND    OFF_START_TIME = @tmp_OFF_START_TIME
               
               
    					 SET @n_log_count = @n_log_count + 1
    					 SET @v_descr = 'DELETE - MERGED : ' + @tmp_COMPANY_ID + '##' + @tmp_DIVISION_ID + '##' + @tmp_SITE_ID+ '##' + @tmp_PLANT_ID+ '##' + @tmp_FACTORY_ID
                                            + '##' + @tmp_OPERATION_ID+ '##' + @tmp_LINE_ID+ '##' + @tmp_EQUIPMENT_ID+ '##' + @tmp_OFF_TYPE_ID+ '##' + convert(varchar, @tmp_OFF_START_TIME, 20)
    					 EXEC PR_LOG_PROCESS @sysdate, '-', '-', @v_proc_name, null, 'DELETE', @n_log_count, NULL, @v_descr, null
               
            END
          
          CLOSE C_DETAIL	
          
          DEALLOCATE C_DETAIL
          
          -- 2.기존 start 조정
          DECLARE C_DETAIL CURSOR FOR
            SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID
                 , A.OPERATION_ID, A.LINE_ID, A.EQUIPMENT_ID
                 , A.OFF_TYPE_ID, A.OFF_START_TIME, A.OFF_END_TIME
            FROM   SCM_OFF_CALENDAR_M A
            WHERE  A.COMPANY_ID   = @_COMPANY_ID
            AND    A.DIVISION_ID  = @_DIVISION_ID
            AND    A.SITE_ID      = @_SITE_ID
            AND    A.PLANT_ID     = @_PLANT_ID
            AND    A.FACTORY_ID   = @_FACTORY_ID
            AND    A.OPERATION_ID = @_OPERATION_ID
            AND    A.LINE_ID      = @_LINE_ID
            AND    A.EQUIPMENT_ID = @_EQUIPMENT_ID
            AND    EXISTS (
                SELECT 1
                FROM   BUF_OFF_CALENDAR_MERGE_M B
                WHERE  A.COMPANY_ID   = B.COMPANY_ID
                AND    A.DIVISION_ID  = B.DIVISION_ID
                AND    A.SITE_ID      = B.SITE_ID
                AND    A.PLANT_ID     = B.PLANT_ID
                AND    A.FACTORY_ID   = B.FACTORY_ID
                AND    A.OPERATION_ID = B.OPERATION_ID
                AND    A.LINE_ID      = B.LINE_ID
                AND    A.EQUIPMENT_ID = B.EQUIPMENT_ID
                AND    B.DB_START_TIME  <= A.OFF_START_TIME
                AND    B.DB_END_TIME    <  A.OFF_END_TIME
                AND    A.OFF_START_TIME <  B.DB_END_TIME
                AND    B.JOB_USER_ID   = @v_user_id
                AND    B.DB_START_TIME = @_DB_START_TIME
                AND    B.DB_END_TIME   = @_DB_END_TIME
            )
            
            OPEN C_DETAIL
            
            WHILE 1=1
            BEGIN
              FETCH C_DETAIL INTO  
                    @tmp_COMPANY_ID
                   ,@tmp_DIVISION_ID
                   ,@tmp_SITE_ID
                   ,@tmp_PLANT_ID
                   ,@tmp_FACTORY_ID
                   ,@tmp_OPERATION_ID
                   ,@tmp_LINE_ID
                   ,@tmp_EQUIPMENT_ID
                   ,@tmp_OFF_TYPE_ID
                   ,@tmp_OFF_START_TIME
                   ,@tmp_OFF_END_TIME

               IF @@FETCH_STATUS <> 0
                BREAK;
               
               -- off_start_time : new off 의 off_end_time 값으로 변경
               UPDATE SCM_OFF_CALENDAR_M SET
                      UPDATE_ID = @v_user_id, UPDATE_TIME = @sysdate
                     ,OFF_START_TIME = @_DB_END_TIME  
               WHERE  COMPANY_ID     = @tmp_COMPANY_ID
               AND    DIVISION_ID    = @tmp_DIVISION_ID
               AND    SITE_ID        = @tmp_SITE_ID
               AND    PLANT_ID       = @tmp_PLANT_ID
               AND    FACTORY_ID     = @tmp_FACTORY_ID
               AND    OPERATION_ID   = @tmp_OPERATION_ID
               AND    LINE_ID        = @tmp_LINE_ID
               AND    EQUIPMENT_ID   = @tmp_EQUIPMENT_ID
               AND    OFF_TYPE_ID    = @tmp_OFF_TYPE_ID
               AND    OFF_START_TIME = @tmp_OFF_START_TIME
               
               -- history
               INSERT INTO HIS_OFF_CALENDAR_M (
                       COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID
                     , OPERATION_ID, LINE_ID, EQUIPMENT_ID
                     , OFF_TYPE_ID
                     , OFF_START_TIME, OFF_END_TIME
                     , REPEAT_ID, REPEAT_FLAG, WORK_CENTER_ID, [DESCRIPTION], PATTERN_ID
                     , INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME
                     , JOB_USER_ID, JOB_TIME, JOB_TYPE
               ) 
               SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID
                    , OPERATION_ID, LINE_ID, EQUIPMENT_ID
                    , OFF_TYPE_ID
                    , OFF_START_TIME, OFF_END_TIME
                    , REPEAT_ID, REPEAT_FLAG, WORK_CENTER_ID, [DESCRIPTION], PATTERN_ID
                    , INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME
                    , @v_user_id, @sysdate, 'UPDATE'
               FROM   SCM_OFF_CALENDAR_M
               WHERE  COMPANY_ID     = @tmp_COMPANY_ID
               AND    DIVISION_ID    = @tmp_DIVISION_ID
               AND    SITE_ID        = @tmp_SITE_ID
               AND    PLANT_ID       = @tmp_PLANT_ID
               AND    FACTORY_ID     = @tmp_FACTORY_ID
               AND    OPERATION_ID   = @tmp_OPERATION_ID
               AND    LINE_ID        = @tmp_LINE_ID
               AND    EQUIPMENT_ID   = @tmp_EQUIPMENT_ID
               AND    OFF_TYPE_ID    = @tmp_OFF_TYPE_ID
               AND    OFF_START_TIME = @_DB_END_TIME
               
    					 SET @n_log_count = @n_log_count + 1
    					 SET @v_descr = 'UPDATE - START : ' + @tmp_COMPANY_ID + '##' + @tmp_DIVISION_ID + '##' + @tmp_SITE_ID+ '##' + @tmp_PLANT_ID+ '##' + @tmp_FACTORY_ID
                                            + '##' + @tmp_OPERATION_ID+ '##' + @tmp_LINE_ID+ '##' + @tmp_EQUIPMENT_ID+ '##' + @tmp_OFF_TYPE_ID
                                            + '##bef. start - ' + convert(varchar, @tmp_OFF_START_TIME, 20) + '##aft. start - ' + convert(varchar, @_DB_END_TIME, 20)
    					 EXEC PR_LOG_PROCESS @sysdate, '-', '-', @v_proc_name, null, 'UPDATE', @n_log_count, NULL, @v_descr, null
               
               
            END
          
          CLOSE C_DETAIL	
          
          DEALLOCATE C_DETAIL
          
          -- 3.기존 end 조정
          DECLARE C_DETAIL CURSOR FOR
            SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID
                 , A.OPERATION_ID, A.LINE_ID, A.EQUIPMENT_ID
                 , A.OFF_TYPE_ID, A.OFF_START_TIME, A.OFF_END_TIME
            FROM   SCM_OFF_CALENDAR_M A
            WHERE  A.COMPANY_ID   = @_COMPANY_ID
            AND    A.DIVISION_ID  = @_DIVISION_ID
            AND    A.SITE_ID      = @_SITE_ID
            AND    A.PLANT_ID     = @_PLANT_ID
            AND    A.FACTORY_ID   = @_FACTORY_ID
            AND    A.OPERATION_ID = @_OPERATION_ID
            AND    A.LINE_ID      = @_LINE_ID
            AND    A.EQUIPMENT_ID = @_EQUIPMENT_ID
            AND    EXISTS (
                SELECT 1
                FROM   BUF_OFF_CALENDAR_MERGE_M B
                WHERE  A.COMPANY_ID   = B.COMPANY_ID
                AND    A.DIVISION_ID  = B.DIVISION_ID
                AND    A.SITE_ID      = B.SITE_ID
                AND    A.PLANT_ID     = B.PLANT_ID
                AND    A.FACTORY_ID   = B.FACTORY_ID
                AND    A.OPERATION_ID = B.OPERATION_ID
                AND    A.LINE_ID      = B.LINE_ID
                AND    A.EQUIPMENT_ID = B.EQUIPMENT_ID
                AND    B.DB_START_TIME >= A.OFF_START_TIME
                AND    B.DB_END_TIME   >  A.OFF_END_TIME
                AND    A.OFF_END_TIME  > B.DB_START_TIME
                AND    B.JOB_USER_ID   = @v_user_id
                AND    B.DB_START_TIME = @_DB_START_TIME
                AND    B.DB_END_TIME   = @_DB_END_TIME
            )
            
            OPEN C_DETAIL
            
            WHILE 1=1
            BEGIN
              
              FETCH C_DETAIL INTO  
                    @tmp_COMPANY_ID
                   ,@tmp_DIVISION_ID
                   ,@tmp_SITE_ID
                   ,@tmp_PLANT_ID
                   ,@tmp_FACTORY_ID
                   ,@tmp_OPERATION_ID
                   ,@tmp_LINE_ID
                   ,@tmp_EQUIPMENT_ID
                   ,@tmp_OFF_TYPE_ID
                   ,@tmp_OFF_START_TIME
                   ,@tmp_OFF_END_TIME
               
               IF @@FETCH_STATUS <> 0
                BREAK;
               
               -- off_start_time : new off 의 off_end_time 값으로 변경
               UPDATE SCM_OFF_CALENDAR_M SET
                      UPDATE_ID = @v_user_id, UPDATE_TIME = @sysdate
                     ,OFF_END_TIME = @_DB_START_TIME
               WHERE  COMPANY_ID     = @tmp_COMPANY_ID
               AND    DIVISION_ID    = @tmp_DIVISION_ID
               AND    SITE_ID        = @tmp_SITE_ID
               AND    PLANT_ID       = @tmp_PLANT_ID
               AND    FACTORY_ID     = @tmp_FACTORY_ID
               AND    OPERATION_ID   = @tmp_OPERATION_ID
               AND    LINE_ID        = @tmp_LINE_ID
               AND    EQUIPMENT_ID   = @tmp_EQUIPMENT_ID
               AND    OFF_TYPE_ID    = @tmp_OFF_TYPE_ID
               AND    OFF_START_TIME = @tmp_OFF_START_TIME
               
               -- history
               INSERT INTO HIS_OFF_CALENDAR_M (
                       COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID
                     , OPERATION_ID, LINE_ID, EQUIPMENT_ID
                     , OFF_TYPE_ID
                     , OFF_START_TIME, OFF_END_TIME
                     , REPEAT_ID, REPEAT_FLAG, WORK_CENTER_ID, [DESCRIPTION], PATTERN_ID
                     , INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME
                     , JOB_USER_ID, JOB_TIME, JOB_TYPE
               ) 
               SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID
                    , OPERATION_ID, LINE_ID, EQUIPMENT_ID
                    , OFF_TYPE_ID
                    , OFF_START_TIME, OFF_END_TIME
                    , REPEAT_ID, REPEAT_FLAG, WORK_CENTER_ID, [DESCRIPTION], PATTERN_ID
                    , INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME
                    , @v_user_id, @sysdate, 'UPDATE'
               FROM   SCM_OFF_CALENDAR_M
               WHERE  COMPANY_ID     = @tmp_COMPANY_ID
               AND    DIVISION_ID    = @tmp_DIVISION_ID
               AND    SITE_ID        = @tmp_SITE_ID
               AND    PLANT_ID       = @tmp_PLANT_ID
               AND    FACTORY_ID     = @tmp_FACTORY_ID
               AND    OPERATION_ID   = @tmp_OPERATION_ID
               AND    LINE_ID        = @tmp_LINE_ID
               AND    EQUIPMENT_ID   = @tmp_EQUIPMENT_ID
               AND    OFF_TYPE_ID    = @tmp_OFF_TYPE_ID
               AND    OFF_START_TIME = @tmp_OFF_START_TIME
               
               
    					 SET @n_log_count = @n_log_count + 1
    					 SET @v_descr = 'UPDATE - END : ' + @tmp_COMPANY_ID + '##' + @tmp_DIVISION_ID + '##' + @tmp_SITE_ID+ '##' + @tmp_PLANT_ID+ '##' + @tmp_FACTORY_ID
                                            + '##' + @tmp_OPERATION_ID+ '##' + @tmp_LINE_ID+ '##' + @tmp_EQUIPMENT_ID+ '##' + @tmp_OFF_TYPE_ID + '##' + convert(varchar, @tmp_OFF_START_TIME, 20)
    					 EXEC PR_LOG_PROCESS @sysdate, '-', '-', @v_proc_name, null, 'UPDATE', @n_log_count, NULL, @v_descr, null
               
            END
            
            -- 신규 off 추가
            INSERT INTO SCM_OFF_CALENDAR_M (
                COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID
              , OPERATION_ID, LINE_ID, EQUIPMENT_ID
              , OFF_TYPE_ID
              , OFF_START_TIME, OFF_END_TIME
              , REPEAT_ID, REPEAT_FLAG, WORK_CENTER_ID, [DESCRIPTION], PATTERN_ID
              , INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME
            ) VALUES (
                @_COMPANY_ID, @_DIVISION_ID, @_SITE_ID, @_PLANT_ID, @_FACTORY_ID
               ,@_OPERATION_ID, @_LINE_ID, @_EQUIPMENT_ID
               ,@_OFF_TYPE_ID
               ,@_DB_START_TIME, @_DB_END_TIME
               ,@_REPEAT_ID, @_REPEAT_FLAG, '-', @_DESCRIPTION, @_PATTERN_ID
               ,@v_user_id, @sysdate, @v_user_id, @sysdate
            )
            
            INSERT INTO HIS_OFF_CALENDAR_M (
                COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID
              , OPERATION_ID, LINE_ID, EQUIPMENT_ID
              , OFF_TYPE_ID
              , OFF_START_TIME, OFF_END_TIME
              , REPEAT_ID, REPEAT_FLAG, WORK_CENTER_ID, [DESCRIPTION], PATTERN_ID
              , INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME
              , JOB_USER_ID, JOB_TIME, JOB_TYPE
            ) VALUES (
                @_COMPANY_ID, @_DIVISION_ID, @_SITE_ID, @_PLANT_ID, @_FACTORY_ID
               ,@_OPERATION_ID, @_LINE_ID, @_EQUIPMENT_ID
               ,@_OFF_TYPE_ID
               ,@_DB_START_TIME, @_DB_END_TIME
               ,@_REPEAT_ID, @_REPEAT_FLAG, '-', @_DESCRIPTION, @_PATTERN_ID
               ,@v_user_id, @sysdate, @v_user_id, @sysdate
               ,@v_user_id, @sysdate, 'INSERT'
            )
            
  				  SET @n_log_count = @n_log_count + 1
  				  SET @v_descr = 'INSERT NEW OFF : ' + @_COMPANY_ID + '##' + @_DIVISION_ID + '##' + @_SITE_ID + '##' + @_PLANT_ID + '##' + @_FACTORY_ID
                                         + '##' + @_OPERATION_ID + '##' + @_LINE_ID + '##' + @_EQUIPMENT_ID + '##' + @_REPEAT_ID + '##' + convert(varchar, @_DB_START_TIME, 20)
  				  EXEC PR_LOG_PROCESS @sysdate, '-', '-', @v_proc_name, null, 'INSERT', @n_log_count, NULL, @v_descr, null
          
          
          CLOSE C_DETAIL	
          
          DEALLOCATE C_DETAIL
          
          select 1
        END
        -- 중복 OFF 가 없으면 바로 INSERT
        ELSE
        BEGIN
        
          INSERT INTO SCM_OFF_CALENDAR_M (
              COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID
            , OPERATION_ID, LINE_ID, EQUIPMENT_ID
            , OFF_TYPE_ID
            , OFF_START_TIME, OFF_END_TIME
            , REPEAT_ID, REPEAT_FLAG, WORK_CENTER_ID, [DESCRIPTION], PATTERN_ID
            , INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME
          ) VALUES (
              @_COMPANY_ID, @_DIVISION_ID, @_SITE_ID, @_PLANT_ID, @_FACTORY_ID
             ,@_OPERATION_ID, @_LINE_ID, @_EQUIPMENT_ID
             ,@_OFF_TYPE_ID
             ,@_DB_START_TIME, @_DB_END_TIME
             ,@_REPEAT_ID, @_REPEAT_FLAG, '-', @_DESCRIPTION, @_PATTERN_ID
             ,@v_user_id, @sysdate, @v_user_id, @sysdate
          )
          
          INSERT INTO HIS_OFF_CALENDAR_M (
              COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID
            , OPERATION_ID, LINE_ID, EQUIPMENT_ID
            , OFF_TYPE_ID
            , OFF_START_TIME, OFF_END_TIME
            , REPEAT_ID, REPEAT_FLAG, WORK_CENTER_ID, [DESCRIPTION], PATTERN_ID
            , INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME
            , JOB_USER_ID, JOB_TIME, JOB_TYPE
          ) VALUES (
              @_COMPANY_ID, @_DIVISION_ID, @_SITE_ID, @_PLANT_ID, @_FACTORY_ID
             ,@_OPERATION_ID, @_LINE_ID, @_EQUIPMENT_ID
             ,@_OFF_TYPE_ID
             ,@_DB_START_TIME, @_DB_END_TIME
             ,@_REPEAT_ID, @_REPEAT_FLAG, '-', @_DESCRIPTION, @_PATTERN_ID
             ,@v_user_id, @sysdate, @v_user_id, @sysdate
             ,@v_user_id, @sysdate, 'INSERT'
          )
          
				  SET @n_log_count = @n_log_count + 1
				  SET @v_descr = 'INSERT NEW OFF(no Dup.) : ' + @_COMPANY_ID + '##' + @_DIVISION_ID + '##' + @_SITE_ID + '##' + @_PLANT_ID + '##' + @_FACTORY_ID
                                       + '##' + @_OPERATION_ID + '##' + @_LINE_ID + '##' + @_EQUIPMENT_ID + '##' + @_OFF_TYPE_ID + '##' + convert(varchar, @_DB_START_TIME, 20)
				  EXEC PR_LOG_PROCESS @sysdate, '-', '-', @v_proc_name, null, 'INSERT', @n_log_count, NULL, @v_descr, null
          
        END
        
      END
      
    END
    
    CLOSE C_BUF_OFF
    
    DEALLOCATE C_BUF_OFF
    
    SET @n_log_count = @n_log_count + 1
    SET @sysdate = GETDATE()
    EXEC PR_LOG_PROCESS @sysdate, '-', '-', @v_proc_name, '###############', 'END', @n_log_count, null, '############### End of procedure ###############', null
    
  END TRY

  BEGIN CATCH
    BEGIN
    
      IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'C_BUF_OFF')
      BEGIN
          CLOSE C_BUF_OFF
          DEALLOCATE C_BUF_OFF
      END
      
      IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'C_DETAIL')
      BEGIN
          CLOSE C_DETAIL
          DEALLOCATE C_DETAIL
      END
      
      
      DECLARE 
        @v_error_message nvarchar(max),
        @v_error_procedure nvarchar(max),
        @v_error_line nvarchar(max)

      SET @v_error_message = ERROR_MESSAGE()

      SET @v_error_procedure = ERROR_PROCEDURE()
  
      SET @v_error_line = convert(nvarchar,ERROR_LINE())


      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_error_procedure, null, 'ERROR', null, @v_error_line, null, @v_error_message

      IF @@TRANCOUNT > 0
         COMMIT WORK 
    END
  END CATCH
  
  
END
