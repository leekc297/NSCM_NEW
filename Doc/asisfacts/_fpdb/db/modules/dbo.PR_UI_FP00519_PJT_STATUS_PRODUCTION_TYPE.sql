

/*
 * Program ID   : PR_UI_FP00519_PJT_STATUS_PRODUCTION_TYPE
 * Description  : PJT Status & Production Type
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/02/08   CYS				Initial Release UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FP00519_PJT_STATUS_PRODUCTION_TYPE]
  @p_sys_type			NVARCHAR(MAX),  
  @p_sys_flag			NVARCHAR(MAX),
  @p_sys_gubun			NVARCHAR(MAX),  
  @p_user_id			NVARCHAR(MAX),

  @p_instance_id		NVARCHAR(MAX),
  @p_shop_group_id		NVARCHAR(MAX),
  @p_division_id		NVARCHAR(MAX),
  @p_item_id			NVARCHAR(MAX),
  @p_nick_name			NVARCHAR(MAX),
  @p_applied_model		NVARCHAR(MAX),
  @p_item_class_id		NVARCHAR(MAX),
  @p_item_class_name	NVARCHAR(MAX),
  @p_target_yn			NVARCHAR(MAX)	

AS 
BEGIN
	
    SET NOCOUNT ON;

	DECLARE @v_proc_name	nvarchar(100) = 'PR_UI_FP00519_PJT_STATUS_PRODUCTION_TYPE';
	DECLARE @runstart		datetime;
	DECLARE @runend			datetime;
	DECLARE @v_dSql			nvarchar(MAX)='';
	
	BEGIN

		SET	@v_dSql = ''
		SET @v_dSql += '	WITH SCP_TARGET AS (																																						' + char(10);
		SET @v_dSql += '							SELECT 	*                                                                                                                                           ' + char(10);
		SET @v_dSql += '							FROM 	(                                                                                                                                           ' + char(10);
		SET @v_dSql += '										SELECT	B.INSTANCE_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.SHOP_GROUP_ID, MAX(SCP_PLAN_ID) AS SCP_PLAN_ID                         ' + char(10);
		SET @v_dSql += '										FROM	DBO.FP_WEEKLY_DEMAND_PRODUCT_H	A WITH(NOLOCK)                                                                                  ' + char(10);
		SET @v_dSql += '												, (                                                                                                                             ' + char(10);
		SET @v_dSql += '													SELECT	DISTINCT A.INSTANCE_ID,A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, B.SHOP_GROUP_ID                          ' + char(10);
		SET @v_dSql += '													FROM	FP_INSTANCE_INFO_V A WITH(NOLOCK)                                                                                   ' + char(10);
		SET @v_dSql += '															, FP_INSTANCE_FACTORY_M B WITH(NOLOCK)                                                                              ' + char(10);
		SET @v_dSql += '													WHERE	1=1                                                                                                                 ' + char(10);
		SET @v_dSql += '													AND		A.INSTANCE_ID = B.INSTANCE_ID                                                                                       ' + char(10);
		SET @v_dSql += '													AND		B.ACTIVE_FLAG = ''Y''                                                                                                 ' + char(10);
		SET @v_dSql += '												) B                                                                                                                             ' + char(10);
		SET @v_dSql += '										WHERE  1=1                                                                                                                              ' + char(10);
		SET @v_dSql += '										AND		A.COMPANY_ID = B.COMPANY_ID                                                                                                     ' + char(10);
		SET @v_dSql += '										AND		A.DIVISION_ID = B.DIVISION_ID                                                                                                   ' + char(10);
		SET @v_dSql += '										AND		A.SITE_ID = B.SITE_ID                                                                                                           ' + char(10);
		SET @v_dSql += '										AND		A.PLANT_ID = B.PLANT_ID                                                                                                         ' + char(10);
		SET @v_dSql += '										AND		A.SHOP_GROUP_ID = B.SHOP_GROUP_ID                                                                                               ' + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SHOP_GROUP_ID' , 'EQ', @p_shop_group_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.INSTANCE_ID' , 'EQ', @p_instance_id)) + char(10);
		SET @v_dSql += '										GROUP BY B.INSTANCE_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.SHOP_GROUP_ID                                                         ' + char(10);
		SET @v_dSql += '							                                                                                                                                                    ' + char(10);
		SET @v_dSql += '									) A                                                                                                                                         ' + char(10);
		SET @v_dSql += '							WHERE EXISTS (                                                                                                                                      ' + char(10);
		SET @v_dSql += '											SELECT 1                                                                                                                            ' + char(10);
		SET @v_dSql += '											FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)                                                                                           ' + char(10);
		SET @v_dSql += '											WHERE  A.COMPANY_ID   = B.COMPANY_ID                                                                                                ' + char(10);
		SET @v_dSql += '											AND    A.DIVISION_ID  = B.DIVISION_ID                                                                                               ' + char(10);
		SET @v_dSql += '											AND    A.SITE_ID      = B.SITE_ID                                                                                                   ' + char(10);
		SET @v_dSql += '											AND    A.INSTANCE_ID  = B.INSTANCE_ID                                                                                               ' + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_ID' , 'EQ', @p_instance_id)) + char(10);
		SET @v_dSql += '											AND    B.USER_ID      = '''+ @p_user_id +'''                                                                                        ' + char(10);
		SET @v_dSql += '										)                                                                                                                                       ' + char(10);
		SET @v_dSql += '					)                                                                                                                                                           ' + char(10);
		SET @v_dSql += '	SELECT 	A.DIVISION_ID, A.CLASS_NAME, A.ITEM_ID, A.NICK_NAME, A.APPLIED_MODEL, A.PJT_STATUS_ID, A.PJT_PROGRESS_STEP_ID, A.PRODUCTION_TYPE                                    ' + char(10);
		SET @v_dSql += '			  , CASE WHEN MODEL_ID IS NULL OR R.DIVISION_ID IS NULL THEN ''N'' ELSE ''Y'' END AS EDIT_YN                                                                        ' + char(10);
		SET @v_dSql += '	FROM	(                                                                                                                                                                   ' + char(10);
		SET @v_dSql += '				SELECT A.DIVISION_ID, E.CLASS_NAME, A.ITEM_ID, B.NICK_NAME, B.APPLIED_MODEL, D.PJT_STATUS_ID, D.PJT_PROGRESS_STEP_ID, D.PRODUCTION_TYPE                         ' + char(10);
		SET @v_dSql += '						 , D.MODEL_ID                                                                                                                                           ' + char(10);
		SET @v_dSql += '				FROM 	FP_WEEKLY_DEMAND_PRODUCT_H A  WITH(NOLOCK)                                                                                                              ' + char(10);
		SET @v_dSql += '						LEFT OUTER JOIN SCM_ITEM_M B  WITH(NOLOCK)                                                                                                              ' + char(10);
		SET @v_dSql += '						ON 	1=1                                                                                                                                                 ' + char(10);
		SET @v_dSql += '						AND A.COMPANY_ID  = B.COMPANY_ID                                                                                                                        ' + char(10);
		SET @v_dSql += '						AND A.DIVISION_ID = B.DIVISION_ID                                                                                                                       ' + char(10);
		SET @v_dSql += '						AND A.SITE_ID     = B.SITE_ID                                                                                                                           ' + char(10);
		SET @v_dSql += '						AND A.ITEM_ID     = B.ITEM_ID                                                                                                                           ' + char(10);
		SET @v_dSql += '						AND B.ACTIVE_FLAG = ''Y''                                                                                                                               ' + char(10);
		SET @v_dSql += '						LEFT OUTER JOIN FP_PLM_PJT_MODEL_MASTER D  WITH(NOLOCK)                                                                                                 ' + char(10);
		SET @v_dSql += '						ON 	1=1                                                                                                                                                 ' + char(10);
		SET @v_dSql += '						AND B.DIVISION_ID   = D.DIVISION_ID                                                                                                                     ' + char(10);
		SET @v_dSql += '						AND B.APPLIED_MODEL = D.MODEL_ID,                                                                                                                       ' + char(10);
		SET @v_dSql += '						SCP_TARGET C  WITH(NOLOCK),                                                                                                                             ' + char(10);
		SET @v_dSql += '						SCM_ITEM_CLASS_M E  WITH(NOLOCK)                                                                                                                        ' + char(10);
		SET @v_dSql += '				WHERE 1 = (CASE WHEN ISNULL('''+ @p_target_yn +''',''N'') = ''Y'' THEN 1 ELSE 0 END)                                                                            ' + char(10);
		SET @v_dSql += '				AND 	A.SHOP_GROUP_ID = ''E''                                                                                                                                 ' + char(10);
		SET @v_dSql += '				AND 	A.COMPANY_ID    = C.COMPANY_ID                                                                                                                          ' + char(10);
		SET @v_dSql += '				AND 	A.DIVISION_ID   = C.DIVISION_ID                                                                                                                         ' + char(10);
		SET @v_dSql += '				AND 	A.SITE_ID       = C.SITE_ID                                                                                                                             ' + char(10);
		SET @v_dSql += '				AND 	A.SCP_PLAN_ID   = C.SCP_PLAN_ID                                                                                                                         ' + char(10);
		SET @v_dSql += '				AND 	B.ITEM_CLASS    = E.CLASS_ID                                                                                                                            ' + char(10);
		SET @v_dSql += '				AND 	E.LEVEL_2_NAME LIKE ''PANCAKE''                                                                                                                         ' + char(10);
		SET @v_dSql += '				AND 	E.LEVEL_3_NAME != ''SRS Pancake''                                                                                                                       ' + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.INSTANCE_ID' , 'EQ', @p_instance_id)) + char(10);
		SET @v_dSql += '				AND   ''E'' = '''+ @p_shop_group_id +'''                                                                                                                        ' + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('E.CLASS_ID' , 'EQ', @p_item_class_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('E.CLASS_NAME' , 'LIKE', @p_item_class_name)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.APPLIED_MODEL' , 'LIKE', @p_applied_model)) + char(10);
		SET @v_dSql += '				GROUP BY A.DIVISION_ID, E.CLASS_NAME, A.ITEM_ID, B.NICK_NAME, B.APPLIED_MODEL, D.PJT_STATUS_ID, D.PJT_PROGRESS_STEP_ID, D.PRODUCTION_TYPE, D.MODEL_ID           ' + char(10);
		SET @v_dSql += '				UNION ALL                                                                                                                                                       ' + char(10);
		SET @v_dSql += '				SELECT 	A.DIVISION_ID, C.CLASS_NAME, A.ITEM_ID, A.NICK_NAME, A.APPLIED_MODEL, B.PJT_STATUS_ID, B.PJT_PROGRESS_STEP_ID, B.PRODUCTION_TYPE, B.MODEL_ID            ' + char(10);
		SET @v_dSql += '				FROM 	SCM_ITEM_M A  WITH(NOLOCK)                                                                                                                              ' + char(10);
		SET @v_dSql += '						LEFT OUTER JOIN FP_PLM_PJT_MODEL_MASTER B  WITH(NOLOCK)                                                                                                 ' + char(10);
		SET @v_dSql += '						ON 	1=1                                                                                                                                                 ' + char(10);
		SET @v_dSql += '						AND A.DIVISION_ID   = B.DIVISION_ID                                                                                                                     ' + char(10);
		SET @v_dSql += '						AND A.APPLIED_MODEL = B.MODEL_ID,                                                                                                                       ' + char(10);
		SET @v_dSql += '						SCM_ITEM_CLASS_M C  WITH(NOLOCK),                                                                                                                       ' + char(10);
		SET @v_dSql += '						SCP_TARGET D  WITH(NOLOCK)                                                                                                                              ' + char(10);
		SET @v_dSql += '				WHERE 1 = (CASE WHEN ISNULL('''+ @p_target_yn +''',''N'') = ''N'' THEN 1 ELSE 0 END)                                                                            ' + char(10);
		SET @v_dSql += '				AND 	A.COMPANY_ID   = D.COMPANY_ID                                                                                                                           ' + char(10);
		SET @v_dSql += '				AND 	A.DIVISION_ID  = D.DIVISION_ID                                                                                                                          ' + char(10);
		SET @v_dSql += '				AND 	A.SITE_ID      = D.SITE_ID                                                                                                                              ' + char(10);
		SET @v_dSql += '				AND 	A.ACTIVE_FLAG  = ''Y''                                                                                                                                  ' + char(10);
		SET @v_dSql += '				AND 	A.ITEM_CLASS   = C.CLASS_ID                                                                                                                             ' + char(10);
		SET @v_dSql += '				AND 	C.LEVEL_2_NAME LIKE ''PANCAKE''                                                                                                                         ' + char(10);
		SET @v_dSql += '				AND 	C.LEVEL_3_NAME != ''SRS Pancake''                                                                                                                       ' + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('D.INSTANCE_ID' , 'EQ', @p_instance_id)) + char(10);
		SET @v_dSql += '				AND   ''E'' = '''+ @p_shop_group_id +'''                                                                                                                        ' + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.CLASS_ID' , 'EQ', @p_item_class_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.CLASS_NAME' , 'LIKE', @p_item_class_name)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.APPLIED_MODEL' , 'LIKE', @p_applied_model)) + char(10);
		SET @v_dSql += '				GROUP BY A.DIVISION_ID, C.CLASS_NAME, A.ITEM_ID, A.NICK_NAME, A.APPLIED_MODEL, B.PJT_STATUS_ID, B.PJT_PROGRESS_STEP_ID, B.PRODUCTION_TYPE, B.MODEL_ID           ' + char(10);
		SET @v_dSql += '				-- PACK                                                                                                                                                         ' + char(10);
		SET @v_dSql += '				UNION ALL                                                                                                                                                       ' + char(10);
		SET @v_dSql += '				SELECT 	A.DIVISION_ID, E.CLASS_NAME, ''-'' AS ITEM_ID, B.NICK_NAME, A.ITEM_ID AS APPLIED_MODEL, D.PJT_STATUS_ID, D.PJT_PROGRESS_STEP_ID, D.PRODUCTION_TYPE      ' + char(10);
		SET @v_dSql += '					    --, D.MODEL_ID                                                                                                                                          ' + char(10);
		SET @v_dSql += '					    , A.ITEM_ID AS MODEL_ID                                                                                                                                 ' + char(10);
		SET @v_dSql += '				FROM 	FP_WEEKLY_DEMAND_PRODUCT_H A  WITH(NOLOCK)                                                                                                              ' + char(10);
		SET @v_dSql += '						LEFT OUTER HASH JOIN SCM_ITEM_M B  WITH(NOLOCK)                                                                                                         ' + char(10);
		SET @v_dSql += '						ON 	1=1                                                                                                                                                 ' + char(10);
		SET @v_dSql += '						AND A.COMPANY_ID  = B.COMPANY_ID                                                                                                                        ' + char(10);
		SET @v_dSql += '						AND A.DIVISION_ID = B.DIVISION_ID                                                                                                                       ' + char(10);
		SET @v_dSql += '						AND A.SITE_ID     = B.SITE_ID                                                                                                                           ' + char(10);
		SET @v_dSql += '						AND A.ITEM_ID     = B.ITEM_ID                                                                                                                           ' + char(10);
		SET @v_dSql += '						AND B.ACTIVE_FLAG = ''Y''                                                                                                                               ' + char(10);
		SET @v_dSql += '						LEFT OUTER HASH JOIN FP_PLM_PJT_MODEL_MASTER D  WITH(NOLOCK)                                                                                            ' + char(10);
		SET @v_dSql += '						ON 	1=1                                                                                                                                                 ' + char(10);
		SET @v_dSql += '						AND A.DIVISION_ID = D.DIVISION_ID                                                                                                                       ' + char(10);
		SET @v_dSql += '						AND A.ITEM_ID     = D.MODEL_ID,                                                                                                                         ' + char(10);
		SET @v_dSql += '						SCP_TARGET C  WITH(NOLOCK),                                                                                                                             ' + char(10);
		SET @v_dSql += '						SCM_ITEM_CLASS_M E  WITH(NOLOCK)                                                                                                                        ' + char(10);
		SET @v_dSql += '				WHERE 1 = (CASE WHEN ISNULL('''+ @p_target_yn +''',''N'') = ''Y'' THEN 1 ELSE 0 END)                                                                            ' + char(10);
		SET @v_dSql += '				AND 	A.SHOP_GROUP_ID = ''P''                                                                                                                                 ' + char(10);
		SET @v_dSql += '				AND 	A.COMPANY_ID    = C.COMPANY_ID                                                                                                                          ' + char(10);
		SET @v_dSql += '				AND 	A.DIVISION_ID   = C.DIVISION_ID                                                                                                                         ' + char(10);
		SET @v_dSql += '				AND 	A.SITE_ID       = C.SITE_ID                                                                                                                             ' + char(10);
		SET @v_dSql += '				AND 	A.SCP_PLAN_ID   = C.SCP_PLAN_ID                                                                                                                         ' + char(10);
		SET @v_dSql += '				AND 	B.ITEM_CLASS    = E.CLASS_ID                                                                                                                            ' + char(10);
		SET @v_dSql += '				AND   E.LEVEL_1_NAME  = ''Model''                                                                                                                               ' + char(10);
		SET @v_dSql += '				AND   E.LEVEL_3_NAME IN (''Pack'',''Module'',''House'')                                                                                                         ' + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.INSTANCE_ID' , 'EQ', @p_instance_id)) + char(10);
		SET @v_dSql += '				AND   ''P'' = '''+ @p_shop_group_id +'''                                                                                                                        ' + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('E.CLASS_ID' , 'EQ', @p_item_class_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('E.CLASS_NAME' , 'LIKE', @p_item_class_name)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_applied_model)) + char(10);
		SET @v_dSql += '				GROUP BY A.DIVISION_ID, E.CLASS_NAME, A.ITEM_ID, B.NICK_NAME, D.PJT_STATUS_ID, D.PJT_PROGRESS_STEP_ID, D.PRODUCTION_TYPE                                        ' + char(10);
		SET @v_dSql += '				--, D.MODEL_ID                                                                                                                                                  ' + char(10);
		SET @v_dSql += '				UNION ALL                                                                                                                                                       ' + char(10);
		SET @v_dSql += '				SELECT 	A.DIVISION_ID, C.CLASS_NAME, ''-'' AS ITEM_ID, A.NICK_NAME, A.ITEM_ID AS APPLIED_MODEL, B.PJT_STATUS_ID, B.PJT_PROGRESS_STEP_ID, B.PRODUCTION_TYPE, A.ITEM_ID AS MODEL_ID	' + char(10);
		SET @v_dSql += '				FROM 	SCM_ITEM_M A  WITH(NOLOCK)                                                                                                                              ' + char(10);
		SET @v_dSql += '						LEFT OUTER JOIN FP_PLM_PJT_MODEL_MASTER B  WITH(NOLOCK)                                                                                                 ' + char(10);
		SET @v_dSql += '						ON 	1=1                                                                                                                                                 ' + char(10);
		SET @v_dSql += '						AND A.DIVISION_ID = B.DIVISION_ID                                                                                                                       ' + char(10);
		SET @v_dSql += '						AND A.ITEM_ID     = B.MODEL_ID,                                                                                                                         ' + char(10);
		SET @v_dSql += '						SCM_ITEM_CLASS_M C  WITH(NOLOCK),                                                                                                                       ' + char(10);
		SET @v_dSql += '						SCP_TARGET D  WITH(NOLOCK)                                                                                                                              ' + char(10);
		SET @v_dSql += '				WHERE 1 = (CASE WHEN ISNULL('''+ @p_target_yn +''',''N'') = ''N'' THEN 1 ELSE 0 END)                                                                            ' + char(10);
		SET @v_dSql += '				AND   A.COMPANY_ID  = D.COMPANY_ID                                                                                                                              ' + char(10);
		SET @v_dSql += '				AND   A.DIVISION_ID = D.DIVISION_ID                                                                                                                             ' + char(10);
		SET @v_dSql += '				AND   A.SITE_ID     = D.SITE_ID                                                                                                                                 ' + char(10);
		SET @v_dSql += '				AND   A.ACTIVE_FLAG = ''Y''                                                                                                                                     ' + char(10);
		SET @v_dSql += '				AND   A.ITEM_CLASS  = C.CLASS_ID                                                                                                                                ' + char(10);
		SET @v_dSql += '				AND   C.LEVEL_1_NAME = ''Model''                                                                                                                                ' + char(10);
		SET @v_dSql += '				AND   C.LEVEL_3_NAME IN (''Pack'',''Module'',''House'')                                                                                                         ' + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('D.INSTANCE_ID' , 'EQ', @p_instance_id)) + char(10);
		SET @v_dSql += '				AND   ''P'' = '''+ @p_shop_group_id +'''                                                                                                                        ' + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.CLASS_ID' , 'EQ', @p_item_class_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.CLASS_NAME' , 'LIKE', @p_item_class_name)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_applied_model)) + char(10);
		SET @v_dSql += '				GROUP BY A.DIVISION_ID, C.CLASS_NAME, A.NICK_NAME, A.ITEM_ID, B.PJT_STATUS_ID, B.PJT_PROGRESS_STEP_ID, B.PRODUCTION_TYPE                                        ' + char(10);
		SET @v_dSql += '				                                                                                                                                                                ' + char(10);
		SET @v_dSql += '				-- CELL                                                                                                                                                         ' + char(10);
		SET @v_dSql += '				UNION ALL                                                                                                                                                       ' + char(10);
		SET @v_dSql += '				SELECT 	A.DIVISION_ID, E.CLASS_NAME, ''-'' AS ITEM_ID, B.NICK_NAME, A.ITEM_ID AS APPLIED_MODEL, D.PJT_STATUS_ID, D.PJT_PROGRESS_STEP_ID, D.PRODUCTION_TYPE      ' + char(10);
		SET @v_dSql += '					    --, D.MODEL_ID                                                                                                                                          ' + char(10);
		SET @v_dSql += '					    , A.ITEM_ID AS MODEL_ID                                                                                                                                 ' + char(10);
		SET @v_dSql += '				FROM 	FP_WEEKLY_DEMAND_PRODUCT_H A  WITH(NOLOCK)                                                                                                              ' + char(10);
		SET @v_dSql += '						LEFT OUTER HASH JOIN SCM_ITEM_M B  WITH(NOLOCK)                                                                                                         ' + char(10);
		SET @v_dSql += '						ON 	1=1                                                                                                                                                 ' + char(10);
		SET @v_dSql += '						AND A.COMPANY_ID  = B.COMPANY_ID                                                                                                                        ' + char(10);
		SET @v_dSql += '						AND A.DIVISION_ID = B.DIVISION_ID                                                                                                                       ' + char(10);
		SET @v_dSql += '						AND A.SITE_ID     = B.SITE_ID                                                                                                                           ' + char(10);
		SET @v_dSql += '						AND A.ITEM_ID     = B.ITEM_ID                                                                                                                           ' + char(10);
		SET @v_dSql += '						AND B.ACTIVE_FLAG = ''Y''                                                                                                                               ' + char(10);
		SET @v_dSql += '						LEFT OUTER HASH JOIN FP_PLM_PJT_MODEL_MASTER D  WITH(NOLOCK)                                                                                            ' + char(10);
		SET @v_dSql += '						ON 	1=1                                                                                                                                                 ' + char(10);
		SET @v_dSql += '						AND A.DIVISION_ID = D.DIVISION_ID                                                                                                                       ' + char(10);
		SET @v_dSql += '						AND A.ITEM_ID     = D.MODEL_ID,                                                                                                                         ' + char(10);
		SET @v_dSql += '						SCP_TARGET C  WITH(NOLOCK),                                                                                                                             ' + char(10);
		SET @v_dSql += '						SCM_ITEM_CLASS_M E  WITH(NOLOCK)                                                                                                                        ' + char(10);
		SET @v_dSql += '				WHERE 1 = (CASE WHEN ISNULL('''+ @p_target_yn +''',''N'') = ''Y'' THEN 1 ELSE 0 END)                                                                            ' + char(10);
		SET @v_dSql += '				AND 	A.SHOP_GROUP_ID = ''A''                                                                                                                                 ' + char(10);
		SET @v_dSql += '				AND 	A.COMPANY_ID    = C.COMPANY_ID                                                                                                                          ' + char(10);
		SET @v_dSql += '				AND 	A.DIVISION_ID   = C.DIVISION_ID                                                                                                                         ' + char(10);
		SET @v_dSql += '				AND 	A.SITE_ID       = C.SITE_ID                                                                                                                             ' + char(10);
		SET @v_dSql += '				AND 	A.SCP_PLAN_ID   = C.SCP_PLAN_ID                                                                                                                         ' + char(10);
		SET @v_dSql += '				AND 	B.ITEM_CLASS    = E.CLASS_ID                                                                                                                            ' + char(10);
		SET @v_dSql += '				AND   E.LEVEL_1_NAME  = ''Model''                                                                                                                               ' + char(10);
		SET @v_dSql += '				AND   E.LEVEL_3_NAME LIKE ''%Cell%''                                                                                                                            ' + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.INSTANCE_ID' , 'EQ', @p_instance_id)) + char(10);
		SET @v_dSql += '				AND   ''A'' = '''+ @p_shop_group_id +'''                                                                                                                        ' + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('E.CLASS_ID' , 'EQ', @p_item_class_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('E.CLASS_NAME' , 'LIKE', @p_item_class_name)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_applied_model)) + char(10);
		SET @v_dSql += '				GROUP BY A.DIVISION_ID, E.CLASS_NAME, A.ITEM_ID, B.NICK_NAME, D.PJT_STATUS_ID, D.PJT_PROGRESS_STEP_ID, D.PRODUCTION_TYPE                                        ' + char(10);
		SET @v_dSql += '				--, D.MODEL_ID                                                                                                                                                  ' + char(10);
		SET @v_dSql += '				UNION ALL                                                                                                                                                       ' + char(10);
		SET @v_dSql += '				SELECT 	A.DIVISION_ID, C.CLASS_NAME, ''-'' AS ITEM_ID, A.NICK_NAME, A.ITEM_ID AS APPLIED_MODEL, B.PJT_STATUS_ID, B.PJT_PROGRESS_STEP_ID, B.PRODUCTION_TYPE, A.ITEM_ID AS MODEL_ID	' + char(10);
		SET @v_dSql += '				FROM 	SCM_ITEM_M A  WITH(NOLOCK)                                                                                                                              ' + char(10);
		SET @v_dSql += '						LEFT OUTER JOIN FP_PLM_PJT_MODEL_MASTER B  WITH(NOLOCK)                                                                                                 ' + char(10);
		SET @v_dSql += '						ON 	1=1                                                                                                                                                 ' + char(10);
		SET @v_dSql += '						AND A.DIVISION_ID = B.DIVISION_ID                                                                                                                       ' + char(10);
		SET @v_dSql += '						AND A.ITEM_ID     = B.MODEL_ID,                                                                                                                         ' + char(10);
		SET @v_dSql += '						SCM_ITEM_CLASS_M C  WITH(NOLOCK),                                                                                                                       ' + char(10);
		SET @v_dSql += '						SCP_TARGET D  WITH(NOLOCK)                                                                                                                              ' + char(10);
		SET @v_dSql += '				WHERE 1 = (CASE WHEN ISNULL('''+ @p_target_yn +''',''N'') = ''N'' THEN 1 ELSE 0 END)                                                                            ' + char(10);
		SET @v_dSql += '				AND   A.COMPANY_ID  = D.COMPANY_ID                                                                                                                              ' + char(10);
		SET @v_dSql += '				AND   A.DIVISION_ID = D.DIVISION_ID                                                                                                                             ' + char(10);
		SET @v_dSql += '				AND   A.SITE_ID     = D.SITE_ID                                                                                                                                 ' + char(10);
		SET @v_dSql += '				AND   A.ACTIVE_FLAG = ''Y''                                                                                                                                     ' + char(10);
		SET @v_dSql += '				AND   A.ITEM_CLASS  = C.CLASS_ID                                                                                                                                ' + char(10);
		SET @v_dSql += '				AND   D.INSTANCE_ID = '''+ @p_instance_id +'''                                                                                                                  ' + char(10);
		SET @v_dSql += '				AND   C.LEVEL_1_NAME = ''Model''                                                                                                                                ' + char(10);
		SET @v_dSql += '				AND   C.LEVEL_3_NAME LIKE ''%Cell%''                                                                                                                            ' + char(10);
		SET @v_dSql += '				AND   ''A'' = '''+ @p_shop_group_id +'''                                                                                                                        ' + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('D.INSTANCE_ID' , 'EQ', @p_instance_id)) + char(10);
		SET @v_dSql += '				AND   ''A'' = '''+ @p_shop_group_id +'''                                                                                                                        ' + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.CLASS_ID' , 'EQ', @p_item_class_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.CLASS_NAME' , 'LIKE', @p_item_class_name)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_applied_model)) + char(10);
		SET @v_dSql += '				GROUP BY A.DIVISION_ID, C.CLASS_NAME, A.NICK_NAME, A.ITEM_ID, B.PJT_STATUS_ID, B.PJT_PROGRESS_STEP_ID, B.PRODUCTION_TYPE                                        ' + char(10);
		SET @v_dSql += '			) A                                                                                                                                                                 ' + char(10);
		SET @v_dSql += '			LEFT OUTER JOIN (                                                                                                                                                   ' + char(10);
		SET @v_dSql += '								SELECT DISTINCT R.DIVISION_ID                                                                                                                   ' + char(10);
		SET @v_dSql += '								FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK)                                                                                                       ' + char(10);
		SET @v_dSql += '								WHERE  R.USER_ID     = '''+ @p_user_id +'''                                                                                                     ' + char(10);
		SET @v_dSql += '								AND    R.SAVE_FLAG   = ''Y''                                                                                                                    ' + char(10);
		SET @v_dSql += '								AND    R.INSTANCE_ID = '''+ @p_instance_id +'''                                                                                                 ' + char(10);
		SET @v_dSql += '							) R                                                                                                                                                 ' + char(10);
		SET @v_dSql += '			ON   A.DIVISION_ID  = R.DIVISION_ID                                                                                                                                 ' + char(10);
		SET @v_dSql += '	WHERE	1 = 1		                                                                                                                                                        ' + char(10);
		SET @v_dSql += '	ORDER BY 1,3                                                                                                                                                                ' + char(10);
		
	END
	
	IF @p_sys_type = 'SQL'
    BEGIN
		select @v_dSql as [QUERY_VALUE]
    END ELSE BEGIN
		SET @runstart = GetDate()
		BEGIN TRY
		     BEGIN TRAN
	             exec sp_executesql @v_dSql
		     COMMIT TRAN
		END TRY
        BEGIN CATCH
             ROLLBACK
        END CATCH
	    SET @runend = GetDate()
		exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_dSql,'SELECT',@runstart, @runend
    END
	
  
END

