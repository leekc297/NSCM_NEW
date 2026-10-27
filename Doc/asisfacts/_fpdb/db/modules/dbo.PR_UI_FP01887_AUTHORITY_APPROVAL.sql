


/*
 * Program ID   : PR_UI_FP01887_AUTHORITY_APPROVAL
 * Description  : Authority Approval
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/06/09   JYJ				Initial Release UI통합
 * 2022/11/09   lgda106			User Company 컬럼 정보 추가
 * 2024/04/15   leejsthira2		기준 user 테이블 변경
 */

CREATE PROCEDURE [dbo].[PR_UI_FP01887_AUTHORITY_APPROVAL]
  @p_sys_type                   NVARCHAR(MAX),
  @p_sys_flag                   NVARCHAR(MAX),
  @p_sys_gubun                  NVARCHAR(MAX),
  @p_user_id                    NVARCHAR(MAX),
  @p_seq	    	            NVARCHAR(MAX),
  @p_new_user_id	    	    NVARCHAR(MAX),
  @p_new_user_name	    	    NVARCHAR(MAX),
  @p_division_id 				NVARCHAR(MAX), 
  @p_plant_id    				NVARCHAR(MAX),
  @p_factory_id  				NVARCHAR(MAX),
  @p_instance_id 				NVARCHAR(MAX),
  @p_plan_group_id	            NVARCHAR(MAX),
  @p_menu_authority_id  	    NVARCHAR(MAX),
  @p_release_notifiy            NVARCHAR(MAX),
  @p_request_id  	            NVARCHAR(MAX),
  @p_request_name 	            NVARCHAR(MAX),
  @p_start_date  	            NVARCHAR(MAX),
  @p_end_date   	            NVARCHAR(MAX),
  @p_approval_flag 	            NVARCHAR(MAX),
  @p_description  	            NVARCHAR(MAX),
  @p_org_division_id 			NVARCHAR(MAX),
  @p_org_plant_id    			NVARCHAR(MAX),
  @p_org_factory_id  			NVARCHAR(MAX),
  @p_org_instance_id 			NVARCHAR(MAX),
  @p_org_plan_group_id	        NVARCHAR(MAX)

