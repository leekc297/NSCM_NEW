

/*
 * Program ID   : PR_UI_FP02550_EXCEL
 * Description  : Operation BOD
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/06/23   CYS				Initial Release UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FP02550_EXCEL]
  @p_sys_type                   NVARCHAR(MAX),
  @p_sys_flag                   NVARCHAR(MAX),
  @p_sys_gubun                  NVARCHAR(MAX),
  @p_user_id                    NVARCHAR(MAX),
  @p_company_id                 NVARCHAR(MAX),
  @p_division_id                NVARCHAR(MAX),
  @p_site_id                    NVARCHAR(MAX),
  @p_plant_id                   NVARCHAR(MAX),
  @p_operation_id               NVARCHAR(MAX),
  @p_line_setup_group_id        NVARCHAR(MAX),
  @p_org_line_setup_group_id    NVARCHAR(MAX),
  @p_description                NVARCHAR(MAX)

AS 
BEGIN  --MAIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
    SET NOCOUNT ON                                                                                                                                                                                                                                                   
	SET XACT_ABORT ON 

	DECLARE @v_sys_type                   NVARCHAR(MAX)  -- 값>> SELEC: SQL저장안함, SQL:SQL저장함
	DECLARE @v_sys_flag                   NVARCHAR(MAX)  -- 값>> I: Insert, M: Update, D: Delete, G: MERGE
	DECLARE @v_sys_gubun                  NVARCHAR(MAX) 
	DECLARE @v_user_id                    NVARCHAR(MAX)
    DECLARE @v_company_id                 NVARCHAR(MAX)
	DECLARE @v_division_id                NVARCHAR(MAX)
    DECLARE @v_site_id                    NVARCHAR(MAX)
    DECLARE @v_plant_id                   NVARCHAR(MAX)
    DECLARE @v_operation_id               NVARCHAR(MAX)
    DECLARE @v_line_setup_group_id        NVARCHAR(MAX)
    DECLARE @v_org_line_setup_group_id    NVARCHAR(MAX)
	DECLARE @v_description                NVARCHAR(MAX)

	DECLARE @recv_active_flag       NVARCHAR(MAX)				    
	DECLARE @v_proc_name	        NVARCHAR(100) = 'PR_UI_FP02550_EXCEL'
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

	SET @v_sys_type                 = ''
	SET @v_sys_flag                 = ''
	SET @v_sys_gubun                = ''
	SET @v_user_id                  = ''
    SET @v_company_id               = '' 
	SET @v_division_id              = '' 
    SET @v_site_id                  = '' 
    SET @v_plant_id                 = ''
    SET @v_operation_id             = ''
    SET @v_line_setup_group_id      = ''
    SET @v_org_line_setup_group_id  = ''
	SET @v_description              = ''

	SET @recv_active_flag       = NULL	
	SET @recv_active_flag       = @p_sys_flag
	SET @v_delimiter            = '|'             -- 데이터 구분자
	SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_sys_flag, @v_delimiter) -- 프로시저 LOOP 길이를 판단  

	SET	@v_dSql                 = ''
	SET	@v_dSql1                = ''
	SET	@v_dSql2                = ''
	SET	@v_dSql3                = ''

    /************************************************************************************************/
	/* SELECT경우 :(SELECT_IMPORT Select)                                            */
	/************************************************************************************************/
    IF(@p_sys_flag ='SELECT_IMPORT')
	    BEGIN --ELSE IF(START)
		    SELECT @v_dSql = ''
            SELECT @v_dSql += ' SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID      ' + char(10)
            SELECT @v_dSql += '      , A.LINE_SETUP_GROUP_ID, A.LINE_SETUP_GROUP_ID AS ORG_LINE_SETUP_GROUP_ID ' + char(10)
            SELECT @v_dSql += '      ,'''' AS DESCRIPTION, '''' AS MESSAGE_ID  ' + char(10)
            SELECT @v_dSql += '      , (CASE WHEN R.COMPANY_ID IS NULL THEN ''N'' ELSE ''Y'' END) AS VALID_YN  ' + char(10)
            SELECT @v_dSql += ' FROM   SCM_LINE_SETUP_GROUP_M A WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += ' LEFT OUTER JOIN (                            ' + char(10)
            SELECT @v_dSql += '      SELECT DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.OPERATION_ID ' + char(10)
            SELECT @v_dSql += '      FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += '      WHERE  R.USER_ID   = '''+ @p_user_id +''' ' + char(10)
            SELECT @v_dSql += '      AND    R.SAVE_FLAG = ''Y''                ' + char(10)
            SELECT @v_dSql += ' ) R ' + char(10)
            SELECT @v_dSql += ' ON   A.COMPANY_ID   = R.COMPANY_ID   ' + char(10)
            SELECT @v_dSql += ' AND  A.DIVISION_ID  = R.DIVISION_ID  ' + char(10)
            SELECT @v_dSql += ' AND  A.SITE_ID      = R.SITE_ID      ' + char(10)
            SELECT @v_dSql += ' AND  A.PLANT_ID     = R.PLANT_ID     ' + char(10)
            SELECT @v_dSql += ' AND  A.OPERATION_ID = R.OPERATION_ID ' + char(10)
            SELECT @v_dSql += ' WHERE  EXISTS ( ' + char(10)
            SELECT @v_dSql += '       SELECT 1  ' + char(10)
            SELECT @v_dSql += '       FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)    ' + char(10)
            SELECT @v_dSql += '       WHERE  A.COMPANY_ID   = B.COMPANY_ID         ' + char(10)
            SELECT @v_dSql += '       AND    A.DIVISION_ID  = B.DIVISION_ID        ' + char(10)
            SELECT @v_dSql += '       AND    A.SITE_ID      = B.SITE_ID            ' + char(10)
            SELECT @v_dSql += '       AND    A.PLANT_ID     = B.PLANT_ID           ' + char(10)
            SELECT @v_dSql += '       AND    A.OPERATION_ID = B.OPERATION_ID       ' + char(10)
            SELECT @v_dSql += '       AND    B.USER_ID      = '''+ @p_user_id +''' ' + char(10)
            SELECT @v_dSql += ' ) ' + char(10)
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
	        SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))    + char(10)
	        SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))    + char(10)
	        SELECT @v_dSql += ' ORDER BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID, A.LINE_SETUP_GROUP_ID ' + char(10)


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
	/* SELECT_VALID인경우 :(Excel Import Validation Select)                                            */
	/************************************************************************************************/
    ELSE IF(@p_sys_flag ='SELECT_VALID')
	    BEGIN --ELSE IF(START)
             SELECT @v_dSql1 = ''
             SELECT @v_dSql1 += ' SELECT A.* ' + char(10)
             SELECT @v_dSql1 += '    ,CASE WHEN __MSG = '' Not Found'' THEN (CASE WHEN MSG3 = '''' THEN '''' ELSE MSG3 END)     ' + char(10)
             SELECT @v_dSql1 += '       ELSE (CASE WHEN MSG3 = '''' THEN __MSG ELSE __MSG + '' AND '' + MSG3 END)           ' + char(10)
             SELECT @v_dSql1 += '       END AS MESSAGE_ID                                                                   ' + char(10)
             SELECT @v_dSql1 += '   ,CASE WHEN __MSG = '' Not Found'' AND MSG3 = '''' THEN ''Y'' ELSE ''N'' END AS VALID_YN ' + char(10)
             SELECT @v_dSql1 += ' FROM (           ' + char(10)
             SELECT @v_dSql1 += '      SELECT A.*  ' + char(10)
             SELECT @v_dSql1 += '            ,MSG1 ' + char(10)
             SELECT @v_dSql1 += '            +(CASE WHEN (MSG1 = '''')               THEN MSG2 ELSE (CASE WHEN MSG2 = '''' THEN '''' ELSE '','' + MSG2 END) END)   ' + char(10)
             SELECT @v_dSql1 += '            +(CASE WHEN (MSG1 = '''' AND MSG2 = '''') THEN MSG4 ELSE (CASE WHEN MSG4 = '''' THEN '''' ELSE '','' + MSG4 END) END) ' + char(10)
             SELECT @v_dSql1 += '            + '' Not Found''  AS __MSG ' + char(10)
             SELECT @v_dSql1 += '      FROM (            ' + char(10)
             SELECT @v_dSql1 += '            SELECT A.*  ' + char(10)
             SELECT @v_dSql1 += '                ,CASE WHEN B.PLANT_ID IS NULL THEN ''Plant'' ELSE '''' END AS MSG1         ' + char(10)
             SELECT @v_dSql1 += '                ,CASE WHEN C.OPERATION_ID IS NULL THEN ''Operation'' ELSE '''' END AS MSG2 ' + char(10)
             SELECT @v_dSql1 += '                ,CASE WHEN ROW_NUMBER() OVER(PARTITION BY A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.OPERATION_ID,A.LINE_SETUP_GROUP_ID ' + char(10)
             SELECT @v_dSql1 += '                      ORDER BY A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.OPERATION_ID,A.LINE_SETUP_GROUP_ID)>1 THEN ''Data Overlap''   ' + char(10)
             SELECT @v_dSql1 += '                  ELSE '''' END AS MSG3 ' + char(10)
             SELECT @v_dSql1 += '                ,(CASE WHEN R.COMPANY_ID IS NULL THEN ''Permissions'' ELSE '''' END) AS MSG4 ' + char(10)
             SELECT @v_dSql1 += '            FROM   BUF_LINE_SETUP_GROUP_M A(NOLOCK) ' + char(10)
             SELECT @v_dSql1 += '            LEFT OUTER JOIN SCM_PLANT_M B(NOLOCK)   ' + char(10)
             SELECT @v_dSql1 += '            ON  A.COMPANY_ID  = B.COMPANY_ID  ' + char(10)
             SELECT @v_dSql1 += '            AND A.DIVISION_ID = B.DIVISION_ID ' + char(10)
             SELECT @v_dSql1 += '            AND A.SITE_ID     = B.SITE_ID     ' + char(10)
             SELECT @v_dSql1 += '            AND A.PLANT_ID    = B.PLANT_ID    ' + char(10)
             SELECT @v_dSql1 += '            LEFT OUTER JOIN (                 ' + char(10)
             SELECT @v_dSql1 += '                            SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID ' + char(10)
             SELECT @v_dSql1 += '                            FROM   SCM_OPERATION_M A(NOLOCK) ' + char(10)
             SELECT @v_dSql1 += '                            WHERE  A.ACTIVE_FLAG = ''Y''     ' + char(10)
             SELECT @v_dSql1 += '            ) C ' + char(10)
             SELECT @v_dSql2 =''
             SELECT @v_dSql2 += '            ON  A.COMPANY_ID    = C.COMPANY_ID   ' + char(10)
             SELECT @v_dSql2 += '            AND A.DIVISION_ID   = C.DIVISION_ID  ' + char(10)
             SELECT @v_dSql2 += '            AND A.SITE_ID       = C.SITE_ID      ' + char(10)
             SELECT @v_dSql2 += '            AND A.OPERATION_ID  = C.OPERATION_ID ' + char(10)
             SELECT @v_dSql2 += '            LEFT OUTER JOIN (                    ' + char(10)
             SELECT @v_dSql2 += '                           SELECT DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.OPERATION_ID ' + char(10)
             SELECT @v_dSql2 += '                           FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK) ' + char(10)
             SELECT @v_dSql2 += '                           WHERE  R.USER_ID   = '''+ @p_user_id +''' ' + char(10)
             SELECT @v_dSql2 += '                           AND    R.SAVE_FLAG = ''Y''                ' + char(10)
             SELECT @v_dSql2 += '            ) R ' + char(10)
             SELECT @v_dSql2 += '            ON   A.COMPANY_ID   = R.COMPANY_ID         ' + char(10)
             SELECT @v_dSql2 += '            AND  A.DIVISION_ID  = R.DIVISION_ID        ' + char(10)
             SELECT @v_dSql2 += '            AND  A.SITE_ID      = R.SITE_ID            ' + char(10)
             SELECT @v_dSql2 += '            AND  A.PLANT_ID     = R.PLANT_ID           ' + char(10)
             SELECT @v_dSql2 += '            AND  A.OPERATION_ID = R.OPERATION_ID       ' + char(10)
             SELECT @v_dSql2 += '            WHERE A.JOB_USER_ID = '''+ @p_user_id +''' ' + char(10)
             SELECT @v_dSql2 += '      ) A ' + char(10)
             SELECT @v_dSql2 += ' ) A ' + char(10)
             SELECT @v_dSql2 += ' ORDER BY A.JOB_ORDER ' + char(10)

			 SELECT @v_dSql = @v_dSql1 + @v_dSql2

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

	ELSE
		-- 트랜잭션 (TRAN)
		BEGIN TRY				                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
		BEGIN TRAN   

		BEGIN --ELSE ( BEGIN )
		    --max_loop_cnt:전체 Row수 , mst_loop_cnt:1씩 증가시켜서 전체 Row수 까지만 로직을 수행
			WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
			    BEGIN --WHILE 내(START)
					 
						SELECT @mst_loop_cnt = @mst_loop_cnt + 1	-- @mst_loop_cnt 1증가

						SELECT @v_sys_type            = [dbo].[SCM_ARR_SPL_VAL](@p_sys_type ,@v_delimiter, @mst_loop_cnt)
						, @v_sys_flag                 = [dbo].[SCM_ARR_SPL_VAL](@p_sys_flag ,@v_delimiter, @mst_loop_cnt)
						, @v_sys_gubun                = [dbo].[SCM_ARR_SPL_VAL](@p_sys_gubun ,@v_delimiter, @mst_loop_cnt)
						, @v_user_id                  = [dbo].[SCM_ARR_SPL_VAL](@p_user_id ,@v_delimiter, @mst_loop_cnt)
                        , @v_company_id               = [dbo].[SCM_ARR_SPL_VAL](@p_company_id ,@v_delimiter, @mst_loop_cnt)
                        , @v_division_id              = [dbo].[SCM_ARR_SPL_VAL](@p_division_id ,@v_delimiter, @mst_loop_cnt)
                        , @v_site_id                  = [dbo].[SCM_ARR_SPL_VAL](@p_site_id ,@v_delimiter, @mst_loop_cnt)
                        , @v_plant_id                 = [dbo].[SCM_ARR_SPL_VAL](@p_plant_id ,@v_delimiter, @mst_loop_cnt)
                        , @v_operation_id             = [dbo].[SCM_ARR_SPL_VAL](@p_operation_id ,@v_delimiter, @mst_loop_cnt)
                        , @v_line_setup_group_id      = [dbo].[SCM_ARR_SPL_VAL](@p_line_setup_group_id ,@v_delimiter, @mst_loop_cnt)
                        , @v_org_line_setup_group_id  = [dbo].[SCM_ARR_SPL_VAL](@p_org_line_setup_group_id ,@v_delimiter, @mst_loop_cnt)
                        , @v_description              = [dbo].[SCM_ARR_SPL_VAL](@p_description ,@v_delimiter, @mst_loop_cnt)
					   
					   --/***************************************************************************/
					   --/* DELETE_BUFFER: Excel Import경우 (Excel Import Buffer Delete)           */
					   --/***************************************************************************/
					   IF(@v_sys_flag ='DELETE_BUFFER')
					       BEGIN
						       SELECT @v_dSql = ''
							   SELECT @v_dSql += '	 DELETE FROM BUF_LINE_SETUP_GROUP_M        ' + char(10)
                               SELECT @v_dSql += '	 WHERE JOB_USER_ID = '''+ @v_user_id +'''  ' + char(10)

						   END						   
					   --/***************************************************************/
					   --/* Excel Import경우 P: (Excel Import Buffer 저장)              */
					   --/***************************************************************/
					   ELSE IF(@v_sys_flag ='INSERT_BUFFER')
					       BEGIN
						       SELECT @v_seq_no += 1
							   SELECT @v_dSql =''
                               SELECT @v_dSql += ' INSERT INTO BUF_LINE_SETUP_GROUP_M (              ' + char(10)
                               SELECT @v_dSql += '    COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID     ' + char(10)
                               SELECT @v_dSql += '   ,OPERATION_ID, LINE_SETUP_GROUP_ID, DESCRIPTION ' + char(10)
                               SELECT @v_dSql += '   ,JOB_USER_ID, JOB_TIME, JOB_TYPE, JOB_ORDER     ' + char(10)
                               SELECT @v_dSql += ' )        ' + char(10)
                               SELECT @v_dSql += ' VALUES ( ' + char(10)
                               SELECT @v_dSql += '   '''+ @v_company_id +''','''+ @v_division_id +''','''+ @v_site_id +''', '''+ @v_plant_id +'''  ' + char(10)
                               SELECT @v_dSql += '  ,'''+ @v_operation_id +''', '''+ @v_line_setup_group_id +''', '''+ @v_description +'''         ' + char(10)
                               SELECT @v_dSql += '  ,'''+ @v_user_id +''', GETDATE(), ''-'', '+ CONVERT(VARCHAR, @v_seq_no) +'                     ' + char(10)
                               SELECT @v_dSql += ' ) ' + char(10)  
						   
						   END

					   --/*******************************************************************************/
					   --/* INSERT_EXCEL: ( Excel Import 저장 )                                         */
					   --/*******************************************************************************/
					   ELSE IF(@v_sys_flag ='INSERT_EXCEL')

						   BEGIN 
						        SELECT @v_dSql = ''
                                SELECT @v_dSql += ' MERGE INTO SCM_LINE_SETUP_GROUP_M AS A ' + char(10)
                                SELECT @v_dSql += ' USING (SELECT RTRIM(LTRIM('''+ @v_company_id +''')) AS COMPANY_ID, RTRIM(LTRIM('''+ @v_division_id +''')) AS DIVISION_ID, RTRIM(LTRIM('''+ @v_site_id +''')) AS SITE_ID, RTRIM(LTRIM('''+ @v_plant_id +''')) AS PLANT_ID ' + char(10)
                                SELECT @v_dSql += '     , RTRIM(LTRIM('''+ @v_operation_id +''')) AS OPERATION_ID, RTRIM(LTRIM('''+ @v_line_setup_group_id +''')) AS LINE_SETUP_GROUP_ID) AS B ' + char(10)
                                SELECT @v_dSql += '   ON (A.COMPANY_ID    = B.COMPANY_ID   ' + char(10)
                                SELECT @v_dSql += '   AND A.DIVISION_ID   = B.DIVISION_ID  ' + char(10)
                                SELECT @v_dSql += '   AND A.SITE_ID       = B.SITE_ID      ' + char(10)
                                SELECT @v_dSql += '   AND A.PLANT_ID      = B.PLANT_ID     ' + char(10)
                                SELECT @v_dSql += '   AND A.OPERATION_ID  = B.OPERATION_ID ' + char(10)
                                SELECT @v_dSql += '   AND A.LINE_SETUP_GROUP_ID = B.LINE_SETUP_GROUP_ID) ' + char(10)
                                SELECT @v_dSql += ' WHEN MATCHED THEN                                ' + char(10) 
                                SELECT @v_dSql += '   UPDATE SET  UPDATE_ID   = '''+ @v_user_id +''' ' + char(10)
                                SELECT @v_dSql += '              ,UPDATE_TIME = GETDATE()            ' + char(10)
                                SELECT @v_dSql += ' WHEN NOT MATCHED THEN  ' + char(10)
                                SELECT @v_dSql += '   INSERT (             ' + char(10)
                                SELECT @v_dSql += '      COMPANY_ID,   DIVISION_ID, SITE_ID, PLANT_ID   ' + char(10)
                                SELECT @v_dSql += '     ,OPERATION_ID, LINE_SETUP_GROUP_ID, DESCRIPTION ' + char(10)
                                SELECT @v_dSql += '     ,INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME ' + char(10)
                                SELECT @v_dSql += '   ) VALUES ( ' + char(10)
                                SELECT @v_dSql += '      RTRIM(LTRIM('''+ @v_company_id +''')), RTRIM(LTRIM('''+ @v_division_id +''')), RTRIM(LTRIM('''+ @v_site_id +''')), RTRIM(LTRIM('''+ @v_plant_id +''')) ' + char(10)
                                SELECT @v_dSql += '     ,RTRIM(LTRIM('''+ @v_operation_id +''')), RTRIM(LTRIM('''+ @v_line_setup_group_id +''' )), RTRIM(LTRIM('''+ @v_description +''')) ' + char(10)
                                SELECT @v_dSql += '     ,'''+ @v_user_id +''',GETDATE(),'''+ @v_user_id +''',GETDATE() ' + char(10)
                                SELECT @v_dSql += '   ); ' + char(10)
                                SELECT @v_dSql += ' INSERT INTO HIS_LINE_SETUP_GROUP_M (                  ' + char(10)
                                SELECT @v_dSql += '        COMPANY_ID,   DIVISION_ID, SITE_ID, PLANT_ID   ' + char(10)
                                SELECT @v_dSql += '       ,OPERATION_ID, LINE_SETUP_GROUP_ID, DESCRIPTION ' + char(10)
                                SELECT @v_dSql += '       ,INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME ' + char(10)
                                SELECT @v_dSql += '       ,JOB_USER_ID ,JOB_TIME,JOB_TYPE                 ' + char(10)
                                SELECT @v_dSql += ' ) ' + char(10)
                                SELECT @v_dSql += ' SELECT COMPANY_ID,   DIVISION_ID, SITE_ID, PLANT_ID   ' + char(10)
                                SELECT @v_dSql += '       ,OPERATION_ID, LINE_SETUP_GROUP_ID, DESCRIPTION ' + char(10)
                                SELECT @v_dSql += '       ,INSERT_ID,INSERT_TIME,UPDATE_ID,UPDATE_TIME    ' + char(10)
                                SELECT @v_dSql += '       ,'''+ @v_user_id +''',GETDATE(),''EXCEL''       ' + char(10)
                                SELECT @v_dSql += ' FROM   SCM_LINE_SETUP_GROUP_M(NOLOCK) ' + char(10)
                                SELECT @v_dSql += ' WHERE COMPANY_ID        = '''+ @v_company_id +'''             ' + char(10)
                                SELECT @v_dSql += ' AND   DIVISION_ID       = '''+ @v_division_id +'''            ' + char(10)
                                SELECT @v_dSql += ' AND   SITE_ID           = '''+ @v_site_id +'''                ' + char(10)
                                SELECT @v_dSql += ' AND   PLANT_ID          = '''+ @v_plant_id +'''               ' + char(10)
                                SELECT @v_dSql += ' AND   OPERATION_ID      = '''+ @v_operation_id +'''           ' + char(10)
                                SELECT @v_dSql += ' AND   LINE_SETUP_GROUP_ID = '''+ @v_line_setup_group_id +'''  ' + char(10)

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

