
/*
 * Program ID   : PR_UI_FP00510_SCP_TARGET
 * Description  : SCP Target
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/02/01   JYJ				Initial Release UI통합
 */


CREATE PROCEDURE [dbo].[PR_UI_FP00510_SCP_TARGET_TUNING]
  @p_sys_type             NVARCHAR(MAX),  
  @p_sys_flag             NVARCHAR(MAX),
  @p_sys_gubun            NVARCHAR(MAX),  
  @p_user_id              NVARCHAR(MAX),
  @p_company_id           NVARCHAR(MAX), 
  @p_division_id          NVARCHAR(MAX),
  @p_site_id              NVARCHAR(MAX),
  @p_plant_id             NVARCHAR(MAX), 
  @p_instance_id          NVARCHAR(MAX),  --plan group
  @p_scp_plan_id          NVARCHAR(MAX),
  @p_scp_target_id        NVARCHAR(MAX),
  @p_shop_group_id        NVARCHAR(MAX),
  @p_item_id              NVARCHAR(MAX), 
  @p_nick_name            NVARCHAR(MAX), 
  @p_mfg_week             NVARCHAR(MAX), 
  @p_market               NVARCHAR(MAX), 
  @p_org_market           NVARCHAR(MAX), 
  @p_mfg_date             NVARCHAR(MAX), 
  @p_mfg_qty              NVARCHAR(MAX), 
  @p_chg_qty              NVARCHAR(MAX),
  @p_production_type      NVARCHAR(MAX),
  @p_priority             NVARCHAR(MAX),
  @p_period_type          NVARCHAR(MAX),
  @p_line_id              NVARCHAR(MAX), 
  @p_line_name            NVARCHAR(MAX) 

AS 
BEGIN  --MAIN
    
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
    SET NOCOUNT ON                                                                                                                                                                                                                                                   
    SET XACT_ABORT ON 
    
    DECLARE @v_sys_type			    NVARCHAR(100)  -- 값>> SELEC: SQL저장안함, SQL:SQL저장함
    DECLARE @v_sys_flag			    NVARCHAR(100)  -- 값>> I: Insert, M: Update, D: Delete, G: MERGE
    DECLARE @v_sys_gubun			NVARCHAR(100) 
    DECLARE @v_user_id			    NVARCHAR(100)
    DECLARE @v_company_id           NVARCHAR(100) 
    DECLARE @v_division_id          NVARCHAR(100)
    DECLARE @v_site_id              NVARCHAR(100)
    DECLARE @v_plant_id             NVARCHAR(100) 
    DECLARE @v_instance_id          NVARCHAR(100)
    DECLARE @v_scp_plan_id          NVARCHAR(100)
    DECLARE @v_scp_target_id        NVARCHAR(200)
    DECLARE @v_shop_group_id        NVARCHAR(100)
    DECLARE @v_item_id              NVARCHAR(100) 
    DECLARE @v_nick_name            NVARCHAR(200) 
    DECLARE @v_mfg_week             NVARCHAR(100) 
    DECLARE @v_market               NVARCHAR(100) 
    DECLARE @v_org_market           NVARCHAR(100) 
    DECLARE @v_mfg_date             NVARCHAR(100) 
    DECLARE @v_mfg_qty              NVARCHAR(100) 
    DECLARE @v_chg_qty              NVARCHAR(100)
    DECLARE @v_production_type      NVARCHAR(100)
    DECLARE @v_priority             NVARCHAR(100)
    DECLARE @v_period_type          NVARCHAR(100)
    DECLARE @v_line_id              NVARCHAR(100) 
    DECLARE @v_line_name            NVARCHAR(200) 
    
    DECLARE @v_sample_from_date     NVARCHAR(100) 
    DECLARE @v_sample_to_date       NVARCHAR(100)
    DECLARE @v_confirm_type         NVARCHAR(100) 
    DECLARE @v_demand_type          NVARCHAR(100)
    
    DECLARE @recv_active_flag       NVARCHAR(MAX)
    DECLARE @v_proc_name	        NVARCHAR(100) = OBJECT_NAME(@@PROCID)
    DECLARE @v_log_type             NVARCHAR(100) = '' 
    DECLARE @v_log_message          NVARCHAR(MAX) = ''
    DECLARE @v_error_description    NVARCHAR(MAX) = ''
    DECLARE @v_delimiter            NVARCHAR(1)
    DECLARE @max_loop_cnt	        INTEGER = 0 
    DECLARE @mst_loop_cnt	        INTEGER = 0
    DECLARE @v_seq_no   	        INTEGER = 0
    
    DECLARE @sysdate                DATETIME      = GETDATE()
    DECLARE @runstart               datetime
    DECLARE @runend                 datetime

    DECLARE @v_dSql                 NVARCHAR(MAX)=''
    DECLARE @v_dSql1                NVARCHAR(MAX)=''
    DECLARE @v_dSql2                NVARCHAR(MAX)=''
    DECLARE @v_dSql3                NVARCHAR(MAX)=''
    DECLARE @v_dSql4                NVARCHAR(MAX)=''
    DECLARE @v_dSql5                NVARCHAR(MAX)=''

    SELECT  @v_sys_type         = '', @v_sys_flag             = '', @v_sys_gubun            = '', @v_user_id         = ''
          , @v_company_id       = '', @v_division_id          = '', @v_site_id              = '', @v_plant_id        = '' 
          , @v_instance_id      = '', @v_scp_plan_id          = '', @v_scp_target_id        = '', @v_shop_group_id   = ''
          , @v_item_id          = '', @v_nick_name            = '', @v_mfg_week             = '', @v_market          = '' 
          , @v_org_market       = '', @v_mfg_date             = '', @v_mfg_qty              = '', @v_chg_qty         = ''
          , @v_production_type  = '', @v_priority             = '', @v_period_type          = '', @v_line_id         = '' 
          , @v_line_name        = '', @v_sample_from_date     = '', @v_sample_to_date       = '', @v_confirm_type    = ''
          , @v_demand_type      = ''


     --SET @p_user_id               = dbo.FN_deCRYPT_AES128(@p_user_id)
     SET  @recv_active_flag       = ''		
     SET  @recv_active_flag       = @p_sys_flag
     SET  @v_delimiter            = '|'  -- 데이터 구분자(파이프라인)
     SET  @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_sys_flag, @v_delimiter) -- 프로시저 LOOP 길이를 판단  
     
     SET  @v_dSql                 = ''
     SET  @v_dSql1                = ''
     SET  @v_dSql2                = ''
     SET  @v_dSql3                = ''
     SET  @v_dSql4                = ''
     SET  @v_dSql5                = ''



--DECLARE @PARAMS NVARCHAR(MAX)

