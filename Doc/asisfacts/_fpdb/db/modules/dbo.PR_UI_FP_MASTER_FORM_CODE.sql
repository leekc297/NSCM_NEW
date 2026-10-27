


/*
 * Program ID   : PR_UI_FP_MASTER_FORM_CODE
 * Description  : 여러 UI에서 사용하는 FP용 조회 조건, 입력 가능 값 관리
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * ...
 * 2025/11/24   kimcd           [PJ2025F254]  JV법인 ESS 혼용 생산 시스템 개선
 *                              JV ESS 생산에 따른 실제 생산하는 라인과 연결 정보 관리. 가상 라인 여부 관리
 *                              LINK_LINE_ID, VIRTUAL_LINE_YN 컬럼 추가
 *                              LINK_LINE_ID에서 사용 가능한 목록 조회문장 추가
 */
CREATE PROCEDURE [dbo].[PR_UI_FP_MASTER_FORM_CODE]
	  @p_code	  NVARCHAR(100)
    , @p_user_id  NVARCHAR(100)
	, @param1     NVARCHAR(MAX)  
	, @param2     NVARCHAR(MAX)  
	, @param3     NVARCHAR(MAX)  
	, @param4     NVARCHAR(MAX)  
	, @param5     NVARCHAR(MAX)
	, @param6     NVARCHAR(MAX)
	, @param7     NVARCHAR(MAX)
	, @param8     NVARCHAR(MAX)
	, @param9     NVARCHAR(MAX)
	, @param10    NVARCHAR(MAX)
	, @param11    NVARCHAR(MAX)
	, @param12    NVARCHAR(MAX)
	, @param13    NVARCHAR(MAX)
	, @param14    NVARCHAR(MAX)
	, @param15    NVARCHAR(MAX)
	, @param16    NVARCHAR(MAX)
	, @param17    NVARCHAR(MAX)
	, @param18    NVARCHAR(MAX)
	, @param19    NVARCHAR(MAX)
	, @param20    NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON;

    DECLARE @v_dept_id          NVARCHAR(50)=''
	DECLARE @v_group_id         NVARCHAR(50)=''
	DECLARE @v_text             NVARCHAR(MAX)=''
	DECLARE @v_dSql             NVARCHAR(MAX)=''

	INSERT INTO TH_UIS_SQL 
	VALUES
	(	'PR_UI_FP_FORM_CODE',@p_code,'====== START =======', @p_user_id, getdate() )

	/****************************************************************************************************************************************/
	/*  Parameter 세팅                                                                                                       */
	/*                                                                                                    */
	/****************************************************************************************************************************************/
	--BEGIN


	SELECT @v_dSql  = '' 

		BEGIN
			SET @v_group_id = 'ADMIN'
		END

	    /****************************************************************************************************************************************/
		/*   xpcommoncond findFactoryCode_common 정보갖고오기                                                                                        */
		/*   Param : @param1:NON_AUTH, @param2:SAVE_AUTH, @param3:  INSTANCE, @param4:  DIVISION,  @param5:  SITE , @param6:  PLANT             */
		/****************************************************************************************************************************************/
		IF @p_code = 'findFactoryCode_common'

			BEGIN
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT A.FACTORY_ID AS CODE, ''('' + A.FACTORY_ID + '')'' + ISNULL(A.FACTORY_NAME, A.FACTORY_ID) AS NAME ' + char(10)
                SELECT @v_dSql += ' 		  , CASE WHEN R.FACTORY_ID IS NOT NULL THEN 1 ELSE 0 END AS ROWCHK ' + char(10)
                SELECT @v_dSql += ' FROM   SCM_FACTORY_M A WITH(NOLOCK)                                        ' + char(10)
                SELECT @v_dSql += '        LEFT OUTER JOIN (                                                   ' + char(10)
                SELECT @v_dSql += '              SELECT	DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID      ' + char(10)
                SELECT @v_dSql += '              FROM	FP_USER_ROLE_INFO_V R WITH(NOLOCK)       ' + char(10)
                SELECT @v_dSql += '              WHERE	1=1                                      ' + char(10)
                SELECT @v_dSql += '              AND    R.USER_ID	= '''+ @p_user_id +'''       ' + char(10)
				
				IF (@param2 = 'Y') --SAVE_AUTH
					BEGIN
						SET	@v_dSql += '              AND    R.SAVE_FLAG = ''Y'' ' + char(10)
					END
                SELECT @v_dSql += '              ) R                             ' + char(10)
                SELECT @v_dSql += ' ON		1=1                                  ' + char(10)
                SELECT @v_dSql += ' AND		A.COMPANY_ID		= R.COMPANY_ID   ' + char(10)
                SELECT @v_dSql += ' AND		A.DIVISION_ID		= R.DIVISION_ID  ' + char(10)
                SELECT @v_dSql += ' AND		A.SITE_ID			= R.SITE_ID      ' + char(10)
                SELECT @v_dSql += ' AND		A.PLANT_ID			= R.PLANT_ID     ' + char(10)
                SELECT @v_dSql += ' AND		A.FACTORY_ID		= R.FACTORY_ID   ' + char(10)
                SELECT @v_dSql += ' WHERE  1=1	                                 ' + char(10)

				IF (@param1 = 'Y') --NON_AUTH
				    BEGIN
                        SELECT @v_dSql += ' AND  EXISTS (         ' + char(10)
                        SELECT @v_dSql += '             SELECT 1  ' + char(10)
                        SELECT @v_dSql += '             FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)   ' + char(10)
                        SELECT @v_dSql += '             WHERE  A.COMPANY_ID  = B.COMPANY_ID         ' + char(10)
                        SELECT @v_dSql += '             AND    A.DIVISION_ID = B.DIVISION_ID        ' + char(10)
                        SELECT @v_dSql += '             AND    A.SITE_ID     = B.SITE_ID            ' + char(10)
                        SELECT @v_dSql += '             AND    A.PLANT_ID    = B.PLANT_ID           ' + char(10)
                        SELECT @v_dSql += '             AND    A.FACTORY_ID  = B.FACTORY_ID         ' + char(10)
                        SELECT @v_dSql += '             AND    B.USER_ID     = '''+ @p_user_id +''' ' + char(10)
					

					    IF (@param2 = 'Y') --SAVE_AUTH
					        BEGIN
					        	SET	@v_dSql += '            AND    B.SAVE_FLAG = ''Y'' ' + char(10)
					        END
                        IF (Len(@param3) > 0 ) --Instance
					        BEGIN
							    SET @v_dSql += '            ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.INSTANCE_ID' , 'EQ', @param3))   + char(10)
					        END
                        SELECT @v_dSql += '         )             ' + char(10)
                    END

                SELECT @v_dSql += ' AND A.ACTIVE_FLAG = ''Y'' ' + char(10)
                SELECT @v_dSql += ' AND EXISTS (              ' + char(10)
                SELECT @v_dSql += '            SELECT 1       ' + char(10)
                SELECT @v_dSql += '            FROM (         ' + char(10)
                SELECT @v_dSql += '                   SELECT DISTINCT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID          ' + char(10)
                SELECT @v_dSql += '                   FROM   SCM_FACTORY_M A WITH(NOLOCK)             ' + char(10)
                SELECT @v_dSql += '                   INNER JOIN FP_INSTANCE_FACTORY_M B WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += '                   ON    A.FACTORY_ID=B.FACTORY_ID                 ' + char(10)
                SELECT @v_dSql += '                   AND   B.ACTIVE_FLAG = ''Y''                     ' + char(10)
                SELECT @v_dSql += '                   WHERE 1=1                                       ' + char(10)
                SELECT @v_dSql += '                   AND   A.ACTIVE_FLAG = ''Y''                     ' + char(10)
                SELECT @v_dSql += '                   ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.INSTANCE_ID' , 'EQ', @param3))   + char(10)
                SELECT @v_dSql += '                 ) C ' + char(10)
                SELECT @v_dSql += '            WHERE C.COMPANY_ID=A.COMPANY_ID AND C.DIVISION_ID=A.DIVISION_ID                 ' + char(10)
				SELECT @v_dSql += '            AND C.SITE_ID=A.SITE_ID AND C.PLANT_ID=A.PLANT_ID AND C.FACTORY_ID=A.FACTORY_ID ' + char(10)
                SELECT @v_dSql += '           )       ' + char(10)
				SELECT @v_dSql += ' ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param4)) + char(10)
				SELECT @v_dSql += ' ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' ,     'EQ', @param5)) + char(10)
				SELECT @v_dSql += ' ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' ,    'EQ', @param6)) + char(10)
                SELECT @v_dSql += ' GROUP BY a.FACTORY_ID, a.FACTORY_NAME                     ' + char(10)
                SELECT @v_dSql += '     ,CASE WHEN R.FACTORY_ID IS NOT NULL THEN 1 ELSE 0 END ' + char(10)
                SELECT @v_dSql += ' ORDER BY A.FACTORY_ID                                     ' + char(10)
				
				--SELECT @v_dSql
			    exec sp_executesql @v_dSql
			END
		/****************************************************************************************************************************************/
		/*   xpcommoncond findPlantList_common 정보갖고오기                                                                                      */
		/*   Param : @param1:NON_AUTH, @param2:SAVE_AUTH, @param3:  INSTANCE, @param4:  DIVISION,  @param5:  SITE , @param6:  PLANT             */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'findPlantList_common'

			BEGIN
			    SELECT @v_dSql = ''

                SELECT @v_dSql += ' SELECT PLANT_ID as CODE         ' + char(10)
                SELECT @v_dSql += '      , ''('' + PLANT_ID + '')'' + case when PLANT_NAME = '''' or PLANT_NAME is null then PLANT_ID else PLANT_NAME end as NAME ' + char(10)
                SELECT @v_dSql += ' FROM  SCM_PLANT_M A WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += ' WHERE 1 = 1                      ' + char(10)

                IF (@param1 = 'Y' )--NON_AUTH
                    BEGIN
                         SELECT @v_dSql += ' AND  EXISTS (                                            ' + char(10)
                         SELECT @v_dSql += '              SELECT 1                                     ' + char(10)
                         SELECT @v_dSql += '              FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)    ' + char(10)
                         SELECT @v_dSql += '              WHERE  A.COMPANY_ID  = B.COMPANY_ID          ' + char(10)
                         SELECT @v_dSql += '              AND    A.DIVISION_ID = B.DIVISION_ID         ' + char(10)
                         SELECT @v_dSql += '              AND    A.SITE_ID     = B.SITE_ID             ' + char(10)
                         SELECT @v_dSql += '              AND    A.PLANT_ID    = B.PLANT_ID            ' + char(10)
                         SELECT @v_dSql += '              AND    B.USER_ID     = '''+ @p_user_id +'''  ' + char(10)
                         IF (@param2 = 'Y') --SAVE_AUTH
                             BEGIN
                            	    SET	@v_dSql += '              AND    B.SAVE_FLAG = ''Y'' ' + char(10)
                             END
                         SELECT @v_dSql += ' ) ' + char(10)                   
				    END 


                SELECT @v_dSql += ' AND EXISTS ( ' + char(10)
                SELECT @v_dSql += '          SELECT 1 FROM (  ' + char(10)
				SELECT @v_dSql += '                           ' + char(10)
                SELECT @v_dSql += '                         SELECT DISTINCT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID ' + char(10)
                SELECT @v_dSql += '                         FROM SCM_FACTORY_M A WITH(NOLOCK) INNER JOIN FP_INSTANCE_FACTORY_M B WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += '                         ON  A.FACTORY_ID=B.FACTORY_ID ' + char(10)
                SELECT @v_dSql += '                         AND B.ACTIVE_FLAG = ''Y'' ' + char(10)
                SELECT @v_dSql += '                         WHERE 1=1 ' + char(10)
                SELECT @v_dSql += '                         AND   A.ACTIVE_FLAG = ''Y'' ' + char(10)
                IF (Len(@param3) > 0 ) --Instance
				    BEGIN
					    SET @v_dSql += '                         ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.INSTANCE_ID' , 'EQ', @param3))   + char(10)
				    END

                SELECT @v_dSql += '                         ) C ' + char(10)
                SELECT @v_dSql += '          WHERE C.COMPANY_ID=A.COMPANY_ID AND C.DIVISION_ID=A.DIVISION_ID AND C.SITE_ID=A.SITE_ID AND C.PLANT_ID=A.PLANT_ID ' + char(10)
                SELECT @v_dSql += '          ) ' + char(10)
				SELECT @v_dSql += ' ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param4)) + char(10)
				SELECT @v_dSql += ' ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' ,     'EQ', @param5)) + char(10)
				SELECT @v_dSql += ' ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' ,    'EQ', @param6)) + char(10)

                SELECT @v_dSql += ' GROUP BY PLANT_ID, PLANT_NAME ' + char(10)
                SELECT @v_dSql += ' ORDER BY PLANT_ID ASC         ' + char(10)

				--SELECT @v_dSql
			    exec sp_executesql @v_dSql
			END
		/****************************************************************************************************************************************/
		/*   FP00100 Division 정보갖고오기                                                                                                              */
		/*   Param :@Param1	:LOOKUP_TYPE_CODE           																						*/
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00100_findLineLookup'

			BEGIN
				SET @v_dSql = '';
				/* Alias setting */																				
				SET @v_dSql  = ' SELECT A.SEGMENT1 AS SITE_ID															                                    ';
				SET @v_dSql += '    , A.SEGMENT2 AS DIVISION_ID															                                    ';
				SET @v_dSql += '    , A.SEGMENT3 AS PLANT_ID															                                    ';
				SET @v_dSql += '    , A.SEGMENT4 AS FACTORY_ID															                                    ';
				SET @v_dSql += '    , A.SEGMENT5 AS CODE															                                        ';
				SET @v_dSql += '    , ( CASE WHEN '''+ @param1 +''' = ''LINE_MODEL_TYPE'' THEN                                                              ';
				SET @v_dSql += '          ( CASE WHEN ISNULL(A.ATTRIBUTE1, A.SEGMENT5) = ''Automotive'' THEN ISNULL(A.ATTRIBUTE1, A.SEGMENT5)               ';
				SET @v_dSql += '                 WHEN ISNULL(A.ATTRIBUTE1, A.SEGMENT5) = ''Electrode'' THEN ISNULL(A.ATTRIBUTE1, A.SEGMENT5)                ';
				SET @v_dSql += '    	         WHEN ISNULL(A.ATTRIBUTE1, A.SEGMENT5) = ''Cylindrical'' THEN ISNULL(A.ATTRIBUTE1, A.SEGMENT5)              ';
				SET @v_dSql += '    	         WHEN ISNULL(A.ATTRIBUTE1, A.SEGMENT5) = ''Pouch'' THEN ISNULL(A.ATTRIBUTE1, A.SEGMENT5)                    ';
				SET @v_dSql += '    	         WHEN ISNULL(A.ATTRIBUTE1, A.SEGMENT5) = ''Prismatic'' THEN ISNULL(A.ATTRIBUTE1, A.SEGMENT5)                ';
				SET @v_dSql += '    	         WHEN ISNULL(A.ATTRIBUTE1, A.SEGMENT5) = ''Subminiature Cylindrical'' THEN ISNULL(A.ATTRIBUTE1, A.SEGMENT5) ';
				SET @v_dSql += '             ELSE A.SEGMENT5 + ''('' + ISNULL(A.ATTRIBUTE1, A.SEGMENT5)+ '')'' END )                                        ';
				SET @v_dSql += '      ELSE ISNULL(A.ATTRIBUTE1, A.SEGMENT5) END ) AS NAME	                                                                ';
				SET @v_dSql += ' FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)												                                    ';
				SET @v_dSql += ' WHERE  A.LOOKUP_TYPE_CODE =  '''+ @param1 +'''											                                    ';
				SET @v_dSql += ' AND    A.ACTIVE_FLAG      = ''Y''														                                    ';
				SET @v_dSql += ' ORDER BY A.SEGMENT1, A.SEGMENT2, A.SEGMENT3, A.SEGMENT4, A.SORT_ORDER					                                    ';

				--print @v_dSql;
				--INSERT INTO TH_UIS_SQL VALUES ('@@@v_dSql',@p_code,@v_dSql , @param1, getdate() ) ;

				exec sp_executesql @v_dSql;
			END

		/****************************************************************************************************************************************/
		/*   FP00100 Line Set Group ID 정보갖고오기                                                                                                     */
		/*   Param :  @PARAM1 =                                                                                                                 */
		/****************************************************************************************************************************************/
		ELSE IF @p_code ='FP00100_findMatrix_linesetup'
		    BEGIN
				SET @v_dSql = '';   
				SET @v_dSql  += ' SELECT A.COMPANY_ID As COMPANY_ID, A.DIVISION_ID As DIVISION_ID, A.SITE_ID As SITE_ID, A.PLANT_ID As PLANT_ID	   ';
				SET @v_dSql  += ' 	,A.OPERATION_ID As OPERATION_ID																			       ';
				SET @v_dSql  += ' 	,A.LINE_SETUP_GROUP_ID As CODE																			       ';
				SET @v_dSql  += ' 	,A.LINE_SETUP_GROUP_ID As NAME																			       ';
				SET @v_dSql  += ' FROM  SCM_LINE_SETUP_GROUP_M A(NOLOCK)																	           ';
				SET @v_dSql  += ' ORDER  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID, A.LINE_SETUP_GROUP_ID               ';  
				
				--print @v_dSql;
				--INSERT INTO TH_UIS_SQL VALUES ('@@@v_dSql',@p_code,@v_dSql , @param1, getdate() ) ;

				exec sp_executesql @v_dSql;
			END	

		/****************************************************************************************************************************************/
		/*   FP00100 find_FP00100_dup 정보갖고오기                                                                                                      */
		/*   Param :  @PARAM1 =                                                                                                                 */
		/****************************************************************************************************************************************/
		ELSE IF @p_code ='FP00100_find_FP00100_dup'
		    BEGIN
			    SET @v_dSql = '';
				SET @v_dSql += '  SELECT A.SEGMENT1 As CODE, A.SEGMENT2 As NAME 					 ' + char(10);
				SET @v_dSql += '  FROM  SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)							 ' + char(10);
				SET @v_dSql += '  WHERE A.LOOKUP_TYPE_CODE = ''ELECTRODE_TYPE'' 					 ' + char(10);
				SET @v_dSql += '  ORDER BY A.SORT_ORDER ASC											 ' + char(10);
				
				--print @v_dSql;
				--INSERT INTO TH_UIS_SQL VALUES ('@@@v_dSql',@p_code,@v_dSql , @param1, getdate() ) ;
				exec sp_executesql @v_dSql;
			END	
		/****************************************************************************************************************************************/
		/*   FP00510 Instance_Info 정보갖고오기                                                                                          */
		/*   Param :@Param1	:DIVISION , @Param2	:SITE        																					*/
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00510_Instance_Info'

			BEGIN
				SELECT @v_dSql = '';
				SELECT @v_dSql +='      SELECT A.SEGMENT4 AS CODE, ISNULL(B.INST_NAME,A.SEGMENT4) AS NAME			  ' + char(10)
				SELECT @v_dSql +='		   , A.SEGMENT2 AS SITE_ID, A.SEGMENT5 AS DIVISION_ID						  ' + char(10)
				SELECT @v_dSql +='		   , MAX(D.DIVISION_NAME) AS DIVISION_NAME, MAX(A.SORT_ORDER) AS SORT_ORDER	  ' + char(10)
				SELECT @v_dSql +='	  FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)									  ' + char(10)
				SELECT @v_dSql +='	  LEFT OUTER JOIN (																  ' + char(10)
				SELECT @v_dSql +='		  SELECT SEGMENT1 AS INST, SEGMENT2 AS INST_NAME							  ' + char(10)
				SELECT @v_dSql +='		  FROM   SCM_SYS_LOOKUP_VALUE B WITH(NOLOCK)								  ' + char(10)
				SELECT @v_dSql +='		  WHERE  B.LOOKUP_TYPE_CODE = ''INSTANCE_ID''								  ' + char(10)
				SELECT @v_dSql +='		  AND    B.ACTIVE_FLAG      = ''Y''											  ' + char(10)
				SELECT @v_dSql +='	  ) B																			  ' + char(10)
				SELECT @v_dSql +='	  ON     A.SEGMENT4         = B.INST											  ' + char(10)
				SELECT @v_dSql +='	  LEFT JOIN ( SELECT DISTINCT DIVISION_ID, DIVISION_NAME                          ' + char(10)
				SELECT @v_dSql +='	 	   FROM SCM_DIVISION_M  D WITH(NOLOCK)                                        ' + char(10)
				SELECT @v_dSql +='	 	  ) D                                                                         ' + char(10)
				SELECT @v_dSql +='	 	  ON   A.SEGMENT5         = D.DIVISION_ID									  ' + char(10)
				SELECT @v_dSql +='	  WHERE  A.LOOKUP_TYPE_CODE = ''TARGET_INSTANCE''								  ' + char(10)
				SELECT @v_dSql +='	  AND    A.SEGMENT1         = ''SCP TARGET''									  ' + char(10)
				SELECT @v_dSql +='	  AND    ACTIVE_FLAG        = ''Y''												  ' + char(10)
				SELECT @v_dSql +='	  AND A.SEGMENT4 IN (															  ' + char(10)
				SELECT @v_dSql +='						SELECT DISTINCT B.INSTANCE_ID								  ' + char(10)
			    SELECT @v_dSql +='						FROM   SCM_FACTORY_M A(NOLOCK) 								  ' + char(10)
				SELECT @v_dSql +='						INNER JOIN FP_INSTANCE_FACTORY_M B(NOLOCK)					  ' + char(10)
			    SELECT @v_dSql +='							ON     A.FACTORY_ID=B.FACTORY_ID						  ' + char(10)
			    SELECT @v_dSql +='							AND    B.ACTIVE_FLAG        = ''Y''						  ' + char(10)
			    SELECT @v_dSql +='							WHERE 1=1												  ' + char(10)
			    SELECT @v_dSql +='							AND    A.ACTIVE_FLAG        = ''Y''						  ' + char(10)
				SELECT @v_dSql +=    (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID', 'EQ', @param1 ))     + char(10)
  	            SELECT @v_dSql +=    (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID', 'EQ', @param2 ))         + char(10)
				SELECT @v_dSql +='						 )															  ' + char(10)
				SELECT @v_dSql +='	  AND    EXISTS (																  ' + char(10)
				SELECT @v_dSql +='			SELECT 1																  ' + char(10)
				SELECT @v_dSql +='			FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)								  ' + char(10)
				SELECT @v_dSql +='			WHERE  A.SEGMENT4 = B.INSTANCE_ID										  ' + char(10)
				SELECT @v_dSql +='			AND    B.USER_ID  = '''+ @p_user_id +'''								  ' + char(10)
				SELECT @v_dSql +='	  )																				  ' + char(10)
				SELECT @v_dSql +='	  GROUP BY A.SEGMENT4, B.INST_NAME,A.SEGMENT2, A.SEGMENT5						  ' + char(10)
				SELECT @v_dSql +='	  ORDER BY SORT_ORDER															  ' + char(10)

				--SELECT @v_dSql
				exec sp_executesql @v_dSql;
			END
		/****************************************************************************************************************************************/
		/*   FP00510 find_InstanceId 정보갖고오기                                                                                               */
		/*   Param :@Param1	:DIVISION , @Param2	:SITE        																					*/
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00510_find_InstanceId'

			BEGIN
				SELECT @v_dSql = '';
				SELECT @v_dSql +='      SELECT A.SEGMENT4 AS CODE, ISNULL(B.INST_NAME,A.SEGMENT4) AS NAME		      ' + char(10)
				SELECT @v_dSql +='		   , MAX(A.SORT_ORDER) AS SORT_ORDER                                          ' + char(10)
				SELECT @v_dSql +='	  FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)									  ' + char(10)
				SELECT @v_dSql +='	  LEFT OUTER JOIN (																  ' + char(10)
				SELECT @v_dSql +='		  SELECT SEGMENT1 AS INST, SEGMENT2 AS INST_NAME							  ' + char(10)
				SELECT @v_dSql +='		  FROM   SCM_SYS_LOOKUP_VALUE B WITH(NOLOCK)								  ' + char(10)
				SELECT @v_dSql +='		  WHERE  B.LOOKUP_TYPE_CODE = ''INSTANCE_ID''								  ' + char(10)
				SELECT @v_dSql +='		  AND    B.ACTIVE_FLAG      = ''Y''											  ' + char(10)
				SELECT @v_dSql +='	  ) B																			  ' + char(10)
				SELECT @v_dSql +='	  ON     A.SEGMENT4         = B.INST											  ' + char(10)
				SELECT @v_dSql +='	  LEFT JOIN ( SELECT DISTINCT DIVISION_ID, DIVISION_NAME                          ' + char(10)
				SELECT @v_dSql +='	 	   FROM SCM_DIVISION_M  D WITH(NOLOCK)                                        ' + char(10)
				SELECT @v_dSql +='	 	  ) D                                                                         ' + char(10)
				SELECT @v_dSql +='	 	  ON   A.SEGMENT5         = D.DIVISION_ID									  ' + char(10)
				SELECT @v_dSql +='	  WHERE  A.LOOKUP_TYPE_CODE = ''TARGET_INSTANCE''								  ' + char(10)
				SELECT @v_dSql +='	  AND    A.SEGMENT1         = ''SCP TARGET''									  ' + char(10)
				SELECT @v_dSql +='	  AND    ACTIVE_FLAG        = ''Y''												  ' + char(10)
				SELECT @v_dSql +='	  AND A.SEGMENT4 IN (															  ' + char(10)
				SELECT @v_dSql +='						SELECT DISTINCT B.INSTANCE_ID								  ' + char(10)
			    SELECT @v_dSql +='						FROM   SCM_FACTORY_M A(NOLOCK) 								  ' + char(10)
				SELECT @v_dSql +='						INNER JOIN FP_INSTANCE_FACTORY_M B(NOLOCK)					  ' + char(10)
			    SELECT @v_dSql +='							ON     A.FACTORY_ID=B.FACTORY_ID						  ' + char(10)
			    SELECT @v_dSql +='							AND    B.ACTIVE_FLAG        = ''Y''						  ' + char(10)
			    SELECT @v_dSql +='							WHERE 1=1												  ' + char(10)
			    SELECT @v_dSql +='							AND    A.ACTIVE_FLAG        = ''Y''						  ' + char(10)
				SELECT @v_dSql +=    (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID', 'EQ', @param1 ))     + char(10)
  	            SELECT @v_dSql +=    (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID', 'EQ', @param2 ))         + char(10)
				SELECT @v_dSql +='						 )															  ' + char(10)
				SELECT @v_dSql +='	  AND    EXISTS (																  ' + char(10)
				SELECT @v_dSql +='			SELECT 1																  ' + char(10)
				SELECT @v_dSql +='			FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)								  ' + char(10)
				SELECT @v_dSql +='			WHERE  A.SEGMENT4 = B.INSTANCE_ID										  ' + char(10)
				SELECT @v_dSql +='			AND    B.USER_ID  = '''+ @p_user_id +'''								  ' + char(10)
				SELECT @v_dSql +='	  )																				  ' + char(10)
				SELECT @v_dSql +='	  GROUP BY A.SEGMENT4, B.INST_NAME						                          ' + char(10)
				SELECT @v_dSql +='	  ORDER BY SORT_ORDER															  ' + char(10)

				DECLARE @runstart DATETIME
				DECLARE @runend DATETIME
				SET @runstart = GetDate()
				SET @runend = GetDate()
				exec PR_UI_SQL_LOG 'PR_UI_FP_MASTER_FORM_CODE',  @p_user_id, @p_code,'',@v_dSql,'SELECT',@runstart, @runend
				--INSERT INTO TH_UIS_SQL VALUES ('@@@v_dSql',@p_code,@v_dSql , @param1, getdate() ) ;
				--SELECT @v_dSql
				exec sp_executesql @v_dSql;
			END
		/****************************************************************************************************************************************/
		/*   FP00514 MFG Min-Max Date 정보갖고오기                                                                                                              */
		/*   Param :@Param1	:         																						*/
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00514_findMFGDate'

			BEGIN
				SELECT @v_dSql = ''
				/* Alias setting */																				
				SELECT @v_dSql += '  SELECT MIN(YYYYMMDD) AS MIN_DATE, MAX(YYYYMMDD) AS MAX_DATE  ' + char(10)
				SELECT @v_dSql += '  FROM   TH_UIS_CAL A(NOLOCK)                                  ' + char(10)
				SELECT @v_dSql += '  WHERE   EXISTS (                                             ' + char(10)
				SELECT @v_dSql += '	             SELECT 1                                         ' + char(10)
				SELECT @v_dSql += '              FROM   TH_UIS_CAL B                              ' + char(10)
				SELECT @v_dSql += '	             WHERE  A.ISO_YYYYWW = B.ISO_YYYYWW               ' + char(10)
				SELECT @v_dSql += '	            AND  ( B.YYYYMMDD = CONVERT(VARCHAR(8), DBO.SYSDATE1(), 112) OR B.YYYYMMDD = CONVERT(VARCHAR(8), DBO.SYSDATE1()+7, 112) ) ' + char(10)
				SELECT @v_dSql += '             ) '
			   
				--print @v_dSql
				--INSERT INTO TH_UIS_SQL VALUES ('@@@v_dSql',@p_code,@v_dSql , @param1, getdate() ) ;

				exec sp_executesql @v_dSql
			END

		/****************************************************************************************************************************************/
		/*   FP03590 MFG Min-Max Date 정보갖고오기 : pds target                                                                                 */
		/*   Param :@Param1	:         				                    																		*/
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP03590_findMFGDate'

			BEGIN
				SELECT @v_dSql = ''
				/* Alias setting */																				
				SELECT @v_dSql += 'SELECT MIN(YYYYMMDD) AS MIN_DATE, MAX(YYYYMMDD) AS MAX_DATE ' + char(10)
				SELECT @v_dSql += 'FROM   TH_UIS_CAL A WITH(NOLOCK) ' + char(10)
				SELECT @v_dSql += 'WHERE   EXISTS ( ' + char(10)
				SELECT @v_dSql += '	SELECT 1 ' + char(10)
				SELECT @v_dSql += '	FROM   TH_UIS_CAL B WITH(NOLOCK) ' + char(10)
				SELECT @v_dSql += '	WHERE  A.ISO_YYYYWW = B.ISO_YYYYWW ' + char(10)
				SELECT @v_dSql += '	AND  ( B.YYYYMMDD = CONVERT(VARCHAR(8), DBO.SYSDATE1(), 112) OR B.YYYYMMDD = CONVERT(VARCHAR(8), DBO.SYSDATE1()+(7*7), 112) ) ' + char(10)
				SELECT @v_dSql += ') ' + char(10)

				exec sp_executesql @v_dSql
		END


		/****************************************************************************************************************************************/
		/*   FP00514 find_ProdType 정보갖고오기                                                                                                              */
		/*   Param :@Param1	:         																						*/
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00514_find_ProdType'

			BEGIN
				SELECT @v_dSql = ''       
				SELECT @v_dSql += '  SELECT DISTINCT  A.SEGMENT1 AS DIVISION_ID, A.ATTRIBUTE2 AS CODE, A.SEGMENT3 AS NAME  ' + char(10)
				SELECT @v_dSql += '  FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                            ' + char(10)
				SELECT @v_dSql += '  WHERE  A.LOOKUP_TYPE_CODE = ''DIVISION_DEMAND_TYPE''                                  ' + char(10)
				SELECT @v_dSql += '  AND    A.ACTIVE_FLAG = ''Y''                                                          ' + char(10)
				SELECT @v_dSql += '  AND	   A.SEGMENT5 = ''T''                                                          ' + char(10)
				SELECT @v_dSql += '  AND	   A.ATTRIBUTE3 = ''N''                                                        ' + char(10)

				exec sp_executesql @v_dSql

			END
		/****************************************************************************************************************************************/
		/*   FP00160 findLookUpCode 정보갖고오기                                                                                                              */
		/*   Param :@Param1	:         																						*/
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00160_findLookUpCode'

			BEGIN
				SELECT @v_dSql = ''       
                SELECT @v_dSql += ' SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME  ' + char(10)
                SELECT @v_dSql += ' FROM   SCM_SYS_LOOKUP_VALUE(NOLOCK)  ' + char(10)
                SELECT @v_dSql += ' WHERE  LOOKUP_TYPE_CODE =  '''+ @param1 +''' ' + char(10)
                SELECT @v_dSql += ' AND    ACTIVE_FLAG = ''Y''  ' + char(10)
                SELECT @v_dSql += ' ORDER BY SORT_ORDER  ' + char(10)

				exec sp_executesql @v_dSql

			END
		/****************************************************************************************************************************************/
		/*   FP00460 find_FilterCategory 정보갖고오기                                                                                                              */
		/*   Param :@Param1	:         																						*/
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00460_find_FilterCategory'

			BEGIN
				SELECT @v_dSql = ''       
                SELECT @v_dSql += ' SELECT a.segment1 as CODE, a.segment1 as NAME               ' + char(10)
                SELECT @v_dSql += '    ,a.segment1,a.segment2,a.segment3,a.segment4,a.segment5  ' + char(10)
                SELECT @v_dSql += '    ,a.sort_order                                            ' + char(10)
                SELECT @v_dSql += ' FROM   scm_sys_lookup_value a(NOLOCK)                       ' + char(10)
                SELECT @v_dSql += ' WHERE  a.lookup_type_code = ''SETUP_CATEGORY''              ' + char(10)
                SELECT @v_dSql += ' AND    a.active_flag=''Y''                                  ' + char(10)
                SELECT @v_dSql += ' ORDER BY a.sort_order                                       ' + char(10)

				exec sp_executesql @v_dSql

			END
		/****************************************************************************************************************************************/
		/*   FP00460 findKey 정보갖고오기                                                                                                              */
		/*   Param :@Param1	:         																						*/
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00460_findKey'

			BEGIN
				SELECT @v_dSql = ''       
                SELECT @v_dSql += ' SELECT a.level_code as CODE, ''('' + a.level_code + '')'' + a.level_name as NAME  ' + char(10)
                SELECT @v_dSql += '       ,a.level , a.operation_group_id, a.operation_group_name  ' + char(10)
                SELECT @v_dSql += ' FROM   scm_item_class_level_m a(NOLOCK)  ' + char(10)
                SELECT @v_dSql += ' WHERE  a.use_flag = ''Y''  ' + char(10)
                SELECT @v_dSql += ' AND    a.level = ''2''  ' + char(10)
                SELECT @v_dSql += ' ORDER BY CODE  ' + char(10)

				exec sp_executesql @v_dSql

			END
		/****************************************************************************************************************************************/
		/*   FP00460 findCalculation 정보갖고오기                                                                                                              */
		/*   Param :@Param1	:         																						*/
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00460_findCalculation'

			BEGIN
				SELECT @v_dSql = ''       
                SELECT @v_dSql += ' SELECT a.segment1 as CODE, a.segment1 as NAME  ' + char(10)
                SELECT @v_dSql += '       ,a.segment1,a.segment2,a.segment3,a.segment4,a.segment5  ' + char(10)
                SELECT @v_dSql += '       ,a.sort_order  ' + char(10)
                SELECT @v_dSql += ' FROM   scm_sys_lookup_value a(NOLOCK)  ' + char(10)
                SELECT @v_dSql += ' WHERE  a.lookup_type_code = ''SETUP_CALCULATION''  ' + char(10)
                SELECT @v_dSql += ' AND    a.active_flag = ''Y''  ' + char(10)
                SELECT @v_dSql += ' ORDER BY a.sort_order  ' + char(10)

				exec sp_executesql @v_dSql

			END
		/****************************************************************************************************************************************/
		/*   FP00460 findRefOperation 정보갖고오기                                                                                                              */
		/*   Param :@Param1	:         																						*/
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00460_findRefOperation'

			BEGIN
				SELECT @v_dSql = ''       
                SELECT @v_dSql += ' SELECT a.company_id, a.division_id, a.site_id, a.operation_id ,a.operation_name  ' + char(10)
                SELECT @v_dSql += '       ,a.operation_group_id, a.operation_group_name  ' + char(10)
                SELECT @v_dSql += '       ,a.operation_id as CODE, ''('' + a.operation_id + '')'' + a.operation_name as NAME  ' + char(10)
                SELECT @v_dSql += ' FROM   scm_operation_m a(NOLOCK), (  ' + char(10)
                SELECT @v_dSql += '           SELECT b.company_id,b.division_id,b.site_id  ' + char(10)
                SELECT @v_dSql += '           FROM th_uis_user_factory_relate a(NOLOCK), th_uis_role_factory_relate b(NOLOCK)  ' + char(10)
                SELECT @v_dSql += '           WHERE A.USER_ID = '''+ @p_user_id +'''  ' + char(10)
                SELECT @v_dSql += '           AND   A.ROLE_ID = B.ROLE_ID  ' + char(10)
                SELECT @v_dSql += '           AND   A.USE_AT_FLAG = ''Y''  ' + char(10)
                SELECT @v_dSql += '           AND   B.USE_AT_FLAG = ''Y''  ' + char(10)
                SELECT @v_dSql += '           GROUP BY b.company_id,b.division_id,b.site_id  ' + char(10)
                SELECT @v_dSql += '        ) aa  ' + char(10)
                SELECT @v_dSql += ' WHERE a.company_id = aa.company_id  ' + char(10)
                SELECT @v_dSql += ' AND   a.division_id = aa.division_id  ' + char(10)
                SELECT @v_dSql += ' AND   a.site_id = aa.site_id  ' + char(10)
                SELECT @v_dSql += ' AND   a.active_flag = ''Y''  ' + char(10)
                SELECT @v_dSql += ' ORDER BY a.operation_group_id, a.operation_id desc  ' + char(10)

				exec sp_executesql @v_dSql

			END
		/****************************************************************************************************************************************/
		/*   FP00518 findInstanceList_common 정보갖고오기                                                                                       */
		/*   Param :@Param1	:         																						*/
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00518_findInstanceList_common'

			BEGIN
				SELECT @v_dSql = ''       
                SELECT @v_dSql += ' SELECT A.INSTANCE_ID AS CODE, B.SEGMENT2 AS NAME, B.SORT_ORDER  ' + char(10)
                SELECT @v_dSql += ' 	, B.ATTRIBUTE3 AS USE_WOW_STATUS   ' + char(10)
                SELECT @v_dSql += ' 	, B.ATTRIBUTE1 AS CONFIRM_AREA     ' + char(10)
                SELECT @v_dSql += ' 	, B.ATTRIBUTE2 AS IS_SAME_PLAN_ID  ' + char(10)
                SELECT @v_dSql += ' 	, C.SITE_ID  ' + char(10)
                SELECT @v_dSql += ' FROM 	(        ' + char(10)
                SELECT @v_dSql += '            SELECT DISTINCT B.INSTANCE_ID              ' + char(10)
                SELECT @v_dSql += '            FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)  ' + char(10)
                SELECT @v_dSql += '            WHERE  B.USER_ID = '''+ @p_user_id +'''    ' + char(10)
                SELECT @v_dSql += '         ) A  ' + char(10)
                SELECT @v_dSql += ' 		, SCM_SYS_LOOKUP_VALUE B WITH(NOLOCK)         ' + char(10)
                SELECT @v_dSql += ' 		, (  ' + char(10)
                SELECT @v_dSql += '             SELECT B.INSTANCE_ID, MAX(A.SITE_ID) AS SITE_ID  ' + char(10)
                SELECT @v_dSql += '             FROM   SCM_FACTORY_M A WITH(NOLOCK), FP_INSTANCE_FACTORY_M B WITH(NOLOCK)  ' + char(10)
                SELECT @v_dSql += '             WHERE  A.FACTORY_ID  = B.FACTORY_ID  ' + char(10)
                SELECT @v_dSql += '             AND    A.ACTIVE_FLAG = ''Y''         ' + char(10)
                SELECT @v_dSql += '             AND    B.ACTIVE_FLAG = ''Y''         ' + char(10)
                SELECT @v_dSql += '             GROUP BY B.INSTANCE_ID               ' + char(10)
                SELECT @v_dSql += ' 			) C                             ' + char(10)
                SELECT @v_dSql += ' WHERE A.INSTANCE_ID      = B.SEGMENT1       ' + char(10)
                SELECT @v_dSql += ' AND   A.INSTANCE_ID      = C.INSTANCE_ID    ' + char(10)
                SELECT @v_dSql += ' AND   B.LOOKUP_TYPE_CODE = ''INSTANCE_ID''  ' + char(10)
                SELECT @v_dSql += ' AND   B.SEGMENT1 IN (                       ' + char(10)
                SELECT @v_dSql += '                      SELECT INSTANCE_ID     ' + char(10)
                SELECT @v_dSql += '                      FROM   FP_AMEND_UI_V   ' + char(10)
                SELECT @v_dSql += '                      WHERE  AMEND_UI_NAME =  '''+ @param1 +'''  ' + char(10)
                SELECT @v_dSql += '                      AND    USE_FLAG = ''Y''  ' + char(10)
                SELECT @v_dSql += '                      )  ' + char(10)
                SELECT @v_dSql += ' ORDER BY B.SORT_ORDER   ' + char(10)

				exec sp_executesql @v_dSql

			END
		/****************************************************************************************************************************************/
		/*   FP00518 find_cellType 정보갖고오기                                                                                       */
		/*   Param :@Param1	:         																						*/
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00518_find_cellType'

			BEGIN
				SELECT @v_dSql = ''       
                SELECT @v_dSql += ' SELECT A.CELL_TYPE AS CODE, A.CELL_TYPE AS NAME                                                                 ' + char(10)
                SELECT @v_dSql += ' FROM (                                                                                                          ' + char(10)
                SELECT @v_dSql += ' 		SELECT 	DISTINCT (CASE WHEN LEVEL_4_NAME = ''-'' THEN LEVEL_2_NAME ELSE LEVEL_4_NAME END) AS CELL_TYPE  ' + char(10)
                SELECT @v_dSql += ' 		FROM 	SCM_ITEM_CLASS_M A WITH(NOLOCK)                                                                 ' + char(10)
                SELECT @v_dSql += ' 		WHERE 	LEVEL_1_NAME = ''Model''                                                                        ' + char(10)
                SELECT @v_dSql += ' 		AND 	USE_FLAG = ''Y''                                                                                ' + char(10)
                SELECT @v_dSql += ' 		AND 	SCP_OPERATION_GROUP = ''A''                                                                     ' + char(10)
                SELECT @v_dSql += ' 		AND 	CASE WHEN LEVEL_4_NAME = ''-'' THEN LEVEL_2_NAME ELSE LEVEL_4_NAME END != ''-''                 ' + char(10)
                SELECT @v_dSql += ' 	) A                                                                                                         ' + char(10)
                SELECT @v_dSql += ' ORDER BY CODE                                                                                                   ' + char(10)

				exec sp_executesql @v_dSql
			END
		/****************************************************************************************************************************************/
		/*   FP00518 find_pancakeType 정보갖고오기                                                                                       */
		/*   Param :@Param1	:         																						*/
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00518_find_pancakeType'

			BEGIN
				SELECT @v_dSql = ''       
                SELECT @v_dSql += ' SELECT 	DISTINCT LEVEL_3_NAME AS CODE, LEVEL_3_NAME AS NAME  ' + char(10)
                SELECT @v_dSql += ' FROM 	SCM_ITEM_CLASS_M A WITH(NOLOCK)                      ' + char(10)
                SELECT @v_dSql += ' WHERE 	LEVEL_2_CODE = ''APC''                               ' + char(10)
                SELECT @v_dSql += ' AND 	LEVEL_3_CODE NOT IN (''-'',''APCSR'')                ' + char(10)
                SELECT @v_dSql += ' ORDER BY CODE                                                ' + char(10)

				exec sp_executesql @v_dSql
			END
		/****************************************************************************************************************************************/
		/*   FP00518 find_WPPWeek 정보갖고오기                                                                                       */
		/*   Param :@Param1	:         																						*/
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00518_find_WPPWeek'

			BEGIN
				SELECT @v_dSql = ''       
                SELECT @v_dSql += ' SELECT DISTINCT A.ISO_YYYYWW AS CODE, SUBSTRING(A.ISO_YYYYWW,1,4) + ''-'' + SUBSTRING(A.ISO_YYYYWW,5,2) AS NAME  ' + char(10)
                SELECT @v_dSql += ' FROM   TH_UIS_CAL A WITH(NOLOCK)                                                                                  ' + char(10)
                SELECT @v_dSql += ' WHERE  A.YYYYMMDD BETWEEN CONVERT(VARCHAR,DATEADD(mm,-5,GETDATE()),112) AND CONVERT(VARCHAR,GETDATE(),112)        ' + char(10)
                SELECT @v_dSql += ' ORDER BY 1 DESC                                                                                                   ' + char(10)

				exec sp_executesql @v_dSql
			END
		/****************************************************************************************************************************************/
		/*   FP00518 find_WPPSeq 정보갖고오기                                                                                       */
		/*   Param :@Param1	:         																						*/
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00518_find_WPPSeq'

			BEGIN
				SELECT @v_dSql = ''       
                SELECT @v_dSql += ' SELECT A.WPP_SEQ AS CODE, A.WPP_SEQ AS NAME                 ' + char(10)
                SELECT @v_dSql += '      , CONVERT(VARCHAR, MIN(A.SHIP_DATE), 112) AS MIN_DATE  ' + char(10)
                SELECT @v_dSql += '      , CONVERT(VARCHAR, MAX(A.SHIP_DATE), 112) AS MAX_DATE  ' + char(10)
                SELECT @v_dSql += ' FROM   FP_SHIPMENT_PLAN_WPP_H A WITH(NOLOCK)                ' + char(10)
                SELECT @v_dSql += ' WHERE  A.INSTANCE_ID = '''+ @param1 +'''                    ' + char(10)
                SELECT @v_dSql += ' AND    A.WPP_WEEK    = '''+ @param2 +'''                    ' + char(10)
                SELECT @v_dSql += ' GROUP BY A.WPP_SEQ                                          ' + char(10)
                SELECT @v_dSql += ' ORDER BY 1 DESC                                             ' + char(10)

				exec sp_executesql @v_dSql
			END
		/****************************************************************************************************************************************/
		/*   FP00518 find_currVersion 정보갖고오기                                                                                       */
		/*   Param :@Param1	:         																						*/
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00518_find_currVersion'

			BEGIN
				SELECT @v_dSql = ''       
                SELECT @v_dSql += ' WITH MAIN AS                ' + char(10)
                SELECT @v_dSql += '    (   SELECT CASE WHEN FORMAT(DBO.FN_SITE_TIME(B.SITE_ID) ,''yyyyMMddHHmmss'') < CONVERT(VARCHAR,DBO.FN_SITE_TIME(B.SITE_ID),112) + A.BASIS_START_TIME   ' + char(10)
                SELECT @v_dSql += '           THEN CONVERT(DATE, DATEADD(DD,-1,DBO.FN_SITE_TIME(B.SITE_ID)))                            ' + char(10)
                SELECT @v_dSql += '           ELSE CONVERT(DATE, DBO.FN_SITE_TIME(B.SITE_ID)) END AS CURR_DATE, A.INSTANCE_ID           ' + char(10)
                SELECT @v_dSql += '        FROM   FP_INSTANCE_START_TIME_V A                                                            ' + char(10)
                SELECT @v_dSql += '        , (                                                                                          ' + char(10)
                SELECT @v_dSql += '           SELECT MAX(B.SITE_ID) AS SITE_ID                                                          ' + char(10)
                SELECT @v_dSql += '           FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK), SCM_FACTORY_M B WITH(NOLOCK)                 ' + char(10)
                SELECT @v_dSql += '           WHERE  A.FACTORY_ID = B.FACTORY_ID                                                        ' + char(10)
                SELECT @v_dSql += '           AND    A.ACTIVE_FLAG = ''Y''                                                              ' + char(10)
                SELECT @v_dSql += '           AND    B.ACTIVE_FLAG = ''Y''                                                              ' + char(10)
                SELECT @v_dSql += '           AND    A.INSTANCE_ID = '''+ @param1 +'''                                                  ' + char(10)
                SELECT @v_dSql += '          ) B                                                                                        ' + char(10)
                SELECT @v_dSql += '        WHERE  A.INSTANCE_ID = '''+ @param1 +'''                                                     ' + char(10)
                SELECT @v_dSql += '     )                                                                                               ' + char(10)
                SELECT @v_dSql += ' SELECT ISNULL(CONVERT(CHAR(19), B.INSTANCE_DATE, 20),CONVERT(CHAR(19), A.CURR_DATE, 20)) AS INSTANCE_DATE  ' + char(10)
				SELECT @v_dSql += ' , ISNULL(B.VERSION_ID,1) AS VERSION_ID , A.INSTANCE_ID                                              ' + char(10)
                SELECT @v_dSql += ' FROM  MAIN A                                                                                        ' + char(10)
                SELECT @v_dSql += '     LEFT OUTER JOIN (                                                                               ' + char(10)
                SELECT @v_dSql += '          SELECT INSTANCE_DATE, MAX(VERSION_ID) AS VERSION_ID                                        ' + char(10)
                SELECT @v_dSql += '          FROM FP_SHIPMENT_PLAN_H A                                                                  ' + char(10)
                SELECT @v_dSql += '          WHERE INSTANCE_DATE = (                                                                    ' + char(10)
                SELECT @v_dSql += '                                 SELECT ISNULL(MAX(AA.INSTANCE_DATE),0) AS INSTANCE_DATE             ' + char(10)
                SELECT @v_dSql += '                                 FROM   FP_SHIPMENT_PLAN_H AA WITH(NOLOCK)                           ' + char(10)
                SELECT @v_dSql += '                                 WHERE  AA.INSTANCE_ID   = '''+ @param1 +'''                         ' + char(10)
                SELECT @v_dSql += '                                )                                                                    ' + char(10)
                SELECT @v_dSql += '          GROUP BY INSTANCE_DATE                                                                     ' + char(10)
                SELECT @v_dSql += '     ) B                                                                                             ' + char(10)
                SELECT @v_dSql += '     ON 1=1                                                                                          ' + char(10)

				exec sp_executesql @v_dSql
			END
		/****************************************************************************************************************************************/
		/*   FP00518 find_newVersion 정보갖고오기                                                                                       */
		/*   Param :@Param1	: Instance_id																					*/
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00518_find_newVersion'

			BEGIN
				SELECT @v_dSql = ''       
                SELECT @v_dSql += ' WITH MAIN AS (                                                                         ' + char(10)
                SELECT @v_dSql += ' 	SELECT CASE WHEN FORMAT(dbo.FN_SITE_TIME(B.SITE_ID) ,''yyyyMMddHHmmss'')           ' + char(10)
				SELECT @v_dSql += ' 	    < CONVERT(VARCHAR,dbo.FN_SITE_TIME(B.SITE_ID),112) + A.BASIS_START_TIME        ' + char(10)
                SELECT @v_dSql += ' 	  		THEN CONVERT(DATE, DATEADD(DD,-1,dbo.FN_SITE_TIME(B.SITE_ID)))             ' + char(10)
                SELECT @v_dSql += ' 	  		ELSE CONVERT(DATE, dbo.FN_SITE_TIME(B.SITE_ID))                            ' + char(10)
                SELECT @v_dSql += ' 			END AS CURR_DATE                                                           ' + char(10)
                SELECT @v_dSql += ' 	FROM   FP_INSTANCE_START_TIME_V A                                                  ' + char(10)
                SELECT @v_dSql += '          ,(                                                                            ' + char(10)
                SELECT @v_dSql += '             SELECT MAX(B.SITE_ID) AS SITE_ID                                           ' + char(10)
                SELECT @v_dSql += '             FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK), SCM_FACTORY_M B WITH(NOLOCK)  ' + char(10)
                SELECT @v_dSql += '             WHERE  A.FACTORY_ID = B.FACTORY_ID                                         ' + char(10)
                SELECT @v_dSql += '             AND    A.ACTIVE_FLAG = ''Y''                                               ' + char(10)
                SELECT @v_dSql += '             AND    B.ACTIVE_FLAG = ''Y''                                               ' + char(10)
                SELECT @v_dSql += '             AND    A.INSTANCE_ID = '''+ @param1 +'''                                   ' + char(10)
                SELECT @v_dSql += '           ) B                                                                          ' + char(10)
                SELECT @v_dSql += ' 	WHERE  A.INSTANCE_ID = '''+ @param1 +'''                                           ' + char(10)
                SELECT @v_dSql += ' )                                                                                      ' + char(10)
                SELECT @v_dSql += ' SELECT CONVERT(VARCHAR, A.CURR_DATE, 112) AS INSTANCE_DATE                             ' + char(10)
				SELECT @v_dSql += '    , (B.VERSION_ID+1) AS VERSION_ID                                                    ' + char(10)
                SELECT @v_dSql += ' FROM   MAIN A                                                                          ' + char(10)
                SELECT @v_dSql += ' 		LEFT OUTER JOIN (                                                              ' + char(10)
                SELECT @v_dSql += ' 			SELECT ISNULL(MAX(AA.VERSION_ID),0) AS VERSION_ID                          ' + char(10)
                SELECT @v_dSql += ' 			FROM   FP_SHIPMENT_PLAN_H AA WITH(NOLOCK)                                  ' + char(10)
                SELECT @v_dSql += ' 			WHERE  AA.INSTANCE_ID   = '''+ @param1 +'''                                ' + char(10)
                SELECT @v_dSql += ' 			AND    AA.INSTANCE_DATE = (SELECT CURR_DATE FROM MAIN)                     ' + char(10)
                SELECT @v_dSql += ' 		) B                                                                            ' + char(10)
                SELECT @v_dSql += ' 		ON 1=1                                                                         ' + char(10)

				exec sp_executesql @v_dSql
			END

		/****************************************************************************************************************************************/
		/*   FP00518 find_WPP_newVersion 정보갖고오기                                                                                       */
		/*   Param :@Param1	:  Instance_id   																						*/
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00518_find_WPP_newVersion'

			BEGIN
				SELECT @v_dSql = ''       
                SELECT @v_dSql += ' SELECT A.INSTANCE_ID, A.WPP_WEEK                               ' + char(10)
                SELECT @v_dSql += '      , (CASE WHEN A.WPP_SEQ = -9999 THEN 1                     ' + char(10)
                SELECT @v_dSql += '              ELSE A.WPP_SEQ+1 END) AS WPP_SEQ                  ' + char(10)
                SELECT @v_dSql += ' FROM (                                                         ' + char(10)
                SELECT @v_dSql += ' 	SELECT '''+ @param1 +''' AS INSTANCE_ID                    ' + char(10)
                SELECT @v_dSql += ' 		 , A.ISO_YYYYWW AS WPP_WEEK                            ' + char(10)
                SELECT @v_dSql += ' 		 , ISNULL(MAX(B.WPP_SEQ), -9999) AS WPP_SEQ            ' + char(10)
                SELECT @v_dSql += ' 	FROM (                                                     ' + char(10)
                SELECT @v_dSql += ' 		SELECT KK.ISO_YYYYWW                                   ' + char(10)
                SELECT @v_dSql += ' 		FROM   TH_UIS_CAL KK WITH(NOLOCK)                      ' + char(10)
                SELECT @v_dSql += ' 		WHERE  KK.YYYYMMDD = CONVERT(VARCHAR, GETDATE(), 112)  ' + char(10)
                SELECT @v_dSql += ' 	) A                                                        ' + char(10)
                SELECT @v_dSql += ' 	LEFT OUTER JOIN FP_SHIPMENT_PLAN_WPP_H B WITH(NOLOCK)      ' + char(10)
                SELECT @v_dSql += ' 	ON  A.ISO_YYYYWW  = B.WPP_WEEK                             ' + char(10)
                SELECT @v_dSql += ' 	AND B.INSTANCE_ID = '''+ @param1 +'''                      ' + char(10)
                SELECT @v_dSql += ' 	GROUP BY A.ISO_YYYYWW                                      ' + char(10)
                SELECT @v_dSql += ' ) A                                                            ' + char(10)

				exec sp_executesql @v_dSql
			END
		/****************************************************************************************************************************************/
		/*   FP02650 findNewBatch 정보갖고오기                                                                                       */
		/*   Param :@Param1	:  COMPANY_ID , :@Param2:  DIVISION_ID , :@Param3:  SITE_ID . :@Param4:  PLANT_ID 	                                */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP02650_findNewBatch'

			BEGIN
				SELECT @v_dSql = ''   
                SELECT @v_dSql += ' SELECT (''BATCH_'' + '''+ @param3 +''' + ''_'')                                                                                ' + char(10)
                SELECT @v_dSql += '        + CASE WHEN A.RATIO_ID = ''EMPTY'' THEN ''0000''                                                                        ' + char(10)
                SELECT @v_dSql += '          ELSE REPLICATE (''0'',4-LEN((CONVERT(NUMERIC, A.RATIO_ID)+1))) + CAST ((CONVERT(NUMERIC, A.RATIO_ID)+1) AS VARCHAR )  ' + char(10)
                SELECT @v_dSql += '          END AS RATIO_ID                                                                                                       ' + char(10)
                SELECT @v_dSql += ' FROM (                                                                                                                         ' + char(10)
                SELECT @v_dSql += '     SELECT ISNULL(CONVERT(VARCHAR, MAX(SUBSTRING(A.RATIO_ID,12,99)*1)), ''EMPTY'') AS RATIO_ID                                 ' + char(10)
                SELECT @v_dSql += '     FROM   SCM_MATERIAL_RATIO_M A WITH(NOLOCK)                                                                                 ' + char(10)
                SELECT @v_dSql += '     WHERE  A.COMPANY_ID   = '''+ @param1 +'''                                                                                  ' + char(10)
                SELECT @v_dSql += '     AND    A.DIVISION_ID  = '''+ @param2 +'''                                                                                  ' + char(10)
                SELECT @v_dSql += '     AND    A.SITE_ID      = '''+ @param3 +'''                                                                                  ' + char(10)
                SELECT @v_dSql += '     AND    A.PLANT_ID     = '''+ @param4 +'''                                                                                  ' + char(10)
                SELECT @v_dSql += '     AND    A.RATIO_ID LIKE (''BATCH_'' + '''+ @param3 +''' + ''_%'')                                                           ' + char(10)
                SELECT @v_dSql += ' ) A                                                                                                                            ' + char(10)
				
				--SELECT @v_dSql
				exec sp_executesql @v_dSql
			END

		/****************************************************************************************************************************************/
		/*   FP00521 find_default_date 정보갖고오기                                                                                       */
		/*   Param :@Param1	:  COMPANY_ID , :@Param2:  DIVISION_ID , :@Param3:  SITE_ID . :@Param4:  PLANT_ID 	                                */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00521_find_default_date'

			BEGIN
				SELECT @v_dSql = ''   
                SELECT @v_dSql += ' SELECT CONVERT(VARCHAR, GETDATE(), 112) AS PLAN_DATE             ' + char(10)
                SELECT @v_dSql += '     , (	SELECT MIN(YYYYMMDD)                                     ' + char(10)
                SELECT @v_dSql += '     FROM   TH_UIS_CAL A WITH(NOLOCK)                             ' + char(10)
                SELECT @v_dSql += '     WHERE  ISO_YYYYWW IN (                                       ' + char(10)
                SELECT @v_dSql += '            SELECT ISO_YYYYWW                                     ' + char(10)
                SELECT @v_dSql += '            FROM   TH_UIS_CAL A WITH(NOLOCK)                      ' + char(10)
                SELECT @v_dSql += '            WHERE  YYYYMMDD = CONVERT(VARCHAR, GETDATE()-28, 112) ' + char(10)
                SELECT @v_dSql += '     ) ) AS START_DATE                                            ' + char(10)
                SELECT @v_dSql += '     , (	SELECT MAX(YYYYMMDD)                                     ' + char(10)
                SELECT @v_dSql += '     FROM   TH_UIS_CAL A WITH(NOLOCK)                             ' + char(10)
                SELECT @v_dSql += '     WHERE  ISO_YYYYWW IN (                                       ' + char(10)
                SELECT @v_dSql += '            SELECT ISO_YYYYWW                                     ' + char(10)
                SELECT @v_dSql += '            FROM   TH_UIS_CAL A WITH(NOLOCK)                      ' + char(10)
                SELECT @v_dSql += '            WHERE  YYYYMMDD = CONVERT(VARCHAR, GETDATE(), 112)    ' + char(10)
                SELECT @v_dSql += '     ) ) AS END_DATE                                              ' + char(10)

				exec sp_executesql @v_dSql
			END
		/****************************************************************************************************************************************/
		/*   FP00521 findInstanceList_common 정보갖고오기                                                                                       */
		/*   Param :@Param1	:  SITE_ID                                                                       	                                */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00521_findInstanceList_common'

			BEGIN
				SELECT @v_dSql = ''   
                SELECT @v_dSql += ' SELECT A.SEGMENT4 AS CODE, ISNULL(B.INST_NAME,A.SEGMENT4) AS NAME     ' + char(10)
				SELECT @v_dSql += '     , MAX(A.SORT_ORDER) AS SORT_ORDER                                 ' + char(10)
                SELECT @v_dSql += ' FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                            ' + char(10)
                SELECT @v_dSql += ' LEFT OUTER JOIN (                                                     ' + char(10)
                SELECT @v_dSql += '     SELECT SEGMENT1 AS INST, SEGMENT2 AS INST_NAME                    ' + char(10)
                SELECT @v_dSql += '     FROM   SCM_SYS_LOOKUP_VALUE B WITH(NOLOCK)                        ' + char(10)
                SELECT @v_dSql += '     WHERE  B.LOOKUP_TYPE_CODE = ''INSTANCE_ID''                       ' + char(10)
                SELECT @v_dSql += '     AND    B.ACTIVE_FLAG      = ''Y''                                 ' + char(10)
                SELECT @v_dSql += ' ) B                                                                   ' + char(10)
                SELECT @v_dSql += ' ON     A.SEGMENT4         = B.INST                                    ' + char(10)
                SELECT @v_dSql += ' WHERE  A.LOOKUP_TYPE_CODE = ''TARGET_INSTANCE''                       ' + char(10)
                SELECT @v_dSql += ' AND    ACTIVE_FLAG        = ''Y''                                     ' + char(10)
                SELECT @v_dSql += ' AND    A.SEGMENT4 IN (                                                ' + char(10)
                SELECT @v_dSql += '                       SELECT DISTINCT B.INSTANCE_ID                   ' + char(10)
                SELECT @v_dSql += '                       FROM   SCM_FACTORY_M A WITH(NOLOCK)             ' + char(10)
                SELECT @v_dSql += '                       INNER JOIN FP_INSTANCE_FACTORY_M B WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += '                        ON     A.FACTORY_ID  = B.FACTORY_ID            ' + char(10)
                SELECT @v_dSql += '                        AND    B.ACTIVE_FLAG = ''Y''                   ' + char(10)
                SELECT @v_dSql += '                        WHERE  A.ACTIVE_FLAG = ''Y''                   ' + char(10)
				IF( LEN(@param1) > 0)
				    BEGIN
                        SELECT @v_dSql += '                        AND    A.SITE_ID     = '''+ @param1 +''' ' + char(10)
					END				
				IF( LEN(@param2) > 0)
				    BEGIN
                        SELECT @v_dSql += '                        AND    A.DIVISION_ID     = '''+ @param2 +''' ' + char(10)
					END

                SELECT @v_dSql += '                      )                                ' + char(10)
                SELECT @v_dSql += ' AND  EXISTS (                                         ' + char(10)
                SELECT @v_dSql += '             SELECT 1                                  ' + char(10)
                SELECT @v_dSql += '             FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += '             WHERE  A.SEGMENT4 = B.INSTANCE_ID         ' + char(10)
                SELECT @v_dSql += '             AND    B.USER_ID  = '''+ @p_user_id +'''  ' + char(10)
                SELECT @v_dSql += ' )                                                     ' + char(10)
                SELECT @v_dSql += ' AND   A.SEGMENT3 IN (''A'',''P'') -- 조립, 팩만 출력  ' + char(10)
                SELECT @v_dSql += ' AND   A.SEGMENT4 NOT LIKE ''%FORM%''                  ' + char(10)
                SELECT @v_dSql += ' GROUP BY A.SEGMENT4, B.INST_NAME                      ' + char(10)
                SELECT @v_dSql += ' ORDER BY SORT_ORDER                                   ' + char(10)

				exec sp_executesql @v_dSql
			END
		/****************************************************************************************************************************************/
		/*   FP00521 find_SCP_Plan_List 정보갖고오기                                                                                       */
		/*   Param :@Param1	:  INSATACE_ID , @Param2	:  PLAN_DATE                                                                          */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00521_find_SCP_Plan_List'

			BEGIN
				SELECT @v_dSql = ''  
                SELECT @v_dSql += ' SELECT DISTINCT TOP 20 CODE, NAME, SCP_PLAN_ID, PLAN_DATE                                ' + char(10)
                SELECT @v_dSql += '     , ( SELECT CONVERT(VARCHAR, MIN(DT-28), 112) AS START_DATE                           ' + char(10)
                SELECT @v_dSql += '         FROM   TH_UIS_CAL A WITH(NOLOCK)                                                 ' + char(10)
                SELECT @v_dSql += '         WHERE  ISO_YYYYWW IN (                                                           ' + char(10)
                SELECT @v_dSql += '                     SELECT ISO_YYYYWW                                                    ' + char(10)
                SELECT @v_dSql += '                     FROM   TH_UIS_CAL A WITH(NOLOCK)                                     ' + char(10)
                SELECT @v_dSql += '                     WHERE  YYYYMMDD = AA.PLAN_DATE                                       ' + char(10)
                SELECT @v_dSql += '         ) ) AS START_DATE                                                                ' + char(10)
                SELECT @v_dSql += '     , (	SELECT MAX(YYYYMMDD)                                                             ' + char(10)
                SELECT @v_dSql += '         FROM   TH_UIS_CAL A WITH(NOLOCK)                                                 ' + char(10)
                SELECT @v_dSql += '         WHERE  ISO_YYYYWW IN (                                                           ' + char(10)
                SELECT @v_dSql += '                      SELECT ISO_YYYYWW                                                   ' + char(10)
                SELECT @v_dSql += '                      FROM   TH_UIS_CAL A WITH(NOLOCK)                                    ' + char(10)
                SELECT @v_dSql += '                      WHERE  YYYYMMDD = AA.PLAN_DATE                                      ' + char(10)
                SELECT @v_dSql += '         ) ) AS END_DATE                                                                  ' + char(10)
                SELECT @v_dSql += ' FROM (                                                                                   ' + char(10)
                SELECT @v_dSql += '       SELECT SCP_PLAN_ID AS CODE, SCP_PLAN_ID AS NAME                                    ' + char(10)
                SELECT @v_dSql += ' 	     , SCP_PLAN_ID, SUBSTRING(SCP_PLAN_ID, 1, 8) AS PLAN_DATE                        ' + char(10)
                SELECT @v_dSql += '       FROM   FP_WEEKLY_DEMAND_PRODUCT_H A WITH(NOLOCK)                                   ' + char(10)
                SELECT @v_dSql += '       WHERE  1=1                                                                         ' + char(10)
                SELECT @v_dSql += '       AND    (A.DIVISION_ID+A.SHOP_GROUP_ID+A.SITE_ID) IN (                              ' + char(10)
                SELECT @v_dSql += '                          SELECT DISTINCT A.DIVISION_ID+B.SHOP_GROUP_ID+A.SITE_ID AS CODE ' + char(10)
                SELECT @v_dSql += '                          FROM   SCM_FACTORY_M A WITH(NOLOCK)                             ' + char(10)
                SELECT @v_dSql += '                          INNER JOIN FP_INSTANCE_FACTORY_M B WITH(NOLOCK)                 ' + char(10)
                SELECT @v_dSql += '                          ON    A.FACTORY_ID  = B.FACTORY_ID                              ' + char(10)
                SELECT @v_dSql += '                          AND   B.ACTIVE_FLAG = ''Y''                                     ' + char(10)
                SELECT @v_dSql += '                          WHERE A.ACTIVE_FLAG = ''Y''                                     ' + char(10)
                SELECT @v_dSql += '                          AND   B.INSTANCE_ID = '''+ @param1 +'''                         ' + char(10)
                SELECT @v_dSql += '       )                                                                                  ' + char(10)
                SELECT @v_dSql += ' ) AA                                                                                     ' + char(10)
                SELECT @v_dSql += ' WHERE AA.PLAN_DATE <= '''+ @param2 +'''                                                  ' + char(10)
                SELECT @v_dSql += ' ORDER BY CODE DESC                                                                       ' + char(10)		

				--SELECT @v_dSql
				exec sp_executesql @v_dSql
			END
		/****************************************************************************************************************************************/
		/*   FP00521 find_FPProdType 정보갖고오기                                                                                       */
		/*   Param :@Param1	:  INSATACE_ID                                                                                             */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00521_find_FPProdType'

			BEGIN
				SELECT @v_dSql = ''   
                SELECT @v_dSql += ' SELECT DISTINCT A.ATTRIBUTE2 AS CODE, A.ATTRIBUTE2 AS NAME ' + char(10)
                SELECT @v_dSql += ' FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                 ' + char(10)
                SELECT @v_dSql += ' WHERE  A.LOOKUP_TYPE_CODE = ''DIVISION_DEMAND_TYPE''       ' + char(10)
                SELECT @v_dSql += ' AND    A.ACTIVE_FLAG = ''Y''                               ' + char(10)

				IF( LEN(@param1) > 0)
				    BEGIN
                        SELECT @v_dSql += ' AND   A.SEGMENT1 IN (                             ' + char(10)
                        SELECT @v_dSql += '         SELECT DISTINCT VV.DIVISION_ID            ' + char(10)
                        SELECT @v_dSql += '         FROM   FP_INSTANCE_INFO_V VV WITH(NOLOCK) ' + char(10)
                        SELECT @v_dSql += '         WHERE  VV.INSTANCE_ID = '''+ @param1 +''' ' + char(10)
                        SELECT @v_dSql += '         )                                         ' + char(10)
					END				

				exec sp_executesql @v_dSql
			END
		/****************************************************************************************************************************************/
		/*   FP00521 find_WeekCnt 정보갖고오기                                                                                       */
		/*   Param :@Param1	:  bucket_from,      :@Param2	:  bucket_to                                                            */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00521_find_WeekCnt'

			BEGIN
				SELECT @v_dSql = ''  
                SELECT @v_dSql += ' SELECT ISO_YYYYWW AS WEEK                                                             ' + char(10)
                SELECT @v_dSql += '      , (SUBSTRING(ISO_YYYYWW,1,4) + ''W'' + SUBSTRING(ISO_YYYYWW,5,2)) AS WEEK_NAME   ' + char(10)
                SELECT @v_dSql += '      , 1 AS WEEK_COUNT                                                                ' + char(10)
                SELECT @v_dSql += '      , ''W'' + CONVERT(VARCHAR,(ROW_NUMBER() OVER(ORDER BY ISO_YYYYWW))-1) AS W_VALUE ' + char(10)
                SELECT @v_dSql += '      , ''1'' AS IS_DAY_VIEW                                                           ' + char(10)
                SELECT @v_dSql += ' FROM   TH_UIS_CAL AS CAL WITH(NOLOCK)                                                 ' + char(10)
                SELECT @v_dSql += ' WHERE  CAL.DT >= CONVERT(DATETIME, '''+ @param1 +''', 112)                            ' + char(10)
                SELECT @v_dSql += ' AND    CAL.DT <= CONVERT(DATETIME, '''+ @param2 +''', 112)                            ' + char(10)
                SELECT @v_dSql += ' GROUP BY ISO_YYYYWW                                                                   ' + char(10)
                SELECT @v_dSql += ' ORDER BY ISO_YYYYWW                                                                   ' + char(10)

				exec sp_executesql @v_dSql
			END
		/****************************************************************************************************************************************/
		/*   FP00521 find_MonthCnt 정보갖고오기                                                                                       */
		/*   Param :@Param1	:  scp_plan_id                                                                                               */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'find_MonthCnt'

			BEGIN
				SELECT @v_dSql = ''  
                SELECT @v_dSql += ' SELECT YYYYMM AS MONTH                     ' + char(10)
                SELECT @v_dSql += '    , SUBSTRING(YYYYMM,1,4) + ''-'' +       ' + char(10)
                SELECT @v_dSql += '     (CASE WHEN MONTH = ''01'' THEN ''Jan'' ' + char(10)
                SELECT @v_dSql += '           WHEN MONTH = ''02'' THEN ''Feb'' ' + char(10)
                SELECT @v_dSql += '           WHEN MONTH = ''03'' THEN ''Mar'' ' + char(10)
                SELECT @v_dSql += '           WHEN MONTH = ''04'' THEN ''Apr'' ' + char(10)
                SELECT @v_dSql += '           WHEN MONTH = ''05'' THEN ''May'' ' + char(10)
                SELECT @v_dSql += '           WHEN MONTH = ''06'' THEN ''Jun'' ' + char(10)
                SELECT @v_dSql += '           WHEN MONTH = ''07'' THEN ''Jul'' ' + char(10)
                SELECT @v_dSql += '           WHEN MONTH = ''08'' THEN ''Aug'' ' + char(10)
                SELECT @v_dSql += '           WHEN MONTH = ''09'' THEN ''Sep'' ' + char(10)
                SELECT @v_dSql += '           WHEN MONTH = ''10'' THEN ''Oct'' ' + char(10)
                SELECT @v_dSql += '           WHEN MONTH = ''11'' THEN ''Nov'' ' + char(10)
                SELECT @v_dSql += '           ELSE ''Dec'' END) AS MONTH_NAME  ' + char(10)
                SELECT @v_dSql += '    , COUNT(*) AS MONTH_COUNT               ' + char(10)
                SELECT @v_dSql += '    , ''M'' + CONVERT(VARCHAR,(ROW_NUMBER() OVER(ORDER BY YYYYMM))-1) AS M_VALUE ' + char(10)
                SELECT @v_dSql += ' FROM   TH_UIS_CAL AS CAL WITH(NOLOCK)                     ' + char(10)
                SELECT @v_dSql += ' WHERE  CAL.DT >= CONVERT(DATETIME,'''+ @param1 +''', 112) ' + char(10)
                SELECT @v_dSql += ' AND    CAL.DT <= CONVERT(DATETIME,'''+ @param2 +''', 112) ' + char(10)
                SELECT @v_dSql += ' GROUP BY YYYYMM, MONTH                                    ' + char(10)
                SELECT @v_dSql += ' ORDER BY YYYYMM                                           ' + char(10)

				exec sp_executesql @v_dSql
			END
		/****************************************************************************************************************************************/
		/*   FP00521 find_PlanWeekCnt 정보갖고오기                                                                                       */
		/*   Param :@Param1	:  scp_plan_id                                                                                               */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00521_find_PlanWeekCnt'

			BEGIN
				SELECT @v_dSql = ''  
                SELECT @v_dSql += ' SELECT DISTINCT ISO_YYYYWW AS PLAN_WEEK                                                                                                         ' + char(10)
                SELECT @v_dSql += ' FROM   TH_UIS_CAL A WITH(NOLOCK)                                                                                                                ' + char(10)
                SELECT @v_dSql += ' WHERE A.YYYYMMDD BETWEEN CONVERT(VARCHAR, CONVERT(DATETIME,SUBSTRING('''+ @param1 +''',1,8))-(7*4), 112) AND SUBSTRING('''+ @param1 +''',1,8) ' + char(10)

				exec sp_executesql @v_dSql
			END

		/****************************************************************************************************************************************/
		/*   FP00521 find_BucketWeekCnt 정보갖고오기                                                                                       */
		/*   Param :@Param1	:  bucket_from,      :@Param2	:  bucket_to                                                                   */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00521_find_BucketWeekCnt'

			BEGIN
				SELECT @v_dSql = ''  
                SELECT @v_dSql += ' SELECT MIN(ISO_YYYYWW) AS BUCKET_FROM_WEEK                          ' + char(10)
				SELECT @v_dSql += '       , MAX(ISO_YYYYWW) AS BUCKET_TO_WEEK                           ' + char(10)
                SELECT @v_dSql += ' FROM   TH_UIS_CAL A WITH(NOLOCK)                                    ' + char(10)
                SELECT @v_dSql += ' WHERE  A.YYYYMMDD BETWEEN '''+ @param1 +'''  AND '''+ @param2 +''' ' + char(10)

				exec sp_executesql @v_dSql
			END
		/****************************************************************************************************************************************/
		/*   FP00521 find_MonthColumn 정보갖고오기                                                                                       */
		/*   Param :@Param1	:  bucket_from,      :@Param2	:  bucket_to                                                                   */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00521_find_MonthColumn'

			BEGIN
				SELECT @v_dSql = ''  
                SELECT @v_dSql += ' WITH AA AS (                                                                            ' + char(10)
                SELECT @v_dSql += ' 	SELECT YYYYMM, ISO_YYYYWW AS YYYYWW                                                 ' + char(10)
                SELECT @v_dSql += '         , ''M'' + CONVERT(VARCHAR, (DENSE_RANK() OVER(ORDER BY YYYYMM))-1) AS _MONTH    ' + char(10)
                SELECT @v_dSql += '         , ''W'' + CONVERT(VARCHAR, (ROW_NUMBER() OVER(ORDER BY ISO_YYYYWW))-1) AS _WEEK ' + char(10)
                SELECT @v_dSql += ' 	FROM   TH_UIS_CAL AS CAL WITH(NOLOCK)                                               ' + char(10)
                SELECT @v_dSql += ' 	WHERE  ISO_YYYYWW IN (                                                              ' + char(10)
                SELECT @v_dSql += '                  SELECT DISTINCT ISO_YYYYWW                                             ' + char(10)
                SELECT @v_dSql += '                  FROM   TH_UIS_CAL AS CAL WITH(NOLOCK)                                  ' + char(10)
                SELECT @v_dSql += '                  WHERE  CAL.DT >= CONVERT(DATETIME, '''+ @param1 +''', 112)             ' + char(10)
                SELECT @v_dSql += '                  AND    CAL.DT <= CONVERT(DATETIME, '''+ @param2 +''', 112)             ' + char(10)
                SELECT @v_dSql += '     )                                                                                   ' + char(10)
                SELECT @v_dSql += '     AND    DAY_SEQ = 5                                                                  ' + char(10)
                SELECT @v_dSql += ' )                                                                                       ' + char(10)
                SELECT @v_dSql += ' SELECT DISTINCT A._MONTH AS MONTH_COLUMN, A.YYYYMM                                      ' + char(10)
                SELECT @v_dSql += '     ,STUFF(( SELECT ''+'' + _WEEK                                                       ' + char(10)
                SELECT @v_dSql += '              FROM   AA B                                                                ' + char(10)
                SELECT @v_dSql += '              WHERE  A._MONTH  = B._MONTH                                                ' + char(10)
                SELECT @v_dSql += '              FOR XML PATH('''')                                                         ' + char(10)
                SELECT @v_dSql += '              ),1,1,'''') AS WEEK_COLUMN                                                 ' + char(10)
                SELECT @v_dSql += ' FROM AA A                                                                               ' + char(10)
                SELECT @v_dSql += ' ORDER BY A.YYYYMM                                                                       ' + char(10)

				exec sp_executesql @v_dSql
			END
		/****************************************************************************************************************************************/
		/*   FP00521 find_currWeek 정보갖고오기                                                                                                 */
		/*   Param :@Param1	:                                                                                                                   */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00521_find_currWeek'

			BEGIN
				SELECT @v_dSql = ''  
                SELECT @v_dSql += ' SELECT CC.ISO_YYYYWW AS CURR_WEEK FROM TH_UIS_CAL CC WITH(NOLOCK) WHERE CC.YYYYMMDD = CONVERT(VARCHAR, GETDATE(), 112) ' + char(10)
				
				exec sp_executesql @v_dSql
			END
		/****************************************************************************************************************************************/
		/*   FP00521 find_bukInfo 정보갖고오기                                                                                       */
		/*   Param :@Param1	:  bucket_from,      :@Param2	:  bucket_to                                                                   */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00521_find_bukInfo'

			BEGIN
				SELECT @v_dSql = ''  
                SELECT @v_dSql += ' SELECT A.*                                  ' + char(10)
                SELECT @v_dSql += ' FROM (                                      ' + char(10)
                SELECT @v_dSql += '     SELECT A._DATE, A._NAME, A._COUNT       ' + char(10)
                SELECT @v_dSql += '          , (A._VALUE + B.POSTFIX) AS _VALUE ' + char(10)
                SELECT @v_dSql += '          , A._DATE_SEQ, A.WEEK_SEQ, A._TYPE ' + char(10)
                SELECT @v_dSql += '          , B.POST_ORDER                     ' + char(10)
                SELECT @v_dSql += '     FROM (                                  ' + char(10)
                SELECT @v_dSql += '         SELECT YYYYMMDD AS _DATE            ' + char(10)
                SELECT @v_dSql += '               ,SUBSTRING(YYYYMMDD,1,4) + ''-'' + SUBSTRING(YYYYMMDD,5,2) + ''-'' + SUBSTRING(YYYYMMDD,7,2) + '' '' ' + char(10)
                SELECT @v_dSql += '               +(CASE WHEN DAY_SEQ=2 THEN ''(Mon)'' ' + char(10)
                SELECT @v_dSql += '                      WHEN DAY_SEQ=3 THEN ''(Tue)'' ' + char(10)
                SELECT @v_dSql += '                      WHEN DAY_SEQ=4 THEN ''(Wed)'' ' + char(10)
                SELECT @v_dSql += '                      WHEN DAY_SEQ=5 THEN ''(Thu)'' ' + char(10)
                SELECT @v_dSql += '                      WHEN DAY_SEQ=6 THEN ''(Fri)'' ' + char(10)
                SELECT @v_dSql += '                      WHEN DAY_SEQ=7 THEN ''(Sat)'' ' + char(10)
                SELECT @v_dSql += '                      ELSE ''(SUN)'' END) AS _NAME  ' + char(10)
                SELECT @v_dSql += '               , 1 AS _COUNT                        ' + char(10)
                SELECT @v_dSql += '               ,''D'' + CONVERT(VARCHAR,(ROW_NUMBER() OVER(ORDER BY YYYYMMDD))-1) AS _VALUE   ' + char(10)
                SELECT @v_dSql += '               , 1 AS _DATE_SEQ                                           ' + char(10)
                SELECT @v_dSql += '               , ISO_YYYYWW AS WEEK_SEQ                                   ' + char(10)
                SELECT @v_dSql += '               , ''D'' AS _TYPE                                           ' + char(10)
                SELECT @v_dSql += '         FROM   TH_UIS_CAL A WITH(NOLOCK)                                 ' + char(10)
                SELECT @v_dSql += '         WHERE  YYYYMMDD BETWEEN '''+ @param1 +''' AND '''+ @param2 +'''  ' + char(10)
                SELECT @v_dSql += '     ) A                                                                  ' + char(10)
                SELECT @v_dSql += '     INNER JOIN (                                                         ' + char(10)
                SELECT @v_dSql += '         SELECT '''' AS POSTFIX, 10 AS POST_ORDER                         ' + char(10)
                SELECT @v_dSql += '     ) B                                                                  ' + char(10)
                SELECT @v_dSql += '     ON     1=0                                                           ' + char(10)
                SELECT @v_dSql += '     UNION ALL                                                            ' + char(10)
                SELECT @v_dSql += '     SELECT A._DATE, A._NAME, A._COUNT                                    ' + char(10)
                SELECT @v_dSql += '          , (A._VALUE + B.POSTFIX) AS _VALUE                              ' + char(10)
                SELECT @v_dSql += '          , A._DATE_SEQ, A.WEEK_SEQ, A._TYPE                              ' + char(10)
                SELECT @v_dSql += '          , B.POST_ORDER                                                  ' + char(10)
                SELECT @v_dSql += '     FROM (                                                               ' + char(10)
                SELECT @v_dSql += '         SELECT ISO_YYYYWW AS _DATE                                       ' + char(10)
                SELECT @v_dSql += '              , (SUBSTRING(ISO_YYYYWW,1,4) + ''W'' + SUBSTRING(ISO_YYYYWW,5,2)) AS _NAME      ' + char(10)
                SELECT @v_dSql += '              , COUNT(*) AS _COUNT                                                            ' + char(10)
                SELECT @v_dSql += '              , ''W'' + CONVERT(VARCHAR,(ROW_NUMBER() OVER(ORDER BY ISO_YYYYWW))-1) AS _VALUE ' + char(10)
                SELECT @v_dSql += '              , 1 AS _DATE_SEQ                                      ' + char(10)
                SELECT @v_dSql += '              , ISO_YYYYWW AS WEEK_SEQ                              ' + char(10)
                SELECT @v_dSql += '              , ''W'' AS _TYPE                                      ' + char(10)
                SELECT @v_dSql += '         FROM   TH_UIS_CAL AS CAL WITH(NOLOCK)                      ' + char(10)
                SELECT @v_dSql += '         WHERE  CAL.DT >= CONVERT(DATETIME, '''+ @param1 +''', 112) ' + char(10)
                SELECT @v_dSql += '         AND    CAL.DT <= CONVERT(DATETIME, '''+ @param2 +''', 112) ' + char(10)
                SELECT @v_dSql += '         GROUP BY ISO_YYYYWW                                        ' + char(10)
                SELECT @v_dSql += '     ) A                                                            ' + char(10)
                SELECT @v_dSql += '     INNER JOIN (                                                   ' + char(10)
                SELECT @v_dSql += '         SELECT '''' AS POSTFIX, 100 AS POST_ORDER                  ' + char(10)
                SELECT @v_dSql += '     ) B                                                            ' + char(10)
                SELECT @v_dSql += '     ON     1=1                                                     ' + char(10)
                SELECT @v_dSql += ' ) A                                                                ' + char(10)
                SELECT @v_dSql += ' ORDER BY WEEK_SEQ, (CASE WHEN _TYPE = ''W'' THEN 1 ELSE 2 END), _DATE, POST_ORDER ' + char(10)

				exec sp_executesql @v_dSql
			END
		/****************************************************************************************************************************************/
		/*   FP00521 find_bukInfo_LVL1 정보갖고오기                                                                                       */
		/*   Param :@Param1	:  bucket_from,      :@Param2	:  bucket_to                                                                   */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00521_find_bukInfo_LVL1'

			BEGIN
				SELECT @v_dSql = ''  
                SELECT @v_dSql += ' SELECT A.*                    ' + char(10)
                SELECT @v_dSql += ' FROM (                        ' + char(10)
                SELECT @v_dSql += '      SELECT YYYYMMDD AS _DATE ' + char(10)
                SELECT @v_dSql += '          ,SUBSTRING(YYYYMMDD,1,4) + ''-'' + SUBSTRING(YYYYMMDD,5,2) + ''-'' + SUBSTRING(YYYYMMDD,7,2) + '' '' ' + char(10)
                SELECT @v_dSql += '          +(CASE WHEN DAY_SEQ=2 THEN ''(Mon)'' ' + char(10)
                SELECT @v_dSql += '                 WHEN DAY_SEQ=3 THEN ''(Tue)'' ' + char(10)
                SELECT @v_dSql += '                 WHEN DAY_SEQ=4 THEN ''(Wed)'' ' + char(10)
                SELECT @v_dSql += '                 WHEN DAY_SEQ=5 THEN ''(Thu)'' ' + char(10)
                SELECT @v_dSql += '                 WHEN DAY_SEQ=6 THEN ''(Fri)'' ' + char(10)
                SELECT @v_dSql += '                 WHEN DAY_SEQ=7 THEN ''(Sat)'' ' + char(10)
                SELECT @v_dSql += '                 ELSE ''(SUN)'' END) AS _NAME  ' + char(10)
                SELECT @v_dSql += '          , 1 AS _COUNT                        ' + char(10)
                SELECT @v_dSql += '          ,''D'' + CONVERT(VARCHAR,(ROW_NUMBER() OVER(ORDER BY YYYYMMDD))-1) AS _VALUE ' + char(10)
                SELECT @v_dSql += '          , 1 AS _DATE_SEQ                                                             ' + char(10)
                SELECT @v_dSql += '          , ISO_YYYYWW AS WEEK_SEQ                                                     ' + char(10)
                SELECT @v_dSql += '          , ''D'' AS _TYPE                                                             ' + char(10)
                SELECT @v_dSql += '      FROM   TH_UIS_CAL A WITH(NOLOCK)                                                 ' + char(10)
                SELECT @v_dSql += '      WHERE  YYYYMMDD BETWEEN '''+ @param1 +''' AND '''+ @param2 +'''                  ' + char(10)
                SELECT @v_dSql += '      AND    1=0                                                                       ' + char(10)
                SELECT @v_dSql += '      UNION ALL                                                                        ' + char(10)
                SELECT @v_dSql += '      SELECT ISO_YYYYWW AS _DATE                                                       ' + char(10)
                SELECT @v_dSql += '          , (SUBSTRING(ISO_YYYYWW,1,4) + ''W'' + SUBSTRING(ISO_YYYYWW,5,2)) AS _NAME      ' + char(10)
                SELECT @v_dSql += '          , COUNT(*) AS _COUNT                                                            ' + char(10)
                SELECT @v_dSql += '          , ''W'' + CONVERT(VARCHAR,(ROW_NUMBER() OVER(ORDER BY ISO_YYYYWW))-1) AS _VALUE ' + char(10)
                SELECT @v_dSql += '          , 1 AS _DATE_SEQ                                              ' + char(10)
                SELECT @v_dSql += '          , ISO_YYYYWW AS WEEK_SEQ                                      ' + char(10)
                SELECT @v_dSql += '          , ''W'' AS _TYPE                                              ' + char(10)
                SELECT @v_dSql += '      FROM   TH_UIS_CAL AS CAL WITH(NOLOCK)                             ' + char(10)
                SELECT @v_dSql += '      WHERE  CAL.DT >= CONVERT(DATETIME, '''+ @param1 +''', 112)        ' + char(10)
                SELECT @v_dSql += '      AND    CAL.DT <= CONVERT(DATETIME, '''+ @param2 +''', 112)        ' + char(10)
                SELECT @v_dSql += '      GROUP BY ISO_YYYYWW                                               ' + char(10)
                SELECT @v_dSql += ' ) A                                                                    ' + char(10)
                SELECT @v_dSql += ' ORDER BY WEEK_SEQ, (CASE WHEN _TYPE = ''W'' THEN 1 ELSE 2 END), _DATE  ' + char(10)

				exec sp_executesql @v_dSql
			END
		/****************************************************************************************************************************************/
		/*   FP03033 find_Operation 정보갖고오기                                                                                       */
		/*   Param :@Param1	:  _Save_Auth, :@Param2	: DIVISION,  @Param3: SITE, @Param4	:PLANT,@Param5	:FACTORY                       */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP03033_find_Operation'

			BEGIN
				SELECT @v_dSql = ''  
                SELECT @v_dSql += ' SELECT OPERATION_ID AS CODE                                                     ' + char(10)
                SELECT @v_dSql += '    , ''(''+ OPERATION_ID + '')'' + ISNULL(OPERATION_NAME, OPERATION_ID) AS NAME ' + char(10)
                SELECT @v_dSql += ' FROM SCM_OPERATION_M A WITH(NOLOCK)                                ' + char(10)
                SELECT @v_dSql += ' WHERE ( ( EXISTS                                                   ' + char(10)
                SELECT @v_dSql += '                ( SELECT 1                                          ' + char(10)
				SELECT @v_dSql += '                  FROM SCM_MMD_OPERATION_GROUP_M B WITH(NOLOCK)     ' + char(10) 
				SELECT @v_dSql += '                  WHERE B.OPERATION_GROUP_ID = A.OPERATION_GROUP_ID ' + char(10)
				SELECT @v_dSql += '                  AND B.ROUTE_TYPE=''P''    ' + char(10)
				SELECT @v_dSql += '                )                           ' + char(10)
                SELECT @v_dSql += '           AND MES_ERP_INTERFACE_FLAG=''Y'' ' + char(10)
                SELECT @v_dSql += '           ) OR                             ' + char(10)
                SELECT @v_dSql += '          (                                 ' + char(10)
                SELECT @v_dSql += '             NOT EXISTS (                   ' + char(10)
				SELECT @v_dSql += '                         SELECT 1           ' + char(10)
				SELECT @v_dSql += '                         FROM SCM_MMD_OPERATION_GROUP_M B WITH(NOLOCK)   ' + char(10)
				SELECT @v_dSql += '                         WHERE B.OPERATION_GROUP_ID=A.OPERATION_GROUP_ID ' + char(10)
				SELECT @v_dSql += '                         AND B.ROUTE_TYPE = ''P''     ' + char(10)
				SELECT @v_dSql += '                         )                            ' + char(10)
                SELECT @v_dSql += '          )                                           ' + char(10)
				SELECT @v_dSql += '     )                                                ' + char(10)
                SELECT @v_dSql += ' AND EXISTS ( SELECT 1 FROM SCM_LINE_M C WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += '              WHERE C.COMPANY_ID   = A.COMPANY_ID     ' + char(10)
                SELECT @v_dSql += '              AND   C.DIVISION_ID  = A.DIVISION_ID    ' + char(10)
                SELECT @v_dSql += '              AND   C.SITE_ID      = A.SITE_ID        ' + char(10)
                SELECT @v_dSql += '              AND   C.OPERATION_ID = A.OPERATION_ID   ' + char(10)
                SELECT @v_dSql += '              '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.PLANT_ID' , 'EQ', @param4))    + char(10)
                SELECT @v_dSql += '              '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.FACTORY_ID' , 'EQ', @param5))  + char(10)
                SELECT @v_dSql += '            )                                                   ' + char(10)
                SELECT @v_dSql += ' AND EXISTS ( SELECT 1 FROM ( SELECT DISTINCT B.INSTANCE_TYPE   ' + char(10)
                SELECT @v_dSql += '                              FROM SCM_FACTORY_M A WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += '                              INNER JOIN FP_INSTANCE_FACTORY_M B WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += '                              ON  A.FACTORY_ID=B.FACTORY_ID ' + char(10)
                SELECT @v_dSql += '                              AND B.ACTIVE_FLAG = ''Y''     ' + char(10)
                SELECT @v_dSql += '                              WHERE 1=1                     ' + char(10)
                SELECT @v_dSql += '                              AND   A.ACTIVE_FLAG = ''Y''   ' + char(10)
                SELECT @v_dSql += '                             ) C                            ' + char(10)
                SELECT @v_dSql += '               WHERE C.INSTANCE_TYPE=A.INSTANCE_TYPE )      ' + char(10)
                SELECT @v_dSql += ' AND  EXISTS (                                              ' + char(10)
                SELECT @v_dSql += '              SELECT 1                                      ' + char(10)
                SELECT @v_dSql += '              FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)     ' + char(10)
                SELECT @v_dSql += '              WHERE  A.COMPANY_ID   = B.COMPANY_ID          ' + char(10)
                SELECT @v_dSql += '              AND    A.DIVISION_ID  = B.DIVISION_ID         ' + char(10)
                SELECT @v_dSql += '              AND    A.SITE_ID      = B.SITE_ID             ' + char(10)
                SELECT @v_dSql += '              AND    A.OPERATION_ID = B.OPERATION_ID        ' + char(10)
                SELECT @v_dSql += '              AND    B.USER_ID      = '''+ @p_user_id +'''  ' + char(10)

                IF ( @param1 = 'Y') 
                    BEGIN
                	    SELECT @v_dSql += '              AND    B.SAVE_FLAG = ''Y'' ' + char(10)
                    END
                SELECT @v_dSql += '           )                                     ' + char(10)
                SELECT @v_dSql += ' AND  A.ACTIVE_FLAG  = ''Y''                     ' + char(10)
                SELECT @v_dSql += ' AND  A.OPERATION_ID = ''E2000''                 ' + char(10)
                SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param2)) + char(10)
                SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @param3))     + char(10)
                SELECT @v_dSql += ' GROUP BY A.OPERATION_ID, A.OPERATION_NAME       ' + char(10)
                SELECT @v_dSql += ' ORDER BY A.OPERATION_ID                         ' + char(10)

				exec sp_executesql @v_dSql
			END
		/****************************************************************************************************************************************/
		/*   FP03033 find_Lane 정보갖고오기                                                                                       */
		/*   Param :@Param1	:  DIVISION, :@Param2: SITE,  @Param3: PLANT, @Param4 :FACTORY, @Param5	:ITEM, @Param6	:PROD_VERSION_TYPE        */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP03033_find_Lane'

			BEGIN
				SELECT @v_dSql = ''  
				SELECT @v_dSql += ' SELECT A.CODE, A.NAME'  
				SELECT @v_dSql += ' FROM ( '  
				--SELECT @v_dSql += '      SELECT 0 AS CODE, 0 AS NAME                                           ' + char(10)
                --SELECT @v_dSql += '      UNION ALL                                                             ' + char(10)
                SELECT @v_dSql += '      SELECT DISTINCT CONVERT(NUMERIC(18,5),A.LANE_QTY) AS CODE          ' + char(10)
                SELECT @v_dSql += '          , CAST(A.LANE_QTY AS INT) AS NAME                              ' + char(10)
                SELECT @v_dSql += '      FROM SCM_ITEM_LANE_M A WITH(NOLOCK)                                ' + char(10)
                SELECT @v_dSql += '      WHERE   A.ACTIVE_FLAG = ''Y''                                      ' + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param1))   + char(10)
                SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @param2))       + char(10)
                SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @param3))      + char(10)
                SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @param4))    + char(10)
                SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'EQ', @param5))       + char(10)
				
				IF(LEN(@param6) > 0)
				    BEGIN
                        SELECT @v_dSql += ' AND    A.PROD_VERSION_TYPE = '''+ @param6 +''' ' + char(10)
					END
				ELSE
				    BEGIN
                        SELECT @v_dSql += ' AND    A.PROD_VERSION_TYPE = ''GENERAL''       ' + char(10)
					END
                SELECT @v_dSql += ' ) A '  
				SELECT @v_dSql += ' ORDER BY A.CODE                                          ' + char(10)

				--SELECT @v_dSql
				exec sp_executesql @v_dSql
			END
		/****************************************************************************************************************************************/
		/*   FP03033 find_siteTime 정보갖고오기                                                                                       */
		/*   Param :@Param1	:  SITE                                                                                                  */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP03033_find_siteTime'

			BEGIN
				SELECT @v_dSql = ''  
				SELECT @v_dSql += ' SELECT CONVERT(VARCHAR, DBO.FN_SITE_TIME('''+ @param1 +'''), 20) AS SITE_TIME ' + char(10)

				exec sp_executesql @v_dSql
			END
		/****************************************************************************************************************************************/
		/*   FP03033 find_ConversionType 정보갖고오기                                                                                           */
		/*   Param :@Param1	:  DIVISION, :@Param2	: SITE,  @Param3: PLANT, @Param4	:FACTORY                                                */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP03033_find_ConversionType'

			BEGIN
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT DISTINCT A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                   ' + char(10)
				SELECT @v_dSql += ' , A.FACTORY_ID, ISNULL(B.ATTRIBUTE1, ''GENERAL'') AS CODE              ' + char(10)
				SELECT @v_dSql += ' , ISNULL(B.ATTRIBUTE1, ''GENERAL'') AS NAME                            ' + char(10)
                SELECT @v_dSql += ' FROM SCM_FACTORY_M A WITH(NOLOCK)                                      ' + char(10)
                SELECT @v_dSql += ' LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE B WITH(NOLOCK)                    ' + char(10)
                SELECT @v_dSql += ' ON 1=1                                                                 ' + char(10)
                SELECT @v_dSql += ' AND A.ACTIVE_FLAG = ''Y''                                              ' + char(10)
                SELECT @v_dSql += ' AND B.LOOKUP_TYPE_CODE = ''LINE_PROD_VERSION_TYPE''                    ' + char(10)
                SELECT @v_dSql += ' AND A.DIVISION_ID = B.SEGMENT2                                         ' + char(10)
                SELECT @v_dSql += ' AND A.SITE_ID = B.SEGMENT1                                             ' + char(10)
                SELECT @v_dSql += ' AND A.PLANT_ID = B.SEGMENT3                                            ' + char(10)
                SELECT @v_dSql += ' AND A.FACTORY_ID = B.SEGMENT4                                          ' + char(10)
                SELECT @v_dSql += ' WHERE 1=1                                                              ' + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param1))  + char(10)
                SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @param2))      + char(10)
                SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @param3))     + char(10)
                SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @param4))   + char(10)

				--SELECT @v_dSql
			    exec sp_executesql @v_dSql
			END
		/****************************************************************************************************************************************/
		/*   FP03033 find_category 정보갖고오기                                                                                       */
		/*   Param :@Param1	:  _Save_Auth, :@Param2	: DIVISION,  @Param3: SITE, @Param4	:PLANT,@Param5	:FACTORY                       */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP03033_find_category'

			BEGIN
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT A.ATTRIBUTE1 AS CODE, A.ATTRIBUTE1 AS NAME ' + char(10)
                SELECT @v_dSql += ' FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)        ' + char(10)
                SELECT @v_dSql += ' WHERE  A.LOOKUP_TYPE_CODE = ''ITEM_CONV_CALC''    ' + char(10)
                SELECT @v_dSql += ' AND    A.ATTRIBUTE2  = ''Y''                      ' + char(10)
                SELECT @v_dSql += ' ORDER BY A.ATTRIBUTE1                             ' + char(10)

			    exec sp_executesql @v_dSql
			END
		/****************************************************************************************************************************************/
		/*   FP03033 find_LastVersion 정보갖고오기                                                                                       */
		/*   Param :@Param1	:  _Save_Auth, :@Param2	: DIVISION,  @Param3: SITE, @Param4	:PLANT,@Param5	:FACTORY                       */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP03033_find_LastVersion'

			BEGIN
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT LTRIM( STUFF(                          ' + char(10)
                SELECT @v_dSql += '    ( SELECT DISTINCT '', '' + VERSION         ' + char(10)
                SELECT @v_dSql += '      FROM SCM_ITEM_CONV_CALC_M A WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += '      WHERE 1=1                                ' + char(10)
                SELECT @v_dSql += '      AND    A.MAX_VER_FLAG	= ''Y''           ' + char(10)
				SELECT @v_dSql += '      '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param1))       + char(10)
                SELECT @v_dSql += '      '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @param2))           + char(10)
                SELECT @v_dSql += '      '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @param3))          + char(10)
                SELECT @v_dSql += '      '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @param4))        + char(10)
				SELECT @v_dSql += '      '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION' , 'EQ', @param5))         + char(10)
				SELECT @v_dSql += '      '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.MODEL_ID' , 'EQ', @param6))          + char(10)
				SELECT @v_dSql += '      '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'EQ', @param7))           + char(10)
				SELECT @v_dSql += '      '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PROD_VERSION_TYPE' , 'EQ', @param8)) + char(10)
				SELECT @v_dSql += '      '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.VERSION_TYPE' , 'EQ', @param9))      + char(10)
                SELECT @v_dSql += '     FOR XML PATH(''''))                       ' + char(10)
                SELECT @v_dSql += '  , 1, 1, '''') ) AS LAST_VERSION              ' + char(10)

			    exec sp_executesql @v_dSql
			END
		/****************************************************************************************************************************************/
		/*   FP03033 find_Version 정보갖고오기                                                                                       */
		/*   Param :@Param1	:  _Save_Auth, :@Param2	: DIVISION,  @Param3: SITE, @Param4	:PLANT,@Param5	:FACTORY                       */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP03033_find_Version'

			BEGIN
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT VERSION ' + char(10)
                SELECT @v_dSql += ' FROM SCM_ITEM_CONV_CALC_M A WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += ' WHERE 1=1 ' + char(10)
                SELECT @v_dSql += ' AND    A.MAX_VER_FLAG	= ''Y'' ' + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param1))       + char(10)
                SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @param2))           + char(10)
                SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @param3))          + char(10)
                SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @param4))          + char(10)
                SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION' , 'EQ', @param5))          + char(10)
                SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.MODEL_ID' , 'EQ', @param6))          + char(10)
                SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'EQ', @param7))          + char(10)
                SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.VERSION' , 'EQ', @param8))          + char(10)

				IF(LEN(@param9) > 0)
				    BEGIN
                        SELECT @v_dSql += 'AND A.PROD_VERSION_TYPE = ISNULL('''+ @param8 +''',''GENERAL'') '  + char(10)
					END
                SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.VERSION_TYPE' , 'EQ', @param10))          + char(10)

			    exec sp_executesql @v_dSql
			END
		/****************************************************************************************************************************************/
		/*   FP03033 find_add_dupcheck 정보갖고오기                                                                                       */
		/*   Param :@Param1	:  COMPANY, :@Param2	: FACTORY,  @Param3: MODEL, @Param4	:OPERATION, @Param5	:ITEM, @Param6	:VERSION , @Param7	:VERSION_TYPE                     */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP03033_find_add_dupcheck'

			BEGIN
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT COUNT(*) AS CNT                     '  + char(10)
                SELECT @v_dSql += ' FROM   SCM_ITEM_CONV_CALC_M A WITH(NOLOCK) '  + char(10)
                SELECT @v_dSql += ' INNER JOIN                                 '  + char(10)
				SELECT @v_dSql += '    (  SELECT '''+ @param1 +''' AS COMPANY_ID, '''+ @param1 +''' AS FACTORY_ID '  + char(10)
                SELECT @v_dSql += '       , '''+ @param2 +''' AS MODEL_ID                                         '  + char(10)
                SELECT @v_dSql += '       , ( CASE WHEN CHARINDEX(''.'','''+ @param6 +''',1) > 0 THEN             '  + char(10)
                SELECT @v_dSql += '           ISNULL(REPLICATE(''0'', 3 - LEN(SUBSTRING('''+ @param6 +''', 1, ABS(CHARINDEX(''.'','''+ @param6 +''',1)-1)))),'''') '  + char(10)
				SELECT @v_dSql += '           + SUBSTRING('''+ @param6 +''', 1, ABS(CHARINDEX(''.'','''+ @param6 +''',1)-1)   ) + ''.''                            '  + char(10)
				SELECT @v_dSql += '           + SUBSTRING('''+ @param6 +''', CHARINDEX(''.'','''+ @param6 +''',1)+1,10)      '  + char(10)
                SELECT @v_dSql += '          ELSE                                                                            '  + char(10)
                SELECT @v_dSql += '            ISNULL(REPLICATE(''0'', 3 - LEN('''+ @param6 +''')),'''') + '''+ @param6 +''' '  + char(10)
                SELECT @v_dSql += '          END ) AS VERSION                 '  + char(10)
                SELECT @v_dSql += '       , '''+ @param4 +''' AS OPERATION    '  + char(10)
                SELECT @v_dSql += '       , '''+ @param5 +''' AS ITEM_ID      '  + char(10)
                SELECT @v_dSql += '       , '''+ @param7 +''' AS VERSION_TYPE '  + char(10)
                SELECT @v_dSql += '       , ''cell/batch'' AS CATEGORY '  + char(10)
                SELECT @v_dSql += ' ) AS B                             '  + char(10)
                SELECT @v_dSql += ' ON (  A.COMPANY_ID = B.COMPANY_ID  '  + char(10)
                SELECT @v_dSql += '    AND A.FACTORY_ID = B.FACTORY_ID '  + char(10)
                SELECT @v_dSql += '    AND A.MODEL_ID   = B.MODEL_ID   '  + char(10)
                SELECT @v_dSql += '    AND A.VERSION    = B.VERSION    '  + char(10)
                SELECT @v_dSql += '    AND A.OPERATION  = B.OPERATION  '  + char(10)
                SELECT @v_dSql += '    AND A.ITEM_ID    = B.ITEM_ID    '  + char(10)
                SELECT @v_dSql += '    AND A.CATEGORY   = B.CATEGORY   '  + char(10)
                SELECT @v_dSql += ' )                                  '  + char(10)

			    exec sp_executesql @v_dSql
			END
		/****************************************************************************************************************************************/
		/*   FP01886 find_userInfo 정보갖고오기                                                                                        */
		/*   Param :@Param1	:  ALT_USER_ID                                                                                                 */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP01886_find_userInfo'

			BEGIN
			    SELECT @v_dSql = ''
                --SELECT @v_dSql += ' SELECT A.USER_ID AS NEW_USER_ID, A.USER_NAME, A.DEPARTMENT '  + char(10)
                --SELECT @v_dSql += ' FROM   TH_UIS_USER_DETAIL A WITH(NOLOCK)                   '  + char(10)
                --SELECT @v_dSql += ' WHERE  A.USER_ID = '''+ @param1 +'''                       '  + char(10)
				-- user 정보 GSCM user 테이블로 변경
                SELECT @v_dSql += 'SELECT A.USERID AS NEW_USER_ID, A.USERNAME AS USER_NAME '  + char(10)
                SELECT @v_dSql += '     , ISNULL((CASE WHEN A.LANGUAGE = ''KR'' THEN B.DEPT_NAME_KO '  + char(10)
                SELECT @v_dSql += '                    WHEN A.LANGUAGE = ''EN'' THEN B.DEPT_NAME_EN '  + char(10)
                SELECT @v_dSql += '                    ELSE B.DEPT_NAME_KO END), A.DEPT_ID)AS DEPARTMENT '  + char(10)
                SELECT @v_dSql += 'FROM  TB_FX_USER_SN A WITH(NOLOCK) '  + char(10)
                SELECT @v_dSql += 'LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO_SN B WITH(NOLOCK) '  + char(10)
                SELECT @v_dSql += 'ON    A.DEPT_ID = B.DEPT_ID '  + char(10)
                SELECT @v_dSql += 'WHERE A.USERID = '''+ @param1 +''' '  + char(10)

				declare @runtime datetime
				SET @runtime = GetDate()
				exec PR_UI_SQL_LOG 'PR_UI_FP_MASTER_FORM_CODE',  @p_user_id, @p_code,'',@v_dSql,'SELECT',@runtime, @runtime

			    exec sp_executesql @v_dSql
			END
		/****************************************************************************************************************************************/
		/*   FP01886 find_newAuth_div 정보갖고오기                                                                                        */
		/*   Param :@Param1	:  DIVISION                                                                                        */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP01886_find_newAuth_div'

			BEGIN
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT CODE_ID AS CODE, CODE_NAME AS NAME                                                     '  + char(10)
				SELECT @v_dSql += ' FROM (                                                                                        '  + char(10)
                SELECT @v_dSql += '        SELECT A.DIVISION_ID AS CODE_ID,                                                       '  + char(10)
                SELECT @v_dSql += '            ( CASE WHEN A.DIVISION_NAME = '''' OR A.DIVISION_NAME IS NULL THEN A.DIVISION_ID   '  + char(10)
				SELECT @v_dSql += '              ELSE A.DIVISION_NAME END) + ''('' + A.DIVISION_ID + '')'' AS CODE_NAME,          '  + char(10)
                SELECT @v_dSql += '            ROW_NUMBER() OVER(PARTITION BY A.DIVISION_ID ORDER BY A.DIVISION_NAME ASC) AS RNUM '  + char(10)
                SELECT @v_dSql += '        FROM   SCM_DIVISION_M A WITH(NOLOCK)                                                   '  + char(10)
                SELECT @v_dSql += '        WHERE  1=1                                                                             '  + char(10)
                SELECT @v_dSql += '        AND EXISTS (                                                                           '  + char(10)
                SELECT @v_dSql += '               SELECT 1                                                                        '  + char(10)
                SELECT @v_dSql += '               FROM   SCM_FACTORY_M FF WITH(NOLOCK)                                            '  + char(10)
                SELECT @v_dSql += '               WHERE  A.COMPANY_ID   = FF.COMPANY_ID                                           '  + char(10)
                SELECT @v_dSql += '               AND    A.DIVISION_ID  = FF.DIVISION_ID                                          '  + char(10)
                SELECT @v_dSql += '               AND    FF.ACTIVE_FLAG = ''Y''                                                   '  + char(10)
                SELECT @v_dSql += '        )                                                                                      '  + char(10)
                SELECT @v_dSql += ' ) AA                                                                                          '  + char(10)
                SELECT @v_dSql += ' WHERE RNUM=1                                                                                  '  + char(10)
				
				IF(LEN(@param1) > 0)
				    BEGIN
				        SELECT @v_dSql += ' AND CODE_ID ='''+ @param1 +'''                                                        '  + char(10)
				    END

                SELECT @v_dSql += ' ORDER BY CODE                                                                                 '  + char(10)

			    exec sp_executesql @v_dSql
			END
		/****************************************************************************************************************************************/
		/*   FP01886 find_newAuth_plant 정보갖고오기                                                                                        */
		/*   Param :@Param1	:  DIVISION_ID                                                                                                 */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP01886_find_newAuth_plant'

			BEGIN
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT PLANT_ID AS CODE                                                 '  + char(10)
                SELECT @v_dSql += '      ,(CASE WHEN PLANT_NAME = '''' OR PLANT_NAME IS NULL THEN PLANT_ID  '  + char(10)
                SELECT @v_dSql += '      ELSE PLANT_NAME END) + ''('' + PLANT_ID + '')'' AS NAME            '  + char(10)
                SELECT @v_dSql += '      ,A.SITE_ID                                                         '  + char(10)
                SELECT @v_dSql += ' FROM   SCM_PLANT_M A WITH(NOLOCK)                                       '  + char(10)
                SELECT @v_dSql += ' WHERE  1 = 1                                                            '  + char(10)
                SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param1))      + char(10)
                SELECT @v_dSql += ' AND EXISTS (                                                            '  + char(10)
                SELECT @v_dSql += ' 		SELECT 1                                                        '  + char(10)
                SELECT @v_dSql += ' 		FROM   SCM_FACTORY_M FF WITH(NOLOCK)                            '  + char(10)
                SELECT @v_dSql += ' 		WHERE  A.COMPANY_ID   = FF.COMPANY_ID                           '  + char(10)
                SELECT @v_dSql += ' 		AND    A.DIVISION_ID  = FF.DIVISION_ID                          '  + char(10)
                SELECT @v_dSql += ' 		AND    A.SITE_ID      = FF.SITE_ID                              '  + char(10)
                SELECT @v_dSql += ' 		AND    A.PLANT_ID     = FF.PLANT_ID                             '  + char(10)
                SELECT @v_dSql += ' 		AND    FF.ACTIVE_FLAG = ''Y''                                   '  + char(10)
                SELECT @v_dSql += ' )                                                                       '  + char(10)
                SELECT @v_dSql += ' GROUP BY PLANT_ID, PLANT_NAME, A.SITE_ID                                '  + char(10)
                SELECT @v_dSql += ' ORDER BY PLANT_ID ASC                                                   '  + char(10)

			    exec sp_executesql @v_dSql
			END

		/****************************************************************************************************************************************/
		/*   FP01886 find_newAuth_shop 정보갖고오기                                                                                        */
		/*   Param :@param1	:  DIVISION, @param2:  PLANT                                                                                               */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP01886_find_newAuth_shop'

			BEGIN
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT DISTINCT A.SHOP_GROUP_ID AS CODE           '  + char(10)
                SELECT @v_dSql += ' , (CASE A.SHOP_GROUP_ID WHEN ''A'' THEN ''Assy''  '  + char(10)
                SELECT @v_dSql += '       WHEN ''E'' THEN ''Electrode''               '  + char(10)
                SELECT @v_dSql += ' 	  WHEN ''F'' THEN ''Formation''               '  + char(10)
                SELECT @v_dSql += ' 	  WHEN ''P'' THEN ''Pack'' END                '  + char(10)
                SELECT @v_dSql += '   ) + ''('' + A.SHOP_GROUP_ID + '')'' AS NAME     '  + char(10)
                SELECT @v_dSql += ' FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK)       '  + char(10)
                SELECT @v_dSql += ' WHERE  A.ACTIVE_FLAG = ''Y''                      '  + char(10)
                SELECT @v_dSql += ' AND    A.FACTORY_ID IN (                          '  + char(10)
                SELECT @v_dSql += '           SELECT FACTORY_ID                       '  + char(10)
                SELECT @v_dSql += '           FROM   SCM_FACTORY_M A WITH(NOLOCK)     '  + char(10)
                SELECT @v_dSql += '           WHERE  1=1                              '  + char(10)
                SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param1))   + char(10)
                SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @param2))      + char(10)
                SELECT @v_dSql += ' AND    A.ACTIVE_FLAG = ''Y''                      '  + char(10)
                SELECT @v_dSql += ' )                                                 '  + char(10)
                SELECT @v_dSql += ' ORDER BY SHOP_GROUP_ID                            '  + char(10)

			    exec sp_executesql @v_dSql
			END
		/****************************************************************************************************************************************/
		/*   FP01886 find_newAuth_instance 정보갖고오기                                                                                        */
		/*   Param :@param1	:  DIVISION, @param2:  PLANT, @param3:  SHOP_GROUP                                                                 */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP01886_find_newAuth_instance'

			BEGIN
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT DISTINCT A.INSTANCE_ID AS CODE, B.SEGMENT2 AS NAME,B.SORT_ORDER AS SORT '  + char(10)
                SELECT @v_dSql += ' FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK)               '  + char(10)
                SELECT @v_dSql += ' INNER JOIN SCM_SYS_LOOKUP_VALUE B WITH(NOLOCK)            '  + char(10)
                SELECT @v_dSql += ' ON     A.INSTANCE_ID = B.SEGMENT1                         '  + char(10)
                SELECT @v_dSql += ' AND    B.LOOKUP_TYPE_CODE = ''INSTANCE_ID''               '  + char(10)
                SELECT @v_dSql += ' AND    B.ACTIVE_FLAG = ''Y''                              '  + char(10)
                SELECT @v_dSql += ' WHERE  A.ACTIVE_FLAG = ''Y''                              '  + char(10)
                SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SHOP_GROUP_ID' , 'EQ', @param3))   + char(10)

                SELECT @v_dSql += ' AND    A.FACTORY_ID IN (                '  + char(10)
                SELECT @v_dSql += ' 	SELECT FACTORY_ID                   '  + char(10)
                SELECT @v_dSql += ' 	FROM   SCM_FACTORY_M A WITH(NOLOCK) '  + char(10)
                SELECT @v_dSql += ' 	WHERE  1=1                          '  + char(10)
                SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param1))   + char(10)
                SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @param2))      + char(10)
                SELECT @v_dSql += ' 	AND    A.ACTIVE_FLAG = ''Y''        '  + char(10)
                SELECT @v_dSql += ' )                                       '  + char(10)
