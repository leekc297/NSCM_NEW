

CREATE PROCEDURE [dbo].[PR_SCM_ENGINE_RUN_SIM_UI_PL_PACK]
@p_instance_id nvarchar(MAX) = '-', @p_plan_id nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
  SET XACT_ABORT ON

  -- LOG 용 변수 설정
  DECLARE @v_proc_name nvarchar(100) = 'PR_SCM_ENGINE_RUN_SIM_UI_PL_PACK'
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
  DECLARE @v_plan_date    nvarchar(1000)
  
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

   
    END

    -- ================================================
    -- 로직 추가 start
    -- ================================================    
    IF @v_plan_id = 'FIRST_PLAN'
    BEGIN
		
		-- SITE 현재 일자
		SELECT	@v_plan_date = CASE	WHEN FORMAT(DBO.FN_SITE_TIME(@v_lgc_site) ,'yyyyMMddHHmmss') < CONVERT(VARCHAR,DBO.FN_SITE_TIME(@v_lgc_site),112) + A.BASIS_START_TIME 
									THEN CONVERT(VARCHAR, DATEADD(DD,-1,DBO.FN_SITE_TIME(@v_lgc_site)), 112)                                                               
									ELSE CONVERT(VARCHAR, DBO.FN_SITE_TIME(@v_lgc_site), 112) END                                                              
		FROM	FP_INSTANCE_START_TIME_V A
		WHERE	A.INSTANCE_ID = @v_instance_id

		
      SET @v_plan_id = @v_instance_id + '-' + @v_plan_date + '-001'
      
      SET @n_log_count = @n_log_count + 1
      SET @v_descr = 'SET First Plan : ' + @v_plan_id
      EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'SET', @n_log_count, NULL, @v_descr, null

      
      SELECT @v_plan_run_flag = ( CASE WHEN COUNT(1) > 0 THEN 'SKIP'
                                                         ELSE 'RUN'
                                  END )
      FROM   FP_SIM_PLAN_H A
      WHERE  1=1
	  AND	 A.PROGRAM_TYPE		=		'PACK_SIMUL'
	  AND	 A.INSTANCE_ID		=		@v_instance_id
      AND    A.SIM_PLAN_ID      LIKE	SUBSTRING(@v_plan_id, 1, LEN(@v_plan_id) - 1) + '%'    -- 001 번 제외한 다른 PLAN 이 존재 유무
      AND    A.SIM_PLAN_ID		!=		SUBSTRING(@v_plan_id, 1, LEN(@v_plan_id) - 1) + '1'    -- 001 번 제외
      
      SET @n_log_count = @n_log_count + 1
      SET @v_descr = 'PLAN RUN FLAG : ' + @v_plan_run_flag
      EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'SELECT', @n_log_count, NULL, @v_descr, null

	 
	  IF @v_plan_run_flag = 'RUN'
      BEGIN

        DELETE FROM FP_SIM_PLAN_H
        WHERE 1=1
		AND	PROGRAM_TYPE = 'PACK_SIMUL'
		AND INSTANCE_ID = @v_instance_id
        AND SIM_PLAN_ID = @v_plan_id
        
		INSERT INTO FP_SIM_PLAN_H
		(
			  PROGRAM_TYPE
			, INSTANCE_ID
			, SIM_PLAN_ID
			, PLAN_TYPE
			, SITE_ID
			, PLAN_DATE
			, PLAN_START_TIME
			, PLAN_END_TIME
			, DESCRIPTION
			, CONFIRM_ID
			, CONFIRM_DTTM
			, INSERT_ID
			, INSERT_DTTM
			, UPDATE_ID
			, UPDATE_DTTM
			, HISTORY_YN
		)
		VALUES
		(
			'PACK_SIMUL'
			, @p_instance_id
			, @v_plan_id
			, 'PRE-SIM'
			, @v_lgc_site
			, @v_plan_date
			, CONVERT(DATE, @v_plan_date)
			, (	SELECT DATED7 -- 10일후 일요일
				FROM TH_UIS_CALENDAR
				WHERE 1=1
				AND D0 = (	SELECT ISO_YYYYWW
							FROM TH_UIS_CAL 
							WHERE  YYYYMMDD=DATEADD( DAY, 6, CONVERT(DATE, @v_plan_date) )
						 )
			   )
			, NULL
			, NULL
			, NULL
			, @v_proc_name
			, dbo.FN_SITE_TIME(@v_lgc_site)
			, NULL
			, NULL
			, 'N'
		);

        SET @n_log_count = @n_log_count + 1
        SET @v_descr = 'Create Plan : ' + @v_plan_id
        EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'SET', @n_log_count, NULL, @v_descr, null
        
		------------------------------------------------------------------
		-- 신규 Plan 생성
		------------------------------------------------------------------
		EXEC PR_SCM_PACK_MATERIAL_SIMULATION	@v_instance_id, @v_plan_id
        

      END
    
    END

   END TRY

  BEGIN CATCH
   
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