--SET @PARAMS = ''
--SET @PARAMS += '@P_SYS_TYPE=' +ISNULL(@P_SYS_TYPE,'') +CHAR(10)
--SET @PARAMS += '@P_SYS_FLAG=' +ISNULL(@P_SYS_FLAG,'') +CHAR(10)
--SET @PARAMS += '@P_SYS_GUBUN=' +ISNULL(@P_SYS_GUBUN,'') +CHAR(10)
--SET @PARAMS += '@P_USER_ID=' +ISNULL(@P_USER_ID,'') +CHAR(10)
--SET @PARAMS += '@p_company_id=' +ISNULL(@p_company_id,'') +CHAR(10)
--SET @PARAMS += '@p_division_id=' +ISNULL(@p_division_id,'') +CHAR(10)
--SET @PARAMS += '@p_site_id=' +ISNULL(@p_site_id,'') +CHAR(10)
--SET @PARAMS += '@p_plant_id=' +ISNULL(@p_plant_id,'') +CHAR(10)
--SET @PARAMS += '@p_instance_id=' +ISNULL(@p_instance_id,'') +CHAR(10)
--SET @PARAMS += '@p_scp_plan_id=' +ISNULL(@p_scp_plan_id,'') +CHAR(10)
--SET @PARAMS += '@p_scp_target_id=' +ISNULL(@p_scp_target_id,'') +CHAR(10)
--SET @PARAMS += '@p_shop_group_id=' +ISNULL(@p_shop_group_id,'') +CHAR(10)
--SET @PARAMS += '@p_item_id=' +ISNULL(@p_item_id,'') +CHAR(10)
--SET @PARAMS += '@p_nick_name=' +ISNULL(@p_nick_name,'') +CHAR(10)
--SET @PARAMS += '@p_mfg_week=' +ISNULL(@p_mfg_week,'') +CHAR(10)
--SET @PARAMS += '@p_market=' +ISNULL(@p_market,'') +CHAR(10)
--SET @PARAMS += '@p_org_market=' +ISNULL(@p_org_market,'') +CHAR(10)
--SET @PARAMS += '@p_mfg_date=' +ISNULL(@p_mfg_date,'') +CHAR(10)
--SET @PARAMS += '@p_mfg_qty=' +ISNULL(@p_mfg_qty,'') +CHAR(10)
--SET @PARAMS += '@p_chg_qty=' +ISNULL(@p_chg_qty,'') +CHAR(10)
--SET @PARAMS += '@p_production_type=' +ISNULL(@p_production_type,'') +CHAR(10)
--SET @PARAMS += '@p_priority=' +ISNULL(@p_priority,'') +CHAR(10)
--SET @PARAMS += '@p_period_type=' +ISNULL(@p_period_type,'') +CHAR(10)
--SET @PARAMS += '@p_line_id=' +ISNULL(@p_line_id,'') +CHAR(10)
--SET @PARAMS += '@p_line_name=' +ISNULL(@p_line_name,'') +CHAR(10)

