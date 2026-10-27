

/*
 * Program ID   : PR_UI_FP01630_CLOSE_WORK_ORDER
 * Description  : Close Work Order
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/03/03   CYS				Initial Release UI통합
 * 2023/11/14   LJS             version 추가
 */

CREATE PROCEDURE [dbo].[PR_UI_FP01630_CLOSE_WORK_ORDER]
  @p_sys_type			NVARCHAR(MAX),  
  @p_sys_flag			NVARCHAR(MAX),
  @p_sys_gubun			NVARCHAR(MAX),  
  @p_user_id			NVARCHAR(MAX),

  @p_division_id		NVARCHAR(MAX),
  @p_site_id			NVARCHAR(MAX),
  @p_plant_id			NVARCHAR(MAX),
  @p_factory_id			NVARCHAR(MAX),
  @p_operation_id		NVARCHAR(MAX),
  @p_line_id			NVARCHAR(MAX),
  @p_item_id			NVARCHAR(MAX),
  @p_work_order_id		NVARCHAR(MAX),
  @p_from_date			NVARCHAR(MAX),
  @p_to_date			NVARCHAR(MAX)
  
AS 
BEGIN
	
    SET NOCOUNT ON;

	DECLARE @v_proc_name	nvarchar(100) = 'PR_UI_FP01630_CLOSE_WORK_ORDER';
	DECLARE @runstart		datetime;
	DECLARE @runend			datetime;
	DECLARE @v_dSql			nvarchar(MAX)='';
	
	BEGIN

		SET	@v_dSql = ''

		SET @v_dSql += 'if object_id(''tempdb..#FP_USER_ROLE_INFO_V'') IS NOT NULL ' + char(10)
		SET @v_dSql += '	DROP TABLE #FP_USER_ROLE_INFO_V ' + char(10)
		SET @v_dSql += '' + char(10)
		SET @v_dSql += 'SELECT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID, R.OPERATION_ID, R.LINE_ID, MAX(R.SAVE_FLAG) AS SAVE_FLAG, MIN(INSTANCE_ID) AS INSTANCE_ID ' + char(10)
		SET @v_dSql += 'INTO   #FP_USER_ROLE_INFO_V ' + char(10)
		SET @v_dSql += 'FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK) ' + char(10)
		SET @v_dSql += 'WHERE  1=1 ' + char(10)
		SET @v_dSql += 'AND	  R.USER_ID	= ''' + @p_user_id + ''' ' + char(10)
		SET @v_dSql += 'GROUP BY R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID, R.OPERATION_ID, R.LINE_ID ' + char(10)
		SET @v_dSql += '; ' + char(10)+ char(10)

		SET @v_dSql += '	WITH BASE AS (																																	' + char(10)
		SET @v_dSql += '					  SELECT SITE_ID, MAX(CUTOFF_DATE) AS CUTOFF_DATE                                                                               ' + char(10)
		SET @v_dSql += '					  FROM   FP_MES_WORK_ORDER_STATUS_H A WITH(NOLOCK)                                                                              ' + char(10)
		SET @v_dSql += '					  GROUP BY SITE_ID                                                                                                              ' + char(10)
		SET @v_dSql += '	)                                                                                                                                               ' + char(10)
		SET @v_dSql += '	, FP_PLAN AS (                                                                                                                                  ' + char(10)
		SET @v_dSql += '					  SELECT B.SITE_ID, B.CUTOFF_DATE, P.RELEASE_PLAN_ID                                                                            ' + char(10)
		SET @v_dSql += '					  FROM   DBO.SCM_FP_PLAN_GROUP_DETAIL_H P WITH(NOLOCK)                                                                          ' + char(10)
		SET @v_dSql += '					        ,FP_INSTANCE_FACTORY_M          SIF WITH(NOLOCK)                                                                        ' + char(10)
		SET @v_dSql += '					        ,SCM_FACTORY_M                  F WITH(NOLOCK)                                                                          ' + char(10)
		SET @v_dSql += '					        ,BASE                           B                                                                                       ' + char(10)
		SET @v_dSql += '					  WHERE SIF.FACTORY_ID = F.FACTORY_ID                                                                                           ' + char(10)
		SET @v_dSql += '					  AND   P.INSTANCE_ID  = SIF.INSTANCE_ID                                                                                        ' + char(10)
		SET @v_dSql += '					  AND   P.PLAN_DATE    = CONVERT(NVARCHAR(8), B.CUTOFF_DATE, 112)                                                               ' + char(10)
		SET @v_dSql += '					  AND   F.SITE_ID      = B.SITE_ID                                                                                              ' + char(10)
		SET @v_dSql += '					  UNION                                                                                                                         ' + char(10)
		SET @v_dSql += '					  SELECT B.SITE_ID, B.CUTOFF_DATE, P.RELEASE_PLAN_ID                                                                            ' + char(10)
		SET @v_dSql += '					  FROM   DBO.SCM_FP_PLAN_DETAIL_H       P WITH(NOLOCK)                                                                          ' + char(10)
		SET @v_dSql += '					        ,FP_INSTANCE_FACTORY_M          SIF WITH(NOLOCK)                                                                        ' + char(10)
		SET @v_dSql += '					        ,SCM_FACTORY_M                  F WITH(NOLOCK)                                                                          ' + char(10)
		SET @v_dSql += '					        ,BASE                           B                                                                                       ' + char(10)
		SET @v_dSql += '					  WHERE SIF.FACTORY_ID = F.FACTORY_ID                                                                                           ' + char(10)
		SET @v_dSql += '					  AND   P.INSTANCE_ID  = SIF.INSTANCE_ID                                                                                        ' + char(10)
		SET @v_dSql += '					  AND   P.PLAN_DATE    = CONVERT(NVARCHAR(8), B.CUTOFF_DATE, 112)                                                               ' + char(10)
		SET @v_dSql += '					  AND   F.SITE_ID      = B.SITE_ID                                                                                              ' + char(10)
		SET @v_dSql += '	)                                                                                                                                               ' + char(10)
		SET @v_dSql += '	SELECT A.CHK, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                                  ' + char(10)
		SET @v_dSql += '		   , A.CUTOFF_DATE                                                                                                                          ' + char(10)
		SET @v_dSql += '		   , A.WORK_ORDER_ID                                                                                                                        ' + char(10)
		SET @v_dSql += '		   , A.WORK_ORDER_SPL_ID                                                                                                                    ' + char(10)
		SET @v_dSql += '		   , A.DEMAND_ID, A.PRODUCTION_TYPE, A.ORDER_TYPE                                                                                           ' + char(10)
		SET @v_dSql += '		   , A.ITEM_ID, A.NICK_NAME, A.TOP_ITEM_ID                                                                                                  ' + char(10)
		SET @v_dSql += '		   , A.OPERATION_ID, A.LINE_ID, A.EQUIPMENT_ID                                                                                              ' + char(10)
		SET @v_dSql += '		   , A.PLAN_DATE, A.PLAN_START_TIME, A.PLAN_END_TIME, A.PLAN_QTY                                                                            ' + char(10)
		SET @v_dSql += '		   , A.ACTUAL_GOOD_QTY, A.ACTUAL_QTY, A.ACTUAL_SCRAP_QTY                                                                                    ' + char(10)
		SET @v_dSql += '		   , A.WO_STATUS                                                                                                                            ' + char(10)
		SET @v_dSql += '		   , A.REMAIN_QTY, A.LANE_QTY, A.BATCH_LOT_SIZE                                                                                             ' + char(10)
		SET @v_dSql += '		   , SUBSTRING(A.RELEASE_PLAN, 1 , CHARINDEX(''^'',A.RELEASE_PLAN)-1) AS RELEASE_PLAN                                                       ' + char(10)
		SET @v_dSql += '		   , SUBSTRING(A.RELEASE_PLAN, CHARINDEX(''^'',A.RELEASE_PLAN)+1, 20) AS RELEASE_DATE                                                       ' + char(10)
		SET @v_dSql += '		   , A.ERROR_MSG, A.ERP_MESSAGE                                                                                                             ' + char(10)
		SET @v_dSql += '		   , RE.LINE_NAME                                                                                                                           ' + char(10)
		--SET @v_dSql += '		   , CASE WHEN R.FACTORY_ID IS NULL THEN ''N'' ELSE ''Y'' END EDIT_YN                                                                       ' + char(10)
		SET @v_dSql += '		   , CASE WHEN R.SAVE_FLAG = ''Y'' THEN ''Y'' ELSE ''N'' END AS EDIT_YN ' + char(10)
		SET @v_dSql += '		   , A.WORK_REQUEST_MODEL_ID ' + char(10) -- version 추가... 20231114
		--SET @v_dSql += '		   , CASE WHEN R.INSTANCE_ID LIKE ''%CELL%'' THEN A.PLM_EC_NO ' + char(10)
		--SET @v_dSql += '		          WHEN R.INSTANCE_ID LIKE ''%E_PRE%'' THEN A.VERSION ' + char(10)
		--SET @v_dSql += '		          ELSE A.VERSION END AS VERSION ' + char(10)
		SET @v_dSql += '		   , A.PLM_EC_NO, A.VERSION ' + char(10)
		SET @v_dSql += '	FROM	(                                                                                                                                       ' + char(10)
		SET @v_dSql += '	    		SELECT (CASE WHEN(SELECT TOP 1 E.PROCESSING_YN                                                                                      ' + char(10)
		SET @v_dSql += '	                      FROM   DBO.SCM_MANUAL_WO_CREATE E WITH(NOLOCK) ' + char(10)
		SET @v_dSql += '	                      WHERE  E.WO_BASE_DATE >= CONVERT(VARCHAR(8), A.CUTOFF_DATE, 112)                                                          ' + char(10)
		SET @v_dSql += '	                      AND    E.WO_ID         = A.WORK_ORDER_ID                                                                                  ' + char(10)
		SET @v_dSql += '	                      AND    E.MO_ID         = A.WORK_ORDER_SPL_ID                                                                              ' + char(10)
		SET @v_dSql += '	                      AND    E.ITEM_ID       = A.ITEM_ID                                                                                        ' + char(10)
		SET @v_dSql += '	                      AND    E.OPERATION_ID  = A.OPERATION_ID                                                                                   ' + char(10)
		SET @v_dSql += '	                      ORDER BY E.PROCESSING_YN) = ''N'' THEN 1 ELSE 0 END) AS CHK                                                               ' + char(10)
		SET @v_dSql += '			          , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                            ' + char(10)
		SET @v_dSql += '			          , CONVERT(VARCHAR, A.CUTOFF_DATE, 112) AS CUTOFF_DATE                                                                         ' + char(10)
		SET @v_dSql += '			          , A.WORK_ORDER_ID                                                                                                             ' + char(10)
		SET @v_dSql += '			          , A.WORK_ORDER_SPL_ID                                                                                                         ' + char(10)
		SET @v_dSql += '			          , A.DEMAND_ID, A.PRODUCTION_TYPE, A.ORDER_TYPE                                                                                ' + char(10)
		SET @v_dSql += '			          , A.ITEM_ID, ISNULL(C.NICK_NAME,''-'') AS NICK_NAME                                                                           ' + char(10)
		SET @v_dSql += '			          , A.TOP_ITEM_ID                                                                                                               ' + char(10)
		SET @v_dSql += '			          , A.OPERATION_ID, A.LINE_ID, A.EQUIPMENT_ID                                                                                   ' + char(10)
		SET @v_dSql += '			          , CONVERT(VARCHAR, A.PLAN_DATE, 20) AS PLAN_DATE                                                                              ' + char(10)
		SET @v_dSql += '			          , CONVERT(VARCHAR, A.PLAN_START_TIME, 20) AS PLAN_START_TIME                                                                  ' + char(10)
		SET @v_dSql += '			          , CONVERT(VARCHAR, A.PLAN_END_TIME, 20) AS PLAN_END_TIME                                                                      ' + char(10)
		SET @v_dSql += '			          , A.PLAN_QTY                                                                                                                  ' + char(10)
		SET @v_dSql += '			          , A.ACTUAL_GOOD_QTY, A.ACTUAL_QTY, A.ACTUAL_SCRAP_QTY                                                                         ' + char(10)
		SET @v_dSql += '			          , A.WO_STATUS                                                                                                                 ' + char(10)
		SET @v_dSql += '			          , (ISNULL(A.PLAN_QTY,0) - ISNULL(A.ACTUAL_QTY,0)) AS REMAIN_QTY                                                               ' + char(10)
		SET @v_dSql += '			          , (SELECT TOP 1 B.MAIN_LANE_QTY                                                                                               ' + char(10)
		SET @v_dSql += '			             FROM   SCM_ITEM_LANE_M B WITH(NOLOCK)                                                                                      ' + char(10)
		SET @v_dSql += '			             WHERE  B.COMPANY_ID    = A.COMPANY_ID                                                                                      ' + char(10)
		SET @v_dSql += '			             AND    B.DIVISION_ID   = A.DIVISION_ID                                                                                     ' + char(10)
		SET @v_dSql += '			             AND    B.SITE_ID       = A.SITE_ID                                                                                         ' + char(10)
		SET @v_dSql += '			             AND    B.PLANT_ID      = A.PLANT_ID                                                                                        ' + char(10)
		SET @v_dSql += '			             AND    B.FACTORY_ID    = A.FACTORY_ID                                                                                      ' + char(10)
		SET @v_dSql += '			             AND    B.ITEM_ID       = A.ITEM_ID                                                                                         ' + char(10)
		SET @v_dSql += '			             AND    B.ACTIVE_FLAG   = ''Y''                                                                                             ' + char(10)
		SET @v_dSql += '			             ORDER BY B.MAIN_LANE_QTY DESC ) AS LANE_QTY                                                                                ' + char(10)
		SET @v_dSql += '			          , (SELECT TOP 1 C.BATCH_LOT_SIZE                                                                                              ' + char(10)
		SET @v_dSql += '			             FROM   SCM_ITEM_EQUIP_RATE_BATCH_M C WITH(NOLOCK)                                                                          ' + char(10)
		SET @v_dSql += '			             WHERE  C.COMPANY_ID    = A.COMPANY_ID                                                                                      ' + char(10)
		SET @v_dSql += '			             AND    C.DIVISION_ID   = A.DIVISION_ID                                                                                     ' + char(10)
		SET @v_dSql += '			             AND    C.SITE_ID       = A.SITE_ID                                                                                         ' + char(10)
		SET @v_dSql += '			             AND    C.PLANT_ID      = A.PLANT_ID                                                                                        ' + char(10)
		SET @v_dSql += '			             AND    C.FACTORY_ID    = A.FACTORY_ID                                                                                      ' + char(10)
		SET @v_dSql += '			             AND    C.OPERATION_ID  = A.OPERATION_ID                                                                                    ' + char(10)
		SET @v_dSql += '			             AND    C.ITEM_ID       = A.ITEM_ID                                                                                         ' + char(10)
		SET @v_dSql += '			             AND    C.ACTIVE_FLAG   = ''Y'') AS BATCH_LOT_SIZE                                                                          ' + char(10)
		SET @v_dSql += '			          , (SELECT TOP 1 RELEASE_PLAN_ID + ''^'' + CONVERT( VARCHAR(20), INSERT_TIME, 120)                                             ' + char(10)
		SET @v_dSql += '			             FROM   FP_RELEASE_FIX_PLAN_H D WITH(NOLOCK)                                                                                ' + char(10)
		SET @v_dSql += '			             WHERE  D.WORK_ORDER_ID  = A.WORK_ORDER_ID                                                                                  ' + char(10)
		SET @v_dSql += '			             AND    D.ITEM_ID        = A.ITEM_ID                                                                                        ' + char(10)
		SET @v_dSql += '			             AND    D.OPERATION_ID   = A.OPERATION_ID                                                                                   ' + char(10)
		SET @v_dSql += '			             ORDER  BY D.INSERT_TIME DESC) AS RELEASE_PLAN                                                                              ' + char(10)
		SET @v_dSql += '			          , (SELECT TOP 1 E.ERROR_MSG                                                                                                   ' + char(10)
		SET @v_dSql += '			             FROM   SCM_MANUAL_WO_CREATE E WITH(NOLOCK)                                                                                 ' + char(10)
		SET @v_dSql += '			             WHERE  E.WO_BASE_DATE >= CONVERT(VARCHAR(8), A.CUTOFF_DATE, 112)                                                           ' + char(10)
		SET @v_dSql += '			             AND    E.WO_ID         = A.WORK_ORDER_ID                                                                                   ' + char(10)
		SET @v_dSql += '			             AND    E.MO_ID         = A.WORK_ORDER_SPL_ID                                                                               ' + char(10)
		SET @v_dSql += '			             AND    E.ITEM_ID       = A.ITEM_ID                                                                                         ' + char(10)
		SET @v_dSql += '			             AND    E.OPERATION_ID  = A.OPERATION_ID                                                                                    ' + char(10)
		SET @v_dSql += '			             ORDER BY E.UPDATE_DATE DESC) AS ERROR_MSG                                                                                  ' + char(10)
		SET @v_dSql += '			          , (SELECT TOP 1 F.ERP_IF_RETURN                                                                                               ' + char(10)
		SET @v_dSql += '			             FROM   FP_ERP_PRODUCTION_PLAN_M F WITH(NOLOCK)                                                                             ' + char(10)
		SET @v_dSql += '			             WHERE  F.WORK_ORDER_ID = A.WORK_ORDER_ID                                                                                   ' + char(10)
		SET @v_dSql += '			             AND    F.UPDATE_TIME   > A.CUTOFF_DATE) AS ERP_MESSAGE                                                                     ' + char(10)
		SET @v_dSql += '			          , A.WORK_REQUEST_MODEL_ID, A.VERSION, A.PLM_EC_NO ' + char(10) -- version 추가... 20231114
		SET @v_dSql += '	    		FROM	(                                                                                                                           ' + char(10)
		SET @v_dSql += '			    			SELECT A.COMPANY_ID                                                                                                     ' + char(10)
		SET @v_dSql += '				                   ,A.DIVISION_ID                                                                                                   ' + char(10)
		SET @v_dSql += '				                   ,A.SITE_ID                                                                                                       ' + char(10)
		SET @v_dSql += '				                   ,A.PLANT_ID                                                                                                      ' + char(10)
		SET @v_dSql += '				                   ,A.FACTORY_ID                                                                                                    ' + char(10)
		SET @v_dSql += '				                   ,A.CUTOFF_DATE                                                                                                   ' + char(10)
		SET @v_dSql += '				                   ,A.WORK_ORDER_ID                                                                                                 ' + char(10)
		SET @v_dSql += '				                   ,A.WORK_ORDER_SPL_ID                                                                                             ' + char(10)
		SET @v_dSql += '				                   ,A.DEMAND_ID                                                                                                     ' + char(10)
		SET @v_dSql += '				                   ,A.PRODUCTION_TYPE                                                                                               ' + char(10)
		SET @v_dSql += '				                   ,A.ORDER_TYPE                                                                                                    ' + char(10)
		SET @v_dSql += '				                   ,A.ITEM_ID                                                                                                       ' + char(10)
		SET @v_dSql += '				                   ,A.TOP_ITEM_ID                                                                                                   ' + char(10)
		SET @v_dSql += '				                   ,A.OPERATION_ID                                                                                                  ' + char(10)
		SET @v_dSql += '				                   ,A.LINE_ID                                                                                                       ' + char(10)
		SET @v_dSql += '				                   ,A.EQUIPMENT_ID                                                                                                  ' + char(10)
		SET @v_dSql += '				                   ,A.PLAN_DATE                                                                                                     ' + char(10)
		SET @v_dSql += '				                   ,A.PLAN_START_TIME                                                                                               ' + char(10)
		SET @v_dSql += '				                   ,A.PLAN_END_TIME                                                                                                 ' + char(10)
		SET @v_dSql += '				                   ,A.PLAN_QTY                                                                                                      ' + char(10)
		SET @v_dSql += '				                   ,A.ACTUAL_GOOD_QTY                                                                                               ' + char(10)
		SET @v_dSql += '				                   ,A.ACTUAL_QTY                                                                                                    ' + char(10)
		SET @v_dSql += '				                   ,A.ACTUAL_SCRAP_QTY                                                                                              ' + char(10)
		SET @v_dSql += '				                   ,A.WO_STATUS                                                                                                     ' + char(10)
		SET @v_dSql += '				                   ,A.WORK_REQUEST_MODEL_ID, A.VERSION, A.PLM_EC_NO ' + char(10) -- version 추가... 20231114
		SET @v_dSql += '			             	FROM   FP_MES_WORK_ORDER_STATUS_H A WITH(NOLOCK)                                                                        ' + char(10)
		SET @v_dSql += '						             INNER JOIN BASE B                                                                                              ' + char(10)
		SET @v_dSql += '						             ON     A.SITE_ID     = B.SITE_ID                                                                               ' + char(10)
		SET @v_dSql += '						             AND    A.CUTOFF_DATE = B.CUTOFF_DATE                                                                           ' + char(10)
		SET @v_dSql += '							WHERE  NOT EXISTS (	SELECT 1                                                                                            ' + char(10)
		SET @v_dSql += '												FROM   FP_MES_PRODUCTION_PLAN_M M WITH(NOLOCK)                                                      ' + char(10)
		SET @v_dSql += '												   		,FP_PLAN F                                                                                  ' + char(10)
		SET @v_dSql += '												WHERE  M.UPDATE_FP_PLAN_ID = F.RELEASE_PLAN_ID                                                      ' + char(10)
		SET @v_dSql += '												AND    M.WORK_ORDER_ID     = A.WORK_ORDER_ID                                                        ' + char(10)
		SET @v_dSql += '												AND    M.WORK_ORDER_SPL_ID = A.WORK_ORDER_SPL_ID )                                                  ' + char(10)
		SET @v_dSql += '							UNION ALL                                                                                                               ' + char(10)
		SET @v_dSql += '							SELECT A.COMPANY_ID                                                                                                     ' + char(10)
		SET @v_dSql += '									,A.DIVISION_ID                                                                                                  ' + char(10)
		SET @v_dSql += '									,A.SITE_ID                                                                                                      ' + char(10)
		SET @v_dSql += '									,A.PLANT_ID                                                                                                     ' + char(10)
		SET @v_dSql += '									,A.FACTORY_ID                                                                                                   ' + char(10)
		SET @v_dSql += '									,F.CUTOFF_DATE                                                                                                  ' + char(10)
		SET @v_dSql += '									,A.WORK_ORDER_ID                                                                                                ' + char(10)
		SET @v_dSql += '									,A.WORK_ORDER_SPL_ID                                                                                            ' + char(10)
		SET @v_dSql += '									,A.WORK_ORDER_ID   AS DEMAND_ID                                                                                 ' + char(10)
		SET @v_dSql += '									,A.PRODUCTION_TYPE                                                                                              ' + char(10)
		SET @v_dSql += '									,A.ORDER_TYPE+ ''O'' AS ORDER_TYPE                                                                              ' + char(10)
		SET @v_dSql += '									,A.ITEM_ID                                                                                                      ' + char(10)
		SET @v_dSql += '									,A.ATTRIBUTE4      AS TOP_ITEM_ID                                                                               ' + char(10)
		SET @v_dSql += '									,A.OPERATION_ID                                                                                                 ' + char(10)
		SET @v_dSql += '									,A.LINE_ID                                                                                                      ' + char(10)
		SET @v_dSql += '									,A.EQUIPMENT_ID                                                                                                 ' + char(10)
		SET @v_dSql += '									,CONVERT(DATETIME,A.ATTRIBUTE2,120) AS PLAN_DATE                                                                ' + char(10)
		SET @v_dSql += '									,A.START_TIME                                                                                                   ' + char(10)
		SET @v_dSql += '									,A.END_TIME                                                                                                     ' + char(10)
		SET @v_dSql += '									,A.PLAN_QTY                                                                                                     ' + char(10)
		SET @v_dSql += '									,A.ACTUAL_GOOD_QTY                                                                                              ' + char(10)
		SET @v_dSql += '									,A.ACTUAL_QTY                                                                                                   ' + char(10)
		SET @v_dSql += '									,A.ACTUAL_SCRAP_QTY                                                                                             ' + char(10)
		SET @v_dSql += '									,A.WO_STATUS                                                                                                    ' + char(10)
		SET @v_dSql += '									,A.WORK_REQUEST_MODEL_ID, A.VERSION, A.PLM_EC_NO ' + char(10) -- version 추가... 20231114
		SET @v_dSql += '							FROM   	FP_MES_PRODUCTION_PLAN_M A WITH(NOLOCK)                                                                         ' + char(10)
		SET @v_dSql += '									INNER JOIN FP_PLAN F                                                                                            ' + char(10)
		SET @v_dSql += '									ON     A.SITE_ID = F.SITE_ID                                                                                    ' + char(10)
		SET @v_dSql += '									AND    A.UPDATE_FP_PLAN_ID = F.RELEASE_PLAN_ID                                                                  ' + char(10)
		SET @v_dSql += '							WHERE  A.ORDER_TYPE = ''W''                                                                                             ' + char(10)
		SET @v_dSql += '						) A                                                                                                                         ' + char(10)
		SET @v_dSql += '						LEFT OUTER JOIN SCM_ITEM_M C WITH(NOLOCK) ' + char(10)
		SET @v_dSql += '						ON      A.COMPANY_ID  = C.COMPANY_ID                                                                                        ' + char(10)
		SET @v_dSql += '						AND     A.DIVISION_ID = C.DIVISION_ID                                                                                       ' + char(10)
		SET @v_dSql += '						AND     A.SITE_ID     = C.SITE_ID                                                                                           ' + char(10)
		SET @v_dSql += '						AND     A.ITEM_ID     = C.ITEM_ID                                                                                           ' + char(10)
		SET @v_dSql += '				WHERE   CONVERT(VARCHAR, A.PLAN_END_TIME, 112)    >= '''+ @p_from_date +'''                                                         ' + char(10)
		SET @v_dSql += '				AND     CONVERT(VARCHAR, A.PLAN_START_TIME, 112)  <= '''+ @p_to_date +'''                                                           ' + char(10)
		SET @v_dSql += '				AND     A.WO_STATUS <> ''CLOSE''                                                                                                    ' + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.WORK_ORDER_ID' , 'LIKE', @p_work_order_id)) + char(10)
		SET @v_dSql += '			) A                                                                                                                                     ' + char(10)
		SET @v_dSql += '			LEFT OUTER JOIN (                                                                                                                       ' + char(10)
		SET @v_dSql += '							    SELECT 	A.COMPANY_ID,A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.LINE_NAME     ' + char(10)
		SET @v_dSql += '							    FROM 	SCM_LINE_M A WITH(NOLOCK)                                                                                  ' + char(10)
		/*
		SET @v_dSql += '							    		, (                                                                                                           ' + char(10)
		SET @v_dSql += '									        SELECT DISTINCT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, B.FACTORY_ID                        ' + char(10)
		SET @v_dSql += '									      	FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)                                                               ' + char(10)
		SET @v_dSql += '									      	WHERE  B.USER_ID     = '''+ @p_user_id +'''                                                             ' + char(10)
		SET @v_dSql += '							    		) B                                                                                                         ' + char(10)
		SET @v_dSql += '								WHERE A.COMPANY_ID  = B.COMPANY_ID                                                                                  ' + char(10)
		SET @v_dSql += '								AND   A.DIVISION_ID = B.DIVISION_ID                                                                                 ' + char(10)
		SET @v_dSql += '								AND   A.SITE_ID     = B.SITE_ID                                                                                     ' + char(10)
		SET @v_dSql += '								AND   A.PLANT_ID    = B.PLANT_ID                                                                                    ' + char(10)
		SET @v_dSql += '								AND   A.FACTORY_ID  = B.FACTORY_ID                                                                                  ' + char(10)
		*/
		SET @v_dSql += '								WHERE 1=1 ' + char(10)
		SET @v_dSql += '								AND   A.ACTIVE_FLAG = ''Y''                                                                                         ' + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SET @v_dSql += '								GROUP BY A.COMPANY_ID,A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.LINE_NAME    ' + char(10)
		SET @v_dSql += '			) RE                                                                                                                                    ' + char(10)
		SET @v_dSql += '			ON     A.COMPANY_ID   = RE.COMPANY_ID                                                                                                   ' + char(10)
		SET @v_dSql += '			AND    A.DIVISION_ID  = RE.DIVISION_ID                                                                                                  ' + char(10)
		SET @v_dSql += '			AND    A.SITE_ID      = RE.SITE_ID                                                                                                      ' + char(10)
		SET @v_dSql += '			AND    A.PLANT_ID     = RE.PLANT_ID                                                                                                     ' + char(10)
		SET @v_dSql += '			AND    A.FACTORY_ID   = RE.FACTORY_ID                                                                                                   ' + char(10)
		SET @v_dSql += '			AND    A.OPERATION_ID = RE.OPERATION_ID                                                                                                 ' + char(10)
		SET @v_dSql += '			AND    A.LINE_ID      = RE.LINE_ID                                                                                                      ' + char(10)
		--SET @v_dSql += '			LEFT OUTER JOIN (                                                                                                                       ' + char(10)
		--SET @v_dSql += '								SELECT	DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID, R.OPERATION_ID, R.LINE_ID        ' + char(10)
		--SET @v_dSql += '								FROM	FP_USER_ROLE_INFO_V R WITH(NOLOCK)                                                                          ' + char(10)
		--SET @v_dSql += '								WHERE	1=1                                                                                                         ' + char(10)
		--SET @v_dSql += '								AND		R.USER_ID	= '''+ @p_user_id +'''                                                                          ' + char(10)
		--SET @v_dSql += '								AND		R.SAVE_FLAG	= ''Y''                                                                                         ' + char(10)
		--SET @v_dSql += '			) R                                                                                                                                     ' + char(10)
		SET @v_dSql += '			INNER HASH JOIN #FP_USER_ROLE_INFO_V R WITH(NOLOCK) ' + char(10)
		SET @v_dSql += '			ON		1=1                                                                                                                             ' + char(10)
		SET @v_dSql += '			AND		A.COMPANY_ID		= R.COMPANY_ID                                                                                              ' + char(10)
		SET @v_dSql += '			AND		A.DIVISION_ID		= R.DIVISION_ID                                                                                             ' + char(10)
		SET @v_dSql += '			AND		A.SITE_ID			= R.SITE_ID                                                                                                 ' + char(10)
		SET @v_dSql += '			AND		A.PLANT_ID			= R.PLANT_ID                                                                                                ' + char(10)
		SET @v_dSql += '			AND		A.FACTORY_ID		= R.FACTORY_ID                                                                                              ' + char(10)
		SET @v_dSql += '			AND		A.OPERATION_ID		= R.OPERATION_ID                                                                                            ' + char(10)
		SET @v_dSql += '			AND		A.LINE_ID			= R.LINE_ID                                                                                                 ' + char(10)
		SET @v_dSql += '	WHERE 1=1                                                                                                                                       ' + char(10)
		--SET @v_dSql += '	AND    EXISTS (                                                                                                                                 ' + char(10)
		--SET @v_dSql += '			        	SELECT 1                                                                                                                    ' + char(10)
		--SET @v_dSql += '			        	FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)                                                                                   ' + char(10)
		--SET @v_dSql += '			        	WHERE  A.COMPANY_ID  = B.COMPANY_ID                                                                                         ' + char(10)
		--SET @v_dSql += '			        	AND    A.DIVISION_ID = B.DIVISION_ID                                                                                        ' + char(10)
		--SET @v_dSql += '			        	AND    A.SITE_ID     = B.SITE_ID                                                                                            ' + char(10)
		--SET @v_dSql += '			        	AND    A.PLANT_ID	 = B.PLANT_ID                                                                                           ' + char(10)
		--SET @v_dSql += '			        	AND    A.FACTORY_ID  = B.FACTORY_ID                                                                                         ' + char(10)
		--SET @v_dSql += '			        	AND    A.OPERATION_ID = B.OPERATION_ID                                                                                      ' + char(10)
		--SET @v_dSql += '			        	AND    A.LINE_ID 	 = B.LINE_ID                                                                                            ' + char(10)
		--SET @v_dSql += '			        	AND    B.USER_ID     = '''+ @p_user_id +'''                                                                                 ' + char(10)
		--SET @v_dSql += '		      	  )                                                                                                                                 ' + char(10)
		SET @v_dSql += '	ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.CUTOFF_DATE, A.OPERATION_ID, A.LINE_ID, A.ITEM_ID                  ' + char(10)+ char(10)

		SET @v_dSql += 'if object_id(''tempdb..#FP_USER_ROLE_INFO_V'') IS NOT NULL ' + char(10)
		SET @v_dSql += '	DROP TABLE #FP_USER_ROLE_INFO_V ' + char(10)+ char(10)
			
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

