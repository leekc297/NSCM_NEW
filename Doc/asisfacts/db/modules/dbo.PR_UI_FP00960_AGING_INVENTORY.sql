
/*
 * Program ID   : PR_UI_FP00960_AGING_INVENTORY
 * Description  : Formation Yield
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/11/05  JYJ				Initial Release UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FP00960_AGING_INVENTORY]
  @p_sys_type             NVARCHAR(MAX),
  @p_sys_flag             NVARCHAR(MAX),
  @p_sys_gubun            NVARCHAR(MAX),
  @p_user_id              NVARCHAR(MAX),
  @p_division_id          NVARCHAR(MAX),
  @p_site_id              NVARCHAR(MAX),
  @p_plant_id             NVARCHAR(MAX),
  @p_factory_id           NVARCHAR(MAX),
  @p_line_id              NVARCHAR(MAX),
  @p_operation_id         NVARCHAR(MAX),
  @p_route_id             NVARCHAR(MAX),
  @p_item_id              NVARCHAR(MAX),
  @p_cur_off_date         NVARCHAR(MAX)

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
    DECLARE @v_plant_id             NVARCHAR(MAX)
    DECLARE @v_factory_id           NVARCHAR(MAX)
    DECLARE @v_line_id              NVARCHAR(MAX)
    DECLARE @v_item_id              NVARCHAR(MAX)
    DECLARE @v_nick_name            NVARCHAR(MAX)


	DECLARE @recv_active_flag       NVARCHAR(MAX)				    
	DECLARE @v_proc_name	        NVARCHAR(100) = 'PR_UI_FP00960_AGING_INVENTORY'
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
	SET @v_division_id        = '' 
    SET @v_site_id            = '' 
    SET @v_plant_id           = ''
    SET @v_factory_id         = ''
    SET @v_line_id            = ''
	SET @v_item_id            = ''
	SET @v_nick_name          = ''


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
		    SELECT @v_dSql  = ''

            SELECT @v_dSql += ' SELECT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID ' + char(10)
            SELECT @v_dSql += '     ,A.ROUTE_ID                                                     ' + char(10)
			SELECT @v_dSql += '     ,D.ROUTE_DESC                                                     ' + char(10)
            SELECT @v_dSql += '     ,A.LINE_ID                                                      ' + char(10)
            SELECT @v_dSql += '     ,FORMAT(A.CUTOFF_DATE, ''yyyyMMdd'') AS CUTOFF_DATE             ' + char(10)
            SELECT @v_dSql += '     ,A.SEQ                                                          ' + char(10)
            SELECT @v_dSql += '     ,A.ITEM_ID, ISNULL(C.NICK_NAME, ''-'') AS NICK_NAME             ' + char(10)
            SELECT @v_dSql += '     ,A.PRODUCTION_TYPE                                              ' + char(10)
            SELECT @v_dSql += '     ,FORMAT(A.FCS_INPUT_DATE, ''yyyyMMdd'') AS FCS_INPUT_DATE       ' + char(10)
            SELECT @v_dSql += '     ,FORMAT(A.BASE_AVAILABLE_DATE, ''yyyyMMdd'') AS AVAILABLE_DATE  ' + char(10)
            SELECT @v_dSql += '     ,FORMAT(A.AVAILABLE_DATE, ''yyyyMMdd'') AS AVAILABLE_DATE2      ' + char(10)
            SELECT @v_dSql += '     ,FORMAT(A.REMAIN_LEAD_TIME,''##0.0'') AS REMAIN_LEAD_TIME       ' + char(10)
            SELECT @v_dSql += '     ,FORMAT(A.HOLDING_DATE, ''yyyyMMdd'') AS HOLDING_DATE           ' + char(10)
            SELECT @v_dSql += '     ,A.INPUT_QTY                                                    ' + char(10)
            SELECT @v_dSql += '     ,FLOOR(A.QTY) AS QTY, FLOOR(A.ORIGINAL_QTY) AS ORIGINAL_QTY     ' + char(10)
            SELECT @v_dSql += '     ,A.QTY_UOM                                              ' + char(10)
            SELECT @v_dSql += '     ,A.STOCK_STATUS                                         ' + char(10)
            SELECT @v_dSql += '     ,A.OPERATION_ID ' + char(10)
            --SELECT @v_dSql += '     ,E.OPERATION_NAME ' + char(10)
            SELECT @v_dSql += '     ,ISNULL(E.OPERATION_NAME, B.OPERATION_NAME) AS OPERATION_NAME ' + char(10)
            SELECT @v_dSql += '     ,A.OPERATION_SEQ                                        ' + char(10)
            SELECT @v_dSql += '     ,FORMAT(A.OP_START_TIME, ''yyyyMMdd'') AS OP_START_TIME ' + char(10)
            SELECT @v_dSql += '     ,A.TRAY_OP_STATUS                                       ' + char(10)
            SELECT @v_dSql += '     ,A.LOT_ID, A.WIPHOLD_YN, A.SPECIAL_YN                   ' + char(10)
            SELECT @v_dSql += '     ,A.UPDATE_ID                                            ' + char(10)
            SELECT @v_dSql += '     ,CONVERT(VARCHAR, A.UPDATE_TIME, 120) AS UPDATE_TIME    ' + char(10)
            SELECT @v_dSql += '     ,(SELECT TOP 1 X.LINE_NAME                              ' + char(10)
            SELECT @v_dSql += '       FROM   SCM_LINE_M  X WITH(NOLOCK)                     ' + char(10)
            SELECT @v_dSql += '       WHERE  X.COMPANY_ID   = A.COMPANY_ID                  ' + char(10)
            SELECT @v_dSql += '       AND    X.DIVISION_ID  = A.DIVISION_ID                 ' + char(10)
            SELECT @v_dSql += '       AND    X.SITE_ID      = A.SITE_ID                     ' + char(10)
            SELECT @v_dSql += '       AND    X.PLANT_ID     = A.PLANT_ID                    ' + char(10)
            SELECT @v_dSql += '       AND    X.FACTORY_ID   = A.FACTORY_ID                  ' + char(10)
            SELECT @v_dSql += '       AND    X.OPERATION_ID = A.OPERATION_ID                ' + char(10)
            SELECT @v_dSql += '       AND    X.LINE_ID      = A.LINE_ID                     ' + char(10)
            SELECT @v_dSql += '       ORDER BY X.OPERATION_ID DESC) AS LINE_NAME /* LINE 정보 표기 20171114 YANG*/  ' + char(10)
            SELECT @v_dSql += '     ,FORMAT(A.DEGAS_END_DATE, ''yyyy-MM-dd'') AS DEGAS_END_DATE                     ' + char(10)
            SELECT @v_dSql += '     ,FORMAT(A.UNHOLD_EXP_DATE, ''yyyy-MM-dd'') AS UNHOLD_EXP_DATE -- Hold 해제일자 추가... 20210813 ' + char(10)
            SELECT @v_dSql += ' FROM   SCM_AGING_STOCK_H A WITH(NOLOCK)             ' + char(10)
			SELECT @v_dSql += '			LEFT HASH JOIN (																												' + char(10)
			--SELECT @v_dSql += '						SELECT	A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID, A.ITEM_ID, A.ROUTE_ID, A.LINE_ID			' + char(10)
			SELECT @v_dSql += '						SELECT	A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID, A.ROUTE_ID		' + char(10)
			SELECT @v_dSql += '								, MAX(ROUTE_DESCRIPTION) AS ROUTE_DESC						' + char(10)
			SELECT @v_dSql += '						FROM	SCM_AGING_ITEM_FLOW_M A WITH(NOLOCK)       																	' + char(10)
			SELECT @v_dSql += '						WHERE	1=1																											' + char(10)
			
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
	        IF(LEN(@p_site_id) > 0)
            BEGIN
	               SELECT @v_dSql += ' AND  A.SITE_ID = '''+ @p_site_id +''' ' +  char(10)
            END
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
			
			IF(LEN(@p_route_id) > 0)
                BEGIN
                   SELECT @v_dSql += ' AND  A.ROUTE_ID  = '''+ @p_route_id +'''  ' + char(10)
                END            
			IF(LEN(@p_operation_id) > 0)
                BEGIN
                   SELECT @v_dSql += ' AND  A.OPERATION_ID  = '''+ @p_operation_id +'''  ' + char(10)
                END
            IF(LEN(@p_item_id) > 0)
                BEGIN
                  SELECT @v_dSql += ' AND  A.ITEM_ID LIKE  UPPER(''%'' + '''+ @p_item_id +''' + ''%'') ' + char(10)
               END	  

			--SELECT @v_dSql += '						GROUP BY A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID, A.ITEM_ID, A.ROUTE_ID, A.LINE_ID		' + char(10)
			SELECT @v_dSql += '						GROUP BY A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID, A.ROUTE_ID		' + char(10)
			SELECT @v_dSql += '			) D																																' + char(10)
			SELECT @v_dSql += '			ON     A.COMPANY_ID = D.COMPANY_ID                  																			' + char(10)
			SELECT @v_dSql += '			AND    A.DIVISION_ID = D.DIVISION_ID                																			' + char(10)
			SELECT @v_dSql += '			AND    A.SITE_ID = D.SITE_ID                        																			' + char(10)
			SELECT @v_dSql += '			AND    A.PLANT_ID = D.PLANT_ID                        																			' + char(10)
			SELECT @v_dSql += '			AND    A.FACTORY_ID = D.FACTORY_ID                        																			' + char(10)
			--SELECT @v_dSql += '			AND	   A.ITEM_ID = D.ITEM_ID																									' + char(10)
			SELECT @v_dSql += '			AND	   A.ROUTE_ID = D.ROUTE_ID																									' + char(10)
			--SELECT @v_dSql += '			AND    A.LINE_ID = D.LINE_ID                        																			' + char(10)
			
			SELECT @v_dSql += '			LEFT HASH JOIN (																												' + char(10)
			SELECT @v_dSql += '						SELECT	A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID, A.OPERATION_ID			' + char(10)
			SELECT @v_dSql += '								, MAX(A.OPERATION_NAME) AS OPERATION_NAME						' + char(10)
			SELECT @v_dSql += '						FROM	SCM_AGING_ITEM_FLOW_M A WITH(NOLOCK)       																	' + char(10)
			SELECT @v_dSql += '						WHERE	1=1																											' + char(10)
			
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
	        IF(LEN(@p_site_id) > 0)
            BEGIN
	               SELECT @v_dSql += ' AND  A.SITE_ID = '''+ @p_site_id +''' ' +  char(10)
            END
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
			
			IF(LEN(@p_route_id) > 0)
                BEGIN
                   SELECT @v_dSql += ' AND  A.ROUTE_ID  = '''+ @p_route_id +'''  ' + char(10)
                END            
			IF(LEN(@p_operation_id) > 0)
                BEGIN
                   SELECT @v_dSql += ' AND  A.OPERATION_ID  = '''+ @p_operation_id +'''  ' + char(10)
                END
            IF(LEN(@p_item_id) > 0)
                BEGIN
                  SELECT @v_dSql += ' AND  A.ITEM_ID LIKE  UPPER(''%'' + '''+ @p_item_id +''' + ''%'') ' + char(10)
               END	  

			SELECT @v_dSql += '						GROUP BY A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID, A.OPERATION_ID		' + char(10)
			SELECT @v_dSql += '			) E																																' + char(10)
			SELECT @v_dSql += '			ON     A.COMPANY_ID = E.COMPANY_ID                  																			' + char(10)
			SELECT @v_dSql += '			AND    A.DIVISION_ID = E.DIVISION_ID                																			' + char(10)
			SELECT @v_dSql += '			AND    A.SITE_ID = E.SITE_ID                        																			' + char(10)
			SELECT @v_dSql += '			AND    A.PLANT_ID = E.PLANT_ID                        																			' + char(10)
			SELECT @v_dSql += '			AND    A.OPERATION_ID = E.OPERATION_ID           																				' + char(10)
			/*
            SELECT @v_dSql += ' LEFT HASH JOIN SCM_OPERATION_M B WITH(NOLOCK)       ' + char(10)
            SELECT @v_dSql += ' ON     A.COMPANY_ID = B.COMPANY_ID                  ' + char(10)
            SELECT @v_dSql += ' AND    A.DIVISION_ID = B.DIVISION_ID                ' + char(10)
            SELECT @v_dSql += ' AND    A.SITE_ID = B.SITE_ID                        ' + char(10)
            SELECT @v_dSql += ' AND    A.OPERATION_ID = B.OPERATION_ID              ' + char(10)
			*/
            SELECT @v_dSql += ' LEFT OUTER JOIN ( ' + char(10)
            SELECT @v_dSql += ' 	SELECT B.OPERATION_ID, MAX(B.OPERATION_NAME) AS OPERATION_NAME ' + char(10)
            SELECT @v_dSql += ' 	FROM   SCM_MMD_OPERATION_M B WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += ' 	WHERE  1=1 ' + char(10)
            SELECT @v_dSql += ' 	AND    B.OPERATION_NAME IS NOT NULL ' + char(10)
            SELECT @v_dSql += ' 	GROUP BY B.OPERATION_ID ' + char(10)
            SELECT @v_dSql += ' ) B ' + char(10)
            SELECT @v_dSql += ' ON     A.OPERATION_ID = B.OPERATION_ID ' + char(10)
            SELECT @v_dSql += ' INNER HASH JOIN SCM_ITEM_M C WITH(NOLOCK)           ' + char(10)
            SELECT @v_dSql += ' ON     A.COMPANY_ID = C.COMPANY_ID                  ' + char(10)
            SELECT @v_dSql += ' AND    A.DIVISION_ID = C.DIVISION_ID                ' + char(10)
            SELECT @v_dSql += ' AND    A.SITE_ID = C.SITE_ID                        ' + char(10)
            SELECT @v_dSql += ' AND    A.ITEM_ID = C.ITEM_ID                        ' + char(10)
            SELECT @v_dsql += '	INNER JOIN ( ' + char(10)
            SELECT @v_dsql += '		SELECT C.COMPANY_ID, C.DIVISION_ID, C.SITE_ID, C.PLANT_ID, C.FACTORY_ID' + char(10)
            SELECT @v_dsql += '		FROM   TH_UIS_USER_INSTANCE_RELATE B WITH (NOLOCK)' + char(10)
            SELECT @v_dsql += '		INNER JOIN (' + char(10)
            SELECT @v_dsql += '				SELECT	C.ROLE_ID, C.INSTANCE_ID, C.COMPANY_ID, C.DIVISION_ID, C.SITE_ID, C.PLANT_ID, C.FACTORY_ID, A.OPERATION_ID, C.PLAN_GROUP_ID' + char(10)
            SELECT @v_dsql += '				FROM	FP_INSTANCE_OPERATION_V A WITH (NOLOCK)' + char(10)
            SELECT @v_dsql += '					  , TH_UIS_ROLE_INSTANCE_RELATE C WITH (NOLOCK)' + char(10)
            SELECT @v_dsql += '				WHERE	A.INSTANCE_ID = C.INSTANCE_ID' + char(10)
            SELECT @v_dsql += '				AND		A.COMPANY_ID  = C.COMPANY_ID' + char(10)
            SELECT @v_dsql += '				AND		A.DIVISION_ID = C.DIVISION_ID' + char(10)
            SELECT @v_dsql += '				AND		A.SITE_ID	  = C.SITE_ID' + char(10)
            SELECT @v_dsql += '				AND		C.USE_AT_FLAG = ''Y''' + char(10)
            SELECT @v_dsql += '				GROUP BY C.ROLE_ID, C.INSTANCE_ID, C.COMPANY_ID, C.DIVISION_ID, C.SITE_ID, C.PLANT_ID, C.FACTORY_ID, A.OPERATION_ID, C.PLAN_GROUP_ID' + char(10)
            SELECT @v_dsql += '		) C ' + char(10)
            SELECT @v_dsql += '		ON     B.ROLE_ID          = C.ROLE_ID' + char(10)
            SELECT @v_dsql += '		INNER JOIN SCM_SYS_LOOKUP_VALUE D WITH(NOLOCK)' + char(10)
            SELECT @v_dsql += '		ON     1=1' + char(10)
            SELECT @v_dsql += '		AND    D.LOOKUP_TYPE_CODE = ''INSTANCE_ID''' + char(10)
            SELECT @v_dsql += '		AND    D.ACTIVE_FLAG      = ''Y''' + char(10)
            SELECT @v_dsql += '		AND    C.INSTANCE_ID      = D.SEGMENT1' + char(10)
            SELECT @v_dsql += '		INNER JOIN SCM_LINE_M E WITH(NOLOCK)' + char(10)
            SELECT @v_dsql += '		ON     1=1' + char(10)
            SELECT @v_dsql += '		AND    E.ACTIVE_FLAG = ''Y''' + char(10)
            SELECT @v_dsql += '		AND    C.COMPANY_ID  = E.COMPANY_ID' + char(10)
            SELECT @v_dsql += '		AND    C.DIVISION_ID = E.DIVISION_ID' + char(10)
            SELECT @v_dsql += '		AND    C.SITE_ID	 = E.SITE_ID' + char(10)
            SELECT @v_dsql += '		AND    C.PLANT_ID	 = E.PLANT_ID' + char(10)
            SELECT @v_dsql += '		AND    C.FACTORY_ID  = E.FACTORY_ID' + char(10)
            SELECT @v_dsql += '		AND    C.OPERATION_ID  = E.OPERATION_ID' + char(10)
            SELECT @v_dsql += '		AND    (CASE WHEN D.ATTRIBUTE1 = ''PLAN GROUP'' THEN C.PLAN_GROUP_ID ELSE ''-'' END) ' + char(10)
            SELECT @v_dsql += '			 = (CASE WHEN D.ATTRIBUTE1 = ''PLAN GROUP'' THEN E.MODEL_TYPE    ELSE ''-'' END)' + char(10)
            SELECT @v_dsql += '		WHERE  B.USE_AT_FLAG = ''Y'' and B.USER_ID     = '''+ @p_user_id +''' ' + char(10)
            SELECT @v_dsql += '		GROUP BY C.COMPANY_ID, C.DIVISION_ID, C.SITE_ID, C.PLANT_ID, C.FACTORY_ID' + char(10)
            SELECT @v_dsql += '	) B1 on   A.COMPANY_ID  = B1.COMPANY_ID' + char(10)
            SELECT @v_dsql += ' AND    A.DIVISION_ID = B1.DIVISION_ID' + char(10)
            SELECT @v_dsql += ' AND    A.SITE_ID     = B1.SITE_ID' + char(10)
            SELECT @v_dsql += ' AND    A.PLANT_ID    = B1.PLANT_ID' + char(10)
            SELECT @v_dsql += ' AND    A.FACTORY_ID  = B1.FACTORY_ID' + char(10) 
            SELECT @v_dSql += ' WHERE  C.ACTIVE_FLAG = ''Y''                        ' + char(10)
            /*SELECT @v_dSql += ' AND    EXISTS (                                     ' + char(10)
            SELECT @v_dSql += '         SELECT 1                                    ' + char(10)
            SELECT @v_dSql += '         FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)   ' + char(10)
            SELECT @v_dSql += '         WHERE  A.COMPANY_ID  = B.COMPANY_ID         ' + char(10)
            SELECT @v_dSql += '         AND    A.DIVISION_ID = B.DIVISION_ID        ' + char(10)
            SELECT @v_dSql += '         AND    A.SITE_ID     = B.SITE_ID            ' + char(10)
            SELECT @v_dSql += '         AND    A.PLANT_ID    = B.PLANT_ID           ' + char(10)
            SELECT @v_dSql += '         AND    A.FACTORY_ID  = B.FACTORY_ID         ' + char(10)
            SELECT @v_dSql += '         AND    B.USER_ID     = '''+ @p_user_id +''' ' + char(10)
            SELECT @v_dSql += '         )                                           ' + char(10)*/

	        SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
	        IF(LEN(@p_site_id) > 0)
	            BEGIN
	               SELECT @v_dSql += ' AND  A.SITE_ID = '''+ @p_site_id +''' ' +  char(10)
	          END

            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
            
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
            
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
			
			IF(LEN(@p_route_id) > 0)
                BEGIN
                   SELECT @v_dSql += ' AND  A.ROUTE_ID  = '''+ @p_route_id +'''  ' + char(10)
                END            
			IF(LEN(@p_line_id) > 0)
                BEGIN
                   SELECT @v_dSql += ' AND  A.LINE_ID  = '''+ @p_line_id +'''    ' + char(10)
                END
			IF(LEN(@p_operation_id) > 0)
                BEGIN
                   SELECT @v_dSql += ' AND  A.OPERATION_ID  = '''+ @p_operation_id +'''  ' + char(10)
                END
            IF(LEN(@p_item_id) > 0)
                BEGIN
                  SELECT @v_dSql += ' AND  A.ITEM_ID LIKE  UPPER(''%'' + '''+ @p_item_id +''' + ''%'') ' + char(10)
               END	  

            SELECT @v_dSql += ' AND    CONVERT(VARCHAR(8), A.CUTOFF_DATE, 112) = '''+ @p_cur_off_date +''' ' + char(10)

            SELECT @v_dSql += '  ORDER BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                  ' + char(10)
            SELECT @v_dSql += '          ,A.ITEM_ID, A.PRODUCTION_TYPE, A.ROUTE_ID, A.OPERATION_ID            ' + char(10)
            SELECT @v_dSql += '          ,A.LINE_ID, A.TRAY_OP_STATUS, FORMAT(A.FCS_INPUT_DATE, ''yyyyMMdd'') ' + char(10)

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
					EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_dSql,'select',@runstart, @runend
				END
	    END	--IF( END )

END --MAIN END

