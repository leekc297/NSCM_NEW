

/*
 * Program ID   : PR_UI_FP00590_REPLAN_POPUP
 * Description  : Re Plan Total Popup
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/09/17   JYJ				Initial Release UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FP00590_REPLAN_POPUP]
  @p_sys_type             NVARCHAR(MAX),
  @p_sys_flag             NVARCHAR(MAX),
  @p_sys_gubun            NVARCHAR(MAX),
  @p_user_id              NVARCHAR(MAX),
  @p_site_id              NVARCHAR(MAX),
  @p_instance_id          NVARCHAR(MAX),
  @p_plan_date            NVARCHAR(MAX),
  @p_plan_id              NVARCHAR(MAX),
  @p_plan_type            NVARCHAR(MAX),
  @p_description          NVARCHAR(MAX),
  @p_pre_fix_date         NVARCHAR(MAX),
  @p_amend_fix_date       NVARCHAR(MAX)


AS 
BEGIN  --MAIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
    SET NOCOUNT ON                                                                                                                                                                                                                                                   
	SET XACT_ABORT ON 

	DECLARE @v_sys_type             NVARCHAR(MAX)  -- 값>> SELEC: SQL저장안함, SQL:SQL저장함
	DECLARE @v_sys_flag             NVARCHAR(MAX)  -- 값>> I: Insert, M: Update, D: Delete, G: MERGE
	DECLARE @v_sys_gubun            NVARCHAR(MAX) 
	DECLARE @v_user_id              NVARCHAR(MAX)
    DECLARE @v_site_id              NVARCHAR(MAX)
	DECLARE @v_instance_id          NVARCHAR(MAX)
    DECLARE @v_plan_date            NVARCHAR(MAX)
    DECLARE @v_plan_id              NVARCHAR(MAX)
    DECLARE @v_plan_type            NVARCHAR(MAX)
    DECLARE @v_description          NVARCHAR(MAX)
    DECLARE @v_pre_fix_date  	    NVARCHAR(MAX)
    DECLARE @v_amend_fix_date	    NVARCHAR(MAX)


	DECLARE @recv_active_flag       NVARCHAR(MAX)				    
	DECLARE @v_proc_name	        NVARCHAR(100) = 'PR_UI_FP00590_REPLAN_POPUP'
	DECLARE @v_log_type             NVARCHAR(100) = ''
	DECLARE @v_log_message          NVARCHAR(MAX) = ''
	DECLARE @v_error_description    NVARCHAR(MAX) = ''
	DECLARE @v_delimiter            NVARCHAR(1)
	DECLARE @max_loop_cnt	        INTEGER = 0
	DECLARE @mst_loop_cnt	        INTEGER = 0
	DECLARE @v_seq_no   	        INTEGER = 0
	DECLARE @rtnCount   	        INTEGER = 0

	DECLARE @sysdate                DATETIME      = GETDATE()
	DECLARE @runstart               datetime
    DECLARE @runend                 datetime

	DECLARE @v_dSql                 NVARCHAR(MAX)=''

	SET @v_sys_type          = ''
	SET @v_sys_flag          = ''
	SET @v_sys_gubun         = ''
	SET @v_user_id           = ''
    SET @v_site_id           = '' 
	SET @v_instance_id       = '' 
    SET @v_plan_date         = '' 
    SET @v_plan_id           = ''
    SET @v_plan_type         = ''
    SET @v_description       = ''
	SET @v_pre_fix_date      = ''
	SET @v_amend_fix_date    = ''


	SET @recv_active_flag       = NULL	
	SET @recv_active_flag       = @p_sys_flag
	SET @v_delimiter            = '|'             -- 데이터 구분자
	SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_sys_flag, @v_delimiter) -- 프로시저 LOOP 길이를 판단  

	SET	@v_dSql                 = ''


    /************************************************************************************************/
	/* SELECT_ENGINE_RUN경우 :(SELECT_ENGINE_RUN Select)                                            */
	/************************************************************************************************/
    IF(@p_sys_flag ='SELECT_ENGINE_RUN')
	    BEGIN --ELSE IF(START)
		    SELECT @v_dSql = ''
			SELECT @v_dSql += '   SELECT ''INBOUND'' AS ENGINE_STATUS, ''Input Data Create'' AS STATUS_NAME, ' + char(10)
			SELECT @v_dSql += '       A.INBOUND_FLAG AS STATUS_FLAG, A.INBOUND_STEP AS STATUS_STEP ,         ' + char(10)
			SELECT @v_dSql += '       FORMAT(A.INBOUND_START ,''yyyy-MM-dd HH:mm:ss'') AS STATUS_START ,     ' + char(10)
			SELECT @v_dSql += '       FORMAT(A.INBOUND_END   ,''yyyy-MM-dd HH:mm:ss'') AS STATUS_END ,       ' + char(10)
			SELECT @v_dSql += '       CASE WHEN A.INBOUND_FLAG=''R'' THEN ''Ready''                          ' + char(10)
			SELECT @v_dSql += '          WHEN A.INBOUND_FLAG = ''P'' THEN ''Processing''+CASE WHEN A.INBOUND_START IS NOT NULL THEN '' (''+CONVERT(VARCHAR,DATEDIFF(SECOND,A.INBOUND_START,GETDATE())/60) + '':'' + CONVERT(VARCHAR,DATEDIFF(SECOND,A.INBOUND_START,GETDATE())-(DATEDIFF(SECOND,A.INBOUND_START,GETDATE())/60)*60) + '')'' END  ' + char(10)
			SELECT @v_dSql += '          WHEN A.INBOUND_FLAG = ''C'' THEN ''Completed'' +CASE WHEN A.INBOUND_END   IS NOT NULL THEN '' (''+CONVERT(VARCHAR, A.INBOUND_START, 20) + ''  /  ''  + CONVERT(VARCHAR,DATEDIFF(SECOND,A.INBOUND_START,A.INBOUND_END)/60) + '':'' + CONVERT(VARCHAR,DATEDIFF(SECOND,A.INBOUND_START,A.INBOUND_END)-(DATEDIFF(SECOND,A.INBOUND_START,A.INBOUND_END)/60)*60) + '')'' END  ' + char(10)
			SELECT @v_dSql += '          WHEN A.INBOUND_FLAG = ''E'' THEN ''Error''                          ' + char(10)
			SELECT @v_dSql += '       ELSE NULL END AS STATUS_MSG                                            ' + char(10)
			SELECT @v_dSql += '   FROM   FP_PLAN_STATUS_H A(NOLOCK)                                          ' + char(10)
			SELECT @v_dSql += '   WHERE  A.INSTANCE_ID = '''+ @p_instance_id +'''                            ' + char(10)
			SELECT @v_dSql += '   AND    A.PLAN_ID     = '''+ @p_plan_id +'''                                ' + char(10)
			SELECT @v_dSql += '   UNION ALL                                                                  ' + char(10)
			SELECT @v_dSql += '   SELECT ''ENGINE'' AS ENGINE_STATUS, ''Engine Running'' AS STATUS_NAME,     ' + char(10)
			SELECT @v_dSql += '        A.ENGINE_FLAG AS STATUS_FLAG, A.ENGINE_STEP AS STATUS_STEP ,          ' + char(10)
			SELECT @v_dSql += '        FORMAT(A.ENGINE_START  ,''yyyy-MM-dd HH:mm:ss'') AS STATUS_START ,    ' + char(10)
			SELECT @v_dSql += '        FORMAT(A.ENGINE_END    ,''yyyy-MM-dd HH:mm:ss'') AS STATUS_END ,      ' + char(10)
			SELECT @v_dSql += '        CASE WHEN A.ENGINE_FLAG = ''S'' THEN ''Stop''                         ' + char(10)
			SELECT @v_dSql += '             WHEN A.ENGINE_FLAG = ''E'' THEN ''Error''                        ' + char(10)
			SELECT @v_dSql += '        	    WHEN A.ENGINE_STEP = ''0'' THEN ''Ready''                        ' + char(10)
			SELECT @v_dSql += '             WHEN A.ENGINE_STEP = ''1'' THEN ''Processing'' + CASE WHEN A.ENGINE_START IS NOT NULL THEN '' ('' + CONVERT(VARCHAR,DATEDIFF(SECOND,A.ENGINE_START,GETDATE())/60) + '':'' + CONVERT(VARCHAR,DATEDIFF(SECOND,A.ENGINE_START,GETDATE())-(DATEDIFF(SECOND,A.ENGINE_START,GETDATE())/60)*60) + '')'' END ' + char(10)
			SELECT @v_dSql += '             WHEN A.ENGINE_STEP = ''2'' THEN ''Processing'' + CASE WHEN A.ENGINE_START IS NOT NULL THEN '' ('' + CONVERT(VARCHAR,DATEDIFF(SECOND,A.ENGINE_START,GETDATE())/60) + '':'' + CONVERT(VARCHAR,DATEDIFF(SECOND,A.ENGINE_START,GETDATE())-(DATEDIFF(SECOND,A.ENGINE_START,GETDATE())/60)*60) + '')'' END ' + char(10)
			SELECT @v_dSql += '             WHEN A.ENGINE_STEP = ''3'' THEN ''Processing'' + CASE WHEN A.ENGINE_START IS NOT NULL THEN '' ('' + CONVERT(VARCHAR,DATEDIFF(SECOND,A.ENGINE_START,GETDATE())/60) + '':'' + CONVERT(VARCHAR,DATEDIFF(SECOND,A.ENGINE_START,GETDATE())-(DATEDIFF(SECOND,A.ENGINE_START,GETDATE())/60)*60) + '')'' END ' + char(10)
			SELECT @v_dSql += '             WHEN A.ENGINE_STEP = ''4'' THEN ''Completed'' +  CASE WHEN A.OUTBOUND_END IS NOT NULL THEN '' ('' + CONVERT(VARCHAR, A.ENGINE_START, 20) + ''  /  ''+CONVERT(VARCHAR,DATEDIFF(SECOND,A.ENGINE_START,A.OUTBOUND_END)/60) + '':'' + CONVERT(VARCHAR,DATEDIFF(SECOND,A.ENGINE_START,A.OUTBOUND_END)-(DATEDIFF(SECOND,A.ENGINE_START,A.OUTBOUND_END)/60)*60) + '')'' END ' + char(10)
			SELECT @v_dSql += '             ELSE NULL END AS STATUS_MSG                                       ' + char(10)
			SELECT @v_dSql += '  FROM   FP_PLAN_STATUS_H A(NOLOCK)                                            ' + char(10)
			SELECT @v_dSql += '  WHERE  A.INSTANCE_ID = '''+ @p_instance_id +'''                              ' + char(10)
			SELECT @v_dSql += '  AND    A.PLAN_ID     = '''+ @p_plan_id +'''                                  ' + char(10)
			SELECT @v_dSql += '  UNION ALL                                                                    ' + char(10)
			SELECT @v_dSql += '  SELECT ''OUTBOUND'' AS ENGINE_STATUS, ''Output Data Create'' AS STATUS_NAME, ' + char(10)
			SELECT @v_dSql += '       A.DB_TRANS_FLAG AS STATUS_FLAG, A.DB_TRANS_STEP AS STATUS_STEP ,        ' + char(10)
			SELECT @v_dSql += '       FORMAT(A.DB_TRANS_START  ,''yyyy-MM-dd HH:mm:ss'') AS STATUS_START ,    ' + char(10)
			SELECT @v_dSql += '       FORMAT(A.DB_TRANS_END    ,''yyyy-MM-dd HH:mm:ss'') AS STATUS_END ,      ' + char(10)
			SELECT @v_dSql += '       CASE WHEN A.DB_TRANS_FLAG = ''S'' THEN ''Stop''                         ' + char(10)
			SELECT @v_dSql += '            WHEN A.DB_TRANS_FLAG = ''R'' THEN ''Ready''                        ' + char(10)
			SELECT @v_dSql += '            WHEN A.DB_TRANS_FLAG = ''P'' THEN ''Processing'' + CASE WHEN A.DB_TRANS_START IS NOT NULL THEN '' ('' + CONVERT(VARCHAR,DATEDIFF(SECOND,A.DB_TRANS_START,GETDATE())/60) + '':'' + CONVERT(VARCHAR,DATEDIFF(SECOND,A.DB_TRANS_START,GETDATE())-(DATEDIFF(SECOND,A.DB_TRANS_START,GETDATE())/60)*60) + '')'' END ' + char(10)
			SELECT @v_dSql += '            WHEN A.DB_TRANS_FLAG = ''C'' THEN ''Completed''  + CASE WHEN A.DB_TRANS_END   IS NOT NULL THEN '' ('' + CONVERT(VARCHAR, A.DB_TRANS_START, 20) + ''  /  ''+CONVERT(VARCHAR,DATEDIFF(SECOND,A.DB_TRANS_START,A.DB_TRANS_END)/60) + '':'' +CONVERT(VARCHAR,DATEDIFF(SECOND,A.DB_TRANS_START,A.DB_TRANS_END)-(DATEDIFF(SECOND,A.DB_TRANS_START,A.DB_TRANS_END)/60)*60) + '')'' END ' + char(10)
			SELECT @v_dSql += '            WHEN A.DB_TRANS_FLAG = ''E'' THEN ''Error'' ' + char(10)
			SELECT @v_dSql += '            ELSE NULL END AS STATUS_MSG                 ' + char(10)
			SELECT @v_dSql += '  FROM   FP_PLAN_STATUS_H A(NOLOCK)                     ' + char(10)
			SELECT @v_dSql += '  WHERE  A.INSTANCE_ID = '''+ @p_instance_id +'''       ' + char(10)
			SELECT @v_dSql += '  AND    A.PLAN_ID     = '''+ @p_plan_id +'''           ' + char(10)

			IF @p_sys_type = 'SQL'
				BEGIN
					--EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_dSql,'select',@runstart, @runend
					SELECT @v_dSql as [QUERY_VALUE]

				END  
			ELSE 
				BEGIN
					SET @runstart = GetDate()
					--쿼리실행
					EXEC sp_executesql @v_dSql

					SET @runend = GetDate()
					--EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_dSql,'select',@runstart, @runend
				END	
			END
    /************************************************************************************************/
	/* Plan Control본화면 EXECUTE_VALIDATION경우 :(EXECUTE_VALIDATION )                             */
	/************************************************************************************************/
    ELSE IF(@p_sys_flag ='EXECUTE_VALIDATION')
	    BEGIN --ELSE IF(START)
		    SELECT @v_dSql = ''
			SELECT @v_dSql = 'EXEC PR_SCM_AF_MASTER_VALIDATION'
			
			--Log 남김
			EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_dSql,'select',@runstart, @runend

			EXEC  @rtnCount = [dbo].[PR_SCM_AF_MASTER_VALIDATION]
			
			SET @rtnCount = 1
            SELECT	'Result' = @rtnCount

		END

	ELSE
		-- 트랜잭션 (TRAN)
		BEGIN TRY				                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
		BEGIN TRAN   

		BEGIN --ELSE ( BEGIN )
		    --max_loop_cnt:전체 Row수 , mst_loop_cnt:1씩 증가시켜서 전체 Row수 까지만 로직을 수행
			WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
			    BEGIN --WHILE 내(START)
					 
						SELECT @mst_loop_cnt = @mst_loop_cnt + 1	-- @mst_loop_cnt 1증가

						SELECT @v_sys_type     = [dbo].[SCM_ARR_SPL_VAL](@p_sys_type ,         @v_delimiter, @mst_loop_cnt)
						, @v_sys_flag          = [dbo].[SCM_ARR_SPL_VAL](@p_sys_flag ,         @v_delimiter, @mst_loop_cnt)
						, @v_sys_gubun         = [dbo].[SCM_ARR_SPL_VAL](@p_sys_gubun ,        @v_delimiter, @mst_loop_cnt)
						, @v_user_id           = [dbo].[SCM_ARR_SPL_VAL](@p_user_id ,          @v_delimiter, @mst_loop_cnt)
                        , @v_site_id           = [dbo].[SCM_ARR_SPL_VAL](@p_site_id ,          @v_delimiter, @mst_loop_cnt)
                        , @v_instance_id       = [dbo].[SCM_ARR_SPL_VAL](@p_instance_id ,      @v_delimiter, @mst_loop_cnt)
                        , @v_plan_date         = [dbo].[SCM_ARR_SPL_VAL](@p_plan_date ,        @v_delimiter, @mst_loop_cnt)
                        , @v_plan_id           = [dbo].[SCM_ARR_SPL_VAL](@p_plan_id ,          @v_delimiter, @mst_loop_cnt)
                        , @v_plan_type         = [dbo].[SCM_ARR_SPL_VAL](@p_plan_type ,        @v_delimiter, @mst_loop_cnt)
                        , @v_description       = [dbo].[SCM_ARR_SPL_VAL](@p_description ,      @v_delimiter, @mst_loop_cnt)
                        , @v_pre_fix_date      = [dbo].[SCM_ARR_SPL_VAL](@p_pre_fix_date ,     @v_delimiter, @mst_loop_cnt)
                        , @v_amend_fix_date    = [dbo].[SCM_ARR_SPL_VAL](@p_amend_fix_date ,   @v_delimiter, @mst_loop_cnt)

					   /******************************************************************************/
					   /* SAVE_FIX_PLAN 경우 : UPDATE                                                */
					   /******************************************************************************/
					   IF(@v_sys_flag ='SAVE_FIX_PLAN')  
							BEGIN
							   
                                SELECT @v_dSql = ''
                                SELECT @v_dSql += ' UPDATE SCM_FP_PLAN_H                          ' + char(10)
                                SELECT @v_dSql += '    SET AMEND_FIX_DATE = CONVERT(VARCHAR, '''+ @v_amend_fix_date +''', 112) ' + char(10)
                                SELECT @v_dSql += '      , DESCRIPTION = '''+ @v_description +''' ' + char(10)
                                SELECT @v_dSql += '    	 , UPDATE_ID	= '''+ @v_user_id +'''    ' + char(10)
                                SELECT @v_dSql += '    	 , UPDATE_TIME 	= GETDATE()               ' + char(10)
                                SELECT @v_dSql += ' WHERE 1=1                                     ' + char(10)
                                SELECT @v_dSql += ' AND   INSTANCE_ID = '''+ @v_instance_id +'''  ' + char(10)
                                SELECT @v_dSql += ' AND	  PLAN_ID	  = '''+ @v_plan_id +'''      ' + char(10)
                                SELECT @v_dSql += ' AND   PLAN_TYPE   = '''+ @v_plan_type +'''    ' + char(10)

                                SELECT @v_dSql += ' INSERT INTO HIS_FP_PLAN_H ( ' + char(10)
                                SELECT @v_dSql += '      INSTANCE_ID        ' + char(10)
                                SELECT @v_dSql += '     ,PLAN_ID            ' + char(10)
                                SELECT @v_dSql += '     ,PLAN_TYPE          ' + char(10)
                                SELECT @v_dSql += '     ,SITE_ID            ' + char(10)
                                SELECT @v_dSql += '     ,PLAN_START_TIME    ' + char(10)
                                SELECT @v_dSql += '     ,PLAN_HORIZON       ' + char(10)
                                SELECT @v_dSql += '     ,PLAN_HORIZON_UOM   ' + char(10)
                                SELECT @v_dSql += '     ,DEMAND_HORIZON     ' + char(10)
                                SELECT @v_dSql += '     ,DEMAND_HORIZON_UOM ' + char(10)
                                SELECT @v_dSql += '     ,CONFIG_SET_ID      ' + char(10)
                                SELECT @v_dSql += '     ,BASIS_PLAN_ID      ' + char(10)
                                SELECT @v_dSql += '     ,DEMAND_PLAN_ID     ' + char(10)
                                SELECT @v_dSql += '     ,SCP_PLAN_ID        ' + char(10)
                                SELECT @v_dSql += '     ,PLAN_WEEK          ' + char(10)
                                SELECT @v_dSql += '     ,CONFIRM_FLAG       ' + char(10)
                                SELECT @v_dSql += '     ,SYNC_OPERATION_ID  ' + char(10)
                                SELECT @v_dSql += '     ,DESCRIPTION        ' + char(10)
                                SELECT @v_dSql += '     ,PRE_FIX_DATE       ' + char(10)
                                SELECT @v_dSql += '     ,AMEND_FIX_DATE     ' + char(10)
                                SELECT @v_dSql += '     ,INSERT_ID          ' + char(10)
                                SELECT @v_dSql += '     ,INSERT_TIME        ' + char(10)
                                SELECT @v_dSql += '     ,UPDATE_ID          ' + char(10)
                                SELECT @v_dSql += '     ,UPDATE_TIME        ' + char(10)
                                SELECT @v_dSql += '     ,JOB_USER_ID        ' + char(10)
                                SELECT @v_dSql += '     ,JOB_TIME           ' + char(10)
                                SELECT @v_dSql += '     ,JOB_TYPE           ' + char(10)
                                SELECT @v_dSql += ' )                       ' + char(10)
                                SELECT @v_dSql += ' SELECT INSTANCE_ID      ' + char(10)
                                SELECT @v_dSql += '     ,PLAN_ID            ' + char(10)
                                SELECT @v_dSql += '     ,PLAN_TYPE          ' + char(10)
                                SELECT @v_dSql += '     ,SITE_ID            ' + char(10)
                                SELECT @v_dSql += '     ,PLAN_START_TIME    ' + char(10)
                                SELECT @v_dSql += '     ,PLAN_HORIZON       ' + char(10)
                                SELECT @v_dSql += '     ,PLAN_HORIZON_UOM   ' + char(10)
                                SELECT @v_dSql += '     ,DEMAND_HORIZON     ' + char(10)
                                SELECT @v_dSql += '     ,DEMAND_HORIZON_UOM ' + char(10)
                                SELECT @v_dSql += '     ,CONFIG_SET_ID      ' + char(10)
                                SELECT @v_dSql += '     ,BASIS_PLAN_ID      ' + char(10)
                                SELECT @v_dSql += '     ,DEMAND_PLAN_ID     ' + char(10)
                                SELECT @v_dSql += '     ,SCP_PLAN_ID        ' + char(10)
                                SELECT @v_dSql += '     ,PLAN_WEEK          ' + char(10)
                                SELECT @v_dSql += '     ,CONFIRM_FLAG       ' + char(10)
                                SELECT @v_dSql += '     ,SYNC_OPERATION_ID  ' + char(10)
                                SELECT @v_dSql += '     ,DESCRIPTION        ' + char(10)
                                SELECT @v_dSql += '     ,PRE_FIX_DATE       ' + char(10)
                                SELECT @v_dSql += '     ,AMEND_FIX_DATE     ' + char(10)
                                SELECT @v_dSql += '     ,INSERT_ID          ' + char(10)
                                SELECT @v_dSql += '     ,INSERT_TIME        ' + char(10)
                                SELECT @v_dSql += '     ,UPDATE_ID          ' + char(10)
                                SELECT @v_dSql += '     ,UPDATE_TIME        ' + char(10)
                                SELECT @v_dSql += '     ,'''+ @v_user_id +''' as JOB_USER_ID      ' + char(10)
                                SELECT @v_dSql += '     ,GETDATE() as JOB_TIME                    ' + char(10)
                                SELECT @v_dSql += '     ,''RE-UPDATE'' as JOB_TYPE                ' + char(10)
                                SELECT @v_dSql += ' FROM   SCM_FP_PLAN_H A WITH(NOLOCK)           ' + char(10)
                                SELECT @v_dSql += ' WHERE  INSTANCE_ID = '''+ @v_instance_id +''' ' + char(10)
                                SELECT @v_dSql += ' AND    PLAN_ID     = '''+ @v_plan_id +'''     ' + char(10)
                                SELECT @v_dSql += ' AND    PLAN_TYPE   = '''+ @v_plan_type +'''   ' + char(10)

						   END --'I'
					   /****************************************************************************/
					   /* UPDATE  경우  :UPDATE_CLEAR_STATUS                                                         */
					   /****************************************************************************/
					   ELSE IF(@v_sys_flag ='UPDATE_CLEAR_STATUS')
							BEGIN
							    SELECT @v_dSql = ''
                                SELECT @v_dSql += '  DELETE FROM FP_PLAN_STATUS_H                          ' + char(10)
                                SELECT @v_dSql += '  WHERE  INSTANCE_ID = '''+ @v_instance_id +'''         ' + char(10)
                                SELECT @v_dSql += '  AND    PLAN_ID     = '''+ @v_plan_id +'''             ' + char(10)
                                SELECT @v_dSql += '                                                        ' + char(10) 
                                SELECT @v_dSql += '  INSERT INTO FP_PLAN_STATUS_H (                        ' + char(10)
                                SELECT @v_dSql += '      INSTANCE_ID,       PLAN_ID,          ACTIVE_FLAG  ' + char(10)
                                SELECT @v_dSql += '    , INBOUND_FLAG,      INBOUND_START,    ENGINE_FLAG  ' + char(10)
                                SELECT @v_dSql += '    , OUTBOUND_FLAG,     DB_TRANS_FLAG,    INSERT_ID    ' + char(10)
                                SELECT @v_dSql += '    , INSERT_TIME,       UPDATE_ID,        UPDATE_TIME  ' + char(10)
                                SELECT @v_dSql += '  )                                                     ' + char(10)
                                SELECT @v_dSql += '  SELECT                                                ' + char(10)
								SELECT @v_dSql += '       '''+ @v_instance_id +''', '''+ @v_plan_id +''',               1 AS active_flag                  ' + char(10)
                                SELECT @v_dSql += '     , ''P'' AS inbound_flag,    GETDATE() AS inbound_start,        ''R'' AS engine_flag               ' + char(10)
                                SELECT @v_dSql += '     , ''R'' AS outbound_flag,   ''R'' AS db_trans_flag,            '''+ @v_user_id +''' AS insert_id  ' + char(10)
                                SELECT @v_dSql += '     , GETDATE() AS insert_date, '''+ @v_user_id +''' AS update_id, GETDATE() AS update_date           ' + char(10)
                                SELECT @v_dSql += '                                                                                 ' + char(10)
                                SELECT @v_dSql += '  INSERT INTO HIS_PLAN_STATUS_H (                                                ' + char(10)
                                SELECT @v_dSql += '         INSTANCE_ID,           PLAN_ID,            ACTIVE_FLAG                  ' + char(10)
                                SELECT @v_dSql += '        ,INBOUND_FLAG,          INBOUND_STEP,       INBOUND_START                ' + char(10)
                                SELECT @v_dSql += '        ,INBOUND_END,           ENGINE_FLAG,        ENGINE_STEP                  ' + char(10)
                                SELECT @v_dSql += '        ,ENGINE_START,          ENGINE_END,         OUTBOUND_FLAG                ' + char(10)
								SELECT @v_dSql += '        ,OUTBOUND_STEP,         OUTBOUND_START,     OUTBOUND_END                 ' + char(10)
                                SELECT @v_dSql += '        ,DB_TRANS_FLAG,         DB_TRANS_STEP,      DB_TRANS_START               ' + char(10)
                                SELECT @v_dSql += '        ,DB_TRANS_END,          DESCRIPTION,        DB_CONNECTION_NAME           ' + char(10)
                                SELECT @v_dSql += '        ,INSERT_ID,             INSERT_TIME,        UPDATE_ID                    ' + char(10)
                                SELECT @v_dSql += '        ,UPDATE_TIME,           JOB_USER_ID,        JOB_TIME                     ' + char(10)
								SELECT @v_dSql += '        ,JOB_TYPE                                                                ' + char(10)
                                SELECT @v_dSql += '  )                                                                              ' + char(10)
                                SELECT @v_dSql += '  SELECT INSTANCE_ID,           PLAN_ID,            ACTIVE_FLAG                  ' + char(10)
                                SELECT @v_dSql += '        ,INBOUND_FLAG,          INBOUND_STEP,       INBOUND_START                ' + char(10)
                                SELECT @v_dSql += '        ,INBOUND_END,           ENGINE_FLAG,        ENGINE_STEP                  ' + char(10)
                                SELECT @v_dSql += '        ,ENGINE_START,          ENGINE_END,         OUTBOUND_FLAG                ' + char(10)
								SELECT @v_dSql += '        ,OUTBOUND_STEP,         OUTBOUND_START,     OUTBOUND_END                 ' + char(10)
                                SELECT @v_dSql += '        ,DB_TRANS_FLAG,         DB_TRANS_STEP,      DB_TRANS_START               ' + char(10)
                                SELECT @v_dSql += '        ,DB_TRANS_END,          DESCRIPTION,        DB_CONNECTION_NAME           ' + char(10)
                                SELECT @v_dSql += '        ,INSERT_ID,             INSERT_TIME,        UPDATE_ID                    ' + char(10)
                                SELECT @v_dSql += '        ,UPDATE_TIME,        '''+ @v_user_id +''' , dbo.SYSDATE1() AS JOB_TIME   ' + char(10)
								SELECT @v_dSql += '        ,''INSERT'' AS JOB_TYPE                                                  ' + char(10)
                                SELECT @v_dSql += '  FROM   FP_PLAN_STATUS_H(NOLOCK)                                                ' + char(10)
                                SELECT @v_dSql += '  WHERE  INSTANCE_ID = '''+ @v_instance_id +'''                                  ' + char(10)
                                SELECT @v_dSql += '  AND    PLAN_ID     = '''+ @v_plan_id +'''                                      ' + char(10)


                            END --M
					   /****************************************************************************/
					   /* UPDATE  경우  :UPDATE_ENGINE_RUN                                          */
					   /****************************************************************************/
					   ELSE IF(@v_sys_flag ='UPDATE_ENGINE_RUN')
						   BEGIN
								SELECT @v_dSql = ''

                                SELECT @v_dSql += ' UPDATE JOB_SCHEDULE_DETAIL SET                                  ' + char(10)
                                SELECT @v_dSql += '        PARAMETER1 = '''+ @v_instance_id +'''                    ' + char(10)
                                SELECT @v_dSql += '      , PARAMETER2 = '''+ @v_plan_id +'''                        ' + char(10)
                                SELECT @v_dSql += ' WHERE  GROUP_ID = ''ENGINE_RUN_UI-'' + '''+ @v_instance_id +''' ' + char(10)
								SELECT @v_dSql += '                                                                 ' + char(10)
                                SELECT @v_dSql += ' UPDATE JOB_SCHEDULE_MASTER SET                                  ' + char(10)
                                SELECT @v_dSql += '        IMMEDIATE_FLAG = ''Y''                                   ' + char(10)
                                SELECT @v_dSql += ' WHERE  GROUP_ID = ''ENGINE_RUN_UI-'' + '''+ @v_instance_id +''' ' + char(10)

						   END --'M1'

						/****************************************************************************/
						/* UPDATE  경우  :액션 종료후에 상태를 저장 - 프로시저 : callback 이후, link : 메뉴 호출 후               */
						/****************************************************************************/
						ELSE IF(@v_sys_flag ='UPDATE_STATUS')
							BEGIN	
					
								SELECT @v_dSql = ''
								SELECT @v_dSql += N'	MERGE INTO FP_WOW_HIST AS A																' + char(10)
								
							END
					IF @v_sys_type = 'SQL'
						BEGIN
							--EXEC PR_UI_SQL_LOG @v_proc_name,  @v_user_id,'','',@v_dSql,'select',@runstart, @runend
							SELECT @v_dSql as [QUERY_VALUE]

						END
					ELSE
						BEGIN
							SET @runstart = GetDate()
							--쿼리실행
							EXEC sp_executesql @v_dSql

							SET @runend = GetDate()
							EXEC PR_UI_SQL_LOG  @v_proc_name,  @v_user_id, @v_sys_flag,'', @v_dSql,'SELECT',@runstart, @runend
						END

			    END --WHILE 내(END)

		END --ELSE (END)
 		
        -- 트랜잭션 (COMMIT)
		COMMIT TRAN
		
		-- 수행결과 성공여부 RETURN
		IF @v_sys_type <> 'SQL'
		    SELECT 'SUCCESS' AS result_code,  @max_loop_cnt AS result_cnt	

		END TRY
		BEGIN CATCH                                                                                                                                                                                                                                                      
                                                                                                                                                                                                                                                                     
			ROLLBACK TRAN                                                                                                                                                                                                                                                 
			-- 에러나도 로그는 인서트                                                                                                                                                                                                                                              
			SET @v_log_message = ERROR_MESSAGE()
			EXEC PR_UI_SQL_LOG  @v_proc_name,  @v_user_id,'','',@v_log_message,'excute',@runstart, @runend
        
			SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  
		
		END CATCH    

END --MAIN END

