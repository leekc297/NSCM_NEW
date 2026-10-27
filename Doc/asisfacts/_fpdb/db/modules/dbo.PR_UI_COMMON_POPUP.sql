

/*
 * Program ID   : PR_UI_COMMON_POPUP
 * Description  : 공통 팝업 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/01/15   				Initial	Release GSCM UI통합
 * 2024/11/01                   [E20241031-001176]Domestic Model Master 화면 Insert 팝업 수정 요청
 */



CREATE PROCEDURE [dbo].[PR_UI_COMMON_POPUP]
	@p_sys_type		    NVARCHAR(MAX),
	@p_sys_flag		    NVARCHAR(MAX),
	@p_sys_gubun	    NVARCHAR(MAX),
	@p_user_id			NVARCHAR(MAX),
	@p_non_auth			NVARCHAR(MAX),
	@p_save_auth		NVARCHAR(MAX),
	@p_param1			NVARCHAR(MAX),
	@p_param2			NVARCHAR(MAX),
	@p_param3			NVARCHAR(MAX),
	@p_param4			NVARCHAR(MAX),
	@p_param5			NVARCHAR(MAX),
	@p_param6			NVARCHAR(MAX),
	@p_param7			NVARCHAR(MAX),
	@p_param8			NVARCHAR(MAX),
	@p_param9			NVARCHAR(MAX),
	@p_param10			NVARCHAR(MAX),
	@p_param11			NVARCHAR(MAX),
	@p_param12			NVARCHAR(MAX),
	@p_param13			NVARCHAR(MAX),
	@p_param14			NVARCHAR(MAX),
	@p_param15			NVARCHAR(MAX),
	@p_param16			NVARCHAR(MAX),
	@p_param17			NVARCHAR(MAX),
	@p_param18			NVARCHAR(MAX),
	@p_param19			NVARCHAR(MAX),
	@p_param20			NVARCHAR(MAX),
	@TimeZone NVARCHAR(MAX) = 'AS054'

AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @v_proc_name      nvarchar(100) = 'PR_UI_COMMON_POPUP';
	DECLARE @runstart datetime;
	DECLARE @runend datetime;
	DECLARE @v_dSql nvarchar(MAX)=''; 
	

	
	
		/****************************************************************************************************************************************/
		/*   Item Popup																															*/
		/*   Param :	@p_param1 - COMPANY_ID / @p_param2 - DIVISION_ID / @p_param3 - SITE_ID / @p_param4 - ITEM_ID / @p_param5 - NICK_NAME	*/
		/*   Param :	@p_param6 - LEVEL_2_CODE_FLAG / @p_param7 - LEVEL_2_CODE / @p_param8 - IS_FORMATION_FLOW_ID_EXISTS / @p_param9 -  / @p_param10 - 	*/
		/****************************************************************************************************************************************/
		IF @p_sys_flag = 'ITEM_POPUP'

			BEGIN
				
				SET @v_dSql = '';
				SET @v_dSql += '	WITH USER_SHOP (COMPANY, DIVISION, SITE)																					' + char(10);
				SET @v_dSql += '	   AS (                                                                                                                     ' + char(10);
				SET @v_dSql += '	        SELECT DISTINCT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID                                                              ' + char(10);
				SET @v_dSql += '	        FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)                                                                           ' + char(10);
				SET @v_dSql += '	        WHERE  B.USER_ID = '''+ @p_user_id +'''                                                                             ' + char(10);
				SET @v_dSql += '	        AND	 B.SAVE_FLAG	  = ''Y''                                                                                       ' + char(10);
				SET @v_dSql += '	      )                                                                                                                     ' + char(10);
				SET @v_dSql += '	SELECT COMPANY_ID, DIVISION_ID, SITE_ID, ITEM_ID, ITEM_NAME, ISNULL(NICK_NAME,''-'') AS NICK_NAME                           ' + char(10);
				SET @v_dSql += '	   , A.FLOW_ID, A.FORMATION_FLOW_ID, A.ITEM_UOM ' + char(10);
				SET @v_dSql += '	FROM   SCM_ITEM_M A WITH(NOLOCK), SCM_ITEM_CLASS_M IC WITH(NOLOCK)                                                          ' + char(10);
				SET @v_dSql += '	WHERE  A.ITEM_CLASS = IC.CLASS_ID                                                                                           ' + char(10);
				SET @v_dSql += '	AND    A.ACTIVE_FLAG = ''Y''                                                                                                ' + char(10);
				SET @v_dSql += '	AND    IC.USE_FLAG = ''Y''                                                                                                  ' + char(10);
				SET @v_dSql += '	AND    EXISTS (SELECT SITE FROM USER_SHOP WHERE COMPANY = A.COMPANY_ID AND DIVISION = A.DIVISION_ID AND SITE = A.SITE_ID)   ' + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.COMPANY_ID' , 'EQ', @p_param1)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_param2)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_param3)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_param4)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.NICK_NAME' , 'LIKE', @p_param5)) + char(10);
				
				IF @p_param6 = 'Y'
					BEGIN
						SET	@v_dSql += '	AND    ( IC.LEVEL_1_NAME  = ''Model'' OR IC.LEVEL_2_CODE = ''APC'' OR IC.LEVEL_3_NAME = ''Cell Assembly'' )			    ' + char(10); -- [E20241031-001176]Domestic Model Master 화면 Insert 팝업 수정 요청
					END
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('IC.LEVEL_2_CODE' , 'EQ', @p_param7)) + char(10);

				IF @p_param8 = 'Y'
					BEGIN
						SET	@v_dSql += '	AND    A.FORMATION_FLOW_ID IS NOT NULL			    ' + char(10);
					END
				SET @v_dSql += '	ORDER BY A.DIVISION_ID, A.SITE_ID, A.ITEM_ID                                                                                ' + char(10);

				
			END

		IF @p_sys_flag = 'ITEM_POPUP_FP00414' -- Formation Tray for Model UI item 조회
		BEGIN
				
			SET @v_dSql = '';
			SET @v_dSql += 'SELECT A.* ' + char(10);
			SET @v_dSql += 'FROM ( ' + char(10);
			SET @v_dSql += '	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID ' + char(10);
			SET @v_dSql += '		, (CASE WHEN E.IS_CELL_ASSY = ''Y'' THEN D.ITEM_ID ELSE C.ITEM_ID END) AS ITEM_ID ' + char(10);
			SET @v_dSql += '		, (CASE WHEN E.IS_CELL_ASSY = ''Y'' THEN D.ITEM_NAME ELSE C.ITEM_NAME END) AS ITEM_NAME ' + char(10);
			SET @v_dSql += '		, (CASE WHEN E.IS_CELL_ASSY = ''Y'' THEN D.NICK_NAME ELSE C.NICK_NAME END) AS NICK_NAME ' + char(10);
			SET @v_dSql += '		, (CASE WHEN E.IS_CELL_ASSY = ''Y'' THEN D.FLOW_ID ELSE C.FLOW_ID END) AS FLOW_ID ' + char(10);
			SET @v_dSql += '		, (CASE WHEN E.IS_CELL_ASSY = ''Y'' THEN D.FORMATION_FLOW_ID ELSE C.FORMATION_FLOW_ID END) AS FORMATION_FLOW_ID ' + char(10);
			--SET @v_dSql += '		--, (CASE WHEN E.IS_CELL_ASSY = 'Y' THEN D.APPLIED_MODEL ELSE C.APPLIED_MODEL END) AS APPLIED_MODEL ' + char(10);
			SET @v_dSql += '	FROM   FP_CELL_ASSY_PRODUCT_MAP_V A WITH(NOLOCK) ' + char(10);
			SET @v_dSql += '	INNER JOIN ( ' + char(10);
			SET @v_dSql += '		SELECT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID ' + char(10);
			SET @v_dSql += '		FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK) ' + char(10);
			SET @v_dSql += '		WHERE  B.USER_ID = ''' + @p_user_id + ''' ' + char(10);
			SET @v_dSql += '		AND	   B.SAVE_FLAG = ''Y'' ' + char(10);
			SET @v_dSql += '		GROUP BY B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID ' + char(10);
			SET @v_dSql += '	) B ' + char(10);
			SET @v_dSql += '	ON    A.COMPANY_ID  = B.COMPANY_ID ' + char(10);
			SET @v_dSql += '	AND   A.DIVISION_ID = B.DIVISION_ID ' + char(10);
			SET @v_dSql += '	AND   A.SITE_ID     = B.SITE_ID ' + char(10);
			--SET @v_dSql += '	-- cell product
			SET @v_dSql += '	LEFT OUTER JOIN SCM_ITEM_M C WITH(NOLOCK) ' + char(10);
			SET @v_dSql += '	ON    A.COMPANY_ID  = C.COMPANY_ID ' + char(10);
			SET @v_dSql += '	AND   A.DIVISION_ID = C.DIVISION_ID ' + char(10);
			SET @v_dSql += '	AND   A.SITE_ID     = C.SITE_ID ' + char(10);
			SET @v_dSql += '	AND   A.CELL_PRODUCT_ITEM_ID = C.ITEM_ID ' + char(10);
			--SET @v_dSql += '	-- cell assy
			SET @v_dSql += '	LEFT OUTER JOIN SCM_ITEM_M D WITH(NOLOCK) ' + char(10);
			SET @v_dSql += '	ON    A.COMPANY_ID  = D.COMPANY_ID ' + char(10);
			SET @v_dSql += '	AND   A.DIVISION_ID = D.DIVISION_ID ' + char(10);
			SET @v_dSql += '	AND   A.SITE_ID     = D.SITE_ID ' + char(10);
			SET @v_dSql += '	AND   A.CELL_ASSY_ITEM_ID = D.ITEM_ID ' + char(10);
			SET @v_dSql += '	LEFT OUTER JOIN ( ' + char(10);
			SET @v_dSql += '		SELECT (CASE WHEN MAX(B.SEGMENT1) IS NULL THEN ''N'' ELSE ''Y'' END) AS IS_CELL_ASSY ' + char(10);
			SET @v_dSql += '		FROM   SCM_SYS_LOOKUP_VALUE  B WITH(NOLOCK) ' + char(10);
			SET @v_dSql += '		WHERE  B.ACTIVE_FLAG = ''Y'' ' + char(10);
			SET @v_dSql += '		AND    B.ATTRIBUTE1 = ''Y'' ' + char(10);
			SET @v_dSql += '		AND    B.LOOKUP_TYPE_CODE = ''CELL_PRODUCT_ASSY'' ' + char(10);
			SET @v_dSql += '		AND    B.SEGMENT1 = ''' + @p_param3 + ''' ' + char(10);
			SET @v_dSql += '	) E ' + char(10);
			SET @v_dSql += '	ON 1=1 ' + char(10);
			SET @v_dSql += '	WHERE 1=1 ' + char(10);
			SET @v_dSql += ') A ' + char(10);
			SET @v_dSql += 'WHERE 1=1 ' + char(10);
			SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.COMPANY_ID' , 'EQ', @p_param1))
			SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_param2))
			SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_param3))
			SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_param4))
			SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.NICK_NAME' , 'LIKE', @p_param5))
			SET @v_dSql += 'ORDER BY DIVISION_ID, SITE_ID, ITEM_ID ' + char(10);
				
		END

        ELSE IF @p_sys_flag = 'ITEM_POPUP_WIP'

			BEGIN
				
				SELECT @v_dSql = '';
				SELECT @v_dSql += '	 with tmpITEM as									   ' + char(10);
				SELECT @v_dSql += '	 (													   ' + char(10);
				SELECT @v_dSql += '	 		select distinct  			   ' + char(10);
				IF(LEN(@p_param2) > 0) 
				BEGIN
					SELECT @v_dSql += '	 		CT.COMPANY_ID,	CT.DIVISION_ID, 			   ' + char(10);
				END
				IF(LEN(@p_param3) > 0) 
				BEGIN
					SELECT @v_dSql += '	 		CT.SITE_ID, 						' + char(10);
				END
				IF(LEN(@p_param4) > 0) 
				BEGIN
					SELECT @v_dSql += '	 		CT.PLANT_ID, 						' + char(10);
				END
				SELECT @v_dSql += '	 						CT.CHILD_ITEM_ID 			   ' + char(10);
				SELECT @v_dSql += '	 		from SCM_MODEL_COMP_TEMP CT, SCM_ITEM_M IT	   ' + char(10);
				SELECT @v_dSql += '	 		where  1=1  								   ' + char(10);
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL](' CT.DIVISION_ID' , 'EQ', @p_param2))        + char(10)
				SELECT @v_dSql  += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL](' CT.SITE_ID' , 'EQ', @p_param3))        + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL](' CT.PLANT_ID' , 'EQ', @p_param4))              + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL](' CT.CHILD_ITEM_ID' , 'LK', @p_param5))              + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL](' CT.COMPANY_ID' , 'EQ', @p_param1))              + char(10)
				SELECT @v_dSql += '	 		AND CT.CHILD_ITEM_ID   = IT.ITEM_ID			   ' + char(10);
				
				SELECT @v_dSql += '	 		AND CT.COMPANY_ID   = IT.COMPANY_ID			   ' + char(10);
				SELECT @v_dSql += '	 		AND CT.DIVISION_ID   = IT.DIVISION_ID			   ' + char(10);
				SELECT @v_dSql += '	 		AND CT.SITE_ID   = IT.SITE_ID			   ' + char(10);
				SELECT @v_dSql += '	 		AND IT.ACTIVE_FLAG	= ''Y''		   ' + char(10);


				SELECT @v_dSql += '		group by  						' + char(10);
				IF(LEN(@p_param2) > 0) 
				BEGIN
					SELECT @v_dSql += '	 		CT.COMPANY_ID,	CT.DIVISION_ID, 			   ' + char(10);
				END
				IF(LEN(@p_param3) > 0) 
				BEGIN
					SELECT @v_dSql += '	 		CT.SITE_ID, 						' + char(10);
				END
				IF(LEN(@p_param4) > 0) 
				BEGIN
					SELECT @v_dSql += '	 		CT.PLANT_ID, 						' + char(10);
				END
				SELECT @v_dSql += '					CT.CHILD_ITEM_ID 		' + char(10);
				SELECT @v_dSql += ' ),								' + char(10);
				SELECT @v_dSql += ' tmpLINE as		' + char(10);
				SELECT @v_dSql += ' (				' + char(10);
				SELECT @v_dSql += ' 		select distinct ITEM_ID  from SCM_ITEM_LINE_ASSIGN_M ' + char(10);		
				SELECT @v_dSql += ' 		where  1=1 		' + char(10);						  
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL](' DIVISION_ID' , 'EQ', @p_param2))        + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL](' SITE_ID' , 'EQ', @p_param3))        + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL](' PLANT_ID' , 'EQ', @p_param4))              + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL](' ITEM_ID' , 'LK', @p_param5))              + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL](' COMPANY_ID' , 'EQ', @p_param1))              + char(10)
				
				SELECT @v_dSql += '		group by ITEM_ID	 ' + char(10);
				SELECT @v_dSql += ' ) ' + char(10);
				SELECT @v_dSql += ' select distinct												  ' + char(10);		
				IF(LEN(@p_param2) > 0) 
				BEGIN
					SELECT @v_dSql += '	 		A.COMPANY_ID,	A.DIVISION_ID, 			   ' + char(10);
				END
				IF(LEN(@p_param3) > 0) 
				BEGIN
					SELECT @v_dSql += '	 		A.SITE_ID, 						' + char(10);
				END
				IF(LEN(@p_param4) > 0) 
				BEGIN
					SELECT @v_dSql += '	 		A.PLANT_ID, 						' + char(10);
				END
				SELECT @v_dSql += '						  A.CHILD_ITEM_ID AS ITEM_ID from tmpITEM A  ' + char(10);		
				SELECT @v_dSql += ' LEFT OUTER JOIN  tmpLINE B 	' + char(10);
				SELECT @v_dSql += ' ON     A.CHILD_ITEM_ID  =  B.ITEM_ID   ' + char(10);
				SELECT @v_dSql += ' WHERE  B.ITEM_ID IS  NULL ' + char(10);
				
			END


    ELSE IF (@p_sys_flag = 'BUILDING_POPUP')
		BEGIN
		    SET @v_dSql = '';
			SET @v_dSql += ' SELECT A.COMPANY_ID AS COMPANY_ID, A.DIVISION_ID AS DIVISION_ID, A.SITE_ID AS SITE_ID ' +char(10)        
			SET @v_dSql += ' ,A.PLANT_ID AS PLANT_ID, A.FACTORY_ID AS FACTORY_ID, A.FACTORY_NAME AS FACTORY_NAME   ' +char(10)
			SET @v_dSql += ' FROM   SCM_FACTORY_M A WITH(NOLOCK)                                                   ' +char(10)               
			SET @v_dSql += ' WHERE  EXISTS (                                                                       ' +char(10)               
			SET @v_dSql += ' 		SELECT 1                                                                       ' +char(10)            
			SET @v_dSql += ' 		FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)                                      ' +char(10)            
			SET @v_dSql += ' 		WHERE  A.COMPANY_ID   = B.COMPANY_ID                                           ' +char(10)            
			SET @v_dSql += ' 		AND    A.DIVISION_ID  = B.DIVISION_ID                                          ' +char(10)            
			SET @v_dSql += ' 		AND    A.SITE_ID      = B.SITE_ID                                              ' +char(10)            
			SET @v_dSql += ' 		AND    A.PLANT_ID     = B.PLANT_ID                                             ' +char(10)            
			SET @v_dSql += ' 		AND    B.USER_ID      = '''+ @p_user_id +'''                                   ' +char(10)  
			SET @v_dSql += ' 		AND	   B.SAVE_FLAG	  = ''Y''                                                  ' +char(10)         
			SET @v_dSql += ' 	)                                                                                  ' +char(10)            
			SET @v_dSql += ' AND   A.ACTIVE_FLAG = ''Y''   														   ' +char(10)
			SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_param1)) + char(10);
			SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_param2)) + char(10);
			SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'LIKE', @p_param3)) + char(10);																			
			SET @v_dSql += ' ORDER BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID  ' +char(10)
	   
		END
    ELSE IF (@p_sys_flag = 'OPERATION_POPUP')
		BEGIN
		    SET @v_dSql = '';																																							   
			SET @v_dSql += '    SELECT 	DISTINCT  A.COMPANY_ID AS COMPANY_ID,  A.DIVISION_ID AS DIVISION_ID,  A.SITE_ID AS SITE_ID														   ' + char(10)
			SET @v_dSql += '	, A.OPERATION_ID AS OPERATION_ID, ''('' + A.OPERATION_ID + '')''+ISNULL(A.OPERATION_NAME, OPERATION_ID) AS OPERATION_NAME								   ' + char(10)
    		SET @v_dSql += '	, A.OPERATION_GROUP_ID, A.OPERATION_GROUP_NAME																											   ' + char(10)
			SET @v_dSql += '	FROM   SCM_OPERATION_M A WITH(NOLOCK)																													   ' + char(10)
			SET @v_dSql += '	WHERE  	(																																				   ' + char(10)
      		SET @v_dSql += '				(																																			   ' + char(10)
            SET @v_dSql += '  					EXISTS ( SELECT 1 FROM SCM_MMD_OPERATION_GROUP_M B(NOLOCK) WHERE B.OPERATION_GROUP_ID=A.OPERATION_GROUP_ID AND B.ROUTE_TYPE=''P'' )		   ' + char(10)
            SET @v_dSql += '  					AND MES_ERP_INTERFACE_FLAG=''Y''																										   ' + char(10)
            SET @v_dSql += '  				) OR																																		   ' + char(10)
            SET @v_dSql += '  				(																																			   ' + char(10)
            SET @v_dSql += '  					NOT EXISTS ( SELECT 1 FROM SCM_MMD_OPERATION_GROUP_M B(NOLOCK) WHERE B.OPERATION_GROUP_ID=A.OPERATION_GROUP_ID AND B.ROUTE_TYPE=''P'' )	   ' + char(10)
            SET @v_dSql += '  				)																		' + char(10)
			SET @v_dSql += '			)																			' + char(10)
    		SET @v_dSql += '	AND EXISTS (																		' + char(10)
			SET @v_dSql += '					SELECT 1 FROM SCM_LINE_M C WITH(NOLOCK)								' + char(10)
			SET @v_dSql += '					WHERE C.COMPANY_ID   = A.COMPANY_ID									' + char(10)
			SET @v_dSql += '					AND   C.DIVISION_ID  = A.DIVISION_ID								' + char(10)
			SET @v_dSql += '					AND   C.SITE_ID      = A.SITE_ID									' + char(10)
			SET @v_dSql += '					AND   C.OPERATION_ID = A.OPERATION_ID								' + char(10)
			--SET @v_dSql += '					AND   C.PLANT_ID = A.PLANT_ID								' + char(10)
			SET @v_dSql += '					AND   C.ACTIVE_FLAG  = ''Y''										' + char(10)
			SET @v_dSql += '				)																		' + char(10)
			SET @v_dSql += '	AND   A.ACTIVE_FLAG = ''Y''															' + char(10)
			SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_param1)) + char(10)
			SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_param2)) + char(10)
			SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'LIKE', @p_param3)) + char(10)																		
			SET @v_dSql += '	AND    EXISTS (																		' + char(10)
			SET @v_dSql += '        			SELECT 1															' + char(10)
			SET @v_dSql += '        			FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)							' + char(10)
			SET @v_dSql += '        			WHERE  A.COMPANY_ID  = B.COMPANY_ID									' + char(10)
			SET @v_dSql += '        			AND    A.DIVISION_ID = B.DIVISION_ID								' + char(10)
			SET @v_dSql += '        			AND    A.SITE_ID     = B.SITE_ID									' + char(10)
			SET @v_dSql += '        			AND    A.OPERATION_ID = B.OPERATION_ID								' + char(10)
			SET @v_dSql += '        			AND    B.USER_ID      = '''+ @p_user_id +'''						' + char(10)
			SET @v_dSql += '        			AND	   B.SAVE_FLAG	  = ''Y''										' + char(10)
			SET @v_dSql += '      			)																		' + char(10)
			SET @v_dSql += '	ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID						' + char(10)
	   
		END
		/****************************************************************************************************************************************/
		/*   Plant Popup																															*/
		/*   Param :	@p_param1 - COMPANY_ID / @p_param2 - DIVISION_ID / @p_param3 - SITE_ID / @p_param4 - PLANT_ID / @p_param5 - PLANT_NAME	*/
		/*   Param :	@p_param6 - LEVEL_2_CODE_FLAG / @p_param7 - LEVEL_2_CODE / @p_param8 - IS_FORMATION_FLOW_ID_EXISTS / @p_param9 -  / @p_param10 - 	*/
		/****************************************************************************************************************************************/
			ELSE IF (@p_sys_flag = 'PLANT_POPUP')
				BEGIN
					SET @v_dSql = '';																																							   
					SET @v_dSql += '	SELECT A.COMPANY_ID     												' + char(10)
					SET @v_dSql += '	    ,A.DIVISION_ID                                                      ' + char(10)
					SET @v_dSql += '	    ,A.SITE_ID                                                          ' + char(10)
					SET @v_dSql += '				  ,A.PLANT_ID                                               ' + char(10)
					SET @v_dSql += '				  ,A.PLANT_NAME                                             ' + char(10)
					SET @v_dSql += '	    ,'''' MASTER_ID                                                     ' + char(10)
					SET @v_dSql += '	    ,'''' PLAN_ID                                                       ' + char(10)
					SET @v_dSql += '	FROM   SCM_PLANT_M A WITH(NOLOCK)                                       ' + char(10)
					SET @v_dSql += '	WHERE  EXISTS (                                                         ' + char(10)
					SET @v_dSql += '		        	SELECT 1                                                ' + char(10)
					SET @v_dSql += '		        	FROM   FP_USER_ROLE_INFO_V BB WITH(NOLOCK)              ' + char(10)
					SET @v_dSql += '		        	WHERE  A.COMPANY_ID     = BB.COMPANY_ID                 ' + char(10)
					SET @v_dSql += '		        	AND    A.DIVISION_ID    = BB.DIVISION_ID                ' + char(10)
					SET @v_dSql += '		        	AND    A.SITE_ID        = BB.SITE_ID                    ' + char(10)
					SET @v_dSql += '		        	AND    A.PLANT_ID       = BB.PLANT_ID                   ' + char(10)
					SET @v_dSql += '		        	AND    BB.USER_ID       = '''+ @p_user_id +'''          ' + char(10)
					SET @v_dSql += '		        	AND	   BB.SAVE_FLAG	  = ''Y''                           ' + char(10)
					SET @v_dSql += '		      	)                                                           ' + char(10)
					SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.COMPANY_ID' , 'EQ', @p_param1)) + char(10)
					SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_param2)) + char(10)
					SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_param3)) + char(10)
					SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_param4)) + char(10)
					SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_NAME' , 'LIKE', @p_param5)) + char(10)						
					SET @v_dSql += '	ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID             ' + char(10)
						   
				END
    ELSE IF (@p_sys_flag = 'WORKCENTER_OPERATION_FACTORY')
		BEGIN
		    SELECT @v_dSql = ''																																						   
            SELECT @v_dSql += ' SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID  ' + char(10)
            SELECT @v_dSql += '      , A.OPERATION_ID, B.OPERATION_NAME, B.OPERATION_GROUP_ID  ' + char(10)
            SELECT @v_dSql += ' FROM   SCM_LINE_M A WITH(NOLOCK), SCM_OPERATION_M B WITH(NOLOCK)  ' + char(10)
            SELECT @v_dSql += ' WHERE  A.COMPANY_ID   = B.COMPANY_ID  ' + char(10)
            SELECT @v_dSql += ' AND    A.DIVISION_ID  = B.DIVISION_ID  ' + char(10)
            SELECT @v_dSql += ' AND    A.SITE_ID      = B.SITE_ID  ' + char(10)
            SELECT @v_dSql += ' AND    A.OPERATION_ID = B.OPERATION_ID  ' + char(10)
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'NE', @p_param6)) + char(10) --@p_param5: FACTORY_ID, , @p_param6: NO_FACTORY_ID --NE:NOT IN
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.COMPANY_ID' , 'EQ', @p_param1)) + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_param2)) + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_param3)) + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_param4)) + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_param5)) + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.OPERATION_ID' , 'LK', @p_param7)) + char(10)
            --SELECT @v_dSql += ' AND B.OPERATION_ID LIKE ''%' + @p_param7 + '%''' + char(10) --(SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.OPERATION_ID' , 'LK', @p_param7)) + char(10)
            SELECT @v_dSql += ' AND   EXISTS (  ' + char(10)
            SELECT @v_dSql += '               SELECT 1  ' + char(10)
            SELECT @v_dSql += '               FROM   FP_USER_ROLE_INFO_V BB WITH(NOLOCK)  ' + char(10)
            SELECT @v_dSql += '               WHERE  A.COMPANY_ID     = BB.COMPANY_ID  ' + char(10)
            SELECT @v_dSql += '               AND    A.DIVISION_ID    = BB.DIVISION_ID  ' + char(10)
            SELECT @v_dSql += '               AND    A.SITE_ID        = BB.SITE_ID  ' + char(10)
            SELECT @v_dSql += '               AND    A.PLANT_ID       = BB.PLANT_ID  ' + char(10)
            SELECT @v_dSql += '               AND    A.FACTORY_ID     = BB.FACTORY_ID  ' + char(10)
            SELECT @v_dSql += '               AND    A.OPERATION_ID   = BB.OPERATION_ID  ' + char(10)
            SELECT @v_dSql += '               AND    A.LINE_ID        = BB.LINE_ID  ' + char(10)
            SELECT @v_dSql += '               AND    A.ELECTRODE_TYPE = BB.ELECTRODE_TYPE  ' + char(10)
            SELECT @v_dSql += '               AND    BB.USER_ID       = '''+ @p_user_id +'''  ' + char(10)
            SELECT @v_dSql += '               AND	   BB.SAVE_FLAG	  = ''Y''  ' + char(10)
            SELECT @v_dSql += '              )  ' + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.COMPANY_ID' , 'EQ', @p_param1)) + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_param2)) + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_param3)) + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_param4)) + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_param5)) + char(10)
			--SELECT @v_dSql += ' AND B.OPERATION_ID LIKE ''%' + @p_param7 + '%''' + char(10) --(SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.OPERATION_ID' , 'LK', @p_param7)) + char(10)
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.OPERATION_ID' , 'LK', @p_param7)) + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.LINE_ID' , 'EQ', @p_param8)) + char(10)
			SELECT @v_dSql += ' AND    B.ACTIVE_FLAG = ''Y'' '+ char(10)
			SELECT @v_dSql += ' ORDER BY A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID '+ char(10)
	   
		END

    ELSE IF (@p_sys_flag = 'WORKCENTER_OPERATION_FACTORY_NONE')
		BEGIN
		    SELECT @v_dSql = ''																																						   
            SELECT @v_dSql += ' SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID  ' + char(10)
            SELECT @v_dSql += '     , A.OPERATION_ID, B.OPERATION_NAME, B.OPERATION_GROUP_ID        ' + char(10)
            SELECT @v_dSql += ' FROM   SCM_LINE_M A WITH(NOLOCK), SCM_OPERATION_M B WITH(NOLOCK)    ' + char(10)
            SELECT @v_dSql += ' WHERE  A.COMPANY_ID   = B.COMPANY_ID  ' + char(10)
            SELECT @v_dSql += ' AND    A.DIVISION_ID  = B.DIVISION_ID  ' + char(10)
            SELECT @v_dSql += ' AND    A.SITE_ID      = B.SITE_ID  ' + char(10)
            SELECT @v_dSql += ' AND    A.OPERATION_ID = B.OPERATION_ID  ' + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'NE', @p_param6)) + char(10) --@p_param5: FACTORY_ID, , @p_param6: NO_FACTORY_ID --NE:NOT IN
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.COMPANY_ID' , 'EQ', @p_param1)) + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_param2)) + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_param3)) + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_param4)) + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.OPERATION_ID' , 'EQ', @p_param7)) + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_param8)) + char(10)
            SELECT @v_dSql += ' AND   EXISTS (  ' + char(10)
            SELECT @v_dSql += '               SELECT 1  ' + char(10)
            SELECT @v_dSql += '               FROM   FP_USER_ROLE_INFO_V BB WITH(NOLOCK)  ' + char(10)
            SELECT @v_dSql += '               WHERE  A.COMPANY_ID     = BB.COMPANY_ID  ' + char(10)
            SELECT @v_dSql += '               AND    A.DIVISION_ID    = BB.DIVISION_ID  ' + char(10)
            SELECT @v_dSql += '               AND    A.SITE_ID        = BB.SITE_ID  ' + char(10)
            SELECT @v_dSql += '               AND    A.PLANT_ID       = BB.PLANT_ID  ' + char(10)
            SELECT @v_dSql += '               AND    A.FACTORY_ID     = BB.FACTORY_ID  ' + char(10)
            SELECT @v_dSql += '               AND    A.OPERATION_ID   = BB.OPERATION_ID  ' + char(10)
            SELECT @v_dSql += '               AND    A.LINE_ID        = BB.LINE_ID  ' + char(10)
            SELECT @v_dSql += '               AND    A.ELECTRODE_TYPE = BB.ELECTRODE_TYPE  ' + char(10)
            SELECT @v_dSql += '               AND    BB.USER_ID       = '''+ @p_user_id +'''  ' + char(10)
            SELECT @v_dSql += '               AND	 BB.SAVE_FLAG	  = ''Y''  ' + char(10)
            SELECT @v_dSql += '              )  ' + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_param2)) + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_param3)) + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_param4)) + char(10)
			SELECT @v_dSql += ' AND    B.ACTIVE_FLAG = ''Y'' '+ char(10)
			SELECT @v_dSql += ' ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID '+ char(10)
	   
		END
	END -- IF END

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

