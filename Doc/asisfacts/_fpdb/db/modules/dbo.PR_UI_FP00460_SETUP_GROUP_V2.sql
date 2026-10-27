

/*
 * Program ID   : PR_UI_FP00460_SETUP_GROUP
 * Description  : PR_UI_FP00460_SETUP_GROUP
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/03/25   JYJ				Initial Release UI통합
 * 2023/03/14   KCH             Move to Dynamic Query
 */

CREATE PROCEDURE [dbo].[PR_UI_FP00460_SETUP_GROUP_V2]
	@p_sys_type			NVARCHAR(MAX)='',  
	@p_sys_flag			NVARCHAR(MAX)='',
	@p_sys_gubun		NVARCHAR(MAX)='',  
	@p_user_id			NVARCHAR(MAX)='',
	@in_columns			NVARCHAR(MAX)='',
	@in_row				NVARCHAR(MAX)='',
	@opt_none			NVARCHAR(5) = 'N'

AS 
BEGIN  --MAIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
    SET NOCOUNT ON                                                                                                                                                                                                                                                   
	SET XACT_ABORT ON 

		DECLARE @v_delimiter    NVARCHAR(1);
	DECLARE @max_loop_cnt	INTEGER = 0;
	DECLARE @mst_loop_cnt	INTEGER = 0;

	DECLARE @p__save_auth	NVARCHAR(MAX);
	DECLARE @p__non_auth	NVARCHAR(MAX);

	DECLARE   @p_company_id                 NVARCHAR(MAX)=''
	DECLARE   @p_division_id                NVARCHAR(MAX)=''
	DECLARE   @p_site_id                    NVARCHAR(MAX)=''
	DECLARE   @p_plant_id                   NVARCHAR(MAX)=''
	DECLARE   @p_operation_id               NVARCHAR(MAX)=''
	DECLARE   @p_setup_category_id          NVARCHAR(MAX)=''
	DECLARE   @p_setup_key_id               NVARCHAR(MAX)=''
	DECLARE   @p_level                      NVARCHAR(MAX)=''
	DECLARE   @p_referance_operation_id     NVARCHAR(MAX)=''
	DECLARE   @p_calculation                NVARCHAR(MAX)=''
	DECLARE   @p_description                NVARCHAR(MAX)=''
	DECLARE   @p_line_setup_group_id        NVARCHAR(MAX)=''
	DECLARE   @p_org_line_setup_group_id    NVARCHAR(MAX)=''
	DECLARE @p_instance_id NVARCHAR(MAX)=''

	DECLARE   @attribute1    NVARCHAR(MAX)=''
	DECLARE   @attribute2    NVARCHAR(MAX)=''
	DECLARE   @attribute3    NVARCHAR(MAX)=''
	DECLARE   @attribute4    NVARCHAR(MAX)=''
	DECLARE   @attribute5    NVARCHAR(MAX)=''
	DECLARE   @attribute6    NVARCHAR(MAX)=''
	DECLARE   @attribute7    NVARCHAR(MAX)=''
	DECLARE   @attribute8    NVARCHAR(MAX)=''
	DECLARE   @attribute9    NVARCHAR(MAX)=''
	DECLARE   @attribute10    NVARCHAR(MAX)=''
	DECLARE   @attribute11    NVARCHAR(MAX)=''
	DECLARE   @attribute12    NVARCHAR(MAX)=''
	DECLARE   @attribute13    NVARCHAR(MAX)=''
	DECLARE   @attribute14    NVARCHAR(MAX)=''
	DECLARE   @attribute15    NVARCHAR(MAX)=''

	DECLARE @v_sys_type                   NVARCHAR(MAX)  -- 값>> SELEC: SQL저장안함, SQL:SQL저장함
	DECLARE @v_sys_flag                   NVARCHAR(MAX)  -- 값>> I: Insert, M: Update, D: Delete, G: MERGE
	DECLARE @v_sys_gubun                  NVARCHAR(MAX) 
	DECLARE @v_user_id                    NVARCHAR(MAX)
    DECLARE @v_company_id                 NVARCHAR(MAX)
	DECLARE @v_division_id                NVARCHAR(MAX)
    DECLARE @v_site_id                    NVARCHAR(MAX)
    DECLARE @v_plant_id                   NVARCHAR(MAX)
    DECLARE @v_operation_id               NVARCHAR(MAX)
    DECLARE @v_setup_category_id          NVARCHAR(MAX)
    DECLARE @v_setup_key_id               NVARCHAR(MAX)
    DECLARE @v_level                      NVARCHAR(MAX)
    DECLARE @v_referance_operation_id     NVARCHAR(MAX)
    DECLARE @v_calculation                NVARCHAR(MAX)
    DECLARE @v_description                NVARCHAR(MAX)
    DECLARE @v_line_setup_group_id        NVARCHAR(MAX)
    DECLARE @v_org_line_setup_group_id    NVARCHAR(MAX)
    DECLARE @v_instance_id   NVARCHAR(MAX)

	DECLARE @recv_active_flag       NVARCHAR(MAX)				    
	DECLARE @v_proc_name	        NVARCHAR(100) = 'PR_UI_FP00460_SETUP_GROUP'
	DECLARE @v_log_type             NVARCHAR(100) = ''
	DECLARE @v_log_message          NVARCHAR(MAX) = ''
	DECLARE @v_error_description    NVARCHAR(MAX) = ''

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

	SET @v_sys_type                 = ''
	SET @v_sys_flag                 = ''
	SET @v_sys_gubun                = ''
	SET @v_user_id                  = ''
    SET @v_company_id               = '' 
	SET @v_division_id              = '' 
    SET @v_site_id                  = '' 
    SET @v_plant_id                 = ''
    SET @v_operation_id             = ''
    SET @v_setup_category_id        = ''
    SET @v_setup_key_id             = ''
    SET @v_level                    = ''
    SET @v_referance_operation_id   = ''
    SET @v_calculation              = ''
    SET @v_description              = ''
    SET @v_line_setup_group_id      = ''
    SET @v_org_line_setup_group_id  = ''
    SET @v_instance_id  = ''

		DECLARE @tmp_column		NVARCHAR(MAX);
	DECLARE @tmp_value		NVARCHAR(MAX);
	DECLARE @dbg_txt		NVARCHAR(MAX);
		SET @v_delimiter            = '^'  -- 데이터 구분자
	SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@in_columns, @v_delimiter) -- 프로시저 LOOP 길이를 판단
	
	WHILE @mst_loop_cnt < @max_loop_cnt
	BEGIN -- 각 컬럼들에 대한 스플릿처리로직 스타트	
		
		SET @mst_loop_cnt = @mst_loop_cnt + 1;	-- @mst_loop_cnt 1증가

		SET @tmp_column	= [dbo].[SCM_ARR_SPL_VAL]( @in_columns , @v_delimiter , @mst_loop_cnt);
		SET @tmp_value	= [dbo].[SCM_ARR_SPL_VAL]( @in_row , @v_delimiter , @mst_loop_cnt);

		IF @tmp_column = '_SAVE_AUTH' BEGIN
			SET @p__save_auth =			@tmp_value ;
		END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
			SET @p__non_auth =			@tmp_value ;
		
		END ELSE IF @tmp_column = 'COMPANY_ID' BEGIN
			SET @p_company_id =			@tmp_value ;
		END ELSE IF @tmp_column = 'INSTANCE_ID' BEGIN
			SET @p_instance_id =		@tmp_value ;
		END ELSE IF @tmp_column = 'DIVISION_ID' BEGIN
			SET @p_division_id =		@tmp_value ;
		END ELSE IF @tmp_column = 'SITE_ID' BEGIN
			SET @p_site_id =			@tmp_value ;
		END ELSE IF @tmp_column = 'PLANT_ID' BEGIN
			SET @p_plant_id =			@tmp_value ;
		END ELSE IF @tmp_column = 'OPERATION_ID' BEGIN
			SET @p_operation_id =		@tmp_value ;
		END ELSE IF @tmp_column = 'SETUP_CATEGORY_ID' BEGIN
			SET @p_setup_category_id =			@tmp_value ;
		END ELSE IF @tmp_column = 'SETUP_KEY_ID' BEGIN
			SET @p_setup_key_id =			@tmp_value ;
		END ELSE IF @tmp_column = 'LEVEL' BEGIN
			SET @p_level =			@tmp_value ;
		END ELSE IF @tmp_column = 'REFERANCE_OPERATION_ID' BEGIN
			SET @p_referance_operation_id =			@tmp_value ;
		END ELSE IF @tmp_column = 'CALCULATION' BEGIN
			SET @p_calculation =			@tmp_value ;
		END ELSE IF @tmp_column = 'DESCRIPTION' BEGIN
			SET @p_description =			@tmp_value ;

		END ELSE IF @tmp_column = 'ATTRIBUTE1' BEGIN
			SET @attribute1 =			@tmp_value ;
		END ELSE IF @tmp_column = 'ATTRIBUTE2' BEGIN
			SET @attribute2 =			@tmp_value ;
		END ELSE IF @tmp_column = 'ATTRIBUTE3' BEGIN
			SET @attribute3 =			@tmp_value ;
		END ELSE IF @tmp_column = 'ATTRIBUTE4' BEGIN
			SET @attribute4 =			@tmp_value ;
		END ELSE IF @tmp_column = 'ATTRIBUTE5' BEGIN
			SET @attribute5 =			@tmp_value ;
		END ELSE IF @tmp_column = 'ATTRIBUTE6' BEGIN
			SET @attribute6 =			@tmp_value ;
		END ELSE IF @tmp_column = 'ATTRIBUTE7' BEGIN
			SET @attribute7 =			@tmp_value ;
		END ELSE IF @tmp_column = 'ATTRIBUTE8' BEGIN
			SET @attribute8 =			@tmp_value ;
		END ELSE IF @tmp_column = 'ATTRIBUTE9' BEGIN
			SET @attribute9 =			@tmp_value ;
		END ELSE IF @tmp_column = 'ATTRIBUTE10' BEGIN
			SET @attribute10 =			@tmp_value ;
		END ELSE IF @tmp_column = 'ATTRIBUTE11' BEGIN
			SET @attribute11 =			@tmp_value ;
		END ELSE IF @tmp_column = 'ATTRIBUTE12' BEGIN
			SET @attribute12 =			@tmp_value ;
		END ELSE IF @tmp_column = 'ATTRIBUTE13' BEGIN
			SET @attribute13 =			@tmp_value ;
		END ELSE IF @tmp_column = 'ATTRIBUTE14' BEGIN
			SET @attribute14 =			@tmp_value ;
		END ELSE IF @tmp_column = 'ATTRIBUTE15' BEGIN
			SET @attribute15 =			@tmp_value ;




		END ELSE IF @tmp_column = 'LINE_SETUP_GROUP_ID' BEGIN
			SET @p_line_setup_group_id =			@tmp_value ;
		END ELSE IF @tmp_column = 'ORG_LINE_SETUP_GROUP_ID' BEGIN
			SET @p_org_line_setup_group_id =			@tmp_value ;
		END

	END


	--SET @p_user_id              = dbo.FN_deCRYPT_AES128(@p_user_id)
	SET @recv_active_flag       = NULL	
	SET @recv_active_flag       = @p_sys_flag
	SET @v_delimiter            = '|'             -- 데이터 구분자
	SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_sys_flag, @v_delimiter) -- 프로시저 LOOP 길이를 판단  

	SET	@v_dSql                 = ''
	SET	@v_dSql1                = ''
	SET	@v_dSql2                = ''
	SET	@v_dSql3                = ''
	/************************************************************************************************/
	/* SELECT인경우 :SELECT(SELECT)                                                                      */
	/************************************************************************************************/
	IF(@p_sys_flag ='SELECT_MAIN')
		BEGIN --IF(START)
		    SELECT @v_dSql = ''
            SELECT @v_dSql += ' SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID   ' + char(10)
            SELECT @v_dSql += '    , A.OPERATION_ID, A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID ' + char(10)
            SELECT @v_dSql += '    , A.LEVEL, A.REFERANCE_OPERATION_ID, A.CALCULATION    ' + char(10)
            SELECT @v_dSql += '    , A.DESCRIPTION ' + char(10)
            SELECT @v_dSql += '    , (CASE WHEN R.COMPANY_ID IS NULL THEN ''N'' ELSE ''Y'' END) AS EDIT_YN ' + char(10)
            SELECT @v_dSql += ' FROM   SCM_ITEM_SETUP_GROUP_M A WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += ' LEFT OUTER JOIN ( ' + char(10)
            SELECT @v_dSql += '      SELECT DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.OPERATION_ID ' + char(10)
            SELECT @v_dSql += '      FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += '      WHERE  R.USER_ID   = '''+ @p_user_id +''' ' + char(10)
            SELECT @v_dSql += '      AND    R.SAVE_FLAG = ''Y'' ' + char(10)
            SELECT @v_dSql += ' ) R ' + char(10)
            SELECT @v_dSql += ' ON   A.COMPANY_ID   = R.COMPANY_ID   ' + char(10)
            SELECT @v_dSql += ' AND  A.DIVISION_ID  = R.DIVISION_ID  ' + char(10)
            SELECT @v_dSql += ' AND  A.SITE_ID      = R.SITE_ID      ' + char(10)
            SELECT @v_dSql += ' AND  A.OPERATION_ID = R.OPERATION_ID ' + char(10)
            SELECT @v_dSql += ' WHERE  EXISTS ( ' + char(10)
            SELECT @v_dSql += '       SELECT 1  ' + char(10)
            SELECT @v_dSql += '       FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)    ' + char(10)
            SELECT @v_dSql += '       WHERE  A.COMPANY_ID   = B.COMPANY_ID         ' + char(10)
            SELECT @v_dSql += '       AND    A.DIVISION_ID  = B.DIVISION_ID        ' + char(10)
            SELECT @v_dSql += '       AND    A.SITE_ID      = B.SITE_ID            ' + char(10)
            SELECT @v_dSql += '       AND    A.OPERATION_ID = B.OPERATION_ID       ' + char(10)
            SELECT @v_dSql += '       AND    B.USER_ID      = '''+ @p_user_id +''' ' + char(10)
            SELECT @v_dSql += ' ) ' + char(10)
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
	        SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))            + char(10)
	        SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))  + char(10)
	        SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SETUP_CATEGORY_ID' , 'EQ', @v_setup_category_id))    + char(10)
            SELECT @v_dSql += ' ORDER BY A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID, A.LEVEL, A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID '+ char(10)

			IF @p_sys_type = 'SQL'
				BEGIN
					EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
					SELECT @v_dSql as [QUERY_VALUE]

				END  
			ELSE 
				BEGIN
					SET @runstart = GetDate()
					--쿼리실행
					EXEC sp_executesql @v_dSql

					SET @runend = GetDate()
					EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
				END
	    END	--IF( END )
		/************************************************************************************************/
	/* 
	SELECT인경우 :SELECT(SELECT)        
	--2023-0314 chkim.68
	--형교환 고도화에 의한 추가 (테이블 교체, 인스턴스ID로 기준 변경)
	*/
	/************************************************************************************************/
	ELSE IF(@p_sys_flag ='SELECT_MAIN_V2')
		BEGIN --IF(START)
		    SELECT @v_dSql = ''
            SELECT @v_dSql += ' SELECT DISTINCT A.INSTANCE_ID,LK.SEGMENT2 AS INSTANCE_NAME   ' + char(10)
            SELECT @v_dSql += '    , A.OPERATION_ID, A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID ' + char(10)

            SELECT @v_dSql += ',CASE ' + char(10)
			SELECT @v_dSql += 'WHEN A.SETUP_KEY_ID = ''ATTRIBUTE1'' THEN B.ATTRIBUTE1 ' + char(10)
            SELECT @v_dSql += 'WHEN A.SETUP_KEY_ID = ''ATTRIBUTE2'' THEN B.ATTRIBUTE2' + char(10)
            SELECT @v_dSql += 'WHEN A.SETUP_KEY_ID = ''ATTRIBUTE3'' THEN B.ATTRIBUTE3' + char(10)
            SELECT @v_dSql += 'WHEN A.SETUP_KEY_ID = ''ATTRIBUTE4'' THEN B.ATTRIBUTE4 ' + char(10)
            SELECT @v_dSql += 'WHEN A.SETUP_KEY_ID = ''ATTRIBUTE5'' THEN B.ATTRIBUTE5 ' + char(10)
            SELECT @v_dSql += 'WHEN A.SETUP_KEY_ID = ''ATTRIBUTE6'' THEN B.ATTRIBUTE6 ' + char(10)
            SELECT @v_dSql += 'WHEN A.SETUP_KEY_ID = ''ATTRIBUTE7'' THEN B.ATTRIBUTE7 ' + char(10)
            SELECT @v_dSql += 'WHEN A.SETUP_KEY_ID = ''ATTRIBUTE8'' THEN B.ATTRIBUTE8 ' + char(10)
            SELECT @v_dSql += 'WHEN A.SETUP_KEY_ID = ''ATTRIBUTE9'' THEN B.ATTRIBUTE9 ' + char(10)
			SELECT @v_dSql += 'WHEN A.SETUP_KEY_ID = ''ATTRIBUTE10'' THEN B.ATTRIBUTE10 ' + char(10)
			SELECT @v_dSql += 'WHEN A.SETUP_KEY_ID = ''ATTRIBUTE11'' THEN B.ATTRIBUTE11 ' + char(10)
			SELECT @v_dSql += 'WHEN A.SETUP_KEY_ID = ''ATTRIBUTE12'' THEN B.ATTRIBUTE12 ' + char(10)
			SELECT @v_dSql += 'WHEN A.SETUP_KEY_ID = ''ATTRIBUTE13'' THEN B.ATTRIBUTE13 ' + char(10)
			SELECT @v_dSql += 'WHEN A.SETUP_KEY_ID = ''ATTRIBUTE14'' THEN B.ATTRIBUTE14 ' + char(10)
			SELECT @v_dSql += 'WHEN A.SETUP_KEY_ID = ''ATTRIBUTE15'' THEN B.ATTRIBUTE15 ' + char(10)
			SELECT @v_dSql += 'ELSE '''' ' + char(10)
			SELECT @v_dSql += 'END AS SETUP_KEY_NAME' + char(10)

            SELECT @v_dSql += '    , A.LEVEL, A.REFERANCE_OPERATION_ID, A.CALCULATION    ' + char(10)
            SELECT @v_dSql += '    , A.DESCRIPTION ' + char(10)
            SELECT @v_dSql += '    , (CASE WHEN R.INSTANCE_ID IS NULL THEN ''N'' ELSE ''Y'' END) AS EDIT_YN ' + char(10)
            SELECT @v_dSql += ' FROM   FP_ITEM_SETUP_GROUP_M A WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += ' LEFT OUTER JOIN ( ' + char(10)
            SELECT @v_dSql += '      SELECT DISTINCT R.INSTANCE_ID ' + char(10)
            SELECT @v_dSql += '      FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += '      WHERE  R.USER_ID   = '''+ @p_user_id +''' ' + char(10)
            SELECT @v_dSql += '      AND    R.SAVE_FLAG = ''Y'' ' + char(10)
            SELECT @v_dSql += ' ) R ' + char(10)
            SELECT @v_dSql += ' ON   1=1   ' + char(10)
            SELECT @v_dSql += ' AND  A.INSTANCE_ID = R.INSTANCE_ID  ' + char(10)


            SELECT @v_dSql += ' LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE LK WITH(NOLOCK)'+ char(10)
            SELECT @v_dSql += ' ON 1=1'+ char(10)
            SELECT @v_dSql += ' AND LK.LOOKUP_TYPE_CODE=''INSTANCE_ID'''+ char(10)
            SELECT @v_dSql += ' AND A.INSTANCE_ID = LK.SEGMENT1'+ char(10)

            SELECT @v_dSql += '  LEFT OUTER JOIN FP_INSTANCE_ITEM_SETUP_ATTR_TYPE_M B WITH(NOLOCK)'+ char(10)
            SELECT @v_dSql += ' ON A.INSTANCE_ID = b.INSTANCE_ID'+ char(10)
            SELECT @v_dSql += ' and A.OPERATION_ID = b.OPERATION_ID'+ char(10)
            SELECT @v_dSql += ' AND A.SETUP_CATEGORY_ID = ''ATTRIBUTE'''+ char(10)

            SELECT @v_dSql += ' WHERE  EXISTS ( ' + char(10)
            SELECT @v_dSql += '       SELECT 1  ' + char(10)
            SELECT @v_dSql += '       FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)    ' + char(10)
            SELECT @v_dSql += '       WHERE  1=1' + char(10)
            SELECT @v_dSql += '       AND    A.INSTANCE_ID  = B.INSTANCE_ID        ' + char(10)
            SELECT @v_dSql += '       AND    B.USER_ID      = '''+ @p_user_id +''' ' + char(10)
            SELECT @v_dSql += ' ) ' + char(10)
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_ID' , 'EQ', @p_instance_id))    + char(10)
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))    + char(10)
	        SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SETUP_CATEGORY_ID' , 'EQ', @p_setup_category_id))    + char(10)
            SELECT @v_dSql += ' ORDER BY A.INSTANCE_ID, A.OPERATION_ID, A.LEVEL, A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID '+ char(10)

			IF @p_sys_type = 'SQL'
				BEGIN
					EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
					SELECT @v_dSql as [QUERY_VALUE]

				END  
			ELSE 
				BEGIN
					SET @runstart = GetDate()
					--쿼리실행
					EXEC sp_executesql @v_dSql

					SET @runend = GetDate()
					EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
				END
	    END	--IF( END )
		/************************************************************************************************/
	/* 
	OPERATION_DIVISION인경우 :SELECT(SELECT)        
	--2023-0314 chkim.68
	--형교환 고도화에 의한 추가 (테이블 교체, 인스턴스ID로 기준 변경)
	*/
	/************************************************************************************************/

		ELSE IF (@p_sys_flag = 'OPERATION_DIVISION')
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
			SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
			SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
			SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'LIKE', @p_operation_id)) + char(10)																		
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

			
			IF @p_sys_type = 'SQL'
				BEGIN
					EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
					SELECT @v_dSql as [QUERY_VALUE]

				END  
			ELSE 
				BEGIN
					SET @runstart = GetDate()
					--쿼리실행
					EXEC sp_executesql @v_dSql

					SET @runend = GetDate()
					EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
				END
	   
		END

    /************************************************************************************************/
	/* SELECT인경우 :OPERATION_INSTANCE                                                                 */
	/************************************************************************************************/
		ELSE 	IF @p_sys_flag = 'OPERATION_INSTANCE'	-- findOperationCode_common
	BEGIN
				SELECT @v_dSql += N'	SELECT DISTINCT A.OPERATION_ID AS CODE                              	' + char(10)
		SELECT @v_dSql += N'			, ''('' + A.OPERATION_ID + '')'' + B.OPERATION_NAME AS NAME     ' + char(10)

		SELECT @v_dSql += N',A.INSTANCE_ID,LK.SEGMENT2 AS INSTANCE_NAME, A.OPERATION_ID, B.OPERATION_NAME, B.OPERATION_GROUP_ID, B.OPERATION_GROUP_NAME     ' + char(10)

		SELECT @v_dSql += N'	   		, A.AMEND_MAIN_FLAG                                             ' + char(10)
		SELECT @v_dSql += N'	FROM	FP_INSTANCE_OPERATION_V A                                       ' + char(10)
		--SELECT @v_dSql += N'		  , SCM_OPERATION_M B                                               ' + char(10)

		SELECT @v_dSql += N'INNER JOIN SCM_OPERATION_M B      ' + char(10)                             
		SELECT @v_dSql += N'ON  A.COMPANY_ID   = B.COMPANY_ID    ' + char(10)                                
		SELECT @v_dSql += N'AND    A.DIVISION_ID  = B.DIVISION_ID    ' + char(10)                               
		SELECT @v_dSql += N'AND    A.SITE_ID      = B.SITE_ID     ' + char(10)                                  
		SELECT @v_dSql += N'AND    A.OPERATION_ID = B.OPERATION_ID   ' + char(10)
		SELECT @v_dSql += N'LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE LK WITH(NOLOCK)' + char(10)
		SELECT @v_dSql += N'ON 1=1' + char(10)
		SELECT @v_dSql += N'AND LK.LOOKUP_TYPE_CODE=''INSTANCE_ID''' + char(10)
		SELECT @v_dSql += N'AND A.INSTANCE_ID = LK.SEGMENT1' + char(10)


		SELECT @v_dSql += N'	WHERE  A.COMPANY_ID   = B.COMPANY_ID                                    ' + char(10)
		SELECT @v_dSql += N'	AND    A.DIVISION_ID  = B.DIVISION_ID                                   ' + char(10)
		SELECT @v_dSql += N'	AND    A.SITE_ID      = B.SITE_ID                                       ' + char(10)
		SELECT @v_dSql += N'	AND    A.OPERATION_ID = B.OPERATION_ID                                  ' + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_ID' , 'EQ', @p_instance_id)) + char(10)																		
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)																		
		SELECT @v_dSql += N'	AND    EXISTS (                                                         ' + char(10)
		SELECT @v_dSql += N'		        	SELECT 1                                                ' + char(10)
		SELECT @v_dSql += N'		        	FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)               ' + char(10)
		SELECT @v_dSql += N'		        	WHERE  A.COMPANY_ID  = B.COMPANY_ID                     ' + char(10)
		SELECT @v_dSql += N'		        	AND    A.DIVISION_ID = B.DIVISION_ID                    ' + char(10)
		SELECT @v_dSql += N'		        	AND    A.SITE_ID     = B.SITE_ID                        ' + char(10)
		SELECT @v_dSql += N'		        	AND    A.OPERATION_ID = B.OPERATION_ID                  ' + char(10)
		SELECT @v_dSql += N'		        	AND    B.USER_ID     = '''+ @p_user_id +'''                        ' + char(10)
		SELECT @v_dSql += N'		      	)                                                           ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_ID' , 'EQ', @p_instance_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += N'	AND   A.AMEND_FLAG = ''Y''                                              ' + char(10)				
		SELECT @v_dSql += N'	ORDER BY LK.SEGMENT2 , A.OPERATION_ID DESC    ' +char(10)      

		
			IF @p_sys_type = 'SQL'
				BEGIN
					EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
					SELECT @v_dSql as [QUERY_VALUE]

				END  
			ELSE 
				BEGIN
					SET @runstart = GetDate()
					--쿼리실행
					EXEC sp_executesql @v_dSql

					SET @runend = GetDate()
					EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
				END

	END

			/************************************************************************************************/
	/* 
	OPERATION_DIVISION인경우 :SELECT(SELECT)        
	--2023-0314 chkim.68
	--형교환 고도화에 의한 추가 (테이블 교체, 인스턴스ID로 기준 변경)
	*/
	/************************************************************************************************/

	--ELSE IF (@p_sys_flag = 'FPC0623_OPERATION_POPUP')
	--BEGIN

		

	--END

	/************************************************************************************************/
	/* SELECT인경우 :SELECT(SELECT)                                                                      */
	/************************************************************************************************/
	ELSE IF(@p_sys_flag ='SELECT_SUB')
		BEGIN --IF(START)
		    SELECT @v_dSql = ''
            SELECT @v_dSql += ' SELECT A.INSTANCE_ID,LK.SEGMENT2 AS INSTANCE_NAME, A.OPERATION_ID      ' + char(10)
            SELECT @v_dSql += '      , A.LINE_SETUP_GROUP_ID, A.LINE_SETUP_GROUP_ID AS ORG_LINE_SETUP_GROUP_ID ' + char(10)
            SELECT @v_dSql += '      , (CASE WHEN R.INSTANCE_ID IS NULL THEN ''N'' ELSE ''Y'' END) AS EDIT_YN   ' + char(10)
            SELECT @v_dSql += ' FROM   FP_LINE_SETUP_GROUP_M A WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += ' LEFT OUTER JOIN (                            ' + char(10)
            SELECT @v_dSql += '      SELECT DISTINCT R.INSTANCE_ID, R.OPERATION_ID ' + char(10)
            SELECT @v_dSql += '      FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += '      WHERE  R.USER_ID   = '''+ @p_user_id +''' ' + char(10)
            SELECT @v_dSql += '      AND    R.SAVE_FLAG = ''Y''                ' + char(10)
            SELECT @v_dSql += ' ) R ' + char(10)
            SELECT @v_dSql += ' ON   A.INSTANCE_ID = R.INSTANCE_ID   ' + char(10)
            SELECT @v_dSql += ' AND  A.OPERATION_ID = R.OPERATION_ID ' + char(10)

			SELECT @v_dSql += ' LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE LK WITH(NOLOCK)'+ char(10)
            SELECT @v_dSql += ' ON 1=1'+ char(10)
            SELECT @v_dSql += ' AND LK.LOOKUP_TYPE_CODE=''INSTANCE_ID'''+ char(10)
            SELECT @v_dSql += ' AND A.INSTANCE_ID = LK.SEGMENT1'+ char(10)

            SELECT @v_dSql += ' WHERE  EXISTS ( ' + char(10)
            SELECT @v_dSql += '       SELECT 1  ' + char(10)
            SELECT @v_dSql += '       FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)    ' + char(10)
            SELECT @v_dSql += '       WHERE  A.INSTANCE_ID   = B.INSTANCE_ID         ' + char(10)
            SELECT @v_dSql += '       AND    A.OPERATION_ID = B.OPERATION_ID       ' + char(10)
            SELECT @v_dSql += '       AND    B.USER_ID      = '''+ @p_user_id +''' ' + char(10)
            SELECT @v_dSql += ' ) ' + char(10)
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_ID' , 'EQ', @p_instance_id))      + char(10)
	        SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))    + char(10)
	        SELECT @v_dSql += ' ORDER BY A.INSTANCE_ID, A.OPERATION_ID, A.LINE_SETUP_GROUP_ID ' + char(10)

			IF @p_sys_type = 'SQL'
				BEGIN
					EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
					SELECT @v_dSql as [QUERY_VALUE]

				END  
			ELSE 
				BEGIN
					SET @runstart = GetDate()
					--쿼리실행
					EXEC sp_executesql @v_dSql

					SET @runend = GetDate()
					EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
				END
	    END	--IF( END )

	/************************************************************************************************/
	/* SELECT인경우 :SELECT DETAIL Popup(SELECT_DETAIL_POPUP)                                       */
	/************************************************************************************************/
	ELSE IF(@p_sys_flag ='SELECT_DETAIL_POPUP')
		BEGIN --IF(START)
		    SELECT @v_dSql = ''
            SELECT @v_dSql += ' SELECT A.INSTANCE_ID   ' + char(10)
            SELECT @v_dSql += '     , A.OPERATION_ID, A.LEVEL, A.SETUP_CATEGORY_ID           ' + char(10)
            SELECT @v_dSql += '     , A.SETUP_KEY_ID, A.ITEM_SETUP_GROUP_ID                  ' + char(10)
            SELECT @v_dSql += '     , A.REFERANCE_OPERATION_ID, A.CALCULATION, A.DESCRIPTION ' + char(10)
            SELECT @v_dSql += ' FROM   FP_ITEM_SETUP_GROUP_M A(NOLOCK)                      ' + char(10)

			            SELECT @v_dSql += ' LEFT OUTER JOIN (                            ' + char(10)
            SELECT @v_dSql += '      SELECT DISTINCT R.INSTANCE_ID, R.OPERATION_ID ' + char(10)
            SELECT @v_dSql += '      FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += '      WHERE  R.USER_ID   = '''+ @p_user_id +''' ' + char(10)
            SELECT @v_dSql += '      AND    R.SAVE_FLAG = ''Y''                ' + char(10)
            SELECT @v_dSql += ' ) R ' + char(10)
            SELECT @v_dSql += ' ON   A.INSTANCE_ID = R.INSTANCE_ID   ' + char(10)
            SELECT @v_dSql += ' AND  A.OPERATION_ID = R.OPERATION_ID ' + char(10)

            --SELECT @v_dSql += '     , (                                                      ' + char(10)
            --SELECT @v_dSql += '        SELECT B.COMPANY_ID,B.DIVISION_ID,B.SITE_ID           ' + char(10)
            --SELECT @v_dSql += '        FROM TH_UIS_USER_FACTORY_RELATE A(NOLOCK)             ' + char(10)
            --SELECT @v_dSql += '           , TH_UIS_ROLE_FACTORY_RELATE B(NOLOCK)             ' + char(10)
            --SELECT @v_dSql += '        WHERE A.USER_ID = '''+ @p_user_id +'''                ' + char(10)
            --SELECT @v_dSql += '        AND   A.ROLE_ID = B.ROLE_ID                           ' + char(10)
            --SELECT @v_dSql += '        AND   A.USE_AT_FLAG = ''Y''                           ' + char(10)
            --SELECT @v_dSql += '        AND   B.USE_AT_FLAG = ''Y''                           ' + char(10)
            --SELECT @v_dSql += '        GROUP BY B.COMPANY_ID,B.DIVISION_ID,B.SITE_ID         ' + char(10)
            --SELECT @v_dSql += '       ) AA                                                   ' + char(10)
            --SELECT @v_dSql += ' WHERE A.COMPANY_ID=AA.COMPANY_ID                             ' + char(10)
            --SELECT @v_dSql += ' AND   A.DIVISION_ID=AA.DIVISION_ID                           ' + char(10)
            --SELECT @v_dSql += ' AND   A.SITE_ID=AA.SITE_ID                                   ' + char(10)
            SELECT @v_dSql += ' ORDER BY A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID            ' + char(10)
            SELECT @v_dSql += '      , A.LEVEL, A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID          ' + char(10)

			IF @p_sys_type = 'SQL'
				BEGIN
					EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
					SELECT @v_dSql as [QUERY_VALUE]

				END  
			ELSE 
				BEGIN
					SET @runstart = GetDate()
					--쿼리실행
					EXEC sp_executesql @v_dSql

					SET @runend = GetDate()
					EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
				END
	    END	--IF( END )
    /************************************************************************************************/
	/*  EXECUTE 경우 :(EXECUTE_INIT_SETUP  )                             */
	/************************************************************************************************/
    ELSE IF(@p_sys_flag ='EXECUTE_INIT_SETUP')
	    BEGIN --ELSE IF(START)
		    --SELECT @v_dSql = ''
			EXEC  @rtnCount = [dbo].[PR_SCM_UF_ITEM_SETUP_RENEW]
	
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

		    /************************************************************************************************/
	/*  EXECUTE 경우 :(EXECUTE_INIT_SETUP  )                             */
	/************************************************************************************************/
    ELSE IF(@p_sys_flag ='EXECUTE_INIT_SETUP_V2')
	    BEGIN --ELSE IF(START)
		    --SELECT @v_dSql = ''
			EXEC  @rtnCount = [dbo].[PR_SCM_UF_ITEM_SETUP_RENEW_V2]
	
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
    /************************************************************************************************/
	/*  EXECUTE 경우 :(EXECUTE_ADD  )                             */
	/************************************************************************************************/
    ELSE IF(@p_sys_flag ='EXECUTE_ADD')
	    BEGIN --ELSE IF(START)
		    --SELECT @v_dSql = ''
			EXEC  @rtnCount = [dbo].[PR_SCM_UF_ITEM_SETUP_INSERT] @p_company_id, @p_division_id, @p_site_id, @p_operation_id, @p_level, @p_setup_category_id, @p_setup_key_id, @p_referance_operation_id, @p_calculation, @p_user_id
	
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

    /************************************************************************************************/
	/*  EXECUTE 경우 :(EXECUTE_ADD_V2  )     형교환 고도화 23/03/16                        */
	/************************************************************************************************/
    ELSE IF(@p_sys_flag ='EXECUTE_ADD_V2')
	    BEGIN --ELSE IF(START)
		    --SELECT @v_dSql = ''
			EXEC  @rtnCount = [dbo].[PR_SCM_UF_ITEM_SETUP_INSERT_V2] @p_instance_id, @p_operation_id, @p_level, @p_setup_category_id, @p_setup_key_id, @p_referance_operation_id, @p_calculation, @p_user_id
			--IF @p_setup_key_id = 'ATTRIBUTE' 
			--BEGIN

			--END

	
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
	/************************************************************************************************/
	/*  EXECUTE 경우 :(EXECUTE_ADD_ATTR  )     형교환 고도화 23/03/16                        */
	/************************************************************************************************/
    ELSE IF(@p_sys_flag ='EXECUTE_ADD_ATTR')
	    BEGIN --ELSE IF(START)
		    --SELECT @v_dSql = ''
			EXEC  @rtnCount = [dbo].[PR_SCM_UF_ITEM_SETUP_INSERT_V2] @p_instance_id, @p_operation_id, @p_level, @p_setup_category_id, @p_setup_key_id, @p_referance_operation_id, @p_calculation, @p_user_id

	
				MERGE INTO FP_INSTANCE_ITEM_SETUP_ATTR_TYPE_M A
				using

				(SELECT @p_instance_id AS INSTANCE_ID, @p_operation_id AS OPERATION_ID) B
				ON 1=1 AND A.INSTANCE_ID = B.INSTANCE_ID AND A.OPERATION_ID = B.OPERATION_ID
				WHEN MATCHED THEN
				UPDATE SET 
				UPDATE_ID = @p_user_id
				,ACTIVE_FLAG = 'Y'
				,ATTRIBUTE1 = @ATTRIBUTE1
				,ATTRIBUTE2 = @ATTRIBUTE2
				,ATTRIBUTE3 = @ATTRIBUTE3
				,ATTRIBUTE4 = @ATTRIBUTE4
				,ATTRIBUTE5 = @ATTRIBUTE5
				,ATTRIBUTE6 = @ATTRIBUTE6
				,ATTRIBUTE7 = @ATTRIBUTE7
				,ATTRIBUTE8 = @ATTRIBUTE8
				,ATTRIBUTE9 = @ATTRIBUTE9
				,ATTRIBUTE10 = @ATTRIBUTE10
				,ATTRIBUTE11 = @ATTRIBUTE11
				,ATTRIBUTE12 = @ATTRIBUTE12
				,ATTRIBUTE13 = @ATTRIBUTE13
				,ATTRIBUTE14 = @ATTRIBUTE14
				,ATTRIBUTE15= @ATTRIBUTE15

				WHEN NOT MATCHED THEN
				INSERT (INSTANCE_ID, OPERATION_ID, ACTIVE_FLAG, INSERT_ID, UPDATE_ID, INSERT_TIME, UPDATE_TIME,
				ATTRIBUTE1,
				ATTRIBUTE2,
				ATTRIBUTE3,
				ATTRIBUTE4,
				ATTRIBUTE5,
				ATTRIBUTE6,
				ATTRIBUTE7,
				ATTRIBUTE8,
				ATTRIBUTE9,
				ATTRIBUTE10,
				ATTRIBUTE11,
				ATTRIBUTE12,
				ATTRIBUTE13,
				ATTRIBUTE14,
				ATTRIBUTE15)
				VALUES
				(@p_instance_id, @p_operation_id, 'Y', @p_user_id, @p_user_id, GetDate(),GetDate(),
								@ATTRIBUTE1,
				@ATTRIBUTE2,
				@ATTRIBUTE3,
				@ATTRIBUTE4,
				@ATTRIBUTE5,
				@ATTRIBUTE6,
				@ATTRIBUTE7,
				@ATTRIBUTE8,
				@ATTRIBUTE9,
				@ATTRIBUTE10,
				@ATTRIBUTE11,
				@ATTRIBUTE12,
				@ATTRIBUTE13,
				@ATTRIBUTE14,
				@ATTRIBUTE15);

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

						SELECT @v_sys_type            = [dbo].[SCM_ARR_SPL_VAL](@p_sys_type ,               @v_delimiter, @mst_loop_cnt)
						, @v_sys_flag                 = [dbo].[SCM_ARR_SPL_VAL](@p_sys_flag ,               @v_delimiter, @mst_loop_cnt)
						, @v_sys_gubun                = [dbo].[SCM_ARR_SPL_VAL](@p_sys_gubun ,              @v_delimiter, @mst_loop_cnt)
						, @v_user_id                  = [dbo].[SCM_ARR_SPL_VAL](@p_user_id ,                @v_delimiter, @mst_loop_cnt)
                        , @v_instance_id               = [dbo].[SCM_ARR_SPL_VAL](@p_instance_id ,             @v_delimiter, @mst_loop_cnt)
                        , @v_operation_id             = [dbo].[SCM_ARR_SPL_VAL](@p_operation_id ,           @v_delimiter, @mst_loop_cnt)
                        , @v_setup_category_id        = [dbo].[SCM_ARR_SPL_VAL](@p_setup_category_id ,      @v_delimiter, @mst_loop_cnt)
                        , @v_setup_key_id             = [dbo].[SCM_ARR_SPL_VAL](@p_setup_key_id ,           @v_delimiter, @mst_loop_cnt)
                        , @v_level                    = [dbo].[SCM_ARR_SPL_VAL](@p_level ,                  @v_delimiter, @mst_loop_cnt)
                        , @v_referance_operation_id   = [dbo].[SCM_ARR_SPL_VAL](@p_referance_operation_id , @v_delimiter, @mst_loop_cnt)
                        , @v_calculation              = [dbo].[SCM_ARR_SPL_VAL](@p_calculation ,            @v_delimiter, @mst_loop_cnt)
                        , @v_description              = [dbo].[SCM_ARR_SPL_VAL](@p_description ,            @v_delimiter, @mst_loop_cnt)
                        , @v_line_setup_group_id      = [dbo].[SCM_ARR_SPL_VAL](@p_line_setup_group_id ,    @v_delimiter, @mst_loop_cnt)
                        , @v_org_line_setup_group_id  = [dbo].[SCM_ARR_SPL_VAL](@p_org_line_setup_group_id ,@v_delimiter, @mst_loop_cnt)
					   
					   /****************************************************************************/
					   /* DELETE  경우  :     D(MAIN)                                                   */
					   /****************************************************************************/
					   IF(@v_sys_flag ='D')
						   BEGIN

						        --EXEC  @rtnCount = [dbo].[PR_SCM_UF_ITEM_SETUP_INSERT] @v_company_id, @v_division_id, @v_site_id, @v_operation_id, @v_setup_category_id, @v_setup_key_id;
	
								SELECT @v_dSql1 = ''
						        SELECT @v_dSql1 += ' EXEC [dbo].[PR_SCM_UF_ITEM_SETUP_INSERT_V2] '''+ @v_instance_id + ''', '''+ @v_operation_id +''','''+ @v_setup_category_id +''', '''+@v_setup_key_id +''' ; ' + char(10)
                                SELECT @v_dSql2 = ''
								SELECT @v_dSql2 += ' INSERT INTO HIS_FP_SETUP_MATRIX_M (  ' + char(10)
                                SELECT @v_dSql2 += '    INSTANCE_ID ' + char(10)
                                SELECT @v_dSql2 += '   ,           LINE_SETUP_GROUP_ID,      SETUP_CATEGORY_ID ' + char(10)
                                SELECT @v_dSql2 += '   ,SETUP_KEY_ID,       FROM_ITEM_SETUP_GROUP_ID, TO_ITEM_SETUP_GROUP_ID ' + char(10)
                                SELECT @v_dSql2 += '   , OPERATION_ID,             SETUP_TIME  ' + char(10)
                                SELECT @v_dSql2 += '   ,SETUP_TIME_UOM,     DESCRIPTION ' + char(10)
                                SELECT @v_dSql2 += '   ,INSERT_ID,          INSERT_TIME,              UPDATE_ID   ' + char(10)
                                SELECT @v_dSql2 += '   ,UPDATE_TIME,        JOB_USER_ID,              JOB_TIME    ' + char(10)
                                SELECT @v_dSql2 += '   ,JOB_TYPE ' + char(10)
                                SELECT @v_dSql2 += ' )           ' + char(10)
                                SELECT @v_dSql2 += ' SELECT INSTANCE_ID           ' + char(10)
                                SELECT @v_dSql2 += '       ,LINE_SETUP_GROUP_ID,       SETUP_CATEGORY_ID      ' + char(10)
                                SELECT @v_dSql2 += '       ,SETUP_KEY_ID,       FROM_ITEM_SETUP_GROUP_ID,  TO_ITEM_SETUP_GROUP_ID ' + char(10)
                                SELECT @v_dSql2 += '       , OPERATION_ID,              SETUP_TIME  ' + char(10)
                                SELECT @v_dSql2 += '       ,SETUP_TIME_UOM,     DESCRIPTION ' + char(10)
                                SELECT @v_dSql2 += '       ,INSERT_ID,         INSERT_TIME,                UPDATE_ID   ' + char(10)
                                SELECT @v_dSql2 += '       ,UPDATE_TIME,       '''+ @v_user_id +''',       GETDATE()   ' + char(10)
                                SELECT @v_dSql2 += '       ,''DELETE'' AS JOB_TYPE     ' + char(10)
                                SELECT @v_dSql2 += ' FROM   FP_SETUP_MATRIX_M(NOLOCK) ' + char(10)
                                SELECT @v_dSql2 += ' WHERE  INSTANCE_ID        = '''+ @v_instance_id +'''        ' + char(10)
                                SELECT @v_dSql2 += ' AND    OPERATION_ID      = '''+ @v_operation_id +'''      ' + char(10)
                                SELECT @v_dSql2 += ' AND    SETUP_CATEGORY_ID = '''+ @v_setup_category_id +''' ' + char(10)
                                SELECT @v_dSql2 += ' AND    SETUP_KEY_ID      = '''+ @v_setup_key_id +'''      ' + char(10)
                                SELECT @v_dSql2 += '        ' + char(10)
                                SELECT @v_dSql2 += ' DELETE ' + char(10)
                                SELECT @v_dSql2 += ' FROM   SCM_SETUP_MATRIX_M                                 ' + char(10)
                                SELECT @v_dSql2 += ' WHERE  INSTANCE_ID        = '''+ @v_instance_id +'''        ' + char(10)
                                SELECT @v_dSql2 += ' AND    OPERATION_ID      = '''+ @v_operation_id +'''      ' + char(10)
                                SELECT @v_dSql2 += ' AND    SETUP_CATEGORY_ID = '''+ @v_setup_category_id +''' ' + char(10)
                                SELECT @v_dSql2 += ' AND    SETUP_KEY_ID      = '''+ @v_setup_key_id +'''      ' + char(10)		
								
								SELECT @v_dSql = @v_dSql1 + @v_dSql2

						   END --'D'
					   /******************************************************************************/
					   /* INSERT 경우 : INSERT(DETAIL)                                                 */
					   /******************************************************************************/
					   ELSE IF(@v_sys_flag ='INSERT_SUB')  
							BEGIN
                                SELECT @v_dSql = ''
                                SELECT @v_dSql += ' INSERT INTO fp_line_setup_group_m(                        ' + char(10)
                                SELECT @v_dSql += '    INSTANCE_ID' + char(10)
                                SELECT @v_dSql += '   , OPERATION_ID,        LINE_SETUP_GROUP_ID  ' + char(10)
                                SELECT @v_dSql += '   , DESCRIPTION, INSERT_ID,           INSERT_TIME          ' + char(10)
								SELECT @v_dSql += '   , UPDATE_ID,   UPDATE_TIME                               ' + char(10)
                                SELECT @v_dSql += ' ) VALUES (  ' + char(10)
                                SELECT @v_dSql += '   '''+ @v_instance_id +''' ' + char(10)
                                SELECT @v_dSql += '   , '''+  @v_operation_id +''', N'''+ @v_line_setup_group_id +'''  ' + char(10)
                                SELECT @v_dSql += '   , N'''+ @v_description +''', '''+ @v_user_id +''',     GETDATE()                        ' + char(10)
								SELECT @v_dSql += '   , '''+ @v_user_id +''',     GETDATE()                     ' + char(10)
                                SELECT @v_dSql += ' )  ' + char(10)
                                SELECT @v_dSql += '    ' + char(10)
                                SELECT @v_dSql += ' INSERT INTO his_fp_line_setup_group_m (                     ' + char(10)
                                SELECT @v_dSql += '     INSTANCE_ID   ' + char(10)
                                SELECT @v_dSql += '    , OPERATION_ID,   LINE_SETUP_GROUP_ID    ' + char(10)
                                SELECT @v_dSql += '    , DESCRIPTION, INSERT_ID,      INSERT_TIME            ' + char(10)
								SELECT @v_dSql += '    , UPDATE_ID,   UPDATE_TIME,    JOB_USER_ID            ' + char(10)
                                SELECT @v_dSql += '    , JOB_TIME,    JOB_TYPE                               ' + char(10)
                                SELECT @v_dSql += ' )  ' + char(10)
                                SELECT @v_dSql += ' SELECT INSTANCE_ID     ' + char(10)
                                SELECT @v_dSql += '    , OPERATION_ID,    LINE_SETUP_GROUP_ID ' + char(10)
                                SELECT @v_dSql += '    , DESCRIPTION ,  INSERT_ID,       INSERT_TIME         ' + char(10)
                                SELECT @v_dSql += '    , UPDATE_ID,     UPDATE_TIME ,   '''+ @v_user_id +''' ' + char(10)
								SELECT @v_dSql += '    , GETDATE(),     ''INSERT''                           ' + char(10)
                                SELECT @v_dSql += ' FROM   fp_line_setup_group_m(NOLOCK)                    ' + char(10)
                                SELECT @v_dSql += ' WHERE INSTANCE_ID        = '''+ @v_instance_id +'''        ' + char(10)
                                SELECT @v_dSql += ' AND   OPERATION_ID      = '''+ @v_operation_id +'''      ' + char(10)
                                SELECT @v_dSql += ' AND   LINE_SETUP_GROUP_ID = N'''+ @v_line_setup_group_id +'''  ' + char(10)

						   END --'I'
					   /****************************************************************************/
					   /* UPDATE  경우  :    M(UPDATE_SUB)                                         */
					   /****************************************************************************/
					   ELSE IF(@v_sys_flag ='UPDATE_SUB')
							BEGIN
							    SELECT @v_dSql1 = ''
                                SELECT @v_dSql1 += ' UPDATE scm_line_setup_group_m SET      ' + char(10)
                                SELECT @v_dSql1 += '     update_id   = '''+ @v_user_id +''' ' + char(10)
                                SELECT @v_dSql1 += '    ,update_time = GETDATE()            ' + char(10)
                                SELECT @v_dSql1 += '    ,line_setup_group_id = N'''+ @v_line_setup_group_id +'''   ' + char(10)
                                SELECT @v_dSql1 += ' WHERE COMPANY_ID        = '''+ @v_company_id +'''             ' + char(10)
                                SELECT @v_dSql1 += ' AND   DIVISION_ID       = '''+ @v_division_id +'''            ' + char(10)
                                SELECT @v_dSql1 += ' AND   SITE_ID           = '''+ @v_site_id +'''                ' + char(10)
                                SELECT @v_dSql1 += ' AND   PLANT_ID          = '''+ @v_plant_id +'''               ' + char(10)
                                SELECT @v_dSql1 += ' AND   OPERATION_ID      = '''+ @v_operation_id +'''           ' + char(10)
                                SELECT @v_dSql1 += ' AND   LINE_SETUP_GROUP_ID = N'''+ @v_org_line_setup_group_id +'''  ' + char(10)
                                SELECT @v_dSql1 += '   ' + char(10)
                                SELECT @v_dSql1 += ' INSERT INTO his_line_setup_group_m (                  ' + char(10)
                                SELECT @v_dSql1 += '      COMPANY_ID,   DIVISION_ID,  SITE_ID              ' + char(10)
                                SELECT @v_dSql1 += '     , PLANT_ID,    OPERATION_ID, LINE_SETUP_GROUP_ID  ' + char(10)
                                SELECT @v_dSql1 += '     , DESCRIPTION, INSERT_ID,    INSERT_TIME          ' + char(10)
                                SELECT @v_dSql1 += '     , UPDATE_ID,   UPDATE_TIME,  JOB_USER_ID          ' + char(10)
                                SELECT @v_dSql1 += '     ,JOB_TIME,     JOB_TYPE                           ' + char(10)
                                SELECT @v_dSql1 += ' )  ' + char(10)
                                SELECT @v_dSql1 += ' SELECT COMPANY_ID,   DIVISION_ID,   SITE_ID              ' + char(10)
                                SELECT @v_dSql1 += '       , PLANT_ID,    OPERATION_ID,  LINE_SETUP_GROUP_ID  ' + char(10)
                                SELECT @v_dSql1 += '       , DESCRIPTION, INSERT_ID,     INSERT_TIME          ' + char(10)
                                SELECT @v_dSql1 += '       ,UPDATE_ID,    UPDATE_TIME,  '''+ @v_user_id +'''  ' + char(10)
                                SELECT @v_dSql1 += '       ,GETDATE(),    ''UPDATE''                          ' + char(10)
                                SELECT @v_dSql1 += ' FROM   scm_line_setup_group_m(NOLOCK)                    ' + char(10)
                                SELECT @v_dSql1 += ' WHERE COMPANY_ID        = '''+ @v_company_id +'''        ' + char(10)
                                SELECT @v_dSql1 += ' AND   DIVISION_ID       = '''+ @v_division_id +'''       ' + char(10)
                                SELECT @v_dSql1 += ' AND   SITE_ID           = '''+ @v_site_id +'''           ' + char(10)
                                SELECT @v_dSql1 += ' AND   PLANT_ID          = '''+ @v_plant_id +'''          ' + char(10)
                                SELECT @v_dSql1 += ' AND   OPERATION_ID      = '''+ @v_operation_id +'''      ' + char(10)
                                SELECT @v_dSql1 += ' AND   LINE_SETUP_GROUP_ID = N'''+ @v_line_setup_group_id +'''  ' + char(10)
								SELECT @v_dSql2 = ''
                                SELECT @v_dSql2 += ' UPDATE SCM_SETUP_CONDITION_M SET                             ' + char(10)
                                SELECT @v_dSql2 += '      LINE_SETUP_GROUP_ID = '''+ @v_line_setup_group_id +'''  ' + char(10)
                                SELECT @v_dSql2 += '     ,UPDATE_ID           = '''+ @v_user_id +'''              ' + char(10)
                                SELECT @v_dSql2 += '     ,UPDATE_TIME         = GETDATE()                         ' + char(10)
                                SELECT @v_dSql2 += ' WHERE COMPANY_ID        = '''+ @v_company_id +'''            ' + char(10)
                                SELECT @v_dSql2 += ' AND   DIVISION_ID       = '''+ @v_division_id +'''           ' + char(10)
                                SELECT @v_dSql2 += ' AND   SITE_ID           = '''+ @v_site_id +'''               ' + char(10)
                                SELECT @v_dSql2 += ' AND   PLANT_ID          = '''+ @v_plant_id +'''              ' + char(10)
                                SELECT @v_dSql2 += ' AND   OPERATION_ID      = '''+ @v_operation_id +'''          ' + char(10)
                                SELECT @v_dSql2 += ' AND   LINE_SETUP_GROUP_ID = N'''+ @v_org_line_setup_group_id +''' ' + char(10)
                                SELECT @v_dSql2 += '  ' + char(10)
                                SELECT @v_dSql2 += ' INSERT INTO HIS_SETUP_CONDITION_M (                            ' + char(10)
                                SELECT @v_dSql2 += '     COMPANY_ID,         DIVISION_ID,       SITE_ID             ' + char(10)
                                SELECT @v_dSql2 += '    ,PLANT_ID,           OPERATION_ID,      LINE_SETUP_GROUP_ID ' + char(10)
                                SELECT @v_dSql2 += '    ,SETUP_CATEGORY_ID,  SETUP_KEY_ID,      SETUP_CONDITION_ID  ' + char(10)
                                SELECT @v_dSql2 += '    ,SHOP_GROUP_ID,      SETUP_TIME,        SETUP_TIME_UOM      ' + char(10)
                                SELECT @v_dSql2 += '    ,DESCRIPTION,        INSERT_ID,         INSERT_TIME         ' + char(10)
                                SELECT @v_dSql2 += '    ,UPDATE_ID,          UPDATE_TIME,       JOB_USER_ID         ' + char(10)
                                SELECT @v_dSql2 += '    ,JOB_TIME,           JOB_TYPE ' + char(10)
                                SELECT @v_dSql2 += ' ) ' + char(10)
                                SELECT @v_dSql2 += ' SELECT COMPANY_ID,        DIVISION_ID,   SITE_ID              ' + char(10)
                                SELECT @v_dSql2 += '       ,PLANT_ID,          OPERATION_ID,  LINE_SETUP_GROUP_ID  ' + char(10)
                                SELECT @v_dSql2 += '       ,SETUP_CATEGORY_ID, SETUP_KEY_ID,  SETUP_CONDITION_ID   ' + char(10)
                                SELECT @v_dSql2 += '       ,SHOP_GROUP_ID,     SETUP_TIME,    SETUP_TIME_UOM       ' + char(10)
                                SELECT @v_dSql2 += '       ,DESCRIPTION,       INSERT_ID,     INSERT_TIME          ' + char(10)
                                SELECT @v_dSql2 += '       ,UPDATE_ID,         UPDATE_TIME,  '''+ @v_user_id +'''  ' + char(10)
                                SELECT @v_dSql2 += '       ,GETDATE(),         ''UPDATE'' AS JOB_TYPE              ' + char(10)
                                SELECT @v_dSql2 += ' FROM   SCM_SETUP_CONDITION_M(NOLOCK)                          ' + char(10)
                                SELECT @v_dSql2 += ' WHERE COMPANY_ID        = '''+ @v_company_id +'''             ' + char(10)
                                SELECT @v_dSql2 += ' AND   DIVISION_ID       = '''+ @v_division_id +'''            ' + char(10)
                                SELECT @v_dSql2 += ' AND   SITE_ID           = '''+ @v_site_id +'''                ' + char(10)
                                SELECT @v_dSql2 += ' AND   PLANT_ID          = '''+ @v_plant_id +'''               ' + char(10)
                                SELECT @v_dSql2 += ' AND   OPERATION_ID      = '''+ @v_operation_id +'''           ' + char(10)
                                SELECT @v_dSql2 += ' AND   LINE_SETUP_GROUP_ID = N'''+ @v_line_setup_group_id +''' ' + char(10)
                                SELECT @v_dSql2 += '   ' + char(10)
                                SELECT @v_dSql2 += ' UPDATE SCM_SETUP_MATRIX_M SET                                ' + char(10)
                                SELECT @v_dSql2 += '      LINE_SETUP_GROUP_ID = N'''+ @v_line_setup_group_id +''' ' + char(10)
                                SELECT @v_dSql2 += '     ,UPDATE_ID           = '''+ @v_user_id +'''              ' + char(10)
                                SELECT @v_dSql2 += '     ,UPDATE_TIME         = GETDATE()                         ' + char(10)
                                SELECT @v_dSql2 += ' WHERE COMPANY_ID        = '''+ @v_company_id +'''            ' + char(10)
                                SELECT @v_dSql2 += ' AND   DIVISION_ID       = '''+ @v_division_id +'''           ' + char(10)
                                SELECT @v_dSql2 += ' AND   SITE_ID           = '''+ @v_site_id +'''               ' + char(10)
                                SELECT @v_dSql2 += ' AND   PLANT_ID          = '''+ @v_plant_id +'''              ' + char(10)
                                SELECT @v_dSql2 += ' AND   OPERATION_ID      = '''+ @v_operation_id +'''          ' + char(10)
                                SELECT @v_dSql2 += ' AND   LINE_SETUP_GROUP_ID = N'''+ @v_org_line_setup_group_id +''' ' + char(10)
                                SELECT @v_dSql2 += '   ' + char(10)
                                SELECT @v_dSql2 += ' INSERT INTO HIS_SETUP_MATRIX_M (                                            ' + char(10)
                                SELECT @v_dSql2 += '        COMPANY_ID,         DIVISION_ID,             SITE_ID                 ' + char(10)
                                SELECT @v_dSql2 += '       ,PLANT_ID,           LINE_SETUP_GROUP_ID,     SETUP_CATEGORY_ID       ' + char(10)
                                SELECT @v_dSql2 += '       ,SETUP_KEY_ID,       FROM_ITEM_SETUP_GROUP_ID,TO_ITEM_SETUP_GROUP_ID  ' + char(10)
                                SELECT @v_dSql2 += '       ,SETUP_CONDITION_ID, OPERATION_ID,            SETUP_TIME              ' + char(10)
                                SELECT @v_dSql2 += '       ,SETUP_TIME_UOM,     ADJUST_CELL_QTY,         DESCRIPTION             ' + char(10)
                                SELECT @v_dSql2 += '       ,INSERT_ID,          INSERT_TIME,             UPDATE_ID               ' + char(10)
                                SELECT @v_dSql2 += '       ,UPDATE_TIME,        JOB_USER_ID,             JOB_TIME,   JOB_TYPE    ' + char(10)
                                SELECT @v_dSql2 += ' )  ' + char(10)
                                SELECT @v_dSql2 += ' SELECT COMPANY_ID,         DIVISION_ID,             SITE_ID                 ' + char(10)
                                SELECT @v_dSql2 += '       ,PLANT_ID,           LINE_SETUP_GROUP_ID,     SETUP_CATEGORY_ID       ' + char(10)
                                SELECT @v_dSql2 += '       ,SETUP_KEY_ID,       FROM_ITEM_SETUP_GROUP_ID,TO_ITEM_SETUP_GROUP_ID  ' + char(10)
                                SELECT @v_dSql2 += '       ,SETUP_CONDITION_ID, OPERATION_ID,            SETUP_TIME              ' + char(10)
                                SELECT @v_dSql2 += '       ,SETUP_TIME_UOM,     ADJUST_CELL_QTY,         DESCRIPTION             ' + char(10)
                                SELECT @v_dSql2 += '       ,INSERT_ID,          INSERT_TIME,             UPDATE_ID               ' + char(10)
                                SELECT @v_dSql2 += '       ,UPDATE_TIME,        '''+ @v_user_id +''' ,   GETDATE(),  ''UPDATE''  ' + char(10)
                                SELECT @v_dSql2 += ' FROM  SCM_SETUP_MATRIX_M(NOLOCK)  ' + char(10)
                                SELECT @v_dSql2 += ' WHERE COMPANY_ID        = '''+ @v_company_id +'''             ' + char(10)
                                SELECT @v_dSql2 += ' AND   DIVISION_ID       = '''+ @v_division_id +'''            ' + char(10)
                                SELECT @v_dSql2 += ' AND   SITE_ID           = '''+ @v_site_id +'''                ' + char(10)
                                SELECT @v_dSql2 += ' AND   PLANT_ID          = '''+ @v_plant_id +'''               ' + char(10)
                                SELECT @v_dSql2 += ' AND   OPERATION_ID      = '''+ @v_operation_id +'''           ' + char(10)
                                SELECT @v_dSql2 += ' AND   LINE_SETUP_GROUP_ID = N'''+ @v_line_setup_group_id +''' ' + char(10)
                                SELECT @v_dSql3 = ''
                                SELECT @v_dSql3 += ' UPDATE SCM_LINE_M SET ' + char(10)
                                SELECT @v_dSql3 += '      LINE_SETUP_GROUP_ID = N'''+ @v_line_setup_group_id +''' ' + char(10)
                                SELECT @v_dSql3 += '    , UPDATE_ID           = '''+ @v_user_id +'''              ' + char(10)
                                SELECT @v_dSql3 += '    , UPDATE_TIME         = GETDATE()                         ' + char(10)
                                SELECT @v_dSql3 += ' WHERE COMPANY_ID        = '''+ @v_company_id +'''            ' + char(10)
                                SELECT @v_dSql3 += ' AND   DIVISION_ID       = '''+ @v_division_id +'''           ' + char(10)
                                SELECT @v_dSql3 += ' AND   SITE_ID           = '''+ @v_site_id +'''               ' + char(10)
                                SELECT @v_dSql3 += ' AND   PLANT_ID          = '''+ @v_plant_id +'''              ' + char(10)
                                SELECT @v_dSql3 += ' AND   OPERATION_ID      = '''+ @v_operation_id +'''          ' + char(10)
                                SELECT @v_dSql3 += ' AND   LINE_SETUP_GROUP_ID = N'''+ @v_org_line_setup_group_id +''' ' + char(10)
                                SELECT @v_dSql3 += '  ' + char(10)
                                SELECT @v_dSql3 += ' INSERT INTO HIS_LINE_M ( ' + char(10)
                                SELECT @v_dSql3 += '     COMPANY_ID,      DIVISION_ID,   SITE_ID,            PLANT_ID           ' + char(10)
                                SELECT @v_dSql3 += '    , FACTORY_ID,     OPERATION_ID,  LINE_ID,            LINE_NAME          ' + char(10)
								SELECT @v_dSql3 += '    , ELECTRODE_TYPE, LINE_TYPE,     LINE_SETUP_GROUP_ID,LINE_TYPE_NAME     ' + char(10)
                                SELECT @v_dSql3 += '    , ACTIVE_FLAG,    DESCRIPTION,   INSERT_ID,          INSERT_TIME        ' + char(10)
                                SELECT @v_dSql3 += '    , UPDATE_ID,      UPDATE_TIME,   JOB_USER_ID,        JOB_TIME, JOB_TYPE ' + char(10)
                                SELECT @v_dSql3 += ' ) ' + char(10)
                                SELECT @v_dSql3 += ' SELECT COMPANY_ID,   DIVISION_ID,   SITE_ID,              PLANT_ID         ' + char(10)
                                SELECT @v_dSql3 += '    , FACTORY_ID,     OPERATION_ID,  LINE_ID,              LINE_NAME        ' + char(10)
								SELECT @v_dSql3 += '    , ELECTRODE_TYPE, LINE_TYPE,     LINE_SETUP_GROUP_ID,  LINE_TYPE_NAME   ' + char(10)
                                SELECT @v_dSql3 += '    , ACTIVE_FLAG,    DESCRIPTION,   INSERT_ID,            INSERT_TIME      ' + char(10)
                                SELECT @v_dSql3 += '    ,UPDATE_ID,       UPDATE_TIME,   '''+ @v_user_id +''', GETDATE(), ''UPDATE'' ' + char(10)
                                SELECT @v_dSql3 += ' FROM   SCM_LINE_M(NOLOCK)                                     ' + char(10)
                                SELECT @v_dSql3 += ' WHERE COMPANY_ID        = '''+ @v_company_id +'''             ' + char(10)
                                SELECT @v_dSql3 += ' AND   DIVISION_ID       = '''+ @v_division_id +'''            ' + char(10)
                                SELECT @v_dSql3 += ' AND   SITE_ID           = '''+ @v_site_id +'''                ' + char(10)
                                SELECT @v_dSql3 += ' AND   PLANT_ID          = '''+ @v_plant_id +'''               ' + char(10)
                                SELECT @v_dSql3 += ' AND   OPERATION_ID      = '''+ @v_operation_id +'''           ' + char(10)
                                SELECT @v_dSql3 += ' AND   LINE_SETUP_GROUP_ID = N'''+ @v_line_setup_group_id +''' ' + char(10)

								SELECT @v_dSql = @v_dSql1 + @v_dSql2 +@v_dSql3

                            END --M

					   /****************************************************************************/
					   /* DELETE  경우  :    D(SUB)                                             */
					   /****************************************************************************/
					   ELSE IF(@v_sys_flag ='DELETE_SUB')
							BEGIN
							    SELECT @v_dSql1 = ''
                                SELECT @v_dSql1 += ' INSERT INTO his_line_setup_group_m (                ' + char(10)
                                SELECT @v_dSql1 += '     COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID      ' + char(10)
                                SELECT @v_dSql1 += '    ,OPERATION_ID, LINE_SETUP_GROUP_ID, DESCRIPTION  ' + char(10)
                                SELECT @v_dSql1 += '    ,INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME  ' + char(10)
                                SELECT @v_dSql1 += '    ,JOB_USER_ID,JOB_TIME,JOB_TYPE                   ' + char(10)
                                SELECT @v_dSql1 += ' )  ' + char(10)
                                SELECT @v_dSql1 += ' SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID   ' + char(10)
                                SELECT @v_dSql1 += '    ,OPERATION_ID, LINE_SETUP_GROUP_ID, DESCRIPTION  ' + char(10)
                                SELECT @v_dSql1 += '    ,INSERT_ID,INSERT_TIME,UPDATE_ID,UPDATE_TIME     ' + char(10)
                                SELECT @v_dSql1 += '    ,'''+ @v_user_id +''' ,GETDATE(),''DELETE''      ' + char(10)
                                SELECT @v_dSql1 += ' FROM   scm_line_setup_group_m(NOLOCK)               ' + char(10)
                                SELECT @v_dSql1 += ' WHERE COMPANY_ID        = '''+ @v_company_id +'''   ' + char(10)
                                SELECT @v_dSql1 += ' AND   DIVISION_ID       = '''+ @v_division_id +'''  ' + char(10)
                                SELECT @v_dSql1 += ' AND   SITE_ID           = '''+ @v_site_id +'''      ' + char(10)
                                SELECT @v_dSql1 += ' AND   PLANT_ID          = '''+ @v_plant_id +'''     ' + char(10)
                                SELECT @v_dSql1 += ' AND   OPERATION_ID      = '''+ @v_operation_id +''' ' + char(10)
                                SELECT @v_dSql1 += ' AND   LINE_SETUP_GROUP_ID = N'''+ @v_org_line_setup_group_id +'''  ' + char(10)
                                SELECT @v_dSql1 += '  ' + char(10)
                                SELECT @v_dSql1 += ' DELETE FROM scm_line_setup_group_m                  ' + char(10)
                                SELECT @v_dSql1 += ' WHERE COMPANY_ID        = '''+ @v_company_id +'''   ' + char(10)
                                SELECT @v_dSql1 += ' AND   DIVISION_ID       = '''+ @v_division_id +'''  ' + char(10)
                                SELECT @v_dSql1 += ' AND   SITE_ID           = '''+ @v_site_id +'''      ' + char(10)
                                SELECT @v_dSql1 += ' AND   PLANT_ID          = '''+ @v_plant_id +'''     ' + char(10)
                                SELECT @v_dSql1 += ' AND   OPERATION_ID      = '''+ @v_operation_id +''' ' + char(10)
                                SELECT @v_dSql1 += ' AND   LINE_SETUP_GROUP_ID = N'''+ @v_org_line_setup_group_id +'''  ' + char(10)
                                SELECT @v_dSql1 += '   ' + char(10)
                                SELECT @v_dSql1 += ' INSERT INTO HIS_SETUP_CONDITION_M (  ' + char(10)
                                SELECT @v_dSql1 += '     COMPANY_ID,   DIVISION_ID,         SITE_ID,           PLANT_ID       ' + char(10)
                                SELECT @v_dSql1 += '    ,OPERATION_ID, LINE_SETUP_GROUP_ID, SETUP_CATEGORY_ID, SETUP_KEY_ID   ' + char(10)
                                SELECT @v_dSql1 += '    ,SETUP_CONDITION_ID,SHOP_GROUP_ID,  SETUP_TIME,        SETUP_TIME_UOM ' + char(10)
                                SELECT @v_dSql1 += '    ,DESCRIPTION,  INSERT_ID,           INSERT_TIME,       UPDATE_ID      ' + char(10)
                                SELECT @v_dSql1 += '    ,UPDATE_TIME,  JOB_USER_ID,         JOB_TIME,          JOB_TYPE       ' + char(10)
                                SELECT @v_dSql1 += ' )  ' + char(10)
                                SELECT @v_dSql1 += ' SELECT COMPANY_ID,    DIVISION_ID,        SITE_ID,           PLANT_ID       ' + char(10)
                                SELECT @v_dSql1 += '   ,OPERATION_ID,      LINE_SETUP_GROUP_ID,SETUP_CATEGORY_ID, SETUP_KEY_ID   ' + char(10)
                                SELECT @v_dSql1 += '   ,SETUP_CONDITION_ID,SHOP_GROUP_ID,      SETUP_TIME,        SETUP_TIME_UOM ' + char(10)
                                SELECT @v_dSql1 += '   ,DESCRIPTION,       INSERT_ID,          INSERT_TIME,       UPDATE_ID      ' + char(10)
                                SELECT @v_dSql1 += '   ,UPDATE_TIME,       '''+ @v_user_id +''',GETDATE(),        ''DELETE''     ' + char(10)
                                SELECT @v_dSql1 += ' FROM   SCM_SETUP_CONDITION_M(NOLOCK)                 ' + char(10)
                                SELECT @v_dSql1 += ' WHERE COMPANY_ID        = '''+ @v_company_id +'''    ' + char(10)
                                SELECT @v_dSql1 += ' AND   DIVISION_ID       = '''+ @v_division_id +'''   ' + char(10)
                                SELECT @v_dSql1 += ' AND   SITE_ID           = '''+ @v_site_id +'''       ' + char(10)
                                SELECT @v_dSql1 += ' AND   PLANT_ID          = '''+ @v_plant_id +'''      ' + char(10)
                                SELECT @v_dSql1 += ' AND   OPERATION_ID      = '''+ @v_operation_id +'''  ' + char(10)
                                SELECT @v_dSql1 += ' AND   LINE_SETUP_GROUP_ID = N'''+ @v_org_line_setup_group_id +'''  ' + char(10)
                                SELECT @v_dSql2 = ''
                                SELECT @v_dSql2 += ' DELETE  FROM   SCM_SETUP_CONDITION_M                 ' + char(10)
                                SELECT @v_dSql2 += ' WHERE COMPANY_ID        = '''+ @v_company_id +'''    ' + char(10)
                                SELECT @v_dSql2 += ' AND   DIVISION_ID       = '''+ @v_division_id +'''   ' + char(10)
                                SELECT @v_dSql2 += ' AND   SITE_ID           = '''+ @v_site_id +'''       ' + char(10)
                                SELECT @v_dSql2 += ' AND   PLANT_ID          = '''+ @v_plant_id +'''      ' + char(10)
                                SELECT @v_dSql2 += ' AND   OPERATION_ID      = '''+ @v_operation_id +'''  ' + char(10)
                                SELECT @v_dSql2 += ' AND   LINE_SETUP_GROUP_ID = N'''+ @v_org_line_setup_group_id +'''  ' + char(10)
                                SELECT @v_dSql2 += '  ' + char(10)
                                SELECT @v_dSql2 += ' INSERT INTO HIS_SETUP_MATRIX_M ( ' + char(10)
                                SELECT @v_dSql2 += '     COMPANY_ID,            DIVISION_ID,       SITE_ID,      PLANT_ID     ' + char(10)
                                SELECT @v_dSql2 += '    ,LINE_SETUP_GROUP_ID,   SETUP_CATEGORY_ID, SETUP_KEY_ID, FROM_ITEM_SETUP_GROUP_ID ' + char(10)
                                SELECT @v_dSql2 += '    ,TO_ITEM_SETUP_GROUP_ID,SETUP_CONDITION_ID,OPERATION_ID, SETUP_TIME   ' + char(10)
                                SELECT @v_dSql2 += '    ,SETUP_TIME_UOM,        ADJUST_CELL_QTY,   DESCRIPTION,  INSERT_ID    ' + char(10)
                                SELECT @v_dSql2 += '    ,INSERT_TIME,           UPDATE_ID,         UPDATE_TIME,  JOB_USER_ID  ' + char(10)
                                SELECT @v_dSql2 += '    ,JOB_TIME,JOB_TYPE ' + char(10)
                                SELECT @v_dSql2 += ' ) ' + char(10)
                                SELECT @v_dSql2 += ' SELECT COMPANY_ID,            DIVISION_ID,       SITE_ID,      PLANT_ID                 ' + char(10)
                                SELECT @v_dSql2 += '       ,LINE_SETUP_GROUP_ID,   SETUP_CATEGORY_ID, SETUP_KEY_ID, FROM_ITEM_SETUP_GROUP_ID ' + char(10)
                                SELECT @v_dSql2 += '       ,TO_ITEM_SETUP_GROUP_ID,SETUP_CONDITION_ID,OPERATION_ID, SETUP_TIME               ' + char(10)
                                SELECT @v_dSql2 += '       ,SETUP_TIME_UOM,        ADJUST_CELL_QTY,   DESCRIPTION,  INSERT_ID                ' + char(10)
                                SELECT @v_dSql2 += '       ,INSERT_TIME,           UPDATE_ID,         UPDATE_TIME,  '''+ @v_user_id +'''     ' + char(10)
                                SELECT @v_dSql2 += '       ,GETDATE() ,''DELETE''                        ' + char(10)
                                SELECT @v_dSql2 += ' FROM  SCM_SETUP_MATRIX_M(NOLOCK)                    ' + char(10)
                                SELECT @v_dSql2 += ' WHERE COMPANY_ID        = '''+ @v_company_id +'''   ' + char(10)
                                SELECT @v_dSql2 += ' AND   DIVISION_ID       = '''+ @v_division_id +'''  ' + char(10)
                                SELECT @v_dSql2 += ' AND   SITE_ID           = '''+ @v_site_id +'''      ' + char(10)
                                SELECT @v_dSql2 += ' AND   PLANT_ID          = '''+ @v_plant_id +'''     ' + char(10)
                                SELECT @v_dSql2 += ' AND   OPERATION_ID      = '''+ @v_operation_id +''' ' + char(10)
                                SELECT @v_dSql2 += ' AND   LINE_SETUP_GROUP_ID = N'''+ @v_org_line_setup_group_id +'''  ' + char(10)
                                SELECT @v_dSql2 += '  ' + char(10)
                                SELECT @v_dSql2 += ' DELETE   FROM   SCM_SETUP_MATRIX_M                  ' + char(10)
                                SELECT @v_dSql2 += ' WHERE COMPANY_ID        = '''+ @v_company_id +'''   ' + char(10)
                                SELECT @v_dSql2 += ' AND   DIVISION_ID       = '''+ @v_division_id +'''  ' + char(10)
                                SELECT @v_dSql2 += ' AND   SITE_ID           = '''+ @v_site_id +'''      ' + char(10)
                                SELECT @v_dSql2 += ' AND   PLANT_ID          = '''+ @v_plant_id +'''     ' + char(10)
                                SELECT @v_dSql2 += ' AND   OPERATION_ID      = '''+ @v_operation_id +''' ' + char(10)
                                SELECT @v_dSql2 += ' AND   LINE_SETUP_GROUP_ID = N'''+ @v_line_setup_group_id +'''  ' + char(10)
                                SELECT @v_dSql2 += '  ' + char(10)
                                SELECT @v_dSql2 += ' UPDATE SCM_LINE_M SET                               ' + char(10)
                                SELECT @v_dSql2 += '        LINE_SETUP_GROUP_ID = null                   ' + char(10)
                                SELECT @v_dSql2 += '       ,UPDATE_ID           = '''+ @v_user_id +'''   ' + char(10)
                                SELECT @v_dSql2 += '       ,UPDATE_TIME         = GETDATE()              ' + char(10)
                                SELECT @v_dSql2 += ' WHERE COMPANY_ID        = '''+ @v_company_id +'''   ' + char(10)
                                SELECT @v_dSql2 += ' AND   DIVISION_ID       = '''+ @v_division_id +'''  ' + char(10)
                                SELECT @v_dSql2 += ' AND   SITE_ID           = '''+ @v_site_id +'''      ' + char(10)
                                SELECT @v_dSql2 += ' AND   PLANT_ID          = '''+ @v_plant_id +'''     ' + char(10)
                                SELECT @v_dSql2 += ' AND   OPERATION_ID      = '''+ @v_operation_id +''' ' + char(10)
                                SELECT @v_dSql2 += ' AND   LINE_SETUP_GROUP_ID = N'''+ @v_org_line_setup_group_id +'''  ' + char(10)
                                SELECT @v_dSql2 += '   ' + char(10)
                                SELECT @v_dSql2 += ' INSERT INTO HIS_LINE_M ( ' + char(10)
                                SELECT @v_dSql2 += '      COMPANY_ID,     DIVISION_ID,  SITE_ID,             PLANT_ID       ' + char(10)
                                SELECT @v_dSql2 += '    , FACTORY_ID,     OPERATION_ID, LINE_ID,             LINE_NAME      ' + char(10)
								SELECT @v_dSql2 += '    , ELECTRODE_TYPE, LINE_TYPE,    LINE_SETUP_GROUP_ID, LINE_TYPE_NAME ' + char(10)
                                SELECT @v_dSql2 += '    , ACTIVE_FLAG,    DESCRIPTION,  INSERT_ID,           INSERT_TIME    ' + char(10)
                                SELECT @v_dSql2 += '    , UPDATE_ID,      UPDATE_TIME,  JOB_USER_ID,  JOB_TIME, JOB_TYPE    ' + char(10)
                                SELECT @v_dSql2 += ' ) ' + char(10)
                                SELECT @v_dSql2 += ' SELECT COMPANY_ID,   DIVISION_ID,  SITE_ID,             PLANT_ID       ' + char(10)
                                SELECT @v_dSql2 += '    , FACTORY_ID,     OPERATION_ID, LINE_ID,             LINE_NAME      ' + char(10)
								SELECT @v_dSql2 += '    , ELECTRODE_TYPE, LINE_TYPE,    LINE_SETUP_GROUP_ID, LINE_TYPE_NAME ' + char(10)
                                SELECT @v_dSql2 += '    , ACTIVE_FLAG,    DESCRIPTION,  INSERT_ID,           INSERT_TIME    ' + char(10)
                                SELECT @v_dSql2 += '    , UPDATE_ID,      UPDATE_TIME,'''+ @v_user_id +''', GETDATE(), ''UPDATE'' ' + char(10)
                                SELECT @v_dSql2 += ' FROM   SCM_LINE_M(NOLOCK)                           ' + char(10)
                                SELECT @v_dSql2 += ' WHERE COMPANY_ID        = '''+ @v_company_id +'''   ' + char(10)
                                SELECT @v_dSql2 += ' AND   DIVISION_ID       = '''+ @v_division_id +'''  ' + char(10)
                                SELECT @v_dSql2 += ' AND   SITE_ID           = '''+ @v_site_id +'''      ' + char(10)
                                SELECT @v_dSql2 += ' AND   PLANT_ID          = '''+ @v_plant_id +'''     ' + char(10)
                                SELECT @v_dSql2 += ' AND   OPERATION_ID      = '''+ @v_operation_id +''' ' + char(10)
                                SELECT @v_dSql2 += ' AND   LINE_SETUP_GROUP_ID = N'''+ @v_org_line_setup_group_id +'''  ' + char(10)

								SELECT @v_dSql = @v_dSql1 + @v_dSql2

                            END --M

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
							EXEC PR_UI_SQL_LOG  @v_proc_name,  @v_user_id,'','', @v_dSql,'SELECT',@runstart, @runend
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

