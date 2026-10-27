

/*
 * Program ID   : PR_UI_FP00160_BUILDING_BOD
 * Description  : Buidling BOD
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/03/18   JYJ				Initial Release UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FP00160_BUILDING_BOD]
  @p_sys_type             NVARCHAR(MAX),
  @p_sys_flag             NVARCHAR(MAX),
  @p_sys_gubun            NVARCHAR(MAX),
  @p_user_id              NVARCHAR(MAX),
  @p_company_id           NVARCHAR(MAX),
  @p_division_id          NVARCHAR(MAX),
  @p_site_id              NVARCHAR(MAX),
  @p_plant_id             NVARCHAR(MAX),
  @p_factory_id           NVARCHAR(MAX),
  @p_bod_id               NVARCHAR(MAX),
  @p_from_factory_id      NVARCHAR(MAX),
  @p_from_operation_id    NVARCHAR(MAX),
  @p_to_factory_id        NVARCHAR(MAX),
  @p_to_operation_id      NVARCHAR(MAX),
  @p_bod_pattern_id       NVARCHAR(MAX),
  @p_transport_mode       NVARCHAR(MAX),
  @p_transport_time       NVARCHAR(MAX),
  @p_transport_time_uom   NVARCHAR(MAX),
  @p_bod_start_time       NVARCHAR(MAX),
  @p_release_flag         NVARCHAR(MAX),
  @p_description          NVARCHAR(MAX)

AS 
BEGIN  --MAIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
    SET NOCOUNT ON                                                                                                                                                                                                                                                   
	SET XACT_ABORT ON 

	DECLARE @v_sys_type             NVARCHAR(MAX)  -- 값>> SELEC: SQL저장안함, SQL:SQL저장함
	DECLARE @v_sys_flag             NVARCHAR(MAX)  -- 값>> I: Insert, M: Update, D: Delete, G: MERGE
	DECLARE @v_sys_gubun            NVARCHAR(MAX) 
	DECLARE @v_user_id              NVARCHAR(MAX)
    DECLARE @v_company_id           NVARCHAR(MAX)
	DECLARE @v_division_id          NVARCHAR(MAX)
    DECLARE @v_site_id              NVARCHAR(MAX)
    DECLARE @v_plant_id             NVARCHAR(MAX)
    DECLARE @v_factory_id           NVARCHAR(MAX)
    DECLARE @v_bod_id               NVARCHAR(MAX)
    DECLARE @v_from_factory_id      NVARCHAR(MAX)
    DECLARE @v_from_operation_id    NVARCHAR(MAX)
    DECLARE @v_to_factory_id        NVARCHAR(MAX)
    DECLARE @v_to_operation_id      NVARCHAR(MAX)
    DECLARE @v_bod_pattern_id       NVARCHAR(MAX)
    DECLARE @v_transport_mode       NVARCHAR(MAX)
    DECLARE @v_transport_time       NVARCHAR(MAX)
    DECLARE @v_transport_time_uom   NVARCHAR(MAX)
    DECLARE @v_bod_start_time       NVARCHAR(MAX)
    DECLARE @v_release_flag         NVARCHAR(MAX)
    DECLARE @v_description          NVARCHAR(MAX)

	DECLARE @recv_active_flag       NVARCHAR(MAX)				    
	DECLARE @v_proc_name	        NVARCHAR(100) = 'PR_UI_FP00160_BUILDING_BOD'
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

	SET @v_sys_type           = ''
	SET @v_sys_flag           = ''
	SET @v_sys_gubun          = ''
	SET @v_user_id            = ''
    SET @v_company_id         = '' 
	SET @v_division_id        = '' 
    SET @v_site_id            = '' 
    SET @v_plant_id           = ''
    SET @v_factory_id         = ''
    SET @v_bod_id             = ''
	SET @v_from_factory_id    = ''
	SET @v_from_operation_id  = ''
    SET @v_to_factory_id      = ''
	SET @v_to_operation_id    = ''
    SET @v_bod_pattern_id     = ''
	SET @v_transport_mode      = ''
    SET @v_transport_time      = ''
	SET @v_transport_time_uom  = ''
    SET @v_bod_start_time     = ''
	SET @v_release_flag       = ''
    SET @v_description        = ''

	--SET @p_user_id              = dbo.FN_deCRYPT_AES128(@p_user_id)
	SET @recv_active_flag       = NULL	
	SET @recv_active_flag       = @p_sys_flag
	SET @v_delimiter            = '|'             -- 데이터 구분자
	SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_sys_flag, @v_delimiter) -- 프로시저 LOOP 길이를 판단  

	SET	@v_dSql                 = ''
	SET	@v_dSql1                = ''
	SET	@v_dSql2                = ''
	SET	@v_dSql3                = ''
	/************************************************************************************************/
	/* SELECT인경우 :SELECT(SELECT)                                                                      */
	/************************************************************************************************/
	IF(@p_sys_flag ='SELECT')
		BEGIN --IF(START)
		    SELECT @v_dSql =''
            SELECT @v_dSql += ' SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                         ' + char(10)
            SELECT @v_dSql += '     , A.FACTORY_ID, A.BOD_ID, A.FROM_FACTORY_ID, A.FROM_OPERATION_ID              ' + char(10)
            SELECT @v_dSql += '     , A.TO_FACTORY_ID, A.TO_OPERATION_ID, B.OPERATION_NAME AS FROM_OPERATION_NAME ' + char(10)
            SELECT @v_dSql += '     , C.OPERATION_NAME AS TO_OPERATION_NAME, A.BOD_PATTERN_ID                     ' + char(10)
            SELECT @v_dSql += '     , A.TRANSPORT_MODE, A.TRANSPORT_TIME, A.TRANSPORT_TIME_UOM                    ' + char(10)
            SELECT @v_dSql += '     , FORMAT(A.BOD_START_TIME ,''yyyyMMddHHmmss'') AS BOD_START_TIME              ' + char(10)
            SELECT @v_dSql += '     , A.RELEASE_FLAG, A.DESCRIPTION                                               ' + char(10)
            SELECT @v_dSql += '     , (CASE WHEN R.FACTORY_ID IS NULL THEN ''N'' ELSE ''Y'' END) AS EDIT_YN       ' + char(10)
            SELECT @v_dSql += '     , (CASE WHEN R2.FACTORY_ID IS NULL THEN ''N'' ELSE ''Y'' END) AS EDIT_YN2     ' + char(10)
            SELECT @v_dSql += ' FROM   SCM_BOD_M A WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += ' LEFT OUTER JOIN (               ' + char(10)
            SELECT @v_dSql += '      SELECT DISTINCT R.FACTORY_ID, R.OPERATION_ID ' + char(10)
            SELECT @v_dSql += '      FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK)    ' + char(10)
            SELECT @v_dSql += '      WHERE  R.USER_ID   = '''+ @p_user_id +'''    ' + char(10)
            SELECT @v_dSql += '      AND    R.SAVE_FLAG = ''Y''                   ' + char(10)
            SELECT @v_dSql += ' ) R ' + char(10)
            SELECT @v_dSql += ' ON   A.FROM_FACTORY_ID     = R.FACTORY_ID   ' + char(10)
            SELECT @v_dSql += ' AND  A.FROM_OPERATION_ID   = R.OPERATION_ID ' + char(10)
            SELECT @v_dSql += ' LEFT OUTER JOIN (                           ' + char(10)
            SELECT @v_dSql += '      SELECT DISTINCT R.FACTORY_ID, R.OPERATION_ID ' + char(10)
            SELECT @v_dSql += '      FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK)    ' + char(10)
            SELECT @v_dSql += '      WHERE  R.USER_ID   = '''+ @p_user_id +'''    ' + char(10)
            SELECT @v_dSql += '      AND    R.SAVE_FLAG = ''Y''                   ' + char(10)
            SELECT @v_dSql += ' ) R2 ' + char(10)
            SELECT @v_dSql += ' ON   A.TO_FACTORY_ID       = R2.FACTORY_ID   ' + char(10)
            SELECT @v_dSql += ' AND  A.TO_OPERATION_ID     = R2.OPERATION_ID ' + char(10)
            SELECT @v_dSql += ' , SCM_OPERATION_M B WITH(NOLOCK), SCM_OPERATION_M C WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += ' WHERE  A.COMPANY_ID        = B.COMPANY_ID   ' + char(10)
            SELECT @v_dSql += ' AND    A.DIVISION_ID       = B.DIVISION_ID  ' + char(10)
            SELECT @v_dSql += ' AND    A.SITE_ID           = B.SITE_ID      ' + char(10)
            SELECT @v_dSql += ' AND    A.FROM_OPERATION_ID = B.OPERATION_ID ' + char(10)
            SELECT @v_dSql += ' AND    A.COMPANY_ID        = C.COMPANY_ID   ' + char(10)
            SELECT @v_dSql += ' AND    A.DIVISION_ID       = C.DIVISION_ID  ' + char(10)
            SELECT @v_dSql += ' AND    A.SITE_ID           = C.SITE_ID      ' + char(10)
            SELECT @v_dSql += ' AND    A.TO_OPERATION_ID   = C.OPERATION_ID ' + char(10)
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))    + char(10)
	        SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
	        SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FROM_FACTORY_ID' , 'EQ', @p_from_factory_id))    + char(10)
            SELECT @v_dSql += ' ORDER BY A.DIVISION_ID, A.FROM_FACTORY_ID, FROM_OPERATION_ID, TO_FACTORY_ID, TO_OPERATION_ID, TRANSPORT_MODE ' + char(10)

			IF @p_sys_type = 'SQL'
				BEGIN
					EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
					SELECT @v_dSql as [QUERY_VALUE]

				END  
			ELSE 
				BEGIN
					SET @runstart = GetDate()
					--쿼리실행
					EXEC sp_executesql @v_dSql

					SET @runend = GetDate()
					EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
				END
	    END	--IF( END )
    /************************************************************************************************/
	/* SELECT경우 :(SELECT_IMPORT Select)                                            */
	/************************************************************************************************/
    ELSE IF(@p_sys_flag ='SELECT_IMPORT')
	    BEGIN --ELSE IF(START)
		    SELECT @v_dSql = ''
            SELECT @v_dSql += ' SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                         ' + char(10)
            SELECT @v_dSql += '     , A.FACTORY_ID, A.BOD_ID, A.FROM_FACTORY_ID, A.FROM_OPERATION_ID              ' + char(10)
            SELECT @v_dSql += '     , A.TO_FACTORY_ID, A.TO_OPERATION_ID, A.BOD_PATTERN_ID                        ' + char(10)
            SELECT @v_dSql += '     , A.TRANSPORT_MODE, A.TRANSPORT_TIME, A.TRANSPORT_TIME_UOM                    ' + char(10)
            SELECT @v_dSql += '     , FORMAT(A.BOD_START_TIME ,''yyyyMMddHHmmss'') AS BOD_START_TIME              ' + char(10)
            SELECT @v_dSql += '     , A.RELEASE_FLAG, A.DESCRIPTION, '''' AS MESSAGE_ID                           ' + char(10)
            SELECT @v_dSql += '     , (CASE WHEN R.FACTORY_ID IS NULL THEN ''N'' ELSE ''Y'' END) AS VALID_YN      ' + char(10)
            SELECT @v_dSql += ' FROM   SCM_BOD_M A WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += ' LEFT OUTER JOIN (               ' + char(10)
            SELECT @v_dSql += '      SELECT DISTINCT R.FACTORY_ID, R.OPERATION_ID ' + char(10)
            SELECT @v_dSql += '      FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK)    ' + char(10)
            SELECT @v_dSql += '      WHERE  R.USER_ID   = '''+ @p_user_id +'''    ' + char(10)
            SELECT @v_dSql += '      AND    R.SAVE_FLAG = ''Y''                   ' + char(10)
            SELECT @v_dSql += ' ) R ' + char(10)
            SELECT @v_dSql += ' ON   A.FROM_FACTORY_ID     = R.FACTORY_ID   ' + char(10)
            SELECT @v_dSql += ' AND  A.FROM_OPERATION_ID   = R.OPERATION_ID ' + char(10)
            SELECT @v_dSql += ' LEFT OUTER JOIN (                           ' + char(10)
            SELECT @v_dSql += '      SELECT DISTINCT R.FACTORY_ID, R.OPERATION_ID ' + char(10)
            SELECT @v_dSql += '      FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK)    ' + char(10)
            SELECT @v_dSql += '      WHERE  R.USER_ID   = '''+ @p_user_id +'''    ' + char(10)
            SELECT @v_dSql += '      AND    R.SAVE_FLAG = ''Y''                   ' + char(10)
            SELECT @v_dSql += ' ) R2 ' + char(10)
            SELECT @v_dSql += ' ON   A.TO_FACTORY_ID       = R2.FACTORY_ID   ' + char(10)
            SELECT @v_dSql += ' AND  A.TO_OPERATION_ID     = R2.OPERATION_ID ' + char(10)
            SELECT @v_dSql += ' , SCM_OPERATION_M B WITH(NOLOCK), SCM_OPERATION_M C WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += ' WHERE  A.COMPANY_ID        = B.COMPANY_ID   ' + char(10)
            SELECT @v_dSql += ' AND    A.DIVISION_ID       = B.DIVISION_ID  ' + char(10)
            SELECT @v_dSql += ' AND    A.SITE_ID           = B.SITE_ID      ' + char(10)
            SELECT @v_dSql += ' AND    A.FROM_OPERATION_ID = B.OPERATION_ID ' + char(10)
            SELECT @v_dSql += ' AND    A.COMPANY_ID        = C.COMPANY_ID   ' + char(10)
            SELECT @v_dSql += ' AND    A.DIVISION_ID       = C.DIVISION_ID  ' + char(10)
            SELECT @v_dSql += ' AND    A.SITE_ID           = C.SITE_ID      ' + char(10)
            SELECT @v_dSql += ' AND    A.TO_OPERATION_ID   = C.OPERATION_ID ' + char(10)
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))    + char(10)
	        SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
	        SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FROM_FACTORY_ID' , 'EQ', @p_from_factory_id))    + char(10)
            SELECT @v_dSql += ' ORDER BY A.DIVISION_ID, A.FROM_FACTORY_ID, FROM_OPERATION_ID, TO_FACTORY_ID, TO_OPERATION_ID, TRANSPORT_MODE ' + char(10)

			IF @p_sys_type = 'SQL'
				BEGIN
					EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
					SELECT @v_dSql as [QUERY_VALUE]

				END  
			ELSE 
				BEGIN
					SET @runstart = GetDate()
					--쿼리실행
					EXEC sp_executesql @v_dSql

					SET @runend = GetDate()
					EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
				END	
			END
    /************************************************************************************************/
	/* SEL_VALID인경우 :(Excel Upload Validation Select)                                            */
	/************************************************************************************************/
    ELSE IF(@p_sys_flag ='SELECT_VALID')
	    BEGIN --ELSE IF(START)
		    SELECT @v_dSql1 = ''
            SELECT @v_dSql1 += ' SELECT A.*  ' + char(10)
            SELECT @v_dSql1 += '     ,CASE WHEN __MSG = '' Not Found'' THEN '''' ELSE __MSG END AS MESSAGE_ID  ' + char(10)
            SELECT @v_dSql1 += '     ,CASE WHEN __MSG = '' Not Found'' THEN ''Y'' ELSE ''N'' END AS VALID_YN   ' + char(10)
            SELECT @v_dSql1 += ' FROM (         ' + char(10)
            SELECT @v_dSql1 += '   SELECT A.*   ' + char(10)
            SELECT @v_dSql1 += '      ,MSG1     ' + char(10)
            SELECT @v_dSql1 += '      +(CASE WHEN (MSG1 = '''')                    THEN MSG2 ELSE (CASE WHEN MSG2 = '''' THEN '''' ELSE '','' + MSG2 END) END)  ' + char(10)
            SELECT @v_dSql1 += '      +(CASE WHEN (MSG1 = '''' AND MSG2 = '''')    THEN MSG3 ELSE (CASE WHEN MSG3 = '''' THEN '''' ELSE '','' + MSG3 END) END)  ' + char(10)
            SELECT @v_dSql1 += '      +(CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''')    THEN MSG4 ELSE (CASE WHEN MSG4 = '''' THEN '''' ELSE '','' + MSG4 END) END)  ' + char(10)
            SELECT @v_dSql1 += '      +(CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''' AND MSG4 = '''') THEN MSG5 ELSE (CASE WHEN MSG5 = '''' THEN '''' ELSE '','' + MSG5 END) END)  ' + char(10)
            SELECT @v_dSql1 += '      + '' Not Found'' AS __MSG  ' + char(10)
            SELECT @v_dSql1 += '   FROM (  ' + char(10)
            SELECT @v_dSql1 += '          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID  ' + char(10)
            SELECT @v_dSql1 += '            , A.BOD_ID, A.FROM_FACTORY_ID, A.FROM_OPERATION_ID, A.TO_FACTORY_ID, A.TO_OPERATION_ID             ' + char(10)
            SELECT @v_dSql1 += '            , A.FROM_OPERATION_NAME, A.TO_OPERATION_NAME, A.BOD_PATTERN_ID, A.TRANSPORT_MODE, A.TRANSPORT_TIME ' + char(10)
            SELECT @v_dSql1 += '            , A.TRANSPORT_TIME_UOM, FORMAT(A.BOD_START_TIME ,''yyyyMMddHHmmss'') AS BOD_START_TIME             ' + char(10)
            SELECT @v_dSql1 += '            , A.RELEASE_FLAG, A.DESCRIPTION, A.JOB_USER_ID         ' + char(10)
            SELECT @v_dSql1 += '            , A.JOB_TIME, A.JOB_TYPE, A.JOB_SEQ, A.JOB_ORDER       ' + char(10)
            SELECT @v_dSql1 += '            , CASE WHEN B.FACTORY_ID IS NULL THEN ''Building'' ELSE '''' END AS MSG1                  ' + char(10)
            SELECT @v_dSql1 += '            , CASE WHEN C.OPERATION_ID IS NULL THEN ''From Building-Operation'' ELSE '''' END AS MSG2 ' + char(10)
            SELECT @v_dSql1 += '            , CASE WHEN D.OPERATION_ID IS NULL THEN ''To Building-Operation'' ELSE '''' END AS MSG3   ' + char(10)
            SELECT @v_dSql1 += '            , CASE WHEN R.FACTORY_ID IS NULL THEN ''Permissions(From)'' ELSE '''' END AS MSG4         ' + char(10)
            SELECT @v_dSql1 += '            , CASE WHEN R2.FACTORY_ID IS NULL THEN ''Permissions(To)'' ELSE '''' END AS MSG5          ' + char(10)
            SELECT @v_dSql1 += '          FROM   BUF_BOD_M A WITH(NOLOCK)  ' + char(10)
            SELECT @v_dSql1 += '          LEFT OUTER JOIN (                ' + char(10)
            SELECT @v_dSql1 += '                    SELECT DISTINCT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID  ' + char(10)
            SELECT @v_dSql1 += '                    FROM   SCM_FACTORY_M B WITH(NOLOCK)  ' + char(10)
            SELECT @v_dSql1 += '                    WHERE  ACTIVE_FLAG = ''Y''           ' + char(10)
            SELECT @v_dSql1 += '          ) B  ' + char(10)
            SELECT @v_dSql1 += '         ON  A.COMPANY_ID  = B.COMPANY_ID   ' + char(10)
            SELECT @v_dSql1 += '         AND A.DIVISION_ID = B.DIVISION_ID  ' + char(10)
            SELECT @v_dSql1 += '         AND A.SITE_ID     = B.SITE_ID      ' + char(10)
            SELECT @v_dSql1 += '         AND A.PLANT_ID    = B.PLANT_ID     ' + char(10)
            SELECT @v_dSql1 += '         AND A.FACTORY_ID  = B.FACTORY_ID   ' + char(10)
			SELECT @v_dSql2 = ''         
            SELECT @v_dSql2 += '         LEFT OUTER JOIN (  ' + char(10)
            SELECT @v_dSql2 += '                   SELECT DISTINCT A.FACTORY_ID, A.OPERATION_ID  ' + char(10)
            SELECT @v_dSql2 += '                   FROM   SCM_LINE_M A WITH(NOLOCK), SCM_OPERATION_M B WITH(NOLOCK)  ' + char(10)
            SELECT @v_dSql2 += '                   WHERE  A.COMPANY_ID   = B.COMPANY_ID    ' + char(10)
            SELECT @v_dSql2 += '                   AND    A.DIVISION_ID  = B.DIVISION_ID   ' + char(10)
            SELECT @v_dSql2 += '                   AND    A.SITE_ID      = B.SITE_ID       ' + char(10)
            SELECT @v_dSql2 += '                   AND    A.OPERATION_ID = B.OPERATION_ID  ' + char(10)
            SELECT @v_dSql2 += '                   and    A.ACTIVE_FLAG  = ''Y''           ' + char(10)
            SELECT @v_dSql2 += '                   AND    B.ACTIVE_FLAG  = ''Y''           ' + char(10)
            SELECT @v_dSql2 += '         ) C  ' + char(10)
            SELECT @v_dSql2 += '         ON  A.FROM_FACTORY_ID   = C.FACTORY_ID                 ' + char(10)
            SELECT @v_dSql2 += '         AND A.FROM_OPERATION_ID = C.OPERATION_ID               ' + char(10)
            SELECT @v_dSql2 += '         LEFT OUTER JOIN (                                      ' + char(10)
            SELECT @v_dSql2 += '                  SELECT DISTINCT A.FACTORY_ID, A.OPERATION_ID  ' + char(10)
            SELECT @v_dSql2 += '                  FROM   SCM_LINE_M A WITH(NOLOCK), SCM_OPERATION_M B WITH(NOLOCK)  ' + char(10)
            SELECT @v_dSql2 += '                  WHERE  A.COMPANY_ID   = B.COMPANY_ID    ' + char(10)
            SELECT @v_dSql2 += '                  AND    A.DIVISION_ID  = B.DIVISION_ID   ' + char(10)
            SELECT @v_dSql2 += '                  AND    A.SITE_ID      = B.SITE_ID       ' + char(10)
            SELECT @v_dSql2 += '                  AND    A.OPERATION_ID = B.OPERATION_ID  ' + char(10)
            SELECT @v_dSql2 += '                  and    A.ACTIVE_FLAG  = ''Y''  ' + char(10)
            SELECT @v_dSql2 += '                  AND    B.ACTIVE_FLAG  = ''Y''  ' + char(10)
            SELECT @v_dSql2 += '         ) D  ' + char(10)
            SELECT @v_dSql2 += '         ON  A.TO_FACTORY_ID   = D.FACTORY_ID    ' + char(10)
            SELECT @v_dSql2 += '         AND A.TO_OPERATION_ID = D.OPERATION_ID  ' + char(10)
            SELECT @v_dSql2 += '         LEFT OUTER JOIN (                       ' + char(10)
            SELECT @v_dSql2 += '                  SELECT DISTINCT R.FACTORY_ID, R.OPERATION_ID  ' + char(10)
            SELECT @v_dSql2 += '                  FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK)     ' + char(10)
            SELECT @v_dSql2 += '                  WHERE  R.USER_ID   = '''+ @p_user_id +'''     ' + char(10)
            SELECT @v_dSql2 += '                  AND    R.SAVE_FLAG = ''Y''                    ' + char(10)
            SELECT @v_dSql2 += '         ) R  ' + char(10)
            SELECT @v_dSql2 += '         ON   A.FROM_FACTORY_ID     = R.FACTORY_ID    ' + char(10)
            SELECT @v_dSql2 += '         AND  A.FROM_OPERATION_ID   = R.OPERATION_ID  ' + char(10)
            SELECT @v_dSql2 += '         LEFT OUTER JOIN (                            ' + char(10)
            SELECT @v_dSql2 += '                  SELECT DISTINCT R.FACTORY_ID, R.OPERATION_ID  ' + char(10)
            SELECT @v_dSql2 += '                  FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK)     ' + char(10)
            SELECT @v_dSql2 += '                  WHERE  R.USER_ID   = '''+ @p_user_id +'''     ' + char(10)
            SELECT @v_dSql2 += '                  AND    R.SAVE_FLAG = ''Y''                    ' + char(10)
            SELECT @v_dSql2 += '         ) R2  ' + char(10)
            SELECT @v_dSql2 += '         ON   A.TO_FACTORY_ID       = R2.FACTORY_ID    ' + char(10)
            SELECT @v_dSql2 += '         AND  A.TO_OPERATION_ID     = R2.OPERATION_ID  ' + char(10)
            SELECT @v_dSql2 += '         WHERE A.JOB_USER_ID = '''+ @p_user_id +'''    ' + char(10)
            SELECT @v_dSql2 += '     ) A  ' + char(10)
            SELECT @v_dSql2 += ' ) A      ' + char(10)
            SELECT @v_dSql2 += ' ORDER BY A.JOB_ORDER  ' + char(10)

			SELECT @v_dSql =  @v_dSql1 +  @v_dSql2

			IF @p_sys_type = 'SQL'
				BEGIN
					EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
					SELECT @v_dSql as [QUERY_VALUE]

				END  
			ELSE 
				BEGIN
					SET @runstart = GetDate()
					--쿼리실행
					EXEC sp_executesql @v_dSql

					SET @runend = GetDate()
					EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
				END	
			END
    /************************************************************************************************/
	/*  EXECUTE 경우 :(EXECUTE  )                             */
	/************************************************************************************************/
    ELSE IF(@p_sys_flag ='EXECUTE ')
	    BEGIN --ELSE IF(START)
		 --   SELECT @v_dSql = ''
			--SELECT @v_dSql = ' PR_SCM_AF_MASTER_VALIDATION'
			EXEC  @rtnCount = [dbo].[PR_SCM_AF_MASTER_VALIDATION]
			
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

						SELECT @v_sys_type      = [dbo].[SCM_ARR_SPL_VAL](@p_sys_type ,          @v_delimiter, @mst_loop_cnt)
						, @v_sys_flag           = [dbo].[SCM_ARR_SPL_VAL](@p_sys_flag ,          @v_delimiter, @mst_loop_cnt)
						, @v_sys_gubun          = [dbo].[SCM_ARR_SPL_VAL](@p_sys_gubun ,         @v_delimiter, @mst_loop_cnt)
						, @v_user_id            = [dbo].[SCM_ARR_SPL_VAL](@p_user_id ,           @v_delimiter, @mst_loop_cnt)
                        , @v_company_id         = [dbo].[SCM_ARR_SPL_VAL](@p_company_id ,        @v_delimiter, @mst_loop_cnt)
                        , @v_division_id        = [dbo].[SCM_ARR_SPL_VAL](@p_division_id ,       @v_delimiter, @mst_loop_cnt)
                        , @v_site_id            = [dbo].[SCM_ARR_SPL_VAL](@p_site_id ,           @v_delimiter, @mst_loop_cnt)
                        , @v_plant_id           = [dbo].[SCM_ARR_SPL_VAL](@p_plant_id ,          @v_delimiter, @mst_loop_cnt)
                        , @v_factory_id         = [dbo].[SCM_ARR_SPL_VAL](@p_factory_id ,        @v_delimiter, @mst_loop_cnt)
                        , @v_bod_id             = [dbo].[SCM_ARR_SPL_VAL](@p_bod_id ,            @v_delimiter, @mst_loop_cnt)
                        , @v_from_factory_id    = [dbo].[SCM_ARR_SPL_VAL](@p_from_factory_id ,   @v_delimiter, @mst_loop_cnt)
                        , @v_from_operation_id  = [dbo].[SCM_ARR_SPL_VAL](@p_from_operation_id , @v_delimiter, @mst_loop_cnt)
                        , @v_to_factory_id      = [dbo].[SCM_ARR_SPL_VAL](@p_to_factory_id ,     @v_delimiter, @mst_loop_cnt)
                        , @v_to_operation_id    = [dbo].[SCM_ARR_SPL_VAL](@p_to_operation_id ,   @v_delimiter, @mst_loop_cnt)
                        , @v_bod_pattern_id     = [dbo].[SCM_ARR_SPL_VAL](@p_bod_pattern_id ,    @v_delimiter, @mst_loop_cnt)
                        , @v_transport_mode     = [dbo].[SCM_ARR_SPL_VAL](@p_transport_mode ,    @v_delimiter, @mst_loop_cnt)
                        , @v_transport_time     = [dbo].[SCM_ARR_SPL_VAL](@p_transport_time ,    @v_delimiter, @mst_loop_cnt)
                        , @v_transport_time_uom = [dbo].[SCM_ARR_SPL_VAL](@p_transport_time_uom ,@v_delimiter, @mst_loop_cnt)
                        , @v_bod_start_time     = [dbo].[SCM_ARR_SPL_VAL](@p_bod_start_time ,    @v_delimiter, @mst_loop_cnt)
                        , @v_release_flag       = [dbo].[SCM_ARR_SPL_VAL](@p_release_flag ,      @v_delimiter, @mst_loop_cnt)
                        , @v_description        = [dbo].[SCM_ARR_SPL_VAL](@p_description ,       @v_delimiter, @mst_loop_cnt)
					   /******************************************************************************/
					   /* CREATE_PLAN 경우 : INSERT                                                  */
					   /******************************************************************************/
					   IF(@v_sys_flag ='I')  
							BEGIN
                                SELECT @v_dSql1 = ''
                                SELECT @v_dSql1 += ' INSERT INTO SCM_BOD_M ( ' + char(10)
                                SELECT @v_dSql1 += '    COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID ' + char(10)
                                SELECT @v_dSql1 += '    , FACTORY_ID, BOD_ID, FROM_FACTORY_ID      ' + char(10)
								SELECT @v_dSql1 += '    , TO_FACTORY_ID, FROM_OPERATION_ID, TO_OPERATION_ID ' + char(10)
                                SELECT @v_dSql1 += '    , BOD_PATTERN_ID, TRANSPORT_MODE, TRANSPORT_TIME    ' + char(10)
                                SELECT @v_dSql1 += '    , TRANSPORT_TIME_UOM,BOD_START_TIME,  DESCRIPTION   ' + char(10)
                                SELECT @v_dSql1 += '    , RELEASE_FLAG, INSERT_ID, INSERT_TIME ' + char(10)
								SELECT @v_dSql1 += '    , UPDATE_ID, UPDATE_TIME               ' + char(10)
                                SELECT @v_dSql1 += ' )        ' + char(10)
                                SELECT @v_dSql1 += ' VALUES ( ' + char(10)
                                SELECT @v_dSql1 += '    '''+ @v_company_id +''' , '''+ @v_division_id +''', '''+ @v_site_id +''' ' + char(10)
								SELECT @v_dSql1 += '    , '''+ @v_plant_id +''', '''+ @v_factory_id +''' ' + char(10)
                                SELECT @v_dSql1 += '    , '''+ @v_from_factory_id +''' + ''#'' + '''+ @v_from_operation_id +''' + ''_'' + '''+ @v_to_factory_id +''' + ''#'' + '''+ @v_to_operation_id +'''  ' + char(10)
                                SELECT @v_dSql1 += '    , '''+ @v_from_factory_id +''', '''+ @v_to_factory_id +''', '''+ @v_from_operation_id +''' ' + char(10)
                                SELECT @v_dSql1 += '    , '''+ @v_to_operation_id +''', ''-'', '''+ @v_transport_mode +''' ' + char(10)
                                SELECT @v_dSql1 += '    , '''+ @v_transport_time +''', '''+ @v_transport_time_uom +''', GETDATE() - 365 ' + char(10)
                                SELECT @v_dSql1 += '    , '''+ @v_description +''', ''Y'', '''+ @v_user_id +'''  ' + char(10)
                                SELECT @v_dSql1 += '    , GETDATE(), '''+ @v_user_id +''' , GETDATE() ' + char(10)
                                SELECT @v_dSql1 += ' ) ' + char(10)
                                SELECT @v_dSql1 += '  ' + char(10)
								SELECT @v_dSql2 =''
                                SELECT @v_dSql2 += ' INSERT INTO HIS_BOD_M ( ' + char(10)
                                SELECT @v_dSql2 += '    COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID            ' + char(10)
                                SELECT @v_dSql2 += '    , FACTORY_ID, BOD_ID, FROM_FACTORY_ID, TO_FACTORY_ID  ' + char(10)
                                SELECT @v_dSql2 += '    , FROM_OPERATION_ID, TO_OPERATION_ID, BOD_PATTERN_ID, TRANSPORT_MODE ' + char(10)
                                SELECT @v_dSql2 += '    , TRANSPORT_TIME, TRANSPORT_TIME_UOM, BOD_START_TIME, RELEASE_FLAG   ' + char(10)
                                SELECT @v_dSql2 += '    , DESCRIPTION, INSERT_ID, INSERT_TIME, UPDATE_ID ' + char(10)
                                SELECT @v_dSql2 += '    , UPDATE_TIME, JOB_USER_ID, JOB_TIME, JOB_TYPE   ' + char(10)
                                SELECT @v_dSql2 += ' ) ' + char(10)
                                SELECT @v_dSql2 += ' SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID           ' + char(10)
                                SELECT @v_dSql2 += '       , FACTORY_ID, BOD_ID, FROM_FACTORY_ID, TO_FACTORY_ID  ' + char(10)
                                SELECT @v_dSql2 += '       , FROM_OPERATION_ID, TO_OPERATION_ID, BOD_PATTERN_ID, TRANSPORT_MODE ' + char(10)
                                SELECT @v_dSql2 += '       , TRANSPORT_TIME, TRANSPORT_TIME_UOM, BOD_START_TIME, RELEASE_FLAG   ' + char(10)
                                SELECT @v_dSql2 += '       , DESCRIPTION,  INSERT_ID, INSERT_TIME, UPDATE_ID                    ' + char(10)
                                SELECT @v_dSql2 += '       , UPDATE_TIME, '''+ @v_user_id +''' , dbo.SYSDATE1(), ''INSERT''     ' + char(10)
                                SELECT @v_dSql2 += ' FROM   SCM_BOD_M ' + char(10)
                                SELECT @v_dSql2 += ' WHERE  COMPANY_ID   = '''+ @v_company_id +'''  ' + char(10)
                                SELECT @v_dSql2 += ' AND    DIVISION_ID  = '''+ @v_division_id +''' ' + char(10)
                                SELECT @v_dSql2 += ' AND    SITE_ID      = '''+ @v_site_id +'''     ' + char(10)
                                SELECT @v_dSql2 += ' AND    PLANT_ID     = '''+ @v_plant_id +'''    ' + char(10)
                                SELECT @v_dSql2 += ' AND    FACTORY_ID   = '''+ @v_factory_id +'''  ' + char(10)
                                SELECT @v_dSql2 += ' AND    BOD_ID       = '''+ @v_from_factory_id +''' + ''#'' + '''+ @v_from_operation_id +''' + ''_'' + '''+ @v_to_factory_id +''' + ''#'' + '''+ @v_to_operation_id +'''  ' + char(10)
        
								SELECT @v_dSql = @v_dSql1 + @v_dSql2

						   END --'I'
					   /****************************************************************************/
					   /* UPDATE  경우  :    M                                                     */
					   /****************************************************************************/
					   ELSE IF(@v_sys_flag ='M')
							BEGIN
							    SELECT @v_dSql = ''
                                SELECT @v_dSql += ' UPDATE SCM_BOD_M  ' + char(10)
                                SELECT @v_dSql += ' SET TRANSPORT_TIME   = '''+ @v_transport_time +'''      ' + char(10)
                                SELECT @v_dSql += ' , TRANSPORT_TIME_UOM = '''+ @v_transport_time_uom +'''  ' + char(10)
                                SELECT @v_dSql += ' , UPDATE_ID          = '''+ @v_user_id +'''             ' + char(10)
                                SELECT @v_dSql += ' , UPDATE_TIME        = GETDATE()               ' + char(10)
                                SELECT @v_dSql += ' WHERE  COMPANY_ID  = '''+ @v_company_id +'''   ' + char(10)
                                SELECT @v_dSql += ' AND    DIVISION_ID = '''+ @v_division_id +'''  ' + char(10)
                                SELECT @v_dSql += ' AND    SITE_ID     = '''+ @v_site_id +'''      ' + char(10)
                                SELECT @v_dSql += ' AND    PLANT_ID    = '''+ @v_plant_id +'''     ' + char(10)
                                SELECT @v_dSql += ' AND    FACTORY_ID  = '''+ @v_factory_id +'''   ' + char(10)
                                SELECT @v_dSql += ' AND    BOD_ID      = '''+ @v_bod_id +'''       ' + char(10)
                                SELECT @v_dSql += '   ' + char(10)
                                SELECT @v_dSql += ' INSERT INTO HIS_BOD_M  ' + char(10)
                                SELECT @v_dSql += ' (  COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, BOD_ID       ' + char(10)
                                SELECT @v_dSql += '  , FROM_FACTORY_ID, TO_FACTORY_ID, FROM_OPERATION_ID, TO_OPERATION_ID   ' + char(10)
                                SELECT @v_dSql += '  , BOD_PATTERN_ID, TRANSPORT_MODE, TRANSPORT_TIME, TRANSPORT_TIME_UOM   ' + char(10)
                                SELECT @v_dSql += '  , BOD_START_TIME, RELEASE_FLAG, DESCRIPTION        ' + char(10)
                                SELECT @v_dSql += '  , INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME   ' + char(10)
                                SELECT @v_dSql += '  , JOB_USER_ID, JOB_TIME, JOB_TYPE)                 ' + char(10)
                                SELECT @v_dSql += ' SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, BOD_ID   ' + char(10) 
                                SELECT @v_dSql += '  , FROM_FACTORY_ID, TO_FACTORY_ID, FROM_OPERATION_ID, TO_OPERATION_ID   ' + char(10)
                                SELECT @v_dSql += '  , BOD_PATTERN_ID, TRANSPORT_MODE, TRANSPORT_TIME, TRANSPORT_TIME_UOM   ' + char(10)
                                SELECT @v_dSql += '  , BOD_START_TIME, RELEASE_FLAG, DESCRIPTION        ' + char(10)
                                SELECT @v_dSql += '  , INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME   ' + char(10)
                                SELECT @v_dSql += '  , '''+ @v_user_id +''', GETDATE(), ''UPDATE''      ' + char(10)
                                SELECT @v_dSql += ' FROM SCM_BOD_M(NOLOCK)                         ' + char(10)
                                SELECT @v_dSql += ' WHERE  COMPANY_ID  = '''+ @v_company_id +'''   ' + char(10)
                                SELECT @v_dSql += ' AND    DIVISION_ID = '''+ @v_division_id +'''  ' + char(10)
                                SELECT @v_dSql += ' AND    SITE_ID     = '''+ @v_site_id +'''      ' + char(10)
                                SELECT @v_dSql += ' AND    PLANT_ID    = '''+ @v_plant_id +'''     ' + char(10)
                                SELECT @v_dSql += ' AND    FACTORY_ID  = '''+ @v_factory_id +'''   ' + char(10)
                                SELECT @v_dSql += ' AND    BOD_ID      = '''+ @v_bod_id +'''       ' + char(10)

                            END --M
					   /****************************************************************************/
					   /* DELETE  경우  :     D                                                    */
					   /****************************************************************************/
					   ELSE IF(@v_sys_flag ='D')
						   BEGIN
								SELECT @v_dSql1 = ''
                                SELECT @v_dSql1 += ' INSERT INTO HIS_BOD_EXCEPT_M                                       ' + char(10)
                                SELECT @v_dSql1 += ' (  COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID          ' + char(10)
                                SELECT @v_dSql1 += '  , BOD_ID, BOD_PATTERN_ID, TRANSPORT_TIME, TRANSPORT_TIME_UOM      ' + char(10)
                                SELECT @v_dSql1 += '  , BOD_START_TIME, ACTIVE_FLAG, START_TIME, END_TIME, DESCRIPTION  ' + char(10)
                                SELECT @v_dSql1 += '  , INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME                  ' + char(10)
                                SELECT @v_dSql1 += '  , JOB_USER_ID, JOB_TIME, JOB_TYPE)                                ' + char(10)
                                SELECT @v_dSql1 += ' SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID      ' + char(10) 
                                SELECT @v_dSql1 += '  , BOD_ID, BOD_PATTERN_ID, TRANSPORT_TIME, TRANSPORT_TIME_UOM      ' + char(10)
                                SELECT @v_dSql1 += '  , BOD_START_TIME, ACTIVE_FLAG, START_TIME, END_TIME, DESCRIPTION  ' + char(10)
                                SELECT @v_dSql1 += '  , INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME                  ' + char(10)
                                SELECT @v_dSql1 += '  , '''+ @v_user_id +''', GETDATE(), ''DELETE'' ' + char(10)
                                SELECT @v_dSql1 += ' FROM SCM_BOD_EXCEPT_M(NOLOCK)                  ' + char(10)
                                SELECT @v_dSql1 += ' WHERE  COMPANY_ID  = '''+ @v_company_id +'''   ' + char(10)
                                SELECT @v_dSql1 += ' AND    DIVISION_ID = '''+ @v_division_id +'''  ' + char(10)
                                SELECT @v_dSql1 += ' AND    SITE_ID     = '''+ @v_site_id +'''      ' + char(10)
                                SELECT @v_dSql1 += ' AND    PLANT_ID    = '''+ @v_plant_id +'''     ' + char(10)
                                SELECT @v_dSql1 += ' AND    FACTORY_ID  = '''+ @v_factory_id +'''   ' + char(10)
                                SELECT @v_dSql1 += ' AND    BOD_ID      = '''+ @v_bod_id +'''       ' + char(10)
                                SELECT @v_dSql1 += '                                ' + char(10)
                                SELECT @v_dSql1 += ' DELETE FROM  SCM_BOD_EXCEPT_M  ' + char(10)
                                SELECT @v_dSql1 += ' WHERE  COMPANY_ID  = '''+ @v_company_id +'''   ' + char(10)
                                SELECT @v_dSql1 += ' AND    DIVISION_ID = '''+ @v_division_id +'''  ' + char(10)
                                SELECT @v_dSql1 += ' AND    SITE_ID     = '''+ @v_site_id +'''      ' + char(10)
                                SELECT @v_dSql1 += ' AND    PLANT_ID    = '''+ @v_plant_id +'''     ' + char(10)
                                SELECT @v_dSql1 += ' AND    FACTORY_ID  = '''+ @v_factory_id +'''   ' + char(10)
                                SELECT @v_dSql1 += ' AND    BOD_ID      = '''+ @v_bod_id +'''       ' + char(10)
                                SELECT @v_dSql2 = ''
                                SELECT @v_dSql2 += ' INSERT INTO HIS_BOD_M           ' + char(10)
                                SELECT @v_dSql2 += ' (   COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, BOD_ID       ' + char(10)
                                SELECT @v_dSql2 += '   , FROM_FACTORY_ID, TO_FACTORY_ID, FROM_OPERATION_ID, TO_OPERATION_ID   ' + char(10)
                                SELECT @v_dSql2 += '   , BOD_PATTERN_ID, TRANSPORT_MODE, TRANSPORT_TIME, TRANSPORT_TIME_UOM   ' + char(10)
                                SELECT @v_dSql2 += '   , BOD_START_TIME, RELEASE_FLAG, DESCRIPTION        ' + char(10)
                                SELECT @v_dSql2 += '   , INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME   ' + char(10)
                                SELECT @v_dSql2 += '   , JOB_USER_ID, JOB_TIME, JOB_TYPE)                 ' + char(10)
                                SELECT @v_dSql2 += ' SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, BOD_ID    ' + char(10)
                                SELECT @v_dSql2 += '   , FROM_FACTORY_ID, TO_FACTORY_ID, FROM_OPERATION_ID, TO_OPERATION_ID   ' + char(10)
                                SELECT @v_dSql2 += '   , BOD_PATTERN_ID, TRANSPORT_MODE, TRANSPORT_TIME, TRANSPORT_TIME_UOM   ' + char(10)
                                SELECT @v_dSql2 += '   , BOD_START_TIME, RELEASE_FLAG, DESCRIPTION        ' + char(10)
                                SELECT @v_dSql2 += '   , INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME   ' + char(10)
                                SELECT @v_dSql2 += '   , '''+ @v_user_id +''', GETDATE(), ''DELETE''      ' + char(10)
                                SELECT @v_dSql2 += ' FROM SCM_BOD_M(NOLOCK)                         ' + char(10)
                                SELECT @v_dSql2 += ' WHERE  COMPANY_ID  = '''+ @v_company_id +'''   ' + char(10)
                                SELECT @v_dSql2 += ' AND    DIVISION_ID = '''+ @v_division_id +'''  ' + char(10)
                                SELECT @v_dSql2 += ' AND    SITE_ID     = '''+ @v_site_id +'''      ' + char(10)
                                SELECT @v_dSql2 += ' AND    PLANT_ID    = '''+ @v_plant_id +'''     ' + char(10)
                                SELECT @v_dSql2 += ' AND    FACTORY_ID  = '''+ @v_factory_id +'''   ' + char(10)
                                SELECT @v_dSql2 += ' AND    BOD_ID      = '''+ @v_bod_id +'''       ' + char(10)
                                SELECT @v_dSql2 += ' ' + char(10)
                                SELECT @v_dSql2 += ' DELETE FROM  SCM_BOD_M  ' + char(10)
                                SELECT @v_dSql2 += ' WHERE  COMPANY_ID  = '''+ @v_company_id +'''   ' + char(10)
                                SELECT @v_dSql2 += ' AND    DIVISION_ID = '''+ @v_division_id +'''  ' + char(10)
                                SELECT @v_dSql2 += ' AND    SITE_ID     = '''+ @v_site_id +'''      ' + char(10)
                                SELECT @v_dSql2 += ' AND    PLANT_ID    = '''+ @v_plant_id +'''     ' + char(10)
                                SELECT @v_dSql2 += ' AND    FACTORY_ID  = '''+ @v_factory_id +'''   ' + char(10)
                                SELECT @v_dSql2 += ' AND    BOD_ID      = '''+ @v_bod_id +'''       ' + char(10)
           
		                        SELECT @v_dSql = @v_dSql1 + @v_dSql2

						   END --'D'
					   --/***************************************************************************/
					   --/* DELETE_BUFFER: Excel Import경우 (Excel Import Buffer Delete)           */
					   --/***************************************************************************/
					   ELSE IF(@v_sys_flag ='DELETE_BUFFER')
					       BEGIN
						       SELECT @v_dSql = ''
							   SELECT @v_dSql += '	 DELETE FROM BUF_BOD_M                     ' + char(10)
                               SELECT @v_dSql += '	 WHERE JOB_USER_ID = '''+ @v_user_id +'''  ' + char(10)

						   END						   
					   --/***************************************************************/
					   --/* Excel Import경우 P: (Excel Import Buffer 저장)              */
					   --/***************************************************************/
					   ELSE IF(@v_sys_flag ='INSERT_BUFFER')
					       BEGIN
						       SELECT @v_seq_no += 1

							   SELECT @v_dSql  =''
                               SELECT @v_dSql  = ' INSERT INTO BUF_BOD_M (  ' + char(10)
                               SELECT @v_dSql += '     COMPANY_ID,         DIVISION_ID,         SITE_ID           ' + char(10)
                               SELECT @v_dSql += '   , PLANT_ID,           FACTORY_ID,          BOD_ID            ' + char(10)
                               SELECT @v_dSql += '   , FROM_FACTORY_ID,    TO_FACTORY_ID,       FROM_OPERATION_ID ' + char(10)
                               SELECT @v_dSql += '   , TO_OPERATION_ID,    FROM_OPERATION_NAME, TO_OPERATION_NAME ' + char(10)
                               SELECT @v_dSql += '   , BOD_PATTERN_ID,     TRANSPORT_MODE,      TRANSPORT_TIME    ' + char(10)
                               SELECT @v_dSql += '   , TRANSPORT_TIME_UOM, BOD_START_TIME,      RELEASE_FLAG      ' + char(10)
                               SELECT @v_dSql += '   , DESCRIPTION,        JOB_USER_ID,         JOB_TIME          ' + char(10)
                               SELECT @v_dSql += '   , JOB_TYPE,           JOB_ORDER  ' + char(10)
                               SELECT @v_dSql += ' )         ' + char(10)
                               SELECT @v_dSql += ' VALUES (  ' + char(10)
                               SELECT @v_dSql += '    '''+ @v_company_id +''',       '''+ @v_division_id +''',   '''+ @v_site_id +''' ' + char(10)
                               SELECT @v_dSql += '   , '''+ @v_plant_id +''',        '''+ @v_factory_id +''',    '''+ @v_bod_id +'''  ' + char(10)
                               SELECT @v_dSql += '   , '''+ @v_from_factory_id +''', '''+ @v_to_factory_id +''', '''+ @v_from_operation_id +'''  ' + char(10)
                               SELECT @v_dSql += '   , '''+ @v_to_operation_id +''', '''', ''''  ' + char(10)
                               SELECT @v_dSql += '   , '''+ @v_bod_pattern_id +''',  '''+ @v_transport_mode +''', '''+ @v_transport_time +''' ' + char(10)
                               SELECT @v_dSql += '   , '''+ @v_transport_time_uom +''' ' + char(10)
                               SELECT @v_dSql += '   , CONVERT(DATETIME, SUBSTRING('''+ @v_bod_start_time +''',1,4)    ' + char(10)
                               SELECT @v_dSql += '              + ''-'' + SUBSTRING('''+ @v_bod_start_time +''',5,2)   ' + char(10)
                               SELECT @v_dSql += '              + ''-'' + SUBSTRING('''+ @v_bod_start_time +''',7,2)   ' + char(10)
                               SELECT @v_dSql += '              + '' '' + SUBSTRING('''+ @v_bod_start_time +''',9,2)   ' + char(10)
                               SELECT @v_dSql += '              + '':'' + SUBSTRING('''+ @v_bod_start_time +''',11,2)  ' + char(10)
                               SELECT @v_dSql += '              + '':'' + SUBSTRING('''+ @v_bod_start_time +''',13,2)), '''+ @v_release_flag +'''  ' + char(10)
                               SELECT @v_dSql += '   , '''+ @v_description +''' ,    '''+ @v_user_id +''',         GETDATE()  ' + char(10)
							   SELECT @v_dSql += '   , ''-'',          '+ CONVERT(VARCHAR, @v_seq_no) +'  ' + char(10)
                               SELECT @v_dSql += ' )	 ' + char(10)						   
						   
						   END

					   --/*******************************************************************************/
					   --/* INSERT_EXCEL: ( Excel Import 저장 )                                         */
					   --/*******************************************************************************/
					   ELSE IF(@v_sys_flag ='INSERT_EXCEL')

						   BEGIN 
						        SELECT @v_dSql = ''

                                SELECT @v_dSql += ' MERGE INTO SCM_BOD_M A ' + char(10)
                                SELECT @v_dSql += ' USING ( SELECT RTRIM(LTRIM('''+ @v_company_id +''')) AS COMPANY_ID ' + char(10)
								SELECT @v_dSql += '         , RTRIM(LTRIM('''+ @v_division_id +''')) AS DIVISION_ID    ' + char(10)
								SELECT @v_dSql += '         , RTRIM(LTRIM('''+ @v_site_id +''')) AS SITE_ID            ' + char(10)
                                SELECT @v_dSql += '         , RTRIM(LTRIM('''+ @v_plant_id +''')) AS PLANT_ID          ' + char(10)
								SELECT @v_dSql += '         , RTRIM(LTRIM('''+ @v_factory_id +''')) AS FACTORY_ID      ' + char(10)
                                SELECT @v_dSql += '         , RTRIM(LTRIM('''+ @v_bod_id +''')) AS BOD_ID) AS B        ' + char(10)
                                SELECT @v_dSql += '   ON (A.COMPANY_ID  = B.COMPANY_ID  ' + char(10)
                                SELECT @v_dSql += '   AND A.DIVISION_ID = B.DIVISION_ID ' + char(10)
                                SELECT @v_dSql += '   AND A.SITE_ID     = B.SITE_ID     ' + char(10)
                                SELECT @v_dSql += '   AND A.PLANT_ID    = B.PLANT_ID    ' + char(10)
                                SELECT @v_dSql += '   AND A.FACTORY_ID  = B.FACTORY_ID  ' + char(10)
                                SELECT @v_dSql += '   AND A.BOD_ID      = B.BOD_ID )    ' + char(10)
                                SELECT @v_dSql += ' WHEN MATCHED THEN   ' + char(10)
                                SELECT @v_dSql += '     UPDATE SET      ' + char(10)
                                SELECT @v_dSql += '       TRANSPORT_TIME      = RTRIM(LTRIM('''+ @v_transport_time +'''))     ' + char(10)
                                SELECT @v_dSql += '     , TRANSPORT_TIME_UOM  = RTRIM(LTRIM('''+ @v_transport_time_uom +''')) ' + char(10)
                                SELECT @v_dSql += '     , UPDATE_ID           = '''+ @v_user_id +''' ' + char(10)
                                SELECT @v_dSql += '     , UPDATE_TIME         = GETDATE()            ' + char(10)
                                SELECT @v_dSql += ' WHEN NOT MATCHED THEN                            ' + char(10)
                                SELECT @v_dSql += '     INSERT ( COMPANY_ID,      DIVISION_ID,   SITE_ID,      PLANT_ID,   FACTORY_ID,   BOD_ID                 ' + char(10)
                                SELECT @v_dSql += '        , FROM_FACTORY_ID, TO_FACTORY_ID, FROM_OPERATION_ID, TO_OPERATION_ID, BOD_PATTERN_ID, TRANSPORT_MODE ' + char(10)
                                SELECT @v_dSql += '        , TRANSPORT_TIME, TRANSPORT_TIME_UOM,   BOD_START_TIME,  RELEASE_FLAG,  DESCRIPTION,  INSERT_ID      ' + char(10)
                                SELECT @v_dSql += '        , INSERT_TIME, UPDATE_ID, UPDATE_TIME ' + char(10)
                                SELECT @v_dSql += '     )        ' + char(10)
                                SELECT @v_dSql += '     VALUES ( RTRIM(LTRIM('''+ @v_company_id +''')), RTRIM(LTRIM('''+ @v_division_id +''')), RTRIM(LTRIM('''+ @v_site_id +''')) ' + char(10)
								SELECT @v_dSql += '        , RTRIM(LTRIM('''+ @v_plant_id +''')), RTRIM(LTRIM('''+ @v_factory_id +''')) ' + char(10)
                                SELECT @v_dSql += '        , RTRIM(LTRIM('''+ @v_from_factory_id +''')) + ''#'' + RTRIM(LTRIM('''+ @v_from_operation_id +''')) + ''_'' + RTRIM(LTRIM('''+ @v_to_factory_id +''')) + ''#'' + RTRIM(LTRIM('''+ @v_to_operation_id +'''))  ' + char(10)
                                SELECT @v_dSql += '        , RTRIM(LTRIM('''+ @v_from_factory_id +''')), RTRIM(LTRIM('''+ @v_to_factory_id +''')), RTRIM(LTRIM('''+ @v_from_operation_id +''')), RTRIM(LTRIM('''+ @v_to_operation_id +'''))  ' + char(10)
                                SELECT @v_dSql += '        , RTRIM(LTRIM('''+ @v_bod_pattern_id +''')), RTRIM(LTRIM('''+ @v_transport_mode +''')), RTRIM(LTRIM('''+ @v_transport_time +''')), RTRIM(LTRIM('''+ @v_transport_time_uom +''')) ' + char(10)
                                SELECT @v_dSql += '        , CONVERT(DATETIME, SUBSTRING(RTRIM(LTRIM('''+ @v_bod_start_time +''')),1,4)  ' + char(10)
                                SELECT @v_dSql += '          + ''-'' + SUBSTRING(RTRIM(LTRIM('''+ @v_bod_start_time +''')),5,2)   ' + char(10)
                                SELECT @v_dSql += '          + ''-'' + SUBSTRING(RTRIM(LTRIM('''+ @v_bod_start_time +''')),7,2)   ' + char(10)
                                SELECT @v_dSql += '          + '' '' + SUBSTRING(RTRIM(LTRIM('''+ @v_bod_start_time +''')),9,2)   ' + char(10)
                                SELECT @v_dSql += '          + '':'' + SUBSTRING(RTRIM(LTRIM('''+ @v_bod_start_time +''')),11,2)  ' + char(10)
                                SELECT @v_dSql += '          + '':'' + SUBSTRING(RTRIM(LTRIM('''+ @v_bod_start_time +''')),13,2)) ' + char(10)
                                SELECT @v_dSql += '        , RTRIM(LTRIM('''+ @v_release_flag +''')), RTRIM(LTRIM('''+ @v_description +''')), '''+ @v_user_id +''', GETDATE(), '''+ @v_user_id +''', GETDATE() ' + char(10)
                                SELECT @v_dSql += '   ) ; ' + char(10)
                                SELECT @v_dSql += ' INSERT INTO HIS_BOD_M ( ' + char(10)
                                SELECT @v_dSql += '      COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID                      ' + char(10)
                                SELECT @v_dSql += '    , BOD_ID, FROM_FACTORY_ID, TO_FACTORY_ID, FROM_OPERATION_ID, TO_OPERATION_ID  ' + char(10)
                                SELECT @v_dSql += '    , BOD_PATTERN_ID, TRANSPORT_MODE, TRANSPORT_TIME, TRANSPORT_TIME_UOM, BOD_START_TIME  ' + char(10)
                                SELECT @v_dSql += '    , RELEASE_FLAG, DESCRIPTION, INSERT_ID, INSERT_TIME, UPDATE_ID  ' + char(10)
                                SELECT @v_dSql += '    , UPDATE_TIME, JOB_USER_ID, JOB_TIME, JOB_TYPE                  ' + char(10)
                                SELECT @v_dSql += ' ) ' + char(10)
                                SELECT @v_dSql += ' SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID      ' + char(10)
                                SELECT @v_dSql += '    , BOD_ID, FROM_FACTORY_ID, TO_FACTORY_ID, FROM_OPERATION_ID, TO_OPERATION_ID          ' + char(10)
                                SELECT @v_dSql += '    , BOD_PATTERN_ID, TRANSPORT_MODE, TRANSPORT_TIME, TRANSPORT_TIME_UOM, BOD_START_TIME  ' + char(10)
                                SELECT @v_dSql += '    , RELEASE_FLAG, DESCRIPTION, INSERT_ID, INSERT_TIME, UPDATE_ID  ' + char(10)
                                SELECT @v_dSql += '    , UPDATE_TIME, '''+ @v_user_id +''', GETDATE(), ''EXCEL''       ' + char(10)
                                SELECT @v_dSql += ' FROM   SCM_BOD_M A(NOLOCK) ' + char(10)
                                SELECT @v_dSql += ' WHERE  COMPANY_ID   = RTRIM(LTRIM('''+ @v_company_id +'''))  ' + char(10)
                                SELECT @v_dSql += ' AND    DIVISION_ID  = RTRIM(LTRIM('''+ @v_division_id +''')) ' + char(10)
                                SELECT @v_dSql += ' AND    SITE_ID      = RTRIM(LTRIM('''+ @v_site_id +'''))     ' + char(10)
                                SELECT @v_dSql += ' AND    PLANT_ID     = RTRIM(LTRIM('''+ @v_plant_id +'''))    ' + char(10)
                                SELECT @v_dSql += ' AND    FACTORY_ID   = RTRIM(LTRIM('''+ @v_factory_id +'''))  ' + char(10)
                                SELECT @v_dSql += ' AND    BOD_ID       = RTRIM(LTRIM('''+ @v_from_factory_id +''')) + ''#'' + RTRIM(LTRIM('''+ @v_from_operation_id +''')) + ''_'' + RTRIM(LTRIM('''+ @v_to_factory_id +''')) + ''#'' + RTRIM(LTRIM('''+ @v_to_operation_id +''')) ' + char(10)

      
						   END --'G'

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
							EXEC PR_UI_SQL_LOG  @v_proc_name,  @v_user_id,'','', @v_dSql,'SELECT',@runstart, @runend
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

