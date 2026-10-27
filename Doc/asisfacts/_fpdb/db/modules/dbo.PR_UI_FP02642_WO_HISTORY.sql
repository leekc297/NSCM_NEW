

/*
 * Program ID   : PR_UI_FP02642_WO_HISTORY
 * Description  : W/O History
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/03/02   CYS				Initial Release UI통합
 * 2026/07/16   kimcd           E20260629-000238 WO history UI 오류 수정. 생산 버전을 계획 FP_PLAN_ID 기준으로 조회하도록 보완
 */

CREATE PROCEDURE [dbo].[PR_UI_FP02642_WO_HISTORY]
  @p_sys_type			NVARCHAR(MAX),  
  @p_sys_flag			NVARCHAR(MAX),
  @p_sys_gubun			NVARCHAR(MAX),  
  @p_user_id			NVARCHAR(MAX),

  @p_instance_id		NVARCHAR(MAX),
  @p_division_id		NVARCHAR(MAX),
  @p_site_id			NVARCHAR(MAX),
  @p_plant_id			NVARCHAR(MAX),
  @p_factory_id			NVARCHAR(MAX),
  @p_operation_id		NVARCHAR(MAX),
  @p_line_id			NVARCHAR(MAX),
  @p_top_item_id		NVARCHAR(MAX),
  @p_item_id			NVARCHAR(MAX),
  @p_work_order_id		NVARCHAR(MAX),
  @p_from_date			NVARCHAR(MAX),
  @p_to_date			NVARCHAR(MAX),
  @p_update_from_date	NVARCHAR(MAX),
  @p_update_to_date		NVARCHAR(MAX),
  @p_prod_type			NVARCHAR(MAX),	
  @p_status				NVARCHAR(MAX)

AS 
BEGIN
	
    SET NOCOUNT ON;

	DECLARE @v_proc_name	nvarchar(100) = 'PR_UI_FP02642_WO_HISTORY';
	DECLARE @runstart		datetime;
	DECLARE @runend			datetime;
	DECLARE @v_dSql			nvarchar(MAX)='';
	
--DECLARE @PARAMS NVARCHAR(MAX)

--SET @PARAMS = ''
--SET @PARAMS += '@P_SYS_TYPE=' +ISNULL(@P_SYS_TYPE,'') +CHAR(10)
--SET @PARAMS += '@P_SYS_FLAG=' +ISNULL(@P_SYS_FLAG,'') +CHAR(10)
--SET @PARAMS += '@P_SYS_GUBUN=' +ISNULL(@P_SYS_GUBUN,'') +CHAR(10)
--SET @PARAMS += '@P_USER_ID=' +ISNULL(@P_USER_ID,'') +CHAR(10)
--SET @PARAMS += '@p_instance_id=' +ISNULL(@p_instance_id,'') +CHAR(10)
--SET @PARAMS += '@p_division_id=' +ISNULL(@p_division_id,'') +CHAR(10)
--SET @PARAMS += '@p_site_id=' +ISNULL(@p_site_id,'') +CHAR(10)
--SET @PARAMS += '@p_plant_id=' +ISNULL(@p_plant_id,'') +CHAR(10)
--SET @PARAMS += '@p_factory_id=' +ISNULL(@p_factory_id,'') +CHAR(10)
--SET @PARAMS += '@p_operation_id=' +ISNULL(@p_operation_id,'') +CHAR(10)
--SET @PARAMS += '@p_line_id=' +ISNULL(@p_line_id,'') +CHAR(10)
--SET @PARAMS += '@p_top_item_id=' +ISNULL(@p_top_item_id,'') +CHAR(10)
--SET @PARAMS += '@p_item_id=' +ISNULL(@p_item_id,'') +CHAR(10)
--SET @PARAMS += '@p_work_order_id=' +ISNULL(@p_work_order_id,'') +CHAR(10)
--SET @PARAMS += '@p_from_date=' +ISNULL(@p_from_date,'') +CHAR(10)
--SET @PARAMS += '@p_to_date=' +ISNULL(@p_to_date,'') +CHAR(10)
--SET @PARAMS += '@p_update_from_date=' +ISNULL(@p_update_from_date,'') +CHAR(10)
--SET @PARAMS += '@p_update_to_date=' +ISNULL(@p_update_to_date,'') +CHAR(10)
--SET @PARAMS += '@p_prod_type=' +ISNULL(@p_prod_type,'') +CHAR(10)
--SET @PARAMS += '@p_status=' +ISNULL(@p_status,'') +CHAR(10)

