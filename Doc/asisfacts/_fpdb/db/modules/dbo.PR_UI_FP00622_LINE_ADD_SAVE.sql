

/*
 * Program ID   : PR_UI_FP00622_LINE_ADD_SAVE
 * Description  : Plan Amend Line NJ Pouch
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/05/11   JYJ				Initial Release UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FP00622_LINE_ADD_SAVE]
  @p_sys_type            NVARCHAR(MAX),
  @p_sys_flag            NVARCHAR(MAX),
  @p_sys_gubun           NVARCHAR(MAX),
  @p_user_id             NVARCHAR(MAX),
  @p_instance_id         NVARCHAR(MAX),
  @p_plan_date           NVARCHAR(MAX),
  @p_plan_id             NVARCHAR(MAX), 
  @p_division_id         NVARCHAR(MAX),
  @p_site_id             NVARCHAR(MAX),
  @p_plant_id            NVARCHAR(MAX),
  @p_factory_id          NVARCHAR(MAX),
  @p_line_id             NVARCHAR(MAX),
  @p_operation_id        NVARCHAR(MAX),
  @p_item_id             NVARCHAR(MAX),
  @p_top_item_id         NVARCHAR(MAX),
  @p_item_type           NVARCHAR(MAX),
  @p_nick_name           NVARCHAR(MAX),
  @p_location            NVARCHAR(MAX),
  @p_prod_type           NVARCHAR(MAX),
  @p_market              NVARCHAR(MAX),
  @p_electrode_type      NVARCHAR(MAX),
  @p_confirm_area        NVARCHAR(MAX),
  @p_release_value       NVARCHAR(MAX),
  @p_in_qty              NVARCHAR(MAX),
  @p_out_qty             NVARCHAR(MAX),
  @p_cell_in_qty         NVARCHAR(MAX),
  @p_cell_out_qty        NVARCHAR(MAX),
  @p_qty                 NVARCHAR(MAX)

AS 
BEGIN  --MAIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
    SET NOCOUNT ON                                                                                                                                                                                                                                                   
	SET XACT_ABORT ON 

	DECLARE @v_sys_type             NVARCHAR(MAX)  -- 값>> SELEC: SQL저장안함, SQL:SQL저장함
	DECLARE @v_sys_flag             NVARCHAR(MAX)  -- 값>> I: Insert, M: Update, D: Delete, G: MERGE
	DECLARE @v_sys_gubun            NVARCHAR(MAX) 
	DECLARE @v_user_id              NVARCHAR(MAX)
    DECLARE @v_instance_id          NVARCHAR(MAX)
    DECLARE @v_plan_date            NVARCHAR(MAX)
    DECLARE @v_plan_id              NVARCHAR(MAX)
    DECLARE @v_division_id          NVARCHAR(MAX)
    DECLARE @v_site_id              NVARCHAR(MAX)
    DECLARE @v_plant_id             NVARCHAR(MAX)
    DECLARE @v_factory_id           NVARCHAR(MAX)
    DECLARE @v_line_id              NVARCHAR(MAX)
    DECLARE @v_operation_id         NVARCHAR(MAX)
    DECLARE @v_item_id              NVARCHAR(MAX)
    DECLARE @v_top_item_id          NVARCHAR(MAX)
	DECLARE @v_item_type            NVARCHAR(MAX)
	DECLARE @v_nick_name            NVARCHAR(MAX)
    DECLARE @v_location             NVARCHAR(MAX)
    DECLARE @v_prod_type            NVARCHAR(MAX)
    DECLARE @v_market               NVARCHAR(MAX)
    DECLARE @v_electrode_type       NVARCHAR(MAX)
	DECLARE @v_confirm_area         NVARCHAR(MAX)
	DECLARE @v_release_value        NVARCHAR(MAX)
    DECLARE @v_in_qty               NVARCHAR(MAX)
    DECLARE @v_out_qty              NVARCHAR(MAX)
    DECLARE @v_cell_in_qty          NVARCHAR(MAX)
    DECLARE @v_cell_out_qty         NVARCHAR(MAX)
    DECLARE @v_qty                  NVARCHAR(MAX)


	DECLARE @recv_active_flag       NVARCHAR(MAX)				    
	DECLARE @v_proc_name	        NVARCHAR(100) = 'PR_UI_FP00622_LINE_ADD_SAVE'
	DECLARE @v_log_type             NVARCHAR(100) = ''
	DECLARE @v_log_message          NVARCHAR(MAX) = ''
	DECLARE @v_error_description    NVARCHAR(MAX) = ''
	DECLARE @v_delimiter            NVARCHAR(1)
	DECLARE @max_loop_cnt	        INTEGER = 0
	DECLARE @mst_loop_cnt	        INTEGER = 0
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

    DECLARE @v_pSql                 NVARCHAR(MAX)=''

	DECLARE @v_tmp1                 NVARCHAR(MAX)=''
	DECLARE @v_tmp2                 NVARCHAR(MAX)=''
	DECLARE @v_tmp3                 NVARCHAR(MAX)=''


	SET @v_sys_type             = ''
	SET @v_sys_flag             = ''
	SET @v_sys_gubun            = ''
	SET @v_user_id              = ''
    SET @v_instance_id          = ''
    SET @v_plan_date            = ''
    SET @v_plan_id              = ''  
    SET @v_division_id          = ''
    SET @v_site_id              = ''
    SET @v_plant_id             = ''
    SET @v_factory_id           = ''
    SET @v_line_id              = ''
    SET @v_operation_id         = ''
    SET @v_item_id              = ''
    SET @v_top_item_id          = '' 
	SET @v_item_type            = '' 
    SET @v_location             = ''
    SET @v_prod_type            = ''
    SET @v_market               = ''
    SET @v_electrode_type       = ''
	SET @v_confirm_area         = ''
	SET @v_release_value        = ''
    SET @v_in_qty               = ''
    SET @v_out_qty              = ''
    SET @v_cell_in_qty          = ''
    SET @v_cell_out_qty         = ''
    SET @v_qty                  = ''

	SET @recv_active_flag       = NULL	
	SET @recv_active_flag       = @p_sys_flag
	SET @v_delimiter            = '|'             -- 데이터 구분자
	SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_sys_flag, @v_delimiter) -- 프로시저 LOOP 길이를 판단  

	SET	@v_dSql                 = ''
	SET	@v_dSql1                = ''
	SET	@v_dSql2                = ''
	SET	@v_dSql3                = ''
	SET	@v_dSql4                = ''
	SET	@v_dSql5                = ''

	SET	@v_pSql                 = ''

    SET	@v_tmp1                 = ''
	SET	@v_tmp2                 = ''
	SET	@v_tmp3                 = ''


	/************************************************************************************************/
	/* SELECT인경우 :SELECT_ITEM_POPUP(ADD Popup)                                                                      */
	/************************************************************************************************/
    IF(@p_sys_flag ='SELECT_ITEM_POPUP')
        BEGIN --IF(START)
			DECLARE @IS_CELL_ASSY nvarchar(2) = '' 
			SET @IS_CELL_ASSY= (
								SELECT (CASE WHEN MAX(B.SEGMENT1) IS NULL THEN 'N' ELSE 'Y' END) AS IS_CELL_ASSY
								FROM   SCM_SYS_LOOKUP_VALUE  B WITH(NOLOCK)
								WHERE  B.ACTIVE_FLAG = 'Y'
								AND    B.LOOKUP_TYPE_CODE = 'CELL_PRODUCT_ASSY_INSTANCE'
								AND    B.SEGMENT1 IN (
									SELECT MAX(INSTANCE_ID)
									FROM   FP_INSTANCE_INFO_V V WITH(NOLOCK)
									WHERE  V.INSTANCE_ID = @p_instance_id
								) );

            SELECT @v_dSql  = ''
            SELECT @v_dSql += ' SELECT DISTINCT A.DIVISION_ID, A.SITE_ID, B.PLANT_ID, B.MODEL_ID, A.ITEM_ID, ISNULL(A.NICK_NAME,''-'') AS NICK_NAME ' + char(10)
            SELECT @v_dSql += '     ,( CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME ' + char(10)
            SELECT @v_dSql += '           WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'') ' + char(10)
            SELECT @v_dSql += '           ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE ' + char(10)
            SELECT @v_dSql += ' FROM  SCM_ITEM_M A WITH(NOLOCK)          ' + char(10)
            SELECT @v_dSql += '     , SCM_MODEL_COMP_TEMP B WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += '     , SCM_ITEM_CLASS_M C WITH(NOLOCK)    ' + char(10)
            SELECT @v_dSql += '     , (                                  ' + char(10)
            SELECT @v_dSql += '        SELECT DISTINCT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.OPERATION_ID        ' + char(10)
            SELECT @v_dSql += '        FROM   FP_INSTANCE_OPERATION_V A WITH(NOLOCK), SCM_OPERATION_M B WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += '        WHERE  A.COMPANY_ID   = B.COMPANY_ID             ' + char(10)
            SELECT @v_dSql += '        AND    A.DIVISION_ID  = B.DIVISION_ID            ' + char(10)
            SELECT @v_dSql += '        AND    A.SITE_ID      = B.SITE_ID                ' + char(10)
            SELECT @v_dSql += '        AND    A.OPERATION_ID = B.OPERATION_ID           ' + char(10)
            SELECT @v_dSql += '        AND    A.INSTANCE_ID  = '''+ @p_instance_id +''' ' + char(10)
            SELECT @v_dSql += '        AND    A.AMEND_FLAG   = ''Y''  ' + char(10)
            SELECT @v_dSql += '        AND    B.ACTIVE_FLAG  = ''Y''  ' + char(10)
            SELECT @v_dSql += '      ) D                              ' + char(10)
			SELECT @v_dSql += ' , SCM_ITEM_M E WITH(NOLOCK)' + char(10)
            SELECT @v_dSql += ' WHERE A.COMPANY_ID  = B.COMPANY_ID    ' + char(10)
            SELECT @v_dSql += ' AND   A.DIVISION_ID = B.DIVISION_ID   ' + char(10)
            SELECT @v_dSql += ' AND   A.SITE_ID     = B.SITE_ID       ' + char(10)
            SELECT @v_dSql += ' AND   A.ITEM_ID     = B.CHILD_ITEM_ID ' + char(10)
            SELECT @v_dSql += ' AND   A.ITEM_CLASS  = C.CLASS_ID      ' + char(10)
            SELECT @v_dSql += ' AND   A.COMPANY_ID  = D.COMPANY_ID    ' + char(10)
            SELECT @v_dSql += ' AND   A.DIVISION_ID = D.DIVISION_ID   ' + char(10)
            SELECT @v_dSql += ' AND   A.SITE_ID     = D.SITE_ID       ' + char(10)
			SELECT @v_dSql += ' AND   E.COMPANY_ID  = B.COMPANY_ID ' + char(10)
			SELECT @v_dSql += ' AND   E.DIVISION_ID = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql += ' AND   E.SITE_ID     = B.SITE_ID ' + char(10)
			SELECT @v_dSql += ' AND   E.ITEM_ID     = B.MODEL_ID ' + char(10)
			SELECT @v_dSql += ' AND   E.ITEM_CLASS != ''ES1901'' ' + char(10) -- Model 에 cell assy item 조회 안되도록 제약 추가... 20230703

			IF @IS_CELL_ASSY = 'Y' -- 20230613 Assy Changes
				SELECT @v_dSql += ' AND NOT ( A.ITEM_ID = B.MODEL_ID ) ' + char(10)
 
            SELECT @v_dSql += ' AND   EXISTS (                        ' + char(10)
            SELECT @v_dSql += '               SELECT 1                ' + char(10)
            SELECT @v_dSql += '               FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)      ' + char(10)
            SELECT @v_dSql += '               WHERE  A.COMPANY_ID     = B.COMPANY_ID         ' + char(10)
            SELECT @v_dSql += '               AND    A.DIVISION_ID    = B.DIVISION_ID        ' + char(10)
            SELECT @v_dSql += '               AND    A.SITE_ID        = B.SITE_ID            ' + char(10)
            SELECT @v_dSql += '               AND    B.USER_ID        = '''+ @p_user_id +''' ' + char(10)
            SELECT @v_dSql += '               AND	   B.SAVE_FLAG	  = ''Y''                ' + char(10)
            SELECT @v_dSql += '       )                                                      ' + char(10)

			SELECT @v_dSql += ' AND   A.FLOW_ID LIKE ''%'' + D.OPERATION_ID + ''%''  ' + char(10)

            IF(LEN(@p_top_item_id) > 0)
			    BEGIN
                    SELECT @v_dSql += ' AND  B.MODEL_ID   = '''+ @p_top_item_id +''' ' + char(10)
			    END
            IF(LEN(@p_item_id) > 0)
			    BEGIN
                    SELECT @v_dSql += ' AND  A.ITEM_ID    = '''+ @p_item_id +''' ' + char(10)
			    END
            IF(LEN(@p_nick_name) > 0)
			    BEGIN
                    SELECT @v_dSql += ' AND  A.NICK_NAME  = '''+ @p_nick_name +''' ' + char(10)
			    END

            SELECT @v_dSql += ' AND    EXISTS (  SELECT  1 ' + char(10)
            SELECT @v_dSql += '                  FROM   FP_INSTANCE_FACTORY_M FF WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += '                        ,SCM_FACTORY_M  F  WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += '                  WHERE  FF.FACTORY_ID 	= F.FACTORY_ID ' + char(10)
            SELECT @v_dSql += '                  AND    FF.INSTANCE_ID  = '''+ @p_instance_id +''' ' + char(10)
            SELECT @v_dSql += '                  AND    F.COMPANY_ID 	= A.COMPANY_ID ' + char(10)
            SELECT @v_dSql += '                  AND    F.DIVISION_ID 	= A.DIVISION_ID ' + char(10)
            SELECT @v_dSql += '                  AND    F.SITE_ID       = A.SITE_ID	) ' + char(10)
            SELECT @v_dSql += ' ORDER BY A.DIVISION_ID, A.SITE_ID, B.PLANT_ID, B.MODEL_ID, A.ITEM_ID, ISNULL(A.NICK_NAME,''-''), ITEM_TYPE ' + char(10)

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
	/* SELECT인경우 :SELECT_ITEM_POPUP_ELEC(ADD Popup for ELECTRODE)                                                                      */
	/************************************************************************************************/
    ELSE IF(@p_sys_flag ='SELECT_ITEM_POPUP_ELEC')
        BEGIN --IF(START)
            SELECT @v_dSql  = ''
  SET @v_dSql += ' SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID'+ char(10)
  SET @v_dSql += '            , A.ITEM_ID AS MODEL_ID, A.ITEM_ID, ISNULL(A.NICK_NAME,''-'') AS NICK_NAME,'+ char(10)
  SET @v_dSql += '             (CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME'+ char(10)
  SET @v_dSql += '             	     WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'')'+ char(10)
  SET @v_dSql += '             	     ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE'+ char(10)
  SET @v_dSql += '      FROM SCM_ITEM_M A WITH(NOLOCK), SCM_ITEM_CLASS_M C WITH(NOLOCK)'+ char(10)
  SET @v_dSql += '      , ('+ char(10)
  SET @v_dSql += '          SELECT DISTINCT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.OPERATION_ID'+ char(10)
  SET @v_dSql += '          FROM   FP_INSTANCE_OPERATION_V A WITH(NOLOCK), SCM_OPERATION_M B WITH(NOLOCK)'+ char(10)
  SET @v_dSql += '          WHERE  A.COMPANY_ID   = B.COMPANY_ID'+ char(10)
  SET @v_dSql += '          AND    A.DIVISION_ID  = B.DIVISION_ID'+ char(10)
  SET @v_dSql += '          AND    A.SITE_ID      = B.SITE_ID'+ char(10)
  SET @v_dSql += '          AND    A.OPERATION_ID = B.OPERATION_ID'+ char(10)
  SET @v_dSql += '          AND    A.INSTANCE_ID  = '''+ @p_instance_id +''' ' + char(10)
  SET @v_dSql += '          AND    A.AMEND_FLAG   = ''Y'''+ char(10)
  SET @v_dSql += '          AND    B.ACTIVE_FLAG  = ''Y'''+ char(10)
  SET @v_dSql += '      ) D'+ char(10)
  SET @v_dSql += '      WHERE	 A.ITEM_CLASS  = C.CLASS_ID'+ char(10)
  SET @v_dSql += '      AND    A.COMPANY_ID  = D.COMPANY_ID'+ char(10)
  SET @v_dSql += '      AND    A.DIVISION_ID = D.DIVISION_ID'+ char(10)
  SET @v_dSql += '      AND    A.SITE_ID     = D.SITE_ID'+ char(10)
  SET @v_dSql += '      AND    A.FLOW_ID LIKE ''%'' + D.OPERATION_ID + ''%'''+ char(10)
  --SET @v_dSql += '      [AND		 A.DIVISION_ID = #DIVISION_ID#]'+ char(10)
  --SET @v_dSql += '      [AND		 A.SITE_ID     = #SITE_ID#]'+ char(10)
  --SET @v_dSql += '      --AND    A.FLOW_ID LIKE ''%'' + '''' + ''%'''+ char(10)
  --SET @v_dSql += '      [AND		 A.ITEM_ID     LIKE ''%'' + #ITEM_ID# + ''%'']'+ char(10)
  --SET @v_dSql += '      [AND		 A.NICK_NAME   = #NICK_NAME#]'+ char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'EQ', @p_item_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.NICK_NAME' , 'EQ', @p_nick_name)) + char(10)
  SET @v_dSql += '      AND    EXISTS (	SELECT 	1'+ char(10)
  SET @v_dSql += '    									FROM   FP_INSTANCE_FACTORY_M FF WITH(NOLOCK)'+ char(10)
  SET @v_dSql += '    												,SCM_FACTORY_M         F  WITH(NOLOCK)'+ char(10)
  SET @v_dSql += '    									WHERE  FF.FACTORY_ID 	= F.FACTORY_ID'+ char(10)
  SET @v_dSql += '    									AND    FF.INSTANCE_ID = '''+ @p_instance_id +''' ' + char(10)
  SET @v_dSql += '    									AND    F.COMPANY_ID 	= A.COMPANY_ID'+ char(10)
  SET @v_dSql += '    									AND    F.DIVISION_ID 	= A.DIVISION_ID'+ char(10)
  SET @v_dSql += '    									AND    F.SITE_ID 			= A.SITE_ID	)'+ char(10)
  SET @v_dSql += '		AND    EXISTS ('+ char(10)
  SET @v_dSql += '				        	SELECT 1'+ char(10)
  SET @v_dSql += '				        	FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)'+ char(10)
  SET @v_dSql += '				        	WHERE  A.COMPANY_ID     = B.COMPANY_ID'+ char(10)
  SET @v_dSql += '				        	AND    A.DIVISION_ID    = B.DIVISION_ID'+ char(10)
  SET @v_dSql += '				        	AND    A.SITE_ID        = B.SITE_ID'+ char(10)
  SET @v_dSql += '				        	AND    B.USER_ID        = '''+ @p_user_id +''' ' + char(10)
  SET @v_dSql += '				        	AND	   B.SAVE_FLAG	  	= ''Y'''+ char(10)
  SET @v_dSql += '					    )'+ char(10)
  SET @v_dSql += '      ORDER BY DIVISION_ID, SITE_ID, MODEL_ID, ITEM_ID'+ char(10)

   --         SELECT @v_dSql += ' SELECT DISTINCT A.DIVISION_ID, A.SITE_ID, B.PLANT_ID, B.MODEL_ID, A.ITEM_ID, ISNULL(A.NICK_NAME,''-'') AS NICK_NAME ' + char(10)
   --         SELECT @v_dSql += '     ,( CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME ' + char(10)
   --         SELECT @v_dSql += '           WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'') ' + char(10)
   --         SELECT @v_dSql += '           ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE ' + char(10)
   --         SELECT @v_dSql += ' FROM  SCM_ITEM_M A WITH(NOLOCK)          ' + char(10)
   --         SELECT @v_dSql += '     , SCM_MODEL_COMP_TEMP B WITH(NOLOCK) ' + char(10)
   --         SELECT @v_dSql += '     , SCM_ITEM_CLASS_M C WITH(NOLOCK)    ' + char(10)
   --         SELECT @v_dSql += '     , (                                  ' + char(10)
   --         SELECT @v_dSql += '        SELECT DISTINCT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.OPERATION_ID        ' + char(10)
   --         SELECT @v_dSql += '        FROM   FP_INSTANCE_OPERATION_V A WITH(NOLOCK), SCM_OPERATION_M B WITH(NOLOCK) ' + char(10)
   --         SELECT @v_dSql += '        WHERE  A.COMPANY_ID   = B.COMPANY_ID             ' + char(10)
   --         SELECT @v_dSql += '        AND    A.DIVISION_ID  = B.DIVISION_ID            ' + char(10)
   --         SELECT @v_dSql += '        AND    A.SITE_ID      = B.SITE_ID                ' + char(10)
   --         SELECT @v_dSql += '        AND    A.OPERATION_ID = B.OPERATION_ID           ' + char(10)
   --         SELECT @v_dSql += '        AND    A.INSTANCE_ID  = '''+ @p_instance_id +''' ' + char(10)
   --         SELECT @v_dSql += '        AND    A.AMEND_FLAG   = ''Y''  ' + char(10)
   --         SELECT @v_dSql += '        AND    B.ACTIVE_FLAG  = ''Y''  ' + char(10)
   --         SELECT @v_dSql += '      ) D                              ' + char(10)
   --         SELECT @v_dSql += ' WHERE A.COMPANY_ID  = B.COMPANY_ID    ' + char(10)
   --         SELECT @v_dSql += ' AND   A.DIVISION_ID = B.DIVISION_ID   ' + char(10)
   --         SELECT @v_dSql += ' AND   A.SITE_ID     = B.SITE_ID       ' + char(10)
   --         SELECT @v_dSql += ' AND   A.ITEM_ID     = B.CHILD_ITEM_ID ' + char(10)
   --         SELECT @v_dSql += ' AND   A.ITEM_CLASS  = C.CLASS_ID      ' + char(10)
   --         SELECT @v_dSql += ' AND   A.COMPANY_ID  = D.COMPANY_ID    ' + char(10)
   --         SELECT @v_dSql += ' AND   A.DIVISION_ID = D.DIVISION_ID   ' + char(10)
   --         SELECT @v_dSql += ' AND   A.SITE_ID     = D.SITE_ID       ' + char(10)
   --         SELECT @v_dSql += ' AND   EXISTS (                        ' + char(10)
   --         SELECT @v_dSql += '               SELECT 1                ' + char(10)
   --         SELECT @v_dSql += '               FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)      ' + char(10)
   --         SELECT @v_dSql += '               WHERE  A.COMPANY_ID     = B.COMPANY_ID         ' + char(10)
   --         SELECT @v_dSql += '               AND    A.DIVISION_ID    = B.DIVISION_ID        ' + char(10)
   --         SELECT @v_dSql += '               AND    A.SITE_ID        = B.SITE_ID            ' + char(10)
   --         SELECT @v_dSql += '               AND    B.USER_ID        = '''+ @p_user_id +''' ' + char(10)
   --         SELECT @v_dSql += '               AND	   B.SAVE_FLAG	  = ''Y''                ' + char(10)
   --         SELECT @v_dSql += '       )                                                      ' + char(10)

			--SELECT @v_dSql += ' AND   A.FLOW_ID LIKE ''%'' + D.OPERATION_ID + ''%''  ' + char(10)

   --         IF(LEN(@p_top_item_id) > 0)
			--    BEGIN
   --                 SELECT @v_dSql += ' AND  B.MODEL_ID   = '''+ @p_top_item_id +''' ' + char(10)
			--    END
   --         IF(LEN(@p_item_id) > 0)
			--    BEGIN
   --                 SELECT @v_dSql += ' AND  A.ITEM_ID    = '''+ @p_item_id +''' ' + char(10)
			--    END
   --         IF(LEN(@p_nick_name) > 0)
			--    BEGIN
   --                 SELECT @v_dSql += ' AND  A.NICK_NAME  = '''+ @p_nick_name +''' ' + char(10)
			--    END

   --         SELECT @v_dSql += ' AND    EXISTS (  SELECT  1 ' + char(10)
   --         SELECT @v_dSql += '                  FROM   FP_INSTANCE_FACTORY_M FF WITH(NOLOCK) ' + char(10)
   --         SELECT @v_dSql += '                        ,SCM_FACTORY_M  F  WITH(NOLOCK) ' + char(10)
   --         SELECT @v_dSql += '                  WHERE  FF.FACTORY_ID 	= F.FACTORY_ID ' + char(10)
   --         SELECT @v_dSql += '                  AND    FF.INSTANCE_ID  = '''+ @p_instance_id +''' ' + char(10)
   --         SELECT @v_dSql += '                  AND    F.COMPANY_ID 	= A.COMPANY_ID ' + char(10)
   --         SELECT @v_dSql += '                  AND    F.DIVISION_ID 	= A.DIVISION_ID ' + char(10)
   --         SELECT @v_dSql += '                  AND    F.SITE_ID       = A.SITE_ID	) ' + char(10)
   --         SELECT @v_dSql += ' ORDER BY A.DIVISION_ID, A.SITE_ID, B.PLANT_ID, B.MODEL_ID, A.ITEM_ID, ISNULL(A.NICK_NAME,''-''), ITEM_TYPE ' + char(10)

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
	/* SELECT인경우 :SELECT_LINE_POPUP(ADD Popup)   pr_amend/planamend_cn2_addLine(find_LineList)   */
	/************************************************************************************************/
    ELSE IF(@p_sys_flag ='SELECT_LINE_POPUP')
        BEGIN --IF(START)
            SELECT @v_dSql  = ''
            SELECT @v_dSql += ' SELECT DISTINCT                                          ' + char(10)
            SELECT @v_dSql += '       A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
            SELECT @v_dSql += '     , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
            SELECT @v_dSql += '     , ISNULL(B.LINE_NAME,''-'') AS LINE_NAME      ' + char(10)
            SELECT @v_dSql += '     , B.LOCATION                             ' + char(10)
            SELECT @v_dSql += ' FROM   SCM_ITEM_LINE_ASSIGN_M A WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += ' INNER JOIN SCM_LINE_M B WITH(NOLOCK)     ' + char(10)
            SELECT @v_dSql += ' ON   A.COMPANY_ID     = B.COMPANY_ID     ' + char(10)
            SELECT @v_dSql += ' AND  A.DIVISION_ID    = B.DIVISION_ID    ' + char(10)
            SELECT @v_dSql += ' AND  A.SITE_ID        = B.SITE_ID        ' + char(10)
            SELECT @v_dSql += ' AND  A.PLANT_ID       = B.PLANT_ID       ' + char(10)
            SELECT @v_dSql += ' AND  A.FACTORY_ID     = B.FACTORY_ID     ' + char(10)
            SELECT @v_dSql += ' AND  A.OPERATION_ID   = B.OPERATION_ID   ' + char(10)
            SELECT @v_dSql += ' AND  A.LINE_ID        = B.LINE_ID        ' + char(10)
            SELECT @v_dSql += ' AND  A.ELECTRODE_TYPE = B.ELECTRODE_TYPE ' + char(10)
			
			IF (@p_confirm_area = 'PLAN GROUP')
			    BEGIN
				    SELECT @v_dSql += ' INNER JOIN  ' + char(10)
				END
			ELSE
			    BEGIN
				    SELECT @v_dSql += ' LEFT OUTER JOIN  ' + char(10)
				END

            SELECT @v_dSql += ' (                                           ' + char(10)
            SELECT @v_dSql += '  SELECT A.SEGMENT2 AS PLAN_GROUP_ID         ' + char(10)
            SELECT @v_dSql += '  FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += '  WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP'' ' + char(10)
            SELECT @v_dSql += '  AND    A.ACTIVE_FLAG = ''Y''                    ' + char(10)
            SELECT @v_dSql += '  AND    A.SEGMENT1    = '''+ @p_instance_id +''' ' + char(10)
            SELECT @v_dSql += ' ) C                                       ' + char(10)
            SELECT @v_dSql += ' ON     B.MODEL_TYPE   = C.PLAN_GROUP_ID   ' + char(10)
            SELECT @v_dSql += ' INNER JOIN (                              ' + char(10)
            SELECT @v_dSql += '             SELECT DISTINCT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.OPERATION_ID        ' + char(10)
            SELECT @v_dSql += '             FROM   FP_INSTANCE_OPERATION_V A WITH(NOLOCK), SCM_OPERATION_M B WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += '             WHERE  A.COMPANY_ID   = B.COMPANY_ID               ' + char(10)
            SELECT @v_dSql += '             AND    A.DIVISION_ID  = B.DIVISION_ID              ' + char(10)
            SELECT @v_dSql += '             AND    A.SITE_ID      = B.SITE_ID                  ' + char(10)
            SELECT @v_dSql += '             AND    A.OPERATION_ID = B.OPERATION_ID             ' + char(10)
			SELECT @v_dSql += '             '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_ID' , 'EQ', @p_instance_id)) + char(10)
			SELECT @v_dSql += '             '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
			SELECT @v_dSql += '             '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.SITE_ID' , 'EQ', @p_site_id))         + char(10)

            SELECT @v_dSql += '             AND    A.AMEND_FLAG   = ''Y'' ' + char(10)
            SELECT @v_dSql += '             AND    B.ACTIVE_FLAG  = ''Y'' ' + char(10)
            SELECT @v_dSql += ' ) D                                       ' + char(10)
            SELECT @v_dSql += ' ON     A.COMPANY_ID    = D.COMPANY_ID     ' + char(10)
            SELECT @v_dSql += ' AND    A.DIVISION_ID   = D.DIVISION_ID    ' + char(10)
            SELECT @v_dSql += ' AND    A.SITE_ID       = D.SITE_ID        ' + char(10)
            SELECT @v_dSql += ' AND    A.OPERATION_ID  = D.OPERATION_ID   ' + char(10)
			SELECT @v_dSql += ' WHERE 1=1 ' + char(10)
			SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
			SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' ,     'EQ', @p_site_id))     + char(10)
			SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' ,    'EQ', @p_plant_id))    + char(10)
            SELECT @v_dSql += ' AND    A.ITEM_ID       = '''+ @p_item_id +'''     ' + char(10)

			IF(LEN(@p_line_id) > 0)
			    BEGIN
                    SELECT @v_dSql += ' AND    A.LINE_ID LIKE ''%'' +  '''+ @p_line_id +''' + ''%'' ' + char(10)
			    END
            SELECT @v_dSql += ' AND    A.ACTIVE_FLAG    = ''Y'' ' + char(10)
            SELECT @v_dSql += ' AND    B.ACTIVE_FLAG    = ''Y'' ' + char(10)
            SELECT @v_dSql += ' AND    A.MONTH          = SUBSTRING(CONVERT(VARCHAR,dbo.SYSDATE1(),112),1,6) ' + char(10)
            SELECT @v_dSql += ' AND    A.PRIORITY NOT IN (''0'',''9'')                        ' + char(10)
            SELECT @v_dSql += ' AND    EXISTS (                                               ' + char(10)
            SELECT @v_dSql += '                SELECT 1                                       ' + char(10)
            SELECT @v_dSql += '                FROM   FP_USER_ROLE_INFO_V BB WITH(NOLOCK)     ' + char(10)
            SELECT @v_dSql += '                WHERE  A.COMPANY_ID     = BB.COMPANY_ID        ' + char(10)
            SELECT @v_dSql += '                AND    A.DIVISION_ID    = BB.DIVISION_ID       ' + char(10)
            SELECT @v_dSql += '                AND    A.SITE_ID        = BB.SITE_ID           ' + char(10)
            SELECT @v_dSql += '                AND    A.PLANT_ID       = BB.PLANT_ID          ' + char(10)
            SELECT @v_dSql += '                AND    A.FACTORY_ID     = BB.FACTORY_ID        ' + char(10)
            SELECT @v_dSql += '                AND    A.OPERATION_ID   = BB.OPERATION_ID      ' + char(10)
            SELECT @v_dSql += '                AND    A.LINE_ID        = BB.LINE_ID           ' + char(10)
            SELECT @v_dSql += '                AND    BB.USER_ID       = '''+ @p_user_id +''' ' + char(10)
            SELECT @v_dSql += '                AND    BB.SAVE_FLAG	  = ''Y''                 ' + char(10)
            SELECT @v_dSql += ' 		    )                                                 ' + char(10)
            SELECT @v_dSql += ' ORDER BY A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, LINE_NAME, LOCATION ' + char(10)

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
	/* SELECT인경우 :SELECT_LINE_MPPWPP_POPUP(ADD Popup) FP00602_MPPWPP(find_LineList_addLine)      */
	/************************************************************************************************/
    ELSE IF(@p_sys_flag ='SELECT_LINE_MPPWPP_POPUP')
        BEGIN --IF(START)
            SELECT @v_dSql  = ''
            SELECT @v_dSql += ' SELECT DISTINCT                                          ' + char(10)
            SELECT @v_dSql += '       B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, B.FACTORY_ID ' + char(10)
            SELECT @v_dSql += '     , B.OPERATION_ID, B.LINE_ID, B.ELECTRODE_TYPE        ' + char(10)
            SELECT @v_dSql += '     , ISNULL(B.LINE_NAME,''-'') AS LINE_NAME             ' + char(10)
            SELECT @v_dSql += '     , B.LOCATION                 ' + char(10)
            SELECT @v_dSql += ' FROM   SCM_LINE_M B WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += ' INNER JOIN (                     ' + char(10)
            SELECT @v_dSql += '        SELECT DISTINCT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.OPERATION_ID        ' + char(10)
            SELECT @v_dSql += '        FROM   FP_INSTANCE_OPERATION_V A WITH(NOLOCK), SCM_OPERATION_M B WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += '        WHERE  A.COMPANY_ID   = B.COMPANY_ID             ' + char(10)
            SELECT @v_dSql += '        AND    A.DIVISION_ID  = B.DIVISION_ID            ' + char(10)
            SELECT @v_dSql += '        AND    A.SITE_ID      = B.SITE_ID                ' + char(10)
            SELECT @v_dSql += '        AND    A.OPERATION_ID = B.OPERATION_ID           ' + char(10)
			SELECT @v_dSql += '        '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_ID' , 'EQ', @p_instance_id)) + char(10)
			SELECT @v_dSql += '        '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
			SELECT @v_dSql += '        '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.SITE_ID' , 'EQ', @p_site_id))         + char(10)

            SELECT @v_dSql += '        AND    A.AMEND_FLAG   = ''Y''     ' + char(10)
            SELECT @v_dSql += '        AND    B.ACTIVE_FLAG  = ''Y''     ' + char(10)
            SELECT @v_dSql += ' ) D                                      ' + char(10)
            SELECT @v_dSql += ' ON     B.COMPANY_ID     = D.COMPANY_ID   ' + char(10)
            SELECT @v_dSql += ' AND    B.DIVISION_ID    = D.DIVISION_ID  ' + char(10)
            SELECT @v_dSql += ' AND    B.SITE_ID        = D.SITE_ID      ' + char(10)
            SELECT @v_dSql += ' AND    B.OPERATION_ID   = D.OPERATION_ID ' + char(10)
			SELECT @v_dSql += ' WHERE  1=1                               ' + char(10)
			SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
			SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.SITE_ID' ,     'EQ', @p_site_id))     + char(10)
			SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.PLANT_ID' ,    'EQ', @p_plant_id))    + char(10)

            SELECT @v_dSql += ' AND    B.ACTIVE_FLAG    = ''Y'' ' + char(10)

	  		IF(LEN(@p_line_id) > 0)
			    BEGIN
                    SELECT @v_dSql += ' AND    B.LINE_ID LIKE ''%'' +  '''+ @p_line_id +''' + ''%'' ' + char(10)
			    END

	  		IF (@p_confirm_area = 'BUILDING')
			    BEGIN
				    SELECT @v_dSql += ' AND    B.FACTORY_ID     = '''+ @p_release_value + ''' ' + char(10)
				END
			ELSE
			    BEGIN
				    SELECT @v_dSql += ' AND    B.MODEL_TYPE     = '''+ @p_release_value + ''' ' + char(10)
				END

            SELECT @v_dSql += ' ORDER BY B.FACTORY_ID, B.OPERATION_ID, B.LINE_ID, LINE_NAME, LOCATION ' + char(10)

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
		/************************************************************************************************/
		/* SAVE인경우 :SAVE                                                                      */
		/************************************************************************************************/
		-- 트랜잭션 (TRAN)
		BEGIN TRY				                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
		BEGIN TRAN   

		BEGIN --( BEGIN )
				--max_loop_cnt:전체 Row수 , mst_loop_cnt:1씩 증가시켜서 전체 Row수 까지만 로직을 수행
				WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
					BEGIN --WHILE 내(START)
					 
							SELECT @mst_loop_cnt = @mst_loop_cnt + 1	-- @mst_loop_cnt 1증가

							SELECT @v_sys_type    = [dbo].[SCM_ARR_SPL_VAL](@p_sys_type ,      @v_delimiter, @mst_loop_cnt)
							, @v_sys_flag         = [dbo].[SCM_ARR_SPL_VAL](@p_sys_flag ,      @v_delimiter, @mst_loop_cnt)
							, @v_sys_gubun        = [dbo].[SCM_ARR_SPL_VAL](@p_sys_gubun ,     @v_delimiter, @mst_loop_cnt)
							, @v_user_id          = [dbo].[SCM_ARR_SPL_VAL](@p_user_id ,       @v_delimiter, @mst_loop_cnt)
							, @v_instance_id      = [dbo].[SCM_ARR_SPL_VAL](@p_instance_id ,   @v_delimiter, @mst_loop_cnt)
							, @v_plan_date        = [dbo].[SCM_ARR_SPL_VAL](@p_plan_date ,     @v_delimiter, @mst_loop_cnt)
							, @v_plan_id          = [dbo].[SCM_ARR_SPL_VAL](@p_plan_id ,       @v_delimiter, @mst_loop_cnt)
							, @v_division_id      = [dbo].[SCM_ARR_SPL_VAL](@p_division_id ,   @v_delimiter, @mst_loop_cnt)
							, @v_site_id          = [dbo].[SCM_ARR_SPL_VAL](@p_site_id ,       @v_delimiter, @mst_loop_cnt)
							, @v_plant_id         = [dbo].[SCM_ARR_SPL_VAL](@p_plant_id ,      @v_delimiter, @mst_loop_cnt)
							, @v_factory_id       = [dbo].[SCM_ARR_SPL_VAL](@p_factory_id ,    @v_delimiter, @mst_loop_cnt)
							, @v_line_id          = [dbo].[SCM_ARR_SPL_VAL](@p_line_id ,       @v_delimiter, @mst_loop_cnt)
							, @v_operation_id     = [dbo].[SCM_ARR_SPL_VAL](@p_operation_id ,  @v_delimiter, @mst_loop_cnt)
							, @v_item_id          = [dbo].[SCM_ARR_SPL_VAL](@p_item_id ,       @v_delimiter, @mst_loop_cnt)
							, @v_top_item_id      = [dbo].[SCM_ARR_SPL_VAL](@p_top_item_id ,   @v_delimiter, @mst_loop_cnt)
							, @v_item_type        = [dbo].[SCM_ARR_SPL_VAL](@p_item_type ,     @v_delimiter, @mst_loop_cnt)
							, @v_nick_name        = [dbo].[SCM_ARR_SPL_VAL](@p_nick_name ,     @v_delimiter, @mst_loop_cnt)
							, @v_location         = [dbo].[SCM_ARR_SPL_VAL](@p_location ,      @v_delimiter, @mst_loop_cnt)
							, @v_prod_type        = [dbo].[SCM_ARR_SPL_VAL](@p_prod_type ,     @v_delimiter, @mst_loop_cnt)
							, @v_market           = [dbo].[SCM_ARR_SPL_VAL](@p_market ,        @v_delimiter, @mst_loop_cnt)
							, @v_electrode_type   = [dbo].[SCM_ARR_SPL_VAL](@p_electrode_type ,@v_delimiter, @mst_loop_cnt)
							, @v_confirm_area     = [dbo].[SCM_ARR_SPL_VAL](@p_confirm_area ,  @v_delimiter, @mst_loop_cnt)
							, @v_release_value    = [dbo].[SCM_ARR_SPL_VAL](@p_release_value , @v_delimiter, @mst_loop_cnt)
							, @v_in_qty           = [dbo].[SCM_ARR_SPL_VAL](@p_in_qty ,        @v_delimiter, @mst_loop_cnt)
							, @v_out_qty          = [dbo].[SCM_ARR_SPL_VAL](@p_out_qty ,       @v_delimiter, @mst_loop_cnt)
							, @v_cell_in_qty      = [dbo].[SCM_ARR_SPL_VAL](@p_cell_in_qty ,   @v_delimiter, @mst_loop_cnt)
							, @v_cell_out_qty     = [dbo].[SCM_ARR_SPL_VAL](@p_cell_out_qty ,  @v_delimiter, @mst_loop_cnt)
							, @v_qty              = [dbo].[SCM_ARR_SPL_VAL](@p_qty ,           @v_delimiter, @mst_loop_cnt)
					   

						   /****************************************************************************/
						   /* INSERT_ADD_MPPWPP  경우  :   (ADD POPUP)                                          */
						   /****************************************************************************/
						   IF(@v_sys_flag ='INSERT_ADD_MPPWPP')
							   BEGIN

									SELECT @v_dSql = ''

									SELECT @v_dSql += ' INSERT INTO FP_AMEND_PLAN_CELL_H ( ' + char(10)
									SELECT @v_dSql += '    INSTANCE_ID, FP_PLAN_ID         ' + char(10)
									SELECT @v_dSql += '   ,COMPANY_ID, DIVISION_ID         ' + char(10)
									SELECT @v_dSql += '   ,CATEGORY_ID                     ' + char(10)
									SELECT @v_dSql += '   ,SITE_ID, PLANT_ID, ITEM_ID, OPERATION_ID, FACTORY_ID ' + char(10)
									SELECT @v_dSql += '   ,LOCATION, PRODUCTION_TYPE, MARKET ' + char(10)
									SELECT @v_dSql += '   ,LINE_ID, ELECTRODE_TYPE           ' + char(10)
									SELECT @v_dSql += '   ,PLAN_DATE                         ' + char(10)
									SELECT @v_dSql += '   ,TOP_ITEM_ID, ITEM_TYPE            ' + char(10)
									SELECT @v_dSql += '   ,'+ TRY_CONVERT(NVARCHAR, @v_in_qty) +'       ' + char(10)
									SELECT @v_dSql += '   ,'+ TRY_CONVERT(NVARCHAR, @v_out_qty) +'      ' + char(10)
									SELECT @v_dSql += '   ,'+ TRY_CONVERT(NVARCHAR, @v_cell_in_qty) +'  ' + char(10)
									SELECT @v_dSql += '   ,'+ TRY_CONVERT(NVARCHAR, @v_cell_out_qty) +' ' + char(10)
									SELECT @v_dSql += '   ,DATE_SEQ               ' + char(10)
									SELECT @v_dSql += '   ,INSERT_ID, INSERT_TIME ' + char(10)
									SELECT @v_dSql += '   ,UPDATE_ID, UPDATE_TIME ' + char(10)
									SELECT @v_dSql += ' )        ' + char(10)
									SELECT @v_dSql += ' VALUES ( ' + char(10)
									SELECT @v_dSql += '   UPPER('''+ @v_instance_id +'''), UPPER('''+ @v_plan_id +''') ' + char(10)
									SELECT @v_dSql += '  ,(SELECT DISTINCT COMPANY_ID FROM SCM_FACTORY_M WHERE DIVISION_ID = '''+ @v_division_id +''' AND SITE_ID = '''+ @v_site_id +''' AND PLANT_ID = '''+ @v_plant_id +''' AND ACTIVE_FLAG = ''Y''), '''+ @v_division_id +''' ' + char(10)
									SELECT @v_dSql += '  ,''PLAN'' ' + char(10)
									SELECT @v_dSql += '  ,UPPER('''+ @v_site_id +'''), UPPER('''+ @v_plant_id +'''), UPPER('''+ @v_item_id +'''), UPPER('''+ @v_operation_id +'''), UPPER('''+ @v_factory_id +''') ' + char(10)
									SELECT @v_dSql += '  ,UPPER('''+ @v_location +'''), UPPER('''+ @v_prod_type +'''), UPPER('''+ @v_market +''') ' + char(10)
									SELECT @v_dSql += '  ,UPPER('''+ @v_line_id +'''), '''+ @v_electrode_type +''' ' + char(10)
									SELECT @v_dSql += '  ,CONVERT(DATE,'''+ @v_plan_date +''') ' + char(10)
									SELECT @v_dSql += '  ,UPPER('''+ @v_top_item_id +'''), UPPER('''+ @v_item_type +''') ' + char(10)
									SELECT @v_dSql += '  ,CEILING(FLOOR('''+ @v_qty +''' * dbo.FN_GET_REQ_QTY_MODEL( '''+ @v_plant_id +''', '''+ @v_top_item_id +''', '''+ @v_item_id +''', '''+ @v_plan_date +''') ) ' + char(10)
									SELECT @v_dSql += '               / ( SELECT ISNULL( ISNULL(MAX(B.YIELD),(CASE WHEN MAX(A.YIELD) = 0 THEN 1 ELSE MAX(A.YIELD) END)) ,1) AS YIELD ' + char(10)
									SELECT @v_dSql += '                   FROM   SCM_YIELD_M A WITH(NOLOCK) ' + char(10)
									SELECT @v_dSql += '                   LEFT OUTER JOIN ( ' + char(10)
									SELECT @v_dSql += '                   	SELECT (CASE WHEN MAX(YIELD) = 0 THEN 1 ELSE MAX(YIELD) END) AS YIELD ' + char(10)
									SELECT @v_dSql += '                   	FROM   SCM_YIELD_EXCEPT_M A WITH(NOLOCK)          ' + char(10)
									SELECT @v_dSql += '                   	WHERE  A.DIVISION_ID  = '''+ @v_division_id +'''  ' + char(10)
									SELECT @v_dSql += '                   	AND    A.SITE_ID      = '''+ @v_site_id +'''      ' + char(10)
									SELECT @v_dSql += '                   	AND    A.PLANT_ID     = '''+ @v_plant_id +'''     ' + char(10)
									SELECT @v_dSql += '                   	AND    A.FACTORY_ID   = '''+ @v_factory_id +'''   ' + char(10)
									SELECT @v_dSql += '                   	AND    A.OPERATION_ID = '''+ @v_operation_id +''' ' + char(10)
									SELECT @v_dSql += '                   	AND    A.LINE_ID      = '''+ @v_line_id +'''      ' + char(10)
									SELECT @v_dSql += '                   	AND    A.ITEM_ID      = '''+ @v_item_id +'''      ' + char(10)
									SELECT @v_dSql += '                   	AND    CONVERT(DATE,'''+ @v_plan_date +''') BETWEEN A.START_TIME AND A.END_TIME ' + char(10)
									SELECT @v_dSql += '                   ) B        ' + char(10)
									SELECT @v_dSql += '                   ON     1=1 ' + char(10)
									SELECT @v_dSql += '                   WHERE  A.DIVISION_ID  = '''+ @v_division_id +'''  ' + char(10)
									SELECT @v_dSql += '                   AND    A.SITE_ID      = '''+ @v_site_id +'''      ' + char(10)
									SELECT @v_dSql += '                   AND    A.PLANT_ID     = '''+ @v_plant_id +'''     ' + char(10)
									SELECT @v_dSql += '                   AND    A.FACTORY_ID   = '''+ @v_factory_id +'''   ' + char(10)
									SELECT @v_dSql += '                   AND    A.OPERATION_ID = '''+ @v_operation_id +''' ' + char(10)
									SELECT @v_dSql += '                   AND    A.LINE_ID      = '''+ @v_line_id +'''      ' + char(10)
									SELECT @v_dSql += '                   AND    A.ITEM_ID      = '''+ @v_item_id +'''      ' + char(10)
									SELECT @v_dSql += '                   AND    A.MONTH        = SUBSTRING('''+ @v_plan_date +''',1,6)) ) ' + char(10)
									SELECT @v_dSql += '  ,FLOOR('''+ @v_qty +''' * dbo.FN_GET_REQ_QTY_MODEL( '''+ @v_plant_id +''', '''+ @v_top_item_id +''', '''+ @v_item_id +''', '''+ @v_plan_date +''') ) ' + char(10)
									SELECT @v_dSql += '  ,CEILING('''+ @v_qty +''' / ( SELECT ISNULL( ISNULL(MAX(B.YIELD),(CASE WHEN MAX(A.YIELD) = 0 THEN 1 ELSE MAX(A.YIELD) END)) ,1) AS YIELD ' + char(10)
									SELECT @v_dSql += '                     FROM   SCM_YIELD_M A WITH(NOLOCK) ' + char(10)
									SELECT @v_dSql += '                     LEFT OUTER JOIN (                 ' + char(10)
									SELECT @v_dSql += '                         SELECT (CASE WHEN MAX(YIELD) = 0 THEN 1 ELSE MAX(YIELD) END) AS YIELD ' + char(10)
									SELECT @v_dSql += '                         FROM   SCM_YIELD_EXCEPT_M A WITH(NOLOCK)          ' + char(10)
									SELECT @v_dSql += '                         WHERE  A.DIVISION_ID  = '''+ @v_division_id +'''  ' + char(10)
									SELECT @v_dSql += '                         AND    A.SITE_ID      = '''+ @v_site_id +'''      ' + char(10)
									SELECT @v_dSql += '                         AND    A.PLANT_ID     = '''+ @v_plant_id +'''     ' + char(10)
									SELECT @v_dSql += '                         AND    A.FACTORY_ID   = '''+ @v_factory_id +'''   ' + char(10)
									SELECT @v_dSql += '                         AND    A.OPERATION_ID = '''+ @v_operation_id +''' ' + char(10)
									SELECT @v_dSql += '                         AND    A.LINE_ID      = '''+ @v_line_id +'''      ' + char(10)
									SELECT @v_dSql += '                         AND    A.ITEM_ID      = '''+ @v_item_id +'''      ' + char(10)
									SELECT @v_dSql += '                         AND    CONVERT(DATE,'''+ @v_plan_date +''') BETWEEN A.START_TIME AND A.END_TIME ' + char(10)
									SELECT @v_dSql += '                     ) B        ' + char(10)
									SELECT @v_dSql += '                     ON     1=1 ' + char(10)
									SELECT @v_dSql += '                     WHERE  A.DIVISION_ID  = '''+ @v_division_id +'''  ' + char(10)
									SELECT @v_dSql += '                     AND    A.SITE_ID      = '''+ @v_site_id +'''      ' + char(10)
									SELECT @v_dSql += '                     AND    A.PLANT_ID     = '''+ @v_plant_id +'''     ' + char(10)
									SELECT @v_dSql += '                     AND    A.FACTORY_ID   = '''+ @v_factory_id +'''   ' + char(10)
									SELECT @v_dSql += '                     AND    A.OPERATION_ID = '''+ @v_operation_id +''' ' + char(10)
									SELECT @v_dSql += '                     AND    A.LINE_ID      = '''+ @v_line_id +'''      ' + char(10)
									SELECT @v_dSql += '                     AND    A.ITEM_ID      = '''+ @v_item_id +'''      ' + char(10)
									SELECT @v_dSql += '                     AND    A.MONTH        = SUBSTRING('''+ @v_plan_date +''',1,6))) ' + char(10)
									SELECT @v_dSql += '  ,'''+ @v_qty +''' ' + char(10)
									SELECT @v_dSql += '  ,1                ' + char(10)
									SELECT @v_dSql += '  ,'''+ @v_user_id +''', dbo.FN_SITE_TIME('''+ @v_site_id +''') ' + char(10)
									SELECT @v_dSql += '  ,'''+ @v_user_id +''', dbo.FN_SITE_TIME('''+ @v_site_id +''') ' + char(10)
									SELECT @v_dSql += '  ) ' + char(10)

							   END --'D'
						   /****************************************************************************/
						   /* INSERT_ADD_MPPWPP_LOG  경우  : (ADD Popup)                                         */
						   /****************************************************************************/
						   ELSE IF(@v_sys_flag ='INSERT_ADD_MPPWPP_LOG')
								BEGIN
									SELECT @v_dSql = ''
									SELECT @v_dSql += ' INSERT INTO HIS_AMEND_PLAN_CELL_R ( ' + char(10)
									SELECT @v_dSql += '      INSTANCE_ID, FP_PLAN_ID        ' + char(10)
									SELECT @v_dSql += '     ,COMPANY_ID, DIVISION_ID        ' + char(10)
									SELECT @v_dSql += '     ,CATEGORY_ID                    ' + char(10)
									SELECT @v_dSql += '     ,SITE_ID, PLANT_ID,ITEM_ID, OPERATION_ID, FACTORY_ID ' + char(10)
									SELECT @v_dSql += '     ,LOCATION, PRODUCTION_TYPE, MARKET ' + char(10)
									SELECT @v_dSql += '     ,LINE_ID, ELECTRODE_TYPE           ' + char(10)
									SELECT @v_dSql += '     ,PLAN_DATE   ' + char(10)
									SELECT @v_dSql += '     ,TOP_ITEM_ID ' + char(10)
									SELECT @v_dSql += '     ,ITEM_TYPE   ' + char(10)
									SELECT @v_dSql += '     ,'+ TRY_CONVERT(NVARCHAR, @v_out_qty) +'      ' + char(10)
									SELECT @v_dSql += '     ,'+ TRY_CONVERT(NVARCHAR, @v_cell_out_qty) +' ' + char(10)
									SELECT @v_dSql += '     ,INSERT_ID, INSERT_TIME                       ' + char(10)
									SELECT @v_dSql += '     ,UPDATE_ID, UPDATE_TIME                       ' + char(10)
									SELECT @v_dSql += '     ,DATE_SEQ                        ' + char(10)
									SELECT @v_dSql += '     ,JOB_USER_ID, JOB_TIME, JOB_TYPE ' + char(10)
									SELECT @v_dSql += '  )                              ' + char(10)
									SELECT @v_dSql += '  SELECT INSTANCE_ID, FP_PLAN_ID ' + char(10)
									SELECT @v_dSql += '        ,COMPANY_ID, DIVISION_ID ' + char(10)
									SELECT @v_dSql += '        ,CATEGORY_ID             ' + char(10)
									SELECT @v_dSql += '        ,SITE_ID, PLANT_ID,ITEM_ID, OPERATION_ID, FACTORY_ID ' + char(10)
									SELECT @v_dSql += '        ,LOCATION, PRODUCTION_TYPE, MARKET ' + char(10)
									SELECT @v_dSql += '        ,LINE_ID, ELECTRODE_TYPE ' + char(10)
									SELECT @v_dSql += '        ,PLAN_DATE               ' + char(10)
									SELECT @v_dSql += '        ,TOP_ITEM_ID             ' + char(10)
									SELECT @v_dSql += '        ,ITEM_TYPE               ' + char(10)
									SELECT @v_dSql += '        ,'+ TRY_CONVERT(NVARCHAR, @v_out_qty) +'      ' + char(10)
									SELECT @v_dSql += '        ,'+ TRY_CONVERT(NVARCHAR, @v_cell_out_qty) +' ' + char(10)
									SELECT @v_dSql += '        ,INSERT_ID, INSERT_TIME ' + char(10)
									SELECT @v_dSql += '        ,UPDATE_ID, UPDATE_TIME ' + char(10)
									SELECT @v_dSql += '        ,DATE_SEQ               ' + char(10)
									SELECT @v_dSql += '        ,'''+ @v_user_id +''' , GETDATE() , ''INSERT'' ' + char(10)
									SELECT @v_dSql += '  FROM   FP_AMEND_PLAN_CELL_H                          ' + char(10)
									SELECT @v_dSql += '  WHERE  INSTANCE_ID    = '''+ @v_instance_id +'''     ' + char(10)
									SELECT @v_dSql += '  AND    FP_PLAN_ID     = '''+ @v_plan_id +'''         ' + char(10)
									SELECT @v_dSql += '  AND    DIVISION_ID    = '''+ @v_division_id +'''     ' + char(10)
									SELECT @v_dSql += '  AND    SITE_ID        = '''+ @v_site_id +'''         ' + char(10)
									SELECT @v_dSql += '  AND    PLANT_ID       = '''+ @v_plant_id +'''        ' + char(10)
									SELECT @v_dSql += '  AND    FACTORY_ID     = '''+ @v_factory_id +'''      ' + char(10)
									SELECT @v_dSql += '  AND    OPERATION_ID   = '''+ @v_operation_id +'''    ' + char(10)
									SELECT @v_dSql += '  AND    LINE_ID        = '''+ @v_line_id +'''         ' + char(10)
									SELECT @v_dSql += '  AND    ELECTRODE_TYPE = '''+ @v_electrode_type +'''  ' + char(10)
									SELECT @v_dSql += '  AND    PLAN_DATE      = CONVERT(DATE,'''+ @v_plan_date +''') ' + char(10)
									SELECT @v_dSql += '  AND    ITEM_ID        = '''+ @v_item_id +'''     ' + char(10)
									SELECT @v_dSql += '  AND    TOP_ITEM_ID    = '''+ @v_top_item_id +''' ' + char(10)

								END
						   /****************************************************************************/
						   /* INSERT_ADD_LINE  경우  : (ADD Popup)                                        */
						   /****************************************************************************/
						   ELSE IF(@v_sys_flag ='INSERT_ADD_LINE')
								BEGIN
									SELECT @v_dSql = ''
									SELECT @v_dSql += '   INSERT INTO FP_AMEND_PLAN_CELL_R ( ' + char(10)
									SELECT @v_dSql += '        INSTANCE_ID, FP_PLAN_ID       ' + char(10)
									SELECT @v_dSql += '      , COMPANY_ID, DIVISION_ID       ' + char(10)
									SELECT @v_dSql += '      , CATEGORY_ID                   ' + char(10)
									SELECT @v_dSql += '      , SITE_ID, PLANT_ID, ITEM_ID, OPERATION_ID, FACTORY_ID ' + char(10)
									SELECT @v_dSql += '      , LOCATION, PRODUCTION_TYPE, MARKET ' + char(10)
									SELECT @v_dSql += '      , LINE_ID, ELECTRODE_TYPE ' + char(10)
									SELECT @v_dSql += '      , PLAN_DATE               ' + char(10)
									SELECT @v_dSql += '      , TOP_ITEM_ID, ITEM_TYPE  ' + char(10)
									SELECT @v_dSql += '      , IN_QTY                  ' + char(10)
									SELECT @v_dSql += '      , OUT_QTY                 ' + char(10)
									SELECT @v_dSql += '      , CELL_IN_QTY             ' + char(10)
									SELECT @v_dSql += '      , CELL_OUT_QTY            ' + char(10)
									SELECT @v_dSql += '      , DATE_SEQ                ' + char(10)
									SELECT @v_dSql += '      , INSERT_ID, INSERT_TIME  ' + char(10)
									SELECT @v_dSql += '      , UPDATE_ID, UPDATE_TIME  ' + char(10)
									SELECT @v_dSql += '   )        ' + char(10)
									SELECT @v_dSql += '   VALUES ( ' + char(10)
									SELECT @v_dSql += '      '''+ @v_instance_id +''', '''+ @v_plan_id +''' ' + char(10)
									SELECT @v_dSql += '    , (SELECT DISTINCT COMPANY_ID FROM SCM_FACTORY_M WHERE DIVISION_ID = '''+ @v_division_id +''' AND SITE_ID ='''+ @v_site_id +''' AND PLANT_ID = '''+ @v_plant_id +''' AND ACTIVE_FLAG = ''Y''), '''+ @v_division_id +''' ' + char(10)
									SELECT @v_dSql += '    , ''PLAN'' ' + char(10)
									SELECT @v_dSql += '    , '''+ @v_site_id +''', '''+ @v_plant_id +''', '''+ @v_item_id +''' , '''+ @v_operation_id +''', '''+ @v_factory_id +''' ' + char(10)
									SELECT @v_dSql += '    , '''+ @v_location +''','''+ @v_prod_type +''', '''+ @v_market +''' ' + char(10)
									SELECT @v_dSql += '    , '''+ @v_line_id +''', '''+ @v_electrode_type +''' ' + char(10)
									SELECT @v_dSql += '    , CONVERT(DATE,'''+ @v_plan_date +''')              ' + char(10)
									SELECT @v_dSql += '    , '''+ @v_top_item_id +''', '''+ @v_item_type +'''  ' + char(10)
									SELECT @v_dSql += '    , CEILING(FLOOR('''+ @v_qty +''' * dbo.FN_GET_REQ_QTY_MODEL('''+ @v_plant_id +''', '''+ @v_top_item_id +''', '''+ @v_item_id +''', '''+ @v_plan_date +''')) ' + char(10)
									SELECT @v_dSql += '             / ( SELECT ISNULL( ISNULL(MAX(EEE.YIELD),(CASE WHEN MAX(YYY.YIELD) = 0 THEN 1 ELSE MAX(YYY.YIELD) END)) ,1) AS YIELD ' + char(10)
									SELECT @v_dSql += '                 FROM   SCM_YIELD_M YYY WITH(NOLOCK) ' + char(10)
									SELECT @v_dSql += '                 LEFT OUTER JOIN (                   ' + char(10)
									SELECT @v_dSql += '                 	SELECT (CASE WHEN MAX(YIELD) = 0 THEN 1 ELSE MAX(YIELD) END) AS YIELD ' + char(10)
									SELECT @v_dSql += '                 	FROM   SCM_YIELD_EXCEPT_M EE WITH(NOLOCK)          ' + char(10)
									SELECT @v_dSql += '                 	WHERE  EE.DIVISION_ID  = '''+ @v_division_id +'''  ' + char(10)
									SELECT @v_dSql += '                 	AND    EE.SITE_ID      = '''+ @v_site_id +'''      ' + char(10)
									SELECT @v_dSql += '                 	AND    EE.PLANT_ID     = '''+ @v_plant_id +'''     ' + char(10)
									SELECT @v_dSql += '                 	AND    EE.FACTORY_ID   = '''+ @v_factory_id +'''   ' + char(10)
									SELECT @v_dSql += '                 	AND    EE.OPERATION_ID = '''+ @v_operation_id +''' ' + char(10)
									SELECT @v_dSql += '                 	AND    EE.LINE_ID      = '''+ @v_line_id +'''      ' + char(10)
									SELECT @v_dSql += '                 	AND    EE.ITEM_ID      = '''+ @v_item_id +'''      ' + char(10)
									SELECT @v_dSql += '                 	AND    CONVERT(DATE,'''+ @v_plan_date +''') BETWEEN EE.START_TIME AND EE.END_TIME ' + char(10)
									SELECT @v_dSql += '                 ) EEE      ' + char(10)
									SELECT @v_dSql += '                 ON     1=1 ' + char(10)
									SELECT @v_dSql += '                 WHERE  YYY.DIVISION_ID  = '''+ @v_division_id +'''  ' + char(10)
									SELECT @v_dSql += '                 AND    YYY.SITE_ID      = '''+ @v_site_id +'''      ' + char(10)
									SELECT @v_dSql += '                 AND    YYY.PLANT_ID     = '''+ @v_plant_id +'''     ' + char(10)
									SELECT @v_dSql += '                 AND    YYY.FACTORY_ID   = '''+ @v_factory_id +'''   ' + char(10)
									SELECT @v_dSql += '                 AND    YYY.OPERATION_ID = '''+ @v_operation_id +''' ' + char(10)
									SELECT @v_dSql += '                 AND    YYY.LINE_ID      = '''+ @v_line_id +'''      ' + char(10)
									SELECT @v_dSql += '                 AND    YYY.ITEM_ID      = '''+ @v_item_id +'''      ' + char(10)
									SELECT @v_dSql += '                 AND    YYY.MONTH        = SUBSTRING('''+ @v_plan_date +''',1,6))) ' + char(10)
									SELECT @v_dSql += '    , FLOOR('''+ @v_qty +''' * dbo.FN_GET_REQ_QTY_MODEL('''+ @v_plant_id +''', '''+ @v_top_item_id +''', '''+ @v_item_id +''', '''+ @v_plan_date +''')) ' + char(10)
									SELECT @v_dSql += '    , CEILING('''+ @v_qty +''' / (  SELECT ISNULL( ISNULL(MAX(B.YIELD),(CASE WHEN MAX(A.YIELD) = 0 THEN 1 ELSE MAX(A.YIELD) END)) ,1) AS YIELD ' + char(10)
									SELECT @v_dSql += '                        FROM   SCM_YIELD_M A WITH(NOLOCK) ' + char(10)
									SELECT @v_dSql += '                        LEFT OUTER JOIN (                 ' + char(10)
									SELECT @v_dSql += '                            SELECT (CASE WHEN MAX(YIELD) = 0 THEN 1 ELSE MAX(YIELD) END) AS YIELD ' + char(10)
									SELECT @v_dSql += '                            FROM   SCM_YIELD_EXCEPT_M A WITH(NOLOCK)          ' + char(10)
									SELECT @v_dSql += '                            WHERE  A.DIVISION_ID  = '''+ @v_division_id +'''  ' + char(10)
									SELECT @v_dSql += '                            AND    A.SITE_ID      = '''+ @v_site_id +'''      ' + char(10)
									SELECT @v_dSql += '                            AND    A.PLANT_ID     = '''+ @v_plant_id +'''     ' + char(10)
									SELECT @v_dSql += '                            AND    A.FACTORY_ID   = '''+ @v_factory_id +'''   ' + char(10)
									SELECT @v_dSql += '                            AND    A.OPERATION_ID = '''+ @v_operation_id +''' ' + char(10)
									SELECT @v_dSql += '                            AND    A.LINE_ID      = '''+ @v_line_id +'''      ' + char(10)
									SELECT @v_dSql += '                            AND    A.ITEM_ID      = '''+ @v_item_id +'''      ' + char(10)
									SELECT @v_dSql += '                            AND    CONVERT(DATE,'''+ @v_plan_date +''') BETWEEN A.START_TIME AND A.END_TIME ' + char(10)
									SELECT @v_dSql += '                        ) B        ' + char(10)
									SELECT @v_dSql += '                        ON     1=1 ' + char(10)
									SELECT @v_dSql += '                        WHERE  A.DIVISION_ID  = '''+ @v_division_id +'''  ' + char(10)
									SELECT @v_dSql += '                        AND    A.SITE_ID      = '''+ @v_site_id +'''      ' + char(10)
									SELECT @v_dSql += '                        AND    A.PLANT_ID     = '''+ @v_plant_id +'''     ' + char(10)
									SELECT @v_dSql += '                        AND    A.FACTORY_ID   = '''+ @v_factory_id +'''   ' + char(10)
									SELECT @v_dSql += '                        AND    A.OPERATION_ID = '''+ @v_operation_id +''' ' + char(10)
									SELECT @v_dSql += '                        AND    A.LINE_ID      = '''+ @v_line_id +'''      ' + char(10)
									SELECT @v_dSql += '                        AND    A.ITEM_ID      = '''+ @v_item_id +'''      ' + char(10)
									SELECT @v_dSql += '                        AND    A.MONTH        = SUBSTRING('''+ @v_plan_date +''',1,6))) ' + char(10)
									SELECT @v_dSql += '    , '''+ @v_qty +''' ' + char(10)
									SELECT @v_dSql += '    , 1                ' + char(10)
									SELECT @v_dSql += '    , '''+ @v_user_id +''', dbo.FN_SITE_TIME('''+ @v_site_id +''') ' + char(10)
									SELECT @v_dSql += '    , '''+ @v_user_id +''', dbo.FN_SITE_TIME('''+ @v_site_id +''') ' + char(10)
									SELECT @v_dSql += '  ) ' + char(10)

								END
						   /****************************************************************************/
						   /* INSERT_ADD_LINE_LOG  경우  : (ADD Popup)                                        */
						   /****************************************************************************/
						   ELSE IF(@v_sys_flag ='INSERT_ADD_LINE_LOG')
								BEGIN
									SELECT @v_dSql = ''
                                    SELECT @v_dSql += ' INSERT INTO HIS_AMEND_PLAN_CELL_R ( ' + char(10)
                                    SELECT @v_dSql += '      INSTANCE_ID, FP_PLAN_ID        ' + char(10)
                                    SELECT @v_dSql += '     ,COMPANY_ID, DIVISION_ID        ' + char(10)
                                    SELECT @v_dSql += '     ,CATEGORY_ID                    ' + char(10)
                                    SELECT @v_dSql += '     ,SITE_ID, PLANT_ID, ITEM_ID, OPERATION_ID, FACTORY_ID ' + char(10)
                                    SELECT @v_dSql += '     ,LOCATION, PRODUCTION_TYPE, MARKET ' + char(10)
                                    SELECT @v_dSql += '     ,LINE_ID, ELECTRODE_TYPE ' + char(10)
                                    SELECT @v_dSql += '     ,PLAN_DATE               ' + char(10)
                                    SELECT @v_dSql += '     ,TOP_ITEM_ID             ' + char(10)
                                    SELECT @v_dSql += '     ,ITEM_TYPE               ' + char(10)
                                    SELECT @v_dSql += '     ,IN_QTY                  ' + char(10)
                                    SELECT @v_dSql += '     ,OUT_QTY                 ' + char(10)
                                    SELECT @v_dSql += '     ,CELL_IN_QTY             ' + char(10)
                                    SELECT @v_dSql += '     ,CELL_OUT_QTY            ' + char(10)
                                    SELECT @v_dSql += '     ,INSERT_ID, INSERT_TIME  ' + char(10)
                                    SELECT @v_dSql += '     ,UPDATE_ID, UPDATE_TIME  ' + char(10)
                                    SELECT @v_dSql += '     ,DATE_SEQ                ' + char(10)
                                    SELECT @v_dSql += '     ,JOB_USER_ID, JOB_TIME, JOB_TYPE ' + char(10)
                                    SELECT @v_dSql += ' )                              ' + char(10)
                                    SELECT @v_dSql += ' SELECT INSTANCE_ID, FP_PLAN_ID ' + char(10)
                                    SELECT @v_dSql += '     ,COMPANY_ID, DIVISION_ID   ' + char(10)
                                    SELECT @v_dSql += '     ,CATEGORY_ID               ' + char(10)
                                    SELECT @v_dSql += '     ,SITE_ID, PLANT_ID, ITEM_ID, OPERATION_ID, FACTORY_ID ' + char(10)
                                    SELECT @v_dSql += '     ,LOCATION, PRODUCTION_TYPE, MARKET ' + char(10)
                                    SELECT @v_dSql += '     ,LINE_ID, ELECTRODE_TYPE ' + char(10)
                                    SELECT @v_dSql += '     ,PLAN_DATE               ' + char(10)
                                    SELECT @v_dSql += '     ,TOP_ITEM_ID             ' + char(10)
                                    SELECT @v_dSql += '     ,ITEM_TYPE               ' + char(10)
                                    SELECT @v_dSql += '     ,IN_QTY                  ' + char(10)
                                    SELECT @v_dSql += '     ,OUT_QTY                 ' + char(10)
                                    SELECT @v_dSql += '     ,CELL_IN_QTY             ' + char(10)
                                    SELECT @v_dSql += '     ,CELL_OUT_QTY            ' + char(10)
                                    SELECT @v_dSql += '     ,INSERT_ID, INSERT_TIME  ' + char(10)
                                    SELECT @v_dSql += '     ,UPDATE_ID, UPDATE_TIME  ' + char(10)
                                    SELECT @v_dSql += '     ,DATE_SEQ                ' + char(10)
                                    SELECT @v_dSql += '     ,'''+ @v_user_id +''' AS JOB_USER_ID, GETDATE() AS JOB_TIME, ''LINE_ADD'' AS JOB_TYPE ' + char(10)
                                    SELECT @v_dSql += ' FROM   FP_AMEND_PLAN_CELL_R A WITH(NOLOCK)            ' + char(10)
                                    SELECT @v_dSql += ' WHERE  A.INSTANCE_ID      = '''+ @v_instance_id +'''  ' + char(10)
                                    SELECT @v_dSql += ' AND    A.FP_PLAN_ID       = '''+ @v_plan_id +'''      ' + char(10)
                                    SELECT @v_dSql += ' AND    A.DIVISION_ID      = '''+ @v_division_id +'''  ' + char(10)
                                    SELECT @v_dSql += ' AND    A.CATEGORY_ID      = ''PLAN''                  ' + char(10)
                                    SELECT @v_dSql += ' AND    A.SITE_ID          = '''+ @v_site_id +'''      ' + char(10)
                                    SELECT @v_dSql += ' AND    A.PLANT_ID         = '''+ @v_plant_id +'''     ' + char(10)
                                    SELECT @v_dSql += ' AND    A.TOP_ITEM_ID      = '''+ @v_top_item_id +'''  ' + char(10)
                                    SELECT @v_dSql += ' AND    A.ITEM_ID          = '''+ @v_item_id +'''      ' + char(10)
                                    SELECT @v_dSql += ' AND    A.OPERATION_ID     = '''+ @v_operation_id +''' ' + char(10)
                                    SELECT @v_dSql += ' AND    A.FACTORY_ID       = '''+ @v_factory_id +'''   ' + char(10)
                                    SELECT @v_dSql += ' AND    A.LOCATION         = '''+ @v_location +'''     ' + char(10)
                                    SELECT @v_dSql += ' AND    A.PRODUCTION_TYPE  = '''+ @v_prod_type +'''    ' + char(10)
                                    SELECT @v_dSql += ' AND    A.MARKET           = '''+ @v_market +'''       ' + char(10)
                                    SELECT @v_dSql += ' AND    A.LINE_ID          = '''+ @v_line_id +'''      ' + char(10)
                                    SELECT @v_dSql += ' AND    A.ELECTRODE_TYPE   = '''+ @v_electrode_type +'''          ' + char(10)
                                    SELECT @v_dSql += ' AND    A.PLAN_DATE        = CONVERT(DATE,'''+ @v_plan_date +''') ' + char(10)

								END

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

			END --(END)
 	
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