--SELECT @PARAMS AS SQL
--RETURN


	/************************************************************************************************/
	/* SELECT인경우 :SELECT_MAIN(SELECT)                                                            */
	/************************************************************************************************/
	IF(@p_sys_flag ='SELECT_MAIN')
		BEGIN --IF(START)
            SELECT @v_dSql = ''
            SELECT @v_dSql += '  SELECT A.COMPANY_ID As COMPANY_ID,         A.SCP_PLAN_ID As SCP_PLAN_ID,   C.SEGMENT4 AS INSTANCE_ID                        ' + char(10)
            SELECT @v_dSql += '     , A.DIVISION_ID As DIVISION_ID,         A.SITE_ID As SITE_ID,           A.PLANT_ID As PLANT_ID                           ' + char(10)
            SELECT @v_dSql += '     ,  A.SCP_TARGET_ID As SCP_TARGET_ID,    A.ITEM_ID As ITEM_ID,           ISNULL(B.NICK_NAME, ''-'') AS NICK_NAME          ' + char(10)
            SELECT @v_dSql += '     , A.SHOP_GROUP_ID As SHOP_GROUP_ID,     A.MFG_WEEK As MFG_WEEK,         A.MARKET As MARKET,      A.MARKET As ORG_MARKET  ' + char(10)
            SELECT @v_dSql += '     , CONVERT(VARCHAR(10), CONVERT(DATE,ISNULL(A.MFG_DATE, E.YYYYMMDD)), 120) AS MFG_DATE, A.MFG_QTY As MFG_QTY,     A.CHG_QTY As CHG_QTY       ' + char(10)
            SELECT @v_dSql += '     , A.PRODUCTION_TYPE As PRODUCTION_TYPE, A.PRIORITY	As PRIORITY,         A.PERIOD_TYPE As PERIOD_TYPE            ' + char(10)
            SELECT @v_dSql += '     , D.LINE_ID As LINE_ID,           D.LINE_NAME,  A.OPERATION_ID As OPERATION_ID                                   ' + char(10)
            SELECT @v_dSql += '     ,(CASE WHEN R.INSTANCE_ID IS NULL THEN ''N'' ELSE ''Y'' END) AS EDIT_YN, A.SAMPLE_FROM_DATE As SAMPLE_FROM_DATE  ' + char(10)
            SELECT @v_dSql += '     , A.SAMPLE_TO_DATE As SAMPLE_TO_DATE,   A.CONFIRM_TYPE As CONFIRM_TYPE, A.DEMAND_TYPE As DEMAND_TYPE             ' + char(10)
			SELECT @v_dSql += '     , (CASE WHEN A.OPERATION_ID <> ''E2000''  THEN '''' WHEN F.ITEM_ID IS NULL THEN ''N'' ELSE ''Y'' END) AS VERSION_YN ' + char(10) -- 환산자 버전 정보 유무 확인... 20230220
            SELECT @v_dSql += '  FROM FP_WEEKLY_DEMAND_PRODUCT_H A WITH(NOLOCK)                                          ' + char(10)
            SELECT @v_dSql += '  INNER HASH JOIN (                                                                       ' + char(10)
            SELECT @v_dSql += '           SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.NICK_NAME ' + char(10)
            SELECT @v_dSql += '           FROM   SCM_ITEM_M A WITH(NOLOCK), SCM_ITEM_CLASS_M B WITH(NOLOCK)              ' + char(10)
            SELECT @v_dSql += '           WHERE  A.ITEM_CLASS  = B.CLASS_ID   ' + char(10)
            SELECT @v_dSql += '           AND    A.ACTIVE_FLAG = ''Y''        ' + char(10)
            SELECT @v_dSql += '           AND    B.USE_FLAG    = ''Y''        ' + char(10)
            SELECT @v_dSql += '  ) B                                          ' + char(10)
            SELECT @v_dSql += '  ON  A.COMPANY_ID  = B.COMPANY_ID             ' + char(10)
            SELECT @v_dSql += '  AND A.DIVISION_ID = B.DIVISION_ID            ' + char(10)
            SELECT @v_dSql += '  AND A.SITE_ID     = B.SITE_ID                ' + char(10)
            SELECT @v_dSql += '  AND A.ITEM_ID     = B.ITEM_ID                ' + char(10)
            SELECT @v_dSql += '  INNER HASH JOIN SCM_SYS_LOOKUP_VALUE C WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += '  ON  A.SITE_ID          = C.SEGMENT2                 ' + char(10)
            SELECT @v_dSql += '  AND A.SHOP_GROUP_ID    = C.SEGMENT3                 ' + char(10)
            SELECT @v_dSql += '  AND A.DIVISION_ID      = C.SEGMENT5                 ' + char(10)
            SELECT @v_dSql += '  AND C.LOOKUP_TYPE_CODE = ''TARGET_INSTANCE''        ' + char(10)
            SELECT @v_dSql += '  AND C.SEGMENT1         = ''SCP TARGET''             ' + char(10)
            SELECT @v_dSql += '  AND C.ACTIVE_FLAG      = ''Y''                      ' + char(10)
            SELECT @v_dSql += '  AND C.SEGMENT4         = '''+ @p_instance_id +'''   ' + char(10)
            SELECT @v_dSql += '  LEFT OUTER HASH JOIN ( ' + char(10)
            SELECT @v_dSql += '    SELECT * FROM(       ' + char(10)
            SELECT @v_dSql += '      SELECT  *          ' + char(10)
            SELECT @v_dSql += '        ,ROW_NUMBER() OVER(partition by COMPANY_ID,DIVISION_ID,SITE_ID,PLANT_ID,FACTORY_ID, SCP_LINE_ID ' + char(10)
            SELECT @v_dSql += '         ORDER BY OPERATION_ID DESC) ROW_NUM    ' + char(10)
            SELECT @v_dSql += '      FROM  SCM_LINE_M WITH(NOLOCK)  ' + char(10)
            SELECT @v_dSql += '        WHERE ACTIVE_FLAG = ''Y''    ' + char(10)
            SELECT @v_dSql += '    ) A                              ' + char(10)
            SELECT @v_dSql += '    WHERE ROW_NUM = 1                ' + char(10)
            SELECT @v_dSql += '  ) D                                ' + char(10)
            SELECT @v_dSql += '  ON  D.COMPANY_ID   = A.COMPANY_ID  ' + char(10)
            SELECT @v_dSql += '  AND D.DIVISION_ID  = A.DIVISION_ID ' + char(10)
            SELECT @v_dSql += '  AND D.SITE_ID      = A.SITE_ID	    ' + char(10)
            SELECT @v_dSql += '  AND D.PLANT_ID     = A.PLANT_ID    ' + char(10)
            SELECT @v_dSql += '  AND D.SCP_LINE_ID  = A.LINE_ID     ' + char(10)
            SELECT @v_dSql += '  LEFT OUTER HASH JOIN TH_UIS_CAL E WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += '  ON  E.ISO_YYYYWW = A.MFG_WEEK                  ' + char(10)
            SELECT @v_dSql += '  AND E.DAY_SEQ = ''2''                          ' + char(10)
			-- 환산자 버전 정보 유무 확인... 20230220
            SELECT @v_dSql += '  LEFT OUTER JOIN ( ' + char(10)
            SELECT @v_dSql += '  	SELECT DISTINCT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, B.ITEM_ID ' + char(10)
            SELECT @v_dSql += '  	FROM   SCM_ITEM_CONV_CALC_M B WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += '  	WHERE  1=1 ' + char(10)
            SELECT @v_dSql += '  	AND	   B.OPERATION = ''E2000'' ' + char(10)
            SELECT @v_dSql += '  	AND	   B.CATEGORY = ''Lane Number'' ' + char(10)
            SELECT @v_dSql += '  	AND    B.VALUE IS NOT NULL ' + char(10)
            SELECT @v_dSql += '  ) F ' + char(10)
            SELECT @v_dSql += '  ON 1=1 ' + char(10)
            SELECT @v_dSql += '  AND A.COMPANY_ID  = F.COMPANY_ID ' + char(10)
            SELECT @v_dSql += '  AND A.DIVISION_ID = F.DIVISION_ID ' + char(10)
            SELECT @v_dSql += '  AND A.SITE_ID     = F.SITE_ID ' + char(10)
            SELECT @v_dSql += '  AND A.PLANT_ID    = F.PLANT_ID ' + char(10)
            SELECT @v_dSql += '  AND A.ITEM_ID     = F.ITEM_ID ' + char(10)
			SELECT @v_dSql += '  LEFT OUTER JOIN (                              ' + char(10)
            SELECT @v_dSql += '       SELECT DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.INSTANCE_ID  ' + char(10)
            SELECT @v_dSql += '       FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK)	' + char(10)
            SELECT @v_dSql += '       WHERE  R.USER_ID   = '''+ @p_user_id +'''	' + char(10)
            SELECT @v_dSql += '       AND    R.SAVE_FLAG = ''Y''     ' + char(10)
            SELECT @v_dSql += '  ) R                                 ' + char(10)
            SELECT @v_dSql += '  ON   A.COMPANY_ID  = R.COMPANY_ID   ' + char(10)
            SELECT @v_dSql += '  AND  A.DIVISION_ID = R.DIVISION_ID  ' + char(10)
            SELECT @v_dSql += '  AND  A.SITE_ID     = R.SITE_ID      ' + char(10)
            SELECT @v_dSql += '  AND  A.PLANT_ID    = R.PLANT_ID     ' + char(10)
            --SELECT @v_dSql += '  AND  C.SEGMENT4    = R.INSTANCE_ID  ' + char(10)
            SELECT @v_dSql += '  AND  '''+ @p_instance_id +'''    = R.INSTANCE_ID  ' + char(10)
            SELECT @v_dSql += '  WHERE 1=1                           ' + char(10)
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SHOP_GROUP_ID', 'EQ', @p_shop_group_id ))     + char(10)
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SCP_PLAN_ID', 'EQ', @p_scp_plan_id ))         + char(10)
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE', 'EQ', @p_production_type )) + char(10)
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID', 'EQ', @p_division_id ))         + char(10)
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID', 'EQ', @p_site_id ))                 + char(10)
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID', 'EQ', @p_plant_id ))               + char(10)
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID', 'LIKE', @p_item_id ))               + char(10)
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.NICK_NAME', 'LIKE', @p_nick_name ))           + char(10)
            SELECT @v_dSql += '  AND EXISTS ( SELECT  1                                        ' + char(10)
            SELECT @v_dSql += '               FROM    SCM_SYS_LOOKUP_VALUE LV1 WITH(NOLOCK)    ' + char(10)
            SELECT @v_dSql += '                 WHERE   LV1.LOOKUP_TYPE_CODE = ''INSTANCE_ID'' ' + char(10)
            --SELECT @v_dSql += '                 AND     LV1.SEGMENT1         = C.SEGMENT4      ' + char(10)
            SELECT @v_dSql += '                 AND     LV1.SEGMENT1         = '''+ @p_instance_id +'''      ' + char(10)
            SELECT @v_dSql += '                 AND     LV1.ACTIVE_FLAG      = ''Y''           ' + char(10)
            SELECT @v_dSql += '                 AND     LV1.ATTRIBUTE1       = ''BUILDING''    ' + char(10)
            SELECT @v_dSql += '                 UNION ALL                                      ' + char(10)
            SELECT @v_dSql += '                 SELECT  1                                      ' + char(10)
            SELECT @v_dSql += '             FROM   SCM_SYS_LOOKUP_VALUE LV1 WITH(NOLOCK),      ' + char(10)
            SELECT @v_dSql += '                    SCM_SYS_LOOKUP_VALUE LV2 WITH(NOLOCK)       ' + char(10)
            SELECT @v_dSql += '             WHERE   LV1.LOOKUP_TYPE_CODE = ''INSTANCE_ID''     ' + char(10)
            SELECT @v_dSql += '             AND     LV2.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP''  ' + char(10)
            SELECT @v_dSql += '             AND     LV1.SEGMENT1         = LV2.SEGMENT1                 ' + char(10)
            --SELECT @v_dSql += '             AND     LV1.SEGMENT1         = C.SEGMENT4                   ' + char(10)
            SELECT @v_dSql += '             AND     LV1.SEGMENT1         = '''+ @p_instance_id +'''                   ' + char(10)
            SELECT @v_dSql += '             AND     LV1.ACTIVE_FLAG      = ''Y''                        ' + char(10)
            SELECT @v_dSql += '             AND     LV1.ATTRIBUTE1       = ''PLAN GROUP''               ' + char(10)
            SELECT @v_dSql += '             AND     LV2.SEGMENT2         = ISNULL(D.MODEL_TYPE,LV2.SEGMENT2) )	' + char(10)
            SELECT @v_dSql += '  AND    EXISTS (                                    ' + char(10)
            SELECT @v_dSql += '        SELECT 1                                     ' + char(10)
            SELECT @v_dSql += '        FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)    ' + char(10)
            SELECT @v_dSql += '        WHERE  A.COMPANY_ID  = B.COMPANY_ID          ' + char(10)
            SELECT @v_dSql += '        AND    A.DIVISION_ID = B.DIVISION_ID         ' + char(10)
            SELECT @v_dSql += '        AND    A.SITE_ID     = B.SITE_ID             ' + char(10)
            SELECT @v_dSql += '        AND    A.PLANT_ID    = B.PLANT_ID            ' + char(10)
            --SELECT @v_dSql += '        AND    C.SEGMENT4    = B.INSTANCE_ID         ' + char(10)
            SELECT @v_dSql += '        AND    '''+ @p_instance_id +'''    = B.INSTANCE_ID         ' + char(10)
            SELECT @v_dSql += '        AND    B.USER_ID     = '''+ @p_user_id +'''  ' + char(10)
            SELECT @v_dSql += '  )                                                  ' + char(10)
            SELECT @v_dSql += '  ORDER BY SCP_PLAN_ID, DIVISION_ID, SITE_ID, PLANT_ID, SHOP_GROUP_ID, SCP_TARGET_ID ' + char(10)

			IF @p_sys_type = 'SQL'
				BEGIN
                    EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_dSql,'SELECT',@runstart, @runend
                    SELECT @v_dSql as [QUERY_VALUE]
                    
				END  
			ELSE 
				BEGIN
                    SET @runstart = GetDate()
                    --쿼리실행
                    EXEC sp_executesql @v_dSql
                    
                    SET @runend = GetDate()
                    EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id,@p_sys_flag,'',@v_dSql,'select',@runstart, @runend
				END
	    END	--IF( END )
    /************************************************************************************************/
	/* SELECT인경우 :SELECT_PRODUCTIONTYPE(CHANGE PRODUCTION TYPE POPUP)                            */
	/************************************************************************************************/
	ELSE IF(@p_sys_flag ='SELECT_PRODUCTIONTYPE')
		BEGIN --ELSE IF(START)
             SELECT @v_dSql = ''
             SELECT @v_dSql += '  SELECT '''' As CHK, A.COMPANY_ID As COMPANY_ID,  A.SCP_PLAN_ID As SCP_PLAN_ID, C.SEGMENT4 AS INSTANCE_ID             ' + char(10)
             SELECT @v_dSql += '     , A.DIVISION_ID As DIVISION_ID,         A.SITE_ID As SITE_ID,        A.PLANT_ID As PLANT_ID                       ' + char(10)
             SELECT @v_dSql += '     ,  A.SCP_TARGET_ID As SCP_TARGET_ID,    A.ITEM_ID As ITEM_ID,        ISNULL(B.NICK_NAME, ''-'') AS NICK_NAME      ' + char(10)
             SELECT @v_dSql += '     , A.SHOP_GROUP_ID As SHOP_GROUP_ID,     A.MFG_WEEK As MFG_WEEK,      A.MARKET As MARKET,   A.MARKET As ORG_MARKET ' + char(10)
             SELECT @v_dSql += '     , CONVERT(DATE,ISNULL(A.MFG_DATE, E.YYYYMMDD)) AS MFG_DATE, A.MFG_QTY As MFG_QTY,     A.CHG_QTY As CHG_QTY      ' + char(10)
             SELECT @v_dSql += '     , A.PRODUCTION_TYPE As PRODUCTION_TYPE, A.PRIORITY	As PRIORITY,      A.PERIOD_TYPE As PERIOD_TYPE               ' + char(10)
             SELECT @v_dSql += '     , D.LINE_ID As LINE_ID,           D.LINE_NAME                                                                   ' + char(10)
             SELECT @v_dSql += '     ,(CASE WHEN R.INSTANCE_ID IS NULL THEN ''N'' ELSE ''Y'' END) AS EDIT_YN, A.SAMPLE_FROM_DATE As SAMPLE_FROM_DATE ' + char(10)
             SELECT @v_dSql += '     , A.SAMPLE_TO_DATE As SAMPLE_TO_DATE,   A.CONFIRM_TYPE As CONFIRM_TYPE, A.DEMAND_TYPE As DEMAND_TYPE            ' + char(10)
             SELECT @v_dSql += '  FROM FP_WEEKLY_DEMAND_PRODUCT_H A WITH(NOLOCK)                                        ' + char(10)
             SELECT @v_dSql += '  INNER HASH JOIN (                                                                     ' + char(10)
             SELECT @v_dSql += '         SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.NICK_NAME	' + char(10)
             SELECT @v_dSql += '         FROM   SCM_ITEM_M A WITH(NOLOCK), SCM_ITEM_CLASS_M B WITH(NOLOCK)              ' + char(10)
             SELECT @v_dSql += '         WHERE  A.ITEM_CLASS  = B.CLASS_ID ' + char(10)
             SELECT @v_dSql += '         AND    A.ACTIVE_FLAG = ''Y''      ' + char(10)
             SELECT @v_dSql += '         AND    B.USE_FLAG    = ''Y''      ' + char(10)
             SELECT @v_dSql += '  ) B                                      ' + char(10)
             SELECT @v_dSql += '  ON  A.COMPANY_ID  = B.COMPANY_ID         ' + char(10)
             SELECT @v_dSql += '  AND A.DIVISION_ID = B.DIVISION_ID        ' + char(10)
             SELECT @v_dSql += '  AND A.SITE_ID     = B.SITE_ID            ' + char(10)
             SELECT @v_dSql += '  AND A.ITEM_ID     = B.ITEM_ID            ' + char(10)
             SELECT @v_dSql += '  INNER HASH JOIN SCM_SYS_LOOKUP_VALUE C WITH(NOLOCK)  ' + char(10)
             SELECT @v_dSql += '  ON  A.SITE_ID          = C.SEGMENT2                ' + char(10)
             SELECT @v_dSql += '  AND A.SHOP_GROUP_ID    = C.SEGMENT3                ' + char(10)
             SELECT @v_dSql += '  AND A.DIVISION_ID      = C.SEGMENT5                ' + char(10)
             SELECT @v_dSql += '  AND C.LOOKUP_TYPE_CODE = ''TARGET_INSTANCE''       ' + char(10)
             SELECT @v_dSql += '  AND C.SEGMENT1         = ''SCP TARGET''            ' + char(10)
             SELECT @v_dSql += '  AND C.ACTIVE_FLAG      = ''Y''                     ' + char(10)
             SELECT @v_dSql += '  AND C.SEGMENT4         = '''+ @p_instance_id +'''  ' + char(10)
             SELECT @v_dSql += '  LEFT OUTER HASH JOIN (  ' + char(10)
             SELECT @v_dSql += '    SELECT * FROM(	      ' + char(10)
             SELECT @v_dSql += '      SELECT  *           ' + char(10)
             SELECT @v_dSql += '        ,ROW_NUMBER() OVER(partition by COMPANY_ID,DIVISION_ID,SITE_ID,PLANT_ID,FACTORY_ID, SCP_LINE_ID ' + char(10)
             SELECT @v_dSql += '                   ORDER BY OPERATION_ID DESC) ROW_NUM ' + char(10)
             SELECT @v_dSql += '      FROM  SCM_LINE_M WITH(NOLOCK)                    ' + char(10)
             SELECT @v_dSql += '        WHERE ACTIVE_FLAG = ''Y''    ' + char(10)
             SELECT @v_dSql += '    ) A                              ' + char(10)
             SELECT @v_dSql += '    WHERE ROW_NUM = 1                ' + char(10)
             SELECT @v_dSql += '  ) D                                ' + char(10)
             SELECT @v_dSql += '  ON  D.COMPANY_ID   = A.COMPANY_ID  ' + char(10)
             SELECT @v_dSql += '  AND D.DIVISION_ID  = A.DIVISION_ID ' + char(10)
             SELECT @v_dSql += '  AND D.SITE_ID      = A.SITE_ID     ' + char(10)
             SELECT @v_dSql += '  AND D.PLANT_ID     = A.PLANT_ID    ' + char(10)
             SELECT @v_dSql += '  AND D.SCP_LINE_ID  = A.LINE_ID     ' + char(10)
             SELECT @v_dSql += '  LEFT OUTER HASH JOIN TH_UIS_CAL E WITH(NOLOCK) ' + char(10)
             SELECT @v_dSql += '  ON  E.ISO_YYYYWW = A.MFG_WEEK                  ' + char(10)
             SELECT @v_dSql += '  AND E.DAY_SEQ = ''2''                          ' + char(10)
             SELECT @v_dSql += '  LEFT OUTER JOIN (                              ' + char(10)
             SELECT @v_dSql += '       SELECT DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.INSTANCE_ID ' + char(10)
             SELECT @v_dSql += '       FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK)    ' + char(10)
             SELECT @v_dSql += '       WHERE  R.USER_ID   = '''+ @p_user_id +'''    ' + char(10)
             SELECT @v_dSql += '       AND    R.SAVE_FLAG = ''Y''                   ' + char(10)
             SELECT @v_dSql += '  ) R                                               ' + char(10)
             SELECT @v_dSql += '  ON   A.COMPANY_ID  = R.COMPANY_ID   ' + char(10)
             SELECT @v_dSql += '  AND  A.DIVISION_ID = R.DIVISION_ID  ' + char(10)
             SELECT @v_dSql += '  AND  A.SITE_ID     = R.SITE_ID      ' + char(10)
             SELECT @v_dSql += '  AND  A.PLANT_ID    = R.PLANT_ID     ' + char(10)
             SELECT @v_dSql += '  AND  C.SEGMENT4    = R.INSTANCE_ID  ' + char(10)
             SELECT @v_dSql += '  WHERE 1=1                           ' + char(10)
             SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SHOP_GROUP_ID', 'EQ', @p_shop_group_id ))     + char(10)
             SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SCP_PLAN_ID', 'EQ', @p_scp_plan_id ))         + char(10)
             SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE', 'EQ', @p_production_type )) + char(10)
             SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID', 'EQ', @p_division_id ))         + char(10)
             SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID', 'EQ', @p_site_id ))                 + char(10)
             SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID', 'EQ', @p_plant_id ))               + char(10)
			 IF(LEN(@p_item_id) > 0)
			     BEGIN
                     SELECT @v_dSql  += '  AND A.ITEM_ID  LIKE  ''%'' + '''+ @p_item_id +''' + ''%''    '             + char(10)
			     END
			 IF(LEN(@p_nick_name) > 0)
			     BEGIN
                     SELECT @v_dSql  += '  AND B.NICK_NAME  LIKE  ''%'' + '''+ @p_nick_name +''' + ''%''  '           + char(10)
			     END

             SELECT @v_dSql += '  AND EXISTS ( SELECT  1                                             ' + char(10)
             SELECT @v_dSql += '               FROM    SCM_SYS_LOOKUP_VALUE LV1 WITH(NOLOCK)         ' + char(10)
             SELECT @v_dSql += '                    WHERE   LV1.LOOKUP_TYPE_CODE = ''INSTANCE_ID''   ' + char(10)
             SELECT @v_dSql += '                    AND     LV1.SEGMENT1         = C.SEGMENT4        ' + char(10)
             SELECT @v_dSql += '                    AND     LV1.ACTIVE_FLAG      = ''Y''             ' + char(10)
             SELECT @v_dSql += '                    AND     LV1.ATTRIBUTE1       = ''BUILDING''      ' + char(10)
             SELECT @v_dSql += '                    UNION ALL                                        ' + char(10)
             SELECT @v_dSql += '                    SELECT  1                                        ' + char(10)
             SELECT @v_dSql += '               FROM    SCM_SYS_LOOKUP_VALUE LV1 WITH(NOLOCK),        ' + char(10)
             SELECT @v_dSql += '                       SCM_SYS_LOOKUP_VALUE LV2 WITH(NOLOCK)         ' + char(10)
             SELECT @v_dSql += '                WHERE   LV1.LOOKUP_TYPE_CODE = ''INSTANCE_ID''       ' + char(10)
             SELECT @v_dSql += '                AND 	   LV2.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP'' ' + char(10)
             SELECT @v_dSql += '                AND     LV1.SEGMENT1         = LV2.SEGMENT1                   ' + char(10)
             SELECT @v_dSql += '                AND     LV1.SEGMENT1         = C.SEGMENT4                     ' + char(10)
             SELECT @v_dSql += '                AND     LV1.ACTIVE_FLAG      = ''Y''                          ' + char(10)
             SELECT @v_dSql += '                AND     LV1.ATTRIBUTE1       = ''PLAN GROUP''                 ' + char(10)
             SELECT @v_dSql += '                AND     LV2.SEGMENT2         = ISNULL(D.MODEL_TYPE,LV2.SEGMENT2) ) ' + char(10)
             SELECT @v_dSql += '  AND    EXISTS (                                       ' + char(10)
             SELECT @v_dSql += '         SELECT 1                                       ' + char(10)
             SELECT @v_dSql += '         FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)      ' + char(10)
             SELECT @v_dSql += '         WHERE  A.COMPANY_ID  = B.COMPANY_ID            ' + char(10)
             SELECT @v_dSql += '         AND    A.DIVISION_ID = B.DIVISION_ID           ' + char(10)
             SELECT @v_dSql += '         AND    A.SITE_ID     = B.SITE_ID               ' + char(10)
             SELECT @v_dSql += '         AND    A.PLANT_ID    = B.PLANT_ID              ' + char(10)
             SELECT @v_dSql += '         AND    C.SEGMENT4    = B.INSTANCE_ID           ' + char(10)
             SELECT @v_dSql += '         AND    B.USER_ID     = '''+ @p_user_id +'''    ' + char(10)
             SELECT @v_dSql += '  )                                                     ' + char(10)
             SELECT @v_dSql += '  ORDER BY SCP_PLAN_ID, DIVISION_ID, SITE_ID, PLANT_ID, SHOP_GROUP_ID, SCP_TARGET_ID' + char(10)
             
			IF @p_sys_type = 'SQL'
				BEGIN
                    EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,@p_sys_flag,'',@v_dSql,'SELECT',@runstart, @runend
                    SELECT @v_dSql as [QUERY_VALUE]
                    
				END  
			ELSE 
				BEGIN
                    SET @runstart = GetDate()
                    --쿼리실행
                    EXEC sp_executesql @v_dSql
                    
                    SET @runend = GetDate()
                    EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id,@p_sys_flag,'',@v_dSql,'select',@runstart, @runend
				END
	    END	--ELSE IF( END )
    /************************************************************************************************/
	/* SELECT인경우 :SELECT_SUB(SELECT)                                                             */
	/************************************************************************************************/
    ELSE IF(@p_sys_flag ='SELECT_SUB')
	    BEGIN --ELSE IF(START)
            SELECT @v_dSql = ''																													 
            SELECT @v_dSql += '   SELECT A.COMPANY_ID As COMPANY_ID, A.DIVISION_ID As DIVISION_ID, A.SITE_ID As SITE_ID                  ' + char(10)
            SELECT @v_dSql += '      , A.PLANT_ID As PLANT_ID, A.SHOP_GROUP_ID As SHOP_GROUP_ID, A.SCP_PLAN_ID	 As SCP_PLAN_ID          ' + char(10)
            SELECT @v_dSql += '      , A.SCP_TARGET_ID As SCP_TARGET_ID, A.ITEM_ID As ITEM_ID, ISNULL(B.NICK_NAME, ''-'') AS NICK_NAME   ' + char(10)
            SELECT @v_dSql += '      , '''+ @p_mfg_week +''' AS MFG_WEEK,  A.TO_SITE_ID,  A.TO_PLANT_ID, A.SHIP_WEEK As SHIP_WEEK        ' + char(10)
            SELECT @v_dSql += '      , A.SHIP_QTY As SHIP_QTY, A.CUSTOMER_ID As CUSTOMER_ID, A.DESCRIPTION AS DESCRIPTION                ' + char(10)
            SELECT @v_dSql += '      , '''' As MESSAGE_ID, A.SEQ                ' + char(10)
            SELECT @v_dSql += '    FROM   FP_WEEKLY_DEMAND_DETAIL_H A(NOLOCK)   ' + char(10)
            SELECT @v_dSql += '	  INNER MERGE JOIN (                            ' + char(10)
            SELECT @v_dSql += '          SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.NICK_NAME ' + char(10)
            SELECT @v_dSql += '          FROM   SCM_ITEM_M A(NOLOCK), SCM_ITEM_CLASS_M B(NOLOCK)  ' + char(10)
            SELECT @v_dSql += '          WHERE  A.ITEM_CLASS   = B.CLASS_ID  ' + char(10)
            SELECT @v_dSql += '          AND    A.ACTIVE_FLAG  = ''Y''  ' + char(10)
            SELECT @v_dSql += '          AND    B.USE_FLAG     = ''Y''  ' + char(10)
            SELECT @v_dSql += '   ) B                                   ' + char(10)
            SELECT @v_dSql += '   ON  A.COMPANY_ID  = B.COMPANY_ID      ' + char(10)
            SELECT @v_dSql += '   AND A.DIVISION_ID = B.DIVISION_ID     ' + char(10)
            SELECT @v_dSql += '   AND A.SITE_ID     = B.SITE_ID         ' + char(10)
            SELECT @v_dSql += '   AND A.ITEM_ID     = B.ITEM_ID         ' + char(10)
            SELECT @v_dSql += '   WHERE  A.COMPANY_ID     = '''+ @p_company_id +'''	   ' + char(10)
            SELECT @v_dSql += '   AND    A.DIVISION_ID    = '''+ @p_division_id	 +'''  ' + char(10)
            SELECT @v_dSql += '   AND    A.SITE_ID        = '''+ @p_site_id +'''       ' + char(10)
            SELECT @v_dSql += '   AND    A.PLANT_ID       = '''+ @p_plant_id +'''      ' + char(10)
            SELECT @v_dSql += '   AND    A.SHOP_GROUP_ID  = '''+ @p_shop_group_id +''' ' + char(10)
            SELECT @v_dSql += '   AND    A.SCP_PLAN_ID    = '''+ @p_scp_plan_id	 +'''  ' + char(10)
            SELECT @v_dSql += '   AND    A.SCP_TARGET_ID  = '''+ @p_scp_target_id +''' ' + char(10)
            SELECT @v_dSql += '   ORDER BY SCP_TARGET_ID, ITEM_ID, TO_SITE_ID, SHIP_WEEK, SHIP_QTY	' + char(10)

			IF @p_sys_type = 'SQL'
				BEGIN
                    EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,@p_sys_flag,'',@v_dSql,'select',@runstart, @runend
                    SELECT @v_dSql as [QUERY_VALUE]
                    
				END  
			ELSE 
				BEGIN
                    SET @runstart = GetDate()
                    --쿼리실행
                    EXEC sp_executesql @v_dSql
                    
                    SET @runend = GetDate()
                    EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id,@p_sys_flag,'',@v_dSql,'select',@runstart, @runend
				END		
		END	--ELSE IF(END)
    /************************************************************************************************/
	/* SELECT인경우 :SELECT_NEWTARGET_ID  (SPLIT)                                                    */
	/************************************************************************************************/
    ELSE IF(@p_sys_flag ='SELECT_NEWTARGET_ID')
	    BEGIN --ELSE IF(START)

            SELECT @v_dSql = ''
            SELECT @v_dSql += '      WITH TAG AS  ' + char(10)
            SELECT @v_dSql += '      (            ' + char(10)
            SELECT @v_dSql += ' 	    SELECT CASE WHEN LASTIDX = 0 THEN '''+ @p_scp_target_id +'''    							' + char(10)
            SELECT @v_dSql += '                     ELSE SUBSTRING('''+ @p_scp_target_id +''', 1, LASTIDX-1) END AS SCP_TARGET_ID	' + char(10)
            SELECT @v_dSql += '          FROM  (                                                                                    ' + char(10)
            SELECT @v_dSql += '                 SELECT CHARINDEX(''#'' ,'''+ @p_scp_target_id +''') AS LASTIDX	                    ' + char(10)
            SELECT @v_dSql += '                 ) TMP                                                                               ' + char(10)
            SELECT @v_dSql += '   )                                                                                                 ' + char(10)
            SELECT @v_dSql += '   SELECT ( SELECT TAG.SCP_TARGET_ID FROM TAG) + ''#'' +                                             ' + char(10)
            SELECT @v_dSql += '                  ( CASE WHEN A.SCP_TARGET_ID = ( SELECT TAG.SCP_TARGET_ID FROM TAG ) THEN ''001''   ' + char(10)
            SELECT @v_dSql += '                 ELSE ( REPLICATE(''0'',3 - LEN((CONVERT(NUMERIC, RIGHT(A.SCP_TARGET_ID,3) ) +1 )) ) ' + char(10)
            SELECT @v_dSql += '                         + CAST( (CONVERT( NUMERIC, RIGHT(A.SCP_TARGET_ID,3) )+1) AS VARCHAR) )      ' + char(10)
            SELECT @v_dSql += '                    END ) AS NEW_TARGET_ID                    ' + char(10)
            SELECT @v_dSql += '   FROM (                                                     ' + char(10)
            --SELECT @v_dSql += '         SELECT MAX(A.SCP_TARGET_ID) AS SCP_TARGET_ID         ' + char(10)
			SELECT @v_dSql += '         SELECT (CASE WHEN RIGHT(MAX(A.SCP_TARGET_ID),2) = ''_C''  THEN SUBSTRING(MAX(A.SCP_TARGET_ID), 1, LEN(MAX(A.SCP_TARGET_ID)) -2) ELSE MAX(A.SCP_TARGET_ID) END) AS SCP_TARGET_ID ' + char(10)
            SELECT @v_dSql += '         FROM   FP_WEEKLY_DEMAND_PRODUCT_H A                  ' + char(10)
            SELECT @v_dSql += '         WHERE  A.COMPANY_ID     = '''+ @p_company_id +'''    ' + char(10)
            SELECT @v_dSql += '         AND    A.DIVISION_ID    = '''+ @p_division_id  +'''  ' + char(10)
            SELECT @v_dSql += '         AND    A.SITE_ID        = '''+ @p_site_id +'''       ' + char(10)
            SELECT @v_dSql += '         AND    A.PLANT_ID       = '''+ @p_plant_id +'''      ' + char(10)
            SELECT @v_dSql += '         AND    A.SHOP_GROUP_ID  = '''+ @p_shop_group_id +''' ' + char(10)
            SELECT @v_dSql += '         AND    A.SCP_PLAN_ID    = '''+ @p_scp_plan_id +'''   ' + char(10)
            SELECT @v_dSql += '         AND    A.SCP_TARGET_ID LIKE (SELECT TAG.SCP_TARGET_ID FROM TAG) + ''%''  ' + char(10)
            SELECT @v_dSql += '   ) A   ' + char(10)

            IF @p_sys_type = 'SQL'
                BEGIN
                    EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,@p_sys_flag,'',@v_dSql,'select',@runstart, @runend
                    SELECT @v_dSql as [QUERY_VALUE]
                    
                END  
			ELSE 
				BEGIN
                    SET @runstart = GetDate()
                    --쿼리실행
                    EXEC sp_executesql @v_dSql
                    
                    SET @runend = GetDate()
                    EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id,@p_sys_flag,'',@v_dSql,'select',@runstart, @runend
                END		
	    END --ELSE IF(END)

	ELSE
		-- 트랜잭션 (TRAN)
		BEGIN TRY				                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
		BEGIN TRAN   

		BEGIN --ELSE ( BEGIN )
		    --max_loop_cnt:전체 Row수 , mst_loop_cnt:1씩 증가시켜서 전체 Row수 까지만 로직을 수행
			WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
			    BEGIN --WHILE 내(START)
                    
						SELECT @mst_loop_cnt = @mst_loop_cnt + 1	-- @mst_loop_cnt 1증가

                        SELECT @v_sys_type         = isnull([dbo].[SCM_ARR_SPL_VAL]( @p_sys_type        ,@v_delimiter, @mst_loop_cnt), '')
                          , @v_sys_flag            = isnull([dbo].[SCM_ARR_SPL_VAL]( @p_sys_flag        ,@v_delimiter, @mst_loop_cnt), '')
                          , @v_sys_gubun           = isnull([dbo].[SCM_ARR_SPL_VAL]( @p_sys_gubun       ,@v_delimiter, @mst_loop_cnt), '')
                          , @v_user_id			   = isnull([dbo].[SCM_ARR_SPL_VAL]( @p_user_id         ,@v_delimiter, @mst_loop_cnt), '')
                          , @v_company_id          = isnull([dbo].[SCM_ARR_SPL_VAL]( @p_company_id      ,@v_delimiter, @mst_loop_cnt), '')
                          , @v_division_id         = isnull([dbo].[SCM_ARR_SPL_VAL]( @p_division_id     ,@v_delimiter, @mst_loop_cnt), '')
                          , @v_site_id             = isnull([dbo].[SCM_ARR_SPL_VAL]( @p_site_id         ,@v_delimiter, @mst_loop_cnt), '')
                          , @v_plant_id            = isnull([dbo].[SCM_ARR_SPL_VAL]( @p_plant_id        ,@v_delimiter, @mst_loop_cnt), '')  
                          , @v_instance_id         = isnull([dbo].[SCM_ARR_SPL_VAL]( @p_instance_id     ,@v_delimiter, @mst_loop_cnt), '')
                          , @v_scp_plan_id         = isnull([dbo].[SCM_ARR_SPL_VAL]( @p_scp_plan_id     ,@v_delimiter, @mst_loop_cnt), '')
                          , @v_scp_target_id       = isnull([dbo].[SCM_ARR_SPL_VAL]( @p_scp_target_id   ,@v_delimiter, @mst_loop_cnt), '')
                          , @v_shop_group_id       = isnull([dbo].[SCM_ARR_SPL_VAL]( @p_shop_group_id   ,@v_delimiter, @mst_loop_cnt), '')
                          , @v_item_id             = isnull([dbo].[SCM_ARR_SPL_VAL]( @p_item_id         ,@v_delimiter, @mst_loop_cnt), '') 
                          , @v_nick_name           = isnull([dbo].[SCM_ARR_SPL_VAL]( @p_nick_name       ,@v_delimiter, @mst_loop_cnt), '') 
                          , @v_mfg_week            = isnull([dbo].[SCM_ARR_SPL_VAL]( @p_mfg_week        ,@v_delimiter, @mst_loop_cnt), '') 
                          , @v_market              = isnull([dbo].[SCM_ARR_SPL_VAL]( @p_market          ,@v_delimiter, @mst_loop_cnt), '') 
                          , @v_org_market          = isnull([dbo].[SCM_ARR_SPL_VAL]( @p_org_market      ,@v_delimiter, @mst_loop_cnt), '') 
                          , @v_mfg_date            = isnull([dbo].[SCM_ARR_SPL_VAL]( @p_mfg_date        ,@v_delimiter, @mst_loop_cnt), '') 
                          , @v_mfg_qty             = isnull([dbo].[SCM_ARR_SPL_VAL]( @p_mfg_qty         ,@v_delimiter, @mst_loop_cnt), '') 
                          , @v_chg_qty             = isnull([dbo].[SCM_ARR_SPL_VAL]( @p_chg_qty         ,@v_delimiter, @mst_loop_cnt), '')
                          , @v_production_type     = isnull([dbo].[SCM_ARR_SPL_VAL]( @p_production_type ,@v_delimiter, @mst_loop_cnt), '')
                          , @v_priority            = isnull([dbo].[SCM_ARR_SPL_VAL]( @p_priority        ,@v_delimiter, @mst_loop_cnt), '')
                          , @v_period_type         = isnull([dbo].[SCM_ARR_SPL_VAL]( @p_period_type     ,@v_delimiter, @mst_loop_cnt), '')
                          , @v_line_id             = isnull([dbo].[SCM_ARR_SPL_VAL]( @p_line_id         ,@v_delimiter, @mst_loop_cnt), '') 
                          , @v_line_name           = isnull([dbo].[SCM_ARR_SPL_VAL]( @p_line_name       ,@v_delimiter, @mst_loop_cnt), '') 

                       /****************************************************************************/
                       /* UPDATE  경우  :MAIN                                                      */
                       /****************************************************************************/
                       IF(@v_sys_flag = 'M')
                            BEGIN
                                 SELECT @v_dSql = ''
                                 
                                 SELECT @v_dSql1 = ''
                                 SELECT @v_dSql1 += '    UPDATE FP_WEEKLY_DEMAND_PRODUCT_H SET   ' + char(10)
                                 SELECT @v_dSql1 += '        MARKET          = ( CASE  WHEN N'''+ @v_market +''' IS NULL THEN '''' ELSE N'''+ @v_market +''' END )  ' + char(10)
                                 SELECT @v_dSql1 += '        ,PRODUCTION_TYPE = N'''+ @v_production_type +''' ' + char(10)
                                 SELECT @v_dSql1 += '        ,UPDATE_ID       = N'''+ @v_user_id +'''         ' + char(10)
                                 SELECT @v_dSql1 += '        ,UPDATE_TIME     = GETDATE()                     ' + char(10)
                                 SELECT @v_dSql1 += '    WHERE  COMPANY_ID     = N'''+ @v_company_id +'''     ' + char(10)
                                 SELECT @v_dSql1 += '    AND    DIVISION_ID    = N'''+ @v_division_id +'''    ' + char(10)
                                 SELECT @v_dSql1 += '    AND    SITE_ID        = N'''+ @v_site_id +'''        ' + char(10)
                                 SELECT @v_dSql1 += '    AND    PLANT_ID       = N'''+ @v_plant_id +'''       ' + char(10)
                                 SELECT @v_dSql1 += '    AND    SHOP_GROUP_ID  = N'''+ @v_shop_group_id +'''  ' + char(10)
                                 SELECT @v_dSql1 += '    AND    SCP_PLAN_ID    = N'''+ @v_scp_plan_id +'''    ' + char(10)
                                 SELECT @v_dSql1 += '    AND    SCP_TARGET_ID  = N'''+ @v_scp_target_id +'''  ' + char(10)
                                 SELECT @v_dSql1 += '    AND    MARKET  = ( CASE  WHEN  N'''+ @v_org_market +''' IS NULL THEN '''' ELSE  N'''+ @v_org_market +''' END ) ' + char(10)
                                 SELECT @v_dSql3  = '' + char(10)
                                 SELECT @v_dSql3 += ' INSERT INTO HIS_WEEKLY_DEMAND_PRODUCT_H (                                         ' + char(10)
                                 SELECT @v_dSql3 += '      COMPANY_ID,  DIVISION_ID,   SITE_ID,     PLANT_ID,       SHOP_GROUP_ID       ' + char(10)
                                 SELECT @v_dSql3 += '    , SCP_PLAN_ID, SCP_TARGET_ID, MARKET,      ITEM_ID,        MFG_WEEK            ' + char(10)
                                 SELECT @v_dSql3 += '    , MFG_QTY,     CHG_QTY,     PRODUCTION_TYPE, SAMPLE_FROM_DATE, SAMPLE_TO_DATE  ' + char(10)
                                 SELECT @v_dSql3 += '    , LINE_ID,      PRIORITY,    PERIOD_TYPE,   CONFIRM_TYPE,   DEMAND_TYPE        ' + char(10)
                                 SELECT @v_dSql3 += '    , INSERT_ID,   INSERT_TIME, UPDATE_ID,     UPDATE_TIME,    JOB_USER_ID         ' + char(10)
                                 SELECT @v_dSql3 += '    , JOB_TIME,    JOB_TYPE                                                 ' + char(10)
                                 SELECT @v_dSql3 += ' )                                                                          ' + char(10)
                                 SELECT @v_dSql3 += ' SELECT COMPANY_ID, DIVISION_ID, SITE_ID,       PLANT_ID,       SHOP_GROUP_ID       ' + char(10)
                                 SELECT @v_dSql3 += '   , SCP_PLAN_ID,   SCP_TARGET_ID, MARKET,      ITEM_ID,        MFG_WEEK            ' + char(10)
                                 SELECT @v_dSql3 += '   , MFG_QTY,       CHG_QTY,     PRODUCTION_TYPE, SAMPLE_FROM_DATE, SAMPLE_TO_DATE  ' + char(10)
                                 SELECT @v_dSql3 += '   , LINE_ID,       PRIORITY,    PERIOD_TYPE,   CONFIRM_TYPE,    DEMAND_TYPE        ' + char(10)
                                 SELECT @v_dSql3 += '   , INSERT_ID,     INSERT_TIME, UPDATE_ID,     UPDATE_TIME, N'''+ @v_user_id +'''   ' + char(10)
                                 SELECT @v_dSql3 += '   , GETDATE(), ''UPDATE''                            ' + char(10)
                                 SELECT @v_dSql3 += ' FROM   FP_WEEKLY_DEMAND_PRODUCT_H A                  ' + char(10)
                                 SELECT @v_dSql3 += ' WHERE  COMPANY_ID     = N'''+ @v_company_id +'''     ' + char(10)
                                 SELECT @v_dSql3 += ' AND    DIVISION_ID    = N'''+ @v_division_id +'''    ' + char(10)
                                 SELECT @v_dSql3 += ' AND    SITE_ID        = N'''+ @v_site_id +'''        ' + char(10)
                                 SELECT @v_dSql3 += ' AND    PLANT_ID       = N'''+ @v_plant_id +'''       ' + char(10)
                                 SELECT @v_dSql3 += ' AND    SHOP_GROUP_ID  = N'''+ @v_shop_group_id +'''  ' + char(10)
                                 SELECT @v_dSql3 += ' AND    SCP_PLAN_ID    = N'''+ @v_scp_plan_id +'''    ' + char(10)
                                 SELECT @v_dSql3 += ' AND    SCP_TARGET_ID  = N'''+ @v_scp_target_id +'''  ' + char(10)
                                 SELECT @v_dSql3 += ' AND    MARKET         = N'''+ @v_market +'''         ' + char(10)

                                 SELECT @v_dSql =  @v_dSql1 + @v_dSql3
                             END --M
                       /****************************************************************************/
                       /* UPDATE경우 : UPDATE_PRODUCTIONTYPE (CHANGE PROD TYPE POPUP)              */
                       /****************************************************************************/
                       ELSE IF(@v_sys_flag = 'UPDATE_PRODUCTIONTYPE')
                            BEGIN
                                 SELECT @v_dSql = ''
                                 SELECT @v_dSql += '  UPDATE FP_WEEKLY_DEMAND_PRODUCT_H SET                ' + char(10)
                                 SELECT @v_dSql += '     PRODUCTION_TYPE    = '''+ @v_production_type +''' ' + char(10)
                                 SELECT @v_dSql += '   , UPDATE_ID          = '''+ @v_user_id +'''         ' + char(10)
                                 SELECT @v_dSql += '   , UPDATE_TIME        = GETDATE()            		   ' + char(10)
                                 SELECT @v_dSql += '  WHERE  COMPANY_ID     = '''+ @v_company_id +'''      ' + char(10)
                                 SELECT @v_dSql += '  AND    DIVISION_ID    = '''+ @v_division_id +'''     ' + char(10)
                                 SELECT @v_dSql += '  AND    SITE_ID        = '''+ @v_site_id +'''         ' + char(10)
                                 SELECT @v_dSql += '  AND    PLANT_ID       = '''+ @v_plant_id +'''        ' + char(10)
                                 SELECT @v_dSql += '  AND    SHOP_GROUP_ID  = '''+ @v_shop_group_id +'''   ' + char(10)
                                 SELECT @v_dSql += '  AND    SCP_PLAN_ID    = '''+ @v_scp_plan_id +'''     ' + char(10)
                                 SELECT @v_dSql += '  AND    SCP_TARGET_ID  = '''+ @v_scp_target_id +'''   ' + char(10)
                                 SELECT @v_dSql += '  AND    MARKET         = '''+ @v_market +'''          ' + char(10)
                                 SELECT @v_dSql += '   ' + char(10)
                                 SELECT @v_dSql += '  INSERT INTO HIS_WEEKLY_DEMAND_PRODUCT_H (            ' + char(10)
                                 SELECT @v_dSql += '       COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, SHOP_GROUP_ID, SCP_PLAN_ID, SCP_TARGET_ID, MARKET	 ' + char(10)
                                 SELECT @v_dSql += '       ,ITEM_ID, MFG_WEEK, MFG_QTY, CHG_QTY, PRODUCTION_TYPE, SAMPLE_FROM_DATE, SAMPLE_TO_DATE, LINE_ID  ' + char(10)
                                 SELECT @v_dSql += '       ,PRIORITY, PERIOD_TYPE, CONFIRM_TYPE, DEMAND_TYPE, INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME ' + char(10)
                                 SELECT @v_dSql += '       ,JOB_USER_ID, JOB_TIME, JOB_TYPE   ' + char(10)
                                 SELECT @v_dSql += '  )                                       ' + char(10)
                                 SELECT @v_dSql += '  SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, SHOP_GROUP_ID, SCP_PLAN_ID, SCP_TARGET_ID, MARKET	' + char(10)
                                 SELECT @v_dSql += '     ,ITEM_ID, MFG_WEEK, MFG_QTY, CHG_QTY, PRODUCTION_TYPE, SAMPLE_FROM_DATE, SAMPLE_TO_DATE, LINE_ID 	' + char(10)
                                 SELECT @v_dSql += '     ,PRIORITY, PERIOD_TYPE, CONFIRM_TYPE, DEMAND_TYPE, INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME	' + char(10)
                                 SELECT @v_dSql += '     ,'''+ @v_user_id +''', GETDATE() , ''UPDATE''   ' + char(10)
                                 SELECT @v_dSql += '  FROM   FP_WEEKLY_DEMAND_PRODUCT_H A                ' + char(10)
                                 SELECT @v_dSql += '  WHERE  COMPANY_ID   = '''+ @v_company_id +'''      ' + char(10)
                                 SELECT @v_dSql += '  AND  DIVISION_ID    = '''+ @v_division_id +'''     ' + char(10)
                                 SELECT @v_dSql += '  AND  SITE_ID        = '''+ @v_site_id +'''         ' + char(10)
                                 SELECT @v_dSql += '  AND  PLANT_ID       = '''+ @v_plant_id +'''        ' + char(10)
                                 SELECT @v_dSql += '  AND  SHOP_GROUP_ID  = '''+ @v_shop_group_id +'''	 ' + char(10)
                                 SELECT @v_dSql += '  AND  SCP_PLAN_ID    = '''+ @v_scp_plan_id +'''     ' + char(10)
                                 SELECT @v_dSql += '  AND  SCP_TARGET_ID  = '''+ @v_scp_target_id +'''	 ' + char(10)
                                 SELECT @v_dSql += '  AND  MARKET         = '''+ @v_market +'''          ' + char(10)

                            END

					IF @v_sys_type = 'SQL'
						BEGIN
						select @v_dSql = substring(@v_dSql, 1, 1000)
							--EXEC PR_UI_SQL_LOG @v_proc_name,  @v_user_id,'','', @v_dSql, 'select', @runstart, @runend
							SELECT @v_dSql as [QUERY_VALUE]
						END
					ELSE
						BEGIN
							SET @runstart = GetDate()
							--쿼리실행
							EXEC sp_executesql @v_dSql

							SET @runend = GetDate()
							EXEC PR_UI_SQL_LOG  @v_proc_name,  @v_user_id,@v_sys_flag,'', @v_dSql,'SELECT',@runstart, @runend
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
        
			SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE() 
		
		END CATCH    

END --MAIN END

