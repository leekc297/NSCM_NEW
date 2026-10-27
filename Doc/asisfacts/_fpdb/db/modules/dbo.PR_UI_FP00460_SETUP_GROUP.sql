

/*
 * Program ID   : PR_UI_FP00460_SETUP_GROUP
 * Description  : PR_UI_FP00460_SETUP_GROUP
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/03/25   JYJ				Initial Release UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FP00460_SETUP_GROUP]
  @p_sys_type                   NVARCHAR(MAX)='',
  @p_sys_flag                   NVARCHAR(MAX)='',
  @p_sys_gubun                  NVARCHAR(MAX)='',
  @p_user_id                    NVARCHAR(MAX)='',
  @p_company_id                 NVARCHAR(MAX)='',
  @p_division_id                NVARCHAR(MAX)='',
  @p_site_id                    NVARCHAR(MAX)='',
  @p_plant_id                   NVARCHAR(MAX)='',
  @p_operation_id               NVARCHAR(MAX)='',
  @p_setup_category_id          NVARCHAR(MAX)='',
  @p_setup_key_id               NVARCHAR(MAX)='',
  @p_level                      NVARCHAR(MAX)='',
  @p_referance_operation_id     NVARCHAR(MAX)='',
  @p_calculation                NVARCHAR(MAX)='',
  @p_description                NVARCHAR(MAX)='',
  @p_line_setup_group_id        NVARCHAR(MAX)='',
  @p_org_line_setup_group_id    NVARCHAR(MAX)='',
  @p_plangroup_oid   NVARCHAR(MAX)=''
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
    DECLARE @v_setup_category_id          NVARCHAR(MAX)
    DECLARE @v_setup_key_id               NVARCHAR(MAX)
    DECLARE @v_level                      NVARCHAR(MAX)
    DECLARE @v_referance_operation_id     NVARCHAR(MAX)
    DECLARE @v_calculation                NVARCHAR(MAX)
    DECLARE @v_description                NVARCHAR(MAX)
    DECLARE @v_line_setup_group_id        NVARCHAR(MAX)
    DECLARE @v_org_line_setup_group_id    NVARCHAR(MAX)
    DECLARE @v_instance_id   NVARCHAR(MAX)

	DECLARE @recv_active_flag       NVARCHAR(MAX)				    
	DECLARE @v_proc_name	        NVARCHAR(100) = 'PR_UI_FP00460_SETUP_GROUP'
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
    SET @v_setup_category_id        = ''
    SET @v_setup_key_id             = ''
    SET @v_level                    = ''
    SET @v_referance_operation_id   = ''
    SET @v_calculation              = ''
    SET @v_description              = ''
    SET @v_line_setup_group_id      = ''
    SET @v_org_line_setup_group_id  = ''
    SET @v_instance_id  = ''

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
	IF(@p_sys_flag ='SELECT_MAIN')
		BEGIN --IF(START)
		    SELECT @v_dSql = ''
            SELECT @v_dSql += ' SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID   ' + char(10)
            SELECT @v_dSql += '    , A.OPERATION_ID, A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID ' + char(10)
            SELECT @v_dSql += '    , A.LEVEL, A.REFERANCE_OPERATION_ID, A.CALCULATION    ' + char(10)
            SELECT @v_dSql += '    , A.DESCRIPTION ' + char(10)
            SELECT @v_dSql += '    , (CASE WHEN R.COMPANY_ID IS NULL THEN ''N'' ELSE ''Y'' END) AS EDIT_YN ' + char(10)
            SELECT @v_dSql += ' FROM   SCM_ITEM_SETUP_GROUP_M A WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += ' LEFT OUTER JOIN ( ' + char(10)
            SELECT @v_dSql += '      SELECT DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.OPERATION_ID ' + char(10)
            SELECT @v_dSql += '      FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += '      WHERE  R.USER_ID   = '''+ @p_user_id +''' ' + char(10)
            SELECT @v_dSql += '      AND    R.SAVE_FLAG = ''Y'' ' + char(10)
            SELECT @v_dSql += ' ) R ' + char(10)
            SELECT @v_dSql += ' ON   A.COMPANY_ID   = R.COMPANY_ID   ' + char(10)
            SELECT @v_dSql += ' AND  A.DIVISION_ID  = R.DIVISION_ID  ' + char(10)
            SELECT @v_dSql += ' AND  A.SITE_ID      = R.SITE_ID      ' + char(10)
            SELECT @v_dSql += ' AND  A.OPERATION_ID = R.OPERATION_ID ' + char(10)
            SELECT @v_dSql += ' WHERE  EXISTS ( ' + char(10)
            SELECT @v_dSql += '       SELECT 1  ' + char(10)
            SELECT @v_dSql += '       FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)    ' + char(10)
            SELECT @v_dSql += '       WHERE  A.COMPANY_ID   = B.COMPANY_ID         ' + char(10)
            SELECT @v_dSql += '       AND    A.DIVISION_ID  = B.DIVISION_ID        ' + char(10)
            SELECT @v_dSql += '       AND    A.SITE_ID      = B.SITE_ID            ' + char(10)
            SELECT @v_dSql += '       AND    A.OPERATION_ID = B.OPERATION_ID       ' + char(10)
            SELECT @v_dSql += '       AND    B.USER_ID      = '''+ @p_user_id +''' ' + char(10)
            SELECT @v_dSql += ' ) ' + char(10)
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
	        SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))            + char(10)
	        SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))  + char(10)
	        SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SETUP_CATEGORY_ID' , 'EQ', @v_setup_category_id))    + char(10)
            SELECT @v_dSql += ' ORDER BY A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID, A.LEVEL, A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID '+ char(10)

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
	/* 
	SELECT인경우 :SELECT(SELECT)        
	--2023-0314 chkim.68
	--형교환 고도화에 의한 추가 (테이블 교체, 인스턴스ID로 기준 변경)
	*/
	/************************************************************************************************/
	ELSE IF(@p_sys_flag ='SELECT_MAIN_V2')
		BEGIN --IF(START)
		    SELECT @v_dSql = ''
            SELECT @v_dSql += ' SELECT DISTINCT A.INSTANCE_ID   ' + char(10)
            SELECT @v_dSql += '    , A.OPERATION_ID, A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID ' + char(10)
            SELECT @v_dSql += '    , A.LEVEL, A.REFERANCE_OPERATION_ID, A.CALCULATION    ' + char(10)
            SELECT @v_dSql += '    , A.DESCRIPTION ' + char(10)
            SELECT @v_dSql += '    , (CASE WHEN R.INSTANCE_ID IS NULL THEN ''N'' ELSE ''Y'' END) AS EDIT_YN ' + char(10)
            SELECT @v_dSql += ' FROM   FP_ITEM_SETUP_GROUP_M A WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += ' LEFT OUTER JOIN ( ' + char(10)
            SELECT @v_dSql += '      SELECT DISTINCT R.INSTANCE_ID ' + char(10)
            SELECT @v_dSql += '      FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += '      WHERE  R.USER_ID   = '''+ @p_user_id +''' ' + char(10)
            SELECT @v_dSql += '      AND    R.SAVE_FLAG = ''Y'' ' + char(10)
            SELECT @v_dSql += ' ) R ' + char(10)
            SELECT @v_dSql += ' ON   1=1   ' + char(10)
            SELECT @v_dSql += ' AND  A.INSTANCE_ID = R.INSTANCE_ID  ' + char(10)
            SELECT @v_dSql += ' WHERE  EXISTS ( ' + char(10)
            SELECT @v_dSql += '       SELECT 1  ' + char(10)
            SELECT @v_dSql += '       FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)    ' + char(10)
            SELECT @v_dSql += '       WHERE  1=1' + char(10)
            SELECT @v_dSql += '       AND    A.INSTANCE_ID  = B.INSTANCE_ID        ' + char(10)
            SELECT @v_dSql += '       AND    B.USER_ID      = '''+ @p_user_id +''' ' + char(10)
            SELECT @v_dSql += ' ) ' + char(10)
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_ID' , 'EQ', @p_plangroup_oid))    + char(10)
	        SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SETUP_CATEGORY_ID' , 'EQ', @v_setup_category_id))    + char(10)
            SELECT @v_dSql += ' ORDER BY A.INSTANCE_ID, A.OPERATION_ID, A.LEVEL, A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID '+ char(10)

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
	/* SELECT인경우 :SELECT(SELECT)                                                                      */
	/************************************************************************************************/
	ELSE IF(@p_sys_flag ='SELECT_SUB')
		BEGIN --IF(START)
		    SELECT @v_dSql = ''
            SELECT @v_dSql += ' SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID      ' + char(10)
            SELECT @v_dSql += '      , A.LINE_SETUP_GROUP_ID, A.LINE_SETUP_GROUP_ID AS ORG_LINE_SETUP_GROUP_ID ' + char(10)
            SELECT @v_dSql += '      , (CASE WHEN R.COMPANY_ID IS NULL THEN ''N'' ELSE ''Y'' END) AS EDIT_YN   ' + char(10)
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
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))      + char(10)
	        SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))              + char(10)
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
	    END	--IF( END )

	/************************************************************************************************/
	/* SELECT인경우 :SELECT DETAIL Popup(SELECT_DETAIL_POPUP)                                       */
	/************************************************************************************************/
	ELSE IF(@p_sys_flag ='SELECT_DETAIL_POPUP')
		BEGIN --IF(START)
		    SELECT @v_dSql = ''
            SELECT @v_dSql += ' SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID                ' + char(10)
            SELECT @v_dSql += '     , A.OPERATION_ID, A.LEVEL, A.SETUP_CATEGORY_ID           ' + char(10)
            SELECT @v_dSql += '     , A.SETUP_KEY_ID, A.ITEM_SETUP_GROUP_ID                  ' + char(10)
            SELECT @v_dSql += '     , A.REFERANCE_OPERATION_ID, A.CALCULATION, A.DESCRIPTION ' + char(10)
            SELECT @v_dSql += ' FROM   SCM_ITEM_SETUP_GROUP_M A(NOLOCK)                      ' + char(10)
            SELECT @v_dSql += '     , (                                                      ' + char(10)
            SELECT @v_dSql += '        SELECT B.COMPANY_ID,B.DIVISION_ID,B.SITE_ID           ' + char(10)
            SELECT @v_dSql += '        FROM TH_UIS_USER_FACTORY_RELATE A(NOLOCK)             ' + char(10)
            SELECT @v_dSql += '           , TH_UIS_ROLE_FACTORY_RELATE B(NOLOCK)             ' + char(10)
            SELECT @v_dSql += '        WHERE A.USER_ID = '''+ @p_user_id +'''                ' + char(10)
            SELECT @v_dSql += '        AND   A.ROLE_ID = B.ROLE_ID                           ' + char(10)
            SELECT @v_dSql += '        AND   A.USE_AT_FLAG = ''Y''                           ' + char(10)
            SELECT @v_dSql += '        AND   B.USE_AT_FLAG = ''Y''                           ' + char(10)
            SELECT @v_dSql += '        GROUP BY B.COMPANY_ID,B.DIVISION_ID,B.SITE_ID         ' + char(10)
            SELECT @v_dSql += '       ) AA                                                   ' + char(10)
            SELECT @v_dSql += ' WHERE A.COMPANY_ID=AA.COMPANY_ID                             ' + char(10)
            SELECT @v_dSql += ' AND   A.DIVISION_ID=AA.DIVISION_ID                           ' + char(10)
            SELECT @v_dSql += ' AND   A.SITE_ID=AA.SITE_ID                                   ' + char(10)
            SELECT @v_dSql += ' ORDER BY A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID            ' + char(10)
            SELECT @v_dSql += '      , A.LEVEL, A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID          ' + char(10)

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
	/*  EXECUTE 경우 :(EXECUTE_INIT_SETUP  )                             */
	/************************************************************************************************/
    ELSE IF(@p_sys_flag ='EXECUTE_INIT_SETUP ')
	    BEGIN --ELSE IF(START)
		    --SELECT @v_dSql = ''
			EXEC  @rtnCount = [dbo].[PR_SCM_UF_ITEM_SETUP_RENEW]
	
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
    /************************************************************************************************/
	/*  EXECUTE 경우 :(EXECUTE_ADD  )                             */
	/************************************************************************************************/
    ELSE IF(@p_sys_flag ='EXECUTE_ADD ')
	    BEGIN --ELSE IF(START)
		    --SELECT @v_dSql = ''
			EXEC  @rtnCount = [dbo].[PR_SCM_UF_ITEM_SETUP_INSERT] @p_company_id, @p_division_id, @p_site_id, @p_operation_id, @p_level, @p_setup_category_id, @p_setup_key_id, @p_referance_operation_id, @p_calculation, @p_user_id
	
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

						SELECT @v_sys_type            = [dbo].[SCM_ARR_SPL_VAL](@p_sys_type ,               @v_delimiter, @mst_loop_cnt)
						, @v_sys_flag                 = [dbo].[SCM_ARR_SPL_VAL](@p_sys_flag ,               @v_delimiter, @mst_loop_cnt)
						, @v_sys_gubun                = [dbo].[SCM_ARR_SPL_VAL](@p_sys_gubun ,              @v_delimiter, @mst_loop_cnt)
						, @v_user_id                  = [dbo].[SCM_ARR_SPL_VAL](@p_user_id ,                @v_delimiter, @mst_loop_cnt)
                        , @v_company_id               = [dbo].[SCM_ARR_SPL_VAL](@p_company_id ,             @v_delimiter, @mst_loop_cnt)
                        , @v_division_id              = [dbo].[SCM_ARR_SPL_VAL](@p_division_id ,            @v_delimiter, @mst_loop_cnt)
                        , @v_site_id                  = [dbo].[SCM_ARR_SPL_VAL](@p_site_id ,                @v_delimiter, @mst_loop_cnt)
                        , @v_plant_id                 = [dbo].[SCM_ARR_SPL_VAL](@p_plant_id ,               @v_delimiter, @mst_loop_cnt)
                        , @v_operation_id             = [dbo].[SCM_ARR_SPL_VAL](@p_operation_id ,           @v_delimiter, @mst_loop_cnt)
                        , @v_setup_category_id        = [dbo].[SCM_ARR_SPL_VAL](@p_setup_category_id ,      @v_delimiter, @mst_loop_cnt)
                        , @v_setup_key_id             = [dbo].[SCM_ARR_SPL_VAL](@p_setup_key_id ,           @v_delimiter, @mst_loop_cnt)
                        , @v_level                    = [dbo].[SCM_ARR_SPL_VAL](@p_level ,                  @v_delimiter, @mst_loop_cnt)
                        , @v_referance_operation_id   = [dbo].[SCM_ARR_SPL_VAL](@p_referance_operation_id , @v_delimiter, @mst_loop_cnt)
                        , @v_calculation              = [dbo].[SCM_ARR_SPL_VAL](@p_calculation ,            @v_delimiter, @mst_loop_cnt)
                        , @v_description              = [dbo].[SCM_ARR_SPL_VAL](@p_description ,            @v_delimiter, @mst_loop_cnt)
                        , @v_line_setup_group_id      = [dbo].[SCM_ARR_SPL_VAL](@p_line_setup_group_id ,    @v_delimiter, @mst_loop_cnt)
                        , @v_org_line_setup_group_id  = [dbo].[SCM_ARR_SPL_VAL](@p_org_line_setup_group_id ,@v_delimiter, @mst_loop_cnt)
					   
					   /****************************************************************************/
					   /* DELETE  경우  :     D(MAIN)                                                   */
					   /****************************************************************************/
					   IF(@v_sys_flag ='D')
						   BEGIN

						        --EXEC  @rtnCount = [dbo].[PR_SCM_UF_ITEM_SETUP_INSERT] @v_company_id, @v_division_id, @v_site_id, @v_operation_id, @v_setup_category_id, @v_setup_key_id;
	
								SELECT @v_dSql1 = ''
						        SELECT @v_dSql1 += ' EXEC [dbo].[PR_SCM_UF_ITEM_SETUP_INSERT] '''+ @v_company_id +''', '''+ @v_division_id +''', '''+@v_site_id +''', '''+ @v_operation_id +''','''+ @v_setup_category_id +''', '''+@v_setup_key_id +''' ; ' + char(10)
                                SELECT @v_dSql2 = ''
								SELECT @v_dSql2 += ' INSERT INTO HIS_SETUP_MATRIX_M (  ' + char(10)
                                SELECT @v_dSql2 += '    COMPANY_ID,         DIVISION_ID,              SITE_ID           ' + char(10)
                                SELECT @v_dSql2 += '   ,PLANT_ID,           LINE_SETUP_GROUP_ID,      SETUP_CATEGORY_ID ' + char(10)
                                SELECT @v_dSql2 += '   ,SETUP_KEY_ID,       FROM_ITEM_SETUP_GROUP_ID, TO_ITEM_SETUP_GROUP_ID ' + char(10)
                                SELECT @v_dSql2 += '   ,SETUP_CONDITION_ID, OPERATION_ID,             SETUP_TIME  ' + char(10)
                                SELECT @v_dSql2 += '   ,SETUP_TIME_UOM,     ADJUST_CELL_QTY,          DESCRIPTION ' + char(10)
                                SELECT @v_dSql2 += '   ,INSERT_ID,          INSERT_TIME,              UPDATE_ID   ' + char(10)
                                SELECT @v_dSql2 += '   ,UPDATE_TIME,        JOB_USER_ID,              JOB_TIME    ' + char(10)
                                SELECT @v_dSql2 += '   ,JOB_TYPE ' + char(10)
                                SELECT @v_dSql2 += ' )           ' + char(10)
                                SELECT @v_dSql2 += ' SELECT COMPANY_ID,         DIVISION_ID,               SITE_ID                ' + char(10)
                                SELECT @v_dSql2 += '       ,PLANT_ID,           LINE_SETUP_GROUP_ID,       SETUP_CATEGORY_ID      ' + char(10)
                                SELECT @v_dSql2 += '       ,SETUP_KEY_ID,       FROM_ITEM_SETUP_GROUP_ID,  TO_ITEM_SETUP_GROUP_ID ' + char(10)
                                SELECT @v_dSql2 += '       ,SETUP_CONDITION_ID, OPERATION_ID,              SETUP_TIME  ' + char(10)
                                SELECT @v_dSql2 += '       ,SETUP_TIME_UOM,     ADJUST_CELL_QTY,           DESCRIPTION ' + char(10)
                                SELECT @v_dSql2 += '       ,INSERT_ID,         INSERT_TIME,                UPDATE_ID   ' + char(10)
                                SELECT @v_dSql2 += '       ,UPDATE_TIME,       '''+ @v_user_id +''',       GETDATE()   ' + char(10)
                                SELECT @v_dSql2 += '       ,''DELETE'' AS JOB_TYPE     ' + char(10)
                                SELECT @v_dSql2 += ' FROM   SCM_SETUP_MATRIX_M(NOLOCK) ' + char(10)
                                SELECT @v_dSql2 += ' WHERE  COMPANY_ID        = '''+ @v_company_id +'''        ' + char(10)
                                SELECT @v_dSql2 += ' AND    DIVISION_ID       = '''+ @v_division_id +'''       ' + char(10)
                                SELECT @v_dSql2 += ' AND    SITE_ID           = '''+ @v_site_id +'''           ' + char(10)
                                SELECT @v_dSql2 += ' AND    OPERATION_ID      = '''+ @v_operation_id +'''      ' + char(10)
                                SELECT @v_dSql2 += ' AND    SETUP_CATEGORY_ID = '''+ @v_setup_category_id +''' ' + char(10)
                                SELECT @v_dSql2 += ' AND    SETUP_KEY_ID      = '''+ @v_setup_key_id +'''      ' + char(10)
                                SELECT @v_dSql2 += '        ' + char(10)
                                SELECT @v_dSql2 += ' DELETE ' + char(10)
                                SELECT @v_dSql2 += ' FROM   SCM_SETUP_MATRIX_M                                 ' + char(10)
                                SELECT @v_dSql2 += ' WHERE  COMPANY_ID        = '''+ @v_company_id +'''        ' + char(10)
                                SELECT @v_dSql2 += ' AND    DIVISION_ID       = '''+ @v_division_id +'''       ' + char(10)
                                SELECT @v_dSql2 += ' AND    SITE_ID           = '''+ @v_site_id +'''           ' + char(10)
                                SELECT @v_dSql2 += ' AND    OPERATION_ID      = '''+ @v_operation_id +'''      ' + char(10)
                                SELECT @v_dSql2 += ' AND    SETUP_CATEGORY_ID = '''+ @v_setup_category_id +''' ' + char(10)
                                SELECT @v_dSql2 += ' AND    SETUP_KEY_ID      = '''+ @v_setup_key_id +'''      ' + char(10)		
								
								SELECT @v_dSql = @v_dSql1 + @v_dSql2

						   END --'D'
					   /******************************************************************************/
					   /* INSERT 경우 : INSERT(DETAIL)                                                 */
					   /******************************************************************************/
					   ELSE IF(@v_sys_flag ='INSERT_SUB')  
							BEGIN
                                SELECT @v_dSql = ''
                                SELECT @v_dSql += ' INSERT INTO scm_line_setup_group_m(                        ' + char(10)
                                SELECT @v_dSql += '    COMPANY_ID,   DIVISION_ID,         SITE_ID              ' + char(10)
                                SELECT @v_dSql += '   , PLANT_ID,    OPERATION_ID,        LINE_SETUP_GROUP_ID  ' + char(10)
                                SELECT @v_dSql += '   , DESCRIPTION, INSERT_ID,           INSERT_TIME          ' + char(10)
								SELECT @v_dSql += '   , UPDATE_ID,   UPDATE_TIME                               ' + char(10)
                                SELECT @v_dSql += ' ) VALUES (  ' + char(10)
                                SELECT @v_dSql += '   '''+ @v_company_id +''',  '''+ @v_division_id +''',  '''+ @v_site_id +'''              ' + char(10)
                                SELECT @v_dSql += '   , '''+ @v_plant_id +''' , '''+ @v_operation_id +''', N'''+ @v_line_setup_group_id +'''  ' + char(10)
                                SELECT @v_dSql += '   , N'''+ @v_description +''', '''+ @v_user_id +''',     GETDATE()                        ' + char(10)
								SELECT @v_dSql += '   , '''+ @v_user_id +''',     GETDATE()                     ' + char(10)
                                SELECT @v_dSql += ' )  ' + char(10)
                                SELECT @v_dSql += '    ' + char(10)
                                SELECT @v_dSql += ' INSERT INTO his_line_setup_group_m (                     ' + char(10)
                                SELECT @v_dSql += '     COMPANY_ID,   DIVISION_ID,    SITE_ID                ' + char(10)
                                SELECT @v_dSql += '    , PLANT_ID,    OPERATION_ID,   LINE_SETUP_GROUP_ID    ' + char(10)
                                SELECT @v_dSql += '    , DESCRIPTION, INSERT_ID,      INSERT_TIME            ' + char(10)
								SELECT @v_dSql += '    , UPDATE_ID,   UPDATE_TIME,    JOB_USER_ID            ' + char(10)
                                SELECT @v_dSql += '    , JOB_TIME,    JOB_TYPE                               ' + char(10)
                                SELECT @v_dSql += ' )  ' + char(10)
                                SELECT @v_dSql += ' SELECT COMPANY_ID,     DIVISION_ID,     SITE_ID          ' + char(10)
                                SELECT @v_dSql += '    , PLANT_ID,      OPERATION_ID,    LINE_SETUP_GROUP_ID ' + char(10)
                                SELECT @v_dSql += '    , DESCRIPTION ,  INSERT_ID,       INSERT_TIME         ' + char(10)
                                SELECT @v_dSql += '    , UPDATE_ID,     UPDATE_TIME ,   '''+ @v_user_id +''' ' + char(10)
								SELECT @v_dSql += '    , GETDATE(),     ''INSERT''                           ' + char(10)
                                SELECT @v_dSql += ' FROM   scm_line_setup_group_m(NOLOCK)                    ' + char(10)
                                SELECT @v_dSql += ' WHERE COMPANY_ID        = '''+ @v_company_id +'''        ' + char(10)
                                SELECT @v_dSql += ' AND   DIVISION_ID       = '''+ @v_division_id +'''       ' + char(10)
                                SELECT @v_dSql += ' AND   SITE_ID           = '''+ @v_site_id +'''           ' + char(10)
                                SELECT @v_dSql += ' AND   PLANT_ID          = '''+ @v_plant_id +'''          ' + char(10)
                                SELECT @v_dSql += ' AND   OPERATION_ID      = '''+ @v_operation_id +'''      ' + char(10)
                                SELECT @v_dSql += ' AND   LINE_SETUP_GROUP_ID = N'''+ @v_line_setup_group_id +'''  ' + char(10)

						   END --'I'
					   /****************************************************************************/
					   /* UPDATE  경우  :    M(UPDATE_SUB)                                         */
					   /****************************************************************************/
					   ELSE IF(@v_sys_flag ='UPDATE_SUB')
							BEGIN
							    SELECT @v_dSql1 = ''
                                SELECT @v_dSql1 += ' UPDATE scm_line_setup_group_m SET      ' + char(10)
                                SELECT @v_dSql1 += '     update_id   = '''+ @v_user_id +''' ' + char(10)
                                SELECT @v_dSql1 += '    ,update_time = GETDATE()            ' + char(10)
                                SELECT @v_dSql1 += '    ,line_setup_group_id = N'''+ @v_line_setup_group_id +'''   ' + char(10)
                                SELECT @v_dSql1 += ' WHERE COMPANY_ID        = '''+ @v_company_id +'''             ' + char(10)
                                SELECT @v_dSql1 += ' AND   DIVISION_ID       = '''+ @v_division_id +'''            ' + char(10)
                                SELECT @v_dSql1 += ' AND   SITE_ID           = '''+ @v_site_id +'''                ' + char(10)
                                SELECT @v_dSql1 += ' AND   PLANT_ID          = '''+ @v_plant_id +'''               ' + char(10)
                                SELECT @v_dSql1 += ' AND   OPERATION_ID      = '''+ @v_operation_id +'''           ' + char(10)
                                SELECT @v_dSql1 += ' AND   LINE_SETUP_GROUP_ID = N'''+ @v_org_line_setup_group_id +'''  ' + char(10)
                                SELECT @v_dSql1 += '   ' + char(10)
                                SELECT @v_dSql1 += ' INSERT INTO his_line_setup_group_m (                  ' + char(10)
                                SELECT @v_dSql1 += '      COMPANY_ID,   DIVISION_ID,  SITE_ID              ' + char(10)
                                SELECT @v_dSql1 += '     , PLANT_ID,    OPERATION_ID, LINE_SETUP_GROUP_ID  ' + char(10)
                                SELECT @v_dSql1 += '     , DESCRIPTION, INSERT_ID,    INSERT_TIME          ' + char(10)
                                SELECT @v_dSql1 += '     , UPDATE_ID,   UPDATE_TIME,  JOB_USER_ID          ' + char(10)
                                SELECT @v_dSql1 += '     ,JOB_TIME,     JOB_TYPE                           ' + char(10)
                                SELECT @v_dSql1 += ' )  ' + char(10)
                                SELECT @v_dSql1 += ' SELECT COMPANY_ID,   DIVISION_ID,   SITE_ID              ' + char(10)
                                SELECT @v_dSql1 += '       , PLANT_ID,    OPERATION_ID,  LINE_SETUP_GROUP_ID  ' + char(10)
                                SELECT @v_dSql1 += '       , DESCRIPTION, INSERT_ID,     INSERT_TIME          ' + char(10)
                                SELECT @v_dSql1 += '       ,UPDATE_ID,    UPDATE_TIME,  '''+ @v_user_id +'''  ' + char(10)
                                SELECT @v_dSql1 += '       ,GETDATE(),    ''UPDATE''                          ' + char(10)
                                SELECT @v_dSql1 += ' FROM   scm_line_setup_group_m(NOLOCK)                    ' + char(10)
                                SELECT @v_dSql1 += ' WHERE COMPANY_ID        = '''+ @v_company_id +'''        ' + char(10)
                                SELECT @v_dSql1 += ' AND   DIVISION_ID       = '''+ @v_division_id +'''       ' + char(10)
                                SELECT @v_dSql1 += ' AND   SITE_ID           = '''+ @v_site_id +'''           ' + char(10)
                                SELECT @v_dSql1 += ' AND   PLANT_ID          = '''+ @v_plant_id +'''          ' + char(10)
                                SELECT @v_dSql1 += ' AND   OPERATION_ID      = '''+ @v_operation_id +'''      ' + char(10)
                                SELECT @v_dSql1 += ' AND   LINE_SETUP_GROUP_ID = N'''+ @v_line_setup_group_id +'''  ' + char(10)
								SELECT @v_dSql2 = ''
                                SELECT @v_dSql2 += ' UPDATE SCM_SETUP_CONDITION_M SET                             ' + char(10)
                                SELECT @v_dSql2 += '      LINE_SETUP_GROUP_ID = '''+ @v_line_setup_group_id +'''  ' + char(10)
                                SELECT @v_dSql2 += '     ,UPDATE_ID           = '''+ @v_user_id +'''              ' + char(10)
                                SELECT @v_dSql2 += '     ,UPDATE_TIME         = GETDATE()                         ' + char(10)
                                SELECT @v_dSql2 += ' WHERE COMPANY_ID        = '''+ @v_company_id +'''            ' + char(10)
                                SELECT @v_dSql2 += ' AND   DIVISION_ID       = '''+ @v_division_id +'''           ' + char(10)
                                SELECT @v_dSql2 += ' AND   SITE_ID           = '''+ @v_site_id +'''               ' + char(10)
                                SELECT @v_dSql2 += ' AND   PLANT_ID          = '''+ @v_plant_id +'''              ' + char(10)
                                SELECT @v_dSql2 += ' AND   OPERATION_ID      = '''+ @v_operation_id +'''          ' + char(10)
                                SELECT @v_dSql2 += ' AND   LINE_SETUP_GROUP_ID = N'''+ @v_org_line_setup_group_id +''' ' + char(10)
                                SELECT @v_dSql2 += '  ' + char(10)
                                SELECT @v_dSql2 += ' INSERT INTO HIS_SETUP_CONDITION_M (                            ' + char(10)
                                SELECT @v_dSql2 += '     COMPANY_ID,         DIVISION_ID,       SITE_ID             ' + char(10)
                                SELECT @v_dSql2 += '    ,PLANT_ID,           OPERATION_ID,      LINE_SETUP_GROUP_ID ' + char(10)
                                SELECT @v_dSql2 += '    ,SETUP_CATEGORY_ID,  SETUP_KEY_ID,      SETUP_CONDITION_ID  ' + char(10)
                                SELECT @v_dSql2 += '    ,SHOP_GROUP_ID,      SETUP_TIME,        SETUP_TIME_UOM      ' + char(10)
                                SELECT @v_dSql2 += '    ,DESCRIPTION,        INSERT_ID,         INSERT_TIME         ' + char(10)
                                SELECT @v_dSql2 += '    ,UPDATE_ID,          UPDATE_TIME,       JOB_USER_ID         ' + char(10)
                                SELECT @v_dSql2 += '    ,JOB_TIME,           JOB_TYPE ' + char(10)
                                SELECT @v_dSql2 += ' ) ' + char(10)
                                SELECT @v_dSql2 += ' SELECT COMPANY_ID,        DIVISION_ID,   SITE_ID              ' + char(10)
                                SELECT @v_dSql2 += '       ,PLANT_ID,          OPERATION_ID,  LINE_SETUP_GROUP_ID  ' + char(10)
                                SELECT @v_dSql2 += '       ,SETUP_CATEGORY_ID, SETUP_KEY_ID,  SETUP_CONDITION_ID   ' + char(10)
                                SELECT @v_dSql2 += '       ,SHOP_GROUP_ID,     SETUP_TIME,    SETUP_TIME_UOM       ' + char(10)
                                SELECT @v_dSql2 += '       ,DESCRIPTION,       INSERT_ID,     INSERT_TIME          ' + char(10)
                                SELECT @v_dSql2 += '       ,UPDATE_ID,         UPDATE_TIME,  '''+ @v_user_id +'''  ' + char(10)
                                SELECT @v_dSql2 += '       ,GETDATE(),         ''UPDATE'' AS JOB_TYPE              ' + char(10)
                                SELECT @v_dSql2 += ' FROM   SCM_SETUP_CONDITION_M(NOLOCK)                          ' + char(10)
                                SELECT @v_dSql2 += ' WHERE COMPANY_ID        = '''+ @v_company_id +'''             ' + char(10)
                                SELECT @v_dSql2 += ' AND   DIVISION_ID       = '''+ @v_division_id +'''            ' + char(10)
                                SELECT @v_dSql2 += ' AND   SITE_ID           = '''+ @v_site_id +'''                ' + char(10)
                                SELECT @v_dSql2 += ' AND   PLANT_ID          = '''+ @v_plant_id +'''               ' + char(10)
                                SELECT @v_dSql2 += ' AND   OPERATION_ID      = '''+ @v_operation_id +'''           ' + char(10)
                                SELECT @v_dSql2 += ' AND   LINE_SETUP_GROUP_ID = N'''+ @v_line_setup_group_id +''' ' + char(10)
                                SELECT @v_dSql2 += '   ' + char(10)
                                SELECT @v_dSql2 += ' UPDATE SCM_SETUP_MATRIX_M SET                                ' + char(10)
                                SELECT @v_dSql2 += '      LINE_SETUP_GROUP_ID = N'''+ @v_line_setup_group_id +''' ' + char(10)
                                SELECT @v_dSql2 += '     ,UPDATE_ID           = '''+ @v_user_id +'''              ' + char(10)
                                SELECT @v_dSql2 += '     ,UPDATE_TIME         = GETDATE()                         ' + char(10)
                                SELECT @v_dSql2 += ' WHERE COMPANY_ID        = '''+ @v_company_id +'''            ' + char(10)
                                SELECT @v_dSql2 += ' AND   DIVISION_ID       = '''+ @v_division_id +'''           ' + char(10)
                                SELECT @v_dSql2 += ' AND   SITE_ID           = '''+ @v_site_id +'''               ' + char(10)
                                SELECT @v_dSql2 += ' AND   PLANT_ID          = '''+ @v_plant_id +'''              ' + char(10)
                                SELECT @v_dSql2 += ' AND   OPERATION_ID      = '''+ @v_operation_id +'''          ' + char(10)
                                SELECT @v_dSql2 += ' AND   LINE_SETUP_GROUP_ID = N'''+ @v_org_line_setup_group_id +''' ' + char(10)
                                SELECT @v_dSql2 += '   ' + char(10)
                                SELECT @v_dSql2 += ' INSERT INTO HIS_SETUP_MATRIX_M (                                            ' + char(10)
                                SELECT @v_dSql2 += '        COMPANY_ID,         DIVISION_ID,             SITE_ID                 ' + char(10)
                                SELECT @v_dSql2 += '       ,PLANT_ID,           LINE_SETUP_GROUP_ID,     SETUP_CATEGORY_ID       ' + char(10)
                                SELECT @v_dSql2 += '       ,SETUP_KEY_ID,       FROM_ITEM_SETUP_GROUP_ID,TO_ITEM_SETUP_GROUP_ID  ' + char(10)
                                SELECT @v_dSql2 += '       ,SETUP_CONDITION_ID, OPERATION_ID,            SETUP_TIME              ' + char(10)
                                SELECT @v_dSql2 += '       ,SETUP_TIME_UOM,     ADJUST_CELL_QTY,         DESCRIPTION             ' + char(10)
                                SELECT @v_dSql2 += '       ,INSERT_ID,          INSERT_TIME,             UPDATE_ID               ' + char(10)
                                SELECT @v_dSql2 += '       ,UPDATE_TIME,        JOB_USER_ID,             JOB_TIME,   JOB_TYPE    ' + char(10)
                                SELECT @v_dSql2 += ' )  ' + char(10)
                                SELECT @v_dSql2 += ' SELECT COMPANY_ID,         DIVISION_ID,             SITE_ID                 ' + char(10)
                                SELECT @v_dSql2 += '       ,PLANT_ID,           LINE_SETUP_GROUP_ID,     SETUP_CATEGORY_ID       ' + char(10)
                                SELECT @v_dSql2 += '       ,SETUP_KEY_ID,       FROM_ITEM_SETUP_GROUP_ID,TO_ITEM_SETUP_GROUP_ID  ' + char(10)
                                SELECT @v_dSql2 += '       ,SETUP_CONDITION_ID, OPERATION_ID,            SETUP_TIME              ' + char(10)
                                SELECT @v_dSql2 += '       ,SETUP_TIME_UOM,     ADJUST_CELL_QTY,         DESCRIPTION             ' + char(10)
                                SELECT @v_dSql2 += '       ,INSERT_ID,          INSERT_TIME,             UPDATE_ID               ' + char(10)
                                SELECT @v_dSql2 += '       ,UPDATE_TIME,        '''+ @v_user_id +''' ,   GETDATE(),  ''UPDATE''  ' + char(10)
                                SELECT @v_dSql2 += ' FROM  SCM_SETUP_MATRIX_M(NOLOCK)  ' + char(10)
                                SELECT @v_dSql2 += ' WHERE COMPANY_ID        = '''+ @v_company_id +'''             ' + char(10)
                                SELECT @v_dSql2 += ' AND   DIVISION_ID       = '''+ @v_division_id +'''            ' + char(10)
                                SELECT @v_dSql2 += ' AND   SITE_ID           = '''+ @v_site_id +'''                ' + char(10)
                                SELECT @v_dSql2 += ' AND   PLANT_ID          = '''+ @v_plant_id +'''               ' + char(10)
                                SELECT @v_dSql2 += ' AND   OPERATION_ID      = '''+ @v_operation_id +'''           ' + char(10)
                                SELECT @v_dSql2 += ' AND   LINE_SETUP_GROUP_ID = N'''+ @v_line_setup_group_id +''' ' + char(10)
                                SELECT @v_dSql3 = ''
                                SELECT @v_dSql3 += ' UPDATE SCM_LINE_M SET ' + char(10)
                                SELECT @v_dSql3 += '      LINE_SETUP_GROUP_ID = N'''+ @v_line_setup_group_id +''' ' + char(10)
                                SELECT @v_dSql3 += '    , UPDATE_ID           = '''+ @v_user_id +'''              ' + char(10)
                                SELECT @v_dSql3 += '    , UPDATE_TIME         = GETDATE()                         ' + char(10)
                                SELECT @v_dSql3 += ' WHERE COMPANY_ID        = '''+ @v_company_id +'''            ' + char(10)
                                SELECT @v_dSql3 += ' AND   DIVISION_ID       = '''+ @v_division_id +'''           ' + char(10)
                                SELECT @v_dSql3 += ' AND   SITE_ID           = '''+ @v_site_id +'''               ' + char(10)
                                SELECT @v_dSql3 += ' AND   PLANT_ID          = '''+ @v_plant_id +'''              ' + char(10)
                                SELECT @v_dSql3 += ' AND   OPERATION_ID      = '''+ @v_operation_id +'''          ' + char(10)
                                SELECT @v_dSql3 += ' AND   LINE_SETUP_GROUP_ID = N'''+ @v_org_line_setup_group_id +''' ' + char(10)
                                SELECT @v_dSql3 += '  ' + char(10)
                                SELECT @v_dSql3 += ' INSERT INTO HIS_LINE_M ( ' + char(10)
                                SELECT @v_dSql3 += '     COMPANY_ID,      DIVISION_ID,   SITE_ID,            PLANT_ID           ' + char(10)
                                SELECT @v_dSql3 += '    , FACTORY_ID,     OPERATION_ID,  LINE_ID,            LINE_NAME          ' + char(10)
								SELECT @v_dSql3 += '    , ELECTRODE_TYPE, LINE_TYPE,     LINE_SETUP_GROUP_ID,LINE_TYPE_NAME     ' + char(10)
                                SELECT @v_dSql3 += '    , ACTIVE_FLAG,    DESCRIPTION,   INSERT_ID,          INSERT_TIME        ' + char(10)
                                SELECT @v_dSql3 += '    , UPDATE_ID,      UPDATE_TIME,   JOB_USER_ID,        JOB_TIME, JOB_TYPE ' + char(10)
                                SELECT @v_dSql3 += ' ) ' + char(10)
                                SELECT @v_dSql3 += ' SELECT COMPANY_ID,   DIVISION_ID,   SITE_ID,              PLANT_ID         ' + char(10)
                                SELECT @v_dSql3 += '    , FACTORY_ID,     OPERATION_ID,  LINE_ID,              LINE_NAME        ' + char(10)
								SELECT @v_dSql3 += '    , ELECTRODE_TYPE, LINE_TYPE,     LINE_SETUP_GROUP_ID,  LINE_TYPE_NAME   ' + char(10)
                                SELECT @v_dSql3 += '    , ACTIVE_FLAG,    DESCRIPTION,   INSERT_ID,            INSERT_TIME      ' + char(10)
                                SELECT @v_dSql3 += '    ,UPDATE_ID,       UPDATE_TIME,   '''+ @v_user_id +''', GETDATE(), ''UPDATE'' ' + char(10)
                                SELECT @v_dSql3 += ' FROM   SCM_LINE_M(NOLOCK)                                     ' + char(10)
                                SELECT @v_dSql3 += ' WHERE COMPANY_ID        = '''+ @v_company_id +'''             ' + char(10)
                                SELECT @v_dSql3 += ' AND   DIVISION_ID       = '''+ @v_division_id +'''            ' + char(10)
                                SELECT @v_dSql3 += ' AND   SITE_ID           = '''+ @v_site_id +'''                ' + char(10)
                                SELECT @v_dSql3 += ' AND   PLANT_ID          = '''+ @v_plant_id +'''               ' + char(10)
                                SELECT @v_dSql3 += ' AND   OPERATION_ID      = '''+ @v_operation_id +'''           ' + char(10)
                                SELECT @v_dSql3 += ' AND   LINE_SETUP_GROUP_ID = N'''+ @v_line_setup_group_id +''' ' + char(10)

								SELECT @v_dSql = @v_dSql1 + @v_dSql2 +@v_dSql3

                            END --M

					   /****************************************************************************/
					   /* DELETE  경우  :    D(SUB)                                             */
					   /****************************************************************************/
					   ELSE IF(@v_sys_flag ='DELETE_SUB')
							BEGIN
							    SELECT @v_dSql1 = ''
                                SELECT @v_dSql1 += ' INSERT INTO his_line_setup_group_m (                ' + char(10)
                                SELECT @v_dSql1 += '     COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID      ' + char(10)
                                SELECT @v_dSql1 += '    ,OPERATION_ID, LINE_SETUP_GROUP_ID, DESCRIPTION  ' + char(10)
                                SELECT @v_dSql1 += '    ,INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME  ' + char(10)
                                SELECT @v_dSql1 += '    ,JOB_USER_ID,JOB_TIME,JOB_TYPE                   ' + char(10)
                                SELECT @v_dSql1 += ' )  ' + char(10)
                                SELECT @v_dSql1 += ' SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID   ' + char(10)
                                SELECT @v_dSql1 += '    ,OPERATION_ID, LINE_SETUP_GROUP_ID, DESCRIPTION  ' + char(10)
                                SELECT @v_dSql1 += '    ,INSERT_ID,INSERT_TIME,UPDATE_ID,UPDATE_TIME     ' + char(10)
                                SELECT @v_dSql1 += '    ,'''+ @v_user_id +''' ,GETDATE(),''DELETE''      ' + char(10)
                                SELECT @v_dSql1 += ' FROM   scm_line_setup_group_m(NOLOCK)               ' + char(10)
                                SELECT @v_dSql1 += ' WHERE COMPANY_ID        = '''+ @v_company_id +'''   ' + char(10)
                                SELECT @v_dSql1 += ' AND   DIVISION_ID       = '''+ @v_division_id +'''  ' + char(10)
                                SELECT @v_dSql1 += ' AND   SITE_ID           = '''+ @v_site_id +'''      ' + char(10)
                                SELECT @v_dSql1 += ' AND   PLANT_ID          = '''+ @v_plant_id +'''     ' + char(10)
                                SELECT @v_dSql1 += ' AND   OPERATION_ID      = '''+ @v_operation_id +''' ' + char(10)
                                SELECT @v_dSql1 += ' AND   LINE_SETUP_GROUP_ID = N'''+ @v_org_line_setup_group_id +'''  ' + char(10)
                                SELECT @v_dSql1 += '  ' + char(10)
                                SELECT @v_dSql1 += ' DELETE FROM scm_line_setup_group_m                  ' + char(10)
                                SELECT @v_dSql1 += ' WHERE COMPANY_ID        = '''+ @v_company_id +'''   ' + char(10)
                                SELECT @v_dSql1 += ' AND   DIVISION_ID       = '''+ @v_division_id +'''  ' + char(10)
                                SELECT @v_dSql1 += ' AND   SITE_ID           = '''+ @v_site_id +'''      ' + char(10)
                                SELECT @v_dSql1 += ' AND   PLANT_ID          = '''+ @v_plant_id +'''     ' + char(10)
                                SELECT @v_dSql1 += ' AND   OPERATION_ID      = '''+ @v_operation_id +''' ' + char(10)
                                SELECT @v_dSql1 += ' AND   LINE_SETUP_GROUP_ID = N'''+ @v_org_line_setup_group_id +'''  ' + char(10)
                                SELECT @v_dSql1 += '   ' + char(10)
                                SELECT @v_dSql1 += ' INSERT INTO HIS_SETUP_CONDITION_M (  ' + char(10)
                                SELECT @v_dSql1 += '     COMPANY_ID,   DIVISION_ID,         SITE_ID,           PLANT_ID       ' + char(10)
                                SELECT @v_dSql1 += '    ,OPERATION_ID, LINE_SETUP_GROUP_ID, SETUP_CATEGORY_ID, SETUP_KEY_ID   ' + char(10)
                                SELECT @v_dSql1 += '    ,SETUP_CONDITION_ID,SHOP_GROUP_ID,  SETUP_TIME,        SETUP_TIME_UOM ' + char(10)
                                SELECT @v_dSql1 += '    ,DESCRIPTION,  INSERT_ID,           INSERT_TIME,       UPDATE_ID      ' + char(10)
                                SELECT @v_dSql1 += '    ,UPDATE_TIME,  JOB_USER_ID,         JOB_TIME,          JOB_TYPE       ' + char(10)
                                SELECT @v_dSql1 += ' )  ' + char(10)
                                SELECT @v_dSql1 += ' SELECT COMPANY_ID,    DIVISION_ID,        SITE_ID,           PLANT_ID       ' + char(10)
                                SELECT @v_dSql1 += '   ,OPERATION_ID,      LINE_SETUP_GROUP_ID,SETUP_CATEGORY_ID, SETUP_KEY_ID   ' + char(10)
                                SELECT @v_dSql1 += '   ,SETUP_CONDITION_ID,SHOP_GROUP_ID,      SETUP_TIME,        SETUP_TIME_UOM ' + char(10)
                                SELECT @v_dSql1 += '   ,DESCRIPTION,       INSERT_ID,          INSERT_TIME,       UPDATE_ID      ' + char(10)
                                SELECT @v_dSql1 += '   ,UPDATE_TIME,       '''+ @v_user_id +''',GETDATE(),        ''DELETE''     ' + char(10)
                                SELECT @v_dSql1 += ' FROM   SCM_SETUP_CONDITION_M(NOLOCK)                 ' + char(10)
                                SELECT @v_dSql1 += ' WHERE COMPANY_ID        = '''+ @v_company_id +'''    ' + char(10)
                                SELECT @v_dSql1 += ' AND   DIVISION_ID       = '''+ @v_division_id +'''   ' + char(10)
                                SELECT @v_dSql1 += ' AND   SITE_ID           = '''+ @v_site_id +'''       ' + char(10)
                                SELECT @v_dSql1 += ' AND   PLANT_ID          = '''+ @v_plant_id +'''      ' + char(10)
                                SELECT @v_dSql1 += ' AND   OPERATION_ID      = '''+ @v_operation_id +'''  ' + char(10)
                                SELECT @v_dSql1 += ' AND   LINE_SETUP_GROUP_ID = N'''+ @v_org_line_setup_group_id +'''  ' + char(10)
                                SELECT @v_dSql2 = ''
                                SELECT @v_dSql2 += ' DELETE  FROM   SCM_SETUP_CONDITION_M                 ' + char(10)
                                SELECT @v_dSql2 += ' WHERE COMPANY_ID        = '''+ @v_company_id +'''    ' + char(10)
                                SELECT @v_dSql2 += ' AND   DIVISION_ID       = '''+ @v_division_id +'''   ' + char(10)
                                SELECT @v_dSql2 += ' AND   SITE_ID           = '''+ @v_site_id +'''       ' + char(10)
                                SELECT @v_dSql2 += ' AND   PLANT_ID          = '''+ @v_plant_id +'''      ' + char(10)
                                SELECT @v_dSql2 += ' AND   OPERATION_ID      = '''+ @v_operation_id +'''  ' + char(10)
                                SELECT @v_dSql2 += ' AND   LINE_SETUP_GROUP_ID = N'''+ @v_org_line_setup_group_id +'''  ' + char(10)
                                SELECT @v_dSql2 += '  ' + char(10)
                                SELECT @v_dSql2 += ' INSERT INTO HIS_SETUP_MATRIX_M ( ' + char(10)
                                SELECT @v_dSql2 += '     COMPANY_ID,            DIVISION_ID,       SITE_ID,      PLANT_ID     ' + char(10)
                                SELECT @v_dSql2 += '    ,LINE_SETUP_GROUP_ID,   SETUP_CATEGORY_ID, SETUP_KEY_ID, FROM_ITEM_SETUP_GROUP_ID ' + char(10)
                                SELECT @v_dSql2 += '    ,TO_ITEM_SETUP_GROUP_ID,SETUP_CONDITION_ID,OPERATION_ID, SETUP_TIME   ' + char(10)
                                SELECT @v_dSql2 += '    ,SETUP_TIME_UOM,        ADJUST_CELL_QTY,   DESCRIPTION,  INSERT_ID    ' + char(10)
                                SELECT @v_dSql2 += '    ,INSERT_TIME,           UPDATE_ID,         UPDATE_TIME,  JOB_USER_ID  ' + char(10)
                                SELECT @v_dSql2 += '    ,JOB_TIME,JOB_TYPE ' + char(10)
                                SELECT @v_dSql2 += ' ) ' + char(10)
                                SELECT @v_dSql2 += ' SELECT COMPANY_ID,            DIVISION_ID,       SITE_ID,      PLANT_ID                 ' + char(10)
                                SELECT @v_dSql2 += '       ,LINE_SETUP_GROUP_ID,   SETUP_CATEGORY_ID, SETUP_KEY_ID, FROM_ITEM_SETUP_GROUP_ID ' + char(10)
                                SELECT @v_dSql2 += '       ,TO_ITEM_SETUP_GROUP_ID,SETUP_CONDITION_ID,OPERATION_ID, SETUP_TIME               ' + char(10)
                                SELECT @v_dSql2 += '       ,SETUP_TIME_UOM,        ADJUST_CELL_QTY,   DESCRIPTION,  INSERT_ID                ' + char(10)
                                SELECT @v_dSql2 += '       ,INSERT_TIME,           UPDATE_ID,         UPDATE_TIME,  '''+ @v_user_id +'''     ' + char(10)
                                SELECT @v_dSql2 += '       ,GETDATE() ,''DELETE''                        ' + char(10)
                                SELECT @v_dSql2 += ' FROM  SCM_SETUP_MATRIX_M(NOLOCK)                    ' + char(10)
                                SELECT @v_dSql2 += ' WHERE COMPANY_ID        = '''+ @v_company_id +'''   ' + char(10)
                                SELECT @v_dSql2 += ' AND   DIVISION_ID       = '''+ @v_division_id +'''  ' + char(10)
                                SELECT @v_dSql2 += ' AND   SITE_ID           = '''+ @v_site_id +'''      ' + char(10)
                                SELECT @v_dSql2 += ' AND   PLANT_ID          = '''+ @v_plant_id +'''     ' + char(10)
                                SELECT @v_dSql2 += ' AND   OPERATION_ID      = '''+ @v_operation_id +''' ' + char(10)
                                SELECT @v_dSql2 += ' AND   LINE_SETUP_GROUP_ID = N'''+ @v_org_line_setup_group_id +'''  ' + char(10)
                                SELECT @v_dSql2 += '  ' + char(10)
                                SELECT @v_dSql2 += ' DELETE   FROM   SCM_SETUP_MATRIX_M                  ' + char(10)
                                SELECT @v_dSql2 += ' WHERE COMPANY_ID        = '''+ @v_company_id +'''   ' + char(10)
                                SELECT @v_dSql2 += ' AND   DIVISION_ID       = '''+ @v_division_id +'''  ' + char(10)
                                SELECT @v_dSql2 += ' AND   SITE_ID           = '''+ @v_site_id +'''      ' + char(10)
                                SELECT @v_dSql2 += ' AND   PLANT_ID          = '''+ @v_plant_id +'''     ' + char(10)
                                SELECT @v_dSql2 += ' AND   OPERATION_ID      = '''+ @v_operation_id +''' ' + char(10)
                                SELECT @v_dSql2 += ' AND   LINE_SETUP_GROUP_ID = N'''+ @v_line_setup_group_id +'''  ' + char(10)
                                SELECT @v_dSql2 += '  ' + char(10)
                                SELECT @v_dSql2 += ' UPDATE SCM_LINE_M SET                               ' + char(10)
                                SELECT @v_dSql2 += '        LINE_SETUP_GROUP_ID = null                   ' + char(10)
                                SELECT @v_dSql2 += '       ,UPDATE_ID           = '''+ @v_user_id +'''   ' + char(10)
                                SELECT @v_dSql2 += '       ,UPDATE_TIME         = GETDATE()              ' + char(10)
                                SELECT @v_dSql2 += ' WHERE COMPANY_ID        = '''+ @v_company_id +'''   ' + char(10)
                                SELECT @v_dSql2 += ' AND   DIVISION_ID       = '''+ @v_division_id +'''  ' + char(10)
                                SELECT @v_dSql2 += ' AND   SITE_ID           = '''+ @v_site_id +'''      ' + char(10)
                                SELECT @v_dSql2 += ' AND   PLANT_ID          = '''+ @v_plant_id +'''     ' + char(10)
                                SELECT @v_dSql2 += ' AND   OPERATION_ID      = '''+ @v_operation_id +''' ' + char(10)
                                SELECT @v_dSql2 += ' AND   LINE_SETUP_GROUP_ID = N'''+ @v_org_line_setup_group_id +'''  ' + char(10)
                                SELECT @v_dSql2 += '   ' + char(10)
                                SELECT @v_dSql2 += ' INSERT INTO HIS_LINE_M ( ' + char(10)
                                SELECT @v_dSql2 += '      COMPANY_ID,     DIVISION_ID,  SITE_ID,             PLANT_ID       ' + char(10)
                                SELECT @v_dSql2 += '    , FACTORY_ID,     OPERATION_ID, LINE_ID,             LINE_NAME      ' + char(10)
								SELECT @v_dSql2 += '    , ELECTRODE_TYPE, LINE_TYPE,    LINE_SETUP_GROUP_ID, LINE_TYPE_NAME ' + char(10)
                                SELECT @v_dSql2 += '    , ACTIVE_FLAG,    DESCRIPTION,  INSERT_ID,           INSERT_TIME    ' + char(10)
                                SELECT @v_dSql2 += '    , UPDATE_ID,      UPDATE_TIME,  JOB_USER_ID,  JOB_TIME, JOB_TYPE    ' + char(10)
                                SELECT @v_dSql2 += ' ) ' + char(10)
                                SELECT @v_dSql2 += ' SELECT COMPANY_ID,   DIVISION_ID,  SITE_ID,             PLANT_ID       ' + char(10)
                                SELECT @v_dSql2 += '    , FACTORY_ID,     OPERATION_ID, LINE_ID,             LINE_NAME      ' + char(10)
								SELECT @v_dSql2 += '    , ELECTRODE_TYPE, LINE_TYPE,    LINE_SETUP_GROUP_ID, LINE_TYPE_NAME ' + char(10)
                                SELECT @v_dSql2 += '    , ACTIVE_FLAG,    DESCRIPTION,  INSERT_ID,           INSERT_TIME    ' + char(10)
                                SELECT @v_dSql2 += '    , UPDATE_ID,      UPDATE_TIME,'''+ @v_user_id +''', GETDATE(), ''UPDATE'' ' + char(10)
                                SELECT @v_dSql2 += ' FROM   SCM_LINE_M(NOLOCK)                           ' + char(10)
                                SELECT @v_dSql2 += ' WHERE COMPANY_ID        = '''+ @v_company_id +'''   ' + char(10)
                                SELECT @v_dSql2 += ' AND   DIVISION_ID       = '''+ @v_division_id +'''  ' + char(10)
                                SELECT @v_dSql2 += ' AND   SITE_ID           = '''+ @v_site_id +'''      ' + char(10)
                                SELECT @v_dSql2 += ' AND   PLANT_ID          = '''+ @v_plant_id +'''     ' + char(10)
                                SELECT @v_dSql2 += ' AND   OPERATION_ID      = '''+ @v_operation_id +''' ' + char(10)
                                SELECT @v_dSql2 += ' AND   LINE_SETUP_GROUP_ID = N'''+ @v_org_line_setup_group_id +'''  ' + char(10)

								SELECT @v_dSql = @v_dSql1 + @v_dSql2

                            END --M

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