AS 
BEGIN  --MAIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
    SET NOCOUNT ON                                                                                                                                                                                                                                                   
	SET XACT_ABORT ON 

	DECLARE @v_sys_type                  NVARCHAR(MAX)  -- 값>> SELEC: SQL저장안함, SQL:SQL저장함
	DECLARE @v_sys_flag                  NVARCHAR(MAX)  -- 값>> I: Insert, M: Update, D: Delete, G: MERGE
	DECLARE @v_sys_gubun                 NVARCHAR(MAX) 
	DECLARE @v_user_id                   NVARCHAR(MAX)
    DECLARE @v_seq      				 NVARCHAR(MAX)
    DECLARE @v_new_user_id				 NVARCHAR(MAX)
    DECLARE @v_new_user_name	    	 NVARCHAR(MAX)
	DECLARE @v_division_id 				 NVARCHAR(MAX) 
	DECLARE @v_plant_id    				 NVARCHAR(MAX)
	DECLARE @v_factory_id  				 NVARCHAR(MAX)
	DECLARE @v_instance_id 				 NVARCHAR(MAX)
	DECLARE @v_plan_group_id			 NVARCHAR(MAX)
    DECLARE @v_menu_authority_id  	     NVARCHAR(MAX)
	DECLARE @v_release_notifiy           NVARCHAR(MAX)
    DECLARE @v_request_id  	             NVARCHAR(MAX)
    DECLARE @v_request_name 	         NVARCHAR(MAX)
    DECLARE @v_start_date  	             NVARCHAR(MAX)
    DECLARE @v_end_date   	             NVARCHAR(MAX)
    DECLARE @v_approval_flag     	     NVARCHAR(MAX)
	DECLARE @v_description	             NVARCHAR(MAX)
    DECLARE @v_org_division_id 			 NVARCHAR(MAX)
    DECLARE @v_org_plant_id    			 NVARCHAR(MAX)
    DECLARE @v_org_factory_id  			 NVARCHAR(MAX)
    DECLARE @v_org_instance_id 			 NVARCHAR(MAX)
    DECLARE @v_org_plan_group_id	     NVARCHAR(MAX)


	DECLARE @recv_active_flag       NVARCHAR(MAX)				    
	DECLARE @v_proc_name	        NVARCHAR(100) = 'PR_UI_FP01887_AUTHORITY_APPROVAL'
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
    SET @v_seq      				= ''
    SET @v_new_user_id				= ''
    SET @v_new_user_name			= ''
	SET @v_division_id 				= ''
	SET @v_plant_id    				= ''
	SET @v_factory_id  				= ''
	SET @v_instance_id 				= ''
	SET @v_plan_group_id			= ''
    SET @v_menu_authority_id  	    = ''
	SET @v_release_notifiy          = ''
    SET @v_request_id  	            = ''
    SET @v_request_name 	        = ''
    SET @v_start_date  	            = ''
    SET @v_end_date   	            = ''
    SET @v_approval_flag            = ''
	SET @v_description              = ''
    SET @v_org_division_id 			= ''
    SET @v_org_plant_id    			= ''
    SET @v_org_factory_id  			= ''
    SET @v_org_instance_id 			= ''
    SET @v_org_plan_group_id	    = ''

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
            SELECT @v_dSql = ''
			-- 기준 user 테이블 변경... 20240415
            SELECT @v_dSql += ' if object_id(''tempdb..#TH_UIS_USER_DETAIL'') is not null	DROP TABLE #TH_UIS_USER_DETAIL ' + char(10)
			/*
            SELECT @v_dSql += ' SELECT A.USERID AS USER_ID, A.USERNAME AS USER_NAME ' + char(10)
            SELECT @v_dSql += '      , ISNULL((CASE WHEN A.LANGUAGE = ''KR'' THEN B.DEPT_NAME_KO ' + char(10)
            SELECT @v_dSql += '                     WHEN A.LANGUAGE = ''EN'' THEN B.DEPT_NAME_EN ' + char(10)
            SELECT @v_dSql += '     	            ELSE B.DEPT_NAME_KO END), A.DEPT_ID)AS DEPARTMENT ' + char(10)
            SELECT @v_dSql += ' INTO #TH_UIS_USER_DETAIL ' + char(10)
            SELECT @v_dSql += ' FROM  TB_FX_USER_SN A WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += ' LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO_SN B WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += ' ON    A.DEPT_ID = B.DEPT_ID ' + char(10)+ char(10)
			*/
			-- 유저테이블 변경... 수정 중
            SELECT @v_dSql += 'SELECT A.USER_ID AS USER_ID, A.USER_NAME AS USER_NAME ' + char(10)
            SELECT @v_dSql += '    , ISNULL((CASE WHEN C.SITE_ID = ''A001'' THEN B.DEPT_NAME_KO ' + char(10)
            SELECT @v_dSql += '     	           ELSE B.DEPT_NAME_KO END), A.DEPT_ID)AS DEPARTMENT ' + char(10)
            SELECT @v_dSql += 'INTO  #TH_UIS_USER_DETAIL ' + char(10)
            SELECT @v_dSql += 'FROM  SCM_MST_SSO_USER_INFO_SN A WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += 'LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO_SN B WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += 'ON    A.DEPT_ID = B.DEPT_ID ' + char(10)
            SELECT @v_dSql += 'LEFT OUTER JOIN (' + char(10)
            SELECT @v_dSql += '	SELECT COMPANY_ID, MAX(SITE_ID) AS SITE_ID ' + char(10)
            SELECT @v_dSql += '	FROM   SCM_SITE_M B WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += '	GROUP BY COMPANY_ID ' + char(10)
            SELECT @v_dSql += ') C ' + char(10)
            SELECT @v_dSql += 'ON A.COMPANY_ID = C.COMPANY_ID ' + char(10)
			SELECT @v_dSql += '; ' + char(10)+ char(10)

			-- planner권한자가 viewer 권한 요청시 체크... 20240529
            SELECT @v_dSql += ' if object_id(''tempdb..#USER_CURRENT_ROLE'') is not null	DROP TABLE #USER_CURRENT_ROLE ' + char(10)
            SELECT @v_dSql += ' SELECT C.USER_ID, MIN(CASE WHEN C.SAVE_FLAG = ''Y'' THEN ''PLANNER'' ELSE ''VIEWER'' END) AS MENU_AUTHORITY_ID ' + char(10)
            SELECT @v_dSql += '      , B.DIVISION_ID, B.PLANT_ID, D.SHOP_GROUP_ID ' + char(10)
            SELECT @v_dSql += '      , B.INSTANCE_ID, B.FACTORY_ID, B.PLAN_GROUP_ID ' + char(10)
            SELECT @v_dSql += ' INTO #USER_CURRENT_ROLE ' + char(10)
            SELECT @v_dSql += ' FROM TH_UIS_ROLE_INSTANCE A WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += '    , TH_UIS_ROLE_INSTANCE_RELATE B WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += '    , TH_UIS_USER_INSTANCE_RELATE C WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += '    , ( ' + char(10)
            SELECT @v_dSql += ' 		SELECT A.INSTANCE_ID, MAX(SHOP_GROUP_ID) AS SHOP_GROUP_ID ' + char(10)
            SELECT @v_dSql += ' 		FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += ' 		WHERE  A.ACTIVE_FLAG = ''Y'' ' + char(10)
            SELECT @v_dSql += ' 		GROUP BY A.INSTANCE_ID ' + char(10)
            SELECT @v_dSql += '    ) D ' + char(10)
            SELECT @v_dSql += ' WHERE  A.ROLE_ID = B.ROLE_ID ' + char(10)
            SELECT @v_dSql += ' AND    A.ROLE_ID = C.ROLE_ID ' + char(10)
            SELECT @v_dSql += ' AND    B.INSTANCE_ID = D.INSTANCE_ID ' + char(10)
            SELECT @v_dSql += ' AND    B.USE_AT_FLAG = ''Y'' ' + char(10)
            SELECT @v_dSql += ' AND    C.USE_AT_FLAG = ''Y'' ' + char(10)
            SELECT @v_dSql += ' AND    C.USER_ID in ( ' + char(10)
            SELECT @v_dSql += ' 	SELECT USER_ID ' + char(10) -- 조회대상의 user 정보
            SELECT @v_dSql += ' 	FROM   FP_AUTH_REQUEST_INFO_M A WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += ' 	WHERE  1=1 ' + char(10)
			SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('    A.USER_ID' , 'LK', @p_new_user_id))  + char(10)
			SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('    A.REQUEST_ID' , 'LK', @p_request_id))  + char(10)
            SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('    A.DIVISION_ID' , 'EQ', @p_division_id))  + char(10)
            SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('    A.PLANT_ID' , 'EQ', @p_plant_id))        + char(10)
            SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('    A.INSTANCE_ID' , 'EQ', @p_instance_id))  + char(10)
            SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('    A.FACTORY_ID' , 'EQ', @p_factory_id))    + char(10)
            SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('    A.PLAN_GROUP_ID' , 'EQ', @p_plan_group_id)) + char(10)
			SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('    A.APPROVAL_FLAG' , 'EQ', @p_approval_flag)) + char(10)
            SELECT @v_dSql += ' 	AND    CONVERT(VARCHAR, A.REQUEST_TIME, 112) BETWEEN '''+ @p_start_date +''' AND '''+ @p_end_date +''' ' + char(10)
            SELECT @v_dSql += ' 	GROUP BY USER_ID ' + char(10)
            SELECT @v_dSql += ' ) ' + char(10)
            SELECT @v_dSql += ' GROUP BY C.USER_ID, B.DIVISION_ID, B.PLANT_ID, D.SHOP_GROUP_ID ' + char(10)
            SELECT @v_dSql += '        , B.INSTANCE_ID, B.FACTORY_ID, B.PLAN_GROUP_ID ' + char(10)
            SELECT @v_dSql += ' ; ' + char(10)+ char(10)

            SELECT @v_dSql += ' SELECT (CASE WHEN A.APPROVAL_FLAG = ''R'' THEN ''1'' ELSE ''0'' END) AS CHK   ' + char(10)
            SELECT @v_dSql += '     , A._SEQ AS SEQ, A.USER_ID AS NEW_USER_ID, B.USER_NAME AS NEW_USER_NAME  ' + char(10)
		    SELECT @v_dSql += '     , E.COMPANY_ID    ' + char(10)
		    SELECT @v_dSql += '     , B.DEPARTMENT AS NEW_USER_DEPARTMENT, A.MENU_AUTHORITY_ID               ' + char(10)
            SELECT @v_dSql += '     , A.DIVISION_ID, A.PLANT_ID, A.SHOP_GROUP_ID, A.INSTANCE_ID              ' + char(10)
            SELECT @v_dSql += '     , A.FACTORY_ID, A.PLAN_GROUP_ID                                          ' + char(10)
            SELECT @v_dSql += '     , ( SELECT MAX(SITE_ID) FROM SCM_FACTORY_M FFF WITH(NOLOCK)              ' + char(10)
            SELECT @v_dSql += '         WHERE A.FACTORY_ID = FFF.FACTORY_ID) AS SITE_ID                      ' + char(10)
            SELECT @v_dSql += '     , A.REQUEST_ID, C.USER_NAME AS REQUEST_NAME                              ' + char(10)
            SELECT @v_dSql += '     , CONVERT(VARCHAR, A.REQUEST_TIME, 20) AS REQUEST_TIME                   ' + char(10)
            SELECT @v_dSql += '     , A.APPROVAL_ID, D.USER_NAME AS APPROVAL_NAME                            ' + char(10)
            SELECT @v_dSql += '     , CONVERT(VARCHAR, A.APPROVAL_TIME, 20) AS APPROVAL_TIME                 ' + char(10)
            SELECT @v_dSql += '     , A.APPROVAL_FLAG, A.RELEASE_NOTIFIY_TYPE, A.RELEASE_APPLY_FLAG          ' + char(10)
            SELECT @v_dSql += '     , A.DESCRIPTION, ''0'' AS _EDIT                                          ' + char(10)
            SELECT @v_dSql += '     , A.DIVISION_ID AS ORG_DIVISION_ID, A.PLANT_ID  AS ORG_PLANT_ID          ' + char(10)
            SELECT @v_dSql += '     , A.SHOP_GROUP_ID AS ORG_SHOP_GROUP_ID, A.INSTANCE_ID AS ORG_INSTANCE_ID ' + char(10)
            SELECT @v_dSql += '     , A.FACTORY_ID AS ORG_FACTORY_ID, A.PLAN_GROUP_ID AS ORG_PLAN_GROUP_ID   ' + char(10)
            SELECT @v_dSql += '     , ( SELECT MAX(SITE_ID) FROM SCM_FACTORY_M FFF WITH(NOLOCK)              ' + char(10)
            SELECT @v_dSql += '         WHERE A.FACTORY_ID = FFF.FACTORY_ID ) AS ORG_SITE_ID                 ' + char(10)
			SELECT @v_dSql += '     , ISNULL(F.MENU_AUTHORITY_ID, ''-'') AS CUR_AUTH ' + char(10) -- 현재 권한 상태 : VIEWER  : 조회, PLANNER : 저장, '-' : 권한없음
            SELECT @v_dSql += ' FROM   FP_AUTH_REQUEST_INFO_M A WITH(NOLOCK)                                 ' + char(10)
            SELECT @v_dSql += ' INNER JOIN #TH_UIS_USER_DETAIL B WITH(NOLOCK)                                 ' + char(10)
            SELECT @v_dSql += ' ON     A.USER_ID     = B.USER_ID                                             ' + char(10)
            SELECT @v_dSql += ' INNER JOIN #TH_UIS_USER_DETAIL C WITH(NOLOCK)                                 ' + char(10)
            SELECT @v_dSql += ' ON     A.REQUEST_ID  = C.USER_ID                                             ' + char(10)
            SELECT @v_dSql += ' LEFT OUTER JOIN #TH_UIS_USER_DETAIL D WITH(NOLOCK)                            ' + char(10)
            SELECT @v_dSql += ' ON     A.APPROVAL_ID = D.USER_ID                                             ' + char(10)
			SELECT @v_dSql += ' INNER JOIN SY_SCM_MST_SSO_USER_INFO E WITH(NOLOCK)                            ' + char(10)
            SELECT @v_dSql += ' ON     A.USER_ID = E.USER_ID                                             ' + char(10)
			-- planner권한자가 viewer 권한 요청시 체크... 20240529
            SELECT @v_dSql += ' LEFT OUTER JOIN #USER_CURRENT_ROLE F WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += ' ON  A.USER_ID       = F.USER_ID ' + char(10)
            SELECT @v_dSql += ' AND A.DIVISION_ID   = F.DIVISION_ID ' + char(10)
            SELECT @v_dSql += ' AND A.PLANT_ID      = F.PLANT_ID ' + char(10)
            SELECT @v_dSql += ' AND A.SHOP_GROUP_ID = F.SHOP_GROUP_ID ' + char(10)
            SELECT @v_dSql += ' AND A.INSTANCE_ID   = F.INSTANCE_ID ' + char(10)
            SELECT @v_dSql += ' AND A.FACTORY_ID    = F.FACTORY_ID ' + char(10)
            SELECT @v_dSql += ' AND A.PLAN_GROUP_ID = F.PLAN_GROUP_ID ' + char(10)

            SELECT @v_dSql += ' WHERE  1=1                                                                   ' + char(10)
			
			IF(LEN(@p_new_user_id) > 0)
			    BEGIN
                    SELECT @v_dSql += ' AND    A.USER_ID LIKE ''%'' + '''+ @p_new_user_id +''' + ''%'' ' + char(10)
				END
			IF(LEN(@p_new_user_name) > 0)
			    BEGIN
                    SELECT @v_dSql += ' AND    B.USER_NAME LIKE ''%'' + '''+ @p_new_user_name +''' + ''%'' ' + char(10)
				END

            SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))  + char(10)
            SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))        + char(10)
            SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_ID' , 'EQ', @p_instance_id))  + char(10)
            SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))    + char(10)
            SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLAN_GROUP_ID' , 'EQ', @p_plan_group_id)) + char(10)

			IF(LEN(@p_request_id) > 0)
			    BEGIN
                    SELECT @v_dSql += ' AND    A.REQUEST_ID LIKE ''%'' + '''+ @p_request_id +''' + ''%'' ' + char(10)
				END
			IF(LEN(@p_request_name) > 0)
			    BEGIN
                    SELECT @v_dSql += ' AND    B.USER_NAME LIKE ''%'' + '''+ @p_request_name +''' + ''%'' ' + char(10)
				END

            SELECT @v_dSql += ' AND    CONVERT(VARCHAR, A.REQUEST_TIME, 112) BETWEEN '''+ @p_start_date +''' AND '''+ @p_end_date +''' ' + char(10)
			IF(LEN(@p_approval_flag) > 0)
			    BEGIN
                    SELECT @v_dSql += ' AND   A.APPROVAL_FLAG = '''+ @p_approval_flag +''' ' + char(10)
				END

            SELECT @v_dSql += ' ORDER BY A.REQUEST_TIME, B.DEPARTMENT, A.USER_ID, A.DIVISION_ID, A.PLANT_ID ' + char(10)
            SELECT @v_dSql += '        , A.SHOP_GROUP_ID, A.INSTANCE_ID, A.FACTORY_ID, A.PLAN_GROUP_ID      ' + char(10)+ char(10)

            SELECT @v_dSql += ' if object_id(''tempdb..#TH_UIS_USER_DETAIL'') is not null	DROP TABLE #TH_UIS_USER_DETAIL ' + char(10)
			SELECT @v_dSql += ' if object_id(''tempdb..#USER_CURRENT_ROLE'') is not null	DROP TABLE #USER_CURRENT_ROLE ' + char(10) -- planner권한자가 viewer 권한 요청시 체크... 20240529


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
	/* SELECT인경우 :Popup SELECT(INSTANCE Popup)                                                                 */
	/************************************************************************************************/
    ELSE IF(@p_sys_flag ='SELECT_INSTANCE_POPUP')
        BEGIN --IF(START)
            SELECT @v_dSql = ''
            SELECT @v_dSql += ' SELECT DISTINCT A.INSTANCE_ID, B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, B.FACTORY_ID, B.FACTORY_NAME    ' + char(10)
            SELECT @v_dSql += '   , (CASE WHEN A.CONFIRM_AREA = ''PLAN GROUP'' THEN C.PLAN_GROUP_ID                                                ' + char(10)
            SELECT @v_dSql += '           WHEN A.CONFIRM_AREA = ''BUILDING''   THEN ''-'' ELSE ''-'' END) AS PLAN_GROUP_ID                         ' + char(10)
            SELECT @v_dSql += '   , A.INSTANCE_ID + ''_'' + B.FACTORY_ID + (CASE WHEN A.CONFIRM_AREA = ''PLAN GROUP'' THEN ''_'' + C.PLAN_GROUP_ID ' + char(10)
            SELECT @v_dSql += '                                                WHEN A.CONFIRM_AREA = ''BUILDING''   THEN '''' ELSE '''' END) AS ROLE_NAME ' + char(10)
            SELECT @v_dSql += '   , B.SHOP_GROUP_ID                                              ' + char(10)
            SELECT @v_dSql += ' FROM (                                                           ' + char(10)
            SELECT @v_dSql += '       SELECT SEGMENT1 AS INSTANCE_ID, ATTRIBUTE1 AS CONFIRM_AREA ' + char(10)
            SELECT @v_dSql += '       FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                 ' + char(10)
            SELECT @v_dSql += '       WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_ID''                ' + char(10)
            SELECT @v_dSql += '       AND    A.ACTIVE_FLAG = ''Y''                               ' + char(10)
            SELECT @v_dSql += ' ) A                                                              ' + char(10)
            SELECT @v_dSql += ' LEFT OUTER JOIN (                                                ' + char(10)
            SELECT @v_dSql += '        SELECT DISTINCT A.INSTANCE_ID, B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID     ' + char(10)
            SELECT @v_dSql += '             , B.PLANT_ID, A.FACTORY_ID, B.FACTORY_NAME, A.SHOP_GROUP_ID          ' + char(10)
            SELECT @v_dSql += '        FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK), SCM_FACTORY_M B WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += '        WHERE  A.FACTORY_ID = B.FACTORY_ID                        ' + char(10)
            SELECT @v_dSql += '        AND    B.ACTIVE_FLAG = ''Y''                              ' + char(10)
            SELECT @v_dSql += ' ) B                                                              ' + char(10)
            SELECT @v_dSql += ' ON  A.INSTANCE_ID = B.INSTANCE_ID                                ' + char(10)
            SELECT @v_dSql += ' LEFT OUTER JOIN (                                                ' + char(10)
            SELECT @v_dSql += '        SELECT SEGMENT1 AS INSTANCE_ID, SEGMENT2 AS PLAN_GROUP_ID ' + char(10)
            SELECT @v_dSql += '        FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                ' + char(10)
            SELECT @v_dSql += '        WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP''   ' + char(10)
            SELECT @v_dSql += '        AND    A.ACTIVE_FLAG = ''Y''                              ' + char(10)
            SELECT @v_dSql += ' ) C                                                              ' + char(10)
            SELECT @v_dSql += ' ON    A.INSTANCE_ID = C.INSTANCE_ID                              ' + char(10)
            SELECT @v_dSql += ' WHERE 1=1                                                        ' + char(10)
            SELECT @v_dSql += ' AND   B.COMPANY_ID IS NOT NULL                                   ' + char(10)
            SELECT @v_dSql += ' ORDER BY SITE_ID, INSTANCE_ID, FACTORY_ID, PLAN_GROUP_ID         ' + char(10)

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

						SELECT @v_sys_type     = [dbo].[SCM_ARR_SPL_VAL](@p_sys_type ,           @v_delimiter, @mst_loop_cnt)
						, @v_sys_flag          = [dbo].[SCM_ARR_SPL_VAL](@p_sys_flag ,           @v_delimiter, @mst_loop_cnt)
						, @v_sys_gubun         = [dbo].[SCM_ARR_SPL_VAL](@p_sys_gubun ,          @v_delimiter, @mst_loop_cnt)
						, @v_user_id           = [dbo].[SCM_ARR_SPL_VAL](@p_user_id ,            @v_delimiter, @mst_loop_cnt)
                        , @v_seq               = [dbo].[SCM_ARR_SPL_VAL](@p_seq ,                @v_delimiter, @mst_loop_cnt)
                        , @v_new_user_id       = [dbo].[SCM_ARR_SPL_VAL](@p_new_user_id ,        @v_delimiter, @mst_loop_cnt)
                        , @v_new_user_name     = [dbo].[SCM_ARR_SPL_VAL](@p_new_user_name ,      @v_delimiter, @mst_loop_cnt)
                        , @v_division_id       = [dbo].[SCM_ARR_SPL_VAL](@p_division_id ,        @v_delimiter, @mst_loop_cnt)
                        , @v_plant_id          = [dbo].[SCM_ARR_SPL_VAL](@p_plant_id ,           @v_delimiter, @mst_loop_cnt)
                        , @v_factory_id        = [dbo].[SCM_ARR_SPL_VAL](@p_factory_id ,         @v_delimiter, @mst_loop_cnt)
                        , @v_instance_id       = [dbo].[SCM_ARR_SPL_VAL](@p_instance_id ,        @v_delimiter, @mst_loop_cnt)
                        , @v_plan_group_id     = [dbo].[SCM_ARR_SPL_VAL](@p_plan_group_id ,      @v_delimiter, @mst_loop_cnt)
                        , @v_menu_authority_id = [dbo].[SCM_ARR_SPL_VAL](@p_menu_authority_id ,  @v_delimiter, @mst_loop_cnt)
                        , @v_release_notifiy   = [dbo].[SCM_ARR_SPL_VAL](@p_release_notifiy ,    @v_delimiter, @mst_loop_cnt)
                        , @v_request_id        = [dbo].[SCM_ARR_SPL_VAL](@p_request_id ,         @v_delimiter, @mst_loop_cnt)
                        , @v_request_name      = [dbo].[SCM_ARR_SPL_VAL](@p_request_name ,       @v_delimiter, @mst_loop_cnt)
                        , @v_approval_flag     = [dbo].[SCM_ARR_SPL_VAL](@p_approval_flag ,      @v_delimiter, @mst_loop_cnt)
                        , @v_description       = [dbo].[SCM_ARR_SPL_VAL](@p_description ,        @v_delimiter, @mst_loop_cnt)
                        , @v_org_division_id   = [dbo].[SCM_ARR_SPL_VAL](@p_org_division_id ,    @v_delimiter, @mst_loop_cnt)
                        , @v_org_plant_id      = [dbo].[SCM_ARR_SPL_VAL](@p_org_plant_id ,       @v_delimiter, @mst_loop_cnt)
                        , @v_org_factory_id    = [dbo].[SCM_ARR_SPL_VAL](@p_org_factory_id ,     @v_delimiter, @mst_loop_cnt)
                        , @v_org_instance_id   = [dbo].[SCM_ARR_SPL_VAL](@p_org_instance_id ,    @v_delimiter, @mst_loop_cnt)
                        , @v_org_plan_group_id = [dbo].[SCM_ARR_SPL_VAL](@p_org_plan_group_id ,  @v_delimiter, @mst_loop_cnt)
                       /****************************************************************************/
					   /* INSERT  경우  :  (INSERT_APPROVAL)                               */
					   /****************************************************************************/
					   IF(@v_sys_flag ='INSERT_APPROVAL')
						   BEGIN
								SELECT @v_dSql1  = ''
                                SELECT @v_dSql1 += ' -- Approval                                             ' + char(10)
                                SELECT @v_dSql1 += ' UPDATE A SET APPROVAL_FLAG   = ''Y''                    ' + char(10)
                                SELECT @v_dSql1 += '     , APPROVAL_ID     = '''+ @v_user_id +'''            ' + char(10)
                                SELECT @v_dSql1 += '     , APPROVAL_TIME   = GETDATE()                       ' + char(10)
                                SELECT @v_dSql1 += '     , DESCRIPTION     = N'''+ @v_description +'''        ' + char(10)
                                SELECT @v_dSql1 += ' FROM   FP_AUTH_REQUEST_INFO_M A                         ' + char(10)
                                SELECT @v_dSql1 += ' WHERE  A._SEQ          = '''+ @v_seq +'''               ' + char(10)
                                SELECT @v_dSql1 += ' AND    A.DIVISION_ID   = '''+ @v_org_division_id +'''   ' + char(10)
                                SELECT @v_dSql1 += ' AND    A.PLANT_ID      = '''+ @v_org_plant_id +'''      ' + char(10)
                                SELECT @v_dSql1 += ' AND    A.INSTANCE_ID   = '''+ @v_org_instance_id +'''   ' + char(10)
                                SELECT @v_dSql1 += ' AND    A.FACTORY_ID    = '''+ @v_org_factory_id +'''    ' + char(10)
                                SELECT @v_dSql1 += ' AND    A.PLAN_GROUP_ID = '''+ @v_org_plan_group_id +''' ' + char(10)

                                SELECT @v_dSql1 += ' -- instance authority                                   ' + char(10)
                                SELECT @v_dSql1 += ' UPDATE C SET  USE_AT_FLAG = ''Y''                       ' + char(10)
                                SELECT @v_dSql1 += '     , SAVE_FLAG = (CASE WHEN '''+ @v_menu_authority_id +''' = ''PLANNER'' THEN ''Y'' ' + char(10)
                                SELECT @v_dSql1 += '                      WHEN '''+ @v_menu_authority_id +''' = ''VIEWER'' THEN ''N''     ' + char(10)
                                SELECT @v_dSql1 += '                    ELSE ''N'' END)                      ' + char(10)
                                SELECT @v_dSql1 += '     , UPDATE_ID   = '''+ @v_user_id +'''                ' + char(10)
                                SELECT @v_dSql1 += '     , UPDATE_DTTM = GETDATE()                           ' + char(10)
                                SELECT @v_dSql1 += ' FROM   TH_UIS_ROLE_INSTANCE_RELATE A                    ' + char(10)
                                SELECT @v_dSql1 += '      , TH_UIS_ROLE_INSTANCE B                           ' + char(10)
                                SELECT @v_dSql1 += '      , TH_UIS_USER_INSTANCE_RELATE C                    ' + char(10)
                                SELECT @v_dSql1 += ' WHERE  A.ROLE_ID = B.ROLE_ID                            ' + char(10)
                                SELECT @v_dSql1 += ' AND    A.ROLE_ID = C.ROLE_ID                            ' + char(10)
                                SELECT @v_dSql1 += ' AND    B.APPROVAL_EXCEPTION_FLAG = ''Y''                ' + char(10)
                                SELECT @v_dSql1 += ' AND    A.DIVISION_ID   = '''+ @v_org_division_id +'''   ' + char(10)
                                SELECT @v_dSql1 += ' AND    A.PLANT_ID      = '''+ @v_org_plant_id +'''      ' + char(10)
                                SELECT @v_dSql1 += ' AND    A.INSTANCE_ID   = '''+ @v_org_instance_id +'''   ' + char(10)
                                SELECT @v_dSql1 += ' AND    A.FACTORY_ID    = '''+ @v_org_factory_id +'''    ' + char(10)
                                SELECT @v_dSql1 += ' AND    A.PLAN_GROUP_ID = '''+ @v_org_plan_group_id +''' ' + char(10)
                                SELECT @v_dSql1 += ' AND    C.USER_ID       = '''+ @v_new_user_id +'''       ' + char(10)

                                SELECT @v_dSql2  = ''
                                SELECT @v_dSql2 += ' INSERT INTO TH_UIS_USER_INSTANCE_RELATE (                           ' + char(10)
                                SELECT @v_dSql2 += '        USER_ID, ROLE_ID, USE_AT_FLAG                                ' + char(10)
                                SELECT @v_dSql2 += '      , INSERT_ID, INSERT_DTTM, UPDATE_ID                            ' + char(10)
                                SELECT @v_dSql2 += '      , UPDATE_DTTM, SAVE_FLAG                                       ' + char(10)
                                SELECT @v_dSql2 += ' )                                                                   ' + char(10)
                                SELECT @v_dSql2 += ' SELECT A.USER_ID, (                                                 ' + char(10)
                                SELECT @v_dSql2 += '        SELECT MAX(A.ROLE_ID)                                        ' + char(10)
                                SELECT @v_dSql2 += '        FROM   TH_UIS_ROLE_INSTANCE_RELATE A, TH_UIS_ROLE_INSTANCE B ' + char(10)
                                SELECT @v_dSql2 += '        WHERE  A.ROLE_ID = B.ROLE_ID                                 ' + char(10)
                                SELECT @v_dSql2 += '        AND    B.APPROVAL_EXCEPTION_FLAG = ''Y''                     ' + char(10)
                                SELECT @v_dSql2 += '        AND    A.DIVISION_ID   = '''+ @v_org_division_id +'''        ' + char(10)
                                SELECT @v_dSql2 += '        AND    A.PLANT_ID      = '''+ @v_org_plant_id +'''           ' + char(10)
                                SELECT @v_dSql2 += '        AND    A.INSTANCE_ID   = '''+ @v_org_instance_id +'''        ' + char(10)
                                SELECT @v_dSql2 += '        AND    A.FACTORY_ID    = '''+ @v_org_factory_id +'''         ' + char(10)
                                SELECT @v_dSql2 += '        AND    A.PLAN_GROUP_ID = '''+ @v_org_plan_group_id +'''      ' + char(10)
                                SELECT @v_dSql2 += '     ) AS ROLE_ID                                                    ' + char(10)
                                SELECT @v_dSql2 += '     , ''Y'' AS USE_AT_FLAG                                          ' + char(10)
                                SELECT @v_dSql2 += '     , '''+ @v_user_id +''' AS INSERT_ID                             ' + char(10)
                                SELECT @v_dSql2 += '     , GETDATE() AS INSER_DTTM                                       ' + char(10)
                                SELECT @v_dSql2 += '     , NULL AS UPDATE_ID                                             ' + char(10)
                                SELECT @v_dSql2 += '     , NULL AS UPDATE_DTTM                                           ' + char(10)
                                SELECT @v_dSql2 += '     , A.SAVE_FLAG                                                   ' + char(10)
                                SELECT @v_dSql2 += ' FROM (                                                              ' + char(10)
                                SELECT @v_dSql2 += '        SELECT '''+ @v_org_instance_id +''' AS INSTANCE_ID, '''+ @v_org_division_id +''' AS DIVISION_ID ' + char(10)
                                SELECT @v_dSql2 += '            , '''+ @v_org_plant_id +''' AS PLANT_ID, '''+ @v_org_factory_id +''' AS FACTORY_ID          ' + char(10)
                                SELECT @v_dSql2 += '            , '''+ @v_org_plan_group_id +''' AS PLAN_GROUP_ID,'''+ @v_new_user_id +''' AS USER_ID       ' + char(10)
                                SELECT @v_dSql2 += ' 	       , (CASE WHEN '''+ @v_menu_authority_id +''' = ''PLANNER'' THEN ''Y'' ' + char(10)
                                SELECT @v_dSql2 += '                   WHEN '''+ @v_menu_authority_id +''' = ''VIEWER'' THEN ''N''  ' + char(10)
                                SELECT @v_dSql2 += '              ELSE ''N'' END) AS SAVE_FLAG       ' + char(10)
                                SELECT @v_dSql2 += ' ) A                                             ' + char(10)
                                SELECT @v_dSql2 += ' WHERE NOT EXISTS (                              ' + char(10)
                                SELECT @v_dSql2 += ' 	SELECT 1                                     ' + char(10)
                                SELECT @v_dSql2 += ' 	FROM   TH_UIS_ROLE_INSTANCE_RELATE AA        ' + char(10)
                                SELECT @v_dSql2 += ' 	     , TH_UIS_ROLE_INSTANCE BB               ' + char(10)
                                SELECT @v_dSql2 += ' 	     , TH_UIS_USER_INSTANCE_RELATE CC        ' + char(10)
                                SELECT @v_dSql2 += ' 	WHERE  AA.ROLE_ID = BB.ROLE_ID               ' + char(10)
                                SELECT @v_dSql2 += ' 	AND    AA.ROLE_ID = CC.ROLE_ID               ' + char(10)
                                SELECT @v_dSql2 += ' 	AND    BB.APPROVAL_EXCEPTION_FLAG = ''Y''    ' + char(10)
                                SELECT @v_dSql2 += ' 	AND    AA.INSTANCE_ID   = A.INSTANCE_ID      ' + char(10)
                                SELECT @v_dSql2 += ' 	AND    AA.DIVISION_ID   = A.DIVISION_ID      ' + char(10)
                                SELECT @v_dSql2 += ' 	AND    AA.PLANT_ID      = A.PLANT_ID         ' + char(10)
                                SELECT @v_dSql2 += ' 	AND    AA.FACTORY_ID    = A.FACTORY_ID       ' + char(10)
                                SELECT @v_dSql2 += ' 	AND    AA.PLAN_GROUP_ID = A.PLAN_GROUP_ID    ' + char(10)
                                SELECT @v_dSql2 += ' 	AND    CC.USER_ID       = A.USER_ID	         ' + char(10)
                                SELECT @v_dSql2 += ' )                                               ' + char(10)

								SELECT @v_dSql = @v_dSql1 + @v_dSql2

						   END --'D'
					   /******************************************************************************/
					   /* UPDATE경우 : (UPDATE_REJECT)                        */
					   /******************************************************************************/
					   ELSE IF(@v_sys_flag ='UPDATE_REJECT')  
							BEGIN

                                SELECT @v_dSql = ''
                                SELECT @v_dSql += ' UPDATE A SET  APPROVAL_FLAG   = ''N''                   ' + char(10)
                                SELECT @v_dSql += '     , APPROVAL_ID     = '''+ @v_user_id +'''            ' + char(10)
                                SELECT @v_dSql += '     , APPROVAL_TIME   = GETDATE()                       ' + char(10)
                                SELECT @v_dSql += '     , DESCRIPTION     = N'''+ @v_description +'''        ' + char(10)
                                SELECT @v_dSql += '     , RELEASE_NOTIFIY_TYPE     = ''MAIL''        ' + char(10)
								SELECT @v_dSql += ' FROM   FP_AUTH_REQUEST_INFO_M A                         ' + char(10)
                                SELECT @v_dSql += ' WHERE  A._SEQ          = '''+ @v_seq +'''               ' + char(10)
                                SELECT @v_dSql += ' AND    A.DIVISION_ID   = '''+ @v_org_division_id +'''   ' + char(10)
                                SELECT @v_dSql += ' AND    A.PLANT_ID      = '''+ @v_org_plant_id +'''      ' + char(10)
                                SELECT @v_dSql += ' AND    A.INSTANCE_ID   = '''+ @v_org_instance_id +'''   ' + char(10)
                                SELECT @v_dSql += ' AND    A.FACTORY_ID    = '''+ @v_org_factory_id +'''    ' + char(10)
                                SELECT @v_dSql += ' AND    A.PLAN_GROUP_ID = '''+ @v_org_plan_group_id +''' ' + char(10)

						    END --'I'

					   /******************************************************************************/
					   /* UPDATE 경우 : (INSERT_EDIT_SAVE)                                          */
					   /******************************************************************************/
					   ELSE IF(@v_sys_flag ='INSERT_EDIT_SAVE')  
							BEGIN
                                SELECT @v_dSql = ''
                                SELECT @v_dSql += ' UPDATE A SET DIVISION_ID   = '''+ @v_division_id +'''       ' + char(10)
                                SELECT @v_dSql += '     , PLANT_ID             = '''+ @v_plant_id +'''          ' + char(10)
                                SELECT @v_dSql += '     , INSTANCE_ID          = '''+ @v_instance_id +'''       ' + char(10)
                                SELECT @v_dSql += '     , FACTORY_ID           = '''+ @v_factory_id +'''        ' + char(10)
                                SELECT @v_dSql += '     , PLAN_GROUP_ID        = '''+ @v_plan_group_id +'''     ' + char(10)
                                SELECT @v_dSql += '     , MENU_AUTHORITY_ID    = '''+ @v_menu_authority_id +''' ' + char(10)
                                SELECT @v_dSql += '     , RELEASE_NOTIFIY_TYPE = '''+ @v_release_notifiy +'''   ' + char(10)
                                SELECT @v_dSql += ' FROM   FP_AUTH_REQUEST_INFO_M A                             ' + char(10)
                                SELECT @v_dSql += ' WHERE  A._SEQ          = '''+ @v_seq +'''                   ' + char(10)
                                SELECT @v_dSql += ' AND    A.DIVISION_ID   = '''+ @v_org_division_id +'''       ' + char(10)
                                SELECT @v_dSql += ' AND    A.PLANT_ID      = '''+ @v_org_plant_id +'''          ' + char(10)
                                SELECT @v_dSql += ' AND    A.INSTANCE_ID   = '''+ @v_org_instance_id +'''       ' + char(10)
                                SELECT @v_dSql += ' AND    A.FACTORY_ID    = '''+ @v_org_factory_id +'''        ' + char(10)
                                SELECT @v_dSql += ' AND    A.PLAN_GROUP_ID = '''+ @v_org_plan_group_id +'''     ' + char(10)

						   END --'I'
					   /******************************************************************************/
					   /* MERGE 경우 : (INSERT_AUTHAPPROVAL_MENU)                                    */
					   /******************************************************************************/
					   ELSE IF(@v_sys_flag ='INSERT_AUTHAPPROVAL_MENU')  
							BEGIN
                                SELECT @v_dSql = ''

                                SELECT @v_dSql += ' MERGE INTO TH_UIS_USER_ROLE_RELATE A                                                   ' + char(10)
                                SELECT @v_dSql += ' USING (SELECT '''+ @v_new_user_id +''' AS NEW_USER_ID                                  ' + char(10)
                                SELECT @v_dSql += '          ,(CASE WHEN '''+ @v_menu_authority_id +''' = ''PLANNER'' THEN ''RA10101007''  ' + char(10)
                                SELECT @v_dSql += '                 WHEN '''+ @v_menu_authority_id +''' = ''VIEWER''  THEN ''RA10101016''  ' + char(10)
                                SELECT @v_dSql += '            ELSE ''RA10101016'' END) AS ROLE_ID ) B                                     ' + char(10)
                                SELECT @v_dSql += ' ON ( A.USER_ID = B.NEW_USER_ID AND A.ROLE_ID = B.ROLE_ID )                             ' + char(10)
                                SELECT @v_dSql += ' WHEN MATCHED THEN                                                                      ' + char(10)
                                SELECT @v_dSql += '      UPDATE SET USE_AT_FLAG = ''Y''                                                    ' + char(10)
                                SELECT @v_dSql += '               , UPDATE_ID = '''+ @v_user_id +''', UPDATE_DTTM = GETDATE()              ' + char(10)
                                SELECT @v_dSql += ' WHEN NOT MATCHED THEN                                                                  ' + char(10)
                                SELECT @v_dSql += '      INSERT (                                                                          ' + char(10)
                                SELECT @v_dSql += '            USER_ID, ROLE_ID, APPLY_DTTM                                                ' + char(10)
                                SELECT @v_dSql += '          , USE_AT_FLAG, INSERT_ID, INSERT_DTTM                                         ' + char(10)
                                SELECT @v_dSql += '          , UPDATE_ID, UPDATE_DTTM                                                      ' + char(10)
                                SELECT @v_dSql += '      )                                                                                 ' + char(10)
                                SELECT @v_dSql += '      VALUES (                                                                          ' + char(10)
                                SELECT @v_dSql += '            B.NEW_USER_ID,B.ROLE_ID, GETDATE()                                          ' + char(10)
                                SELECT @v_dSql += '          , ''Y'', '''+ @v_user_id +''', GETDATE()                                      ' + char(10)
                                SELECT @v_dSql += '          , NULL, NULL                                                                  ' + char(10)
                                SELECT @v_dSql += '      );                                                                                ' + char(10)

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

