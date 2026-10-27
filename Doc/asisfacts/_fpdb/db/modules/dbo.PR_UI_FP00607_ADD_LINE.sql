




/*
 * Program ID   : PR_UI_FP00607_ADD_LINE
 * Description  : Plan Amend Line Formation
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/05/11   JYJ				Initial Release UI통합
 * 2024/04/17   leejsthira2		item 팝업에서 formation flow id 조건이 cell group 에 걸린것을 item 에 걸리도록 변경
 */

CREATE PROCEDURE [dbo].[PR_UI_FP00607_ADD_LINE]
  @p_sys_type            NVARCHAR(MAX),
  @p_sys_flag            NVARCHAR(MAX),
  @p_sys_gubun           NVARCHAR(MAX),
  @p_user_id             NVARCHAR(MAX),
  @p_instance_id         NVARCHAR(MAX),
  @p_date                NVARCHAR(MAX),
  @p_plan_id             NVARCHAR(MAX), 
  @p_division_id         NVARCHAR(MAX),
  @p_site_id             NVARCHAR(MAX),
  @p_plant_id            NVARCHAR(MAX),
  @p_factory_id          NVARCHAR(MAX),
  @p_line_id             NVARCHAR(MAX),
  @p_operation_id        NVARCHAR(MAX),
  @p_from_operation_id   NVARCHAR(MAX),
  @p_item_id             NVARCHAR(MAX),
  @p_top_item_id         NVARCHAR(MAX),
  @p_item_type           NVARCHAR(MAX),
  @p_location            NVARCHAR(MAX),
  @p_prod_type           NVARCHAR(MAX),
  @p_electrode_type      NVARCHAR(MAX),
  @p_cell_group_code     NVARCHAR(MAX),
  @p_nick_name           NVARCHAR(MAX),
  @p_qty                 NVARCHAR(MAX),
  @p_mpp_wpp             NVARCHAR(MAX)
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
    DECLARE @v_date                 NVARCHAR(MAX)
    DECLARE @v_plan_id              NVARCHAR(MAX)
    DECLARE @v_division_id          NVARCHAR(MAX)
    DECLARE @v_site_id              NVARCHAR(MAX)
    DECLARE @v_plant_id             NVARCHAR(MAX)
    DECLARE @v_factory_id           NVARCHAR(MAX)
    DECLARE @v_line_id              NVARCHAR(MAX)
    DECLARE @v_operation_id         NVARCHAR(MAX)
	DECLARE @v_from_operation_id    NVARCHAR(MAX)
    DECLARE @v_item_id              NVARCHAR(MAX)
    DECLARE @v_top_item_id          NVARCHAR(MAX)
	DECLARE @v_item_type            NVARCHAR(MAX)
    DECLARE @v_location             NVARCHAR(MAX)
    DECLARE @v_prod_type            NVARCHAR(MAX)
    DECLARE @v_electrode_type       NVARCHAR(MAX)
    DECLARE @v_cell_group_code      NVARCHAR(MAX)
    DECLARE @v_nick_name            NVARCHAR(MAX)
    DECLARE @v_qty                  NVARCHAR(MAX)
    DECLARE @v_mpp_wpp              NVARCHAR(MAX)


	DECLARE @recv_active_flag       NVARCHAR(MAX)				    
	DECLARE @v_proc_name	        NVARCHAR(100) = 'PR_UI_FP00607_ADD_LINE'
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


	SET @v_sys_type                 = ''
	SET @v_sys_flag                 = ''
	SET @v_sys_gubun                = ''
	SET @v_user_id                  = ''
    SET @v_instance_id              = ''
    SET @v_date                     = ''
    SET @v_plan_id                  = ''  
    SET @v_division_id              = ''
    SET @v_site_id                  = ''
    SET @v_plant_id                 = ''
    SET @v_factory_id               = ''
    SET @v_line_id                  = ''
    SET @v_operation_id             = ''
    SET @v_item_id                  = ''
    SET @v_top_item_id              = '' 
	SET @v_item_type                = '' 
    SET @v_location                 = ''
    SET @v_prod_type                = ''
    SET @v_electrode_type           = ''
    SET @v_cell_group_code          = ''
    SET @v_nick_name                = ''
    SET @v_mpp_wpp                  = ''


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
	/* SELECT인경우 :SELECT(SELECT)                                                                      */
	/************************************************************************************************/
    IF(@p_sys_flag ='SELECT_ITEM_POPUP')
		BEGIN --ELSE IF(START)
		    -- 20230702 Assy / Product 관련 수정
		    SELECT @v_dSql = ''
		    SELECT @v_dSql += ' SELECT A.DIVISION_ID, A.SITE_ID, A.PLANT_ID,A.MODEL_ID, A.ITEM_ID,X.ITEM_CLASS, A.NICK_NAME,'+ char(10)
		    SELECT @v_dSql += '(CASE WHEN LEFT(X.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME '+ char(10)
		    SELECT @v_dSql += 'WHEN LEFT(X.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'') '+ char(10)
		    SELECT @v_dSql += 'ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE,CELL_GROUP_CODE'+ char(10)
		    SELECT @v_dSql += 'FROM ('+ char(10)
			
            SELECT @v_dSql += ' SELECT DISTINCT A.DIVISION_ID, A.SITE_ID, B.PLANT_ID' + char(10)
            -- 20230702 ITEM_ID,MODEL_ID는 A9000의 경우 PROD - ASSY MAP 테이블에서 가져옴
			SELECT @v_dSql += ',' + char(10)
			SELECT @v_dSql += ' (CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN CELLMAP.CELL_PRODUCT_ITEM_ID' + char(10)
			SELECT @v_dSql += ' ELSE A.ITEM_ID END) AS MODEL_ID' + char(10)
			SELECT @v_dSql += ',' + char(10)
			SELECT @v_dSql += ' (CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN CELLMAP.CELL_ASSY_ITEM_ID' + char(10)
			SELECT @v_dSql += ' ELSE A.ITEM_ID END) AS ITEM_ID' + char(10)
			SELECT @v_dSql += ',' + char(10)

            SELECT @v_dSql += 'ISNULL(A.NICK_NAME,''-'') AS NICK_NAME ' + char(10)
            -- 20230702 ITEM_TYPE은 최종 ITEM_ID  기준으로 변경
			--SELECT @v_dSql += '      (CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME ' + char(10)
            --SELECT @v_dSql += '            WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'') ' + char(10)
            --SELECT @v_dSql += '            ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE             ' + char(10)
            SELECT @v_dSql += '      , ISNULL(E.GROUP_ITEM_ID, A.ITEM_ID) AS CELL_GROUP_CODE ' + char(10)
            SELECT @v_dSql += ' FROM   SCM_ITEM_M A WITH(NOLOCK)                             ' + char(10)
            SELECT @v_dSql += '        LEFT OUTER JOIN (                                     ' + char(10)
            SELECT @v_dSql += '              SELECT A.SEGMENT1 AS SITE_ID, A.SEGMENT2 AS DIVISION_ID, A.SEGMENT3 AS GROUP_ITEM_ID, A.SEGMENT4 AS ITEM_ID, A.SORT_ORDER ' + char(10)
            SELECT @v_dSql += '              FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)        ' + char(10)
            SELECT @v_dSql += '              WHERE  A.LOOKUP_TYPE_CODE = ''MODULE_CELL_GROUP'' ' + char(10)
            SELECT @v_dSql += '              AND    A.ACTIVE_FLAG = ''Y''   ' + char(10)
            SELECT @v_dSql += '         ) E                                 ' + char(10)
            SELECT @v_dSql += '         ON  A.DIVISION_ID = E.DIVISION_ID   ' + char(10)
            SELECT @v_dSql += '         AND A.SITE_ID = E.SITE_ID           ' + char(10)
            SELECT @v_dSql += '         AND A.ITEM_ID = E.ITEM_ID           ' + char(10)

			 -- 20230702 FP_CELL_ASSY_PRODUCT_MAP_V 바인딩
            SELECT @v_dSql += 'LEFT OUTER JOIN' + char(10)
            SELECT @v_dSql += 'FP_CELL_ASSY_PRODUCT_MAP_V CELLMAP WITH(NOLOCK) ON' + char(10)
            SELECT @v_dSql += 'CELLMAP.DIVISION_ID = A.DIVISION_ID' + char(10)
            SELECT @v_dSql += 'AND    CELLMAP.SITE_ID = A.SITE_ID' + char(10)
            SELECT @v_dSql += 'AND    CELLMAP.CELL_PRODUCT_ITEM_ID = A.ITEM_ID' + char(10)

            SELECT @v_dSql += '        , SCM_MODEL_COMP_TEMP B WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += '        , SCM_ITEM_CLASS_M C WITH(NOLOCK)    ' + char(10)
			-- item 팝업에서 formation flow id 조건이 cell group 에 걸린것을 item 에 걸리도록 변경.. 20240417
			/*
            SELECT @v_dSql += '        , (                                  ' + char(10)
            SELECT @v_dSql += '           SELECT DISTINCT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.OPERATION_ID       ' + char(10)
            SELECT @v_dSql += '           FROM   FP_INSTANCE_OPERATION_V A WITH(NOLOCK), SCM_OPERATION_M B WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += '           WHERE  A.COMPANY_ID   = B.COMPANY_ID               ' + char(10)
            SELECT @v_dSql += '           AND    A.DIVISION_ID  = B.DIVISION_ID              ' + char(10)
            SELECT @v_dSql += '           AND    A.SITE_ID      = B.SITE_ID                  ' + char(10)
            SELECT @v_dSql += '           AND    A.OPERATION_ID = B.OPERATION_ID             ' + char(10)
            SELECT @v_dSql += '           AND    A.INSTANCE_ID  = ''' + @p_instance_id + ''' ' + char(10)
            SELECT @v_dSql += '           AND    A.AMEND_FLAG   = ''Y'' ' + char(10)
            SELECT @v_dSql += '           AND    B.ACTIVE_FLAG  = ''Y'' ' + char(10)
            SELECT @v_dSql += '        ) D                              ' + char(10)
			*/
            SELECT @v_dSql += ' WHERE  A.COMPANY_ID  = B.COMPANY_ID     ' + char(10)
            SELECT @v_dSql += ' AND   A.DIVISION_ID = B.DIVISION_ID     ' + char(10)
            SELECT @v_dSql += ' AND   A.SITE_ID     = B.SITE_ID         ' + char(10)
            SELECT @v_dSql += ' AND   A.ITEM_ID     = B.CHILD_ITEM_ID   ' + char(10)
            SELECT @v_dSql += ' AND   A.ITEM_CLASS  = C.CLASS_ID        ' + char(10)
			-- item 팝업에서 formation flow id 조건이 cell group 에 걸린것을 item 에 걸리도록 변경.. 20240417
			/*
            SELECT @v_dSql += ' AND   A.COMPANY_ID  = D.COMPANY_ID      ' + char(10)
            SELECT @v_dSql += ' AND   A.DIVISION_ID = D.DIVISION_ID     ' + char(10)
            SELECT @v_dSql += ' AND   A.SITE_ID     = D.SITE_ID         ' + char(10)
			
		    IF ( LEN(@p_from_operation_id) > 0)
		        BEGIN 
			        SELECT @v_dSql += ' AND  A.FORMATION_FLOW_ID LIKE ''%'' + D.OPERATION_ID + ''%''  ' + char(10)
			    END
			ELSE
		        BEGIN 
			        SELECT @v_dSql += ' AND   A.FLOW_ID LIKE ''%'' + D.OPERATION_ID + ''%''  ' + char(10)
			    END
			*/

            IF ( LEN(@p_cell_group_code) > 0)
		        BEGIN 
			        SELECT @v_dSql += ' AND	 ISNULL(E.GROUP_ITEM_ID, A.ITEM_ID) LIKE ''%'' + '''+ @p_cell_group_code +''' + ''%''  ' + char(10)
			    END

            IF ( LEN(@p_item_id) > 0)
		        BEGIN 
			        SELECT @v_dSql += ' AND	 A.ITEM_ID  LIKE ''%'' + '''+ @p_item_id +''' + ''%''     ' + char(10)
			    END

		    IF ( LEN(@p_nick_name) > 0)
		        BEGIN 
			        SELECT @v_dSql += ' AND	 A.NICK_NAME  LIKE ''%'' + '''+ @p_nick_name +''' + ''%''  ' + char(10)
			    END
		    
            SELECT @v_dSql += ' AND    EXISTS (	SELECT 	1                                             ' + char(10)
            SELECT @v_dSql += '                   FROM   FP_INSTANCE_FACTORY_M FF WITH(NOLOCK)        ' + char(10)
            SELECT @v_dSql += '                         ,SCM_FACTORY_M         F  WITH(NOLOCK)        ' + char(10)
            SELECT @v_dSql += '                   WHERE  FF.FACTORY_ID   = F.FACTORY_ID               ' + char(10)
            SELECT @v_dSql += '                   AND    FF.INSTANCE_ID  = ''' + @p_instance_id + ''' ' + char(10)
            SELECT @v_dSql += '                   AND    F.COMPANY_ID    = A.COMPANY_ID               ' + char(10)
            SELECT @v_dSql += '                   AND    F.DIVISION_ID   = A.DIVISION_ID              ' + char(10)
            SELECT @v_dSql += '                   AND    F.SITE_ID       = A.SITE_ID	              ' + char(10)
            SELECT @v_dSql += '               )                                                       ' + char(10)
            SELECT @v_dSql += ' AND  EXISTS (                                                         ' + char(10)
            SELECT @v_dSql += '              SELECT 1                                                 ' + char(10)
            SELECT @v_dSql += '              FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)                ' + char(10)
            SELECT @v_dSql += '              WHERE  A.COMPANY_ID     = B.COMPANY_ID                   ' + char(10)
            SELECT @v_dSql += '              AND    A.DIVISION_ID    = B.DIVISION_ID                  ' + char(10)
            SELECT @v_dSql += '              AND    A.SITE_ID        = B.SITE_ID                      ' + char(10)
            SELECT @v_dSql += '              AND    B.USER_ID        = ''' + @p_user_id + '''         ' + char(10)
            SELECT @v_dSql += '              AND	   B.SAVE_FLAG	  = ''Y''                         ' + char(10)
            SELECT @v_dSql += ' 		   )                                                          ' + char(10)
			
			
			-- 20230702 ORDER 조정
            --SELECT @v_dSql += ' ORDER BY A.DIVISION_ID, A.SITE_ID, B.PLANT_ID, A.ITEM_ID, ISNULL(A.NICK_NAME,''-''), ITEM_TYPE ' + char(10)

			-- 20230702 최종 결과 기준으로 표시
			SELECT @v_dSql += ' ) A' + char(10)
			SELECT @v_dSql += 'INNER JOIN SCM_ITEM_M X WITH(NOLOCK)' + char(10)
			SELECT @v_dSql += ' ON 1=1' + char(10)
			SELECT @v_dSql += ' AND A.DIVISION_ID    = X.DIVISION_ID ' + char(10)
			SELECT @v_dSql += ' AND A.SITE_ID        = X.SITE_ID ' + char(10)
			SELECT @v_dSql += ' AND A.ITEM_ID = X.ITEM_ID' + char(10)
			SELECT @v_dSql += ' INNER JOIN SCM_ITEM_CLASS_M C WITH(NOLOCK)' + char(10)
			SELECT @v_dSql += ' ON X.ITEM_CLASS = C.CLASS_ID' + char(10)
			-- item 팝업에서 formation flow id 조건이 cell group 에 걸린것을 item 에 걸리도록 변경.. 20240417
			SELECT @v_dSql += ' , ( ' + char(10)
			SELECT @v_dSql += '     SELECT DISTINCT B.DIVISION_ID, B.SITE_ID, B.OPERATION_ID ' + char(10)
			SELECT @v_dSql += '     FROM   FP_INSTANCE_OPERATION_V A WITH(NOLOCK), SCM_OPERATION_M B WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += '     WHERE  A.COMPANY_ID   = B.COMPANY_ID ' + char(10)
			SELECT @v_dSql += '     AND    A.DIVISION_ID  = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql += '     AND    A.SITE_ID      = B.SITE_ID ' + char(10)
			SELECT @v_dSql += '     AND    A.OPERATION_ID = B.OPERATION_ID ' + char(10)
			SELECT @v_dSql += '     AND    A.INSTANCE_ID  = ''' + @p_instance_id + ''' ' + char(10)
			SELECT @v_dSql += '     AND    A.AMEND_FLAG   = ''Y'' ' + char(10)
			SELECT @v_dSql += '     AND    B.ACTIVE_FLAG  = ''Y'' ' + char(10)
			SELECT @v_dSql += ' 	GROUP BY B.DIVISION_ID, B.SITE_ID, B.OPERATION_ID ' + char(10)
			SELECT @v_dSql += ' ) D ' + char(10)
			SELECT @v_dSql += ' WHERE 1=1 ' + char(10)
			SELECT @v_dSql += ' AND   X.DIVISION_ID = D.DIVISION_ID ' + char(10)
			SELECT @v_dSql += ' AND   X.SITE_ID     = D.SITE_ID ' + char(10)
		    IF ( LEN(@p_from_operation_id) > 0)
		    BEGIN 
			    SELECT @v_dSql += ' AND  X.FORMATION_FLOW_ID LIKE ''%'' + D.OPERATION_ID + ''%''  ' + char(10)
			END
			ELSE
		    BEGIN 
			    SELECT @v_dSql += ' AND   X.FLOW_ID LIKE ''%'' + D.OPERATION_ID + ''%''  ' + char(10)
			END

			SELECT @v_dSql += ' ORDER BY  A.DIVISION_ID, A.SITE_ID, A.PLANT_ID,A.MODEL_ID, A.ITEM_ID, A.NICK_NAME, ITEM_TYPE' + char(10)

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
	    END	--ELSE IF( END )
	/****************************************************************************/
	/* EXECUTE  경우  :  EXEC_SIMULATION                                           */
	/****************************************************************************/
	ELSE IF(@p_sys_flag ='EXEC_SIMULATION')
         BEGIN
		    SET @runstart = GETDATE()
			SELECT @v_dSql = '[dbo].[PR_SCM_OF_PSI_SHORTER_LT_SIM_CALL] '''+ @p_instance_id +''', '''+ @p_plan_id +''' '
		    EXEC PR_UI_SQL_LOG  @v_proc_name,  @v_user_id, @p_sys_flag,'', @v_dSql,'SELECT(START)',@runstart, @runend
			
			--실제수행
			EXEC  @rtnCount = [dbo].[PR_SCM_OF_PSI_SHORTER_LT_SIM_CALL] @v_instance_id, @v_plan_id

			SET @runend = GETDATE()
			EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id, @p_sys_flag,'', @v_dSql,'SELECT',@runstart, @runend
			--SET @rtnCount = 1
			SELECT	'Result' = @rtnCount

         END
    ELSE
		/************************************************************************************************/
		/* SAVE인경우 :SAVE                                                                      */
		/************************************************************************************************/
		-- 트랜잭션 (TRAN)
		BEGIN TRY				                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
		BEGIN TRAN   

		BEGIN --( BEGIN )

             /****************************************************************************/
             /* INSERT_LINE  저장 경우  :                                               */
             /****************************************************************************/
             IF(@p_sys_flag ='INSERT_LINE')
                
                BEGIN
             		--SELECT @v_dSql = ''
               --      SELECT @v_dSql += ' INSERT INTO FP_AMEND_PLAN_FORM_R (  ' + char(10)
               --      SELECT @v_dSql += '       INSTANCE_ID, FP_PLAN_ID       ' + char(10)
               --      SELECT @v_dSql += '     , COMPANY_ID                    ' + char(10)
               --      SELECT @v_dSql += '     , DIVISION_ID                   ' + char(10)
               --      SELECT @v_dSql += '     , CATEGORY_ID                   ' + char(10)
               --      SELECT @v_dSql += '     , SITE_ID, PLANT_ID             ' + char(10)
               --      SELECT @v_dSql += '     , ITEM_ID, OPERATION_ID, FACTORY_ID, LOCATION ' + char(10)
               --      SELECT @v_dSql += '     , PRODUCTION_TYPE, MARKET       ' + char(10)
               --      SELECT @v_dSql += '     , LINE_ID, ELECTRODE_TYPE       ' + char(10)
               --      SELECT @v_dSql += '     , CUSTOMER_ID                   ' + char(10)
               --      SELECT @v_dSql += '     , PLAN_DATE                     ' + char(10)
               --      SELECT @v_dSql += '     , TOP_ITEM_ID, ITEM_TYPE        ' + char(10)
               --      SELECT @v_dSql += '     , CELL_GROUP_CODE               ' + char(10)
               --      SELECT @v_dSql += '     , IN_QTY                        ' + char(10)
               --      SELECT @v_dSql += '     , OUT_QTY                       ' + char(10)
               --      SELECT @v_dSql += '     , INSERT_ID, INSERT_TIME        ' + char(10)
               --      SELECT @v_dSql += '     , UPDATE_ID, UPDATE_TIME        ' + char(10)
               --      SELECT @v_dSql += ' )                                   ' + char(10)
               --      SELECT @v_dSql += ' VALUES (                            ' + char(10)
               --      SELECT @v_dSql += '       '''+ @p_instance_id +''', '''+ @p_plan_id +'''   ' + char(10)
               --      SELECT @v_dSql += '     , (SELECT MAX(COMPANY_ID) FROM SCM_FACTORY_M WHERE FACTORY_ID = '''+ @p_factory_id +''' AND  ACTIVE_FLAG = ''Y'') ' + char(10)
               --      SELECT @v_dSql += '     , '''+ @p_division_id +'''                          ' + char(10)
               --      SELECT @v_dSql += '     , ''PLAN''                                          ' + char(10)
               --      SELECT @v_dSql += '     , '''+ @p_site_id +''', '''+ @p_plant_id +'''       ' + char(10)
               --      SELECT @v_dSql += '     , '''+ @p_item_id +''', '''+ @p_operation_id +''', '''+ @p_factory_id +''', '''+ @p_location +''' ' + char(10)
               --      SELECT @v_dSql += '     , ''-'', ''D''                                      ' + char(10)
               --      SELECT @v_dSql += '     , '''+ @p_line_id +''', '''+ @p_electrode_type +''' ' + char(10)
               --      SELECT @v_dSql += '     , ''-''                                             ' + char(10)
               --      SELECT @v_dSql += '     , CONVERT(DATE,'''+ @p_date +''')                   ' + char(10)
               --      SELECT @v_dSql += '     , '''+ @p_top_item_id +''', '''+ @p_item_type +'''              ' + char(10)
               --      SELECT @v_dSql += '     , ISNULL( (	SELECT DISTINCT A.SEGMENT3 AS GROUP_ITEM_ID      ' + char(10)
               --      SELECT @v_dSql += '     			FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)           ' + char(10)
               --      SELECT @v_dSql += '     			WHERE  A.LOOKUP_TYPE_CODE = ''MODULE_CELL_GROUP''    ' + char(10)
               --      SELECT @v_dSql += '     			AND    A.ACTIVE_FLAG = ''Y''                         ' + char(10)
               --      SELECT @v_dSql += '     			AND    A.SEGMENT2 = '''+ @p_division_id +'''         ' + char(10)
               --      SELECT @v_dSql += '     			AND    A.SEGMENT1 = '''+ @p_site_id +'''             ' + char(10)
               --      SELECT @v_dSql += '     			AND    A.SEGMENT4 = '''+ @p_item_id +'''             ' + char(10)
               --      SELECT @v_dSql += '     		 ), '''+ @p_item_id +''' )                               ' + char(10)
               --      SELECT @v_dSql += '     , CEILING('''+ @p_qty +'''                                      ' + char(10)
               --      SELECT @v_dSql += '         / ( SELECT ISNULL( ISNULL(MAX(B.YIELD),(CASE WHEN MAX(A.YIELD) = 0 THEN 1 ELSE MAX(A.YIELD) END)) ,1) AS YIELD ' + char(10)
               --      SELECT @v_dSql += '             FROM   SCM_YIELD_M A WITH(NOLOCK)                       ' + char(10)
               --      SELECT @v_dSql += '             LEFT OUTER JOIN (                                       ' + char(10)
               --      SELECT @v_dSql += '                   SELECT (CASE WHEN MAX(YIELD) = 0 THEN 1 ELSE MAX(YIELD) END) AS YIELD ' + char(10)
               --      SELECT @v_dSql += '                   FROM   SCM_YIELD_EXCEPT_M A WITH(NOLOCK)          ' + char(10)
               --      SELECT @v_dSql += '                   WHERE  A.DIVISION_ID  = '''+ @p_division_id +'''  ' + char(10)
               --      SELECT @v_dSql += '                   AND    A.SITE_ID      = '''+ @p_site_id +'''      ' + char(10)
               --      SELECT @v_dSql += '                   AND    A.PLANT_ID     = '''+ @p_plant_id +'''     ' + char(10)
               --      SELECT @v_dSql += '                   AND    A.FACTORY_ID   = '''+ @p_factory_id +'''   ' + char(10)
               --      SELECT @v_dSql += '                   AND    A.OPERATION_ID = '''+ @p_operation_id +''' ' + char(10)
               --      SELECT @v_dSql += '                   AND    A.LINE_ID      = '''+ @p_line_id +'''      ' + char(10)
               --      SELECT @v_dSql += '                   AND    A.ITEM_ID      = '''+ @p_item_id +'''      ' + char(10)
               --      SELECT @v_dSql += '                   AND    CONVERT(DATE,'''+ @p_date +''') BETWEEN A.START_TIME AND A.END_TIME ' + char(10)
               --      SELECT @v_dSql += '             ) B                                                        ' + char(10)
               --      SELECT @v_dSql += '             ON     1=1                                                 ' + char(10)
               --      SELECT @v_dSql += '             WHERE  A.DIVISION_ID  = '''+ @p_division_id +'''           ' + char(10)
               --      SELECT @v_dSql += '             AND    A.SITE_ID      = '''+ @p_site_id +'''               ' + char(10)
               --      SELECT @v_dSql += '             AND    A.PLANT_ID     = '''+ @p_plant_id +'''              ' + char(10)
               --      SELECT @v_dSql += '             AND    A.FACTORY_ID   = '''+ @p_factory_id +'''            ' + char(10)
               --      SELECT @v_dSql += '             AND    A.OPERATION_ID = '''+ @p_operation_id +'''          ' + char(10)
               --      SELECT @v_dSql += '             AND    A.LINE_ID      = '''+ @p_line_id +'''               ' + char(10)
               --      SELECT @v_dSql += '             AND    A.ITEM_ID      = '''+ @p_item_id +'''               ' + char(10)
               --      SELECT @v_dSql += '             AND    A.MONTH        = SUBSTRING('''+ @p_date +''',1,6))) ' + char(10)
               --      SELECT @v_dSql += '     , '''+ @p_qty+'''                                                  ' + char(10)
               --      SELECT @v_dSql += '     , '''+ @p_user_id +''', dbo.FN_SITE_TIME('''+ @p_site_id +''')     ' + char(10)
               --      SELECT @v_dSql += '     , '''+ @p_user_id +''', dbo.FN_SITE_TIME('''+ @p_site_id +''')     ' + char(10)
               --      SELECT @v_dSql += ' )                                                                      ' + char(10)
					 
					SELECT @v_dSql = ''
                    SELECT @v_dSql += ' MERGE INTO FP_AMEND_PLAN_FORM_R A ' + char(10)
                    SELECT @v_dSql += '    USING (SELECT '''+ @p_instance_id +''' AS INSTANCE_ID, '''+ @p_plan_id +''' AS FP_PLAN_ID, ' + char(10)
                    SELECT @v_dSql += '               '''+ @p_division_id +''' AS DIVISION_ID, ''PLAN'' AS CATEGORY_ID, '''+ @p_site_id +''' AS SITE_ID, '''+ @p_plant_id +''' AS PLANT_ID, ' + char(10)
                    SELECT @v_dSql += '               '''+ @p_item_id +''' AS ITEM_ID, '''+ @p_operation_id +''' AS OPERATION_ID,      ' + char(10)
                    SELECT @v_dSql += '               UPPER(''-'') AS PRODUCTION_TYPE, ''D'' AS MARKET, ' + char(10)
                    SELECT @v_dSql += '               '''+ @p_line_id +''' AS LINE_ID, ''-'' AS CUSTOMER_ID, '''+ @p_date +''' AS PLAN_DATE, '''+ @p_top_item_id +''' AS TOP_ITEM_ID ) B ' + char(10)
                    SELECT @v_dSql += '    ON (  A.INSTANCE_ID = B.INSTANCE_ID AND A.FP_PLAN_ID = B.FP_PLAN_ID ' + char(10)
                    SELECT @v_dSql += '          AND A.DIVISION_ID = B.DIVISION_ID AND A.CATEGORY_ID = B.CATEGORY_ID AND A.SITE_ID = B.SITE_ID AND A.PLANT_ID = B.PLANT_ID ' + char(10) 
                    SELECT @v_dSql += '          AND A.ITEM_ID = B.ITEM_ID AND A.OPERATION_ID = B.OPERATION_ID     ' + char(10)
                    SELECT @v_dSql += '          AND A.PRODUCTION_TYPE = B.PRODUCTION_TYPE AND A.MARKET = B.MARKET ' + char(10)
                    SELECT @v_dSql += '          AND A.LINE_ID = B.LINE_ID AND A.CUSTOMER_ID = B.CUSTOMER_ID       ' + char(10)
                    SELECT @v_dSql += '          AND CONVERT(VARCHAR,A.PLAN_DATE,112) = B.PLAN_DATE AND A.TOP_ITEM_ID = B.TOP_ITEM_ID ' + char(10)
                    SELECT @v_dSql += ' )                 ' + char(10)
                    SELECT @v_dSql += ' WHEN MATCHED THEN ' + char(10)
                    SELECT @v_dSql += '   UPDATE SET OUT_QTY = '''+ @p_qty +'''        ' + char(10)
					SELECT @v_dSql += '           , IN_QTY  = CEILING('''+ @p_qty +''' ' + char(10)
                    SELECT @v_dSql += '             / ( SELECT ISNULL( ISNULL(MAX(B.YIELD),(CASE WHEN MAX(A.YIELD) = 0 THEN 1 ELSE MAX(A.YIELD) END)) ,1) AS YIELD ' + char(10)
                    SELECT @v_dSql += '                 FROM   SCM_YIELD_M A WITH(NOLOCK) ' + char(10)
                    SELECT @v_dSql += '                 LEFT OUTER JOIN (                 ' + char(10)
                    SELECT @v_dSql += '                        SELECT (CASE WHEN MAX(YIELD) = 0 THEN 1 ELSE MAX(YIELD) END) AS YIELD ' + char(10)
                    SELECT @v_dSql += '                        FROM   SCM_YIELD_EXCEPT_M A WITH(NOLOCK)          ' + char(10)
                    SELECT @v_dSql += '                        WHERE  A.DIVISION_ID  = '''+ @p_division_id +'''  ' + char(10)
                    SELECT @v_dSql += '                        AND    A.SITE_ID      = '''+ @p_site_id +'''      ' + char(10)
                    SELECT @v_dSql += '                        AND    A.PLANT_ID     = '''+ @p_plant_id +'''     ' + char(10)
                    SELECT @v_dSql += '                        AND    A.FACTORY_ID   = '''+ @p_factory_id +'''   ' + char(10)
                    SELECT @v_dSql += '                        AND    A.OPERATION_ID = '''+ @p_operation_id +''' ' + char(10)
                    SELECT @v_dSql += '                        AND    A.LINE_ID      = '''+ @p_line_id +'''      ' + char(10)
                    SELECT @v_dSql += '                        AND    A.ITEM_ID      = '''+ @p_item_id +'''      ' + char(10)
                    SELECT @v_dSql += '                        AND    CONVERT(DATE,'''+ @p_date +''') BETWEEN A.START_TIME AND A.END_TIME ' + char(10)
                    SELECT @v_dSql += '                 ) B        ' + char(10)
                    SELECT @v_dSql += '                 ON     1=1 ' + char(10)
                    SELECT @v_dSql += '                 WHERE  A.DIVISION_ID  = '''+ @p_division_id +'''  ' + char(10)
                    SELECT @v_dSql += '                 AND    A.SITE_ID      = '''+ @p_site_id +'''      ' + char(10)
                    SELECT @v_dSql += '                 AND    A.PLANT_ID     = '''+ @p_plant_id +'''     ' + char(10)
                    SELECT @v_dSql += '                 AND    A.FACTORY_ID   = '''+ @p_factory_id +'''   ' + char(10)
                    SELECT @v_dSql += '                 AND    A.OPERATION_ID = '''+ @p_operation_id +''' ' + char(10)
                    SELECT @v_dSql += '                 AND    A.LINE_ID      = '''+ @p_line_id +'''      ' + char(10)
                    SELECT @v_dSql += '                 AND    A.ITEM_ID      = '''+ @p_item_id +'''      ' + char(10)
                    SELECT @v_dSql += '                 AND    A.MONTH        = SUBSTRING('''+ @p_date +''',1,6))) ' + char(10)
                    SELECT @v_dSql += '           , PRODUCTION_TYPE = UPPER(''-'')                     ' + char(10)
                    SELECT @v_dSql += '           , UPDATE_ID = '''+ @p_user_id +''', UPDATE_TIME = dbo.FN_SITE_TIME('''+ @p_site_id +''') ' + char(10)
                    SELECT @v_dSql += ' WHEN NOT MATCHED THEN           ' + char(10)
                    SELECT @v_dSql += '     INSERT (                    ' + char(10)
                    SELECT @v_dSql += '         INSTANCE_ID, FP_PLAN_ID ' + char(10)
                    SELECT @v_dSql += '        ,COMPANY_ID              ' + char(10)
                    SELECT @v_dSql += '        ,DIVISION_ID             ' + char(10)
                    SELECT @v_dSql += '        ,CATEGORY_ID             ' + char(10)
                    SELECT @v_dSql += '        ,SITE_ID, PLANT_ID       ' + char(10)
                    SELECT @v_dSql += '        ,ITEM_ID, OPERATION_ID, FACTORY_ID, LOCATION ' + char(10)
                    SELECT @v_dSql += '        ,PRODUCTION_TYPE, MARKET ' + char(10)
                    SELECT @v_dSql += '        ,LINE_ID, ELECTRODE_TYPE ' + char(10)
                    SELECT @v_dSql += '        ,CUSTOMER_ID             ' + char(10)
                    SELECT @v_dSql += '        ,PLAN_DATE               ' + char(10)
                    SELECT @v_dSql += '        ,TOP_ITEM_ID, ITEM_TYPE  ' + char(10)
                    SELECT @v_dSql += '        ,CELL_GROUP_CODE         ' + char(10)
                    SELECT @v_dSql += '        ,IN_QTY                  ' + char(10)
                    SELECT @v_dSql += '        ,OUT_QTY                 ' + char(10)
                    SELECT @v_dSql += '        ,INSERT_ID, INSERT_TIME  ' + char(10)
                    SELECT @v_dSql += '        ,UPDATE_ID, UPDATE_TIME  ' + char(10)
                    SELECT @v_dSql += '     )        ' + char(10)
                    SELECT @v_dSql += '     VALUES ( ' + char(10)
                    SELECT @v_dSql += '         '''+ @p_instance_id +''', '''+ @p_plan_id +''' ' + char(10)
                    SELECT @v_dSql += '        ,(SELECT DISTINCT COMPANY_ID FROM SCM_FACTORY_M WHERE DIVISION_ID = '''+ @p_division_id +''' AND SITE_ID = '''+ @p_site_id +''' AND PLANT_ID = '''+ @p_plant_id +''' AND ACTIVE_FLAG = ''Y'') ' + char(10)
                    SELECT @v_dSql += '        ,'''+ @p_division_id +''' ' + char(10)
                    SELECT @v_dSql += '        ,''PLAN''                 ' + char(10)
                    SELECT @v_dSql += '        ,'''+ @p_site_id +''', '''+ @p_plant_id +''' ' + char(10)
                    SELECT @v_dSql += '        ,'''+ @p_item_id +''', '''+ @p_operation_id +''', '''+ @p_factory_id +''', '''+ @p_location +''' ' + char(10)
                    SELECT @v_dSql += '        ,UPPER(''-''), ''D''     ' + char(10)
                    SELECT @v_dSql += '        ,'''+ @p_line_id +''', '''+ @p_electrode_type +'''      ' + char(10)
                    SELECT @v_dSql += '        ,''-''                               ' + char(10)
                    SELECT @v_dSql += '        ,CONVERT(DATE,'''+ @p_date +''')                   ' + char(10)
                    SELECT @v_dSql += '        ,'''+ @p_top_item_id +''', '''+ @p_item_type +'''       ' + char(10)
                    SELECT @v_dSql += '        ,ISNULL( (	SELECT DISTINCT A.SEGMENT3 AS GROUP_ITEM_ID ' + char(10)
                    SELECT @v_dSql += '                    FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)  ' + char(10)
                    SELECT @v_dSql += '                    WHERE  A.LOOKUP_TYPE_CODE = ''MODULE_CELL_GROUP'' ' + char(10)
                    SELECT @v_dSql += '                    AND    A.ACTIVE_FLAG = ''Y''                      ' + char(10)
                    SELECT @v_dSql += '                    AND    A.SEGMENT2 = RTRIM(LTRIM('''+ @p_division_id +''')) ' + char(10)
					SELECT @v_dSql += '                    AND    A.SEGMENT1 = RTRIM(LTRIM('''+ @p_site_id +'''))     ' + char(10)
                    SELECT @v_dSql += '                    AND    A.SEGMENT4 = RTRIM(LTRIM('''+ @p_item_id +'''))     ' + char(10)
					SELECT @v_dSql += '                  ), RTRIM(LTRIM('''+ @p_item_id +''')) ) ' + char(10)
                    SELECT @v_dSql += '        ,CEILING('''+ @p_qty +'''                     ' + char(10)
                    SELECT @v_dSql += '            / (SELECT ISNULL( ISNULL(MAX(B.YIELD),(CASE WHEN MAX(A.YIELD) = 0 THEN 1 ELSE MAX(A.YIELD) END)) ,1) AS YIELD ' + char(10)
                    SELECT @v_dSql += '               FROM   SCM_YIELD_M A WITH(NOLOCK) ' + char(10)
                    SELECT @v_dSql += '               LEFT OUTER JOIN (                 ' + char(10)
                    SELECT @v_dSql += '                   SELECT (CASE WHEN MAX(YIELD) = 0 THEN 1 ELSE MAX(YIELD) END) AS YIELD ' + char(10)
                    SELECT @v_dSql += '                   FROM   SCM_YIELD_EXCEPT_M A WITH(NOLOCK)          ' + char(10)
                    SELECT @v_dSql += '                   WHERE  A.DIVISION_ID  = '''+ @p_division_id +'''  ' + char(10)
                    SELECT @v_dSql += '                   AND    A.SITE_ID      = '''+ @p_site_id +'''      ' + char(10)
                    SELECT @v_dSql += '                   AND    A.PLANT_ID     = '''+ @p_plant_id +'''     ' + char(10)
                    SELECT @v_dSql += '                   AND    A.FACTORY_ID   = '''+ @p_factory_id +'''   ' + char(10)
                    SELECT @v_dSql += '                   AND    A.OPERATION_ID = '''+ @p_operation_id +''' ' + char(10)
                    SELECT @v_dSql += '                   AND    A.LINE_ID      = '''+ @p_line_id +'''      ' + char(10)
                    SELECT @v_dSql += '                   AND    A.ITEM_ID      = '''+ @p_item_id +'''      ' + char(10)
                    SELECT @v_dSql += '                   AND    CONVERT(DATE,'''+ @p_date +''') BETWEEN A.START_TIME AND A.END_TIME ' + char(10)
                    SELECT @v_dSql += '               ) B        ' + char(10)
                    SELECT @v_dSql += '               ON     1=1 ' + char(10)
                    SELECT @v_dSql += '               WHERE  A.DIVISION_ID  = '''+ @p_division_id +'''  ' + char(10)
                    SELECT @v_dSql += '               AND    A.SITE_ID      = '''+ @p_site_id +'''      ' + char(10)
                    SELECT @v_dSql += '               AND    A.PLANT_ID     = '''+ @p_plant_id +'''     ' + char(10)
                    SELECT @v_dSql += '               AND    A.FACTORY_ID   = '''+ @p_factory_id +'''   ' + char(10)
                    SELECT @v_dSql += '               AND    A.OPERATION_ID = '''+ @p_operation_id +''' ' + char(10)
                    SELECT @v_dSql += '               AND    A.LINE_ID      = '''+ @p_line_id +'''      ' + char(10)
                    SELECT @v_dSql += '               AND    A.ITEM_ID      = '''+ @p_item_id +'''      ' + char(10)
                    SELECT @v_dSql += '               AND    A.MONTH        = SUBSTRING('''+ @p_date +''',1,6))) ' + char(10)
                    SELECT @v_dSql += '        ,'''+ @p_qty +'''                                         ' + char(10)
                    SELECT @v_dSql += '        ,'''+ @p_user_id +''', dbo.FN_SITE_TIME('''+ @p_site_id +''') ' + char(10)
                    SELECT @v_dSql += '        ,'''+ @p_user_id +''', dbo.FN_SITE_TIME('''+ @p_site_id +''') ' + char(10)
					SELECT @v_dSql += '     ) ; ' + char(10)

					 -- ADD Line 후 계획일자까지 임의 데이타 넣어주기 위해 먼저 실행시켜줌 20221227 by cys
					SET @runstart = GetDate()
                     --쿼리실행
                    EXEC sp_executesql @v_dSql
                     
                    SET @runend = GetDate()
                    EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id,'','', @v_dSql,'SELECT',@runstart, @runend


					SELECT @v_dSql = ''
                    SELECT @v_dSql += ' MERGE INTO FP_AMEND_PLAN_FORM_R A ' + char(10)
                    SELECT @v_dSql += '    USING (	SELECT '''+ @p_instance_id +''' AS INSTANCE_ID, '''+ @p_plan_id +''' AS FP_PLAN_ID, ' + char(10)
                    SELECT @v_dSql += '					'''+ @p_division_id +''' AS DIVISION_ID, ''PLAN'' AS CATEGORY_ID, '''+ @p_site_id +''' AS SITE_ID, '''+ @p_plant_id +''' AS PLANT_ID, ' + char(10)
                    SELECT @v_dSql += '					'''+ @p_item_id +''' AS ITEM_ID, '''+ @p_operation_id +''' AS OPERATION_ID,      ' + char(10)
                    SELECT @v_dSql += '					 UPPER(''-'') AS PRODUCTION_TYPE, ''D'' AS MARKET, ' + char(10)
                    SELECT @v_dSql += '					'''+ @p_line_id +''' AS LINE_ID, ''-'' AS CUSTOMER_ID, '''+ @p_top_item_id +''' AS TOP_ITEM_ID ,  ' + char(10)
					SELECT @v_dSql += '					DATEADD(DAY, B.INT - 1, '''+ @p_date +''') AS PLAN_DATE  ' + char(10)
                    SELECT @v_dSql += '				FROM   FP_INSTANCE_FACTORY_M A						' + char(10) 
					SELECT @v_dSql += '						, SCM_FP_PLAN_H C							' + char(10) 
					SELECT @v_dSql += '						, COPYT                    B				' + char(10) 
					SELECT @v_dSql += '				WHERE  A.INSTANCE_ID = '''+ @p_instance_id +'''		' + char(10) 
					SELECT @v_dSql += '				AND	   A.FACTORY_ID	 = '''+ @p_factory_id +'''		' + char(10) 
					SELECT @v_dSql += '				AND	   A.INSTANCE_ID = C.INSTANCE_ID				' + char(10) 
					SELECT @v_dSql += '				AND	   C.PLAN_ID =  '''+ @p_plan_id +''' 			' + char(10) 
					SELECT @v_dSql += '				AND    B.INT        <= ( C.PLAN_HORIZON  + 1)		' + char(10) 
					SELECT @v_dSql += '          ) B ' + char(10)
					SELECT @v_dSql += '    ON (  A.INSTANCE_ID = B.INSTANCE_ID AND A.FP_PLAN_ID = B.FP_PLAN_ID ' + char(10)
                    SELECT @v_dSql += '          AND A.DIVISION_ID = B.DIVISION_ID AND A.CATEGORY_ID = B.CATEGORY_ID AND A.SITE_ID = B.SITE_ID AND A.PLANT_ID = B.PLANT_ID ' + char(10) 
                    SELECT @v_dSql += '          AND A.ITEM_ID = B.ITEM_ID AND A.OPERATION_ID = B.OPERATION_ID     ' + char(10)
                    SELECT @v_dSql += '          AND A.PRODUCTION_TYPE = B.PRODUCTION_TYPE AND A.MARKET = B.MARKET ' + char(10)
                    SELECT @v_dSql += '          AND A.LINE_ID = B.LINE_ID AND A.CUSTOMER_ID = B.CUSTOMER_ID       ' + char(10)
                    SELECT @v_dSql += '          AND CONVERT(VARCHAR,A.PLAN_DATE,112) = B.PLAN_DATE AND A.TOP_ITEM_ID = B.TOP_ITEM_ID ' + char(10)
                    SELECT @v_dSql += ' )                 ' + char(10)
					SELECT @v_dSql += ' WHEN NOT MATCHED THEN           ' + char(10)
                    SELECT @v_dSql += '     INSERT (                    ' + char(10)
                    SELECT @v_dSql += '         INSTANCE_ID, FP_PLAN_ID ' + char(10)
                    SELECT @v_dSql += '        ,COMPANY_ID              ' + char(10)
                    SELECT @v_dSql += '        ,DIVISION_ID             ' + char(10)
                    SELECT @v_dSql += '        ,CATEGORY_ID             ' + char(10)
                    SELECT @v_dSql += '        ,SITE_ID, PLANT_ID       ' + char(10)
                    SELECT @v_dSql += '        ,ITEM_ID, OPERATION_ID, FACTORY_ID, LOCATION ' + char(10)
                    SELECT @v_dSql += '        ,PRODUCTION_TYPE, MARKET ' + char(10)
                    SELECT @v_dSql += '        ,LINE_ID, ELECTRODE_TYPE ' + char(10)
                    SELECT @v_dSql += '        ,CUSTOMER_ID             ' + char(10)
                    SELECT @v_dSql += '        ,PLAN_DATE               ' + char(10)
                    SELECT @v_dSql += '        ,TOP_ITEM_ID, ITEM_TYPE  ' + char(10)
                    SELECT @v_dSql += '        ,CELL_GROUP_CODE         ' + char(10)
                    SELECT @v_dSql += '        ,IN_QTY                  ' + char(10)
                    SELECT @v_dSql += '        ,OUT_QTY                 ' + char(10)
                    SELECT @v_dSql += '        ,INSERT_ID, INSERT_TIME  ' + char(10)
                    SELECT @v_dSql += '        ,UPDATE_ID, UPDATE_TIME  ' + char(10)
                    SELECT @v_dSql += '     )        ' + char(10)
                    SELECT @v_dSql += '     VALUES ( ' + char(10)
                    SELECT @v_dSql += '         '''+ @p_instance_id +''', '''+ @p_plan_id +''' ' + char(10)
                    SELECT @v_dSql += '        ,(SELECT DISTINCT COMPANY_ID FROM SCM_FACTORY_M WHERE DIVISION_ID = '''+ @p_division_id +''' AND SITE_ID = '''+ @p_site_id +''' AND PLANT_ID = '''+ @p_plant_id +''' AND ACTIVE_FLAG = ''Y'') ' + char(10)
                    SELECT @v_dSql += '        ,'''+ @p_division_id +''' ' + char(10)
                    SELECT @v_dSql += '        ,''PLAN''                 ' + char(10)
                    SELECT @v_dSql += '        ,'''+ @p_site_id +''', '''+ @p_plant_id +''' ' + char(10)
                    SELECT @v_dSql += '        ,'''+ @p_item_id +''', '''+ @p_operation_id +''', '''+ @p_factory_id +''', '''+ @p_location +''' ' + char(10)
                    SELECT @v_dSql += '        ,UPPER(''-''), ''D''     ' + char(10)
                    SELECT @v_dSql += '        ,'''+ @p_line_id +''', '''+ @p_electrode_type +'''      ' + char(10)
                    SELECT @v_dSql += '        ,''-''                               ' + char(10)
                    SELECT @v_dSql += '        ,B.PLAN_DATE            ' + char(10)
                    SELECT @v_dSql += '        ,'''+ @p_top_item_id +''', '''+ @p_item_type +'''       ' + char(10)
                    SELECT @v_dSql += '        ,ISNULL( (	SELECT DISTINCT A.SEGMENT3 AS GROUP_ITEM_ID ' + char(10)
                    SELECT @v_dSql += '                    FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)  ' + char(10)
                    SELECT @v_dSql += '                    WHERE  A.LOOKUP_TYPE_CODE = ''MODULE_CELL_GROUP'' ' + char(10)
                    SELECT @v_dSql += '                    AND    A.ACTIVE_FLAG = ''Y''                      ' + char(10)
                    SELECT @v_dSql += '                    AND    A.SEGMENT2 = RTRIM(LTRIM('''+ @p_division_id +''')) ' + char(10)
					SELECT @v_dSql += '                    AND    A.SEGMENT1 = RTRIM(LTRIM('''+ @p_site_id +'''))     ' + char(10)
                    SELECT @v_dSql += '                    AND    A.SEGMENT4 = RTRIM(LTRIM('''+ @p_item_id +'''))     ' + char(10)
					SELECT @v_dSql += '                  ), RTRIM(LTRIM('''+ @p_item_id +''')) ) ' + char(10)
                    SELECT @v_dSql += '        ,0	' + char(10)
                    SELECT @v_dSql += '        ,0                                         ' + char(10)
                    SELECT @v_dSql += '        ,'''+ @p_user_id +''', dbo.FN_SITE_TIME('''+ @p_site_id +''') ' + char(10)
                    SELECT @v_dSql += '        ,'''+ @p_user_id +''', dbo.FN_SITE_TIME('''+ @p_site_id +''') ' + char(10)
					SELECT @v_dSql += '     ) ; ' + char(10)

                END --'D'
			ELSE IF(@p_sys_flag ='MERGE_LINE')
                
                BEGIN
             		
					SELECT @v_dSql = ''
                    SELECT @v_dSql += ' MERGE INTO FP_AMEND_PLAN_FORM_R A ' + char(10)
                    SELECT @v_dSql += '    USING (SELECT '''+ @p_instance_id +''' AS INSTANCE_ID, '''+ @p_plan_id +''' AS FP_PLAN_ID, ' + char(10)
                    SELECT @v_dSql += '               '''+ @p_division_id +''' AS DIVISION_ID, ''PLAN'' AS CATEGORY_ID, '''+ @p_site_id +''' AS SITE_ID, '''+ @p_plant_id +''' AS PLANT_ID, ' + char(10)
                    SELECT @v_dSql += '               '''+ @p_item_id +''' AS ITEM_ID, '''+ @p_operation_id +''' AS OPERATION_ID,      ' + char(10)
                    SELECT @v_dSql += '               UPPER(''-'') AS PRODUCTION_TYPE, ''D'' AS MARKET, ' + char(10)
                    SELECT @v_dSql += '               '''+ @p_line_id +''' AS LINE_ID, ''-'' AS CUSTOMER_ID, '''+ @p_date +''' AS PLAN_DATE, '''+ @p_top_item_id +''' AS TOP_ITEM_ID ) B ' + char(10)
                    SELECT @v_dSql += '    ON (  A.INSTANCE_ID = B.INSTANCE_ID AND A.FP_PLAN_ID = B.FP_PLAN_ID ' + char(10)
                    SELECT @v_dSql += '          AND A.DIVISION_ID = B.DIVISION_ID AND A.CATEGORY_ID = B.CATEGORY_ID AND A.SITE_ID = B.SITE_ID AND A.PLANT_ID = B.PLANT_ID ' + char(10) 
                    SELECT @v_dSql += '          AND A.ITEM_ID = B.ITEM_ID AND A.OPERATION_ID = B.OPERATION_ID     ' + char(10)
                    SELECT @v_dSql += '          AND A.PRODUCTION_TYPE = B.PRODUCTION_TYPE AND A.MARKET = B.MARKET ' + char(10)
                    SELECT @v_dSql += '          AND A.LINE_ID = B.LINE_ID AND A.CUSTOMER_ID = B.CUSTOMER_ID       ' + char(10)
                    SELECT @v_dSql += '          AND CONVERT(VARCHAR,A.PLAN_DATE,112) = B.PLAN_DATE AND A.TOP_ITEM_ID = B.TOP_ITEM_ID ' + char(10)
                    SELECT @v_dSql += ' )                 ' + char(10)
                    SELECT @v_dSql += ' WHEN MATCHED THEN ' + char(10)
                    SELECT @v_dSql += '   UPDATE SET OUT_QTY = '''+ @p_qty +'''        ' + char(10)
					SELECT @v_dSql += '           , IN_QTY  = CEILING('''+ @p_qty +''' ' + char(10)
                    SELECT @v_dSql += '             / ( SELECT ISNULL( ISNULL(MAX(B.YIELD),(CASE WHEN MAX(A.YIELD) = 0 THEN 1 ELSE MAX(A.YIELD) END)) ,1) AS YIELD ' + char(10)
                    SELECT @v_dSql += '                 FROM   SCM_YIELD_M A WITH(NOLOCK) ' + char(10)
                    SELECT @v_dSql += '                 LEFT OUTER JOIN (                 ' + char(10)
                    SELECT @v_dSql += '                        SELECT (CASE WHEN MAX(YIELD) = 0 THEN 1 ELSE MAX(YIELD) END) AS YIELD ' + char(10)
                    SELECT @v_dSql += '                        FROM   SCM_YIELD_EXCEPT_M A WITH(NOLOCK)          ' + char(10)
                    SELECT @v_dSql += '                        WHERE  A.DIVISION_ID  = '''+ @p_division_id +'''  ' + char(10)
                    SELECT @v_dSql += '                        AND    A.SITE_ID      = '''+ @p_site_id +'''      ' + char(10)
                    SELECT @v_dSql += '                        AND    A.PLANT_ID     = '''+ @p_plant_id +'''     ' + char(10)
                    SELECT @v_dSql += '                        AND    A.FACTORY_ID   = '''+ @p_factory_id +'''   ' + char(10)
                    SELECT @v_dSql += '                        AND    A.OPERATION_ID = '''+ @p_operation_id +''' ' + char(10)
                    SELECT @v_dSql += '                        AND    A.LINE_ID      = '''+ @p_line_id +'''      ' + char(10)
                    SELECT @v_dSql += '                        AND    A.ITEM_ID      = '''+ @p_item_id +'''      ' + char(10)
                    SELECT @v_dSql += '                        AND    CONVERT(DATE,'''+ @p_date +''') BETWEEN A.START_TIME AND A.END_TIME ' + char(10)
                    SELECT @v_dSql += '                 ) B        ' + char(10)
                    SELECT @v_dSql += '                 ON     1=1 ' + char(10)
                    SELECT @v_dSql += '                 WHERE  A.DIVISION_ID  = '''+ @p_division_id +'''  ' + char(10)
                    SELECT @v_dSql += '                 AND    A.SITE_ID      = '''+ @p_site_id +'''      ' + char(10)
                    SELECT @v_dSql += '                 AND    A.PLANT_ID     = '''+ @p_plant_id +'''     ' + char(10)
                    SELECT @v_dSql += '                 AND    A.FACTORY_ID   = '''+ @p_factory_id +'''   ' + char(10)
                    SELECT @v_dSql += '                 AND    A.OPERATION_ID = '''+ @p_operation_id +''' ' + char(10)
                    SELECT @v_dSql += '                 AND    A.LINE_ID      = '''+ @p_line_id +'''      ' + char(10)
                    SELECT @v_dSql += '                 AND    A.ITEM_ID      = '''+ @p_item_id +'''      ' + char(10)
                    SELECT @v_dSql += '                 AND    A.MONTH        = SUBSTRING('''+ @p_date +''',1,6))) ' + char(10)
                    SELECT @v_dSql += '           , PRODUCTION_TYPE = UPPER(''-'')                     ' + char(10)
                    SELECT @v_dSql += '           , UPDATE_ID = '''+ @p_user_id +''', UPDATE_TIME = dbo.FN_SITE_TIME('''+ @p_site_id +''') ' + char(10)
                    SELECT @v_dSql += ' WHEN NOT MATCHED THEN           ' + char(10)
                    SELECT @v_dSql += '     INSERT (                    ' + char(10)
                    SELECT @v_dSql += '         INSTANCE_ID, FP_PLAN_ID ' + char(10)
                    SELECT @v_dSql += '        ,COMPANY_ID              ' + char(10)
                    SELECT @v_dSql += '        ,DIVISION_ID             ' + char(10)
                    SELECT @v_dSql += '        ,CATEGORY_ID             ' + char(10)
                    SELECT @v_dSql += '        ,SITE_ID, PLANT_ID       ' + char(10)
                    SELECT @v_dSql += '        ,ITEM_ID, OPERATION_ID, FACTORY_ID, LOCATION ' + char(10)
                    SELECT @v_dSql += '        ,PRODUCTION_TYPE, MARKET ' + char(10)
                    SELECT @v_dSql += '        ,LINE_ID, ELECTRODE_TYPE ' + char(10)
                    SELECT @v_dSql += '        ,CUSTOMER_ID             ' + char(10)
                    SELECT @v_dSql += '        ,PLAN_DATE               ' + char(10)
                    SELECT @v_dSql += '        ,TOP_ITEM_ID, ITEM_TYPE  ' + char(10)
                    SELECT @v_dSql += '        ,CELL_GROUP_CODE         ' + char(10)
                    SELECT @v_dSql += '        ,IN_QTY                  ' + char(10)
                    SELECT @v_dSql += '        ,OUT_QTY                 ' + char(10)
                    SELECT @v_dSql += '        ,INSERT_ID, INSERT_TIME  ' + char(10)
                    SELECT @v_dSql += '        ,UPDATE_ID, UPDATE_TIME  ' + char(10)
                    SELECT @v_dSql += '     )        ' + char(10)
                    SELECT @v_dSql += '     VALUES ( ' + char(10)
                    SELECT @v_dSql += '         '''+ @p_instance_id +''', '''+ @p_plan_id +''' ' + char(10)
                    SELECT @v_dSql += '        ,(SELECT DISTINCT COMPANY_ID FROM SCM_FACTORY_M WHERE DIVISION_ID = '''+ @p_division_id +''' AND SITE_ID = '''+ @p_site_id +''' AND PLANT_ID = '''+ @p_plant_id +''' AND ACTIVE_FLAG = ''Y'') ' + char(10)
                    SELECT @v_dSql += '        ,'''+ @p_division_id +''' ' + char(10)
                    SELECT @v_dSql += '        ,''PLAN''                 ' + char(10)
                    SELECT @v_dSql += '        ,'''+ @p_site_id +''', '''+ @p_plant_id +''' ' + char(10)
                    SELECT @v_dSql += '        ,'''+ @p_item_id +''', '''+ @p_operation_id +''', '''+ @p_factory_id +''', '''+ @p_location +''' ' + char(10)
                    SELECT @v_dSql += '        ,UPPER(''-''), ''D''     ' + char(10)
                    SELECT @v_dSql += '        ,'''+ @p_line_id +''', '''+ @p_electrode_type +'''      ' + char(10)
                    SELECT @v_dSql += '        ,''-''                               ' + char(10)
                    SELECT @v_dSql += '        ,CONVERT(DATE,'''+ @p_date +''')                   ' + char(10)
                    SELECT @v_dSql += '        ,'''+ @p_top_item_id +''', '''+ @p_item_type +'''       ' + char(10)
                    SELECT @v_dSql += '        ,ISNULL( (	SELECT DISTINCT A.SEGMENT3 AS GROUP_ITEM_ID ' + char(10)
                    SELECT @v_dSql += '                    FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)  ' + char(10)
                    SELECT @v_dSql += '                    WHERE  A.LOOKUP_TYPE_CODE = ''MODULE_CELL_GROUP'' ' + char(10)
                    SELECT @v_dSql += '                    AND    A.ACTIVE_FLAG = ''Y''                      ' + char(10)
                    SELECT @v_dSql += '                    AND    A.SEGMENT2 = RTRIM(LTRIM('''+ @p_division_id +''')) ' + char(10)
					SELECT @v_dSql += '                    AND    A.SEGMENT1 = RTRIM(LTRIM('''+ @p_site_id +'''))     ' + char(10)
                    SELECT @v_dSql += '                    AND    A.SEGMENT4 = RTRIM(LTRIM('''+ @p_item_id +'''))     ' + char(10)
					SELECT @v_dSql += '                  ), RTRIM(LTRIM('''+ @p_item_id +''')) ) ' + char(10)
                    SELECT @v_dSql += '        ,CEILING('''+ @p_qty +'''                     ' + char(10)
                    SELECT @v_dSql += '            / (SELECT ISNULL( ISNULL(MAX(B.YIELD),(CASE WHEN MAX(A.YIELD) = 0 THEN 1 ELSE MAX(A.YIELD) END)) ,1) AS YIELD ' + char(10)
                    SELECT @v_dSql += '               FROM   SCM_YIELD_M A WITH(NOLOCK) ' + char(10)
                    SELECT @v_dSql += '               LEFT OUTER JOIN (                 ' + char(10)
                    SELECT @v_dSql += '                   SELECT (CASE WHEN MAX(YIELD) = 0 THEN 1 ELSE MAX(YIELD) END) AS YIELD ' + char(10)
                    SELECT @v_dSql += '                   FROM   SCM_YIELD_EXCEPT_M A WITH(NOLOCK)          ' + char(10)
                    SELECT @v_dSql += '                   WHERE  A.DIVISION_ID  = '''+ @p_division_id +'''  ' + char(10)
                    SELECT @v_dSql += '                   AND    A.SITE_ID      = '''+ @p_site_id +'''      ' + char(10)
                    SELECT @v_dSql += '                   AND    A.PLANT_ID     = '''+ @p_plant_id +'''     ' + char(10)
                    SELECT @v_dSql += '                   AND    A.FACTORY_ID   = '''+ @p_factory_id +'''   ' + char(10)
                    SELECT @v_dSql += '                   AND    A.OPERATION_ID = '''+ @p_operation_id +''' ' + char(10)
                    SELECT @v_dSql += '                   AND    A.LINE_ID      = '''+ @p_line_id +'''      ' + char(10)
                    SELECT @v_dSql += '                   AND    A.ITEM_ID      = '''+ @p_item_id +'''      ' + char(10)
                    SELECT @v_dSql += '                   AND    CONVERT(DATE,'''+ @p_date +''') BETWEEN A.START_TIME AND A.END_TIME ' + char(10)
                    SELECT @v_dSql += '               ) B        ' + char(10)
                    SELECT @v_dSql += '               ON     1=1 ' + char(10)
                    SELECT @v_dSql += '               WHERE  A.DIVISION_ID  = '''+ @p_division_id +'''  ' + char(10)
                    SELECT @v_dSql += '               AND    A.SITE_ID      = '''+ @p_site_id +'''      ' + char(10)
                    SELECT @v_dSql += '               AND    A.PLANT_ID     = '''+ @p_plant_id +'''     ' + char(10)
                    SELECT @v_dSql += '               AND    A.FACTORY_ID   = '''+ @p_factory_id +'''   ' + char(10)
                    SELECT @v_dSql += '               AND    A.OPERATION_ID = '''+ @p_operation_id +''' ' + char(10)
                    SELECT @v_dSql += '               AND    A.LINE_ID      = '''+ @p_line_id +'''      ' + char(10)
                    SELECT @v_dSql += '               AND    A.ITEM_ID      = '''+ @p_item_id +'''      ' + char(10)
                    SELECT @v_dSql += '               AND    A.MONTH        = SUBSTRING('''+ @p_date +''',1,6))) ' + char(10)
                    SELECT @v_dSql += '        ,'''+ @p_qty +'''                                         ' + char(10)
                    SELECT @v_dSql += '        ,'''+ @p_user_id +''', dbo.FN_SITE_TIME('''+ @p_site_id +''') ' + char(10)
                    SELECT @v_dSql += '        ,'''+ @p_user_id +''', dbo.FN_SITE_TIME('''+ @p_site_id +''') ' + char(10)
					SELECT @v_dSql += '     ) ; ' + char(10)

					-- ADD Line 후 계획일자까지 임의 데이타 넣어주기 위해 먼저 실행시켜줌 20221227 by cys
					SET @runstart = GetDate()
                     --쿼리실행
                    EXEC sp_executesql @v_dSql
                     
                    SET @runend = GetDate()
                    EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id,'','', @v_dSql,'SELECT',@runstart, @runend


					SELECT @v_dSql = ''
                    SELECT @v_dSql += ' MERGE INTO FP_AMEND_PLAN_FORM_R A ' + char(10)
                    SELECT @v_dSql += '    USING (	SELECT '''+ @p_instance_id +''' AS INSTANCE_ID, '''+ @p_plan_id +''' AS FP_PLAN_ID, ' + char(10)
                    SELECT @v_dSql += '					'''+ @p_division_id +''' AS DIVISION_ID, ''PLAN'' AS CATEGORY_ID, '''+ @p_site_id +''' AS SITE_ID, '''+ @p_plant_id +''' AS PLANT_ID, ' + char(10)
                    SELECT @v_dSql += '					'''+ @p_item_id +''' AS ITEM_ID, '''+ @p_operation_id +''' AS OPERATION_ID,      ' + char(10)
                    SELECT @v_dSql += '					 UPPER(''-'') AS PRODUCTION_TYPE, ''D'' AS MARKET, ' + char(10)
                    SELECT @v_dSql += '					'''+ @p_line_id +''' AS LINE_ID, ''-'' AS CUSTOMER_ID, '''+ @p_top_item_id +''' AS TOP_ITEM_ID ,  ' + char(10)
					SELECT @v_dSql += '					DATEADD(DAY, B.INT - 1, '''+ @p_date +''') AS PLAN_DATE  ' + char(10)
                    SELECT @v_dSql += '				FROM   FP_INSTANCE_FACTORY_M A						' + char(10) 
					SELECT @v_dSql += '						, SCM_FP_PLAN_H C							' + char(10) 
					SELECT @v_dSql += '						, COPYT                    B				' + char(10) 
					SELECT @v_dSql += '				WHERE  A.INSTANCE_ID = '''+ @p_instance_id +'''		' + char(10) 
					SELECT @v_dSql += '				AND	   A.FACTORY_ID	 = '''+ @p_factory_id +'''		' + char(10) 
					SELECT @v_dSql += '				AND	   A.INSTANCE_ID = C.INSTANCE_ID				' + char(10) 
					SELECT @v_dSql += '				AND	   C.PLAN_ID =  '''+ @p_plan_id +''' 			' + char(10) 
					SELECT @v_dSql += '				AND    B.INT        <= ( C.PLAN_HORIZON  + 1)		' + char(10) 
					SELECT @v_dSql += '          ) B ' + char(10)
					SELECT @v_dSql += '    ON (  A.INSTANCE_ID = B.INSTANCE_ID AND A.FP_PLAN_ID = B.FP_PLAN_ID ' + char(10)
                    SELECT @v_dSql += '          AND A.DIVISION_ID = B.DIVISION_ID AND A.CATEGORY_ID = B.CATEGORY_ID AND A.SITE_ID = B.SITE_ID AND A.PLANT_ID = B.PLANT_ID ' + char(10) 
                    SELECT @v_dSql += '          AND A.ITEM_ID = B.ITEM_ID AND A.OPERATION_ID = B.OPERATION_ID     ' + char(10)
                    SELECT @v_dSql += '          AND A.PRODUCTION_TYPE = B.PRODUCTION_TYPE AND A.MARKET = B.MARKET ' + char(10)
                    SELECT @v_dSql += '          AND A.LINE_ID = B.LINE_ID AND A.CUSTOMER_ID = B.CUSTOMER_ID       ' + char(10)
                    SELECT @v_dSql += '          AND CONVERT(VARCHAR,A.PLAN_DATE,112) = B.PLAN_DATE AND A.TOP_ITEM_ID = B.TOP_ITEM_ID ' + char(10)
                    SELECT @v_dSql += ' )                 ' + char(10)
					SELECT @v_dSql += ' WHEN NOT MATCHED THEN           ' + char(10)
                    SELECT @v_dSql += '     INSERT (                    ' + char(10)
                    SELECT @v_dSql += '         INSTANCE_ID, FP_PLAN_ID ' + char(10)
                    SELECT @v_dSql += '        ,COMPANY_ID              ' + char(10)
                    SELECT @v_dSql += '        ,DIVISION_ID             ' + char(10)
                    SELECT @v_dSql += '        ,CATEGORY_ID             ' + char(10)
                    SELECT @v_dSql += '        ,SITE_ID, PLANT_ID       ' + char(10)
                    SELECT @v_dSql += '        ,ITEM_ID, OPERATION_ID, FACTORY_ID, LOCATION ' + char(10)
                    SELECT @v_dSql += '        ,PRODUCTION_TYPE, MARKET ' + char(10)
                    SELECT @v_dSql += '        ,LINE_ID, ELECTRODE_TYPE ' + char(10)
                    SELECT @v_dSql += '        ,CUSTOMER_ID             ' + char(10)
                    SELECT @v_dSql += '        ,PLAN_DATE               ' + char(10)
                    SELECT @v_dSql += '        ,TOP_ITEM_ID, ITEM_TYPE  ' + char(10)
                    SELECT @v_dSql += '        ,CELL_GROUP_CODE         ' + char(10)
                    SELECT @v_dSql += '        ,IN_QTY                  ' + char(10)
                    SELECT @v_dSql += '        ,OUT_QTY                 ' + char(10)
                    SELECT @v_dSql += '        ,INSERT_ID, INSERT_TIME  ' + char(10)
                    SELECT @v_dSql += '        ,UPDATE_ID, UPDATE_TIME  ' + char(10)
                    SELECT @v_dSql += '     )        ' + char(10)
                    SELECT @v_dSql += '     VALUES ( ' + char(10)
                    SELECT @v_dSql += '         '''+ @p_instance_id +''', '''+ @p_plan_id +''' ' + char(10)
                    SELECT @v_dSql += '        ,(SELECT DISTINCT COMPANY_ID FROM SCM_FACTORY_M WHERE DIVISION_ID = '''+ @p_division_id +''' AND SITE_ID = '''+ @p_site_id +''' AND PLANT_ID = '''+ @p_plant_id +''' AND ACTIVE_FLAG = ''Y'') ' + char(10)
                    SELECT @v_dSql += '        ,'''+ @p_division_id +''' ' + char(10)
                    SELECT @v_dSql += '        ,''PLAN''                 ' + char(10)
                    SELECT @v_dSql += '        ,'''+ @p_site_id +''', '''+ @p_plant_id +''' ' + char(10)
                    SELECT @v_dSql += '        ,'''+ @p_item_id +''', '''+ @p_operation_id +''', '''+ @p_factory_id +''', '''+ @p_location +''' ' + char(10)
                    SELECT @v_dSql += '        ,UPPER(''-''), ''D''     ' + char(10)
                    SELECT @v_dSql += '        ,'''+ @p_line_id +''', '''+ @p_electrode_type +'''      ' + char(10)
                    SELECT @v_dSql += '        ,''-''                               ' + char(10)
                    SELECT @v_dSql += '        ,B.PLAN_DATE            ' + char(10)
                    SELECT @v_dSql += '        ,'''+ @p_top_item_id +''', '''+ @p_item_type +'''       ' + char(10)
                    SELECT @v_dSql += '        ,ISNULL( (	SELECT DISTINCT A.SEGMENT3 AS GROUP_ITEM_ID ' + char(10)
                    SELECT @v_dSql += '                    FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)  ' + char(10)
                    SELECT @v_dSql += '                    WHERE  A.LOOKUP_TYPE_CODE = ''MODULE_CELL_GROUP'' ' + char(10)
                    SELECT @v_dSql += '                    AND    A.ACTIVE_FLAG = ''Y''                      ' + char(10)
                    SELECT @v_dSql += '                    AND    A.SEGMENT2 = RTRIM(LTRIM('''+ @p_division_id +''')) ' + char(10)
					SELECT @v_dSql += '                    AND    A.SEGMENT1 = RTRIM(LTRIM('''+ @p_site_id +'''))     ' + char(10)
                    SELECT @v_dSql += '                    AND    A.SEGMENT4 = RTRIM(LTRIM('''+ @p_item_id +'''))     ' + char(10)
					SELECT @v_dSql += '                  ), RTRIM(LTRIM('''+ @p_item_id +''')) ) ' + char(10)
                    SELECT @v_dSql += '        ,0	' + char(10)
                    SELECT @v_dSql += '        ,0                                         ' + char(10)
                    SELECT @v_dSql += '        ,'''+ @p_user_id +''', dbo.FN_SITE_TIME('''+ @p_site_id +''') ' + char(10)
                    SELECT @v_dSql += '        ,'''+ @p_user_id +''', dbo.FN_SITE_TIME('''+ @p_site_id +''') ' + char(10)
					SELECT @v_dSql += '     ) ; ' + char(10)

                END --'D'
              /****************************************************************************/
             /* INSERT_LINE_LOG  저장 경우  :                                        */
             /****************************************************************************/
             ELSE IF(@p_sys_flag ='INSERT_LINE_LOG')
                 BEGIN
                      
                      SELECT @v_dSql = ''
                     SELECT @v_dSql += ' INSERT INTO HIS_AMEND_PLAN_FORM_R ( ' + char(10)
                     SELECT @v_dSql += '        INSTANCE_ID, FP_PLAN_ID      ' + char(10)
                     SELECT @v_dSql += '       ,COMPANY_ID                   ' + char(10)
                     SELECT @v_dSql += '       ,DIVISION_ID                  ' + char(10)
                     SELECT @v_dSql += '       ,CATEGORY_ID                  ' + char(10)
                     SELECT @v_dSql += '       ,SITE_ID, PLANT_ID            ' + char(10)
                     SELECT @v_dSql += '       ,ITEM_ID, OPERATION_ID, FACTORY_ID, LOCATION ' + char(10)
                     SELECT @v_dSql += '       ,PRODUCTION_TYPE, MARKET ' + char(10)
                     SELECT @v_dSql += '       ,LINE_ID, ELECTRODE_TYPE ' + char(10)
                     SELECT @v_dSql += '       ,CUSTOMER_ID             ' + char(10)
                     SELECT @v_dSql += '       ,PLAN_DATE               ' + char(10)
                     SELECT @v_dSql += '       ,TOP_ITEM_ID, ITEM_TYPE  ' + char(10)
                     SELECT @v_dSql += '       ,CELL_GROUP_CODE         ' + char(10)
                     SELECT @v_dSql += '       ,IN_QTY                  ' + char(10)
                     SELECT @v_dSql += '       ,OUT_QTY                 ' + char(10)
                     SELECT @v_dSql += '       ,INSERT_ID, INSERT_TIME  ' + char(10)
                     SELECT @v_dSql += '       ,UPDATE_ID, UPDATE_TIME  ' + char(10)
                     SELECT @v_dSql += '       ,JOB_USER_ID, JOB_TIME, JOB_TYPE ' + char(10)
                     SELECT @v_dSql += ' )                              ' + char(10)
                     SELECT @v_dSql += ' SELECT INSTANCE_ID, FP_PLAN_ID ' + char(10)
                     SELECT @v_dSql += '       ,COMPANY_ID              ' + char(10)
                     SELECT @v_dSql += '       ,DIVISION_ID             ' + char(10)
                     SELECT @v_dSql += '       ,CATEGORY_ID             ' + char(10)
                     SELECT @v_dSql += '       ,SITE_ID, PLANT_ID       ' + char(10)
                     SELECT @v_dSql += '       ,ITEM_ID, OPERATION_ID, FACTORY_ID, LOCATION ' + char(10)
                     SELECT @v_dSql += '       ,PRODUCTION_TYPE, MARKET ' + char(10)
                     SELECT @v_dSql += '       ,LINE_ID, ELECTRODE_TYPE ' + char(10)
                     SELECT @v_dSql += '       ,CUSTOMER_ID             ' + char(10)
                     SELECT @v_dSql += '       ,PLAN_DATE               ' + char(10)
                     SELECT @v_dSql += '       ,TOP_ITEM_ID, ITEM_TYPE  ' + char(10)
                     SELECT @v_dSql += '       ,CELL_GROUP_CODE         ' + char(10)
                     SELECT @v_dSql += '       ,IN_QTY                  ' + char(10)
                     SELECT @v_dSql += '       ,OUT_QTY                 ' + char(10)
                     SELECT @v_dSql += '       ,INSERT_ID, INSERT_TIME  ' + char(10)
                     SELECT @v_dSql += '       ,UPDATE_ID, UPDATE_TIME  ' + char(10)
                     SELECT @v_dSql += '       ,'''+ @p_user_id +''' AS JOB_USER_ID, GETDATE() AS JOB_TIME, ''INSERT'' AS JOB_TYPE ' + char(10)
                     SELECT @v_dSql += ' FROM   FP_AMEND_PLAN_FORM_R A WITH(NOLOCK)            ' + char(10)
                     SELECT @v_dSql += ' WHERE  A.INSTANCE_ID      = '''+ @p_instance_id +'''  ' + char(10)
                     SELECT @v_dSql += ' AND    A.FP_PLAN_ID       = '''+ @p_plan_id +'''      ' + char(10)
                     SELECT @v_dSql += ' AND    A.DIVISION_ID      = '''+ @p_division_id +'''  ' + char(10)
                     SELECT @v_dSql += ' AND    A.CATEGORY_ID      = ''PLAN''                  ' + char(10)
                     SELECT @v_dSql += ' AND    A.SITE_ID          = '''+ @p_site_id +'''      ' + char(10)
                     SELECT @v_dSql += ' AND    A.PLANT_ID         = '''+ @p_plant_id +'''     ' + char(10)
                     SELECT @v_dSql += ' AND    A.ITEM_ID          = '''+ @p_item_id +'''      ' + char(10)
                     SELECT @v_dSql += ' AND    A.OPERATION_ID     = '''+ @p_operation_id +''' ' + char(10)
                     SELECT @v_dSql += ' AND    A.PRODUCTION_TYPE  = ''-''                     ' + char(10)
                     SELECT @v_dSql += ' AND    A.MARKET           = ''D''                     ' + char(10)
                     SELECT @v_dSql += ' AND    A.LINE_ID          = '''+ @p_line_id +'''      ' + char(10)
                     SELECT @v_dSql += ' AND    A.CUSTOMER_ID      = ''-''                     ' + char(10)
                     SELECT @v_dSql += ' AND    A.PLAN_DATE        = CONVERT(DATE,'''+ @p_date +''') ' + char(10)
                     SELECT @v_dSql += ' AND    A.TOP_ITEM_ID      = '''+ @p_top_item_id +''' ' + char(10)
                 END --'D'            
             /****************************************************************************/
             /* INSERT_LINE_MPPWPP  저장 경우  : merge 문으로 변경                       */
             /****************************************************************************/
             ELSE IF(@p_sys_flag ='INSERT_LINE_MPPWPP')
                 BEGIN
					SELECT @v_dSql = ''
					SELECT @v_dSql += 'MERGE INTO FP_AMEND_PLAN_FORM_H A ' + char(10)
					SELECT @v_dSql += 'USING ( ' + char(10)
					SELECT @v_dSql += '	SELECT ''' + @p_instance_id + ''' AS INSTANCE_ID ' + char(10)
					SELECT @v_dSql += '	     , ''' + @p_plan_id + ''' AS FP_PLAN_ID ' + char(10)
					SELECT @v_dSql += '	     , (SELECT MAX(COMPANY_ID) FROM SCM_FACTORY_M WHERE FACTORY_ID = ''' + @p_factory_id + ''' AND  ACTIVE_FLAG = ''Y'') AS COMPANY_ID ' + char(10)
					SELECT @v_dSql += '	     , ''' + @p_division_id + ''' AS DIVISION_ID ' + char(10)
					SELECT @v_dSql += '	     , ''PLAN'' AS CATEGORY_ID ' + char(10)
					SELECT @v_dSql += '	     , ''' + @p_site_id + ''' AS SITE_ID, ''' + @p_plant_id + ''' AS PLANT_ID ' + char(10)
					SELECT @v_dSql += '		 , ''' + @p_item_id + ''' AS ITEM_ID, ''' + @p_operation_id + ''' AS OPERATION_ID, ''' + @p_factory_id + ''' AS FACTORY_ID, ''' + @p_electrode_type + ''' AS LOCATION ' + char(10)
					SELECT @v_dSql += '		 , ''-'' AS PRODUCTION_TYPE, ''D'' AS MARKET ' + char(10)
					SELECT @v_dSql += '		 , ''' + @p_line_id + ''' AS LINE_ID, ''' + @p_electrode_type + ''' AS ELECTRODE_TYPE ' + char(10)
					SELECT @v_dSql += '		 , ''-'' AS CUSTOMER_ID ' + char(10)
					SELECT @v_dSql += '		 , CONVERT(DATE,''' + @p_date + ''') AS PLAN_DATE ' + char(10)
					SELECT @v_dSql += '		 , ''' + @p_top_item_id + ''' AS TOP_ITEM_ID, ''' + @p_item_type + ''' AS ITEM_TYPE ' + char(10)
					SELECT @v_dSql += '		 , ISNULL( ( SELECT DISTINCT A.SEGMENT3 AS GROUP_ITEM_ID ' + char(10)
					SELECT @v_dSql += '               FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
					SELECT @v_dSql += '               WHERE  A.LOOKUP_TYPE_CODE = ''MODULE_CELL_GROUP'' ' + char(10)
					SELECT @v_dSql += '               AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
					SELECT @v_dSql += '               AND    A.SEGMENT2 = ''' + @p_division_id + ''' ' + char(10)
					SELECT @v_dSql += '               AND    A.SEGMENT1 = ''' + @p_site_id + ''' ' + char(10)
					SELECT @v_dSql += '               AND    A.SEGMENT4 = ''' + @p_item_id + ''' ' + char(10)
					SELECT @v_dSql += ' 		 ), ''' + @p_item_id + ''' ) AS CELL_GROUP_CODE ' + char(10)
					SELECT @v_dSql += '		 , CEILING( ''' + @p_qty + ''' / ( SELECT ISNULL( ISNULL(MAX(B.YIELD),(CASE WHEN MAX(A.YIELD) = 0 THEN 1 ELSE MAX(A.YIELD) END)) ,1) AS YIELD ' + char(10)
					SELECT @v_dSql += '           FROM   SCM_YIELD_M A WITH(NOLOCK) ' + char(10)
					SELECT @v_dSql += '           LEFT OUTER JOIN ( ' + char(10)
					SELECT @v_dSql += '               SELECT (CASE WHEN MAX(YIELD) = 0 THEN 1 ELSE MAX(YIELD) END) AS YIELD ' + char(10)
					SELECT @v_dSql += '               FROM   SCM_YIELD_EXCEPT_M A WITH(NOLOCK) ' + char(10)
					SELECT @v_dSql += '               WHERE  A.DIVISION_ID  = ''' + @p_division_id + ''' ' + char(10)
					SELECT @v_dSql += '               AND    A.SITE_ID      = ''' + @p_site_id + ''' ' + char(10)
					SELECT @v_dSql += '               AND    A.PLANT_ID     = ''' + @p_plant_id + ''' ' + char(10)
					SELECT @v_dSql += '               AND    A.FACTORY_ID   = ''' + @p_factory_id + ''' ' + char(10)
					SELECT @v_dSql += '               AND    A.OPERATION_ID = ''' + @p_operation_id + ''' ' + char(10)
					SELECT @v_dSql += '               AND    A.LINE_ID      = ''' + @p_line_id + ''' ' + char(10)
					SELECT @v_dSql += '               AND    A.ITEM_ID      = ''' + @p_item_id + ''' ' + char(10)
					SELECT @v_dSql += '               AND    CONVERT(DATE,''' + @p_date + ''') BETWEEN A.START_TIME AND A.END_TIME ' + char(10)
					SELECT @v_dSql += '           ) B ' + char(10)
					SELECT @v_dSql += '           ON     1=1 ' + char(10)
					SELECT @v_dSql += '           WHERE  A.DIVISION_ID  = ''' + @p_division_id + ''' ' + char(10) 
					SELECT @v_dSql += '           AND    A.SITE_ID      = ''' + @p_site_id + ''' ' + char(10)
					SELECT @v_dSql += '           AND    A.PLANT_ID     = ''' + @p_plant_id + ''' ' + char(10)
					SELECT @v_dSql += '           AND    A.FACTORY_ID   = ''' + @p_factory_id + ''' ' + char(10)
					SELECT @v_dSql += '           AND    A.OPERATION_ID = ''' + @p_operation_id + ''' ' + char(10)
					SELECT @v_dSql += '           AND    A.LINE_ID      = ''' + @p_line_id + ''' ' + char(10)
					SELECT @v_dSql += '           AND    A.ITEM_ID      = ''' + @p_item_id + ''' ' + char(10)
					SELECT @v_dSql += '           AND    A.MONTH        = SUBSTRING(''' + @p_date + ''',1,6))) AS IN_QTY ' + char(10)
					SELECT @v_dSql += '		 , ''' + @p_qty + ''' AS OUT_QTY ' + char(10)
					SELECT @v_dSql += '		 , ''' + @p_user_id + ''' AS INSERT_ID, dbo.FN_SITE_TIME(''' + @p_site_id + ''') AS INSERT_TIME ' + char(10)
					SELECT @v_dSql += '		 , ''' + @p_user_id + ''' AS UPDATE_ID, dbo.FN_SITE_TIME(''' + @p_site_id + ''') AS UPDATE_TIME ' + char(10)
					SELECT @v_dSql += ') B ' + char(10)
					SELECT @v_dSql += 'ON ( A.INSTANCE_ID = B.INSTANCE_ID AND A.FP_PLAN_ID = B.FP_PLAN_ID ' + char(10)
					SELECT @v_dSql += ' AND A.DIVISION_ID = B.DIVISION_ID AND A.CATEGORY_ID = B.CATEGORY_ID AND A.SITE_ID = B.SITE_ID AND A.PLANT_ID = B.PLANT_ID ' + char(10)
					SELECT @v_dSql += ' AND A.ITEM_ID = B.ITEM_ID AND A.OPERATION_ID = B.OPERATION_ID ' + char(10)
					SELECT @v_dSql += ' AND A.PRODUCTION_TYPE = B.PRODUCTION_TYPE AND A.MARKET = B.MARKET ' + char(10)
					SELECT @v_dSql += ' AND A.LINE_ID = B.LINE_ID AND A.CUSTOMER_ID = B.CUSTOMER_ID ' + char(10)
					SELECT @v_dSql += ' AND CONVERT(VARCHAR,A.PLAN_DATE,112) = B.PLAN_DATE AND A.TOP_ITEM_ID = B.TOP_ITEM_ID ' + char(10)
					SELECT @v_dSql += ') ' + char(10)
					SELECT @v_dSql += 'WHEN MATCHED THEN ' + char(10)
					SELECT @v_dSql += '	UPDATE SET ' + char(10)

					IF (@p_mpp_wpp = 'MPP')
					BEGIN 
						SELECT @v_dSql += '	  MPP_IN_QTY      = B.IN_QTY' + char(10)
						SELECT @v_dSql += '	, MPP_OUT_QTY     = B.OUT_QTY  ' + char(10)
					END										   
					ELSE											   
					BEGIN 									   
						SELECT @v_dSql += '	  WPP_IN_QTY      = B.IN_QTY' + char(10)
						SELECT @v_dSql += '	, WPP_OUT_QTY     = B.OUT_QTY  ' + char(10)
					END

					SELECT @v_dSql += '	, PRODUCTION_TYPE = B.PRODUCTION_TYPE ' + char(10)
					SELECT @v_dSql += '	, UPDATE_ID       = B.UPDATE_ID ' + char(10)
					SELECT @v_dSql += '	, UPDATE_TIME     = B.UPDATE_TIME ' + char(10)
					SELECT @v_dSql += 'WHEN NOT MATCHED THEN ' + char(10)
					SELECT @v_dSql += '		INSERT  ( ' + char(10)
					SELECT @v_dSql += '			  INSTANCE_ID, FP_PLAN_ID ' + char(10)
					SELECT @v_dSql += '			, COMPANY_ID ' + char(10)
					SELECT @v_dSql += '			, DIVISION_ID ' + char(10)
					SELECT @v_dSql += '			, CATEGORY_ID ' + char(10)
					SELECT @v_dSql += '			, SITE_ID, PLANT_ID ' + char(10)
					SELECT @v_dSql += '			, ITEM_ID, OPERATION_ID, FACTORY_ID, LOCATION ' + char(10)
					SELECT @v_dSql += '			, PRODUCTION_TYPE, MARKET ' + char(10)
					SELECT @v_dSql += '			, LINE_ID, ELECTRODE_TYPE ' + char(10)
					SELECT @v_dSql += '			, CUSTOMER_ID ' + char(10)
					SELECT @v_dSql += '			, PLAN_DATE ' + char(10)
					SELECT @v_dSql += '			, TOP_ITEM_ID, ITEM_TYPE ' + char(10)
					SELECT @v_dSql += '			, CELL_GROUP_CODE ' + char(10)

					IF (@p_mpp_wpp = 'MPP')
					BEGIN 
						SELECT @v_dSql += '			, MPP_IN_QTY ' + char(10)
						SELECT @v_dSql += '			, MPP_OUT_QTY ' + char(10)
					END										   
					ELSE											   
					BEGIN 									   
						SELECT @v_dSql += '			, WPP_IN_QTY ' + char(10)
						SELECT @v_dSql += '			, WPP_OUT_QTY ' + char(10)
					END

					SELECT @v_dSql += '			, INSERT_ID, INSERT_TIME ' + char(10)
					SELECT @v_dSql += '			, UPDATE_ID, UPDATE_TIME ' + char(10)
					SELECT @v_dSql += '		) ' + char(10)
					SELECT @v_dSql += '		VALUES ( ' + char(10)
					SELECT @v_dSql += '			  B.INSTANCE_ID, B.FP_PLAN_ID ' + char(10)
					SELECT @v_dSql += '			, B.COMPANY_ID ' + char(10)
					SELECT @v_dSql += '			, B.DIVISION_ID ' + char(10)
					SELECT @v_dSql += '			, B.CATEGORY_ID ' + char(10)
					SELECT @v_dSql += '			, B.SITE_ID, B.PLANT_ID ' + char(10)
					SELECT @v_dSql += '			, B.ITEM_ID, B.OPERATION_ID, B.FACTORY_ID, B.LOCATION ' + char(10)
					SELECT @v_dSql += '			, B.PRODUCTION_TYPE, B.MARKET ' + char(10)
					SELECT @v_dSql += '			, B.LINE_ID, B.ELECTRODE_TYPE ' + char(10)
					SELECT @v_dSql += '			, B.CUSTOMER_ID ' + char(10)
					SELECT @v_dSql += '			, B.PLAN_DATE ' + char(10)
					SELECT @v_dSql += '			, B.TOP_ITEM_ID, B.ITEM_TYPE ' + char(10)
					SELECT @v_dSql += '			, B.CELL_GROUP_CODE ' + char(10)
					SELECT @v_dSql += '			, B.IN_QTY ' + char(10)
					SELECT @v_dSql += '			, B.OUT_QTY ' + char(10)
					SELECT @v_dSql += '			, B.INSERT_ID, B.INSERT_TIME ' + char(10)
					SELECT @v_dSql += '			, B.UPDATE_ID, B.UPDATE_TIME ' + char(10)
					SELECT @v_dSql += '		) ' + char(10)
					SELECT @v_dSql += '; ' + char(10)

                      /*
                      SELECT @v_dSql = ''
                      SELECT @v_dSql += ' INSERT INTO FP_AMEND_PLAN_FORM_H (  ' + char(10)
                      SELECT @v_dSql += '      INSTANCE_ID, FP_PLAN_ID        ' + char(10)
                      SELECT @v_dSql += '    , COMPANY_ID                     ' + char(10)
                      SELECT @v_dSql += '    , DIVISION_ID                    ' + char(10)
                      SELECT @v_dSql += '    , CATEGORY_ID                    ' + char(10)
                      SELECT @v_dSql += '    , SITE_ID, PLANT_ID              ' + char(10)
                      SELECT @v_dSql += '    , ITEM_ID, OPERATION_ID, FACTORY_ID, LOCATION  ' + char(10)
                      SELECT @v_dSql += '    , PRODUCTION_TYPE, MARKET  ' + char(10)
                      SELECT @v_dSql += '    , LINE_ID, ELECTRODE_TYPE  ' + char(10)
                      SELECT @v_dSql += '    , CUSTOMER_ID              ' + char(10)
                      SELECT @v_dSql += '    , PLAN_DATE                ' + char(10)
                      SELECT @v_dSql += '    , TOP_ITEM_ID, ITEM_TYPE   ' + char(10)
                      SELECT @v_dSql += '    , CELL_GROUP_CODE          ' + char(10)
                      IF (@p_mpp_wpp = 'MPP')
                          BEGIN 
                              SELECT @v_dSql += '    , MPP_IN_QTY      ' + char(10)
							  SELECT @v_dSql += '    , MPP_OUT_QTY     ' + char(10)
                          END										   
                      ELSE											   
                          BEGIN 									   
                              SELECT @v_dSql += '    , WPP_IN_QTY      ' + char(10)
							  SELECT @v_dSql += '    , WPP_OUT_QTY     ' + char(10)
                          END

                      SELECT @v_dSql += '    , INSERT_ID, INSERT_TIME  ' + char(10)
                      SELECT @v_dSql += '    , UPDATE_ID, UPDATE_TIME  ' + char(10)
                      SELECT @v_dSql += ' )                            ' + char(10)
                      SELECT @v_dSql += ' VALUES (                     ' + char(10)
                      SELECT @v_dSql += '       '''+ @p_instance_id +''', '''+ @p_plan_id +''' ' + char(10)
                      SELECT @v_dSql += '     , (SELECT MAX(COMPANY_ID) FROM SCM_FACTORY_M WHERE FACTORY_ID = '''+ @p_factory_id +''' AND  ACTIVE_FLAG = ''Y'')  ' + char(10)
                      SELECT @v_dSql += '     , '''+ @p_division_id +'''                                   ' + char(10)
                      SELECT @v_dSql += '     , ''PLAN''                                                   ' + char(10)
                      SELECT @v_dSql += '     , '''+ @p_site_id +''', '''+ @p_plant_id +'''                ' + char(10)
                      SELECT @v_dSql += '     , '''+ @p_item_id +''', '''+ @p_operation_id +''', '''+ @p_factory_id +''', '''+ @p_location +'''  ' + char(10)
                      SELECT @v_dSql += '     , ''-'', ''D''                                               ' + char(10)
                      SELECT @v_dSql += '     , '''+ @p_line_id +''', '''+ @p_electrode_type +'''          ' + char(10)
                      SELECT @v_dSql += '     , ''-''                                                      ' + char(10)
                      SELECT @v_dSql += '     , CONVERT(DATE,'''+ @p_date +''')                            ' + char(10)
                      SELECT @v_dSql += '     , '''+ @p_top_item_id +''', '''+ @p_item_type +'''           ' + char(10)
                      SELECT @v_dSql += '     ,ISNULL( (	SELECT DISTINCT A.SEGMENT3 AS GROUP_ITEM_ID    ' + char(10)
                      SELECT @v_dSql += '               FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)         ' + char(10)
                      SELECT @v_dSql += '               WHERE  A.LOOKUP_TYPE_CODE = ''MODULE_CELL_GROUP''  ' + char(10)
                      SELECT @v_dSql += '               AND    A.ACTIVE_FLAG = ''Y''                       ' + char(10)
                      SELECT @v_dSql += '               AND    A.SEGMENT2 = '''+ @p_division_id +'''       ' + char(10)
                      SELECT @v_dSql += '               AND    A.SEGMENT1 = '''+ @p_site_id +'''           ' + char(10)
                      SELECT @v_dSql += '               AND    A.SEGMENT4 = '''+ @p_item_id +'''           ' + char(10)
                      SELECT @v_dSql += ' 		 ), '''+ @p_item_id +''' )                                 ' + char(10)
                      SELECT @v_dSql += '     ,CEILING( '''+ @p_qty +'''                                   ' + char(10)
                      SELECT @v_dSql += '     / ( SELECT ISNULL( ISNULL(MAX(B.YIELD),(CASE WHEN MAX(A.YIELD) = 0 THEN 1 ELSE MAX(A.YIELD) END)) ,1) AS YIELD  ' + char(10)
                      SELECT @v_dSql += '           FROM   SCM_YIELD_M A WITH(NOLOCK)                      ' + char(10)
                      SELECT @v_dSql += '           LEFT OUTER JOIN (                                      ' + char(10)
                      SELECT @v_dSql += '               SELECT (CASE WHEN MAX(YIELD) = 0 THEN 1 ELSE MAX(YIELD) END) AS YIELD  ' + char(10)
                      SELECT @v_dSql += '               FROM   SCM_YIELD_EXCEPT_M A WITH(NOLOCK)           ' + char(10)
                      SELECT @v_dSql += '               WHERE  A.DIVISION_ID  = '''+ @p_division_id +'''   ' + char(10)
                      SELECT @v_dSql += '               AND    A.SITE_ID      = '''+ @p_site_id +'''       ' + char(10)
                      SELECT @v_dSql += '               AND    A.PLANT_ID     = '''+ @p_plant_id +'''      ' + char(10)
                      SELECT @v_dSql += '               AND    A.FACTORY_ID   = '''+ @p_factory_id +'''    ' + char(10)
                      SELECT @v_dSql += '               AND    A.OPERATION_ID = '''+ @p_operation_id +'''  ' + char(10)
                      SELECT @v_dSql += '               AND    A.LINE_ID      = '''+ @p_line_id +'''       ' + char(10)
                      SELECT @v_dSql += '               AND    A.ITEM_ID      = '''+ @p_item_id +'''       ' + char(10)
                      SELECT @v_dSql += '               AND    CONVERT(DATE,'''+ @p_date +''') BETWEEN A.START_TIME AND A.END_TIME  ' + char(10)
                      SELECT @v_dSql += '           ) B                                                         ' + char(10)
                      SELECT @v_dSql += '           ON     1=1                                                  ' + char(10)
                      SELECT @v_dSql += '           WHERE  A.DIVISION_ID  = '''+ @p_division_id +'''            ' + char(10)
                      SELECT @v_dSql += '           AND    A.SITE_ID      = '''+ @p_site_id +'''                ' + char(10)
                      SELECT @v_dSql += '           AND    A.PLANT_ID     = '''+ @p_plant_id +'''               ' + char(10)
                      SELECT @v_dSql += '           AND    A.FACTORY_ID   = '''+ @p_factory_id +'''             ' + char(10)
                      SELECT @v_dSql += '           AND    A.OPERATION_ID = '''+ @p_operation_id +'''           ' + char(10)
                      SELECT @v_dSql += '           AND    A.LINE_ID      = '''+ @p_line_id +'''                ' + char(10)
                      SELECT @v_dSql += '           AND    A.ITEM_ID      = '''+ @p_item_id +'''                ' + char(10)
                      SELECT @v_dSql += '           AND    A.MONTH        = SUBSTRING('''+ @p_date +''',1,6)))  ' + char(10)
                      SELECT @v_dSql += '    ,'''+ @p_qty +'''                                                  ' + char(10)
                      SELECT @v_dSql += '    ,'''+ @p_user_id +''', dbo.FN_SITE_TIME('''+ @p_site_id +''')      ' + char(10)
                      SELECT @v_dSql += '    ,'''+ @p_user_id +''', dbo.FN_SITE_TIME('''+ @p_site_id +''')      ' + char(10)
                      SELECT @v_dSql += ' )                                                                     ' + char(10)
					  */

                 END --'D'
             /****************************************************************************/
             /* INSERT_LINE_MPPWPP_LOG  경우  :  INSERT_LINE_MPPWPP                      */
             /****************************************************************************/
             ELSE IF(@p_sys_flag ='INSERT_LINE_MPPWPP_LOG')
                 BEGIN
                     SELECT @v_dSql += ' INSERT INTO HIS_AMEND_PLAN_FORM_R (                ' + char(10)
                     SELECT @v_dSql += '      INSTANCE_ID, FP_PLAN_ID                       ' + char(10)
                     SELECT @v_dSql += '     , COMPANY_ID                                   ' + char(10)
                     SELECT @v_dSql += '     , DIVISION_ID                                  ' + char(10)
                     SELECT @v_dSql += '     , CATEGORY_ID                                  ' + char(10)
                     SELECT @v_dSql += '     , SITE_ID, PLANT_ID                            ' + char(10)
                     SELECT @v_dSql += '     , ITEM_ID, OPERATION_ID, FACTORY_ID, LOCATION  ' + char(10)
                     SELECT @v_dSql += '     , PRODUCTION_TYPE, MARKET                      ' + char(10)
                     SELECT @v_dSql += '     , LINE_ID, ELECTRODE_TYPE                      ' + char(10)
                     SELECT @v_dSql += '     , CUSTOMER_ID                                  ' + char(10)
                     SELECT @v_dSql += '     , PLAN_DATE                                    ' + char(10)
                     SELECT @v_dSql += '     , TOP_ITEM_ID, ITEM_TYPE                       ' + char(10)
                     SELECT @v_dSql += '     , CELL_GROUP_CODE                              ' + char(10)
                      IF (@p_mpp_wpp = 'MPP')
                          BEGIN 
							  SELECT @v_dSql += '    , MPP_OUT_QTY             ' + char(10)
                          END										           
                      ELSE											           
                          BEGIN 									           
							  SELECT @v_dSql += '    , WPP_OUT_QTY             ' + char(10)
                          END										           
                     SELECT @v_dSql += '     , INSERT_ID, INSERT_TIME          ' + char(10)
                     SELECT @v_dSql += '     , UPDATE_ID, UPDATE_TIME          ' + char(10)
                     SELECT @v_dSql += '     , JOB_USER_ID, JOB_TIME, JOB_TYPE ' + char(10)
                     SELECT @v_dSql += ' )                                     ' + char(10)
                     SELECT @v_dSql += ' VALUES (                              ' + char(10)
                     SELECT @v_dSql += '      '''+ @p_instance_id +''', '''+ @p_plan_id +'''     ' + char(10)
                     SELECT @v_dSql += '     , (SELECT DISTINCT COMPANY_ID FROM SCM_FACTORY_M WHERE DIVISION_ID = '''+ @p_division_id +''' AND SITE_ID = '''+ @p_site_id +''' AND PLANT_ID = '''+ @p_plant_id +''' AND ACTIVE_FLAG = ''Y'') ' + char(10)
					 SELECT @v_dSql += '     , '''+ @p_division_id +'''                          ' + char(10)
                     SELECT @v_dSql += '     , ''PLAN''                                          ' + char(10)
                     SELECT @v_dSql += '     , '''+ @p_site_id +''', '''+ @p_plant_id +''','''+ @p_item_id +''', '''+ @p_operation_id +''', '''+ @p_factory_id +''', '''+ @p_location +''' ' + char(10)
                     SELECT @v_dSql += '     , ''-'', ''D''                                      ' + char(10)
                     SELECT @v_dSql += '     , '''+ @p_line_id +''', '''+ @p_electrode_type +''' ' + char(10)
                     SELECT @v_dSql += '     , ''-''                                             ' + char(10)
                     SELECT @v_dSql += '     , CONVERT(DATE,'''+ @p_date +''')                   ' + char(10)
                     SELECT @v_dSql += '     , '''+ @p_top_item_id +''', '''+ @p_item_type +'''             ' + char(10)
                     SELECT @v_dSql += '     , ISNULL( (	SELECT DISTINCT A.SEGMENT3 AS GROUP_ITEM_ID     ' + char(10)
                     SELECT @v_dSql += '                  FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)        ' + char(10)
                     SELECT @v_dSql += '                  WHERE  A.LOOKUP_TYPE_CODE = ''MODULE_CELL_GROUP'' ' + char(10)
                     SELECT @v_dSql += '                  AND    A.ACTIVE_FLAG = ''Y''                      ' + char(10)
                     SELECT @v_dSql += '                  AND    A.SEGMENT2 = '''+ @p_division_id +'''      ' + char(10)
                     SELECT @v_dSql += '                  AND    A.SEGMENT1 = '''+ @p_site_id +'''          ' + char(10)
                     SELECT @v_dSql += '                  AND    A.SEGMENT4 = '''+ @p_item_id +'''          ' + char(10)
                     SELECT @v_dSql += '               ), '''+ @p_item_id +''' )                            ' + char(10)
                     SELECT @v_dSql += '     , '''+ @p_qty +'''                                             ' + char(10)
                     SELECT @v_dSql += '     , '''+ @p_user_id +''', dbo.FN_SITE_TIME('''+ @p_site_id +''') ' + char(10)
                     SELECT @v_dSql += '     , '''+ @p_user_id +''', dbo.FN_SITE_TIME('''+ @p_site_id +''') ' + char(10)
                     SELECT @v_dSql += '     , '''+ @p_user_id +''' , GETDATE() , ''INSERT''                ' + char(10)
                     SELECT @v_dSql += ' )                                                                  ' + char(10)
                 END
             /****************************************************************************/
             /* EXECUTE  경우  :  TEST                                    */
             /****************************************************************************/
             ELSE IF(@p_sys_flag ='TEST')
             	BEGIN
             	    EXEC  @rtnCount = [dbo].[PR_SCM_OF_PSI_AMEND_UI_CALCULATION_PARALLEL_B] @p_instance_id, @p_plan_id

             	    SELECT	'Result' = @rtnCount
             	END

             IF @p_sys_type = 'SQL'
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
                     EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id,'','', @v_dSql,'SELECT',@runstart, @runend
                 END

         END --(END)           
         -- 트랜잭션 (COMMIT)
	     COMMIT TRAN
	     
	     -- 수행결과 성공여부 RETURN
	     IF @p_sys_type <> 'SQL'
	         SELECT 'SUCCESS' AS result_code,  @max_loop_cnt AS result_cnt	
	     
	     END TRY
	     BEGIN CATCH                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
             ROLLBACK TRAN                                                                                                                                                                                                                                                 
             -- 에러나도 로그는 인서트                                                                                                                                                                                                                                              
             SET @v_log_message = ERROR_MESSAGE()
             EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id,'','',@v_log_message,'excute',@runstart, @runend
             SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  
	     END CATCH    

END --MAIN END