--                SELECT @v_dSql += ' ORDER BY CODE                           '  + char(10)
                SELECT @v_dSql += ' ORDER BY SORT                           '  + char(10)

			    exec sp_executesql @v_dSql
			END
		/****************************************************************************************************************************************/
		/*   FP01886 find_newAuth_factory 정보갖고오기                                                                                        */
		/*   Param :@param1	:  DIVISION, @param2:  PLANT, @param3:  SHOP_GROUP, @param4:  INSTANCE                                               */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP01886_find_newAuth_factory'

			BEGIN
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT DISTINCT A.FACTORY_ID AS CODE                                 '  + char(10)
                SELECT @v_dSql += '    , B.FACTORY_NAME + ''('' + A.FACTORY_ID + '')'' AS NAME           '  + char(10)
                SELECT @v_dSql += ' FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK)                          '  + char(10)
                SELECT @v_dSql += ' INNER JOIN SCM_FACTORY_M B WITH(NOLOCK)                              '  + char(10)
                SELECT @v_dSql += ' ON     A.FACTORY_ID  = B.FACTORY_ID                                  '  + char(10)
                SELECT @v_dSql += ' AND    B.ACTIVE_FLAG = ''Y''                                         '  + char(10)
                SELECT @v_dSql += ' WHERE  A.ACTIVE_FLAG = ''Y''                                         '  + char(10)
                SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SHOP_GROUP_ID' , 'EQ', @param3)) + char(10)
                SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_ID' , 'EQ', @param4))   + char(10)
                SELECT @v_dSql += ' AND    A.FACTORY_ID IN (                                             '  + char(10)
                SELECT @v_dSql += '          SELECT FACTORY_ID                                           '  + char(10)
                SELECT @v_dSql += '          FROM   SCM_FACTORY_M A WITH(NOLOCK)                         '  + char(10)
                SELECT @v_dSql += '          WHERE  1=1                                                  '  + char(10)
                SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param1))   + char(10)
                SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @param2))      + char(10)
                SELECT @v_dSql += '          AND    A.ACTIVE_FLAG = ''Y''                                '  + char(10)
                SELECT @v_dSql += ' )                                                                    '  + char(10)
				--[E20250530-001605]MI 법인 ESS Planner 권한신청 오류건
                SELECT @v_dSql += ' AND    A.FACTORY_ID IN ( '  + char(10)
                SELECT @v_dSql += ' 		SELECT FACTORY_ID '  + char(10)
                SELECT @v_dSql += ' 		FROM   SCM_LINE_M A WITH(NOLOCK) '  + char(10)
                SELECT @v_dSql += ' 		WHERE  A.ACTIVE_FLAG = ''Y'' '  + char(10)
                SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param1))   + char(10)
                SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @param2))      + char(10)
                SELECT @v_dSql += ' ) '  + char(10)
                SELECT @v_dSql += ' AND    A.FACTORY_ID IN ( '  + char(10)
                SELECT @v_dSql += ' 		SELECT DISTINCT A.FACTORY_ID '  + char(10)
                SELECT @v_dSql += ' 		FROM   TH_UIS_ROLE_INSTANCE_RELATE A WITH(NOLOCK), TH_UIS_ROLE_INSTANCE B WITH(NOLOCK) '  + char(10)
                SELECT @v_dSql += ' 		WHERE  A.ROLE_ID = B.ROLE_ID '  + char(10)
                SELECT @v_dSql += ' 		AND    A.USE_AT_FLAG = ''Y'' '  + char(10)
                SELECT @v_dSql += ' 		AND    B.APPROVAL_EXCEPTION_FLAG = ''Y'' '  + char(10)
                SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param1))   + char(10)
                SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @param2))      + char(10)
                SELECT @v_dSql += ' ) '  + char(10)

                SELECT @v_dSql += ' ORDER BY CODE                                                        '  + char(10)

			    exec sp_executesql @v_dSql
				EXEC PR_UI_SQL_LOG 'PR_UI_FP_MASTER_FORM_CODE', @p_user_id, @p_code, '', @v_dSql, 'select', @runstart, @runend
			END
		/****************************************************************************************************************************************/
		/*   FP01886 find_newAuth_plangroup 정보갖고오기                                                                                        */
		/*   Param :@Param1	:  DIVISION_ID                                                                                                 */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP01886_find_newAuth_plangroup'

			BEGIN
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT DISTINCT (CASE WHEN A.CONFIRM_AREA = ''PLAN GROUP'' THEN C.PLAN_GROUP_ID         '  + char(10)
                SELECT @v_dSql += '                   WHEN A.CONFIRM_AREA = ''BUILDING'' THEN ''-'' ELSE ''-'' END) AS CODE '  + char(10)
                SELECT @v_dSql += '     , (CASE WHEN A.CONFIRM_AREA = ''PLAN GROUP'' THEN                                   '  + char(10)
                SELECT @v_dSql += '                 ( CASE WHEN C.PLAN_GROUP_NAME IS NULL THEN C.PLAN_GROUP_ID              '  + char(10)
                SELECT @v_dSql += '                   ELSE C.PLAN_GROUP_ID + ''('' + C.PLAN_GROUP_NAME + '')'' END )        '  + char(10)
                SELECT @v_dSql += '             WHEN A.CONFIRM_AREA = ''BUILDING'' THEN ''-'' ELSE ''-'' END) AS NAME       '  + char(10)
                SELECT @v_dSql += ' FROM (                                                           '  + char(10)
                SELECT @v_dSql += '       SELECT SEGMENT1 AS INSTANCE_ID, ATTRIBUTE1 AS CONFIRM_AREA '  + char(10)
                SELECT @v_dSql += '       FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                 '  + char(10)
                SELECT @v_dSql += '       WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_ID''                '  + char(10)
                SELECT @v_dSql += '       AND    A.ACTIVE_FLAG = ''Y''                               '  + char(10)
                SELECT @v_dSql += ' ) A                                                              '  + char(10)
                SELECT @v_dSql += ' INNER JOIN (                                                     '  + char(10)
                SELECT @v_dSql += '       SELECT DISTINCT A.INSTANCE_ID, B.COMPANY_ID, B.DIVISION_ID '  + char(10)
                SELECT @v_dSql += '             , B.SITE_ID, B.PLANT_ID, A.FACTORY_ID                '  + char(10)
                SELECT @v_dSql += '       FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK)                '  + char(10)
                SELECT @v_dSql += '            , SCM_FACTORY_M B WITH(NOLOCK)                        '  + char(10)
                SELECT @v_dSql += '       WHERE  A.FACTORY_ID  = B.FACTORY_ID                        '  + char(10)
                SELECT @v_dSql += '       AND    A.ACTIVE_FLAG = ''Y''                               '  + char(10)
                SELECT @v_dSql += '       AND    B.ACTIVE_FLAG = ''Y''                               '  + char(10)
                SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @param2))   + char(10)
                SELECT @v_dSql += ' ) B                                                              '  + char(10)
                SELECT @v_dSql += ' ON  A.INSTANCE_ID = B.INSTANCE_ID                                '  + char(10)
                SELECT @v_dSql += ' LEFT OUTER JOIN (                                                '  + char(10)
                SELECT @v_dSql += '        SELECT SEGMENT1 AS INSTANCE_ID, SEGMENT2 AS PLAN_GROUP_ID '  + char(10)
                SELECT @v_dSql += '             , ATTRIBUTE4 AS PLAN_GROUP_NAME                      '  + char(10)
                SELECT @v_dSql += '        FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                '  + char(10)	
                SELECT @v_dSql += '        WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP''   '  + char(10)
                SELECT @v_dSql += '        AND    A.ACTIVE_FLAG = ''Y''	                             '  + char(10)
                SELECT @v_dSql += ' ) C                                                              '  + char(10)
                SELECT @v_dSql += ' ON    A.INSTANCE_ID = C.INSTANCE_ID                              '  + char(10)
                SELECT @v_dSql += ' WHERE 1=1                                                        '  + char(10)
                SELECT @v_dSql += ' AND   B.COMPANY_ID IS NOT NULL                                   '  + char(10)
                SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_ID' , 'EQ', @param1))   + char(10)
                SELECT @v_dSql += ' ORDER BY CODE                                                    '  + char(10)

			    exec sp_executesql @v_dSql
			END
		/****************************************************************************************************************************************/
		/*   FP01886 find_is_exists_request 정보갖고오기                                                                                        */
		/*   Param :@param1	:  USER, @param2:  SQL String                                               */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP01886_find_is_exists_request'

			BEGIN
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT DISTINCT A.USER_ID, A.INSTANCE_ID, A.FACTORY_ID, A.PLAN_GROUP_ID                     ' + char(10)
                SELECT @v_dSql += ' FROM   FP_AUTH_REQUEST_INFO_M A WITH(NOLOCK)                                                ' + char(10)
                SELECT @v_dSql += ' WHERE  1=1                                                                                  ' + char(10)
                SELECT @v_dSql += ' AND    A.APPROVAL_FLAG = ''R''                                                              ' + char(10)
                SELECT @v_dSql += ' AND    A.USER_ID = '''+ @param1 +'''                                                        ' + char(10)
                SELECT @v_dSql += ' AND    EXISTS (                                                                             ' + char(10)
                SELECT @v_dSql += '                SELECT 1                                                                     ' + char(10)
                SELECT @v_dSql += '                FROM (                                                                       ' + char(10)
                SELECT @v_dSql += '                      SELECT ''-'' AS INSTANCE_ID, ''-'' AS FACTORY_ID, ''-'' AS PLAN_GROUP_ID ' + char(10)
                SELECT @v_dSql += '                         '+ @param2 +'                                                       ' + char(10)
                SELECT @v_dSql += '                     ) AA                                                                    ' + char(10)
                SELECT @v_dSql += '                WHERE 1=1                                                                    ' + char(10) 
                SELECT @v_dSql += '                AND   A.INSTANCE_ID   = AA.INSTANCE_ID                                       ' + char(10)
                SELECT @v_dSql += '                AND   A.FACTORY_ID    = AA.FACTORY_ID                                        ' + char(10)
                SELECT @v_dSql += '                AND   A.PLAN_GROUP_ID = AA.PLAN_GROUP_ID                                     ' + char(10)
                SELECT @v_dSql += ' )                                                                                           ' + char(10)
                SELECT @v_dSql += ' ORDER BY A.INSTANCE_ID, A.FACTORY_ID, A.PLAN_GROUP_ID                                       ' + char(10)

				--SELECT @v_dSql
			    exec sp_executesql @v_dSql
			END

		/****************************************************************************************************************************************/
		/*   FP01886 find_auth_seq 정보갖고오기                                                                                        */
		/*   Param :@param1	:                                               */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP01886_find_auth_seq'

			BEGIN
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT NEXT VALUE FOR [SEQ_AUTH_REQUEST] AS NEW_SEQ     ' + char(10)

			    exec sp_executesql @v_dSql
			END
		/****************************************************************************************************************************************/
		/*   FP01887 find_newAuth_instance 정보갖고오기                                                                                        */
		/*   Param :@param1:  DIVISION, @param2:  PLANT                                            */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP01887_find_newAuth_instance'

			BEGIN
			    SELECT @v_dSql = ''

                SELECT @v_dSql += ' SELECT DISTINCT A.INSTANCE_ID AS CODE, B.SEGMENT2 AS NAME ' + char(10)
                SELECT @v_dSql += ' FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK)               ' + char(10)
                SELECT @v_dSql += ' INNER JOIN SCM_SYS_LOOKUP_VALUE B WITH(NOLOCK)            ' + char(10)
                SELECT @v_dSql += ' ON     A.INSTANCE_ID = B.SEGMENT1                         ' + char(10)
                SELECT @v_dSql += ' AND    B.LOOKUP_TYPE_CODE = ''INSTANCE_ID''               ' + char(10)
                SELECT @v_dSql += ' AND    B.ACTIVE_FLAG = ''Y''                              ' + char(10)
                SELECT @v_dSql += ' WHERE  A.ACTIVE_FLAG = ''Y''                              ' + char(10)
                SELECT @v_dSql += ' AND    A.FACTORY_ID IN (                                  ' + char(10)
                SELECT @v_dSql += ' 	SELECT FACTORY_ID                                     ' + char(10)
                SELECT @v_dSql += ' 	FROM   SCM_FACTORY_M A WITH(NOLOCK)                   ' + char(10)
                SELECT @v_dSql += ' 	WHERE  1=1                                            ' + char(10)
                SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param1))   + char(10)
				SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @param2))   + char(10)
                SELECT @v_dSql += ' AND    A.ACTIVE_FLAG = ''Y''                              ' + char(10)
                SELECT @v_dSql += ' )                                                         ' + char(10)
                SELECT @v_dSql += ' ORDER BY CODE                                             ' + char(10)
				
				--SELECT @v_dSql
			    exec sp_executesql @v_dSql
			END
		/****************************************************************************************************************************************/
		/*   FP01887 findFactoryCode_common 정보갖고오기                                                                                        */
		/*   Param : @param1:NON_AUTH, @param2:SAVE_AUTH, @param3:  INSTANCE, @param4:  DIVISION, @param4:  PLANT                               */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP01887_findFactoryCode_common'

			BEGIN
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT A.FACTORY_ID AS CODE, ''('' + A.FACTORY_ID + '')'' + ISNULL(A.FACTORY_NAME, A.FACTORY_ID) AS NAME ' + char(10)
                SELECT @v_dSql += ' 		  , CASE WHEN R.FACTORY_ID IS NOT NULL THEN 1 ELSE 0 END AS ROWCHK ' + char(10)
                SELECT @v_dSql += ' FROM   SCM_FACTORY_M A WITH(NOLOCK)                                        ' + char(10)
                SELECT @v_dSql += '        LEFT OUTER JOIN (                                                   ' + char(10)
                SELECT @v_dSql += '              SELECT	DISTINCT R.COMPANY_ID, R.DIVISION_ID     ' + char(10)
                SELECT @v_dSql += '                   , R.SITE_ID, R.PLANT_ID, R.FACTORY_ID      ' + char(10)
                SELECT @v_dSql += '              FROM	FP_USER_ROLE_INFO_V R WITH(NOLOCK)       ' + char(10)
                SELECT @v_dSql += '              WHERE	1=1                                      ' + char(10)
                SELECT @v_dSql += '              AND    R.USER_ID	= '''+ @p_user_id +'''       ' + char(10)
				IF @param2 = 'Y' --SAVE_AUTH
					BEGIN
						SET	@v_dSql += '              AND    R.SAVE_FLAG = ''Y'' ' + char(10)
					END
                SELECT @v_dSql += '              ) R                             ' + char(10)
                SELECT @v_dSql += ' ON		1=1                                  ' + char(10)
                SELECT @v_dSql += ' AND		A.COMPANY_ID		= R.COMPANY_ID   ' + char(10)
                SELECT @v_dSql += ' AND		A.DIVISION_ID		= R.DIVISION_ID  ' + char(10)
                SELECT @v_dSql += ' AND		A.SITE_ID			= R.SITE_ID      ' + char(10)
                SELECT @v_dSql += ' AND		A.PLANT_ID			= R.PLANT_ID     ' + char(10)
                SELECT @v_dSql += ' AND		A.FACTORY_ID		= R.FACTORY_ID   ' + char(10)
                SELECT @v_dSql += ' WHERE  1=1	                                 ' + char(10)

				IF @param1 != 'Y' --NON_AUTH
				    BEGIN
                        SELECT @v_dSql += ' AND  EXISTS (         ' + char(10)
                        SELECT @v_dSql += '             SELECT 1  ' + char(10)
                        SELECT @v_dSql += '             FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)   ' + char(10)
                        SELECT @v_dSql += '             WHERE  A.COMPANY_ID  = B.COMPANY_ID         ' + char(10)
                        SELECT @v_dSql += '             AND    A.DIVISION_ID = B.DIVISION_ID        ' + char(10)
                        SELECT @v_dSql += '             AND    A.SITE_ID     = B.SITE_ID            ' + char(10)
                        SELECT @v_dSql += '             AND    A.PLANT_ID    = B.PLANT_ID           ' + char(10)
                        SELECT @v_dSql += '             AND    A.FACTORY_ID  = B.FACTORY_ID         ' + char(10)
                        SELECT @v_dSql += '             AND    B.USER_ID     = '''+ @p_user_id +''' ' + char(10)
					

					    IF @param2 = 'Y' --SAVE_AUTH
					        BEGIN
					        	SET	@v_dSql += '            AND    B.SAVE_FLAG = ''Y'' ' + char(10)
					        END
                        IF @param3 = 'Y' --Instance
					        BEGIN
					        	SET	@v_dSql += '            AND    B.INSTANCE_ID = '''+ @param3 +''' ' + char(10)
					        END
                        SELECT @v_dSql += '         )             ' + char(10)
                    END

                SELECT @v_dSql += ' AND A.ACTIVE_FLAG = ''Y'' ' + char(10)
                SELECT @v_dSql += ' AND EXISTS (              ' + char(10)
                SELECT @v_dSql += '            SELECT 1       ' + char(10)
                SELECT @v_dSql += '            FROM (         ' + char(10)
                SELECT @v_dSql += '                   SELECT DISTINCT A.COMPANY_ID,A.DIVISION_ID      ' + char(10)
                SELECT @v_dSql += '                       ,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID          ' + char(10)
                SELECT @v_dSql += '                   FROM   SCM_FACTORY_M A WITH(NOLOCK)             ' + char(10)
                SELECT @v_dSql += '                   INNER JOIN FP_INSTANCE_FACTORY_M B WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += '                   ON    A.FACTORY_ID=B.FACTORY_ID                 ' + char(10)
                SELECT @v_dSql += '                   AND   B.ACTIVE_FLAG = ''Y''                     ' + char(10)
                SELECT @v_dSql += '                   WHERE 1=1                                       ' + char(10)
                SELECT @v_dSql += '                   AND   A.ACTIVE_FLAG = ''Y''                     ' + char(10)
                SELECT @v_dSql += '                   ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.INSTANCE_ID' , 'EQ', @param3))   + char(10)
                SELECT @v_dSql += '                 ) C ' + char(10)
                SELECT @v_dSql += '            WHERE C.COMPANY_ID=A.COMPANY_ID AND C.DIVISION_ID=A.DIVISION_ID                 ' + char(10)
				SELECT @v_dSql += '            AND C.SITE_ID=A.SITE_ID AND C.PLANT_ID=A.PLANT_ID AND C.FACTORY_ID=A.FACTORY_ID ' + char(10)
                SELECT @v_dSql += '           )       ' + char(10)
				SELECT @v_dSql += ' ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param4)) + char(10)
				SELECT @v_dSql += ' ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @param5))    + char(10)
                SELECT @v_dSql += ' GROUP BY a.FACTORY_ID, a.FACTORY_NAME                     ' + char(10)
                SELECT @v_dSql += '     ,CASE WHEN R.FACTORY_ID IS NOT NULL THEN 1 ELSE 0 END ' + char(10)
                SELECT @v_dSql += ' ORDER BY A.FACTORY_ID                                     ' + char(10)
				
				--SELECT @v_dSql
			    exec sp_executesql @v_dSql
			END
		/****************************************************************************************************************************************/
		/*   FP01887 find_newAuth_plangroup 정보갖고오기                                                                                        */
		/*   Param :@param1:  INSTANCE, @param2:  FACTORY                                                                                       */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP01887_find_newAuth_plangroup'

			BEGIN
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT DISTINCT (CASE WHEN A.CONFIRM_AREA = ''PLAN GROUP'' THEN C.PLAN_GROUP_ID     ' + char(10)
                SELECT @v_dSql += '                       WHEN A.CONFIRM_AREA = ''BUILDING''   THEN ''-''               ' + char(10)
                SELECT @v_dSql += '                  ELSE ''-'' END) AS CODE                                            ' + char(10)
                SELECT @v_dSql += '     , (CASE WHEN A.CONFIRM_AREA = ''PLAN GROUP'' THEN                               ' + char(10)
                SELECT @v_dSql += '                ( CASE WHEN C.PLAN_GROUP_NAME IS NULL THEN C.PLAN_GROUP_ID           ' + char(10)
                SELECT @v_dSql += '                  ELSE C.PLAN_GROUP_ID + ''('' + C.PLAN_GROUP_NAME + '')'' END )     ' + char(10)
                SELECT @v_dSql += '             WHEN A.CONFIRM_AREA = ''BUILDING''   THEN ''-'' ELSE ''-'' END) AS NAME ' + char(10)
                SELECT @v_dSql += ' FROM (                                                            ' + char(10)
                SELECT @v_dSql += '       SELECT SEGMENT1 AS INSTANCE_ID, ATTRIBUTE1 AS CONFIRM_AREA  ' + char(10)
                SELECT @v_dSql += '       FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                  ' + char(10)
                SELECT @v_dSql += '       WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_ID''                 ' + char(10)
                SELECT @v_dSql += '       AND    A.ACTIVE_FLAG = ''Y''                                ' + char(10)
                SELECT @v_dSql += ' ) A                                                               ' + char(10)
                SELECT @v_dSql += ' INNER JOIN (                                                      ' + char(10)
                SELECT @v_dSql += '         SELECT DISTINCT A.INSTANCE_ID, B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, A.FACTORY_ID	 ' + char(10)
                SELECT @v_dSql += '         FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK), SCM_FACTORY_M B WITH(NOLOCK)                        ' + char(10)
                SELECT @v_dSql += '         WHERE  A.FACTORY_ID  = B.FACTORY_ID                                    ' + char(10)
                SELECT @v_dSql += '         AND    A.ACTIVE_FLAG = ''Y''                                           ' + char(10)
                SELECT @v_dSql += '         AND    B.ACTIVE_FLAG = ''Y''                                           ' + char(10)
                SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @param2))   + char(10)

                SELECT @v_dSql += ' ) B                                                                            ' + char(10)
                SELECT @v_dSql += ' ON  A.INSTANCE_ID = B.INSTANCE_ID                                              ' + char(10)
                SELECT @v_dSql += ' LEFT OUTER JOIN (                                                              ' + char(10)
                SELECT @v_dSql += '        SELECT SEGMENT1 AS INSTANCE_ID, SEGMENT2 AS PLAN_GROUP_ID, ATTRIBUTE4 AS PLAN_GROUP_NAME ' + char(10)
                SELECT @v_dSql += '        FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)	           ' + char(10)
                SELECT @v_dSql += '        WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP'' ' + char(10)
                SELECT @v_dSql += '        AND    A.ACTIVE_FLAG = ''Y''	                           ' + char(10)
                SELECT @v_dSql += ' ) C                                                            ' + char(10)
                SELECT @v_dSql += ' ON    A.INSTANCE_ID = C.INSTANCE_ID                            ' + char(10)
                SELECT @v_dSql += ' WHERE 1=1                                                      ' + char(10)
                SELECT @v_dSql += ' AND   B.COMPANY_ID IS NOT NULL                                 ' + char(10)
                SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_ID' , 'EQ', @param1))   + char(10)
                SELECT @v_dSql += ' ORDER BY CODE                                                  ' + char(10)

				--SELECT @v_dSql
			    exec sp_executesql @v_dSql
			END
		/****************************************************************************************************************************************/
		/*   FP00310 findLineCode_common 정보갖고오기                                                                                        */
		/*   Param :@param1:  INSTANCE, @param1 DIVISION, @param2: Site, @param3: Plant, @param4:  FACTORY                                    */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00310_findLineCode_common'

			BEGIN
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT DISTINCT A.LINE_ID AS CODE  ' + char(10)
                SELECT @v_dSql += '      , ''('' + A.LINE_ID + '')'' + ( CASE WHEN A.LINE_NAME = '''' OR A.LINE_NAME IS NULL THEN A.LINE_ID ELSE A.LINE_NAME END ) AS NAME ' + char(10)
                SELECT @v_dSql += ' FROM (                              ' + char(10)
                SELECT @v_dSql += '       SELECT A.LINE_ID, A.LINE_NAME ' + char(10)
                SELECT @v_dSql += '           , ROW_NUMBER() OVER(PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LINE_ID ORDER BY CASE WHEN A.OPERATION_ID LIKE ''F%6000'' THEN 1 WHEN A.OPERATION_ID LIKE ''F%'' THEN 10 ELSE  100 END, A.OPERATION_ID DESC) AS ROW_NUM ' + char(10)
                SELECT @v_dSql += '       FROM   SCM_LINE_M A WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += '       WHERE 1=1                        ' + char(10)
                SELECT @v_dSql += '       AND   A.ACTIVE_FLAG = ''Y''      ' + char(10)
                SELECT @v_dSql += '       AND   EXISTS (                   ' + char(10)
                SELECT @v_dSql += '                     SELECT 1           ' + char(10)
                SELECT @v_dSql += '                     FROM (             ' + char(10)
                SELECT @v_dSql += '                           SELECT DISTINCT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID ' + char(10)
                SELECT @v_dSql += '                           FROM   SCM_FACTORY_M A WITH(NOLOCK)             ' + char(10)
                SELECT @v_dSql += '                           INNER JOIN FP_INSTANCE_FACTORY_M B WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += '                           ON    A.FACTORY_ID=B.FACTORY_ID                 ' + char(10)
                SELECT @v_dSql += '                           AND   B.ACTIVE_FLAG = ''Y''                     ' + char(10)
                SELECT @v_dSql += '                           WHERE A.ACTIVE_FLAG = ''Y''                     ' + char(10)

                IF (LEN(@param1) > 0)
                    BEGIN
                    	SELECT	@v_dSql += '                          AND   B.INSTANCE_ID = '''+ @param1 +''' ' + char(10)
                    END
                SELECT @v_dSql += '                     	 ) C ' + char(10)
                SELECT @v_dSql += '                     WHERE C.COMPANY_ID=A.COMPANY_ID AND C.DIVISION_ID=A.DIVISION_ID AND C.SITE_ID=A.SITE_ID AND C.PLANT_ID=A.PLANT_ID AND C.FACTORY_ID=A.FACTORY_ID ' + char(10)
                SELECT @v_dSql += '                    )         ' + char(10)
                SELECT @v_dSql += '       AND   EXISTS (         ' + char(10)
                SELECT @v_dSql += '                     SELECT 1 ' + char(10)
                SELECT @v_dSql += '                     FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)    ' + char(10)
                SELECT @v_dSql += '                     WHERE  A.COMPANY_ID  = B.COMPANY_ID          ' + char(10)
                SELECT @v_dSql += '                     AND    A.DIVISION_ID = B.DIVISION_ID         ' + char(10)
                SELECT @v_dSql += '                     AND    A.SITE_ID     = B.SITE_ID             ' + char(10)
                SELECT @v_dSql += '                     AND    A.PLANT_ID	 = B.PLANT_ID            ' + char(10)
                SELECT @v_dSql += '                     AND    A.FACTORY_ID  = B.FACTORY_ID          ' + char(10)
                SELECT @v_dSql += '                     AND    A.OPERATION_ID = B.OPERATION_ID       ' + char(10)
                SELECT @v_dSql += '                     AND    A.LINE_ID      = B.LINE_ID            ' + char(10)
                SELECT @v_dSql += '                     AND    B.USER_ID      = '''+ @p_user_id +''' ' + char(10)
                SELECT @v_dSql += '                     )                                            ' + char(10)
                IF (LEN(@param2) > 0)
                    BEGIN
                		SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param2))   + char(10)
                    END
                IF (LEN(@param3) > 0)
                    BEGIN
                		SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @param3))   + char(10)
                    END
                IF (LEN(@param4) > 0)
                    BEGIN
                	    SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @param4))   + char(10)
                    END
                IF (LEN(@param5) > 0)
                    BEGIN
                        SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @param5))   + char(10)
                    END
                IF (LEN(@param6) > 0)
                    BEGIN
                        SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @param6))   + char(10)
                    END
                IF (LEN(@param7) > 0)
                    BEGIN
                        SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @param7))   + char(10)
                    END
                
                IF (LEN(@param8) > 0)
                    BEGIN
                        SELECT	@v_dSql += '     AND EXISTS (                                    ' + char(10)
                        SELECT	@v_dSql += '             SELECT 1 FROM SCM_OPERATION_M OP        ' + char(10)
                        SELECT	@v_dSql += '             WHERE  A.COMPANY_ID   = OP.COMPANY_ID   ' + char(10)
                        SELECT	@v_dSql += '             AND    A.DIVISION_ID  = OP.DIVISION_ID  ' + char(10)
                        SELECT	@v_dSql += '             AND    A.SITE_ID      = OP.SITE_ID      ' + char(10)
                        SELECT	@v_dSql += '             AND    A.OPERATION_ID = OP.OPERATION_ID ' + char(10)
                        SELECT	@v_dSql += '             AND    OP.AMEND_FLAG  = ''Y''           ' + char(10)
                        SELECT	@v_dSql += '     )                                               ' + char(10)
                    END
                
                IF (LEN(@param1) > 0)
                    BEGIN
                        SELECT	@v_dSql += '     AND EXISTS ( SELECT  1                  ' + char(10)
                        SELECT	@v_dSql += '                FROM    SCM_SYS_LOOKUP_VALUE LV1 WITH(NOLOCK)         ' + char(10)
                        SELECT	@v_dSql += '      				   WHERE   LV1.LOOKUP_TYPE_CODE = ''INSTANCE_ID'' ' + char(10)
                        SELECT	@v_dSql += '           		 AND     LV1.SEGMENT1         = '''+ @param1 +'''     ' + char(10)
                        SELECT	@v_dSql += '           		 AND     LV1.ACTIVE_FLAG      = ''Y''                 ' + char(10)
                        SELECT	@v_dSql += '           		 AND     LV1.ATTRIBUTE1       = ''BUILDING''          ' + char(10)
                        SELECT	@v_dSql += '           		 UNION ALL                                            ' + char(10)
                        SELECT	@v_dSql += '           		 SELECT  1                                            ' + char(10)
                        SELECT	@v_dSql += '                FROM    SCM_SYS_LOOKUP_VALUE LV1 WITH(NOLOCK),        ' + char(10)
                        SELECT	@v_dSql += '           		         SCM_SYS_LOOKUP_VALUE LV2 WITH(NOLOCK)        ' + char(10)
                        SELECT	@v_dSql += '           		 WHERE   LV1.LOOKUP_TYPE_CODE = ''INSTANCE_ID''       ' + char(10)
                        SELECT	@v_dSql += '           		 AND 	   LV2.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP'' ' + char(10)
                        SELECT	@v_dSql += '           		 AND     LV1.SEGMENT1         = LV2.SEGMENT1      ' + char(10)
                        SELECT	@v_dSql += '           		 AND     LV1.SEGMENT1         = '''+ @param1 +''' ' + char(10)
                        SELECT	@v_dSql += '           		 AND     LV1.ACTIVE_FLAG      = ''Y''             ' + char(10)
                        SELECT	@v_dSql += '           		 AND     LV1.ATTRIBUTE1       = ''PLAN GROUP''    ' + char(10)
                        SELECT	@v_dSql += '           		 AND     LV2.SEGMENT2         = ISNULL(A.MODEL_TYPE,LV2.SEGMENT2) ) ' + char(10)
                     END               
                SELECT @v_dSql += '     ) A ' + char(10)
                SELECT @v_dSql += ' WHERE A.ROW_NUM = 1 ' + char(10)
                SELECT @v_dSql += ' ORDER BY A.LINE_ID  ' + char(10)

				--SELECT @v_dSql
			    exec sp_executesql @v_dSql
			END
        /****************************************************************************************************************************************/
        /*   FP00960화면에서 findAgingLine 정보갖고오기                                                                                        */
        /*            @param1     @Param2,    @Param3,    @Param4,    @Param5,    @Param6                                                      */
        /*   Param : DIVISION_ID, SITE_ID,  PLANT_ID,     FACTORY_ID,  OPERATION , ROUTE                                                       */
        /****************************************************************************************************************************************/
        ELSE IF @p_code = 'FP00960_findAgingLine' 
            BEGIN	
                SELECT @v_dSql = ''

                --SELECT @v_dSql += ' SELECT '''' AS CODE, ''ALL'' AS NAME ' + char(10)
                --SELECT @v_dSql += ' UNION ALL                            ' + char(10)
                SELECT @v_dSql += ' SELECT DISTINCT A.LINE_ID AS CODE, A.LINE_ID AS NAME ' + char(10)
                SELECT @v_dSql += ' FROM   SCM_AGING_ITEM_FLOW_M A WITH(NOLOCK)        ' + char(10)
                SELECT @v_dSql += ' WHERE  EXISTS (                                    ' + char(10)
                SELECT @v_dSql += '       SELECT 1                                     ' + char(10)
                SELECT @v_dSql += '       FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)    ' + char(10)
                SELECT @v_dSql += '       WHERE  A.COMPANY_ID   = B.COMPANY_ID         ' + char(10)
                SELECT @v_dSql += '       AND    A.DIVISION_ID  = B.DIVISION_ID        ' + char(10)
                SELECT @v_dSql += '       AND    A.SITE_ID      = B.SITE_ID            ' + char(10)
                SELECT @v_dSql += '       AND    A.PLANT_ID     = B.PLANT_ID           ' + char(10)
                SELECT @v_dSql += '       AND    A.FACTORY_ID   = B.FACTORY_ID         ' + char(10)
                SELECT @v_dSql += '       AND    B.USER_ID      = '''+ @p_user_id +''' ' + char(10)
                SELECT @v_dSql += ' )                                                  ' + char(10)

                SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param1))        + char(10)
				IF(LEN(@param2) > 0)
				    BEGIN
				        SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @param2))    + char(10)
				    END
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('       A.PLANT_ID' , 'EQ', @param3))    + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('       A.FACTORY_ID' , 'EQ', @param4))  + char(10)
				
				IF(LEN(@param5) > 0)
				    BEGIN
				        SELECT @v_dSql += 'AND   A.OPERATION_ID = '''+ @param5 +'''  ' + char(10)
				    END

				IF(LEN(@param6) > 0)
				    BEGIN
				        SELECT @v_dSql += 'AND    A.ROUTE_ID = '''+ @param6 +'''  ' + char(10)
				    END                
				SELECT @v_dSql += ' ORDER BY CODE                                 ' + char(10)

                --SELECT @v_dSql
                exec sp_executesql @v_dSql
        
           END
        /****************************************************************************************************************************************/
        /*   FP00960화면에서 findAgingOperation 정보갖고오기                                                                                    */
        /*            @param1     @Param2,    @Param3,    @Param4,     @Param5                                                                  */
        /*   Param : DIVISION_ID, SITE_ID,  PLANT_ID,     FACTORY_ID,  ROUTE                                                                    */
        /****************************************************************************************************************************************/
        ELSE IF @p_code = 'FP00960_findAgingOperation' 
            BEGIN	
                SELECT @v_dSql = ''

                --SELECT @v_dSql += ' SELECT '''' AS CODE, ''ALL'' AS NAME ' + char(10)
                --SELECT @v_dSql += ' UNION ALL                            ' + char(10)
                SELECT @v_dSql += ' SELECT DISTINCT A.OPERATION_ID AS CODE, A.OPERATION_ID AS NAME ' + char(10)
                SELECT @v_dSql += ' FROM   SCM_AGING_ITEM_FLOW_M A WITH(NOLOCK)        ' + char(10)
                SELECT @v_dSql += ' WHERE  EXISTS (                                    ' + char(10)
                SELECT @v_dSql += '       SELECT 1                                     ' + char(10)
                SELECT @v_dSql += '       FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)    ' + char(10)
                SELECT @v_dSql += '       WHERE  A.COMPANY_ID   = B.COMPANY_ID         ' + char(10)
                SELECT @v_dSql += '       AND    A.DIVISION_ID  = B.DIVISION_ID        ' + char(10)
                SELECT @v_dSql += '       AND    A.SITE_ID      = B.SITE_ID            ' + char(10)
                SELECT @v_dSql += '       AND    A.PLANT_ID     = B.PLANT_ID           ' + char(10)
                SELECT @v_dSql += '       AND    A.FACTORY_ID   = B.FACTORY_ID         ' + char(10)
                SELECT @v_dSql += '       AND    B.USER_ID      = '''+ @p_user_id +''' ' + char(10)
                SELECT @v_dSql += ' )                                                  ' + char(10)

                SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param1))        + char(10)
				IF(LEN(@param2) > 0)
				    BEGIN
				        SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @param2))    + char(10)
				    END
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('       A.PLANT_ID' , 'EQ', @param3))    + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('       A.FACTORY_ID' , 'EQ', @param4))  + char(10)
				
				IF(LEN(@param5) > 0)
				    BEGIN
				        SELECT @v_dSql += 'AND    A.ROUTE_ID = '''+ @param5 +'''  ' + char(10)
				    END
                
				SELECT @v_dSql += ' ORDER BY CODE                                 ' + char(10)

              --SELECT @v_dSql
              exec sp_executesql @v_dSql
        
           END
        /****************************************************************************************************************************************/
        /*   FP00960화면에서 findAgingRoute 정보갖고오기                                                                                        */
        /*            @param1     @Param2,    @Param3,    @Param4,                                                                              */
        /*   Param : DIVISION_ID, SITE_ID,  PLANT_ID,     FACTORY_ID,                                                                           */
        /****************************************************************************************************************************************/
        ELSE IF @p_code = 'FP00960_findAgingRoute' 
            BEGIN	
                SELECT @v_dSql = ''
                --SELECT @v_dSql += ' SELECT '''' AS CODE, ''ALL'' AS NAME ' + char(10)
                --SELECT @v_dSql += ' UNION ALL                            ' + char(10)
                SELECT @v_dSql += ' SELECT DISTINCT A.ROUTE_ID AS CODE, A.ROUTE_ID AS NAME ' + char(10)
                SELECT @v_dSql += ' FROM   SCM_AGING_ITEM_FLOW_M A WITH(NOLOCK)           ' + char(10)
                SELECT @v_dSql += ' WHERE  1=1                                            ' + char(10)
                SELECT @v_dSql += ' AND   EXISTS (                                        ' + char(10)
                SELECT @v_dSql += '          SELECT 1                                     ' + char(10)
                SELECT @v_dSql += '          FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)    ' + char(10)
                SELECT @v_dSql += '          WHERE  A.COMPANY_ID   = B.COMPANY_ID         ' + char(10)
                SELECT @v_dSql += '          AND    A.DIVISION_ID  = B.DIVISION_ID        ' + char(10)
                SELECT @v_dSql += '          AND    A.SITE_ID      = B.SITE_ID            ' + char(10)
                SELECT @v_dSql += '          AND    A.PLANT_ID     = B.PLANT_ID           ' + char(10)
                SELECT @v_dSql += '          AND    A.FACTORY_ID   = B.FACTORY_ID         ' + char(10)
                SELECT @v_dSql += '          AND    B.USER_ID      = '''+ @p_user_id +''' ' + char(10)
                SELECT @v_dSql += ' ) ' + char(10)

                SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param1))        + char(10)
				IF(LEN(@param2) > 0)
				    BEGIN
				        SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @param2))    + char(10)
				    END
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('       A.PLANT_ID' , 'EQ', @param3))    + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('       A.FACTORY_ID' , 'EQ', @param4))  + char(10)

                SELECT @v_dSql += ' ORDER BY CODE                                       ' + char(10)

              --SELECT @v_dSql
              exec sp_executesql @v_dSql
        
           END
		/****************************************************************************************************************************************/
		/*                */
		/*   Param :                                            */
		/*   Param : MST USER_INFO                              */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'MST_SSO_USER_INFO' 
		    BEGIN
				
			    SELECT @v_dSql =''
                SELECT @v_dSql += '	select * from   SY_SCM_MST_SSO_USER_INFO where ' + char(10);                
				
				SELECT @v_dSql += '			USER_ID = '''+ @param1 + '''' + char(10);			
				--SELECT @v_dSql += '			UserID = '''+ @param1 + '''' + char(10);			
				--EXEC PR_UI_SQL_LOG @v_proc_name, @p_user_id, @p_code, '', @v_dSql, 'select', @runstart, @runend
			    exec sp_executesql @v_dSql

		   END
		/****************************************************************************************************************************************/
		/*                */
		/*   Param :                                            */
		/*   Param : MST USER_INFO                              */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00100_find_virtual_factory' 
		    BEGIN
				
			    SELECT @v_dSql =''
                SELECT @v_dSql += ' SELECT	DISTINCT C.SEGMENT1 AS INSTNCE_ID, V.COMPANY_ID, V.SITE_ID, V.DIVISION_ID, V.PLANT_ID, V.FACTORY_ID, V.LINE_ID	' + char(10)
				SELECT @v_dSql += '			, D.SEGMENT5 AS CODE, D.SEGMENT5 AS NAME	' + char(10)
				SELECT @v_dSql += ' FROM	SCM_SYS_LOOKUP_VALUE C  																						' + char(10)
				SELECT @v_dSql += ' 		, SCM_SYS_LOOKUP_VALUE D           																				' + char(10)
				SELECT @v_dSql += ' 		, FP_INSTANCE_LINE_V V																							' + char(10)
				SELECT @v_dSql += ' WHERE	1=1                                                                                                             ' + char(10)            
				SELECT @v_dSql += ' AND		C.LOOKUP_TYPE_CODE = ''FORM_TRAY_SIMUL_OPTION''                                                                   ' + char(10)     
				SELECT @v_dSql += ' AND		C.ACTIVE_FLAG = ''Y''       																					    ' + char(10)
				SELECT @v_dSql += ' AND     C.ATTRIBUTE1 = ''BUILDING''																						' + char(10)
				SELECT @v_dSql += ' AND     D.LOOKUP_TYPE_CODE = ''FORMATION_TRAY_FACTORY_OPTION''                                                            ' + char(10)            
				SELECT @v_dSql += ' AND		D.ACTIVE_FLAG = ''Y''       																					    ' + char(10)
				SELECT @v_dSql += ' AND     C.SEGMENT1 = D.SEGMENT1																							' + char(10)
				SELECT @v_dSql += ' AND		C.SEGMENT1 = V.INSTANCE_ID																						' + char(10)
				SELECT @v_dSql += ' AND     D.SEGMENT4 = V.FACTORY_ID																						' + char(10)
				
				--EXEC PR_UI_SQL_LOG @v_proc_name, @p_user_id, @p_code, '', @v_dSql, 'select', @runstart, @runend
			    exec sp_executesql @v_dSql

		   END
		/****************************************************************************************************************************************/
		/* 2025/11/24   kimcd           [PJ2025F254]  JV법인 ESS 혼용 생산 시스템 개선                                                            */
        /*                              JV ESS 생산에 따른 실제 생산하는 라인과 연결 정보 관리. 가상 라인 여부 관리                                  */
        /*                              LINK_LINE_ID, VIRTUAL_LINE_YN 컬럼 추가                                                                  */
        /*                              LINK_LINE_ID에서 사용 가능한 목록 조회문장 추가                                                            */
		/*   Param : FP00100_find_link_line_id                                                                                                  */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00100_find_link_line_id' 
		    BEGIN

			    SELECT @v_dSql =''
                SELECT @v_dSql += ' SELECT LM.LINE_ID AS CODE, MAX(LM.LINE_NAME) AS NAME	' + char(10)
				SELECT @v_dSql += '	FROM   SCM_LINE_M  LM WITH(NOLOCK)	' + char(10)
				SELECT @v_dSql += '	       INNER JOIN SCM_PLANT_M PM WITH(NOLOCK)	' + char(10)
				SELECT @v_dSql += '			   ON  LM.PLANT_ID    = PM.LINK_PLANT_ID	' + char(10)
				SELECT @v_dSql += '			   AND LM.ACTIVE_FLAG = ''Y''	' + char(10)
				SELECT @v_dSql += ' WHERE	1=1   ' + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('PM.PLANT_ID' , 'EQ', @param1))        + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('LM.OPERATION_ID' , 'EQ', @param2))        + char(10)
				SELECT @v_dSql += '	GROUP BY LM.LINE_ID	' + char(10)

				--EXEC PR_UI_SQL_LOG @v_proc_name, @p_user_id, @p_code, '', @v_dSql, 'select', @runstart, @runend
			    exec sp_executesql @v_dSql

		   END		
	END
