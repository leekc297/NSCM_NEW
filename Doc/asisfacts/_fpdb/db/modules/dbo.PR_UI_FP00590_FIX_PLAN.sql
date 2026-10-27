

/*
 * Program ID   : PR_UI_FP00590_FIX_PLAN
 * Description  : RePlan Poup
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/09/17   JYJ				Initial Release UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FP00590_FIX_PLAN]
  @p_sys_type             NVARCHAR(MAX),
  @p_sys_flag             NVARCHAR(MAX),
  @p_sys_gubun            NVARCHAR(MAX),
  @p_user_id              NVARCHAR(MAX),
  @p_site_id              NVARCHAR(MAX),
  @p_instance_id          NVARCHAR(MAX),
  @p_plan_date            NVARCHAR(MAX),
  @p_plan_id              NVARCHAR(MAX),
  @p_plan_type            NVARCHAR(MAX),
  @p_plan_horizon         NVARCHAR(MAX),
  @p_demand_horizon       NVARCHAR(MAX),
  @p_basis_plan_id        NVARCHAR(MAX),
  @p_pre_fix_flag         NVARCHAR(MAX),
  @p_pre_fix_target_id    NVARCHAR(MAX),
  @p_sync_operation       NVARCHAR(MAX),
  @p_description          NVARCHAR(MAX),
  @p_pre_fix_type         NVARCHAR(MAX),
  @p_pre_fix_date         NVARCHAR(MAX),
  @p_pre_fix_2_flag       NVARCHAR(MAX),
  @p_amend_fix_date       NVARCHAR(MAX),
  @p_pre_fix_type2        NVARCHAR(MAX),
  @p_wow_id			      NVARCHAR(MAX)

AS 
BEGIN  --MAIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
    SET NOCOUNT ON                                                                                                                                                                                                                                                   
	SET XACT_ABORT ON 

	DECLARE @v_sys_type             NVARCHAR(MAX)  -- 값>> SELEC: SQL저장안함, SQL:SQL저장함
	DECLARE @v_sys_flag             NVARCHAR(MAX)  -- 값>> I: Insert, M: Update, D: Delete, G: MERGE
	DECLARE @v_sys_gubun            NVARCHAR(MAX) 
	DECLARE @v_user_id              NVARCHAR(MAX)
    DECLARE @v_site_id              NVARCHAR(MAX)
	DECLARE @v_instance_id          NVARCHAR(MAX)
    DECLARE @v_plan_date            NVARCHAR(MAX)
    DECLARE @v_plan_id              NVARCHAR(MAX)
    DECLARE @v_plan_type            NVARCHAR(MAX)
    DECLARE @v_plan_horizon         NVARCHAR(MAX)
    DECLARE @v_demand_horizon		NVARCHAR(MAX)
    DECLARE @v_basis_plan_id		NVARCHAR(MAX)
    DECLARE @v_pre_fix_flag         NVARCHAR(MAX)
    DECLARE @v_pre_fix_target_id	NVARCHAR(MAX)
    DECLARE @v_sync_operation		NVARCHAR(MAX)
    DECLARE @v_description          NVARCHAR(MAX)
    DECLARE @v_pre_fix_type         NVARCHAR(MAX)
    DECLARE @v_pre_fix_date         NVARCHAR(MAX)
    DECLARE @v_pre_fix_2_flag       NVARCHAR(MAX)
    DECLARE @v_amend_fix_date        NVARCHAR(MAX)
    DECLARE @v_pre_fix_type2        NVARCHAR(MAX)
	DECLARE @v_wow_id				NVARCHAR(MAX)

	DECLARE @recv_active_flag       NVARCHAR(MAX)				    
	DECLARE @v_proc_name	        NVARCHAR(100) = 'PR_UI_FP00590_FIX_PLAN'
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

	SET @v_sys_type          = ''
	SET @v_sys_flag          = ''
	SET @v_sys_gubun         = ''
	SET @v_user_id           = ''
    SET @v_site_id           = '' 
	SET @v_instance_id       = '' 
    SET @v_plan_date         = '' 
    SET @v_plan_id           = ''
    SET @v_plan_type         = ''
    SET @v_plan_horizon      = ''
	SET @v_demand_horizon    = ''
	SET @v_basis_plan_id     = ''
    SET @v_pre_fix_flag      = ''
	SET @v_pre_fix_target_id = ''
    SET @v_sync_operation    = ''
	SET @v_description       = ''
    SET @v_pre_fix_type      = ''
	SET @v_pre_fix_date      = ''
    SET @v_pre_fix_2_flag    = ''
	SET @v_amend_fix_date     = ''
    SET @v_pre_fix_type2     = ''
	SET @v_wow_id		     = ''

	SET @recv_active_flag       = NULL	
	SET @recv_active_flag       = @p_sys_flag
	SET @v_delimiter            = '|'             -- 데이터 구분자
	SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_sys_flag, @v_delimiter) -- 프로시저 LOOP 길이를 판단  

	SET	@v_dSql                 = ''
	SET	@v_dSql1                = ''
	SET	@v_dSql2                = ''
	SET	@v_dSql3                = ''

		
	/************************************************************************************************/
	/* SELECT인경우 :SELECT_CONTROL(SELECT)                                                                      */
	/************************************************************************************************/
	IF(@p_sys_flag ='SELECT_CONTROL')
		BEGIN --IF(START)
		    SELECT @v_dSql1 = ''
            SELECT @v_dSql1 = '   WITH MAIN AS (  ' + char(10)
            SELECT @v_dSql1 += '       SELECT A.SITE_ID, A.INSTANCE_ID, A.WOW_ID, A.WOW_NAME, A.ROLE_ID, A.ROLE_NAME, A.PLAN_SEQ  ' + char(10)
            SELECT @v_dSql1 += '             ,B.ACTION_01_TYPE, B.ACTION_01_VALUE, B.ACTION_01_NAME        ' + char(10)
            SELECT @v_dSql1 += '             ,B.ACTION_02_TYPE, B.ACTION_02_VALUE, B.ACTION_02_NAME        ' + char(10)
            SELECT @v_dSql1 += '             ,B.ACTION_03_TYPE, B.ACTION_03_VALUE, B.ACTION_03_NAME        ' + char(10)
            SELECT @v_dSql1 += '             ,B.ACTION_04_TYPE, B.ACTION_04_VALUE, B.ACTION_04_NAME        ' + char(10)
            SELECT @v_dSql1 += '             ,B.ACTION_05_TYPE, B.ACTION_05_VALUE, B.ACTION_05_NAME        ' + char(10)
            SELECT @v_dSql1 += '             ,B.ACTION_06_TYPE, B.ACTION_06_VALUE, B.ACTION_06_NAME        ' + char(10)
            SELECT @v_dSql1 += '       FROM   FP_WOW_PROCESS A WITH(NOLOCK), FP_WOW_ACTION B WITH(NOLOCK)  ' + char(10)
            SELECT @v_dSql1 += '       WHERE  A.SITE_ID      = B.SITE_ID      ' + char(10)
            SELECT @v_dSql1 += '       AND    A.INSTANCE_ID  = B.INSTANCE_ID  ' + char(10)
            SELECT @v_dSql1 += '       AND    A.WOW_ID       = B.WOW_ID       ' + char(10)
            SELECT @v_dSql1 += '       AND    A.SITE_ID      = ''-''          ' + char(10)
            SELECT @v_dSql1 += '       AND    A.INSTANCE_ID  = ''-''          ' + char(10)
            SELECT @v_dSql1 += '   )           ' + char(10)
            SELECT @v_dSql1 += '  , LOG AS (   ' + char(10)
            SELECT @v_dSql1 += ' 		SELECT A.SITE_ID, A.INSTANCE_ID, A.WOW_ID,A.PLAN_DATE,A.PLAN_ID,A.CONFIRM_ID,A.CONFIRM_DATE,A.DESCRIPTION         ' + char(10)
            SELECT @v_dSql1 += ' 		FROM (        ' + char(10)
            SELECT @v_dSql1 += ' 	           SELECT A.SITE_ID, A.INSTANCE_ID, A.WOW_ID,A.PLAN_DATE,A.PLAN_ID,A.CONFIRM_ID,A.CONFIRM_DATE,A.DESCRIPTION  ' + char(10)
            SELECT @v_dSql1 += ' 	                 ,ROW_NUMBER() OVER(PARTITION BY A.INSTANCE_ID, A.WOW_ID ORDER BY A.PLAN_DATE DESC, A.CONFIRM_DATE DESC) AS RNUM  ' + char(10)
            SELECT @v_dSql1 += ' 	           FROM (  ' + char(10)
            SELECT @v_dSql1 += ' 		              SELECT A.SITE_ID, A.INSTANCE_ID, A.WOW_ID, CONVERT(VARCHAR(10), A.PLAN_DATE, 120) AS PLAN_DATE, ISNULL(A.PLAN_ID,''-'') AS PLAN_ID  ' + char(10)
            SELECT @v_dSql1 += ' 		                    ,A.CONFIRM_ID, CONVERT(VARCHAR(19), A.CONFIRM_DATE, 20) AS CONFIRM_DATE, DESCRIPTION  ' + char(10)
            SELECT @v_dSql1 += ' 		              FROM   FP_WOW_HIST A WITH(NOLOCK)                ' + char(10)
            SELECT @v_dSql1 += ' 		              WHERE  A.INSTANCE_ID = '''+ @p_instance_id +'''  ' + char(10)
            SELECT @v_dSql1 += ' 		              AND    CONVERT(VARCHAR(8), A.PLAN_DATE, 112) = '''+ @p_plan_date +'''  ' + char(10)
            SELECT @v_dSql1 += ' 		              AND    EXISTS (   ' + char(10)
			SELECT @v_dSql1 += ' 		                              SELECT WOW_ID  FROM   FP_WOW_PROCESS WW WITH(NOLOCK)   ' + char(10)
            SELECT @v_dSql1 += ' 		                              WHERE  A.WOW_ID = WW.WOW_ID            ' + char(10)
            SELECT @v_dSql1 += ' 		                              AND    WW.ROLE_ID = ''ALL''            ' + char(10)
            SELECT @v_dSql1 += ' 		                             )  ' + char(10)
            SELECT @v_dSql1 += ' 		              UNION ALL         ' + char(10)
            SELECT @v_dSql1 += ' 		              SELECT A.SITE_ID, A.INSTANCE_ID, A.WOW_ID, CONVERT(VARCHAR(10), A.PLAN_DATE, 120) AS PLAN_DATE, ISNULL(A.PLAN_ID,''-'') AS PLAN_ID  ' + char(10)
            SELECT @v_dSql1 += ' 		                    ,A.CONFIRM_ID, CONVERT(VARCHAR(16), A.CONFIRM_DATE, 20) AS CONFIRM_DATE, DESCRIPTION  ' + char(10)
            SELECT @v_dSql1 += ' 		              FROM   FP_WOW_HIST A WITH(NOLOCK)                 ' + char(10)
            SELECT @v_dSql1 += ' 		              WHERE  A.INSTANCE_ID = '''+ @p_instance_id +'''   ' + char(10)
            SELECT @v_dSql1 += ' 		              AND    DATEDIFF(MONTH,A.PLAN_DATE,GETDATE()) < 3  ' + char(10)
            SELECT @v_dSql1 += ' 		              AND    CONVERT(VARCHAR(8), A.PLAN_DATE, 112) < '''+ @p_plan_date +'''  ' + char(10)
            SELECT @v_dSql1 += ' 		              AND    EXISTS (                 ' + char(10)
            SELECT @v_dSql1 += ' 		                               SELECT WOW_ID  FROM   FP_WOW_PROCESS WW WITH(NOLOCK)  ' + char(10)
            SELECT @v_dSql1 += ' 		                               WHERE  A.WOW_ID = WW.WOW_ID  ' + char(10)
            SELECT @v_dSql1 += ' 		                               AND    WW.ROLE_ID = ''ALL''  ' + char(10)
            SELECT @v_dSql1 += ' 		                             )   ' + char(10)
            SELECT @v_dSql1 += ' 	                ) A  ' + char(10)
            SELECT @v_dSql1 += ' 		    ) A          ' + char(10)
            SELECT @v_dSql1 += ' 	 WHERE RNUM=1        ' + char(10)
            SELECT @v_dSql2  = ''
			SELECT @v_dSql2  = '     UNION ALL  ' + char(10)
            SELECT @v_dSql2 += '     SELECT A.SITE_ID, A.INSTANCE_ID, A.WOW_ID, A.PLAN_DATE       ' + char(10)
            SELECT @v_dSql2 += '        , A.PLAN_ID, A.CONFIRM_ID, A.CONFIRM_DATE, A.DESCRIPTION  ' + char(10)
            SELECT @v_dSql2 += '     FROM (     ' + char(10)
            SELECT @v_dSql2 += '            SELECT A.SITE_ID, A.INSTANCE_ID, A.WOW_ID, CONVERT(VARCHAR(10), A.PLAN_DATE, 120) AS PLAN_DATE, A.PLAN_ID  ' + char(10)
            SELECT @v_dSql2 += '                  ,A.CONFIRM_ID, CONVERT(VARCHAR(19), A.CONFIRM_DATE, 20) AS CONFIRM_DATE  ' + char(10)
            SELECT @v_dSql2 += '                  ,(ROW_NUMBER() OVER(PARTITION BY A.WOW_ID ORDER BY A.WOW_ID, A.CONFIRM_DATE DESC)) AS RANK  ' + char(10)
            SELECT @v_dSql2 += '                  ,A.DESCRIPTION                ' + char(10)
            SELECT @v_dSql2 += '            FROM   FP_WOW_HIST A WITH(NOLOCK)   ' + char(10)
            SELECT @v_dSql2 += '            WHERE  A.INSTANCE_ID = '''+ @p_instance_id +'''  ' + char(10)
            SELECT @v_dSql2 += '            AND    CONVERT(VARCHAR(8), A.PLAN_DATE, 112) = '''+ @p_plan_date +'''  ' + char(10)
            SELECT @v_dSql2 += '            AND    EXISTS (  ' + char(10)
            SELECT @v_dSql2 += '                            SELECT WOW_ID  FROM   FP_WOW_PROCESS WW WITH(NOLOCK)  ' + char(10)
            SELECT @v_dSql2 += '                            WHERE  A.WOW_ID = WW.WOW_ID      ' + char(10)
            SELECT @v_dSql2 += '                            AND    WW.ROLE_ID = ''PRIVATE''  ' + char(10)
            SELECT @v_dSql2 += '                          )  ' + char(10)
            SELECT @v_dSql2 += '          ) A                ' + char(10)
            SELECT @v_dSql2 += '      WHERE A.RANK = 1       ' + char(10)
            SELECT @v_dSql2 += '  )                          ' + char(10)
            SELECT @v_dSql2 += '  , SCP_PLAN_INFO AS (       ' + char(10)
            SELECT @v_dSql2 += '        SELECT TOP 1 SCP_PLAN_ID, CONVERT(VARCHAR(20), INSERT_TIME, 120) INSERT_TIME   ' + char(10)
            SELECT @v_dSql2 += '        FROM   FP_WEEKLY_DEMAND_PRODUCT_H A WITH(NOLOCK), ' + char(10)
            SELECT @v_dSql2 += '  	         ( SELECT DISTINCT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, CASE WHEN INSTANCE_ID LIKE ''%FORM%'' THEN ''A'' ELSE A.SHOP_GROUP_ID END SHOP_GROUP_ID ' + char(10)
            SELECT @v_dSql2 += '          	   FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK), SCM_FACTORY_M B WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql2 += '          	   WHERE  A.FACTORY_ID  = B.FACTORY_ID    ' + char(10)
            SELECT @v_dSql2 += '          	   AND    A.ACTIVE_FLAG = ''Y''           ' + char(10)
            SELECT @v_dSql2 += '          	   AND    B.ACTIVE_FLAG = ''Y''           ' + char(10)
            SELECT @v_dSql2 += '          	   AND    A.INSTANCE_ID = '''+ @p_instance_id +''' ) B ' + char(10)
            SELECT @v_dSql2 += '        WHERE  A.COMPANY_ID  = B.COMPANY_ID    ' + char(10)
            SELECT @v_dSql2 += '  	    AND  A.DIVISION_ID   = B.DIVISION_ID   ' + char(10)
            SELECT @v_dSql2 += '  	    AND  A.SITE_ID       = B.SITE_ID       ' + char(10)
            SELECT @v_dSql2 += '  	    AND  A.PLANT_ID      = B.PLANT_ID      ' + char(10)
            SELECT @v_dSql2 += '  	    AND  A.SHOP_GROUP_ID = B.SHOP_GROUP_ID ' + char(10)
            SELECT @v_dSql2 += '  	    ORDER BY SCP_PLAN_ID DESC, INSERT_TIME ' + char(10)
            SELECT @v_dSql2 += '  )      ' + char(10)
            SELECT @v_dSql2 += '  , SHIPMENT_PLAN_INFO AS (                   ' + char(10)
            SELECT @v_dSql2 += '        SELECT TOP 1 SCP_PLAN_ID, CONVERT(VARCHAR(20), INSERT_TIME, 120) INSERT_TIME  ' + char(10)
            SELECT @v_dSql2 += '        FROM   FP_WEEKLY_DEMAND_SHIPMENT_H A WITH(NOLOCK), ' + char(10)
            SELECT @v_dSql2 += '             ( SELECT DISTINCT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, CASE WHEN INSTANCE_ID LIKE ''%FORM%'' THEN ''A'' ELSE A.SHOP_GROUP_ID END SHOP_GROUP_ID ' + char(10)
            SELECT @v_dSql2 += '         		FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK), SCM_FACTORY_M B WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql2 += '        		WHERE  A.FACTORY_ID  = B.FACTORY_ID    ' + char(10)
            SELECT @v_dSql2 += '         		AND    A.ACTIVE_FLAG = ''Y''           ' + char(10)
            SELECT @v_dSql2 += '        		AND    B.ACTIVE_FLAG = ''Y''           ' + char(10)
            SELECT @v_dSql2 += '        		AND    A.INSTANCE_ID = '''+ @p_instance_id +''' ) B ' + char(10)
            SELECT @v_dSql2 += '        WHERE  A.COMPANY_ID    = B.COMPANY_ID    ' + char(10)
            SELECT @v_dSql2 += '        AND    A.DIVISION_ID   = B.DIVISION_ID   ' + char(10)
            SELECT @v_dSql2 += '        AND    A.SITE_ID       = B.SITE_ID       ' + char(10)
            SELECT @v_dSql2 += '        AND    A.PLANT_ID      = B.PLANT_ID      ' + char(10)
            SELECT @v_dSql2 += '        AND    A.SHOP_GROUP_ID = B.SHOP_GROUP_ID ' + char(10)
            SELECT @v_dSql2 += '        ORDER BY SCP_PLAN_ID DESC, INSERT_TIME   ' + char(10)
            SELECT @v_dSql2 += '  )      ' + char(10)
            SELECT @v_dSql3  = ''
			SELECT @v_dSql3  = '   , TARGETINFO AS (   ' + char(10)
            SELECT @v_dSql3 += '     			SELECT  PRODUCT.SCP_PLAN_ID AS P_SCP_PLAN_ID, SHIPMENT.SCP_PLAN_ID AS S_SCP_PLAN_ID, TARGET.TARGET     ' + char(10)
            SELECT @v_dSql3 += '                   	, CASE WHEN TARGET.TARGET IN (''PRODUCT'',''SHIPMENT'') AND TARGET.TARGET NOT IN (''PRODUCT'') THEN (''SCP Shipment Target   : '' + SHIPMENT.SCP_PLAN_ID) ' + char(10)
            SELECT @v_dSql3 += '                       	   WHEN TARGET.TARGET IN (''PRODUCT'',''SHIPMENT'') AND TARGET.TARGET NOT IN (''SHIPMENT'') THEN (''SCP Product Target : '' + PRODUCT.SCP_PLAN_ID)    ' + char(10)
            SELECT @v_dSql3 += '                           WHEN TARGET.TARGET IN (''PRODUCT'',''SHIPMENT'') THEN (''SCP Product Target : '' + PRODUCT.SCP_PLAN_ID + CHAR(13) + CHAR(10) + ''SCP Shipment Target   : '' + SHIPMENT.SCP_PLAN_ID) ' + char(10)
            SELECT @v_dSql3 += '                           ELSE ''-'' END AS MSG         ' + char(10)
            SELECT @v_dSql3 += '           			, CASE WHEN TARGET.TARGET IN (''PRODUCT'',''SHIPMENT'') AND TARGET.TARGET NOT IN (''PRODUCT'') THEN (''Target I/F : '' + SHIPMENT.INSERT_TIME) ' + char(10)
            SELECT @v_dSql3 += '           				   WHEN TARGET.TARGET IN (''PRODUCT'',''SHIPMENT'') AND TARGET.TARGET NOT IN (''SHIPMENT'') THEN (''Target I/F : '' + PRODUCT.INSERT_TIME) ' + char(10)
            SELECT @v_dSql3 += '           				   WHEN TARGET.TARGET IN (''PRODUCT'',''SHIPMENT'') THEN (''SCP Product Target : '' + PRODUCT.INSERT_TIME + CHAR(13) + CHAR(10) + ''SCP Shipment Target   : '' + SHIPMENT.INSERT_TIME) ' + char(10)
            SELECT @v_dSql3 += '           				   ELSE ''-'' END AS IF_TIME_MSG ' + char(10)
            SELECT @v_dSql3 += '          	     FROM SCP_PLAN_INFO      PRODUCT,        ' + char(10)
            SELECT @v_dSql3 += '                      SHIPMENT_PLAN_INFO SHIPMENT        ' + char(10)
            SELECT @v_dSql3 += '                LEFT OUTER JOIN (                        ' + char(10)
            SELECT @v_dSql3 += '                                  SELECT DISTINCT KEY_VALUE AS TARGET            ' + char(10)
            SELECT @v_dSql3 += '                                  FROM   FP_INSTANCE_CONFIG_M KK WITH(NOLOCK)    ' + char(10)
            SELECT @v_dSql3 += '                                  WHERE  1=1                                     ' + char(10)
            SELECT @v_dSql3 += '                                  AND    CATEGORY_ID = ''DEMAND_TARGET''         ' + char(10)
            SELECT @v_dSql3 += '                                  AND    INSTANCE_ID = '''+ @p_instance_id +'''  ' + char(10)
            SELECT @v_dSql3 += '                                  AND    KEY_VALUE IN (''PRODUCT'',''SHIPMENT'') ' + char(10)
            SELECT @v_dSql3 += '                                  AND    USE_YN = ''Y''                          ' + char(10)
            SELECT @v_dSql3 += '                               	) TARGET ' + char(10)
            SELECT @v_dSql3 += '                ON 1=1                   ' + char(10)
            SELECT @v_dSql3 += '   )                                     ' + char(10)
            SELECT @v_dSql3 += '   SELECT '''+ @p_site_id +''' AS SITE_ID, '''+ @p_instance_id +''' AS INSTANCE_ID           ' + char(10)
            SELECT @v_dSql3 += '      , A.WOW_ID As WOW_ID, A.WOW_NAME As WOW_NAME, A.ROLE_ID As ROLE_ID         ' + char(10)
			SELECT @v_dSql3 += '      , A.ROLE_NAME As ROLE_NAME, A.PLAN_SEQ As PLAN_SEQ                         ' + char(10)
            SELECT @v_dSql3 += '      , A.ACTION_01_TYPE As ACTION_01_TYPE, A.ACTION_01_VALUE As ACTION_01_VALUE ' + char(10)
			SELECT @v_dSql3 += '      , A.ACTION_01_NAME As ACTION_01_NAME, A.ACTION_02_TYPE As ACTION_02_TYPE   ' + char(10)
            SELECT @v_dSql3 += '      , A.ACTION_02_VALUE As ACTION_02_VALUE                                     ' + char(10)
			SELECT @v_dSql3 += '      , ( CASE WHEN A.WOW_ID=''W004'' THEN ISNULL(E.PLAN_ID, E.PLAN_ID) ELSE A.ACTION_02_NAME END) AS ACTION_02_NAME  ' + char(10)
            SELECT @v_dSql3 += '      , A.ACTION_03_TYPE As ACTION_03_TYPE, A.ACTION_03_VALUE As ACTION_03_VALUE    ' + char(10)
            SELECT @v_dSql3 += '      , A.ACTION_03_NAME As ACTION_03_NAME, A.ACTION_04_TYPE As ACTION_04_TYPE      ' + char(10)
			SELECT @v_dSql3 += '      , A.ACTION_04_VALUE As ACTION_04_VALUE, A.ACTION_04_NAME As ACTION_04_NAME    ' + char(10)
            SELECT @v_dSql3 += '      , A.ACTION_05_TYPE As ACTION_05_TYPE, A.ACTION_05_VALUE  As ACTION_05_VALUE   ' + char(10)
            SELECT @v_dSql3 += '      , A.ACTION_05_NAME As ACTION_05_NAME, A.ACTION_06_TYPE As ACTION_06_TYPE      ' + char(10)
			SELECT @v_dSql3 += '      , A.ACTION_06_VALUE As ACTION_06_VALUE, A.ACTION_06_NAME As ACTION_06_NAME    ' + char(10)
            SELECT @v_dSql3 += '      , CASE WHEN B.CONFIRM_ID IS NULL OR B.CONFIRM_ID = '''' THEN '''' ELSE ''Complete'' END AS STATUS ' + char(10)
			SELECT @v_dSql3 += '      , '''' AS INSERT_ID                          ' + char(10)
            SELECT @v_dSql3 += '      , CASE WHEN A.WOW_ID = ''W001'' THEN C.MSG   ' + char(10)
            SELECT @v_dSql3 += '             WHEN A.WOW_ID = ''W002'' THEN D._MSG  ' + char(10)
            SELECT @v_dSql3 += '             ELSE B.DESCRIPTION END AS DESCRIPTION ' + char(10)            
			SELECT @v_dSql3 += '      , '''+ @p_plan_date +''' AS PLAN_DATE        ' + char(10)
            SELECT @v_dSql3 += '      , CASE WHEN A.ROLE_ID = ''ALL'' THEN ''-'' ELSE B.PLAN_ID END AS PLAN_ID      ' + char(10)
            SELECT @v_dSql3 += '      ,  B.CONFIRM_ID AS CONFIRM_ID                                                 ' + char(10)
			SELECT @v_dSql3 += '      , (CASE WHEN A.WOW_ID = ''W001'' THEN C.IF_TIME_MSG ELSE B.CONFIRM_DATE END) CONFIRM_DATE ' + char(10)
            SELECT @v_dSql3 += '   FROM   MAIN A LEFT OUTER     ' + char(10)
            SELECT @v_dSql3 += '   JOIN LOG B                   ' + char(10)
            SELECT @v_dSql3 += '      ON   A.WOW_ID = B.WOW_ID  ' + char(10)
            SELECT @v_dSql3 += '   LEFT JOIN TARGETINFO C       ' + char(10)
            SELECT @v_dSql3 += '      ON    1=1                 ' + char(10)
            SELECT @v_dSql3 += '   LEFT JOIN (                  ' + char(10)
            SELECT @v_dSql3 += '              SELECT ''Validation Count : '' + CONVERT(VARCHAR,COUNT(*)) AS _MSG ' + char(10)
            SELECT @v_dSql3 += '              FROM   FP_MASTER_VALIDATION_H A WITH(NOLOCK)                       ' + char(10)
            SELECT @v_dSql3 += '              WHERE CONVERT(VARCHAR(10), CONVERT(DATETIME, A.PLAN_DATE), 112) = '''+ @p_plan_date +''' ' + char(10)
            SELECT @v_dSql3 += '              AND    A.INSTANCE_ID = '''+ @p_instance_id +'''   ' + char(10)
            SELECT @v_dSql3 += '   ) D           ' + char(10)
            SELECT @v_dSql3 += '      ON     1=1 ' + char(10)
            SELECT @v_dSql3 += '   LEFT JOIN (   ' + char(10)
            SELECT @v_dSql3 += '               SELECT MAX(PLAN_ID) AS PLAN_ID                   ' + char(10)
            SELECT @v_dSql3 += '               FROM   SCM_FP_PLAN_H A WITH(NOLOCK)              ' + char(10)
            SELECT @v_dSql3 += '               WHERE  A.INSTANCE_ID = '''+ @p_instance_id +'''  ' + char(10)
            SELECT @v_dSql3 += '               AND    CONVERT(VARCHAR(8), A.PLAN_START_TIME, 112) = '''+ @p_plan_date +''' ' + char(10)
            SELECT @v_dSql3 += '               AND    PLAN_TYPE <> ''RELEASE''     ' + char(10)
            SELECT @v_dSql3 += '               AND    RIGHT(A.PLAN_ID,2) <> ''00'' ' + char(10)
            SELECT @v_dSql3 += '   ) E                ' + char(10)
            SELECT @v_dSql3 += '      ON     1=1      ' + char(10)
            SELECT @v_dSql3 += '  ORDER BY A.PLAN_SEQ ' + char(10)

			SELECT @v_dSql = @v_dSql1 + @v_dSql2 + @v_dSql3

			IF @p_sys_type = 'SQL'
				BEGIN
					--EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,@p_sys_flag,'',@v_dSql,'select',@runstart, @runend
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
    /************************************************************************************************/
	/* SELECT_ENGINE_RUN경우 :(SELECT_ENGINE_RUN Select)                                            */
	/************************************************************************************************/
    ELSE IF(@p_sys_flag ='SELECT_ENGINE_RUN')
	    BEGIN --ELSE IF(START)
		    SELECT @v_dSql = ''
			SELECT @v_dSql += '   SELECT ''INBOUND'' AS ENGINE_STATUS, ''Input Data Create'' AS STATUS_NAME, ' + char(10)
			SELECT @v_dSql += '       A.INBOUND_FLAG AS STATUS_FLAG, A.INBOUND_STEP AS STATUS_STEP ,      ' + char(10)
			SELECT @v_dSql += '       FORMAT(A.INBOUND_START ,''yyyy-MM-dd HH:mm:ss'') AS STATUS_START ,  ' + char(10)
			SELECT @v_dSql += '       FORMAT(A.INBOUND_END   ,''yyyy-MM-dd HH:mm:ss'') AS STATUS_END ,    ' + char(10)
			SELECT @v_dSql += '       CASE WHEN A.INBOUND_FLAG=''R'' THEN ''Ready''  ' + char(10)
			SELECT @v_dSql += '          WHEN A.INBOUND_FLAG = ''P'' THEN ''Processing''+CASE WHEN A.INBOUND_START IS NOT NULL THEN '' (''+CONVERT(VARCHAR,DATEDIFF(SECOND,A.INBOUND_START,GETDATE())/60) + '':'' + CONVERT(VARCHAR,DATEDIFF(SECOND,A.INBOUND_START,GETDATE())-(DATEDIFF(SECOND,A.INBOUND_START,GETDATE())/60)*60) + '')'' END  ' + char(10)
			SELECT @v_dSql += '          WHEN A.INBOUND_FLAG = ''C'' THEN ''Completed'' +CASE WHEN A.INBOUND_END   IS NOT NULL THEN '' (''+CONVERT(VARCHAR, A.INBOUND_START, 20) + ''  /  ''  + CONVERT(VARCHAR,DATEDIFF(SECOND,A.INBOUND_START,A.INBOUND_END)/60) + '':'' + CONVERT(VARCHAR,DATEDIFF(SECOND,A.INBOUND_START,A.INBOUND_END)-(DATEDIFF(SECOND,A.INBOUND_START,A.INBOUND_END)/60)*60) + '')'' END  ' + char(10)
			SELECT @v_dSql += '          WHEN A.INBOUND_FLAG = ''E'' THEN ''Error''  ' + char(10)
			SELECT @v_dSql += '       ELSE NULL END AS STATUS_MSG                    ' + char(10)
			SELECT @v_dSql += '   FROM   FP_PLAN_STATUS_H A(NOLOCK)                  ' + char(10)
			SELECT @v_dSql += '   WHERE  A.INSTANCE_ID = '''+ @p_instance_id +'''    ' + char(10)
			SELECT @v_dSql += '   AND    A.PLAN_ID     = '''+ @p_plan_id +'''        ' + char(10)
			SELECT @v_dSql += '   UNION ALL                                          ' + char(10)
			SELECT @v_dSql += '   SELECT ''ENGINE'' AS ENGINE_STATUS, ''Engine Running'' AS STATUS_NAME,   ' + char(10)
			SELECT @v_dSql += '        A.ENGINE_FLAG AS STATUS_FLAG, A.ENGINE_STEP AS STATUS_STEP ,        ' + char(10)
			SELECT @v_dSql += '        FORMAT(A.ENGINE_START  ,''yyyy-MM-dd HH:mm:ss'') AS STATUS_START ,  ' + char(10)
			SELECT @v_dSql += '        FORMAT(A.ENGINE_END    ,''yyyy-MM-dd HH:mm:ss'') AS STATUS_END ,    ' + char(10)
			SELECT @v_dSql += '        CASE WHEN A.ENGINE_FLAG = ''S'' THEN ''Stop''   ' + char(10)
			SELECT @v_dSql += '             WHEN A.ENGINE_FLAG = ''E'' THEN ''Error''  ' + char(10)
			SELECT @v_dSql += '        	    WHEN A.ENGINE_STEP = ''0'' THEN ''Ready''  ' + char(10)
			SELECT @v_dSql += '             WHEN A.ENGINE_STEP = ''1'' THEN ''Processing'' + CASE WHEN A.ENGINE_START IS NOT NULL THEN '' ('' + CONVERT(VARCHAR,DATEDIFF(SECOND,A.ENGINE_START,GETDATE())/60) + '':'' + CONVERT(VARCHAR,DATEDIFF(SECOND,A.ENGINE_START,GETDATE())-(DATEDIFF(SECOND,A.ENGINE_START,GETDATE())/60)*60) + '')'' END ' + char(10)
			SELECT @v_dSql += '             WHEN A.ENGINE_STEP = ''2'' THEN ''Processing'' + CASE WHEN A.ENGINE_START IS NOT NULL THEN '' ('' + CONVERT(VARCHAR,DATEDIFF(SECOND,A.ENGINE_START,GETDATE())/60) + '':'' + CONVERT(VARCHAR,DATEDIFF(SECOND,A.ENGINE_START,GETDATE())-(DATEDIFF(SECOND,A.ENGINE_START,GETDATE())/60)*60) + '')'' END ' + char(10)
			SELECT @v_dSql += '             WHEN A.ENGINE_STEP = ''3'' THEN ''Processing'' + CASE WHEN A.ENGINE_START IS NOT NULL THEN '' ('' + CONVERT(VARCHAR,DATEDIFF(SECOND,A.ENGINE_START,GETDATE())/60) + '':'' + CONVERT(VARCHAR,DATEDIFF(SECOND,A.ENGINE_START,GETDATE())-(DATEDIFF(SECOND,A.ENGINE_START,GETDATE())/60)*60) + '')'' END ' + char(10)
			SELECT @v_dSql += '             WHEN A.ENGINE_STEP = ''4'' THEN ''Completed'' +  CASE WHEN A.OUTBOUND_END IS NOT NULL THEN '' ('' + CONVERT(VARCHAR, A.ENGINE_START, 20) + ''  /  ''+CONVERT(VARCHAR,DATEDIFF(SECOND,A.ENGINE_START,A.OUTBOUND_END)/60) + '':'' + CONVERT(VARCHAR,DATEDIFF(SECOND,A.ENGINE_START,A.OUTBOUND_END)-(DATEDIFF(SECOND,A.ENGINE_START,A.OUTBOUND_END)/60)*60) + '')'' END ' + char(10)
			SELECT @v_dSql += '             ELSE NULL END AS STATUS_MSG           ' + char(10)
			SELECT @v_dSql += '  FROM   FP_PLAN_STATUS_H A(NOLOCK)                ' + char(10)
			SELECT @v_dSql += '  WHERE  A.INSTANCE_ID = '''+ @p_instance_id +'''  ' + char(10)
			SELECT @v_dSql += '  AND    A.PLAN_ID     = '''+ @p_plan_id +'''      ' + char(10)
			SELECT @v_dSql += '  UNION ALL                                        ' + char(10)
			SELECT @v_dSql += '  SELECT ''OUTBOUND'' AS ENGINE_STATUS, ''Output Data Create'' AS STATUS_NAME, ' + char(10)
			SELECT @v_dSql += '       A.DB_TRANS_FLAG AS STATUS_FLAG, A.DB_TRANS_STEP AS STATUS_STEP ,        ' + char(10)
			SELECT @v_dSql += '       FORMAT(A.DB_TRANS_START  ,''yyyy-MM-dd HH:mm:ss'') AS STATUS_START ,    ' + char(10)
			SELECT @v_dSql += '       FORMAT(A.DB_TRANS_END    ,''yyyy-MM-dd HH:mm:ss'') AS STATUS_END ,      ' + char(10)
			SELECT @v_dSql += '       CASE WHEN A.DB_TRANS_FLAG = ''S'' THEN ''Stop''                         ' + char(10)
			SELECT @v_dSql += '            WHEN A.DB_TRANS_FLAG = ''R'' THEN ''Ready''                        ' + char(10)
			SELECT @v_dSql += '            WHEN A.DB_TRANS_FLAG = ''P'' THEN ''Processing'' + CASE WHEN A.DB_TRANS_START IS NOT NULL THEN '' ('' + CONVERT(VARCHAR,DATEDIFF(SECOND,A.DB_TRANS_START,GETDATE())/60) + '':'' + CONVERT(VARCHAR,DATEDIFF(SECOND,A.DB_TRANS_START,GETDATE())-(DATEDIFF(SECOND,A.DB_TRANS_START,GETDATE())/60)*60) + '')'' END ' + char(10)
			SELECT @v_dSql += '            WHEN A.DB_TRANS_FLAG = ''C'' THEN ''Completed''  + CASE WHEN A.DB_TRANS_END   IS NOT NULL THEN '' ('' + CONVERT(VARCHAR, A.DB_TRANS_START, 20) + ''  /  ''+CONVERT(VARCHAR,DATEDIFF(SECOND,A.DB_TRANS_START,A.DB_TRANS_END)/60) + '':'' +CONVERT(VARCHAR,DATEDIFF(SECOND,A.DB_TRANS_START,A.DB_TRANS_END)-(DATEDIFF(SECOND,A.DB_TRANS_START,A.DB_TRANS_END)/60)*60) + '')'' END ' + char(10)
			SELECT @v_dSql += '            WHEN A.DB_TRANS_FLAG = ''E'' THEN ''Error'' ' + char(10)
			SELECT @v_dSql += '            ELSE NULL END AS STATUS_MSG                 ' + char(10)
			SELECT @v_dSql += '  FROM   FP_PLAN_STATUS_H A(NOLOCK)                     ' + char(10)
			SELECT @v_dSql += '  WHERE  A.INSTANCE_ID = '''+ @p_instance_id +'''       ' + char(10)
			SELECT @v_dSql += '  AND    A.PLAN_ID     = '''+ @p_plan_id +'''           ' + char(10)

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
					--EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_dSql,'select',@runstart, @runend
				END	
			END
    /************************************************************************************************/
	/* Plan Control본화면 EXECUTE_VALIDATION경우 :(EXECUTE_VALIDATION )                             */
	/************************************************************************************************/
    ELSE IF(@p_sys_flag ='EXECUTE_VALIDATION')
	    BEGIN --ELSE IF(START)
		    SELECT @v_dSql = ''
			SELECT @v_dSql = 'EXEC PR_SCM_AF_MASTER_VALIDATION'
			
			--Log 남김
			EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_dSql,'select',@runstart, @runend

			EXEC  @rtnCount = [dbo].[PR_SCM_AF_MASTER_VALIDATION]
			
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

						SELECT @v_sys_type     = [dbo].[SCM_ARR_SPL_VAL](@p_sys_type ,         @v_delimiter, @mst_loop_cnt)
						, @v_sys_flag          = [dbo].[SCM_ARR_SPL_VAL](@p_sys_flag ,         @v_delimiter, @mst_loop_cnt)
						, @v_sys_gubun         = [dbo].[SCM_ARR_SPL_VAL](@p_sys_gubun ,        @v_delimiter, @mst_loop_cnt)
						, @v_user_id           = [dbo].[SCM_ARR_SPL_VAL](@p_user_id ,          @v_delimiter, @mst_loop_cnt)
                        , @v_site_id           = [dbo].[SCM_ARR_SPL_VAL](@p_site_id ,          @v_delimiter, @mst_loop_cnt)
                        , @v_instance_id       = [dbo].[SCM_ARR_SPL_VAL](@p_instance_id ,      @v_delimiter, @mst_loop_cnt)
                        , @v_plan_date         = [dbo].[SCM_ARR_SPL_VAL](@p_plan_date ,        @v_delimiter, @mst_loop_cnt)
                        , @v_plan_id           = [dbo].[SCM_ARR_SPL_VAL](@p_plan_id ,          @v_delimiter, @mst_loop_cnt)
                        , @v_plan_type         = [dbo].[SCM_ARR_SPL_VAL](@p_plan_type ,        @v_delimiter, @mst_loop_cnt)
                        , @v_plan_horizon      = [dbo].[SCM_ARR_SPL_VAL](@p_plan_horizon ,     @v_delimiter, @mst_loop_cnt)
                        , @v_demand_horizon    = [dbo].[SCM_ARR_SPL_VAL](@p_demand_horizon ,   @v_delimiter, @mst_loop_cnt)
                        , @v_basis_plan_id     = [dbo].[SCM_ARR_SPL_VAL](@p_basis_plan_id ,    @v_delimiter, @mst_loop_cnt)
                        , @v_pre_fix_flag      = [dbo].[SCM_ARR_SPL_VAL](@p_pre_fix_flag ,     @v_delimiter, @mst_loop_cnt)
                        , @v_pre_fix_target_id = [dbo].[SCM_ARR_SPL_VAL](@p_pre_fix_target_id ,@v_delimiter, @mst_loop_cnt)
                        , @v_sync_operation    = [dbo].[SCM_ARR_SPL_VAL](@p_sync_operation ,   @v_delimiter, @mst_loop_cnt)
                        , @v_description       = [dbo].[SCM_ARR_SPL_VAL](@p_description ,      @v_delimiter, @mst_loop_cnt)
                        , @v_pre_fix_type      = [dbo].[SCM_ARR_SPL_VAL](@p_pre_fix_type ,     @v_delimiter, @mst_loop_cnt)
                        , @v_pre_fix_date      = [dbo].[SCM_ARR_SPL_VAL](@p_pre_fix_date ,     @v_delimiter, @mst_loop_cnt)
                        , @v_pre_fix_2_flag    = [dbo].[SCM_ARR_SPL_VAL](@p_pre_fix_2_flag ,   @v_delimiter, @mst_loop_cnt)
                        , @v_amend_fix_date    = [dbo].[SCM_ARR_SPL_VAL](@p_amend_fix_date ,   @v_delimiter, @mst_loop_cnt)
                        , @v_pre_fix_type2     = [dbo].[SCM_ARR_SPL_VAL](@p_pre_fix_type2 ,    @v_delimiter, @mst_loop_cnt)
                        , @v_wow_id			   = [dbo].[SCM_ARR_SPL_VAL](@p_wow_id		  ,    @v_delimiter, @mst_loop_cnt)

					   /******************************************************************************/
					   /* SAVE_FIX_PLAN 경우 : INSERT                                                  */
					   /******************************************************************************/
					   IF(@v_sys_flag ='SAVE_FIX_PLAN')  
							BEGIN
							   
                                SELECT @v_dSql = ''
                                SELECT @v_dSql += ' UPDATE SCM_FP_PLAN_H                           ' + char(10)
                                SELECT @v_dSql += '     SET AMEND_FIX_DATE = CONVERT(VARCHAR, '''+ @v_amend_fix_date +''', 112) ' + char(10)
                                SELECT @v_dSql += '        , DESCRIPTION = '''+ @v_description +''' ' + char(10)
                                SELECT @v_dSql += '        , UPDATE_ID	 = '''+ @v_user_id +'''     ' + char(10)
                                SELECT @v_dSql += '        , UPDATE_TIME = GETDATE()                ' + char(10)
                                SELECT @v_dSql += ' WHERE 1=1                                       ' + char(10)
                                SELECT @v_dSql += ' AND   INSTANCE_ID = '''+ @v_instance_id +'''    ' + char(10)
                                SELECT @v_dSql += ' AND	  PLAN_ID	  = '''+ @v_plan_id +'''        ' + char(10)
                                SELECT @v_dSql += ' AND   PLAN_TYPE   = '''+ @v_plan_type +'''      ' + char(10)
                                SELECT @v_dSql += '                             ' + char(10)
                                SELECT @v_dSql += ' INSERT INTO HIS_FP_PLAN_H ( ' + char(10)
                                SELECT @v_dSql += '      INSTANCE_ID        ' + char(10)
                                SELECT @v_dSql += '     ,PLAN_ID            ' + char(10)
                                SELECT @v_dSql += '     ,PLAN_TYPE          ' + char(10)
                                SELECT @v_dSql += '     ,SITE_ID            ' + char(10)
                                SELECT @v_dSql += '     ,PLAN_START_TIME    ' + char(10)
                                SELECT @v_dSql += '     ,PLAN_HORIZON       ' + char(10)
                                SELECT @v_dSql += '     ,PLAN_HORIZON_UOM   ' + char(10)
                                SELECT @v_dSql += '     ,DEMAND_HORIZON     ' + char(10)
                                SELECT @v_dSql += '     ,DEMAND_HORIZON_UOM ' + char(10)
                                SELECT @v_dSql += '     ,CONFIG_SET_ID      ' + char(10)
                                SELECT @v_dSql += '     ,BASIS_PLAN_ID      ' + char(10)
                                SELECT @v_dSql += '     ,DEMAND_PLAN_ID     ' + char(10)
                                SELECT @v_dSql += '     ,SCP_PLAN_ID        ' + char(10)
                                SELECT @v_dSql += '     ,PLAN_WEEK          ' + char(10)
                                SELECT @v_dSql += '     ,CONFIRM_FLAG       ' + char(10)
                                SELECT @v_dSql += '     ,SYNC_OPERATION_ID  ' + char(10)
                                SELECT @v_dSql += '     ,DESCRIPTION        ' + char(10)
                                SELECT @v_dSql += '     ,PRE_FIX_DATE       ' + char(10)
                                SELECT @v_dSql += '     ,AMEND_FIX_DATE     ' + char(10)
                                SELECT @v_dSql += '     ,INSERT_ID          ' + char(10)
                                SELECT @v_dSql += '     ,INSERT_TIME        ' + char(10)
                                SELECT @v_dSql += '     ,UPDATE_ID          ' + char(10)
                                SELECT @v_dSql += '     ,UPDATE_TIME        ' + char(10)
                                SELECT @v_dSql += '     ,JOB_USER_ID        ' + char(10)
                                SELECT @v_dSql += '     ,JOB_TIME           ' + char(10)
                                SELECT @v_dSql += '     ,JOB_TYPE           ' + char(10)
                                SELECT @v_dSql += ' )                       ' + char(10)
                                SELECT @v_dSql += ' SELECT INSTANCE_ID      ' + char(10)
                                SELECT @v_dSql += '     ,PLAN_ID            ' + char(10)
                                SELECT @v_dSql += '     ,PLAN_TYPE          ' + char(10)
                                SELECT @v_dSql += '     ,SITE_ID            ' + char(10)
                                SELECT @v_dSql += '     ,PLAN_START_TIME    ' + char(10)
                                SELECT @v_dSql += '     ,PLAN_HORIZON       ' + char(10)
                                SELECT @v_dSql += '     ,PLAN_HORIZON_UOM   ' + char(10)
                                SELECT @v_dSql += '     ,DEMAND_HORIZON     ' + char(10)
                                SELECT @v_dSql += '     ,DEMAND_HORIZON_UOM ' + char(10)
                                SELECT @v_dSql += '     ,CONFIG_SET_ID      ' + char(10)
                                SELECT @v_dSql += '     ,BASIS_PLAN_ID      ' + char(10)
                                SELECT @v_dSql += '     ,DEMAND_PLAN_ID     ' + char(10)
                                SELECT @v_dSql += '     ,SCP_PLAN_ID        ' + char(10)
                                SELECT @v_dSql += '     ,PLAN_WEEK          ' + char(10)
                                SELECT @v_dSql += '     ,CONFIRM_FLAG       ' + char(10)
                                SELECT @v_dSql += '     ,SYNC_OPERATION_ID  ' + char(10)
                                SELECT @v_dSql += '     ,DESCRIPTION        ' + char(10)
                                SELECT @v_dSql += '     ,PRE_FIX_DATE       ' + char(10)
                                SELECT @v_dSql += '     ,AMEND_FIX_DATE     ' + char(10)
                                SELECT @v_dSql += '     ,INSERT_ID          ' + char(10)
                                SELECT @v_dSql += '     ,INSERT_TIME        ' + char(10)
                                SELECT @v_dSql += '     ,UPDATE_ID          ' + char(10)
                                SELECT @v_dSql += '     ,UPDATE_TIME        ' + char(10)
                                SELECT @v_dSql += '     ,'''+ @v_user_id +''' as JOB_USER_ID ' + char(10)
                                SELECT @v_dSql += '     ,GETDATE() as JOB_TIME               ' + char(10)
                                SELECT @v_dSql += '     ,''RE-UPDATE'' as JOB_TYPE           ' + char(10)
                                SELECT @v_dSql += ' FROM   SCM_FP_PLAN_H A WITH(NOLOCK)      ' + char(10)
                                SELECT @v_dSql += ' WHERE  INSTANCE_ID = '''+ @v_instance_id +''' ' + char(10)
                                SELECT @v_dSql += ' AND    PLAN_ID     = '''+ @v_plan_id +'''     ' + char(10)
                                SELECT @v_dSql += ' AND    PLAN_TYPE   = '''+ @v_plan_type +'''   ' + char(10)


						   END --'I'
					   /****************************************************************************/
					   /* UPDATE  경우  :UPDATE_CLEAR_STATUS                                                         */
					   /****************************************************************************/
					   ELSE IF(@v_sys_flag ='UPDATE_CLEAR_STATUS')
							BEGIN
							    SELECT @v_dSql = ''
                                SELECT @v_dSql += '  DELETE FROM FP_PLAN_STATUS_H                  ' + char(10)
                                SELECT @v_dSql += '  WHERE  INSTANCE_ID = '''+ @v_instance_id +''' ' + char(10)
                                SELECT @v_dSql += '  AND    PLAN_ID     = '''+ @v_plan_id +'''     ' + char(10)
                                SELECT @v_dSql += '  ' + char(10) 
                                SELECT @v_dSql += '  INSERT INTO FP_PLAN_STATUS_H (                        ' + char(10)
                                SELECT @v_dSql += '      INSTANCE_ID,       PLAN_ID,          ACTIVE_FLAG  ' + char(10)
                                SELECT @v_dSql += '    , INBOUND_FLAG,      INBOUND_START,    ENGINE_FLAG  ' + char(10)
                                SELECT @v_dSql += '    , OUTBOUND_FLAG,     DB_TRANS_FLAG,    INSERT_ID    ' + char(10)
                                SELECT @v_dSql += '    , INSERT_TIME,       UPDATE_ID,        UPDATE_TIME  ' + char(10)
                                SELECT @v_dSql += '  )         ' + char(10)
                                SELECT @v_dSql += '  SELECT    ' + char(10)
								SELECT @v_dSql += '       '''+ @v_instance_id +''', '''+ @v_plan_id +''',               1 AS active_flag                  ' + char(10)
                                SELECT @v_dSql += '     , ''P'' AS inbound_flag,    GETDATE() AS inbound_start,        ''R'' AS engine_flag               ' + char(10)
                                SELECT @v_dSql += '     , ''R'' AS outbound_flag,   ''R'' AS db_trans_flag,            '''+ @v_user_id +''' AS insert_id  ' + char(10)
                                SELECT @v_dSql += '     , GETDATE() AS insert_date, '''+ @v_user_id +''' AS update_id, GETDATE() AS update_date           ' + char(10)
                                SELECT @v_dSql += '    ' + char(10)
                                SELECT @v_dSql += '  INSERT INTO HIS_PLAN_STATUS_H (  ' + char(10)
                                SELECT @v_dSql += '         INSTANCE_ID,           PLAN_ID,            ACTIVE_FLAG         ' + char(10)
                                SELECT @v_dSql += '        ,INBOUND_FLAG,          INBOUND_STEP,       INBOUND_START       ' + char(10)
                                SELECT @v_dSql += '        ,INBOUND_END,           ENGINE_FLAG,        ENGINE_STEP         ' + char(10)
                                SELECT @v_dSql += '        ,ENGINE_START,          ENGINE_END,         OUTBOUND_FLAG       ' + char(10)
								SELECT @v_dSql += '        ,OUTBOUND_STEP,         OUTBOUND_START,     OUTBOUND_END        ' + char(10)
                                SELECT @v_dSql += '        ,DB_TRANS_FLAG,         DB_TRANS_STEP,      DB_TRANS_START      ' + char(10)
                                SELECT @v_dSql += '        ,DB_TRANS_END,          DESCRIPTION,        DB_CONNECTION_NAME  ' + char(10)
                                SELECT @v_dSql += '        ,INSERT_ID,             INSERT_TIME,        UPDATE_ID           ' + char(10)
                                SELECT @v_dSql += '        ,UPDATE_TIME,           JOB_USER_ID,        JOB_TIME            ' + char(10)
								SELECT @v_dSql += '        ,JOB_TYPE                                                       ' + char(10)
                                SELECT @v_dSql += '  )   ' + char(10)
                                SELECT @v_dSql += '  SELECT INSTANCE_ID,           PLAN_ID,            ACTIVE_FLAG         ' + char(10)
                                SELECT @v_dSql += '        ,INBOUND_FLAG,          INBOUND_STEP,       INBOUND_START       ' + char(10)
                                SELECT @v_dSql += '        ,INBOUND_END,           ENGINE_FLAG,        ENGINE_STEP         ' + char(10)
                                SELECT @v_dSql += '        ,ENGINE_START,          ENGINE_END,         OUTBOUND_FLAG       ' + char(10)
								SELECT @v_dSql += '        ,OUTBOUND_STEP,         OUTBOUND_START,     OUTBOUND_END        ' + char(10)
                                SELECT @v_dSql += '        ,DB_TRANS_FLAG,         DB_TRANS_STEP,      DB_TRANS_START      ' + char(10)
                                SELECT @v_dSql += '        ,DB_TRANS_END,          DESCRIPTION,        DB_CONNECTION_NAME  ' + char(10)
                                SELECT @v_dSql += '        ,INSERT_ID,             INSERT_TIME,        UPDATE_ID           ' + char(10)
                                SELECT @v_dSql += '        ,UPDATE_TIME,        '''+ @v_user_id +''' , dbo.SYSDATE1() AS JOB_TIME   ' + char(10)
								SELECT @v_dSql += '        ,''INSERT'' AS JOB_TYPE                    ' + char(10)
                                SELECT @v_dSql += '  FROM   FP_PLAN_STATUS_H(NOLOCK)                  ' + char(10)
                                SELECT @v_dSql += '  WHERE  INSTANCE_ID = '''+ @v_instance_id +'''    ' + char(10)
                                SELECT @v_dSql += '  AND    PLAN_ID     = '''+ @v_plan_id +'''        ' + char(10)


                            END --M
					   /****************************************************************************/
					   /* UPDATE  경우  :UPDATE_ENGINE_RUN                                          */
					   /****************************************************************************/
					   ELSE IF(@v_sys_flag ='UPDATE_ENGINE_RUN')
						   BEGIN
								SELECT @v_dSql = ''
                                SELECT @v_dSql += ' UPDATE JOB_SCHEDULE_DETAIL SET                 ' + char(10)
                                SELECT @v_dSql += '        PARAMETER1 = '''+ @v_instance_id +'''   ' + char(10)
                                SELECT @v_dSql += '      , PARAMETER2 = '''+ @v_plan_id +'''       ' + char(10)
                                SELECT @v_dSql += ' WHERE  GROUP_ID = ''ENGINE_RUN_UI-'' + '''+ @v_instance_id +''' ' + char(10)
								SELECT @v_dSql += '  ' + char(10)
                                SELECT @v_dSql += ' UPDATE JOB_SCHEDULE_MASTER SET  ' + char(10)
                                SELECT @v_dSql += '        IMMEDIATE_FLAG = ''Y''   ' + char(10)
                                SELECT @v_dSql += ' WHERE  GROUP_ID = ''ENGINE_RUN_UI-'' + '''+ @v_instance_id +''' ' + char(10)

						   END --'M1'
					   /****************************************************************************/
					   /* UPDATE  경우  :UPDATE_PLANIFO(Plan Info팝업                              */
					   /****************************************************************************/
					   ELSE IF(@v_sys_flag ='UPDATE_PLANIFO')
						   BEGIN
								SELECT @v_dSql = ''
                                SELECT @v_dSql += '  UPDATE  SCM_FP_PLAN_H SET                     ' + char(10)
                                SELECT @v_dSql += '      PLAN_HORIZON  = '''+ @v_plan_horizon +''' ' + char(10)
                                SELECT @v_dSql += '     ,UPDATE_ID     = '''+ @v_user_id +'''      ' + char(10)
                                SELECT @v_dSql += '     ,UPDATE_TIME   = GETDATE()                 ' + char(10)
                                SELECT @v_dSql += '  WHERE INSTANCE_ID = '''+ @v_instance_id +'''  ' + char(10)
                                SELECT @v_dSql += '  AND   PLAN_ID     = '''+ @v_plan_id +'''      ' + char(10)
                                SELECT @v_dSql += '  AND   PLAN_TYPE   = '''+ @v_plan_type +'''    ' + char(10)
								SELECT @v_dSql += '                               ' + char(10)
                                SELECT @v_dSql += ' INSERT INTO HIS_FP_PLAN_H  (  ' + char(10)
                                SELECT @v_dSql += '        INSTANCE_ID                ,PLAN_ID                ,PLAN_TYPE                ,SITE_ID         ' + char(10)
                                SELECT @v_dSql += '       ,PLAN_START_TIME            ,PLAN_HORIZON           ,PLAN_HORIZON_UOM         ,DEMAND_HORIZON  ' + char(10)
                                SELECT @v_dSql += '       ,DEMAND_HORIZON_UOM         ,CONFIG_SET_ID          ,BASIS_PLAN_ID            ,DEMAND_PLAN_ID  ' + char(10)
                                SELECT @v_dSql += '       ,SCP_PLAN_ID                ,PLAN_WEEK              ,CONFIRM_FLAG             ,DESCRIPTION     ' + char(10)
                                SELECT @v_dSql += '       ,INSERT_ID                  ,INSERT_TIME            ,UPDATE_ID                ,UPDATE_TIME     ' + char(10)
                                SELECT @v_dSql += '       ,JOB_USER_ID                ,JOB_TIME               ,JOB_TYPE                                  ' + char(10)
                                SELECT @v_dSql += ' )                                                                                                    ' + char(10)
                                SELECT @v_dSql += ' SELECT INSTANCE_ID                ,PLAN_ID                ,PLAN_TYPE                ,SITE_ID         ' + char(10)
                                SELECT @v_dSql += '       ,PLAN_START_TIME            ,PLAN_HORIZON           ,PLAN_HORIZON_UOM         ,DEMAND_HORIZON  ' + char(10)
                                SELECT @v_dSql += '       ,DEMAND_HORIZON_UOM         ,CONFIG_SET_ID          ,BASIS_PLAN_ID            ,DEMAND_PLAN_ID  ' + char(10)
                                SELECT @v_dSql += '       ,SCP_PLAN_ID                ,PLAN_WEEK              ,CONFIRM_FLAG             ,DESCRIPTION     ' + char(10)
                                SELECT @v_dSql += '       ,INSERT_ID                  ,INSERT_TIME            ,UPDATE_ID                ,UPDATE_TIME     ' + char(10)
                                SELECT @v_dSql += '       ,'''+ @v_user_id +'''       ,GETDATE() as JOB_TIME  ,''UPDATE'' as JOB_TYPE                    ' + char(10)
                                SELECT @v_dSql += ' FROM   SCM_FP_PLAN_H(NOLOCK)                  ' + char(10)
                                SELECT @v_dSql += ' WHERE INSTANCE_ID = '''+ @v_instance_id +'''  ' + char(10)
                                SELECT @v_dSql += ' AND   PLAN_ID     = '''+ @v_plan_id +'''      ' + char(10)
                                SELECT @v_dSql += ' AND   PLAN_TYPE   = '''+ @v_plan_type +'''    ' + char(10)                          

						   END --'M1'

						/****************************************************************************/
						/* UPDATE  경우  :액션 종료후에 상태를 저장 - 프로시저 : callback 이후, link : 메뉴 호출 후               */
						/****************************************************************************/
						ELSE IF(@v_sys_flag ='UPDATE_STATUS')
							BEGIN	
					
								SELECT @v_dSql = ''
								SELECT @v_dSql += N'	MERGE INTO FP_WOW_HIST AS A																' + char(10)
			
								SELECT @v_dSql += N'	USING (SELECT '''+ @v_site_id +''' AS SITE_ID, '''+ @v_instance_id +''' AS INSTANCE_ID, '''+ @v_wow_id +''' AS WOW_ID    ' + char(10)
								SELECT @v_dSql += N'	          , '''+ @v_plan_date +''' AS PLAN_DATE) AS B                                              ' + char(10)
								SELECT @v_dSql += N'	ON (A.SITE_ID     = B.SITE_ID                                                           ' + char(10)
								SELECT @v_dSql += N'	AND A.INSTANCE_ID = B.INSTANCE_ID                                                       ' + char(10)
								SELECT @v_dSql += N'	AND A.WOW_ID      = B.WOW_ID                                                            ' + char(10)
								SELECT @v_dSql += N'	AND CONVERT(VARCHAR(8), A.PLAN_DATE, 112) = B.PLAN_DATE)                                ' + char(10)
								SELECT @v_dSql += N'	WHEN MATCHED THEN                                                                       ' + char(10)
								SELECT @v_dSql += N'	UPDATE SET                                                                              ' + char(10)
			
								SELECT @v_dSql += N'	  PLAN_ID      = '''+ @v_plan_id +'''                                                              ' + char(10)
								SELECT @v_dSql += N'	 ,CONFIRM_ID   = '''+ @v_user_id +'''                                                              ' + char(10)
								SELECT @v_dSql += N'	 ,CONFIRM_DATE = DBO.FN_SITE_TIME('''+ @v_site_id +''')                                            ' + char(10)
								SELECT @v_dSql += N'	 ,UPDATE_ID    = '''+ @v_user_id +'''                                                              ' + char(10)
								SELECT @v_dSql += N'	 ,UPDATE_DATE  = DBO.FN_SITE_TIME('''+ @v_site_id +''')                                            ' + char(10)
								SELECT @v_dSql += N'	WHEN NOT MATCHED THEN                                                                   ' + char(10)
								SELECT @v_dSql += N'	INSERT (                                                                                ' + char(10)
								SELECT @v_dSql += N'	   SITE_ID                                                                              ' + char(10)
								SELECT @v_dSql += N'	  ,INSTANCE_ID                                                                          ' + char(10)
								SELECT @v_dSql += N'	  ,WOW_ID                                                                               ' + char(10)
								SELECT @v_dSql += N'	  ,PLAN_DATE                                                                            ' + char(10)
								SELECT @v_dSql += N'	  ,PLAN_ID                                                                              ' + char(10)
								SELECT @v_dSql += N'	  ,DESCRIPTION                                                                          ' + char(10)
								SELECT @v_dSql += N'	  ,CONFIRM_ID, CONFIRM_DATE                                                             ' + char(10)
								SELECT @v_dSql += N'	  ,INSERT_ID, INSERT_DATE, UPDATE_ID, UPDATE_DATE                                       ' + char(10)
								SELECT @v_dSql += N'	) VALUES (                                                                              ' + char(10)
								SELECT @v_dSql += N'	   '''+ @v_site_id +'''                                                                            ' + char(10)
								SELECT @v_dSql += N'	  ,'''+ @v_instance_id +'''                                                                        ' + char(10)
								SELECT @v_dSql += N'	  ,'''+ @v_wow_id +'''                                                                             ' + char(10)
								SELECT @v_dSql += N'	  ,CONVERT(DATETIME, '''+ @v_plan_date +''')                                                       ' + char(10)
								SELECT @v_dSql += N'	  ,(CASE WHEN '''+ @v_plan_id +''' IS NULL OR '''+ @v_plan_id +''' = '''' THEN ''-'' ELSE '''+ @v_plan_id +''' END)      ' + char(10)
								SELECT @v_dSql += N'	  ,'''+ @v_description +'''                                                                       ' + char(10)
								SELECT @v_dSql += N'	  ,'''+ @v_user_id +''', DBO.FN_SITE_TIME('''+ @v_site_id +''')                                               ' + char(10)
								SELECT @v_dSql += N'	  ,'''+ @v_user_id +''', DBO.FN_SITE_TIME('''+ @v_site_id +'''), '''+ @v_user_id +''', DBO.FN_SITE_TIME('''+ @v_site_id +''')       ' + char(10)
								SELECT @v_dSql += N'	)                                                                                       ' + char(10)
								SELECT @v_dSql += N'	;                                                                                       ' + char(10)
								
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
							EXEC PR_UI_SQL_LOG  @v_proc_name,  @v_user_id, @v_sys_flag,'', @v_dSql,'SELECT',@runstart, @runend
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

