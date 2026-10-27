/*
 * Program ID   : UI_FP_COMMON
 * Description  : 공통 코드성 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/01/15   				Initial	Release GSCM UI통합
 *
 */



CREATE PROCEDURE [dbo].[UI_FP_COMMON]
	  @Code	NVARCHAR(100)
    , @USER_ID NVARCHAR(100)
	, @NON_AUTH NVARCHAR(10)
	, @SAVE_AUTH NVARCHAR(10)
	, @Param1 NVARCHAR(MAX)  
	, @Param2 NVARCHAR(MAX)  
	, @Param3 NVARCHAR(MAX)  
	, @Param4 NVARCHAR(MAX)  
	, @Param5 NVARCHAR(MAX)
	, @Param6 NVARCHAR(MAX)
	, @Param7 NVARCHAR(MAX)
	, @Param8 NVARCHAR(MAX)
	, @Param9 NVARCHAR(MAX)
	, @Param10 NVARCHAR(MAX)
	, @Param11 NVARCHAR(MAX)
	, @Param12 NVARCHAR(MAX)
	, @Param13 NVARCHAR(MAX)
	, @Param14 NVARCHAR(MAX)
	, @Param15 NVARCHAR(MAX)
	, @Param16 NVARCHAR(MAX)
	, @Param17 NVARCHAR(MAX)
	, @Param18 NVARCHAR(MAX)
	, @Param19 NVARCHAR(MAX)
	, @Param20 NVARCHAR(MAX)
	, @Param21 NVARCHAR(MAX)
	, @Param22 NVARCHAR(MAX)
	, @Param23 NVARCHAR(MAX)
	, @Param24 NVARCHAR(MAX)
	, @Param25 NVARCHAR(MAX)
	, @Param26 NVARCHAR(MAX)
	, @Param27 NVARCHAR(MAX)
	, @Param28 NVARCHAR(MAX)
	, @Param29 NVARCHAR(MAX)
	, @Param30 NVARCHAR(MAX)
	, @TimeZone NVARCHAR(MAX) = 'AS054'
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @v_proc_name      nvarchar(100) = 'UI_FP_COMMON';
	DECLARE @runstart datetime;
	DECLARE @runend datetime;

    DECLARE @v_dept_id nvarchar(50)='';
	DECLARE @v_group_id nvarchar(50)='';
	DECLARE @v_text nvarchar(MAX)='';
	DECLARE @v_dSql nvarchar(MAX)=''; 
	DECLARE @V_INSTANCE_ID  NVARCHAR(MAX), @V_INSTANCE_LT	NVARCHAR(MAX)
	DECLARE @V_COMPANY_ID 	NVARCHAR(MAX), @V_COMPANY_LT    NVARCHAR(MAX)
	DECLARE @V_DIVISION_ID 	NVARCHAR(MAX), @V_DIVISION_LT   NVARCHAR(MAX)
	DECLARE @V_SITE_ID 		NVARCHAR(MAX), @V_SITE_LT       NVARCHAR(MAX)
	DECLARE @V_PLANT_ID 	NVARCHAR(MAX), @V_PLANT_LT	    NVARCHAR(MAX)
	DECLARE @V_FACTORY_ID 	NVARCHAR(MAX), @V_FACTORY_LT    NVARCHAR(MAX)
	DECLARE @V_OPERATION_ID NVARCHAR(MAX), @V_OPERATION_LT  NVARCHAR(MAX)
	DECLARE @V_LINE_ID 		NVARCHAR(MAX), @V_LINE_LT       NVARCHAR(MAX)
	DECLARE @V_ITEM_ID 		NVARCHAR(MAX), @V_ITEM_LT       NVARCHAR(MAX)
	DECLARE @V_NICK_NAME_ID NVARCHAR(MAX), @V_NICK_NAME_LT  NVARCHAR(MAX)
	DECLARE @V_INSTANCE_ID_STR  NVARCHAR(MAX)

	
	/****************************************************************************************************************************************/
	/*  Parameter 세팅                                                                                                       */
	/*                                                                                                    */
	/****************************************************************************************************************************************/
	BEGIN

	/*
			IF LEN(@Param1) < 1
				BEGIN	
					SET @V_INSTANCE_ID = ''
					SET @V_INSTANCE_ID_STR = ''
				END 
			ELSE
				BEGIN
					SET @V_INSTANCE_ID = 'AND	A.INSTANCE_ID = ''' + @Param1 +''' '
					SET @V_INSTANCE_ID_STR = @Param1
				END
			
			IF LEN(@Param2) < 1
				BEGIN	SET @V_INSTANCE_LT = '' END 
			ELSE
				BEGIN
					SET @V_INSTANCE_LT = 'AND	A.INSTANCE_ID IN (SELECT TOKEN FROM dbo.String_Split(''' + @Param2 + '''  ,'','')) '
				END

			IF LEN(@Param3) < 1
				BEGIN	SET @V_COMPANY_ID = '' END 
			ELSE
				BEGIN
					SET @V_COMPANY_ID = 'AND	A.COMPANY_ID = ''' + @Param3 +''' '
				END
			
			IF LEN(@Param4) < 1
				BEGIN	SET @V_COMPANY_LT = '' END 
			ELSE
				BEGIN
					SET @V_COMPANY_LT = 'AND	A.COMPANY_ID IN (SELECT TOKEN FROM dbo.String_Split(''' + @Param4 + '''  ,'','')) '
				END

			IF LEN(@Param5) < 1
				BEGIN	SET @V_DIVISION_ID = '' END 
			ELSE
				BEGIN
					SET @V_DIVISION_ID = 'AND	A.DIVISION_ID = ''' + @Param5 +''' '
				END
			
			IF LEN(@Param6) < 1
				BEGIN	SET @V_DIVISION_LT = '' END 
			ELSE
				BEGIN
					SET @V_DIVISION_LT = 'AND	A.DIVISION_ID IN (SELECT TOKEN FROM dbo.String_Split(''' + @Param6 + '''  ,'','')) '
				END

			IF LEN(@Param7) < 1
				BEGIN	SET @V_SITE_ID = '' END 
			ELSE
				BEGIN
					SET @V_SITE_ID = 'AND	A.SITE_ID = ''' + @Param7 +''' '
				END
			
			IF LEN(@Param8) < 1
				BEGIN	SET @V_SITE_LT = '' END 
			ELSE
				BEGIN
					SET @V_SITE_LT = 'AND	A.SITE_ID IN (SELECT TOKEN FROM dbo.String_Split(''' + @Param8 + '''  ,'','')) '
				END

			IF LEN(@Param9) < 1
				BEGIN	SET @V_PLANT_ID = '' END 
			ELSE
				BEGIN
					SET @V_PLANT_ID = 'AND	A.PLANT_ID = ''' + @Param9 +''' '
				END
			
			IF LEN(@Param10) < 1
				BEGIN	SET @V_PLANT_LT = '' END 
			ELSE
				BEGIN
					SET @V_PLANT_LT = 'AND	A.PLANT_ID IN (SELECT TOKEN FROM dbo.String_Split(''' + @Param10 + '''  ,'','')) '
				END

			IF LEN(@Param11) < 1
				BEGIN	SET @V_FACTORY_ID = '' END 
			ELSE
				BEGIN
					SET @V_FACTORY_ID = 'AND	A.FACTORY_ID = ''' + @Param11 +''' '
				END
			
			IF LEN(@Param12) < 1
				BEGIN	SET @V_FACTORY_LT = '' END 
			ELSE
				BEGIN
					SET @V_FACTORY_LT = 'AND	A.FACTORY_ID IN (SELECT TOKEN FROM dbo.String_Split(''' + @Param12 + '''  ,'','')) '
				END

			IF LEN(@Param13) < 1
				BEGIN	SET @V_OPERATION_ID = '' END 
			ELSE
				BEGIN
					SET @V_OPERATION_ID = 'AND	A.OPERATION_ID = ''' + @Param13 +''' '
				END
			
			IF LEN(@Param14) < 1
				BEGIN	SET @V_OPERATION_LT = '' END 
			ELSE
				BEGIN
					SET @V_OPERATION_LT = 'AND	A.OPERATION_ID IN (SELECT TOKEN FROM dbo.String_Split(''' + @Param14 + '''  ,'','')) '
				END

			IF LEN(@Param15) < 1
				BEGIN	SET @V_LINE_ID = '' END 
			ELSE
				BEGIN
					SET @V_LINE_ID = 'AND	A.LINE_ID = ''' + @Param15 + ''' '
				END
			
			IF LEN(@Param16) < 1
				BEGIN	SET @V_LINE_LT = '' END 
			ELSE
				BEGIN
					SET @V_LINE_LT = 'AND	A.LINE_ID IN (SELECT TOKEN FROM dbo.String_Split(''' + @Param16 + '''  ,'','')) '
				END
				
			IF LEN(@Param17) < 1
				BEGIN	SET @V_ITEM_ID = '' END 
			ELSE
				BEGIN
					SET @V_ITEM_ID = 'AND	A.ITEM_ID LIKE ''%' + @Param17 +'%'' '
				END
			
			IF LEN(@Param18) < 1
				BEGIN	SET @V_ITEM_LT = '' END 
			ELSE
				BEGIN
					SET @V_ITEM_LT = 'AND	A.ITEM_ID IN (SELECT TOKEN FROM dbo.String_Split(''' + @Param18 + '''  ,'','')) '
				END

			IF LEN(@Param19) < 1
				BEGIN	SET @V_NICK_NAME_ID = '' END 
			ELSE
				BEGIN
					SET @V_NICK_NAME_ID = 'AND	A.NICK_NAME LIKE ''%' + @Param19 +'%'' '
				END
			
			IF LEN(@Param20) < 1
				BEGIN	SET @V_NICK_NAME_LT = '' END 
			ELSE
				BEGIN
					SET @V_NICK_NAME_LT = 'AND	A.NICK_NAME IN (SELECT TOKEN FROM dbo.String_Split(''' + @Param20 + '''  ,'','')) '
				END
		*/

			--SET @USER_ID        = dbo.FN_deCRYPT_AES128(@USER_ID);
			SET @USER_ID        = @USER_ID;
			SET @V_INSTANCE_ID  = @Param1 ;
			SET @V_INSTANCE_LT	= @Param2 ;
			SET @V_COMPANY_ID 	= @Param3 ;
			SET @V_COMPANY_LT   = @Param4 ;
			SET @V_DIVISION_ID 	= @Param5 ;
			SET @V_DIVISION_LT  = @Param6 ;
			SET @V_SITE_ID 		= @Param7 ;
			SET @V_SITE_LT      = @Param8 ;
			SET @V_PLANT_ID 	= @Param9 ;
			SET @V_PLANT_LT	    = @Param10 ;
			SET @V_FACTORY_ID 	= @Param11 ;
			SET @V_FACTORY_LT   = @Param12 ;
			SET @V_OPERATION_ID = @Param13 ;
			SET @V_OPERATION_LT = @Param14 ;
			SET @V_LINE_ID 		= @Param15 ;
			SET @V_LINE_LT      = @Param16 ;
			SET @V_ITEM_ID 		= @Param17 ;
			SET @V_ITEM_LT      = @Param18 ;
			SET @V_NICK_NAME_ID = @Param19 ;
			SET @V_NICK_NAME_LT = @Param20 ;


			/**
				_LT 사용하지 않는다.
			**/
			IF LEN(@V_INSTANCE_LT) > 0 BEGIN SET @V_INSTANCE_ID = @V_INSTANCE_LT END
			IF LEN(@V_COMPANY_LT) > 0 BEGIN SET @V_COMPANY_ID = @V_COMPANY_LT END
			IF LEN(@V_DIVISION_LT) > 0 BEGIN SET @V_DIVISION_ID = @V_DIVISION_LT END
			IF LEN(@V_SITE_LT) > 0 BEGIN SET @V_SITE_ID = @V_SITE_LT END
			IF LEN(@V_PLANT_LT) > 0 BEGIN SET @V_PLANT_ID = @V_PLANT_LT END
			IF LEN(@V_FACTORY_LT) > 0 BEGIN SET @V_FACTORY_ID = @V_FACTORY_LT END
			IF LEN(@V_OPERATION_LT) > 0 BEGIN SET @V_OPERATION_ID = @V_OPERATION_LT END
			IF LEN(@V_LINE_LT) > 0 BEGIN SET @V_LINE_ID = @V_LINE_LT END
			IF LEN(@V_ITEM_LT) > 0 BEGIN SET @V_ITEM_ID = @V_ITEM_LT END
			IF LEN(@V_NICK_NAME_LT) > 0 BEGIN SET @V_NICK_NAME_ID = @V_NICK_NAME_LT END
			
	END

	
	-- 사용자의 팀정보 & 권한
	--SELECT @v_dept_id = U.DEPT_ID
	--FROM   [dbo].[TB_FX_User] U
	--WHERE  U.UserID = @Param1
	BEGIN
		SET @v_dept_id = '';
	END

		/****************************************************************************************************************************************/
	    /*  권한그룹을 LOOKUP관리 (BEGIN)                                                                                                       */
		/*    Param1 = , Param2 =                                                                                                  */
		/****************************************************************************************************************************************/
		--IF ISNULL((
		--			SELECT COUNT(1) FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
		--				where LOOKUP_TYPE = 'GET_ADMIN_GROUP' 
		--					AND VALID_YN = 'Y'
		--					--AND SEGMENT2 = 'ALL'  -- 'ALL'인경우 기본값(특정화면에서 추가된 그룹을 제외)
		--					AND SEGMENT2 in ('ALL','DMF0003')  -- 'ALL'인경우 기본값 + DMF0003는 W/S 그룹 추가
		--					AND SEGMENT1 = @Param3
		--		  ),0) > 0
		BEGIN
			SET @v_group_id = 'ADMIN'
		END

		/****************************************************************************************************************************************/
		/*   TimeZone정보 갖고오기                                                                                                              */
		/*   Param :                                                                                                                            */
		/****************************************************************************************************************************************/	
		-- TimeZone
		IF @Code = 'TIME_ZONE'	

			BEGIN
			    SELECT Getdate()
				--SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME FROM SCM_ADM_LOOKUP_MASTER_DETAIL  WITH(NOLOCK) 
				--WHERE LOOKUP_TYPE = 'TIME_ZONE'
				--  AND VALID_YN = 'Y'
				--ORDER BY DISPLAY_SEQ
			END	
		/****************************************************************************************************************************************/
		/*   Language정보 갖고오기                                                                                                              */
		/*   Param :                                                                                                                            */
		/****************************************************************************************************************************************/
		ELSE IF @Code = 'LANGUAGE'	

			BEGIN
			    SELECT Getdate()
				--SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME FROM SCM_ADM_LOOKUP_MASTER_DETAIL  WITH(NOLOCK) 
				--WHERE LOOKUP_TYPE = 'LANGUAGE'
				--  AND VALID_YN = 'Y'
				--ORDER BY DISPLAY_SEQ
			END		

		/****************************************************************************************************************************************/
		/*   그룹-사용자별 Division 정보갖고오기                                                                                                */
		/*    Param1 = UserID , Param2 = GroupID                                                                                                 */
		/****************************************************************************************************************************************/
		IF @Code = 'TEST' 

			BEGIN
			    /*   Param :  @Param21 : OPERATION_GROUP_ID, @Param22 : CAPA_TYPE            */
				
				/* Alias setting */
				BEGIN
					SET @V_INSTANCE_ID	= REPLACE(@V_INSTANCE_ID, 'A.', 'B.');
				END

				SET	@v_dSql = ''
				SET @v_dSql += '	SELECT A.LINE_ID AS CODE_ID																																' + char(10);
				SET @v_dSql += '	   , ''('' + A.LINE_ID + '')'' + CASE WHEN A.LINE_NAME = '''' OR A.LINE_NAME IS NULL THEN A.LINE_ID ELSE A.LINE_NAME END AS CODE_NAME                   ' + char(10);
				SET @v_dSql += '	FROM   SCM_LINE_M A WITH(NOLOCK)                                                                                                                        ' + char(10);
				SET @v_dSql += '	WHERE  EXISTS (                                                                                                                                         ' + char(10);
				SET @v_dSql += '		SELECT 1                                                                                                                                            ' + char(10);
				SET @v_dSql += '		FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)                                                                                                           ' + char(10);
				SET @v_dSql += '		WHERE  A.COMPANY_ID     = B.COMPANY_ID                                                                                                              ' + char(10);
				SET @v_dSql += '		AND    A.DIVISION_ID    = B.DIVISION_ID                                                                                                             ' + char(10);
				SET @v_dSql += '		AND    A.SITE_ID        = B.SITE_ID                                                                                                                 ' + char(10);
				SET @v_dSql += '		AND    A.PLANT_ID       = B.PLANT_ID                                                                                                                ' + char(10);
				SET @v_dSql += '		AND    A.FACTORY_ID     = B.FACTORY_ID                                                                                                              ' + char(10);
				SET @v_dSql += '		AND    A.OPERATION_ID   = B.OPERATION_ID                                                                                                            ' + char(10);
				SET @v_dSql += '		AND    A.LINE_ID        = B.LINE_ID                                                                                                                 ' + char(10);
				SET @v_dSql += '		AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE                                                                                                          ' + char(10);
				SET @v_dSql += '		AND    B.USER_ID     = '''+ @USER_ID +'''                                                                                                           ' + char(10);
				
				--IF @SAVE_AUTH = 'Y'
				--	BEGIN
				--		SET	@v_dSql += '						AND    B.SAVE_FLAG = ''Y''			    ' + char(10);
				--	END

				SET @v_dSql += '					)                                                                                                                                       ' + char(10);
				SET @v_dSql += '	AND   A.ACTIVE_FLAG = ''Y''                                                                                                                             ' + char(10);
				SET @v_dSql += '	AND   EXISTS (                                                                                                                                          ' + char(10);
				SET @v_dSql += '	    SELECT 1 FROM (                                                                                                                                     ' + char(10);
				SET @v_dSql += '	      SELECT DISTINCT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID                                                                      ' + char(10);
				SET @v_dSql += '	      FROM  SCM_FACTORY_M A WITH(NOLOCK)                                                                                                                ' + char(10);
				SET @v_dSql += '	      INNER JOIN FP_INSTANCE_FACTORY_M B WITH(NOLOCK)                                                                                                   ' + char(10);
				SET @v_dSql += '	      ON    A.FACTORY_ID  = B.FACTORY_ID                                                                                                                ' + char(10);
				SET @v_dSql += '	      AND   B.ACTIVE_FLAG = ''Y''                                                                                                                       ' + char(10);
				SET @v_dSql += '	      WHERE A.ACTIVE_FLAG = ''Y''                                                                                                                       ' + char(10);
				SET @v_dSql += '		  '+ @V_INSTANCE_ID +'																																' + char(10);
				SET @v_dSql += '	    ) C                                                                                                                                                 ' + char(10);
				SET @v_dSql += '	    WHERE C.COMPANY_ID=A.COMPANY_ID AND C.DIVISION_ID=A.DIVISION_ID AND C.SITE_ID=A.SITE_ID AND C.PLANT_ID=A.PLANT_ID AND C.FACTORY_ID=A.FACTORY_ID     ' + char(10);
				SET @v_dSql += '	)                                                                                                                                                       ' + char(10);
				SET @v_dSql += '	'+ @V_COMPANY_ID +'																																' + char(10);				
				SET @v_dSql += '	'+ @V_DIVISION_ID +'																															' + char(10);				
				SET @v_dSql += '	'+ @V_DIVISION_LT +'																															' + char(10);				
				SET @v_dSql += '	'+ @V_SITE_ID +'																																' + char(10);				
				SET @v_dSql += '	'+ @V_SITE_LT +'																																' + char(10);
				SET @v_dSql += '	'+ @V_PLANT_ID +'																															' + char(10);				
				SET @v_dSql += '	'+ @V_PLANT_LT +'																															' + char(10);
				SET @v_dSql += '	'+ @V_FACTORY_ID +'																															' + char(10);				
				SET @v_dSql += '	'+ @V_FACTORY_LT +'																															' + char(10);
				SET @v_dSql += '	'+ @V_OPERATION_ID +'																															' + char(10);
				SET @v_dSql += '	'+ @V_OPERATION_LT +'																															' + char(10);
				SET @v_dSql += '	'+ @V_LINE_ID +'																															' + char(10);				

				IF @param21 != '' --AMEND_FLAG
					BEGIN
						SET @v_dSql += '	              AND EXISTS (                                                                                                                  ' + char(10);
						SET @v_dSql += '	                SELECT 1 FROM SCM_OPERATION_M OP                                                                                            ' + char(10);
						SET @v_dSql += '	                WHERE  A.COMPANY_ID   = OP.COMPANY_ID                                                                                       ' + char(10);
						SET @v_dSql += '	                AND    A.DIVISION_ID  = OP.DIVISION_ID                                                                                      ' + char(10);
						SET @v_dSql += '	                AND    A.SITE_ID      = OP.SITE_ID                                                                                          ' + char(10);
						SET @v_dSql += '	                AND    A.OPERATION_ID = OP.OPERATION_ID                                                                                     ' + char(10);
						SET @v_dSql += '	                AND    OP.AMEND_FLAG  = ''Y''                                                                                               ' + char(10);
						SET @v_dSql += '	              )                                                                                                                             ' + char(10);
					END
				
				IF @V_INSTANCE_ID != ''
					BEGIN
						SET @v_dSql += '	  AND EXISTS ( SELECT  1                                                                                                                  ' + char(10);
						SET @v_dSql += '	               FROM    SCM_SYS_LOOKUP_VALUE LV1 WITH(NOLOCK)                                                                              ' + char(10);
						SET @v_dSql += '	     				   WHERE   LV1.LOOKUP_TYPE_CODE = ''INSTANCE_ID''                                                                     ' + char(10);
						SET @v_dSql += '	          		 AND     LV1.SEGMENT1         = ''' + @V_INSTANCE_ID_STR + '''                                                            ' + char(10);
						SET @v_dSql += '	          		 AND     LV1.ACTIVE_FLAG      = ''Y''                                                                                     ' + char(10);
						SET @v_dSql += '	          		 AND     LV1.ATTRIBUTE1       = ''BUILDING''                                                                              ' + char(10);
						SET @v_dSql += '	          		 UNION ALL                                                                                                                ' + char(10);
						SET @v_dSql += '	          		 SELECT  1                                                                                                                ' + char(10);
						SET @v_dSql += '	               FROM    SCM_SYS_LOOKUP_VALUE LV1 WITH(NOLOCK),                                                                             ' + char(10);
						SET @v_dSql += '	          		         SCM_SYS_LOOKUP_VALUE LV2 WITH(NOLOCK)                                                                            ' + char(10);
						SET @v_dSql += '	          		 WHERE   LV1.LOOKUP_TYPE_CODE = ''INSTANCE_ID''                                                                           ' + char(10);
						SET @v_dSql += '	          		 AND 	   LV2.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP''                                                             ' + char(10);
						SET @v_dSql += '	          		 AND     LV1.SEGMENT1         = LV2.SEGMENT1                                                                              ' + char(10);
						SET @v_dSql += '	          		 AND     LV1.SEGMENT1         = ''' + @V_INSTANCE_ID_STR + '''                                                            ' + char(10);
						SET @v_dSql += '	          		 AND     LV1.ACTIVE_FLAG      = ''Y''                                                                                     ' + char(10);
						SET @v_dSql += '	          		 AND     LV1.ATTRIBUTE1       = ''PLAN GROUP''                                                                            ' + char(10);
						SET @v_dSql += '	          		 AND     LV2.SEGMENT2         = ISNULL(A.MODEL_TYPE,LV2.SEGMENT2) )                                                       ' + char(10);
					END

				
				SET @v_dSql += '	GROUP BY a.LINE_ID, a.LINE_NAME                                                                                                                         ' + char(10);
				SET @v_dSql += '	ORDER BY A.LINE_ID                                                                                                                                      ' + char(10);

				--print @v_dSql;

				--exec sp_executesql @v_dSql;
			END		

		/****************************************************************************************************************************************/
		/*   Division 정보갖고오기                                                                                                              */
		/*   Param :																															*/
		/****************************************************************************************************************************************/
		ELSE IF @Code = 'DIVISION'

			BEGIN
				
				/* Alias setting */
				--BEGIN
				--	SET @V_INSTANCE_ID	= REPLACE(@V_INSTANCE_ID, 'A.', 'B.');
				--	SET @V_INSTANCE_LT	= REPLACE(@V_INSTANCE_LT, 'A.', 'B.');
				--END
				
				SET @v_dSql = '';
				SET	@v_dSql += '	SELECT	CODE, NAME													';
				SET	@v_dSql += '	FROM	(													';
				SET	@v_dSql += '				SELECT A.DIVISION_ID as CODE,				';
				SET	@v_dSql += '						''('' + A.DIVISION_ID + '')'' + case when A.division_name = '''' or A.division_name is null then A.DIVISION_ID else A.division_name end as NAME,		';
				SET	@v_dSql += '						ROW_NUMBER() OVER(PARTITION BY A.DIVISION_ID ORDER BY A.division_name ASC) AS RNUM																	';
				SET	@v_dSql += '				FROM  SCM_DIVISION_M A WITH(NOLOCK)																															';	

				IF	@NON_AUTH = 'Y'
					BEGIN
						SET	@v_dSql += '				WHERE 1=1                            ';
					END
				ELSE
					BEGIN
						SET	@v_dSql += '				WHERE  EXISTS (													';
						SET	@v_dSql += '								SELECT 1                                        ';
						SET	@v_dSql += '								FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)	    ';
						SET	@v_dSql += '								WHERE  A.COMPANY_ID  = B.COMPANY_ID             ';
						SET	@v_dSql += '								AND    A.DIVISION_ID = B.DIVISION_ID			';
						SET	@v_dSql += '								AND    B.USER_ID	 = '''+ @USER_ID +'''		';
						--IF @SAVE_AUTH = 'Y'
						--	BEGIN
						--		SET	@v_dSql += '								AND    B.SAVE_FLAG = ''Y''			    ';
						--	END
						SET	@v_dSql += '							  )			                                 ';

					END
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.COMPANY_ID' , 'EQ', @V_COMPANY_ID)) + char(10);
				--SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @V_DIVISION_ID)) + char(10);
				--SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @V_DIVISION_LT)) + char(10);
				SET @v_dSql += '		AND   EXISTS (							';
    			SET @v_dSql += '						SELECT 1 FROM (			';
    			SET @v_dSql += '								SELECT DISTINCT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID					';
    			SET @v_dSql += '								FROM   SCM_FACTORY_M A WITH(NOLOCK) INNER JOIN FP_INSTANCE_FACTORY_M B WITH(NOLOCK)				';
    			SET @v_dSql += '										ON     A.FACTORY_ID=B.FACTORY_ID														';	
    			SET @v_dSql += '										AND		 B.ACTIVE_FLAG = ''Y''															';	
    			SET @v_dSql += '								WHERE  1=1																						';			
    			SET @v_dSql += '								AND		 A.ACTIVE_FLAG = ''Y''																	';
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.INSTANCE_ID' , 'EQ', @V_INSTANCE_ID)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.INSTANCE_ID' , 'EQ', @V_INSTANCE_LT)) + char(10);
				SET @v_dSql += '							) C			';
    			SET @v_dSql += '						WHERE C.COMPANY_ID=A.COMPANY_ID AND C.DIVISION_ID=A.DIVISION_ID		';
				SET @v_dSql += '					)	';
				SET @v_dSql += '		) AA	';
				SET @v_dSql += '	WHERE RNUM=1	';
				SET @v_dSql += '	ORDER BY CODE	';

				--print @v_dSql;
				--INSERT INTO TH_UIS_SQL VALUES ('@@@v_dSql',@Code,@v_dSql , @USER_ID, getdate() ) ;

				--exec sp_executesql @v_dSql;
			END
		/****************************************************************************************************************************************/
		/*   Site 정보갖고오기                                                                                                                  */
		/*   Param :  @USER_ID = USER_ID, @Param1 : COMPANY_ID, @Param2 : DIVISION_ID , @Param3 : DIVISION_LT , @Param4 : INSTANCE_ID           */
		/*			  @Param21 : COUNTRY_ID 			*/
		/****************************************************************************************************************************************/
		ELSE IF @Code = 'SITE'

			BEGIN

				/* Alias setting */
				--BEGIN
				--	SET @V_INSTANCE_ID	= REPLACE(@V_INSTANCE_ID, 'A.', 'B.');
				--	SET @V_INSTANCE_LT	= REPLACE(@V_INSTANCE_LT, 'A.', 'B.');
				--END

				SET	@v_dSql = ''
				SET	@v_dSql += 'SELECT SITE_ID as code,									' + char(10);
				SET	@v_dSql += '	   ''('' + SITE_ID + '')'' + case when SITE_NAME = '''' or SITE_NAME is null then SITE_ID else SITE_NAME end as NAME		' + char(10);
				--SET	@v_dSql += '	   , COUNTRY_ID as country		' + char(10);
  				SET	@v_dSql += 'FROM SCM_SITE_M A WITH(NOLOCK)				' + char(10);
  				SET	@v_dSql += 'WHERE 1 = 1													' + char(10);
				
				IF	@NON_AUTH = 'Y'
					BEGIN
						SET	@v_dSql += '  ' + char(10);
					END
				ELSE
					BEGIN
						SET	@v_dSql += '				AND  EXISTS (													' + char(10);
						SET	@v_dSql += '								SELECT 1                                        ' + char(10);
						SET	@v_dSql += '								FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)	    ' + char(10);
						SET	@v_dSql += '								WHERE  A.COMPANY_ID  = B.COMPANY_ID             ' + char(10);
						SET	@v_dSql += '								AND    A.SITE_ID     = B.SITE_ID				' + char(10);
						SET	@v_dSql += '								AND    B.USER_ID	 = '''+ @USER_ID +'''		' + char(10);
						--IF @SAVE_AUTH = 'Y'
						--	BEGIN
						--		SET	@v_dSql += '								AND    B.SAVE_FLAG = ''Y''			    ' + char(10);
						--	END
						SET	@v_dSql += '							  )			                                 ' + char(10);

					END			  
				
				SET	@v_dSql += 'AND   EXISTS (														'+ char(10);
				SET	@v_dSql += '							SELECT 1 FROM (											'+ char(10);
				SET	@v_dSql += '						SELECT DISTINCT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID		'+ char(10);
				SET	@v_dSql += '								FROM SCM_FACTORY_M A WITH(NOLOCK) INNER JOIN FP_INSTANCE_FACTORY_M B WITH(NOLOCK)	'+ char(10);
				SET	@v_dSql += '								ON  A.FACTORY_ID=B.FACTORY_ID														'+ char(10);
				SET	@v_dSql += '								AND B.ACTIVE_FLAG = ''Y''												'+ char(10);
				SET	@v_dSql += '								WHERE 1=1																'+ char(10);
				SET	@v_dSql += '								AND		 A.ACTIVE_FLAG = ''Y''											'+ char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.INSTANCE_ID' , 'EQ', @V_INSTANCE_ID)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.INSTANCE_ID' , 'EQ', @V_INSTANCE_LT)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @V_DIVISION_ID)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @V_DIVISION_LT)) + char(10);
				--SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @V_SITE_ID)) + char(10);
				SET @v_dSql += '		) C															'+ char(10);
				SET @v_dSql += '	WHERE C.COMPANY_ID=A.COMPANY_ID AND C.SITE_ID=A.SITE_ID			'+ char(10);
				SET @v_dSql += '	)																'+ char(10);
				SET @v_dSql += '	'+ @V_COMPANY_ID +'																														' + char(10);				
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.COUNTRY_ID' , 'EQ', @Param21)) + char(10);
				SET @v_dSql += 'GROUP BY SITE_ID, SITE_NAME																													'+ char(10);
				SET @v_dSql += 'ORDER BY SITE_ID ASC																														'+ char(10);
				

				--print @v_dSql;

				--INSERT INTO TH_UIS_SQL VALUES ('@@@v_dSql',@Code,@v_dSql , @USER_ID, getdate() ) ;

				--exec sp_executesql @v_dSql;
		END
		/****************************************************************************************************************************************/
		/*   Plant 정보갖고오기                                                                                                                 */
		/*   Param :  @USER_ID = USER_ID, @Param1 : COMPANY_ID, @Param2 : DIVISION_ID , @Param3 : DIVISION_LT , @Param4 : INSTANCE_ID           */
		/*			  @Param5 : INSTANCE_LT , @Param6 : SITE_ID , @Param7 : PLANT_LT , @Param8 : NON_AUTH , @Param9 : SAVE_AUTH 				*/
		/****************************************************************************************************************************************/
		ELSE IF @Code = 'PLANT'

			BEGIN

				/* Alias setting */
				--BEGIN
				--	SET @V_INSTANCE_ID	= REPLACE(@V_INSTANCE_ID, 'A.', 'B.');
				--	SET @V_INSTANCE_LT	= REPLACE(@V_INSTANCE_LT, 'A.', 'B.');
				--END

				SET	@v_dSql = ''
				SET @v_dSql += '	SELECT PLANT_ID as CODE,																													' + char(10);	
				SET @v_dSql += '	       ''('' + PLANT_ID + '')'' + case when PLANT_NAME = '''' or PLANT_NAME is null then PLANT_ID else PLANT_NAME end as NAME                ' + char(10);
				SET @v_dSql += '	FROM  SCM_PLANT_M A WITH(NOLOCK)                                                                                                            ' + char(10);
				SET @v_dSql += '	WHERE 1 = 1                                                                                                                                 ' + char(10);
				
				IF	@NON_AUTH = 'Y'
					BEGIN
						SET	@v_dSql += '  ' + char(10);
					END
				ELSE
					BEGIN
						SET	@v_dSql += '				AND  EXISTS (													' + char(10);
						SET	@v_dSql += '								SELECT 1                                        ' + char(10);
						SET	@v_dSql += '								FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)	    ' + char(10);
						SET	@v_dSql += '								WHERE  A.COMPANY_ID  = B.COMPANY_ID             ' + char(10);
						SET	@v_dSql += '								AND    A.DIVISION_ID     = B.DIVISION_ID		' + char(10);
						SET	@v_dSql += '								AND    A.SITE_ID     = B.SITE_ID				' + char(10);
						SET	@v_dSql += '								AND    A.PLANT_ID     = B.PLANT_ID				' + char(10);
						SET	@v_dSql += '								AND    B.USER_ID	 = '''+ @USER_ID +'''		' + char(10);
						--IF @SAVE_AUTH = 'Y'
						--	BEGIN
						--		SET	@v_dSql += '								AND    B.SAVE_FLAG = ''Y''			    ' + char(10);
						--	END
						SET	@v_dSql += '							  )			                                 ' + char(10);

					END		
				SET @v_dSql += '	AND   EXISTS (                                                                                                                              ' + char(10);
				SET @v_dSql += '	        SELECT 1 FROM (                                                                                                                     ' + char(10);
				SET @v_dSql += '						SELECT DISTINCT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID                                            ' + char(10);
				SET @v_dSql += '						FROM SCM_FACTORY_M A WITH(NOLOCK) INNER JOIN FP_INSTANCE_FACTORY_M B WITH(NOLOCK)                                       ' + char(10);
				SET @v_dSql += '						ON  A.FACTORY_ID=B.FACTORY_ID                                                                                           ' + char(10);
				SET @v_dSql += '						AND B.ACTIVE_FLAG = ''Y''                                                                                                 ' + char(10);
				SET @v_dSql += '						WHERE 1=1                                                                                                               ' + char(10);
				SET @v_dSql += '						AND   A.ACTIVE_FLAG = ''Y''                                                                                               ' + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.INSTANCE_ID' , 'EQ', @V_INSTANCE_ID)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.INSTANCE_ID' , 'EQ', @V_INSTANCE_LT)) + char(10);
				SET @v_dSql += '					) C                                                                                                                         ' + char(10);
				SET @v_dSql += '					WHERE C.COMPANY_ID=A.COMPANY_ID AND C.DIVISION_ID=A.DIVISION_ID AND C.SITE_ID=A.SITE_ID AND C.PLANT_ID=A.PLANT_ID           ' + char(10);
				SET @v_dSql += '				)                                                                                                                               ' + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.COMPANY_ID' , 'EQ', @V_COMPANY_ID)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @V_DIVISION_ID)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @V_DIVISION_LT)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @V_SITE_ID)) + char(10);
				--SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @V_PLANT_ID)) + char(10);
				SET @v_dSql += '	GROUP BY PLANT_ID, PLANT_NAME                                                                                                               ' + char(10);
				SET @v_dSql += '	ORDER BY PLANT_ID ASC                                                                                                                       ' + char(10);

				--print @v_dSql;

				--INSERT INTO TH_UIS_SQL VALUES ('@@@v_dSql',@Code,@v_dSql , @USER_ID, getdate() ) ;

				--exec sp_executesql @v_dSql;

			END
		/****************************************************************************************************************************************/
		/*   Plant 정보갖고오기                                                                                                                 */
		/*   Param :  @USER_ID = USER_ID, @Param1 : COMPANY_ID, @Param2 : DIVISION_ID , @Param3 : DIVISION_LT , @Param4 : INSTANCE_ID           */
		/*			  @Param5 : INSTANCE_LT , @Param6 : SITE_ID , @Param7 : SITE_LT , @Param8 : PLANT_ID , @Param9 : PLANT_LT 				*/
		/*			  @Param10 : FACTORY_ID , @Param11 : SAVE_AUTH																			*/
		/****************************************************************************************************************************************/
		ELSE IF @Code ='FACTORY'
		    BEGIN
				
				/* Alias setting */
				--BEGIN
				--	SET @V_INSTANCE_ID	= REPLACE(@V_INSTANCE_ID, 'A.', 'B.');
				--	SET @V_INSTANCE_LT	= REPLACE(@V_INSTANCE_LT, 'A.', 'B.');
				--END

				SET	@v_dSql = ''
				SET @v_dSql += ' SELECT A.FACTORY_ID AS CODE,																															' + char(10);
				SET @v_dSql += '        ''('' + A.FACTORY_ID + '')'' + CASE WHEN A.FACTORY_NAME = '''' OR A.FACTORY_NAME IS NULL THEN A.FACTORY_ID ELSE A.FACTORY_NAME END AS NAME     ' + char(10);
				--SET @v_dSql += '        , CASE WHEN R.FACTORY_ID IS NOT NULL THEN 1 ELSE 0 END AS ROWCHK                                                                                    ' + char(10);
				SET @v_dSql += ' FROM   SCM_FACTORY_M A WITH(NOLOCK)                                                                                                                        ' + char(10);
				SET @v_dSql += ' 		LEFT OUTER JOIN (                                                                                                                                   ' + char(10);
				SET @v_dSql += ' 				SELECT	DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID                                                           ' + char(10);
				SET @v_dSql += ' 				FROM	FP_USER_ROLE_INFO_V R WITH(NOLOCK)                                                                                                  ' + char(10);
				SET @v_dSql += ' 				WHERE	1=1                                                                                                                                 ' + char(10);
				SET @v_dSql += ' 				AND		R.USER_ID	= '''+ @USER_ID +'''                                                                                                    ' + char(10);
				
				--IF @SAVE_AUTH = 'Y'
				--	BEGIN
				--		SET	@v_dSql += '								AND    R.SAVE_FLAG = ''Y''			    ' + char(10);
				--	END
				
				SET @v_dSql += ' 		) R                                                                                                                                                 ' + char(10);
				SET @v_dSql += ' 		ON		1=1                                                                                                                                         ' + char(10);
				SET @v_dSql += ' 		AND		A.COMPANY_ID		= R.COMPANY_ID                                                                                            ' + char(10);
				SET @v_dSql += ' 		AND		A.DIVISION_ID		= R.DIVISION_ID                                                                                                         ' + char(10);
				SET @v_dSql += ' 		AND		A.SITE_ID			= R.SITE_ID                                                                                                             ' + char(10);
				SET @v_dSql += ' 		AND		A.PLANT_ID			= R.PLANT_ID                                                                                                            ' + char(10);
				SET @v_dSql += ' 		AND		A.FACTORY_ID		= R.FACTORY_ID                                                                                                          ' + char(10);
				SET @v_dSql += ' WHERE  EXISTS (                                                                                                                                            ' + char(10);
				SET @v_dSql += ' 	    			SELECT 1                                                                                                                                ' + char(10);
				SET @v_dSql += ' 	    			FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)                                                                                               ' + char(10);
				SET @v_dSql += ' 	    			WHERE  A.COMPANY_ID     = B.COMPANY_ID                                                                                                  ' + char(10);
				SET @v_dSql += ' 	    			AND    A.DIVISION_ID    = B.DIVISION_ID                                                                                                 ' + char(10);
				SET @v_dSql += ' 	    			AND    A.SITE_ID        = B.SITE_ID                                                                                                     ' + char(10);
				SET @v_dSql += ' 	    			AND    A.PLANT_ID       = B.PLANT_ID                                                                                                    ' + char(10);
				SET @v_dSql += ' 	    			AND    A.FACTORY_ID     = B.FACTORY_ID                                                                                                  ' + char(10);
				SET @v_dSql += ' 	    			AND    B.USER_ID        = '''+ @USER_ID +'''                                                                                            ' + char(10);
				
				--IF @SAVE_AUTH = 'Y'
				--	BEGIN
				--		SET	@v_dSql += '								AND    B.SAVE_FLAG = ''Y''			    ' + char(10);
				--	END
				
				SET @v_dSql += ' 			  )                                                                                                                                             ' + char(10);
				SET @v_dSql += ' AND		 A.ACTIVE_FLAG = ''Y''                                                                                                                          ' + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.COMPANY_ID' , 'EQ', @V_COMPANY_ID)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @V_DIVISION_ID)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @V_DIVISION_LT)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @V_SITE_ID)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @V_SITE_LT)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @V_PLANT_ID)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @V_PLANT_LT)) + char(10);
				--SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @V_FACTORY_ID)) + char(10);
				SET @v_dSql += ' GROUP BY a.FACTORY_ID, a.FACTORY_NAME, CASE WHEN R.FACTORY_ID IS NOT NULL THEN 1 ELSE 0 END                                                                ' + char(10);
				SET @v_dSql += ' ORDER BY a.FACTORY_ID                                                                                                                                      ' + char(10);
				
				--print @v_dSql;
				--INSERT INTO TH_UIS_SQL VALUES ('@@@v_dSql',@Code,@v_dSql , @USER_ID, getdate() ) ;

				--exec sp_executesql @v_dSql;
			END
		/****************************************************************************************************************************************/
		/*   Operation 정보갖고오기                                                                                                             */
		/*   Param :  @Param21 = OPERATION_GROUP_ID, @Param22 = CAPA_TYPE, @Param23 -- SLURRY YN									               */
		/****************************************************************************************************************************************/
		ELSE IF @Code ='OPERATION'
		    BEGIN

				/* Alias setting */
				--BEGIN
				--	SET @V_PLANT_LT		= REPLACE(@V_PLANT_LT, 'A.', 'C.');
				--	SET @V_FACTORY_LT	= REPLACE(@V_FACTORY_LT, 'A.', 'C.');
				--	SET @V_INSTANCE_ID	= REPLACE(@V_INSTANCE_ID, 'A.', 'B.');
				--	SET @V_INSTANCE_LT	= REPLACE(@V_INSTANCE_LT, 'A.', 'B.');
				--END

				SET	@v_dSql = ''
				SET @v_dSql += '	SELECT OPERATION_ID AS CODE, ''(''+OPERATION_ID+'')''+ISNULL(OPERATION_NAME, OPERATION_ID) AS NAME       								' + char(10);
				SET @v_dSql += '	FROM SCM_OPERATION_M A WITH(NOLOCK)                                                                                                             ' + char(10);
				SET @v_dSql += '	WHERE ((                                                                                                                                        ' + char(10);
				SET @v_dSql += '	EXISTS (SELECT 1 FROM SCM_MMD_OPERATION_GROUP_M B WITH(NOLOCK) WHERE B.OPERATION_GROUP_ID=A.OPERATION_GROUP_ID AND B.ROUTE_TYPE=''P'')          ' + char(10);
				SET @v_dSql += '	AND MES_ERP_INTERFACE_FLAG=''Y''                                                                                                                ' + char(10);
				SET @v_dSql += '	) OR                                                                                                                                            ' + char(10);
				SET @v_dSql += '	(                                                                                                                                               ' + char(10);
				SET @v_dSql += '	NOT EXISTS (SELECT 1 FROM SCM_MMD_OPERATION_GROUP_M B WITH(NOLOCK) WHERE B.OPERATION_GROUP_ID=A.OPERATION_GROUP_ID AND B.ROUTE_TYPE=''P'')      ' + char(10);
				SET @v_dSql += '	))                                                                                                                                              ' + char(10);
				SET @v_dSql += '	AND EXISTS (SELECT 1 FROM SCM_LINE_M C WITH(NOLOCK)                                                                                             ' + char(10);
				SET @v_dSql += '	          WHERE C.COMPANY_ID=A.COMPANY_ID                                                                                                       ' + char(10);
				SET @v_dSql += '	          AND   C.DIVISION_ID=A.DIVISION_ID                                                                                                     ' + char(10);
				SET @v_dSql += '	          AND   C.SITE_ID=A.SITE_ID                                                                                                             ' + char(10);
				SET @v_dSql += '	          AND   C.OPERATION_ID=A.OPERATION_ID                                                                                                   ' + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.PLANT_ID' , 'EQ', @V_PLANT_ID)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.FACTORY_ID' , 'EQ', @V_FACTORY_ID)) + char(10);
				SET @v_dSql += '	       )                                                                                                                                     ' + char(10);
				SET @v_dSql += '	AND EXISTS (SELECT 1 FROM (SELECT DISTINCT B.INSTANCE_TYPE                                                                                      ' + char(10);
				SET @v_dSql += '	          							 FROM SCM_FACTORY_M A WITH(NOLOCK)                                                                          ' + char(10);
				SET @v_dSql += '	          							 INNER JOIN FP_INSTANCE_FACTORY_M B WITH(NOLOCK)                                                            ' + char(10);
				SET @v_dSql += '	          							 ON  A.FACTORY_ID=B.FACTORY_ID                                                                              ' + char(10);
				SET @v_dSql += '	          							 AND B.ACTIVE_FLAG = ''Y''                                                                                  ' + char(10);
				SET @v_dSql += '	          							 WHERE 1=1                                                                                                  ' + char(10);
				SET @v_dSql += '	          							 AND   A.ACTIVE_FLAG = ''Y''                                                                                ' + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.INSTANCE_ID' , 'EQ', @V_INSTANCE_ID)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.INSTANCE_ID' , 'EQ', @V_INSTANCE_LT)) + char(10);
				SET @v_dSql += '	          							 ) C                                                                                                        ' + char(10);
				SET @v_dSql += '			                     WHERE C.INSTANCE_TYPE=A.INSTANCE_TYPE )                                                                            ' + char(10);
				SET @v_dSql += '	AND  EXISTS (                                                                                                                                   ' + char(10);
				SET @v_dSql += '		          SELECT 1                                                                                                                          ' + char(10);
				SET @v_dSql += '		          FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)                                                                                         ' + char(10);
				SET @v_dSql += '		          WHERE  A.COMPANY_ID   = B.COMPANY_ID                                                                                              ' + char(10);
				SET @v_dSql += '		          AND    A.DIVISION_ID  = B.DIVISION_ID                                                                                             ' + char(10);
				SET @v_dSql += '		          AND    A.SITE_ID      = B.SITE_ID                                                                                                 ' + char(10);
				SET @v_dSql += '		          AND    A.OPERATION_ID = B.OPERATION_ID                                                                                            ' + char(10);
				SET @v_dSql += '		          AND    B.USER_ID      = '''+ @USER_ID +'''		                                                                                    ' + char(10);
				
				--IF @SAVE_AUTH = 'Y'
				--	BEGIN
				--		SET	@v_dSql += '						AND    B.SAVE_FLAG = ''Y''			    ' + char(10);
				--	END

				SET @v_dSql += '		      )                                                                                                                                     ' + char(10);
				SET @v_dSql += '	AND   ACTIVE_FLAG = ''Y''                                                                                                                       ' + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.COMPANY_ID' , 'EQ', @V_COMPANY_ID)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @V_DIVISION_ID)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @V_DIVISION_LT)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @V_SITE_ID)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @V_SITE_LT)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_GROUP_ID' , 'EQ', @Param21)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.CAPA_TYPE' , 'EQ', @Param22)) + char(10);

				IF @Param23 = 'Y'
					BEGIN
						SET	@v_dSql += '						AND  A.OPERATION_ID = ''E0500''			    ' + char(10);
					END

				SET @v_dSql += '	GROUP BY A.OPERATION_ID, A.OPERATION_NAME                                                                                                       ' + char(10);
				SET @v_dSql += '	ORDER BY A.OPERATION_ID                                                                                                                         ' + char(10);

				--print @v_dSql;
				--INSERT INTO TH_UIS_SQL VALUES ('@@@v_dSql',@Code,@v_dSql , @USER_ID, getdate() ) ;

				--exec sp_executesql @v_dSql;

			END
		/****************************************************************************************************************************************/
		/*   Line 정보갖고오기                                                                                                                 */
		/*   Param :  @PARAM21 = AMEND_FLAG																										*/
		/****************************************************************************************************************************************/
		ELSE IF @Code ='LINE'
		    BEGIN
				  
				  /* Alias setting */
				--BEGIN
				--	SET @V_INSTANCE_ID	= REPLACE(@V_INSTANCE_ID, 'A.', 'B.');
				--END

				SET	@v_dSql = ''
				SET @v_dSql += '	SELECT A.LINE_ID AS CODE																																' + char(10);
				--SET @v_dSql += '	, A.COMPANY_ID  AS COMPANY_ID' + char(10);
				--SET @v_dSql += '	   , A.COMPANY_ID AS COMPANY_ID, A.DIVISION_ID AS DIVISION_ID, A.SITE_ID AS SITE_ID, A.PLANT_ID AS PLANT_ID, A.FACTORY_ID AS FACTORY_ID, A.OPERATION_ID AS OPERATION_ID,A.ELECTRODE_TYPE  AS ELECTRODE_TYPE                ' + char(10);
				SET @v_dSql += '	   , ''('' + A.LINE_ID + '')'' + CASE WHEN A.LINE_NAME = '''' OR A.LINE_NAME IS NULL THEN A.LINE_ID ELSE A.LINE_NAME END AS NAME                   ' + char(10);
				SET @v_dSql += '	FROM   SCM_LINE_M A WITH(NOLOCK)                                                                                                                        ' + char(10);
				SET @v_dSql += '	WHERE  EXISTS (                                                                                                                                         ' + char(10);
				SET @v_dSql += '		SELECT 1                                                                                                                                            ' + char(10);
				SET @v_dSql += '		FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)                                                                                                           ' + char(10);
				SET @v_dSql += '		WHERE  A.COMPANY_ID     = B.COMPANY_ID                                                                                                              ' + char(10);
				SET @v_dSql += '		AND    A.DIVISION_ID    = B.DIVISION_ID                                                                                                             ' + char(10);
				SET @v_dSql += '		AND    A.SITE_ID        = B.SITE_ID                                                                                                                 ' + char(10);
				SET @v_dSql += '		AND    A.PLANT_ID       = B.PLANT_ID                                                                                                                ' + char(10);
				SET @v_dSql += '		AND    A.FACTORY_ID     = B.FACTORY_ID                                                                                                       ' + char(10);
				SET @v_dSql += '		AND    A.OPERATION_ID   = B.OPERATION_ID                                                                                                            ' + char(10);
				SET @v_dSql += '		AND    A.LINE_ID        = B.LINE_ID                                                                                                                 ' + char(10);
				SET @v_dSql += '		AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE                                                                                                          ' + char(10);
				SET @v_dSql += '		AND    B.USER_ID     = '''+ @USER_ID +'''                                                                                                           ' + char(10);
				
				--IF @SAVE_AUTH = 'Y'
				--	BEGIN
				--		SET	@v_dSql += '						AND    B.SAVE_FLAG = ''Y''			    ' + char(10);
				--	END

				SET @v_dSql += '					)                                                                                                                                       ' + char(10);
				SET @v_dSql += '	AND   A.ACTIVE_FLAG = ''Y''                                                                                                                             ' + char(10);
				SET @v_dSql += '	AND   EXISTS (                                                                                                                                          ' + char(10);
				SET @v_dSql += '	    SELECT 1 FROM (                                                                                                                                     ' + char(10);
				SET @v_dSql += '	      SELECT DISTINCT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID                                                                      ' + char(10);
				SET @v_dSql += '	      FROM  SCM_FACTORY_M A WITH(NOLOCK)                                                                                                                ' + char(10);
				SET @v_dSql += '	      INNER JOIN FP_INSTANCE_FACTORY_M B WITH(NOLOCK)                                                                                                   ' + char(10);
				SET @v_dSql += '	      ON    A.FACTORY_ID  = B.FACTORY_ID                                                                                                                ' + char(10);
				SET @v_dSql += '	      AND   B.ACTIVE_FLAG = ''Y''                                                                                                                       ' + char(10);
				SET @v_dSql += '	      WHERE A.ACTIVE_FLAG = ''Y''                                                                                                                       ' + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.INSTANCE_ID' , 'EQ', @V_INSTANCE_ID)) + char(10);
				SET @v_dSql += '	    ) C                                                                                                                                                 ' + char(10);
				SET @v_dSql += '	    WHERE C.COMPANY_ID=A.COMPANY_ID AND C.DIVISION_ID=A.DIVISION_ID AND C.SITE_ID=A.SITE_ID AND C.PLANT_ID=A.PLANT_ID AND C.FACTORY_ID=A.FACTORY_ID     ' + char(10);
				SET @v_dSql += '	)                                                                                                                                                       ' + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.COMPANY_ID' , 'EQ', @V_COMPANY_ID)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @V_DIVISION_ID)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @V_DIVISION_LT)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @V_SITE_ID)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @V_SITE_LT)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @V_PLANT_ID)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @V_PLANT_LT)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @V_FACTORY_ID)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @V_FACTORY_LT)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @V_OPERATION_ID)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @V_OPERATION_LT)) + char(10);
				--SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @V_LINE_ID)) + char(10);

				IF @param21 != '' --AMEND_FLAG
					BEGIN
						SET @v_dSql += '	              AND EXISTS (                                                                                                                  ' + char(10);
						SET @v_dSql += '	                SELECT 1 FROM SCM_OPERATION_M OP                                                                                            ' + char(10);
						SET @v_dSql += '	                WHERE  A.COMPANY_ID   = OP.COMPANY_ID                                                                                       ' + char(10);
						SET @v_dSql += '	                AND    A.DIVISION_ID  = OP.DIVISION_ID                                                                                      ' + char(10);
						SET @v_dSql += '	                AND    A.SITE_ID      = OP.SITE_ID                                                                                          ' + char(10);
						SET @v_dSql += '	                AND    A.OPERATION_ID = OP.OPERATION_ID                                                                                     ' + char(10);
						SET @v_dSql += '	                AND    OP.AMEND_FLAG  = ''Y''                                                                                               ' + char(10);
						SET @v_dSql += '	              )                                                                                                                             ' + char(10);
					END
				
				IF @V_INSTANCE_ID_STR != ''
					BEGIN
						SET @v_dSql += '	  AND EXISTS ( SELECT  1                                                                                                                  ' + char(10);
						SET @v_dSql += '	               FROM    SCM_SYS_LOOKUP_VALUE LV1 WITH(NOLOCK)                                                                              ' + char(10);
						SET @v_dSql += '	     				   WHERE   LV1.LOOKUP_TYPE_CODE = ''INSTANCE_ID''                                                                     ' + char(10);
						SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('LV1.SEGMENT1' , 'EQ', @V_INSTANCE_ID)) + char(10);
						SET @v_dSql += '	          		 AND     LV1.ACTIVE_FLAG      = ''Y''                                                                                     ' + char(10);
						SET @v_dSql += '	          		 AND     LV1.ATTRIBUTE1       = ''BUILDING''                                                                              ' + char(10);
						SET @v_dSql += '	          		 UNION ALL                                                                                                                ' + char(10);
						SET @v_dSql += '	          		 SELECT  1                                                                                                                ' + char(10);
						SET @v_dSql += '	               FROM    SCM_SYS_LOOKUP_VALUE LV1 WITH(NOLOCK),                                                                             ' + char(10);
						SET @v_dSql += '	          		         SCM_SYS_LOOKUP_VALUE LV2 WITH(NOLOCK)                     ' + char(10);
						SET @v_dSql += '	          		 WHERE   LV1.LOOKUP_TYPE_CODE = ''INSTANCE_ID''                                                                           ' + char(10);
						SET @v_dSql += '	          		 AND 	   LV2.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP''                                                             ' + char(10);
						SET @v_dSql += '	          		 AND     LV1.SEGMENT1         = LV2.SEGMENT1                                                                              ' + char(10);
						SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('LV1.SEGMENT1' , 'EQ', @V_INSTANCE_ID)) + char(10);
						SET @v_dSql += '	          		 AND     LV1.ACTIVE_FLAG      = ''Y''                                                                                     ' + char(10);
						SET @v_dSql += '	          		 AND     LV1.ATTRIBUTE1       = ''PLAN GROUP''                                                                            ' + char(10);
						SET @v_dSql += '	          		 AND     LV2.SEGMENT2         = ISNULL(A.MODEL_TYPE,LV2.SEGMENT2) )                                                       ' + char(10);
					END

				SET @v_dSql += '	GROUP BY a.LINE_ID, a.LINE_NAME   ' + char(10);
				--SET @v_dSql += '	GROUP BY a.LINE_ID, a.LINE_NAME, a.COMPANY_ID , A.DIVISION_ID,  A.SITE_ID, A.PLANT_ID , A.FACTORY_ID , A.OPERATION_ID ,A.ELECTRODE_TYPE                                                                                                                         ' + char(10);
				SET @v_dSql += '	ORDER BY A.LINE_ID                                                                                                                                      ' + char(10);
				
				--print @v_dSql;
				--INSERT INTO TH_UIS_SQL VALUES ('@@@v_dSql',@Code,@v_dSql , @USER_ID, getdate() ) ;

				--exec sp_executesql @v_dSql;

			END  
		/****************************************************************************************************************************************/
		/*   Line Set Group ID 정보갖고오기                                                                                                     */
		/*   Param :  @PARAM1 = USER_ID,@PARAM2 = DIVISION ,@PARAM3= SITE,@PARAM4= PLANT,@PARAM5= FACTORY,@PARAM6= OPERATION,@PARAM7= LINE      */
		/****************************************************************************************************************************************/
		ELSE IF @Code ='LINE_SETUP_GROUP_ID'
		    BEGIN

				SET @v_dSql  = '';   
				SET @v_dSql  += ' SELECT A.COMPANY_ID As COMPANY_ID,A.DIVISION_ID As DIVISION_ID,A.SITE_ID As SITE_ID,A.PLANT_ID As PLANT_ID   ';
				SET @v_dSql  += ' 	,A.OPERATION_ID As OPERATION_ID																			   ';
				SET @v_dSql  += ' 	,A.LINE_SETUP_GROUP_ID As CODE																			   ';
				SET @v_dSql  += ' 	,A.LINE_SETUP_GROUP_ID As NAME																			   ';
				SET @v_dSql  += ' FROM   SCM_LINE_SETUP_GROUP_M A(NOLOCK)																	   ';
				SET @v_dSql  += ' ORDER BY A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.OPERATION_ID,A.LINE_SETUP_GROUP_ID                ';  
				
				--print @v_dSql;
				 --INSERT INTO TH_UIS_SQL VALUES ('@@@v_dSql',@Code,@v_dSql , @USER_ID, getdate() ) ;

				-- exec sp_executesql @v_dSql;

			END	
		/****************************************************************************************************************************************/
		/*   Line Type     정보갖고오기                                                                                                         */
		/*   Param :  @PARAM1 = USER_ID,@PARAM2 = DIVISION ,@PARAM3= SITE,@PARAM4= PLANT,@PARAM5= FACTORY,@PARAM6= OPERATION,@PARAM7= LINE      */
		/****************************************************************************************************************************************/
		ELSE IF @Code ='LINE_TYPE'
		    BEGIN
			    SET @v_dSql = '';
				SET @v_dSql += '  SELECT A.SEGMENT1 As CODE, A.SEGMENT2 As NAME 					  ' + char(10);
				SET @v_dSql += '  FROM  SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)							  ' + char(10);
				SET @v_dSql += '  WHERE A.LOOKUP_TYPE_CODE = ''LINE_TYPE'' 							  ' + char(10);
				SET @v_dSql += '  AND  A.ACTIVE_FLAG     = ''Y'' 						              ' + char(10);
				SET @v_dSql += '  ORDER BY A.SORT_ORDER ASC											  ' + char(10);

				--print @v_dSql;
				--INSERT INTO TH_UIS_SQL VALUES ('@@@v_dSql',@Code,@v_dSql , @USER_ID, getdate() ) ;

				--exec sp_executesql @v_dSql;
			END	
		/****************************************************************************************************************************************/
		/*   Electrode Type 정보갖고오기                                                                                                        */
		/*   Param :  @PARAM1 = USER_ID,@PARAM2 = DIVISION ,@PARAM3= SITE,@PARAM4= PLANT,@PARAM5= FACTORY,@PARAM6= OPERATION,@PARAM7= LINE      */
		/****************************************************************************************************************************************/
		ELSE IF @Code ='ELECTRODE_TYPE'
		    BEGIN
			    SET @v_dSql = '';
				SET @v_dSql += '  SELECT A.SEGMENT1 As CODE, A.SEGMENT1 As NAME 					 ' + char(10);
				SET @v_dSql += '  FROM  SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)							 ' + char(10);
				SET @v_dSql += '  WHERE A.LOOKUP_TYPE_CODE = ''ELECTRODE_TYPE'' 					 ' + char(10);
				SET @v_dSql += '  AND  A.ACTIVE_FLAG = ''Y'' 					                     ' + char(10);
				SET @v_dSql += '  ORDER BY A.SORT_ORDER ASC											 ' + char(10);
				
				--print @v_dSql;
				--INSERT INTO TH_UIS_SQL VALUES ('@@@v_dSql',@Code,@v_dSql , @USER_ID, getdate() ) ;

				--exec sp_executesql @v_dSql;
			END	
		/****************************************************************************************************************************************/
		/*   Model Type 정보갖고오기                                                                                                        */
		/*   Param :  @PARAM1 = USER_ID,@PARAM2 = DIVISION ,@PARAM3= SITE,@PARAM4= PLANT,@PARAM5= FACTORY,@PARAM6= OPERATION,@PARAM7= LINE      */
		/****************************************************************************************************************************************/
		ELSE IF @Code ='LINE_MODEL_TYPE'
		    BEGIN
			    SET @v_dSql = '';
				SET @v_dSql += '  SELECT A.CODE As CODE, A.NAME As NAME                                                                                   ' + char(10);
				SET @v_dSql += '  FROM (                                                                                                                  ' + char(10);
				SET @v_dSql += '        SELECT A.SEGMENT5 As CODE                                                                                         ' + char(10);
				SET @v_dSql += '         ,( CASE WHEN ISNULL(A.ATTRIBUTE1, A.SEGMENT5) = ''Automotive'' THEN ISNULL(A.ATTRIBUTE1, A.SEGMENT5)             ' + char(10);
				SET @v_dSql += '               WHEN ISNULL(A.ATTRIBUTE1, A.SEGMENT5) = ''Electrode'' THEN ISNULL(A.ATTRIBUTE1, A.SEGMENT5)                ' + char(10);
				SET @v_dSql += '          	   WHEN ISNULL(A.ATTRIBUTE1, A.SEGMENT5) = ''Cylindrical'' THEN ISNULL(A.ATTRIBUTE1, A.SEGMENT5)              ' + char(10);
				SET @v_dSql += '          	   WHEN ISNULL(A.ATTRIBUTE1, A.SEGMENT5) = ''Pouch'' THEN ISNULL(A.ATTRIBUTE1, A.SEGMENT5)                    ' + char(10);
				SET @v_dSql += '          	   WHEN ISNULL(A.ATTRIBUTE1, A.SEGMENT5) = ''Prismatic'' THEN ISNULL(A.ATTRIBUTE1, A.SEGMENT5)                ' + char(10);
				SET @v_dSql += '          	   WHEN ISNULL(A.ATTRIBUTE1, A.SEGMENT5) = ''Subminiature Cylindrical'' THEN ISNULL(A.ATTRIBUTE1, A.SEGMENT5) ' + char(10);
				SET @v_dSql += '            ELSE A.SEGMENT5 + ''('' + ISNULL(A.ATTRIBUTE1, A.SEGMENT5)+ '')'' END ) As NAME                               ' + char(10);
				SET @v_dSql += '        FROM  SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)							                                              ' + char(10);
				SET @v_dSql += '        WHERE LOOKUP_TYPE_CODE = ''LINE_MODEL_TYPE'' 						                                              ' + char(10);
				SET @v_dSql += '        AND  A.ACTIVE_FLAG     = ''Y'' 						                                                              ' + char(10);
				SET @v_dSql += '  ) A						                                                                                              ' + char(10);
                SET @v_dSql += '  GROUP BY A.CODE, A.NAME									                                                              ' + char(10);

				--print @v_dSql;
				--INSERT INTO TH_UIS_SQL VALUES ('@@@v_dSql',@Code,@v_dSql , @USER_ID, getdate() ) ;

				--exec sp_executesql @v_dSql;
			END	
		/****************************************************************************************************************************************/
		/*   LINE_ATTRIBUTE 정보갖고오기                                                                                                        */
		/*   Param :  @PARAM1 = USER_ID,@PARAM2 = DIVISION ,@PARAM3= SITE,@PARAM4= PLANT,@PARAM5= FACTORY,@PARAM6= OPERATION,@PARAM7= LINE      */
		/****************************************************************************************************************************************/
		ELSE IF @Code ='LINE_ATTRIBUTE'
		    BEGIN
			    SET @v_dSql = '';
				SET @v_dSql += '  SELECT A.SEGMENT5 As CODE, A.SEGMENT5 As NAME 					   ' + char(10);
				SET @v_dSql += '  FROM  SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)							   ' + char(10);
				SET @v_dSql += '  WHERE LOOKUP_TYPE_CODE = ''LINE_ATTRIBUTE'' 						   ' + char(10);
				SET @v_dSql += '  AND  A.ACTIVE_FLAG     = ''Y'' 						               ' + char(10);
				SET @v_dSql += '  GROUP BY A.SEGMENT5, A.SEGMENT5									   ' + char(10);

				--print @v_dSql;
				--INSERT INTO TH_UIS_SQL VALUES ('@@@v_dSql',@Code,@v_dSql , @USER_ID, getdate() ) ;

				--exec sp_executesql @v_dSql;
			END	
		/****************************************************************************************************************************************/
		/*   LINE_LOCATION 정보갖고오기                                                                                                        */
		/*   Param :  @PARAM1 = USER_ID,@PARAM2 = DIVISION ,@PARAM3= SITE,@PARAM4= PLANT,@PARAM5= FACTORY,@PARAM6= OPERATION,@PARAM7= LINE      */
		/****************************************************************************************************************************************/
		ELSE IF @Code ='LINE_LOCATION'
		    BEGIN
			    SET @v_dSql = '';
				SET @v_dSql += '  SELECT A.SEGMENT5 As CODE, A.SEGMENT5 As NAME                        ' + char(10);
				SET @v_dSql += '  FROM  SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)	                           ' + char(10);
				SET @v_dSql += '  WHERE LOOKUP_TYPE_CODE = ''LINE_LOCATION'' 	                       ' + char(10);
				SET @v_dSql += '  AND  A.ACTIVE_FLAG     = ''Y'' 						               ' + char(10);
				SET @v_dSql += '  GROUP BY A.SEGMENT5, A.SEGMENT5			                           ' + char(10);

				--print @v_dSql;
				--INSERT INTO TH_UIS_SQL VALUES ('@@@v_dSql',@Code,@v_dSql , @USER_ID, getdate() ) ;

				--exec sp_executesql @v_dSql;

			END	
		/****************************************************************************************************************************************/
		/*   ROUTE_TYPE 정보갖고오기																											*/
		/*   Param :																															*/
		/****************************************************************************************************************************************/
		ELSE IF @Code ='ROUTE_TYPE'
		    BEGIN
				
				/* Alias setting */
				
				SET @v_dSql = '';
				SET @v_dSql += '	SELECT DISTINCT A.ROUTE_TYPE AS CODE, A.ROUTE_TYPE AS NAME					' + char(10);
				SET @v_dSql += '	FROM   SCM_AGING_ITEM_FLOW_M A WITH(NOLOCK)									' + char(10);
				SET @v_dSql += '	WHERE  EXISTS (																' + char(10);
				SET @v_dSql += '		SELECT 1																' + char(10);
				SET @v_dSql += '		FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)								' + char(10);
				SET @v_dSql += '		WHERE  A.COMPANY_ID  = B.COMPANY_ID										' + char(10);
				SET @v_dSql += '		AND    A.DIVISION_ID = B.DIVISION_ID									' + char(10);
				SET @v_dSql += '		AND    A.SITE_ID     = B.SITE_ID										' + char(10);
				SET @v_dSql += '		AND    A.PLANT_ID    = B.PLANT_ID										' + char(10);
				SET @v_dSql += '		AND    A.FACTORY_ID  = B.FACTORY_ID										' + char(10);
				SET @v_dSql += '		AND    B.USER_ID     = '''+ @USER_ID +'''								' + char(10);
				SET @v_dSql += '	)																			' + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @V_DIVISION_ID)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @V_DIVISION_LT)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @V_SITE_ID)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @V_SITE_LT)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @V_PLANT_ID)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @V_PLANT_LT)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @V_FACTORY_ID)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @V_FACTORY_LT)) + char(10);
				SET @v_dSql += '	ORDER BY CODE																' + char(10);


				--print @v_dSql;
				--INSERT INTO TH_UIS_SQL VALUES ('@@@v_dSql',@Code,@v_dSql , @USER_ID, getdate() ) ;

				--exec sp_executesql @v_dSql;

			END	

		/****************************************************************************************************************************************/
		/*   ROUTE_TYPE 정보갖고오기																											*/
		/*   Param :																															*/
		/****************************************************************************************************************************************/
		ELSE IF @Code ='ROUTE'
		    BEGIN
				
				/* Alias setting */
				
				SET @v_dSql = '';
				SET @v_dSql += '	SELECT DISTINCT A.ROUTE_ID AS CODE, A.ROUTE_ID AS NAME						' + char(10);
				SET @v_dSql += '	FROM   SCM_AGING_ITEM_FLOW_M A WITH(NOLOCK)									' + char(10);
				SET @v_dSql += '	WHERE  EXISTS (																' + char(10);
				SET @v_dSql += '		SELECT 1																' + char(10);
				SET @v_dSql += '		FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)								' + char(10);
				SET @v_dSql += '		WHERE  A.COMPANY_ID  = B.COMPANY_ID										' + char(10);
				SET @v_dSql += '		AND    A.DIVISION_ID = B.DIVISION_ID									' + char(10);
				SET @v_dSql += '		AND    A.SITE_ID     = B.SITE_ID										' + char(10);
				SET @v_dSql += '		AND    A.PLANT_ID    = B.PLANT_ID										' + char(10);
				SET @v_dSql += '		AND    A.FACTORY_ID  = B.FACTORY_ID										' + char(10);
				SET @v_dSql += '		AND    B.USER_ID     = '''+ @USER_ID +'''								' + char(10);
				SET @v_dSql += '	)																			' + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @V_DIVISION_ID)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @V_DIVISION_LT)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @V_SITE_ID)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @V_SITE_LT)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @V_PLANT_ID)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @V_PLANT_LT)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @V_FACTORY_ID)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @V_FACTORY_LT)) + char(10);
				SET @v_dSql += '	ORDER BY CODE																' + char(10);


				--print @v_dSql;
				--INSERT INTO TH_UIS_SQL VALUES ('@@@v_dSql',@Code,@v_dSql , @USER_ID, getdate() ) ;

				--exec sp_executesql @v_dSql;

			END

		/****************************************************************************************************************************************/
		/*   TARGET 을 사용하는 INSTANCE 정보갖고오기																											*/
		/*   Param :	@Param21 = SEGMENT1																														*/
		/****************************************************************************************************************************************/
		ELSE IF @Code ='TARGET_INSTANCE'
		    BEGIN
				
				/* Alias setting */
				
				SET @v_dSql = '';
				SET @v_dSql += '	SELECT 	A.SEGMENT4 AS CODE, ISNULL(B.INST_NAME,A.SEGMENT4) AS NAME, MAX(A.SORT_ORDER) AS SORT_ORDER		' + char(10);
				SET @v_dSql += '	FROM   	SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)																' + char(10);
				SET @v_dSql += '			LEFT OUTER JOIN (																				' + char(10);
				SET @v_dSql += '							  SELECT SEGMENT1 AS INST, SEGMENT2 AS INST_NAME								' + char(10);
				SET @v_dSql += '							  FROM   SCM_SYS_LOOKUP_VALUE B WITH(NOLOCK)									' + char(10);
				SET @v_dSql += '							  WHERE  B.LOOKUP_TYPE_CODE = ''INSTANCE_ID''									' + char(10);
				SET @v_dSql += '							  AND    B.ACTIVE_FLAG      = ''Y''												' + char(10);
				SET @v_dSql += '							) B																				' + char(10);
				SET @v_dSql += '			ON     A.SEGMENT4         = B.INST																' + char(10);
				SET @v_dSql += '	WHERE  	A.LOOKUP_TYPE_CODE = ''TARGET_INSTANCE''														' + char(10);
				SET @v_dSql += '	AND    	A.SEGMENT1         = '''+ @Param21 +'''															' + char(10);
				SET @v_dSql += '	AND    	ACTIVE_FLAG        = ''Y''																		' + char(10);
				SET @v_dSql += '	AND 	A.SEGMENT4 IN (																					' + char(10);
				SET @v_dSql += '								SELECT 	DISTINCT B.INSTANCE_ID												' + char(10);
				SET @v_dSql += '								FROM   	SCM_FACTORY_M A(NOLOCK) 											' + char(10);
				SET @v_dSql += '										INNER JOIN FP_INSTANCE_FACTORY_M B(NOLOCK)							' + char(10);
				SET @v_dSql += '										ON     A.FACTORY_ID=B.FACTORY_ID									' + char(10);
				SET @v_dSql += '										AND    B.ACTIVE_FLAG        = ''Y''									' + char(10);
				SET @v_dSql += '								WHERE 1=1																	' + char(10);
				SET @v_dSql += '								AND    A.ACTIVE_FLAG        = ''Y''											' + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @V_DIVISION_ID)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @V_SITE_ID)) + char(10);
				SET @v_dSql += '						  )																					' + char(10);
				SET @v_dSql += '	AND		EXISTS (																						' + char(10);
				SET @v_dSql += '						SELECT 1																			' + char(10);
				SET @v_dSql += '						FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)											' + char(10);
				SET @v_dSql += '						WHERE  A.SEGMENT4 = B.INSTANCE_ID													' + char(10);
				SET @v_dSql += '						AND    B.USER_ID  = '''+ @USER_ID +'''												' + char(10);
				SET @v_dSql += '				   )																						' + char(10);
				SET @v_dSql += '	GROUP BY A.SEGMENT4, B.INST_NAME																		' + char(10);
				SET @v_dSql += '	ORDER BY CODE, SORT_ORDER																				' + char(10);

				--INSERT INTO TH_UIS_SQL VALUES ('@@@v_dSql',@Code,@v_dSql , @USER_ID, getdate() ) ;

				--exec sp_executesql @v_dSql;

			END	

		/****************************************************************************************************************************************/
		/*   DEMAND_MARKET_TYPE 정보갖고오기																											*/
		/* Param :																														*/
		/****************************************************************************************************************************************/
		ELSE IF @Code ='DEMAND_MARKET_TYPE'
		    BEGIN
				
				/* Alias setting */
				
				SET @v_dSql = '';
				SET @v_dSql += '	SELECT A.SEGMENT1 As CODE, A.SEGMENT1 As NAME  	   ' + char(10);
				SET @v_dSql += '	FROM  SCM_SYS_LOOKUP_VALUE A(NOLOCK)  		       ' + char(10);
				SET @v_dSql += '	WHERE A.LOOKUP_TYPE_CODE = ''DEMAND_MARKET_TYPE''  ' + char(10);
				SET @v_dSql += '	ORDER BY A.SORT_ORDER							   ' + char(10);

				--INSERT INTO TH_UIS_SQL VALUES ('@@@v_dSql',@Code,@v_dSql , @USER_ID, getdate() ) ;

				--exec sp_executesql @v_dSql;

			END				
		/****************************************************************************************************************************************/
		/*   DIVISION_DEMAND_TYPE 정보갖고오기																											*/
		/*   Param :																														*/
		/****************************************************************************************************************************************/
		ELSE IF @Code ='DIVISION_DEMAND_TYPE'
		    BEGIN
				
				/* Alias setting */
				
				SET @v_dSql = '';
				SET @v_dSql += '	SELECT A.SEGMENT2 As CODE, A.SEGMENT3 As NAME, A.SEGMENT1 As DIVISION_ID  ' + char(10);
				SET @v_dSql += '	FROM  SCM_SYS_LOOKUP_VALUE A(NOLOCK)                            ' + char(10);
				SET @v_dSql += '	WHERE A.LOOKUP_TYPE_CODE =  ''DIVISION_DEMAND_TYPE''		    ' + char(10);
				SET @v_dSql += '	AND A.ACTIVE_FLAG        =  ''Y''		                        ' + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SEGMENT1' , 'EQ', @V_DIVISION_ID)) + char(10);
                SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SEGMENT1' , 'EQ', @V_DIVISION_LT)) + char(10);
				SET @v_dSql += '	ORDER BY A.SORT_ORDER										' + char(10);

				--INSERT INTO TH_UIS_SQL VALUES ('@@@v_dSql',@Code,@v_dSql , @USER_ID, getdate() ) ;

				--exec sp_executesql @v_dSql;

			END			
		/****************************************************************************************************************************************/
		/*   DIVISION 별 PRODUCTION TYPE 정보갖고오기																											*/
		/*   Param :	@Param21 = SEGMENT1																														*/
		/****************************************************************************************************************************************/
		ELSE IF @Code ='LOOKUP_CODE_TARGET'
		    BEGIN
				
				/* Alias setting */
				
				SET @v_dSql = '';
				SET @v_dSql += '	SELECT ATTRIBUTE1 AS CODE, ATTRIBUTE2 AS NAME, SEGMENT1 As DIVISION_ID ' + char(10);
				SET @v_dSql += '	FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)				' + char(10);
				SET @v_dSql += '	WHERE  LOOKUP_TYPE_CODE = ''DIVISION_DEMAND_TYPE''		' + char(10);
				SET @v_dSql += '	AND    ACTIVE_FLAG = ''Y''								' + char(10);
				SET @v_dSql += '	AND    ATTRIBUTE3 = ''Y''								' + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('SEGMENT1' , 'EQ', @V_DIVISION_ID)) + char(10);
				SET @v_dSql += '	ORDER BY SORT_ORDER										' + char(10);

				--INSERT INTO TH_UIS_SQL VALUES ('@@@v_dSql',@Code,@v_dSql , @USER_ID, getdate() ) ;

				--exec sp_executesql @v_dSql;

			END	
			
		/****************************************************************************************************************************************/
		/*   TYPE 별 Target정보 갖고오기																										*/
		/*   Param :	@Param21 = SCP_PLAN_TYPE																								*/
		/****************************************************************************************************************************************/
		ELSE IF @Code ='SCP_PLAN'
		    BEGIN
				
				/* Alias setting */
				
				-- Query 속도 때문에 수정 20210122 by cys
				--SET @v_dSql = '';
				--SET @v_dSql += '	SELECT	DISTINCT TOP 10 CODE, NAME, SCP_PLAN_ID, SCP_PLAN_TYPE											' + char(10);
				--SET @v_dSql += '	FROM	(																								' + char(10);
				--SET @v_dSql += '				SELECT	SCP_PLAN_ID AS CODE,SCP_PLAN_ID AS NAME, SCP_PLAN_ID, ''PRODUCT'' AS SCP_PLAN_TYPE	' + char(10);
				--SET @v_dSql += '				FROM	FP_WEEKLY_DEMAND_PRODUCT_H A WITH(NOLOCK)											' + char(10);
				--SET @v_dSql += '				WHERE	1=1																					' + char(10);
				--SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @V_DIVISION_ID)) + char(10);
				--SET @v_dSql += '				UNION ALL																					' + char(10);
				--SET @v_dSql += '				SELECT SCP_PLAN_ID AS CODE,SCP_PLAN_ID AS NAME, SCP_PLAN_ID, ''SHIPMENT'' AS SCP_PLAN_TYPE	' + char(10);
				--SET @v_dSql += '				FROM	FP_WEEKLY_DEMAND_SHIPMENT_H A WITH(NOLOCK)											' + char(10);
				--SET @v_dSql += '				WHERE	1=1																					' + char(10);
				--SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @V_DIVISION_ID)) + char(10);
				--SET @v_dSql += '			) AA																							' + char(10);
				--SET @v_dSql += '	WHERE	SCP_PLAN_TYPE = '''+ @Param21 +'''																' + char(10);
				--SET @v_dSql += '	ORDER BY CODE DESC																						' + char(10);


				SET @v_dSql = '';
				SET @v_dSql += '	SELECT	TOP 10 CODE, NAME, SCP_PLAN_ID, SCP_PLAN_TYPE											' + char(10);
				SET @v_dSql += '	FROM	(																								' + char(10);
				SET @v_dSql += '				SELECT	DISTINCT SCP_PLAN_ID AS CODE,SCP_PLAN_ID AS NAME, SCP_PLAN_ID, ''PRODUCT'' AS SCP_PLAN_TYPE	' + char(10);
				SET @v_dSql += '				FROM	FP_WEEKLY_DEMAND_PRODUCT_H A WITH(NOLOCK)											' + char(10);
				SET @v_dSql += '				WHERE	1=1																					' + char(10);
				SET	@v_dSql += '				AND   EXISTS (																				'+ char(10);
				SET	@v_dSql += '								SELECT 1 FROM (																'+ char(10);
				SET	@v_dSql += '									SELECT DISTINCT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.SHOP_GROUP_ID		'+ char(10);
				SET	@v_dSql += '									FROM SCM_FACTORY_M A WITH(NOLOCK) INNER JOIN FP_INSTANCE_FACTORY_M B WITH(NOLOCK)	'+ char(10);
				SET	@v_dSql += '									ON  A.FACTORY_ID=B.FACTORY_ID														'+ char(10);
				SET	@v_dSql += '									AND B.ACTIVE_FLAG = ''Y''												'+ char(10);
				SET	@v_dSql += '									WHERE	1=1																'+ char(10);
				SET	@v_dSql += '									AND		A.ACTIVE_FLAG = ''Y''											'+ char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.INSTANCE_ID' , 'EQ', @V_INSTANCE_ID)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.INSTANCE_ID' , 'EQ', @V_INSTANCE_LT)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @V_DIVISION_ID)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @V_DIVISION_LT)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @V_SITE_ID)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @V_SITE_LT)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @V_PLANT_ID)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @V_PLANT_LT)) + char(10);
				SET @v_dSql += '									) C															'+ char(10);
				SET @v_dSql += '								WHERE	C.COMPANY_ID = A.COMPANY_ID								'+ char(10);
				SET @v_dSql += '								AND		C.DIVISION_ID = A.DIVISION_ID							'+ char(10);
				SET @v_dSql += '								AND		C.SITE_ID = A.SITE_ID									'+ char(10);
				SET @v_dSql += '								AND		C.PLANT_ID = A.PLANT_ID									'+ char(10);
				SET @v_dSql += '								AND		C.SHOP_GROUP_ID = A.SHOP_GROUP_ID						'+ char(10);
				SET @v_dSql += '							)																	'+ char(10);
				SET @v_dSql += '				UNION ALL																					' + char(10);
				SET @v_dSql += '				SELECT DISTINCT SCP_PLAN_ID AS CODE,SCP_PLAN_ID AS NAME, SCP_PLAN_ID, ''SHIPMENT'' AS SCP_PLAN_TYPE	' + char(10);
				SET @v_dSql += '				FROM	FP_WEEKLY_DEMAND_SHIPMENT_H A WITH(NOLOCK)											' + char(10);
				SET @v_dSql += '				WHERE	1=1																					' + char(10);
				SET	@v_dSql += '				AND   EXISTS (																				'+ char(10);
				SET	@v_dSql += '								SELECT 1 FROM (																'+ char(10);
				SET	@v_dSql += '									SELECT DISTINCT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.SHOP_GROUP_ID		'+ char(10);
				SET	@v_dSql += '									FROM SCM_FACTORY_M A WITH(NOLOCK) INNER JOIN FP_INSTANCE_FACTORY_M B WITH(NOLOCK)	'+ char(10);
				SET	@v_dSql += '									ON  A.FACTORY_ID=B.FACTORY_ID														'+ char(10);
				SET	@v_dSql += '									AND B.ACTIVE_FLAG = ''Y''												'+ char(10);
				SET	@v_dSql += '									WHERE	1=1																'+ char(10);
				SET	@v_dSql += '									AND		A.ACTIVE_FLAG = ''Y''											'+ char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.INSTANCE_ID' , 'EQ', @V_INSTANCE_ID)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.INSTANCE_ID' , 'EQ', @V_INSTANCE_LT)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @V_DIVISION_ID)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @V_DIVISION_LT)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @V_SITE_ID)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @V_SITE_LT)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @V_PLANT_ID)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @V_PLANT_LT)) + char(10);
				SET @v_dSql += '									) C															'+ char(10);
				SET @v_dSql += '								WHERE	C.COMPANY_ID = A.COMPANY_ID								'+ char(10);
				SET @v_dSql += '								AND		C.DIVISION_ID = A.DIVISION_ID							'+ char(10);
				SET @v_dSql += '								AND		C.SITE_ID = A.SITE_ID									'+ char(10);
				SET @v_dSql += '								AND		C.PLANT_ID = A.PLANT_ID									'+ char(10);
				SET @v_dSql += '								AND		C.SHOP_GROUP_ID = A.SHOP_GROUP_ID						'+ char(10);
				SET @v_dSql += '							)																	'+ char(10);
				SET @v_dSql += '			) AA																							' + char(10);
				SET @v_dSql += '	WHERE	SCP_PLAN_TYPE = '''+ @Param21 +'''																' + char(10);
				SET @v_dSql += '	ORDER BY CODE DESC																						' + char(10);

				--SELECT @v_dSql
				--INSERT INTO TH_UIS_SQL VALUES ('@@@v_dSql',@Code,@v_dSql , @USER_ID, getdate() ) ;

				--exec sp_executesql @v_dSql;

			END

		/****************************************************************************************************************************************/
		/*   TYPE 별 Target정보 갖고오기																										*/
		/*   Param :	@Param21 = SCP_PLAN_TYPE																								*/
		/****************************************************************************************************************************************/
		ELSE IF @Code ='OPERATION_GROUP'
		    BEGIN
				
				/* Alias setting */
				
				--BEGIN
				--	SET @V_PLANT_LT	= REPLACE(@V_PLANT_LT, 'A.', 'C.');
				--	SET @V_FACTORY_LT	= REPLACE(@V_FACTORY_LT, 'A.', 'C.');
				--END

				SET @v_dSql = '';
				SET @v_dSql += '	SELECT A.OPERATION_GROUP_ID AS CODE                   																										' + char(10);
				SET @v_dSql += '	  , ''(''+A.OPERATION_GROUP_ID+'')''+ISNULL(A.OPERATION_GROUP_NAME, A.OPERATION_GROUP_ID) AS NAME                                                          ' + char(10);
				SET @v_dSql += '	FROM  SCM_OPERATION_M A WITH(NOLOCK)                                                                                                                            ' + char(10);
				SET @v_dSql += '	WHERE 	(                                                    ' + char(10);
				SET @v_dSql += '				(                                                                                                                                                   ' + char(10);
				SET @v_dSql += '					EXISTS (SELECT 1 FROM SCM_MMD_OPERATION_GROUP_M B(NOLOCK) WHERE B.OPERATION_GROUP_ID=A.OPERATION_GROUP_ID AND B.ROUTE_TYPE=''P'')               ' + char(10);
				SET @v_dSql += '					AND MES_ERP_INTERFACE_FLAG=''Y''                                                                                                                ' + char(10);
				SET @v_dSql += '				)                                                                                                                                                   ' + char(10);
				SET @v_dSql += '				OR                                                                                                                                                  ' + char(10);
				SET @v_dSql += '				(                                                                                                                                                   ' + char(10);
				SET @v_dSql += '					not exists (select 1 from SCM_MMD_OPERATION_GROUP_M B(NOLOCK) WHERE B.OPERATION_GROUP_ID=A.OPERATION_GROUP_ID AND B.ROUTE_TYPE=''P'')           ' + char(10);
				SET @v_dSql += '				)                                                                                                                                                   ' + char(10);
				SET @v_dSql += '			)                                                                                                                                                       ' + char(10);
				SET @v_dSql += '	and exists (                                                                                                                                                    ' + char(10);
				SET @v_dSql += '					select 1 from SCM_EQUIPMENT_M C(NOLOCK)                                                                                                         ' + char(10);
				SET @v_dSql += '		            WHERE C.company_id=A.company_id                                                                                                                 ' + char(10);
				SET @v_dSql += '		            AND   C.division_id=A.division_id                                                                                                               ' + char(10);
				SET @v_dSql += '		            AND   C.SITE_ID=A.SITE_ID                                                                                                                       ' + char(10);
				SET @v_dSql += '		            AND   C.OPERATION_ID=A.OPERATION_ID                                                                                                             ' + char(10);
				--SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.PLANT_ID' , 'EQ', @V_PLANT_LT)) + char(10);
				--SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.FACTORY_ID' , 'EQ', @V_FACTORY_LT)) + char(10);
				SET @v_dSql += '			   )                                                                                                                                                    ' + char(10);
				SET @v_dSql += '	AND  EXISTS (                                                                                                                                                   ' + char(10);
				SET @v_dSql += '					SELECT 1                                                                                                                                        ' + char(10);
				SET @v_dSql += '					FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)                                                                                                       ' + char(10);
				SET @v_dSql += '					WHERE  A.COMPANY_ID   = B.COMPANY_ID                                     ' + char(10);
				SET @v_dSql += '					AND    A.DIVISION_ID  = B.DIVISION_ID                                                                                                           ' + char(10);
				SET @v_dSql += '					AND    A.SITE_ID      = B.SITE_ID                                                                                                               ' + char(10);
				SET @v_dSql += '					AND    A.OPERATION_ID = B.OPERATION_ID                                                                                                          ' + char(10);
				SET @v_dSql += '					AND    B.USER_ID      = '''+ @USER_ID +'''                                                                                                      ' + char(10);
				
				--IF @SAVE_AUTH = 'Y'
				--	BEGIN
				--		SET	@v_dSql += '								AND    B.SAVE_FLAG = ''Y''			    ';
				--	END
				
				SET @v_dSql += '				)                                                                                                                                                   ' + char(10);
				SET @v_dSql += '	AND   A.ACTIVE_FLAG = ''Y''                                                                                                                                     ' + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @V_DIVISION_ID)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @V_DIVISION_LT)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @V_SITE_ID)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @V_SITE_LT)) + char(10);
				SET @v_dSql += '	GROUP BY A.OPERATION_GROUP_ID, A.OPERATION_GROUP_NAME                                                                                                           ' + char(10);
				SET @v_dSql += '	ORDER BY A.OPERATION_GROUP_ID                                                                                                                                   ' + char(10);
				
				--INSERT INTO TH_UIS_SQL VALUES ('@@@v_dSql',@Code,@v_dSql , @USER_ID, getdate() ) ;

				--exec sp_executesql @v_dSql;

			END

		/****************************************************************************************************************************************/
		/*   TYPE 별 Target정보 갖고오기																										*/
		/*   Param :	@Param21 = IS_POST_VISIBLE																								*/
		/****************************************************************************************************************************************/
		ELSE IF @Code ='INSTANCE'
		    BEGIN
				
				/* Alias setting */
				
				
				SET @v_dSql = '';
				SET @v_dSql += '	SELECT A.INSTANCE_ID AS CODE, B.SEGMENT2 AS NAME, B.SORT_ORDER				' + char(10);
				SET @v_dSql += '	FROM (																		' + char(10);
				SET @v_dSql += '	SELECT DISTINCT INSTANCE_ID													' + char(10);
				SET @v_dSql += '	FROM   FP_USER_ROLE_INFO_V A WITH(NOLOCK)									' + char(10);
				SET @v_dSql += '	WHERE  USER_ID = '''+ @USER_ID +'''											' + char(10);
				
				--IF @SAVE_AUTH = 'Y'
				--	BEGIN
				--		SET	@v_dSql += '								AND    A.SAVE_FLAG = ''Y''			    ' + char(10);
				--	END

				SET @v_dSql += '	) A, SCM_SYS_LOOKUP_VALUE B(NOLOCK)											' + char(10);
				SET @v_dSql += '	WHERE A.INSTANCE_ID = B.SEGMENT1											' + char(10);
				SET @v_dSql += '	AND   B.LOOKUP_TYPE_CODE = ''INSTANCE_ID''									' + char(10);
				SET @v_dSql += '	AND   B.ACTIVE_FLAG = ''Y''													' + char(10);
				
				IF @Param21 = 'Y'
					BEGIN
						SET	@v_dSql += '								AND   A.INSTANCE_ID NOT LIKE ''%POST%''			    ' + char(10);
					END
				
				SET @v_dSql += '	ORDER BY B.SORT_ORDER														' + char(10);


			END

		/****************************************************************************************************************************************/
		/*   TYPE 별 Target정보 갖고오기																										*/
		/*   Param :	@Param21 = IS_POST_VISIBLE																								*/
		/****************************************************************************************************************************************/
		ELSE IF @Code ='CURRENT_DATE'
		    BEGIN
				
				/* Alias setting */
				
				
				SET @v_dSql = '';
				SET @v_dSql += '	SELECT CONVERT(VARCHAR,GETDATE(), 112) AS CUR_DATE							' + char(10);
				
			END

		/****************************************************************************************************************************************/
		/*   DIVISION 별 PRODUCTION TYPE 정보갖고오기																							*/
		/*   Param :	@Param21 = IS_NON_EXIST_TEST																							*/
		/****************************************************************************************************************************************/
		ELSE IF @Code ='PRODUCTION_TYPE'
		    BEGIN
				
				/* Alias setting */
				
				SET @v_dSql = '';
				SET @v_dSql += '	SELECT ATTRIBUTE1 AS CODE, ATTRIBUTE2 AS NAME, SEGMENT1 AS DIVISION_ID	' + char(10);
				SET @v_dSql += '	FROM   SCM_SYS_LOOKUP_VALUE A (NOLOCK)									' + char(10);
				SET @v_dSql += '	WHERE  LOOKUP_TYPE_CODE = ''DIVISION_DEMAND_TYPE''		' + char(10);
				SET @v_dSql += '	AND    ACTIVE_FLAG = ''Y''								' + char(10);
				SET @v_dSql += '	AND    ATTRIBUTE3 = ''Y''								' + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('SEGMENT1' , 'EQ', @V_DIVISION_ID)) + char(10);
				IF @Param21 = 'Y'
					BEGIN
						SET	@v_dSql += '	AND	   SEGMENT2 <> ''TEST''					' + char(10);
					END
				SET @v_dSql += '	ORDER BY SORT_ORDER										' + char(10);

			END	
		
		/****************************************************************************************************************************************/
		/*   AMEND INSTANCE 정보갖고오기																										*/
		/*   Param :	@Param21 = AMEND_INSTANCE																								*/
		/****************************************************************************************************************************************/
		ELSE IF @Code ='AMEND_INSTANCE'
		    BEGIN
				
				/* Alias setting */
				
				SET @v_dSql = '';
				SET @v_dSql += '	SELECT A.INSTANCE_ID AS CODE, B.SEGMENT2 AS NAME, B.SORT_ORDER									' + char(10);
				SET @v_dSql += '		, B.ATTRIBUTE3 AS USE_WOW_STATUS                                                            ' + char(10);
				SET @v_dSql += '		, B.ATTRIBUTE1 AS CONFIRM_AREA                                                              ' + char(10);
				SET @v_dSql += '		, B.ATTRIBUTE2 AS IS_SAME_PLAN_ID                                                           ' + char(10);
				SET @v_dSql += '		, C.SITE_ID, A.SHOP_GROUP_ID                                                                ' + char(10);
				SET @v_dSql += '		, ISNULL(D.VERSION_YN, ''N'') AS VERSION_YN ' + char(10)
				SET @v_dSql += '	FROM 	(                                                                                       ' + char(10);
				SET @v_dSql += '	SELECT DISTINCT B.INSTANCE_ID, C.SHOP_GROUP_ID                                                  ' + char(10);
				SET @v_dSql += '	FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK), FP_INSTANCE_FACTORY_M C WITH(NOLOCK)                 ' + char(10);
				SET @v_dSql += '	WHERE  B.INSTANCE_ID = C.INSTANCE_ID                                                            ' + char(10);
				SET @v_dSql += '	AND    B.USER_ID     = '''+ @USER_ID +'''                                                       ' + char(10);
				SET @v_dSql += '				) A                                                                                 ' + char(10);
				-- 전극 버전 사용유무 추가.... 20230130
				SET @v_dSql += '	LEFT OUTER JOIN ( ' + char(10)
				SET @v_dSql += '		SELECT SEGMENT1 AS INSTANCE_ID, ATTRIBUTE1 AS VERSION_YN ' + char(10)
				SET @v_dSql += '		FROM   SCM_SYS_LOOKUP_VALUE B WITH(NOLOCK) ' + char(10)
				SET @v_dSql += '		WHERE  1=1 ' + char(10)
				SET @v_dSql += '		AND    LOOKUP_TYPE_CODE = ''ELEC_INSTANCE_OPTION'' ' + char(10)
				SET @v_dSql += '		AND    ACTIVE_FLAG = ''Y'' ' + char(10)
				SET @v_dSql += '	) D ' + char(10)
				SET @v_dSql += '	ON 1=1 ' + char(10)
				SET @v_dSql += '	AND A.INSTANCE_ID = D.INSTANCE_ID ' + char(10)
				SET @v_dSql += '			, SCM_SYS_LOOKUP_VALUE B WITH(NOLOCK)                                                   ' + char(10);
				SET @v_dSql += '			, (                                                                                     ' + char(10);
				SET @v_dSql += '					SELECT B.INSTANCE_ID, MAX(A.SITE_ID) AS SITE_ID                                 ' + char(10);
				SET @v_dSql += '					FROM   SCM_FACTORY_M A WITH(NOLOCK), FP_INSTANCE_FACTORY_M B WITH(NOLOCK)       ' + char(10);
				SET @v_dSql += '					WHERE  A.FACTORY_ID  = B.FACTORY_ID                                             ' + char(10);
				SET @v_dSql += '					AND    A.ACTIVE_FLAG = ''Y''                                                    ' + char(10);
				SET @v_dSql += '					AND    B.ACTIVE_FLAG = ''Y''                                                    ' + char(10);
				SET @v_dSql += '					GROUP BY B.INSTANCE_ID                                                          ' + char(10);
				SET @v_dSql += '				) C                                                                                 ' + char(10);
				SET @v_dSql += '	WHERE A.INSTANCE_ID      = B.SEGMENT1                                                           ' + char(10);
				SET @v_dSql += '	AND   A.INSTANCE_ID      = C.INSTANCE_ID                                                        ' + char(10);
				SET @v_dSql += '	AND   B.LOOKUP_TYPE_CODE = ''INSTANCE_ID''                                                      ' + char(10);
				SET @v_dSql += '	AND   B.SEGMENT1 IN (                                                                           ' + char(10);
				SET @v_dSql += '							SELECT INSTANCE_ID                                                      ' + char(10);
				SET @v_dSql += '							FROM   FP_AMEND_UI_V                                                    ' + char(10);
				SET @v_dSql += '							WHERE  1=1																' + char(10);	
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AMEND_UI_NAME' , 'EQ', @Param21)) + char(10);
				SET @v_dSql += '							AND    USE_FLAG = ''Y''                                                 ' + char(10);
				SET @v_dSql += '						)                                                                           ' + char(10);
				SET @v_dSql += '	ORDER BY A.SHOP_GROUP_ID, B.SORT_ORDER                                                          ' + char(10);

			END

		/****************************************************************************************************************************************/
		/*   ITEM_CLASS 정보갖고오기																										*/
		/*   Param :	@Param21 = SHOP_GROUP_ID																								*/
		/****************************************************************************************************************************************/
		ELSE IF @Code ='ITEM_CLASS'
		    BEGIN
				
				/* Alias setting */
				
				SET @v_dSql = '';
				SET @v_dSql += '	SELECT A.CLASS_ID AS CODE, A.CLASS_NAME AS CODE								' + char(10);
				SET @v_dSql += '	FROM   SCM_ITEM_CLASS_M A WITH(NOLOCK)                                              ' + char(10);
				SET @v_dSql += '	WHERE  1=1                                                                          ' + char(10);
				
				IF @Param21 = 'E'
					BEGIN
						SET	@v_dSql += '	AND	   A.LEVEL_2_NAME LIKE ''PANCAKE''					' + char(10);
						SET	@v_dSql += '	AND    A.LEVEL_3_NAME != ''SRS PANCAKE''					' + char(10);
					END
				
				ELSE IF @Param21 = 'P'
					BEGIN
						SET	@v_dSql += '	AND    A.LEVEL_1_NAME = ''Model''					' + char(10);
						SET	@v_dSql += '	AND    A.LEVEL_3_NAME IN (''Pack'',''Module'',''House'')	' + char(10);
					END

				ELSE IF @Param21 = 'A'
					BEGIN
						SET	@v_dSql += '	AND    A.LEVEL_1_NAME = ''Model''					' + char(10);
						SET	@v_dSql += '	AND    A.LEVEL_3_NAME LIKE ''%Cell%''					' + char(10);
					END

				ELSE
					BEGIN
						SET	@v_dSql += '	AND 	 A.LEVEL_2_NAME LIKE ''PANCAKE''					' + char(10);
						SET	@v_dSql += '	AND 	 A.LEVEL_3_NAME != ''SRS PANCAKE''					' + char(10);
					END

			END

		/****************************************************************************************************************************************/
		/*   PLAN_ID 정보갖고오기																										*/
		/*   Param : @Param21 = PLAN_TYPE | @Param22 = PLAN_DATE																									*/
		/****************************************************************************************************************************************/
		ELSE IF @Code ='FP_PLAN_INFO'
		    BEGIN
				
				SET @v_dSql = '';
				SET @v_dSql += '	SELECT A.PLAN_ID AS CODE, PLAN_ID AS NAME			     												' + char(10);						
				SET @v_dSql += '	    ,A.PLAN_ID                                                                                          ' + char(10);
				SET @v_dSql += '	    ,A.PLAN_TYPE                                                                                        ' + char(10);
				SET @v_dSql += '	    ,A.PLAN_START_TIME                                                                                  ' + char(10);
				SET @v_dSql += '	    ,A.PLAN_HORIZON                                                                                     ' + char(10);
				SET @v_dSql += '	    ,A.PLAN_HORIZON_UOM                                                                                 ' + char(10);
				SET @v_dSql += '	    ,A.DEMAND_HORIZON                                                                                   ' + char(10);
				SET @v_dSql += '	    ,A.DEMAND_HORIZON_UOM                                                                               ' + char(10);
				SET @v_dSql += '	    ,A.CONFIG_SET_ID                                                                                    ' + char(10);
				SET @v_dSql += '	    ,A.BASIS_PLAN_ID                                                                                    ' + char(10);
				SET @v_dSql += '	    ,A.DEMAND_PLAN_ID                                                                                   ' + char(10);
				SET @v_dSql += '	    ,A.SCP_PLAN_ID                                                                                      ' + char(10);
				SET @v_dSql += '	    ,A.PLAN_WEEK                                                                                        ' + char(10);
				SET @v_dSql += '	    ,CONVERT(VARCHAR(8), A.PLAN_START_TIME, 112) AS PLAN_START_DATE                                     ' + char(10);
				SET @v_dSql += '	    ,CONVERT(VARCHAR(8), DATEADD(DAY, A.PLAN_HORIZON-1, A.PLAN_START_TIME), 112) AS PLAN_END_DATE       ' + char(10);
				SET @v_dSql += '	    ,A.INSTANCE_ID                                                                                      ' + char(10);
				SET @v_dSql += '	FROM   SCM_FP_PLAN_H A(NOLOCK)                                                                          ' + char(10);
				SET @v_dSql += '	, (                                                                                                     ' + char(10);
				SET @v_dSql += '	  SELECT DISTINCT INSTANCE_ID                                                                           ' + char(10);
				SET @v_dSql += '	  FROM   FP_USER_ROLE_INFO_V A WITH(NOLOCK)                                                             ' + char(10);
				SET @v_dSql += '	  WHERE  A.USER_ID = '''+ @USER_ID +'''                                                                 ' + char(10);
				--IF @SAVE_AUTH = 'Y'
				--	BEGIN
				--		SET	@v_dSql += '								AND    A.SAVE_FLAG = ''Y''			    ' + char(10);
				--	END
				SET @v_dSql += '	) B                                                                                                     ' + char(10);
				SET @v_dSql += '	WHERE  A.INSTANCE_ID = B.INSTANCE_ID                                                                    ' + char(10);
				
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_ID' , 'EQ', @V_INSTANCE_ID)) + char(10);
					SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLAN_TYPE' , 'EQ', @Param21)) + char(10);
					SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('CONVERT(VARCHAR(8), PLAN_START_TIME, 112)' , 'EQ', @Param22)) + char(10);
					SET @v_dSql += '	AND A.PLAN_START_TIME > DATEADD(DAY, -30, GETDATE())       -- 건수가 많아 한달치만 가져옴 20210630 by cys   ' + char(10);
				


				SET @v_dSql += '	ORDER BY CONVERT(VARCHAR,A.PLAN_START_TIME,112) DESC, A.PLAN_ID DESC                                    ' + char(10);
				
				

			END
		
		/****************************************************************************************************************************************/
		/*   DIVISION 별 LOOKUP_CODE 정보갖고오기																											*/
		/*   Param :	@Param21 = LOOKUP_TYPE_CODE																														*/
		/****************************************************************************************************************************************/
		ELSE IF @Code ='LOOKUP_CODE'
		    BEGIN
				
				/* Alias setting */
				
				SET @v_dSql = '';
				SET @v_dSql += '	SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME				' + char(10);
				SET @v_dSql += '	FROM   SCM_SYS_LOOKUP_VALUE A (NOLOCK)					' + char(10);
				SET @v_dSql += '	WHERE  1=1												' + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LOOKUP_TYPE_CODE' , 'EQ', @Param21)) + char(10);
				SET @v_dSql += '	AND    ACTIVE_FLAG = ''Y''								' + char(10);
				SET @v_dSql += '	ORDER BY SORT_ORDER										' + char(10);

				
			END	
		
		/****************************************************************************************************************************************/
		/*   WEEK 정보 가져오기																													*/
		/*   Param :																															*/
		/****************************************************************************************************************************************/
		ELSE IF @Code ='FP_PLAN_WEEK'
		    BEGIN
				
				/* Alias setting */
				
				SET @v_dSql = '';
				SET @v_dSql += '	SELECT PLAN_WEEK AS CODE, SUBSTRING(PLAN_WEEK,1,4) + ''-'' + SUBSTRING(PLAN_WEEK,5,2) AS NAME		' + char(10);
				SET @v_dSql += '	FROM   SCM_FP_PLAN_H A (NOLOCK)						' + char(10);
				SET @v_dSql += '	WHERE  1=1											' + char(10);
				SET @v_dSql += '	GROUP BY PLAN_WEEK									' + char(10);
				SET @v_dSql += '	ORDER BY PLAN_WEEK DESC								' + char(10);

				
			END	
		
		/****************************************************************************************************************************************/
		/*   WEEK 정보 및 부가 정보 가져오기																									*/
		/*   Param : @Param21 = START_WEEK:END_WEEK , @Param22 = 현재일기준 - Y																		*/
		/****************************************************************************************************************************************/
		ELSE IF @Code ='WEEK_EXP'
		    BEGIN
				
				/* Alias setting */
				
				SET @v_dSql = '';
				SET @v_dSql += '	SELECT										' + char(10) 
				SET @v_dSql += '		D0 AS CODE, D0 AS NAME,                ' + char(10) ;
				SET @v_dSql += '		YR,                                     ' + char(10) ;
				SET @v_dSql += '		HFYR,                                   ' + char(10) ;
				SET @v_dSql += '		QTR,                                    ' + char(10) ;
				SET @v_dSql += '		MONTH,		                            ' + char(10) ;
				SET @v_dSql += '		CAL_YEAR_MON,                           ' + char(10) ;
				SET @v_dSql += '		D1,                                     ' + char(10) ;
				SET @v_dSql += '		D2,                                     ' + char(10) ;
				SET @v_dSql += '		D3,                                     ' + char(10) ;
				SET @v_dSql += '		D4,                                     ' + char(10) ;
				SET @v_dSql += '		D5,                                     ' + char(10) ;
				SET @v_dSql += '		D6,                                     ' + char(10) ;
				SET @v_dSql += '		D7,                                     ' + char(10) ;
				SET @v_dSql += '		DATED1,                                 ' + char(10) ;
				SET @v_dSql += '		DATED2,                                 ' + char(10) ;
				SET @v_dSql += '		DATED3,                                 ' + char(10) ;
				SET @v_dSql += '		DATED4,                                 ' + char(10) ;
				SET @v_dSql += '		DATED5,                                 ' + char(10) ;
				SET @v_dSql += '		DATED6,                                 ' + char(10) ;
				SET @v_dSql += '		DATED7,                                 ' + char(10) ;
				SET @v_dSql += '		PARTIAL_D1,                             ' + char(10) ;
				SET @v_dSql += '		PARTIAL_D2,                             ' + char(10) ;
				SET @v_dSql += '		PARTIAL_D3,                             ' + char(10) ;
				SET @v_dSql += '		PARTIAL_D4,                             ' + char(10) ;
				SET @v_dSql += '		PARTIAL_D5,                             ' + char(10) ;
				SET @v_dSql += '		PARTIAL_D6,                             ' + char(10) ;
				SET @v_dSql += '		PARTIAL_D7,                             ' + char(10) ;
				SET @v_dSql += '		PARTIAL_WEEK,                           ' + char(10) ;
				SET @v_dSql += '		PARTIAL_MONTH,                          ' + char(10) ;
				SET @v_dSql += '		PARTIAL_QTR,                            ' + char(10) ;
				SET @v_dSql += '		PARTIAL_HF_YR,                          ' + char(10) ;
				SET @v_dSql += '		PARTIAL_YR                              ' + char(10) ;
				SET @v_dSql += '	FROM TH_UIS_CALENDAR A				        ' + char(10) ;
				SET @v_dSql += '	WHERE 1=1							        ' + char(10) ;
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DO' , 'BW', @Param21)) + char(10);
				IF @Param22 = 'Y'
					BEGIN
						SET @v_dSql += '	AND D0 BETWEEN (CONVERT(VARCHAR, DATEPART(YEAR, DATEADD(DAY,-60, GETDATE())), 112) + RIGHT(''00'' + CONVERT(VARCHAR, DATEPART(ISO_WEEK, DATEADD(DAY,-60, GETDATE())), 23), 2))    ' + char(10) ;
						SET @v_dSql += '			   AND (CONVERT(VARCHAR, DATEPART(YEAR, GETDATE()), 112) + RIGHT(''00'' + CONVERT(VARCHAR, DATEPART(ISO_WEEK, GETDATE()), 23), 2))    ' + char(10) ;
					END
				SET @v_dSql += '	ORDER BY D0 DESC					        ' + char(10) ;

			END	

		/****************************************************************************************************************************************/
		/*   DIVISION 별 PRODUCTION TYPE 정보갖고오기																											*/
		/*   Param :	@Param21 = SUB_ROLE																														*/
		/****************************************************************************************************************************************/
		ELSE IF @Code ='USER_AUTH'
		    BEGIN
				

				/* Alias setting */
				
				SET @v_dSql = '';
				SET @v_dSql += '	SELECT SEGMENT2 , SEGMENT3 								' + char(10)
				SET @v_dSql += '	FROM   SCM_SYS_LOOKUP_VALUE A (NOLOCK)					' + char(10)
				SET @v_dSql += '	WHERE  1=1												' + char(10)
				SET @v_dSql += '	AND		LOOKUP_TYPE_CODE = ''EXPR_USER''				' + char(10)
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SEGMENT1' , 'EQ', @USER_ID)) + char(10)
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SEGMENT2' , 'EQ', @Param21)) + char(10)
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SEGMENT3' , 'EQ', @Param22)) + char(10)
				SET @v_dSql += '	AND    ACTIVE_FLAG = ''Y''								' + char(10)
				SET @v_dSql += '	ORDER BY SORT_ORDER										' + char(10)
				IF ISNULL(@USER_ID,'') = 'chkim.68' BEGIN
					SELECT @v_dSql as SRC_SQL 
					RETURN 1
				END

				
			END	
		/****************************************************************************************************************************************/
		/*   Amend 용 Building 정보갖고오기                                                                                                        */
		/*   Param :	@Param21 = PLAN_TYPE @Param22 = BUILDING @Param23 = MASTER_ID @Param24 = PLAN_ID																				*/
		/****************************************************************************************************************************************/
		ELSE IF @Code ='FACTORY_CODE_AMEND'
		    BEGIN
				
				

				SET	@v_dSql = ''
				SET @v_dSql += '	SELECT A.FACTORY_ID AS CODE, ''('' + A.FACTORY_ID + '')'' + ISNULL(A.FACTORY_NAME, A.FACTORY_ID) AS NAME									' + char(10)
				SET @v_dSql += '	FROM   SCM_FACTORY_M A WITH(NOLOCK)                                                                                                                 ' + char(10)
				SET @v_dSql += '	WHERE  1=1                                                                                                                                          ' + char(10)
				IF	@NON_AUTH = 'Y'
					BEGIN
						SET	@v_dSql += '  ' + char(10);
					END
				ELSE
					BEGIN
						SET	@v_dSql += '				AND  EXISTS (													' + char(10);
						SET	@v_dSql += '								SELECT 1                                        ' + char(10);
						SET	@v_dSql += '								FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)	    ' + char(10);
						SET	@v_dSql += '								WHERE  A.COMPANY_ID  = B.COMPANY_ID             ' + char(10);
						SET	@v_dSql += '								AND    A.DIVISION_ID     = B.DIVISION_ID		' + char(10);
						SET	@v_dSql += '								AND    A.SITE_ID     = B.SITE_ID				' + char(10);
						SET	@v_dSql += '								AND    A.PLANT_ID     = B.PLANT_ID				' + char(10);
						SET	@v_dSql += '								AND    A.FACTORY_ID     = B.FACTORY_ID			' + char(10);
						SET	@v_dSql += '								AND    B.USER_ID	 = '''+ @USER_ID +'''		' + char(10);
						--IF @SAVE_AUTH = 'Y'
						--	BEGIN
						--		SET	@v_dSql += '								AND    B.SAVE_FLAG = ''Y''			    ' + char(10);
						--	END
						SET	@v_dSql += '							  )			                                 ' + char(10);

					END	
				SET @v_dSql += '	AND A.ACTIVE_FLAG = ''Y''                                                                                                                           ' + char(10)
				SET @v_dSql += '	AND EXISTS (                                                                                                                                        ' + char(10)
				SET @v_dSql += '	  SELECT 1 FROM (                                                                                                                                   ' + char(10)
				SET @v_dSql += '	      SELECT DISTINCT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID                                                                  ' + char(10)
				SET @v_dSql += '	      FROM   SCM_FACTORY_M A WITH(NOLOCK)                                                                                                           ' + char(10)
				SET @v_dSql += '	      INNER JOIN FP_INSTANCE_FACTORY_M B WITH(NOLOCK)                                                                                               ' + char(10)
				SET @v_dSql += '	      ON    A.FACTORY_ID=B.FACTORY_ID                                                                                                               ' + char(10)
				SET @v_dSql += '	      AND		B.ACTIVE_FLAG = ''Y''                                                                                                               ' + char(10)
				SET @v_dSql += '	      WHERE 1=1                                                                                                                                     ' + char(10)
				SET @v_dSql += '	      AND		 A.ACTIVE_FLAG = ''Y''                                                                                                              ' + char(10)
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.INSTANCE_ID' , 'EQ', @V_INSTANCE_ID)) + char(10);
				SET @v_dSql += '	  ) C                                                                                                                                               ' + char(10)
				SET @v_dSql += '	  WHERE C.COMPANY_ID=A.COMPANY_ID AND C.DIVISION_ID=A.DIVISION_ID AND C.SITE_ID=A.SITE_ID AND C.PLANT_ID=A.PLANT_ID AND C.FACTORY_ID=A.FACTORY_ID   ' + char(10)
				SET @v_dSql += '	)                                                                                                                                                   ' + char(10)
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.COMPANY_ID' , 'EQ', @V_COMPANY_ID)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @V_DIVISION_ID)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @V_DIVISION_LT)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @V_SITE_ID)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @V_SITE_LT)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @V_PLANT_ID)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @V_PLANT_LT)) + char(10);
				IF	(@Param21 = 'RELEASE' AND @Param22 = 'BUILDING')	
					BEGIN
						SET	@v_dSql += '		AND A.FACTORY_ID IN (													' + char(10);
						SET	@v_dSql += '								SELECT KK.FACTORY_ID                                        ' + char(10);
						SET	@v_dSql += '								FROM   FP_RELEASE_PLAN_INFO_H KK WITH(NOLOCK)	    ' + char(10);
						SET	@v_dSql += '								WHERE  1=1             ' + char(10);
						--SET	@v_dSql += '								AND  KK.INSTANCE_ID = '''+ @Param23 +'''		' + char(10);
						SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('KK.INSTANCE_ID' , 'EQ', @V_INSTANCE_ID)) + char(10); -- instance 오류 수정
						SET	@v_dSql += '								AND    KK.RELEASE_PLAN_ID = '''+ @Param24 +'''				' + char(10);
						SET	@v_dSql += '							  )			                                 ' + char(10);

					END	
				SET @v_dSql += '	GROUP BY A.FACTORY_ID, A.FACTORY_NAME                                                                                                               ' + char(10)
				SET @v_dSql += '	ORDER BY A.FACTORY_ID                                                                                                                               ' + char(10)


				
			END
		/****************************************************************************************************************************************/
		/*   Building 정보갖고오기                                                                                                                 */
		/*   Param :																													*/
		/****************************************************************************************************************************************/
		ELSE IF @Code ='FACTORY_CODE'
		    BEGIN
				
				
				SET	@v_dSql = ''
				SET @v_dSql += '	SELECT A.FACTORY_ID AS CODE, ''('' + A.FACTORY_ID + '')'' + ISNULL(A.FACTORY_NAME, A.FACTORY_ID) AS NAME						' + char(10)				
				SET @v_dSql += '		  , CASE WHEN R.FACTORY_ID IS NOT NULL THEN 1 ELSE 0 END AS ROWCHK                                                          ' + char(10)
				SET @v_dSql += '	FROM   SCM_FACTORY_M A WITH(NOLOCK)                                                                                             ' + char(10)
				SET @v_dSql += '		LEFT OUTER JOIN (                                                                                                           ' + char(10)
				SET @v_dSql += '				SELECT	DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID                                   ' + char(10)
				SET @v_dSql += '				FROM	FP_USER_ROLE_INFO_V R WITH(NOLOCK)                                                                          ' + char(10)
				SET @v_dSql += '				WHERE	1=1                                                                                                         ' + char(10)
				SET @v_dSql += '				AND		R.USER_ID	= '''+ @USER_ID +'''                                                                            ' + char(10)
				--IF @SAVE_AUTH = 'Y'
				--	BEGIN
				--		SET	@v_dSql += '								AND    B.SAVE_FLAG = ''Y''			    ' + char(10);
				--	END
				SET @v_dSql += '		) R                                                                                                                         ' + char(10)
				SET @v_dSql += '		ON		1=1                                                                                                                 ' + char(10)
				SET @v_dSql += '		AND		A.COMPANY_ID		= R.COMPANY_ID                                                                                  ' + char(10)
				SET @v_dSql += '		AND		A.DIVISION_ID		= R.DIVISION_ID                                                                                 ' + char(10)
				SET @v_dSql += '		AND		A.SITE_ID			= R.SITE_ID                                                                                     ' + char(10)
				SET @v_dSql += '		AND		A.PLANT_ID			= R.PLANT_ID                                                                                    ' + char(10)
				SET @v_dSql += '		AND		A.FACTORY_ID		= R.FACTORY_ID                                                                                  ' + char(10)
				SET @v_dSql += '	WHERE  1=1                                                                                                                      ' + char(10)
				IF @NON_AUTH = 'Y'
					BEGIN 
						SET @v_dSql += ''
					END
				ELSE
					BEGIN
						SET @v_dSql += '	AND  EXISTS (                                                                                                                                            ' + char(10);
						SET @v_dSql += ' 	    			SELECT 1                                                                                                                                ' + char(10);
						SET @v_dSql += ' 	    			FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)                                                                                               ' + char(10);
						SET @v_dSql += ' 	    			WHERE  A.COMPANY_ID     = B.COMPANY_ID                                                                                                  ' + char(10);
						SET @v_dSql += ' 	    			AND    A.DIVISION_ID    = B.DIVISION_ID                                                                                                 ' + char(10);
						SET @v_dSql += ' 	    			AND    A.SITE_ID        = B.SITE_ID                                                                                                     ' + char(10);
						SET @v_dSql += ' 	    			AND    A.PLANT_ID       = B.PLANT_ID                                                                                                    ' + char(10);
						SET @v_dSql += ' 	    			AND    A.FACTORY_ID     = B.FACTORY_ID                                                                                                  ' + char(10);
						SET @v_dSql += ' 	    			AND    B.USER_ID        = '''+ @USER_ID +'''                                                                                            ' + char(10);
				
						--IF @SAVE_AUTH = 'Y'
						--	BEGIN
						--		SET	@v_dSql += '								AND    B.SAVE_FLAG = ''Y''			    ' + char(10);
						--	END
						SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.INSTANCE_ID' , 'EQ', @V_INSTANCE_ID)) + char(10);
					END
				
				SET @v_dSql += ' 			  )                                                           ' + char(10);
				SET @v_dSql += '	AND A.ACTIVE_FLAG = ''Y''                                                                                                       ' + char(10)
				SET @v_dSql += '	AND EXISTS (                                                                                                                    ' + char(10)
				SET @v_dSql += '	  SELECT 1 FROM (                                                                                                               ' + char(10)
				SET @v_dSql += '	      SELECT DISTINCT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID                                              ' + char(10)
				SET @v_dSql += '	      FROM   SCM_FACTORY_M A WITH(NOLOCK)                                                                                       ' + char(10)
				SET @v_dSql += '	      INNER JOIN FP_INSTANCE_FACTORY_M B WITH(NOLOCK)                                                                           ' + char(10)
				SET @v_dSql += '	      ON    A.FACTORY_ID=B.FACTORY_ID                                                                                           ' + char(10)
				SET @v_dSql += '	      AND		B.ACTIVE_FLAG = ''Y''                                                                                           ' + char(10)
				SET @v_dSql += '	      WHERE 1=1                                                                                                                 ' + char(10)
				SET @v_dSql += '	      AND		 A.ACTIVE_FLAG = ''Y''                                                                                          ' + char(10)
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.INSTANCE_ID' , 'EQ', @V_INSTANCE_ID)) + char(10);
				SET @v_dSql += '	  ) C                                                                                                                           ' + char(10)
				SET @v_dSql += '	  WHERE C.COMPANY_ID=A.COMPANY_ID AND C.DIVISION_ID=A.DIVISION_ID AND C.SITE_ID=A.SITE_ID										' + char(10)
				SET @v_dSql += '	  AND	C.PLANT_ID=A.PLANT_ID AND C.FACTORY_ID=A.FACTORY_ID																		' + char(10)
				SET @v_dSql += '	)                                                                                                                               ' + char(10)
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.COMPANY_ID' , 'EQ', @V_COMPANY_ID)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @V_DIVISION_ID)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @V_SITE_ID)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @V_PLANT_ID)) + char(10);
				SET @v_dSql += '	GROUP BY a.FACTORY_ID, a.FACTORY_NAME, CASE WHEN R.FACTORY_ID IS NOT NULL THEN 1 ELSE 0 END                                     ' + char(10)
				SET @v_dSql += '	ORDER BY A.FACTORY_ID                                                                                                           ' + char(10)

			END

		/****************************************************************************************************************************************/
		/*   Building 정보갖고오기                                                                                                                 */
		/*   Param :																													*/
		/****************************************************************************************************************************************/
		ELSE IF @Code ='NON_AUTH_FACTORY'
		    BEGIN
				
				
				SET	@v_dSql = ''
				SET @v_dSql += '	SELECT a.FACTORY_ID AS CODE, ''('' + a.FACTORY_ID + '')'' + ISNULL(a.FACTORY_NAME, a.FACTORY_ID) AS NAME	' + char(10)
				SET @v_dSql += '	FROM SCM_FACTORY_M A WITH(NOLOCK)                                                                                   ' + char(10)
				IF @NON_AUTH = 'Y'
					BEGIN 
						SET @v_dSql += ' WHERE 1=1 '
					END
				ELSE
					BEGIN
						SET @v_dSql += '	  (  																									 ' + char(10)
						SET @v_dSql += '	      SELECT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, B.FACTORY_ID;                           ' + char(10)
						SET @v_dSql += '	        FROM   TH_UIS_USER_FACTORY_RELATE A WITH(NOLOCK), TH_UIS_ROLE_FACTORY_RELATE B WITH(NOLOCK)	     ' + char(10)
						SET @v_dSql += '	        WHERE  A.USER_ID = '''+ @USER_ID +'''															 ' + char(10)
						SET @v_dSql += '	        AND    A.ROLE_ID = B.ROLE_ID                                                                    ' + char(10)
						SET @v_dSql += '	        AND    A.USE_AT_FLAG = ''Y''                                                                    ' + char(10)
						SET @v_dSql += '	        AND    B.USE_AT_FLAG = ''Y''                                                                    ' + char(10)
						SET @v_dSql += '	        GROUP BY B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, B.FACTORY_ID                        ' + char(10)
						SET @v_dSql += '	  ) AA                                                                                                  ' + char(10)
						SET @v_dSql += '	  WHERE A.COMPANY_ID=AA.COMPANY_ID                                                                      ' + char(10)
						SET @v_dSql += '	  AND   A.DIVISION_ID=AA.DIVISION_ID                                                                    ' + char(10)
						SET @v_dSql += '	  AND   A.SITE_ID=AA.SITE_ID                                                                            ' + char(10)
						SET @v_dSql += '	  AND   A.PLANT_ID=AA.PLANT_ID                                                                          ' + char(10)
						SET @v_dSql += '	  AND   A.FACTORY_ID=AA.FACTORY_ID                                                                      ' + char(10)
					END

				SET @v_dSql += '	AND A.ACTIVE_FLAG = ''Y''                                                                                           ' + char(10)
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.COMPANY_ID' , 'EQ', @V_COMPANY_ID)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @V_DIVISION_ID)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @V_SITE_ID)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @V_PLANT_ID)) + char(10);
				SET @v_dSql += '	GROUP BY a.FACTORY_ID, a.FACTORY_NAME                                                                               ' + char(10)
				SET @v_dSql += '	ORDER BY A.FACTORY_ID                                                                                               ' + char(10)


			END
		/****************************************************************************************************************************************/
		/*   TRANSPORT_MODE or TRANSPORT_TIME_UOM 정보갖고오기																					*/
		/*   Param :	TRANSPORT_MODE	or TRANSPORT_TIME_UOM             																		*/
		/****************************************************************************************************************************************/
		ELSE IF @Code ='TRANSPORT_MODE' Or @Code ='TRANSPORT_TIME_UOM'
		    BEGIN
				/* Alias setting */
				SET @v_dSql = '';
				SET @v_dSql += '	SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME				' + char(10)
				SET @v_dSql += '	FROM   SCM_SYS_LOOKUP_VALUE A (NOLOCK)					' + char(10)
				SET @v_dSql += '	WHERE  1=1												' + char(10)
				SET @v_dSql += '    AND A.LOOKUP_TYPE_CODE = '''+ @Code +'''                ' + char(10)
				SET @v_dSql += '	AND    ACTIVE_FLAG = ''Y''								' + char(10)
				SET @v_dSql += '	ORDER BY SORT_ORDER										' + char(10)

			END	

		/****************************************************************************************************************************************/
		/*   DIVISION 별 CONVERSION_TYPE 정보갖고오기																											*/
		/*   Param :																															*/
		/****************************************************************************************************************************************/
		ELSE IF @Code ='CONVERSION_TYPE'
		    BEGIN
				
				/* Alias setting */
				
				SET @v_dSql = '';
				SET @v_dSql += '	SELECT 	DISTINCT A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID		' + char(10)
				SET @v_dSql += '					, ISNULL(B.ATTRIBUTE1, ''GENERAL'') AS CODE	            ' + char(10)
				SET @v_dSql += '					, ISNULL(B.ATTRIBUTE1, ''GENERAL'') AS NAME	            ' + char(10)
				SET @v_dSql += '	FROM 	SCM_FACTORY_M A WITH(NOLOCK)                                    ' + char(10)
				SET @v_dSql += '			LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE B WITH(NOLOCK)             ' + char(10)
				SET @v_dSql += '			ON 1=1                                                          ' + char(10)
				SET @v_dSql += '			AND A.ACTIVE_FLAG = ''Y''                                       ' + char(10)
				SET @v_dSql += '			AND B.LOOKUP_TYPE_CODE = ''LINE_PROD_VERSION_TYPE''             ' + char(10)
				SET @v_dSql += '			AND A.DIVISION_ID = B.SEGMENT2                                  ' + char(10)
				SET @v_dSql += '			AND A.SITE_ID = B.SEGMENT1                                      ' + char(10)
				SET @v_dSql += '			AND A.PLANT_ID = B.SEGMENT3                                     ' + char(10)
				SET @v_dSql += '			AND A.FACTORY_ID = B.SEGMENT4                                   ' + char(10)
				SET @v_dSql += '	WHERE 1=1                                                               ' + char(10)
				
			END	

		/****************************************************************************************************************************************/
		/*   DIVISION 별 PRODUCTION TYPE 정보갖고오기																							*/
		/*   Param :	@Param21 = IS_NON_EXIST_TEST																							*/
		/****************************************************************************************************************************************/
		ELSE IF @Code ='LOOKUP_CODE_PRODTYPE'
		    BEGIN
				
				SET @v_dSql = '';
				SET @v_dSql += '	SELECT DISTINCT A.ATTRIBUTE2 AS CODE, A.SEGMENT2 AS NAME, A.SORT_ORDER	' + char(10);
				SET @v_dSql += '	, ISNULL(A.ATTRIBUTE2,'''') AS FP_PRODUCTION_TYPE	' + char(10);
				SET @v_dSql += '	,  (CASE WHEN ISNULL(A.ATTRIBUTE5,'''')=''Y'' THEN ''Y'' ELSE ''N'' END) AS _4MCC_TARGET_FLAG	' + char(10);
				SET @v_dSql += '	FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)									' + char(10);
				SET @v_dSql += '	WHERE  LOOKUP_TYPE_CODE = ''DIVISION_DEMAND_TYPE''		' + char(10);
				SET @v_dSql += '	AND    ACTIVE_FLAG = ''Y''								' + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('SEGMENT1' , 'EQ', @V_DIVISION_ID)) + char(10);

				IF @V_INSTANCE_ID = 'KR_CELL'
					BEGIN
						SET	@v_dSql += '	UNION ALL SELECT ''M/C'' AS CODE, ''M/C'' AS NAME, ''999'' AS SORT_ORDER, ''M/C'' AS FP_PRODUCTION_TYPE, ''N'' AS _4MCC_TARGET_FLAG' + char(10);
					END
				/*
				SET @v_dSql += '	AND NOT EXISTS (																												' + char(10);
				SET @v_dSql += '						SELECT 1																									' + char(10);
				SET @v_dSql += '						FROM	(																									' + char(10);
				SET @v_dSql += '									SELECT	DISTINCT IV.COMPANY_ID, IV.DIVISION_ID, IV.SITE_ID, IV.PLANT_ID, SS.PRODUCTION_TYPE 	' + char(10);
				SET @v_dSql += '									FROM	FP_INSTANCE_INFO_V IV WITH(NOLOCK)														' + char(10);
				SET @v_dSql += '											, SCM_SYS_LOOKUP_VALUE SV WITH(NOLOCK)													' + char(10);
				SET @v_dSql += '											, (																						' + char(10);
				SET @v_dSql += '												SELECT DISTINCT SEGMENT1 AS DIVISION_ID, SEGMENT2 AS PRODUCTION_TYPE				' + char(10);
				SET @v_dSql += '												FROM   SCM_SYS_LOOKUP_VALUE SS WITH(NOLOCK)											' + char(10);
				SET @v_dSql += '												WHERE 1=1																			' + char(10);
				SET @v_dSql += '												AND SS.LOOKUP_TYPE_CODE = ''DIVISION_DEMAND_TYPE''									' + char(10);
				SET @v_dSql += '												AND SS.ACTIVE_FLAG = ''Y''															' + char(10);
				SET @v_dSql += '												AND SS.ATTRIBUTE3 = ''N'' -- SCP TARGET FLAG											' + char(10);
				SET @v_dSql += '												AND SS.ATTRIBUTE5 = ''Y'' -- PDA TARGET FLAG											' + char(10);
				SET @v_dSql += '											) SS																					' + char(10);
				SET @v_dSql += '									WHERE	1=1																						' + char(10);
				SET @v_dSql += '									AND		SV.LOOKUP_TYPE_CODE = ''PDS_INSTANCE''													' + char(10);
				SET @v_dSql += '									AND		SV.ACTIVE_FLAG	= ''Y''																	' + char(10);
				SET @v_dSql += '									AND		SV.SEGMENT1		= IV.INSTANCE_ID														' + char(10);
				SET @v_dSql += '									AND		IV.INSTANCE_ID	= '''+ @V_INSTANCE_ID +'''															' + char(10);
				SET @v_dSql += '									AND		IV.DIVISION_ID	=  SS.DIVISION_ID														' + char(10);
				SET @v_dSql += '								) X																									' + char(10);
				SET @v_dSql += '						WHERE 1=1																									' + char(10);
				SET @v_dSql += '						AND	  A.SEGMENT1	= X.DIVISION_ID																			' + char(10);
				SET @v_dSql += '						AND	  A.ATTRIBUTE2	= X.PRODUCTION_TYPE																		' + char(10);
				SET @v_dSql += '					)																												' + char(10);
				*/
				SET @v_dSql += '	ORDER BY A.SORT_ORDER										' + char(10);

			END	
		
		/****************************************************************************************************************************************/
		/*   XPCOMMONCOND - find_Block_End_Date																							*/
		/*   		*/
		/*   Param :																							*/
		/****************************************************************************************************************************************/
		ELSE IF @Code ='BLOCK_END_DATE'
		    BEGIN
				
				SET @v_dSql = '';

				SET @v_dSql += N'	SELECT  AA.INSTANCE_ID																																																											' + char(10)
				SET @v_dSql += N'			--, ( SELECT A.DATED7	FROM TH_UIS_CALENDAR A, TH_UIS_CAL B WHERE A.D0 = B.ISO_YYYYWW	AND B.YYYYMMDD = AA.BLOCK_END_DATE ) AS BLOCK_END_DATE                                                                                       ' + char(10)
				SET @v_dSql += N'			--, ( SELECT A.DATED7	FROM TH_UIS_CALENDAR A, TH_UIS_CAL B WHERE A.D0 = B.ISO_YYYYWW	AND B.YYYYMMDD = AA.BLOCK_DATE ) AS c                                                                                                                           ' + char(10)
				SET @v_dSql += N'			, BLOCK_END_DATE                                                                                                                                                                                                                                        ' + char(10)
				SET @v_dSql += N'			, BLOCK_END_DATE                                                                                                                                                                                                                                        ' + char(10)
				SET @v_dSql += N'	FROM 	(                                                                                                                                                                                                                                                       ' + char(10)
				SET @v_dSql += N'				SELECT	SEGMENT1 AS INSTANCE_ID                                                                                                                                                                                                                     ' + char(10)
				SET @v_dSql += N'						, CONVERT(VARCHAR, DATEADD(DD, (CONVERT(INTEGER, ATTRIBUTE15) * 7 -1) * ISNULL(C.ROLE_CNT,1), (SELECT dbo.FN_SITE_TIME(B.SITE_ID)) ), 112) AS BLOCK_END_DATE                                                                                ' + char(10)
				SET @v_dSql += N'						, REPLACE(CONVERT(VARCHAR, DATEADD(DD, (CONVERT(INTEGER, ATTRIBUTE15) * 7 -1) * ISNULL(C.ROLE_CNT,1), (SELECT dbo.FN_SITE_TIME(B.SITE_ID)) ), 112),''/'',''-'') AS BLOCK_DATE                                                               ' + char(10)
				SET @v_dSql += N'						--, CONVERT(VARCHAR, DATEADD(DD, ( (CASE WHEN A.SEGMENT1 LIKE ''KR_%'' THEN CONVERT(INTEGER, ATTRIBUTE15) ELSE 5 END) * 7 -1) * ISNULL(C.ROLE_CNT,1), (SELECT dbo.FN_SITE_TIME(B.SITE_ID)) ), 112) AS BLOCK_END_DATE                        ' + char(10)
				SET @v_dSql += N'						--, REPLACE(CONVERT(VARCHAR, DATEADD(DD, ( (CASE WHEN A.SEGMENT1 LIKE ''KR_%'' THEN CONVERT(INTEGER, ATTRIBUTE15) ELSE 5 END) * 7 -1) * ISNULL(C.ROLE_CNT,1), (SELECT dbo.FN_SITE_TIME(B.SITE_ID)) ), 112),''/'',''-'') AS BLOCK_DATE       ' + char(10)
				SET @v_dSql += N'				FROM	SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                                                                                                                                                                                         ' + char(10)
				SET @v_dSql += N'				LEFT OUTER JOIN (                                                                                                                                                                                                                                   ' + char(10)
				SET @v_dSql += N'						SELECT DISTINCT B.INSTANCE_ID, A.SITE_ID                                                                                                                                                                                                    ' + char(10)
				SET @v_dSql += N'						FROM SCM_FACTORY_M A WITH(NOLOCK) INNER JOIN FP_INSTANCE_FACTORY_M B WITH(NOLOCK)                                                                                                                                                           ' + char(10)
				SET @v_dSql += N'						ON  A.FACTORY_ID=B.FACTORY_ID                ' + char(10)
				SET @v_dSql += N'						AND B.ACTIVE_FLAG = ''Y''                                                                                                                                                                                                                   ' + char(10)
				SET @v_dSql += N'						WHERE 1=1                                                                                                                                                                                                                                   ' + char(10)
				SET @v_dSql += N'						AND	 A.ACTIVE_FLAG = ''Y''                                                                                                                                                                                                                  ' + char(10)
				SET @v_dSql += N'				) B                                                                                                                                                                                                                                                 ' + char(10)
				SET @v_dSql += N'				ON 1=1                                                                                                                                                                                                                                              ' + char(10)
				SET @v_dSql += N'				AND		A.SEGMENT1 = B.INSTANCE_ID                                                                                                                                                                                                                  ' + char(10)
				SET @v_dSql += N'				LEFT OUTER JOIN (                                                                                                                                                                                                                                   ' + char(10)
				SET @v_dSql += N'					SELECT ISNULL(MAX(CASE WHEN ROLE_ID IN (''RA10101001'', ''RA10101007'') THEN 7 ELSE 1 END),1) AS ROLE_CNT                                                                                                                                       ' + char(10)
				SET @v_dSql += N'					FROM TH_UIS_USER_ROLE_RELATE                                                                                                                                                                                                                    ' + char(10)
				SET @v_dSql += N'					WHERE USER_ID = '''+ @USER_ID +'''                                                                                                                                                                                                                       ' + char(10)
				SET @v_dSql += N'					AND USE_AT_FLAG = ''Y''                                                                                                                                                                                                                         ' + char(10)
				SET @v_dSql += N'				) C                                                                                                                                                                                                                                                 ' + char(10)
				SET @v_dSql += N'				ON 1=1                                                                                                                                                                                                                                              ' + char(10)
				SET @v_dSql += N'				WHERE	A.LOOKUP_TYPE_CODE = ''INSTANCE_ID''                                                                                                                                                                                                        ' + char(10)
				SET @v_dSql += N'				AND		A.ACTIVE_FLAG 	= ''Y''                                                                                                                                                                                                                     ' + char(10)
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SEGMENT1' , 'EQ', @V_INSTANCE_ID)) + char(10);
				SET @v_dSql += N'			) AA                                                                                                                                                                                                                                                    ' + char(10)
				SET @v_dSql += N'	WHERE 1=1                                                                                                                                                                                                                                                       ' + char(10)
			
			END
		
		/****************************************************************************************************************************************/
		/*   XPCOMMONCOND - findScpPlanShop_code																							*/
		/*   comment="SCP PLAN list with All"		*/
		/*   Param : @Param21 = SCP_PLAN_TYPE																							*/
		/****************************************************************************************************************************************/
		ELSE IF @Code ='SCP_PLAN_SHOP'
		    BEGIN
				
				SET @v_dSql = '';

				SET @v_dSql += N'	SELECT DISTINCT TOP 20 CODE_ID AS CODE, CODE_NAME AS NAME, SCP_PLAN_ID, SCP_PLAN_TYPE														' + char(10)
				SET @v_dSql += N'	FROM (                                                                                                                      ' + char(10)
				SET @v_dSql += N'			SELECT SCP_PLAN_ID AS CODE_ID,SCP_PLAN_ID AS CODE_NAME, SCP_PLAN_ID, ''PRODUCT'' AS SCP_PLAN_TYPE                   ' + char(10)
				SET @v_dSql += N'			FROM FP_WEEKLY_DEMAND_PRODUCT_H A(NOLOCK)                                                                           ' + char(10)
				SET @v_dSql += N'			WHERE 1=1                                                                                                           ' + char(10)
				SET @v_dSql += N'			AND		(A.DIVISION_ID+A.SHOP_GROUP_ID+A.SITE_ID) IN (                                                              ' + char(10)
				SET @v_dSql += N'															SELECT DISTINCT A.DIVISION_ID+B.SHOP_GROUP_ID+A.SITE_ID AS CODE     ' + char(10)
				SET @v_dSql += N'															FROM SCM_FACTORY_M A WITH(NOLOCK)                                   ' + char(10)
				SET @v_dSql += N'															INNER JOIN FP_INSTANCE_FACTORY_M B WITH(NOLOCK)                     ' + char(10)
				SET @v_dSql += N'															ON  A.FACTORY_ID=B.FACTORY_ID                                       ' + char(10)
				SET @v_dSql += N'															AND B.ACTIVE_FLAG = ''Y''                                           ' + char(10)
				SET @v_dSql += N'															WHERE 1=1                                                           ' + char(10)
				SET @v_dSql += N'															AND	A.ACTIVE_FLAG = ''Y''                                           ' + char(10)
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.INSTANCE_ID' , 'EQ', @V_INSTANCE_ID)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @V_DIVISION_ID)) + char(10);
				SET @v_dSql += N'															                                                                    ' + char(10)
				SET @v_dSql += N'														)                                                                       ' + char(10)
				SET @v_dSql += N'			UNION ALL                                                                                                           ' + char(10)
				SET @v_dSql += N'			SELECT SCP_PLAN_ID AS CODE_ID,SCP_PLAN_ID AS CODE_NAME, SCP_PLAN_ID, ''SHIPMENT'' AS SCP_PLAN_TYPE                  ' + char(10)
				SET @v_dSql += N'			FROM FP_WEEKLY_DEMAND_SHIPMENT_H A(NOLOCK)                                                                          ' + char(10)
				SET @v_dSql += N'			WHERE 1=1                                                                                                           ' + char(10)
				SET @v_dSql += N'			AND		(A.DIVISION_ID+A.SHOP_GROUP_ID+A.SITE_ID) IN (                                                              ' + char(10)
				SET @v_dSql += N'															SELECT DISTINCT A.DIVISION_ID+B.SHOP_GROUP_ID+A.SITE_ID AS CODE     ' + char(10)
				SET @v_dSql += N'															FROM SCM_FACTORY_M A WITH(NOLOCK)                                   ' + char(10)
				SET @v_dSql += N'															INNER JOIN FP_INSTANCE_FACTORY_M B WITH(NOLOCK)                     ' + char(10)
				SET @v_dSql += N'															ON  A.FACTORY_ID=B.FACTORY_ID                                       ' + char(10)
				SET @v_dSql += N'															AND B.ACTIVE_FLAG = ''Y''                                           ' + char(10)
				SET @v_dSql += N'															WHERE 1=1                                                           ' + char(10)
				SET @v_dSql += N'															AND	A.ACTIVE_FLAG = ''Y''                                           ' + char(10)
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.INSTANCE_ID' , 'EQ', @V_INSTANCE_ID)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @V_DIVISION_ID)) + char(10);
				SET @v_dSql += N'														)                                                                       ' + char(10)
				SET @v_dSql += N'	) AA                                                                                                                        ' + char(10)
				SET @v_dSql += N'	WHERE SCP_PLAN_TYPE= '''+ @Param21 +'''                                                                       ' + char(10)
				SET @v_dSql += N'	ORDER BY CODE_ID DESC                                                                                                       ' + char(10)

			END
		
		/****************************************************************************************************************************************/
		/*   XPCOMMONCOND - find_CurrUTDate																							*/
		/*   comment=""		*/
		/*   Param : 																			*/
		/****************************************************************************************************************************************/
		ELSE IF @Code ='CURR_UTDATE'
		    BEGIN
				
				SET @v_dSql = '';

				SET @v_dSql += N'	WITH SITE_T AS (                                             																							' + char(10)
				SET @v_dSql += N'						SELECT 	DISTINCT INSTANCE_ID, SITE_ID                                                                                               ' + char(10)
				SET @v_dSql += N'						FROM 	FP_INSTANCE_OPERATION_V A                                                                                                   ' + char(10)
				SET @v_dSql += N'						WHERE	1=1												                                                                            ' + char(10)
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_ID' , 'EQ', @V_INSTANCE_ID)) + char(10);
				SET @v_dSql += N'					)                                                                                                                                       ' + char(10)
				SET @v_dSql += N'	SELECT (CASE WHEN FORMAT(dbo.FN_SITE_TIME(B.SITE_ID) ,''yyyyMMddHHmmss'') < (FORMAT(dbo.FN_SITE_TIME(B.SITE_ID) ,''yyyyMMdd'') + A.BASIS_START_TIME)    ' + char(10)
				SET @v_dSql += N'				 THEN CONVERT(VARCHAR,DATEADD(DD,-1,FORMAT(dbo.FN_SITE_TIME(B.SITE_ID) ,''yyyyMMdd'')),112)                                                 ' + char(10)
				SET @v_dSql += N'				 ELSE FORMAT(dbo.FN_SITE_TIME(B.SITE_ID) ,''yyyyMMdd'') END) AS CURR_DATE       ' + char(10)
				SET @v_dSql += N'	FROM   FP_INSTANCE_START_TIME_V A                                                                                                                       ' + char(10)
				SET @v_dSql += N'		   ,SITE_T B                                                                                                                                        ' + char(10)
				SET @v_dSql += N'	WHERE  1=1							                                                                                                                    ' + char(10)
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_ID' , 'EQ', @V_INSTANCE_ID)) + char(10);
				SET @v_dSql += N'	AND	   A.INSTANCE_ID = B.INSTANCE_ID                                                                                                                    ' + char(10)

			END
		/****************************************************************************************************************************************/
		/*   XPCOMMONCOND - LANE																							*/
		/*   comment=""		*/
		/*   Param : 																			*/
		/****************************************************************************************************************************************/
		ELSE IF @Code ='LANE'
		    BEGIN
				SET @v_dSql = '';
                SET @v_dSql += ' SELECT A.CODE AS CODE, A.NAME AS NAME           ' + char(10)
                SET @v_dSql += ' FROM (                                          ' + char(10)
				--SET @v_dSql += '      SELECT 0 As CODE, 0 AS NAME                     ' + char(10)
				--SET @v_dSql += '      UNION ALL                                       ' + char(10)
                SET @v_dSql += '      SELECT DISTINCT CONVERT(NUMERIC(18,5),A.LANE_QTY) AS CODE ' + char(10)  
                SET @v_dSql += '        , CAST(A.LANE_QTY AS INT) AS NAME             ' + char(10)
                SET @v_dSql += '      FROM SCM_ITEM_LANE_M A WITH(NOLOCK)             ' + char(10)                                 
                SET @v_dSql += '      WHERE   A.ACTIVE_FLAG = ''Y''                   ' + char(10)
                SET @v_dSql += ' ) A                                             ' + char(10)
                SET @v_dSql += ' ORDER BY A.CODE                                 ' + char(10)
			END
		/****************************************************************************************************************************************/
		/*   XPCOMMONCOND - ITEM_CONV_CALC																							*/
		/*   comment=""		*/
		/*   Param : 																			*/
		/****************************************************************************************************************************************/
		ELSE IF @Code ='ITEM_CONV_CALC'
		    BEGIN
				SET @v_dSql = '';
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT A.ATTRIBUTE1 AS CODE, A.ATTRIBUTE1 AS NAME ' + char(10)
                SELECT @v_dSql += ' FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)        ' + char(10)
                SELECT @v_dSql += ' WHERE  A.LOOKUP_TYPE_CODE = ''ITEM_CONV_CALC''    ' + char(10)
                SELECT @v_dSql += ' AND    A.ATTRIBUTE2  = ''Y''                      ' + char(10)
                SELECT @v_dSql += ' ORDER BY A.ATTRIBUTE1                             ' + char(10)
			END
		/****************************************************************************************************************************************/
		/*   XPCOMMONCOND - findLatestReleasePlanInfo_common																							*/
		/*   comment="SCP PLAN list with All"		*/
		/*   Param : @Param21 = CONFIRM_AREA																							*/
		/****************************************************************************************************************************************/
		ELSE IF @Code ='LATEST_RELEASE_PLAN_INFO'
		    BEGIN
				
				SET @v_dSql = '';

				SET @v_dSql += N'	SELECT A.FACTORY_ID, A.CONFIRM_AREA																					' + char(10)
				SET @v_dSql += N'		   , ISNULL(D.USER_NAME,'''') + ''(''+B.RELEASE_ID+'')'' AS INSERT_ID                                           ' + char(10)
				SET @v_dSql += N'		   , CONVERT(VARCHAR,B.INSERT_TIME,20) AS INSERT_TIME                                                           ' + char(10)
				SET @v_dSql += N'		   , B.DESCRIPTION                                                                                              ' + char(10)
				SET @v_dSql += N'		   , ''(''+A.FACTORY_ID+'')''+ ISNULL(C.FACTORY_NAME,'''') AS FACTORY_NAME                                      ' + char(10)
				SET @v_dSql += N'	FROM	(                                                                                                           ' + char(10)
				SET @v_dSql += N'				  SELECT A.INSTANCE_ID, A.RELEASE_PLAN_ID AS PLAN_ID, ''BUILDING'' AS CONFIRM_AREA                      ' + char(10)
				SET @v_dSql += N'				       , A.FACTORY_ID, A.INSERT_TIME                                                                    ' + char(10)
				SET @v_dSql += N'				       , DENSE_RANK() OVER(PARTITION BY A.FACTORY_ID ORDER BY A.INSERT_TIME DESC) SORT_ORDER            ' + char(10)
				SET @v_dSql += N'				  FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK), (                                                       ' + char(10)
				SET @v_dSql += N'						      SELECT DISTINCT A.INSTANCE_ID, A.FACTORY_ID                                               ' + char(10)
				SET @v_dSql += N'						      FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK)                                               ' + char(10)
				SET @v_dSql += N'						      WHERE  A.ACTIVE_FLAG = ''Y''                                                              ' + char(10)
				SET @v_dSql += N'						      AND    A.INSTANCE_ID = '''+ @V_INSTANCE_ID +'''                                           ' + char(10)
				SET @v_dSql += N'						  ) B                                                                                           ' + char(10)
				SET @v_dSql += N'				  WHERE  A.INSTANCE_ID  = B.INSTANCE_ID                                                                 ' + char(10)
				SET @v_dSql += N'				  AND    A.FACTORY_ID   = B.FACTORY_ID                                                                  ' + char(10)
				SET @v_dSql += N'				  AND    A.INSTANCE_ID  = '''+ @V_INSTANCE_ID +'''                                                      ' + char(10)
				SET @v_dSql += N'				  UNION ALL                                                                                             ' + char(10)
				SET @v_dSql += N'				  SELECT A.INSTANCE_ID, A.RELEASE_PLAN_ID AS PLAN_ID, ''PLAN GROUP'' AS CONFIRM_AREA                    ' + char(10)
				SET @v_dSql += N'				       , A.PLAN_GROUP_ID , A.INSERT_TIME                                                                ' + char(10)
				SET @v_dSql += N'				       , DENSE_RANK() OVER(PARTITION BY A.PLAN_GROUP_ID ORDER BY A.INSERT_TIME DESC) SORT_ORDER         ' + char(10)
				SET @v_dSql += N'				  FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK), (                                                       ' + char(10)
				SET @v_dSql += N'						      SELECT DISTINCT A.SEGMENT1 AS INSTANCE_ID, A.SEGMENT2 AS PLAN_GROUP_ID                    ' + char(10)
				SET @v_dSql += N'						      FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                                ' + char(10)
				SET @v_dSql += N'						      WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP''                                   ' + char(10)
				SET @v_dSql += N'						      AND    A.ACTIVE_FLAG = ''Y''                                                              ' + char(10)
				SET @v_dSql += N'						  ) B                                                                                           ' + char(10)
				SET @v_dSql += N'				  WHERE  A.INSTANCE_ID   = B.INSTANCE_ID                                                                ' + char(10)
				SET @v_dSql += N'				  AND    A.PLAN_GROUP_ID = B.PLAN_GROUP_ID                                                              ' + char(10)
				SET @v_dSql += N'				  AND    A.INSTANCE_ID   = '''+ @V_INSTANCE_ID +'''                                                     ' + char(10)
				SET @v_dSql += N'			) A                                                                                                         ' + char(10)
				SET @v_dSql += N'			INNER JOIN SCM_FP_PLAN_H B WITH(NOLOCK)                                                                     ' + char(10)
				SET @v_dSql += N'			ON    A.INSTANCE_ID  = B.INSTANCE_ID                                                                        ' + char(10)
				SET @v_dSql += N'			AND   A.PLAN_ID      = B.PLAN_ID                                                                            ' + char(10)

				IF @Param21 = 'BUILDING' BEGIN
					SET @v_dSql += N'			INNER JOIN SCM_FACTORY_M C WITH(NOLOCK)                         ' + char(10)
				END ELSE BEGIN
					SET @v_dSql += N'			LEFT OUTER JOIN SCM_FACTORY_M C WITH(NOLOCK)                    ' + char(10)
				END
				
				SET @v_dSql += N'			ON    A.FACTORY_ID   = C.FACTORY_ID                                                                         ' + char(10)
				SET @v_dSql += N'			AND   C.ACTIVE_FLAG  = ''Y''                                                                                ' + char(10)
				SET @v_dSql += N'			LEFT OUTER JOIN TH_UIS_USER_DETAIL D WITH(NOLOCK)                                                           ' + char(10)
				SET @v_dSql += N'			ON B.RELEASE_ID = D.USER_ID                                                                                 ' + char(10)
				SET @v_dSql += N'	WHERE A.SORT_ORDER   = 1                                                                                            ' + char(10)
				SET @v_dSql += N'	AND   A.CONFIRM_AREA IN (                                                                                           ' + char(10)
				SET @v_dSql += N'							  SELECT MAX(A.ATTRIBUTE1) AS CONFIRM_AREA                                                  ' + char(10)
				SET @v_dSql += N'							  FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                                ' + char(10)
				SET @v_dSql += N'							  WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_ID''                                               ' + char(10)
				SET @v_dSql += N'							  AND    A.SEGMENT1         = '''+ @V_INSTANCE_ID +'''                                      ' + char(10)
				SET @v_dSql += N'							  AND    A.ACTIVE_FLAG      = ''Y''                                                         ' + char(10)
				SET @v_dSql += N'							)                                                                                           ' + char(10)
				SET @v_dSql += N'	ORDER BY A.FACTORY_ID                                                                                               ' + char(10)

			END

		/****************************************************************************************************************************************/
		/*   XPCOMMON_AMEND - find_planPeriod_planResult																							*/
		/*   SCP TARGET 배포주차를 시점으로 LOOKUP 구간(INSTANCE_ID.PLAN_WEEK)을 기본으로 설정		*/
		/*   Param :	@Param21 = IS_NON_EXIST_TEST																							*/
		/****************************************************************************************************************************************/
		ELSE IF @Code ='PLAN_PERIOD_PLAN_RESULT_AMEND'
		    BEGIN
				
				SET @v_dSql = '';

				SET @v_dSql += N'	SELECT B.TARGET_WEEK																																			' + char(10)
				SET @v_dSql += N'		   , A.DATED1 AS START_DATE, CONVERT(VARCHAR, CONVERT(DATETIME,DATED7)+(7*(C.PLAN_WEEK -1)), 112) AS END_DATE -- target 주차 기준 날짜범위                  ' + char(10)
				SET @v_dSql += N'		   , (7*C.PLAN_WEEK) AS WEEK_RANGE                                                  ' + char(10)
				SET @v_dSql += N'		   , 1 AS _RNK ' + char(10)
				SET @v_dSql += N'	FROM   TH_UIS_CALENDAR A WITH(NOLOCK)                                                                                                                           ' + char(10)
				SET @v_dSql += N'			, (                                                                                                                                                     ' + char(10)
				SET @v_dSql += N'				 SELECT ISO_YYYYWW AS TARGET_WEEK -- target 주차                                                                                                    ' + char(10)
				SET @v_dSql += N'				 FROM   TH_UIS_CAL A WITH(NOLOCK)                                                                                                                   ' + char(10)
				SET @v_dSql += N'				 		, (                                                                                                                                         ' + char(10)
				SET @v_dSql += N'						      SELECT SUBSTRING(A.SCP_PLAN_ID,1,8) AS TARGET_DATE -- target 일자                                                                     ' + char(10)
				SET @v_dSql += N'						      FROM 	(                                                                                                                               ' + char(10)
				SET @v_dSql += N'								         SELECT MAX(A.SCP_PLAN_ID) AS SCP_PLAN_ID                                                                                   ' + char(10)
				SET @v_dSql += N'								         FROM   FP_WEEKLY_DEMAND_PRODUCT_H A WITH(NOLOCK)                                                                           ' + char(10)
				SET @v_dSql += N'								         WHERE  1=1                                                                                                                 ' + char(10)
				SET @v_dSql += N'								         AND    (A.DIVISION_ID+A.SHOP_GROUP_ID+A.SITE_ID) IN (                                                                      ' + char(10)
				SET @v_dSql += N'																					            SELECT DISTINCT A.DIVISION_ID+B.SHOP_GROUP_ID+A.SITE_ID AS CODE     ' + char(10)
				SET @v_dSql += N'																					            FROM  SCM_FACTORY_M A WITH(NOLOCK)                                  ' + char(10)
				SET @v_dSql += N'																					            INNER JOIN FP_INSTANCE_FACTORY_M B WITH(NOLOCK)                     ' + char(10)
				SET @v_dSql += N'																					            ON    A.FACTORY_ID=B.FACTORY_ID                                     ' + char(10)
				SET @v_dSql += N'																					            AND   B.ACTIVE_FLAG = ''Y''                                         ' + char(10)
				SET @v_dSql += N'																					            WHERE 1=1                                                           ' + char(10)
				SET @v_dSql += N'																					            AND   A.ACTIVE_FLAG = ''Y''                                         ' + char(10)
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.INSTANCE_ID' , 'EQ', @V_INSTANCE_ID)) + char(10);
				SET @v_dSql += N'																			         		)                                                                       ' + char(10)
				SET @v_dSql += N'						      		) A                                                                                                                             ' + char(10)
				SET @v_dSql += N'						 ) B                                                                                                                                        ' + char(10)
				SET @v_dSql += N'				WHERE A.YYYYMMDD = B.TARGET_DATE                                                                                                                    ' + char(10)
				SET @v_dSql += N'			) B                                     ' + char(10)
				SET @v_dSql += N'			, (                                                                                                                                                     ' + char(10)
				--SET @v_dSql += N'				 SELECT CONVERT(NUMERIC, ISNULL(AA.ATTRIBUTE15,8)) AS PLAN_WEEK                                                                                     ' + char(10)
				SET @v_dSql += N'				 SELECT (CASE WHEN CONVERT(NUMERIC, ISNULL(AA.ATTRIBUTE15,8)) > 12 THEN 12 ELSE CONVERT(NUMERIC, ISNULL(AA.ATTRIBUTE15,8)) END ) AS PLAN_WEEK ' + char(10) -- 기본주차가 일정치를 넘어갈 경우 보정 처리... 20241106... PDS 2차 고도화로 12주로 축소
				SET @v_dSql += N'				 FROM   SCM_SYS_LOOKUP_VALUE AA WITH(NOLOCK)                                                                                                        ' + char(10)
				SET @v_dSql += N'				 WHERE  AA.LOOKUP_TYPE_CODE = ''INSTANCE_ID''                                                                                                       ' + char(10)
				SET @v_dSql += N'				 AND    AA.ACTIVE_FLAG = ''Y''                                                                                                                      ' + char(10)
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AA.SEGMENT1' , 'EQ', @V_INSTANCE_ID)) + char(10);
				SET @v_dSql += N'			) C                                                                                                                                                     ' + char(10)
				SET @v_dSql += N'	WHERE A.D0 = B.TARGET_WEEK                                                                                                                                      ' + char(10)
				-- target 없을 경우 기본 구간 조건 추가.... 20230531
				SET @v_dSql += N'UNION ALL ' + char(10)
				SET @v_dSql += N'SELECT B.TARGET_WEEK ' + char(10)
				SET @v_dSql += N'	 , A.DATED1 AS START_DATE, CONVERT(VARCHAR, CONVERT(DATETIME,DATED7)+(7*(C.PLAN_WEEK -1)), 112) AS END_DATE ' + char(10)
				SET @v_dSql += N'	 , (7*C.PLAN_WEEK) AS WEEK_RANGE ' + char(10)
				SET @v_dSql += N'	 , 2 AS _RNK ' + char(10)
				SET @v_dSql += N'FROM   TH_UIS_CALENDAR A WITH(NOLOCK) ' + char(10)
				SET @v_dSql += N', ( ' + char(10)
				SET @v_dSql += N'	SELECT ISO_YYYYWW AS TARGET_WEEK ' + char(10)
				SET @v_dSql += N'	FROM   TH_UIS_CAL A WITH(NOLOCK) ' + char(10)
				SET @v_dSql += N'	WHERE  A.YYYYMMDD =  CONVERT(VARCHAR, (DBO.FN_SITE_TIME( (SELECT MAX(SITE_ID) FROM FP_INSTANCE_INFO_V A WITH(NOLOCK) ' + char(10) -- 사이트별 당일 기준 주차
				SET @v_dSql += N'															  WHERE 1=1 ' + char(10)
				SET @v_dSql += N'															  ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_ID' , 'EQ', @V_INSTANCE_ID)) + char(10);
				SET @v_dSql += N'															  ) )), 112) ' + char(10) 
				SET @v_dSql += N') B ' + char(10)
				SET @v_dSql += N', ( ' + char(10)
				--SET @v_dSql += N'	SELECT CONVERT(NUMERIC, ISNULL(AA.ATTRIBUTE15,8)) AS PLAN_WEEK ' + char(10)
				SET @v_dSql += N'	SELECT (CASE WHEN CONVERT(NUMERIC, ISNULL(AA.ATTRIBUTE15,8)) > 18 THEN 18 ELSE CONVERT(NUMERIC, ISNULL(AA.ATTRIBUTE15,8)) END ) AS PLAN_WEEK ' + char(10) -- 기본주차가 일정치를 넘어갈 경우 보정 처리... 20241106
				SET @v_dSql += N'	FROM   SCM_SYS_LOOKUP_VALUE AA WITH(NOLOCK) ' + char(10)
				SET @v_dSql += N'	WHERE  AA.LOOKUP_TYPE_CODE = ''INSTANCE_ID'' ' + char(10)
				SET @v_dSql += N'	AND    AA.ACTIVE_FLAG = ''Y'' ' + char(10)
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AA.SEGMENT1' , 'EQ', @V_INSTANCE_ID)) + char(10);
				SET @v_dSql += N') C ' + char(10)
				SET @v_dSql += N'WHERE A.D0 = B.TARGET_WEEK ' + char(10)
				SET @v_dSql += N'ORDER BY _RNK ' + char(10)

			END	
		/****************************************************************************************************************************************/
		/*   XPCOMMON - 																							*/
		/*   comment=""		*/
		/*   Param : 																			*/
		/****************************************************************************************************************************************/
		ELSE IF @Code ='RELEASE_NOTIFIY_TYPE'
		    BEGIN
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT ''SMS'' AS CODE, ''SMS'' AS NAME ' + char(10)
                SELECT @v_dSql += ' UNION ALL        ' + char(10)
                SELECT @v_dSql += ' SELECT ''MAIL'' AS CODE, ''Mail'' AS NAME   ' + char(10)
                SELECT @v_dSql += ' UNION ALL        ' + char(10)
                SELECT @v_dSql += ' SELECT ''SMS_MAIL'' AS CODE, ''SMS+Mail'' AS NAME ' + char(10)
                SELECT @v_dSql += ' UNION ALL        ' + char(10)
                SELECT @v_dSql += ' SELECT ''NONE'' AS CODE, ''None'' AS NAME   ' + char(10)

			END
		/****************************************************************************************************************************************/
		/*   XPCOMMON - 																							*/
		/*   comment=""		*/
		/*   Param : 																			*/
		/****************************************************************************************************************************************/
		ELSE IF @Code ='MENU_AUTHORITY_TYPE'
		    BEGIN
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT ''VIEWER'' AS CODE, ''VIEWER'' AS NAME ' + char(10)
                SELECT @v_dSql += ' UNION ALL        ' + char(10)
                SELECT @v_dSql += ' SELECT ''PLANNER'' AS CODE, ''PLANNER'' AS NAME   ' + char(10)

			END
		/****************************************************************************************************************************************/
		/*   AUTHAPPROVAL - 																							*/
		/*   comment=""		*/
		/*   Param : 																			*/
		/****************************************************************************************************************************************/
		ELSE IF @Code ='APPROVAL_FLAG'
		    BEGIN
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT ''R'' AS CODE, ''Request'' AS NAME ' + char(10)
                SELECT @v_dSql += ' UNION ALL        ' + char(10)
                SELECT @v_dSql += ' SELECT ''Y'' AS CODE, ''Approval'' AS NAME   ' + char(10)
                SELECT @v_dSql += ' UNION ALL        ' + char(10)
                SELECT @v_dSql += ' SELECT ''N'' AS CODE, ''Reject'' AS NAME   ' + char(10)

			END
		/****************************************************************************************************************************************/
		/*   AUTHAPPROVAL - 																							*/
		/*   comment="Pancake Master :  ATTR_TYPE "		*/
		/*   Param : 																			*/
		/****************************************************************************************************************************************/
		ELSE IF @Code ='ATTR_TYPE'
		    BEGIN		
			    IF @Param1 ='ROLL_TYPE'
					BEGIN
						SELECT @v_dSql = ''
						SELECT @v_dSql += ' SELECT distinct	 SEGMENT3 AS CODE, NAME = CASE   ' + char(10);
						SELECT @v_dSql += ' WHEN SEGMENT3 = ''J'' THEN ''Jumbo Roll''   ' + char(10);
						SELECT @v_dSql += ' WHEN SEGMENT3 = ''P'' THEN ''Pancake''   ' + char(10);
						SELECT @v_dSql += ' END ' + char(10);
						SELECT @v_dSql += ' FROM 	SCM_SYS_LOOKUP_VALUE		 ' + char(10);
						SELECT @v_dSql += ' WHERE 	1=1		 ' + char(10);
						SELECT @v_dSql += ' AND 	LOOKUP_TYPE_CODE = ''E_POST_WH_CAPA_DEFINIT''		 ' + char(10);
						SELECT @v_dSql += ' AND 	SEGMENT3 <> ''''		 ' + char(10);
					END
				ELSE IF @Param1 ='ELEC_TYPE'
					BEGIN
						SELECT @v_dSql = ''
						SELECT @v_dSql += ' SELECT distinct	 SEGMENT4 AS CODE, NAME = CASE     ' + char(10);
						SELECT @v_dSql += ' WHEN SEGMENT4 = ''C'' THEN ''JCathod''   ' + char(10);
						SELECT @v_dSql += ' WHEN SEGMENT4 = ''A'' THEN ''Anode''   ' + char(10);
						SELECT @v_dSql += ' END ' + char(10);
						SELECT @v_dSql += ' FROM 	SCM_SYS_LOOKUP_VALUE		 ' + char(10);
						SELECT @v_dSql += ' WHERE 	1=1		 ' + char(10);
						SELECT @v_dSql += ' AND 	LOOKUP_TYPE_CODE = ''E_POST_WH_CAPA_DEFINIT''		 ' + char(10);
						SELECT @v_dSql += ' AND 	SEGMENT4 <> ''''		 ' + char(10);
					END
				ELSE
					BEGIN
					--ATTR_TYPE
						SELECT @v_dSql = ''
						SELECT @v_dSql += ' SELECT distinct	 SEGMENT5 AS CODE, NAME = CASE   ' + char(10);
						SELECT @v_dSql += ' WHEN SEGMENT5 = ''-'' THEN ''-''   ' + char(10);
						SELECT @v_dSql += ' WHEN SEGMENT5 = ''A'' THEN ''A_Long''   ' + char(10);
						SELECT @v_dSql += ' WHEN SEGMENT5 = ''B'' THEN ''B_Normal''   ' + char(10);
						SELECT @v_dSql += ' ELSE ''-'' ' + char(10);
						SELECT @v_dSql += ' END ' + char(10);
						SELECT @v_dSql += ' FROM 	SCM_SYS_LOOKUP_VALUE		 ' + char(10);
						SELECT @v_dSql += ' WHERE 	1=1		 ' + char(10);
						SELECT @v_dSql += ' AND 	LOOKUP_TYPE_CODE = ''E_POST_WH_CAPA_DEFINIT''		 ' + char(10);
						SELECT @v_dSql += ' AND 	SEGMENT5 <> ''''		 ' + char(10);
					END				

			END
		/****************************************************************************************************************************************/
		/*   AUTHAPPROVAL - 																							*/
		/*   comment="Pancake Master :  Roll Type "		*/
		/*   Param : 																			*/
		/****************************************************************************************************************************************/
		ELSE IF @Code ='ROLL_TYPE'
		    BEGIN		
				SELECT @v_dSql = ''
				SELECT @v_dSql += ' SELECT distinct	 SEGMENT3 AS CODE, NAME = CASE   ' + char(10);
				SELECT @v_dSql += ' WHEN SEGMENT3 = ''J'' THEN ''Jumbo Roll''   ' + char(10);
				SELECT @v_dSql += ' WHEN SEGMENT3 = ''P'' THEN ''Pancake''   ' + char(10);
				SELECT @v_dSql += ' END ' + char(10);
				SELECT @v_dSql += ' FROM 	SCM_SYS_LOOKUP_VALUE		 ' + char(10);
				SELECT @v_dSql += ' WHERE 	1=1		 ' + char(10);
				SELECT @v_dSql += ' AND 	LOOKUP_TYPE_CODE = ''E_POST_WH_CAPA_DEFINIT''		 ' + char(10);
				SELECT @v_dSql += ' AND 	SEGMENT3 <> ''''		 ' + char(10);

			END
		/****************************************************************************************************************************************/
		/*   AUTHAPPROVAL - 																							*/
		/*   comment="COUNTRY_ID"		*/
		/*   Param : 																			*/
		/****************************************************************************************************************************************/
		ELSE IF @Code ='COUNTRY_ID'
		    BEGIN		
				SET	@v_dSql += 'SELECT SITE_ID as code,		' + char(10);				
				SET	@v_dSql += '	    COUNTRY_ID as NAME		' + char(10);
  				SET	@v_dSql += 'FROM SCM_SITE_M A WITH(NOLOCK)				' + char(10);
			END
		/****************************************************************************************************************************************/
		/*   distinct  PROD_VERSION_TYPE - 																							*/
		/*   comment="COUNTRY_ID"		*/
		/*   Param : 																			*/
		/****************************************************************************************************************************************/
		ELSE IF @Code ='PROD_VERSION_TYPE'
		    BEGIN		
				SET	@v_dSql += ' select distinct  PROD_VERSION_TYPE as CODE ,		' + char(10);				
				SET	@v_dSql += '	    PROD_VERSION_TYPE as NAME		' + char(10);
  				SET	@v_dSql += '    from  SCM_ITEM_LANE_M				' + char(10);
			END	

		/****************************************************************************************************************************************/
		/*   SCM_JOB_MONITER_V - 																							*/
		/*   comment="SCM_JOB_MONITER_V"		*/
		/*   Param : 																			*/
		/****************************************************************************************************************************************/
		ELSE IF @Code ='JOB_MONITER'
		    BEGIN		
				SET	@v_dSql += '	SELECT MODULE, PROGRAM_NAME, LOG_TYPE, LOG_MESSAGE, DESCRIPTION, CREATION_DATE ' + char(10);
				SET	@v_dSql += '	FROM SCM_JOB_MONITER_V		' + char(10);	
			END		

		


	END -- IF END

	BEGIN

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

		exec PR_UI_SQL_LOG @v_proc_name,  @USER_ID, @Code,'',@v_dSql,'SELECT',@runstart, @runend

	END
