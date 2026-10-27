

/*
 * Program ID   :PR_UI_FP01886_AUTHORITYREQUESTPOPUP
 * Description  : GSCM 통합에서 Authority Request
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/12/09   JYJ				Initial Release UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FP01886_AUTHORITYREQUESTPOPUP]
  @p_sys_type                   NVARCHAR(MAX),
  @p_sys_flag                   NVARCHAR(MAX),
  @p_sys_gubun                  NVARCHAR(MAX),
  @p_user_id                    NVARCHAR(MAX),
  @p_alt_user_id	    	    NVARCHAR(MAX),
  @p_alt_user_name	    	    NVARCHAR(MAX),
  @p_company_id 				NVARCHAR(MAX),
  @p_division_id 				NVARCHAR(MAX),
  @p_site_id    				NVARCHAR(MAX), 
  @p_plant_id    				NVARCHAR(MAX),
  @p_factory_id  				NVARCHAR(MAX),
  @p_instance_id 				NVARCHAR(MAX),
  @p_shop_group  	            NVARCHAR(MAX),
  @p_plan_group  	            NVARCHAR(MAX),
  @p_menu_authority_id  	    NVARCHAR(MAX),
  @p_request_id  	            NVARCHAR(MAX),
  @p_release_notifiy            NVARCHAR(MAX),
  @p_new_seq                    NVARCHAR(MAX)
AS 
BEGIN  --MAIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
    SET NOCOUNT ON                                                                                                                                                                                                                                                   
	SET XACT_ABORT ON 

	DECLARE @v_sys_type             NVARCHAR(MAX)  -- 값>> SELEC: SQL저장안함, SQL:SQL저장함
	DECLARE @v_sys_flag             NVARCHAR(MAX)  -- 값>> I: Insert, M: Update, D: Delete, G: MERGE
	DECLARE @v_sys_gubun            NVARCHAR(MAX) 
	DECLARE @v_user_id              NVARCHAR(MAX)
    DECLARE @v_alt_user_id			NVARCHAR(MAX)
    DECLARE @v_alt_user_name	    NVARCHAR(MAX)
	DECLARE @v_company_id           NVARCHAR(MAX)
	DECLARE @v_division_id 			NVARCHAR(MAX)
	DECLARE @v_site_id    			NVARCHAR(MAX) 
	DECLARE @v_plant_id    			NVARCHAR(MAX)
	DECLARE @v_factory_id  			NVARCHAR(MAX)
	DECLARE @v_instance_id 			NVARCHAR(MAX)
	DECLARE @v_shop_group  			NVARCHAR(MAX)
	DECLARE @v_plan_group  			NVARCHAR(MAX)
    DECLARE @v_menu_authority_id  	NVARCHAR(MAX)
    DECLARE @v_request_id  	        NVARCHAR(MAX)
	DECLARE @v_release_notifiy      NVARCHAR(MAX)
	DECLARE @v_new_seq              NVARCHAR(MAX)

	DECLARE @recv_active_flag       NVARCHAR(MAX)				    
	DECLARE @v_proc_name	        NVARCHAR(100) = 'PR_UI_FP01886_AUTHORITYREQUESTPOPUP'
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
    SET @v_alt_user_id				= ''
    SET @v_alt_user_name			= ''
	SET @v_company_id               = ''
	SET @v_division_id 				= ''
	SET @v_site_id    				= '' 
	SET @v_plant_id    				= ''
	SET @v_factory_id  				= ''
	SET @v_instance_id 				= ''
	SET @v_shop_group  				= ''
	SET @v_plan_group  				= ''
    SET @v_menu_authority_id  	    = ''
    SET @v_request_id  	            = ''
	SET @v_release_notifiy          = ''
	SET @v_new_seq                  = ''

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

	/************************************************************************************************/
	/* SELECT인경우 :SELECT(MAIN)                                                                 */
	/************************************************************************************************/
    IF(@p_sys_flag ='SELECT_MAIN')
        BEGIN --IF(START)
            SELECT @v_dSql1 = ''
            SELECT @v_dSql1 += ' SELECT A.*                                                                         ' + char(10)
            SELECT @v_dSql1 += '     , B.DIVISION_NAME                                                              ' + char(10)
            SELECT @v_dSql1 += '     , (CASE WHEN C.PLANT_NAME = '''' OR C.PLANT_NAME IS NULL THEN A.PLANT_ID       ' + char(10)
            SELECT @v_dSql1 += '        ELSE C.PLANT_NAME END) + ''('' + A.PLANT_ID + '')'' AS PLANT_NAME           ' + char(10)
            SELECT @v_dSql1 += '     , ( CASE A.SHOP_GROUP_ID WHEN ''A'' THEN ''Assy''                              ' + char(10)
            SELECT @v_dSql1 += '                             WHEN ''E'' THEN ''Electrode''                          ' + char(10)
            SELECT @v_dSql1 += '                             WHEN ''F'' THEN ''Formation''                          ' + char(10)
            SELECT @v_dSql1 += '                             WHEN ''P'' THEN ''Pack'' END                           ' + char(10) 
            SELECT @v_dSql1 += '        ) + ''('' + A.SHOP_GROUP_ID + '')'' AS SHOP_GROUP_NAME                      ' + char(10)
            SELECT @v_dSql1 += '     , D.SEGMENT2 AS INSTANCE_NAME                                                  ' + char(10)
            SELECT @v_dSql1 += '     , E.FACTORY_NAME + ''('' + A.FACTORY_ID + '')'' AS FACTORY_NAME                ' + char(10)
            SELECT @v_dSql1 += '     , A.DESCRIPTION                                                                ' + char(10)
            SELECT @v_dSql1 += '     , (CASE WHEN A.MENU_AUTHORITY_ID = ''PLANNER'' THEN ''Planner''                ' + char(10)
            SELECT @v_dSql1 += '             WHEN A.MENU_AUTHORITY_ID = ''SCP''     THEN ''Viewer_SCP''             ' + char(10)
            SELECT @v_dSql1 += '             ELSE ''Viewer_Normal'' END) AS MENU_AUTHORITY_NAME                     ' + char(10)
            SELECT @v_dSql1 += ' FROM (                                                                             ' + char(10)
            SELECT @v_dSql1 += '      SELECT -999 AS _SEQ, A.USER_ID                                                ' + char(10)
            SELECT @v_dSql1 += '          , (CASE WHEN B.MENU_AUTHORITY_ID IS NULL THEN A.MENU_AUTHORITY_ID ELSE B.MENU_AUTHORITY_ID END) AS MENU_AUTHORITY_ID ' + char(10)
            SELECT @v_dSql1 += '          , A.DIVISION_ID, A.PLANT_ID, A.SHOP_GROUP_ID, A.INSTANCE_ID, A.FACTORY_ID, A.PLAN_GROUP_ID                           ' + char(10)
            SELECT @v_dSql1 += '          , (CASE WHEN B.REQUEST_ID IS NULL THEN ''SYSTEM'' ELSE B.REQUEST_ID END) AS REQUEST_ID                               ' + char(10)
            SELECT @v_dSql1 += '          , (CASE WHEN B.REQUEST_TIME IS NULL THEN GETDATE() ELSE B.REQUEST_TIME END) AS REQUEST_TIME                          ' + char(10)
            SELECT @v_dSql1 += '          , ''Y'' AS APPROVAL_FLAG                                                                                             ' + char(10)
            SELECT @v_dSql1 += '          , (CASE WHEN B.APPROVAL_ID IS NULL THEN ''SYSTEM'' ELSE B.APPROVAL_ID END) AS APPROVAL_ID                            ' + char(10)
            SELECT @v_dSql1 += '          , (CASE WHEN B.APPROVAL_TIME IS NULL THEN GETDATE() ELSE B.APPROVAL_TIME END) AS APPROVAL_TIME                       ' + char(10)
            SELECT @v_dSql1 += '          , (CASE WHEN B.RELEASE_NOTIFIY_TYPE IS NULL THEN ''NONE'' ELSE B.RELEASE_NOTIFIY_TYPE END) AS RELEASE_NOTIFIY_TYPE   ' + char(10)
            SELECT @v_dSql1 += '          , (CASE WHEN B.RELEASE_APPLY_FLAG IS NULL THEN ''N'' ELSE B.RELEASE_APPLY_FLAG END) AS RELEASE_APPLY_FLAG            ' + char(10)
            SELECT @v_dSql1 += '          , (CASE WHEN B.DESCRIPTION IS NULL THEN '''' ELSE B.DESCRIPTION END) AS DESCRIPTION                                  ' + char(10)
            SELECT @v_dSql1 += '          , ''Approval'' AS APPROVAL_NAME                                          ' + char(10)
            SELECT @v_dSql1 += '      FROM (                                                                       ' + char(10)
            SELECT @v_dSql1 += '            -- 요청/승인 절차를 밟지 않은 데이터를 위한 조치....                   ' + char(10) 
            SELECT @v_dSql1 += '            -- 단, 배포수단 및 비고 정보 등은 가장 최근 승인된 정보를 기반으로 한다' + char(10)
            SELECT @v_dSql1 += '            SELECT C.USER_ID, MAX(CASE WHEN C.SAVE_FLAG = ''Y'' THEN ''PLANNER''   ' + char(10)
            SELECT @v_dSql1 += '                                  ELSE ''VIEWER'' END) AS MENU_AUTHORITY_ID        ' + char(10)
            SELECT @v_dSql1 += '               , B.DIVISION_ID, B.PLANT_ID, D.SHOP_GROUP_ID                        ' + char(10)
            SELECT @v_dSql1 += '               , B.INSTANCE_ID, B.FACTORY_ID, B.PLAN_GROUP_ID                      ' + char(10)
            SELECT @v_dSql1 += '            FROM TH_UIS_ROLE_INSTANCE A WITH(NOLOCK)                               ' + char(10)
            SELECT @v_dSql1 += '            	 , TH_UIS_ROLE_INSTANCE_RELATE B WITH(NOLOCK)                      ' + char(10)
            SELECT @v_dSql1 += '            	 , TH_UIS_USER_INSTANCE_RELATE C WITH(NOLOCK)                      ' + char(10)
            SELECT @v_dSql1 += '            	 , (                                                               ' + char(10)
            SELECT @v_dSql1 += '                 SELECT A.INSTANCE_ID, MAX(SHOP_GROUP_ID) AS SHOP_GROUP_ID         ' + char(10)
            SELECT @v_dSql1 += '                 FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK)                       ' + char(10)
            SELECT @v_dSql1 += '                 WHERE  A.ACTIVE_FLAG = ''Y''                                      ' + char(10)
            SELECT @v_dSql1 += '                 GROUP BY A.INSTANCE_ID                                            ' + char(10)
            SELECT @v_dSql1 += '            	 ) D                                                               ' + char(10)
            SELECT @v_dSql1 += '            WHERE  A.ROLE_ID = B.ROLE_ID                                           ' + char(10)
            SELECT @v_dSql1 += '            AND    A.ROLE_ID = C.ROLE_ID                                           ' + char(10)
            SELECT @v_dSql1 += '            AND    B.INSTANCE_ID = D.INSTANCE_ID                                   ' + char(10)
            SELECT @v_dSql1 += '            AND    C.USER_ID     = '''+ @p_alt_user_id +'''                        ' + char(10)
            SELECT @v_dSql1 += '            AND    B.USE_AT_FLAG = ''Y''                                           ' + char(10)
            SELECT @v_dSql1 += '            AND    C.USE_AT_FLAG = ''Y''                                           ' + char(10)
            SELECT @v_dSql1 += '            GROUP BY C.USER_ID, B.DIVISION_ID, B.PLANT_ID, D.SHOP_GROUP_ID         ' + char(10)
            SELECT @v_dSql1 += '                   , B.INSTANCE_ID, B.FACTORY_ID, B.PLAN_GROUP_ID                  ' + char(10)
            SELECT @v_dSql1 += '   	) A                                                                            ' + char(10)
            SELECT @v_dSql1 += '     LEFT OUTER JOIN (                                                             ' + char(10)
            SELECT @v_dSql1 += '          SELECT A.*                                                               ' + char(10)
            SELECT @v_dSql1 += '          FROM (                                                                   ' + char(10)
            SELECT @v_dSql1 += '                SELECT A.*                                                         ' + char(10)
            SELECT @v_dSql1 += '                   , ROW_NUMBER() OVER(PARTITION BY A.INSTANCE_ID                  ' + char(10)
            SELECT @v_dSql1 += '                                  , A.FACTORY_ID, A.PLAN_GROUP_ID                  ' + char(10)
            SELECT @v_dSql1 += '                         ORDER BY A.APPROVAL_TIME DESC) AS ROW_NUM                 ' + char(10)
            SELECT @v_dSql1 += '                FROM   FP_AUTH_REQUEST_INFO_M A WITH(NOLOCK)                       ' + char(10)
            SELECT @v_dSql1 += '                WHERE  A.USER_ID = '''+ @p_alt_user_id +'''                        ' + char(10)
            SELECT @v_dSql1 += '                AND    A.APPROVAL_FLAG = ''Y''                                     ' + char(10)
            SELECT @v_dSql1 += '          ) A                                                                      ' + char(10)
            SELECT @v_dSql1 += '          WHERE A.ROW_NUM = 1                                                      ' + char(10)
            SELECT @v_dSql1 += '     ) B                                                                           ' + char(10)
            SELECT @v_dSql1 += '     ON  A.USER_ID       = B.USER_ID                                               ' + char(10)
            SELECT @v_dSql1 += '     AND A.DIVISION_ID   = B.DIVISION_ID                                           ' + char(10)
            SELECT @v_dSql1 += '     AND A.PLANT_ID      = B.PLANT_ID                                              ' + char(10)
            SELECT @v_dSql1 += '     AND A.INSTANCE_ID   = B.INSTANCE_ID                                           ' + char(10)
            SELECT @v_dSql1 += '     AND A.FACTORY_ID    = B.FACTORY_ID                                            ' + char(10)
            SELECT @v_dSql1 += '     AND A.PLAN_GROUP_ID = B.PLAN_GROUP_ID                                         ' + char(10)
            SELECT @v_dSql1 += '     -- 승인이 아닌 요청 정보에 대한 조회                                          ' + char(10)
            SELECT @v_dSql1 += '     UNION ALL                                                                     ' + char(10)
            SELECT @v_dSql1 += '     SELECT A.*                                                                    ' + char(10)
            SELECT @v_dSql1 += '         , ''Request'' AS APPROVAL_NAME                                            ' + char(10)
            SELECT @v_dSql1 += '     FROM   FP_AUTH_REQUEST_INFO_M A WITH(NOLOCK)                                  ' + char(10)
            SELECT @v_dSql1 += '     WHERE  A.USER_ID = '''+ @p_alt_user_id +'''                                   ' + char(10)
            SELECT @v_dSql1 += '     AND    A.APPROVAL_FLAG = ''R''                                                ' + char(10)
            SELECT @v_dSql1 += ' ) A                                                                               ' + char(10)

			SELECT @v_dSql2  =''
            SELECT @v_dSql2 += ' LEFT OUTER JOIN (                                                                                 ' + char(10)
            SELECT @v_dSql2 += '      SELECT *                                                                                     ' + char(10)
            SELECT @v_dSql2 += '      FROM (                                                                                       ' + char(10)
            SELECT @v_dSql2 += '            SELECT A.DIVISION_ID                                                                   ' + char(10)
            SELECT @v_dSql2 += '               , ( CASE WHEN A.DIVISION_NAME = '''' OR A.DIVISION_NAME IS NULL THEN A.DIVISION_ID  ' + char(10)
            SELECT @v_dSql2 += '                   ELSE A.DIVISION_NAME END) + ''('' + A.DIVISION_ID + '')'' AS DIVISION_NAME      ' + char(10)
            SELECT @v_dSql2 += '              , ROW_NUMBER() OVER(PARTITION BY A.DIVISION_ID ORDER BY A.DIVISION_NAME ASC) AS RNUM ' + char(10)
            SELECT @v_dSql2 += '            FROM   SCM_DIVISION_M A WITH(NOLOCK)                                                   ' + char(10)
            SELECT @v_dSql2 += '            WHERE  1=1                                                                             ' + char(10)
            SELECT @v_dSql2 += '      ) AA                                                                                         ' + char(10)
            SELECT @v_dSql2 += '      WHERE RNUM=1                                                                                 ' + char(10)
            SELECT @v_dSql2 += ' ) B                                                                                               ' + char(10)
            SELECT @v_dSql2 += ' ON  A.DIVISION_ID = B.DIVISION_ID                                                                 ' + char(10)
            SELECT @v_dSql2 += ' LEFT OUTER JOIN SCM_PLANT_M C WITH(NOLOCK)                                                        ' + char(10)
            SELECT @v_dSql2 += ' ON  A.DIVISION_ID = C.DIVISION_ID                                                                 ' + char(10)
            SELECT @v_dSql2 += ' AND A.PLANT_ID    = C.PLANT_ID                                                                    ' + char(10)
            SELECT @v_dSql2 += ' LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE D WITH(NOLOCK)                                               ' + char(10)
            SELECT @v_dSql2 += ' ON  A.INSTANCE_ID = D.SEGMENT1                                                                    ' + char(10)
            SELECT @v_dSql2 += ' AND D.LOOKUP_TYPE_CODE = ''INSTANCE_ID''                                                          ' + char(10)
            SELECT @v_dSql2 += ' LEFT OUTER JOIN SCM_FACTORY_M E WITH(NOLOCK)                                                      ' + char(10)
            SELECT @v_dSql2 += ' ON  A.DIVISION_ID = E.DIVISION_ID                                                                 ' + char(10)
            SELECT @v_dSql2 += ' AND A.FACTORY_ID  = E.FACTORY_ID                                                                  ' + char(10)
            SELECT @v_dSql2 += ' ORDER BY ( CASE WHEN APPROVAL_NAME = ''Request'' THEN 1 ELSE 2 END )                              ' + char(10)
            SELECT @v_dSql2 += '     , A.DIVISION_ID, A.PLANT_ID, A.INSTANCE_ID, A.FACTORY_ID                                      ' + char(10)
            SELECT @v_dSql2 += '     , A.PLAN_GROUP_ID, A.REQUEST_TIME DESC                                                        ' + char(10)

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
        END	--IF( END )
	/************************************************************************************************/
	/* SELECT인경우 :SELECT(SUB)                                  */
	/************************************************************************************************/
    ELSE IF(@p_sys_flag ='SELECT_SUB')
	    BEGIN
		    SELECT @v_dSql  = ''
            SELECT @v_dSql += ' SELECT DISTINCT '''' AS CHK, B.INSTANCE_ID, B.COMPANY_ID, B.DIVISION_ID         ' + char(10)
            SELECT @v_dSql += '     , B.SITE_ID, B.PLANT_ID, B.FACTORY_ID, B.PLAN_GROUP_ID                      ' + char(10)
            SELECT @v_dSql += '     , '''+ @p_alt_user_id +''' AS NEW_USER_ID                                   ' + char(10)
            SELECT @v_dSql += '     , N'''+ @p_alt_user_name +''' AS NEW_USER_NAME                              ' + char(10)
            SELECT @v_dSql += '     , '''+ @p_menu_authority_id +'''  AS MENU_AUTHORITY_ID                      ' + char(10)
            SELECT @v_dSql += '     , (CASE WHEN '''+ @p_menu_authority_id +''' = ''VIEWER'' THEN ''NONE''      ' + char(10)
            SELECT @v_dSql += '             WHEN '''+ @p_menu_authority_id +''' = ''PLANNER'' THEN ''MAIL''     ' + char(10)
            SELECT @v_dSql += '        ELSE ''NONE'' END) AS RELEASE_NOTIFIY_TYPE                               ' + char(10)
            SELECT @v_dSql += '     , C.SHOP_GROUP_ID, '''+ @p_request_id +''' AS REQUEST_ID                    ' + char(10)
            SELECT @v_dSql += '     , 1 AS _CHK , BB.DIVISION_NAME                                              ' + char(10)
            SELECT @v_dSql += '     , ( CASE WHEN CC.PLANT_NAME = '''' OR CC.PLANT_NAME IS NULL THEN B.PLANT_ID ' + char(10)
            SELECT @v_dSql += '         ELSE CC.PLANT_NAME END) + ''('' + B.PLANT_ID + '')'' AS PLANT_NAME      ' + char(10)
            SELECT @v_dSql += '     , ( CASE C.SHOP_GROUP_ID WHEN ''A'' THEN ''Assy''                           ' + char(10)
            SELECT @v_dSql += '                              WHEN ''E'' THEN ''Electrode''                      ' + char(10)
            SELECT @v_dSql += '                              WHEN ''F'' THEN ''Formation''                      ' + char(10)
            SELECT @v_dSql += '                              WHEN ''P'' THEN ''Pack''                           ' + char(10) 
            SELECT @v_dSql += '         END) + ''('' + C.SHOP_GROUP_ID + '')'' AS SHOP_GROUP_NAME               ' + char(10)
            SELECT @v_dSql += '     , DD.SEGMENT2 AS INSTANCE_NAME                                              ' + char(10)
            SELECT @v_dSql += '     , EE.FACTORY_NAME + ''('' + B.FACTORY_ID + '')'' AS FACTORY_NAME            ' + char(10)
			SELECT @v_dSql += '     , '''+ @p_menu_authority_id +'''  AS ORG_MENU_AUTHORITY_ID                  ' + char(10)
            SELECT @v_dSql += ' FROM   TH_UIS_ROLE_INSTANCE A WITH(NOLOCK)                                      ' + char(10)
            SELECT @v_dSql += ' INNER JOIN TH_UIS_ROLE_INSTANCE_RELATE B WITH(NOLOCK)                           ' + char(10)
            SELECT @v_dSql += ' ON    A.ROLE_ID = B.ROLE_ID                                                     ' + char(10)
            SELECT @v_dSql += ' LEFT OUTER JOIN FP_INSTANCE_FACTORY_M C WITH(NOLOCK)                            ' + char(10)
            SELECT @v_dSql += ' ON    B.INSTANCE_ID = C.INSTANCE_ID                                             ' + char(10)
            SELECT @v_dSql += ' AND   C.ACTIVE_FLAG = ''Y''                                                     ' + char(10)
            SELECT @v_dSql += ' LEFT OUTER JOIN (                                                               ' + char(10)
            SELECT @v_dSql += '      SELECT *                                                                   ' + char(10)
            SELECT @v_dSql += '      FROM (                                                                     ' + char(10)
            SELECT @v_dSql += '      	   SELECT A.DIVISION_ID                                                 ' + char(10)
            SELECT @v_dSql += '      	      , (CASE WHEN A.DIVISION_NAME = '''' OR A.DIVISION_NAME IS NULL THEN A.DIVISION_ID    ' + char(10)
            SELECT @v_dSql += ' 			     ELSE A.DIVISION_NAME END) + ''('' + A.DIVISION_ID + '')'' AS DIVISION_NAME        ' + char(10)
            SELECT @v_dSql += '      	      , ROW_NUMBER() OVER(PARTITION BY A.DIVISION_ID ORDER BY A.DIVISION_NAME ASC) AS RNUM ' + char(10)
            SELECT @v_dSql += '      	   FROM   SCM_DIVISION_M A WITH(NOLOCK)                                  ' + char(10)
            SELECT @v_dSql += '      	   WHERE  1=1                                                            ' + char(10)
            SELECT @v_dSql += '      ) AA                                                                        ' + char(10)
            SELECT @v_dSql += '      WHERE RNUM=1                                                                ' + char(10)
            SELECT @v_dSql += ' ) BB                                                                             ' + char(10)
            SELECT @v_dSql += ' ON  B.DIVISION_ID = BB.DIVISION_ID                                               ' + char(10)
            SELECT @v_dSql += ' LEFT OUTER JOIN SCM_PLANT_M CC WITH(NOLOCK)                                      ' + char(10)
            SELECT @v_dSql += ' ON  B.DIVISION_ID = CC.DIVISION_ID                                               ' + char(10)
            SELECT @v_dSql += ' AND B.PLANT_ID    = CC.PLANT_ID                                                  ' + char(10)
            SELECT @v_dSql += ' LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE DD WITH(NOLOCK)                             ' + char(10)
            SELECT @v_dSql += ' ON  B.INSTANCE_ID = DD.SEGMENT1                                                  ' + char(10)
            SELECT @v_dSql += ' AND DD.LOOKUP_TYPE_CODE = ''INSTANCE_ID''                                        ' + char(10)
            SELECT @v_dSql += ' LEFT OUTER JOIN SCM_FACTORY_M EE WITH(NOLOCK)                                    ' + char(10)
            SELECT @v_dSql += ' ON  B.DIVISION_ID = EE.DIVISION_ID                                               ' + char(10)
            SELECT @v_dSql += ' AND B.FACTORY_ID  = EE.FACTORY_ID                                                ' + char(10)
            SELECT @v_dSql += ' WHERE  A.APPROVAL_EXCEPTION_FLAG = ''Y''                                         ' + char(10)
            SELECT @v_dSql += ' AND    B.USE_AT_FLAG = ''Y''                                                     ' + char(10)
            SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.DIVISION_ID' , 'EQ', @p_division_id))  + char(10)
            SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.PLANT_ID' , 'EQ', @p_plant_id))        + char(10)
            SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.INSTANCE_ID' , 'EQ', @p_instance_id))  + char(10)
            SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.FACTORY_ID' , 'EQ', @p_factory_id))    + char(10)
            SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.PLAN_GROUP_ID' , 'EQ', @p_plan_group)) + char(10)
            SELECT @v_dSql += ' ORDER BY B.SITE_ID, B.INSTANCE_ID, B.FACTORY_ID, B.PLAN_GROUP_ID                 ' + char(10)

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

						SELECT @v_sys_type     = [dbo].[SCM_ARR_SPL_VAL](@p_sys_type ,           @v_delimiter, @mst_loop_cnt)
						, @v_sys_flag          = [dbo].[SCM_ARR_SPL_VAL](@p_sys_flag ,           @v_delimiter, @mst_loop_cnt)
						, @v_sys_gubun         = [dbo].[SCM_ARR_SPL_VAL](@p_sys_gubun ,          @v_delimiter, @mst_loop_cnt)
						, @v_user_id           = [dbo].[SCM_ARR_SPL_VAL](@p_user_id ,            @v_delimiter, @mst_loop_cnt)
                        , @v_alt_user_id       = [dbo].[SCM_ARR_SPL_VAL](@p_alt_user_id ,        @v_delimiter, @mst_loop_cnt)
                        , @v_alt_user_name     = [dbo].[SCM_ARR_SPL_VAL](@p_alt_user_name ,      @v_delimiter, @mst_loop_cnt)
                        , @v_company_id        = [dbo].[SCM_ARR_SPL_VAL](@p_company_id ,         @v_delimiter, @mst_loop_cnt)
                        , @v_division_id       = [dbo].[SCM_ARR_SPL_VAL](@p_division_id ,        @v_delimiter, @mst_loop_cnt)
                        , @v_site_id           = [dbo].[SCM_ARR_SPL_VAL](@p_site_id ,            @v_delimiter, @mst_loop_cnt)
                        , @v_plant_id          = [dbo].[SCM_ARR_SPL_VAL](@p_plant_id ,           @v_delimiter, @mst_loop_cnt)
                        , @v_factory_id        = [dbo].[SCM_ARR_SPL_VAL](@p_factory_id ,         @v_delimiter, @mst_loop_cnt)
                        , @v_instance_id       = [dbo].[SCM_ARR_SPL_VAL](@p_instance_id ,        @v_delimiter, @mst_loop_cnt)
                        , @v_shop_group        = [dbo].[SCM_ARR_SPL_VAL](@p_shop_group ,         @v_delimiter, @mst_loop_cnt)
                        , @v_plan_group        = [dbo].[SCM_ARR_SPL_VAL](@p_plan_group ,         @v_delimiter, @mst_loop_cnt)
                        , @v_menu_authority_id = [dbo].[SCM_ARR_SPL_VAL](@p_menu_authority_id ,  @v_delimiter, @mst_loop_cnt)
                        , @v_request_id        = [dbo].[SCM_ARR_SPL_VAL](@p_request_id ,         @v_delimiter, @mst_loop_cnt)
                        , @v_release_notifiy   = [dbo].[SCM_ARR_SPL_VAL](@p_release_notifiy ,    @v_delimiter, @mst_loop_cnt)
					    , @v_new_seq           = [dbo].[SCM_ARR_SPL_VAL](@p_new_seq ,            @v_delimiter, @mst_loop_cnt)
                       /****************************************************************************/
					   /* INSERT  경우  :     I(INSERT_AUTH_REQUEST)                               */
					   /****************************************************************************/
					   IF(@v_sys_flag ='INSERT_AUTH_REQUEST')
						   BEGIN

						        --EXEC  @rtnCount = [dbo].[PR_SCM_UF_ITEM_SETUP_INSERT] @v_company_id, @v_division_id, @v_site_id, @v_operation_id, @v_setup_category_id, @v_setup_key_id;
	                            SELECT @v_seq_no += 1

								SELECT @v_dSql = '' 
                                SELECT @v_dSql += ' INSERT INTO FP_AUTH_REQUEST_INFO_M (                  ' + char(10)
                                SELECT @v_dSql += '    _SEQ , USER_ID , MENU_AUTHORITY_ID                 ' + char(10)
                                SELECT @v_dSql += '  , DIVISION_ID , PLANT_ID , SHOP_GROUP_ID             ' + char(10)
                                SELECT @v_dSql += '  , INSTANCE_ID , FACTORY_ID , PLAN_GROUP_ID           ' + char(10)
                                SELECT @v_dSql += '  , REQUEST_ID , REQUEST_TIME , APPROVAL_FLAG          ' + char(10)
                                SELECT @v_dSql += '  , APPROVAL_ID , APPROVAL_TIME , RELEASE_NOTIFIY_TYPE ' + char(10)
                                SELECT @v_dSql += '  , RELEASE_APPLY_FLAG                                 ' + char(10)
                                SELECT @v_dSql += ' )                                                     ' + char(10)
                                SELECT @v_dSql += ' VALUES (                                              ' + char(10)
                                SELECT @v_dSql += '    '''+ @v_new_seq +''' , '''+ @v_alt_user_id +''' , '''+ @v_menu_authority_id +''' ' + char(10)
                                SELECT @v_dSql += '  , '''+ @v_division_id +''' , '''+ @v_plant_id +''' , '''+ @v_shop_group +'''       ' + char(10)
                                SELECT @v_dSql += '  , '''+ @v_instance_id +''' , '''+ @v_factory_id +''' , '''+ @v_plan_group +'''     ' + char(10)
                                SELECT @v_dSql += '  , '''+ @v_request_id +''' , GETDATE() , ''R''                                      ' + char(10)
                                SELECT @v_dSql += '  , NULL , NULL , '''+ @v_release_notifiy +'''                                       ' + char(10)
                                SELECT @v_dSql += '  , ''N''                                                                            ' + char(10)
                                SELECT @v_dSql += ' )                                                                                   ' + char(10)
						   END --'D'
					   /******************************************************************************/
					   /* Excel Popup 경우 : MERGE(MERGE_UOM_INFO  Excel Popup)                        */
					   /******************************************************************************/
					   ELSE IF(@v_sys_flag ='MERGE_UOM_INFO')  
							BEGIN

                                SELECT @v_dSql1 = ''

								SELECT @v_dSql = @v_dSql1 + @v_dSql2

						    END --'I'

					   /******************************************************************************/
					   /* INSERT 경우 : INSERT(INSERT_LANE)                                          */
					   /******************************************************************************/
					   ELSE IF(@v_sys_flag ='INSERT_LANE')  
							BEGIN
                                SELECT @v_dSql = ''


						   END --'I'
					   /******************************************************************************/
					   /* UPDATE 경우 : UPDATE(UPDATE_MAXVERFLAG)                                    */
					   /******************************************************************************/
					   ELSE IF(@v_sys_flag ='UPDATE_MAXVERFLAG')  
							BEGIN
                                SELECT @v_dSql = ''


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

