

/*
 * Program ID   : PR_UI_FP00518_SHIPPING_PLAN
 * Description  : Shipping Plan
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/03/30   JYJ				Initial Release UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FP00518_SHIPPING_PLAN]
  @p_sys_type                   NVARCHAR(MAX),
  @p_sys_flag                   NVARCHAR(MAX),
  @p_sys_gubun                  NVARCHAR(MAX),
  @p_user_id                    NVARCHAR(MAX),
  @p_instance_id                NVARCHAR(MAX),
  @p_instance_date              NVARCHAR(MAX),
  @p_version_id                 NVARCHAR(MAX),
  @p_company_id                 NVARCHAR(MAX),
  @p_division_id                NVARCHAR(MAX),
  @p_site_id                    NVARCHAR(MAX),
  @p_plant_id                   NVARCHAR(MAX),
  @p_item_id                    NVARCHAR(MAX),
  @p_item_name                  NVARCHAR(MAX),
  @p_production_type            NVARCHAR(MAX),
  @p_market                     NVARCHAR(MAX),
  @p_transport_mode             NVARCHAR(MAX),
  @p_to_site_id                 NVARCHAR(MAX),
  @p_to_plant_id                NVARCHAR(MAX),
  @p_ship_date                  NVARCHAR(MAX),
  @p_eta                        NVARCHAR(MAX),
  @p_ship_qty                   NVARCHAR(MAX),
  @p_pkg_type                   NVARCHAR(MAX),
  @p_description                NVARCHAR(MAX),
  @p_start_date                 NVARCHAR(MAX),
  @p_end_date                   NVARCHAR(MAX),
  @p_cell_type                  NVARCHAR(MAX),
  @p_wpp_type                   NVARCHAR(MAX),
  @p_wpp_week                   NVARCHAR(MAX),
  @p_wpp_seq                    NVARCHAR(MAX)

AS 
BEGIN  --MAIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
    SET NOCOUNT ON                                                                                                                                                                                                                                                   
	SET XACT_ABORT ON 

	DECLARE @v_sys_type                   NVARCHAR(MAX)  -- 값>> SELEC: SQL저장안함, SQL:SQL저장함
	DECLARE @v_sys_flag                   NVARCHAR(MAX)  -- 값>> I: Insert, M: Update, D: Delete, G: MERGE
	DECLARE @v_sys_gubun                  NVARCHAR(MAX) 
	DECLARE @v_user_id                    NVARCHAR(MAX)
    DECLARE @v_instance_id                NVARCHAR(MAX)
    DECLARE @v_instance_date              NVARCHAR(MAX)
    DECLARE @v_version_id                 NVARCHAR(MAX)
    DECLARE @v_company_id                 NVARCHAR(MAX)
    DECLARE @v_division_id                NVARCHAR(MAX)
    DECLARE @v_site_id                    NVARCHAR(MAX)
    DECLARE @v_plant_id                   NVARCHAR(MAX)
    DECLARE @v_item_id                    NVARCHAR(MAX)
    DECLARE @v_item_name                  NVARCHAR(MAX)
    DECLARE @v_production_type            NVARCHAR(MAX)
    DECLARE @v_market                     NVARCHAR(MAX)
    DECLARE @v_transport_mode             NVARCHAR(MAX)
    DECLARE @v_to_site_id                 NVARCHAR(MAX)
    DECLARE @v_to_plant_id                NVARCHAR(MAX)
    DECLARE @v_ship_date                  NVARCHAR(MAX)
    DECLARE @v_eta                        NVARCHAR(MAX)
    DECLARE @v_ship_qty                   NVARCHAR(MAX)
    DECLARE @v_pkg_type                   NVARCHAR(MAX)
    DECLARE @v_description                NVARCHAR(MAX)
    DECLARE @v_start_date                 NVARCHAR(MAX)
    DECLARE @v_end_date                   NVARCHAR(MAX)
    DECLARE @v_cell_type                  NVARCHAR(MAX)
    DECLARE @v_wpp_type                   NVARCHAR(MAX)
    DECLARE @v_wpp_week                   NVARCHAR(MAX)
    DECLARE @v_wpp_seq                    NVARCHAR(MAX)

	DECLARE @recv_active_flag       NVARCHAR(MAX)				    
	DECLARE @v_proc_name	        NVARCHAR(100) = 'PR_UI_FP00518_SHIPPING_PLAN'
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
    SET @v_instance_id              = ''
    SET @v_instance_date            = ''
    SET @v_version_id               = ''
    SET @v_company_id               = ''
    SET @v_division_id              = ''
    SET @v_site_id                  = ''
    SET @v_plant_id                 = ''
    SET @v_item_id                  = ''
    SET @v_item_name                = ''
    SET @v_production_type          = ''
    SET @v_market                   = ''
    SET @v_transport_mode           = ''
    SET @v_to_site_id               = ''
    SET @v_to_plant_id              = ''
    SET @v_ship_date                = ''
    SET @v_eta                      = ''
    SET @v_ship_qty                 = ''
    SET @v_pkg_type                 = ''
    SET @v_description              = ''
    SET @v_start_date               = ''
    SET @v_end_date                 = ''
    SET @v_cell_type                = ''
    SET @v_wpp_type                 = ''
    SET @v_wpp_week                 = ''
    SET @v_wpp_seq                  = ''

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
		    SELECT @v_dSql = ''
            SELECT @v_dSql += ' SELECT DISTINCT A.INSTANCE_ID, CONVERT(VARCHAR,A.INSTANCE_DATE,120) AS INSTANCE_DATE,  A.VERSION_ID,  A.COMPANY_ID  ' + char(10)
            SELECT @v_dSql += '    , A.DIVISION_ID,     A.SITE_ID,        A.PLANT_ID,    A.ITEM_ID        ' + char(10)
            SELECT @v_dSql += '    , ISNULL(B.NICK_NAME, ''-'') AS NICK_NAME, A.PRODUCTION_TYPE           ' + char(10)
            SELECT @v_dSql += '    , A.MARKET,          A.TO_SITE_ID,     A.TO_PLANT_ID, A.TRANSPORT_MODE ' + char(10)
            SELECT @v_dSql += '    , CONVERT(VARCHAR,A.SHIP_DATE,120) AS SHIP_DATE                        ' + char(10)
            SELECT @v_dSql += '    , CONVERT(VARCHAR,A.ETA,120) AS ETA,  A.SHIP_QTY                       ' + char(10)
            SELECT @v_dSql += '    , C.PKG_TYPE AS PKG_TYPE,  A.DESCRIPTION                               ' + char(10)
            SELECT @v_dSql += '    , A.UPDATE_ID, CONVERT(VARCHAR, A.UPDATE_TIME, 20) AS UPDATE_TIME      ' + char(10)
			SELECT @v_dSql += '    , '''+ @p_wpp_type +''' AS WPP_TYPE                                    ' + char(10)
            SELECT @v_dSql += '    , (CASE WHEN R.PLANT_ID IS NULL THEN ''N'' ELSE ''Y'' END) AS EDIT_YN  ' + char(10)
			IF(@p_wpp_type ='Y')
			    BEGIN 
                    SELECT @v_dSql += ' FROM  FP_SHIPMENT_PLAN_WPP_H   A WITH(NOLOCK) ' + char(10)
				END
            ELSE
				BEGIN 
                    SELECT @v_dSql += ' FROM  FP_SHIPMENT_PLAN_H  A WITH(NOLOCK)   ' + char(10)
				END
            SELECT @v_dSql += ' INNER JOIN SCM_ITEM_M B WITH(NOLOCK)  ' + char(10)
            SELECT @v_dSql += ' ON     A.COMPANY_ID  = B.COMPANY_ID   ' + char(10)
            SELECT @v_dSql += ' AND    A.DIVISION_ID = B.DIVISION_ID  ' + char(10)
            SELECT @v_dSql += ' AND    A.SITE_ID     = B.SITE_ID      ' + char(10)
            SELECT @v_dSql += ' AND    A.ITEM_ID     = B.ITEM_ID      ' + char(10)
            SELECT @v_dSql += ' AND    B.ACTIVE_FLAG = ''Y''          ' + char(10)
            SELECT @v_dSql += ' LEFT OUTER JOIN ( ' + char(10)
            SELECT @v_dSql += '                  SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID  ' + char(10)
            SELECT @v_dSql += '                      , (CASE WHEN LEVEL_4_NAME = ''-'' THEN LEVEL_2_NAME ELSE LEVEL_4_NAME END) PKG_TYPE  ' + char(10)
            SELECT @v_dSql += '                  FROM   SCM_ITEM_M A WITH(NOLOCK), SCM_ITEM_CLASS_M B WITH(NOLOCK)  ' + char(10)
            SELECT @v_dSql += '                  WHERE  A.ITEM_CLASS  = B.CLASS_ID  ' + char(10)
            SELECT @v_dSql += '                  AND    A.ACTIVE_FLAG = ''Y''       ' + char(10)
            SELECT @v_dSql += '                  AND    B.USE_FLAG    = ''Y''       ' + char(10)
            SELECT @v_dSql += ' ) C      ' + char(10)
            SELECT @v_dSql += ' ON  1=1  ' + char(10)
            SELECT @v_dSql += ' AND A.SITE_ID       = C.SITE_ID  ' + char(10)
            SELECT @v_dSql += ' AND B.APPLIED_MODEL = C.ITEM_ID  ' + char(10)
            SELECT @v_dSql += ' LEFT OUTER JOIN (                ' + char(10)
            SELECT @v_dSql += '      SELECT DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.INSTANCE_ID  ' + char(10)
            SELECT @v_dSql += '      FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK)  ' + char(10)
            SELECT @v_dSql += '      WHERE  R.USER_ID   = '''+ @p_user_id +'''  ' + char(10)
            SELECT @v_dSql += '      AND    R.SAVE_FLAG = ''Y''                 ' + char(10)
            SELECT @v_dSql += ' ) R                                  ' + char(10)
            SELECT @v_dSql += ' ON   A.COMPANY_ID   = R.COMPANY_ID   ' + char(10)
            SELECT @v_dSql += ' AND  A.DIVISION_ID  = R.DIVISION_ID  ' + char(10)
            SELECT @v_dSql += ' AND  A.SITE_ID      = R.SITE_ID      ' + char(10)
            SELECT @v_dSql += ' AND  A.PLANT_ID     = R.PLANT_ID     ' + char(10)
            SELECT @v_dSql += ' AND  A.INSTANCE_ID  = R.INSTANCE_ID  ' + char(10)
            SELECT @v_dSql += ' 		WHERE EXISTS (               ' + char(10)
            SELECT @v_dSql += '     SELECT 1                         ' + char(10)
            SELECT @v_dSql += '     FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)   ' + char(10)
            SELECT @v_dSql += '     WHERE  A.COMPANY_ID = B.COMPANY_ID          ' + char(10)
            SELECT @v_dSql += '     AND  A.DIVISION_ID  = B.DIVISION_ID         ' + char(10)
            SELECT @v_dSql += '     AND  A.SITE_ID      = B.SITE_ID             ' + char(10)
            SELECT @v_dSql += '     AND  A.PLANT_ID     = B.PLANT_ID            ' + char(10)
            SELECT @v_dSql += '     AND  A.INSTANCE_ID  = B.INSTANCE_ID         ' + char(10)
            SELECT @v_dSql += '     AND  B.USER_ID      = '''+ @p_user_id +'''  ' + char(10)
            SELECT @v_dSql += ' )                                               ' + char(10)
            SELECT @v_dSql += ' AND	  A.INSTANCE_ID = '''+ @p_instance_id +'''  ' + char(10)

			IF(@p_wpp_type ='Y')
			    BEGIN 
                    SELECT @v_dSql += ' AND	  A.WPP_WEEK = '''+ @p_wpp_week +'''    ' + char(10)
                    SELECT @v_dSql += ' AND	  A.WPP_SEQ  = '''+ @p_wpp_seq +'''     ' + char(10)
				END
            ELSE
			    BEGIN
                    SELECT @v_dSql += ' AND  (CONVERT(VARCHAR,A.INSTANCE_DATE,112) + '' :: '' + CONVERT(VARCHAR,A.VERSION_ID)) IN (  ' + char(10)
                    SELECT @v_dSql += '         SELECT 	MAX(CONVERT(VARCHAR,A.INSTANCE_DATE,112)) + '' :: '' + MAX(CONVERT(VARCHAR,VERSION_ID)) AS CODE  ' + char(10)
                    SELECT @v_dSql += '         FROM   FP_SHIPMENT_PLAN_H A WITH(NOLOCK)            ' + char(10)
                    SELECT @v_dSql += '         WHERE 1=1                                           ' + char(10)
                    SELECT @v_dSql += '         AND   A.INSTANCE_ID = '''+ @p_instance_id +'''      ' + char(10)
                    SELECT @v_dSql += '         AND   A.INSTANCE_DATE = (                           ' + char(10)
                    SELECT @v_dSql += '                                  SELECT MAX(INSTANCE_DATE)  ' + char(10)
                    SELECT @v_dSql += '                                  FROM   FP_SHIPMENT_PLAN_H A WITH(NOLOCK)     ' + char(10)
                    SELECT @v_dSql += '                                  WHERE INSTANCE_ID = '''+ @p_instance_id +''' ' + char(10)
                    SELECT @v_dSql += '             				    )   ' + char(10)
                    SELECT @v_dSql += '       )  ' + char(10)
				END
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))         + char(10)
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))       + char(10)
            SELECT @v_dSql += ' AND	  CONVERT(VARCHAR,A.SHIP_DATE,112) BETWEEN '''+ @p_start_date +'''  AND '''+ @p_end_date +'''  ' + char(10)
            SELECT @v_dSql += ' AND    A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +'''  + ''%''                    ' + char(10)
            SELECT @v_dSql += ' AND    B.NICK_NAME LIKE ''%'' + RTRIM(LTRIM('''+ @p_item_name +''' )) + ''%''  ' + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.PKG_TYPE' , 'EQ', @p_cell_type))      + char(10)
            SELECT @v_dSql += ' ORDER BY DIVISION_ID, SITE_ID, PLANT_ID, SHIP_DATE, ITEM_ID                ' + char(10)


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
	IF(@p_sys_flag ='SELECT_ITEM_POPUP')
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
            SELECT @v_dSql += ' AND    UPPER(A.ITEM_ID) LIKE ''%'' + '''+ @p_item_id +''' + ''%''          ' + char(10)
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
	/************************************************************************************************/
	/* SELECT인경우 :SELECT(SELECT)                                                                      */
	/************************************************************************************************/
	IF(@p_sys_flag ='SELECT_TRANSPORTMODE_POPUP')
		BEGIN --IF(START)
            SELECT @v_dSql = ''
            SELECT @v_dSql += ' SELECT 	DISTINCT FROM_PLANT_ID, TO_PLANT_ID, ''[''+TO_PLANT_ID+''] ''+TO_PLANT_NAME AS TO_PLANT_NAME ' + char(10)
			SELECT @v_dSql += ' , TRANSPORT_MODE, PRIORITY, LT_TOTAL , TO_SITE_ID ' + char(10)
            SELECT @v_dSql += ' , CONVERT(VARCHAR, PRIORITY) + '' :: '' + TRANSPORT_MODE + '' :: '' + TO_SITE_ID + '' :: '' + TO_PLANT_ID+ '' ''+TO_PLANT_NAME  AS NAME ' + char(10)
            SELECT @v_dSql += ' FROM 	IF_FP_SCM_BOD_V A WITH(NOLOCK)              ' + char(10)
            SELECT @v_dSql += ' WHERE	1=1                                         ' + char(10)
            SELECT @v_dSql += ' AND		FROM_PLANT_ID = '''+ @p_plant_id +'''       ' + char(10)
            SELECT @v_dSql += ' AND    EXISTS (                                     ' + char(10)
            SELECT @v_dSql += '       SELECT 1                                      ' + char(10)
            SELECT @v_dSql += '       FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)     ' + char(10)
            SELECT @v_dSql += '       WHERE  A.FROM_PLANT_ID = B.PLANT_ID           ' + char(10)
            SELECT @v_dSql += '       AND    B.SAVE_FLAG     = ''Y''                ' + char(10)
            SELECT @v_dSql += '       AND    B.USER_ID       = '''+ @p_user_id +''' ' + char(10)
            SELECT @v_dSql += ' )                                                   ' + char(10)
		    SELECT @v_dSql += ' ORDER BY FROM_PLANT_ID, TO_PLANT_ID, PRIORITY       ' + char(10)

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

						SELECT @v_sys_type   = [dbo].[SCM_ARR_SPL_VAL](@p_sys_type ,       @v_delimiter, @mst_loop_cnt)
						, @v_sys_flag        = [dbo].[SCM_ARR_SPL_VAL](@p_sys_flag ,       @v_delimiter, @mst_loop_cnt)
						, @v_sys_gubun       = [dbo].[SCM_ARR_SPL_VAL](@p_sys_gubun ,      @v_delimiter, @mst_loop_cnt)
						, @v_user_id         = [dbo].[SCM_ARR_SPL_VAL](@p_user_id ,        @v_delimiter, @mst_loop_cnt)
						, @v_instance_id     = [dbo].[SCM_ARR_SPL_VAL](@p_instance_id ,    @v_delimiter, @mst_loop_cnt)
						, @v_instance_date   = [dbo].[SCM_ARR_SPL_VAL](@p_instance_date ,  @v_delimiter, @mst_loop_cnt)
						, @v_version_id      = [dbo].[SCM_ARR_SPL_VAL](@p_version_id ,     @v_delimiter, @mst_loop_cnt)
						, @v_company_id      = [dbo].[SCM_ARR_SPL_VAL](@p_company_id ,     @v_delimiter, @mst_loop_cnt)
						, @v_division_id     = [dbo].[SCM_ARR_SPL_VAL](@p_division_id ,    @v_delimiter, @mst_loop_cnt)
						, @v_site_id         = [dbo].[SCM_ARR_SPL_VAL](@p_site_id ,        @v_delimiter, @mst_loop_cnt)
						, @v_plant_id        = [dbo].[SCM_ARR_SPL_VAL](@p_plant_id ,       @v_delimiter, @mst_loop_cnt)
						, @v_item_id         = [dbo].[SCM_ARR_SPL_VAL](@p_item_id ,        @v_delimiter, @mst_loop_cnt)
						, @v_item_name       = [dbo].[SCM_ARR_SPL_VAL](@p_item_name ,      @v_delimiter, @mst_loop_cnt)
						, @v_production_type = [dbo].[SCM_ARR_SPL_VAL](@p_production_type ,@v_delimiter, @mst_loop_cnt)
						, @v_market          = [dbo].[SCM_ARR_SPL_VAL](@p_market ,         @v_delimiter, @mst_loop_cnt)
						, @v_transport_mode  = [dbo].[SCM_ARR_SPL_VAL](@p_transport_mode , @v_delimiter, @mst_loop_cnt)
						, @v_to_site_id      = [dbo].[SCM_ARR_SPL_VAL](@p_to_site_id ,     @v_delimiter, @mst_loop_cnt)
						, @v_to_plant_id     = [dbo].[SCM_ARR_SPL_VAL](@p_to_plant_id ,    @v_delimiter, @mst_loop_cnt)
						, @v_ship_date       = [dbo].[SCM_ARR_SPL_VAL](@p_ship_date ,      @v_delimiter, @mst_loop_cnt)
						, @v_eta             = [dbo].[SCM_ARR_SPL_VAL](@p_eta ,            @v_delimiter, @mst_loop_cnt)
						, @v_ship_qty        = [dbo].[SCM_ARR_SPL_VAL](@p_ship_qty ,       @v_delimiter, @mst_loop_cnt)
						, @v_pkg_type        = [dbo].[SCM_ARR_SPL_VAL](@p_pkg_type ,       @v_delimiter, @mst_loop_cnt)
						, @v_description     = [dbo].[SCM_ARR_SPL_VAL](@p_description ,    @v_delimiter, @mst_loop_cnt)
						, @v_start_date      = [dbo].[SCM_ARR_SPL_VAL](@p_start_date ,     @v_delimiter, @mst_loop_cnt)
						, @v_end_date        = [dbo].[SCM_ARR_SPL_VAL](@p_end_date ,       @v_delimiter, @mst_loop_cnt)
						, @v_cell_type       = [dbo].[SCM_ARR_SPL_VAL](@p_cell_type ,      @v_delimiter, @mst_loop_cnt)
						, @v_wpp_type        = [dbo].[SCM_ARR_SPL_VAL](@p_wpp_type ,       @v_delimiter, @mst_loop_cnt)
						, @v_wpp_week        = [dbo].[SCM_ARR_SPL_VAL](@p_wpp_week ,       @v_delimiter, @mst_loop_cnt)
						, @v_wpp_seq         = [dbo].[SCM_ARR_SPL_VAL](@p_wpp_seq ,        @v_delimiter, @mst_loop_cnt)
					   
					   /******************************************************************************/
					   /* INSERT/UPDATE/DELETE 경우 : 본화면                                         */
					   /******************************************************************************/
					   IF(@v_sys_flag ='INSERT' Or @v_sys_flag ='UPDATE' OR @v_sys_flag ='DELETE')  
							BEGIN
                                SELECT @v_dSql = ''
                                SELECT @v_dSql += ' MERGE INTO FP_SHIPMENT_PLAN_H AS A ' + char(10)
                                SELECT @v_dSql += ' USING  ' + char(10)
                                SELECT @v_dSql += '  (  SELECT 	'''+ @v_instance_id +''' AS INSTANCE_ID, CONVERT(DATETIME, '''+ @v_instance_date +''') AS INSTANCE_DATE, '''+ @v_version_id +''' AS VERSION_ID ' + char(10)
                                SELECT @v_dSql += '      , '''+ @v_company_id +''' AS COMPANY_ID, '''+ @v_division_id +''' AS DIVISION_ID, '''+ @v_site_id +''' AS SITE_ID ' + char(10)
                                SELECT @v_dSql += '      , '''+ @v_plant_id +''' AS PLANT_ID, '''+ @v_item_id +''' AS ITEM_ID, ''-'' AS PRODUCTION_TYPE, ''-'' AS MARKET   ' + char(10)
                                SELECT @v_dSql += '      , CONVERT(DATETIME,'''+ @v_ship_date +''') AS SHIP_DATE, '''+ @v_ship_qty +''' AS SHIP_QTY, '''+ @v_to_site_id +''' AS TO_SITE_ID ' + char(10)
                                SELECT @v_dSql += '      , '''+ @v_to_plant_id +''' AS TO_PLANT_ID, '''+ @v_transport_mode +''' AS TRANSPORT_MODE ' + char(10)
                                SELECT @v_dSql += '      , dbo.FN_GET_SCM_ETA('''+ @v_plant_id +''', '''+ @v_to_plant_id +''', CONVERT(CHAR(8), CONVERT(DATE,'''+ @v_ship_date +'''), 112), '''+ @v_transport_mode +''') AS ETA ' + char(10)
                                SELECT @v_dSql += '      , N'''+ @v_description +''' AS DESCRIPTION, '''+ @v_sys_flag +''' AS CRUD_TYPE            ' + char(10)
                                SELECT @v_dSql += ' ) AS B                                ' + char(10)
                                SELECT @v_dSql += ' ON  A.INSTANCE_ID   = B.INSTANCE_ID   ' + char(10)
                                SELECT @v_dSql += ' AND A.INSTANCE_DATE = B.INSTANCE_DATE ' + char(10)
                                SELECT @v_dSql += ' AND A.VERSION_ID    = B.VERSION_ID    ' + char(10)
                                SELECT @v_dSql += ' AND A.COMPANY_ID    = B.COMPANY_ID    ' + char(10)
                                SELECT @v_dSql += ' AND A.DIVISION_ID   = B.DIVISION_ID   ' + char(10)
                                SELECT @v_dSql += ' AND A.SITE_ID      	= B.SITE_ID       ' + char(10)
                                SELECT @v_dSql += ' AND A.PLANT_ID      = B.PLANT_ID      ' + char(10)
                                SELECT @v_dSql += ' AND A.ITEM_ID    	= B.ITEM_ID       ' + char(10)
                                SELECT @v_dSql += ' AND A.SHIP_DATE   	= B.SHIP_DATE     ' + char(10)
                                SELECT @v_dSql += ' WHEN MATCHED AND CRUD_TYPE = ''UPDATE'' THEN           ' + char(10)
                                SELECT @v_dSql += '     UPDATE SET 	SHIP_QTY = B.SHIP_QTY                  ' + char(10)
                                SELECT @v_dSql += '       ,	TO_SITE_ID       = B.TO_SITE_ID                ' + char(10)
                                SELECT @v_dSql += '       ,	TO_PLANT_ID      = B.TO_PLANT_ID               ' + char(10)
                                SELECT @v_dSql += '       ,	TRANSPORT_MODE   = B.TRANSPORT_MODE            ' + char(10)
                                SELECT @v_dSql += '       ,	ETA              = B.ETA                       ' + char(10)
                                SELECT @v_dSql += '       ,	DESCRIPTION      = B.DESCRIPTION               ' + char(10)
                                SELECT @v_dSql += '       , UPDATE_ID        = '''+ @v_user_id +'''        ' + char(10)
								SELECT @v_dSql += '       , UPDATE_TIME      = dbo.FN_SITE_TIME(B.SITE_ID) ' + char(10)
                                SELECT @v_dSql += ' WHEN NOT MATCHED BY TARGET THEN ' + char(10)
                                SELECT @v_dSql += '     INSERT (                    ' + char(10)
                                SELECT @v_dSql += '         INSTANCE_ID,  INSTANCE_DATE, VERSION_ID      ' + char(10)
                                SELECT @v_dSql += '       , COMPANY_ID,   DIVISION_ID,   SITE_ID         ' + char(10)
                                SELECT @v_dSql += '       , PLANT_ID,     ITEM_ID,       PRODUCTION_TYPE ' + char(10)
                                SELECT @v_dSql += '       , MARKET,       SHIP_DATE,     SHIP_QTY        ' + char(10)
                                SELECT @v_dSql += '       , TO_SITE_ID,   TO_PLANT_ID,   TRANSPORT_MODE  ' + char(10)
                                SELECT @v_dSql += '       , ETA,          DESCRIPTION,   INSERT_ID       ' + char(10)
                                SELECT @v_dSql += '       , INSERT_TIME,  UPDATE_ID,     UPDATE_TIME     ' + char(10)
                                SELECT @v_dSql += ' 	)        ' + char(10)
                                SELECT @v_dSql += ' 	VALUES ( ' + char(10)
                                SELECT @v_dSql += '         B.INSTANCE_ID, B.INSTANCE_DATE, B.VERSION_ID         ' + char(10)
                                SELECT @v_dSql += '       , B.COMPANY_ID , B.DIVISION_ID ,  B.SITE_ID            ' + char(10)
                                SELECT @v_dSql += '       , B.PLANT_ID ,   B.ITEM_ID ,      ''-''                ' + char(10)
                                SELECT @v_dSql += '       , ''-'',         B.SHIP_DATE,     B.SHIP_QTY           ' + char(10)
                                SELECT @v_dSql += '       , B.TO_SITE_ID,  B.TO_PLANT_ID,   B.TRANSPORT_MODE     ' + char(10)
                                SELECT @v_dSql += '       , B.ETA,         B.DESCRIPTION,   '''+ @v_user_id +''' ' + char(10)
                                SELECT @v_dSql += '       , dbo.FN_SITE_TIME('''+ @v_site_id +'''),'''+ @v_user_id +''', dbo.FN_SITE_TIME('''+ @v_site_id +''') ' + char(10)
                                SELECT @v_dSql += ' 	)       ' + char(10)
                                SELECT @v_dSql += '     WHEN MATCHED AND CRUD_TYPE=''DELETE'' THEN DELETE ' + char(10)
                                SELECT @v_dSql += '    ;        ' + char(10)
                                SELECT @v_dSql += '    INSERT INTO HIS_SHIPMENT_PLAN_H (                  ' + char(10)
                                SELECT @v_dSql += '         INSTANCE_ID,  INSTANCE_DATE,  VERSION_ID      ' + char(10)
                                SELECT @v_dSql += '       , COMPANY_ID,   DIVISION_ID,    SITE_ID         ' + char(10)
                                SELECT @v_dSql += '       , PLANT_ID,     ITEM_ID,        PRODUCTION_TYPE ' + char(10)
                                SELECT @v_dSql += '       , MARKET,       SHIP_DATE,      SHIP_QTY        ' + char(10)
                                SELECT @v_dSql += '       , TO_SITE_ID,   TO_PLANT_ID,    TRANSPORT_MODE  ' + char(10)
                                SELECT @v_dSql += '       , ETA,          DESCRIPTION,    INSERT_ID       ' + char(10)
                                SELECT @v_dSql += '       , INSERT_TIME,  UPDATE_ID,      UPDATE_TIME     ' + char(10)
                                SELECT @v_dSql += '       , JOB_USER_ID,  JOB_TIME,       JOB_TYPE        ' + char(10)
                                SELECT @v_dSql += '     )       ' + char(10)
                                SELECT @v_dSql += '  SELECT  '''+ @v_instance_id +''', '''+ @v_instance_date +''',  '''+ @v_version_id +'''      ' + char(10)
                                SELECT @v_dSql += '       , '''+ @v_company_id +''',   '''+ @v_division_id +''',    '''+ @v_site_id +'''         ' + char(10)
                                SELECT @v_dSql += '       , '''+ @v_plant_id +''',     '''+ @v_item_id +''',        ''-''                        ' + char(10)
                                SELECT @v_dSql += '       , ''-'',                     '''+ @v_ship_date +''',      '''+ @v_ship_qty +'''        ' + char(10)
                                SELECT @v_dSql += '       , '''+ @v_to_site_id +''',   '''+ @v_to_plant_id +''',    '''+ @v_transport_mode +'''  ' + char(10)
                                SELECT @v_dSql += '       , dbo.FN_GET_SCM_ETA('''+ @v_plant_id +''', '''+ @v_to_plant_id +''', CONVERT(CHAR(8), CONVERT(DATE,'''+ @v_ship_date +'''), 112), '''+ @v_transport_mode +''') ' + char(10)
                                SELECT @v_dSql += '       , N'''+ @v_description +''', '''+ @v_user_id +''', dbo.FN_SITE_TIME('''+ @v_site_id +''') ' + char(10)
                                SELECT @v_dSql += '       , '''+ @v_user_id +''', dbo.FN_SITE_TIME('''+ @v_site_id +'''), '''+ @v_user_id +'''      ' + char(10)
                                SELECT @v_dSql += '       , dbo.FN_SITE_TIME('''+ @v_site_id +''') AS JOB_TIME, '''+ @v_sys_flag +''' AS JOB_TYPE   ' + char(10)

						   END --'I'
					   /******************************************************************************/
					   /* INSERT 팝업경우 : INSERT(merge_createWPP)                                      */
					   /******************************************************************************/
					   ELSE IF(@v_sys_flag ='INSERT_CREATE_WPP')  
							BEGIN
                                SELECT @v_dSql = ''
                                SELECT @v_dSql += ' INSERT INTO FP_SHIPMENT_PLAN_WPP_H  ' +char(10)
                                SELECT @v_dSql += ' SELECT A.INSTANCE_ID     ' +char(10)
                                SELECT @v_dSql += '      , A.INSTANCE_DATE   ' +char(10)
                                SELECT @v_dSql += '      , A.VERSION_ID      ' +char(10)
                                SELECT @v_dSql += '      , A.COMPANY_ID      ' +char(10)
                                SELECT @v_dSql += '      , A.DIVISION_ID     ' +char(10)
                                SELECT @v_dSql += '      , A.SITE_ID         ' +char(10)
                                SELECT @v_dSql += '      , A.PLANT_ID        ' +char(10)
                                SELECT @v_dSql += '      , A.ITEM_ID         ' +char(10)
                                SELECT @v_dSql += '      , A.PRODUCTION_TYPE ' +char(10)
                                SELECT @v_dSql += '      , A.MARKET          ' +char(10)
                                SELECT @v_dSql += '      , A.SHIP_DATE       ' +char(10)
                                SELECT @v_dSql += '      , A.SHIP_QTY        ' +char(10)
                                SELECT @v_dSql += '      , A.TO_SITE_ID      ' +char(10)
                                SELECT @v_dSql += '      , A.TO_PLANT_ID     ' +char(10)
                                SELECT @v_dSql += '      , A.TRANSPORT_MODE  ' +char(10)
                                SELECT @v_dSql += '      , A.ETA             ' +char(10)
                                SELECT @v_dSql += '      , A.DESCRIPTION     ' +char(10)
                                SELECT @v_dSql += '      , A.ATTB_1          ' +char(10)
                                SELECT @v_dSql += '      , A.ATTB_2          ' +char(10)
                                SELECT @v_dSql += '      , A.ATTB_3          ' +char(10)
                                SELECT @v_dSql += '      , A.ATTB_4          ' +char(10)
                                SELECT @v_dSql += '      , A.ATTB_5          ' +char(10)
                                SELECT @v_dSql += '      , A.ATTB_6          ' +char(10)
                                SELECT @v_dSql += '      , A.ATTB_7          ' +char(10)
                                SELECT @v_dSql += '      , A.ATTB_8          ' +char(10)
                                SELECT @v_dSql += '      , A.ATTB_9          ' +char(10)
                                SELECT @v_dSql += '      , A.ATTB_10         ' +char(10)
                                SELECT @v_dSql += '      , '''+ @v_user_id +''' AS INSERT_ID         ' +char(10)
                                SELECT @v_dSql += '      , GETDATE() AS INSERT_TIME                  ' +char(10)
                                SELECT @v_dSql += '      , '''+ @v_user_id +''' AS UPDATE_ID         ' +char(10)
                                SELECT @v_dSql += '      , GETDATE() AS UPDATE_TIME                  ' +char(10)
                                SELECT @v_dSql += ' 	   ,'''+ @v_wpp_week +''' AS WPP_WEEK        ' +char(10)
                                SELECT @v_dSql += ' 	   , '''+ @v_wpp_seq +''' AS WPP_SEQ         ' +char(10)
                                SELECT @v_dSql += ' FROM   FP_SHIPMENT_PLAN_H A WITH(NOLOCK)         ' +char(10)
                                SELECT @v_dSql += ' WHERE  A.INSTANCE_ID = '''+ @v_instance_id +'''  ' +char(10)
                                SELECT @v_dSql += '  AND   (CONVERT(VARCHAR,A.INSTANCE_DATE,112) + '' :: '' + CONVERT(VARCHAR,A.VERSION_ID)) IN (  ' +char(10)
                                SELECT @v_dSql += '            SELECT MAX(CONVERT(VARCHAR,A.INSTANCE_DATE,112)) + '' :: '' + MAX(CONVERT(VARCHAR,VERSION_ID)) AS CODE  ' +char(10)
                                SELECT @v_dSql += '            FROM   FP_SHIPMENT_PLAN_H A WITH(NOLOCK)         ' +char(10)
                                SELECT @v_dSql += '            WHERE  1=1                                       ' +char(10)
                                SELECT @v_dSql += '            AND    A.INSTANCE_ID = '''+ @v_instance_id +'''  ' +char(10)
                                SELECT @v_dSql += '            AND    A.INSTANCE_DATE = (                       ' +char(10)
                                SELECT @v_dSql += '                                       SELECT MAX(INSTANCE_DATE)                     ' +char(10)
                                SELECT @v_dSql += '                                       FROM   FP_SHIPMENT_PLAN_H A WITH(NOLOCK)      ' +char(10)
                                SELECT @v_dSql += '                                       WHERE INSTANCE_ID = '''+ @v_instance_id +'''  ' +char(10)
                                SELECT @v_dSql += '                                     )                                               ' +char(10)
                                SELECT @v_dSql += ' )  ' +char(10)

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

