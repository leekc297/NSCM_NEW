


/*
 * Program ID   : PR_UI_FP03590_PDS_TARGET
 * Description  : PDS Target
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2023/08/31   LJS				Initial Release UI통합
 * 2026/03/04   SYngSn			E20260316-000249 FP 계획 수립시 PDS Target 계획 반영 유무 기능 추가 건
 */

--CREATE
CREATE
PROCEDURE [dbo].[PR_UI_FP03590_PDS_TARGET]
  @p_sys_type			  NVARCHAR(MAX),  
  @p_sys_flag			  NVARCHAR(MAX),
  @p_sys_gubun			  NVARCHAR(MAX),  
  @p_user_id			  NVARCHAR(MAX),
  @p_company_id           NVARCHAR(MAX), 
  @p_division_id          NVARCHAR(MAX),
  @p_site_id              NVARCHAR(MAX),
  @p_plant_id             NVARCHAR(MAX),
  @p_due_start_date       NVARCHAR(MAX),
  @p_due_end_date         NVARCHAR(MAX),
  @p_item_id              NVARCHAR(MAX), 
  @p_model                NVARCHAR(MAX), 
  @p_nick_name            NVARCHAR(MAX), 
  @p_factory_id           NVARCHAR(MAX), 
  @p_operation_id         NVARCHAR(MAX), 
  @p_line_id              NVARCHAR(MAX), 
  @p_line_name            NVARCHAR(MAX), 
  @p_market               NVARCHAR(MAX),
  @p_production_type      NVARCHAR(MAX), 
  @p_due_date             NVARCHAR(MAX), 
  @p_mfg_week             NVARCHAR(MAX), 
  @p_mfg_qty              NVARCHAR(MAX), 
  @p_is_prev_schedule     NVARCHAR(MAX),
  @p_demand_type          NVARCHAR(MAX),
  @p_scp_plan_id          NVARCHAR(MAX),
  @p_description          NVARCHAR(MAX),
  @p_test_target_id       NVARCHAR(MAX),
  @p_electrode_type       NVARCHAR(MAX),
  @p_active_flag          NVARCHAR(MAX) --E20260316-000249 FP 계획 수립시 PDS Target 계획 반영 유무 기능 추가 건

