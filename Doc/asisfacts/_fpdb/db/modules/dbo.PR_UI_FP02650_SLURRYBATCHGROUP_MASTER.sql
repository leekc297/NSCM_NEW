

/*
 * Program ID   : PR_UI_FP02650_SLURRYBATCHGROUP_MASTER
 * Description  : Shipping Plan
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/04/06   JYJ				Initial Release UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FP02650_SLURRYBATCHGROUP_MASTER]
  @p_sys_type                   NVARCHAR(MAX),
  @p_sys_flag                   NVARCHAR(MAX),
  @p_sys_gubun                  NVARCHAR(MAX),
  @p_user_id                    NVARCHAR(MAX),
  @p_company_id                 NVARCHAR(MAX),
  @p_division_id                NVARCHAR(MAX),
  @p_site_id                    NVARCHAR(MAX),
  @p_plant_id                   NVARCHAR(MAX),
  @p_batch_ratio_id             NVARCHAR(MAX),
  @p_description                NVARCHAR(MAX),
  @p_parent_item_id             NVARCHAR(MAX),
  @p_nick_name                  NVARCHAR(MAX),
  @p_parent_item_class          NVARCHAR(MAX),
  @p_material_1                 NVARCHAR(MAX),
  @p_level_name_1               NVARCHAR(MAX),
  @p_input_rate_1               NVARCHAR(MAX),
  @p_material_2                 NVARCHAR(MAX),
  @p_level_name_2               NVARCHAR(MAX),
  @p_input_rate_2               NVARCHAR(MAX),
  @p_material_3                 NVARCHAR(MAX),
  @p_level_name_3               NVARCHAR(MAX),
  @p_input_rate_3               NVARCHAR(MAX),
  @p_material_4                 NVARCHAR(MAX),
  @p_level_name_4               NVARCHAR(MAX),
  @p_input_rate_4               NVARCHAR(MAX),
  @p_material_5                 NVARCHAR(MAX),
  @p_level_name_5               NVARCHAR(MAX),
  @p_input_rate_5               NVARCHAR(MAX),
  @p_material_6                 NVARCHAR(MAX),
  @p_level_name_6               NVARCHAR(MAX),
  @p_input_rate_6               NVARCHAR(MAX),
  @p_material_7                 NVARCHAR(MAX),
  @p_level_name_7               NVARCHAR(MAX),
  @p_input_rate_7               NVARCHAR(MAX),
  @p_material_8                 NVARCHAR(MAX),
  @p_level_name_8               NVARCHAR(MAX),
  @p_input_rate_8               NVARCHAR(MAX),
  @p_material_9                 NVARCHAR(MAX),
  @p_level_name_9               NVARCHAR(MAX),
  @p_input_rate_9               NVARCHAR(MAX),
  @p_material_10                NVARCHAR(MAX),
  @p_level_name_10              NVARCHAR(MAX),
  @p_input_rate_10              NVARCHAR(MAX)


AS 
BEGIN  --MAIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
    SET NOCOUNT ON                                                                                                                                                                                                                                                   
	SET XACT_ABORT ON 

	DECLARE @v_sys_type                   NVARCHAR(MAX)  -- 값>> SELEC: SQL저장안함, SQL:SQL저장함
	DECLARE @v_sys_flag                   NVARCHAR(MAX)  -- 값>> I: Insert, M: Update, D: Delete, G: MERGE
	DECLARE @v_sys_gubun                  NVARCHAR(MAX) 
	DECLARE @v_user_id                    NVARCHAR(MAX)
	DECLARE @v_company_id                 NVARCHAR(MAX)
    DECLARE @v_division_id                NVARCHAR(MAX)
    DECLARE @v_site_id                    NVARCHAR(MAX)
    DECLARE @v_plant_id                   NVARCHAR(MAX)
    DECLARE @v_batch_ratio_id             NVARCHAR(MAX)
    DECLARE @v_description                NVARCHAR(MAX)
    DECLARE @v_parent_item_id             NVARCHAR(MAX)
    DECLARE @v_nick_name                  NVARCHAR(MAX)
    DECLARE @v_parent_item_class          NVARCHAR(MAX)
    DECLARE @v_material_1                 NVARCHAR(MAX)
    DECLARE @v_level_name_1               NVARCHAR(MAX)
    DECLARE @v_input_rate_1               NVARCHAR(MAX)
    DECLARE @v_material_2                 NVARCHAR(MAX)
    DECLARE @v_level_name_2               NVARCHAR(MAX)
    DECLARE @v_input_rate_2               NVARCHAR(MAX)
    DECLARE @v_material_3                 NVARCHAR(MAX)
    DECLARE @v_level_name_3               NVARCHAR(MAX)
    DECLARE @v_input_rate_3               NVARCHAR(MAX)
    DECLARE @v_material_4                 NVARCHAR(MAX)
    DECLARE @v_level_name_4               NVARCHAR(MAX)
    DECLARE @v_input_rate_4               NVARCHAR(MAX)
    DECLARE @v_material_5                 NVARCHAR(MAX)
    DECLARE @v_level_name_5               NVARCHAR(MAX)
    DECLARE @v_input_rate_5               NVARCHAR(MAX)
    DECLARE @v_material_6                 NVARCHAR(MAX)
    DECLARE @v_level_name_6               NVARCHAR(MAX)
    DECLARE @v_input_rate_6               NVARCHAR(MAX)
    DECLARE @v_material_7                 NVARCHAR(MAX)
    DECLARE @v_level_name_7               NVARCHAR(MAX)
    DECLARE @v_input_rate_7               NVARCHAR(MAX)
    DECLARE @v_material_8                 NVARCHAR(MAX)
    DECLARE @v_level_name_8               NVARCHAR(MAX)
    DECLARE @v_input_rate_8               NVARCHAR(MAX)
    DECLARE @v_material_9                 NVARCHAR(MAX)
    DECLARE @v_level_name_9               NVARCHAR(MAX)
    DECLARE @v_input_rate_9               NVARCHAR(MAX)
    DECLARE @v_material_10                NVARCHAR(MAX)
    DECLARE @v_level_name_10              NVARCHAR(MAX)
    DECLARE @v_input_rate_10              NVARCHAR(MAX)

	DECLARE @recv_active_flag       NVARCHAR(MAX)				    
	DECLARE @v_proc_name	        NVARCHAR(100) = 'PR_UI_FP02650_SLURRYBATCHGROUP_MASTER'
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

	SET @v_sys_type                 = ''
	SET @v_sys_flag                 = ''
	SET @v_sys_gubun                = ''
	SET @v_user_id                  = ''
	SET @v_company_id              = ''
    SET @v_division_id             = ''
    SET @v_site_id                 = ''
    SET @v_plant_id                = ''
    SET @v_batch_ratio_id          = ''
    SET @v_description             = ''
    SET @v_parent_item_id          = ''
    SET @v_nick_name               = ''
    SET @v_parent_item_class       = ''
    SET @v_material_1              = ''
    SET @v_level_name_1            = ''
    SET @v_input_rate_1            = ''
    SET @v_material_2              = ''
    SET @v_level_name_2            = ''
    SET @v_input_rate_2            = ''
    SET @v_material_3              = ''
    SET @v_level_name_3            = ''
    SET @v_input_rate_3            = ''
    SET @v_material_4              = ''
    SET @v_level_name_4            = ''
    SET @v_input_rate_4            = ''
    SET @v_material_5              = ''
    SET @v_level_name_5            = ''
    SET @v_input_rate_5            = ''
    SET @v_material_6              = ''
    SET @v_level_name_6            = ''
    SET @v_input_rate_6            = ''
    SET @v_material_7              = ''
    SET @v_level_name_7            = ''
    SET @v_input_rate_7            = ''
    SET @v_material_8              = ''
    SET @v_level_name_8            = ''
    SET @v_input_rate_8            = ''
    SET @v_material_9              = ''
    SET @v_level_name_9            = ''
    SET @v_input_rate_9            = ''
    SET @v_material_10             = ''
    SET @v_level_name_10           = ''
    SET @v_input_rate_10           = ''

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
		    SELECT @v_dSql1 = ''
            SELECT @v_dSql1 += ' SELECT ''0'' AS CHK,  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID                                         ' + char(10)
            SELECT @v_dSql1 += '   , A.PLANT_ID, C.BATCH_ID AS BATCH_RATIO_ID, C.DESCRIPTION                                          ' + char(10)
            SELECT @v_dSql1 += '   , A.PARENT_ITEM_ID, ISNULL(D.NICK_NAME, ''-'') AS NICK_NAME                                        ' + char(10)
            SELECT @v_dSql1 += '   , A.PARENT_ITEM_CLASS_NAME,A.MATERIAL_1,A.LEVEL_NAME_1,A.INPUT_RATE_1                              ' + char(10)
            SELECT @v_dSql1 += '   , A.MATERIAL_2,A.LEVEL_NAME_2,A.INPUT_RATE_2                                                       ' + char(10)
            SELECT @v_dSql1 += '   , A.MATERIAL_3,A.LEVEL_NAME_3,A.INPUT_RATE_3                                                       ' + char(10)
            SELECT @v_dSql1 += '   , A.MATERIAL_4,A.LEVEL_NAME_4,A.INPUT_RATE_4                                                       ' + char(10)
            SELECT @v_dSql1 += '   , A.MATERIAL_5,A.LEVEL_NAME_5,A.INPUT_RATE_5                                                       ' + char(10)
            SELECT @v_dSql1 += '   , A.MATERIAL_6,A.LEVEL_NAME_6,A.INPUT_RATE_6                                                       ' + char(10)
            SELECT @v_dSql1 += '   , A.MATERIAL_7,A.LEVEL_NAME_7,A.INPUT_RATE_7                                                       ' + char(10)
            SELECT @v_dSql1 += '   , A.MATERIAL_8,A.LEVEL_NAME_8,A.INPUT_RATE_8                                                       ' + char(10)
            SELECT @v_dSql1 += '   , A.MATERIAL_9,A.LEVEL_NAME_9,A.INPUT_RATE_9                                                       ' + char(10)
            SELECT @v_dSql1 += '   , A.MATERIAL_10,A.LEVEL_NAME_10,A.INPUT_RATE_10                                                    ' + char(10)
            SELECT @v_dSql1 += '   , DENSE_RANK( ) OVER( ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                  ' + char(10)
            SELECT @v_dSql1 += '        , A.MATERIAL_1, A.MATERIAL_2, A.MATERIAL_3, A.MATERIAL_4, A.MATERIAL_5                        ' + char(10)
            SELECT @v_dSql1 += '        , A.MATERIAL_6, A.MATERIAL_7, A.MATERIAL_8, A.MATERIAL_9, A.MATERIAL_10 ) AS ROW_NUM          ' + char(10)
            SELECT @v_dSql1 += '   ,(DENSE_RANK( ) OVER( ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                  ' + char(10)
            SELECT @v_dSql1 += '        , A.MATERIAL_1, A.MATERIAL_2, A.MATERIAL_3, A.MATERIAL_4, A.MATERIAL_5                        ' + char(10)
            SELECT @v_dSql1 += '        , A.MATERIAL_6, A.MATERIAL_7, A.MATERIAL_8, A.MATERIAL_9, A.MATERIAL_10 ))%2 AS BACK_ROW_NUM  ' + char(10)
            SELECT @v_dSql1 += '   ,(CASE WHEN R.PLANT_ID IS NULL THEN ''N'' ELSE ''Y'' END) AS EDIT_YN                               ' + char(10)
            SELECT @v_dSql1 += ' FROM   SCM_SLURRY_RATE_V A WITH(NOLOCK)                                                              ' + char(10)
            SELECT @v_dSql1 += ' LEFT OUTER JOIN (                                                                                    ' + char(10)
            SELECT @v_dSql1 += '     SELECT A.*, B.DESCRIPTION                                                                        ' + char(10)
            SELECT @v_dSql1 += '     FROM   SCM_BATCH_M A WITH(NOLOCK)                                                                ' + char(10)
            SELECT @v_dSql1 += '     LEFT OUTER JOIN SCM_MATERIAL_RATIO_M B WITH(NOLOCK)                                              ' + char(10)
            SELECT @v_dSql1 += '     ON  A.COMPANY_ID  = B.COMPANY_ID                                                                 ' + char(10)
            SELECT @v_dSql1 += '     AND A.DIVISION_ID = B.DIVISION_ID                                                                ' + char(10)
            SELECT @v_dSql1 += '     AND A.SITE_ID     = B.SITE_ID                                                                    ' + char(10)
            SELECT @v_dSql1 += '     AND A.PLANT_ID    = B.PLANT_ID                                                                   ' + char(10)
            SELECT @v_dSql1 += '     AND A.BATCH_ID    = B.RATIO_ID                                                                   ' + char(10)
            SELECT @v_dSql1 += ' ) C                                                                                                  ' + char(10)
			SELECT @v_dSql2 = ''
            SELECT @v_dSql2 += ' ON     A.COMPANY_ID     = C.COMPANY_ID                                                               ' + char(10)
            SELECT @v_dSql2 += ' AND    A.DIVISION_ID    = C.DIVISION_ID                                                              ' + char(10)
            SELECT @v_dSql2 += ' AND    A.SITE_ID        = C.SITE_ID                                                                  ' + char(10)
            SELECT @v_dSql2 += ' AND    A.PLANT_ID       = C.PLANT_ID                                                                 ' + char(10)
            SELECT @v_dSql2 += ' AND    A.PARENT_ITEM_ID = C.ITEM_ID                                                                  ' + char(10)
            SELECT @v_dSql2 += ' INNER JOIN SCM_ITEM_M D WITH(NOLOCK)                                                                 ' + char(10)
            SELECT @v_dSql2 += ' ON     A.COMPANY_ID     = D.COMPANY_ID                                                               ' + char(10)
            SELECT @v_dSql2 += ' AND    A.DIVISION_ID    = D.DIVISION_ID                                                              ' + char(10)
            SELECT @v_dSql2 += ' AND    A.SITE_ID        = D.SITE_ID                                                                  ' + char(10)
            SELECT @v_dSql2 += ' AND    A.PARENT_ITEM_ID = D.ITEM_ID                                                                  ' + char(10)
            SELECT @v_dSql2 += ' LEFT OUTER JOIN (                                                                                    ' + char(10)
            SELECT @v_dSql2 += '     SELECT DISTINCT R.COMPANY_ID, R.DIVISION_ID                                                      ' + char(10)
            SELECT @v_dSql2 += '         , R.SITE_ID, R.PLANT_ID                                                                      ' + char(10)
            SELECT @v_dSql2 += '     FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK)                                                        ' + char(10)
            SELECT @v_dSql2 += '     WHERE  R.USER_ID   = '''+ @p_user_id +'''                                                        ' + char(10)
            SELECT @v_dSql2 += '     AND    R.SAVE_FLAG = ''Y''                                                                       ' + char(10)
            SELECT @v_dSql2 += ' ) R                                                                                                  ' + char(10)
            SELECT @v_dSql2 += ' ON   A.COMPANY_ID   = R.COMPANY_ID                                                                   ' + char(10)
            SELECT @v_dSql2 += ' AND  A.DIVISION_ID  = R.DIVISION_ID                                                                  ' + char(10)
            SELECT @v_dSql2 += ' AND  A.SITE_ID      = R.SITE_ID                                                                      ' + char(10)
            SELECT @v_dSql2 += ' AND  A.PLANT_ID     = R.PLANT_ID                                                                     ' + char(10)
            SELECT @v_dSql2 += ' WHERE  D.ACTIVE_FLAG = ''Y''                                                                         ' + char(10)
            SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))                          + char(10)
            SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))                                  + char(10)
            SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))                                + char(10)
            SELECT @v_dSql2 += ' AND ISNULL(A.PARENT_ITEM_ID , '''') LIKE ''%'' + '''+ @p_parent_item_id +'''  + ''%''                  ' + char(10)
            SELECT @v_dSql2 += ' AND ISNULL(D.NICK_NAME , '''') LIKE ''%'' + RTRIM(LTRIM('''+ @p_nick_name +''' )) + ''%''              ' + char(10)
            SELECT @v_dSql2 += ' ORDER BY ROW_NUM, A.PARENT_ITEM_ID                                                                   ' + char(10)

			SELECT @v_dSql = @v_dSql1 + @v_dSql2

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
	/* SELECT인경우 :SELECT(BATCH)                                                                      */
	/************************************************************************************************/
	IF(@p_sys_flag ='SELECT_SUB')
		BEGIN --IF(START)
            SELECT @v_dSql = ''
            SELECT @v_dSql += ' SELECT '''+ @p_company_id +''' AS COMPANY_ID      ' + char(10)
            SELECT @v_dSql += '   , '''+ @p_division_id +''' AS DIVISION_ID       ' + char(10)
            SELECT @v_dSql += '   , '''+ @p_site_id +''' AS SITE_ID               ' + char(10)
            SELECT @v_dSql += '   , '''+ @p_plant_id +''' AS PLANT_ID             ' + char(10)
            SELECT @v_dSql += '   , ''-'' AS RATIO_ID                             ' + char(10)
            SELECT @v_dSql += '   , ''[New Batch]'' AS RATIO_NAME               ' + char(10)
            SELECT @v_dSql += '   , '''' AS DESCRIPTION                           ' + char(10)
            SELECT @v_dSql += '   , 1 AS SORT_ORDER                               ' + char(10)
            SELECT @v_dSql += ' UNION ALL                                         ' + char(10)
            SELECT @v_dSql += ' SELECT A.COMPANY_ID                               ' + char(10)
            SELECT @v_dSql += '   , A.DIVISION_ID                                 ' + char(10)
            SELECT @v_dSql += '   , A.SITE_ID                                     ' + char(10)
            SELECT @v_dSql += '   , A.PLANT_ID                                    ' + char(10)
            SELECT @v_dSql += '   , A.RATIO_ID                                    ' + char(10)
            SELECT @v_dSql += '   , A.RATIO_ID AS RATIO_NAME                      ' + char(10)
            SELECT @v_dSql += '   , A.DESCRIPTION                                 ' + char(10)
            SELECT @v_dSql += '   , 2 AS SORT_ORDER                               ' + char(10)
            SELECT @v_dSql += ' FROM   SCM_MATERIAL_RATIO_M A(NOLOCK)             ' + char(10)
            SELECT @v_dSql += ' WHERE  A.COMPANY_ID  =  '''+ @p_company_id +'''   ' + char(10)
            SELECT @v_dSql += ' AND    A.DIVISION_ID =  '''+ @p_division_id +'''  ' + char(10)
            SELECT @v_dSql += ' AND    A.SITE_ID     =  '''+ @p_site_id +'''      ' + char(10)
            SELECT @v_dSql += ' AND    A.PLANT_ID    =  '''+ @p_plant_id +'''     ' + char(10)
            SELECT @v_dSql += ' ORDER BY SORT_ORDER, RATIO_ID                     ' + char(10)

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
	/* SELECT인경우 :SELECT(SELECT_BY_RATIO)                                                        */
	/************************************************************************************************/
	IF(@p_sys_flag ='SELECT_BY_RATIO')
		BEGIN --IF(START)
            SELECT @v_dSql = ''
            SELECT @v_dSql += ' SELECT ''0'' AS CHK,  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID                                 ' + char(10)
            SELECT @v_dSql += '   , A.PLANT_ID, B.BATCH_ID AS BATCH_RATIO_ID, B.DESCRIPTION                                  ' + char(10)
            SELECT @v_dSql += '   , A.PARENT_ITEM_ID, ISNULL(C.NICK_NAME, ''-'') AS NICK_NAME                                ' + char(10)
            SELECT @v_dSql += '   , A.PARENT_ITEM_CLASS_NAME,A.MATERIAL_1,A.LEVEL_NAME_1,A.INPUT_RATE_1                      ' + char(10)
            SELECT @v_dSql += '   , A.MATERIAL_2,A.LEVEL_NAME_2,A.INPUT_RATE_2                                               ' + char(10)
            SELECT @v_dSql += '   , A.MATERIAL_3,A.LEVEL_NAME_3,A.INPUT_RATE_3                                               ' + char(10)
            SELECT @v_dSql += '   , A.MATERIAL_4,A.LEVEL_NAME_4,A.INPUT_RATE_4                                               ' + char(10)
            SELECT @v_dSql += '   , A.MATERIAL_5,A.LEVEL_NAME_5,A.INPUT_RATE_5                                               ' + char(10)
            SELECT @v_dSql += '   , A.MATERIAL_6,A.LEVEL_NAME_6,A.INPUT_RATE_6                                               ' + char(10)
            SELECT @v_dSql += '   , A.MATERIAL_7,A.LEVEL_NAME_7,A.INPUT_RATE_7                                               ' + char(10)
            SELECT @v_dSql += '   , A.MATERIAL_8,A.LEVEL_NAME_8,A.INPUT_RATE_8                                               ' + char(10)
            SELECT @v_dSql += '   , A.MATERIAL_9,A.LEVEL_NAME_9,A.INPUT_RATE_9                                               ' + char(10)
            SELECT @v_dSql += '   , A.MATERIAL_10,A.LEVEL_NAME_10,A.INPUT_RATE_10                                            ' + char(10)
            SELECT @v_dSql += '   , DENSE_RANK( ) OVER( ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID          ' + char(10)
            SELECT @v_dSql += '        , A.MATERIAL_1, A.MATERIAL_2, A.MATERIAL_3, A.MATERIAL_4, A.MATERIAL_5                ' + char(10)
            SELECT @v_dSql += '        , A.MATERIAL_6, A.MATERIAL_7, A.MATERIAL_8, A.MATERIAL_9, A.MATERIAL_10 ) AS ROW_NUM  ' + char(10)
            SELECT @v_dSql += '   ,(DENSE_RANK( ) OVER( ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                  ' + char(10)
            SELECT @v_dSql += '        , A.MATERIAL_1, A.MATERIAL_2, A.MATERIAL_3, A.MATERIAL_4, A.MATERIAL_5                        ' + char(10)
            SELECT @v_dSql += '        , A.MATERIAL_6, A.MATERIAL_7, A.MATERIAL_8, A.MATERIAL_9, A.MATERIAL_10 ))%2 AS BACK_ROW_NUM  ' + char(10)
			SELECT @v_dSql += '   ,(CASE WHEN A.PLANT_ID IS NULL THEN ''N'' ELSE ''Y'' END) AS EDIT_YN                       ' + char(10)
            SELECT @v_dSql += ' FROM  SCM_SLURRY_RATE_V A(NOLOCK)                                                            ' + char(10)
            SELECT @v_dSql += ' LEFT OUTER JOIN (                                                                            ' + char(10)
            SELECT @v_dSql += '     SELECT A.*, B.DESCRIPTION                                                                ' + char(10)
            SELECT @v_dSql += '     FROM   SCM_BATCH_M A WITH(NOLOCK)                                                        ' + char(10)
            SELECT @v_dSql += '     LEFT OUTER JOIN SCM_MATERIAL_RATIO_M B WITH(NOLOCK)                                      ' + char(10)
            SELECT @v_dSql += '     ON  A.COMPANY_ID  = B.COMPANY_ID                                                         ' + char(10)
            SELECT @v_dSql += '     AND A.DIVISION_ID = B.DIVISION_ID                                                        ' + char(10)
            SELECT @v_dSql += '     AND A.SITE_ID     = B.SITE_ID                                                            ' + char(10)
            SELECT @v_dSql += '     AND A.PLANT_ID    = B.PLANT_ID                                                           ' + char(10)
            SELECT @v_dSql += '     AND A.BATCH_ID    = B.RATIO_ID                                                           ' + char(10)
            SELECT @v_dSql += ' ) B                                                                                          ' + char(10)
            SELECT @v_dSql += ' ON    A.COMPANY_ID      = A.COMPANY_ID                                                       ' + char(10)
            SELECT @v_dSql += ' AND   A.DIVISION_ID     = B.DIVISION_ID                                                      ' + char(10)
            SELECT @v_dSql += ' AND   A.SITE_ID         = B.SITE_ID                                                          ' + char(10)
            SELECT @v_dSql += ' AND   A.PLANT_ID        = B.PLANT_ID                                                         ' + char(10)
            SELECT @v_dSql += ' AND   A.PARENT_ITEM_ID  = B.ITEM_ID                                                          ' + char(10)
            SELECT @v_dSql += ' LEFT OUTER JOIN SCM_ITEM_M C WITH(NOLOCK)                                                    ' + char(10)
            SELECT @v_dSql += ' ON    A.COMPANY_ID      = C.COMPANY_ID                                                       ' + char(10)
            SELECT @v_dSql += ' AND   A.DIVISION_ID     = C.DIVISION_ID                                                      ' + char(10)
            SELECT @v_dSql += ' AND   A.SITE_ID         = C.SITE_ID                                                          ' + char(10)
            SELECT @v_dSql += ' AND   A.PARENT_ITEM_ID  = C.ITEM_ID                                                          ' + char(10)
            SELECT @v_dSql += ' WHERE  A.COMPANY_ID  =  '''+ @p_company_id +'''                                              ' + char(10)
            SELECT @v_dSql += ' AND    A.DIVISION_ID =  '''+ @p_division_id +'''                                             ' + char(10)
            SELECT @v_dSql += ' AND    A.SITE_ID     =  '''+ @p_site_id +'''                                                 ' + char(10)
            SELECT @v_dSql += ' AND    A.PLANT_ID    =  '''+ @p_plant_id +'''                                                ' + char(10)
            SELECT @v_dSql += ' AND   B.BATCH_ID     =  '''+ @p_batch_ratio_id +'''                                          ' + char(10)
            SELECT @v_dSql += ' ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.MATERIAL_1  ' + char(10)

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

	ELSE
		-- 트랜잭션 (TRAN)
		BEGIN TRY				                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
		BEGIN TRAN   

		BEGIN --ELSE ( BEGIN )
		    --max_loop_cnt:전체 Row수 , mst_loop_cnt:1씩 증가시켜서 전체 Row수 까지만 로직을 수행
			WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
			    BEGIN --WHILE 내(START)
					 
						SELECT @mst_loop_cnt = @mst_loop_cnt + 1	-- @mst_loop_cnt 1증가

						SELECT @v_sys_type       = [dbo].[SCM_ARR_SPL_VAL](@p_sys_type ,@v_delimiter, @mst_loop_cnt)
						, @v_sys_flag            = [dbo].[SCM_ARR_SPL_VAL](@p_sys_flag ,@v_delimiter, @mst_loop_cnt)
						, @v_sys_gubun           = [dbo].[SCM_ARR_SPL_VAL](@p_sys_gubun ,@v_delimiter, @mst_loop_cnt)
						, @v_user_id             = [dbo].[SCM_ARR_SPL_VAL](@p_user_id ,@v_delimiter, @mst_loop_cnt)
						, @v_company_id          = [dbo].[SCM_ARR_SPL_VAL](@p_company_id ,@v_delimiter, @mst_loop_cnt)
						, @v_division_id         = [dbo].[SCM_ARR_SPL_VAL](@p_division_id ,@v_delimiter, @mst_loop_cnt)
						, @v_site_id             = [dbo].[SCM_ARR_SPL_VAL](@p_site_id ,@v_delimiter, @mst_loop_cnt)
						, @v_plant_id            = [dbo].[SCM_ARR_SPL_VAL](@p_plant_id ,@v_delimiter, @mst_loop_cnt)
						, @v_batch_ratio_id      = [dbo].[SCM_ARR_SPL_VAL](@p_batch_ratio_id ,@v_delimiter, @mst_loop_cnt)
						, @v_description         = [dbo].[SCM_ARR_SPL_VAL](@p_description ,@v_delimiter, @mst_loop_cnt)
						, @v_parent_item_id      = [dbo].[SCM_ARR_SPL_VAL](@p_parent_item_id ,@v_delimiter, @mst_loop_cnt)
						, @v_nick_name           = [dbo].[SCM_ARR_SPL_VAL](@p_nick_name ,@v_delimiter, @mst_loop_cnt)
						, @v_parent_item_class   = [dbo].[SCM_ARR_SPL_VAL](@p_parent_item_class ,@v_delimiter, @mst_loop_cnt)
                        , @v_material_1          = [dbo].[SCM_ARR_SPL_VAL](@p_material_1 ,@v_delimiter, @mst_loop_cnt)
                        , @v_level_name_1        = [dbo].[SCM_ARR_SPL_VAL](@p_level_name_1 ,@v_delimiter, @mst_loop_cnt)
                        , @v_input_rate_1        = [dbo].[SCM_ARR_SPL_VAL](@p_input_rate_1 ,@v_delimiter, @mst_loop_cnt)
                        , @v_material_2          = [dbo].[SCM_ARR_SPL_VAL](@p_material_2 ,@v_delimiter, @mst_loop_cnt)
                        , @v_level_name_2        = [dbo].[SCM_ARR_SPL_VAL](@p_level_name_2 ,@v_delimiter, @mst_loop_cnt)
                        , @v_input_rate_2        = [dbo].[SCM_ARR_SPL_VAL](@p_input_rate_2 ,@v_delimiter, @mst_loop_cnt)
                        , @v_material_3          = [dbo].[SCM_ARR_SPL_VAL](@p_material_3 ,@v_delimiter, @mst_loop_cnt)
                        , @v_level_name_3        = [dbo].[SCM_ARR_SPL_VAL](@p_level_name_3 ,@v_delimiter, @mst_loop_cnt)
                        , @v_input_rate_3        = [dbo].[SCM_ARR_SPL_VAL](@p_input_rate_3 ,@v_delimiter, @mst_loop_cnt)
                        , @v_material_4          = [dbo].[SCM_ARR_SPL_VAL](@p_material_4 ,@v_delimiter, @mst_loop_cnt)
                        , @v_level_name_4        = [dbo].[SCM_ARR_SPL_VAL](@p_level_name_4 ,@v_delimiter, @mst_loop_cnt)
                        , @v_input_rate_4        = [dbo].[SCM_ARR_SPL_VAL](@p_input_rate_4 ,@v_delimiter, @mst_loop_cnt)
                        , @v_material_5          = [dbo].[SCM_ARR_SPL_VAL](@p_material_5 ,@v_delimiter, @mst_loop_cnt)
                        , @v_level_name_5        = [dbo].[SCM_ARR_SPL_VAL](@p_level_name_5 ,@v_delimiter, @mst_loop_cnt)
                        , @v_input_rate_5        = [dbo].[SCM_ARR_SPL_VAL](@p_input_rate_5 ,@v_delimiter, @mst_loop_cnt)
                        , @v_material_6          = [dbo].[SCM_ARR_SPL_VAL](@p_material_6 ,@v_delimiter, @mst_loop_cnt)
                        , @v_level_name_6        = [dbo].[SCM_ARR_SPL_VAL](@p_level_name_6 ,@v_delimiter, @mst_loop_cnt)
                        , @v_input_rate_6        = [dbo].[SCM_ARR_SPL_VAL](@p_input_rate_6 ,@v_delimiter, @mst_loop_cnt)
                        , @v_material_7          = [dbo].[SCM_ARR_SPL_VAL](@p_material_7 ,@v_delimiter, @mst_loop_cnt)
                        , @v_level_name_7        = [dbo].[SCM_ARR_SPL_VAL](@p_level_name_7 ,@v_delimiter, @mst_loop_cnt)
                        , @v_input_rate_7        = [dbo].[SCM_ARR_SPL_VAL](@p_input_rate_7 ,@v_delimiter, @mst_loop_cnt)
                        , @v_material_8          = [dbo].[SCM_ARR_SPL_VAL](@p_material_8 ,@v_delimiter, @mst_loop_cnt)
                        , @v_level_name_8        = [dbo].[SCM_ARR_SPL_VAL](@p_level_name_8 ,@v_delimiter, @mst_loop_cnt)
                        , @v_input_rate_8        = [dbo].[SCM_ARR_SPL_VAL](@p_input_rate_8 ,@v_delimiter, @mst_loop_cnt)
                        , @v_material_9          = [dbo].[SCM_ARR_SPL_VAL](@p_material_9 ,@v_delimiter, @mst_loop_cnt)
                        , @v_level_name_9        = [dbo].[SCM_ARR_SPL_VAL](@p_level_name_9 ,@v_delimiter, @mst_loop_cnt)
                        , @v_input_rate_9        = [dbo].[SCM_ARR_SPL_VAL](@p_input_rate_9 ,@v_delimiter, @mst_loop_cnt)
                        , @v_material_10         = [dbo].[SCM_ARR_SPL_VAL](@p_material_10 ,@v_delimiter, @mst_loop_cnt)
                        , @v_level_name_10       = [dbo].[SCM_ARR_SPL_VAL](@p_level_name_10 ,@v_delimiter, @mst_loop_cnt)
                        , @v_input_rate_10	     = [dbo].[SCM_ARR_SPL_VAL](@p_input_rate_10 ,@v_delimiter, @mst_loop_cnt)					
					   
					   /******************************************************************************/
					   /* UPDATE 경우 : (MAIN Sheet: update_FP02650_Detail)화면                       */
					   /******************************************************************************/
					   IF(@v_sys_flag ='UPDATE_MAIN')  
							BEGIN
                                SELECT @v_dSql = ''
                                SELECT @v_dSql += ' MERGE INTO SCM_BATCH_M AS A                                                                     ' + char(10)
                                SELECT @v_dSql += ' USING (  SELECT '''+ @v_company_id +''' AS COMPANY_ID, '''+ @v_division_id +''' AS DIVISION_ID  ' + char(10)
                                SELECT @v_dSql += '             , '''+ @v_site_id +''' AS SITE_ID, '''+ @v_plant_id +''' AS PLANT_ID                ' + char(10)
								SELECT @v_dSql += '             , '''+ @v_parent_item_id +''' AS ITEM_ID                                            ' + char(10)
								SELECT @v_dSql += '        ) AS B                                                                                   ' + char(10)
                                SELECT @v_dSql += ' ON ( A.COMPANY_ID = B.COMPANY_ID AND A.DIVISION_ID = B.DIVISION_ID                              ' + char(10)
								SELECT @v_dSql += '   AND A.SITE_ID = B.SITE_ID AND A.PLANT_ID = B.PLANT_ID                                         ' + char(10)
                                SELECT @v_dSql += '   AND A.ITEM_ID = B.ITEM_ID )                                                                   ' + char(10)
                                SELECT @v_dSql += ' WHEN MATCHED THEN                                                                               ' + char(10)
                                SELECT @v_dSql += '   UPDATE SET                                                                                    ' + char(10)
								SELECT @v_dSql += '       BATCH_ID    = '''+ @v_batch_ratio_id +'''                                                 ' + char(10)
                                SELECT @v_dSql += '     , UPDATE_ID   = '''+ @v_user_id +'''                                                        ' + char(10)
                                SELECT @v_dSql += '     , UPDATE_TIME = GETDATE()                                                                   ' + char(10)
                                SELECT @v_dSql += ' WHEN NOT MATCHED THEN                                                                           ' + char(10)
                                SELECT @v_dSql += '   INSERT (                                                                                      ' + char(10)
                                SELECT @v_dSql += '       COMPANY_ID,  DIVISION_ID,  SITE_ID                                                        ' + char(10)
                                SELECT @v_dSql += '     , PLANT_ID,    ITEM_ID,      BATCH_ID                                                       ' + char(10)
                                SELECT @v_dSql += '     ,INSERT_ID,    INSERT_TIME,  UPDATE_ID                                                      ' + char(10)
                                SELECT @v_dSql += '     , UPDATE_TIME                                                                               ' + char(10)
                                SELECT @v_dSql += '   )                                                                                             ' + char(10)
                                SELECT @v_dSql += '   VALUES (                                                                                      ' + char(10)
                                SELECT @v_dSql += '       '''+ @v_company_id +''', '''+ @v_division_id +''', '''+ @v_site_id +'''                   ' + char(10)
                                SELECT @v_dSql += '     , '''+ @v_plant_id +''', '''+ @v_parent_item_id +''', '''+ @v_batch_ratio_id +'''           ' + char(10)
                                SELECT @v_dSql += '     , '''+ @v_user_id +''', GETDATE(), '''+ @v_user_id +'''                                     ' + char(10)
								SELECT @v_dSql += '     , GETDATE()  ' + char(10)
                                SELECT @v_dSql += '   ) ;            ' + char(10)

						   END --'I'
					   /******************************************************************************/
					   /* INSERT BATCH경우 : New batch인경우                                         */
					   /******************************************************************************/
					   ELSE IF(@v_sys_flag ='INSERT_BATCH')  
							BEGIN
                                SELECT @v_dSql = ''
                                SELECT @v_dSql += ' INSERT INTO SCM_MATERIAL_RATIO_M (                    ' + char(10)
                                SELECT @v_dSql += '     COMPANY_ID,  DIVISION_ID,  SITE_ID,     PLANT_ID  ' + char(10)
                                SELECT @v_dSql += '   , RATIO_ID,    ACTIVE_FLAG,  DESCRIPTION, INSERT_ID ' + char(10)
                                SELECT @v_dSql += '   , INSERT_TIME, UPDATE_ID,    UPDATE_TIME            ' + char(10)
                                SELECT @v_dSql += ' )        ' + char(10)
                                SELECT @v_dSql += ' VALUES ( ' + char(10)
                                SELECT @v_dSql += '    '''+ @v_company_id +''', '''+ @v_division_id +''', '''+ @v_site_id +''', '''+ @v_plant_id +''' ' + char(10)
                                SELECT @v_dSql += '   ,'''+ @v_batch_ratio_id +''',''Y'',N'''+ @v_description +''','''+ @v_user_id +''' ' + char(10)
                                SELECT @v_dSql += '   , GETDATE(),'''+ @v_user_id +''',GETDATE() ' + char(10)
                                SELECT @v_dSql += ' ) ' + char(10)

						   END --'I'
					   /******************************************************************************/
					   /* UPDATE BATCH경우 :  Sub Sheet                              */
					   /******************************************************************************/
					   ELSE IF(@v_sys_flag ='UPDATE_BATCH')  
							BEGIN
                                SELECT @v_dSql = ''
                                SELECT @v_dSql += ' UPDATE SCM_MATERIAL_RATIO_M SET                      ' + char(10)
                                SELECT @v_dSql += '        DESCRIPTION  = N'''+ @v_description +'''       ' + char(10)
                                SELECT @v_dSql += '       ,UPDATE_ID    = '''+ @v_user_id +'''           ' + char(10)
                                SELECT @v_dSql += '       ,UPDATE_TIME  = GETDATE()                      ' + char(10)
                                SELECT @v_dSql += ' WHERE  COMPANY_ID   = '''+ @v_company_id +'''        ' + char(10)
                                SELECT @v_dSql += ' AND    DIVISION_ID  = '''+ @v_division_id +'''       ' + char(10)
                                SELECT @v_dSql += ' AND    SITE_ID      = '''+ @v_site_id +'''           ' + char(10)
                                SELECT @v_dSql += ' AND    PLANT_ID     = '''+ @v_plant_id +'''          ' + char(10)
                                SELECT @v_dSql += ' AND    RATIO_ID     = '''+ @v_batch_ratio_id +'''    ' + char(10)

						   END --'I'
					   /******************************************************************************/
					   /* DELETE BATCH경우 :  Sub Sheet                                               */
					   /******************************************************************************/
					   ELSE IF(@v_sys_flag ='DELETE_BATCH')  
							BEGIN
                                SELECT @v_dSql = ''
                                SELECT @v_dSql += ' DELETE FROM SCM_MATERIAL_RATIO_M                     ' + char(10)
                                SELECT @v_dSql += ' WHERE  COMPANY_ID   = '''+ @v_company_id +'''        ' + char(10)
                                SELECT @v_dSql += ' AND    DIVISION_ID  = '''+ @v_division_id +'''       ' + char(10)
                                SELECT @v_dSql += ' AND    SITE_ID      = '''+ @v_site_id +'''           ' + char(10)
                                SELECT @v_dSql += ' AND    PLANT_ID     = '''+ @v_plant_id +'''          ' + char(10)
                                SELECT @v_dSql += ' AND    RATIO_ID     = '''+ @v_batch_ratio_id +'''    ' + char(10)
                                SELECT @v_dSql += '                                                      ' + char(10)
                                SELECT @v_dSql += ' DELETE FROM SCM_BATCH_M                              ' + char(10)
                                SELECT @v_dSql += ' WHERE  COMPANY_ID   = '''+ @v_company_id +'''        ' + char(10)
                                SELECT @v_dSql += ' AND    DIVISION_ID  = '''+ @v_division_id +'''       ' + char(10)
                                SELECT @v_dSql += ' AND    SITE_ID      = '''+ @v_site_id +'''           ' + char(10)
                                SELECT @v_dSql += ' AND    PLANT_ID     = '''+ @v_plant_id +'''          ' + char(10)
                                SELECT @v_dSql += ' AND    BATCH_ID     = '''+ @v_batch_ratio_id +'''    ' + char(10)
          

						   END --'I'


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

