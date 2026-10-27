

/*
 * Program ID   : PR_UI_FP00590_PLAN_CONTROL_WOWSTATUS
 * Description  : Plan Control Release
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/03/05   JYJ				Initial Release UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FP00590_PLAN_CONTROL_WOWSTATUS]
  @p_sys_type             NVARCHAR(MAX),
  @p_sys_flag             NVARCHAR(MAX),
  @p_sys_gubun            NVARCHAR(MAX),
  @p_user_id              NVARCHAR(MAX),
  @p_division_id          NVARCHAR(MAX),
  @p_site_id              NVARCHAR(MAX),
  @p_factory_id           NVARCHAR(MAX),
  @p_instance_id          NVARCHAR(MAX),
  @p_plan_date            NVARCHAR(MAX),
  @p_plan_id              NVARCHAR(MAX),
  @p_step_id              NVARCHAR(MAX),
  @p_date_seq             NVARCHAR(MAX),
  @p_user_group_id        NVARCHAR(MAX),
  @p_set_step             NVARCHAR(MAX),
  @p_scp_plan_id          NVARCHAR(MAX),
  @p_draft_plan_id        NVARCHAR(MAX),
  @p_sync_plan_id         NVARCHAR(MAX)


AS 
BEGIN  --MAIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
    SET NOCOUNT ON                                                                                                                                                                                                                                                   
	SET XACT_ABORT ON 

	DECLARE @v_sys_type             NVARCHAR(MAX)  -- 값>> SELEC: SQL저장안함, SQL:SQL저장함
	DECLARE @v_sys_flag             NVARCHAR(MAX)  -- 값>> I: Insert, M: Update, D: Delete, G: MERGE
	DECLARE @v_sys_gubun            NVARCHAR(MAX) 
	DECLARE @v_user_id              NVARCHAR(MAX)
    DECLARE @v_division_id          NVARCHAR(MAX)
    DECLARE @v_site_id              NVARCHAR(MAX)
    DECLARE @v_factory_id           NVARCHAR(MAX)
    DECLARE @v_instance_id          NVARCHAR(MAX)
    DECLARE @v_plan_date            NVARCHAR(MAX)
    DECLARE @v_plan_id              NVARCHAR(MAX)
    DECLARE @v_step_id              NVARCHAR(MAX)
    DECLARE @v_date_seq             NVARCHAR(MAX)
    DECLARE @v_user_group_id        NVARCHAR(MAX)
    DECLARE @v_set_step             NVARCHAR(MAX)
    DECLARE @v_scp_plan_id          NVARCHAR(MAX)
    DECLARE @v_draft_plan_id        NVARCHAR(MAX)
    DECLARE @v_sync_plan_id         NVARCHAR(MAX)

	DECLARE @recv_active_flag       NVARCHAR(MAX)				    
	DECLARE @v_proc_name	        NVARCHAR(100) = 'PR_UI_FP00590_PLAN_CONTROL_WOWSTATUS'
	DECLARE @v_log_type             NVARCHAR(100) = ''
	DECLARE @v_log_message          NVARCHAR(MAX) = ''
	DECLARE @v_error_description    NVARCHAR(MAX) = ''
	DECLARE @v_delimiter            NVARCHAR(1)
	DECLARE @max_loop_cnt	        INTEGER = 0
	DECLARE @mst_loop_cnt	        INTEGER = 0
	DECLARE @v_seq_no   	        INTEGER = 0
	DECLARE @rtnCount   	        INTEGER = 0

	DECLARE @v_temp1                NVARCHAR(1000)
	DECLARE @v_temp2                NVARCHAR(1000)
	DECLARE @sysdate                DATETIME      = GETDATE()
	DECLARE @runstart               datetime
    DECLARE @runend                 datetime

	DECLARE @v_dSql                 NVARCHAR(MAX)=''
	DECLARE @v_dSql1                NVARCHAR(MAX)=''
	DECLARE @v_dSql2                NVARCHAR(MAX)=''
	DECLARE @v_dSql3                NVARCHAR(MAX)=''

	SET @v_sys_type          = ''
	SET @v_sys_flag          = ''
	SET @v_sys_gubun         = ''
	SET @v_user_id           = ''
    SET @v_division_id       = ''
    SET @v_site_id           = ''
    SET @v_factory_id        = ''
    SET @v_instance_id       = ''
    SET @v_plan_date         = ''
    SET @v_plan_id           = ''
    SET @v_step_id           = ''
    SET @v_date_seq          = ''
    SET @v_user_group_id     = ''
    SET @v_set_step          = ''
    SET @v_scp_plan_id       = ''
    SET @v_draft_plan_id     = ''
    SET @v_sync_plan_id      = ''
    
    
    
    
    

	SET @recv_active_flag       = NULL	
	SET @recv_active_flag       = @p_sys_flag
	SET @v_delimiter            = '|'             -- 데이터 구분자
	SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_sys_flag, @v_delimiter) -- 프로시저 LOOP 길이를 판단  

	SET	@v_dSql                 = ''
	SET	@v_dSql1                = ''
	SET	@v_dSql2                = ''
	SET	@v_dSql3                = ''
	
	/************************************************************************************************/
	/* Wow Statusl팝업경우 :(SELECT_WOW_STATUS Select)                                         */
	/************************************************************************************************/
    IF(@p_sys_flag ='SELECT_WOW_STATUS')
	    BEGIN --ELSE IF(START)
		    SELECT @v_dSql1 = ''
            --SELECT @v_dSql1 += ' SELECT M.STEP_ID           ' + char(10)                                                                  
            --SELECT @v_dSql1 += '   ,  M.STEP_DESC,      M.STEP_SEQ,      M.ROLE_ID      ' + char(10)     
            --SELECT @v_dSql1 += '   ,  M.INSTANCE_ID,    M.PLAN_DATE,     M.SCP_PLAN_ID   ' + char(10)
            --SELECT @v_dSql1 += '   ,  M.DRAFT_PLAN_ID,  M.SYNC_PLAN_ID    ' + char(10)                  
            --SELECT @v_dSql1 += '   ,CASE WHEN M.CHECK01 =''Y'' THEN ''1'' ELSE ''0'' END CHECK01, CASE WHEN M.CHECK02 = ''Y'' THEN ''1'' ELSE ''0'' END CHECK02, CASE WHEN M.CHECK03 = ''Y'' THEN ''1'' ELSE ''0'' END CHECK03, CASE WHEN M.CHECK04 =''Y'' THEN ''1'' ELSE ''0'' END CHECK04  ' + char(10)
            --SELECT @v_dSql1 += '   ,CASE WHEN M.CHECK05 =''Y'' THEN ''1'' ELSE ''0'' END CHECK05, CASE WHEN M.CHECK06 = ''Y'' THEN ''1'' ELSE ''0'' END CHECK06, CASE WHEN M.CHECK07 = ''Y'' THEN ''1'' ELSE ''0'' END CHECK07, CASE WHEN M.CHECK08 =''Y'' THEN ''1'' ELSE ''0'' END CHECK08  ' + char(10)
            --SELECT @v_dSql1 += '   ,CASE WHEN M.CHECK09 =''Y'' THEN ''1'' ELSE ''0'' END CHECK09, CASE WHEN M.CHECK10 = ''Y'' THEN ''1'' ELSE ''0'' END CHECK10, CASE WHEN M.CHECK11 = ''Y'' THEN ''1'' ELSE ''0'' END CHECK11, CASE WHEN M.CHECK12 =''Y'' THEN ''1'' ELSE ''0'' END CHECK12  ' + char(10)
            --SELECT @v_dSql1 += '   ,CASE WHEN M.CHECK13 =''Y'' THEN ''1'' ELSE ''0'' END CHECK13, CASE WHEN M.CHECK14 = ''Y'' THEN ''1'' ELSE ''0'' END CHECK14, CASE WHEN M.CHECK15 = ''Y'' THEN ''1'' ELSE ''0'' END CHECK15, CASE WHEN M.CHECK16 =''Y'' THEN ''1'' ELSE ''0'' END CHECK16  ' + char(10)
            --SELECT @v_dSql1 += '   ,CASE WHEN M.CHECK17 =''Y'' THEN ''1'' ELSE ''0'' END CHECK17, CASE WHEN M.CHECK18 = ''Y'' THEN ''1'' ELSE ''0'' END CHECK18, CASE WHEN M.CHECK19 = ''Y'' THEN ''1'' ELSE ''0'' END CHECK19, CASE WHEN M.CHECK20 =''Y'' THEN ''1'' ELSE ''0'' END CHECK20  ' + char(10)
            --SELECT @v_dSql1 += '   , M.DATE_SEQ,        M.DESCRIPTION,   M.USER_ID  ' + char(10)
            --SELECT @v_dSql1 += '   , M.JOB_USER_NAME,   M.JOB_TIME   ' + char(10)
            --SELECT @v_dSql1 += ' FROM ( ' + char(10)
            SELECT @v_dSql1 += '  SELECT STEP_ID                                                                            ' + char(10)
            SELECT @v_dSql1 += '    ,MAX(STEP_DESC) STEP_DESC,    MAX(STEP_SEQ) STEP_SEQ,     MAX(ROLE_ID) ROLE_ID          ' + char(10)
            SELECT @v_dSql1 += '  	,MAX(INSTANCE_ID) INSTANCE_ID,MAX(PLAN_DATE) PLAN_DATE,   MAX(SCP_PLAN_ID) SCP_PLAN_ID  ' + char(10)
            SELECT @v_dSql1 += '  	,MAX(DRAFT_PLAN_ID) DRAFT_PLAN_ID,   MAX(SYNC_PLAN_ID) SYNC_PLAN_ID                     ' + char(10)
            SELECT @v_dSql1 += '    ,MAX(CHECK01) CHECK01, MAX(CHECK02) CHECK02, MAX(CHECK03) CHECK03, MAX(CHECK04) CHECK04 ' + char(10)
            SELECT @v_dSql1 += '    ,MAX(CHECK05) CHECK05, MAX(CHECK06) CHECK06, MAX(CHECK07) CHECK07, MAX(CHECK08) CHECK08 ' + char(10)
            SELECT @v_dSql1 += '    ,MAX(CHECK09) CHECK09, MAX(CHECK10) CHECK10, MAX(CHECK11) CHECK11, MAX(CHECK12) CHECK12 ' + char(10)
            SELECT @v_dSql1 += '    ,MAX(CHECK13) CHECK13, MAX(CHECK14) CHECK14, MAX(CHECK15) CHECK15, MAX(CHECK16) CHECK16 ' + char(10)
            SELECT @v_dSql1 += '    ,MAX(CHECK17) CHECK17, MAX(CHECK18) CHECK18, MAX(CHECK19) CHECK19, MAX(CHECK20) CHECK20 ' + char(10)
            SELECT @v_dSql1 += '    ,MAX(DATE_SEQ) DATE_SEQ, MAX(DESCRIPTION) DESCRIPTION, MAX(USER_ID) USER_ID ' + char(10)
            SELECT @v_dSql1 += '  	,MAX(JOB_USER_ID) JOB_USER_NAME, MAX(JOB_TIME) JOB_TIME  ' + char(10)
            SELECT @v_dSql1 += '  FROM (                                                     ' + char(10)
            SELECT @v_dSql1 += '  		SELECT C.STEP_ID, C.STEP_DESC, C.STEP_SEQ, C.ROLE_ID, C.INSTANCE_ID  ' + char(10)
            SELECT @v_dSql1 += '            ,C.PLAN_DATE, C.SCP_PLAN_ID, C.DRAFT_PLAN_ID, C.SYNC_PLAN_ID     ' + char(10)
            SELECT @v_dSql1 += '            ,C.CHECK01,   C.CHECK02,     C.CHECK03,       C.CHECK04          ' + char(10)
            SELECT @v_dSql1 += '            ,C.CHECK05,   C.CHECK06,     C.CHECK07,       C.CHECK08          ' + char(10)
            SELECT @v_dSql1 += '            ,C.CHECK09,   C.CHECK10,     C.CHECK11,       C.CHECK12          ' + char(10)
            SELECT @v_dSql1 += '            ,C.CHECK13,   C.CHECK14,     C.CHECK15,       C.CHECK16          ' + char(10)
            SELECT @v_dSql1 += '            ,C.CHECK17,   C.CHECK18,     C.CHECK19,       C.CHECK20          ' + char(10)
            SELECT @v_dSql1 += '            ,C.DATE_SEQ,  C.DESCRIPTION, C.USER_ID,       C.JOB_USER_ID      ' + char(10)
            SELECT @v_dSql1 += '  		  ,C.JOB_TIME ' + char(10)
            SELECT @v_dSql1 += '  		FROM (        ' + char(10)
            SELECT @v_dSql1 += '  				SELECT A.STEP_ID, A.STEP_DESC, A.STEP_SEQ, A.ROLE_ID                                            ' + char(10)
            SELECT @v_dSql1 += '  				  , MAX('''+ @p_instance_id +''') INSTANCE_ID, MAX('''+ @p_plan_date +''') PLAN_DATE            ' + char(10)
            SELECT @v_dSql1 += '  				  , MAX('''') SCP_PLAN_ID, MAX('''') DRAFT_PLAN_ID, MAX('''') SYNC_PLAN_ID                      ' + char(10)
            SELECT @v_dSql1 += '  				  , MAX('''') CHECK01,     MAX('''')  CHECK02,      MAX('''')  CHECK03,  MAX('''')  CHECK04     ' + char(10)
            SELECT @v_dSql1 += '  				  , MAX('''') CHECK05,     MAX('''')  CHECK06,      MAX('''')  CHECK07,  MAX('''')  CHECK08     ' + char(10)
            SELECT @v_dSql1 += '  				  , MAX('''') CHECK09,     MAX('''')  CHECK10,      MAX('''')  CHECK11,  MAX('''')  CHECK12     ' + char(10)
            SELECT @v_dSql1 += '  				  , MAX('''') CHECK13,     MAX('''')  CHECK14,      MAX('''')  CHECK15,  MAX('''')  CHECK16     ' + char(10)
            SELECT @v_dSql1 += '  				  , MAX('''') CHECK17,     MAX('''')  CHECK18,      MAX('''')  CHECK19,  MAX('''')  CHECK20     ' + char(10)
            SELECT @v_dSql1 += '  				  , MAX('''') DATE_SEQ,    MAX('''') DESCRIPTION,   MAX('''')  USER_ID,  MAX('''')  JOB_USER_ID ' + char(10)
            SELECT @v_dSql1 += '          		  , MAX('''') JOB_TIME    ' + char(10)
            SELECT @v_dSql1 += '  				FROM (                    ' + char(10)
            SELECT @v_dSql1 += '  					SELECT A.SEGMENT1 AS STEP_ID, A.SEGMENT2 AS STEP_DESC                 ' + char(10)
            SELECT @v_dSql1 += '  						, CONVERT(NUMERIC, A.SEGMENT3) AS STEP_SEQ, A.SEGMENT4 AS ROLE_ID ' + char(10)
            SELECT @v_dSql1 += '  						, A.SEGMENT5 AS USE_WOW_STATUS                ' + char(10)
            SELECT @v_dSql1 += '  					FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)        ' + char(10)
            SELECT @v_dSql1 += '  					WHERE  A.LOOKUP_TYPE_CODE = ''PLAN_PROGRESS_CHK'' ' + char(10)
            SELECT @v_dSql1 += '  					AND    A.ACTIVE_FLAG = ''Y''                      ' + char(10)
            SELECT @v_dSql1 += '          			) A                                               ' + char(10)
            SELECT @v_dSql1 += '  				GROUP BY A.STEP_ID, A.STEP_DESC,A.STEP_SEQ, A.ROLE_ID ' + char(10)
            SELECT @v_dSql1 += '          ) C       ' + char(10)
            SELECT @v_dSql2 = ''
		    SELECT @v_dSql2  = '         UNION ALL ' + char(10)
            SELECT @v_dSql2 += '  		SELECT B.STEP_ID, B.STEP_DESC, B.STEP_SEQ, B.ROLE_ID, B.INSTANCE_ID ' + char(10)
            SELECT @v_dSql2 += '          ,B.PLAN_DATE, B.SCP_PLAN_ID, B.DRAFT_PLAN_ID, B.SYNC_PLAN_ID      ' + char(10)
            SELECT @v_dSql2 += '          ,B.CHECK01,   B.CHECK02,     B.CHECK03,       B.CHECK04           ' + char(10)
            SELECT @v_dSql2 += '          ,B.CHECK05,   B.CHECK06,     B.CHECK07,       B.CHECK08           ' + char(10)
            SELECT @v_dSql2 += '          ,B.CHECK09,   B.CHECK10,     B.CHECK11,       B.CHECK12           ' + char(10)
            SELECT @v_dSql2 += '          ,B.CHECK13,   B.CHECK14,     B.CHECK15,       B.CHECK16           ' + char(10)
            SELECT @v_dSql2 += '          ,B.CHECK17,   B.CHECK18,     B.CHECK19,       B.CHECK20           ' + char(10)
            SELECT @v_dSql2 += '  		  ,B.DATE_SEQ,  B.DESCRIPTION, B.USER_ID,       B.JOB_USER_ID       ' + char(10)
            SELECT @v_dSql2 += '  		  ,B.JOB_TIME ' + char(10)
            SELECT @v_dSql2 += '  		FROM (        ' + char(10)
            SELECT @v_dSql2 += '  				SELECT C.STEP_ID, C.STEP_DESC, C.STEP_SEQ, C.ROLE_ID,  C.INSTANCE_ID, C.PLAN_DATE ' + char(10)
            SELECT @v_dSql2 += '  					,  C.SCP_PLAN_ID, C.DRAFT_PLAN_ID, C.SYNC_PLAN_ID, C.DATE_SEQ   ' + char(10)
            SELECT @v_dSql2 += '  					,  MAX(CASE WHEN C.COL_NUM = 1  THEN C.CHECK_FLAG END)  CHECK01 ' + char(10)
            SELECT @v_dSql2 += '  					,  MAX(CASE WHEN C.COL_NUM = 2  THEN C.CHECK_FLAG END)  CHECK02 ' + char(10)
            SELECT @v_dSql2 += '  					,  MAX(CASE WHEN C.COL_NUM = 3  THEN C.CHECK_FLAG END)  CHECK03 ' + char(10)
            SELECT @v_dSql2 += '  					,  MAX(CASE WHEN C.COL_NUM = 4  THEN C.CHECK_FLAG END)  CHECK04 ' + char(10)
            SELECT @v_dSql2 += '  					,  MAX(CASE WHEN C.COL_NUM = 5  THEN C.CHECK_FLAG END)  CHECK05 ' + char(10)
            SELECT @v_dSql2 += '  					,  MAX(CASE WHEN C.COL_NUM = 6  THEN C.CHECK_FLAG END)  CHECK06 ' + char(10)
            SELECT @v_dSql2 += '  					,  MAX(CASE WHEN C.COL_NUM = 7  THEN C.CHECK_FLAG END)  CHECK07 ' + char(10)
            SELECT @v_dSql2 += '          			,  MAX(CASE WHEN C.COL_NUM = 8  THEN C.CHECK_FLAG END)  CHECK08 ' + char(10)
            SELECT @v_dSql2 += '  					,  MAX(CASE WHEN C.COL_NUM = 9  THEN C.CHECK_FLAG END)  CHECK09 ' + char(10)
            SELECT @v_dSql2 += '  					,  MAX(CASE WHEN C.COL_NUM = 10 THEN C.CHECK_FLAG END)  CHECK10 ' + char(10)
            SELECT @v_dSql2 += '          			,  MAX(CASE WHEN C.COL_NUM = 11 THEN C.CHECK_FLAG END)  CHECK11 ' + char(10)
            SELECT @v_dSql2 += '  					,  MAX(CASE WHEN C.COL_NUM = 12 THEN C.CHECK_FLAG END)  CHECK12 ' + char(10)
            SELECT @v_dSql2 += '  					,  MAX(CASE WHEN C.COL_NUM = 13 THEN C.CHECK_FLAG END)  CHECK13 ' + char(10)
            SELECT @v_dSql2 += '  					,  MAX(CASE WHEN C.COL_NUM = 14 THEN C.CHECK_FLAG END)  CHECK14 ' + char(10)
            SELECT @v_dSql2 += '  					,  MAX(CASE WHEN C.COL_NUM = 15 THEN C.CHECK_FLAG END)  CHECK15 ' + char(10)
            SELECT @v_dSql2 += '  					,  MAX(CASE WHEN C.COL_NUM = 16 THEN C.CHECK_FLAG END)  CHECK16 ' + char(10)
            SELECT @v_dSql2 += '  					,  MAX(CASE WHEN C.COL_NUM = 17 THEN C.CHECK_FLAG END)  CHECK17 ' + char(10)
            SELECT @v_dSql2 += '          			,  MAX(CASE WHEN C.COL_NUM = 18 THEN C.CHECK_FLAG END)  CHECK18 ' + char(10)
            SELECT @v_dSql2 += '  					,  MAX(CASE WHEN C.COL_NUM = 19 THEN C.CHECK_FLAG END)  CHECK19 ' + char(10)
            SELECT @v_dSql2 += '  					,  MAX(CASE WHEN C.COL_NUM = 20 THEN C.CHECK_FLAG END)  CHECK20 ' + char(10)
            SELECT @v_dSql2 += '          			,  MAX(C.DESCRIPTION) DESCRIPTION,      MAX(C.USER_ID) USER_ID  ' + char(10)
            SELECT @v_dSql2 += '  					,  MAX(C.JOB_USER_ID) JOB_USER_ID,    MAX(C.JOB_TIME) JOB_TIME  ' + char(10)
            SELECT @v_dSql2 += '  				FROM (                                                      ' + char(10)
            SELECT @v_dSql2 += '  					   SELECT A.STEP_ID, '''' STEP_DESC, CAST(SUBSTRING(A.STEP_ID,5,2) AS INT) STEP_SEQ ' + char(10)
            SELECT @v_dSql2 += '  						   , '''' ROLE_ID,  A.INSTANCE_ID, A.PLAN_DATE      ' + char(10)
            SELECT @v_dSql2 += '  						   , A.SCP_PLAN_ID, A.DRAFT_PLAN_ID, A.SYNC_PLAN_ID ' + char(10)
            SELECT @v_dSql2 += '  						   , A.CHECK_FLAG , A.DESCRIPTION                   ' + char(10)
            SELECT @v_dSql2 += '                           , A.DATE_SEQ, A.USER_GROUP_ID                    ' + char(10)
            SELECT @v_dSql2 += '  						   , A.UPDATE_ID As USER_ID, B.USER_NAME+''(''+ A.UPDATE_ID+'')'' As JOB_USER_ID    ' + char(10)
            SELECT @v_dSql2 += '  						   , CONVERT(VARCHAR,A.UPDATE_TIME,20) AS JOB_TIME  ' + char(10)
            SELECT @v_dSql2 += '  						   , DENSE_RANK() OVER(  PARTITION BY A.INSTANCE_ID,A.PLAN_DATE, A.STEP_ID          ' + char(10)
            SELECT @v_dSql2 += '  							   ORDER BY A.INSTANCE_ID,A.PLAN_DATE, A.STEP_ID, A.USER_GROUP_ID  ASC) COL_NUM ' + char(10)
            SELECT @v_dSql2 += '  					   FROM   FP_PLAN_PROG_CHK_H A WITH(NOLOCK)             ' + char(10)
            SELECT @v_dSql2 += '  					   LEFT OUTER JOIN TH_UIS_USER_DETAIL B WITH(NOLOCK)    ' + char(10)
            SELECT @v_dSql2 += '  					   ON     A.UPDATE_ID   = B.USER_ID                     ' + char(10)
            SELECT @v_dSql2 += '  					   WHERE  A.INSTANCE_ID = '''+ @p_instance_id +'''      ' + char(10)
            SELECT @v_dSql2 += '  					   AND    A.PLAN_DATE   = '''+ @p_plan_date +'''        ' + char(10)
            SELECT @v_dSql2 += '  					   AND    A.ACTIVE_FLAG = ''Y''                         ' + char(10)
            SELECT @v_dSql2 += '          			) C                                                     ' + char(10)
            SELECT @v_dSql2 += '  				GROUP BY C.STEP_ID, C.STEP_DESC, C.STEP_SEQ, C.ROLE_ID,  C.INSTANCE_ID, C.PLAN_DATE ' + char(10)
            SELECT @v_dSql2 += '  						   , C.SCP_PLAN_ID, C.DRAFT_PLAN_ID, C.SYNC_PLAN_ID, C.DATE_SEQ             ' + char(10)
            SELECT @v_dSql2 += '  			) B      ' + char(10)
            SELECT @v_dSql2 += '  ) D                ' + char(10)
            SELECT @v_dSql2 += '  GROUP BY D.STEP_ID ' + char(10)
            --SELECT @v_dSql2 += '  ) M ' + char(10)


			SELECT @v_dSql =  @v_dSql1 +  @v_dSql2

			IF @p_sys_type = 'SQL'
				BEGIN
					--EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
					SELECT @v_dSql as [QUERY_VALUE]

				END  
			ELSE 
				BEGIN
					SET @runstart = GetDate()
					--쿼리실행
					EXEC sp_executesql @v_dSql

					SET @runend = GetDate()
					EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_dSql,'select',@runstart, @runend
				END	
			END

    ELSE IF(@p_sys_flag ='EXECUTE_SENDMAIL_QUANTITY_CHECK')
	    BEGIN --ELSE IF(START)
		    SELECT @v_dSql = ''
			SELECT @v_dSql = 'EXEC [dbo].[PR_SCM_PLAN_RESULT_SEND] '''+ @p_instance_id +''', '''+ @p_plan_date +''', '''+ @p_factory_id +'''  '
			--Log남김
			EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, 'PR_SCM_PLAN_RESULT_SEND','',@v_dSql,'select',@runstart, @runend

			--수행
			EXEC  @rtnCount = [dbo].[PR_SCM_PLAN_RESULT_SEND] @p_instance_id, @p_plan_date, @p_factory_id
			
			SET @rtnCount = 1
            SELECT	'Result' = @rtnCount
   --         IF @p_sys_type = 'SQL'
			--	BEGIN
			--		EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
			--		SELECT @v_dSql as [QUERY_VALUE]

			--	END  
			--ELSE 
			--	BEGIN
			--		SET @runstart = GetDate()
			--		--쿼리실행
			--		EXEC sp_executesql @v_dSql

			--		SET @runend = GetDate()
			--		EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
			--	END	
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

						SELECT @v_sys_type = [dbo].[SCM_ARR_SPL_VAL](@p_sys_type       ,@v_delimiter, @mst_loop_cnt)
						, @v_sys_flag      = [dbo].[SCM_ARR_SPL_VAL](@p_sys_flag       ,@v_delimiter, @mst_loop_cnt)
						, @v_sys_gubun     = [dbo].[SCM_ARR_SPL_VAL](@p_sys_gubun      ,@v_delimiter, @mst_loop_cnt)
						, @v_user_id       = [dbo].[SCM_ARR_SPL_VAL](@p_user_id        ,@v_delimiter, @mst_loop_cnt)
						, @v_division_id   = [dbo].[SCM_ARR_SPL_VAL](@p_division_id    ,@v_delimiter, @mst_loop_cnt)
                        , @v_site_id       = [dbo].[SCM_ARR_SPL_VAL](@p_site_id        ,@v_delimiter, @mst_loop_cnt)
                        , @v_factory_id    = [dbo].[SCM_ARR_SPL_VAL](@p_factory_id     ,@v_delimiter, @mst_loop_cnt)
                        , @v_instance_id   = [dbo].[SCM_ARR_SPL_VAL](@p_instance_id    ,@v_delimiter, @mst_loop_cnt)
                        , @v_plan_date     = [dbo].[SCM_ARR_SPL_VAL](@p_plan_date      ,@v_delimiter, @mst_loop_cnt)
                        , @v_plan_id       = [dbo].[SCM_ARR_SPL_VAL](@p_plan_id        ,@v_delimiter, @mst_loop_cnt)
						, @v_step_id       = [dbo].[SCM_ARR_SPL_VAL](@p_step_id        ,@v_delimiter, @mst_loop_cnt)
                        , @v_date_seq      = [dbo].[SCM_ARR_SPL_VAL](@p_date_seq       ,@v_delimiter, @mst_loop_cnt)
                        , @v_user_group_id = [dbo].[SCM_ARR_SPL_VAL](@p_user_group_id  ,@v_delimiter, @mst_loop_cnt)
                        , @v_set_step      = [dbo].[SCM_ARR_SPL_VAL](@p_set_step       ,@v_delimiter, @mst_loop_cnt)
                        , @v_scp_plan_id   = [dbo].[SCM_ARR_SPL_VAL](@p_scp_plan_id    ,@v_delimiter, @mst_loop_cnt)
                        , @v_draft_plan_id = [dbo].[SCM_ARR_SPL_VAL](@p_draft_plan_id  ,@v_delimiter, @mst_loop_cnt)
                        , @v_sync_plan_id  = [dbo].[SCM_ARR_SPL_VAL](@p_sync_plan_id   ,@v_delimiter, @mst_loop_cnt)

                        
					   /******************************************************************************/
					   /* UPDATE 경우 : UPDATE_RESET_SUBMIT                                     */
					   /******************************************************************************/
					   IF(@v_sys_flag ='UPDATE_RESET_SUBMIT')  
							BEGIN
                                SELECT @v_dSql1 = ''
                                SELECT @v_dSql1 += ' UPDATE FP_PLAN_PROG_CHK_H SET                           ' + char(10)
                                SELECT @v_dSql1 += '   ACTIVE_FLAG  = ''N''                                  ' + char(10)
                                SELECT @v_dSql1 += '  , UPDATE_ID   = '''+@v_user_id +'''                    ' + char(10)
								SELECT @v_dSql1 += '  , UPDATE_TIME = dbo.FN_SITE_TIME('''+ @v_site_id +''') ' + char(10)
                                SELECT @v_dSql1 += ' WHERE  INSTANCE_ID = '''+ @v_instance_id +'''           ' + char(10)
                                SELECT @v_dSql1 += ' AND    PLAN_DATE   = '''+ @v_plan_date +'''             ' + char(10)
                                SELECT @v_dSql1 += ' AND    ACTIVE_FLAG = ''Y''                              ' + char(10)
								
								SELECT @v_dSql2  = ''
                                SELECT @v_dSql2 += ' INSERT INTO FP_PLAN_PROG_CHK_H (               ' + char(10)
                                SELECT @v_dSql2 += '     INSTANCE_ID,   DRAFT_PLAN_ID, SYNC_PLAN_ID ' + char(10)
                                SELECT @v_dSql2 += '   , PLAN_DATE,     DATE_SEQ,      STEP_ID      ' + char(10)
                                SELECT @v_dSql2 += '   , USER_GROUP_ID, CHECK_FLAG,    SCP_PLAN_ID  ' + char(10)
                                SELECT @v_dSql2 += '   , ACTIVE_FLAG,   DESCRIPTION,   INSERT_ID    ' + char(10)
                                SELECT @v_dSql2 += '   , INSERT_TIME,   UPDATE_ID,     UPDATE_TIME  ' + char(10)
                                SELECT @v_dSql2 += ' ) ' + char(10)
                                SELECT @v_dSql2 += ' SELECT '''+ @v_instance_id +''' AS INSTANCE_ID, ''-'' AS DRAFT_PLAN_ID ' + char(10)
                                SELECT @v_dSql2 += '     , ''-'' AS SYNC_PLAN_ID, '''+ @v_plan_date +''' AS PLAN_DATE       ' + char(10)
                                SELECT @v_dSql2 += '     , ( SELECT (ISNULL(MAX(A.DATE_SEQ),0) + 1) AS NEW_DATE_SEQ         ' + char(10)
                                SELECT @v_dSql2 += '         FROM   FP_PLAN_PROG_CHK_H A WITH(NOLOCK)                       ' + char(10)
                                SELECT @v_dSql2 += '         WHERE  A.INSTANCE_ID = '''+ @v_instance_id +'''                ' + char(10)
                                SELECT @v_dSql2 += '         AND    A.PLAN_DATE   = '''+ @v_plan_date +'''                  ' + char(10)
                                SELECT @v_dSql2 += '       ) AS DATE_SEQ, A.STEP_ID, A.USER_GROUP_ID, ''N'' AS CHECK_FLAG   ' + char(10)
                                SELECT @v_dSql2 += '     , (SELECT MAX(SCP_PLAN_ID) AS PLAN_ID FROM FP_WEEKLY_DEMAND_PRODUCT_H A WITH(NOLOCK)) AS SCP_PLAN_ID  ' + char(10)
                                SELECT @v_dSql2 += '     , ''Y'' AS ACTIVE_FLAG, '''' AS DESCRIPTION, '''+@v_user_id +''' AS INSERT_ID              ' + char(10)
                                SELECT @v_dSql2 += '     , dbo.FN_SITE_TIME('''+ @v_site_id +''') AS INSERT_TIME, '''+@v_user_id +''' AS UPDATE_ID  ' + char(10)
                                SELECT @v_dSql2 += '     , dbo.FN_SITE_TIME('''+ @v_site_id +''') AS UPDATE_TIME                                    ' + char(10)
                                SELECT @v_dSql2 += ' FROM (                             ' + char(10)
                                SELECT @v_dSql2 += '       SELECT A.* , B.USER_GROUP_ID ' + char(10)
                                SELECT @v_dSql2 += '          , ROW_NUMBER( ) OVER( PARTITION BY A.STEP_SEQ ORDER BY A.STEP_SEQ, B.USER_GROUP_ID ) AS COL_NUM ' + char(10)
                                SELECT @v_dSql2 += '       FROM (                       ' + char(10)
                                SELECT @v_dSql2 += '              SELECT A.*, ''ROW'' + CONVERT(VARCHAR,ROW_NUM) AS ROW_VALUE        ' + char(10)
                                SELECT @v_dSql2 += '              FROM (                                                             ' + char(10)
                                SELECT @v_dSql2 += '                    SELECT ROW.STEP_ID, ROW.STEP_DESC, ROW.STEP_SEQ, ROW.ROLE_ID ' + char(10)
                                SELECT @v_dSql2 += '                         , (CASE WHEN ROW.ROLE_ID = ''MASTER'' THEN ''-'' ELSE COL.PLAN_GROUP_ID END) AS PLAN_GROUP_ID     ' + char(10)
                                SELECT @v_dSql2 += '                         , (CASE WHEN ROW.ROLE_ID = ''MASTER'' THEN ''-'' ELSE COL.PLAN_GROUP_DESC END) AS PLAN_GROUP_DESC ' + char(10)
                                SELECT @v_dSql2 += '                         , ROW.STEP_SEQ AS ROW_NUM ' + char(10)
                                SELECT @v_dSql2 += '                    FROM (                         ' + char(10)
                                SELECT @v_dSql2 += '                        SELECT A.SEGMENT1 AS STEP_ID, A.SEGMENT2 AS STEP_DESC, CONVERT(NUMERIC, A.SEGMENT3) AS STEP_SEQ, A.SEGMENT4 AS ROLE_ID ' + char(10)
                                SELECT @v_dSql2 += '                        FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)        ' + char(10)
                                SELECT @v_dSql2 += '                        WHERE  A.LOOKUP_TYPE_CODE = ''PLAN_PROGRESS_CHK'' ' + char(10)
                                SELECT @v_dSql2 += '                        AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
                                SELECT @v_dSql2 += '                    ) AS ROW, (                      ' + char(10)
                                SELECT @v_dSql2 += '                        SELECT A.INSTANCE_ID         ' + char(10)
                                SELECT @v_dSql2 += '                             , A.PLAN_GROUP_ID, A.PLAN_GROUP_DESC       ' + char(10)
                                SELECT @v_dSql2 += '                             , A.USER_GROUP_ID, A.USER_GROUP_DESC       ' + char(10)
                                SELECT @v_dSql2 += '                        FROM   FP_PLAN_GROUP_M A WITH(NOLOCK)           ' + char(10)
                                SELECT @v_dSql2 += '                        WHERE  A.INSTANCE_ID = '''+ @v_instance_id +''' ' + char(10)
                                SELECT @v_dSql2 += '                        AND    A.ACTIVE_FLAG = ''Y''                    ' + char(10)
                                SELECT @v_dSql2 += '                    ) AS COL                                            ' + char(10)
                                SELECT @v_dSql2 += '                    GROUP BY ROW.STEP_ID, ROW.STEP_DESC, ROW.STEP_SEQ, ROW.ROLE_ID                        ' + char(10)
                                SELECT @v_dSql2 += '                            ,(CASE WHEN ROW.ROLE_ID = ''MASTER'' THEN ''-'' ELSE COL.PLAN_GROUP_ID END)   ' + char(10)
                                SELECT @v_dSql2 += '                            ,(CASE WHEN ROW.ROLE_ID = ''MASTER'' THEN ''-'' ELSE COL.PLAN_GROUP_DESC END) ' + char(10)
                                SELECT @v_dSql2 += '              ) A ' + char(10)
                                SELECT @v_dSql2 += '       ) A,       ' + char(10)
                                SELECT @v_dSql2 += ' 	  (           ' + char(10)
                                SELECT @v_dSql2 += '           SELECT _ROW.STEP_ID, _ROW.STEP_DESC, _ROW.STEP_SEQ, _ROW.ROLE_ID                                         ' + char(10)
                                SELECT @v_dSql2 += '                , (CASE WHEN _ROW.ROLE_ID = ''MASTER'' THEN ''-'' ELSE _COL.PLAN_GROUP_ID END) AS PLAN_GROUP_ID     ' + char(10)
                                SELECT @v_dSql2 += '                , (CASE WHEN _ROW.ROLE_ID = ''MASTER'' THEN ''-'' ELSE _COL.USER_GROUP_ID END) AS USER_GROUP_ID     ' + char(10)
                                SELECT @v_dSql2 += '                , (CASE WHEN _ROW.ROLE_ID = ''MASTER'' THEN ''-'' ELSE _COL.USER_GROUP_DESC END) AS USER_GROUP_DESC ' + char(10)
                                SELECT @v_dSql2 += '           FROM (          ' + char(10)
                                SELECT @v_dSql2 += '                    SELECT A.SEGMENT1 AS STEP_ID, A.SEGMENT2 AS STEP_DESC, CONVERT(NUMERIC, A.SEGMENT3) AS STEP_SEQ, A.SEGMENT4 AS ROLE_ID ' + char(10)
                                SELECT @v_dSql2 += '                    FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)        ' + char(10)
                                SELECT @v_dSql2 += '                    WHERE  A.LOOKUP_TYPE_CODE = ''PLAN_PROGRESS_CHK'' ' + char(10)
                                SELECT @v_dSql2 += '                    AND    A.ACTIVE_FLAG = ''Y''                      ' + char(10)
                                SELECT @v_dSql2 += '                 ) AS _ROW ' + char(10)
								SELECT @v_dSql2 += '               , (         ' + char(10)
                                SELECT @v_dSql2 += '                    SELECT A.INSTANCE_ID, A.PLAN_GROUP_ID, A.PLAN_GROUP_DESC ' + char(10)
                                SELECT @v_dSql2 += '                         , A.USER_GROUP_ID, A.USER_GROUP_DESC                ' + char(10)
                                SELECT @v_dSql2 += '                    FROM   FP_PLAN_GROUP_M A WITH(NOLOCK)                    ' + char(10)
                                SELECT @v_dSql2 += '                    WHERE  A.INSTANCE_ID = '''+ @v_instance_id +'''          ' + char(10)
                                SELECT @v_dSql2 += '                    AND    A.ACTIVE_FLAG = ''Y''                             ' + char(10)
                                SELECT @v_dSql2 += '                 ) AS _COL                                                   ' + char(10)
                                SELECT @v_dSql2 += '             GROUP BY _ROW.STEP_ID, _ROW.STEP_DESC, _ROW.STEP_SEQ, _ROW.ROLE_ID                ' + char(10)
                                SELECT @v_dSql2 += '               ,(CASE WHEN _ROW.ROLE_ID = ''MASTER'' THEN ''-'' ELSE _COL.PLAN_GROUP_ID END)   ' + char(10)
                                SELECT @v_dSql2 += '               ,(CASE WHEN _ROW.ROLE_ID = ''MASTER'' THEN ''-'' ELSE _COL.USER_GROUP_ID END)   ' + char(10)
                                SELECT @v_dSql2 += '               ,(CASE WHEN _ROW.ROLE_ID = ''MASTER'' THEN ''-'' ELSE _COL.USER_GROUP_DESC END) ' + char(10)
                                SELECT @v_dSql2 += '       ) B                                     ' + char(10)
                                SELECT @v_dSql2 += '       WHERE A.STEP_ID = B.STEP_ID             ' + char(10)
                                SELECT @v_dSql2 += '       AND   A.PLAN_GROUP_ID = B.PLAN_GROUP_ID ' + char(10)
                                SELECT @v_dSql2 += ' ) A                                           ' + char(10)

								SELECT @v_dSql = @v_dSql1 + @v_dSql2 
						   END --'I'
					   /****************************************************************************/
					   /* UPDATE  경우  :UPDATE_DRAFT_PLAN                                     */
					   /****************************************************************************/
					   ELSE IF(@v_sys_flag ='UPDATE_DRAFT_PLAN')
							BEGIN
							    SELECT @v_dSql = ''
                                SELECT @v_dSql += ' UPDATE FP_PLAN_PROG_CHK_H SET                                  ' + char(10)
                                SELECT @v_dSql += '        DRAFT_PLAN_ID  = '''+ @v_draft_plan_id +'''             ' + char(10)
                                SELECT @v_dSql += '      , CHECK_FLAG     = ''N''                                  ' + char(10)
                                SELECT @v_dSql += '      , SYNC_PLAN_ID   = ''-''                                  ' + char(10)
                                SELECT @v_dSql += '      , UPDATE_ID      = '''+ @v_user_id +'''                   ' + char(10)
                                SELECT @v_dSql += '      , UPDATE_TIME    = dbo.FN_SITE_TIME('''+ @v_site_id +''') ' + char(10)
                                SELECT @v_dSql += ' WHERE  INSTANCE_ID    = '''+ @v_instance_id +'''               ' + char(10)
                                SELECT @v_dSql += ' AND    PLAN_DATE      = '''+ @v_plan_date +'''                 ' + char(10)
                                SELECT @v_dSql += ' AND    DATE_SEQ       = '''+ @v_date_seq +'''                  ' + char(10)

                                SELECT @v_dSql += ' UPDATE FP_PLAN_PROG_CHK_H SET                                  ' + char(10)
                                SELECT @v_dSql += '        CHECK_FLAG  = ''Y'', UPDATE_ID = '''+ @v_user_id +'''   ' + char(10)
                                SELECT @v_dSql += '      , UPDATE_TIME = dbo.FN_SITE_TIME('''+ @v_site_id +''')    ' + char(10)
                                SELECT @v_dSql += ' WHERE  INSTANCE_ID = '''+ @v_instance_id +'''  ' + char(10)
                                SELECT @v_dSql += ' AND    PLAN_DATE   = '''+ @v_plan_date +'''    ' + char(10)
                                SELECT @v_dSql += ' AND    DATE_SEQ    = '''+ @v_date_seq +'''     ' + char(10)
                                SELECT @v_dSql += ' AND    STEP_ID IN (                            ' + char(10)
                                SELECT @v_dSql += '                   SELECT A.STEP_ID             ' + char(10)
                                SELECT @v_dSql += '                   FROM (                       ' + char(10)
                                SELECT @v_dSql += '                           SELECT A.SEGMENT1 AS STEP_ID, A.SEGMENT2 AS STEP_DESC    ' + char(10)
								SELECT @v_dSql += '                              , CONVERT(NUMERIC, A.SEGMENT3) AS STEP_SEQ            ' + char(10)
								SELECT @v_dSql += '                              , A.SEGMENT4 AS ROLE_ID                               ' + char(10)
                                SELECT @v_dSql += '                              ,(CASE WHEN B.STEP_SEQ < CONVERT(NUMERIC, A.SEGMENT3) ' + char(10)
								SELECT @v_dSql += '                                        THEN ''N'' ELSE ''Y'' END) AS YN            ' + char(10)
                                SELECT @v_dSql += '                           FROM  SCM_SYS_LOOKUP_VALUE A,                            ' + char(10)
                                SELECT @v_dSql += '                              ( SELECT CONVERT(NUMERIC, A.SEGMENT3) AS STEP_SEQ     ' + char(10)
                                SELECT @v_dSql += '                                FROM   SCM_SYS_LOOKUP_VALUE A                       ' + char(10)
                                SELECT @v_dSql += '                                WHERE  A.LOOKUP_TYPE_CODE = ''PLAN_PROGRESS_CHK''   ' + char(10)
                                SELECT @v_dSql += '                                AND    A.SEGMENT1 = '''+ @v_set_step +'''           ' + char(10)
                                SELECT @v_dSql += '                                AND    A.ACTIVE_FLAG = ''Y''                        ' + char(10)
                                SELECT @v_dSql += '                               ) B                                                  ' + char(10)
                                SELECT @v_dSql += '                           WHERE  A.LOOKUP_TYPE_CODE = ''PLAN_PROGRESS_CHK''        ' + char(10)
                                SELECT @v_dSql += '                        ) A            ' + char(10)
                                SELECT @v_dSql += '                   WHERE A.YN = ''Y''  ' + char(10)
                                SELECT @v_dSql += ' )                                     ' + char(10)
                            END --M
					   /****************************************************************************/
					   /* UPDATE  경우  :UPDATE_SYNC_PLAN                                     */
					   /****************************************************************************/
					   ELSE IF(@v_sys_flag ='UPDATE_SYNC_PLAN')
							BEGIN
							    SELECT @v_dSql = ''
                                SELECT @v_dSql += ' UPDATE FP_PLAN_PROG_CHK_H SET                                  ' + char(10)
                                SELECT @v_dSql += '        SYNC_PLAN_ID   = '''+ @v_sync_plan_id +'''              ' + char(10)
                                SELECT @v_dSql += '      , CHECK_FLAG     = ''N''                                  ' + char(10)
                                SELECT @v_dSql += '      , UPDATE_ID      = '''+ @v_user_id +'''                   ' + char(10)
                                SELECT @v_dSql += '      , UPDATE_TIME    = dbo.FN_SITE_TIME('''+ @v_site_id +''') ' + char(10)
                                SELECT @v_dSql += ' WHERE  INSTANCE_ID    = '''+ @v_instance_id +'''               ' + char(10)
                                SELECT @v_dSql += ' AND    PLAN_DATE      = '''+ @v_plan_date +'''                 ' + char(10)
                                SELECT @v_dSql += ' AND    DATE_SEQ       = '''+ @v_date_seq +'''                  ' + char(10)

                                SELECT @v_dSql += ' UPDATE FP_PLAN_PROG_CHK_H SET                                  ' + char(10)
                                SELECT @v_dSql += '        CHECK_FLAG  = ''Y'', UPDATE_ID = '''+ @v_user_id +'''   ' + char(10)
                                SELECT @v_dSql += '      , UPDATE_TIME = dbo.FN_SITE_TIME('''+ @v_site_id +''')    ' + char(10)
                                SELECT @v_dSql += ' WHERE  INSTANCE_ID = '''+ @v_instance_id +'''  ' + char(10)
                                SELECT @v_dSql += ' AND    PLAN_DATE   = '''+ @v_plan_date +'''    ' + char(10)
                                SELECT @v_dSql += ' AND    DATE_SEQ    = '''+ @v_date_seq +'''     ' + char(10)
                                SELECT @v_dSql += ' AND    STEP_ID IN (                            ' + char(10)
                                SELECT @v_dSql += '                   SELECT A.STEP_ID             ' + char(10)
                                SELECT @v_dSql += '                   FROM (                       ' + char(10)
                                SELECT @v_dSql += '                           SELECT A.SEGMENT1 AS STEP_ID, A.SEGMENT2 AS STEP_DESC    ' + char(10)
								SELECT @v_dSql += '                              , CONVERT(NUMERIC, A.SEGMENT3) AS STEP_SEQ            ' + char(10)
								SELECT @v_dSql += '                              , A.SEGMENT4 AS ROLE_ID                               ' + char(10)
                                SELECT @v_dSql += '                              ,(CASE WHEN B.STEP_SEQ < CONVERT(NUMERIC, A.SEGMENT3) ' + char(10)
								SELECT @v_dSql += '                                        THEN ''N'' ELSE ''Y'' END) AS YN            ' + char(10)
                                SELECT @v_dSql += '                           FROM  SCM_SYS_LOOKUP_VALUE A,                            ' + char(10)
                                SELECT @v_dSql += '                              ( SELECT CONVERT(NUMERIC, A.SEGMENT3) AS STEP_SEQ     ' + char(10)
                                SELECT @v_dSql += '                                FROM   SCM_SYS_LOOKUP_VALUE A                       ' + char(10)
                                SELECT @v_dSql += '                                WHERE  A.LOOKUP_TYPE_CODE = ''PLAN_PROGRESS_CHK''   ' + char(10)
                                SELECT @v_dSql += '                                AND    A.SEGMENT1 = '''+ @v_set_step +'''           ' + char(10)
                                SELECT @v_dSql += '                                AND    A.ACTIVE_FLAG = ''Y''                        ' + char(10)
                                SELECT @v_dSql += '                               ) B                                                  ' + char(10)
                                SELECT @v_dSql += '                           WHERE  A.LOOKUP_TYPE_CODE = ''PLAN_PROGRESS_CHK''        ' + char(10)
                                SELECT @v_dSql += '                        ) A            ' + char(10)
                                SELECT @v_dSql += '                   WHERE A.YN = ''Y''  ' + char(10)
                                SELECT @v_dSql += ' )                                     ' + char(10)
                            END --M
					   /****************************************************************************/
					   /* UPDATE  경우  :UPDATE_STEP_GROUP                                          */
					   /****************************************************************************/
					   ELSE IF(@v_sys_flag ='UPDATE_STEP_GROUP')
						   BEGIN
								SELECT @v_dSql = ''
                                SELECT @v_dSql += ' UPDATE FP_PLAN_PROG_CHK_H SET                                ' + char(10)
                                SELECT @v_dSql += '      CHECK_FLAG    = ''Y''                                   ' + char(10)
                                SELECT @v_dSql += '    , UPDATE_ID     = '''+ @v_user_id +'''                    ' + char(10)
                                SELECT @v_dSql += '    , UPDATE_TIME   = dbo.FN_SITE_TIME('''+ @v_site_id +''')  ' + char(10)
                                SELECT @v_dSql += '  WHERE  INSTANCE_ID   = '''+ @v_instance_id +'''             ' + char(10)
                                SELECT @v_dSql += '  AND    PLAN_DATE     = '''+ @v_plan_date +'''               ' + char(10)
                                SELECT @v_dSql += '  AND    DATE_SEQ      = '''+ @v_date_seq +'''                ' + char(10)
                                SELECT @v_dSql += '  AND    STEP_ID       = '''+ @v_step_id +'''                 ' + char(10)
                                SELECT @v_dSql += '  AND    USER_GROUP_ID = '''+ @v_user_group_id +'''           ' + char(10)
						   END --'M1'
					   /****************************************************************************/
					   /* UPDATE  경우  :TEST                                          */
					   /****************************************************************************/
					   ELSE IF(@v_sys_flag ='TEST')
						   BEGIN
								SELECT @v_dSql = ''


						   END --'M1'

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

