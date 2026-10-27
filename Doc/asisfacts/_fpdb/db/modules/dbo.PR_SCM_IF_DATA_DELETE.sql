CREATE PROCEDURE [dbo].[PR_SCM_IF_DATA_DELETE]
   @p_master_id nvarchar(max) = '-',
   @p_plan_id nvarchar(max) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_IF_DATA_DELETE                                                     **/
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
  EXEC PR_SCM_IF_DATA_DELETE
*/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- 필수 칼럼
  DECLARE @v_master_id      nvarchar(30)
  DECLARE @v_plan_id        nvarchar(30)

  -- LOG 용 변수 설정
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_IF_DATA_DELETE'
  DECLARE @v_table_name     nvarchar(100)
  DECLARE @v_message        nvarchar(250)
  DECLARE @v_descr          nvarchar(250)
  DECLARE @n_row_count      Integer  = 0
  DECLARE @n_log_count      Integer  = 0
  DECLARE @v_log_code       nvarchar(10)
  
  DECLARE @sysdate          DATETIME2 = GETDATE()
  DECLARE @key_date         nvarchar(8)
  DECLARE @period           int = 7        -- 보관 기간 설정
  DECLARE @v_seq            nvarchar(1000)

  DECLARE @v_temp1          nvarchar(1000)
  DECLARE @v_temp2          nvarchar(1000)
  
  SET @v_master_id  = @p_master_id
  SET @v_plan_id    = @p_plan_id
  
  SET @v_temp1 = 'S' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  SET @v_temp2 = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  
  -- PLAN 설정 안되면 DEFAULT 값으로 설정한다.
  IF @v_master_id = '-' OR @v_plan_id = '-'
    BEGIN
    
      SELECT TOP 1 
             @v_master_id = MASTER_ID
      FROM   TH_MST_PLAN
      ORDER  BY PLAN_START_DTTM DESC, UPDATE_DTTM DESC
      
      SET @v_plan_id = @v_master_id + '-' + CONVERT(NVARCHAR, GETDATE(), 112) + '-00'

    END
  
  SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', null

  BEGIN TRY
    
    SET @key_date = CONVERT(NVARCHAR, DATEADD(DAY, -1 * @period, GETDATE()), 112)
    
    
    DECLARE
      @c_t$table_name   nvarchar(max),
      @c_t$master_id    nvarchar(max),
      @c_t$plan_id      nvarchar(max)
        
    DECLARE
      C_TABLE CURSOR LOCAL FOR 
        SELECT A.TABLE_NAME, B.COLUMN_NAME AS MASTER_ID, A.COLUMN_NAME AS PLAN_ID
        FROM   (
                SELECT DISTINCT TABLE_NAME, COLUMN_NAME
                FROM   INFORMATION_SCHEMA.COLUMNS WHERE 1=1
                AND    COLUMN_NAME LIKE '%PLAN_ID'
                AND    SUBSTRING(TABLE_NAME, 1, 6) IN ('TH_MST','TH_ENG','TH_OUT','TH_LOG','TH_EXP','TH_BUF','TH_DPP')
                AND    TABLE_NAME NOT IN ('TH_MST_PLAN', 'TH_ENG_PLAN_INFO')
                AND    TABLE_NAME NOT IN ('TH_MST_SCM_DEMAND')
                UNION  ALL
                SELECT DISTINCT TABLE_NAME, COLUMN_NAME
                FROM   INFORMATION_SCHEMA.COLUMNS WHERE 1=1
                AND    COLUMN_NAME LIKE '%PLAN_ID'
                AND    SUBSTRING(TABLE_NAME, 1, 3) IN ('BUF')
               ) A
               LEFT OUTER JOIN INFORMATION_SCHEMA.COLUMNS B
                    ON    A.TABLE_NAME = B.TABLE_NAME
                    AND   (   B.COLUMN_NAME LIKE '%MASTER_ID%'
                            OR
                              B.COLUMN_NAME LIKE '%INSTANCE_ID%'
                          )
        ORDER  BY 1

    BEGIN

      OPEN C_TABLE

      WHILE 1 = 1
     
        BEGIN
        
          SET @n_row_count = 0

          FETCH C_TABLE
           INTO @c_t$table_name, @c_t$master_id, @c_t$plan_id

          IF @@FETCH_STATUS <> 0
            BREAK
    
          IF @c_t$table_name IN ('TH_ENG_SETUP_MATRIX', 'TH_MST_SETUP_CATEGORY', 'TH_MST_SETUP_TIME')
            BEGIN
            
              SET @v_seq = 'TRUNCATE TABLE ' + @c_t$table_name + ' '
              
              exec ( @v_seq )

              SET @n_row_count += @@ROWCOUNT
              
            
            END
          ELSE IF CHARINDEX('TH_ENG', @c_t$table_name) > 0
            BEGIN

              -- AMEND
              SET @v_seq = 'DELETE FROM A FROM ' + @c_t$table_name + ' '
                             + ' A, TH_MST_PLAN C '
                             + ' WHERE  1=1 '
                             + ( CASE WHEN @c_t$master_id IS NULL THEN ''
                                      ELSE ' AND    A.'+@c_t$master_id+' = C.MASTER_ID '
                                 END  ) 
                             + ' AND    A.'+@c_t$plan_id+' = C.PLAN_ID + ''_AMEND'' '
                             + ' AND    C.KEY_DATE <= '''+@key_date+''''
              
              exec ( @v_seq )
              
              SET @n_row_count += @@ROWCOUNT

              
              -- RUN-01
              SET @v_seq = 'DELETE FROM A FROM ' + @c_t$table_name + ' '
                             + ' A, TH_MST_PLAN C '
                             + ' WHERE  1=1 '
                             + ( CASE WHEN @c_t$master_id IS NULL THEN ''
                                      ELSE ' AND    A.'+@c_t$master_id+' = C.MASTER_ID '
                                 END  ) 
                             + ' AND    A.'+@c_t$plan_id+' = C.PLAN_ID + ''_RUN-01'' '
                             + ' AND    C.KEY_DATE <= '''+@key_date+''''
              
              exec ( @v_seq )

              SET @n_row_count += @@ROWCOUNT

              
              -- RUN-02
              SET @v_seq = 'DELETE FROM A FROM ' + @c_t$table_name + ' '
                             + ' A, TH_MST_PLAN C '
                             + ' WHERE  1=1 '
                             + ( CASE WHEN @c_t$master_id IS NULL THEN ''
                                      ELSE ' AND    A.'+@c_t$master_id+' = C.MASTER_ID '
                                 END  ) 
                             + ' AND    A.'+@c_t$plan_id+' = C.PLAN_ID + ''_RUN-02'' '
                             + ' AND    C.KEY_DATE <= '''+@key_date+''''
              
              exec ( @v_seq )

              SET @n_row_count += @@ROWCOUNT

              -- RUN-11
              SET @v_seq = 'DELETE FROM A FROM ' + @c_t$table_name + ' '
                             + ' A, TH_MST_PLAN C '
                             + ' WHERE  1=1 '
                             + ( CASE WHEN @c_t$master_id IS NULL THEN ''
                                      ELSE ' AND    A.'+@c_t$master_id+' = C.MASTER_ID '
                                 END  ) 
                             + ' AND    A.'+@c_t$plan_id+' = C.PLAN_ID + ''_RUN-11'' '
                             + ' AND    C.KEY_DATE <= '''+@key_date+''''
              
              exec ( @v_seq )

              SET @n_row_count += @@ROWCOUNT

              
              -- RUN-12
              SET @v_seq = 'DELETE FROM A FROM ' + @c_t$table_name + ' '
                             + ' A, TH_MST_PLAN C '
                             + ' WHERE  1=1 '
                             + ( CASE WHEN @c_t$master_id IS NULL THEN ''
                                      ELSE ' AND    A.'+@c_t$master_id+' = C.MASTER_ID '
                                 END  ) 
                             + ' AND    A.'+@c_t$plan_id+' = C.PLAN_ID + ''_RUN-12'' '
                             + ' AND    C.KEY_DATE <= '''+@key_date+''''
              
              exec ( @v_seq )

              SET @n_row_count += @@ROWCOUNT
              
              -- RUN-13
              SET @v_seq = 'DELETE FROM A FROM ' + @c_t$table_name + ' '
                             + ' A, TH_MST_PLAN C '
                             + ' WHERE  1=1 '
                             + ( CASE WHEN @c_t$master_id IS NULL THEN ''
                                      ELSE ' AND    A.'+@c_t$master_id+' = C.MASTER_ID '
                                 END  ) 
                             + ' AND    A.'+@c_t$plan_id+' = C.PLAN_ID + ''_RUN-13'' '
                             + ' AND    C.KEY_DATE <= '''+@key_date+''''
              
              exec ( @v_seq )

              SET @n_row_count += @@ROWCOUNT

              
              -- RUN-14
              SET @v_seq = 'DELETE FROM A FROM ' + @c_t$table_name + ' '
                             + ' A, TH_MST_PLAN C '
                             + ' WHERE  1=1 '
                             + ( CASE WHEN @c_t$master_id IS NULL THEN ''
                                      ELSE ' AND    A.'+@c_t$master_id+' = C.MASTER_ID '
                                 END  ) 
                             + ' AND    A.'+@c_t$plan_id+' = C.PLAN_ID + ''_RUN-14'' '
                             + ' AND    C.KEY_DATE <= '''+@key_date+''''
              
              exec ( @v_seq )

              SET @n_row_count += @@ROWCOUNT

              -- NULL
              SET @v_seq = 'DELETE FROM A FROM ' + @c_t$table_name + ' '
                             + ' A, TH_MST_PLAN C '
                             + ' WHERE  1=1 '
                             + ( CASE WHEN @c_t$master_id IS NULL THEN ''
                                      ELSE ' AND    A.'+@c_t$master_id+' = C.MASTER_ID '
                                 END  ) 
                             + ' AND    A.'+@c_t$plan_id+' = C.PLAN_ID + ''_NULL'' '
                             + ' AND    C.KEY_DATE <= '''+@key_date+''''
              
              exec ( @v_seq )

              SET @n_row_count += @@ROWCOUNT
              
              -- ORGINAL
              SET @v_seq = 'DELETE FROM A FROM ' + @c_t$table_name + ' '
                             + ' A, TH_MST_PLAN C '
                             + ' WHERE  1=1 '
                             + ( CASE WHEN @c_t$master_id IS NULL THEN ''
                                      ELSE ' AND    A.'+@c_t$master_id+' = C.MASTER_ID '
                                 END  ) 
                             + ' AND    A.'+@c_t$plan_id+' = C.PLAN_ID '
                             + ' AND    C.KEY_DATE <= '''+@key_date+''''

              exec ( @v_seq )

              SET @n_row_count += @@ROWCOUNT

            END
          ELSE IF @c_t$table_name = 'TH_MST_OFF_CALENDAR'
               OR @c_t$table_name = 'TH_DPP_NET_DEMAND'
               OR @c_t$table_name = 'TH_MST_SCM_ORDER_STATUS'
               OR @c_t$table_name = 'TH_EXP_DAILY_PRODUCTION_PLAN'
            BEGIN

              -- _BAK
              SET @v_seq = 'DELETE FROM A FROM ' + @c_t$table_name + ' '
                             + ' A, TH_MST_PLAN C '
                             + ' WHERE  1=1 '
                             + ( CASE WHEN @c_t$master_id IS NULL THEN ''
                                      ELSE ' AND    A.'+@c_t$master_id+' = C.MASTER_ID '
                                 END  ) 
                             + ' AND    A.'+@c_t$plan_id+' = C.PLAN_ID + ''_BAK'' '
                             + ' AND    C.KEY_DATE <= '''+@key_date+''''
              
              exec ( @v_seq )

              SET @n_row_count += @@ROWCOUNT

              
              -- BAK
              SET @v_seq = 'DELETE FROM A FROM ' + @c_t$table_name + ' '
                             + ' A, TH_MST_PLAN C '
                             + ' WHERE  1=1 '
                             + ( CASE WHEN @c_t$master_id IS NULL THEN ''
                                      ELSE ' AND    A.'+@c_t$master_id+' = C.MASTER_ID '
                                 END  ) 
                             + ' AND    A.'+@c_t$plan_id+' = C.PLAN_ID + ''BAK'' '
                             + ' AND    C.KEY_DATE <= '''+@key_date+''''
              
              exec ( @v_seq )

              SET @n_row_count += @@ROWCOUNT

              
              -- _BACK
              SET @v_seq = 'DELETE FROM A FROM ' + @c_t$table_name + ' '
                             + ' A, TH_MST_PLAN C '
                             + ' WHERE  1=1 '
                             + ( CASE WHEN @c_t$master_id IS NULL THEN ''
                                      ELSE ' AND    A.'+@c_t$master_id+' = C.MASTER_ID '
                                 END  ) 
                             + ' AND    A.'+@c_t$plan_id+' = C.PLAN_ID + ''_BACK'' '
                             + ' AND    C.KEY_DATE <= '''+@key_date+''''
              
              exec ( @v_seq )

              SET @n_row_count += @@ROWCOUNT

              
              -- ORGINAL
              SET @v_seq = 'DELETE FROM A FROM ' + @c_t$table_name + ' '
                             + ' A, TH_MST_PLAN C '
                             + ' WHERE  1=1 '
                             + ( CASE WHEN @c_t$master_id IS NULL THEN ''
                                      ELSE ' AND    A.'+@c_t$master_id+' = C.MASTER_ID '
                                 END  ) 
                             + ' AND    A.'+@c_t$plan_id+' = C.PLAN_ID '
                             + ' AND    C.KEY_DATE <= '''+@key_date+''''

              exec ( @v_seq )

              SET @n_row_count += @@ROWCOUNT

            END
          ELSE
            BEGIN
            
              SET @v_seq = 'DELETE FROM A FROM ' + @c_t$table_name + ' '
                             + ' A, TH_MST_PLAN C '
                             + ' WHERE  1=1 '
                             + ( CASE WHEN @c_t$master_id IS NULL THEN ''
                                      ELSE ' AND    A.'+@c_t$master_id+' = C.MASTER_ID '
                                 END  ) 
                             + ' AND    A.'+@c_t$plan_id+' = C.PLAN_ID '
                             + ' AND    C.KEY_DATE <= '''+@key_date+''''
          
              exec ( @v_seq )
            
              SET @n_row_count += @@ROWCOUNT
              
            END
    
          
          SET @v_table_name = @c_t$table_name
                
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_seq

        END
        
      CLOSE C_TABLE

      DEALLOCATE C_TABLE

    END
    
    -- 예외 CASE 테이블 유지
    BEGIN

      SET @v_table_name = 'TH_MST_SCM_DEMAND'

      -- 활성화만 반영함..
      IF CHARINDEX('FORM_A', @v_master_id) > 0
        BEGIN
        
          DELETE FROM A
          FROM   TH_MST_SCM_DEMAND  A
               , TH_MST_PLAN        B
          WHERE  A.INSTANCE_ID      = @v_master_id
          AND    A.INSTANCE_ID      = B.MASTER_ID
          AND    A.DPP_PLAN_ID      = B.PLAN_ID
          AND    B.PLAN_START_DTTM  < DATEADD(DAY, -100, GETDATE())
        
        END
      ELSE
        BEGIN
        
          DELETE FROM A
          FROM   TH_MST_SCM_DEMAND  A
               , TH_MST_PLAN        B
          WHERE  A.INSTANCE_ID      = @v_master_id
          AND    A.INSTANCE_ID      = B.MASTER_ID
          AND    A.DPP_PLAN_ID      = B.PLAN_ID
          AND    B.PLAN_START_DTTM  < DATEADD(DAY, -1 * @period, GETDATE())
        
        END
        
    
      --LOG 생성
      SET @v_message = @@ROWCOUNT
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_seq
    
    END
    
    IF @@TRANCOUNT > 0
      COMMIT WORK 
      
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
