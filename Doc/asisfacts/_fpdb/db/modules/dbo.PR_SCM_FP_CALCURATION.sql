CREATE PROCEDURE [dbo].[PR_SCM_FP_CALCURATION]
@p_instance_id nvarchar(MAX) = '-', @p_plan_id nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_FP_CALCURATION                                                     **/
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
/** 2026/06/08   kimcd      [PJ2026-50273] MI ESS LINK 공장 SCM(SCP/FP/PSCM ) 대응.            **/
/**                         Pack 공정군 로직에 LINK 공정군 추가                                 **/
/***********************************************************************************************/
/*
  EXEC PR_SCM_FP_CALCURATION
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
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_FP_CALCURATION'
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
        , @v_run_event_time     datetime
        
  DECLARE @sysdate          DATETIME2 = GETDATE()
  DECLARE @v_insert_dttm    date

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
    
      SET @v_amend_type = 'AMEND UI'

      SELECT @v_amend_type = ISNULL(MAX(B.ATTRIBUTE1), 'AMEND UI')
      FROM   SCM_SYS_LOOKUP_TYPE_M  A
           , SCM_SYS_LOOKUP_VALUE   B
      WHERE  A.LOOKUP_TYPE_CODE = 'INSTANCE AMEND UI'
      AND    A.LOOKUP_TYPE_CODE = B.LOOKUP_TYPE_CODE
      AND    B.SEGMENT1         = @v_master_id

      --LOG 생성
      SET @v_message = 'AMEND_TYPE : ' + @v_amend_type
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, @v_log_code, @v_message, null


      BEGIN
      
        SELECT @n_order_seq = ISNULL(MAX(ORDER_SEQ), 0)
        FROM   FP_RELEASE_CALCULATION_STATUS_H
        WHERE  ORDER_SEQ > 0
        
        MERGE INTO FP_RELEASE_CALCULATION_STATUS_H A
        USING (
                SELECT
                       @v_master_id     AS INSTANCE_ID
              ) B
        ON    A.INSTANCE_ID   = B.INSTANCE_ID
        WHEN  MATCHED THEN
              UPDATE  SET CALCULATION_STATUS  = 'WAIT'
                        , ORDER_SEQ           = @n_order_seq + 1
                        , EVENT_TIME          = GETDATE()
                        , CALCULATION_START   = NULL
                        , CALCULATION_END     = NULL
        WHEN  NOT MATCHED THEN
              INSERT ( INSTANCE_ID, CALCULATION_STATUS, ORDER_SEQ, EVENT_TIME )
              VALUES ( @v_master_id, 'WAIT', @n_order_seq + 1, GETDATE() )
        ;
      
      END

      WHILE 1=1
      BEGIN
      
        SELECT TOP 1
               @v_run_master_id       = A.INSTANCE_ID
             , @v_run_event_time      = A.EVENT_TIME
        FROM   FP_RELEASE_CALCULATION_STATUS_H A WITH(NOLOCK)
        WHERE  ORDER_SEQ > 0
        ORDER  BY ORDER_SEQ, INSTANCE_ID
        
        IF    @v_run_master_id      = @v_master_id
          BREAK

        IF DATEDIFF(SECOND, @v_run_event_time, GETDATE()) > 300
        BEGIN

          UPDATE A
          SET    A.CALCULATION_STATUS = 'ERROR'
               , A.ORDER_SEQ          = 0
               , A.EVENT_TIME         = GETDATE()
          FROM   FP_RELEASE_CALCULATION_STATUS_H A
          WHERE  A.INSTANCE_ID        = @v_run_master_id
          AND    A.ORDER_SEQ          > 0
          AND    DATEDIFF(SECOND, A.EVENT_TIME, GETDATE()) > 300    -- 5분 이상 차이가 나면 다음 STEP 이 돌도록 설정
          
        END

        WAITFOR DELAY '0:0:1'
            
      END

      UPDATE FP_RELEASE_CALCULATION_STATUS_H
      SET    CALCULATION_STATUS = 'RUN'
           , EVENT_TIME         = GETDATE()
           , CALCULATION_START  = GETDATE()
      WHERE  INSTANCE_ID        = @v_master_id

      
      --------------------------------------------------------------------------
      -- WPP / MPP 프로시저 실행
      --------------------------------------------------------------------------
      BEGIN
      
        IF    CHARINDEX('CELL', @v_master_id) > 0
          OR  CHARINDEX('PACK', @v_master_id) > 0
		  OR  CHARINDEX('LINK', @v_master_id) > 0  -- 2026/06/08 kimcd [PJ2026-50273] MI ESS LINK 공장 SCM(SCP/FP/PSCM ) 대응. Pack 공정군 로직에 LINK 공정군 추가  
        BEGIN
        
          EXEC dbo.PR_SCM_FP_WPPMPP_REBUILD_LINE    @v_master_id, @v_plan_id
        
        END
        
        IF    CHARINDEX('E_PRE',  @v_master_id) > 0
          --OR  CHARINDEX('E_PMIX', @v_master_id) > 0
        BEGIN
        
          EXEC dbo.PR_SCM_FP_WPPMPP_REBUILD_ELEC    @v_master_id, @v_plan_id
          
        END
      
		IF    CHARINDEX('E_POST',  @v_master_id) > 0	--@@@ 후공정 추가 
		BEGIN
			EXEC dbo.PR_SCM_FP_REBUILD_POST    @v_master_id, @v_plan_id
        END
        
      END
      

      --------------------------------------------------------------------------
      -- CALCULATION 프로시저 실행
      --------------------------------------------------------------------------
      IF @v_amend_type = 'PSI AMEND UI'
        BEGIN

          -- 2018.05.15 : 사용자가 시뮬레이션 버튼을 안해서, 여기서 진행하도록 함
          IF CHARINDEX('FORM', @v_master_id) > 0 AND @v_master_id <> 'CN_FORM_T'
            EXEC dbo.PR_SCM_OF_PSI_AMEND_UI_CALCULATION_FORM    @v_master_id, @v_plan_id , 'Y'
          
          ELSE
            EXEC dbo.PR_SCM_OF_PSI_AMEND_UI_CALCULATION         @v_master_id, @v_plan_id, 'Y'
        
        END
          
      UPDATE FP_RELEASE_CALCULATION_STATUS_H
      SET    CALCULATION_STATUS = 'END'
           , ORDER_SEQ          = 0
       , EVENT_TIME         = GETDATE()
           , CALCULATION_END    = GETDATE()
      WHERE  INSTANCE_ID    = @v_master_id

	  
    END;    
  END TRY

  BEGIN CATCH
    --ROLLBACK
    SET @v_descr = ERROR_MESSAGE()
    SET @sysdate = GETDATE()

    EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'ERROR', null, @v_temp2, null, @v_descr
    commit;

	RETURN(-1) -- 신규 UI Return ERROR

  END CATCH

  SET @n_log_count = @n_log_count + 1
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null

  RETURN(0) -- 신규 UI Return 성공: 0

END
