


/*
 * Program ID   : PR_UI_FP00414_ADD_POP
 * Description  : Formation Tray for Model 입력 팝업 조회 쿼리들
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/11/10   LJS				Initial Release UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FP00414_ADD_POP]
  @p_sys_type                   NVARCHAR(MAX),
  @p_sys_flag                   NVARCHAR(MAX),
  @p_sys_gubun                  NVARCHAR(MAX),
  @p_user_id                    NVARCHAR(MAX),
  @p_company_id                 NVARCHAR(MAX),
  @p_division_id                NVARCHAR(MAX),
  @p_site_id                    NVARCHAR(MAX),
  @p_plant_id                   NVARCHAR(MAX),
  @p_param_1                    NVARCHAR(MAX),
  @p_param_2                    NVARCHAR(MAX),
  @p_param_3                    NVARCHAR(MAX),
  @p_param_4                    NVARCHAR(MAX),
  @p_param_5                    NVARCHAR(MAX)

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
	DECLARE @v_factory_id                 NVARCHAR(MAX)

	DECLARE @recv_active_flag       NVARCHAR(MAX)				    
	DECLARE @v_proc_name	        NVARCHAR(100) = 'PR_UI_FP00414_ADD_POP'
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
	SET @v_factory_id               = @p_param_1

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
	IF(@p_sys_flag ='LINE_ADD')
		BEGIN --IF(START)
/*
SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, LINE_ID, LINE_NAME
FROM   SCM_LINE_M A WITH(NOLOCK)
WHERE  1=1
AND    A.OPERATION_ID = 'F6000'
AND    A.ACTIVE_FLAG = 'Y'
ORDER BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.LINE_ID
*/
			SELECT @v_dSql = ''
			SELECT @v_dSql += '	SELECT	A.* ' + char(10)
			SELECT @v_dSql += '	FROM	( ' + char(10)
            SELECT @v_dSql += '				SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			--SELECT @v_dSql += '						, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql += '						, (CASE WHEN C.PLANT_ID IS NOT NULL THEN A.FACTORY_ID ELSE ''-'' END) AS FACTORY_ID ' + char(10)
			SELECT @v_dSql += '						, ISNULL((CASE WHEN C.PLANT_ID IS NOT NULL AND ISNULL(A.PSEUDO_FACTORY_ID,''-'') = ''-'' THEN A.FACTORY_ID ELSE A.PSEUDO_FACTORY_ID END),''-'') AS PSEUDO_FACTORY_ID ' + char(10)
			SELECT @v_dSql += '						, A.LINE_ID, A.LINE_NAME ' + char(10)
			SELECT @v_dSql += '				FROM   SCM_LINE_M A WITH(NOLOCK)	 ' + char(10)
            SELECT @v_dSql += '						LEFT OUTER JOIN (																														 ' + char(10)
			SELECT @v_dSql += '								SELECT	DISTINCT C.SEGMENT1 AS INSTNCE_ID, V.COMPANY_ID, V.SITE_ID, V.DIVISION_ID, V.PLANT_ID      ' + char(10)
			SELECT @v_dSql += '								FROM	SCM_SYS_LOOKUP_VALUE C  																						              ' + char(10)
			SELECT @v_dSql += '										, FP_INSTANCE_INFO_V V																							              ' + char(10)
			SELECT @v_dSql += '								WHERE	1=1                                                                                                                           ' + char(10)            
			SELECT @v_dSql += '								AND		C.LOOKUP_TYPE_CODE = ''FORM_TRAY_SIMUL_OPTION''                                                                                 ' + char(10)     
			SELECT @v_dSql += '								AND		C.ACTIVE_FLAG = ''Y''       																						              ' + char(10)
			SELECT @v_dSql += '								AND     C.ATTRIBUTE1 = ''BUILDING''																						              ' + char(10)
			SELECT @v_dSql += '								AND     C.SEGMENT1 = V.INSTANCE_ID																					              ' + char(10)
			SELECT @v_dSql += '						) C																																		 ' + char(10)
			SELECT @v_dSql += '						ON 1=1																																	 ' + char(10)
			SELECT @v_dSql += '						AND    A.DIVISION_ID     = C.DIVISION_ID 																										 ' + char(10)
			SELECT @v_dSql += '						AND    A.SITE_ID     = C.SITE_ID 																										 ' + char(10)
			SELECT @v_dSql += '						AND    A.PLANT_ID    = C.PLANT_ID 																										 ' + char(10)
			SELECT @v_dSql += '						, ( ' + char(10)
			SELECT @v_dSql += '							SELECT DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.LINE_ID ' + char(10)
			SELECT @v_dSql += '							FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += '							WHERE  1=1 ' + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('R.USER_ID' , 'EQ', @p_user_id)) + char(10)
			SELECT @v_dSql += '				 			AND    R.SAVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql += '				 			AND    R.OPERATION_ID = ''F6000'' ' + char(10)
			SELECT @v_dSql += '						) B ' + char(10)
            SELECT @v_dSql += '				 WHERE  1=1 ' + char(10)
			SELECT @v_dSql += '				 AND    A.COMPANY_ID  = B.COMPANY_ID ' + char(10)
			SELECT @v_dSql += '				 AND    A.DIVISION_ID = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql += '				 AND    A.SITE_ID     = B.SITE_ID ' + char(10)
			SELECT @v_dSql += '				 AND    A.PLANT_ID    = B.PLANT_ID ' + char(10)
			SELECT @v_dSql += '				 AND    A.LINE_ID     = B.LINE_ID ' + char(10)
            SELECT @v_dSql += '				 AND    A.OPERATION_ID = ''F6000'' ' + char(10)
            SELECT @v_dSql += '				 AND    A.ACTIVE_FLAG = ''Y''          ' + char(10)
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))         + char(10)
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))       + char(10)
			SELECT @v_dSql += '			) A ' + char(10)
            SELECT @v_dSql += ' ORDER BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LINE_ID ' + char(10)

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
	/* SELECT인경우 :SELECT(TRAY_ID)                                                                      */
	/************************************************************************************************/
	IF(@p_sys_flag ='TRAY_ADD')
		BEGIN --IF(START)
