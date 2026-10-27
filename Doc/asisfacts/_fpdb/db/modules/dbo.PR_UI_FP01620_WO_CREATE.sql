

/*
 * Program ID   : PR_UI_FP01620_WO_CREATE
 * Description  : W/O Create
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/02/16   CYS				Initial Release UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FP01620_WO_CREATE]
  @p_sys_type			NVARCHAR(MAX),  
  @p_sys_flag			NVARCHAR(MAX),
  @p_sys_gubun			NVARCHAR(MAX),  
  @p_user_id			NVARCHAR(MAX),

  @p_instance_id		NVARCHAR(MAX),
  @p_plan_id			NVARCHAR(MAX),
  @p_division_id		NVARCHAR(MAX),
  @p_site_id			NVARCHAR(MAX),
  @p_plant_id			NVARCHAR(MAX),
  @p_factory_id			NVARCHAR(MAX),
  @p_operation_id		NVARCHAR(MAX),
  @p_line_id			NVARCHAR(MAX),
  @p_item_id			NVARCHAR(MAX),
  @p_work_order_id		NVARCHAR(MAX),
  @p_from_date			NVARCHAR(MAX),
  @p_to_date			NVARCHAR(MAX),
  @p_target_yn			NVARCHAR(MAX)	

AS 
BEGIN
	
    SET NOCOUNT ON;

	DECLARE @v_proc_name	nvarchar(100) = 'PR_UI_FP01620_WO_CREATE';
	DECLARE @runstart		datetime;
	DECLARE @runend			datetime;
	DECLARE @v_dSql			nvarchar(MAX)='';
	
	BEGIN

		SET	@v_dSql = ''
		SET @v_dSql +=	'	SELECT 	A.*																																					' + char(10) ;								
		SET @v_dSql +=	'	FROM 	(                                                                                                                                                   ' + char(10) ;
		SET @v_dSql +=	'				SELECT A.INSTANCE_ID, A.FP_PLAN_ID, SUBSTRING(A.FP_PLAN_ID,CHARINDEX(''-'', A.FP_PLAN_ID,1)+1,11) AS DISPLAY_PLAN_ID                            ' + char(10) ;
		SET @v_dSql +=	'				    ,A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                                           ' + char(10) ;
		SET @v_dSql +=	'				    ,A.WORK_ORDER_ID, A.ITEM_ID, A.TOP_ITEM_ID, A.OPERATION_ID, A.LINE_ID                                                                       ' + char(10) ;
		SET @v_dSql +=	'				    ,A.WORK_CENTER_ID, A.LANE_QTY                                                                                                               ' + char(10) ;
		SET @v_dSql +=	'				    ,CONVERT(VARCHAR, A.PLAN_DATE, 112) AS PLAN_DATE                                                                                            ' + char(10) ;
		SET @v_dSql +=	'				    ,ROUND(A.PLAN_QTY,0) AS PLAN_QTY, ROUND(A.PLAN_IN_QTY,0) AS PLAN_IN_QTY                                                                     ' + char(10) ;
		SET @v_dSql +=	'				    ,C.OPERATION_NAME                                                                                                                           ' + char(10) ;
		SET @v_dSql +=	'				    ,ISNULL(PD.NICK_NAME, ''-'') AS NICK_NAME, PD.ITEM_CLASS_NAME                                                                               ' + char(10) ;
		SET @v_dSql +=	'				    ,ROUND(A.ROLL_IN_QTY,2) AS ROLL_IN_QTY,ROUND(A.ROLL_OUT_QTY,2) AS ROLL_OUT_QTY                                                              ' + char(10) ;
		SET @v_dSql +=	'				    ,ROUND(A.BATCH_QTY,2) AS BATCH_QTY,ROUND(A.BATCH_SUM_QTY,2) AS BATCH_SUM_QTY                                                                ' + char(10) ;
		SET @v_dSql +=	'				    ,(CASE WHEN EWM.ERP_IF_STATUS=''S'' THEN ''Success''                                                                                        ' + char(10) ;
		SET @v_dSql +=	'				           WHEN EWM.ERP_IF_STATUS=''E'' THEN ''Error''                                                                                          ' + char(10) ;
		SET @v_dSql +=	'				           ELSE ISNULL(EWM.ERP_IF_STATUS,'''') END) AS RETURN_STATUS                                                                                         ' + char(10) ;
		SET @v_dSql +=	'				    ,EWM.FP_IF_RETURN AS ERP_RESULT                                                                                                             ' + char(10) ;
		SET @v_dSql +=	'				    ,EWM.ERP_IF_RETURN AS ERP_MESSAGE                                                                                                           ' + char(10) ;
		SET @v_dSql +=	'				    ,A.PRODUCTION_TYPE, A.MARKET, RE.LINE_NAME, ISNULL(RE.LOCATION,''-'') AS LOCATION,  A.ELECTRODE_TYPE                                        ' + char(10) ;
		SET @v_dSql +=	'				    ,ISNULL(EWM.PUBLISH_TYPE,''Created'') AS PUBLISH_TYPE, EWM.FIRST_TEST_WO, ROUND(ISNULL(EWM.ORG_PLAN_IN_QTY,0),0) AS ORG_PLAN_IN_QTY         ' + char(10) ;
		SET @v_dSql +=	'				    ,(SELECT EPP.ACTUAL_QTY FROM FP_ERP_PRODUCTION_PLAN_M EPP (NOLOCK) WHERE EPP.WORK_ORDER_ID = A.WORK_ORDER_ID  ) AS ACTUAL_QTY               ' + char(10) ;
		SET @v_dSql +=	'				    ,ISNULL(CONVERT(VARCHAR,EWM.UPDATE_TIME,20), CONVERT(VARCHAR,A.INSERT_TIME,20)) AS UPDATE_TIME                                              ' + char(10) ;
		SET @v_dSql +=	'				    ,ISNULL(EWM.UPDATE_ID, A.INSERT_ID) AS UPDATE_ID                                                                                            ' + char(10) ;
		SET @v_dSql +=	'				    ,EWM2.ATTRIBUTE2 AS VD_FIRST_TEST_WO                                                                                                        ' + char(10) ;
		SET @v_dSql +=	'				    , A.WORK_REQUEST_MODEL_ID ' + char(10) ;-- version 추가... 20231114
		--SET @v_dSql +=	'				    , CASE WHEN ''' + @p_instance_id + ''' LIKE ''%CELL%'' THEN A.PLM_EC_NO ' + char(10) ;
		--SET @v_dSql +=	'				           WHEN ''' + @p_instance_id + ''' LIKE ''%E_PRE%'' THEN A.VERSION ' + char(10) ;
		--SET @v_dSql +=	'				    	   ELSE A.VERSION END AS VERSION ' + char(10) ;
		SET @v_dSql +=	'				    , A.PLM_EC_NO, A.VERSION' + char(10) ; -- EC NO, VERSION 분리... 20240131
		SET @v_dSql +=	'				FROM   	FP_PRODUCTION_PLAN_R A WITH(NOLOCK)                                                                                                     ' + char(10) ;
		SET @v_dSql +=	'						INNER JOIN (                                                                                                                            ' + char(10) ;
		SET @v_dSql +=	'						  		SELECT DISTINCT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, B.FACTORY_ID                                                ' + char(10) ;
		SET @v_dSql +=	'						      	FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)                                                                                       ' + char(10) ;
		SET @v_dSql +=	'						      	WHERE  B.USER_ID     = '''+ @p_user_id +'''                                                                                                ' + char(10) ;
		SET @v_dSql +=	'						) B                                                                                                                                     ' + char(10) ;
		SET @v_dSql +=	'						ON     A.COMPANY_ID   = B.COMPANY_ID                                                                                                    ' + char(10) ;
		SET @v_dSql +=	'						AND    A.DIVISION_ID  = B.DIVISION_ID                                                                                                   ' + char(10) ;
		SET @v_dSql +=	'						AND    A.SITE_ID      = B.SITE_ID                                                                                                       ' + char(10) ;
		SET @v_dSql +=	'						AND    A.PLANT_ID     = B.PLANT_ID                                                                                                      ' + char(10) ;
		SET @v_dSql +=	'						AND    A.FACTORY_ID   = B.FACTORY_ID                                                                                                    ' + char(10) ;
		SET @v_dSql +=	'						INNER JOIN SCM_OPERATION_M C WITH(NOLOCK)                                                                                               ' + char(10) ;
		SET @v_dSql +=	'						ON     A.COMPANY_ID   = C.COMPANY_ID                                                                                                    ' + char(10) ;
		SET @v_dSql +=	'						AND    A.DIVISION_ID  = C.DIVISION_ID                                                                                                   ' + char(10) ;
		SET @v_dSql +=	'						AND    A.SITE_ID      = C.SITE_ID                                                                                                       ' + char(10) ;
		SET @v_dSql +=	'						AND    A.OPERATION_ID = C.OPERATION_ID                                                                                                  ' + char(10) ;
		SET @v_dSql +=	'						LEFT OUTER JOIN SCM_ITEM_M PD WITH(NOLOCK)                                                                                              ' + char(10) ;
		SET @v_dSql +=	'						ON     A.COMPANY_ID   = PD.COMPANY_ID                                                                                                   ' + char(10) ;
		SET @v_dSql +=	'						AND    A.DIVISION_ID  = PD.DIVISION_ID                                                                                                  ' + char(10) ;
		SET @v_dSql +=	'						AND    A.SITE_ID      = PD.SITE_ID                                                                                                      ' + char(10) ;
		SET @v_dSql +=	'						AND    A.ITEM_ID      = PD.ITEM_ID                                                                                                      ' + char(10) ;
		SET @v_dSql +=	'						LEFT OUTER JOIN FP_ERP_PRODUCTION_PLAN_H EWM WITH(NOLOCK)                                                                               ' + char(10) ;
		SET @v_dSql +=	'						ON     EWM.WORK_ORDER_ID = A.WORK_ORDER_ID                                                                                              ' + char(10) ;
		SET @v_dSql +=	'						AND    EWM.FP_PLAN_ID    = A.FP_PLAN_ID                                                                                                 ' + char(10) ;
		SET @v_dSql +=	'						LEFT OUTER JOIN FP_ERP_PRODUCTION_PLAN_M EWM2 WITH(NOLOCK)                                                                              ' + char(10) ;
		SET @v_dSql +=	'						ON     EWM2.WORK_ORDER_ID     = A.WORK_ORDER_ID                                                                                         ' + char(10) ;
		SET @v_dSql +=	'						AND    EWM2.UPDATE_FP_PLAN_ID = A.FP_PLAN_ID                                                                                            ' + char(10) ;
		SET @v_dSql +=	'						LEFT OUTER JOIN (                                                                                                                       ' + char(10) ;
		SET @v_dSql +=	'											SELECT 	A.COMPANY_ID,A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID                  			' + char(10) ;
		SET @v_dSql +=	'													, A.LINE_ID , A.LINE_NAME, A.ELECTRODE_TYPE, MAX(A.LOCATION) AS LOCATION                                    ' + char(10) ;
		SET @v_dSql +=	'											FROM 	SCM_LINE_M A WITH(NOLOCK),                                                                                  ' + char(10) ;
		SET @v_dSql +=	'													(                                                                                                           ' + char(10) ;
		SET @v_dSql +=	'														SELECT DISTINCT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, B.FACTORY_ID                        ' + char(10) ;
		SET @v_dSql +=	'														FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)                                                               ' + char(10) ;
		SET @v_dSql +=	'														WHERE  B.USER_ID     = '''+ @p_user_id +'''                                                                        ' + char(10) ;
		SET @v_dSql +=	'													) B                                                                                                         ' + char(10) ;
		SET @v_dSql +=	'											WHERE A.COMPANY_ID  = B.COMPANY_ID                                                                                  ' + char(10) ;
		SET @v_dSql +=	'											AND   A.DIVISION_ID = B.DIVISION_ID                                                                                 ' + char(10) ;
		SET @v_dSql +=	'											AND   A.SITE_ID     = B.SITE_ID                                                                                     ' + char(10) ;
		SET @v_dSql +=	'											AND   A.PLANT_ID    = B.PLANT_ID                                                                                    ' + char(10) ;
		SET @v_dSql +=	'											AND   A.FACTORY_ID  = B.FACTORY_ID                                                                                  ' + char(10) ;
		SET @v_dSql +=	'											AND   A.ACTIVE_FLAG = ''Y''                                                                                         ' + char(10) ;
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10);
		SET @v_dSql +=	'											GROUP BY A.COMPANY_ID,A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID						 	' + char(10) ;
		SET @v_dSql +=	'													 , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE    				                                                ' + char(10) ;
		SET @v_dSql +=	'										) RE                                                                                                                    ' + char(10) ;
		SET @v_dSql +=	'						ON     A.COMPANY_ID     = RE.COMPANY_ID                                                                                                 ' + char(10) ;
		SET @v_dSql +=	'						AND    A.DIVISION_ID    = RE.DIVISION_ID                                                                                                ' + char(10) ;
		SET @v_dSql +=	'						AND    A.SITE_ID        = RE.SITE_ID                                                                                                    ' + char(10) ;
		SET @v_dSql +=	'						AND    A.PLANT_ID       = RE.PLANT_ID                                                                                                   ' + char(10) ;
		SET @v_dSql +=	'						AND    A.FACTORY_ID     = RE.FACTORY_ID                                                                                                 ' + char(10) ;
		SET @v_dSql +=	'						AND    A.OPERATION_ID   = RE.OPERATION_ID                                                                                               ' + char(10) ;
		SET @v_dSql +=	'						AND    A.LINE_ID        = RE.LINE_ID                                                                                                    ' + char(10) ;
		SET @v_dSql +=	'						AND    A.ELECTRODE_TYPE = RE.ELECTRODE_TYPE                                                                                             ' + char(10) ;
		SET @v_dSql +=	'				WHERE 	1=1								                                                                                                         ' + char(10) ;
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_ID' , 'EQ', @p_instance_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FP_PLAN_ID' , 'EQ', @p_plan_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.WORK_ORDER_ID' , 'LIKE', @p_work_order_id)) + char(10);
		SET @v_dSql +=	'				AND   CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @p_from_date +''' AND '''+ @p_to_date +'''                                                ' + char(10) ;
		SET @v_dSql +=	'				AND   	C.WO_FLAG       = ''Y''                                                                                                                 ' + char(10) ;
		SET @v_dSql +=	'			) A                                                                                                                                                 ' + char(10) ;
		SET @v_dSql +=	'	WHERE 	1=1                                                                                                                                                 ' + char(10) ;
		SET @v_dSql +=	'	AND    	EXISTS (                                                                                                                                            ' + char(10) ;
		SET @v_dSql +=	'						SELECT 1                                                                                                                                ' + char(10) ;
		SET @v_dSql +=	'						FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)                                                                                               ' + char(10) ;
		SET @v_dSql +=	'						WHERE  A.COMPANY_ID  = B.COMPANY_ID                                                                                                     ' + char(10) ;
		SET @v_dSql +=	'						AND    A.DIVISION_ID = B.DIVISION_ID                                                                                                    ' + char(10) ;
		SET @v_dSql +=	'						AND    A.SITE_ID     = B.SITE_ID                                                                                                        ' + char(10) ;
		SET @v_dSql +=	'						AND    A.PLANT_ID	 = B.PLANT_ID                                                                                                       ' + char(10) ;
		SET @v_dSql +=	'						AND    A.FACTORY_ID  = B.FACTORY_ID                                                                                                     ' + char(10) ;
		SET @v_dSql +=	'						AND    A.OPERATION_ID = B.OPERATION_ID                                                                                                  ' + char(10) ;
		SET @v_dSql +=	'						AND    A.LINE_ID 	 = B.LINE_ID                                                                                                        ' + char(10) ;
		SET @v_dSql +=	'						AND    B.USER_ID     = '''+ @p_user_id +'''                                                                                                        ' + char(10) ;
		SET @v_dSql +=	'	      			)                                                                                                                                           ' + char(10) ;
		IF	@p_target_yn = 'Y'
			BEGIN
				SET @v_dSql +=	'	AND   A.PUBLISH_TYPE <> ''Keep''                                                                                                                    ' + char(10) ;
			END
		SET @v_dSql +=	'	ORDER BY PLAN_DATE, LINE_ID, TOP_ITEM_ID, OPERATION_ID DESC, ITEM_ID, PRODUCTION_TYPE, MARKET                                                               ' + char(10) ;
	
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

