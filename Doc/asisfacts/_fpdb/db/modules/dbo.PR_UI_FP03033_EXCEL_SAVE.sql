

/*
 * Program ID   : PR_UI_FP03033_EXCEL_SAVE
 * Description  : Measure Conversion
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/06/09   JYJ				Initial Release UI통합
 * 2022/04/11   LJS             관리자ID 추가 및 ESNA 제외
 */

CREATE PROCEDURE [dbo].[PR_UI_FP03033_EXCEL_SAVE]
  @p_sys_type                   NVARCHAR(MAX),
  @p_sys_flag                   NVARCHAR(MAX),
  @p_sys_gubun                  NVARCHAR(MAX),
  @p_user_id                    NVARCHAR(MAX),
  @p_company_id				    NVARCHAR(MAX),
  @p_division_id				NVARCHAR(MAX),
  @p_site_id					NVARCHAR(MAX),
  @p_plant_id					NVARCHAR(MAX),
  @p_factory_id					NVARCHAR(MAX),
  @p_model_id					NVARCHAR(MAX),
  @p_pjt_code					NVARCHAR(MAX),
  @p_version_type			    NVARCHAR(MAX),
  @p_version			        NVARCHAR(MAX),
  @p_prod_yn     				NVARCHAR(MAX),
  @p_operation_id				NVARCHAR(MAX),
  @p_item_id					NVARCHAR(MAX),
  @p_electrode_type			    NVARCHAR(MAX),
  @p_category_id			    NVARCHAR(MAX),
  @p_value  			        NVARCHAR(MAX),
  @p_prod_ver_type			    NVARCHAR(MAX),
  @p_max_version  			    NVARCHAR(MAX),
  @p_mark			            NVARCHAR(MAX),
  @p_org_version  			    NVARCHAR(MAX),
  @p_job_type   			    NVARCHAR(MAX)

