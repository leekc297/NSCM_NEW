

/*
 * Program ID   : PR_UI_FP02641_WO_STATUS
 * Description  : W/O History
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/03/05   CYS				Initial Release UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FP02641_WO_STATUS]
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
  @p_prod_type			NVARCHAR(MAX),	
  @p_status				NVARCHAR(MAX)

AS 
BEGIN
	
    SET NOCOUNT ON;

	DECLARE @v_proc_name	nvarchar(100) = 'PR_UI_FP02641_WO_STATUS';
	DECLARE @runstart		datetime;
	DECLARE @runend			datetime;
	DECLARE @v_dSql			nvarchar(MAX)='';
	
	BEGIN

		SET	@v_dSql = ''
		SET @v_dSql += '	SELECT 	A.INSTANCE_ID, A.UPDATE_FP_PLAN_ID, SUBSTRING(A.UPDATE_FP_PLAN_ID, CHARINDEX(''-'', A.UPDATE_FP_PLAN_ID,1)+1,11) AS DISPLAY_PLAN_ID																' + char(10)
		SET @v_dSql += '		    ,A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                                                                                               ' + char(10)
		SET @v_dSql += '		    ,A.WORK_ORDER_ID, A.ITEM_ID, A.TOP_ITEM_ID, A.OPERATION_ID, A.LINE_ID                                                                                                                           ' + char(10)
		SET @v_dSql += '		    ,A.WORK_CENTER_ID, A.LANE_QTY                                                                                                                                                                   ' + char(10)
		SET @v_dSql += '		    ,CONVERT(VARCHAR, A.PLAN_DATE, 112) AS PLAN_DATE                                                                                                                                                ' + char(10)
		SET @v_dSql += '		    ,ROUND(A.PLAN_QTY,0) AS PLAN_QTY, ROUND(A.PLAN_IN_QTY,0) AS PLAN_IN_QTY                                                                                                                         ' + char(10)
		SET @v_dSql += '		    ,C.OPERATION_NAME                                                                                                                                                                               ' + char(10)
		SET @v_dSql += '		    ,ISNULL(PD.NICK_NAME, ''-'') AS NICK_NAME, PD.ITEM_CLASS_NAME                                                                                                                                   ' + char(10)
		SET @v_dSql += '		    ,A.PRODUCTION_TYPE, A.MARKET, RE.LINE_NAME, ISNULL(RE.LOCATION,''-'') AS LOCATION,  A.ELECTRODE_TYPE                                                                                            ' + char(10)
		SET @v_dSql += '		    ,(CASE WHEN A.FIRST_TEST_WO=''Y'' THEN ''true'' ELSE ''false'' END) AS FIRST_TEST_WO                                                                                                                   ' + char(10)
		SET @v_dSql += '		    ,(CASE WHEN A.ATTRIBUTE2=''Y'' THEN ''true'' ELSE ''false'' END) AS VD_FIRST_TEST_WO                                                                                                                   ' + char(10)
		SET @v_dSql += '		    ,(CASE WHEN A.FIRST_TEST_WO=''Y'' THEN ''1'' ELSE ''0'' END) AS FIRST_TEST_WO2                                                                                                                   ' + char(10)
		SET @v_dSql += '		    ,(CASE WHEN A.ATTRIBUTE2=''Y'' THEN ''1'' ELSE ''0'' END) AS VD_FIRST_TEST_WO2                                                                                                                   ' + char(10)
		SET @v_dSql += '		    ,ROUND(A.ACTUAL_QTY,0) AS ACTUAL_QTY                                                                                                                                                            ' + char(10)
		SET @v_dSql += '		    ,ROUND(A.PLAN_IN_QTY,0) - ISNULL(ROUND(A.ACTUAL_QTY,0),0) AS REMAIN_QTY                                                                                                                         ' + char(10)
		SET @v_dSql += '		    ,A.WO_STATUS, CONVERT(VARCHAR,A.UPDATE_TIME,20) AS UPDATE_TIME, A.UPDATE_ID                                                                                                                     ' + char(10)
		SET @v_dSql += '		    ,(CASE WHEN ((CHARINDEX(''CELL'',A.INSTANCE_ID)<>0 OR CHARINDEX(''PACK'',A.INSTANCE_ID)<>0) AND A.PRODUCTION_TYPE=''TEST'') THEN ''Y'' ELSE ''N'' END) IS_FIRST_TEST_WO                         ' + char(10)
		SET @v_dSql += '		    ,(CASE WHEN (CHARINDEX(''CELL'',A.INSTANCE_ID)<>0 AND A.PRODUCTION_TYPE=''TEST'' AND A.OPERATION_ID IN (''A7000'',''A7400'')) THEN ''Y'' ELSE ''N'' END) IS_VD_FIRST_TEST_WO                                   ' + char(10) -- A7400 add
		SET @v_dSql += '		    , CASE WHEN R.FACTORY_ID IS NULL THEN ''N'' ELSE ''Y'' END EDIT_YN                                                                                                                              ' + char(10)
		SET @v_dSql += '		    , RR.WORK_REQUEST_MODEL_ID, RR.PLM_EC_NO, RR.VERSION ' + char(10) -- version 추가... 20231114
		SET @v_dSql += '	FROM   	FP_ERP_PRODUCTION_PLAN_M A WITH(NOLOCK)                                                                                                                                                         ' + char(10)
		SET @v_dSql += '	LEFT OUTER JOIN ( ' + char(10) -- version 추가... 20231114
		SET @v_dSql += '		SELECT WORK_ORDER_ID, MAX(WORK_REQUEST_MODEL_ID ) AS WORK_REQUEST_MODEL_ID ' + char(10)
		--SET @v_dSql += '			 , MAX(CASE WHEN ''' + @p_instance_id + ''' LIKE ''%CELL%'' THEN PLM_EC_NO ' + char(10)
		--SET @v_dSql += '				        WHEN ''' + @p_instance_id + ''' LIKE ''%E_PRE%'' THEN VERSION ' + char(10)
		--SET @v_dSql += '				        ELSE RR.VERSION END) AS VERSION ' + char(10)
		SET @v_dSql += '			 , MAX(PLM_EC_NO) AS PLM_EC_NO, MAX(VERSION) AS VERSION' + char(10)
		SET @v_dSql += '		FROM   FP_PRODUCTION_PLAN_R RR WITH(NOLOCK) ' + char(10)
		SET @v_dSql += '		WHERE  1=1 ' + char(10)
		SET @v_dSql += '		' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('RR.INSTANCE_ID' , 'EQ', @p_instance_id)) + char(10)
		SET @v_dSql += '		AND   CONVERT(VARCHAR, RR.PLAN_DATE, 112) BETWEEN '''+ @p_from_date +''' AND '''+ @p_to_date +''' '
		SET @v_dSql += '		' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('RR.DIVISION_ID' , 'EQ', @p_division_id))
		SET @v_dSql += '		' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('RR.SITE_ID' , 'EQ', @p_site_id))
		SET @v_dSql += '		' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('RR.PLANT_ID' , 'EQ', @p_plant_id))
		SET @v_dSql += '		' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('RR.FACTORY_ID' , 'EQ', @p_factory_id))
		SET @v_dSql += '		' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('RR.OPERATION_ID' , 'EQ', @p_operation_id))
		SET @v_dSql += '		' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('RR.LINE_ID' , 'EQ', @p_line_id))
		SET @v_dSql += '		' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('RR.PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)
		SET @v_dSql +=	'		GROUP BY WORK_ORDER_ID ' + char(10)
		SET @v_dSql += '	) RR ' + char(10)
		SET @v_dSql += '	ON A.WORK_ORDER_ID = RR.WORK_ORDER_ID ' + char(10)
		SET @v_dSql += '			INNER JOIN (                                                                                                                                                                                    ' + char(10)
		SET @v_dSql += '						  	SELECT DISTINCT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, B.FACTORY_ID                                                                                                ' + char(10)
		SET @v_dSql += '						  	FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)                                                                                                                                       ' + char(10)
		SET @v_dSql += '						  	WHERE  B.USER_ID     = '''+ @p_user_id +'''                                                                                                                                     ' + char(10)
		SET @v_dSql += '			) B                                                                                                                                                                                             ' + char(10)
		SET @v_dSql += '			ON     A.COMPANY_ID   = B.COMPANY_ID                                                                                                                                                            ' + char(10)
		SET @v_dSql += '			AND    A.DIVISION_ID  = B.DIVISION_ID                                                                                                                                                           ' + char(10)
		SET @v_dSql += '			AND    A.SITE_ID      = B.SITE_ID                                                                                                                                                               ' + char(10)
		SET @v_dSql += '			AND    A.PLANT_ID     = B.PLANT_ID                                                                                                                                                              ' + char(10)
		SET @v_dSql += '			AND    A.FACTORY_ID   = B.FACTORY_ID                                                                                                                                                            ' + char(10)
		SET @v_dSql += '			INNER JOIN SCM_OPERATION_M C(NOLOCK)                                                                                                                                                            ' + char(10)
		SET @v_dSql += '			ON     A.COMPANY_ID   = C.COMPANY_ID                                                                                                                                                            ' + char(10)
		SET @v_dSql += '			AND    A.DIVISION_ID  = C.DIVISION_ID                                                                                                                                                           ' + char(10)
		SET @v_dSql += '			AND    A.SITE_ID      = C.SITE_ID                                                                                                                                                               ' + char(10)
		SET @v_dSql += '			AND    A.OPERATION_ID = C.OPERATION_ID                                                                                                                                                          ' + char(10)
		SET @v_dSql += '			LEFT OUTER JOIN SCM_ITEM_M PD(NOLOCK)                                                                                                                                                           ' + char(10)
		SET @v_dSql += '			ON     A.COMPANY_ID   = PD.COMPANY_ID                                                                                                                                                           ' + char(10)
		SET @v_dSql += '			AND    A.DIVISION_ID  = PD.DIVISION_ID                                                                                                                                                          ' + char(10)
		SET @v_dSql += '			AND    A.SITE_ID      = PD.SITE_ID                                                                                                                                                              ' + char(10)
		SET @v_dSql += '			AND    A.ITEM_ID      = PD.ITEM_ID                                                                                                                                                              ' + char(10)
		SET @v_dSql += '			LEFT OUTER HASH JOIN (                                                                                                                                                                               ' + char(10)
		SET @v_dSql += '								  SELECT A.COMPANY_ID,A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE, MAX(A.LOCATION) AS LOCATION             ' + char(10)
		SET @v_dSql += '								  FROM 	SCM_LINE_M A WITH(NOLOCK),                                                                                                                                          ' + char(10)
		SET @v_dSql += '								  		(                                                                                                                                                                   ' + char(10)
		SET @v_dSql += '									      	SELECT DISTINCT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, B.FACTORY_ID                                                                                ' + char(10)
		SET @v_dSql += '									      	FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)                                                                                                                       ' + char(10)
		SET @v_dSql += '									      	WHERE  B.USER_ID     = '''+ @p_user_id +'''                                                                                                                     ' + char(10)
		SET @v_dSql += '								  		) B                                                                                                                                                                 ' + char(10)
		SET @v_dSql += '								  WHERE A.COMPANY_ID  = B.COMPANY_ID                                                                                                                                        ' + char(10)
		SET @v_dSql += '								  AND   A.DIVISION_ID = B.DIVISION_ID                                                                                                                                       ' + char(10)
		SET @v_dSql += '								  AND   A.SITE_ID     = B.SITE_ID                                                                                                                                           ' + char(10)
		SET @v_dSql += '								  AND   A.PLANT_ID    = B.PLANT_ID                                                                                                                                          ' + char(10)
		SET @v_dSql += '								  AND   A.FACTORY_ID  = B.FACTORY_ID                                                                                                                                        ' + char(10)
		SET @v_dSql += '								  AND   A.ACTIVE_FLAG = ''Y''                                                                                                                                               ' + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SET @v_dSql += '								  GROUP BY A.COMPANY_ID,A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE                                        ' + char(10)
		SET @v_dSql += '			) RE                                                                                                                                                                                            ' + char(10)
		SET @v_dSql += '			ON    A.COMPANY_ID      = RE.COMPANY_ID                                                                                                                                                         ' + char(10)
		SET @v_dSql += '			AND   A.DIVISION_ID     = RE.DIVISION_ID                                                                                                                                                        ' + char(10)
		SET @v_dSql += '			AND   A.SITE_ID         = RE.SITE_ID                                                                                                                                                            ' + char(10)
		SET @v_dSql += '			AND   A.PLANT_ID        = RE.PLANT_ID                                                                                                                                                           ' + char(10)
		SET @v_dSql += '			AND   A.FACTORY_ID      = RE.FACTORY_ID                                                                                                                                                         ' + char(10)
		SET @v_dSql += '			AND   A.OPERATION_ID    = RE.OPERATION_ID                                                                                                                                                       ' + char(10)
		SET @v_dSql += '			AND   A.LINE_ID         = RE.LINE_ID                                                                                                                                                            ' + char(10)
		SET @v_dSql += '			AND   A.ELECTRODE_TYPE  = RE.ELECTRODE_TYPE                                                                                                                                                     ' + char(10)
		SET @v_dSql += '			LEFT OUTER HASH JOIN (                                                                                                                                                                               ' + char(10)
		SET @v_dSql += '								SELECT	DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID, R.OPERATION_ID, R.LINE_ID                                                                ' + char(10)
		SET @v_dSql += '								FROM	FP_USER_ROLE_INFO_V R WITH(NOLOCK)                                                                                                                                  ' + char(10)
		SET @v_dSql += '								WHERE	1=1                                                                                                                                                                 ' + char(10)
		SET @v_dSql += '								AND		R.USER_ID	= '''+ @p_user_id +'''                                                                                                                                  ' + char(10)
		SET @v_dSql += '								AND		R.SAVE_FLAG	= ''Y''                                                                                                                                                 ' + char(10)
		SET @v_dSql += '			) R                                                                                                                                                                                             ' + char(10)
		SET @v_dSql += '			ON		1=1                                                                                                                                                                                     ' + char(10)
		SET @v_dSql += '			AND		A.COMPANY_ID		= R.COMPANY_ID                                                                                                                                                      ' + char(10)
		SET @v_dSql += '			AND		A.DIVISION_ID		= R.DIVISION_ID                                                                                                                                                     ' + char(10)
		SET @v_dSql += '			AND		A.SITE_ID			= R.SITE_ID                                                                                                                                                         ' + char(10)
		SET @v_dSql += '			AND		A.PLANT_ID			= R.PLANT_ID                                                                                                                                                        ' + char(10)
		SET @v_dSql += '			AND		A.FACTORY_ID		= R.FACTORY_ID                                                                                                                                                      ' + char(10)
		SET @v_dSql += '			AND		A.OPERATION_ID		= R.OPERATION_ID                                                                                                                                                    ' + char(10)
		SET @v_dSql += '			AND		A.LINE_ID			= R.LINE_ID                                                                                                                                                         ' + char(10)
		SET @v_dSql += '	WHERE	1=1																																																' + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_ID' , 'EQ', @p_instance_id)) + char(10)
		SET @v_dSql += '	AND   C.WO_FLAG     = ''Y''                                                                                                                                                                             ' + char(10)
		SET @v_dSql += '	AND   CONVERT(VARCHAR, PLAN_DATE, 112) BETWEEN '''+ @p_from_date +''' AND '''+ @p_to_date +'''                                                                                                          ' + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.WORK_ORDER_ID' , 'LIKE', @p_work_order_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.WO_STATUS' , 'EQ', @p_status)) + char(10)
		SET @v_dSql += '	AND    EXISTS (                                                                                                                                                                                         ' + char(10)
		SET @v_dSql += '		        	SELECT 1                                                                                                                                                                                ' + char(10)
		SET @v_dSql += '		        	FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)                                                                                                                                               ' + char(10)
		SET @v_dSql += '		        	WHERE  A.COMPANY_ID  = B.COMPANY_ID                                                                                                                                                     ' + char(10)
		SET @v_dSql += '		        	AND    A.DIVISION_ID = B.DIVISION_ID                                                                                                                                                    ' + char(10)
		SET @v_dSql += '		        	AND    A.SITE_ID     = B.SITE_ID                                                                                                                                                        ' + char(10)
		SET @v_dSql += '		        	AND    A.PLANT_ID	 = B.PLANT_ID                                                                                                                                                       ' + char(10)
		SET @v_dSql += '		        	AND    A.FACTORY_ID  = B.FACTORY_ID                                                                                                                                                     ' + char(10)
		SET @v_dSql += '		        	AND    A.OPERATION_ID = B.OPERATION_ID                                                                                                                                                  ' + char(10)
		SET @v_dSql += '		        	AND    A.LINE_ID 	 = B.LINE_ID                                                                                                                                                        ' + char(10)
		SET @v_dSql += '		        	AND    B.USER_ID     = '''+ @p_user_id +'''                                                                                                                                                        ' + char(10)
		SET @v_dSql += '		      	)                                                                                                                                                                                           ' + char(10)
		SET @v_dSql += '	ORDER BY DIVISION_ID, SITE_ID, PLANT_ID, PLAN_DATE, FACTORY_ID, LOCATION, LINE_ID, TOP_ITEM_ID, OPERATION_ID DESC, ITEM_ID, ELECTRODE_TYPE                                                                              ' + char(10)

			
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