/*
SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID
     , A.TRAY_TYPE_CODE
	 , A.TRAY_TYPE_NAME
	 , A.TRAY_TYPE_GROUP -- GROUP_TRAY_ID
     , ISNULL(B.ATTRIBUTE1, A.DEGAS_BEFORE_TYPE) AS TRAY_TYPE
FROM   SCM_FCS_TRAY_M A WITH(NOLOCK)
LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE B WITH(NOLOCK)
ON    1=1
AND   B.LOOKUP_TYPE_CODE  = 'FORMATION_TRAY_TYPE'
AND   B.ACTIVE_FLAG       = 'Y'
AND   A.PLANT_ID          = B.SEGMENT1
AND   A.DEGAS_BEFORE_TYPE = B.SEGMENT2
WHERE 1=1
AND   A.USE_YN = 'Y'
AND   A.DIVISION_ID = '81'
AND   A.SITE_ID = 'A001'
AND   A.PLANT_ID = 'A040'
ORDER BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.TRAY_TYPE_CODE
*/
            SELECT @v_dSql = ''
			SELECT @v_dSql += 'SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID' + char(10)
			SELECT @v_dSql += '     , A.TRAY_TYPE_CODE' + char(10)
			SELECT @v_dSql += '     , A.TRAY_TYPE_NAME' + char(10)
			SELECT @v_dSql += '     , A.TRAY_TYPE_GROUP' + char(10)
			SELECT @v_dSql += '     , ISNULL(B.ATTRIBUTE1, A.DEGAS_BEFORE_TYPE) AS TRAY_TYPE' + char(10)
			SELECT @v_dSql += 'FROM   SCM_FCS_TRAY_M A WITH(NOLOCK)' + char(10)
			SELECT @v_dSql += 'LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE B WITH(NOLOCK)' + char(10)
			SELECT @v_dSql += 'ON    1=1' + char(10)
			SELECT @v_dSql += 'AND   B.LOOKUP_TYPE_CODE  = ''FORMATION_TRAY_TYPE'' ' + char(10)
			SELECT @v_dSql += 'AND   B.ACTIVE_FLAG       = ''Y'' ' + char(10)
			SELECT @v_dSql += 'AND   A.PLANT_ID          = B.SEGMENT1' + char(10)
			SELECT @v_dSql += 'AND   A.DEGAS_BEFORE_TYPE = B.SEGMENT2' + char(10)
			SELECT @v_dSql += 'WHERE 1=1' + char(10)
			SELECT @v_dSql += 'AND   A.USE_YN = ''Y'' ' + char(10)
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
	      	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))         + char(10)
	      	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))       + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @v_factory_id))       + char(10)
			SELECT @v_dSql += 'ORDER BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.TRAY_TYPE_CODE' + char(10)

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
	/* SELECT인경우 :SELECT(ITEM_ID)                                                                      */
	/************************************************************************************************/
	IF(@p_sys_flag ='ITEM_ADD')
		BEGIN --IF(START)
            SELECT @v_dSql = ''
            SELECT @v_dSql += ' SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, B.PLANT_ID, A.ITEM_ID, A.NICK_NAME  ' + char(10)
            SELECT @v_dSql += ' FROM	(  ' + char(10)
            SELECT @v_dSql += ' 		SELECT COMPANY_ID, DIVISION_ID, SITE_ID, ITEM_ID, ITEM_NAME, LEVEL_2_CODE, LEVEL_3_CODE, NICK_NAME  ' + char(10)
            SELECT @v_dSql += ' 		FROM   SCM_ITEM_M A WITH(NOLOCK), SCM_ITEM_CLASS_M IC WITH(NOLOCK)  ' + char(10)
            SELECT @v_dSql += ' 		WHERE  A.ITEM_CLASS  = IC.CLASS_ID  ' + char(10)
            SELECT @v_dSql += ' 		AND    IC.USE_FLAG   = ''Y''        ' + char(10)
            SELECT @v_dSql += ' 		AND    A.ACTIVE_FLAG = ''Y''        ' + char(10)
            SELECT @v_dSql += ' 		AND		 IC.LEVEL_2_CODE = ''APC''  ' + char(10)
            SELECT @v_dSql += ' 		AND 	 IC.LEVEL_3_CODE NOT IN (''-'',''APCSR'')  ' + char(10)
            SELECT @v_dSql += ' 		AND    A.FLOW_ID IS NOT NULL                       ' + char(10)
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))         + char(10)
            SELECT @v_dSql += ' ) A, SCM_FACTORY_M B WITH(NOLOCK)      ' + char(10)
            SELECT @v_dSql += ' WHERE	A.COMPANY_ID   = B.COMPANY_ID  ' + char(10)
            SELECT @v_dSql += ' AND		A.DIVISION_ID  = B.DIVISION_ID ' + char(10)
            SELECT @v_dSql += ' AND		A.SITE_ID      = B.SITE_ID     ' + char(10)
            SELECT @v_dSql += ' AND		B.ACTIVE_FLAG  = ''Y''         ' + char(10)
            SELECT @v_dSql += ' AND   EXISTS(         ' + char(10)
            SELECT @v_dSql += ' 			SELECT 1  ' + char(10)
            SELECT @v_dSql += ' 			FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK)    ' + char(10)
            SELECT @v_dSql += ' 			WHERE  R.USER_ID     = '''+ @p_user_id +'''  ' + char(10)
            SELECT @v_dSql += ' 			AND    R.SAVE_FLAG   = ''Y''                 ' + char(10)
            SELECT @v_dSql += ' 			AND    B.COMPANY_ID  = R.COMPANY_ID          ' + char(10)
            SELECT @v_dSql += ' 			AND    B.DIVISION_ID = R.DIVISION_ID         ' + char(10)
            SELECT @v_dSql += ' 			AND    B.SITE_ID     = R.SITE_ID             ' + char(10)
            SELECT @v_dSql += ' 			AND    B.PLANT_ID    = R.PLANT_ID            ' + char(10)
            SELECT @v_dSql += '  )  ' + char(10)
            --SELECT @v_dSql += ' AND    UPPER(A.ITEM_ID) LIKE ''%'' + '''+ @p_item_id +''' + ''%''          ' + char(10)
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
	      	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))         + char(10)
	      	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.PLANT_ID' , 'EQ', @p_plant_id))       + char(10)

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


END --MAIN END