AS 
BEGIN  --MAIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
    SET NOCOUNT ON                                                                                                                                                                                                                                                   
	SET XACT_ABORT ON 

	DECLARE @v_sys_type                  NVARCHAR(100)  -- 값>> SELEC: SQL저장안함, SQL:SQL저장함
	DECLARE @v_sys_flag                  NVARCHAR(100)  -- 값>> I: Insert, M: Update, D: Delete, G: MERGE
	DECLARE @v_sys_gubun                 NVARCHAR(100) 
	DECLARE @v_user_id                   NVARCHAR(100)
    DECLARE @v_company_id				 NVARCHAR(100)
    DECLARE @v_division_id				 NVARCHAR(100)
    DECLARE @v_site_id					 NVARCHAR(100)
    DECLARE @v_plant_id					 NVARCHAR(100)
    DECLARE @v_factory_id				 NVARCHAR(100)
    DECLARE @v_model_id					 NVARCHAR(100)
    DECLARE @v_pjt_code					 NVARCHAR(100)
    DECLARE @v_version_type			     NVARCHAR(100)
    DECLARE @v_version			         NVARCHAR(100)
    DECLARE @v_prod_yn     				 NVARCHAR(100)
    DECLARE @v_operation_id				 NVARCHAR(100)
    DECLARE @v_item_id					 NVARCHAR(100)
    DECLARE @v_electrode_type			 NVARCHAR(100)
    DECLARE @v_category_id			     NVARCHAR(100)
    DECLARE @v_value     			     NVARCHAR(100)
    DECLARE @v_prod_ver_type			 NVARCHAR(100)
    DECLARE @v_max_version  			 NVARCHAR(100)
    DECLARE @v_mark			             NVARCHAR(100)
    DECLARE @v_apply_date  			     NVARCHAR(100)
	DECLARE @v_org_version 			     NVARCHAR(100)
	DECLARE @v_job_type 			     NVARCHAR(100)
	DECLARE @v_site_time			     NVARCHAR(100)

	DECLARE @recv_active_flag       NVARCHAR(MAX)				    
	DECLARE @v_proc_name	        NVARCHAR(100) = 'PR_UI_FP03033_EXCEL_SAVE'
	DECLARE @v_log_type             NVARCHAR(100) = ''
	DECLARE @v_log_message          NVARCHAR(MAX) = ''
	DECLARE @v_error_description    NVARCHAR(MAX) = ''
	DECLARE @v_delimiter            NVARCHAR(1)
	DECLARE @max_loop_cnt	        INTEGER = 0
	DECLARE @mst_loop_cnt	        INTEGER = 0
	DECLARE @max_loop_cnt2	        INTEGER = 0
	DECLARE @mst_loop_cnt2	        INTEGER = 0
	DECLARE @v_seq_no   	        INTEGER = 0
	DECLARE @rtnCount   	        INTEGER = 0

	DECLARE @sysdate                DATETIME      = GETDATE()
	DECLARE @runstart               datetime
    DECLARE @runend                 datetime

	DECLARE @v_dSql                 NVARCHAR(MAX)=''
	DECLARE @v_dSql1                NVARCHAR(MAX)=''
	DECLARE @v_dSql2                NVARCHAR(MAX)=''
	DECLARE @v_dSql3                NVARCHAR(MAX)=''
	DECLARE @v_dSql4                NVARCHAR(MAX)=''
	DECLARE @v_dSql5                NVARCHAR(MAX)=''

	DECLARE @v_tmp1                 NVARCHAR(MAX)=''
	DECLARE @v_tmp2                 NVARCHAR(MAX)=''

	SET @v_sys_type                 = ''
	SET @v_sys_flag                 = ''
	SET @v_sys_gubun                = ''
	SET @v_user_id                  = ''
    SET @v_company_id				= ''
    SET @v_division_id				= ''
    SET @v_site_id					= ''
    SET @v_plant_id					= ''
    SET @v_factory_id				= ''
    SET @v_model_id					= ''
    SET @v_pjt_code					= ''
    SET @v_version_type			    = ''
    SET @v_version			        = ''
    SET @v_prod_yn     				= ''
    SET @v_operation_id				= ''
    SET @v_item_id					= ''
    SET @v_electrode_type			= ''
    SET @v_category_id			    = ''
    SET @v_value    			    = ''
    SET @v_prod_ver_type			= ''
    SET @v_max_version  			= ''
    SET @v_mark			            = ''
    SET @v_apply_date  			    = ''
	SET @v_org_version 			    = ''
	SET @v_job_type 			    = ''
	SET @v_site_time                = ''

	SET @recv_active_flag       = @p_sys_flag
	SET @v_delimiter            = '|'             -- 데이터 구분자

	SET	@v_dSql                 = ''
	SET	@v_dSql1                = ''
	SET	@v_dSql2                = ''
	SET	@v_dSql3                = ''
	SET	@v_dSql4                = ''
	SET	@v_dSql5                = ''

    SET	@v_tmp1                 = ''
	SET	@v_tmp2                 = ''
	SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_sys_flag, @v_delimiter) -- 프로시저 LOOP 길이를 판단

	/************************************************************************************************/
	/* SELECT인경우 :SELECT(SELECT EXCEL)                                                                 */
	/************************************************************************************************/
    IF(@p_sys_flag ='SELECT_IMPORT')
        BEGIN --IF(START)
            SELECT @v_dSql = ''
            SELECT @v_dSql += ' SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
            SELECT @v_dSql += '     , A.MODEL_ID, A.PJT_CODE, A.VERSION_TYPE, A.VERSION, A.OPERATION    ' + char(10)
            SELECT @v_dSql += '     , A.ITEM_ID, MAX('''') AS CATEGORY, MAX('''') AS VALUE              ' + char(10)
            SELECT @v_dSql += '      , A.PROD_VERSION_TYPE , MAX(A.MARK) AS MARK                        ' + char(10)
            SELECT @v_dSql += ' FROM (                                                                  ' + char(10)
            SELECT @v_dSql += '       SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID         ' + char(10)
            SELECT @v_dSql += '          , A.FACTORY_ID, A.MODEL_ID, D.NICK_NAME AS PJT_CODE, A.VERSION ' + char(10)
            SELECT @v_dSql += '          , A.OPERATION, A.ITEM_ID, A.ELECTRODE_TYPE, A.CATEGORY         ' + char(10)
            SELECT @v_dSql += '          , A.VALUE, A.MARK, A.MAX_VER_FLAG, A.VERSION_TYPE              ' + char(10)
            SELECT @v_dSql += '          , DENSE_RANK( ) OVER( PARTITION BY A.FACTORY_ID, A.MODEL_ID, A.OPERATION, A.ITEM_ID       ' + char(10)
            SELECT @v_dSql += '                  ORDER BY A.FACTORY_ID, A.MODEL_ID, A.OPERATION, A.ITEM_ID, A.VERSION ) AS ROW_NUM ' + char(10)
            SELECT @v_dSql += '          , A.PROD_VERSION_TYPE                                           ' + char(10)
            SELECT @v_dSql += '          , CASE WHEN E.ROW_CNT IS NULL THEN ''N''                        ' + char(10)
            SELECT @v_dSql += ' 		        WHEN E.ROW_CNT = 1     THEN ''R''                        ' + char(10)
            SELECT @v_dSql += ' 				WHEN E.ROW_CNT = 2     THEN ''W'' ELSE ''N'' END PROD_YN ' + char(10)
            SELECT @v_dSql += '          , CONVERT(VARCHAR,A.APPLY_DATE,20) AS APPLY_DATE                ' + char(10)
            SELECT @v_dSql += '          , (CASE WHEN R.FACTORY_ID IS NULL THEN ''N'' ELSE ''Y'' END) AS EDIT_YN ' + char(10)
            SELECT @v_dSql += '     FROM   SCM_ITEM_CONV_CALC_M A WITH(NOLOCK)               ' + char(10)
            SELECT @v_dSql += '     INNER JOIN (                                             ' + char(10)
            SELECT @v_dSql += '               SELECT DISTINCT A.ATTRIBUTE1 AS E_CATEGORY     ' + char(10)
            SELECT @v_dSql += '               FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)     ' + char(10)
            SELECT @v_dSql += '               WHERE  A.LOOKUP_TYPE_CODE = ''ITEM_CONV_CALC'' ' + char(10)
            SELECT @v_dSql += '               AND    A.ATTRIBUTE2 = ''Y''                    ' + char(10)
            SELECT @v_dSql += '     ) C                                       ' + char(10)
            SELECT @v_dSql += '     ON  A.CATEGORY = C.E_CATEGORY             ' + char(10)
            SELECT @v_dSql += '     LEFT OUTER JOIN SCM_ITEM_M D WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += '     ON  A.COMPANY_ID  = D.COMPANY_ID          ' + char(10)
            SELECT @v_dSql += '     AND A.DIVISION_ID = D.DIVISION_ID         ' + char(10)
            SELECT @v_dSql += '     AND A.SITE_ID     = D.SITE_ID             ' + char(10)
            SELECT @v_dSql += '     AND A.MODEL_ID    = D.ITEM_ID             ' + char(10)
            SELECT @v_dSql += '     LEFT OUTER JOIN (                         ' + char(10)
            SELECT @v_dSql += '             SELECT DISTINCT A.SEGMENT2 AS DIVISION_ID, A.SEGMENT1 AS SITE_ID                          ' + char(10)
            SELECT @v_dSql += ' 			    , A.SEGMENT3 AS PLANT_ID, A.SEGMENT4 AS FACTORY_ID                                    ' + char(10)
            SELECT @v_dSql += '                 , COUNT(*) OVER (PARTITION BY A.SEGMENT2, A.SEGMENT1, A.SEGMENT3, A.SEGMENT4          ' + char(10)
            SELECT @v_dSql += '                      ORDER BY A.SEGMENT2, A.SEGMENT1, A.SEGMENT3, A.SEGMENT4, A.SEGMENT4 ) AS ROW_CNT ' + char(10)
            SELECT @v_dSql += '             FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)             ' + char(10)
            SELECT @v_dSql += '             WHERE  A.LOOKUP_TYPE_CODE = ''LINE_PROD_VERSION_TYPE'' ' + char(10)
            SELECT @v_dSql += '             AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
            SELECT @v_dSql += '     ) E                                  ' + char(10)
            SELECT @v_dSql += '     ON  A.DIVISION_ID  = E.DIVISION_ID   ' + char(10)
            SELECT @v_dSql += '     AND A.SITE_ID      = E.SITE_ID       ' + char(10)
            SELECT @v_dSql += '     AND A.PLANT_ID     = E.PLANT_ID      ' + char(10)
            SELECT @v_dSql += '     AND A.FACTORY_ID   = E.FACTORY_ID    ' + char(10)
            SELECT @v_dSql += '     LEFT OUTER JOIN (                    ' + char(10)
            SELECT @v_dSql += '            SELECT DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID ' + char(10)
			SELECT @v_dSql += '                , R.PLANT_ID, R.FACTORY_ID, R.OPERATION_ID         ' + char(10)
            SELECT @v_dSql += '            FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK)              ' + char(10)
            SELECT @v_dSql += '            WHERE  R.USER_ID   = '''+ @p_user_id +'''              ' + char(10)
            SELECT @v_dSql += '            AND    R.SAVE_FLAG = ''Y''                             ' + char(10)
            SELECT @v_dSql += '            -- G183 예외처리 : 관리자ID or G183 plant... 20200316  ' + char(10)
            SELECT @v_dSql += '            AND  ((R.USER_ID IN (''leehsthira'',''choikjthira'',''yschoithira'',''leejsthira'',''kimcd'' ' + char(10)
            SELECT @v_dSql += ' 		          ,''piyong'',''dolce1011'',''hseokjang'',''chaosjung'',''DEMO117'',''DEMO109'',''lgda106'',''chkim.68'',''lgzhyu3'',''multishin'',''hwanghg''))       ' + char(10)
            SELECT @v_dSql += '                 OR (R.PLANT_ID IN (''G183''))) ' + char(10) -- 관리자ID 추가 및 ESNA 제외... 20220411
            SELECT @v_dSql += '     ) R                                 ' + char(10)
            SELECT @v_dSql += '     ON   A.COMPANY_ID  = R.COMPANY_ID   ' + char(10)
            SELECT @v_dSql += '     AND  A.DIVISION_ID = R.DIVISION_ID  ' + char(10)
            SELECT @v_dSql += '     AND  A.SITE_ID     = R.SITE_ID      ' + char(10)
            SELECT @v_dSql += '     AND  A.PLANT_ID    = R.PLANT_ID     ' + char(10)
            SELECT @v_dSql += '     AND  A.FACTORY_ID  = R.FACTORY_ID   ' + char(10)
            SELECT @v_dSql += '     AND  A.OPERATION   = R.OPERATION_ID ' + char(10)
            SELECT @v_dSql += '     WHERE EXISTS (                      ' + char(10)
            SELECT @v_dSql += '                   SELECT 1              ' + char(10)
            SELECT @v_dSql += '                   FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)    ' + char(10)
            SELECT @v_dSql += '                   WHERE  A.COMPANY_ID   = B.COMPANY_ID         ' + char(10)
            SELECT @v_dSql += '                   AND    A.DIVISION_ID  = B.DIVISION_ID        ' + char(10)
            SELECT @v_dSql += '                   AND    A.SITE_ID      = B.SITE_ID            ' + char(10)
            SELECT @v_dSql += '                   AND    A.PLANT_ID     = B.PLANT_ID           ' + char(10)
            SELECT @v_dSql += '                   AND    A.FACTORY_ID   = B.FACTORY_ID         ' + char(10)
            SELECT @v_dSql += '                   AND    A.OPERATION    = B.OPERATION_ID       ' + char(10)
            SELECT @v_dSql += '                   AND    B.USER_ID      = '''+ @p_user_id +''' ' + char(10)
            SELECT @v_dSql += '     )                                                          ' + char(10)
            SELECT @v_dSql += '     AND    A.OPERATION = ''E2000'' -- E2000 공정만 보이도록 수정... 20200128 ' + char(10)
	        
			IF(LEN(@p_max_version) > 0)
	            BEGIN
	        	    SELECT @v_dSql += '     AND    A.MAX_VER_FLAG = '''+ @p_max_version +''' ' + char(10)
	        	END
            SELECT @v_dSql += '               '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
            SELECT @v_dSql += '               '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))         + char(10)
            SELECT @v_dSql += '               '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))       + char(10)
            SELECT @v_dSql += '               '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))   + char(10)
            SELECT @v_dSql += '               '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION' , 'EQ', @p_operation_id))  + char(10)
            SELECT @v_dSql += '               '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PROD_VERSION_TYPE' , 'EQ', @p_prod_ver_type))   + char(10)
	        
	        IF(LEN(@p_model_id) > 0)
	            BEGIN
	        	    SELECT @v_dSql += '     AND    A.MODEL_ID LIKE '''+ @p_model_id +''' ' + char(10)
	        	END
	        IF(LEN(@p_item_id) > 0)
	            BEGIN
	        	    SELECT @v_dSql += '     AND    A.ITEM_ID LIKE '''+ @p_item_id +''' ' + char(10)
	        	END
	        IF(LEN(@p_pjt_code) > 0)
	            BEGIN
	        	    SELECT @v_dSql += '     AND    A.PJT_CODE LIKE '''+ @p_pjt_code +''' ' + char(10)
	        	END
            SELECT @v_dSql += '     ) A                                                                         ' + char(10)
            SELECT @v_dSql += ' GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID       ' + char(10)
            SELECT @v_dSql += '     , A.MODEL_ID, A.PJT_CODE, A.VERSION, A.OPERATION, A.ITEM_ID                 ' + char(10)
            SELECT @v_dSql += '     , A.MAX_VER_FLAG, A.VERSION_TYPE, A.PROD_VERSION_TYPE, A.PROD_YN, A.EDIT_YN ' + char(10)
            SELECT @v_dSql += ' ORDER BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.MODEL_ID         ' + char(10)
            SELECT @v_dSql += '     , A.OPERATION, A.ITEM_ID, A.VERSION_TYPE                                    ' + char(10)
            SELECT @v_dSql += '     , CASE WHEN A.VERSION LIKE ''Z%'' THEN REPLACE( A.VERSION, ''Z'', ''/'') ELSE A.VERSION END ' + char(10)

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
	/* SELECT인경우 :SELECT(SELECT_EXCEL_BUFFER_VALID Excel Popup)                                  */
	/************************************************************************************************/
    ELSE IF(@p_sys_flag ='SELECT_EXCEL_BUFFER_VALID')
	    BEGIN
		    SELECT @v_dSql  = ''
            SELECT @v_dSql += ' SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID              ' + char(10)
            SELECT @v_dSql += '     , A.PLANT_ID, A.FACTORY_ID,A.MODEL_ID , A.PJT_CODE     ' + char(10)
            SELECT @v_dSql += '     , A.VERSION, A.OPERATION, A.ITEM_ID,  A.CATEGORY       ' + char(10)
            SELECT @v_dSql += '     , A.VALUE, A.PROD_VERSION_TYPE, A.VERSION_TYPE, A.MARK ' + char(10)
            SELECT @v_dSql += '     , A.JOB_USER_ID, A.JOB_TIME, A.JOB_TYPE, A.JOB_ORDER   ' + char(10)
            SELECT @v_dSql += '     ,CASE WHEN __MSG = '' Not Found'' THEN (CASE WHEN MSG99 = '''' THEN '''' ELSE MSG99 END) ' + char(10)
            SELECT @v_dSql += '           ELSE (CASE WHEN MSG99 = '''' THEN __MSG ELSE __MSG + '' AND '' + MSG99 END )       ' + char(10)
            SELECT @v_dSql += '           END AS _MSG                                                                        ' + char(10)
            SELECT @v_dSql += '     ,CASE WHEN __MSG = '' Not Found'' AND MSG99 = '''' THEN ''Y'' ELSE ''N'' END AS _VALID   ' + char(10)
            SELECT @v_dSql += ' FROM (           ' + char(10)
            SELECT @v_dSql += '       SELECT A.* ' + char(10)
            SELECT @v_dSql += '           ,MSG1  ' + char(10)
            SELECT @v_dSql += '           +(CASE WHEN (MSG1 = '''')                                                         THEN MSG2 ELSE (CASE WHEN MSG2 = '''' THEN '''' ELSE '','' + MSG2 END) END) ' + char(10)
            SELECT @v_dSql += '           +(CASE WHEN (MSG1 = '''' AND MSG2 = '''')                                           THEN MSG3 ELSE (CASE WHEN MSG3 = '''' THEN '''' ELSE '','' + MSG3 END) END) ' + char(10)
            SELECT @v_dSql += '           +(CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''')                             THEN MSG4 ELSE (CASE WHEN MSG4 = '''' THEN '''' ELSE '','' + MSG4 END) END) ' + char(10)
            SELECT @v_dSql += '           +(CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''' AND MSG4 = '''')               THEN MSG5 ELSE (CASE WHEN MSG5 = '''' THEN '''' ELSE '','' + MSG5 END) END) ' + char(10)
            SELECT @v_dSql += '           +(CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''' AND MSG4 = '''' AND MSG5 = '''') THEN MSG6 ELSE (CASE WHEN MSG6 = '''' THEN '''' ELSE '','' + MSG6 END) END) ' + char(10)
            SELECT @v_dSql += '           +(CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''' AND MSG4 = '''' AND MSG5 = '''' AND MSG6 = '''') THEN MSG7 ELSE (CASE WHEN MSG7 = '''' THEN '''' ELSE '','' + MSG7 END) END) ' + char(10)
            SELECT @v_dSql += '           +(CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''' AND MSG4 = '''' AND MSG5 = '''' AND MSG6 = '''' AND MSG7 = '''') THEN MSG8 ELSE (CASE WHEN MSG8 = '''' THEN '''' ELSE '','' + MSG8 END) END) ' + char(10)
            SELECT @v_dSql += '           +(CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''' AND MSG4 = '''' AND MSG5 = '''' AND MSG6 = '''' AND MSG7 = '''' AND MSG8 = '''') THEN MSG9 ELSE (CASE WHEN MSG9 = '''' THEN '''' ELSE '','' + MSG9 END) END) ' + char(10)
            SELECT @v_dSql += '           +(CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''' AND MSG4 = '''' AND MSG5 = '''' AND MSG6 = '''' AND MSG7 = '''' AND MSG8 = '''' AND MSG9 = '''') THEN MSG10 ELSE (CASE WHEN MSG10 = '''' THEN '''' ELSE '','' + MSG10 END) END) ' + char(10)
            SELECT @v_dSql += '           +(CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''' AND MSG4 = '''' AND MSG5 = '''' AND MSG6 = '''' AND MSG7 = '''' AND MSG8 = '''' AND MSG9 = '''' AND MSG10 = '''') THEN MSG11 ELSE (CASE WHEN MSG11 = '''' THEN '''' ELSE '','' + MSG11 END) END) ' + char(10)
            SELECT @v_dSql += '           +(CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''' AND MSG4 = '''' AND MSG5 = '''' AND MSG6 = '''' AND MSG7 = '''' AND MSG8 = '''' AND MSG9 = '''' AND MSG10 = '''' AND MSG11 = '''') THEN MSG12 ELSE (CASE WHEN MSG12 = '''' THEN '''' ELSE '','' + MSG12 END) END) ' + char(10)
            SELECT @v_dSql += '           + '' Not Found'' AS __MSG                       ' + char(10)
            SELECT @v_dSql += '       FROM (                                              ' + char(10)
            SELECT @v_dSql += '             SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID ' + char(10)
            SELECT @v_dSql += '                 , A.PLANT_ID, A.FACTORY_ID,A.MODEL_ID     ' + char(10)
            SELECT @v_dSql += '                 , ISNULL(C.NICK_NAME,''-'') AS PJT_CODE   ' + char(10)
            SELECT @v_dSql += '                 ,A.VERSION, A.OPERATION                   ' + char(10)
            SELECT @v_dSql += '                 ,A.ITEM_ID, A.ELECTRODE_TYPE, A.CATEGORY  ' + char(10)
            SELECT @v_dSql += '                 , A.VALUE, A.PROD_VERSION_TYPE, A.VERSION_TYPE ' + char(10)
            SELECT @v_dSql += '                 , A.MAX_VER_FLAG, A.MARK, A.JOB_USER_ID        ' + char(10)
            SELECT @v_dSql += '                 , A.JOB_TIME, A.JOB_TYPE, A.JOB_ORDER          ' + char(10)
            SELECT @v_dSql += '                 ,CASE WHEN A.COMPANY_ID IS NULL THEN ''Building'' ELSE '''' END AS MSG1    ' + char(10)
            SELECT @v_dSql += '                 ,CASE WHEN B.OPERATION_ID IS NULL THEN ''Operation'' ELSE '''' END AS MSG2 ' + char(10)
            SELECT @v_dSql += '                 ,CASE WHEN C.ITEM_ID IS NULL THEN ''Model'' ELSE '''' END AS MSG3          ' + char(10)
            SELECT @v_dSql += '                 ,CASE WHEN D.ITEM_ID IS NULL THEN ''Material'' ELSE '''' END AS MSG4       ' + char(10)
            SELECT @v_dSql += '                 ,'''' AS MSG5                                                              ' + char(10)
            SELECT @v_dSql += '                 ,CASE WHEN F.ATTRIBUTE1 IS NULL THEN ''Category'' ELSE '''' END AS MSG6    ' + char(10)
            SELECT @v_dSql += '                 ,CASE WHEN H.PROD_VERSION_TYPE IS NULL THEN ''Conversion Different Type'' ELSE '''' END AS MSG7          ' + char(10)
            SELECT @v_dSql += '                 ,CASE WHEN A.CATEGORY = ''Lane Number'' AND G.ITEM_ID IS NULL THEN ''Lane Number'' ELSE '''' END AS MSG8 ' + char(10)
            SELECT @v_dSql += '                 ,CASE WHEN DENSE_RANK() OVER(PARTITION BY A.COMPANY_ID,A.FACTORY_ID,A.MODEL_ID          ' + char(10)
            SELECT @v_dSql += '                                        ,A.VERSION,A.OPERATION,A.ITEM_ID,A.VERSION_TYPE                  ' + char(10)
            SELECT @v_dSql += '                                   ORDER BY A.COMPANY_ID,A.FACTORY_ID,A.MODEL_ID,A.VERSION,A.OPERATION   ' + char(10)
            SELECT @v_dSql += '                                       ,A.ITEM_ID,A.VERSION_TYPE)>1 THEN ''Version Type Different Type'' ' + char(10)
            SELECT @v_dSql += '                       ELSE '''' END AS MSG9                                                             ' + char(10)
			/*
            SELECT @v_dSql += '                 ,CASE WHEN ( A.VERSION_TYPE NOT IN (''TEST'',''MASS'')) OR (A.VERSION_TYPE = ''TEST'' AND SUBSTRING(A.VERSION,1,1) <> ''Z'') ' + char(10)
            SELECT @v_dSql += '                               OR (A.VERSION_TYPE = ''MASS'' AND SUBSTRING(A.VERSION,1,1) = ''Z'') THEN ''Version Type - Version not match''  ' + char(10)
            SELECT @v_dSql += '                               ELSE '''' END AS MSG10                                                                           ' + char(10)
			*/
            -- x 버전 조건 추가... 20230925
			SELECT @v_dSql += '                 ,CASE WHEN (A.VERSION_TYPE NOT IN (''TEST'',''MASS'',''4M'')) ' + char(10)
			SELECT @v_dSql += '                 	         OR (A.VERSION_TYPE = ''TEST'' AND SUBSTRING(A.VERSION,1,1) <> ''Z'') ' + char(10)
            SELECT @v_dSql += '                              OR (A.VERSION_TYPE = ''MASS'' AND SUBSTRING(A.VERSION,1,1) = ''Z'') ' + char(10)
			SELECT @v_dSql += '                 			 OR (A.VERSION_TYPE = ''4M''   AND SUBSTRING(A.VERSION,1,1) <> ''X'') ' + char(10)
			SELECT @v_dSql += '                 		   THEN ''Version Type - Version not match'' ELSE '''' END AS MSG10 ' + char(10)
            SELECT @v_dSql += '                 ,CASE WHEN (A.PROD_VERSION_TYPE NOT IN (''GENERAL'', ''WIDE'', ''PREWET_UNIT2'',''PREWET_UNIT3'', ''UNIT2''))  ' + char(10)
            SELECT @v_dSql += '                        OR (A.PROD_VERSION_TYPE = ''WIDE'' AND CHARINDEX(''W'',A.VERSION,1) < 1)          ' + char(10)
            SELECT @v_dSql += '                        OR (A.PROD_VERSION_TYPE = ''PREWET_UNIT2'' AND CHARINDEX(''P2'',A.VERSION,1) < 1) ' + char(10)
            SELECT @v_dSql += '                        OR (A.PROD_VERSION_TYPE = ''PREWET_UNIT3'' AND CHARINDEX(''P3'',A.VERSION,1) < 1) ' + char(10) 
            SELECT @v_dSql += '                        OR (A.PROD_VERSION_TYPE = ''UNIT2'' AND CHARINDEX(''.S'',A.VERSION,1) < 1)        ' + char(10)
            SELECT @v_dSql += '                      THEN ''Conversion Type - Version not match'' ELSE '''' END AS MSG11                 ' + char(10)
            SELECT @v_dSql += '                 ,CASE WHEN R.FACTORY_ID IS NULL THEN ''Permissions'' ELSE '''' END AS MSG12     ' + char(10)
            SELECT @v_dSql += '                 ,CASE WHEN ROW_NUMBER() OVER(PARTITION BY A.COMPANY_ID,A.FACTORY_ID,A.MODEL_ID  ' + char(10)
            SELECT @v_dSql += '                                   ,A.VERSION,A.OPERATION,A.ITEM_ID,A.CATEGORY,A.VERSION_TYPE    ' + char(10)
            SELECT @v_dSql += '                           ORDER BY  A.COMPANY_ID,A.FACTORY_ID,A.MODEL_ID,A.VERSION,A.OPERATION  ' + char(10)
            SELECT @v_dSql += '                                   ,A.ITEM_ID,A.CATEGORY,A.VERSION_TYPE)>1 THEN ''Data Overlap'' ' + char(10)
            SELECT @v_dSql += '                       ELSE '''' END AS MSG99                                 ' + char(10)
            SELECT @v_dSql += '             FROM (                                                           ' + char(10)
            SELECT @v_dSql += '                   SELECT ISNULL(B.COMPANY_ID,''-'') AS COMPANY_ID            ' + char(10)
            SELECT @v_dSql += '                      , ISNULL(B.DIVISION_ID,''-'') AS DIVISION_ID            ' + char(10)
            SELECT @v_dSql += '                      , ISNULL(B.SITE_ID,''-'') AS SITE_ID                    ' + char(10)
            SELECT @v_dSql += '                      , ISNULL(B.PLANT_ID,''-'') AS PLANT_ID, A.FACTORY_ID    ' + char(10)
            SELECT @v_dSql += '                      , A.MODEL_ID, A.PJT_CODE, A.VERSION, A.OPERATION        ' + char(10)
            SELECT @v_dSql += '                      , A.ITEM_ID, A.ELECTRODE_TYPE, A.CATEGORY, A.VALUE      ' + char(10)
            SELECT @v_dSql += '                      , A.MAX_VER_FLAG, A.MARK, A.PROD_VERSION_TYPE           ' + char(10)
            SELECT @v_dSql += '                      , A.VERSION_TYPE, A.JOB_USER_ID, A.JOB_TIME, A.JOB_TYPE ' + char(10)
            SELECT @v_dSql += '                      , A.JOB_ORDER                             ' + char(10)
            SELECT @v_dSql += '                   FROM   BUF_ITEM_CONV_CALC_M A WITH(NOLOCK)   ' + char(10)
            SELECT @v_dSql += '                   LEFT OUTER JOIN SCM_FACTORY_M B WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += '                   ON    A.FACTORY_ID  = B.FACTORY_ID           ' + char(10)
            SELECT @v_dSql += '                   AND   B.ACTIVE_FLAG = ''Y''                  ' + char(10)
            SELECT @v_dSql += '                   WHERE A.JOB_USER_ID = '''+ @p_user_id +'''   ' + char(10)
            SELECT @v_dSql += '             ) A                                                ' + char(10)
            SELECT @v_dSql += '             LEFT OUTER JOIN SCM_OPERATION_M B WITH(NOLOCK)     ' + char(10)
            SELECT @v_dSql += '             ON  A.COMPANY_ID  = B.COMPANY_ID   ' + char(10)
            SELECT @v_dSql += '             AND A.DIVISION_ID = B.DIVISION_ID  ' + char(10)
            SELECT @v_dSql += '             AND A.SITE_ID     = B.SITE_ID      ' + char(10)
            SELECT @v_dSql += '             AND A.OPERATION   = B.OPERATION_ID ' + char(10)
            SELECT @v_dSql += '             LEFT OUTER JOIN (                  ' + char(10)
            SELECT @v_dSql += '                   SELECT C.ITEM_ID, MAX(NICK_NAME) AS NICK_NAME ' + char(10)
            SELECT @v_dSql += '                   FROM   SCM_ITEM_M C WITH(NOLOCK)              ' + char(10)
            SELECT @v_dSql += '                   WHERE  C.ACTIVE_FLAG = ''Y''                  ' + char(10)
            SELECT @v_dSql += '                   GROUP BY C.ITEM_ID                  ' + char(10)
            SELECT @v_dSql += '             ) C                                       ' + char(10)
            SELECT @v_dSql += '             ON  A.MODEL_ID    = C.ITEM_ID             ' + char(10)
            SELECT @v_dSql += '             LEFT OUTER JOIN SCM_ITEM_M D WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += '             ON  A.COMPANY_ID  = D.COMPANY_ID          ' + char(10)
            SELECT @v_dSql += '             AND A.DIVISION_ID = D.DIVISION_ID         ' + char(10)
            SELECT @v_dSql += '             AND A.SITE_ID     = D.SITE_ID             ' + char(10)
            SELECT @v_dSql += '             AND A.ITEM_ID     = D.ITEM_ID             ' + char(10)
            SELECT @v_dSql += '             LEFT OUTER JOIN (                         ' + char(10)
            SELECT @v_dSql += '                  SELECT A.SEGMENT1 AS CODE_ID         ' + char(10)
            SELECT @v_dSql += '                  FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)     ' + char(10)
            SELECT @v_dSql += '                  WHERE  A.LOOKUP_TYPE_CODE = ''ELECTRODE_TYPE'' ' + char(10)
            SELECT @v_dSql += '                  AND    A.ACTIVE_FLAG      = ''Y''              ' + char(10)
            SELECT @v_dSql += '             ) E                               ' + char(10)
            SELECT @v_dSql += '             ON  A.ELECTRODE_TYPE = E.CODE_ID  ' + char(10)
            SELECT @v_dSql += '             LEFT OUTER JOIN (                 ' + char(10)
            SELECT @v_dSql += '                  SELECT DISTINCT A.ATTRIBUTE1 ' + char(10)
            SELECT @v_dSql += '                  FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)     ' + char(10)
            SELECT @v_dSql += '                  WHERE  A.LOOKUP_TYPE_CODE = ''ITEM_CONV_CALC'' ' + char(10)
            SELECT @v_dSql += '                  AND    A.ATTRIBUTE2       = ''Y''              ' + char(10)
            SELECT @v_dSql += '             ) F                           ' + char(10)
            SELECT @v_dSql += '             ON  A.CATEGORY = F.ATTRIBUTE1 ' + char(10)
            SELECT @v_dSql += '             LEFT OUTER JOIN (             ' + char(10)
            SELECT @v_dSql += '                   SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID       ' + char(10)
            SELECT @v_dSql += '             	    , A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.PROD_VERSION_TYPE ' + char(10)
            SELECT @v_dSql += '                     --, A.LANE_QTY AS LANE            ' + char(10)
            SELECT @v_dSql += '                   FROM SCM_ITEM_LANE_M A WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += '                   WHERE A.ACTIVE_FLAG = ''Y''         ' + char(10)
            SELECT @v_dSql += '              ) G                              ' + char(10)
            SELECT @v_dSql += '             ON A.COMPANY_ID = G.COMPANY_ID    ' + char(10)
            SELECT @v_dSql += '             AND A.DIVISION_ID = G.DIVISION_ID ' + char(10)
            SELECT @v_dSql += '             AND A.SITE_ID = G.SITE_ID         ' + char(10)
            SELECT @v_dSql += '             AND A.PLANT_ID = G.PLANT_ID       ' + char(10)
            SELECT @v_dSql += '             AND A.FACTORY_ID = G.FACTORY_ID   ' + char(10)
            SELECT @v_dSql += '             AND A.ITEM_ID = G.ITEM_ID         ' + char(10)
            SELECT @v_dSql += '             AND ISNULL(A.PROD_VERSION_TYPE,''GENERAL'') = G.PROD_VERSION_TYPE ' + char(10)
            SELECT @v_dSql += '                --AND A.VALUE = G.LANE           ' + char(10)
            SELECT @v_dSql += '                AND A.CATEGORY = ''Lane Number'' ' + char(10)
            SELECT @v_dSql += '             LEFT OUTER JOIN (                   ' + char(10)
            SELECT @v_dSql += '                      SELECT DISTINCT A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
            SELECT @v_dSql += '                          , ISNULL(B.ATTRIBUTE1, ''GENERAL'') AS PROD_VERSION_TYPE       ' + char(10)
            SELECT @v_dSql += '                      FROM SCM_FACTORY_M A WITH(NOLOCK)                   ' + char(10)
            SELECT @v_dSql += '                      LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE B WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += '                      ON 1=1                                              ' + char(10)
            SELECT @v_dSql += '                      AND A.ACTIVE_FLAG      = ''Y''                      ' + char(10)
            SELECT @v_dSql += '                      AND B.LOOKUP_TYPE_CODE = ''LINE_PROD_VERSION_TYPE'' ' + char(10)
            SELECT @v_dSql += '                      AND A.DIVISION_ID = B.SEGMENT2 ' + char(10)
            SELECT @v_dSql += '                      AND A.SITE_ID     = B.SEGMENT1 ' + char(10)
            SELECT @v_dSql += '                      AND A.PLANT_ID    = B.SEGMENT3 ' + char(10)
            SELECT @v_dSql += '                      AND A.FACTORY_ID  = B.SEGMENT4 ' + char(10)
            SELECT @v_dSql += '              ) H                                    ' + char(10)
            SELECT @v_dSql += '              ON 	A.DIVISION_ID 	= H.DIVISION_ID ' + char(10)
            SELECT @v_dSql += '              AND A.SITE_ID          = H.SITE_ID     ' + char(10)
            SELECT @v_dSql += '              AND A.PLANT_ID         = H.PLANT_ID    ' + char(10)
            SELECT @v_dSql += '              AND A.FACTORY_ID       = H.FACTORY_ID  ' + char(10)
            SELECT @v_dSql += '              AND A.PROD_VERSION_TYPE	= H.PROD_VERSION_TYPE ' + char(10)
            SELECT @v_dSql += '              LEFT OUTER JOIN (                                ' + char(10)
            SELECT @v_dSql += '                   SELECT DISTINCT R.COMPANY_ID, R.DIVISION_ID ' + char(10)
            SELECT @v_dSql += '                   , R.SITE_ID, R.PLANT_ID, R.FACTORY_ID, R.OPERATION_ID ' + char(10)
            SELECT @v_dSql += '                   FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK)             ' + char(10)
            SELECT @v_dSql += '                   WHERE  R.USER_ID   = '''+ @p_user_id +'''             ' + char(10)
            SELECT @v_dSql += '                   AND    R.SAVE_FLAG = ''Y''                            ' + char(10)
            SELECT @v_dSql += '                   -- G183 예외처리 : 관리자ID or G183 plant... 20200316 ' + char(10)
            SELECT @v_dSql += '                   AND  ((R.USER_ID IN (''leehsthira'',''choikjthira'',''yschoithira'',''leejsthira'',''kimcd'' ' + char(10)
            SELECT @v_dSql += '                                ,''piyong'',''dolce1011'',''hseokjang'',''chaosjung'',''DEMO117'',''DEMO109'',''yeonjaejeong'',''lgda106'',''chkim.68'',''lgzhyu3'',''multishin'',''hwanghg'')) ' + char(10)
            SELECT @v_dSql += '                       OR (R.PLANT_ID IN (''G183''))) ' + char(10) -- 관리자ID 추가 및 ESNA 제외... 20220411
            SELECT @v_dSql += '              ) R                                 ' + char(10)
            SELECT @v_dSql += '              ON   A.COMPANY_ID  = R.COMPANY_ID   ' + char(10)
            SELECT @v_dSql += '              AND  A.DIVISION_ID = R.DIVISION_ID  ' + char(10)
            SELECT @v_dSql += '              AND  A.SITE_ID     = R.SITE_ID      ' + char(10)
            SELECT @v_dSql += '              AND  A.PLANT_ID    = R.PLANT_ID     ' + char(10)
            SELECT @v_dSql += '              AND  A.FACTORY_ID  = R.FACTORY_ID   ' + char(10)
            SELECT @v_dSql += '              AND  A.OPERATION   = R.OPERATION_ID ' + char(10)
            SELECT @v_dSql += '       ) A            ' + char(10)
            SELECT @v_dSql += ' ) A                  ' + char(10)
            SELECT @v_dSql += ' ORDER BY A.JOB_ORDER ' + char(10)

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

						SELECT @v_sys_type     = [dbo].[SCM_ARR_SPL_VAL](@p_sys_type ,      @v_delimiter, @mst_loop_cnt)
                        , @v_sys_flag          = [dbo].[SCM_ARR_SPL_VAL](@p_sys_flag ,      @v_delimiter, @mst_loop_cnt)
                        , @v_sys_gubun         = [dbo].[SCM_ARR_SPL_VAL](@p_sys_gubun ,     @v_delimiter, @mst_loop_cnt)
                        , @v_user_id           = [dbo].[SCM_ARR_SPL_VAL](@p_user_id ,       @v_delimiter, @mst_loop_cnt)
                        , @v_company_id        = [dbo].[SCM_ARR_SPL_VAL](@p_company_id ,    @v_delimiter, @mst_loop_cnt)
                        , @v_division_id       = [dbo].[SCM_ARR_SPL_VAL](@p_division_id ,   @v_delimiter, @mst_loop_cnt)
                        , @v_site_id           = [dbo].[SCM_ARR_SPL_VAL](@p_site_id ,       @v_delimiter, @mst_loop_cnt)
                        , @v_plant_id          = [dbo].[SCM_ARR_SPL_VAL](@p_plant_id ,      @v_delimiter, @mst_loop_cnt)
                        , @v_factory_id        = [dbo].[SCM_ARR_SPL_VAL](@p_factory_id ,    @v_delimiter, @mst_loop_cnt)
                        , @v_model_id          = [dbo].[SCM_ARR_SPL_VAL](@p_model_id ,      @v_delimiter, @mst_loop_cnt)
                        , @v_pjt_code          = [dbo].[SCM_ARR_SPL_VAL](@p_pjt_code ,      @v_delimiter, @mst_loop_cnt)
                        , @v_version_type	   = [dbo].[SCM_ARR_SPL_VAL](@p_version_type ,  @v_delimiter, @mst_loop_cnt)
                        , @v_version		   = [dbo].[SCM_ARR_SPL_VAL](@p_version ,       @v_delimiter, @mst_loop_cnt)
                        , @v_prod_yn		   = [dbo].[SCM_ARR_SPL_VAL](@p_prod_yn ,       @v_delimiter, @mst_loop_cnt)
                        , @v_operation_id      = [dbo].[SCM_ARR_SPL_VAL](@p_operation_id ,  @v_delimiter, @mst_loop_cnt)
                        , @v_item_id           = [dbo].[SCM_ARR_SPL_VAL](@p_item_id ,       @v_delimiter, @mst_loop_cnt)
                        , @v_electrode_type	   = [dbo].[SCM_ARR_SPL_VAL](@p_electrode_type ,@v_delimiter, @mst_loop_cnt)
                        , @v_category_id	   = [dbo].[SCM_ARR_SPL_VAL](@p_category_id ,   @v_delimiter, @mst_loop_cnt)
                        , @v_value      	   = [dbo].[SCM_ARR_SPL_VAL](@p_value ,         @v_delimiter, @mst_loop_cnt)
                        , @v_prod_ver_type     = [dbo].[SCM_ARR_SPL_VAL](@p_prod_ver_type , @v_delimiter, @mst_loop_cnt)
                        , @v_max_version  	   = [dbo].[SCM_ARR_SPL_VAL](@p_max_version ,   @v_delimiter, @mst_loop_cnt)
                        , @v_mark			   = [dbo].[SCM_ARR_SPL_VAL](@p_mark ,          @v_delimiter, @mst_loop_cnt)
                        , @v_org_version	   = [dbo].[SCM_ARR_SPL_VAL](@p_org_version ,   @v_delimiter, @mst_loop_cnt)
                        , @v_job_type	       = [dbo].[SCM_ARR_SPL_VAL](@p_job_type ,      @v_delimiter, @mst_loop_cnt)
					   
					   /****************************************************************************/
					   /* DELETE  경우  :     D(DELETE_EXCEL_BUFFER)                               */
					   /****************************************************************************/
					   IF(@v_sys_flag ='DELETE_EXCEL_BUFFER')
						   BEGIN

						        --EXEC  @rtnCount = [dbo].[PR_SCM_UF_ITEM_SETUP_INSERT] @v_company_id, @v_division_id, @v_site_id, @v_operation_id, @v_setup_category_id, @v_setup_key_id;
	
								SELECT @v_dSql = ''
                                SELECT @v_dSql += ' DELETE FROM BUF_ITEM_CONV_CALC_M         ' + char(10)
                                SELECT @v_dSql += ' WHERE JOB_USER_ID = '''+ @v_user_id +''' ' + char(10)

						   END --'D'
                       /****************************************************************************/
					   /* INSERT  경우  :     I(INSERT_EXCEL_BUFFER)                               */
					   /****************************************************************************/
					   ELSE IF(@v_sys_flag ='INSERT_EXCEL_BUFFER')
						   BEGIN

						        --EXEC  @rtnCount = [dbo].[PR_SCM_UF_ITEM_SETUP_INSERT] @v_company_id, @v_division_id, @v_site_id, @v_operation_id, @v_setup_category_id, @v_setup_key_id;
	                            SELECT @v_seq_no += 1

								SELECT @v_dSql = ''
                                SELECT @v_dSql += ' INSERT INTO BUF_ITEM_CONV_CALC_M (                ' + char(10)
                                SELECT @v_dSql += '     COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID    ' + char(10)
                                SELECT @v_dSql += '   , FACTORY_ID, MODEL_ID, PJT_CODE, VERSION       ' + char(10)
                                SELECT @v_dSql += '   , OPERATION, ITEM_ID, ELECTRODE_TYPE, CATEGORY  ' + char(10)
                                SELECT @v_dSql += '   , VALUE, MAX_VER_FLAG, MARK, PROD_VERSION_TYPE  ' + char(10)
                                SELECT @v_dSql += '   , VERSION_TYPE, JOB_USER_ID, JOB_TIME, JOB_TYPE ' + char(10)
								SELECT @v_dSql += '   , JOB_ORDER                                     ' + char(10)
                                SELECT @v_dSql += ' )                                                 ' + char(10)
                                SELECT @v_dSql += ' VALUES (                                          ' + char(10)
                                SELECT @v_dSql += '  ( SELECT MAX(KK.COMPANY_ID) AS COMPANY_ID FROM SCM_FACTORY_M KK WITH(NOLOCK)                                                                   ' + char(10)
								SELECT @v_dSql += '    WHERE KK.FACTORY_ID = UPPER(RTRIM(LTRIM('''+ @v_factory_id +'''))) AND KK.ACTIVE_FLAG = ''Y'' )                                              ' + char(10)
                                SELECT @v_dSql += '   , UPPER(RTRIM(LTRIM('''+ @v_division_id +'''))), UPPER(RTRIM(LTRIM('''+ @v_site_id +'''))), UPPER(RTRIM(LTRIM('''+ @v_plant_id +''')))        ' + char(10)
                                SELECT @v_dSql += '   , UPPER(RTRIM(LTRIM('''+ @v_factory_id +'''))), UPPER(RTRIM(LTRIM('''+ @v_model_id +'''))), UPPER(RTRIM(LTRIM('''+ @v_pjt_code +''')))        ' + char(10)
                                SELECT @v_dSql += '   , UPPER(RTRIM(LTRIM('''+ @v_version +'''))), UPPER(RTRIM(LTRIM('''+ @v_operation_id +'''))), UPPER(RTRIM(LTRIM('''+ @v_item_id +''')))        ' + char(10)
                                SELECT @v_dSql += '   , UPPER(RTRIM(LTRIM('''+ @v_electrode_type +'''))),RTRIM(LTRIM('''+ @v_category_id +''')), CAST(RTRIM(LTRIM('''+ @v_value +''')) AS DECIMAL(18,5))  ' + char(10)
                                SELECT @v_dSql += '   , RTRIM(LTRIM('''+ @v_max_version +''')), RTRIM(LTRIM('''+ @v_mark +''')),ISNULL(UPPER(RTRIM(LTRIM('''+ @v_prod_ver_type +'''))),''GENERAL'') ' + char(10)
                                SELECT @v_dSql += '   , ISNULL(UPPER(RTRIM(LTRIM('''+ @v_version_type +'''))),''MASS''), '''+ @v_user_id +''', GETDATE(), ''-'', '+ CONVERT(VARCHAR, @v_seq_no) +'  ' + char(10)
                                SELECT @v_dSql += ' )    ' + char(10)

						   END --'D'
					   /******************************************************************************/
					   /* Excel Popup 경우 : MERGE(MERGE_UOM_INFO  Excel Popup)                        */
					   /******************************************************************************/
					   ELSE IF(@v_sys_flag ='MERGE_UOM_INFO')  
							BEGIN
							    SELECT @v_site_time = ''
								SELECT @v_site_time = CONVERT(VARCHAR, DBO.FN_SITE_TIME('''+ @v_site_id +'''), 20)

                                SELECT @v_dSql1 = ''
                                SELECT @v_dSql1 += ' MERGE INTO SCM_ITEM_CONV_CALC_M AS A ' + char(10)
                                SELECT @v_dSql1 += ' USING (                              ' + char(10)
                                SELECT @v_dSql1 += '        SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID    ' + char(10)
                                SELECT @v_dSql1 += '            , FACTORY_ID, MODEL_ID, PJT_CODE                 ' + char(10)
                                SELECT @v_dSql1 += '            , (CASE WHEN CHARINDEX(''.'',VERSION,1) > 0 THEN ' + char(10)
                                SELECT @v_dSql1 += '                     ISNULL(REPLICATE(''0'', 3 - LEN(SUBSTRING(VERSION, 1, ABS(CHARINDEX(''.'',VERSION,1)-1)))),'''') ' + char(10)
                                SELECT @v_dSql1 += ' 				    + SUBSTRING(VERSION, 1, ABS(CHARINDEX(''.'',VERSION,1)-1)   ) + ''.'' ' + char(10)
                                SELECT @v_dSql1 += ' 					+ SUBSTRING(VERSION, CHARINDEX(''.'',VERSION,1)+1,10)     ' + char(10)
                                SELECT @v_dSql1 += '                ELSE ISNULL(REPLICATE(''0'', 3 - LEN(VERSION)),'''') + VERSION ' + char(10)
                                SELECT @v_dSql1 += '                END ) AS VERSION                           ' + char(10)
                                SELECT @v_dSql1 += '            , OPERATION, ITEM_ID, ELECTRODE_TYPE, CATEGORY ' + char(10)
                                SELECT @v_dSql1 += '            , MAX_VER_FLAG, VALUE, MARK, PROD_VERSION_TYPE ' + char(10)
                                SELECT @v_dSql1 += '            , VERSION_TYPE                                 ' + char(10)
                                SELECT @v_dSql1 += '        FROM   BUF_ITEM_CONV_CALC_M BB WITH(NOLOCK)        ' + char(10)
                                SELECT @v_dSql1 += '        WHERE  BB.JOB_USER_ID = '''+ @v_user_id +'''       ' + char(10)
                                SELECT @v_dSql1 += '       ) AS B                       ' + char(10)
                                SELECT @v_dSql1 += '   ON (A.COMPANY_ID  = B.COMPANY_ID ' + char(10)
                                SELECT @v_dSql1 += '   AND A.FACTORY_ID  = B.FACTORY_ID ' + char(10)
                                SELECT @v_dSql1 += '   AND A.MODEL_ID    = B.MODEL_ID   ' + char(10)
                                SELECT @v_dSql1 += '   AND A.VERSION     = B.VERSION    ' + char(10)
                                SELECT @v_dSql1 += '   AND A.OPERATION   = B.OPERATION  ' + char(10)
                                SELECT @v_dSql1 += '   AND A.ITEM_ID     = B.ITEM_ID    ' + char(10)
                                SELECT @v_dSql1 += '   AND A.CATEGORY    = B.CATEGORY   ' + char(10)
                                SELECT @v_dSql1 += '   AND A.PROD_VERSION_TYPE    = B.PROD_VERSION_TYPE ) ' + char(10)
                                SELECT @v_dSql1 += '   WHEN MATCHED THEN                                  ' + char(10)
                                SELECT @v_dSql1 += '        UPDATE SET UPDATE_ID   = '''+ @v_user_id +''' ' + char(10)
                                SELECT @v_dSql1 += '          ,UPDATE_TIME = dbo.FN_SITE_TIME(B.SITE_ID)  ' + char(10)
                                SELECT @v_dSql1 += '          ,VALUE       = B.VALUE ' + char(10)
                                SELECT @v_dSql1 += '          ,MARK        = B.MARK  ' + char(10)
                                SELECT @v_dSql1 += '   WHEN NOT MATCHED THEN         ' + char(10)
                                SELECT @v_dSql1 += '        INSERT (                 ' + char(10)
                                SELECT @v_dSql1 += '           COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID    ' + char(10)
                                SELECT @v_dSql1 += '          , FACTORY_ID, MODEL_ID, PJT_CODE, VERSION      ' + char(10)
                                SELECT @v_dSql1 += '          , OPERATION, ITEM_ID, ELECTRODE_TYPE, CATEGORY ' + char(10)
                                SELECT @v_dSql1 += '          , MAX_VER_FLAG, VALUE, MARK, PROD_VERSION_TYPE ' + char(10)
                                SELECT @v_dSql1 += '          , VERSION_TYPE, CREATE_ID, CREATE_TIME         ' + char(10)
                                SELECT @v_dSql1 += '          , UPDATE_ID, UPDATE_TIME, APPLY_DATE           ' + char(10)
                                SELECT @v_dSql1 += '        ) VALUES (                                       ' + char(10)
                                SELECT @v_dSql1 += '           B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID    ' + char(10)
                                SELECT @v_dSql1 += '          , B.FACTORY_ID, B.MODEL_ID, B.PJT_CODE, B.VERSION      ' + char(10)
                                SELECT @v_dSql1 += '          , B.OPERATION, B.ITEM_ID, B.ELECTRODE_TYPE, B.CATEGORY ' + char(10)
                                SELECT @v_dSql1 += '          , B.MAX_VER_FLAG, B.VALUE, B.MARK, B.PROD_VERSION_TYPE ' + char(10)
                                SELECT @v_dSql1 += '          , B.VERSION_TYPE, '''+ @v_user_id +''', dbo.FN_SITE_TIME(B.SITE_ID)                            ' + char(10)
                                SELECT @v_dSql1 += '          , '''+ @v_user_id +''', dbo.FN_SITE_TIME(B.SITE_ID), CONVERT(DATETIME, '''+ @v_site_time +''') ' + char(10)
                                SELECT @v_dSql1 += '        ); ' + char(10)

								SELECT @v_dSql2  = ''
                                SELECT @v_dSql2 += ' INSERT INTO HIS_ITEM_CONV_CALC_M (               ' + char(10)
                                SELECT @v_dSql2 += '      COMPANY_ID, FACTORY_ID,MODEL_ID, PJT_CODE   ' + char(10)
                                SELECT @v_dSql2 += '     , VERSION, OPERATION, ITEM_ID,ELECTRODE_TYPE ' + char(10)
                                SELECT @v_dSql2 += '     , CATEGORY,VALUE, MARK, PROD_VERSION_TYPE    ' + char(10)
                                SELECT @v_dSql2 += '     , VERSION_TYPE, CREATE_ID, CREATE_TIME       ' + char(10)
                                SELECT @v_dSql2 += '     , UPDATE_ID, UPDATE_TIME, JOB_USER_ID        ' + char(10)
                                SELECT @v_dSql2 += '     , JOB_TIME, JOB_TYPE                         ' + char(10)
                                SELECT @v_dSql2 += ' )                                                ' + char(10)
                                SELECT @v_dSql2 += ' SELECT A.COMPANY_ID, A.FACTORY_ID, A.MODEL_ID, A.PJT_CODE ' + char(10)
                                SELECT @v_dSql2 += '     , A.VERSION, A.OPERATION, A.ITEM_ID, A.ELECTRODE_TYPE ' + char(10)
                                SELECT @v_dSql2 += '     , A.CATEGORY, A.VALUE, A.MARK, A.PROD_VERSION_TYPE    ' + char(10)
                                SELECT @v_dSql2 += '     , A.VERSION_TYPE, A.CREATE_ID, A.CREATE_TIME          ' + char(10)
                                SELECT @v_dSql2 += '     , A.UPDATE_ID, A.UPDATE_TIME, '''+ @v_user_id +'''    ' + char(10)
                                SELECT @v_dSql2 += '     , dbo.SYSDATE1(), ''EXCEL''                ' + char(10)
                                SELECT @v_dSql2 += ' FROM  SCM_ITEM_CONV_CALC_M A WITH(NOLOCK)      ' + char(10)
                                SELECT @v_dSql2 += ' INNER JOIN BUF_ITEM_CONV_CALC_M B WITH(NOLOCK) ' + char(10)
                                SELECT @v_dSql2 += ' ON  1=1                                  ' + char(10)
                                SELECT @v_dSql2 += ' AND B.JOB_USER_ID = '''+ @v_user_id +''' ' + char(10)
                                SELECT @v_dSql2 += ' AND A.COMPANY_ID  = B.COMPANY_ID         ' + char(10)
                                SELECT @v_dSql2 += ' AND A.FACTORY_ID  = B.FACTORY_ID         ' + char(10)
                                SELECT @v_dSql2 += ' AND A.MODEL_ID    = B.MODEL_ID           ' + char(10)
                                SELECT @v_dSql2 += ' AND A.VERSION     = B.VERSION            ' + char(10)
                                SELECT @v_dSql2 += ' AND A.OPERATION   = B.OPERATION          ' + char(10)
                                SELECT @v_dSql2 += ' AND A.ITEM_ID     = B.ITEM_ID            ' + char(10)
                                SELECT @v_dSql2 += ' AND A.CATEGORY    = B.CATEGORY           ' + char(10)

								SELECT @v_dSql = @v_dSql1 + @v_dSql2

						    END --'I'

					   /******************************************************************************/
					   /* INSERT 경우 : INSERT(INSERT_LANE)                                          */
					   /******************************************************************************/
					   ELSE IF(@v_sys_flag ='INSERT_LANE')  
							BEGIN
                                SELECT @v_dSql = ''
								SELECT  @v_site_time = ''
								SELECT  @v_site_time = CONVERT(VARCHAR, DBO.FN_SITE_TIME('''+ @v_site_id +'''), 20)

                                SELECT @v_dSql += ' MERGE INTO SCM_ITEM_CONV_CALC_M AS A                                                ' + char(10)
                                SELECT @v_dSql += ' USING (                                                                             ' + char(10)
                                SELECT @v_dSql += '         SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID          ' + char(10)
                                SELECT @v_dSql += '             , A.FACTORY_ID, A.MODEL_ID, A.PJT_CODE, A.VERSION                       ' + char(10)
                                SELECT @v_dSql += '             , A.OPERATION, A.ITEM_ID, A.ELECTRODE_TYPE, ''Lane Number'' AS CATEGORY ' + char(10)
                                SELECT @v_dSql += '             , C.LANE AS VALUE, A.MAX_VER_FLAG, A.MARK, A.PROD_VERSION_TYPE          ' + char(10)
                                SELECT @v_dSql += '             , A.VERSION_TYPE                           ' + char(10)
                                SELECT @v_dSql += '         FROM SCM_ITEM_CONV_CALC_M A WITH(NOLOCK)       ' + char(10)
                                SELECT @v_dSql += '         INNER JOIN BUF_ITEM_CONV_CALC_M B WITH(NOLOCK) ' + char(10)
                                SELECT @v_dSql += '         ON A.COMPANY_ID   = B.COMPANY_ID               ' + char(10)
                                SELECT @v_dSql += '         AND A.DIVISION_ID = B.DIVISION_ID              ' + char(10)
                                SELECT @v_dSql += '         AND A.SITE_ID     = B.SITE_ID                  ' + char(10)
                                SELECT @v_dSql += '         AND A.PLANT_ID    = B.PLANT_ID                 ' + char(10)
                                SELECT @v_dSql += '         AND A.FACTORY_ID  = B.FACTORY_ID               ' + char(10)
                                SELECT @v_dSql += '         AND A.MODEL_ID    = B.MODEL_ID                 ' + char(10)
                                SELECT @v_dSql += '         AND A.OPERATION   = B.OPERATION                ' + char(10)
                                SELECT @v_dSql += '         AND A.ITEM_ID     = B.ITEM_ID                  ' + char(10)
                                SELECT @v_dSql += '         AND A.VERSION     = B.VERSION                  ' + char(10)
                                SELECT @v_dSql += '         AND A.CATEGORY    = B.CATEGORY                 ' + char(10)
                                SELECT @v_dSql += '         AND B.JOB_USER_ID = '''+ @v_user_id +'''       ' + char(10)
                                SELECT @v_dSql += '         LEFT OUTER JOIN (                              ' + char(10)
                                SELECT @v_dSql += '                SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID               ' + char(10)
                                SELECT @v_dSql += ' 			       , A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID                   ' + char(10)
                                SELECT @v_dSql += '                    , A.PROD_VERSION_TYPE, MAX( A.LANE_QTY ) AS LANE        ' + char(10)
                                SELECT @v_dSql += '                FROM SCM_ITEM_LANE_M A                                      ' + char(10)
                                SELECT @v_dSql += '                GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID             ' + char(10)
                                SELECT @v_dSql += ' 			    , A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.PROD_VERSION_TYPE ' + char(10)
                                SELECT @v_dSql += '               ) C                                     ' + char(10)
                                SELECT @v_dSql += '         ON A.COMPANY_ID    = C.COMPANY_ID             ' + char(10)
                                SELECT @v_dSql += '         AND A.DIVISION_ID  = C.DIVISION_ID            ' + char(10)
                                SELECT @v_dSql += '         AND A.SITE_ID      = C.SITE_ID                ' + char(10)
                                SELECT @v_dSql += '         AND A.PLANT_ID     = C.PLANT_ID               ' + char(10)
                                SELECT @v_dSql += '         AND A.FACTORY_ID   = C.FACTORY_ID             ' + char(10)
                                SELECT @v_dSql += '         AND A.ITEM_ID      = C.ITEM_ID                ' + char(10)
                                SELECT @v_dSql += '         AND A.PROD_VERSION_TYPE = C.PROD_VERSION_TYPE ' + char(10)
                                SELECT @v_dSql += ' ) AS B                                                ' + char(10)
                                SELECT @v_dSql += ' ON (A.COMPANY_ID  = B.COMPANY_ID                      ' + char(10)
                                SELECT @v_dSql += ' AND A.FACTORY_ID  = B.FACTORY_ID                      ' + char(10)
                                SELECT @v_dSql += ' AND A.MODEL_ID    = B.MODEL_ID                        ' + char(10)
                                SELECT @v_dSql += ' AND A.VERSION     = B.VERSION                         ' + char(10)
                                SELECT @v_dSql += ' AND A.OPERATION   = B.OPERATION                       ' + char(10)
                                SELECT @v_dSql += ' AND A.ITEM_ID     = B.ITEM_ID                         ' + char(10)
                                SELECT @v_dSql += ' AND A.CATEGORY    = B.CATEGORY                        ' + char(10)
                                SELECT @v_dSql += ' AND A.PROD_VERSION_TYPE    = B.PROD_VERSION_TYPE      ' + char(10)
                                SELECT @v_dSql += ' )                                                     ' + char(10)
                                SELECT @v_dSql += ' WHEN NOT MATCHED THEN                                 ' + char(10)
                                SELECT @v_dSql += '     INSERT (                                          ' + char(10)
                                SELECT @v_dSql += '          COMPANY_ID, DIVISION_ID, SITE_ID             ' + char(10)
                                SELECT @v_dSql += '         , PLANT_ID, FACTORY_ID, MODEL_ID              ' + char(10)
                                SELECT @v_dSql += '         , PJT_CODE, VERSION, OPERATION                ' + char(10)
                                SELECT @v_dSql += '         , ITEM_ID, ELECTRODE_TYPE, CATEGORY           ' + char(10)
                                SELECT @v_dSql += '         , MAX_VER_FLAG, VALUE, MARK                   ' + char(10)
                                SELECT @v_dSql += '         , PROD_VERSION_TYPE, VERSION_TYPE, CREATE_ID  ' + char(10)
                                SELECT @v_dSql += '         , CREATE_TIME, UPDATE_ID, UPDATE_TIME         ' + char(10)
                                SELECT @v_dSql += '         ,APPLY_DATE                                   ' + char(10)
                                SELECT @v_dSql += '     ) VALUES (                                        ' + char(10)
                                SELECT @v_dSql += '           B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID      ' + char(10)
                                SELECT @v_dSql += '         , B.PLANT_ID, B.FACTORY_ID, B.MODEL_ID        ' + char(10)
                                SELECT @v_dSql += '         , B.PJT_CODE, B.VERSION, B.OPERATION          ' + char(10)
                                SELECT @v_dSql += '         , B.ITEM_ID, B.ELECTRODE_TYPE, B.CATEGORY     ' + char(10)
                                SELECT @v_dSql += '         , B.MAX_VER_FLAG, B.VALUE, NULL                            ' + char(10)
                                SELECT @v_dSql += '         , B.PROD_VERSION_TYPE, B.VERSION_TYPE,'''+ @v_user_id +''' ' + char(10)
                                SELECT @v_dSql += '         , dbo.FN_SITE_TIME('''+ @v_site_id +'''), '''+ @v_user_id +''', dbo.FN_SITE_TIME('''+ @v_site_id +''') ' + char(10)
                                SELECT @v_dSql += '         , CONVERT(DATETIME, '''+ @v_site_time +''') ' + char(10)
                                SELECT @v_dSql += '     ) ;                                             ' + char(10)

						   END --'I'
					   /******************************************************************************/
					   /* UPDATE 경우 : UPDATE(UPDATE_MAXVERFLAG)                                    */
					   /******************************************************************************/
					   ELSE IF(@v_sys_flag ='UPDATE_MAXVERFLAG')  
							BEGIN
                                SELECT @v_dSql = ''
                                SELECT @v_dSql += ' UPDATE B                                                              ' + char(10)
                                SELECT @v_dSql += '   SET MAX_VER_FLAG = CASE WHEN A.ROW_NUM =1 THEN ''Y'' ELSE ''N'' END ' + char(10)
                                SELECT @v_dSql += ' FROM [dbo].[SCM_ITEM_CONV_CALC_M] B                                   ' + char(10)
                                SELECT @v_dSql += '     ,( SELECT *                                                       ' + char(10)
                                SELECT @v_dSql += '        FROM (                                                         ' + char(10)
                                SELECT @v_dSql += '              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                      ' + char(10)
                                SELECT @v_dSql += '                  , A.FACTORY_ID, A.MODEL_ID, A.OPERATION, A.ITEM_ID                         ' + char(10)
                                SELECT @v_dSql += '                  , A.VERSION, A.VERSION_TYPE, A.PROD_VERSION_TYPE, A.CH_VERSION             ' + char(10)
                                SELECT @v_dSql += '                  , ROW_NUMBER() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID              ' + char(10)
                                SELECT @v_dSql += ' 				       , A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.MODEL_ID, A.OPERATION       ' + char(10)
                                SELECT @v_dSql += ' 					   , A.ITEM_ID, A.VERSION_TYPE, A.PROD_VERSION_TYPE                     ' + char(10)
                                SELECT @v_dSql += '                     ORDER BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.MODEL_ID ' + char(10)
                                SELECT @v_dSql += ' 					        , A.OPERATION, A.ITEM_ID, A.CH_VERSION DESC ) AS ROW_NUM        ' + char(10)
                                SELECT @v_dSql += '              FROM (                                                                         ' + char(10)
                                SELECT @v_dSql += '                    SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID            ' + char(10)
                                SELECT @v_dSql += '                        , A.FACTORY_ID, A.MODEL_ID, A.OPERATION, A.ITEM_ID                        ' + char(10)
                                SELECT @v_dSql += '                        , A.VERSION, A.VERSION_TYPE, A.PROD_VERSION_TYPE                          ' + char(10)
                                SELECT @v_dSql += '                        , CASE WHEN A.VERSION LIKE ''Z%'' THEN REPLACE( A.VERSION, ''Z'', ''/'')  ' + char(10)
								SELECT @v_dSql += '                              WHEN A.VERSION LIKE ''X%'' THEN REPLACE( A.VERSION, ''X'', ''/'')  ' + char(10) -- x 버전 조건 추가... 20230925
                                SELECT @v_dSql += '                              WHEN A.VERSION LIKE ''%W'' THEN REPLACE( A.VERSION, ''W'', ''0'')   ' + char(10)
                                SELECT @v_dSql += '                              WHEN A.VERSION LIKE ''%P'' THEN REPLACE( A.VERSION, ''P'', ''0'')   ' + char(10)
                                SELECT @v_dSql += '                              WHEN A.VERSION LIKE ''%P2'' THEN REPLACE( A.VERSION, ''P2'', ''0'') ' + char(10)
                                SELECT @v_dSql += '                              WHEN A.VERSION LIKE ''%P3'' THEN REPLACE( A.VERSION, ''P3'', ''0'') ' + char(10)
                                SELECT @v_dSql += '                              ELSE A.VERSION END AS CH_VERSION     ' + char(10)
                                SELECT @v_dSql += '                    FROM SCM_ITEM_CONV_CALC_M A WITH(NOLOCK)       ' + char(10)
                                SELECT @v_dSql += '                    INNER JOIN BUF_ITEM_CONV_CALC_M B WITH(NOLOCK) ' + char(10)
                                SELECT @v_dSql += '                    ON A.DIVISION_ID = B.DIVISION_ID               ' + char(10)
                                SELECT @v_dSql += '                    AND A.SITE_ID    = B.SITE_ID                   ' + char(10)
                                SELECT @v_dSql += '                    AND A.PLANT_ID   = B.PLANT_ID                  ' + char(10)
                                SELECT @v_dSql += '                    AND A.FACTORY_ID = B.FACTORY_ID                ' + char(10)
                                SELECT @v_dSql += '                    AND A.MODEL_ID   = B.MODEL_ID                  ' + char(10)
                                SELECT @v_dSql += '                    AND A.OPERATION  = B.OPERATION                 ' + char(10)
                                SELECT @v_dSql += '                    AND A.ITEM_ID    = B.ITEM_ID                   ' + char(10)
                                SELECT @v_dSql += '                    AND B.JOB_USER_ID = '''+ @v_user_id +'''       ' + char(10)
                                SELECT @v_dSql += '              	  ) A                           ' + char(10)
                                SELECT @v_dSql += '        	 ) A                                    ' + char(10)
                                SELECT @v_dSql += '     ) A                                         ' + char(10)
                                SELECT @v_dSql += ' WHERE A.COMPANY_ID  = B.COMPANY_ID              ' + char(10)
                                SELECT @v_dSql += '   AND A.DIVISION_ID = B.DIVISION_ID             ' + char(10)
                                SELECT @v_dSql += '   AND A.SITE_ID     = B.SITE_ID                 ' + char(10)
                                SELECT @v_dSql += '   AND A.PLANT_ID    = B.PLANT_ID                ' + char(10)
                                SELECT @v_dSql += '   AND A.FACTORY_ID  = B.FACTORY_ID              ' + char(10)
                                SELECT @v_dSql += '   AND A.MODEL_ID    = B.MODEL_ID                ' + char(10)
                                SELECT @v_dSql += '   AND A.OPERATION   = B.OPERATION               ' + char(10)
                                SELECT @v_dSql += '   AND A.ITEM_ID     = B.ITEM_ID                 ' + char(10)
                                SELECT @v_dSql += '   AND A.VERSION     = B.VERSION                 ' + char(10)
                                SELECT @v_dSql += '   AND A.PROD_VERSION_TYPE = B.PROD_VERSION_TYPE ' + char(10)

						   END --'I'
					   /******************************************************************************/
					   /* UPDATE 경우 : UPDATE(UPDATE_PANCAKE_M_BATCH)                               */
					   /******************************************************************************/
					   ELSE IF(@v_sys_flag ='UPDATE_PANCAKE_M_BATCH')  
							BEGIN
                                SELECT @v_dSql = ''

                                SELECT @v_dSql += ' MERGE INTO SCM_ITEM_CONV_CALC_M AS A ' + char(10)
                                SELECT @v_dSql += ' USING (                              ' + char(10)
                                SELECT @v_dSql += '        SELECT A.*, ''Pancake (m/batch)'' AS CATEGORY, (A.VALUE_A * A.VALUE_B) AS VALUE ' + char(10)
                                SELECT @v_dSql += '        FROM (                                                                     ' + char(10)
                                SELECT @v_dSql += '              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID            ' + char(10)
                                SELECT @v_dSql += '                  , A.FACTORY_ID,A.MODEL_ID, A.PJT_CODE,A.VERSION                  ' + char(10)
                                SELECT @v_dSql += '                  , A.OPERATION, A.ITEM_ID,MAX(A.ELECTRODE_TYPE) AS ELECTRODE_TYPE ' + char(10)
                                SELECT @v_dSql += '                  ,MAX(CASE WHEN A.CATEGORY = ''Jumbo Roll (m/batch)'' THEN A.VALUE' + char(10)
                                SELECT @v_dSql += '                       ELSE NULL END) AS VALUE_A                                   ' + char(10)
                                SELECT @v_dSql += '                  ,MAX(CASE WHEN A.CATEGORY = ''Lane Number'' THEN                 ' + char(10)
                                SELECT @v_dSql += '                            ( CASE WHEN A.VALUE>0 THEN A.VALUE ELSE NULL END)      ' + char(10)
                                SELECT @v_dSql += '                       ELSE NULL END) AS VALUE_B                                   ' + char(10)
                                SELECT @v_dSql += '                  ,A.MAX_VER_FLAG, A.PROD_VERSION_TYPE, A.VERSION_TYPE             ' + char(10)
                                SELECT @v_dSql += '                  ,( CASE WHEN MAX(ISNULL(A.APPLY_DATE,'''')) = '''' THEN NULL     ' + char(10) 
                                SELECT @v_dSql += '                     ELSE MAX(ISNULL(A.APPLY_DATE,'''')) END) AS APPLY_DATE        ' + char(10)
                                SELECT @v_dSql += '              FROM (                                                               ' + char(10)
                                SELECT @v_dSql += '                  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID        ' + char(10)
                                SELECT @v_dSql += '                      , A.FACTORY_ID,A.MODEL_ID, MAX(A.PJT_CODE) AS PJT_CODE       ' + char(10)
                                SELECT @v_dSql += '                      ,MAX(A.VERSION) AS VERSION, A.OPERATION, A.ITEM_ID           ' + char(10)
                                SELECT @v_dSql += '                      ,MAX(A.ELECTRODE_TYPE) AS ELECTRODE_TYPE, A.CATEGORY         ' + char(10)
                                SELECT @v_dSql += '                      ,MAX(A.VALUE) AS VALUE,''Y'' AS MAX_VER_FLAG                 ' + char(10)
                                SELECT @v_dSql += '                      , A.PROD_VERSION_TYPE, A.VERSION_TYPE                        ' + char(10)
                                SELECT @v_dSql += '                      ,( CASE WHEN MAX(ISNULL(A.APPLY_DATE,'''')) = '''' THEN NULL ' + char(10)
                                SELECT @v_dSql += '                         ELSE MAX(ISNULL(A.APPLY_DATE,'''')) END) AS APPLY_DATE    ' + char(10)
                                SELECT @v_dSql += '                  FROM (           ' + char(10)
                                SELECT @v_dSql += '                        SELECT A.* ' + char(10)
                                SELECT @v_dSql += '                            , ROW_NUMBER() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID    ' + char(10)
                                SELECT @v_dSql += '                                              , A.FACTORY_ID, A.MODEL_ID, A.OPERATION, A.ITEM_ID                    ' + char(10)
                                SELECT @v_dSql += '                                              , A.CATEGORY, A.PROD_VERSION_TYPE, A.VERSION_TYPE                     ' + char(10)
                                SELECT @v_dSql += '                                        ORDER BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                 ' + char(10)
                                SELECT @v_dSql += '                                              , A.MODEL_ID, A.OPERATION, A.ITEM_ID, A.CATEGORY, A.PROD_VERSION_TYPE ' + char(10)
                                SELECT @v_dSql += '                                              , A.VERSION_TYPE, A.CH_VERSION DESC ) AS ROW_NUM                      ' + char(10)
                                SELECT @v_dSql += '                        FROM (           ' + char(10)
                                SELECT @v_dSql += '                              SELECT A.* ' + char(10)
                                SELECT @v_dSql += '                                 , (CASE WHEN A.VERSION LIKE ''Z%'' THEN REPLACE( A.VERSION, ''Z'', ''/'') ' + char(10)
                                SELECT @v_dSql += '                                    ELSE A.VERSION END) AS CH_VERSION ' + char(10)
                                SELECT @v_dSql += '                              FROM   SCM_ITEM_CONV_CALC_M A           ' + char(10)
                                SELECT @v_dSql += '                              WHERE  A.MAX_VER_FLAG = ''Y''           ' + char(10)
                                SELECT @v_dSql += '                              AND    A.CATEGORY IN (''Jumbo Roll (m/batch)'',''Lane Number'') ' + char(10)
                                SELECT @v_dSql += '                        ) A           ' + char(10)
                                SELECT @v_dSql += '                  ) A                 ' + char(10)
                                SELECT @v_dSql += '                  WHERE A.ROW_NUM = 1 ' + char(10)
                                SELECT @v_dSql += '                  GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION ' + char(10)
                                SELECT @v_dSql += '                        , A.MODEL_ID, A.ITEM_ID, A.CATEGORY, A.PROD_VERSION_TYPE, A.VERSION_TYPE         ' + char(10)
                                SELECT @v_dSql += '              ) A                                                         ' + char(10)
                                SELECT @v_dSql += '              GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
                                SELECT @v_dSql += '                  , A.FACTORY_ID,A.MODEL_ID, A.PJT_CODE,A.VERSION         ' + char(10)
                                SELECT @v_dSql += '                  , A.OPERATION, A.ITEM_ID,  A.MAX_VER_FLAG               ' + char(10)
                                SELECT @v_dSql += '                  , A.PROD_VERSION_TYPE, A.VERSION_TYPE                   ' + char(10)
                                SELECT @v_dSql += '        ) A                         ' + char(10)
                                SELECT @v_dSql += '        WHERE A.VALUE_A IS NOT NULL ' + char(10)
                                SELECT @v_dSql += '        AND   A.VALUE_B IS NOT NULL ' + char(10)
                                SELECT @v_dSql += ' ) AS B                             ' + char(10)
                                SELECT @v_dSql += ' ON (A.COMPANY_ID  = B.COMPANY_ID   ' + char(10)
                                SELECT @v_dSql += ' AND A.FACTORY_ID  = B.FACTORY_ID   ' + char(10)
                                SELECT @v_dSql += ' AND A.MODEL_ID    = B.MODEL_ID     ' + char(10)
                                SELECT @v_dSql += ' AND A.VERSION     = B.VERSION      ' + char(10)
                                SELECT @v_dSql += ' AND A.OPERATION   = B.OPERATION    ' + char(10)
                                SELECT @v_dSql += ' AND A.ITEM_ID     = B.ITEM_ID      ' + char(10)
                                SELECT @v_dSql += ' AND A.CATEGORY    = B.CATEGORY     ' + char(10)
                                SELECT @v_dSql += ' AND A.PROD_VERSION_TYPE    = B.PROD_VERSION_TYPE )           ' + char(10)
                                SELECT @v_dSql += ' WHEN MATCHED THEN                                            ' + char(10)
                                SELECT @v_dSql += '     UPDATE SET  UPDATE_ID   = '''+ @v_user_id +'''           ' + char(10)
                                SELECT @v_dSql += '        ,UPDATE_TIME = dbo.FN_SITE_TIME('''+ @v_site_id +''') ' + char(10)
                                SELECT @v_dSql += '        ,VALUE       = B.VALUE ' + char(10)
                                SELECT @v_dSql += ' WHEN NOT MATCHED THEN         ' + char(10)
                                SELECT @v_dSql += '     INSERT (                  ' + char(10)
                                SELECT @v_dSql += '        COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID    ' + char(10)
                                SELECT @v_dSql += '       , FACTORY_ID, MODEL_ID, PJT_CODE, VERSION      ' + char(10)
                                SELECT @v_dSql += '       , OPERATION, ITEM_ID, ELECTRODE_TYPE, CATEGORY ' + char(10)
                                SELECT @v_dSql += '       , MAX_VER_FLAG, VALUE, MARK, PROD_VERSION_TYPE ' + char(10)
                                SELECT @v_dSql += '       , VERSION_TYPE, CREATE_ID, CREATE_TIME         ' + char(10)
                                SELECT @v_dSql += '       , UPDATE_ID, UPDATE_TIME, APPLY_DATE           ' + char(10)
                                SELECT @v_dSql += '     ) VALUES (                                       ' + char(10)
                                SELECT @v_dSql += '        B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID    ' + char(10)
                                SELECT @v_dSql += '       , B.FACTORY_ID, B.MODEL_ID, B.PJT_CODE, B.VERSION      ' + char(10)
                                SELECT @v_dSql += '       , B.OPERATION, B.ITEM_ID, B.ELECTRODE_TYPE, B.CATEGORY ' + char(10)
                                SELECT @v_dSql += '       , B.MAX_VER_FLAG, B.VALUE, NULL, B.PROD_VERSION_TYPE   ' + char(10)
                                SELECT @v_dSql += '       , B.VERSION_TYPE, '''+ @v_user_id +''', dbo.FN_SITE_TIME('''+ @v_site_id +''') ' + char(10)
                                SELECT @v_dSql += '       , '''+ @v_user_id +''', dbo.FN_SITE_TIME('''+ @v_site_id +'''), B.APPLY_DATE   ' + char(10)
                                SELECT @v_dSql += '   ); ' + char(10)

						   END --'I'
					   /******************************************************************************/
					   /* UPDATE 경우 : UPDATE(UPDATE_PANCAKE_CELL_M)                                */
					   /******************************************************************************/
					   ELSE IF(@v_sys_flag ='UPDATE_PANCAKE_CELL_M')  
							BEGIN
                                SELECT @v_dSql = ''
                                SELECT @v_dSql += ' MERGE INTO SCM_ITEM_CONV_CALC_M AS A ' + char(10)
                                SELECT @v_dSql += ' USING (                                             ' + char(10)
                                SELECT @v_dSql += '        SELECT A.*, ''Pancake (cell/m)'' AS CATEGORY ' + char(10)
                                SELECT @v_dSql += '            , (A.VALUE_A / A.VALUE_B) AS VALUE       ' + char(10)
                                SELECT @v_dSql += '        FROM (                                              ' + char(10)
                                SELECT @v_dSql += '              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID ' + char(10)
                                SELECT @v_dSql += '              , A.PLANT_ID, A.FACTORY_ID, A.MODEL_ID        ' + char(10)
                                SELECT @v_dSql += '              , A.PJT_CODE, A.VERSION, A.OPERATION          ' + char(10)
                                SELECT @v_dSql += '              , A.ITEM_ID, MAX(A.ELECTRODE_TYPE) AS ELECTRODE_TYPE         ' + char(10)
                                SELECT @v_dSql += '              , MAX(CASE WHEN A.CATEGORY = ''Jumbo Roll (cell/m)''         ' + char(10)
                                SELECT @v_dSql += '                         THEN A.VALUE ELSE NULL END) AS VALUE_A            ' + char(10)
                                SELECT @v_dSql += '              , MAX(CASE WHEN A.CATEGORY = ''Lane Number'' THEN            ' + char(10)
                                SELECT @v_dSql += '                        (CASE WHEN A.VALUE>0 THEN A.VALUE ELSE NULL END)   ' + char(10)
                                SELECT @v_dSql += '                    ELSE NULL END) AS VALUE_B                              ' + char(10)
                                SELECT @v_dSql += '              , A.MAX_VER_FLAG, A.PROD_VERSION_TYPE, A.VERSION_TYPE        ' + char(10)
                                SELECT @v_dSql += '              , (CASE WHEN MAX(ISNULL(A.APPLY_DATE,'''')) = '''' THEN NULL ' + char(10)
                                SELECT @v_dSql += '                 ELSE MAX(ISNULL(A.APPLY_DATE,'''')) END) AS APPLY_DATE    ' + char(10)
                                SELECT @v_dSql += '              FROM (                                                       ' + char(10)
                                SELECT @v_dSql += '                    SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID       ' + char(10)
                                SELECT @v_dSql += '                        , A.FACTORY_ID,A.MODEL_ID, MAX(A.PJT_CODE) AS PJT_CODE      ' + char(10)
                                SELECT @v_dSql += '                        ,MAX(A.VERSION) AS VERSION, A.OPERATION, A.ITEM_ID          ' + char(10)
                                SELECT @v_dSql += '                        ,MAX(A.ELECTRODE_TYPE) AS ELECTRODE_TYPE, A.CATEGORY        ' + char(10)
                                SELECT @v_dSql += '                        ,MAX(A.VALUE) AS VALUE, ''Y'' AS MAX_VER_FLAG               ' + char(10)
                                SELECT @v_dSql += '                        , A.PROD_VERSION_TYPE, A.VERSION_TYPE                       ' + char(10)
                                SELECT @v_dSql += '                        ,(CASE WHEN MAX(ISNULL(A.APPLY_DATE,'''')) = '''' THEN NULL ' + char(10)
                                SELECT @v_dSql += '                           ELSE MAX(ISNULL(A.APPLY_DATE,'''')) END) AS APPLY_DATE   ' + char(10)
                                SELECT @v_dSql += '                    FROM (                                                          ' + char(10)
                                SELECT @v_dSql += '                          SELECT A.*                                                ' + char(10)
                                SELECT @v_dSql += '                              , ROW_NUMBER() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID    ' + char(10)
                                SELECT @v_dSql += '                                        , A.PLANT_ID, A.FACTORY_ID, A.MODEL_ID, A.OPERATION, A.ITEM_ID    ' + char(10)
                                SELECT @v_dSql += '                                        , A.CATEGORY, A.PROD_VERSION_TYPE, A.VERSION_TYPE                 ' + char(10)
                                SELECT @v_dSql += '                                    ORDER BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID           ' + char(10)
                                SELECT @v_dSql += '                                    , A.MODEL_ID, A.OPERATION, A.ITEM_ID, A.CATEGORY, A.PROD_VERSION_TYPE ' + char(10)
                                SELECT @v_dSql += '                                    , A.VERSION_TYPE, A.CH_VERSION DESC ) AS ROW_NUM ' + char(10)
                                SELECT @v_dSql += '                          FROM (                                                     ' + char(10)
                                SELECT @v_dSql += '                                SELECT A.*                                           ' + char(10)
                                SELECT @v_dSql += '                                    , ( CASE WHEN A.VERSION LIKE ''Z%'' THEN REPLACE( A.VERSION, ''Z'', ''/'') ' + char(10)
                                SELECT @v_dSql += '                                        ELSE A.VERSION END) AS CH_VERSION                      ' + char(10)
                                SELECT @v_dSql += '                                FROM   SCM_ITEM_CONV_CALC_M A                                  ' + char(10)
                                SELECT @v_dSql += '                                WHERE  A.MAX_VER_FLAG = ''Y''                                  ' + char(10)
                                SELECT @v_dSql += '                                AND    A.CATEGORY IN (''Jumbo Roll (cell/m)'',''Lane Number'') ' + char(10)
                                SELECT @v_dSql += '                          ) A           ' + char(10)
                                SELECT @v_dSql += '                    ) A                 ' + char(10)
                                SELECT @v_dSql += '                    WHERE A.ROW_NUM = 1 ' + char(10)
                                SELECT @v_dSql += '                    GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION ' + char(10)
                                SELECT @v_dSql += '                           , A.MODEL_ID, A.ITEM_ID, A.CATEGORY, A.PROD_VERSION_TYPE, A.VERSION_TYPE        ' + char(10)
                                SELECT @v_dSql += '              ) A                                                                       ' + char(10)
                                SELECT @v_dSql += '              GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
                                SELECT @v_dSql += '                  ,A.MODEL_ID, A.PJT_CODE,A.VERSION, A.OPERATION, A.ITEM_ID             ' + char(10)
                                SELECT @v_dSql += '                  ,A.ELECTRODE_TYPE,A.MAX_VER_FLAG, A.PROD_VERSION_TYPE, A.VERSION_TYPE ' + char(10)
                                SELECT @v_dSql += '        ) A                         ' + char(10)
                                SELECT @v_dSql += '        WHERE A.VALUE_A IS NOT NULL ' + char(10)
                                SELECT @v_dSql += '        AND   A.VALUE_B IS NOT NULL ' + char(10)
                                SELECT @v_dSql += ' ) AS B                             ' + char(10)
                                SELECT @v_dSql += ' ON (A.COMPANY_ID  = B.COMPANY_ID   ' + char(10)
                                SELECT @v_dSql += ' AND A.FACTORY_ID  = B.FACTORY_ID   ' + char(10)
                                SELECT @v_dSql += ' AND A.MODEL_ID    = B.MODEL_ID     ' + char(10)
                                SELECT @v_dSql += ' AND A.VERSION     = B.VERSION      ' + char(10)
                                SELECT @v_dSql += ' AND A.OPERATION   = B.OPERATION    ' + char(10)
                                SELECT @v_dSql += ' AND A.ITEM_ID     = B.ITEM_ID      ' + char(10)
                                SELECT @v_dSql += ' AND A.CATEGORY    = B.CATEGORY     ' + char(10)
                                SELECT @v_dSql += ' AND A.PROD_VERSION_TYPE    = B.PROD_VERSION_TYPE )            ' + char(10)
                                SELECT @v_dSql += ' WHEN MATCHED THEN                                             ' + char(10)
                                SELECT @v_dSql += '      UPDATE SET UPDATE_ID   = '''+ @v_user_id +'''            ' + char(10)
                                SELECT @v_dSql += '        , UPDATE_TIME = dbo.FN_SITE_TIME('''+ @v_site_id +''') ' + char(10)
                                SELECT @v_dSql += '        , VALUE       = B.VALUE                        ' + char(10)
                                SELECT @v_dSql += ' WHEN NOT MATCHED THEN                                 ' + char(10)
                                SELECT @v_dSql += '      INSERT (                                         ' + char(10)
                                SELECT @v_dSql += '         COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID    ' + char(10)
                                SELECT @v_dSql += '        , FACTORY_ID, MODEL_ID, PJT_CODE, VERSION      ' + char(10)
                                SELECT @v_dSql += '        , OPERATION, ITEM_ID, ELECTRODE_TYPE, CATEGORY ' + char(10)
                                SELECT @v_dSql += '        , MAX_VER_FLAG, VALUE, MARK, PROD_VERSION_TYPE ' + char(10)
                                SELECT @v_dSql += '        , VERSION_TYPE, CREATE_ID, CREATE_TIME         ' + char(10)
                                SELECT @v_dSql += '        , UPDATE_ID, UPDATE_TIME, APPLY_DATE           ' + char(10)
                                SELECT @v_dSql += '      ) VALUES (                                       ' + char(10)
                                SELECT @v_dSql += '         B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID    ' + char(10)
                                SELECT @v_dSql += '        , B.FACTORY_ID, B.MODEL_ID, B.PJT_CODE, B.VERSION      ' + char(10)
                                SELECT @v_dSql += '        , B.OPERATION, B.ITEM_ID, B.ELECTRODE_TYPE, B.CATEGORY ' + char(10)
                                SELECT @v_dSql += '        , B.MAX_VER_FLAG, B.VALUE, NULL, B.PROD_VERSION_TYPE   ' + char(10)
                                SELECT @v_dSql += '        , B.VERSION_TYPE, '''+ @v_user_id +''', dbo.FN_SITE_TIME('''+ @v_site_id +''') ' + char(10)
                                SELECT @v_dSql += '        , '''+ @v_user_id +''', dbo.FN_SITE_TIME('''+ @v_site_id +'''), B.APPLY_DATE   ' + char(10)
                                SELECT @v_dSql += '      ); ' + char(10)

						   END --'I'

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