AS 
BEGIN  --MAIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
    SET NOCOUNT ON                                                                                                                                                                                                                                                   
	SET XACT_ABORT ON 

	DECLARE @v_sys_type			    NVARCHAR(MAX)  -- 값>> SELEC: SQL저장안함, SQL:SQL저장함
	DECLARE @v_sys_flag			    NVARCHAR(MAX)  -- 값>> I: Insert, M: Update, D: Delete, G: MERGE
	DECLARE @v_sys_gubun			NVARCHAR(MAX) 
	DECLARE @v_user_id			    NVARCHAR(MAX)
    DECLARE @v_company_id           NVARCHAR(MAX)
    DECLARE @v_division_id          NVARCHAR(MAX)
    DECLARE @v_site_id              NVARCHAR(MAX)
    DECLARE @v_plant_id             NVARCHAR(MAX)
    DECLARE @v_due_start_date       NVARCHAR(MAX)
    DECLARE @v_due_end_date         NVARCHAR(MAX)
    DECLARE @v_item_id              NVARCHAR(MAX)
    DECLARE @v_model                NVARCHAR(MAX)
    DECLARE @v_nick_name            NVARCHAR(MAX)
    DECLARE @v_factory_id           NVARCHAR(MAX)
    DECLARE @v_operation_id         NVARCHAR(MAX)
    DECLARE @v_line_id              NVARCHAR(MAX)
    DECLARE @v_line_name            NVARCHAR(MAX)
    DECLARE @v_market               NVARCHAR(MAX)
    DECLARE @v_production_type      NVARCHAR(MAX)
    DECLARE @v_due_date             NVARCHAR(MAX)
    DECLARE @v_mfg_week             NVARCHAR(MAX)
    DECLARE @v_mfg_qty              NVARCHAR(MAX)
    DECLARE @v_is_prev_schedule     NVARCHAR(MAX)
    DECLARE @v_demand_type          NVARCHAR(MAX)
    DECLARE @v_scp_plan_id          NVARCHAR(MAX)
    DECLARE @v_description          NVARCHAR(MAX)
    DECLARE @v_test_target_id       NVARCHAR(MAX)
    DECLARE @v_electrode_type       NVARCHAR(MAX)

	DECLARE @recv_active_flag       NVARCHAR(MAX)				    
	DECLARE @v_proc_name	        NVARCHAR(100) = 'PR_UI_FP03590_PDS_TARGET'
	DECLARE @v_log_type             NVARCHAR(100) = ''
	DECLARE @v_log_message          NVARCHAR(MAX) = ''
	DECLARE @v_error_description    NVARCHAR(MAX) = ''
	DECLARE @v_delimiter            NVARCHAR(1)
	DECLARE @max_loop_cnt	        INTEGER = 0
	DECLARE @mst_loop_cnt	        INTEGER = 0
	DECLARE @v_seq_no   	        INTEGER = 0

	DECLARE @v_temp1                NVARCHAR(1000)
	DECLARE @v_temp2                NVARCHAR(1000)
	DECLARE @sysdate                DATETIME      = GETDATE()
	DECLARE @runstart               datetime
    DECLARE @runend                 datetime

	DECLARE @v_dSql                 NVARCHAR(MAX)=''
	DECLARE @v_dSql1                NVARCHAR(MAX)=''
	DECLARE @v_dSql2                NVARCHAR(MAX)=''
	DECLARE @v_dSql3                NVARCHAR(MAX)=''
    DECLARE @v_active_flag			NVARCHAR(MAX)=''  --E20260316-000249 FP 계획 수립시 PDS Target 계획 반영 유무 기능 추가 건

	SELECT @v_sys_type		    = ''  -- 값>> SELEC: SQL수행결과리턴, SQL:SQL쿼리문리턴
	SELECT @v_sys_flag			= ''  -- 값>> I: Insert, M: Update, D: Delete, G: MERGE
	SELECT @v_sys_gubun			= '' 
	SELECT @v_user_id			= ''
    SELECT @v_company_id        = ''
    SELECT @v_division_id       = ''
    SELECT @v_site_id           = ''
    SELECT @v_plant_id          = ''
    SELECT @v_due_start_date    = ''
    SELECT @v_due_end_date      = ''
    SELECT @v_item_id           = ''
    SELECT @v_model             = ''
    SELECT @v_nick_name         = ''
    SELECT @v_factory_id        = ''
    SELECT @v_operation_id      = ''
    SELECT @v_line_id           = ''
    SELECT @v_line_name         = ''
    SELECT @v_market            = ''
    SELECT @v_production_type   = ''
    SELECT @v_due_date          = ''
    SELECT @v_mfg_week          = ''
    SELECT @v_mfg_qty           = ''
    SELECT @v_is_prev_schedule  = ''
    SELECT @v_demand_type       = ''
    SELECT @v_scp_plan_id       = ''
    SELECT @v_description       = ''
    SELECT @v_test_target_id    = ''
    SELECT @v_electrode_type    = '' 
    

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
	/* SELECT인경우 :S(SELECT)                                                                      */
	/************************************************************************************************/
	IF(@p_sys_flag ='S') -- 메인조회
		BEGIN --IF(START)
		    SELECT @v_dSql = ''

			SELECT @v_dSql += 'SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.SHOP_GROUP_ID ' + char(10)
			SELECT @v_dSql += '     , A.PDS_PLAN_ID, A.PDS_TARGET_ID, A.PDS_TARGET_ID_ORG ' + char(10)
			SELECT @v_dSql += '     , A.MODEL, A.ITEM_ID ' + char(10)
			SELECT @v_dSql += '     , A.MARKET, A.PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql += '     , A.VERSION, A.PLM_EC_NO ' + char(10)
			SELECT @v_dSql += '     , A.FACTORY_ID, A.LINE_ID, A.OPERATION_ID, A.PDS_EQUIPMENT_ID ' + char(10)
			--SELECT @v_dSql += '     , CONVERT(VARCHAR(8), A.DUE_DATE, 112) AS DUE_DATE, A.SEQ ' + char(10)
			SELECT @v_dSql += '     , A.DUE_DATE, A.SEQ ' + char(10)
			SELECT @v_dSql += '     , A.MFG_WEEK, A.MFG_QTY, A.MFG_QTY_UOM ' + char(10)
			SELECT @v_dSql += '     , A.ORG_MFG_QTY, A.ORG_MFG_QTY_UOM ' + char(10)
			SELECT @v_dSql += '     , A.DESCRIPTION, A.DEMAND_TYPE, A.PREV_OPER_PLANNING_YN ' + char(10)
			SELECT @v_dSql += '     , A.IS_PREV_SCHEDULE ' + char(10)
			SELECT @v_dSql += '     , A.INSERT_ID, CONVERT(VARCHAR, A.INSERT_TIME, 20) AS INSERT_TIME ' + char(10)
			SELECT @v_dSql += '     , A.UPDATE_ID, CONVERT(VARCHAR, A.UPDATE_TIME, 20) AS UPDATE_TIME ' + char(10)
			SELECT @v_dSql += '     , ISNULL(B.NICK_NAME,''-'') AS NICK_NAME ' + char(10)
			SELECT @v_dSql += '     , ISNULL(C.LINE_NAME,''-'') AS LINE_NAME ' + char(10)
			SELECT @v_dSql += '     , (CASE WHEN R.SAVE_FLAG = ''Y'' THEN ''Y'' ELSE ''N'' END) AS EDIT_YN ' + char(10) -- 저장 가능 여부
            SELECT @v_dSql += '     , ISNULL(A.ACTIVE_FLAG,''Y'') AS ACTIVE_FLAG ' + char(10)   --E20260316-000249 FP 계획 수립시 PDS Target 계획 반영 유무 기능 추가 건
			SELECT @v_dSql += 'FROM   FP_WEEKLY_DEMAND_PRODUCT_PDS_H A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += 'INNER JOIN SCM_ITEM_M B WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += 'ON  1=1 ' + char(10)
			SELECT @v_dSql += 'AND A.COMPANY_ID  = B.COMPANY_ID ' + char(10)
			SELECT @v_dSql += 'AND A.DIVISION_ID = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql += 'AND A.SITE_ID     = B.SITE_ID ' + char(10)
			SELECT @v_dSql += 'AND A.ITEM_ID     = B.ITEM_ID ' + char(10)
			SELECT @v_dSql += 'LEFT OUTER JOIN ( ' + char(10)
			SELECT @v_dSql += '	SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, LINE_NAME ' + char(10)
			SELECT @v_dSql += '	FROM ( ' + char(10)
			SELECT @v_dSql += '			SELECT * ' + char(10)
			SELECT @v_dSql += '				 , ROW_NUMBER() OVER(PARTITION BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID ' + char(10)
			SELECT @v_dSql += '									 ORDER BY     ELECTRODE_TYPE DESC) ROW_NUM ' + char(10)
			SELECT @v_dSql += '			FROM  SCM_LINE_M MM WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += '			WHERE ACTIVE_FLAG = ''Y'' ' + char(10)
			--SELECT @v_dSql += '			-- div, site, plant 조건 추가
			SELECT @v_dSql += '	) A ' + char(10)
			SELECT @v_dSql += '	WHERE ROW_NUM = 1 ' + char(10)
			SELECT @v_dSql += ') C ' + char(10)
			SELECT @v_dSql += 'ON  1=1 ' + char(10)
			SELECT @v_dSql += 'AND A.COMPANY_ID   = C.COMPANY_ID ' + char(10)
			SELECT @v_dSql += 'AND A.DIVISION_ID  = C.DIVISION_ID ' + char(10)
			SELECT @v_dSql += 'AND A.SITE_ID      = C.SITE_ID ' + char(10)
			SELECT @v_dSql += 'AND A.PLANT_ID     = C.PLANT_ID ' + char(10)
			SELECT @v_dSql += 'AND A.FACTORY_ID   = C.FACTORY_ID ' + char(10)
			SELECT @v_dSql += 'AND A.OPERATION_ID = C.OPERATION_ID ' + char(10)
			SELECT @v_dSql += 'AND A.LINE_ID      = C.LINE_ID ' + char(10)
			SELECT @v_dSql += 'INNER JOIN ( ' + char(10)
			SELECT @v_dSql += '    SELECT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID, R.OPERATION_ID, R.LINE_ID, MAX(R.SAVE_FLAG) AS SAVE_FLAG ' + char(10) -- R.SAVE_FLAG 로 행 별 입력가능여부 판단
			SELECT @v_dSql += '    FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += '    WHERE  R.USER_ID     = ''' + @p_user_id + ''' ' + char(10)
  	        SELECT @v_dSql += '    ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('R.DIVISION_ID', 'EQ', @p_division_id ))
  	        SELECT @v_dSql += '    ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('R.SITE_ID', 'EQ', @p_site_id ))
  	        SELECT @v_dSql += '    ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('R.PLANT_ID', 'EQ', @p_plant_id )) + char(10)
			--SELECT @v_dSql += '	-- div, site, plant 조건 추가
			SELECT @v_dSql += '    GROUP BY R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID, R.OPERATION_ID, R.LINE_ID ' + char(10)
			SELECT @v_dSql += ') R ' + char(10)
			SELECT @v_dSql += 'ON   A.COMPANY_ID   = R.COMPANY_ID ' + char(10)
			SELECT @v_dSql += 'AND  A.DIVISION_ID  = R.DIVISION_ID ' + char(10)
			SELECT @v_dSql += 'AND  A.SITE_ID      = R.SITE_ID ' + char(10)
			SELECT @v_dSql += 'AND  A.PLANT_ID     = R.PLANT_ID ' + char(10)
			SELECT @v_dSql += 'AND  A.FACTORY_ID   = R.FACTORY_ID ' + char(10)
			SELECT @v_dSql += 'AND  A.OPERATION_ID = R.OPERATION_ID ' + char(10)
			SELECT @v_dSql += 'AND  A.LINE_ID      = R.LINE_ID ' + char(10)
			SELECT @v_dSql += 'WHERE 1=1 ' + char(10)
			SELECT @v_dSql += 'AND  A.DUE_DATE BETWEEN CONVERT(VARCHAR, ''' + @p_due_start_date + ''', 112) AND CONVERT(VARCHAR, ''' + @p_due_end_date + ''', 112) ' + char(10)
  	        SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID', 'EQ', @p_division_id ))
  	        SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID', 'EQ', @p_site_id ))
  	        SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID', 'EQ', @p_plant_id ))
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID', 'LIKE', @p_item_id ))
	        SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.NICK_NAME', 'LIKE', @p_nick_name )) + char(10)
			SELECT @v_dSql += 'ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.SHOP_GROUP_ID ' + char(10)
			SELECT @v_dSql += '       , A.PDS_PLAN_ID, A.PDS_TARGET_ID ' + char(10)
			SELECT @v_dSql += '       , A.MODEL, A.ITEM_ID ' + char(10)
			SELECT @v_dSql += '       , A.MARKET, A.PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql += '       , A.VERSION, A.PLM_EC_NO ' + char(10)
			SELECT @v_dSql += '       , A.FACTORY_ID, A.LINE_ID, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql += '       , A.DUE_DATE ' + char(10)

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
	/* SELECT인경우 :SELECT_IMPORT(Import Popup)                                                    */
	/************************************************************************************************/
	ELSE IF(@p_sys_flag ='SELECT_IMPORT')
		BEGIN --IF(START)
		    SELECT @v_dSql = '';
			SELECT @v_dSql += '  SELECT A.COMPANY_ID As COMPANY_ID, A.DIVISION_ID As DIVISION_ID, A.SITE_ID  As SITE_ID  ' + char(10)
			SELECT @v_dSql += '    , A.PLANT_ID As PLANT_ID, A.TEST_TARGET_ID As TEST_TARGET_ID, A.MODEL As MODEL        ' + char(10)
			SELECT @v_dSql += '    , A.ITEM_ID As ITEM_ID, A.FACTORY_ID As FACTORY_ID, A.OPERATION_ID As OPERATION_ID    ' + char(10)
			SELECT @v_dSql += '	   , A.LINE_ID As LINE_ID, A.MARKET As MARKET, A.PRODUCTION_TYPE  As PRODUCTION_TYPE     ' + char(10)
			SELECT @v_dSql += '	   , CONVERT( VARCHAR(8), A.DUE_DATE, 112) AS DUE_DATE                       ' + char(10)
			SELECT @v_dSql += '	   , A.MFG_WEEK As MFG_WEEK, A.MFG_QTY As MFG_QTY                            ' + char(10)
			SELECT @v_dSql += '	   , A.DESCRIPTION As DESCRIPTION , ISNULL(B.NICK_NAME, ''-'') AS NICK_NAME  ' + char(10)
			SELECT @v_dSql += '	   , A.IS_PREV_SCHEDULE As IS_PREV_SCHEDULE, A.DEMAND_TYPE As DEMAND_TYPE    ' + char(10)
			SELECT @v_dSql += '	   , A.SCP_PLAN_ID As SCP_PLAN_ID              ' + char(10)
			SELECT @v_dSql += '	   , '''' As MESSAGE_ID                        ' + char(10)
			SELECT @v_dSql += '	   , (CASE WHEN R.FACTORY_ID IS NULL THEN ''N'' ELSE ''Y'' END) AS VALID_YN  ' + char(10)
			SELECT @v_dSql += '  FROM   FP_WEEKLY_DEMAND_PRODUCT_PDS_H A WITH(NOLOCK)      ' + char(10)
			SELECT @v_dSql += '  LEFT OUTER JOIN SCM_ITEM_M B WITH(NOLOCK)                  ' + char(10)
			SELECT @v_dSql += '  ON     A.COMPANY_ID   = B.COMPANY_ID                       ' + char(10)
			SELECT @v_dSql += '  AND    A.DIVISION_ID  = B.DIVISION_ID                      ' + char(10)
			SELECT @v_dSql += '  AND    A.SITE_ID      = B.SITE_ID                          ' + char(10)
			SELECT @v_dSql += '  AND    A.MODEL        = B.ITEM_ID                          ' + char(10)
			SELECT @v_dSql += '  LEFT OUTER JOIN (                                          ' + char(10)
			SELECT @v_dSql += '	   SELECT DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID   ' + char(10)
			SELECT @v_dSql += '	   , R.PLANT_ID, R.FACTORY_ID, R.OPERATION_ID, R.LINE_ID    ' + char(10)
			SELECT @v_dSql += '	   FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK)                ' + char(10)
			SELECT @v_dSql += '	   WHERE  R.USER_ID   = '''+ @p_user_id +'''                ' + char(10)
			SELECT @v_dSql += '	   AND    R.SAVE_FLAG = ''Y''                               ' + char(10)
			SELECT @v_dSql += '  ) R                                                        ' + char(10)
			SELECT @v_dSql += '  ON   A.COMPANY_ID   = R.COMPANY_ID               ' + char(10)
			SELECT @v_dSql += '  AND  A.DIVISION_ID  = R.DIVISION_ID              ' + char(10)
			SELECT @v_dSql += '  AND  A.SITE_ID      = R.SITE_ID                  ' + char(10)
			SELECT @v_dSql += '  AND  A.PLANT_ID     = R.PLANT_ID                 ' + char(10)
			SELECT @v_dSql += '  AND  A.FACTORY_ID   = R.FACTORY_ID               ' + char(10)
			SELECT @v_dSql += '  AND  A.OPERATION_ID = R.OPERATION_ID             ' + char(10)
			SELECT @v_dSql += '  AND  A.LINE_ID      = R.LINE_ID                  ' + char(10)
			SELECT @v_dSql += '  WHERE  B.ACTIVE_FLAG  = ''Y''                    ' + char(10)
			SELECT @v_dSql += '  AND    EXISTS (                                  ' + char(10)
			SELECT @v_dSql += '		SELECT 1                                      ' + char(10)
			SELECT @v_dSql += '		FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)     ' + char(10)
			SELECT @v_dSql += '		WHERE  A.COMPANY_ID   = B.COMPANY_ID          ' + char(10)
			SELECT @v_dSql += '		AND    A.DIVISION_ID  = B.DIVISION_ID         ' + char(10)
			SELECT @v_dSql += '		AND    A.SITE_ID      = B.SITE_ID             ' + char(10)
			SELECT @v_dSql += '		AND    A.PLANT_ID     = B.PLANT_ID            ' + char(10)
			SELECT @v_dSql += '		AND    A.FACTORY_ID   = B.FACTORY_ID          ' + char(10)
			SELECT @v_dSql += '		AND    A.OPERATION_ID = B.OPERATION_ID        ' + char(10)
			SELECT @v_dSql += '		AND    A.LINE_ID      = B.LINE_ID             ' + char(10)
			SELECT @v_dSql += '		AND    B.USER_ID      = '''+ @p_user_id +'''  ' + char(10)
			SELECT @v_dSql += '  )                                                ' + char(10)
			SELECT @v_dSql += ' AND    CONVERT(VARCHAR(8), A.DUE_DATE, 112) BETWEEN '''+ @p_due_start_date +''' AND '''+ @p_due_end_date +''' ' + char(10)
  	        SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID', 'EQ', @p_division_id ))         + char(10)
  	        SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID', 'EQ', @p_site_id ))                 + char(10)
  	        SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID', 'EQ', @p_plant_id ))               + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID', 'LIKE', @p_item_id ))               + char(10)
	        SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.NICK_NAME', 'LIKE', @p_nick_name ))           + char(10)
			SELECT @v_dSql += ' ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID '                        + char(10)
			SELECT @v_dSql += '	 , A.SCP_PLAN_ID, A.MODEL, A.ITEM_ID, A.DUE_DATE   '                              + char(10)

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
	/* SEL_VALID인경우 :(Excel Upload Validation Select)                                            */
	/************************************************************************************************/
    ELSE IF(@p_sys_flag ='SELECT_VALID')
	    BEGIN --ELSE IF(START)
		    SELECT @v_dSql1 = ''
			SELECT @v_dSql1 += '  SELECT A.COMPANY_ID As COMPANY_ID, A.DIVISION_ID As DIVISION_ID, A.SITE_ID  As SITE_ID              ' + char(10)
			SELECT @v_dSql1 += '    , A.PLANT_ID As PLANT_ID, A.TEST_TARGET_ID As TEST_TARGET_ID, A.MODEL As MODEL                    ' + char(10)
			SELECT @v_dSql1 += '    , A.ITEM_ID As ITEM_ID,  A.FACTORY_ID As FACTORY_ID                                               ' + char(10)
			SELECT @v_dSql1 += '	, A.OPERATION_ID As OPERATION_ID, A.LINE_ID As LINE_ID                                            ' + char(10)
			SELECT @v_dSql1 += '	, A.MARKET As MARKET, A.PRODUCTION_TYPE  As PRODUCTION_TYPE, A.DUE_DATE AS DUE_DATE               ' + char(10)
			SELECT @v_dSql1 += '	, A.MFG_WEEK As MFG_WEEK, A.MFG_QTY As MFG_QTY, A.DESCRIPTION As DESCRIPTION                      ' + char(10)
			SELECT @v_dSql1 += '	, ISNULL(A.NICK_NAME, ''-'') AS NICK_NAME, A.IS_PREV_SCHEDULE As IS_PREV_SCHEDULE, A.DEMAND_TYPE As DEMAND_TYPE, A.SCP_PLAN_ID As SCP_PLAN_ID   ' + char(10)
			SELECT @v_dSql1 += '	, A.MESSAGE_ID AS  MESSAGE_ID                                                                    ' + char(10)
            SELECT @v_dSql1 += '    , CASE WHEN A.MESSAGE_ID = '' Not Found'' AND MSG99 = '''' THEN ''Y'' ELSE ''N'' END AS VALID_YN ' + char(10)
            SELECT @v_dSql1 += ' FROM (                                                                                              ' + char(10)
            SELECT @v_dSql1 += '       SELECT A.*                                                                                    ' + char(10)
            SELECT @v_dSql1 += '   	     ,MSG1 + (CASE WHEN (MSG1 = '''') THEN MSG2 ELSE (CASE WHEN MSG2 = '''' THEN '''' ELSE '','' + MSG2 END) END)     ' + char(10)
            SELECT @v_dSql1 += '   	     + (CASE WHEN (MSG1 = '''' AND MSG2 = '''') THEN MSG3 ELSE (CASE WHEN MSG3 = '''' THEN '''' ELSE '','' + MSG3 END) END)     ' + char(10)
            SELECT @v_dSql1 += '   	     + (CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''') THEN MSG4 ELSE (CASE WHEN MSG4 = '''' THEN '''' ELSE '','' + MSG4 END) END)     ' + char(10)
            SELECT @v_dSql1 += '   	     + (CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''' AND MSG4 = '''')  THEN MSG5 ELSE (CASE WHEN MSG5 = '''' THEN '''' ELSE '','' + MSG5 END) END)     ' + char(10)
            SELECT @v_dSql1 += '   	     + (CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''' AND MSG4 = '''' AND MSG5 = '''')  THEN MSG6 ELSE (CASE WHEN MSG6 = '''' THEN '''' ELSE '','' + MSG6 END) END)     ' + char(10)
            SELECT @v_dSql1 += '   	     + (CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''' AND MSG4 = '''' AND MSG5 = '''' AND MSG6 = '''')  THEN MSG7 ELSE (CASE WHEN MSG7 = '''' THEN '''' ELSE '','' + MSG7 END) END)     ' + char(10)
            SELECT @v_dSql1 += '   	     + (CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''' AND MSG4 = '''' AND MSG5 = '''' AND MSG6 = '''' AND MSG7 = '''')  THEN MSG8 ELSE (CASE WHEN MSG8 = '''' THEN '''' ELSE '','' + MSG8 END) END)     ' + char(10)
            SELECT @v_dSql1 += '   	     + (CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''' AND MSG4 = '''' AND MSG5 = '''' AND MSG6 = '''' AND MSG7 = '''' AND MSG8 = '''')  THEN MSG9 ELSE (CASE WHEN MSG9 = '''' THEN '''' ELSE '','' + MSG9 END) END)     ' + char(10)
            SELECT @v_dSql1 += '   	     + (CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''' AND MSG4 = '''' AND MSG5 = '''' AND MSG6 = '''' AND MSG7 = '''' AND MSG8 = '''' AND MSG9 = '''')  THEN MSG10 ELSE (CASE WHEN MSG10 = '''' THEN '''' ELSE '','' + MSG10 END) END)     ' + char(10)
            SELECT @v_dSql1 += '   	     + (CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''' AND MSG4 = '''' AND MSG5 = '''' AND MSG6 = '''' AND MSG7 = '''' AND MSG8 = '''' AND MSG9 = '''' AND MSG10 = '''')  THEN MSG11 ELSE (CASE WHEN MSG11 = '''' THEN '''' ELSE '','' + MSG11 END) END)     ' + char(10)
            SELECT @v_dSql1 += '   	     + '' Not Found'' AS MESSAGE_ID                               ' + char(10)
            SELECT @v_dSql1 += '       FROM (                                                         ' + char(10)
            SELECT @v_dSql1 += '             SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID            ' + char(10)
            SELECT @v_dSql1 += '                , A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID            ' + char(10)
            SELECT @v_dSql1 += '                , A.LINE_ID, A.SCP_PLAN_ID, A.TEST_TARGET_ID          ' + char(10)
            SELECT @v_dSql1 += '                , A.ITEM_ID, A.MODEL, ISNULL(B.NICK_NAME, ''-'') AS NICK_NAME             ' + char(10)
            SELECT @v_dSql1 += '                , CONVERT(VARCHAR(8), A.DUE_DATE, 112) AS DUE_DATE, A.MFG_WEEK, A.MFG_QTY ' + char(10)
            SELECT @v_dSql1 += '                , A.SEQ, A.DESCRIPTION, A.DEMAND_TYPE                 ' + char(10)
            SELECT @v_dSql1 += '                , A.IS_PREV_SCHEDULE, A.MARKET, A.PRODUCTION_TYPE     ' + char(10)
            SELECT @v_dSql1 += '      	       , A.JOB_USER_ID, A.JOB_TIME, A.JOB_TYPE                ' + char(10)
            SELECT @v_dSql1 += '     		   , A.JOB_SEQ, A.JOB_ORDER, CASE WHEN B.ITEM_ID IS NULL THEN ''Material'' ELSE '''' END AS MSG1 ' + char(10)
            SELECT @v_dSql1 += '     		   , CASE WHEN C.FACTORY_ID IS NULL THEN ''Building'' ELSE '''' END AS MSG2    ' + char(10)
            SELECT @v_dSql1 += '     		   , CASE WHEN D.DT IS NULL THEN ''SCP Date'' ELSE '''' END AS MSG3            ' + char(10)
            SELECT @v_dSql1 += '     		   , CASE WHEN E.OPERATION_ID IS NULL THEN ''Operation'' ELSE '''' END AS MSG4 ' + char(10)
            SELECT @v_dSql1 += '     		   , CASE WHEN F.LINE_ID IS NULL THEN ''Line'' ELSE '''' END AS MSG5           ' + char(10)
            SELECT @v_dSql1 += '     		   , '''' AS MSG6                                                              ' + char(10)
            SELECT @v_dSql1 += '     		   , CASE WHEN H.CODE_ID IS NULL THEN ''Market'' ELSE '''' END AS MSG7         ' + char(10)
            SELECT @v_dSql1 += '     		   , CASE WHEN I.ITEM_ID IS NULL THEN ''Model-Material Relation'' ELSE '''' END AS MSG8                    ' + char(10)
            SELECT @v_dSql1 += '     		   , CASE WHEN J.OPERATION_ID IS NOT NULL THEN ''Unacceptable Operation'' ELSE '''' END AS MSG9            ' + char(10)
            SELECT @v_dSql1 += '     		   , CASE WHEN R.FACTORY_ID IS NULL THEN ''Permissions'' ELSE '''' END AS MSG10                            ' + char(10)
            SELECT @v_dSql1 += '			 	   , CASE WHEN K.PRODUCTION_TYPE IS NULL THEN ''PRODUCTION TYPE'' ELSE '''' END AS MSG11               ' + char(10)
            SELECT @v_dSql1 += '   			   , CASE WHEN ROW_NUMBER() OVER(PARTITION BY A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID              ' + char(10)
			SELECT @v_dSql1 += '   			               ,A.FACTORY_ID,A.OPERATION_ID,A.LINE_ID,A.ITEM_ID,A.DUE_DATE,A.MARKET, A.PRODUCTION_TYPE     ' + char(10)
            SELECT @v_dSql1 += '   				          ORDER BY  A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID,A.OPERATION_ID        ' + char(10)
			SELECT @v_dSql1 += '   				                   ,A.LINE_ID,A.ITEM_ID,A.DUE_DATE,A.MARKET,A.PRODUCTION_TYPE)>1 THEN ''Data Overlap'' ' + char(10)
            SELECT @v_dSql1 += '   					 ELSE '''' END AS MSG99                        ' + char(10)
            SELECT @v_dSql1 += '            FROM   BUF_WEEKLY_DEMAND_PRODUCT_TEST_H A WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql1 += '            LEFT OUTER JOIN (                                      ' + char(10)
            SELECT @v_dSql1 += '            		 SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.NICK_NAME ' + char(10)
            SELECT @v_dSql1 += '            		 FROM   SCM_ITEM_M A WITH(NOLOCK), SCM_ITEM_CLASS_M B WITH(NOLOCK)              ' + char(10)
            SELECT @v_dSql1 += '            		 WHERE  A.ITEM_CLASS  = B.CLASS_ID ' + char(10)
            SELECT @v_dSql1 += '            		 AND    A.ACTIVE_FLAG = ''Y''      ' + char(10)
            SELECT @v_dSql1 += '            		 AND    B.USE_FLAG    = ''Y''      ' + char(10)
            SELECT @v_dSql1 += '            ) B                                        ' + char(10)
            
			SELECT @v_dSql2 = ''
			SELECT @v_dSql2 += '            ON  A.COMPANY_ID  = B.COMPANY_ID                   ' + char(10)
            SELECT @v_dSql2 += '            AND A.DIVISION_ID = B.DIVISION_ID                  ' + char(10)
            SELECT @v_dSql2 += '            AND A.SITE_ID     = B.SITE_ID                      ' + char(10)
            SELECT @v_dSql2 += '            AND A.ITEM_ID     = B.ITEM_ID                      ' + char(10)
            SELECT @v_dSql2 += '            LEFT OUTER JOIN SCM_FACTORY_M C WITH(NOLOCK)       ' + char(10)
            SELECT @v_dSql2 += '            ON  A.COMPANY_ID  = C.COMPANY_ID                   ' + char(10)
            SELECT @v_dSql2 += '            AND A.DIVISION_ID = C.DIVISION_ID                  ' + char(10)
            SELECT @v_dSql2 += '            AND A.SITE_ID     = C.SITE_ID                      ' + char(10)
            SELECT @v_dSql2 += '            AND A.PLANT_ID    = C.PLANT_ID                     ' + char(10)
            SELECT @v_dSql2 += '            AND A.FACTORY_ID  = C.FACTORY_ID                   ' + char(10)
            SELECT @v_dSql2 += '            AND C.ACTIVE_FLAG = ''Y''                          ' + char(10)
            SELECT @v_dSql2 += '            LEFT OUTER JOIN TH_UIS_CAL D WITH(NOLOCK)          ' + char(10)
            SELECT @v_dSql2 += '            ON  CONVERT(VARCHAR(8), A.DUE_DATE, 112) = D.DT    ' + char(10)
            SELECT @v_dSql2 += '            LEFT OUTER JOIN SCM_OPERATION_M E WITH(NOLOCK)     ' + char(10)
            SELECT @v_dSql2 += '            ON  A.COMPANY_ID   = E.COMPANY_ID                  ' + char(10)
            SELECT @v_dSql2 += '            AND A.DIVISION_ID  = E.DIVISION_ID                 ' + char(10)
            SELECT @v_dSql2 += '            AND A.SITE_ID      = E.SITE_ID                     ' + char(10)
            SELECT @v_dSql2 += '            AND A.OPERATION_ID = E.OPERATION_ID                ' + char(10)
            SELECT @v_dSql2 += '            AND E.ACTIVE_FLAG  = ''Y''                         ' + char(10)
            SELECT @v_dSql2 += '            LEFT OUTER JOIN (                                  ' + char(10)
            SELECT @v_dSql2 += '                SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID  ' + char(10)
			SELECT @v_dSql2 += '                , A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID     ' + char(10)
            SELECT @v_dSql2 += '                FROM   SCM_LINE_M A WITH(NOLOCK)                          ' + char(10)
            SELECT @v_dSql2 += '                WHERE  ACTIVE_FLAG = ''Y''                                ' + char(10)
            SELECT @v_dSql2 += '                GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID           ' + char(10)
			SELECT @v_dSql2 += '                    , A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID ' + char(10)
            SELECT @v_dSql2 += '            ) F                                  ' + char(10)
            SELECT @v_dSql2 += '            ON  A.COMPANY_ID   = F.COMPANY_ID    ' + char(10)
            SELECT @v_dSql2 += '            AND A.DIVISION_ID  = F.DIVISION_ID   ' + char(10)
            SELECT @v_dSql2 += '            AND A.SITE_ID      = F.SITE_ID       ' + char(10)
            SELECT @v_dSql2 += '            AND A.PLANT_ID     = F.PLANT_ID      ' + char(10)
            SELECT @v_dSql2 += '            AND A.FACTORY_ID   = F.FACTORY_ID    ' + char(10)
            SELECT @v_dSql2 += '            AND A.OPERATION_ID = F.OPERATION_ID  ' + char(10)
            SELECT @v_dSql2 += '            AND A.LINE_ID      = F.LINE_ID       ' + char(10)
            SELECT @v_dSql2 += '            LEFT OUTER JOIN (                    ' + char(10)
            SELECT @v_dSql2 += '                SELECT ''Y'' AS CODE_ID, ''Y'' AS CODE_NAME ' + char(10)
            SELECT @v_dSql2 += '                UNION ALL                                   ' + char(10)
            SELECT @v_dSql2 += '                SELECT ''N'' AS CODE_ID, ''N'' AS CODE_NAME ' + char(10)
            SELECT @v_dSql2 += '            ) G                                             ' + char(10)
            SELECT @v_dSql2 += '            ON  A.IS_PREV_SCHEDULE = G.CODE_ID              ' + char(10)
            SELECT @v_dSql2 += '            LEFT OUTER JOIN (                               ' + char(10)
            SELECT @v_dSql2 += '                SELECT DISTINCT A.SEGMENT1 AS CODE_ID       ' + char(10)
            SELECT @v_dSql2 += '                FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)  ' + char(10)
            SELECT @v_dSql2 += '                WHERE  A.LOOKUP_TYPE_CODE = ''DEMAND_MARKET_TYPE'' ' + char(10)
            SELECT @v_dSql2 += '            ) H                         ' + char(10)
            SELECT @v_dSql2 += '            ON    A.MARKET = H.CODE_ID  ' + char(10)
            SELECT @v_dSql2 += '            LEFT OUTER HASH JOIN (      ' + char(10)
            SELECT @v_dSql2 += '                 SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
            SELECT @v_dSql2 += '                      , ( CASE WHEN A.SCP_OPERATION_GROUP=''E'' THEN A.MODEL_ID ELSE A.MODEL END ) AS MODEL_ID ' + char(10)
            SELECT @v_dSql2 += '                      , A.ITEM_ID, A.FLOW_ID, A.FORMATION_FLOW_ID ' + char(10)
            SELECT @v_dSql2 += '                 FROM (                                           ' + char(10)
            SELECT @v_dSql2 += '                         SELECT  CT.COMPANY_ID,MAX(CT.DIVISION_ID) AS DIVISION_ID, CT.SITE_ID           ' + char(10)
            SELECT @v_dSql2 += '                           , CT.PLANT_ID, CT.MODEL_ID, CT.CHILD_ITEM_ID AS ITEM_ID                      ' + char(10)
            SELECT @v_dSql2 += '                           , MAX(CT.FLOW_ID) AS FLOW_ID, MAX(CT.FORMATION_FLOW_ID) AS FORMATION_FLOW_ID ' + char(10)
            SELECT @v_dSql2 += '            		 	     , MAX(CT.SCP_OPERATION_GROUP) AS SCP_OPERATION_GROUP, CT.MODEL             ' + char(10)
            SELECT @v_dSql2 += '                         FROM (                                                                ' + char(10)
            SELECT @v_dSql2 += '                              SELECT  CT.COMPANY_ID, CT.DIVISION_ID, CT.SITE_ID                ' + char(10)
            SELECT @v_dSql2 += '                                    , CT.PLANT_ID, CT.MODEL_ID, CT.CHILD_ITEM_ID               ' + char(10)
            SELECT @v_dSql2 += '                                    , SUBSTRING(SI.FLOW_ID,1,5) AS FLOW_ID                     ' + char(10)
            SELECT @v_dSql2 += '                                    , SUBSTRING(SI.FORMATION_FLOW_ID,1,5) AS FORMATION_FLOW_ID ' + char(10)
            SELECT @v_dSql2 += '                                    , CT.MODEL_ID AS MODEL, IC.SCP_OPERATION_GROUP             ' + char(10)
            SELECT @v_dSql2 += '                              FROM   SCM_MODEL_COMP_TEMP CT WITH(NOLOCK)                       ' + char(10)
            SELECT @v_dSql2 += '                                    ,SCM_ITEM_M SI WITH(NOLOCK)                                ' + char(10)
            SELECT @v_dSql2 += '                                    ,SCM_ITEM_CLASS_M IC WITH(NOLOCK)      ' + char(10)
            SELECT @v_dSql2 += '                              WHERE  CT.CHILD_COMPANY_ID  = SI.COMPANY_ID  ' + char(10)
            SELECT @v_dSql2 += '                              AND    CT.CHILD_DIVISION_ID = SI.DIVISION_ID ' + char(10)
            SELECT @v_dSql2 += '                              AND    CT.CHILD_SITE_ID     = SI.SITE_ID     ' + char(10)
            SELECT @v_dSql2 += '                              AND    CT.CHILD_ITEM_ID     = SI.ITEM_ID     ' + char(10)
            SELECT @v_dSql2 += '                              AND    SI.ITEM_CLASS        = IC.CLASS_ID    ' + char(10)
            SELECT @v_dSql2 += '                              AND    IC.USE_FLAG          = ''Y''          ' + char(10)
            SELECT @v_dSql2 += '                              AND    SI.ACTIVE_FLAG       = ''Y''          ' + char(10)
            SELECT @v_dSql2 += '                              AND    ISNULL(SI.ITEM_TYPE,''H'') IN (''P'',''Q'',''H'')             ' + char(10)
            SELECT @v_dSql2 += '                              AND    (SI.FLOW_ID IS NOT NULL OR SI.FORMATION_FLOW_ID IS NOT NULL)  ' + char(10)
            SELECT @v_dSql2 += '                              AND    CT.ALT_PRIORITY      = ''Y''                                  ' + char(10)
            SELECT @v_dSql2 += '                              UNION ALL                                                            ' + char(10)
            SELECT @v_dSql2 += '                              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID                        ' + char(10)
            SELECT @v_dSql2 += '                                   , B.PLANT_ID, A.ITEM_ID AS MODEL_ID, A.ITEM_ID AS CHILD_ITEM_ID ' + char(10)
            SELECT @v_dSql2 += '                                   , SUBSTRING(A.FLOW_ID,1,5) AS FLOW_ID                           ' + char(10)
            SELECT @v_dSql2 += '                                   , SUBSTRING(A.FORMATION_FLOW_ID,1,5) AS FORMATION_FLOW_ID       ' + char(10)
            SELECT @v_dSql2 += '                                   , A.ITEM_ID AS MODEL, IC.SCP_OPERATION_GROUP                    ' + char(10)
            SELECT @v_dSql2 += '                              FROM   SCM_ITEM_M A WITH(NOLOCK)        ' + char(10)
			SELECT @v_dSql2 += '                                   , SCM_PLANT_M B WITH(NOLOCK)       ' + char(10)
			SELECT @v_dSql2 += '                                   , SCM_ITEM_CLASS_M IC WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql2 += '                              WHERE  A.COMPANY_ID   = B.COMPANY_ID    ' + char(10)
            SELECT @v_dSql2 += '                              AND    A.DIVISION_ID  = B.DIVISION_ID   ' + char(10)
            SELECT @v_dSql2 += '                              AND    A.SITE_ID      = B.SITE_ID       ' + char(10)
            SELECT @v_dSql2 += '                              AND    A.ITEM_CLASS   = IC.CLASS_ID     ' + char(10)
            SELECT @v_dSql2 += '                              AND    A.ACTIVE_FLAG  = ''Y''           ' + char(10)
            SELECT @v_dSql2 += '                              AND    (A.FLOW_ID IS NOT NULL OR A.FORMATION_FLOW_ID IS NOT NULL)    ' + char(10)
            SELECT @v_dSql2 += '                              UNION ALL                                                            ' + char(10)
            SELECT @v_dSql2 += '                              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID                        ' + char(10)
            SELECT @v_dSql2 += '                                   , B.PLANT_ID, A.ITEM_ID AS MODEL_ID, A.ITEM_ID AS CHILD_ITEM_ID ' + char(10)
            SELECT @v_dSql2 += '                                   , SUBSTRING(A.FLOW_ID,1,5) AS FLOW_ID                           ' + char(10)
            SELECT @v_dSql2 += '                                   , SUBSTRING(A.FORMATION_FLOW_ID,1,5) AS FORMATION_FLOW_ID       ' + char(10)
            SELECT @v_dSql2 += '                                   , A.ITEM_ID AS MODEL, IC.SCP_OPERATION_GROUP                    ' + char(10)
            SELECT @v_dSql2 += '                              FROM   SCM_ITEM_M A WITH(NOLOCK)          ' + char(10)
			SELECT @v_dSql2 += '                                   , SCM_PLANT_M B WITH(NOLOCK)         ' + char(10)
			SELECT @v_dSql2 += '                                   , SCM_ITEM_CLASS_M IC WITH(NOLOCK)   ' + char(10)
            SELECT @v_dSql2 += '                              WHERE  A.COMPANY_ID   = B.COMPANY_ID      ' + char(10)
            SELECT @v_dSql2 += '                              AND    A.DIVISION_ID  = B.DIVISION_ID     ' + char(10)
            SELECT @v_dSql2 += '                              AND    A.SITE_ID      = B.SITE_ID         ' + char(10)
            SELECT @v_dSql2 += '                              AND    A.ITEM_CLASS   = IC.CLASS_ID       ' + char(10)
            SELECT @v_dSql2 += '                              AND    (A.FLOW_ID IS NOT NULL OR A.FORMATION_FLOW_ID IS NOT NULL) ' + char(10)
            SELECT @v_dSql2 += '            		 	        AND    ITEM_ID IN (                                             ' + char(10)
            SELECT @v_dSql2 += '                                                 SELECT DISTINCT CC.ITEM_ID                     ' + char(10)
            SELECT @v_dSql2 += '            		 					           FROM   SCM_ITEM_CONV_CALC_M  CC WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql2 += '            		 					           WHERE  CC.MAX_VER_FLAG = ''Y'' )             ' + char(10)
            SELECT @v_dSql2 += '                        ) CT                                                                    ' + char(10)
            SELECT @v_dSql2 += '                        GROUP BY CT.COMPANY_ID ,CT.SITE_ID ,CT.PLANT_ID   ' + char(10)
			SELECT @v_dSql2 += '                                 ,CT.CHILD_ITEM_ID, CT.MODEL_ID, CT.MODEL ' + char(10)
            SELECT @v_dSql2 += '                 ) A                                ' + char(10)
            SELECT @v_dSql2 += '            ) I                                     ' + char(10)
            SELECT @v_dSql2 += '            ON  A.COMPANY_ID   = I.COMPANY_ID       ' + char(10)
            SELECT @v_dSql2 += '            AND A.DIVISION_ID  = I.DIVISION_ID      ' + char(10)
            SELECT @v_dSql2 += '            AND A.SITE_ID      = I.SITE_ID          ' + char(10)
            SELECT @v_dSql2 += '            AND A.PLANT_ID     = I.PLANT_ID         ' + char(10)
            SELECT @v_dSql2 += '            AND A.OPERATION_ID = (CASE WHEN A.OPERATION_ID = ''F6000'' THEN I.FORMATION_FLOW_ID ELSE I.FLOW_ID END)  ' + char(10)
            SELECT @v_dSql2 += '            AND A.ITEM_ID      = I.ITEM_ID          ' + char(10)
            SELECT @v_dSql2 += '            AND A.MODEL        = I.MODEL_ID         ' + char(10)
			
			SELECT @v_dSql3 = ''
            SELECT @v_dSql3 += '        LEFT OUTER JOIN (                           ' + char(10)
            SELECT @v_dSql3 += '                         SELECT DISTINCT A.SEGMENT1 AS DIVISION_ID, A.SEGMENT2 AS SITE_ID  ' + char(10)
			SELECT @v_dSql3 += '                            , A.SEGMENT3 AS PLANT_ID, A.SEGMENT4 AS OPERATION_ID           ' + char(10)
            SELECT @v_dSql3 += '                         FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                        ' + char(10)
            SELECT @v_dSql3 += '                         WHERE  A.LOOKUP_TYPE_CODE = ''NO_INPUT_TEST_DEMAND_BY_OPERATION'' ' + char(10)
            SELECT @v_dSql3 += '                         AND    A.ACTIVE_FLAG = ''Y''                                      ' + char(10)
            SELECT @v_dSql3 += '            ) J                                  ' + char(10)
            SELECT @v_dSql3 += '            ON  A.DIVISION_ID  = J.DIVISION_ID   ' + char(10)
            SELECT @v_dSql3 += '            AND A.SITE_ID      = J.SITE_ID       ' + char(10)
            SELECT @v_dSql3 += '            AND A.PLANT_ID     = J.PLANT_ID      ' + char(10)
            SELECT @v_dSql3 += '            AND A.OPERATION_ID = J.OPERATION_ID  ' + char(10)
            SELECT @v_dSql3 += '        LEFT OUTER JOIN (                        ' + char(10)
            SELECT @v_dSql3 += '	                       SELECT DISTINCT  A.SEGMENT1 AS DIVISION_ID, A.ATTRIBUTE2 AS PRODUCTION_TYPE ' + char(10)
            SELECT @v_dSql3 += '		       	  	       FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)           ' + char(10)
            SELECT @v_dSql3 += '		       	  	       WHERE  A.LOOKUP_TYPE_CODE = ''DIVISION_DEMAND_TYPE'' ' + char(10)
            SELECT @v_dSql3 += '		       	  	       AND    A.ACTIVE_FLAG      = ''Y''                    ' + char(10)
            SELECT @v_dSql3 += '		       	  	       AND	   A.SEGMENT5        = ''T''                    ' + char(10)
            SELECT @v_dSql3 += '		       	  	       AND	   A.ATTRIBUTE3      = ''N''                    ' + char(10)
            SELECT @v_dSql3 += '            ) K                                        ' + char(10)
            SELECT @v_dSql3 += '            ON	A.DIVISION_ID  = K.DIVISION_ID         ' + char(10)
            SELECT @v_dSql3 += '            AND A.PRODUCTION_TYPE = K.PRODUCTION_TYPE  ' + char(10)
            SELECT @v_dSql3 += '        LEFT OUTER JOIN (                              ' + char(10)
            SELECT @v_dSql3 += '                         SELECT DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID   ' + char(10)
			SELECT @v_dSql3 += '                           , R.PLANT_ID, R.FACTORY_ID, R.OPERATION_ID, R.LINE_ID  ' + char(10)
            SELECT @v_dSql3 += '                         FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK)                ' + char(10)
            SELECT @v_dSql3 += '                         WHERE  R.USER_ID   = '''+ @p_user_id +'''                ' + char(10)
            SELECT @v_dSql3 += '                         AND    R.SAVE_FLAG = ''Y''                               ' + char(10)
            SELECT @v_dSql3 += '            ) R                                          ' + char(10)
            SELECT @v_dSql3 += '            ON   A.COMPANY_ID   = R.COMPANY_ID           ' + char(10)
            SELECT @v_dSql3 += '            AND  A.DIVISION_ID  = R.DIVISION_ID          ' + char(10)
            SELECT @v_dSql3 += '            AND  A.SITE_ID      = R.SITE_ID              ' + char(10)
            SELECT @v_dSql3 += '            AND  A.PLANT_ID     = R.PLANT_ID             ' + char(10)
            SELECT @v_dSql3 += '            AND  A.FACTORY_ID   = R.FACTORY_ID           ' + char(10)
            SELECT @v_dSql3 += '            AND  A.OPERATION_ID = R.OPERATION_ID         ' + char(10)
            SELECT @v_dSql3 += '            AND  A.LINE_ID      = R.LINE_ID              ' + char(10)
            SELECT @v_dSql3 += '            WHERE A.JOB_USER_ID = '''+ @p_user_id +'''   ' + char(10)
            SELECT @v_dSql3 += '       ) A            ' + char(10)
            SELECT @v_dSql3 += ' ) A                  ' + char(10)
            SELECT @v_dSql3 += ' ORDER BY A.JOB_ORDER ' + char(10)

			SELECT @v_dSql = @v_dSql1 + @v_dSql2 + @v_dSql3

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
	ELSE IF(@p_sys_flag ='SELECT_MULTI')
		BEGIN
			SELECT @v_dSql = ''
            SELECT @v_dSql1 += ' SELECT '''' AS CHK ' + char(10)
            SELECT @v_dSql1 += '     , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID   ' + char(10)
            SELECT @v_dSql1 += '     , (CASE WHEN B.SCP_OPERATION_GROUP = ''E'' THEN B.MODEL_ID ELSE B.MODEL END) AS MODEL ' + char(10)
            SELECT @v_dSql1 += '     , ISNULL(E.NICK_NAME,''-'') AS NICK_NAME, A.OPERATION_ID, A.LINE_ID, A.LINE_NAME      ' + char(10)
            SELECT @v_dSql1 += '     , A.ELECTRODE_TYPE, B.CHILD_ITEM_ID AS ITEM_ID   ' + char(10)
            SELECT @v_dSql1 += '     , '''+ @p_due_date +''' AS DUE_DATE              ' + char(10)
            SELECT @v_dSql1 += '     , '''+ @p_market +'''AS MARKET                   ' + char(10)
            SELECT @v_dSql1 += '     , C.PRODUCTION_TYPE AS PRODUCTION_TYPE , ISNULL(C.QTY, 0) AS MFG_QTY  ' + char(10)
            SELECT @v_dSql1 += '     , ISNULL(C.DESCRIPTION, NULL) AS DESCRIPTION                          ' + char(10)
            SELECT @v_dSql1 += '     , NULL AS IS_PREV_SCHEDULE, NULL AS DEMAND_TYPE, ''-'' AS SCP_PLAN_ID ' + char(10)
            SELECT @v_dSql1 += ' 	 , B.SCP_OPERATION_GROUP As SCP_OPERATION_GROUP, A.SHOP_GROUP_ID As SHOP_GROUP_ID  ' + char(10)
            SELECT @v_dSql1 += ' 	 , CASE WHEN K.SEGMENT4 IS NULL THEN ''M'' ELSE ''S'' END MAIN_YN      ' + char(10)
            SELECT @v_dSql1 += ' FROM (                 ' + char(10)
            SELECT @v_dSql1 += '     SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
            SELECT @v_dSql1 += '        , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE                        ' + char(10)
            SELECT @v_dSql1 += '        , ISNULL(A.LINE_NAME,''-'') AS LINE_NAME, C.SHOP_GROUP_ID            ' + char(10)
            SELECT @v_dSql1 += '     FROM  SCM_LINE_M A WITH(NOLOCK), SCM_OPERATION_M B WITH(NOLOCK), SCM_FACTORY_M C WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql1 += '     WHERE  A.COMPANY_ID   = B.COMPANY_ID   ' + char(10)
            SELECT @v_dSql1 += '     AND A.DIVISION_ID  = B.DIVISION_ID  ' + char(10)
            SELECT @v_dSql1 += '     AND A.SITE_ID      = B.SITE_ID      ' + char(10)
            SELECT @v_dSql1 += '     AND A.OPERATION_ID = B.OPERATION_ID ' + char(10)
            SELECT @v_dSql1 += '     AND A.COMPANY_ID   = C.COMPANY_ID   ' + char(10)
            SELECT @v_dSql1 += '     AND A.DIVISION_ID  = C.DIVISION_ID  ' + char(10)
            SELECT @v_dSql1 += '     AND A.SITE_ID      = C.SITE_ID      ' + char(10)
            SELECT @v_dSql1 += '     AND A.PLANT_ID     = C.PLANT_ID     ' + char(10)
            SELECT @v_dSql1 += '     AND A.FACTORY_ID   = C.FACTORY_ID   ' + char(10)
            SELECT @v_dSql1 += '     AND A.ACTIVE_FLAG  = ''Y''          ' + char(10)
            SELECT @v_dSql1 += '     AND B.ACTIVE_FLAG  = ''Y''          ' + char(10)
            SELECT @v_dSql1 += '     AND C.ACTIVE_FLAG  = ''Y''          ' + char(10)
            SELECT @v_dSql1 += '     AND EXISTS (                        ' + char(10)
            SELECT @v_dSql1 += '               SELECT 1                           ' + char(10)
            SELECT @v_dSql1 += '               FROM   FP_USER_ROLE_INFO_V BB WITH(NOLOCK)    ' + char(10)
            SELECT @v_dSql1 += '               WHERE  A.COMPANY_ID     = BB.COMPANY_ID       ' + char(10)
            SELECT @v_dSql1 += '               AND  A.DIVISION_ID    = BB.DIVISION_ID        ' + char(10)
            SELECT @v_dSql1 += '               AND  A.SITE_ID        = BB.SITE_ID            ' + char(10)
            SELECT @v_dSql1 += '               AND  A.PLANT_ID       = BB.PLANT_ID           ' + char(10)
            SELECT @v_dSql1 += '               AND  A.FACTORY_ID     = BB.FACTORY_ID         ' + char(10)
            SELECT @v_dSql1 += '               AND  A.OPERATION_ID   = BB.OPERATION_ID       ' + char(10)
            SELECT @v_dSql1 += '               AND  A.LINE_ID        = BB.LINE_ID            ' + char(10)
            SELECT @v_dSql1 += '               AND  A.ELECTRODE_TYPE = BB.ELECTRODE_TYPE     ' + char(10)
            SELECT @v_dSql1 += '               AND  BB.SAVE_FLAG     = ''Y''                 ' + char(10)
            SELECT @v_dSql1 += '               AND  BB.USER_ID       = '''+ @p_user_id +'''  ' + char(10)
            SELECT @v_dSql1 += '     )  ' + char(10)
            SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID', 'EQ', @p_factory_id ))       + char(10)
  	        SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID', 'EQ', @p_operation_id ))   + char(10)
			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID', 'EQ', @p_line_id ))             + char(10)
            SELECT @v_dSql1 += ' ) A           ' + char(10)
				
			SELECT @v_dSql2 = ''
            SELECT @v_dSql2 += ' INNER JOIN (  ' + char(10)
            SELECT @v_dSql2 += '               SELECT CT.COMPANY_ID,MAX(CT.DIVISION_ID) AS DIVISION_ID ' + char(10)
            SELECT @v_dSql2 += '                  ,CT.SITE_ID, CT.PLANT_ID,CT.CHILD_ITEM_ID            ' + char(10)
            SELECT @v_dSql2 += '                  ,CT.FLOW_ID,CT.MODEL,CT.MODEL_ID                     ' + char(10)
            SELECT @v_dSql2 += ' 			     ,MAX(CT.SCP_OPERATION_GROUP) AS SCP_OPERATION_GROUP   ' + char(10)
            SELECT @v_dSql2 += '               FROM (                                                  ' + char(10)
            SELECT @v_dSql2 += '                     SELECT DISTINCT CT.COMPANY_ID, CT.DIVISION_ID, CT.SITE_ID, CT.PLANT_ID ' + char(10)
            SELECT @v_dSql2 += '                       ,CT.MODEL_ID, CT.CHILD_ITEM_ID, FL.OPERATION_ID AS FLOW_ID ' + char(10)
            SELECT @v_dSql2 += '                       ,CT.MODEL_ID AS MODEL, IC.SCP_OPERATION_GROUP ' + char(10)
            SELECT @v_dSql2 += '                     FROM   SCM_MODEL_COMP_TEMP CT WITH(NOLOCK)      ' + char(10)
            SELECT @v_dSql2 += '                           ,SCM_ITEM_M SI WITH(NOLOCK)               ' + char(10)
            SELECT @v_dSql2 += '                           ,SCM_ITEM_CLASS_M IC WITH(NOLOCK)         ' + char(10)
            SELECT @v_dSql2 += '                           ,SCM_OPERATION_FLOW_M FL WITH(NOLOCK)     ' + char(10)
            SELECT @v_dSql2 += '                     WHERE  CT.COMPANY_ID  = SI.COMPANY_ID           ' + char(10)
            SELECT @v_dSql2 += '                     AND  CT.DIVISION_ID = SI.DIVISION_ID            ' + char(10)
            SELECT @v_dSql2 += '                     AND  CT.SITE_ID     = SI.SITE_ID                ' + char(10)
            SELECT @v_dSql2 += '                     AND  CT.CHILD_ITEM_ID = SI.ITEM_ID              ' + char(10)
            SELECT @v_dSql2 += '                     AND  CT.PLANT_ID    = CT.CHILD_PLANT_ID         ' + char(10)
            SELECT @v_dSql2 += '                     AND  SI.ITEM_CLASS  = IC.CLASS_ID    ' + char(10)
            SELECT @v_dSql2 += '     		        AND  SI.COMPANY_ID	= FL.COMPANY_ID   ' + char(10)
            SELECT @v_dSql2 += '     		        AND  SI.DIVISION_ID	= FL.DIVISION_ID  ' + char(10)
            SELECT @v_dSql2 += '     		        AND  SI.SITE_ID		= FL.SITE_ID      ' + char(10)
            SELECT @v_dSql2 += '                     AND  (FL.FLOW_ID = SI.FORMATION_FLOW_ID OR FL.FLOW_ID = SI.FLOW_ID)  ' + char(10)
            SELECT @v_dSql2 += '                     AND  IC.USE_FLAG     = ''Y''          ' + char(10)
            SELECT @v_dSql2 += '                     AND  SI.ACTIVE_FLAG  = ''Y''          ' + char(10)
            SELECT @v_dSql2 += '                     AND  ISNULL(SI.ITEM_TYPE,''H'') IN (''P'',''Q'',''H'')            ' + char(10)
            SELECT @v_dSql2 += '                     AND  (SI.FLOW_ID IS NOT NULL OR SI.FORMATION_FLOW_ID IS NOT NULL) ' + char(10)
            SELECT @v_dSql2 += '                     AND  CT.ALT_PRIORITY = ''Y''          ' + char(10)
            SELECT @v_dSql2 += '                     AND  FL.ACTIVE_FLAG  = ''Y''          ' + char(10)
            SELECT @v_dSql2 += '                     AND  CT.DIVISION_ID  = '''+ @p_division_id +'''          ' + char(10)
            SELECT @v_dSql2 += '                     AND  CT.SITE_ID      = '''+ @p_site_id +'''              ' + char(10)
            SELECT @v_dSql2 += '                     AND  CT.PLANT_ID     = '''+ @p_plant_id +'''             ' + char(10)
            SELECT @v_dSql2 += '                     AND  CT.MODEL_ID     = RTRIM(LTRIM('''+ @p_model +''' )) ' + char(10)
            SELECT @v_dSql2 += '                     UNION ALL                                    ' + char(10)
            SELECT @v_dSql2 += '                     SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID           ' + char(10)
			SELECT @v_dSql2 += '                          , '''+ @p_plant_id +''' AS PLANT_ID, A.ITEM_ID AS MODEL_ID  ' + char(10)
            SELECT @v_dSql2 += '                          , A.ITEM_ID AS CHILD_ITEM_ID, FL.OPERATION_ID AS FLOW_ID    ' + char(10)
            SELECT @v_dSql2 += '                          , RTRIM(LTRIM('''+ @p_item_id +''')) AS MODEL               ' + char(10)
            SELECT @v_dSql2 += '                          , IC.SCP_OPERATION_GROUP                 ' + char(10)
            SELECT @v_dSql2 += '                     FROM   SCM_ITEM_M A WITH(NOLOCK)              ' + char(10)
            SELECT @v_dSql2 += '                           ,SCM_ITEM_CLASS_M IC WITH(NOLOCK)       ' + char(10)
            SELECT @v_dSql2 += '                           ,SCM_OPERATION_FLOW_M FL WITH(NOLOCK)   ' + char(10)
            SELECT @v_dSql2 += '                     WHERE  A.ITEM_CLASS = IC.CLASS_ID             ' + char(10)
            SELECT @v_dSql2 += '     		         	  AND    A.COMPANY_ID   = FL.COMPANY_ID    ' + char(10)
            SELECT @v_dSql2 += '     		         	  AND    A.DIVISION_ID	= FL.DIVISION_ID   ' + char(10)
            SELECT @v_dSql2 += '     		         	  AND    A.SITE_ID			= FL.SITE_ID   ' + char(10)
            SELECT @v_dSql2 += '                     AND  (FL.FLOW_ID = A.FORMATION_FLOW_ID OR FL.FLOW_ID = A.FLOW_ID)  ' + char(10)
            SELECT @v_dSql2 += '                     AND  FL.ACTIVE_FLAG  = ''Y''                     ' + char(10)
            SELECT @v_dSql2 += '                     AND  A.DIVISION_ID   = '''+ @p_division_id +'''  ' + char(10)
            SELECT @v_dSql2 += '                     AND  A.SITE_ID       = '''+ @p_site_id +'''      ' + char(10)
            SELECT @v_dSql2 += '                     AND  A.ITEM_ID       = RTRIM(LTRIM('''+ @p_item_id +'''))       ' + char(10)
            SELECT @v_dSql2 += '                     AND  (A.FLOW_ID IS NOT NULL OR A.FORMATION_FLOW_ID IS NOT NULL) ' + char(10)
            SELECT @v_dSql2 += '                     UNION ALL                                                       ' + char(10)
            SELECT @v_dSql2 += '                     SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID          ' + char(10)
			SELECT @v_dSql2 += '                       , '''+ @p_plant_id +''' AS PLANT_ID, A.ITEM_ID AS MODEL_ID    ' + char(10)
            SELECT @v_dSql2 += '                       , A.ITEM_ID AS CHILD_ITEM_ID, FL.OPERATION_ID AS FLOW_ID      ' + char(10)
            SELECT @v_dSql2 += '                       , RTRIM(LTRIM('''+ @p_item_id +''')) AS MODEL, IC.SCP_OPERATION_GROUP  ' + char(10)
            SELECT @v_dSql2 += '                     FROM   SCM_ITEM_M A WITH(NOLOCK)             ' + char(10)
            SELECT @v_dSql2 += '                           ,SCM_ITEM_CLASS_M IC WITH(NOLOCK)      ' + char(10)
            SELECT @v_dSql2 += '                           ,SCM_OPERATION_FLOW_M FL WITH(NOLOCK)  ' + char(10)
            SELECT @v_dSql2 += '                     WHERE  A.ITEM_CLASS = IC.CLASS_ID            ' + char(10)
            SELECT @v_dSql2 += '     		         AND  A.COMPANY_ID   = FL.COMPANY_ID          ' + char(10)
            SELECT @v_dSql2 += '     		         AND  A.DIVISION_ID	= FL.DIVISION_ID          ' + char(10)
            SELECT @v_dSql2 += '     		         AND  A.SITE_ID			= FL.SITE_ID          ' + char(10)
            SELECT @v_dSql2 += '                      AND  (FL.FLOW_ID = A.FORMATION_FLOW_ID OR FL.FLOW_ID = A.FLOW_ID)  ' + char(10)
            SELECT @v_dSql2 += '                      AND  FL.ACTIVE_FLAG = ''Y''                     ' + char(10)
            SELECT @v_dSql2 += ' 			         AND  A.DIVISION_ID  = '''+ @p_division_id +'''   ' + char(10)
            SELECT @v_dSql2 += '                      AND  A.SITE_ID      = '''+ @p_site_id +'''      ' + char(10)
            SELECT @v_dSql2 += '                      AND  (A.FLOW_ID IS NOT NULL OR A.FORMATION_FLOW_ID IS NOT NULL) ' + char(10)
            SELECT @v_dSql2 += ' 			         AND  A.ITEM_ID IN (                     ' + char(10)
            SELECT @v_dSql2 += '                                         SELECT CC.ITEM_ID   ' + char(10)
            SELECT @v_dSql2 += ' 						                FROM   SCM_ITEM_CONV_CALC_M CC WITH(NOLOCK)        ' + char(10)
            SELECT @v_dSql2 += ' 						                WHERE  CC.DIVISION_ID = '''+ @p_division_id +'''   ' + char(10)
            SELECT @v_dSql2 += ' 						                AND  CC.SITE_ID     = '''+ @p_site_id +'''         ' + char(10)
            SELECT @v_dSql2 += ' 						                AND  CC.PLANT_ID    = '''+ @p_plant_id +'''        ' + char(10)
            SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('CC.FACTORY_ID', 'EQ', @p_factory_id ))                 + char(10)
            SELECT @v_dSql2 += ' 							            AND CC.MODEL_ID = RTRIM(LTRIM('''+ @p_model +''')) ' + char(10)
            SELECT @v_dSql2 += ' 							            AND CC.MAX_VER_FLAG = ''Y'' )                      ' + char(10)
            SELECT @v_dSql2 += '                                        ) CT                                               ' + char(10)
            SELECT @v_dSql2 += '                     GROUP BY CT.COMPANY_ID ,CT.SITE_ID ,CT.PLANT_ID ,CT.CHILD_ITEM_ID, CT.MODEL, CT.MODEL_ID, CT.FLOW_ID ' + char(10)
            SELECT @v_dSql2 += ' ) B  ' + char(10)
				
			SELECT @v_dSql3 = ''
            SELECT @v_dSql3 += ' ON  A.COMPANY_ID  = B.COMPANY_ID   ' + char(10)
            SELECT @v_dSql3 += ' AND A.DIVISION_ID = B.DIVISION_ID  ' + char(10)
            SELECT @v_dSql3 += ' AND A.SITE_ID     = B.SITE_ID      ' + char(10)
            SELECT @v_dSql3 += ' AND A.PLANT_ID    = B.PLANT_ID     ' + char(10)
            SELECT @v_dSql3 += ' AND A.OPERATION_ID = B.FLOW_ID     ' + char(10)
            SELECT @v_dSql3 += ' LEFT OUTER JOIN (                  ' + char(10)
            SELECT @v_dSql3 += '                  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID                   ' + char(10)
			SELECT @v_dSql3 += '                     , A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID                   ' + char(10)
            SELECT @v_dSql3 += '                     , LINE_ID, ITEM_ID, DUE_DATE, SUM(A.MFG_QTY) AS QTY          ' + char(10)
			SELECT @v_dSql3 += '                     , MAX(A.DESCRIPTION) AS DESCRIPTION                          ' + char(10)
            SELECT @v_dSql3 += '                   , A.MODEL, A.PRODUCTION_TYPE                                   ' + char(10)
            SELECT @v_dSql3 += '                  FROM  FP_WEEKLY_DEMAND_PRODUCT_PDS_H A WITH(NOLOCK)            ' + char(10)
            SELECT @v_dSql3 += '                  WHERE CONVERT(VARCHAR,A.DUE_DATE,112) = '''+ @p_due_date +'''   ' + char(10)
            SELECT @v_dSql3 += '                  AND  A.MARKET = '''+ @p_market +'''                             ' + char(10)
            SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID', 'EQ', @p_factory_id ))       + char(10)
  	        SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID', 'EQ', @p_operation_id ))   + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID', 'EQ', @p_line_id ))             + char(10)
            SELECT @v_dSql3 += '                 GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID      ' + char(10)
			SELECT @v_dSql3 += '                  , A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ITEM_ID, A.DUE_DATE, A.MODEL, A.PRODUCTION_TYPE ' + char(10)
            SELECT @v_dSql3 += ' ) C  ' + char(10)
            SELECT @v_dSql3 += ' ON  A.COMPANY_ID    = C.COMPANY_ID    ' + char(10)
            SELECT @v_dSql3 += ' AND A.DIVISION_ID   = C.DIVISION_ID   ' + char(10)
            SELECT @v_dSql3 += ' AND A.SITE_ID       = C.SITE_ID       ' + char(10)
            SELECT @v_dSql3 += ' AND A.PLANT_ID      = C.PLANT_ID      ' + char(10)
            SELECT @v_dSql3 += ' AND A.FACTORY_ID    = C.FACTORY_ID    ' + char(10)
            SELECT @v_dSql3 += ' AND A.OPERATION_ID  = C.OPERATION_ID  ' + char(10)
            SELECT @v_dSql3 += ' AND A.LINE_ID       = C.LINE_ID       ' + char(10)
            SELECT @v_dSql3 += ' AND B.COMPANY_ID    = C.COMPANY_ID    ' + char(10)
            SELECT @v_dSql3 += ' AND B.DIVISION_ID   = C.DIVISION_ID   ' + char(10)
            SELECT @v_dSql3 += ' AND B.SITE_ID       = C.SITE_ID       ' + char(10)
            SELECT @v_dSql3 += ' AND B.PLANT_ID      = C.PLANT_ID      ' + char(10)
            SELECT @v_dSql3 += ' AND B.CHILD_ITEM_ID = C.ITEM_ID       ' + char(10)
            SELECT @v_dSql3 += ' AND B.MODEL         = C.MODEL         ' + char(10)
            SELECT @v_dSql3 += ' INNER JOIN (                          ' + char(10)
            SELECT @v_dSql3 += '             SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID                ' + char(10)
            SELECT @v_dSql3 += '               , A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                    ' + char(10)
			SELECT @v_dSql3 += '               , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.ITEM_ID ' + char(10)
            SELECT @v_dSql3 += '             FROM   SCM_ITEM_LINE_ASSIGN_M A WITH(NOLOCK)               ' + char(10)
            SELECT @v_dSql3 += '             WHERE  A.ACTIVE_FLAG  = ''Y''                              ' + char(10)
            SELECT @v_dSql3 += '             AND    A.MONTH = SUBSTRING('''+ @p_due_date +''',1,6)      ' + char(10)
            SELECT @v_dSql3 += '             AND    A.PRIORITY NOT IN (''0'',''9'')                     ' + char(10)
            SELECT @v_dSql3 += '             AND    A.DIVISION_ID  = '''+ @p_division_id +'''           ' + char(10)
            SELECT @v_dSql3 += '             AND    A.SITE_ID      = '''+ @p_site_id +'''               ' + char(10)
            SELECT @v_dSql3 += '             AND    A.PLANT_ID     = '''+ @p_plant_id +'''              ' + char(10)
            SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID', 'EQ', @p_factory_id ))       + char(10)
  	        SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID', 'EQ', @p_operation_id ))   + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID', 'EQ', @p_line_id ))             + char(10)
            SELECT @v_dSql3 += ' ) D                                         ' + char(10)
            SELECT @v_dSql3 += ' ON  A.COMPANY_ID     = D.COMPANY_ID         ' + char(10)
            SELECT @v_dSql3 += '   AND A.DIVISION_ID    = D.DIVISION_ID      ' + char(10)
            SELECT @v_dSql3 += '   AND A.SITE_ID        = D.SITE_ID          ' + char(10)
            SELECT @v_dSql3 += '   AND A.PLANT_ID       = D.PLANT_ID         ' + char(10)
            SELECT @v_dSql3 += '   AND A.FACTORY_ID     = D.FACTORY_ID       ' + char(10)
            SELECT @v_dSql3 += '   AND A.OPERATION_ID   = D.OPERATION_ID     ' + char(10)
            SELECT @v_dSql3 += '   AND A.LINE_ID        = D.LINE_ID          ' + char(10)
            SELECT @v_dSql3 += '   AND A.ELECTRODE_TYPE = D.ELECTRODE_TYPE   ' + char(10)
            SELECT @v_dSql3 += '   AND B.COMPANY_ID     = D.COMPANY_ID       ' + char(10)
            SELECT @v_dSql3 += '   AND B.DIVISION_ID    = D.DIVISION_ID      ' + char(10)
            SELECT @v_dSql3 += '   AND B.SITE_ID        = D.SITE_ID          ' + char(10)
            SELECT @v_dSql3 += '   AND B.PLANT_ID       = D.PLANT_ID         ' + char(10)
            SELECT @v_dSql3 += '   AND B.CHILD_ITEM_ID  = D.ITEM_ID          ' + char(10)
            SELECT @v_dSql3 += ' LEFT OUTER JOIN SCM_ITEM_M E WITH(NOLOCK)   ' + char(10)
            SELECT @v_dSql3 += ' ON  A.COMPANY_ID     = E.COMPANY_ID         ' + char(10)
            SELECT @v_dSql3 += '   AND A.DIVISION_ID    = E.DIVISION_ID      ' + char(10)
            SELECT @v_dSql3 += '   AND A.SITE_ID        = E.SITE_ID          ' + char(10)
            SELECT @v_dSql3 += '   AND (CASE WHEN B.SCP_OPERATION_GROUP = ''E'' THEN B.MODEL_ID ELSE B.MODEL END) = E.ITEM_ID ' + char(10)
            SELECT @v_dSql3 += ' LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE K WITH(NOLOCK)           ' + char(10)
            SELECT @v_dSql3 += ' ON	K.LOOKUP_TYPE_CODE = ''NO_INPUT_TEST_DEMAND_BY_OPERATION'' ' + char(10)
            SELECT @v_dSql3 += ' AND   K.ACTIVE_FLAG = ''Y''        ' + char(10)
            SELECT @v_dSql3 += ' AND	A.DIVISION_ID  = K.SEGMENT1 ' + char(10)
            SELECT @v_dSql3 += ' AND   A.SITE_ID      = K.SEGMENT2  ' + char(10)
            SELECT @v_dSql3 += ' AND   A.PLANT_ID     = K.SEGMENT3  ' + char(10)
            SELECT @v_dSql3 += ' AND   A.OPERATION_ID = K.SEGMENT4  ' + char(10)
            SELECT @v_dSql3 += ' WHERE 1=1                          ' + char(10)
            SELECT @v_dSql3 += ' AND EXISTS (                       ' + char(10)
            SELECT @v_dSql3 += ' 		     SELECT 1               ' + char(10)
            SELECT @v_dSql3 += ' 		     FROM SCM_ITEM_M SA WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql3 += ' 		     WHERE 1=1                       ' + char(10)
			IF(LEN(@p_model) > 0)
			    BEGIN
                    SELECT @v_dSql3 += ' 		     AND SA.ITEM_ID	= RTRIM(LTRIM('''+ @p_model +''' ))  ' + char(10)
				END
            SELECT @v_dSql3 += ' 		     AND SA.ITEM_ID 	= (CASE WHEN B.SCP_OPERATION_GROUP = ''E'' THEN B.MODEL_ID ELSE B.MODEL END) ' + char(10)
            SELECT @v_dSql3 += ' 		     AND SUBSTRING(SA.FLOW_ID,1,1) = SUBSTRING(A.OPERATION_ID,1,1) ' + char(10)
            SELECT @v_dSql3 += ' 			)             ' + char(10)
            SELECT @v_dSql3 += '  AND EXISTS (            ' + char(10)
            SELECT @v_dSql3 += ' 				SELECT *  ' + char(10)
            SELECT @v_dSql3 += ' 				FROM SCM_ITEM_M SA WITH(NOLOCK)  ' + char(10)
            SELECT @v_dSql3 += ' 				WHERE 1=1                        ' + char(10)
			IF(LEN(@p_item_id) > 0)
			    BEGIN
                    SELECT @v_dSql3 += ' 				AND SA.ITEM_ID = RTRIM(LTRIM('''+ @p_item_id +'''))  ' + char(10)
				END
            SELECT @v_dSql3 += ' 				AND SA.ITEM_ID = B.CHILD_ITEM_ID ' + char(10)
            SELECT @v_dSql3 += ' 				AND SUBSTRING(SA.FLOW_ID,1,1) = SUBSTRING(A.OPERATION_ID,1,1) ' + char(10)
            SELECT @v_dSql3 += ' 			) ' + char(10)
            SELECT @v_dSql3 += ' ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
            SELECT @v_dSql3 += '        , MODEL, A.LINE_ID, A.ELECTRODE_TYPE, A.OPERATION_ID DESC, ITEM_ID ' + char(10)
			
			SELECT @v_dSql = ''
			SELECT @v_dSql = @v_dSql1 + @v_dSql2 + @v_dSql3
			    
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
		END	--ELSE IF(END)

	ELSE
		-- 트랜잭션 (TRAN)
		BEGIN TRY				                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
		BEGIN TRAN   

		BEGIN --ELSE ( BEGIN )
		    --max_loop_cnt:전체 Row수 , mst_loop_cnt:1씩 증가시켜서 전체 Row수 까지만 로직을 수행
			WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
			    BEGIN --WHILE 내(START)
					 
						SELECT @mst_loop_cnt = @mst_loop_cnt + 1	-- @mst_loop_cnt 1증가

						SELECT @v_sys_type    = [dbo].[SCM_ARR_SPL_VAL](@p_sys_type ,        @v_delimiter, @mst_loop_cnt)
						, @v_sys_flag         = [dbo].[SCM_ARR_SPL_VAL](@p_sys_flag ,        @v_delimiter, @mst_loop_cnt)
						, @v_sys_gubun        = [dbo].[SCM_ARR_SPL_VAL](@p_sys_gubun ,       @v_delimiter, @mst_loop_cnt)
						, @v_user_id          = [dbo].[SCM_ARR_SPL_VAL](@p_user_id ,         @v_delimiter, @mst_loop_cnt)
                        , @v_company_id       = [dbo].[SCM_ARR_SPL_VAL](@p_company_id ,      @v_delimiter, @mst_loop_cnt)
                        , @v_division_id      = [dbo].[SCM_ARR_SPL_VAL](@p_division_id ,     @v_delimiter, @mst_loop_cnt)
                        , @v_site_id          = [dbo].[SCM_ARR_SPL_VAL](@p_site_id ,         @v_delimiter, @mst_loop_cnt)
                        , @v_plant_id         = [dbo].[SCM_ARR_SPL_VAL](@p_plant_id ,        @v_delimiter, @mst_loop_cnt)
                        , @v_due_start_date   = [dbo].[SCM_ARR_SPL_VAL](@p_due_start_date ,  @v_delimiter, @mst_loop_cnt)
                        , @v_due_end_date     = [dbo].[SCM_ARR_SPL_VAL](@p_due_end_date ,    @v_delimiter, @mst_loop_cnt)
                        , @v_item_id          = [dbo].[SCM_ARR_SPL_VAL](@p_item_id ,         @v_delimiter, @mst_loop_cnt)
                        , @v_model            = [dbo].[SCM_ARR_SPL_VAL](@p_model ,           @v_delimiter, @mst_loop_cnt)
                        , @v_nick_name        = [dbo].[SCM_ARR_SPL_VAL](@p_nick_name ,       @v_delimiter, @mst_loop_cnt)
                        , @v_factory_id       = [dbo].[SCM_ARR_SPL_VAL](@p_factory_id ,      @v_delimiter, @mst_loop_cnt)
                        , @v_operation_id     = [dbo].[SCM_ARR_SPL_VAL](@p_operation_id ,    @v_delimiter, @mst_loop_cnt)
                        , @v_line_id          = [dbo].[SCM_ARR_SPL_VAL](@p_line_id ,         @v_delimiter, @mst_loop_cnt)
                        , @v_line_name        = [dbo].[SCM_ARR_SPL_VAL](@p_line_name ,       @v_delimiter ,@mst_loop_cnt)
                        , @v_market           = [dbo].[SCM_ARR_SPL_VAL](@p_market ,          @v_delimiter, @mst_loop_cnt)
                        , @v_production_type  = [dbo].[SCM_ARR_SPL_VAL](@p_production_type , @v_delimiter, @mst_loop_cnt)
                        , @v_due_date         = [dbo].[SCM_ARR_SPL_VAL](@p_due_date ,        @v_delimiter, @mst_loop_cnt)
                        , @v_mfg_week         = [dbo].[SCM_ARR_SPL_VAL](@p_mfg_week ,        @v_delimiter, @mst_loop_cnt)
                        , @v_mfg_qty          = [dbo].[SCM_ARR_SPL_VAL](@p_mfg_qty ,         @v_delimiter, @mst_loop_cnt)
                        , @v_is_prev_schedule = [dbo].[SCM_ARR_SPL_VAL](@p_is_prev_schedule ,@v_delimiter, @mst_loop_cnt)
                        , @v_demand_type      = [dbo].[SCM_ARR_SPL_VAL](@p_demand_type ,     @v_delimiter, @mst_loop_cnt)
                        , @v_scp_plan_id      = [dbo].[SCM_ARR_SPL_VAL](@p_scp_plan_id  ,    @v_delimiter, @mst_loop_cnt)
                        , @v_description      = [dbo].[SCM_ARR_SPL_VAL](@p_description ,     @v_delimiter, @mst_loop_cnt)
                        , @v_test_target_id   = [dbo].[SCM_ARR_SPL_VAL](@p_test_target_id ,  @v_delimiter, @mst_loop_cnt)
                        , @v_electrode_type   = [dbo].[SCM_ARR_SPL_VAL](@p_electrode_type ,  @v_delimiter, @mst_loop_cnt)
                        , @v_active_flag      = [dbo].[SCM_ARR_SPL_VAL](@p_active_flag ,     @v_delimiter, @mst_loop_cnt) --E20260316-000249 FP 계획 수립시 PDS Target 계획 반영 유무 기능 추가 건

					   /******************************************************************************/
					   /* I 경우 : INSERT                                                            */
					   /******************************************************************************/
					   IF(@v_sys_flag ='I')  
							BEGIN
                                 SELECT @v_dSql = ''
                                 SELECT @v_dSql += '  INSERT INTO FP_WEEKLY_DEMAND_PRODUCT_PDS_H (   ' + char(10)
                                 SELECT @v_dSql += '   COMPANY_ID, DIVISION_ID, SITE_ID               ' + char(10)
                                 SELECT @v_dSql += ' , PLANT_ID, SCP_PLAN_ID, TEST_TARGET_ID          ' + char(10)
                                 SELECT @v_dSql += ' , MODEL, ITEM_ID, FACTORY_ID                     ' + char(10)
                                 SELECT @v_dSql += ' , LINE_ID, OPERATION_ID,DUE_DATE                 ' + char(10)
                                 SELECT @v_dSql += ' , SEQ, MFG_WEEK, MFG_QTY                         ' + char(10)
                                 SELECT @v_dSql += ' , DESCRIPTION, DEMAND_TYPE,IS_PREV_SCHEDULE      ' + char(10)
                                 SELECT @v_dSql += ' , MARKET, PRODUCTION_TYPE, INSERT_ID             ' + char(10)
                                 SELECT @v_dSql += ' , INSERT_TIME, UPDATE_ID, UPDATE_TIME            ' + char(10)
                                 SELECT @v_dSql += ' , ACTIVE_FLAG                                    ' + char(10) --E20260316-000249 FP 계획 수립시 PDS Target 계획 반영 유무 기능 추가 건
                                 SELECT @v_dSql += '  ) VALUES (                                      ' + char(10)
                                 SELECT @v_dSql += '  '''+ @v_company_id +''', '''+ @v_division_id +''', '''+ @v_site_id +'''   ' + char(10)
                                 SELECT @v_dSql += ' , '''+ @v_plant_id +''',  ''-''                                            ' + char(10)
								 SELECT @v_dSql += ' ( '''+ @v_model +''' + ''_'' + '''+ @v_item_id +''' + ''_'' + '''+ @v_due_date +''' + ''_'' + '''+ @v_factory_id +''' + ''_'' + '''+ @v_line_id +''' + ''_'' + '''+ @v_operation_id +''' + ''_'' + '''+ @v_market +''' + ''_'' + '''+ @v_production_type +''' )   ' + char(10)
                                 SELECT @v_dSql += ' , '''+ @v_model +''', '''+ @v_item_id +''', '''+ @v_factory_id +'''        ' + char(10)
                                 SELECT @v_dSql += ' , '''+ @v_line_id +''', '''+ @v_operation_id +''', CONVERT(DATE, '''+ @v_due_date +''')                 ' + char(10)
                                 SELECT @v_dSql += ' , 1,(SELECT ISO_YYYYWW FROM TH_UIS_CAL WHERE YYYYMMDD = '''+ @v_due_date +''' ), '''+ @v_mfg_qty +'''   ' + char(10)
                                 SELECT @v_dSql += ' , N'''+ @v_description +''', '''+ @v_demand_type +''', '''+ @v_is_prev_schedule +'''                    ' + char(10)
                                 SELECT @v_dSql += ' , (CASE WHEN '''+ @v_market +''' IS NULL OR '''+ @v_market +''' = '''' THEN ''E'' ELSE '''+ @v_market +''' END )   ' + char(10)
                                 SELECT @v_dSql += ' , (CASE WHEN '''+ @v_production_type +''' IS NULL OR '''+ @v_production_type +''' = '''' THEN ''TEST'' ELSE '''+ @v_production_type +''' )   ' + char(10)
                                 SELECT @v_dSql += ' , '''+ @v_user_id +'''                         ' + char(10)
                                 SELECT @v_dSql += ' , GETDATE(), '''+ @v_user_id +''', GETDATE()   ' + char(10)
                                 SELECT @v_dSql += ' , '''+ @v_active_flag +'''                     ' + char(10)  --E20260316-000249 FP 계획 수립시 PDS Target 계획 반영 유무 기능 추가 건
								 SELECT @v_dSql += ' )                                              ' + char(10)

								 SELECT @v_dSql += ' INSERT INTO HIS_WEEKLY_DEMAND_PRODUCT_PDS_H (                ' + char(10)
								 SELECT @v_dSql += '		 COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID            ' + char(10)
								 SELECT @v_dSql += '		,SCP_PLAN_ID, TEST_TARGET_ID, MODEL, ITEM_ID           ' + char(10)
								 SELECT @v_dSql += '		,FACTORY_ID, LINE_ID, OPERATION_ID, DUE_DATE           ' + char(10)
								 SELECT @v_dSql += '		,SEQ, MFG_WEEK, MFG_QTY, DESCRIPTION                   ' + char(10)
								 SELECT @v_dSql += '		, DEMAND_TYPE,IS_PREV_SCHEDULE,MARKET, PRODUCTION_TYPE ' + char(10)
								 SELECT @v_dSql += '		,INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME        ' + char(10)
								 SELECT @v_dSql += '		,JOB_USER_ID,JOB_TIME,JOB_TYPE ,ACTIVE_FLAG            ' + char(10)  --E20260316-000249 FP 계획 수립시 PDS Target 계획 반영 유무 기능 추가 건
								 SELECT @v_dSql += ' )                                                             ' + char(10)
								 SELECT @v_dSql += ' SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID             ' + char(10)
								 SELECT @v_dSql += '		, SCP_PLAN_ID, TEST_TARGET_ID, MODEL, ITEM_ID          ' + char(10)
								 SELECT @v_dSql += '		, FACTORY_ID, LINE_ID, OPERATION_ID, DUE_DATE          ' + char(10)
								 SELECT @v_dSql += '		, SEQ, MFG_WEEK, MFG_QTY, DESCRIPTION                  ' + char(10)
								 SELECT @v_dSql += '		, DEMAND_TYPE,IS_PREV_SCHEDULE,MARKET,PRODUCTION_TYPE  ' + char(10)
								 SELECT @v_dSql += '		, INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME       ' + char(10)
								 SELECT @v_dSql += '		, '''+ @v_user_id +''' AS JOB_USER_ID, GETDATE() AS JOB_TIME,''INSERT'' AS JOB_TYPE ' + char(10)
                                 SELECT @v_dSql += '        , ACTIVE_FLAG'                                         + char(10)  --E20260316-000249 FP 계획 수립시 PDS Target 계획 반영 유무 기능 추가 건
								 SELECT @v_dSql += ' FROM   FP_WEEKLY_DEMAND_PRODUCT_PDS_H A WITH(NOLOCK)        ' + char(10)
								 SELECT @v_dSql += '	WHERE COMPANY_ID      = '''+ @v_company_id +'''           ' + char(10)
								 SELECT @v_dSql += '	AND   DIVISION_ID     = '''+ @v_division_id +'''          ' + char(10)
								 SELECT @v_dSql += '	AND   SITE_ID         = '''+ @v_site_id +'''              ' + char(10)
								 SELECT @v_dSql += '	AND   PLANT_ID        = '''+ @v_plant_id +'''             ' + char(10)
								 SELECT @v_dSql += '	AND   FACTORY_ID      = '''+ @v_factory_id +'''           ' + char(10)
								 SELECT @v_dSql += '	AND   OPERATION_ID    = '''+ @v_operation_id +'''         ' + char(10)
								 SELECT @v_dSql += '	AND   LINE_ID         = '''+ @v_line_id +'''              ' + char(10)
								 SELECT @v_dSql += ' AND   ITEM_ID          = '''+ @v_item_id +'''                ' + char(10)
								 SELECT @v_dSql += ' AND   MARKET           = '''+ @v_market +'''                 ' + char(10)
								 SELECT @v_dSql += ' AND   PRODUCTION_TYPE  = '''+ @v_production_type +'''        ' + char(10)
								 SELECT @v_dSql += ' AND   CONVERT(VARCHAR,DUE_DATE,112) = '''+ @v_due_date +'''  ' + char(10)
								 SELECT @v_dSql += ' AND   MODEL            = '''+ @v_model +'''                  ' + char(10)
								 SELECT @v_dSql += ' AND   TEST_TARGET_ID   = '''+ @v_test_target_id +'''         ' + char(10)
								 SELECT @v_dSql += ' AND    TEST_TARGET_ID = ('''+ @v_model +''' + ''_'' + '''+ @v_item_id +''' + ''_'' + '''+ @v_due_date +''' + ''_'' + '''+ @v_factory_id +''' + ''_'' + '''+ @v_line_id +''' + ''_'' + '''+ @v_operation_id +''' + ''_'' + '''+ @v_market +''' + ''_'' + '''+ @v_production_type +''') ' + char(10)
						
						   END --'I'
					   /****************************************************************************/
					   /* UPDATE  경우  :M                                                         */
					   /****************************************************************************/
					   ELSE IF(@v_sys_flag ='M')
							BEGIN
							    SELECT @v_dSql = ''
								SELECT @v_dSql += 'UPDATE FP_WEEKLY_DEMAND_PRODUCT_PDS_H SET ' + char(10)
								SELECT @v_dSql += '		  UPDATE_ID      = '''+ @v_user_id +''' ' + char(10)
								SELECT @v_dSql += '		, UPDATE_TIME    = GETDATE() ' + char(10)
								SELECT @v_dSql += '		, DUE_DATE       = CONVERT(DATETIME, ''' + @v_due_date + ''') ' + char(10)
								SELECT @v_dSql += '		, MFG_WEEK       = (SELECT MAX(CC.ISO_YYYYWW) FROM TH_UIS_CAL CC WITH(NOLOCK) WHERE CC.DT = CONVERT(DATETIME, ''' + @v_due_date + ''')) ' + char(10)
                                SELECT @v_dSql += '     , ACTIVE_FLAG    = '''+ @v_active_flag +'''                   ' + char(10)  --E20260316-000249 FP 계획 수립시 PDS Target 계획 반영 유무 기능 추가 건
								SELECT @v_dSql += 'WHERE 1=1 ' + char(10)
								SELECT @v_dSql += 'AND   DIVISION_ID     = '''+ @v_division_id +''' ' + char(10)
								SELECT @v_dSql += 'AND   SITE_ID         = '''+ @v_site_id +''' ' + char(10)
								SELECT @v_dSql += 'AND   PLANT_ID        = '''+ @v_plant_id +''' ' + char(10)
								SELECT @v_dSql += 'AND   PDS_TARGET_ID   = '''+ @v_test_target_id +''' ' + char(10)
          						SELECT @v_dSql += ' ' + char(10)
								SELECT @v_dSql += 'INSERT INTO HIS_WEEKLY_DEMAND_PRODUCT_PDS_H ( ' + char(10)
								SELECT @v_dSql += '		  COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, SHOP_GROUP_ID ' + char(10)
								SELECT @v_dSql += '		, PDS_PLAN_ID, PDS_TARGET_ID ' + char(10)
								SELECT @v_dSql += '		, MODEL, ITEM_ID ' + char(10)
								SELECT @v_dSql += '		, MARKET, PRODUCTION_TYPE ' + char(10)
								SELECT @v_dSql += '		, VERSION, PLM_EC_NO ' + char(10)
								SELECT @v_dSql += '		, FACTORY_ID ' + char(10)
								SELECT @v_dSql += '		, LINE_ID, OPERATION_ID ' + char(10)
								SELECT @v_dSql += '		, DUE_DATE, SEQ, MFG_WEEK ' + char(10)
								SELECT @v_dSql += '		, MFG_QTY, MFG_QTY_UOM ' + char(10)
								SELECT @v_dSql += '		, ORG_MFG_QTY, ORG_MFG_QTY_UOM ' + char(10)
								SELECT @v_dSql += '		, DESCRIPTION, DEMAND_TYPE ' + char(10)
								SELECT @v_dSql += '		, PREV_OPER_PLANNING_YN, IS_PREV_SCHEDULE ' + char(10)
								SELECT @v_dSql += '		, INSERT_ID, INSERT_TIME ' + char(10)
								SELECT @v_dSql += '		, UPDATE_ID, UPDATE_TIME ' + char(10)
								SELECT @v_dSql += '		, PDS_TARGET_ID_ORG ' + char(10)
								SELECT @v_dSql += '		, JOB_USER_ID, JOB_TIME, JOB_TYPE ,ACTIVE_FLAG            ' + char(10)  --E20260316-000249 FP 계획 수립시 PDS Target 계획 반영 유무 기능 추가 건
								SELECT @v_dSql += ') ' + char(10)
								SELECT @v_dSql += 'SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, SHOP_GROUP_ID ' + char(10)
								SELECT @v_dSql += '		, PDS_PLAN_ID, PDS_TARGET_ID ' + char(10)
								SELECT @v_dSql += '		, MODEL, ITEM_ID ' + char(10)
								SELECT @v_dSql += '		, MARKET, PRODUCTION_TYPE ' + char(10)
								SELECT @v_dSql += '		, VERSION, PLM_EC_NO ' + char(10)
								SELECT @v_dSql += '		, FACTORY_ID ' + char(10)
								SELECT @v_dSql += '		, LINE_ID, OPERATION_ID ' + char(10)
								SELECT @v_dSql += '		, DUE_DATE, SEQ, MFG_WEEK ' + char(10)
								SELECT @v_dSql += '		, MFG_QTY, MFG_QTY_UOM ' + char(10)
								SELECT @v_dSql += '		, ORG_MFG_QTY, ORG_MFG_QTY_UOM ' + char(10)
								SELECT @v_dSql += '		, DESCRIPTION, DEMAND_TYPE ' + char(10)
								SELECT @v_dSql += '		, PREV_OPER_PLANNING_YN, IS_PREV_SCHEDULE ' + char(10)
								SELECT @v_dSql += '		, INSERT_ID, INSERT_TIME ' + char(10)
								SELECT @v_dSql += '		, UPDATE_ID, UPDATE_TIME ' + char(10)
								SELECT @v_dSql += '		, PDS_TARGET_ID_ORG ' + char(10)
								SELECT @v_dSql += '		, '''+ @v_user_id +''' AS JOB_USER_ID, DBO.SYSDATE1() AS JOB_TIME, ''UPDATE'' AS JOB_TYPE' + char(10)
                                SELECT @v_dSql += '     , ACTIVE_FLAG '                                            + char(10)  --E20260316-000249 FP 계획 수립시 PDS Target 계획 반영 유무 기능 추가 건
								SELECT @v_dSql += 'FROM   FP_WEEKLY_DEMAND_PRODUCT_PDS_H A WITH(NOLOCK)	     ' + char(10)
								SELECT @v_dSql += 'WHERE  1=1 ' + char(10)
								SELECT @v_dSql += 'AND    DIVISION_ID     = '''+ @v_division_id +''' ' + char(10)
								SELECT @v_dSql += 'AND    SITE_ID         = '''+ @v_site_id +''' ' + char(10)
								SELECT @v_dSql += 'AND    PLANT_ID        = '''+ @v_plant_id +''' ' + char(10)
								SELECT @v_dSql += 'AND    PDS_TARGET_ID   = '''+ @v_test_target_id +''' ' + char(10)
								SELECT @v_dSql += ' ' + char(10)
								
                            END --M
					   /****************************************************************************/
					   /* DELETE경우 : D                                                           */
					   /****************************************************************************/
					   ELSE IF(@v_sys_flag ='D')
						   BEGIN
								SELECT @v_dSql = ''
								SELECT @v_dSql += 'INSERT INTO HIS_WEEKLY_DEMAND_PRODUCT_PDS_H ( ' + char(10)
								SELECT @v_dSql += '		  COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, SHOP_GROUP_ID ' + char(10)
								SELECT @v_dSql += '		, PDS_PLAN_ID, PDS_TARGET_ID ' + char(10)
								SELECT @v_dSql += '		, MODEL, ITEM_ID ' + char(10)
								SELECT @v_dSql += '		, MARKET, PRODUCTION_TYPE ' + char(10)
								SELECT @v_dSql += '		, VERSION, PLM_EC_NO ' + char(10)
								SELECT @v_dSql += '		, FACTORY_ID ' + char(10)
								SELECT @v_dSql += '		, LINE_ID, OPERATION_ID ' + char(10)
								SELECT @v_dSql += '		, DUE_DATE, SEQ, MFG_WEEK ' + char(10)
								SELECT @v_dSql += '		, MFG_QTY, MFG_QTY_UOM ' + char(10)
								SELECT @v_dSql += '		, ORG_MFG_QTY, ORG_MFG_QTY_UOM ' + char(10)
								SELECT @v_dSql += '		, DESCRIPTION, DEMAND_TYPE ' + char(10)
								SELECT @v_dSql += '		, PREV_OPER_PLANNING_YN, IS_PREV_SCHEDULE ' + char(10)
								SELECT @v_dSql += '		, INSERT_ID, INSERT_TIME ' + char(10)
								SELECT @v_dSql += '		, UPDATE_ID, UPDATE_TIME ' + char(10)
								SELECT @v_dSql += '		, PDS_TARGET_ID_ORG ' + char(10)
								SELECT @v_dSql += '		, JOB_USER_ID, JOB_TIME, JOB_TYPE,ACTIVE_FLAG' + char(10)  --E20260316-000249 FP 계획 수립시 PDS Target 계획 반영 유무 기능 추가 건
								SELECT @v_dSql += ')														     ' + char(10)
								SELECT @v_dSql += 'SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, SHOP_GROUP_ID ' + char(10)
								SELECT @v_dSql += '		, PDS_PLAN_ID, PDS_TARGET_ID ' + char(10)
								SELECT @v_dSql += '		, MODEL, ITEM_ID ' + char(10)
								SELECT @v_dSql += '		, MARKET, PRODUCTION_TYPE ' + char(10)
								SELECT @v_dSql += '		, VERSION, PLM_EC_NO ' + char(10)
								SELECT @v_dSql += '		, FACTORY_ID ' + char(10)
								SELECT @v_dSql += '		, LINE_ID, OPERATION_ID ' + char(10)
								SELECT @v_dSql += '		, DUE_DATE, SEQ, MFG_WEEK ' + char(10)
								SELECT @v_dSql += '		, MFG_QTY, MFG_QTY_UOM ' + char(10)
								SELECT @v_dSql += '		, ORG_MFG_QTY, ORG_MFG_QTY_UOM ' + char(10)
								SELECT @v_dSql += '		, DESCRIPTION, DEMAND_TYPE ' + char(10)
								SELECT @v_dSql += '		, PREV_OPER_PLANNING_YN, IS_PREV_SCHEDULE ' + char(10)
								SELECT @v_dSql += '		, INSERT_ID, INSERT_TIME ' + char(10)
								SELECT @v_dSql += '		, UPDATE_ID, UPDATE_TIME ' + char(10)
								SELECT @v_dSql += '		, PDS_TARGET_ID_ORG ' + char(10)
								SELECT @v_dSql += '		, '''+ @v_user_id +''' AS JOB_USER_ID, DBO.SYSDATE1() AS JOB_TIME, ''DELETE'' AS JOB_TYPE' + char(10)
                                SELECT @v_dSql += '     , ACTIVE_FLAG'                                 + char(10)  --E20260316-000249 FP 계획 수립시 PDS Target 계획 반영 유무 기능 추가 건
								SELECT @v_dSql += 'FROM   FP_WEEKLY_DEMAND_PRODUCT_PDS_H A WITH(NOLOCK)	     ' + char(10)
								SELECT @v_dSql += 'WHERE  1=1 ' + char(10)
								SELECT @v_dSql += 'AND    DIVISION_ID     = '''+ @v_division_id +''' ' + char(10)
								SELECT @v_dSql += 'AND    SITE_ID         = '''+ @v_site_id +''' ' + char(10)
								SELECT @v_dSql += 'AND    PLANT_ID        = '''+ @v_plant_id +''' ' + char(10)
								SELECT @v_dSql += 'AND    PDS_TARGET_ID   = '''+ @v_test_target_id +''' ' + char(10)
                                SELECT @v_dSql += ' ' + char(10)
                                SELECT @v_dSql += 'DELETE FROM FP_WEEKLY_DEMAND_PRODUCT_PDS_H                     ' + char(10)
								SELECT @v_dSql += 'WHERE  1=1 ' + char(10)
								SELECT @v_dSql += 'AND    DIVISION_ID     = '''+ @v_division_id +''' ' + char(10)
								SELECT @v_dSql += 'AND    SITE_ID         = '''+ @v_site_id +''' ' + char(10)
								SELECT @v_dSql += 'AND    PLANT_ID        = '''+ @v_plant_id +''' ' + char(10)
								SELECT @v_dSql += 'AND    PDS_TARGET_ID   = '''+ @v_test_target_id +''' ' + char(10)
                                SELECT @v_dSql += ' ' + char(10)

						   END --'D'
					  --/***************************************************************************/
					   --/* DELETE_BUFFER: Excel Import경우 (Excel Import Buffer Delete)           */
					   --/***************************************************************************/
					   ELSE IF(@v_sys_flag ='DELETE_BUFFER')
					       BEGIN
						       SELECT @v_dSql = '';
							   SELECT @v_dSql += '	 DELETE FROM BUF_WEEKLY_DEMAND_PRODUCT_TEST_H  ' + char(10)
                               SELECT @v_dSql += '	 WHERE JOB_USER_ID = '''+ @v_user_id +'''      ' + char(10)
							   SELECT @v_dSql += '	;                                              ' + char(10)
							END
					   --/***************************************************************/
					   --/* Excel Import경우 P: (Excel Import Buffer 저장)              */
					   --/***************************************************************/
					   ELSE IF(@v_sys_flag ='INSERT_BUFFER')
					       BEGIN
						       SELECT @v_dSql = ''
                               SELECT @v_dSql += ' INSERT INTO BUF_WEEKLY_DEMAND_PRODUCT_TEST_H (      ' + char(10)
                               SELECT @v_dSql += '     COMPANY_ID,   DIVISION_ID,     SITE_ID          ' + char(10)
                               SELECT @v_dSql += '   , PLANT_ID,     SCP_PLAN_ID,     TEST_TARGET_ID   ' + char(10)
                               SELECT @v_dSql += '   , MODEL,        ITEM_ID,         FACTORY_ID       ' + char(10)
                               SELECT @v_dSql += '   , LINE_ID,      OPERATION_ID,    DUE_DATE         ' + char(10)
                               SELECT @v_dSql += '   , SEQ,          MFG_WEEK,        MFG_QTY          ' + char(10)
                               SELECT @v_dSql += '   , DESCRIPTION,  DEMAND_TYPE,     IS_PREV_SCHEDULE ' + char(10)
                               SELECT @v_dSql += '   , MARKET,       PRODUCTION_TYPE, JOB_USER_ID      ' + char(10)
                               SELECT @v_dSql += '   , JOB_TIME,     JOB_TYPE,        JOB_ORDER        ' + char(10)
                               SELECT @v_dSql += ' )      ' + char(10)
                               SELECT @v_dSql += ' VALUES ' + char(10)
							   SELECT @v_dSql += '  (     ' + char(10)
                               SELECT @v_dSql += '     '''+ @v_company_id +''', '''+ @v_division_id +''', '''+ @v_site_id +'''   ' + char(10)
                               SELECT @v_dSql += '   , '''+ @v_plant_id +''',  ''-'' ' + char(10)
							   SELECT @v_dSql += '   , '''+ @v_model +''' + ''_'' + '''+ @v_item_id +''' + ''_'' + '''+ @v_due_date +''' + ''_'' + '''+ @v_factory_id +''' + ''_'' + '''+ @v_line_id +''' + ''_'' + '''+ @v_operation_id +''' + ''_'' + '''+ @v_market +''' + ''_'' + '''+ @v_production_type +''' ' + char(10)
                               SELECT @v_dSql += '   , '''+ @v_model +''', '''+ @v_item_id +''', '''+ @v_factory_id +'''        ' + char(10)
                               SELECT @v_dSql += '   , '''+ @v_line_id +''', '''+ @v_operation_id +''', '''+ @v_due_date +'''   ' + char(10)
                               SELECT @v_dSql += '   , 1, (SELECT ISO_YYYYWW FROM TH_UIS_CAL WHERE YYYYMMDD = '''+ @v_due_date +''' ), '''+ @v_mfg_qty +'''  ' + char(10)
                               SELECT @v_dSql += '   , '''+ @v_description +''', '''+ @v_demand_type +''', '''+ @v_is_prev_schedule +'''  ' + char(10)
                               SELECT @v_dSql += '   , ( CASE WHEN '''+ @v_market +''' IS NULL OR '''+ @v_market +''' = '''' THEN ''E'' ELSE '''+ @v_market +''' END )  ' + char(10)
                               SELECT @v_dSql += '   , ( CASE WHEN '''+ @v_production_type +''' IS NULL OR '''+ @v_production_type +''' = '''' THEN ''TEST'' ELSE  '''+ @v_production_type +''' END ) ' + char(10)
							   SELECT @v_dSql += '   , '''+ @v_user_id +''', GETDATE(), ''-'', '+ CONVERT(VARCHAR, @mst_loop_cnt) +'   ' + char(10)
                               SELECT @v_dSql += '  )' + char(10)

						   END
					   --/*******************************************************************************/
					   --/* INSERT_EXCEL: ( Excel Import 저장 )                                         */
					   --/*******************************************************************************/
					   ELSE IF(@v_sys_flag ='INSERT_EXCEL')

						   BEGIN 
						        SELECT @v_dSql = ''
                                SELECT @v_dSql += ' MERGE INTO FP_WEEKLY_DEMAND_PRODUCT_PDS_H AS A   ' + char(10)
                                SELECT @v_dSql += ' USING (SELECT RTRIM(LTRIM('''+ @v_company_id +''')) AS COMPANY_ID, RTRIM(LTRIM('''+ @v_division_id +''')) AS DIVISION_ID, RTRIM(LTRIM('''+ @v_site_id +''')) AS SITE_ID ' + char(10)
								SELECT @v_dSql += ' , RTRIM(LTRIM('''+ @v_plant_id +''')) AS PLANT_ID, RTRIM(LTRIM('''+ @v_factory_id +''')) AS FACTORY_ID, RTRIM(LTRIM('''+ @v_operation_id +''')) AS OPERATION_ID ' + char(10)
                                SELECT @v_dSql += ' , RTRIM(LTRIM('''+ @v_line_id +''')) AS LINE_ID, RTRIM(LTRIM('''+ @v_item_id +''')) AS ITEM_ID, RTRIM(LTRIM('''+ @v_due_date +''')) AS DUE_DATE ' + char(10)
                                SELECT @v_dSql += ' , RTRIM(LTRIM('''+ @v_test_target_id +''')) AS TEST_TARGET_ID , RTRIM(LTRIM('''+ @v_market +''')) AS MARKET, RTRIM(LTRIM('''+ @v_production_type +''')) AS PRODUCTION_TYPE ' + char(10)
                                SELECT @v_dSql += ' , RTRIM(LTRIM('''+ @v_model +''')) AS MODEL) AS B ' + char(10)
                                SELECT @v_dSql += '   ON (A.COMPANY_ID   = B.COMPANY_ID   ' + char(10)
                                SELECT @v_dSql += '   AND A.DIVISION_ID  = B.DIVISION_ID  ' + char(10)
                                SELECT @v_dSql += '   AND A.SITE_ID      = B.SITE_ID      ' + char(10)
                                SELECT @v_dSql += '   AND A.PLANT_ID     = B.PLANT_ID     ' + char(10)
                                SELECT @v_dSql += '   AND A.FACTORY_ID   = B.FACTORY_ID   ' + char(10)
                                SELECT @v_dSql += '   AND A.OPERATION_ID = B.OPERATION_ID ' + char(10)
                                SELECT @v_dSql += '   AND A.LINE_ID      = B.LINE_ID      ' + char(10)
                                SELECT @v_dSql += '   AND A.ITEM_ID      = B.ITEM_ID      ' + char(10)
                                SELECT @v_dSql += '   AND A.MARKET       = B.MARKET       ' + char(10)
                                SELECT @v_dSql += '   AND A.PRODUCTION_TYPE = B.PRODUCTION_TYPE ' + char(10)
                                SELECT @v_dSql += '   AND CONVERT(VARCHAR, A.DUE_DATE, 112) = RTRIM(LTRIM('''+ @v_due_date +''')) ' + char(10)
                                SELECT @v_dSql += '   AND A.TEST_TARGET_ID = B.TEST_TARGET_ID )                     ' + char(10)
                                SELECT @v_dSql += ' WHEN MATCHED THEN                                               ' + char(10)
                                SELECT @v_dSql += '   UPDATE SET                                                    ' + char(10)
                                SELECT @v_dSql += '       UPDATE_ID        = '''+ @v_user_id +'''                   ' + char(10)
                                SELECT @v_dSql += '     , UPDATE_TIME      = GETDATE()                              ' + char(10)
                                SELECT @v_dSql += '     , MFG_QTY          = RTRIM(LTRIM('''+ @v_mfg_qty +'''))     ' + char(10)
                                SELECT @v_dSql += '     , DESCRIPTION      = RTRIM(LTRIM('''+ @v_description +''')) ' + char(10)
                                SELECT @v_dSql += '     , IS_PREV_SCHEDULE = ''N''                                  ' + char(10)
                                SELECT @v_dSql += ' WHEN NOT MATCHED THEN                                           ' + char(10)
                                SELECT @v_dSql += '   INSERT (                                                      ' + char(10)
                                SELECT @v_dSql += '      COMPANY_ID, DIVISION_ID, SITE_ID                           ' + char(10)
                                SELECT @v_dSql += '     , PLANT_ID, SCP_PLAN_ID, TEST_TARGET_ID                     ' + char(10)
                                SELECT @v_dSql += '     , MODEL, ITEM_ID, FACTORY_ID                                ' + char(10)
                                SELECT @v_dSql += '     , LINE_ID, OPERATION_ID, DUE_DATE                           ' + char(10)
                                SELECT @v_dSql += '     , SEQ, MFG_WEEK, MFG_QTY                                    ' + char(10)
                                SELECT @v_dSql += '     , DESCRIPTION, DEMAND_TYPE,IS_PREV_SCHEDULE                 ' + char(10)
                                SELECT @v_dSql += '     , MARKET,PRODUCTION_TYPE, INSERT_ID                         ' + char(10)
                                SELECT @v_dSql += '     , INSERT_TIME, UPDATE_ID, UPDATE_TIME                       ' + char(10)
                                SELECT @v_dSql += '   ) VALUES (                                                    ' + char(10)
                                SELECT @v_dSql += '       RTRIM(LTRIM('''+ @v_company_id +''')), RTRIM(LTRIM('''+ @v_division_id +''')), RTRIM(LTRIM('''+ @v_site_id +''')) ' + char(10)
								SELECT @v_dSql += '     , RTRIM(LTRIM('''+ @v_plant_id +''')), ''-''   ' + char(10)
							    SELECT @v_dSql += '     , ('''+ @v_model +''' + ''_'' + '''+ @v_item_id +''' + ''_'' + '''+ @v_due_date +''' + ''_'' + '''+ @v_factory_id +''' + ''_'' + '''+ @v_line_id +''' + ''_'' + '''+ @v_operation_id +''' + ''_'' + '''+ @v_market +''' + ''_'' + '''+ @v_production_type +''') ' + char(10)
                                SELECT @v_dSql += '     , RTRIM(LTRIM('''+ @v_model +''')), RTRIM(LTRIM('''+ @v_item_id +''')), RTRIM(LTRIM('''+ @v_factory_id +'''))  ' + char(10)
                                SELECT @v_dSql += '     , RTRIM(LTRIM('''+ @v_line_id +''')), RTRIM(LTRIM('''+ @v_operation_id +''')), CONVERT(DATE, RTRIM(LTRIM('''+ @v_due_date +''')))  ' + char(10)
                                SELECT @v_dSql += '     , 1, (SELECT ISO_YYYYWW FROM TH_UIS_CAL WHERE YYYYMMDD = RTRIM(LTRIM('''+ @v_due_date +'''))), RTRIM(LTRIM('''+ @v_mfg_qty +''')) ' + char(10)
                                SELECT @v_dSql += '     , RTRIM(LTRIM('''+ @v_description +''')), RTRIM(LTRIM('''+ @v_demand_type +''')), ''N'' ' + char(10)
                                SELECT @v_dSql += '     , RTRIM(LTRIM('''+ @v_market +''')), RTRIM(LTRIM('''+ @v_production_type +''')), '''+ @v_user_id +''' ' + char(10)
                                SELECT @v_dSql += '     , GETDATE(), '''+ @v_user_id +''', GETDATE() ' + char(10)
                                SELECT @v_dSql += '   ) ;   ' + char(10)
                                SELECT @v_dSql += '         ' + char(10)
                                SELECT @v_dSql += ' INSERT INTO HIS_WEEKLY_DEMAND_PRODUCT_PDS_H (                    ' + char(10)
                                SELECT @v_dSql += '         COMPANY_ID, DIVISION_ID, SITE_ID                          ' + char(10)
                                SELECT @v_dSql += '       , PLANT_ID, SCP_PLAN_ID, TEST_TARGET_ID                     ' + char(10)
                                SELECT @v_dSql += '       , MODEL, ITEM_ID, FACTORY_ID                                ' + char(10)
                                SELECT @v_dSql += '       , LINE_ID, OPERATION_ID, DUE_DATE                           ' + char(10)
                                SELECT @v_dSql += '       , SEQ, MFG_WEEK, MFG_QTY                                    ' + char(10)
                                SELECT @v_dSql += '       , DESCRIPTION, DEMAND_TYPE, IS_PREV_SCHEDULE                ' + char(10)
                                SELECT @v_dSql += '       , MARKET, PRODUCTION_TYPE, INSERT_ID                        ' + char(10)
                                SELECT @v_dSql += '       , INSERT_TIME, UPDATE_ID, UPDATE_TIME                       ' + char(10)
                                SELECT @v_dSql += '       , JOB_USER_ID, JOB_TIME, JOB_TYPE,ACTIVE_FLAG               ' + char(10)  --E20260316-000249 FP 계획 수립시 PDS Target 계획 반영 유무 기능 추가 건
                                SELECT @v_dSql += ' )                                                                 ' + char(10)
                                SELECT @v_dSql += ' SELECT COMPANY_ID, DIVISION_ID, SITE_ID                           ' + char(10)
                                SELECT @v_dSql += '       , PLANT_ID, SCP_PLAN_ID, TEST_TARGET_ID                     ' + char(10)
                                SELECT @v_dSql += '       , MODEL, ITEM_ID, FACTORY_ID                                ' + char(10)
                                SELECT @v_dSql += '       , LINE_ID, OPERATION_ID, DUE_DATE                           ' + char(10)
                                SELECT @v_dSql += '       , SEQ, MFG_WEEK, MFG_QTY                                    ' + char(10)
                                SELECT @v_dSql += '       , DESCRIPTION, DEMAND_TYPE, IS_PREV_SCHEDULE                ' + char(10)
                                SELECT @v_dSql += '       , MARKET, PRODUCTION_TYPE, INSERT_ID                        ' + char(10)
                                SELECT @v_dSql += '       , INSERT_TIME, UPDATE_ID, UPDATE_TIME                       ' + char(10)
                                SELECT @v_dSql += '       , '''+ @v_user_id +''' AS JOB_USER_ID,GETDATE() AS JOB_TIME ' + char(10)
                                SELECT @v_dSql += '       ,''EXCEL'' AS JOB_TYPE                                    ' + char(10)
                                SELECT @v_dSql += '        , ACTIVE_FLAG'                                             + char(10)  --E20260316-000249 FP 계획 수립시 PDS Target 계획 반영 유무 기능 추가 건
                                SELECT @v_dSql += ' FROM   FP_WEEKLY_DEMAND_PRODUCT_PDS_H A WITH(NOLOCK)           ' + char(10)
								SELECT @v_dSql += '	WHERE COMPANY_ID      = '''+ @v_company_id +'''                 ' + char(10)
								SELECT @v_dSql += '	AND   DIVISION_ID     = '''+ @v_division_id +'''                ' + char(10)
								SELECT @v_dSql += '	AND   SITE_ID         = '''+ @v_site_id +'''                    ' + char(10)
								SELECT @v_dSql += '	AND   PLANT_ID        = '''+ @v_plant_id +'''                   ' + char(10)
								SELECT @v_dSql += '	AND   FACTORY_ID      = '''+ @v_factory_id +'''                 ' + char(10)
								SELECT @v_dSql += '	AND   OPERATION_ID    = '''+ @v_operation_id +'''               ' + char(10)
								SELECT @v_dSql += '	AND   LINE_ID         = '''+ @v_line_id +'''                    ' + char(10)
								SELECT @v_dSql += ' AND   ITEM_ID         = '''+ @v_item_id +'''                    ' + char(10)
								SELECT @v_dSql += ' AND   MARKET          = '''+ @v_market +'''                     ' + char(10)
								SELECT @v_dSql += ' AND   PRODUCTION_TYPE = '''+ @v_production_type +'''            ' + char(10)
								SELECT @v_dSql += ' AND   CONVERT(VARCHAR,DUE_DATE,112) = '''+ @v_due_date +'''     ' + char(10)
                                SELECT @v_dSql += ' AND   TEST_TARGET_ID = ('''+ @v_model +''' + ''_'' + '''+ @v_item_id +''' + ''_'' + '''+ @v_due_date +''' + ''_'' + '''+ @v_factory_id +''' + ''_'' + '''+ @v_line_id +''' + ''_'' + '''+ @v_operation_id +''' + ''_'' + '''+ @v_market +''' + ''_'' + '''+ @v_production_type +''') ' + char(10)
								SELECT @v_dSql += ' AND   MODEL            = '''+ @v_model +'''                      ' + char(10)

						   END --'G'	
					   --/*******************************************************************************/
					   --/* INSERT_MULTI: ( Popup Multi 저장 )                                         */
					   --/*******************************************************************************/
					   ELSE IF(@v_sys_flag ='INSERT_MULTI')

						   BEGIN 
						       SELECT @v_dSql = ''
                               SELECT @v_dSql += ' MERGE INTO FP_WEEKLY_DEMAND_PRODUCT_PDS_H AS A  ' + char(10)
                               SELECT @v_dSql += ' USING ( SELECT '''+ @v_company_id +''' AS COMPANY_ID,'''+ @v_division_id +''' AS DIVISION_ID, '''+ @v_site_id +''' AS SITE_ID  ' + char(10)
							   SELECT @v_dSql += '     , '''+ @v_plant_id +''' AS PLANT_ID,'''+ @v_factory_id +''' AS FACTORY_ID, '''+ @v_operation_id +''' AS OPERATION_ID  ' + char(10)
                               SELECT @v_dSql += '     , '''+ @v_line_id +''' AS LINE_ID, '''+ @v_model +''' AS MODEL_ID, '''+ @v_item_id +''' AS ITEM_ID  ' + char(10)
                               SELECT @v_dSql += '     , '''+ @v_scp_plan_id +'''AS SCP_PLAN_ID, '''+ @v_due_date +''' AS DUE_DATE, '''+ @v_market +''' AS MARKET   ' + char(10)
                               SELECT @v_dSql += ' 	   , (CASE WHEN '''+ @v_mfg_qty +''' IS NULL OR '''+ @v_mfg_qty +''' = '''' THEN ''0'' ELSE '''+ @v_mfg_qty +''' END) AS MFG_QTY  ' + char(10)
                               SELECT @v_dSql += ' 	   , '''+ @v_description +''' AS DESCRIPTION, '''+ @v_production_type +''' AS PRODUCTION_TYPE  ) AS B  ' + char(10)
                               SELECT @v_dSql += ' ON (    A.COMPANY_ID = B.COMPANY_ID AND A.DIVISION_ID = B.DIVISION_ID AND A.SITE_ID = B.SITE_ID   ' + char(10)
							   SELECT @v_dSql += '     AND A.PLANT_ID = B.PLANT_ID AND A.FACTORY_ID = B.FACTORY_ID    ' + char(10)
                               SELECT @v_dSql += '     AND A.OPERATION_ID = B.OPERATION_ID AND A.LINE_ID = B.LINE_ID  ' + char(10)
                               SELECT @v_dSql += '     AND A.ITEM_ID = B.ITEM_ID  AND CONVERT(VARCHAR,A.DUE_DATE,112) = B.DUE_DATE  ' + char(10)
                               SELECT @v_dSql += '     AND A.TEST_TARGET_ID = (B.MODEL_ID + ''_'' + B.ITEM_ID + ''_'' + B.DUE_DATE + ''_'' + B.FACTORY_ID + ''_'' + B.LINE_ID + ''_'' + B.OPERATION_ID + ''_'' + B.MARKET+ ''_'' + B.PRODUCTION_TYPE) ' + char(10)
                               SELECT @v_dSql += '     AND A.MODEL = B.MODEL_ID )        ' + char(10)
                               SELECT @v_dSql += ' WHEN MATCHED THEN                     ' + char(10)
                               SELECT @v_dSql += '     UPDATE SET                        ' + char(10)
                               SELECT @v_dSql += '         MFG_QTY     = B.MFG_QTY,      ' + char(10)
                               SELECT @v_dSql += '         DESCRIPTION = B.DESCRIPTION,  ' + char(10)
                               SELECT @v_dSql += '         UPDATE_ID = '''+ @v_user_id +''', UPDATE_TIME = GETDATE()  ' + char(10)
                               SELECT @v_dSql += ' WHEN NOT MATCHED THEN ' + char(10)
                               SELECT @v_dSql += '   INSERT (            ' + char(10)
                               SELECT @v_dSql += '       COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID    ' + char(10)
                               SELECT @v_dSql += '     , SCP_PLAN_ID, TEST_TARGET_ID, MODEL, ITEM_ID   ' + char(10)
                               SELECT @v_dSql += '     , FACTORY_ID, LINE_ID, OPERATION_ID, DUE_DATE   ' + char(10)
                               SELECT @v_dSql += '     , SEQ, MFG_WEEK, MFG_QTY          ' + char(10)
                               SELECT @v_dSql += '     , DEMAND_TYPE, IS_PREV_SCHEDULE, MARKET, DESCRIPTION, PRODUCTION_TYPE ' + char(10)
                               SELECT @v_dSql += '     , INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME' + char(10)
                               SELECT @v_dSql += '   ) VALUES ( ' + char(10)
                               SELECT @v_dSql += '       B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID ' + char(10)
                               SELECT @v_dSql += '     , B.SCP_PLAN_ID  ' + char(10)
							   SELECT @v_dSql += '     , (B.MODEL_ID + ''_'' + B.ITEM_ID + ''_'' + B.DUE_DATE + ''_'' + B.FACTORY_ID + ''_'' + B.LINE_ID + ''_'' + B.OPERATION_ID + ''_'' + B.MARKET + ''_'' + B.PRODUCTION_TYPE) ' + char(10)
                               SELECT @v_dSql += '     , B.MODEL_ID, B.ITEM_ID ' + char(10)
                               SELECT @v_dSql += '     , B.FACTORY_ID, B.LINE_ID, B.OPERATION_ID, CONVERT(DATE,B.DUE_DATE) ' + char(10)
                               SELECT @v_dSql += '     , 1, (SELECT MAX(AA.ISO_YYYYWW) FROM TH_UIS_CAL AA WITH(NOLOCK) WHERE AA.YYYYMMDD = B.DUE_DATE), B.MFG_QTY ' + char(10)
                               SELECT @v_dSql += '     , NULL,  NULL, B.MARKET, B.DESCRIPTION, B.PRODUCTION_TYPE         ' + char(10)
                               SELECT @v_dSql += '     , '''+ @v_user_id +''', GETDATE(),'''+ @v_user_id +''', GETDATE() ' + char(10)
                               SELECT @v_dSql += '   ); ' + char(10)

                               SELECT @v_dSql += ' INSERT INTO HIS_WEEKLY_DEMAND_PRODUCT_PDS_H (            ' + char(10)
                               SELECT @v_dSql += '      COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID           ' + char(10)
                               SELECT @v_dSql += '    , SCP_PLAN_ID, TEST_TARGET_ID, MODEL, ITEM_ID          ' + char(10)
                               SELECT @v_dSql += '    , FACTORY_ID, LINE_ID, OPERATION_ID, DUE_DATE, SEQ     ' + char(10)
                               SELECT @v_dSql += '    , MFG_WEEK, MFG_QTY, DESCRIPTION, DEMAND_TYPE          ' + char(10)
                               SELECT @v_dSql += '    , IS_PREV_SCHEDULE, MARKET, PRODUCTION_TYPE,INSERT_ID  ' + char(10)
                               SELECT @v_dSql += '    , INSERT_TIME, UPDATE_ID, UPDATE_TIME,JOB_USER_ID      ' + char(10)
                               SELECT @v_dSql += '    , JOB_TIME, JOB_TYPE ,ACTIVE_FLAG                      ' + char(10)  --E20260316-000249 FP 계획 수립시 PDS Target 계획 반영 유무 기능 추가 건
                               SELECT @v_dSql += ' ) ' + char(10)
                               SELECT @v_dSql += ' SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID         ' + char(10)
                               SELECT @v_dSql += '    , SCP_PLAN_ID, TEST_TARGET_ID, MODEL, ITEM_ID          ' + char(10)
                               SELECT @v_dSql += '    , FACTORY_ID, LINE_ID, OPERATION_ID, DUE_DATE, SEQ     ' + char(10)
                               SELECT @v_dSql += '    , MFG_WEEK, MFG_QTY, DESCRIPTION, DEMAND_TYPE          ' + char(10)
                               SELECT @v_dSql += '    , IS_PREV_SCHEDULE, MARKET, PRODUCTION_TYPE,INSERT_ID  ' + char(10)
                               SELECT @v_dSql += '    , INSERT_TIME, UPDATE_ID, UPDATE_TIME,'''+ @v_user_id +'''AS JOB_USER_ID ' + char(10)
                               SELECT @v_dSql += '    , GETDATE() AS JOB_TIME, ''MERGE_BY_BOM'' AS JOB_TYPE  ' + char(10)
                               SELECT @v_dSql += '    , ACTIVE_FLAG                                          ' + char(10)  --E20260316-000249 FP 계획 수립시 PDS Target 계획 반영 유무 기능 추가 건
                               SELECT @v_dSql += ' FROM   FP_WEEKLY_DEMAND_PRODUCT_PDS_H A WITH(NOLOCK)     ' + char(10)
							   SELECT @v_dSql += '	WHERE COMPANY_ID      = '''+ @v_company_id +'''          ' + char(10)
							   SELECT @v_dSql += '	AND  DIVISION_ID      = '''+ @v_division_id +'''         ' + char(10)
							   SELECT @v_dSql += '	AND  SITE_ID          = '''+ @v_site_id +'''             ' + char(10)
							   SELECT @v_dSql += '	AND  PLANT_ID         = '''+ @v_plant_id +'''            ' + char(10)
							   SELECT @v_dSql += '	AND  FACTORY_ID       = '''+ @v_factory_id +'''          ' + char(10)
							   SELECT @v_dSql += '	AND  OPERATION_ID     = '''+ @v_operation_id +'''        ' + char(10)
							   SELECT @v_dSql += '	AND  LINE_ID          = '''+ @v_line_id +'''             ' + char(10)
							   SELECT @v_dSql += '  AND  ITEM_ID          = '''+ @v_item_id +'''             ' + char(10)
							   SELECT @v_dSql += '  AND  MARKET           = '''+ @v_market +'''              ' + char(10)
							   SELECT @v_dSql += '  AND  PRODUCTION_TYPE  = '''+ @v_production_type +'''     ' + char(10)
							   SELECT @v_dSql += '  AND  CONVERT(VARCHAR,DUE_DATE,112) = '''+ @v_due_date +'''  ' + char(10)
                               SELECT @v_dSql += '  AND  TEST_TARGET_ID = ('''+ @v_model +''' + ''_'' + '''+ @v_item_id +''' + ''_'' + '''+ @v_due_date +''' + ''_'' + '''+ @v_factory_id +''' + ''_'' + '''+ @v_line_id +''' + ''_'' + '''+ @v_operation_id +''' + ''_'' + '''+ @v_market +''' + ''_'' + '''+ @v_production_type +''') ' + char(10)
							   SELECT @v_dSql += '  AND  MODEL            = '''+ @v_model +'''                      ' + char(10)

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

