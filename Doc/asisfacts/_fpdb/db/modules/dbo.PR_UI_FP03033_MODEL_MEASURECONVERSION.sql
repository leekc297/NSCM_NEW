

/*
 * Program ID   : PR_UI_FP03033_MODEL_MEASURECONVERSION
 * Description  : Model Measure Conversion
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/06/09   JYJ				Initial Release UI통합
 * 2022/04/11   LJS             관리자ID 추가 및 ESNA 제외
 * 2025/08/10   OIJ             [IT20250117A]구코드 => 신코드로 변경
 * 2026/10/01   SYS             [E20260928-000085]FP - PDS 라인별 전극 환산자 적용건 - 조회 UI 변경
 */

CREATE PROCEDURE [dbo].[PR_UI_FP03033_MODEL_MEASURECONVERSION]
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
  @p_job_type   			    NVARCHAR(MAX),
  @p_line			            NVARCHAR(MAX) = ''

AS 
BEGIN  --MAIN
 
print 'BEGIN Query block: ' + CONVERT(varchar,GETDATE(),14);
DECLARE @InitTime AS DATETIME ;
DECLARE @StartTime AS DATETIME ;
DECLARE @PrintTime AS DATETIME ;
SET @InitTime = GETDATE();
SET @StartTime = @InitTime;
set @InitTime = @StartTime;

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
	DECLARE @v_proc_name	        NVARCHAR(100) = 'PR_UI_FP03033_MODEL_MEASURECONVERSION'
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

	SET @recv_active_flag       = NULL	
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

	
--DECLARE @PARAMS NVARCHAR(MAX)

--SET @PARAMS = ''
--SET @PARAMS += '  @P_SYS_TYPE			= ''' +ISNULL(@P_SYS_TYPE		,'')	+ '''' + CHAR(10)
--SET @PARAMS += ', @P_SYS_FLAG			= ''' +ISNULL(@P_SYS_FLAG		,'')	+ '''' + CHAR(10)
--SET @PARAMS += ', @P_SYS_GUBUN		= ''' +ISNULL(@P_SYS_GUBUN		,'')	+ '''' + CHAR(10)
--SET @PARAMS += ', @P_USER_ID			= ''' +ISNULL(@P_USER_ID		,'')	+ '''' + CHAR(10)
--SET @PARAMS += ', @P_COMPANY_ID		= ''' +ISNULL(@P_COMPANY_ID		,'')	+ '''' + CHAR(10)
--SET @PARAMS += ', @P_DIVISION_ID		= ''' +ISNULL(@P_DIVISION_ID		,'')	+ '''' + CHAR(10)
--SET @PARAMS += ', @P_SITE_ID			= ''' +ISNULL(@P_SITE_ID			,'')	+ '''' + CHAR(10)
--SET @PARAMS += ', @P_PLANT_ID			= ''' +ISNULL(@P_PLANT_ID			,'')	+ '''' + CHAR(10)
--SET @PARAMS += ', @P_FACTORY_ID		= ''' +ISNULL(@P_FACTORY_ID		,'')	+ '''' + CHAR(10)
--SET @PARAMS += ', @P_MODEL_ID			= ''' +ISNULL(@P_MODEL_ID			,'')	+ '''' + CHAR(10)
--SET @PARAMS += ', @P_PJT_CODE			= ''' +ISNULL(@P_PJT_CODE			,'')	+ '''' + CHAR(10)
--SET @PARAMS += ', @P_VERSION_TYPE		= ''' +ISNULL(@P_VERSION_TYPE		,'')	+ '''' + CHAR(10)
--SET @PARAMS += ', @P_VERSION			= ''' +ISNULL(@P_VERSION			,'')	+ '''' + CHAR(10)
--SET @PARAMS += ', @P_PROD_YN     		= ''' +ISNULL(@P_PROD_YN     		,'')	+ '''' + CHAR(10)       
--SET @PARAMS += ', @P_OPERATION_ID		= ''' +ISNULL(@P_OPERATION_ID		,'')	+ '''' + CHAR(10)
--SET @PARAMS += ', @P_ITEM_ID			= ''' +ISNULL(@P_ITEM_ID			,'')	+ '''' + CHAR(10)
--SET @PARAMS += ', @P_ELECTRODE_TYPE	= ''' +ISNULL(@P_ELECTRODE_TYPE	,'')	+ '''' + CHAR(10)
--SET @PARAMS += ', @P_CATEGORY_ID		= ''' +ISNULL(@P_CATEGORY_ID		,'')	+ '''' + CHAR(10)
--SET @PARAMS += ', @P_VALUE  			= ''' +ISNULL(@P_VALUE  			,'')	+ '''' + CHAR(10)
--SET @PARAMS += ', @P_PROD_VER_TYPE	= ''' +ISNULL(@P_PROD_VER_TYPE	,'')	+ '''' + CHAR(10)
--SET @PARAMS += ', @P_MAX_VERSION		= ''' +ISNULL(@P_MAX_VERSION		,'')	+ '''' + CHAR(10)
--SET @PARAMS += ', @P_MARK				= ''' +ISNULL(@P_MARK				 ,'')	+ '''' + CHAR(10)
--SET @PARAMS += ', @P_ORG_VERSION		= ''' +ISNULL(@P_ORG_VERSION		,'')	+ '''' + CHAR(10)
--SET @PARAMS += ', @P_JOB_TYPE   		= ''' +ISNULL(@P_JOB_TYPE   		,'')	+ '''' + CHAR(10)


--IF @P_SYS_TYPE = 'SQL' BEGIN
--	SELECT @PARAMS AS SQL
--	RETURN
--END


	/************************************************************************************************/
	/* SELECT인경우 :SELECT(SELECT)                                                                 */
	/************************************************************************************************/
    IF(@p_sys_flag ='SELECT_MAIN')
        BEGIN --IF(START)
            SELECT @v_dSql = ''
            /*SELECT @v_dSql += ' SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                           ' + char(10)
            SELECT @v_dSql += '     , A.MODEL_ID, A.PJT_CODE, A.VERSION, A.OPERATION, A.ITEM_ID                                   ' + char(10)
            SELECT @v_dSql += '     , NULL AS ELECTRODE_TYPE, MAX(A.MARK) AS MARK, A.MAX_VER_FLAG , A.VERSION_TYPE                ' + char(10)
            SELECT @v_dSql += '     , A.PROD_VERSION_TYPE , A.PROD_YN, MAX(A.APPLY_DATE) AS APPLY_DATE                            ' + char(10)
            SELECT @v_dSql += '     , MAX(CASE WHEN A.CATEGORY = ''cell/batch'' THEN A.VALUE ELSE 0 END) AS CELL_BATCH            ' + char(10)
            SELECT @v_dSql += '     , MAX(CASE WHEN A.CATEGORY = ''Jumbo Roll (cell/m)'' THEN A.VALUE ELSE 0 END) AS CELL_JUMBO   ' + char(10)
            SELECT @v_dSql += '     , MAX(CASE WHEN A.CATEGORY = ''Jumbo Roll (m/batch)'' THEN A.VALUE ELSE 0 END) AS JUMBO_BATCH ' + char(10)
            SELECT @v_dSql += '     , MAX(CASE WHEN A.CATEGORY = ''Lane Number'' THEN CONVERT(NUMERIC(18,5),A.VALUE) ELSE 0 END) AS LANE_NUMBER ' + char(10)
            SELECT @v_dSql += '     , MAX(CASE WHEN A.CATEGORY = ''Pancake (cell/m)'' THEN A.VALUE ELSE 0 END) AS CELL_M          ' + char(10)
            SELECT @v_dSql += '     , MAX(CASE WHEN A.CATEGORY = ''Pancake (m/batch)'' THEN A.VALUE ELSE 0 END) AS M_BATCH        ' + char(10)
            SELECT @v_dSql += '     , A.EDIT_YN                                                         ' + char(10)
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
            SELECT @v_dSql += '               '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))       + char(10)
            SELECT @v_dSql += '               '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))               + char(10)
            SELECT @v_dSql += '               '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))             + char(10)
            SELECT @v_dSql += '               '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))         + char(10)
            SELECT @v_dSql += '               '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION' , 'EQ', @p_operation_id))     + char(10)
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
	        	    SELECT @v_dSql += '     AND    A.PJT_CODE LIKE ''%'+ @p_pjt_code +'%'' ' + char(10)
	        	END
            SELECT @v_dSql += '     ) A                                                                         ' + char(10)
            SELECT @v_dSql += ' GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID       ' + char(10)
            SELECT @v_dSql += '     , A.MODEL_ID, A.PJT_CODE, A.VERSION, A.OPERATION, A.ITEM_ID                 ' + char(10)
            SELECT @v_dSql += '     , A.MAX_VER_FLAG, A.VERSION_TYPE, A.PROD_VERSION_TYPE, A.PROD_YN, A.EDIT_YN ' + char(10)
            SELECT @v_dSql += ' ORDER BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.MODEL_ID         ' + char(10)
            SELECT @v_dSql += '     , A.OPERATION, A.ITEM_ID, A.VERSION_TYPE                                    ' + char(10)
            SELECT @v_dSql += '     , CASE WHEN A.VERSION LIKE ''Z%'' THEN REPLACE( A.VERSION, ''Z'', ''/'') ELSE A.VERSION END ' + char(10)
			*/
			
			SELECT @v_dsql += 'IF OBJECT_ID(''TEMPDB..#Temp01'') IS NOT NULL DROP TABLE #Temp01;' + char(10)
			SELECT @v_dsql += 'SELECT *' + char(10)
			SELECT @v_dsql += 'INTO #Temp01' + char(10)
			SELECT @v_dsql += 'FROM (' + char(10)
			SELECT @v_dsql += '	select  N.COMPANY_ID, N.DIVISION_ID, N.SITE_ID, N.PLANT_ID, N.FACTORY_ID, N.MODEL_ID, N.PJT_CODE, N.VERSION, N.OPERATION, N.ITEM_ID' + char(10)
			SELECT @v_dsql += '		,N.ELECTRODE_TYPE, N.CATEGORY, N.VALUE, N.MARK, N.MAX_VER_FLAG, N.VERSION_TYPE, N.ROW_NUM, N.PROD_VERSION_TYPE, N.PROD_YN, N.APPLY_DATE, N.EDIT_YN		 ' + char(10)
            SELECT @v_dsql += '		,N.PDS_VERSION	, N.DATA_SRCE_CD ' + char(10)--[E20260928-000085]FP - PDS 라인별 전극 환산자 적용건 - 조회 UI 변경
			SELECT @v_dsql += '	from (' + char(10)
			SELECT @v_dsql += '		SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID' + char(10)
			SELECT @v_dsql += '			, A.FACTORY_ID, A.MODEL_ID, D.NICK_NAME AS PJT_CODE, A.VERSION' + char(10)
			SELECT @v_dsql += '			, A.OPERATION, A.ITEM_ID, A.ELECTRODE_TYPE, A.CATEGORY' + char(10)
			SELECT @v_dsql += '			, A.VALUE, A.MARK, A.MAX_VER_FLAG, A.VERSION_TYPE' + char(10)
			SELECT @v_dsql += '			, DENSE_RANK( ) OVER( PARTITION BY A.FACTORY_ID, A.MODEL_ID, A.OPERATION, A.ITEM_ID ORDER BY A.FACTORY_ID, A.MODEL_ID, A.OPERATION, A.ITEM_ID, A.VERSION ) AS ROW_NUM' + char(10)
			SELECT @v_dsql += '			, A.PROD_VERSION_TYPE' + char(10)
			SELECT @v_dsql += '			, CASE ' + char(10)
			SELECT @v_dsql += '				WHEN E.ROW_CNT IS NULL THEN ''N''' + char(10)
			SELECT @v_dsql += '				WHEN E.ROW_CNT = 1     THEN ''R''' + char(10)
			SELECT @v_dsql += '				WHEN E.ROW_CNT = 2     THEN ''W'' ' + char(10)
			SELECT @v_dsql += '				ELSE ''N'' END PROD_YN' + char(10)
			SELECT @v_dsql += '			, CONVERT(VARCHAR,A.APPLY_DATE,20) AS APPLY_DATE' + char(10)
			SELECT @v_dsql += '			, (CASE WHEN R.FACTORY_ID IS NULL THEN ''N'' ELSE ''Y'' END) AS EDIT_YN' + char(10)
            SELECT @v_dsql += '  , A.PDS_VERSION, A.DATA_SRCE_CD' + char(10)--[E20260928-000085]FP - PDS 라인별 전극 환산자 적용건 - 조회 UI 변경
			SELECT @v_dsql += '		FROM   SCM_ITEM_CONV_CALC_M A WITH(NOLOCK)' + char(10)
			SELECT @v_dsql += '			INNER JOIN (' + char(10)
			SELECT @v_dsql += '				SELECT DISTINCT A.ATTRIBUTE1 AS E_CATEGORY' + char(10)
			SELECT @v_dsql += '				FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)' + char(10)
			SELECT @v_dsql += '				WHERE  A.LOOKUP_TYPE_CODE = ''ITEM_CONV_CALC'' AND A.ATTRIBUTE2 = ''Y''' + char(10)
			SELECT @v_dsql += '				) C ON  A.CATEGORY = C.E_CATEGORY' + char(10)
			SELECT @v_dsql += '			LEFT OUTER JOIN SCM_ITEM_M D WITH(NOLOCK) ON  A.COMPANY_ID = D.COMPANY_ID AND A.DIVISION_ID = D.DIVISION_ID AND A.SITE_ID = D.SITE_ID AND A.MODEL_ID = D.ITEM_ID' + char(10)
			SELECT @v_dsql += '			LEFT OUTER JOIN (' + char(10)
			SELECT @v_dsql += '					SELECT DISTINCT A.SEGMENT2 AS DIVISION_ID, A.SEGMENT1 AS SITE_ID, A.SEGMENT3 AS PLANT_ID, A.SEGMENT4 AS FACTORY_ID' + char(10)
			SELECT @v_dsql += '						, COUNT(*) OVER (PARTITION BY A.SEGMENT2, A.SEGMENT1, A.SEGMENT3, A.SEGMENT4 ORDER BY A.SEGMENT2, A.SEGMENT1, A.SEGMENT3, A.SEGMENT4, A.SEGMENT4 ) AS ROW_CNT' + char(10)
			SELECT @v_dsql += '					FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)' + char(10)
			SELECT @v_dsql += '					WHERE  A.LOOKUP_TYPE_CODE = ''LINE_PROD_VERSION_TYPE'' AND A.ACTIVE_FLAG = ''Y''' + char(10)
			SELECT @v_dsql += '				) E ON  A.DIVISION_ID  = E.DIVISION_ID' + char(10)
			SELECT @v_dsql += '					AND A.SITE_ID      = E.SITE_ID' + char(10)
			SELECT @v_dsql += '					AND A.PLANT_ID     = E.PLANT_ID' + char(10)
			SELECT @v_dsql += '					AND A.FACTORY_ID   = E.FACTORY_ID' + char(10)
			SELECT @v_dsql += '			LEFT OUTER JOIN (' + char(10)
			SELECT @v_dsql += '				SELECT DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID' + char(10)
			SELECT @v_dsql += '					, R.PLANT_ID, R.FACTORY_ID, R.OPERATION_ID' + char(10)
			SELECT @v_dsql += '				FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK)' + char(10)
			SELECT @v_dsql += '				WHERE  R.USER_ID = '''+ @p_user_id +''' AND R.SAVE_FLAG = ''Y'' AND  (' + char(10)
			SELECT @v_dsql += '					(R.USER_ID IN (''leehsthira'',''choikjthira'',''yschoithira'',''leejsthira2'',''kimcd'',''piyong'',''dolce1011'',''hseokjang'',''chaosjung'',''DEMO117'',''DEMO109'',''lgda106'',''chkim.68'',''lgzhyu3'',''multishin'',''hwanghg''))' + char(10)
			SELECT @v_dsql += '					OR R.USER_ID IN (	SELECT SEGMENT1 AS USER_ID	       ' + char(10)
			SELECT @v_dsql += '										FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)' + char(10)
			SELECT @v_dsql += '										WHERE  A.LOOKUP_TYPE_CODE = ''EXPR_USER'' AND A.SEGMENT3 = ''PI'' AND A.ACTIVE_FLAG = ''Y''' + char(10)
			SELECT @v_dsql += '									)       ' + char(10)
			SELECT @v_dsql += '					OR (R.PLANT_ID IN (''NJ01'')))       ' + char(10) -- [IT20250117A]구코드 => 신코드로 변경
			SELECT @v_dsql += '				) R' + char(10)
			SELECT @v_dsql += '				ON   A.COMPANY_ID  = R.COMPANY_ID' + char(10)
			SELECT @v_dsql += '				AND  A.DIVISION_ID = R.DIVISION_ID' + char(10)
			SELECT @v_dsql += '				AND  A.SITE_ID     = R.SITE_ID' + char(10)
			SELECT @v_dsql += '				AND  A.PLANT_ID    = R.PLANT_ID' + char(10)
			SELECT @v_dsql += '				AND  A.FACTORY_ID  = R.FACTORY_ID' + char(10)
			SELECT @v_dsql += '				AND  A.OPERATION   = R.OPERATION_ID' + char(10)
			SELECT @v_dsql += '		WHERE 1 = 1' + char(10)
			SELECT @v_dsql += '			AND A.OPERATION = ''E2000''' + char(10)
			IF(LEN(@p_max_version) > 0)
	            BEGIN
	        	    SELECT @v_dSql += '     AND    A.MAX_VER_FLAG = '''+ @p_max_version +''' ' + char(10)
	        	END
            SELECT @v_dSql += '               '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))       + char(10)
            SELECT @v_dSql += '               '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))               + char(10)
            SELECT @v_dSql += '               '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))             + char(10)
            SELECT @v_dSql += '               '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))         + char(10)
            SELECT @v_dSql += '               '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION' , 'EQ', @p_operation_id))     + char(10)
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
	        	    SELECT @v_dSql += '     AND    A.PJT_CODE LIKE ''%'+ @p_pjt_code +'%'' ' + char(10)
	        	END
			SELECT @v_dsql += '		) N inner join (' + char(10)
			SELECT @v_dsql += '		SELECT C.COMPANY_ID, C.DIVISION_ID, C.SITE_ID, C.PLANT_ID, C.FACTORY_ID, E.OPERATION_ID' + char(10)
			SELECT @v_dsql += '		FROM   TH_UIS_USER_INSTANCE_RELATE B WITH (NOLOCK)' + char(10)
			SELECT @v_dsql += '					INNER JOIN (' + char(10)
			SELECT @v_dsql += '						SELECT	C.ROLE_ID, C.INSTANCE_ID, C.COMPANY_ID, C.DIVISION_ID, C.SITE_ID, C.PLANT_ID, C.FACTORY_ID, A.OPERATION_ID, C.PLAN_GROUP_ID' + char(10)
			SELECT @v_dsql += '						FROM FP_INSTANCE_OPERATION_V A WITH (NOLOCK), TH_UIS_ROLE_INSTANCE_RELATE C WITH (NOLOCK)' + char(10)
			SELECT @v_dsql += '						WHERE	A.INSTANCE_ID = C.INSTANCE_ID AND A.COMPANY_ID = C.COMPANY_ID AND A.DIVISION_ID = C.DIVISION_ID AND	A.SITE_ID = C.SITE_ID AND C.USE_AT_FLAG	= ''Y''' + char(10)
			SELECT @v_dsql += '						GROUP BY C.ROLE_ID, C.INSTANCE_ID, C.COMPANY_ID, C.DIVISION_ID, C.SITE_ID, C.PLANT_ID, C.FACTORY_ID, A.OPERATION_ID, C.PLAN_GROUP_ID' + char(10)
			SELECT @v_dsql += '					) C ON B.ROLE_ID = C.ROLE_ID' + char(10)
			SELECT @v_dsql += '					INNER JOIN SCM_SYS_LOOKUP_VALUE D WITH(NOLOCK) ON D.LOOKUP_TYPE_CODE = ''INSTANCE_ID'' AND D.ACTIVE_FLAG = ''Y'' AND C.INSTANCE_ID = D.SEGMENT1' + char(10)
			SELECT @v_dsql += '					INNER JOIN SCM_LINE_M E WITH(NOLOCK) ON E.ACTIVE_FLAG = ''Y'' AND C.COMPANY_ID = E.COMPANY_ID AND C.DIVISION_ID = E.DIVISION_ID ' + char(10)
			SELECT @v_dsql += '						AND C.SITE_ID = E.SITE_ID AND C.PLANT_ID = E.PLANT_ID AND C.FACTORY_ID = E.FACTORY_ID AND  C.OPERATION_ID  = E.OPERATION_ID' + char(10)
			SELECT @v_dsql += '						AND (CASE WHEN D.ATTRIBUTE1 = ''PLAN GROUP'' THEN C.PLAN_GROUP_ID ELSE ''-'' END) = (CASE WHEN D.ATTRIBUTE1 = ''PLAN GROUP'' THEN E.MODEL_TYPE ELSE ''-'' END)' + char(10)
			SELECT @v_dsql += '		WHERE  B.USE_AT_FLAG = ''Y'' AND B.USER_ID = '''+ @p_user_id +'''   ' + char(10)
			SELECT @v_dsql += '		GROUP BY C.COMPANY_ID, C.DIVISION_ID, C.SITE_ID, C.PLANT_ID, C.FACTORY_ID, E.OPERATION_ID		' + char(10)
			SELECT @v_dsql += '		) B                      ' + char(10)
			SELECT @v_dsql += '		on  N.COMPANY_ID   = B.COMPANY_ID                             ' + char(10)
			SELECT @v_dsql += '			AND    N.DIVISION_ID  = B.DIVISION_ID' + char(10)
			SELECT @v_dsql += '			AND    N.SITE_ID      = B.SITE_ID' + char(10)
			SELECT @v_dsql += '			AND    N.PLANT_ID     = B.PLANT_ID' + char(10)
			SELECT @v_dsql += '			AND    N.FACTORY_ID   = B.FACTORY_ID' + char(10)
			SELECT @v_dsql += '			AND    N.OPERATION    = B.OPERATION_ID' + char(10)
			SELECT @v_dsql += '		) A;' + char(10)
			SELECT @v_dsql += 'SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.MODEL_ID, A.PJT_CODE, A.VERSION, A.OPERATION, A.ITEM_ID, NULL AS ELECTRODE_TYPE, MAX(A.MARK) AS MARK' + char(10)
			SELECT @v_dsql += '	, A.MAX_VER_FLAG , A.VERSION_TYPE, A.PROD_VERSION_TYPE , A.PROD_YN, MAX(A.APPLY_DATE) AS APPLY_DATE' + char(10)
			SELECT @v_dsql += '	, MAX(CASE WHEN A.CATEGORY = ''cell/batch'' THEN A.VALUE ELSE 0 END) AS CELL_BATCH' + char(10)
			SELECT @v_dsql += '	, MAX(CASE WHEN A.CATEGORY = ''Jumbo Roll (cell/m)'' THEN A.VALUE ELSE 0 END) AS CELL_JUMBO' + char(10)
			SELECT @v_dsql += '	, MAX(CASE WHEN A.CATEGORY = ''Jumbo Roll (m/batch)'' THEN A.VALUE ELSE 0 END) AS JUMBO_BATCH' + char(10)
			SELECT @v_dsql += '	, MAX(CASE WHEN A.CATEGORY = ''Lane Number'' THEN CONVERT(NUMERIC(18,5),A.VALUE) ELSE 0 END) AS LANE_NUMBER' + char(10)
			SELECT @v_dsql += '	, MAX(CASE WHEN A.CATEGORY = ''Pancake (cell/m)'' THEN A.VALUE ELSE 0 END) AS CELL_M' + char(10)
			SELECT @v_dsql += '	, MAX(CASE WHEN A.CATEGORY = ''Pancake (m/batch)'' THEN A.VALUE ELSE 0 END) AS M_BATCH' + char(10)             
            SELECT @v_dsql += '	, A.EDIT_YN' + char(10)
            SELECT @v_dsql += '	,IIF(EXISTS (SELECT 1 FROM SCM_SYS_LOOKUP_VALUE L WHERE L.LOOKUP_TYPE_CODE = N''PDS_COMPANY''AND L.SEGMENT2 = A.PLANT_ID),A.PDS_VERSION,'''') AS PDS_VERSION' + char(10)  
            SELECT @v_dsql += '	,IIF(EXISTS (SELECT 1 FROM SCM_LINE_M L WHERE L.ACTIVE_FLAG = ''Y''AND L.LINE_ID = A.PROD_VERSION_TYPE),A.PROD_VERSION_TYPE,''''  ) AS LINE_ID ' + char(10)  
            --SELECT @v_dsql += ' ,  IIF(MAX(PDSPLANT.PLANT_ID) IS NOT NULL, A.PDS_VERSION , '''') as  PDS_VERSION , line.LINE_ID' + char(10)--[E20260928-000085]FP - PDS 라인별 전극 환산자 적용건 - 조회 UI 변경
            --SELECT @v_dsql += ' , A.PDS_VERSION , line.LINE_ID' + char(10)--[E20260928-000085]FP - PDS 라인별 전극 환산자 적용건 - 조회 UI 변경
			SELECT @v_dsql += 'FROM #Temp01 A' + char(10)    
            --SELECT @v_dsql += 'LEFT OUTER JOIN (SELECT DISTINCT LINE_ID FROM SCM_LINE_M WHERE ACTIVE_FLAG =''Y'') line on A.PROD_VERSION_TYPE = line.LINE_ID' + char(10)--[E20260928-000085]FP - PDS 라인별 전극 환산자 적용건 - 조회 UI 변경
            --SELECT @v_dsql += 'LEFT OUTER JOIN (SELECT SEGMENT2 AS PLANT_ID FROM   SCM_SYS_LOOKUP_VALUE A WHERE  A.LOOKUP_TYPE_CODE =N''PDS_COMPANY'') PDSPLANT on A.PLANT_ID = PDSPLANT.PLANT_ID' + char(10)--[E20260928-000085]FP - PDS 라인별 전극 환산자 적용건 - 조회 UI 변경
            SELECT @v_dsql += 'WHERE 1 = 1'
            SELECT @v_dSql += ''+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('line.LINE_ID' , 'EQ', @p_line))   + char(10)--[E20260928-000085]FP - PDS 라인별 전극 환산자 적용건 - 조회 UI 변경
			SELECT @v_dsql += 'GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID' + char(10)
			SELECT @v_dsql += '	, A.MODEL_ID, A.PJT_CODE, A.VERSION, A.OPERATION, A.ITEM_ID' + char(10)
			SELECT @v_dsql += '	, A.MAX_VER_FLAG, A.VERSION_TYPE, A.PROD_VERSION_TYPE, A.PROD_YN, A.EDIT_YN  ' + char(10)
            SELECT @v_dsql += ' , A.PDS_VERSION-- ,line.LINE_ID  ' + char(10)--[E20260928-000085]FP - PDS 라인별 전극 환산자 적용건 - 조회 UI 변경
			SELECT @v_dsql += 'ORDER BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.MODEL_ID' + char(10)
			SELECT @v_dsql += '	, A.OPERATION, A.ITEM_ID, A.VERSION_TYPE' + char(10)
			SELECT @v_dsql += '	, CASE WHEN A.VERSION LIKE ''Z%'' THEN REPLACE( A.VERSION, ''Z'', ''/'') ELSE A.VERSION END  ' + char(10)
			SELECT @v_dsql += 'IF OBJECT_ID(''TEMPDB..#Temp01'') IS NOT NULL DROP TABLE #Temp01;' + char(10)

		    IF @p_sys_type = 'SQL'
		  	    BEGIN
		  	    	 EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
		  	    	 SELECT @v_dSql as [QUERY_VALUE]
		  	    END  
		    ELSE 
		    	BEGIN
