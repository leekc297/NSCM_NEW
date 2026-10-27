CREATE PROCEDURE [dbo].[PR_SCM_FP_CONFIRM_RELEASE]
@p_instance_id nvarchar(MAX) = '-', @p_plan_id nvarchar(MAX) = '-', @p_unit_id nvarchar(MAX) = '-', @p_release_id nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_FP_CONFIRM_RELEASE                                                 **/
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
  EXEC PR_SCM_FP_CONFIRM_RELEASE
*/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- 필수 칼럼
  DECLARE @v_master_id      nvarchar(30)
  DECLARE @v_plan_id        nvarchar(30)
  DECLARE @v_plan_date      nvarchar(30)
  DECLARE @v_release_id     nvarchar(50)
  DECLARE @v_unit_id        nvarchar(50)
  DECLARE @v_factory_id     nvarchar(50)
  DECLARE @v_plan_group_id  nvarchar(50)

  -- LOG 용 변수 설정
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_FP_CONFIRM_RELEASE'
  DECLARE @v_table_name     nvarchar(100)
  DECLARE @v_message        nvarchar(250)
  DECLARE @v_descr          nvarchar(250)
  DECLARE @n_row_count      Integer  = 0
  DECLARE @n_log_count      Integer  = 0
  DECLARE @v_log_code       nvarchar(10)
  
  DECLARE @n_order_seq      Integer  = 0
        , @v_amend_type     nvarchar(30)      -- amend 유형 정보
        , @v_confirm_area   nvarchar(30)      -- factory, plan group 
        
  DECLARE @v_run_master_id      nvarchar(30)
        , @v_run_factory_id     nvarchar(50)
        , @v_run_plan_group_id  nvarchar(50)
        , @v_run_event_time     datetime
  
  DECLARE @sysdate          DATETIME2 = GETDATE()
  DECLARE @v_insert_dttm    date

  DECLARE @v_temp1          nvarchar(1000)
  DECLARE @v_temp2          nvarchar(1000)
  
  -------------------------------------------------------------------------------------------

  SET @v_master_id      = @p_instance_id
  SET @v_plan_id        = @p_plan_id
  SET @v_unit_id        = @p_unit_id
  SET @v_release_id     = @p_release_id
  
  SET @v_temp1 = 'S' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  SET @v_temp2 = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))

  SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', null

  BEGIN TRY

    -- 필수 DATA 쿼리.. 반듯이 있어야 함.
    BEGIN
    
      SELECT @v_plan_date = CONVERT(NVARCHAR, PLAN_START_TIME, 112)
      FROM   SCM_FP_PLAN_H WITH(NOLOCK)
      WHERE  INSTANCE_ID  = @v_master_id
      AND    PLAN_ID      = @v_plan_id

      SET @v_confirm_area = 'BUILDING'

      SELECT @v_confirm_area = ISNULL(MAX(B.ATTRIBUTE1), 'BUILDING')
      FROM   SCM_SYS_LOOKUP_TYPE_M  A WITH(NOLOCK)
           , SCM_SYS_LOOKUP_VALUE   B WITH(NOLOCK)
      WHERE  A.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
      AND    A.LOOKUP_TYPE_CODE = B.LOOKUP_TYPE_CODE
      AND    B.SEGMENT1         = @v_master_id
      
      SET @v_factory_id     = '-'
      SET @v_plan_group_id  = '-'
      
      IF @v_confirm_area = 'BUILDING'
        SET @v_factory_id     = @v_unit_id
      ELSE
        SET @v_plan_group_id  = @v_unit_id

      --LOG 생성
      SET @v_message = 'CONFIRM_AREA : ' + @v_confirm_area
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, @v_log_code, @v_message, null

      SET @v_amend_type = 'AMEND UI'

      SELECT @v_amend_type = ISNULL(MAX(B.ATTRIBUTE1), 'AMEND UI')
      FROM   SCM_SYS_LOOKUP_TYPE_M  A WITH(NOLOCK)
           , SCM_SYS_LOOKUP_VALUE   B WITH(NOLOCK)
      WHERE  A.LOOKUP_TYPE_CODE = 'INSTANCE AMEND UI'
      AND    A.LOOKUP_TYPE_CODE = B.LOOKUP_TYPE_CODE
      AND    B.SEGMENT1         = @v_master_id

      --LOG 생성
      SET @v_message = 'AMEND_TYPE : ' + @v_amend_type
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, @v_log_code, @v_message, null


      BEGIN
      
        SELECT @n_order_seq = ISNULL(MAX(ORDER_SEQ), 0)
        FROM   FP_RELEASE_PLAN_STATUS_H WITH(NOLOCK)
        WHERE  ORDER_SEQ > 0
        
        MERGE INTO FP_RELEASE_PLAN_STATUS_H A
        USING (
                SELECT
                       @v_master_id     AS INSTANCE_ID
                     , @v_factory_id    AS FACTORY_ID
                     , @v_plan_group_id AS PLAN_GROUP_ID
              ) B
        ON    A.INSTANCE_ID   = B.INSTANCE_ID
        AND   A.FACTORY_ID    = B.FACTORY_ID
        AND   A.PLAN_GROUP_ID = B.PLAN_GROUP_ID
        WHEN  MATCHED THEN
              UPDATE  SET RELEASE_STATUS  = 'WAIT'
                        , ORDER_SEQ       = @n_order_seq + 1
                        , USER_ID         = @v_release_id
                        , EVENT_TIME      = GETDATE()
                        , CONFIRM_START   = NULL
                        , CONFIRM_END     = NULL
                        , RELEASE_START   = NULL
                        , RELEASE_END     = NULL
        WHEN  NOT MATCHED THEN
              INSERT ( INSTANCE_ID, FACTORY_ID, PLAN_GROUP_ID, RELEASE_STATUS, ORDER_SEQ, USER_ID, EVENT_TIME )
              VALUES ( @v_master_id, @v_factory_id, @v_plan_group_id, 'WAIT', @n_order_seq + 1, @v_release_id, GETDATE() )
        ;
      
      END

      WHILE 1=1
      BEGIN
      
        SELECT TOP 1
               @v_run_master_id       = A.INSTANCE_ID
             , @v_run_factory_id      = A.FACTORY_ID
             , @v_run_plan_group_id   = A.PLAN_GROUP_ID
             , @v_run_event_time      = A.EVENT_TIME
        FROM   FP_RELEASE_PLAN_STATUS_H A WITH(NOLOCK)
        WHERE  ORDER_SEQ > 0
        ORDER  BY ORDER_SEQ
        
        IF    @v_run_master_id      = @v_master_id
          AND @v_run_factory_id     = @v_factory_id
          AND @v_run_plan_group_id  = @v_plan_group_id
          BREAK

        IF DATEDIFF(SECOND, @v_run_event_time, GETDATE()) > 300
        BEGIN

          UPDATE A
          SET    A.RELEASE_STATUS = 'ERROR'
               , A.ORDER_SEQ      = 0
               , A.EVENT_TIME     = GETDATE()
          FROM   FP_RELEASE_PLAN_STATUS_H A
          WHERE  A.INSTANCE_ID    = @v_run_master_id
          AND    A.FACTORY_ID     = @v_run_factory_id
          AND    A.PLAN_GROUP_ID  = @v_run_plan_group_id
          AND    A.ORDER_SEQ      > 0
          AND    DATEDIFF(SECOND, A.EVENT_TIME, GETDATE()) > 300    -- 5분 이상 차이가 나면 다음 STEP 이 돌도록 설정
          
        END

        WAITFOR DELAY '0:0:1'
            
      END

      UPDATE FP_RELEASE_PLAN_STATUS_H
      SET    RELEASE_STATUS = 'RUN'
           , EVENT_TIME     = GETDATE()
           , CONFIRM_START  = GETDATE()
      WHERE  INSTANCE_ID    = @v_master_id
      AND    FACTORY_ID     = @v_factory_id
      AND    PLAN_GROUP_ID  = @v_plan_group_id

      --------------------------------------------------------------------------
      -- CONFIRM 프로시저 실행
      --------------------------------------------------------------------------
      BEGIN
      
        IF @v_confirm_area = 'BUILDING'
          BEGIN
          
            IF @v_amend_type = 'PSI AMEND UI'
              EXEC dbo.PR_SCM_RF_RESCHEDULE_PSI_AMEND               @v_master_id, @v_plan_id, @v_factory_id
                
            ELSE 
            	BEGIN
	            	IF    CHARINDEX('E_POST',  @v_master_id) > 0
	            		EXEC dbo.PR_SCM_RF_RESCHEDULE_FP_AMEND_POST          @v_master_id, @v_plan_id, @v_factory_id
		            ELSE 
		            	EXEC dbo.PR_SCM_RF_RESCHEDULE_FP_AMEND          @v_master_id, @v_plan_id, @v_factory_id
            	END
              
          
            UPDATE SCM_FP_PLAN_DETAIL_H
            SET    CONFIRM_FLAG   = 'Y'
            WHERE  INSTANCE_ID    = @v_master_id
            AND    PLAN_ID        = @v_plan_id
            AND    FACTORY_ID     = @v_factory_id
                
          END
        ELSE
          BEGIN

            IF @v_amend_type = 'PSI AMEND UI'
              EXEC dbo.PR_SCM_RF_PLAN_GROUP_RESCHEDULE_PSI_AMEND  @v_master_id, @v_plan_id, @v_plan_group_id
                
            ELSE
              EXEC dbo.PR_SCM_RF_PLAN_GROUP_RESCHEDULE_FP_AMEND   @v_master_id, @v_plan_id, @v_plan_group_id
                

            UPDATE SCM_FP_PLAN_GROUP_DETAIL_H
            SET    CONFIRM_FLAG   = 'Y'
            WHERE  INSTANCE_ID    = @v_master_id
            AND    PLAN_ID        = @v_plan_id
            AND    PLAN_GROUP_ID  = @v_plan_group_id

          END
      
      END

      
      UPDATE FP_RELEASE_PLAN_STATUS_H
      SET    RELEASE_STATUS = 'RUN'
           , EVENT_TIME     = GETDATE()
           , CONFIRM_END    = GETDATE()
           , RELEASE_START  = GETDATE()
      WHERE  INSTANCE_ID    = @v_master_id
      AND    FACTORY_ID     = @v_factory_id
      AND    PLAN_GROUP_ID  = @v_plan_group_id

      --------------------------------------------------------------------------
      -- RELEASE 프로시저 실행
      --------------------------------------------------------------------------
      BEGIN

        IF @v_confirm_area = 'BUILDING'
          BEGIN

            IF @v_amend_type = 'PSI AMEND UI'
              EXEC dbo.PR_SCM_IF_PLAN_RELEASE_PSI_AMEND             @v_master_id, @v_plan_date, @v_release_id, @v_factory_id
                
            ELSE
            	BEGIN
	            	IF    CHARINDEX('E_POST',  @v_master_id) > 0
	            		EXEC dbo.PR_SCM_IF_PLAN_RELEASE_FP_AMEND_POST       @v_master_id, @v_plan_date, @v_release_id, @v_factory_id
					ELSE
						EXEC dbo.PR_SCM_IF_PLAN_RELEASE_FP_AMEND              @v_master_id, @v_plan_date, @v_release_id, @v_factory_id
				END
              
          END
        ELSE
          BEGIN
          
            IF @v_amend_type = 'PSI AMEND UI'
              EXEC dbo.PR_SCM_IF_PLAN_GROUP_RELEASE_PSI_AMEND       @v_master_id, @v_plan_date, @v_release_id, @v_plan_group_id
              
            ELSE 
              EXEC dbo.PR_SCM_IF_PLAN_GROUP_RELEASE_FP_AMEND        @v_master_id, @v_plan_date, @v_release_id, @v_plan_group_id
          
          END
      END
      

      UPDATE FP_RELEASE_PLAN_STATUS_H
      SET    RELEASE_STATUS = 'END'
           , ORDER_SEQ      = 0
           , EVENT_TIME     = GETDATE()
           , RELEASE_END    = GETDATE()
      WHERE  INSTANCE_ID    = @v_master_id
      AND    FACTORY_ID     = @v_factory_id
      AND    PLAN_GROUP_ID  = @v_plan_group_id


--------------------------------------------------------------------------      
--------------------------------------------------------------------------      

      WAITFOR DELAY '0:0:1'

    END;    
  END TRY

  BEGIN CATCH
    --ROLLBACK
    SET @v_descr = ERROR_MESSAGE()
    SET @sysdate = GETDATE()

    EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'ERROR', null, @v_temp2, null, @v_descr
    commit;
	RETURN(-1) --ERROR
  END CATCH

  SET @n_log_count = @n_log_count + 1
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null
  RETURN(0) --성공: 0
END