--SELECT @PARAMS AS SQL
--RETURN

	BEGIN

		SET	@v_dSql = ''

		SET @v_dSql +=	'	IF object_id(''tempdb.dbo.#FP_USER_ROLE_INFO_V_TEMP'') is not null DROP TABLE #FP_USER_ROLE_INFO_V_TEMP;                            ' + char(10)
		SET @v_dSql +=	'	SELECT DISTINCT  B.COMPANY_ID ,B.DIVISION_ID,B.SITE_ID,B.PLANT_ID ,B.FACTORY_ID INTO #FP_USER_ROLE_INFO_V_TEMP                      ' + char(10)
		SET @v_dSql +=	'	FROM FP_USER_ROLE_INFO_V B WHERE B.USER_ID = '''+ @p_user_id +''' ;                                                                 ' + char(10)


		SET @v_dSql +=	'	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                  											' + char(10)
		SET @v_dSql +=	'		   , A.WORK_ORDER_ID, A.ITEM_ID, A.TOP_ITEM_ID, A.OPERATION_ID, A.LINE_ID                                                       ' + char(10)
		SET @v_dSql +=	'		   , A.WORK_CENTER_ID, A.LANE_QTY                                                                                               ' + char(10)
		SET @v_dSql +=	'		   , CONVERT(VARCHAR, A.PLAN_DATE, 112) AS PLAN_DATE                                                                            ' + char(10)
		SET @v_dSql +=	'		   , ROUND(A.PLAN_QTY,0) AS PLAN_QTY, ROUND(A.PLAN_IN_QTY,0) AS PLAN_IN_QTY                                                     ' + char(10)
		SET @v_dSql +=	'		   , C.OPERATION_NAME                                                                                                           ' + char(10)
		SET @v_dSql +=	'		   , ISNULL(PD.NICK_NAME, ''_'') AS NICK_NAME, PD.ITEM_CLASS_NAME                                                               ' + char(10)
		SET @v_dSql +=	'		   , A.FP_PRODUCTION_TYPE, A.MARKET, RE.LINE_NAME, ISNULL(RE.LOCATION,''_'') AS LOCATION,  A.ELECTRODE_TYPE                     ' + char(10)
		SET @v_dSql +=	'		   , A.PUBLISH_TYPE, ROUND(A.ORG_PLAN_IN_QTY,0) AS ORG_PLAN_IN_QTY, PM.FIRST_TEST_WO, PM.ATTRIBUTE2 AS VD_FIRST_TEST_WO         ' + char(10)
		SET @v_dSql +=	'		   , ROUND(PM.ACTUAL_QTY,0) AS ACTUAL_QTY                                                                                       ' + char(10)
		SET @v_dSql +=	'		   , A.INSTANCE_ID, A.FP_PLAN_ID, SUBSTRING(A.FP_PLAN_ID,CHARINDEX(''_'', A.FP_PLAN_ID,1)+1,11) AS DISPLAY_PLAN_ID              ' + char(10)
		SET @v_dSql +=	'		   , A.ERP_IF_STATUS, A.FP_IF_RETURN                                                                                            ' + char(10)
		SET @v_dSql +=	'		   , CONVERT(VARCHAR,A.UPDATE_TIME,20) AS UPDATE_TIME, A.UPDATE_ID                                                              ' + char(10)
		SET @v_dSql +=	'		   , RR.WORK_REQUEST_MODEL_ID, RR.PLM_EC_NO, RR.VERSION ' + char(10) -- version 추가... 20231114
		SET @v_dSql +=	'	FROM   FP_ERP_PRODUCTION_PLAN_H A WITH(NOLOCK)                                                                                      ' + char(10)
		SET @v_dSql +=	'	LEFT OUTER JOIN ( ' + char(10) -- version 추가... 20231114
		SET @v_dSql +=	'		SELECT RR.INSTANCE_ID, RR.FP_PLAN_ID, RR.WORK_ORDER_ID, MAX(WORK_REQUEST_MODEL_ID ) AS WORK_REQUEST_MODEL_ID ' + char(10)  -- 2026/07/16 kimcd E20260629-000238 WO history UI 오류 수정. 생산 버전을 계획 FP_PLAN_ID 기준으로 조회하도록 보완
		--SET @v_dSql +=	'			 , MAX(CASE WHEN ''' + @p_instance_id + ''' LIKE ''%CELL%'' THEN PLM_EC_NO ' + char(10)
		--SET @v_dSql +=	'				        WHEN ''' + @p_instance_id + ''' LIKE ''%E_PRE%'' THEN VERSION ' + char(10)
		--SET @v_dSql +=	'				        ELSE RR.VERSION END) AS VERSION ' + char(10)
		SET @v_dSql += '			 , MAX(PLM_EC_NO) AS PLM_EC_NO, MAX(VERSION) AS VERSION' + char(10)
		SET @v_dSql +=	'		FROM   FP_PRODUCTION_PLAN_R RR WITH(NOLOCK) ' + char(10)
		SET @v_dSql +=	'		WHERE  1=1 ' + char(10)
		SET @v_dSql +=	'		AND    RR.INSTANCE_ID = N''' + @p_instance_id + ''' ' + char(10)
		SET @v_dSql +=	'		AND    CONVERT(VARCHAR, RR.PLAN_DATE, 112) BETWEEN ''' + @p_from_date + ''' AND ''' + @p_to_date + ''' ' + char(10)
		SET @v_dSql +=  '		' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('RR.DIVISION_ID' , 'EQ', @p_division_id))
		SET @v_dSql +=  '		' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('RR.SITE_ID' , 'EQ', @p_site_id))
		SET @v_dSql +=  '		' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('RR.PLANT_ID' , 'EQ', @p_plant_id))
		SET @v_dSql +=  '		' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('RR.FACTORY_ID' , 'EQ', @p_factory_id))
		SET @v_dSql +=  '		' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('RR.OPERATION_ID' , 'EQ', @p_operation_id))
		SET @v_dSql +=  '		' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('RR.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SET @v_dSql +=	'		GROUP BY RR.INSTANCE_ID, RR.FP_PLAN_ID, RR.WORK_ORDER_ID ' + char(10)  -- 2026/07/16 kimcd E20260629-000238 WO history UI 오류 수정. 생산 버전을 계획 FP_PLAN_ID 기준으로 조회하도록 보완
		SET @v_dSql +=	'	) RR ' + char(10)
		SET @v_dSql +=	'	ON  A.INSTANCE_ID = RR.INSTANCE_ID ' + char(10)
		SET @v_dSql +=	'	AND A.FP_PLAN_ID = RR.FP_PLAN_ID ' + char(10)  -- 2026/07/16 kimcd E20260629-000238 WO history UI 오류 수정. 생산 버전을 계획 FP_PLAN_ID 기준으로 조회하도록 보완
		SET @v_dSql +=	'	AND A.WORK_ORDER_ID = RR.WORK_ORDER_ID ' + char(10)
		SET @v_dSql +=	'			LEFT OUTER JOIN FP_ERP_PRODUCTION_PLAN_M PM WITH(NOLOCK)                                                                    ' + char(10)
		SET @v_dSql +=	'			ON PM.WORK_ORDER_ID = A.WORK_ORDER_ID                                                                                       ' + char(10)
		SET @v_dSql +=	'			INNER JOIN #FP_USER_ROLE_INFO_V_TEMP  B                                                                                     ' + char(10)
		--SET @v_dSql +=	'			INNER JOIN (                                                                                                                ' + char(10)
		--SET @v_dSql +=	'						  	SELECT DISTINCT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, B.FACTORY_ID                            ' + char(10)
		--SET @v_dSql +=	'						  	FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)                                                                   ' + char(10)
		--SET @v_dSql +=	'						  	WHERE  B.USER_ID     = '''+ @p_user_id +'''                                                                 ' + char(10)
		--SET @v_dSql +=	'						) B                                                                                                             ' + char(10)
		SET @v_dSql +=	'			ON     A.COMPANY_ID   = B.COMPANY_ID                                                                                        ' + char(10)
		SET @v_dSql +=	'			AND    A.DIVISION_ID  = B.DIVISION_ID                                                                                       ' + char(10)
		SET @v_dSql +=	'			AND    A.SITE_ID      = B.SITE_ID                                                                                           ' + char(10)
		SET @v_dSql +=	'			AND    A.PLANT_ID     = B.PLANT_ID                                                                                          ' + char(10)
		SET @v_dSql +=	'			AND    A.FACTORY_ID   = B.FACTORY_ID                                                                                        ' + char(10)
		SET @v_dSql +=	'			INNER JOIN SCM_OPERATION_M C WITH(NOLOCK)                                                                                   ' + char(10)
		SET @v_dSql +=	'			ON     A.COMPANY_ID   = C.COMPANY_ID                                                                                        ' + char(10)
		SET @v_dSql +=	'			AND    A.DIVISION_ID  = C.DIVISION_ID                                                                                       ' + char(10)
		SET @v_dSql +=	'			AND    A.SITE_ID      = C.SITE_ID                                                                                           ' + char(10)
		SET @v_dSql +=	'			AND    A.OPERATION_ID = C.OPERATION_ID                                                                                      ' + char(10)
		SET @v_dSql +=	'			LEFT OUTER JOIN SCM_ITEM_M PD WITH(NOLOCK)                                                                                  ' + char(10)
		SET @v_dSql +=	'			ON     A.COMPANY_ID   = PD.COMPANY_ID                                                                                       ' + char(10)
		SET @v_dSql +=	'			AND    A.DIVISION_ID  = PD.DIVISION_ID                                                                                      ' + char(10)
		SET @v_dSql +=	'			AND    A.SITE_ID      = PD.SITE_ID                                                                                          ' + char(10)
		SET @v_dSql +=	'			AND    A.ITEM_ID      = PD.ITEM_ID                                                                                          ' + char(10)
		SET @v_dSql +=	'			LEFT OUTER JOIN (                                                                                                           ' + char(10)
		SET @v_dSql +=	'								SELECT 	A.COMPANY_ID,A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID                 ' + char(10)
		SET @v_dSql +=	'										, A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE, MAX(A.LOCATION) AS LOCATION                         ' + char(10)
		SET @v_dSql +=	'								FROM 	SCM_LINE_M A WITH(NOLOCK),                                                                      ' + char(10)
		SET @v_dSql +=	'										(                                                                                               ' + char(10)
		SET @v_dSql +=	'										  	SELECT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, B.FACTORY_ID            ' + char(10)
		--SET @v_dSql +=	'										  	SELECT DISTINCT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, B.FACTORY_ID            ' + char(10)
		--SET @v_dSql +=	'										  	FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)                                                   ' + char(10)
		SET @v_dSql +=	'										  	FROM   #FP_USER_ROLE_INFO_V_TEMP  B                                                         ' + char(10)
		--SET @v_dSql +=	'										  	WHERE  B.USER_ID     = '''+ @p_user_id +'''                                                 ' + char(10)
		SET @v_dSql +=	'										) B                                                                                             ' + char(10)
		SET @v_dSql +=	'								WHERE A.COMPANY_ID  = B.COMPANY_ID                                                                      ' + char(10)
		SET @v_dSql +=	'								AND   A.DIVISION_ID = B.DIVISION_ID                                                                     ' + char(10)
		SET @v_dSql +=	'								AND   A.SITE_ID     = B.SITE_ID                                                                         ' + char(10)
		SET @v_dSql +=	'								AND   A.PLANT_ID    = B.PLANT_ID                                                                        ' + char(10)
		SET @v_dSql +=	'								AND   A.FACTORY_ID  = B.FACTORY_ID                                                                      ' + char(10)
		SET @v_dSql +=	'								AND   A.ACTIVE_FLAG = ''Y''                                                                             ' + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SET @v_dSql +=	'								GROUP BY A.COMPANY_ID,A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                ' + char(10)
		SET @v_dSql +=	'										, A.OPERATION_ID, A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE                                      ' + char(10)
		SET @v_dSql +=	'							) RE                                                                                                        ' + char(10)
		SET @v_dSql +=	'			ON    A.COMPANY_ID      = RE.COMPANY_ID                                                                                     ' + char(10)
		SET @v_dSql +=	'			AND   A.DIVISION_ID     = RE.DIVISION_ID                                                                                    ' + char(10)
		SET @v_dSql +=	'			AND   A.SITE_ID         = RE.SITE_ID                                                                                        ' + char(10)
		SET @v_dSql +=	'			AND   A.PLANT_ID        = RE.PLANT_ID                                                                                       ' + char(10)
		SET @v_dSql +=	'			AND   A.FACTORY_ID      = RE.FACTORY_ID                                                                                     ' + char(10)
		SET @v_dSql +=	'			AND   A.OPERATION_ID    = RE.OPERATION_ID                                                                                   ' + char(10)
		SET @v_dSql +=	'			AND   A.LINE_ID         = RE.LINE_ID                                                                                        ' + char(10)
		SET @v_dSql +=	'			AND   A.ELECTRODE_TYPE  = RE.ELECTRODE_TYPE                                                                                 ' + char(10)
		SET @v_dSql +=	'	WHERE 	1=1                                                                                                                         ' + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_ID' , 'EQ', @p_instance_id)) + char(10)
		SET @v_dSql +=	'	AND   	C.WO_FLAG         = ''Y''                                                                                                   ' + char(10)
		SET @v_dSql +=	'	AND   	CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @p_from_date +''' AND '''+ @p_to_date +'''                                  ' + char(10)
		SET @v_dSql +=	'	AND   	CONVERT(VARCHAR, A.UPDATE_TIME, 112) BETWEEN '''+ @p_update_from_date +''' AND '''+ @p_update_to_date +'''                  ' + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.WORK_ORDER_ID' , 'LIKE', @p_work_order_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ERP_IF_STATUS' , 'EQ', @p_status)) + char(10)
		SET @v_dSql +=	'	AND    EXISTS (                                                                                                                     ' + char(10)
		SET @v_dSql +=	'						SELECT 1                                                                                                        ' + char(10)
		SET @v_dSql +=	'						FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)                                                                       ' + char(10)
		SET @v_dSql +=	'						WHERE  A.COMPANY_ID  = B.COMPANY_ID                                                                             ' + char(10)
		SET @v_dSql +=	'						AND    A.DIVISION_ID = B.DIVISION_ID                                                                            ' + char(10)
		SET @v_dSql +=	'						AND    A.SITE_ID     = B.SITE_ID                                                                                ' + char(10)
		SET @v_dSql +=	'						AND    A.PLANT_ID	 = B.PLANT_ID                                                                               ' + char(10)
		SET @v_dSql +=	'						AND    A.FACTORY_ID  = B.FACTORY_ID                                                                             ' + char(10)
		SET @v_dSql +=	'						AND    A.OPERATION_ID = B.OPERATION_ID                                                                          ' + char(10)
		SET @v_dSql +=	'						AND    A.LINE_ID 	 = B.LINE_ID                                                                                ' + char(10)
		SET @v_dSql +=	'						AND    B.USER_ID     = '''+ @p_user_id +'''                                                                     ' + char(10)
		SET @v_dSql +=	'		      	  )                                                                                                                     ' + char(10)
		SET @v_dSql +=	'	ORDER BY DIVISION_ID, SITE_ID, PLANT_ID, PLAN_DATE DESC, FACTORY_ID,  LOCATION ,LINE_ID                                             ' + char(10)
		SET @v_dSql +=	'			, TOP_ITEM_ID, OPERATION_ID DESC, ITEM_ID, WORK_ORDER_ID, UPDATE_TIME DESC                                                  ' + char(10)
		
		SET @v_dSql +=	'	IF object_id(''tempdb.dbo.#FP_USER_ROLE_INFO_V_TEMP'') is not null DROP TABLE #FP_USER_ROLE_INFO_V_TEMP;                            ' + char(10)
			
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
		--exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_dSql,'SELECT',@runstart, @runend
    END
	
  
END

