CREATE PROCEDURE [dbo].[PR_SCM_RUN_ENGINE]
@p_master_id nvarchar(MAX) = '-', @p_plan_id nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_IF_PLAN                                                            **/
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
/***********************************************************************************************/
/*
  EXEC PR_SCM_IF_PLAN
*/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- 필수 칼럼
  DECLARE @v_company        nvarchar(30)   
  DECLARE @v_division        nvarchar(30)
  DECLARE @v_corporation    nvarchar(30)
  DECLARE @v_plant           nvarchar(30)
  DECLARE @v_master_id      nvarchar(30)
  DECLARE @v_plan_id        nvarchar(30)
  DECLARE @v_instance_id    nvarchar(30)  

  -- LOG 용 변수 설정
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_RUN_ENGINE'
  DECLARE @v_table_name     nvarchar(100)
  DECLARE @v_message        nvarchar(250)
  DECLARE @v_descr          nvarchar(250)
  DECLARE @n_row_count      Integer  = 0
  DECLARE @n_log_count      Integer  = 0
  DECLARE @v_log_code        nvarchar(10)
  
  DECLARE @sysdate          DATETIME2 = GETDATE()
  DECLARE @key_date         nvarchar(8)  
  DECLARE @eng_count        Integer
  DECLARE @eng_sleep        Integer

  DECLARE @v_temp1        nvarchar(1000)
  DECLARE @v_temp2        nvarchar(1000)
  
  SET @v_master_id  = @p_master_id
  SET @v_plan_id    = @p_plan_id

  SET @n_log_count = @n_log_count + 1
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', null

  BEGIN TRY
    
    BEGIN
      
      IF @v_master_id <> '-'  
          AND dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0

        BEGIN

          SELECT @key_date = PLAN_DATE
          FROM   TH_MST_PLAN
          WHERE  MASTER_ID = @v_master_id
          AND    PLAN_ID = @v_plan_id        
        
          DELETE FROM TH_MST_ENG_PLAN_FLAG
          WHERE  MASTER_ID = @v_master_id 
          AND    PLAN_ID = @v_plan_id 
          AND    OUT_VERSION_ID = @v_plan_id
          
          UPDATE TH_MST_ENG_PLAN_FLAG
          SET    ACTIVE_FLAG = 0

          INSERT INTO TH_MST_ENG_PLAN_FLAG
                (
                  MASTER_ID
                , PLAN_ID
                , OUT_VERSION_ID
                , ACTIVE_FLAG
                , INBOUND_FLAG
                , INBOUND_START
                , ENGINE_FLAG
                , OUTBOUND_FLAG
                , DB_TRANS_FLAG
                , KEY_DATE
                , INSERT_ID
                , INSERT_DATE
                , UPDATE_ID
                , UPDATE_DATE
                )
          SELECT 
                  @v_master_id
                , @v_plan_id
                , @v_plan_id AS out_version_id
                , 1 AS active_flag
                , 'P' AS inbound_flag
                , sysdatetime() AS inbound_start
                , 'R' AS engine_flag
                , 'R' AS outbound_flag
                , 'R' AS db_trans_flag
                , @key_date as key_date
                , @v_proc_name AS insert_id
                , sysdatetime() AS insert_date
                , @v_proc_name AS update_id
                , sysdatetime() AS update_date
        
            
          EXECUTE dbo.PR_SCM_MF_MST_ENG  @v_master_id,@v_plan_id ;
          
          /* -- 엔진 수행 대기 로직
          SET @eng_sleep = 0
          WHILE 1=1
            BEGIN

              set @eng_sleep += 1
              
              SELECT @eng_count = COUNT(1)
              FROM   TH_ENG_PLAN_STATUS
              WHERE  MASTER_ID = @v_master_id
              AND    PLAN_ID = @v_plan_id

              IF @eng_count = 4 or @eng_sleep > 600 -- 10분동안 종료 안되면 강제 종료
                BREAK

              WAITFOR DELAY '0:0:1'   -- 1초 동안 sleep

            END
          */

        END

      IF dbo.fn_plan_status(@v_master_id, @v_plan_id) > 0
         UPDATE SY_FP_PLAN_STATUS_H
            SET 
               ACTIVE_FLAG = 0,
               INBOUND_FLAG = 'S',
               INBOUND_END = sysdatetime(), 
               UPDATE_ID = @v_proc_name, 
               UPDATE_TIME = sysdatetime()
         FROM SY_FP_PLAN_STATUS_H  AS a
         WHERE 
            a.INSTANCE_ID = @v_master_id AND 
            a.PLAN_ID = @v_plan_id            

      IF @@TRANCOUNT > 0
        COMMIT WORK 
        
    END
    
  END TRY

  BEGIN CATCH
    --ROLLBACK
    SET @v_log_code = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
    SET @v_descr = ERROR_MESSAGE()

    EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'ERROR', null, @v_log_code, null, @v_descr
    commit;
  END CATCH

  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'END', 999999, '#######   Engine Start   #######', '############### End of procedure ###############', null

END
