

/*
 * Program ID   : PR_SCM_KPI_TIMELINE
 * Description  : Time Line 준수율 데이타 생성 : 매주 일요일 밤에 당주 정보 생성
 * OutTable     :
 * Execute      : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019.04.22   KSG            Initial Release ******
 */
 
CREATE PROCEDURE [dbo].[PR_SCM_KPI_TIMELINE]
(
   @p_basis_yyyymmdd  NVARCHAR(8)=null
 )
 AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'scm_batch';
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCM_KPI_TIMELINE';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      
    DECLARE @v_table_id     NVARCHAR(150) = N'SCM_KPI_TIMELINE'; 
    DECLARE @d_event_date   DATETIME;

    -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SCM_KPI_TIMELINE INSERT LOGIC';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                              ,@p_log_type      = @v_log_type
                              ,@p_log_count     = @n_log_count 
                              ,@p_log_message   = @v_log_message 
                              ,@p_description   = @v_description 
                              ,@p_event_date    = @d_event_date 
                              ,@p_user_id       = @v_batch_user
                              ;
    

  -- 업무용 변수
  DECLARE @v_basis_yyyymmdd  NVARCHAR(8);  -- 기준 일자  
  DECLARE @v_plan_id         NVARCHAR(8);  -- 
  DECLARE @rows INT;         

  BEGIN TRY
    BEGIN
      ------------------------------------------------------------------------------------
      -- 매주 일요일에 월요일 일자로 적재한다. 
      ------------------------------------------------------------------------------------
      -- 기준일자 설정
      IF @p_basis_yyyymmdd IS NOT NULL
        BEGIN
          SET @v_basis_yyyymmdd = @p_basis_yyyymmdd;
        END
      ELSE
        BEGIN
          SET @v_basis_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) -- 당주 월요일(일요일 밤에 Batch 실행 시)
        END
      ;

	  -- 기준일자의 Plan ID 설정
	  SELECT @v_plan_id = plan_id
      FROM   scm_mst_plan p WITH(NOLOCK)
      WHERE  p.plan_name   = @v_basis_yyyymmdd 
      AND    p.division_id = '81' -- 사업부 상관없이 동일하므로 하나만 가져오기 위해 설정
      AND    p.plan_cycle  = 'WEEKLY'
	  ;
	  
      ------------------------------------------------------------------------------------
	  -- 동일 주차정보 삭제 
      DELETE 
      FROM   SCM_KPI_TIMELINE
      WHERE  plan_start_yyyymmdd = @v_basis_yyyymmdd;
	  
	  -- Time Line 준수율 데이타 생성
      INSERT INTO SCM_KPI_TIMELINE (
            division_id, plan_start_yyyymmdd, plan_type, plan_seq
          , plan_start_date
          , plan_start_week_day
          , plan_week_day
          , plan_start_time
          , plan_time
          , valid_type
          , created_by, creation_date, last_updated_by, last_update_date)

      SELECT p.division_id, p.plan_name, pd.plan_type, pd.plan_seq
           , CONVERT(CHAR(13), pd.input_start_date, 120) AS plan_start_date
           , DATEPART(DW,pd.input_start_date)            AS plan_start_week_day
    	   , l.segment3                                  AS plan_week_day
           , CONVERT(CHAR(2), pd.input_start_date, 114)  AS plan_start_time
           , l.segment4                                  AS plan_time
           , CASE WHEN DATEPART(DW,pd.input_start_date) = l.segment3 AND CONVERT(CHAR(2), pd.input_start_date, 114) = l.segment4
                    THEN 'OK'
                  ELSE 'NG'
             END AS type
           , @v_batch_user, GETDATE(), @v_batch_user, GETDATE()
      FROM   scm_mst_plan p WITH(NOLOCK)
           , scm_mst_plan_detail pd WITH(NOLOCK)
	       ,(SELECT division_id, plan_id, plan_type, MAX(plan_seq) AS plan_seq
             FROM   scm_mst_plan_detail WITH(NOLOCK)
             WHERE  plan_id     = @v_plan_id
             AND    plan_status = '1'
             GROUP BY division_id, plan_id, plan_type
            ) pdm
           , scm_adm_lookup_master_detail l WITH(NOLOCK)
      WHERE  p.division_id  = pd.division_id
      AND    p.plan_id      = pd.plan_id
      AND    p.plan_cycle   = 'WEEKLY'
      AND    p.plan_name    = @v_basis_yyyymmdd 
      AND    pd.division_id = pdm.division_id
      AND    pd.plan_id     = pdm.plan_id
      AND    pd.plan_type   = pdm.plan_type
      AND    pd.plan_seq    = pdm.plan_seq
      AND    p.division_id  = l.segment1
      AND    pd.plan_type   = l.segment2
      AND    l.lookup_type  = 'PLAN_TIME'
      AND    l.valid_yn     = 'Y'
      ;

      SET @n_log_count = @@ROWCOUNT;

    END

  END TRY

  BEGIN CATCH
     
    -- ERROR LOG
    SET @v_log_type = N'ERROR';
    SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
    SET @v_description = N'ERROR_LINE : ' + STR(ERROR_LINE());
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ,@p_user_id       =@v_batch_user
                              ;

    return -1 
  END CATCH;

  -- 종료 LOG
  SET @v_log_type = N'END';
  SET @v_log_message = N'########## END of procedure ##########';
  SET @v_description = N'';
  SET @d_event_date = SYSDATETIME();
  EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                            ,@p_log_type      =@v_log_type
                            ,@p_log_count     =@n_log_count 
                            ,@p_log_message   =@v_log_message 
                            ,@p_description   =@v_description 
                            ,@p_event_date    =@d_event_date 
                            ,@p_user_id       =@v_batch_user
                            ;
  return 1 

  _RETURN_ERR_CODE:          
      BEGIN          
           RETURN -1          
      END;  

  END;