SET @PrintTime = GETDATE(); PRINT 'SecondTimes: ' + CAST(convert(decimal(10,3),datediff(ms,@StartTime,@PrintTime)/1000.0)AS varchar); set @StartTime = @PrintTime
print 'Block_01: ' + CONVERT(varchar,GETDATE(),14);
		    		SET @runstart = GetDate()
		    		--쿼리실행
		    		EXEC sp_executesql @v_dSql
SET @PrintTime = GETDATE(); PRINT 'SecondTimes: ' + CAST(convert(decimal(10,3),datediff(ms,@StartTime,@PrintTime)/1000.0)AS varchar); set @StartTime = @PrintTime
print 'End block 01: ' + CONVERT(varchar,GETDATE(),14);
					
		    		SET @runend = GetDate()
		    		EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend

					return;
		    	END
        END	--IF( END )
	/************************************************************************************************/
	/* SELECT인경우 :SELECT(SELECT_ADD Popup)                                                       */
	/************************************************************************************************/
    ELSE IF(@p_sys_flag ='SELECT_ADD_POPUP')
	    BEGIN
		    SELECT @v_dSql  = ''
            SELECT @v_dSql += ' SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID  ' + char(10)
            SELECT @v_dSql += '     , A.FACTORY_ID, A.MODEL_ID, A.PJT_CODE, A.VERSION      ' + char(10)
            SELECT @v_dSql += '     , A.OPERATION, A.ITEM_ID, A.ELECTRODE_TYPE, A.CATEGORY ' + char(10)
            SELECT @v_dSql += '     , A.VALUE, A.MARK, A.MAX_VER_FLAG, A.PROD_VERSION_TYPE ' + char(10)
            SELECT @v_dSql += '     , A.VERSION_TYPE, A.VERSION AS ORG_VERSION             ' + char(10)
            SELECT @v_dSql += '     , DENSE_RANK( ) OVER( PARTITION BY A.FACTORY_ID, A.MODEL_ID, A.OPERATION, A.ITEM_ID ' + char(10)
            SELECT @v_dSql += '       ORDER BY A.FACTORY_ID, A.MODEL_ID, A.OPERATION, A.ITEM_ID, A.VERSION ) AS ROW_NUM ' + char(10)
            SELECT @v_dSql += ' FROM   SCM_ITEM_CONV_CALC_M A WITH(NOLOCK)           ' + char(10)
            SELECT @v_dSql += ' INNER JOIN (                                         ' + char(10)
            SELECT @v_dSql += '       SELECT DISTINCT A.ATTRIBUTE1 AS E_CATEGORY     ' + char(10)
            SELECT @v_dSql += '       FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)     ' + char(10)
            SELECT @v_dSql += '       WHERE  A.LOOKUP_TYPE_CODE = ''ITEM_CONV_CALC'' ' + char(10)
            SELECT @v_dSql += '       AND    A.ATTRIBUTE2 = ''Y''                    ' + char(10)
            SELECT @v_dSql += ' ) C                                                  ' + char(10)
            SELECT @v_dSql += ' ON     A.CATEGORY = C.E_CATEGORY                     ' + char(10)
            SELECT @v_dSql += ' WHERE  1=1                                           ' + char(10)
            SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))   + char(10)
            SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))           + char(10)
            SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))         + char(10)
            SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))     + char(10)
            SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION' , 'EQ', @p_operation_id))    + char(10)
			SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.MODEL_ID' , 'EQ', @p_model_id))         + char(10)
			SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'EQ', @p_item_id))           + char(10)
			SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PJT_CODE' , 'EQ', @p_pjt_code))         + char(10)
			SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.VERSION_TYPE' , 'EQ', @p_version_type)) + char(10)
            SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PROD_VERSION_TYPE' , 'EQ', @p_prod_ver_type)) + char(10)

            SELECT @v_dSql += ' AND    A.MAX_VER_FLAG = ''Y''                                                ' + char(10)
            SELECT @v_dSql += ' ORDER BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                  ' + char(10)
            SELECT @v_dSql += '     , A.MODEL_ID, A.OPERATION, A.ITEM_ID, A.ELECTRODE_TYPE                   ' + char(10)
            SELECT @v_dSql += '     , CASE WHEN A.VERSION LIKE ''Z%'' THEN REPLACE( A.VERSION, ''Z'', ''/'') ' + char(10)
            SELECT @v_dSql += ' 	       ELSE A.VERSION END, A.CATEGORY                                    ' + char(10)

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
	/* SELECT인경우 :SELECT(SELECT_ITEM Popup)                                                      */
	/************************************************************************************************/
    ELSE IF(@p_sys_flag ='SELECT_ITEM_POPUP')
	    BEGIN
		    SELECT @v_dSql  = ''
            SELECT @v_dSql += ' WITH USER_SHOP (COMPANY, DIVISION, SITE) AS (              ' + char(10)
            SELECT @v_dSql += '     SELECT DISTINCT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID ' + char(10)
            SELECT @v_dSql += '     FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)              ' + char(10)
            SELECT @v_dSql += '     WHERE  1=1                                             ' + char(10)
            SELECT @v_dSql += '     AND    B.USER_ID   = '''+ @p_user_id +'''              ' + char(10)
            SELECT @v_dSql += '     AND	   B.SAVE_FLAG = ''Y''                             ' + char(10)
            SELECT @v_dSql += ' )                                                          ' + char(10)
            SELECT @v_dSql += ' SELECT DISTINCT MODEL_ID, ITEM_ID, NICK_NAME               ' + char(10)
            SELECT @v_dSql += ' FROM (                                                     ' + char(10)
            SELECT @v_dSql += '       SELECT DISTINCT B.MODEL_ID, A.ITEM_ID                ' + char(10)
            SELECT @v_dSql += ' 	      , ISNULL(D.NICK_NAME,''-'') AS NICK_NAME         ' + char(10)
            SELECT @v_dSql += '       FROM	SCM_ITEM_M A WITH(NOLOCK)                      ' + char(10)
            SELECT @v_dSql += '            , SCM_MODEL_COMP_EFFECTIVE_DATE B WITH(NOLOCK)  ' + char(10)
            SELECT @v_dSql += '            , SCM_ITEM_M D WITH(NOLOCK)                     ' + char(10)
            SELECT @v_dSql += '       WHERE	1=1                                            ' + char(10)
            SELECT @v_dSql += '       AND   A.ITEM_ID     = B.CHILD_ITEM_ID                ' + char(10)
            SELECT @v_dSql += '       AND   A.ACTIVE_FLAG = ''Y''                          ' + char(10)
            SELECT @v_dSql += '       AND   D.ITEM_ID     = B.MODEL_ID                     ' + char(10)
            SELECT @v_dSql += '       AND   A.DIVISION_ID = '''+ @p_division_id +'''       ' + char(10)
            SELECT @v_dSql += '       AND   A.SITE_ID     = '''+ @p_site_id +'''           ' + char(10)
            SELECT @v_dSql += '       AND   A.FLOW_ID LIKE ''%'' + '''+ @p_operation_id +''' + ''%''         ' + char(10)
			IF (LEN(@p_model_id) > 0)
			    BEGIN
				    SELECT @v_dSql += '       AND   B.MODEL_ID    LIKE ''%'' + '''+ @p_model_id +''' + ''%'' ' + char(10)
				END
			IF (LEN(@p_item_id) > 0)
			    BEGIN
				    SELECT @v_dSql += '       AND   A.ITEM_ID    LIKE ''%'' + '''+ @p_item_id +''' + ''%''   ' + char(10)
				END
			IF (LEN(@p_pjt_code) > 0)
			    BEGIN
				    SELECT @v_dSql += '       AND   D.NICK_NAME    LIKE ''%'' + '''+ @p_pjt_code +''' + ''%'' ' + char(10)
				END

            SELECT @v_dSql += '       AND   EXISTS (                               ' + char(10)
            SELECT @v_dSql += '                     SELECT SITE FROM USER_SHOP     ' + char(10)
            SELECT @v_dSql += '                     WHERE COMPANY = A.COMPANY_ID   ' + char(10)
            SELECT @v_dSql += '                     AND DIVISION  = A.DIVISION_ID  ' + char(10)
            SELECT @v_dSql += '                     AND SITE      = A.SITE_ID      ' + char(10)
            SELECT @v_dSql += '                    )                               ' + char(10)
            SELECT @v_dSql += '     ) A                                            ' + char(10)
            SELECT @v_dSql += ' ORDER BY MODEL_ID,ITEM_ID, NICK_NAME               ' + char(10)

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
	/* 상세조회                                                                                     */
	/************************************************************************************************/
    IF(@p_sys_flag ='SELECT_DETAIL')
        BEGIN --IF(START)
            SELECT @v_dSql = ''
            SELECT @v_dSql += N'SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
            SELECT @v_dSql += N'	 , A.LINE_ID, D.LINE_NAME , A.ELECTRODE_TYPE ' + char(10)
            SELECT @v_dSql += N'	 , B.MODEL_ID, ISNULL(C.NICK_NAME,''-'') AS NICK_NAME ' + char(10)
            SELECT @v_dSql += N'	 , B.VERSION_TYPE, B.VERSION ' + char(10)
            SELECT @v_dSql += N'	 , A.OPERATION_ID, A.ITEM_ID ' + char(10)
            SELECT @v_dSql += N'	 , ISNULL(E.ACTIVE_FLAG, ''Y'') AS ACTIVE_FLAG ' + char(10)
            SELECT @v_dSql += N'	 , B.PROD_VERSION_TYPE, B.MAX_VER_FLAG, E.DESCRIPTION ' + char(10)
            SELECT @v_dSql += N'     , ISNULL(E.UPDATE_ID, '''') AS UPDATE_ID, ISNULL(CONVERT(VARCHAR,E.UPDATE_TIME,20), '''') AS UPDATE_TIME ' + char(10)
			SELECT @v_dSql += N'FROM ( ' + char(10)
            SELECT @v_dSql += N'	SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.ITEM_ID, A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
            SELECT @v_dSql += N'	FROM   SCM_ITEM_LINE_ASSIGN_M A WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += N'	WHERE  1=1 ' + char(10)
            SELECT @v_dSql += N'	AND    A.OPERATION_ID = ''E2000'' ' + char(10)
            SELECT @v_dSql += N'	'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
            SELECT @v_dSql += N'	'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))         + char(10)
            SELECT @v_dSql += N'	'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))       + char(10)
            SELECT @v_dSql += N'	'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))   + char(10)
	        
			IF(LEN(@p_item_id) > 0)
	        BEGIN
	        	SELECT @v_dSql += N'	AND    A.ITEM_ID LIKE '''+ @p_item_id +''' ' + char(10)
	        END
			
            SELECT @v_dSql += N'	AND    A.MONTH = CONVERT(VARCHAR(6), GETDATE(), 112) ' + char(10) -- 시스템 일자 기준 월
            SELECT @v_dSql += N'	AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql += N'	AND    A.PRIORITY IN (1,2,3,4,5,6,7,8) ' + char(10)
            SELECT @v_dSql += N') A ' + char(10)
            SELECT @v_dSql += N'INNER JOIN ( ' + char(10)
            SELECT @v_dSql += N'	SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION AS OPERATION_ID ' + char(10)
            SELECT @v_dSql += N'		 , A.MODEL_ID, A.ITEM_ID, A.VERSION, A.PROD_VERSION_TYPE, A.MAX_VER_FLAG, A.VERSION_TYPE  ' + char(10)
            --SELECT @v_dSql += N'		 , A.VERSION AS CODE, A.VERSION AS NAME ' + char(10)
            --SELECT @v_dSql += N'		 , A.ELECTRODE_TYPE, A.CATEGORY, A.VALUE ' + char(10)
            --SELECT @v_dSql += N'		 , DENSE_RANK( ) OVER( PARTITION BY A.FACTORY_ID, A.MODEL_ID, A.OPERATION, A.ITEM_ID ORDER BY A.VERSION ) AS ROW_NUM ' + char(10)
            --SELECT @v_dSql += N'		 , CONVERT(VARCHAR,A.APPLY_DATE,20) AS APPLY_DATE ' + char(10)
            SELECT @v_dSql += N'	FROM   SCM_ITEM_CONV_CALC_M A WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += N'	WHERE 1=1 ' + char(10)
            SELECT @v_dSql += N'	AND   A.OPERATION = ''E2000'' ' + char(10)
            SELECT @v_dSql += N'	AND   A.CATEGORY IN ( ''cell/batch'', ''Jumbo Roll (cell/m)'', ''Jumbo Roll (m/batch)'', ''Lane Number'', ''Pancake (cell/m)'', ''Pancake (m/batch)'' ) ' + char(10) 
            --SELECT @v_dSql += N'	AND   A.MAX_VER_FLAG = ''Y'' ' + char(10)
            SELECT @v_dSql += N'	'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
            SELECT @v_dSql += N'	'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))         + char(10)
            SELECT @v_dSql += N'	'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))       + char(10)
            SELECT @v_dSql += N'	'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))   + char(10)
			
			IF(LEN(@p_model_id) > 0)
	        BEGIN
	        	SELECT @v_dSql += N'	AND   A.MODEL_ID LIKE '''+ @p_model_id +''' ' + char(10)
	        END
			IF(LEN(@p_item_id) > 0)
	        BEGIN
	        	SELECT @v_dSql += N'	AND    A.ITEM_ID LIKE '''+ @p_item_id +''' ' + char(10)
	        END
			
            SELECT @v_dSql += N') B ' + char(10)
            SELECT @v_dSql += N'ON  1=1 ' + char(10)
            SELECT @v_dSql += N'AND A.COMPANY_ID   = B.COMPANY_ID ' + char(10)
            SELECT @v_dSql += N'AND A.DIVISION_ID  = B.DIVISION_ID ' + char(10)
            SELECT @v_dSql += N'AND A.SITE_ID      = B.SITE_ID ' + char(10)
            SELECT @v_dSql += N'AND A.PLANT_ID     = B.PLANT_ID ' + char(10)
            SELECT @v_dSql += N'AND A.FACTORY_ID   = B.FACTORY_ID ' + char(10)
            SELECT @v_dSql += N'AND A.OPERATION_ID = B.OPERATION_ID ' + char(10)
            SELECT @v_dSql += N'AND A.ITEM_ID      = B.ITEM_ID ' + char(10)
            SELECT @v_dSql += N'LEFT OUTER JOIN SCM_ITEM_M C WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += N'ON  1=1 ' + char(10)
            SELECT @v_dSql += N'AND B.COMPANY_ID   = C.COMPANY_ID ' + char(10)
            SELECT @v_dSql += N'AND B.DIVISION_ID  = C.DIVISION_ID ' + char(10)
            SELECT @v_dSql += N'AND B.SITE_ID      = C.SITE_ID ' + char(10)
            SELECT @v_dSql += N'AND B.MODEL_ID     = C.ITEM_ID ' + char(10)
            SELECT @v_dSql += N'INNER JOIN SCM_LINE_M D WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += N'ON  1=1 ' + char(10)
            SELECT @v_dSql += N'AND A.COMPANY_ID        = D.COMPANY_ID ' + char(10)
            SELECT @v_dSql += N'AND A.DIVISION_ID       = D.DIVISION_ID ' + char(10)
            SELECT @v_dSql += N'AND A.SITE_ID           = D.SITE_ID ' + char(10)
            SELECT @v_dSql += N'AND A.PLANT_ID          = D.PLANT_ID ' + char(10)
            SELECT @v_dSql += N'AND A.FACTORY_ID        = D.FACTORY_ID ' + char(10)
            SELECT @v_dSql += N'AND A.OPERATION_ID      = D.OPERATION_ID ' + char(10)
            SELECT @v_dSql += N'AND A.LINE_ID           = D.LINE_ID ' + char(10)
            SELECT @v_dSql += N'AND A.ELECTRODE_TYPE    = D.ELECTRODE_TYPE ' + char(10)
            SELECT @v_dSql += N'AND B.PROD_VERSION_TYPE = D.PROD_VERSION_TYPE ' + char(10) -- version type 까지 체크
            SELECT @v_dSql += N'LEFT OUTER JOIN SCM_ITEM_CONV_CALC_USE_M E WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += N'ON  1=1 ' + char(10)
            SELECT @v_dSql += N'AND A.FACTORY_ID     = E.FACTORY_ID ' + char(10)
            SELECT @v_dSql += N'AND B.MODEL_ID       = E.MODEL_ID ' + char(10)
            SELECT @v_dSql += N'AND A.ITEM_ID        = E.ITEM_ID ' + char(10)
            SELECT @v_dSql += N'AND A.LINE_ID        = E.LINE_ID ' + char(10)
            SELECT @v_dSql += N'AND A.ELECTRODE_TYPE = E.ELECTRODE_TYPE ' + char(10)
            SELECT @v_dSql += N'AND B.VERSION        = E.VERSION ' + char(10)
            SELECT @v_dSql += N'WHERE 1=1 ' + char(10)
			/*
	        IF(LEN(@p_pjt_code) > 0)
	        BEGIN
	        	SELECT @v_dSql += N'AND  C.NICK_NAME LIKE ''%'+ @p_pjt_code +'%'' ' + char(10)
	        END
			*/
            SELECT @v_dSql += N'ORDER BY DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, MODEL_ID, ITEM_ID, LINE_ID, VERSION ' + char(10)

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
	
    ELSE IF(@p_sys_flag ='EXECUTE_ITEM_LINE_VERSION')
	    BEGIN --ELSE IF(START)
		    SELECT @v_dSql = ''
			SELECT @v_dSql = 'EXEC PR_SCM_ITEM_LINE_VERSION'
			
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

			/*
			--Log 남김
			EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_dSql,'select',@runstart, @runend

			EXEC  @rtnCount = [dbo].[PR_SCM_AF_MASTER_VALIDATION]
			
			SET @rtnCount = 1
            SELECT	'Result' = @rtnCount
			*/

		END --ELSE IF(END)
    --[E20260928-000085]FP - PDS 라인별 전극 환산자 적용건 - 조회 UI 변경
    ELSE  IF(@p_sys_flag ='SELECT_CONVERSION_TYPE')
        BEGIN --IF(START)
     
            SELECT @v_dSql = ''			
            SELECT @v_dSql += 'SELECT DISTINCT PROD_VERSION_TYPE AS CODE, PROD_VERSION_TYPE AS NAME   ,CASE WHEN PROD_VERSION_TYPE like ''FP%'' THEN 2  ELSE 1 END AS SORT'  + char(10) 
            SELECT @v_dSql += '  FROM SCM_ITEM_CONV_CALC_M  A WITH (NOLOCK)'   + char(10)
            SELECT @v_dSql += ' WHERE COMPANY_ID <>'''' '
            SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))
            SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))
            SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))
            SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))
            SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION' , 'EQ', @p_operation_id))
            SELECT @v_dSql += 'ORDER BY SORT ,PROD_VERSION_TYPE'

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
                                SELECT @v_dSql += ' )                                                                                                                                               ' + char(10)

						   END --'D'
					   /****************************************************************************/
					   /* INSERT  경우  :     INSERT(INSERT_UOM_INFO)                              */
					   /****************************************************************************/
					   ELSE IF(@v_sys_flag ='INSERT_UOM_INFO')
						   BEGIN
								SELECT @v_dSql1 = ''
                                SELECT @v_dSql1 += ' -- update when data exists                                  ' + char(10)
                                SELECT @v_dSql1 += ' UPDATE SCM_ITEM_CONV_CALC_M                                 ' + char(10)
                                SELECT @v_dSql1 += ' SET   UPDATE_ID    = '''+ @v_user_id +'''                   ' + char(10)
                                SELECT @v_dSql1 += '     , UPDATE_TIME  = dbo.FN_SITE_TIME('''+ @v_site_id +''') ' + char(10)
                                SELECT @v_dSql1 += '     , VALUE        = '''+ @v_value +'''                     ' + char(10)
                                SELECT @v_dSql1 += ' WHERE FACTORY_ID   = '''+ @v_factory_id +'''                ' + char(10)
                                SELECT @v_dSql1 += ' AND   MODEL_ID     = '''+ @v_model_id +'''                  ' + char(10)
                                SELECT @v_dSql1 += ' AND   VERSION      = '''+ @v_version +'''                   ' + char(10)
                                SELECT @v_dSql1 += ' AND   OPERATION    = '''+ @v_operation_id +'''              ' + char(10)
                                SELECT @v_dSql1 += ' AND   ITEM_ID      = '''+ @v_item_id +'''                   ' + char(10)
                                SELECT @v_dSql1 += ' AND   CATEGORY     = '''+ @v_category_id +'''               ' + char(10)
                                SELECT @v_dSql1 += ' AND   VERSION_TYPE = '''+ @v_version_type +'''              ' + char(10)
                                SELECT @v_dSql1 += ' AND   PROD_VERSION_TYPE = '''+ @v_prod_ver_type +'''        ' + char(10)

                                SELECT @v_dSql1 += ' -- insert when no data.                                     ' + char(10)
                                SELECT @v_dSql1 += ' INSERT INTO SCM_ITEM_CONV_CALC_M (                          ' + char(10)
                                SELECT @v_dSql1 += '       COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID            ' + char(10)
                                SELECT @v_dSql1 += '     , FACTORY_ID, MODEL_ID, PJT_CODE, VERSION               ' + char(10)
                                SELECT @v_dSql1 += '     , OPERATION, ITEM_ID, ELECTRODE_TYPE, CATEGORY          ' + char(10)
                                SELECT @v_dSql1 += '     , MAX_VER_FLAG, VALUE, PROD_VERSION_TYPE, VERSION_TYPE  ' + char(10)
                                SELECT @v_dSql1 += '     , CREATE_ID, CREATE_TIME, UPDATE_ID, UPDATE_TIME        ' + char(10)
                                SELECT @v_dSql1 += '     , APPLY_DATE                                            ' + char(10)
                                SELECT @v_dSql1 += ' )                                                           ' + char(10)
                                SELECT @v_dSql1 += ' SELECT A.*                                                  ' + char(10)
                                SELECT @v_dSql1 += ' FROM (                                                      ' + char(10)
                                SELECT @v_dSql1 += '     SELECT '''+ @v_company_id +''' AS COMPANY_ID, '''+ @v_division_id +''' AS DIVISION_ID, '''+ @v_site_id +''' AS SITE_ID, '''+ @v_plant_id +''' AS PLANT_ID ' + char(10)
                                SELECT @v_dSql1 += ' 	 , '''+ @v_factory_id +''' AS FACTORY_ID, '''+ @v_model_id +''' AS MODEL_ID, '''+ @v_pjt_code +''' AS PJT_CODE  ' + char(10)
                                SELECT @v_dSql1 += '     , (CASE WHEN CHARINDEX(''.'','''+ @v_version +''',1) > 0 THEN                                                  ' + char(10)
                                SELECT @v_dSql1 += '                 ISNULL(REPLICATE(''0'', 3 - LEN(SUBSTRING('''+ @v_version +''', 1, ABS(CHARINDEX(''.'','''+ @v_version +''',1)-1)))),'''')  ' + char(10)
                                SELECT @v_dSql1 += ' 				+ SUBSTRING('''+ @v_version +''', 1, ABS(CHARINDEX(''.'', '''+ @v_version +''',1)-1) ) + ''.''  ' + char(10)
                                SELECT @v_dSql1 += ' 				+ SUBSTRING('''+ @v_version +''', CHARINDEX(''.'','''+ @v_version +''',1)+1,10)                 ' + char(10)
                                SELECT @v_dSql1 += '            ELSE ISNULL(REPLICATE(''0'', 3 - LEN('''+ @v_version +''')),'''') + '''+ @v_version +'''              ' + char(10)
                                SELECT @v_dSql1 += '            END ) AS VERSION                                                                                    ' + char(10)
                                SELECT @v_dSql1 += '     , '''+ @v_operation_id +''' AS OPERATION, '''+ @v_item_id +''' AS ITEM_ID,'''+ @v_electrode_type +''' AS ELECTRODE_TYPE, '''+ @v_category_id +''' AS CATEGORY ' + char(10)
                                SELECT @v_dSql1 += '     , ''Y'' AS MAX_VER_FLAG, '''+ @v_value +''' AS VALUE                                             ' + char(10)
                                SELECT @v_dSql1 += '     , ( SELECT DISTINCT                                                                                    ' + char(10)
                                SELECT @v_dSql1 += '             CASE WHEN ( COUNT(*) OVER (PARTITION BY A.SEGMENT2, A.SEGMENT1, A.SEGMENT3, A.SEGMENT4 )) > 1  ' + char(10)
                                SELECT @v_dSql1 += '                      AND SUBSTRING('''+ @v_version +''',LEN('''+ @v_version +'''),1) = ''W''               ' + char(10)
                                SELECT @v_dSql1 += '                  THEN ''WIDE''                                                                             ' + char(10)
                                SELECT @v_dSql1 += '             ELSE MIN(A.ATTRIBUTE1) OVER (PARTITION BY A.SEGMENT2, A.SEGMENT1, A.SEGMENT3, A.SEGMENT4 )     ' + char(10)
                                SELECT @v_dSql1 += '             END AS PROD_VERSION_TYPE                           ' + char(10)
                                SELECT @v_dSql1 += '         FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)             ' + char(10)
                                SELECT @v_dSql1 += '         WHERE  A.LOOKUP_TYPE_CODE = ''LINE_PROD_VERSION_TYPE'' ' + char(10)
                                SELECT @v_dSql1 += '         AND    A.ACTIVE_FLAG = ''Y''                           ' + char(10)
                                SELECT @v_dSql1 += '         AND    A.SEGMENT2 = '''+ @v_division_id +'''           ' + char(10)
                                SELECT @v_dSql1 += '         AND    A.SEGMENT1 = '''+ @v_site_id +'''               ' + char(10)
                                SELECT @v_dSql1 += '         AND    A.SEGMENT3 = '''+ @v_plant_id +'''              ' + char(10)
                                SELECT @v_dSql1 += '         AND    A.SEGMENT4 = '''+ @v_factory_id +'''            ' + char(10)
                                SELECT @v_dSql1 += '      ) AS PROD_VERSION_TYPE, '''+ @v_version_type +''' AS VERSION_TYPE                        ' + char(10)
                                SELECT @v_dSql1 += '     ,'''+ @v_user_id +''' AS CREATE_ID, dbo.FN_SITE_TIME('''+ @v_site_id +''') AS CREATE_TIME ' + char(10)
                                SELECT @v_dSql1 += '     ,'''+ @v_user_id +''' AS UPDATE_ID, dbo.FN_SITE_TIME('''+ @v_site_id +''') AS UPDATE_TIME ' + char(10)
                                --SELECT @v_dSql1 += '     ,CONVERT(DATETIME, '''+ @v_site_id +''') AS APPLY_DATE   ' + char(10)
								SELECT @v_dSql1 += '     , CONVERT(DATETIME, CONVERT(VARCHAR,GETDATE(),112)) AS APPLY_DATE   ' + char(10) -- 당일 기본으로 설정... 20231016
                                SELECT @v_dSql1 += ' ) A                                                          ' + char(10)
                                SELECT @v_dSql1 += ' WHERE NOT EXISTS (                                           ' + char(10)
                                SELECT @v_dSql1 += '                  SELECT 1                                    ' + char(10)
                                SELECT @v_dSql1 += '                  FROM   SCM_ITEM_CONV_CALC_M AA WITH(NOLOCK) ' + char(10)
                                SELECT @v_dSql1 += '                  WHERE  A.COMPANY_ID = AA.COMPANY_ID         ' + char(10)
                                SELECT @v_dSql1 += '                  AND    A.FACTORY_ID = AA.FACTORY_ID         ' + char(10)
                                SELECT @v_dSql1 += '                  AND    A.MODEL_ID   = AA.MODEL_ID           ' + char(10)
                                SELECT @v_dSql1 += '                  AND    A.VERSION    = AA.VERSION            ' + char(10)
                                SELECT @v_dSql1 += '                  AND    A.OPERATION  = AA.OPERATION          ' + char(10)
                                SELECT @v_dSql1 += '                  AND    A.ITEM_ID    = AA.ITEM_ID            ' + char(10)
                                SELECT @v_dSql1 += '                  AND    A.CATEGORY   = AA.CATEGORY           ' + char(10)
                                SELECT @v_dSql1 += ' )                                                            ' + char(10)
								
								SELECT @v_dSql2 = ''
                                SELECT @v_dSql2 += ' INSERT INTO HIS_ITEM_CONV_CALC_M (                 ' + char(10)
                                SELECT @v_dSql2 += '       COMPANY_ID, FACTORY_ID, MODEL_ID             ' + char(10)
                                SELECT @v_dSql2 += '     , PJT_CODE,VERSION, OPERATION                  ' + char(10)
                                SELECT @v_dSql2 += '     , ITEM_ID, ELECTRODE_TYPE, CATEGORY            ' + char(10)
                                SELECT @v_dSql2 += '     , VALUE, MARK, PROD_VERSION_TYPE               ' + char(10)
                                SELECT @v_dSql2 += '     , VERSION_TYPE, CREATE_ID, CREATE_TIME         ' + char(10)
                                SELECT @v_dSql2 += '     , UPDATE_ID, UPDATE_TIME, JOB_USER_ID          ' + char(10)
                                SELECT @v_dSql2 += '     , JOB_TIME, JOB_TYPE                           ' + char(10)
                                SELECT @v_dSql2 += ' )                                                  ' + char(10)
                                SELECT @v_dSql2 += ' SELECT COMPANY_ID, FACTORY_ID, MODEL_ID            ' + char(10)
                                SELECT @v_dSql2 += '     , PJT_CODE, VERSION, OPERATION                 ' + char(10)
                                SELECT @v_dSql2 += '     , ITEM_ID, ELECTRODE_TYPE, CATEGORY            ' + char(10)
                                SELECT @v_dSql2 += '     , VALUE, MARK, PROD_VERSION_TYPE               ' + char(10)
                                SELECT @v_dSql2 += '     , VERSION_TYPE, CREATE_ID, CREATE_TIME         ' + char(10)
                                SELECT @v_dSql2 += '     , UPDATE_ID, UPDATE_TIME, '''+ @v_user_id +''' ' + char(10)
                                SELECT @v_dSql2 += '     , GETDATE(), ''MERGE''                         ' + char(10)
                                SELECT @v_dSql2 += ' FROM  SCM_ITEM_CONV_CALC_M A WITH(NOLOCK)          ' + char(10)
                                SELECT @v_dSql2 += ' WHERE FACTORY_ID = '''+ @v_factory_id +'''         ' + char(10)
                                SELECT @v_dSql2 += ' AND  MODEL_ID    = '''+ @v_model_id +'''           ' + char(10)
                                SELECT @v_dSql2 += ' AND  VERSION     =                                 ' + char(10)
								SELECT @v_dSql2 += '     ( CASE WHEN CHARINDEX(''.'','''+ @v_version +''',1) > 0 THEN                                                                    ' + char(10)
                                SELECT @v_dSql2 += '          ISNULL(REPLICATE(''0'', 3 - LEN(SUBSTRING('''+ @v_version +''', 1, ABS(CHARINDEX(''.'','''+ @v_version +''',1)-1)))),'''') ' + char(10)
                                SELECT @v_dSql2 += '          + SUBSTRING('''+ @v_version +''', 1, ABS(CHARINDEX(''.'','''+ @v_version +''',1)-1)   ) + ''.''  ' + char(10)
                                SELECT @v_dSql2 += '          + SUBSTRING('''+ @v_version +''', CHARINDEX(''.'','''+ @v_version +''',1)+1,10)                  ' + char(10)
                                SELECT @v_dSql2 += '       ELSE ISNULL(REPLICATE(''0'', 3 - LEN('''+ @v_version +''')),'''') + '''+ @v_version +'''              ' + char(10)
                                SELECT @v_dSql2 += '       END )                             ' + char(10)
                                SELECT @v_dSql2 += ' AND  OPERATION         = '''+ @v_operation_id +'''  ' + char(10)
                                SELECT @v_dSql2 += ' AND  ITEM_ID           = '''+ @v_item_id +'''       ' + char(10)
                                SELECT @v_dSql2 += ' AND  CATEGORY          = '''+ @v_category_id +'''   ' + char(10)
                                SELECT @v_dSql2 += ' AND  VERSION_TYPE      = '''+ @v_version_type +'''  ' + char(10)
                                SELECT @v_dSql2 += ' AND  PROD_VERSION_TYPE = '''+ @v_prod_ver_type +''' ' + char(10)

								SELECT @v_dSql = @v_dSql1 + @v_dSql2

						   END --'D'
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
                                SELECT @v_dSql += '         , CONVERT(DATETIME, '''+ @v_site_time +''')  ' + char(10)
                                SELECT @v_dSql += '     ) ;                                            ' + char(10)

						   END --'I'
					   /******************************************************************************/
					   /* UPDATE 경우 : UPDATE(UPDATE_MARK)                                          */
					   /******************************************************************************/
					   ELSE IF(@v_sys_flag ='UPDATE_MARK')  
							BEGIN
                                SELECT @v_dSql = ''

                                SELECT @v_dSql += ' UPDATE SCM_ITEM_CONV_CALC_M                                 ' + char(10)
                                SELECT @v_dSql += ' SET   UPDATE_ID    = '''+ @v_user_id +'''                   ' + char(10)
                                SELECT @v_dSql += '     , UPDATE_TIME  = dbo.FN_SITE_TIME('''+ @v_site_id +''') ' + char(10)
                                SELECT @v_dSql += '     , MARK         = '''+ @v_mark +'''                      ' + char(10)
                                SELECT @v_dSql += ' WHERE FACTORY_ID   = '''+ @v_factory_id +'''                ' + char(10)
                                SELECT @v_dSql += ' AND   MODEL_ID     = '''+ @v_model_id +'''                  ' + char(10)
                                SELECT @v_dSql += ' AND   VERSION      = '''+ @v_version +'''                   ' + char(10)
                                SELECT @v_dSql += ' AND   OPERATION    = '''+ @v_operation_id +'''              ' + char(10)
                                SELECT @v_dSql += ' AND   ITEM_ID      = '''+ @v_item_id +'''                   ' + char(10)
                                SELECT @v_dSql += ' AND   CATEGORY IN (''cell/batch'', ''Jumbo Roll (cell/m)'', ''Jumbo Roll (m/batch)'', ''Lane Number'', ''Pancake (cell/m)'', ''Pancake (m/batch)'') ' + char(10)
                                SELECT @v_dSql += ' AND   VERSION_TYPE = '''+ @v_version_type +'''        ' + char(10)
                                SELECT @v_dSql += ' AND   PROD_VERSION_TYPE = '''+ @v_prod_ver_type +'''  ' + char(10)

                                SELECT @v_dSql += ' INSERT INTO HIS_ITEM_CONV_CALC_M (                    ' + char(10)
                                SELECT @v_dSql += '      COMPANY_ID, FACTORY_ID, MODEL_ID                 ' + char(10)
                                SELECT @v_dSql += '     , PJT_CODE, VERSION, OPERATION                    ' + char(10)
                                SELECT @v_dSql += '     , ITEM_ID, ELECTRODE_TYPE, CATEGORY               ' + char(10)
                                SELECT @v_dSql += '     , VALUE, MARK, PROD_VERSION_TYPE                  ' + char(10)
                                SELECT @v_dSql += '     , VERSION_TYPE, CREATE_ID, CREATE_TIME            ' + char(10)
                                SELECT @v_dSql += '     , UPDATE_ID, UPDATE_TIME, JOB_USER_ID             ' + char(10)
                                SELECT @v_dSql += '     , JOB_TIME, JOB_TYPE                              ' + char(10)
                                SELECT @v_dSql += ' )                                                     ' + char(10)
                                SELECT @v_dSql += ' SELECT COMPANY_ID, FACTORY_ID, MODEL_ID               ' + char(10)
                                SELECT @v_dSql += '     , PJT_CODE, VERSION, OPERATION                    ' + char(10)
                                SELECT @v_dSql += '     , ITEM_ID, ELECTRODE_TYPE, CATEGORY               ' + char(10)
                                SELECT @v_dSql += '     , VALUE, MARK, PROD_VERSION_TYPE                  ' + char(10)
                                SELECT @v_dSql += '     , VERSION_TYPE, CREATE_ID, CREATE_TIME            ' + char(10)
                                SELECT @v_dSql += '     , UPDATE_ID, UPDATE_TIME, '''+ @v_user_id +'''    ' + char(10)
                                SELECT @v_dSql += '     , GETDATE(), ''UPDATE_DESC''                      ' + char(10)
                                SELECT @v_dSql += ' FROM  SCM_ITEM_CONV_CALC_M A WITH(NOLOCK)             ' + char(10)
                                SELECT @v_dSql += ' WHERE FACTORY_ID   = '''+ @v_factory_id +'''          ' + char(10)
                                SELECT @v_dSql += ' AND   MODEL_ID     = '''+ @v_model_id +'''            ' + char(10)
                                SELECT @v_dSql += ' AND   VERSION      = '''+ @v_version +'''             ' + char(10)
                                SELECT @v_dSql += ' AND   OPERATION    = '''+ @v_operation_id +'''        ' + char(10)
                                SELECT @v_dSql += ' AND   ITEM_ID      = '''+ @v_item_id +'''             ' + char(10)
                                SELECT @v_dSql += ' AND   CATEGORY IN ( ''cell/batch'', ''Jumbo Roll (cell/m)'', ''Jumbo Roll (m/batch)'', ''Lane Number'', ''Pancake (cell/m)'', ''Pancake (m/batch)'' ) ' + char(10)
                                SELECT @v_dSql += ' AND   VERSION_TYPE = '''+ @v_version_type +'''        ' + char(10)
                                SELECT @v_dSql += ' AND   PROD_VERSION_TYPE = '''+ @v_prod_ver_type +'''  ' + char(10)

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
					   /* UPDATE 경우 : UPDATE(UPDATE_PANCAKE_M_BATCH_UPDATE)                        */
					   /******************************************************************************/
					   ELSE IF(@v_sys_flag ='UPDATE_PANCAKE_M_BATCH_UPDATE')  
							BEGIN
                                SELECT @v_dSql = ''

                                SELECT @v_dSql += ' MERGE INTO SCM_ITEM_CONV_CALC_M AS A  ' + char(10)
                                SELECT @v_dSql += ' USING (                               ' + char(10)
                                SELECT @v_dSql += '       SELECT A.*, ''Pancake (m/batch)'' AS CATEGORY, (A.VALUE_A * A.VALUE_B) AS VALUE ' + char(10)
                                SELECT @v_dSql += '       FROM (                                                          ' + char(10)
                                SELECT @v_dSql += '             SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
                                SELECT @v_dSql += '                 , A.FACTORY_ID, A.MODEL_ID, A.PJT_CODE                ' + char(10)
                                SELECT @v_dSql += '                 , A.VERSION, A.OPERATION, A.ITEM_ID                   ' + char(10)
                                SELECT @v_dSql += '                 , MAX(A.ELECTRODE_TYPE) AS ELECTRODE_TYPE             ' + char(10)
                                SELECT @v_dSql += '                 , MAX(CASE WHEN A.CATEGORY = ''Jumbo Roll (m/batch)'' THEN A.VALUE ' + char(10)
                                SELECT @v_dSql += '                            ELSE NULL END ) AS VALUE_A                              ' + char(10)
                                SELECT @v_dSql += '                 , MAX(CASE WHEN A.CATEGORY = ''Lane Number'' THEN                  ' + char(10)
                                SELECT @v_dSql += '                          ( CASE WHEN A.VALUE>0 THEN A.VALUE ELSE NULL END )        ' + char(10)
                                SELECT @v_dSql += '                       ELSE NULL END) AS VALUE_B                                    ' + char(10)
                                SELECT @v_dSql += '                 , A.MAX_VER_FLAG, A.PROD_VERSION_TYPE, A.VERSION_TYPE              ' + char(10)
                                SELECT @v_dSql += '                 , (CASE WHEN MAX(ISNULL(A.APPLY_DATE,'''')) = '''' THEN NULL       ' + char(10)
                                SELECT @v_dSql += '                    ELSE MAX(ISNULL(A.APPLY_DATE,'''')) END) AS APPLY_DATE          ' + char(10)
                                SELECT @v_dSql += '             FROM (                                                                 ' + char(10)
                                SELECT @v_dSql += '                  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID         ' + char(10)
                                SELECT @v_dSql += '                      , A.FACTORY_ID, A.MODEL_ID, MAX(A.PJT_CODE) AS PJT_CODE       ' + char(10)
                                SELECT @v_dSql += '                      , MAX(A.VERSION) AS VERSION, A.OPERATION, A.ITEM_ID           ' + char(10)
                                SELECT @v_dSql += '                      , MAX(A.ELECTRODE_TYPE) AS ELECTRODE_TYPE, A.CATEGORY         ' + char(10)
                                SELECT @v_dSql += '                      , MAX(A.VALUE) AS VALUE, ''Y'' AS MAX_VER_FLAG                ' + char(10)
                                SELECT @v_dSql += '                      , A.PROD_VERSION_TYPE, A.VERSION_TYPE                         ' + char(10)
                                SELECT @v_dSql += '                      , (CASE WHEN MAX(ISNULL(A.APPLY_DATE,'''')) = '''' THEN NULL  ' + char(10)
                                SELECT @v_dSql += '                  	      ELSE MAX(ISNULL(A.APPLY_DATE,'''')) END) AS APPLY_DATE   ' + char(10)
                                SELECT @v_dSql += '                  FROM (                                                            ' + char(10)
                                SELECT @v_dSql += '                        SELECT A.*                                                  ' + char(10)
                                SELECT @v_dSql += '                            , ROW_NUMBER() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID    ' + char(10)
                                SELECT @v_dSql += '                  		        , A.PLANT_ID, A.FACTORY_ID, A.MODEL_ID, A.OPERATION, A.ITEM_ID         ' + char(10)
                                SELECT @v_dSql += '                  				, A.CATEGORY, A.PROD_VERSION_TYPE, A.VERSION_TYPE                      ' + char(10)
                                SELECT @v_dSql += '                                ORDER BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.MODEL_ID ' + char(10)
                                SELECT @v_dSql += '                  			      , A.OPERATION, A.ITEM_ID, A.CATEGORY, A.PROD_VERSION_TYPE            ' + char(10)
                                SELECT @v_dSql += '                  				  , A.VERSION_TYPE, A.CH_VERSION DESC ) AS ROW_NUM                     ' + char(10)
                                SELECT @v_dSql += '                        FROM (                                               ' + char(10)
                                SELECT @v_dSql += '                              SELECT DISTINCT A.*                            ' + char(10)
                                SELECT @v_dSql += '                                 , (CASE WHEN A.VERSION LIKE ''Z%'' THEN REPLACE( A.VERSION, ''Z'', ''/'') ' + char(10)
                                SELECT @v_dSql += '                                    ELSE A.VERSION END) AS CH_VERSION        ' + char(10)
                                SELECT @v_dSql += '                              FROM   SCM_ITEM_CONV_CALC_M A                  ' + char(10)
                                SELECT @v_dSql += '                              INNER JOIN BUF_ITEM_CONV_CALC_M B WITH(NOLOCK) ' + char(10)
                                SELECT @v_dSql += '                              ON  A.DIVISION_ID = B.DIVISION_ID              ' + char(10)
                                SELECT @v_dSql += '                              AND A.SITE_ID     = B.SITE_ID                  ' + char(10)
                                SELECT @v_dSql += '                              AND A.PLANT_ID    = B.PLANT_ID                 ' + char(10)
                                SELECT @v_dSql += '                              AND A.FACTORY_ID  = B.FACTORY_ID               ' + char(10)
                                SELECT @v_dSql += '                              AND A.MODEL_ID    = B.MODEL_ID                 ' + char(10)
                                SELECT @v_dSql += '                              AND A.OPERATION   = B.OPERATION                ' + char(10)
                                SELECT @v_dSql += '                              AND A.ITEM_ID     = B.ITEM_ID                  ' + char(10)
                                SELECT @v_dSql += '                              AND B.JOB_USER_ID = '''+ @v_user_id +'''       ' + char(10)
                                SELECT @v_dSql += '                              WHERE A.MAX_VER_FLAG = ''Y''                   ' + char(10)
                                SELECT @v_dSql += '                              AND   A.CATEGORY IN (''Jumbo Roll (m/batch)'',''Lane Number'') ' + char(10)
                                SELECT @v_dSql += '                        ) A            ' + char(10)
                                SELECT @v_dSql += '                  ) A                  ' + char(10)
                                SELECT @v_dSql += '                  WHERE A.ROW_NUM = 1  ' + char(10)
                                SELECT @v_dSql += '                  GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID    ' + char(10)
                                SELECT @v_dSql += '                  , A.FACTORY_ID, A.OPERATION, A.MODEL_ID, A.ITEM_ID, A.CATEGORY ' + char(10)
                                SELECT @v_dSql += '                  , A.PROD_VERSION_TYPE, A.VERSION_TYPE                          ' + char(10)
                                SELECT @v_dSql += '             ) A                                                                 ' + char(10)
                                SELECT @v_dSql += '             GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID         ' + char(10)
                                SELECT @v_dSql += '                 , A.FACTORY_ID, A.MODEL_ID, A.PJT_CODE, A.VERSION               ' + char(10)
                                SELECT @v_dSql += '                 , A.OPERATION, A.ITEM_ID, A.MAX_VER_FLAG, A.PROD_VERSION_TYPE   ' + char(10)
                                SELECT @v_dSql += '             	, A.VERSION_TYPE  ' + char(10)
                                SELECT @v_dSql += '       ) A                         ' + char(10)
                                SELECT @v_dSql += '       WHERE A.VALUE_A IS NOT NULL ' + char(10)
                                SELECT @v_dSql += '       AND   A.VALUE_B IS NOT NULL ' + char(10)
                                SELECT @v_dSql += ' ) AS B                            ' + char(10)
                                SELECT @v_dSql += ' ON (A.COMPANY_ID  = B.COMPANY_ID  ' + char(10)
                                SELECT @v_dSql += ' AND A.FACTORY_ID  = B.FACTORY_ID  ' + char(10)
                                SELECT @v_dSql += ' AND A.MODEL_ID    = B.MODEL_ID    ' + char(10)
                                SELECT @v_dSql += ' AND A.VERSION     = B.VERSION     ' + char(10)
                                SELECT @v_dSql += ' AND A.OPERATION   = B.OPERATION   ' + char(10)
                                SELECT @v_dSql += ' AND A.ITEM_ID     = B.ITEM_ID     ' + char(10)
                                SELECT @v_dSql += ' AND A.CATEGORY    = B.CATEGORY    ' + char(10)
                                SELECT @v_dSql += ' AND A.PROD_VERSION_TYPE    = B.PROD_VERSION_TYPE )           ' + char(10)
                                SELECT @v_dSql += ' WHEN MATCHED THEN                                            ' + char(10)
                                SELECT @v_dSql += '     UPDATE SET UPDATE_ID   = '''+ @v_user_id +'''            ' + char(10)
                                SELECT @v_dSql += '       , UPDATE_TIME = dbo.FN_SITE_TIME('''+ @v_site_id +''') ' + char(10)
                                SELECT @v_dSql += '       , VALUE       = B.VALUE    ' + char(10)
                                SELECT @v_dSql += ' WHEN NOT MATCHED THEN            ' + char(10)
                                SELECT @v_dSql += '     INSERT (                     ' + char(10)
                                SELECT @v_dSql += '         COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID   ' + char(10)
                                SELECT @v_dSql += '       , FACTORY_ID, MODEL_ID, PJT_CODE, VERSION      ' + char(10)
                                SELECT @v_dSql += '       , OPERATION, ITEM_ID, ELECTRODE_TYPE, CATEGORY ' + char(10)
                                SELECT @v_dSql += '       , MAX_VER_FLAG, VALUE, MARK, PROD_VERSION_TYPE ' + char(10)
                                SELECT @v_dSql += '       , VERSION_TYPE, CREATE_ID, CREATE_TIME         ' + char(10)
                                SELECT @v_dSql += '       , UPDATE_ID, UPDATE_TIME, APPLY_DATE           ' + char(10)
                                SELECT @v_dSql += '     ) VALUES (                                       ' + char(10)
                                SELECT @v_dSql += '         B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID   ' + char(10)
                                SELECT @v_dSql += '       , B.FACTORY_ID, B.MODEL_ID, B.PJT_CODE, B.VERSION      ' + char(10)
                                SELECT @v_dSql += '       , B.OPERATION, B.ITEM_ID, B.ELECTRODE_TYPE, B.CATEGORY ' + char(10)
                                SELECT @v_dSql += '       , B.MAX_VER_FLAG, B.VALUE, NULL, B.PROD_VERSION_TYPE   ' + char(10)
                                SELECT @v_dSql += '       , B.VERSION_TYPE, '''+ @v_user_id +''', dbo.FN_SITE_TIME('''+ @v_site_id +''') ' + char(10)
                                SELECT @v_dSql += '       , '''+ @v_user_id +''', dbo.FN_SITE_TIME('''+ @v_site_id +'''), B.APPLY_DATE   ' + char(10)
                                SELECT @v_dSql += '     ); ' + char(10)

						   END --'I'
					   /******************************************************************************/
					   /* UPDATE 경우 : UPDATE(UPDATE_PANCAKE_CELL_M_UPDATE)                         */
					   /******************************************************************************/
					   ELSE IF(@v_sys_flag ='UPDATE_PANCAKE_CELL_M_UPDATE')  
							BEGIN
                                SELECT @v_dSql = ''
                                SELECT @v_dSql += ' MERGE INTO SCM_ITEM_CONV_CALC_M AS A ' + char(10)
                                SELECT @v_dSql += ' USING (                              ' + char(10)
                                SELECT @v_dSql += '       SELECT A.*, ''Pancake (cell/m)'' AS CATEGORY, (A.VALUE_A / A.VALUE_B) AS VALUE ' + char(10)
                                SELECT @v_dSql += '       FROM (                                                          ' + char(10)
                                SELECT @v_dSql += '             SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
                                SELECT @v_dSql += '                 , A.FACTORY_ID, A.MODEL_ID, A.PJT_CODE                ' + char(10)
                                SELECT @v_dSql += '                 , A.VERSION, A.OPERATION, A.ITEM_ID                   ' + char(10)
                                SELECT @v_dSql += '                 , MAX(A.ELECTRODE_TYPE) AS ELECTRODE_TYPE             ' + char(10)
                                SELECT @v_dSql += '                 , MAX( CASE WHEN A.CATEGORY = ''Jumbo Roll (cell/m)'' THEN A.VALUE ' + char(10) 
                                SELECT @v_dSql += '             	       ELSE NULL END) AS VALUE_A                              ' + char(10)
                                SELECT @v_dSql += '                 , MAX( CASE WHEN A.CATEGORY = ''Lane Number'' THEN            ' + char(10)
                                SELECT @v_dSql += '             	         ( CASE WHEN A.VALUE>0 THEN A.VALUE ELSE NULL END )   ' + char(10)
                                SELECT @v_dSql += '                        ELSE NULL END ) AS VALUE_B                             ' + char(10)
                                SELECT @v_dSql += '                 , A.MAX_VER_FLAG, A.PROD_VERSION_TYPE, A.VERSION_TYPE         ' + char(10)
                                SELECT @v_dSql += '                 , ( CASE WHEN MAX(ISNULL(A.APPLY_DATE,'''')) = '''' THEN NULL ' + char(10)
                                SELECT @v_dSql += '             	    ELSE MAX(ISNULL(A.APPLY_DATE,'''') ) END ) AS APPLY_DATE  ' + char(10)
                                SELECT @v_dSql += '             FROM (                                                            ' + char(10)
                                SELECT @v_dSql += '                   SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID           ' + char(10)
                                SELECT @v_dSql += '                         , A.FACTORY_ID, A.MODEL_ID, MAX(A.PJT_CODE) AS PJT_CODE       ' + char(10)
                                SELECT @v_dSql += '                         , MAX(A.VERSION) AS VERSION, A.OPERATION, A.ITEM_ID           ' + char(10)
                                SELECT @v_dSql += '                         , MAX(A.ELECTRODE_TYPE) AS ELECTRODE_TYPE, A.CATEGORY         ' + char(10)
                                SELECT @v_dSql += '                         , MAX(A.VALUE) AS VALUE, ''Y'' AS MAX_VER_FLAG                ' + char(10)
                                SELECT @v_dSql += '                         ,  A.PROD_VERSION_TYPE, A.VERSION_TYPE                        ' + char(10)
                                SELECT @v_dSql += '                         , ( CASE WHEN MAX(ISNULL(A.APPLY_DATE,'''')) = '''' THEN NULL ' + char(10)
                                SELECT @v_dSql += '                         ELSE MAX(ISNULL(A.APPLY_DATE,'''') ) END) AS APPLY_DATE       ' + char(10)
                                SELECT @v_dSql += '                   FROM (                                                              ' + char(10)
                                SELECT @v_dSql += '                         SELECT A.*                                                    ' + char(10)
                                SELECT @v_dSql += '                             , ROW_NUMBER() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID   ' + char(10)
                                SELECT @v_dSql += '                                   , A.PLANT_ID, A.FACTORY_ID, A.MODEL_ID, A.OPERATION, A.ITEM_ID       ' + char(10)
                                SELECT @v_dSql += '                                   , A.CATEGORY, A.PROD_VERSION_TYPE, A.VERSION_TYPE                    ' + char(10)
                                SELECT @v_dSql += '                                ORDER BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.MODEL_ID ' + char(10)
                                SELECT @v_dSql += '                                   , A.OPERATION, A.ITEM_ID, A.CATEGORY, A.PROD_VERSION_TYPE            ' + char(10)
                                SELECT @v_dSql += '                                   , A.VERSION_TYPE, A.CH_VERSION DESC ) AS ROW_NUM                     ' + char(10)
                                SELECT @v_dSql += '                         FROM (                                                                         ' + char(10)
                                SELECT @v_dSql += '                               SELECT DISTINCT A.*                                                      ' + char(10)
                                SELECT @v_dSql += '                                 , (CASE WHEN A.VERSION LIKE ''Z%'' THEN REPLACE( A.VERSION, ''Z'', ''/'') ' + char(10)
                                SELECT @v_dSql += '                                    ELSE A.VERSION END) AS CH_VERSION         ' + char(10)
                                SELECT @v_dSql += '                               FROM   SCM_ITEM_CONV_CALC_M A                  ' + char(10)
                                SELECT @v_dSql += '                               INNER JOIN BUF_ITEM_CONV_CALC_M B WITH(NOLOCK) ' + char(10)
                                SELECT @v_dSql += '                               ON  A.DIVISION_ID = B.DIVISION_ID              ' + char(10)
                                SELECT @v_dSql += '                               AND A.SITE_ID     = B.SITE_ID                  ' + char(10)
                                SELECT @v_dSql += '                               AND A.PLANT_ID    = B.PLANT_ID                 ' + char(10)
                                SELECT @v_dSql += '                               AND A.FACTORY_ID  = B.FACTORY_ID               ' + char(10)
                                SELECT @v_dSql += '                               AND A.MODEL_ID    = B.MODEL_ID                 ' + char(10)
                                SELECT @v_dSql += '                               AND A.OPERATION   = B.OPERATION                ' + char(10)
                                SELECT @v_dSql += '                               AND A.ITEM_ID     = B.ITEM_ID                  ' + char(10)
                                SELECT @v_dSql += '                               AND B.JOB_USER_ID = '''+ @v_user_id +'''       ' + char(10)
                                SELECT @v_dSql += '                               WHERE  A.MAX_VER_FLAG = ''Y''                  ' + char(10)
                                SELECT @v_dSql += '                               AND    A.CATEGORY IN (''Jumbo Roll (cell/m)'',''Lane Number'') ' + char(10)
                                SELECT @v_dSql += '                         ) A           ' + char(10)
                                SELECT @v_dSql += '                   ) A                 ' + char(10)
                                SELECT @v_dSql += '                   WHERE A.ROW_NUM = 1 ' + char(10)
                                SELECT @v_dSql += '                   GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
                                SELECT @v_dSql += '                       , A.FACTORY_ID, A.OPERATION, A.MODEL_ID, A.ITEM_ID      ' + char(10)
                                SELECT @v_dSql += '                       , A.CATEGORY, A.PROD_VERSION_TYPE, A.VERSION_TYPE       ' + char(10)
                                SELECT @v_dSql += '             ) A                                                               ' + char(10)
                                SELECT @v_dSql += '             GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
                                SELECT @v_dSql += '                 ,A.MODEL_ID, A.PJT_CODE,A.VERSION, A.OPERATION, A.ITEM_ID             ' + char(10)
                                SELECT @v_dSql += '                 ,A.MAX_VER_FLAG, A.PROD_VERSION_TYPE, A.VERSION_TYPE                  ' + char(10)
                                SELECT @v_dSql += '       ) A                         ' + char(10)
                                SELECT @v_dSql += '       WHERE A.VALUE_A IS NOT NULL ' + char(10)
                                SELECT @v_dSql += '       AND   A.VALUE_B IS NOT NULL ' + char(10)
                                SELECT @v_dSql += ' ) AS B                            ' + char(10)
                                SELECT @v_dSql += ' ON (A.COMPANY_ID  = B.COMPANY_ID  ' + char(10)
                                SELECT @v_dSql += ' AND A.FACTORY_ID  = B.FACTORY_ID  ' + char(10)
                                SELECT @v_dSql += ' AND A.MODEL_ID    = B.MODEL_ID    ' + char(10)
                                SELECT @v_dSql += ' AND A.VERSION     = B.VERSION     ' + char(10)
                                SELECT @v_dSql += ' AND A.OPERATION   = B.OPERATION   ' + char(10)
                                SELECT @v_dSql += ' AND A.ITEM_ID     = B.ITEM_ID     ' + char(10)
                                SELECT @v_dSql += ' AND A.CATEGORY    = B.CATEGORY    ' + char(10)
                                SELECT @v_dSql += ' AND A.PROD_VERSION_TYPE = B.PROD_VERSION_TYPE )   ' + char(10)
                                SELECT @v_dSql += ' WHEN MATCHED THEN                                 ' + char(10)
                                SELECT @v_dSql += '     UPDATE SET UPDATE_ID   = '''+ @v_user_id +''' ' + char(10)
                                SELECT @v_dSql += '       , UPDATE_TIME = dbo.FN_SITE_TIME('''+ @v_site_id +''') ' + char(10)
                                SELECT @v_dSql += '       , VALUE       = B.VALUE                                ' + char(10)
                                SELECT @v_dSql += ' WHEN NOT MATCHED THEN                                        ' + char(10)
                                SELECT @v_dSql += '     INSERT (                                                 ' + char(10)
                                SELECT @v_dSql += '           COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID         ' + char(10)
                                SELECT @v_dSql += '         , FACTORY_ID, MODEL_ID, PJT_CODE, VERSION            ' + char(10)
                                SELECT @v_dSql += '         , OPERATION, ITEM_ID, ELECTRODE_TYPE, CATEGORY       ' + char(10)
                                SELECT @v_dSql += '         , MAX_VER_FLAG, VALUE, MARK, PROD_VERSION_TYPE       ' + char(10)
                                SELECT @v_dSql += '         , VERSION_TYPE, CREATE_ID, CREATE_TIME               ' + char(10)
                                SELECT @v_dSql += '         , UPDATE_ID, UPDATE_TIME, APPLY_DATE                 ' + char(10)
                                SELECT @v_dSql += '     ) VALUES (                                               ' + char(10)
                                SELECT @v_dSql += '         B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID   ' + char(10)
                                SELECT @v_dSql += '       , B.FACTORY_ID, B.MODEL_ID, B.PJT_CODE, B.VERSION      ' + char(10)
                                SELECT @v_dSql += '       , B.OPERATION, B.ITEM_ID, B.ELECTRODE_TYPE, B.CATEGORY ' + char(10)
                                SELECT @v_dSql += '       , B.MAX_VER_FLAG, B.VALUE, NULL, B.PROD_VERSION_TYPE   ' + char(10)
                                SELECT @v_dSql += '       , B.VERSION_TYPE, '''+ @v_user_id +''', dbo.FN_SITE_TIME('''+ @v_site_id +''') ' + char(10)
                                SELECT @v_dSql += '       , '''+ @v_user_id +''', dbo.FN_SITE_TIME('''+ @v_site_id +'''), B.APPLY_DATE   ' + char(10)
                                SELECT @v_dSql += '     ); ' + char(10)

						   END --'I'
					   /******************************************************************************/
					   /* ADD Popup 경우 : MERGE(MERGE_ADD_POPUP Popup)                                  */
					   /******************************************************************************/
					   ELSE IF(@v_sys_flag ='MERGE_ADD_POPUP')  
							BEGIN
							    SELECT @v_site_time = ''
								SELECT @v_site_time = CONVERT(VARCHAR, DBO.FN_SITE_TIME('''+ @v_site_id +'''), 20)

                                SELECT @v_dSql1 = ''
                                SELECT @v_dSql1 += ' MERGE INTO SCM_ITEM_CONV_CALC_M AS A ' + char(10)
                                SELECT @v_dSql1 += ' USING (                              ' + char(10)
                                SELECT @v_dSql1 += '    SELECT '''+ @v_company_id +''' AS COMPANY_ID, '''+ @v_factory_id +''' AS FACTORY_ID,'''+ @v_model_id +''' AS MODEL_ID ' + char(10)
                                SELECT @v_dSql1 += '       , ( CASE WHEN CHARINDEX(''.'','''+ @v_version +''',1) > 0 THEN                                                     ' + char(10)
                                SELECT @v_dSql1 += '                 ISNULL(REPLICATE(''0'', 3 - LEN(SUBSTRING('''+ @v_version +''', 1, ABS(CHARINDEX(''.'','''+ @v_version +''',1)-1)))),'''')  ' + char(10)
                                SELECT @v_dSql1 += '                 + SUBSTRING('''+ @v_version +''', 1, ABS(CHARINDEX(''.'','''+ @v_version +''',1)-1)   ) + ''.''  ' + char(10)
                                SELECT @v_dSql1 += '                 + SUBSTRING('''+ @v_version +''', CHARINDEX(''.'','''+ @v_version +''',1)+1,10)                  ' + char(10)
                                SELECT @v_dSql1 += '           ELSE                                                                                    ' + char(10)
                                SELECT @v_dSql1 += '               ISNULL(REPLICATE(''0'', 3 - LEN('''+ @v_version +''')),'''') + '''+ @v_version +''' ' + char(10)
                                SELECT @v_dSql1 += '           END ) AS VERSION                              ' + char(10)
                                SELECT @v_dSql1 += '       , '''+ @v_operation_id +''' AS OPERATION          ' + char(10)
                                SELECT @v_dSql1 += '       , '''+ @v_item_id +''' AS ITEM_ID                 ' + char(10)
                                SELECT @v_dSql1 += '       , '''+ @v_category_id +''' AS CATEGORY            ' + char(10)
                                SELECT @v_dSql1 += '       , '''+ @v_version_type +''' AS VERSION_TYPE       ' + char(10)
                                SELECT @v_dSql1 += '       , '''+ @v_prod_ver_type +''' AS PROD_VERSION_TYPE ' + char(10)
                                SELECT @v_dSql1 += ' ) AS B                                             ' + char(10)
                                SELECT @v_dSql1 += ' ON (     A.COMPANY_ID  = B.COMPANY_ID              ' + char(10)
                                SELECT @v_dSql1 += '      AND A.FACTORY_ID  = B.FACTORY_ID              ' + char(10)
                                SELECT @v_dSql1 += '      AND A.MODEL_ID    = B.MODEL_ID                ' + char(10)
                                SELECT @v_dSql1 += '      AND A.VERSION     = B.VERSION                 ' + char(10)
                                SELECT @v_dSql1 += '      AND A.OPERATION   = B.OPERATION               ' + char(10)
                                SELECT @v_dSql1 += '      AND A.ITEM_ID     = B.ITEM_ID                 ' + char(10)
                                SELECT @v_dSql1 += '      AND A.CATEGORY    = B.CATEGORY                ' + char(10)
                                SELECT @v_dSql1 += '      AND A.PROD_VERSION_TYPE = B.PROD_VERSION_TYPE ' + char(10)
                                SELECT @v_dSql1 += '     )                                              ' + char(10)
                                SELECT @v_dSql1 += ' WHEN MATCHED THEN                                  ' + char(10)
                                SELECT @v_dSql1 += '     UPDATE SET UPDATE_ID   = '''+ @v_user_id +'''  ' + char(10)
                                SELECT @v_dSql1 += '        , UPDATE_TIME = dbo.FN_SITE_TIME('''+ @v_site_id +''')                                             ' + char(10)
								SELECT @v_dSql1 += '        , VALUE       = CAST(ISNULL(REPLACE(RTRIM(LTRIM('''+ @v_value +''')),'''',0),0) AS DECIMAL(18,5) ) ' + char(10)
                                --SELECT @v_dSql1 += '        , VALUE       = CONVERT(NUMERIC(18,5), ISNULL(REPLACE(RTRIM(LTRIM('''+ @v_value +''')),'''',0),0) ) ' + char(10)
                                SELECT @v_dSql1 += '        , MARK        = RTRIM(LTRIM('''+ @v_mark +''')) ' + char(10)
                                SELECT @v_dSql1 += ' WHEN NOT MATCHED THEN                                  ' + char(10)
                                SELECT @v_dSql1 += '     INSERT (                                           ' + char(10)
                                SELECT @v_dSql1 += '         COMPANY_ID, DIVISION_ID, SITE_ID               ' + char(10)
                                SELECT @v_dSql1 += '       , PLANT_ID, FACTORY_ID, MODEL_ID                 ' + char(10)
                                SELECT @v_dSql1 += '       , PJT_CODE, VERSION, OPERATION                   ' + char(10)
                                SELECT @v_dSql1 += '       , ITEM_ID, ELECTRODE_TYPE, CATEGORY              ' + char(10)
                                SELECT @v_dSql1 += '       , MAX_VER_FLAG, VALUE, MARK                      ' + char(10)
                                SELECT @v_dSql1 += '       , PROD_VERSION_TYPE,VERSION_TYPE,CREATE_ID       ' + char(10)
                                SELECT @v_dSql1 += '       , CREATE_TIME, UPDATE_ID, UPDATE_TIME            ' + char(10)
                                SELECT @v_dSql1 += '       , APPLY_DATE                                     ' + char(10)
                                SELECT @v_dSql1 += '     ) VALUES (                                         ' + char(10)
                                SELECT @v_dSql1 += '         '''+ @v_company_id +''', '''+ @v_division_id +''', '''+ @v_site_id +''' ' + char(10)
                                SELECT @v_dSql1 += '       , '''+ @v_plant_id +''', '''+ @v_factory_id +''', '''+ @v_model_id +'''   ' + char(10)
                                SELECT @v_dSql1 += '       , '''+ @v_pjt_code +'''                                                   ' + char(10)
                                SELECT @v_dSql1 += '       , ( CASE WHEN CHARINDEX(''.'','''+ @v_version +''',1) > 0 THEN            ' + char(10)
                                SELECT @v_dSql1 += '                ISNULL(REPLICATE(''0'', 3 - LEN(SUBSTRING('''+ @v_version +''', 1, ABS(CHARINDEX(''.'','''+ @v_version +''',1)-1)))),'''') ' + char(10)
                                SELECT @v_dSql1 += '              + SUBSTRING('''+ @v_version +''', 1, ABS(CHARINDEX(''.'','''+ @v_version +''',1)-1)   ) + ''.''                              ' + char(10)
                                SELECT @v_dSql1 += '              + SUBSTRING('''+ @v_version +''', CHARINDEX(''.'','''+ @v_version +''',1)+1,10)       ' + char(10)
                                SELECT @v_dSql1 += '           ELSE                                                                                     ' + char(10)
                                SELECT @v_dSql1 += '                ISNULL(REPLICATE(''0'', 3 - LEN('''+ @v_version +''')),'''') + '''+ @v_version +''' ' + char(10)
                                SELECT @v_dSql1 += '           END )                                                                                    ' + char(10)
                                SELECT @v_dSql1 += '       , '''+ @v_operation_id +'''                                                                  ' + char(10)
                                SELECT @v_dSql1 += '       , '''+ @v_item_id +''', '''+ @v_electrode_type +''', '''+ @v_category_id +'''                ' + char(10)
								SELECT @v_dSql1 += '       , '''+ @v_max_version +''', CAST(ISNULL(REPLACE(RTRIM(LTRIM('''+ @v_value +''')),'''',0),0)  AS DECIMAL(18,5) ), '''+ @v_mark +''' ' + char(10)
                                --SELECT @v_dSql1 += '       , '''+ @v_max_version +''', CONVERT(NUMERIC(18,5), ISNULL(REPLACE(RTRIM(LTRIM('''+ @v_value +''')),'''',0),0) ), '''+ @v_mark +''' ' + char(10)
                                SELECT @v_dSql1 += '       , '''+ @v_prod_ver_type +''', '''+ @v_version_type +''', '''+ @v_user_id +'''                          ' + char(10)
                                SELECT @v_dSql1 += '       , dbo.FN_SITE_TIME('''+ @v_site_id +'''), '''+ @v_user_id +''', dbo.FN_SITE_TIME('''+ @v_site_id +''') ' + char(10)
                                SELECT @v_dSql1 += '       , CONVERT(DATETIME, '''+ @v_site_time +''') ' + char(10)
                                SELECT @v_dSql1 += '     )                                      ' + char(10)
                                SELECT @v_dSql1 += ' ;                                          ' + char(10)
                                
								SELECT @v_dSql2  = ''
                                SELECT @v_dSql2 += ' INSERT INTO HIS_ITEM_CONV_CALC_M (         ' + char(10)
                                SELECT @v_dSql2 += '       COMPANY_ID, FACTORY_ID,MODEL_ID      ' + char(10)
                                SELECT @v_dSql2 += '     , PJT_CODE, VERSION, OPERATION         ' + char(10)
                                SELECT @v_dSql2 += '     , ITEM_ID, ELECTRODE_TYPE, CATEGORY    ' + char(10)
                                SELECT @v_dSql2 += '     , VALUE, MARK, PROD_VERSION_TYPE       ' + char(10)
                                SELECT @v_dSql2 += '     , VERSION_TYPE, ORG_VERSION, CREATE_ID ' + char(10)
                                SELECT @v_dSql2 += '     , CREATE_TIME, UPDATE_ID, UPDATE_TIME  ' + char(10)
                                SELECT @v_dSql2 += '     , JOB_USER_ID, JOB_TIME, JOB_TYPE      ' + char(10)
                                SELECT @v_dSql2 += ' )                                          ' + char(10)
                                SELECT @v_dSql2 += ' SELECT COMPANY_ID, FACTORY_ID,MODEL_ID     ' + char(10)
                                SELECT @v_dSql2 += '    , PJT_CODE, VERSION, OPERATION          ' + char(10)
                                SELECT @v_dSql2 += '    , ITEM_ID, ELECTRODE_TYPE, CATEGORY     ' + char(10)
                                SELECT @v_dSql2 += '    , VALUE, MARK, PROD_VERSION_TYPE        ' + char(10)
                                SELECT @v_dSql2 += '    , VERSION_TYPE, '''+ @v_org_version +''', CREATE_ID      ' + char(10) --org_version
                                SELECT @v_dSql2 += '    , CREATE_TIME, UPDATE_ID, UPDATE_TIME                    ' + char(10)
                                SELECT @v_dSql2 += '    , '''+ @v_user_id +''', GETDATE(), '''+ @v_job_type +''' ' + char(10)
                                SELECT @v_dSql2 += ' FROM  SCM_ITEM_CONV_CALC_M A WITH(NOLOCK)                   ' + char(10)
                                SELECT @v_dSql2 += ' WHERE FACTORY_ID  = '''+ @v_factory_id +'''                 ' + char(10)
                                SELECT @v_dSql2 += ' AND   MODEL_ID    = '''+ @v_model_id +'''                   ' + char(10)
                                SELECT @v_dSql2 += ' AND   VERSION     =                                         ' + char(10)
                                SELECT @v_dSql2 += '         ( CASE WHEN CHARINDEX(''.'','''+ @v_version +''',1) > 0 THEN ' + char(10)
                                SELECT @v_dSql2 += '              ISNULL(REPLICATE(''0'', 3 - LEN(SUBSTRING('''+ @v_version +''', 1, ABS(CHARINDEX(''.'','''+ @v_version +''',1)-1)))),'''') ' + char(10)
                                SELECT @v_dSql2 += '              + SUBSTRING('''+ @v_version +''', 1, ABS(CHARINDEX(''.'','''+ @v_version +''',1)-1)   ) + ''.''                            ' + char(10)
                                SELECT @v_dSql2 += '              + SUBSTRING('''+ @v_version +''', CHARINDEX(''.'','''+ @v_version +''',1)+1,10)       ' + char(10)
                                SELECT @v_dSql2 += '           ELSE                                                                                     ' + char(10)
                                SELECT @v_dSql2 += '                ISNULL(REPLICATE(''0'', 3 - LEN('''+ @v_version +''')),'''') + '''+ @v_version +''' ' + char(10)
                                SELECT @v_dSql2 += '           END )                                      ' + char(10)
                                SELECT @v_dSql2 += ' AND   OPERATION     = '''+ @v_operation_id +'''      ' + char(10)
                                SELECT @v_dSql2 += ' AND   ITEM_ID       = '''+ @v_item_id +'''           ' + char(10)
                                SELECT @v_dSql2 += ' AND   CATEGORY      = '''+ @v_category_id +'''       ' + char(10)
                                SELECT @v_dSql2 += ' AND   VERSION_TYPE	 = '''+ @v_version_type +'''      ' + char(10)
                                SELECT @v_dSql2 += ' AND   PROD_VERSION_TYPE = '''+ @v_prod_ver_type +''' ' + char(10)

								SELECT @v_dSql = @v_dSql1 + @v_dSql2

						    END --'I'

                       /******************************************************************************/
					   /* ADD Popup 경우 : ADD(update_pancake_M_Batch_Add Popup)                         */
					   /******************************************************************************/
					   ELSE IF(@v_sys_flag ='UPDATE_PANCAKE_M_BATCH_ADD')  
							BEGIN

                                SELECT @v_dSql = ''
                                SELECT @v_dSql += ' MERGE INTO SCM_ITEM_CONV_CALC_M AS A                 ' + char(10)
                                SELECT @v_dSql += ' USING (                                              ' + char(10)
                                SELECT @v_dSql += '        SELECT A.*, ''Pancake (m/batch)'' AS CATEGORY ' + char(10)
                                SELECT @v_dSql += '            , (A.VALUE_A * A.VALUE_B) AS VALUE        ' + char(10)
                                SELECT @v_dSql += '        FROM (                                        ' + char(10)
                                SELECT @v_dSql += '              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
                                SELECT @v_dSql += '                  , A.FACTORY_ID, A.MODEL_ID, A.OPERATION, A.ITEM_ID    ' + char(10)
                                SELECT @v_dSql += '                  , A.VERSION, A.VERSION_TYPE, A.PROD_VERSION_TYPE, MAX(A.PJT_CODE) AS PJT_CODE ' + char(10)
                                SELECT @v_dSql += '                  , MAX(A.ELECTRODE_TYPE) AS ELECTRODE_TYPE                           ' + char(10)
                                SELECT @v_dSql += '                  , MAX(CASE WHEN A.CATEGORY = ''Jumbo Roll (m/batch)'' THEN A.VALUE  ' + char(10)
                                SELECT @v_dSql += ' 				            ELSE NULL END ) AS VALUE_A                               ' + char(10)
                                SELECT @v_dSql += '                  , MAX(CASE WHEN A.CATEGORY = ''Lane Number'' THEN                   ' + char(10)
                                SELECT @v_dSql += ' 				           ( CASE WHEN A.VALUE>0 THEN A.VALUE ELSE NULL END)         ' + char(10)
                                SELECT @v_dSql += ' 						     ELSE NULL END) AS VALUE_B                               ' + char(10)
                                SELECT @v_dSql += '                  , MAX(A.MAX_VER_FLAG) AS MAX_VER_FLAG                               ' + char(10)
                                SELECT @v_dSql += '                  , (CASE WHEN MAX(ISNULL(A.APPLY_DATE,'''')) = '''' THEN NULL        ' + char(10)
                                SELECT @v_dSql += ' 				    ELSE MAX(ISNULL(A.APPLY_DATE,'''')) END) AS APPLY_DATE           ' + char(10)
                                SELECT @v_dSql += '              FROM (                                                                  ' + char(10)
                                SELECT @v_dSql += '                    SELECT A.*                                                        ' + char(10)
                                SELECT @v_dSql += '                    FROM   SCM_ITEM_CONV_CALC_M A                                     ' + char(10)
                                SELECT @v_dSql += '                    WHERE  A.CATEGORY IN (''Jumbo Roll (m/batch)'',''Lane Number'')   ' + char(10)
                                SELECT @v_dSql += '                    '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @v_division_id))   + char(10)
                                SELECT @v_dSql += '                    '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @v_site_id))           + char(10)
                                SELECT @v_dSql += '                    '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @v_plant_id))         + char(10)
                                SELECT @v_dSql += '                    '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @v_factory_id))     + char(10)
                                SELECT @v_dSql += '                    '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.MODEL_ID' , 'EQ', @v_model_id))         + char(10)
                                SELECT @v_dSql += '                    '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION' , 'EQ', @v_operation_id))    + char(10)
                                SELECT @v_dSql += '                    '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'EQ', @v_item_id))           + char(10)
                                IF(LEN(@v_version) > 0)
                                    BEGIN
                                        SELECT @v_dSql += ' AND   A.VERSION = ( CASE WHEN CHARINDEX(''.'','''+ @v_version +''',1) > 0 THEN                                                        ' + char(10)
                                        SELECT @v_dSql += '            ISNULL(REPLICATE(''0'', 3 - LEN(SUBSTRING('''+ @v_version +''', 1, ABS(CHARINDEX(''.'','''+ @v_version +''',1)-1)))),'''') ' + char(10)
                                        SELECT @v_dSql += '              + SUBSTRING('''+ @v_version +''', 1, ABS(CHARINDEX(''.'','''+ @v_version +''',1)-1)   ) + ''.''  ' + char(10)
                                        SELECT @v_dSql += '              + SUBSTRING('''+ @v_version +''', CHARINDEX(''.'','''+ @v_version +''',1)+1,10)                  ' + char(10)
                                        SELECT @v_dSql += '       ELSE ISNULL(REPLICATE(''0'', 3 - LEN('''+ @v_version +''')),'''') + '''+ @v_version +'''                ' + char(10)
                                        SELECT @v_dSql += '       END )                                                                                                   ' + char(10)
                                    END
                                SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.VERSION_TYPE' , 'EQ', @v_version_type))         + char(10)
                                SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PROD_VERSION_TYPE' , 'EQ', @v_prod_ver_type))   + char(10)
                                SELECT @v_dSql += '              ) A                                                         ' + char(10)
                                SELECT @v_dSql += '              GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
                                SELECT @v_dSql += '                  , A.FACTORY_ID, A.MODEL_ID, A.OPERATION, A.ITEM_ID      ' + char(10)
								SELECT @v_dSql += '                  , A.VERSION, A.VERSION_TYPE, A.PROD_VERSION_TYPE        ' + char(10)
                                SELECT @v_dSql += '        ) A                                    ' + char(10)
                                SELECT @v_dSql += '        WHERE A.VALUE_A IS NOT NULL            ' + char(10)
                                SELECT @v_dSql += '        AND   A.VALUE_B IS NOT NULL            ' + char(10)
                                SELECT @v_dSql += ' ) AS B                                        ' + char(10)
                                SELECT @v_dSql += ' ON (A.COMPANY_ID  = B.COMPANY_ID              ' + char(10)
                                SELECT @v_dSql += ' AND A.FACTORY_ID  = B.FACTORY_ID              ' + char(10)
                                SELECT @v_dSql += ' AND A.MODEL_ID    = B.MODEL_ID                ' + char(10)
                                SELECT @v_dSql += ' AND A.VERSION     = B.VERSION                 ' + char(10)
                                SELECT @v_dSql += ' AND A.OPERATION   = B.OPERATION               ' + char(10)
                                SELECT @v_dSql += ' AND A.ITEM_ID     = B.ITEM_ID                 ' + char(10)
                                SELECT @v_dSql += ' AND A.CATEGORY    = B.CATEGORY                ' + char(10)
                                SELECT @v_dSql += ' AND A.VERSION_TYPE = B.VERSION_TYPE           ' + char(10)
                                SELECT @v_dSql += ' AND A.PROD_VERSION_TYPE = B.PROD_VERSION_TYPE ' + char(10)
                                SELECT @v_dSql += ' )                                                            ' + char(10)
                                SELECT @v_dSql += ' WHEN MATCHED THEN                                            ' + char(10)
                                SELECT @v_dSql += '     UPDATE SET UPDATE_ID   = '''+ @v_user_id +'''            ' + char(10)
                                SELECT @v_dSql += '       , UPDATE_TIME = dbo.FN_SITE_TIME('''+ @v_site_id +''') ' + char(10)
                                SELECT @v_dSql += '       , VALUE       = B.VALUE                                ' + char(10)
                                SELECT @v_dSql += ' WHEN NOT MATCHED THEN                                        ' + char(10)
                                SELECT @v_dSql += '   INSERT (                                                   ' + char(10)
                                SELECT @v_dSql += '       COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID             ' + char(10)
                                SELECT @v_dSql += '     , FACTORY_ID, MODEL_ID, PJT_CODE, VERSION                ' + char(10)
                                SELECT @v_dSql += '     , OPERATION, ITEM_ID, ELECTRODE_TYPE, CATEGORY           ' + char(10)
                                SELECT @v_dSql += '     , MAX_VER_FLAG, VALUE, MARK, PROD_VERSION_TYPE           ' + char(10)
                                SELECT @v_dSql += '     , VERSION_TYPE, CREATE_ID, CREATE_TIME, UPDATE_ID        ' + char(10)
                                SELECT @v_dSql += '     , UPDATE_TIME, APPLY_DATE                                      ' + char(10)
                                SELECT @v_dSql += '   ) VALUES (                                                       ' + char(10)
                                SELECT @v_dSql += '       B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID           ' + char(10)
                                SELECT @v_dSql += '     , B.FACTORY_ID, B.MODEL_ID, B.PJT_CODE, B.VERSION              ' + char(10)
                                SELECT @v_dSql += '     , B.OPERATION, B.ITEM_ID, B.ELECTRODE_TYPE, B.CATEGORY         ' + char(10)
                                SELECT @v_dSql += '     , B.MAX_VER_FLAG, B.VALUE, NULL, B.PROD_VERSION_TYPE           ' + char(10)
                                SELECT @v_dSql += '     , B.VERSION_TYPE, '''+ @v_user_id +'''                         ' + char(10)
                                SELECT @v_dSql += ' 	, dbo.FN_SITE_TIME('''+ @v_site_id +'''), '''+ @v_user_id +''' ' + char(10)
                                SELECT @v_dSql += '     , dbo.FN_SITE_TIME('''+ @v_site_id +'''), B.APPLY_DATE         ' + char(10)
                                SELECT @v_dSql += '   ) ;                                                              ' + char(10)

						    END --'I'
                       /******************************************************************************/
					   /* ADD Popup 경우 : ADD(update_pancake_Cell_M_Add Popup)                         */
					   /******************************************************************************/
					   ELSE IF(@v_sys_flag ='UPDATE_PANCAKE_CELL_M_ADD')  
							BEGIN

                                SELECT @v_dSql = ''
                                SELECT @v_dSql += ' MERGE INTO SCM_ITEM_CONV_CALC_M AS A               ' + char(10)
                                SELECT @v_dSql += ' USING (                                            ' + char(10)
                                SELECT @v_dSql += '       SELECT A.*, ''Pancake (cell/m)'' AS CATEGORY ' + char(10)
                                SELECT @v_dSql += '          , (A.VALUE_A / A.VALUE_B) AS VALUE        ' + char(10)
                                SELECT @v_dSql += '       FROM (                                       ' + char(10)
                                SELECT @v_dSql += '           SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID               ' + char(10)
                                SELECT @v_dSql += '               , A.FACTORY_ID, A.MODEL_ID, A.OPERATION, A.ITEM_ID                  ' + char(10)
                                SELECT @v_dSql += '       		, A.VERSION, A.VERSION_TYPE, A.PROD_VERSION_TYPE                      ' + char(10)
                                SELECT @v_dSql += '       		, MAX(A.PJT_CODE) AS PJT_CODE,MAX(A.ELECTRODE_TYPE) AS ELECTRODE_TYPE ' + char(10)
                                SELECT @v_dSql += '               , MAX(CASE WHEN A.CATEGORY = ''Jumbo Roll (cell/m)'' THEN A.VALUE   ' + char(10)
                                SELECT @v_dSql += ' 			        ELSE NULL END) AS VALUE_A                              ' + char(10)
                                SELECT @v_dSql += '               , MAX(CASE WHEN A.CATEGORY = ''Lane Number'' THEN            ' + char(10)
                                SELECT @v_dSql += '                        ( CASE WHEN A.VALUE>0 THEN A.VALUE ELSE NULL END)   ' + char(10)
                                SELECT @v_dSql += '                     ELSE NULL END) AS VALUE_B                              ' + char(10)
                                SELECT @v_dSql += '               , MAX(A.MAX_VER_FLAG) AS MAX_VER_FLAG                        ' + char(10)
                                SELECT @v_dSql += '               , (CASE WHEN MAX(ISNULL(A.APPLY_DATE,'''')) = '''' THEN NULL ' + char(10) 
                                SELECT @v_dSql += '                  ELSE MAX(ISNULL(A.APPLY_DATE,'''')) END ) AS APPLY_DATE   ' + char(10)
                                SELECT @v_dSql += '           FROM (                                                           ' + char(10)
                                SELECT @v_dSql += '                 SELECT A.*                                                 ' + char(10)
                                SELECT @v_dSql += '                 FROM   SCM_ITEM_CONV_CALC_M A                              ' + char(10)
                                SELECT @v_dSql += '                 WHERE  A.CATEGORY IN (''Jumbo Roll (cell/m)'',''Lane Number'')                       ' + char(10)
                                SELECT @v_dSql += '                    '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @v_division_id))   + char(10)
                                SELECT @v_dSql += '                    '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @v_site_id))           + char(10)
                                SELECT @v_dSql += '                    '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @v_plant_id))         + char(10)
                                SELECT @v_dSql += '                    '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @v_factory_id))     + char(10)
                                SELECT @v_dSql += '                    '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.MODEL_ID' , 'EQ', @v_model_id))         + char(10)
                                SELECT @v_dSql += '                    '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION' , 'EQ', @v_operation_id))    + char(10)
                                SELECT @v_dSql += '                    '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'EQ', @v_item_id))           + char(10)
                                IF(LEN(@v_version) > 0)
                                    BEGIN
                                        SELECT @v_dSql += ' AND   A.VERSION = ( CASE WHEN CHARINDEX(''.'','''+ @v_version +''',1) > 0 THEN                                                        ' + char(10)
                                        SELECT @v_dSql += '            ISNULL(REPLICATE(''0'', 3 - LEN(SUBSTRING('''+ @v_version +''', 1, ABS(CHARINDEX(''.'','''+ @v_version +''',1)-1)))),'''') ' + char(10)
                                        SELECT @v_dSql += '              + SUBSTRING('''+ @v_version +''', 1, ABS(CHARINDEX(''.'','''+ @v_version +''',1)-1)   ) + ''.''  ' + char(10)
                                        SELECT @v_dSql += '              + SUBSTRING('''+ @v_version +''', CHARINDEX(''.'','''+ @v_version +''',1)+1,10)                  ' + char(10)
                                        SELECT @v_dSql += '       ELSE ISNULL(REPLICATE(''0'', 3 - LEN('''+ @v_version +''')),'''') + '''+ @v_version +'''                ' + char(10)
                                        SELECT @v_dSql += '       END )                                                                                                   ' + char(10)
                                    END
                                SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.VERSION_TYPE' , 'EQ', @v_version_type))         + char(10)
                                SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PROD_VERSION_TYPE' , 'EQ', @v_prod_ver_type))   + char(10)
                                SELECT @v_dSql += '           ) A                                                         ' + char(10)
                                SELECT @v_dSql += '           GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
                                SELECT @v_dSql += '               , A.FACTORY_ID,A.MODEL_ID,A.OPERATION, A.ITEM_ID        ' + char(10)
                                SELECT @v_dSql += '               , A.VERSION, A.VERSION_TYPE, A.PROD_VERSION_TYPE        ' + char(10)
                                SELECT @v_dSql += '       ) A                                                          ' + char(10)
                                SELECT @v_dSql += '       WHERE A.VALUE_A IS NOT NULL                                  ' + char(10)
                                SELECT @v_dSql += '       AND   A.VALUE_B IS NOT NULL                                  ' + char(10)
                                SELECT @v_dSql += ' ) AS B                                                             ' + char(10)
                                SELECT @v_dSql += ' ON ( A.COMPANY_ID  = B.COMPANY_ID                                  ' + char(10)
                                SELECT @v_dSql += ' AND A.FACTORY_ID  = B.FACTORY_ID                                   ' + char(10)
                                SELECT @v_dSql += ' AND A.MODEL_ID    = B.MODEL_ID                                     ' + char(10)
                                SELECT @v_dSql += ' AND A.VERSION     = B.VERSION                                      ' + char(10)
                                SELECT @v_dSql += ' AND A.OPERATION   = B.OPERATION                                    ' + char(10)
                                SELECT @v_dSql += ' AND A.ITEM_ID     = B.ITEM_ID                                      ' + char(10)
                                SELECT @v_dSql += ' AND A.CATEGORY    = B.CATEGORY                                     ' + char(10)
                                SELECT @v_dSql += ' AND A.PROD_VERSION_TYPE = B.PROD_VERSION_TYPE )                    ' + char(10)
                                SELECT @v_dSql += ' WHEN MATCHED THEN                                                  ' + char(10)
                                SELECT @v_dSql += '     UPDATE SET UPDATE_ID   = '''+ @v_user_id +'''                  ' + char(10)
                                SELECT @v_dSql += '        , UPDATE_TIME = dbo.FN_SITE_TIME('''+ @v_site_id +''')      ' + char(10)
                                SELECT @v_dSql += '        , VALUE       = B.VALUE                                     ' + char(10)
                                SELECT @v_dSql += ' WHEN NOT MATCHED THEN                                              ' + char(10)
                                SELECT @v_dSql += '   INSERT (                                                         ' + char(10)
                                SELECT @v_dSql += '    COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID                      ' + char(10)
                                SELECT @v_dSql += '   , FACTORY_ID, MODEL_ID, PJT_CODE, VERSION                        ' + char(10)
                                SELECT @v_dSql += '   , OPERATION, ITEM_ID, ELECTRODE_TYPE, CATEGORY                   ' + char(10)
                                SELECT @v_dSql += '   , MAX_VER_FLAG, VALUE, MARK, PROD_VERSION_TYPE                   ' + char(10)
                                SELECT @v_dSql += '   , VERSION_TYPE, CREATE_ID, CREATE_TIME, UPDATE_ID                ' + char(10)
                                SELECT @v_dSql += '   , UPDATE_TIME, APPLY_DATE                                        ' + char(10)
                                SELECT @v_dSql += '   ) VALUES (                                                       ' + char(10)
                                SELECT @v_dSql += '       B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID           ' + char(10)
                                SELECT @v_dSql += '     , B.FACTORY_ID, B.MODEL_ID, B.PJT_CODE, B.VERSION              ' + char(10)
                                SELECT @v_dSql += '     , B.OPERATION, B.ITEM_ID, B.ELECTRODE_TYPE, B.CATEGORY         ' + char(10)
                                SELECT @v_dSql += '     , B.MAX_VER_FLAG, B.VALUE, NULL, B.PROD_VERSION_TYPE           ' + char(10)
                                SELECT @v_dSql += '     , B.VERSION_TYPE, '''+ @v_user_id +'''                         ' + char(10)
                                SELECT @v_dSql += ' 	, dbo.FN_SITE_TIME('''+ @v_site_id +'''), '''+ @v_user_id +''' ' + char(10)
                                SELECT @v_dSql += '     , dbo.FN_SITE_TIME('''+ @v_site_id +'''), B.APPLY_DATE         ' + char(10)
                                SELECT @v_dSql += '   );                                                               ' + char(10)

						    END --'I'
                       /******************************************************************************/
					   /* ADD Popup 경우 : ADD(update_maxVerFlag_Add Popup)                         */
					   /******************************************************************************/
					   ELSE IF(@v_sys_flag ='UPDATE_MAXVERFLAG_ADD')  
							BEGIN

                                SELECT @v_dSql = ''
                                SELECT @v_dSql += ' UPDATE B                                                                 ' + char(10)
                                SELECT @v_dSql += '     SET MAX_VER_FLAG = CASE WHEN A.ROW_NUM = 1 THEN ''Y'' ELSE ''N'' END ' + char(10)
                                SELECT @v_dSql += ' FROM [dbo].[SCM_ITEM_CONV_CALC_M] B                                      ' + char(10)
                                SELECT @v_dSql += '     , ( SELECT *                                                         ' + char(10)
                                SELECT @v_dSql += '         FROM (                                                           ' + char(10)
                                SELECT @v_dSql += '               SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID  ' + char(10)
                                SELECT @v_dSql += '                  , A.FACTORY_ID, A.MODEL_ID, A.OPERATION, A.ITEM_ID      ' + char(10)
                                SELECT @v_dSql += '                  , A.VERSION, A.VERSION_TYPE, A.PROD_VERSION_TYPE, A.CH_VERSION                     ' + char(10)
                                SELECT @v_dSql += '                  , ROW_NUMBER() OVER ( PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID          ' + char(10)
                                SELECT @v_dSql += '                                       , A.PLANT_ID, A.FACTORY_ID, A.MODEL_ID, A.OPERATION           ' + char(10)
                                SELECT @v_dSql += '                                       , A.ITEM_ID, A.VERSION_TYPE, A.PROD_VERSION_TYPE              ' + char(10)
                                SELECT @v_dSql += '                                ORDER BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID          ' + char(10)
                                SELECT @v_dSql += '                                , A.MODEL_ID, A.OPERATION, A.ITEM_ID, A.CH_VERSION DESC ) AS ROW_NUM ' + char(10)
                                SELECT @v_dSql += '                FROM (                                                                               ' + char(10)
                                SELECT @v_dSql += '                      SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID             ' + char(10)
                                SELECT @v_dSql += '                         , A.FACTORY_ID, A.MODEL_ID, A.OPERATION, A.ITEM_ID                          ' + char(10)
                                SELECT @v_dSql += '                         , A.VERSION, A.VERSION_TYPE, A.PROD_VERSION_TYPE                            ' + char(10)
                                SELECT @v_dSql += '                         , CASE WHEN A.VERSION LIKE ''Z%'' THEN REPLACE( A.VERSION, ''Z'', ''/'')    ' + char(10)
								SELECT @v_dSql += '                                WHEN A.VERSION LIKE ''X%'' THEN REPLACE( A.VERSION, ''X'', ''/'')  ' + char(10) -- x 버전 조건 추가... 20230925
                                SELECT @v_dSql += '                                WHEN A.VERSION LIKE ''%W'' THEN REPLACE( A.VERSION, ''W'', ''0'')    ' + char(10)
                                SELECT @v_dSql += '                                WHEN A.VERSION LIKE ''%P'' THEN REPLACE( A.VERSION, ''P'', ''0'')    ' + char(10)
                                SELECT @v_dSql += '                                WHEN A.VERSION LIKE ''%P2'' THEN REPLACE( A.VERSION, ''P2'', ''0'')  ' + char(10)
                                SELECT @v_dSql += '                                WHEN A.VERSION LIKE ''%P3'' THEN REPLACE( A.VERSION, ''P3'', ''0'')  ' + char(10)
                                SELECT @v_dSql += '                           ELSE A.VERSION END AS CH_VERSION                                          ' + char(10)
                                SELECT @v_dSql += '                      FROM SCM_ITEM_CONV_CALC_M A WITH(NOLOCK)                                       ' + char(10)
                                SELECT @v_dSql += '                      WHERE  1=1                                                                     ' + char(10)
                                SELECT @v_dSql += '                    '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @v_division_id))  + char(10)
                                SELECT @v_dSql += '                    '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @v_site_id))          + char(10)
                                SELECT @v_dSql += '                    '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @v_plant_id))        + char(10)
                                SELECT @v_dSql += '                    '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @v_factory_id))    + char(10)
                                SELECT @v_dSql += '                    '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.MODEL_ID' , 'EQ', @v_model_id))        + char(10)
                                SELECT @v_dSql += '                    '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION' , 'EQ', @v_operation_id))   + char(10)
                                SELECT @v_dSql += '                    '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'EQ', @v_item_id))          + char(10)
                                SELECT @v_dSql += '                    '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.VERSION_TYPE' , 'EQ', @v_version_type))       + char(10)
                                SELECT @v_dSql += '                    '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PROD_VERSION_TYPE' , 'EQ', @v_prod_ver_type)) + char(10)
                                SELECT @v_dSql += '                     ) A                       ' + char(10)
                                SELECT @v_dSql += '              ) A                              ' + char(10)
                                SELECT @v_dSql += '     ) A                                       ' + char(10)
                                SELECT @v_dSql += ' WHERE A.COMPANY_ID = B.COMPANY_ID             ' + char(10)
                                SELECT @v_dSql += ' AND A.DIVISION_ID = B.DIVISION_ID             ' + char(10)
                                SELECT @v_dSql += ' AND A.SITE_ID = B.SITE_ID                     ' + char(10)
                                SELECT @v_dSql += ' AND A.PLANT_ID = B.PLANT_ID                   ' + char(10)
                                SELECT @v_dSql += ' AND A.FACTORY_ID = B.FACTORY_ID               ' + char(10)
                                SELECT @v_dSql += ' AND A.MODEL_ID = B.MODEL_ID                   ' + char(10)
                                SELECT @v_dSql += ' AND A.OPERATION = B.OPERATION                 ' + char(10)
                                SELECT @v_dSql += ' AND A.ITEM_ID = B.ITEM_ID                     ' + char(10)
                                SELECT @v_dSql += ' AND A.VERSION = B.VERSION                     ' + char(10)
                                SELECT @v_dSql += ' AND A.VERSION_TYPE = B.VERSION_TYPE           ' + char(10)
                                SELECT @v_dSql += ' AND A.PROD_VERSION_TYPE = B.PROD_VERSION_TYPE ' + char(10)

						    END --'I'
					
					IF @v_sys_type = 'SQL'
						BEGIN
							--EXEC PR_UI_SQL_LOG @v_proc_name,  @v_user_id,'','',@v_dSql,'select',@runstart, @runend
							SELECT @v_dSql as [QUERY_VALUE]

						END
					ELSE
						BEGIN
SET @PrintTime = GETDATE(); PRINT 'SecondTimes: ' + CAST(convert(decimal(10,3),datediff(ms,@StartTime,@PrintTime)/1000.0)AS varchar); set @StartTime = @PrintTime
print 'Block_02: ' + CONVERT(varchar,GETDATE(),14);
							SET @runstart = GetDate()
							--쿼리실행
							EXEC sp_executesql @v_dSql
							
SET @PrintTime = GETDATE(); PRINT 'SecondTimes: ' + CAST(convert(decimal(10,3),datediff(ms,@StartTime,@PrintTime)/1000.0)AS varchar); set @StartTime = @PrintTime
print 'End block 02: ' + CONVERT(varchar,GETDATE(),14);
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

