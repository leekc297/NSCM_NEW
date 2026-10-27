

/*
 * Program ID   : PR_UI_SCP0049_FIND
 * Description  : CAPA 메뉴 각종 select 처리
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2023/05/10   LJS            신규
 */

--CREATE 
CREATE
PROCEDURE [dbo].[PR_UI_SCP0049_FIND]
  @p_sys_type                   NVARCHAR(MAX),
  @p_sys_flag                   NVARCHAR(MAX),
  @p_sys_gubun                  NVARCHAR(MAX),
  @p_user_id                    NVARCHAR(MAX),

  @p_company_id				    NVARCHAR(MAX),
  @p_division_id				NVARCHAR(MAX),
  @p_site_id					NVARCHAR(MAX),
  @p_plant_id					NVARCHAR(MAX),
  @p_factory_id					NVARCHAR(MAX),
  @p_operation_id				NVARCHAR(MAX),
  @p_item_id					NVARCHAR(MAX),
  @p_line_id					NVARCHAR(MAX),
  @p_electrode_type			    NVARCHAR(MAX),
  @p_from_date				    NVARCHAR(MAX),
  @p_to_date  			        NVARCHAR(MAX)

AS 
BEGIN  --MAIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
    SET NOCOUNT ON                                                                                                                                                                                                                                                   
	SET XACT_ABORT ON 

	DECLARE @v_sys_type                  NVARCHAR(100)  -- 값>> SELEC: SQL저장안함, SQL:SQL저장함
	DECLARE @v_sys_flag                  NVARCHAR(100)  -- 값>> I: Insert, M: Update, D: Delete, G: MERGE
	DECLARE @v_sys_gubun                 NVARCHAR(100) 
	DECLARE @v_user_id                   NVARCHAR(100)
    DECLARE @v_company_id				 NVARCHAR(100)
    DECLARE @v_division_id				 NVARCHAR(100)
    DECLARE @v_site_id					 NVARCHAR(100)
    DECLARE @v_plant_id					 NVARCHAR(100)
    DECLARE @v_factory_id				 NVARCHAR(100)
    DECLARE @v_model_id					 NVARCHAR(100)
    DECLARE @v_pjt_code					 NVARCHAR(100)
    DECLARE @v_version_type			     NVARCHAR(100)
    DECLARE @v_version			         NVARCHAR(100)
    DECLARE @v_prod_yn     				 NVARCHAR(100)
    DECLARE @v_operation_id				 NVARCHAR(100)
    DECLARE @v_item_id					 NVARCHAR(100)
    DECLARE @v_electrode_type			 NVARCHAR(100)
    DECLARE @v_category_id			     NVARCHAR(100)
    DECLARE @v_value     			     NVARCHAR(100)
    DECLARE @v_prod_ver_type			 NVARCHAR(100)
    DECLARE @v_max_version  			 NVARCHAR(100)
    DECLARE @v_mark			             NVARCHAR(100)
    DECLARE @v_apply_date  			     NVARCHAR(100)
	DECLARE @v_org_version 			     NVARCHAR(100)
	DECLARE @v_job_type 			     NVARCHAR(100)
	DECLARE @v_site_time			     NVARCHAR(100)

	DECLARE @recv_active_flag       NVARCHAR(MAX)				    
	DECLARE @v_proc_name	        NVARCHAR(100) = 'PR_UI_SCP0049_FIND'
	DECLARE @v_log_type             NVARCHAR(100) = ''
	DECLARE @v_log_message          NVARCHAR(MAX) = ''
	DECLARE @v_error_description    NVARCHAR(MAX) = ''
	DECLARE @v_delimiter            NVARCHAR(1)
	DECLARE @max_loop_cnt	        INTEGER = 0
	DECLARE @mst_loop_cnt	        INTEGER = 0
	DECLARE @max_loop_cnt2	        INTEGER = 0
	DECLARE @mst_loop_cnt2	        INTEGER = 0
	DECLARE @v_seq_no   	        INTEGER = 0
	DECLARE @rtnCount   	        INTEGER = 0

	DECLARE @sysdate                DATETIME      = GETDATE()
	DECLARE @runstart               datetime
    DECLARE @runend                 datetime

	DECLARE @v_dSql                 NVARCHAR(MAX)=''
	DECLARE @v_dSql1                NVARCHAR(MAX)=''
	DECLARE @v_dSql2                NVARCHAR(MAX)=''
	DECLARE @v_dSql3                NVARCHAR(MAX)=''
	DECLARE @v_dSql4                NVARCHAR(MAX)=''
	DECLARE @v_dSql5                NVARCHAR(MAX)=''

	DECLARE @v_tmp1                 NVARCHAR(MAX)=''
	DECLARE @v_tmp2                 NVARCHAR(MAX)=''

	SET @v_sys_type                 = ''
	SET @v_sys_flag                 = ''
	SET @v_sys_gubun                = ''
	SET @v_user_id                  = ''
    SET @v_company_id				= ''
    SET @v_division_id				= ''
    SET @v_site_id					= ''
    SET @v_plant_id					= ''
    SET @v_factory_id				= ''
    SET @v_model_id					= ''
    SET @v_pjt_code					= ''
    SET @v_version_type			    = ''
    SET @v_version			        = ''
    SET @v_prod_yn     				= ''
    SET @v_operation_id				= ''
    SET @v_item_id					= ''
    SET @v_electrode_type			= ''
    SET @v_category_id			    = ''
    SET @v_value    			    = ''
    SET @v_prod_ver_type			= ''
    SET @v_max_version  			= ''
    SET @v_mark			            = ''
    SET @v_apply_date  			    = ''
	SET @v_org_version 			    = ''
	SET @v_job_type 			    = ''
	SET @v_site_time                = ''

	SET @recv_active_flag       = NULL	
	SET @recv_active_flag       = @p_sys_flag
	SET @v_delimiter            = '|'             -- 데이터 구분자

	SET	@v_dSql                 = ''
	SET	@v_dSql1                = ''
	SET	@v_dSql2                = ''
	SET	@v_dSql3                = ''
	SET	@v_dSql4                = ''
	SET	@v_dSql5                = ''

    SET	@v_tmp1                 = ''
	SET	@v_tmp2                 = ''
	SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_sys_flag, @v_delimiter) -- 프로시저 LOOP 길이를 판단


	/************************************************************************************************/
	/* TACT TIME                                                       */
	/************************************************************************************************/
    IF(@p_sys_flag ='TACT_TIME')
    BEGIN
		    SELECT @v_dSql  = ''

            SELECT @v_dSql += 'SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
            SELECT @v_dSql += '     , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
            SELECT @v_dSql += '     , A.ITEM_ID, A.MONTH ' + char(10)
            --SELECT @v_dSql += '     , ROUND(A.TACT_TIME,2,1) AS TACT_TIME, A.DAILY_CAPA ' + char(10) -- 반올림
			SELECT @v_dSql += '     , CEILING(A.TACT_TIME*100)/100 AS TACT_TIME, A.DAILY_CAPA ' + char(10) -- 올림
            SELECT @v_dSql += 'FROM   SCM_TACT_TIME_M A WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += 'WHERE  1=1 ' + char(10)
			SELECT @v_dSql += 'AND    MONTH BETWEEN ''' + @p_from_date + ''' AND ''' + @p_to_date + ''' ' + char(10)
            SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))
            SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))
            SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))
            SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))
            SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))
			--SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'EQ', @p_item_id))
			SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))
            SELECT @v_dSql += 'ORDER BY FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, ITEM_ID, MONTH ' + char(10)


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
	-- 라인별 No-Run loss 합(PM 제외)
    ELSE IF(@p_sys_flag ='LOSS_NORUN_NOTPM')
    BEGIN
		    SELECT @v_dSql  = ''

            SELECT @v_dSql += 'SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
            SELECT @v_dSql += '     , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
            SELECT @v_dSql += '     , A.WORK_MONTH, SUM(A.LOSS_RATE) AS LOSS_RATE ' + char(10)
            SELECT @v_dSql += 'FROM   SCM_LOSS_M A WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += 'WHERE  1=1 ' + char(10)
            SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))
            SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))
            SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))
            SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))
            SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))
			SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))
            SELECT @v_dSql += 'AND    WORK_MONTH BETWEEN ''' + @p_from_date + ''' AND ''' + @p_to_date + ''' ' + char(10)
            SELECT @v_dSql += 'AND    LOSS_CODE IN ( ' + char(10)
            SELECT @v_dSql += '		SELECT SEGMENT1	AS LOSS_CODE ' + char(10)
            SELECT @v_dSql += '		FROM   SCM_SYS_LOOKUP_VALUE LV WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += '		WHERE  1=1 ' + char(10)
            SELECT @v_dSql += '		AND    LOOKUP_TYPE_CODE = ''CAPA_UI_LOSS_TYPE_DEFINIT'' ' + char(10)
            SELECT @v_dSql += '		AND    ACTIVE_FLAG = ''Y'' ' + char(10)
            SELECT @v_dSql += '		AND    ATTRIBUTE1 = ''No-Run'' ' + char(10)
            SELECT @v_dSql += '		AND    SEGMENT1 NOT IN (''EL011'',''EL009'')  ' + char(10) -- PM, Model Change(%) 제외
            SELECT @v_dSql += ') ' + char(10)
            SELECT @v_dSql += 'GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
            SELECT @v_dSql += '       , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
            SELECT @v_dSql += '       , A.WORK_MONTH ' + char(10)
            SELECT @v_dSql += 'ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
            SELECT @v_dSql += '       , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
            SELECT @v_dSql += '       , A.WORK_MONTH ' + char(10)

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
	-- 일별 엑셀 다운용 틀
    ELSE IF(@p_sys_flag ='EXCEL_DOWN_DAY')
    BEGIN
		    SELECT @v_dSql  = ''

            SELECT @v_dSql += 'SELECT ''D_'' + A.YYYYMMDD			AS COLUMN_NAME ' + char(10)
            SELECT @v_dSql += '	 , A.DAY						AS COLUMN_LABEL_NAME ' + char(10)
            SELECT @v_dSql += '	 , ''W'' + A.ISO_WEEK				AS SMALL_CLASS_LABEL_NAME ' + char(10)
            SELECT @v_dSql += '	 , CONVERT(VARCHAR(7), DT, 20)	AS LARGE_CLASS_LABEL_NAME ' + char(10)
            SELECT @v_dSql += '	 , (CASE WHEN A.DAY_SEQ = 2 THEN ''MON'' ' + char(10)
            SELECT @v_dSql += '	         WHEN A.DAY_SEQ = 3 THEN ''TUE'' ' + char(10)
            SELECT @v_dSql += '	 	     WHEN A.DAY_SEQ = 4 THEN ''WED'' ' + char(10)
            SELECT @v_dSql += '	 	     WHEN A.DAY_SEQ = 5 THEN ''THU'' ' + char(10)
            SELECT @v_dSql += '	 	     WHEN A.DAY_SEQ = 6 THEN ''FRI'' ' + char(10)
            SELECT @v_dSql += '	 	     WHEN A.DAY_SEQ = 7 THEN ''SAT'' ' + char(10)
            SELECT @v_dSql += '	 	     ELSE ''SUN'' END) AS DAY_CODE ' + char(10)
            SELECT @v_dSql += '	 , A.YYYYMMDD + CONVERT(CHAR(2), 31) AS SORT_ORDER_NO ' + char(10)
            SELECT @v_dSql += 'FROM   TH_UIS_CAL A WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += 'WHERE  1=1 ' + char(10)
            SELECT @v_dSql += 'AND    YYYYMM BETWEEN ''' + @p_from_date + ''' AND ''' + @p_to_date + ''' ' + char(10)
            SELECT @v_dSql += 'ORDER BY SORT_ORDER_NO ' + char(10)

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

	
    ELSE IF(@p_sys_flag ='EXECUTE_ITEM_LINE_VERSION')
	    BEGIN --ELSE IF(START)
		    SELECT @v_dSql = ''
			SELECT @v_dSql = 'EXEC PR_SCM_ITEM_LINE_VERSION'
			
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

		END --ELSE IF(END)

	ELSE
		-- 트랜잭션 (TRAN)
		BEGIN TRY				                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
		BEGIN TRAN   

		BEGIN --ELSE ( BEGIN )
		    --max_loop_cnt:전체 Row수 , mst_loop_cnt:1씩 증가시켜서 전체 Row수 까지만 로직을 수행
			WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
			    BEGIN --WHILE 내(START)
					 
						SELECT @mst_loop_cnt = @mst_loop_cnt + 1	-- @mst_loop_cnt 1증가

						SELECT @v_sys_type     = [dbo].[SCM_ARR_SPL_VAL](@p_sys_type ,      @v_delimiter, @mst_loop_cnt)
						, @v_sys_flag          = [dbo].[SCM_ARR_SPL_VAL](@p_sys_flag ,      @v_delimiter, @mst_loop_cnt)
						, @v_sys_gubun         = [dbo].[SCM_ARR_SPL_VAL](@p_sys_gubun ,     @v_delimiter, @mst_loop_cnt)
						, @v_user_id           = [dbo].[SCM_ARR_SPL_VAL](@p_user_id ,       @v_delimiter, @mst_loop_cnt)
                        , @v_company_id        = [dbo].[SCM_ARR_SPL_VAL](@p_company_id ,    @v_delimiter, @mst_loop_cnt)
                        , @v_division_id       = [dbo].[SCM_ARR_SPL_VAL](@p_division_id ,   @v_delimiter, @mst_loop_cnt)
                        , @v_site_id           = [dbo].[SCM_ARR_SPL_VAL](@p_site_id ,       @v_delimiter, @mst_loop_cnt)
                        , @v_plant_id          = [dbo].[SCM_ARR_SPL_VAL](@p_plant_id ,      @v_delimiter, @mst_loop_cnt)
                        , @v_factory_id        = [dbo].[SCM_ARR_SPL_VAL](@p_factory_id ,    @v_delimiter, @mst_loop_cnt)
						, @v_operation_id      = [dbo].[SCM_ARR_SPL_VAL](@p_operation_id ,  @v_delimiter, @mst_loop_cnt)
                        , @v_item_id           = [dbo].[SCM_ARR_SPL_VAL](@p_item_id ,       @v_delimiter, @mst_loop_cnt)
                        , @v_electrode_type	   = [dbo].[SCM_ARR_SPL_VAL](@p_electrode_type ,@v_delimiter, @mst_loop_cnt)
					   
					   /****************************************************************************/
					   /* DELETE  경우  :     D(DELETE_EXCEL_BUFFER)                               */
					   /****************************************************************************/
					   IF(@v_sys_flag ='DELETE_EXCEL_BUFFER')
						   BEGIN

						        --EXEC  @rtnCount = [dbo].[PR_SCM_UF_ITEM_SETUP_INSERT] @v_company_id, @v_division_id, @v_site_id, @v_operation_id, @v_setup_category_id, @v_setup_key_id;
	
								SELECT @v_dSql = ''
                                SELECT @v_dSql += ' DELETE FROM BUF_ITEM_CONV_CALC_M         ' + char(10)
                                SELECT @v_dSql += ' WHERE JOB_USER_ID = '''+ @v_user_id +''' ' + char(10)

						   END --'D'
                       /****************************************************************************/
					   /* INSERT  경우  :     I(INSERT_EXCEL_BUFFER)                               */
					   /****************************************************************************/
					   ELSE IF(@v_sys_flag ='INSERT_EXCEL_BUFFER')
						   BEGIN

						        --EXEC  @rtnCount = [dbo].[PR_SCM_UF_ITEM_SETUP_INSERT] @v_company_id, @v_division_id, @v_site_id, @v_operation_id, @v_setup_category_id, @v_setup_key_id;
	                            SELECT @v_seq_no += 1

								SELECT @v_dSql = ''
                                SELECT @v_dSql += ' INSERT INTO BUF_ITEM_CONV_CALC_M (                ' + char(10)
                                SELECT @v_dSql += '     COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID    ' + char(10)
                                SELECT @v_dSql += '   , FACTORY_ID, MODEL_ID, PJT_CODE, VERSION       ' + char(10)
                                SELECT @v_dSql += '   , OPERATION, ITEM_ID, ELECTRODE_TYPE, CATEGORY  ' + char(10)
                                SELECT @v_dSql += '   , VALUE, MAX_VER_FLAG, MARK, PROD_VERSION_TYPE  ' + char(10)
                                SELECT @v_dSql += '   , VERSION_TYPE, JOB_USER_ID, JOB_TIME, JOB_TYPE ' + char(10)
								SELECT @v_dSql += '   , JOB_ORDER                                     ' + char(10)
                                SELECT @v_dSql += ' )                                                 ' + char(10)
                                SELECT @v_dSql += ' VALUES (                                          ' + char(10)
                                SELECT @v_dSql += '  ( SELECT MAX(KK.COMPANY_ID) AS COMPANY_ID FROM SCM_FACTORY_M KK WITH(NOLOCK)                                                                   ' + char(10)
								SELECT @v_dSql += '    WHERE KK.FACTORY_ID = UPPER(RTRIM(LTRIM('''+ @v_factory_id +'''))) AND KK.ACTIVE_FLAG = ''Y'' )                                              ' + char(10)
                                SELECT @v_dSql += '   , UPPER(RTRIM(LTRIM('''+ @v_division_id +'''))), UPPER(RTRIM(LTRIM('''+ @v_site_id +'''))), UPPER(RTRIM(LTRIM('''+ @v_plant_id +''')))        ' + char(10)
                                SELECT @v_dSql += '   , UPPER(RTRIM(LTRIM('''+ @v_factory_id +'''))), UPPER(RTRIM(LTRIM('''+ @v_model_id +'''))), UPPER(RTRIM(LTRIM('''+ @v_pjt_code +''')))        ' + char(10)
                                SELECT @v_dSql += '   , UPPER(RTRIM(LTRIM('''+ @v_version +'''))), UPPER(RTRIM(LTRIM('''+ @v_operation_id +'''))), UPPER(RTRIM(LTRIM('''+ @v_item_id +''')))        ' + char(10)
                                SELECT @v_dSql += '   , UPPER(RTRIM(LTRIM('''+ @v_electrode_type +'''))),RTRIM(LTRIM('''+ @v_category_id +''')), CAST(RTRIM(LTRIM('''+ @v_value +''')) AS DECIMAL(18,5))  ' + char(10)
                                SELECT @v_dSql += '   , RTRIM(LTRIM('''+ @v_max_version +''')), RTRIM(LTRIM('''+ @v_mark +''')),ISNULL(UPPER(RTRIM(LTRIM('''+ @v_prod_ver_type +'''))),''GENERAL'') ' + char(10)
                                SELECT @v_dSql += '   , ISNULL(UPPER(RTRIM(LTRIM('''+ @v_version_type +'''))),''MASS''), '''+ @v_user_id +''', GETDATE(), ''-'', '+ CONVERT(VARCHAR, @v_seq_no) +'  ' + char(10)
                                SELECT @v_dSql += ' )                                                                                                                                               ' + char(10)

						   END --'D'
					   /****************************************************************************/
					   /* INSERT  경우  :     INSERT(INSERT_UOM_INFO)                              */
					   /****************************************************************************/
					   ELSE IF(@v_sys_flag ='INSERT_UOM_INFO')
						   BEGIN
								SELECT @v_dSql1 = ''
                                SELECT @v_dSql1 += ' -- update when data exists                                  ' + char(10)
                                SELECT @v_dSql1 += ' UPDATE SCM_ITEM_CONV_CALC_M                                 ' + char(10)
                                SELECT @v_dSql1 += ' SET   UPDATE_ID    = '''+ @v_user_id +'''                   ' + char(10)
                                SELECT @v_dSql1 += '     , UPDATE_TIME  = dbo.FN_SITE_TIME('''+ @v_site_id +''') ' + char(10)
                                SELECT @v_dSql1 += '     , VALUE        = '''+ @v_value +'''                     ' + char(10)
                                SELECT @v_dSql1 += ' WHERE FACTORY_ID   = '''+ @v_factory_id +'''                ' + char(10)
                                SELECT @v_dSql1 += ' AND   MODEL_ID     = '''+ @v_model_id +'''                  ' + char(10)
                                SELECT @v_dSql1 += ' AND   VERSION      = '''+ @v_version +'''                   ' + char(10)
                                SELECT @v_dSql1 += ' AND   OPERATION    = '''+ @v_operation_id +'''              ' + char(10)
                                SELECT @v_dSql1 += ' AND   ITEM_ID      = '''+ @v_item_id +'''                   ' + char(10)
                                SELECT @v_dSql1 += ' AND   CATEGORY     = '''+ @v_category_id +'''               ' + char(10)
                                SELECT @v_dSql1 += ' AND   VERSION_TYPE = '''+ @v_version_type +'''              ' + char(10)
                                SELECT @v_dSql1 += ' AND   PROD_VERSION_TYPE = '''+ @v_prod_ver_type +'''        ' + char(10)

                                SELECT @v_dSql1 += ' -- insert when no data.                                     ' + char(10)
                                SELECT @v_dSql1 += ' INSERT INTO SCM_ITEM_CONV_CALC_M (                          ' + char(10)
                                SELECT @v_dSql1 += '       COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID            ' + char(10)
                                SELECT @v_dSql1 += '     , FACTORY_ID, MODEL_ID, PJT_CODE, VERSION               ' + char(10)
                                SELECT @v_dSql1 += '     , OPERATION, ITEM_ID, ELECTRODE_TYPE, CATEGORY          ' + char(10)
                                SELECT @v_dSql1 += '     , MAX_VER_FLAG, VALUE, PROD_VERSION_TYPE, VERSION_TYPE  ' + char(10)
                                SELECT @v_dSql1 += '     , CREATE_ID, CREATE_TIME, UPDATE_ID, UPDATE_TIME        ' + char(10)
                                SELECT @v_dSql1 += '     , APPLY_DATE                                            ' + char(10)
                                SELECT @v_dSql1 += ' )                                                           ' + char(10)
                                SELECT @v_dSql1 += ' SELECT A.*                                                  ' + char(10)
                                SELECT @v_dSql1 += ' FROM (                                                      ' + char(10)
                                SELECT @v_dSql1 += '     SELECT '''+ @v_company_id +''' AS COMPANY_ID, '''+ @v_division_id +''' AS DIVISION_ID, '''+ @v_site_id +''' AS SITE_ID, '''+ @v_plant_id +''' AS PLANT_ID ' + char(10)
                                SELECT @v_dSql1 += ' 	 , '''+ @v_factory_id +''' AS FACTORY_ID, '''+ @v_model_id +''' AS MODEL_ID, '''+ @v_pjt_code +''' AS PJT_CODE  ' + char(10)
                                SELECT @v_dSql1 += '     , (CASE WHEN CHARINDEX(''.'','''+ @v_version +''',1) > 0 THEN                                                  ' + char(10)
                                SELECT @v_dSql1 += '                 ISNULL(REPLICATE(''0'', 3 - LEN(SUBSTRING('''+ @v_version +''', 1, ABS(CHARINDEX(''.'','''+ @v_version +''',1)-1)))),'''')  ' + char(10)
                                SELECT @v_dSql1 += ' 				+ SUBSTRING('''+ @v_version +''', 1, ABS(CHARINDEX(''.'', '''+ @v_version +''',1)-1) ) + ''.''  ' + char(10)
                                SELECT @v_dSql1 += ' 				+ SUBSTRING('''+ @v_version +''', CHARINDEX(''.'','''+ @v_version +''',1)+1,10)                 ' + char(10)
                                SELECT @v_dSql1 += '            ELSE ISNULL(REPLICATE(''0'', 3 - LEN('''+ @v_version +''')),'''') + '''+ @v_version +'''              ' + char(10)
                                SELECT @v_dSql1 += '            END ) AS VERSION                                                                                    ' + char(10)
                                SELECT @v_dSql1 += '     , '''+ @v_operation_id +''' AS OPERATION, '''+ @v_item_id +''' AS ITEM_ID,'''+ @v_electrode_type +''' AS ELECTRODE_TYPE, '''+ @v_category_id +''' AS CATEGORY ' + char(10)
                                SELECT @v_dSql1 += '     , ''Y'' AS MAX_VER_FLAG, '''+ @v_value +''' AS VALUE                                             ' + char(10)
                                SELECT @v_dSql1 += '     , ( SELECT DISTINCT                                                                                    ' + char(10)
                                SELECT @v_dSql1 += '             CASE WHEN ( COUNT(*) OVER (PARTITION BY A.SEGMENT2, A.SEGMENT1, A.SEGMENT3, A.SEGMENT4 )) > 1  ' + char(10)
                                SELECT @v_dSql1 += '                      AND SUBSTRING('''+ @v_version +''',LEN('''+ @v_version +'''),1) = ''W''               ' + char(10)
                                SELECT @v_dSql1 += '                  THEN ''WIDE''                                                                             ' + char(10)
                                SELECT @v_dSql1 += '             ELSE MIN(A.ATTRIBUTE1) OVER (PARTITION BY A.SEGMENT2, A.SEGMENT1, A.SEGMENT3, A.SEGMENT4 )     ' + char(10)
                                SELECT @v_dSql1 += '             END AS PROD_VERSION_TYPE                           ' + char(10)
                                SELECT @v_dSql1 += '         FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)             ' + char(10)
                                SELECT @v_dSql1 += '         WHERE  A.LOOKUP_TYPE_CODE = ''LINE_PROD_VERSION_TYPE'' ' + char(10)
                                SELECT @v_dSql1 += '         AND    A.ACTIVE_FLAG = ''Y''                           ' + char(10)
                                SELECT @v_dSql1 += '         AND    A.SEGMENT2 = '''+ @v_division_id +'''           ' + char(10)
                                SELECT @v_dSql1 += '         AND    A.SEGMENT1 = '''+ @v_site_id +'''               ' + char(10)
                                SELECT @v_dSql1 += '         AND    A.SEGMENT3 = '''+ @v_plant_id +'''              ' + char(10)
                                SELECT @v_dSql1 += '         AND    A.SEGMENT4 = '''+ @v_factory_id +'''            ' + char(10)
                                SELECT @v_dSql1 += '      ) AS PROD_VERSION_TYPE, '''+ @v_version_type +''' AS VERSION_TYPE                        ' + char(10)
                                SELECT @v_dSql1 += '     ,'''+ @v_user_id +''' AS CREATE_ID, dbo.FN_SITE_TIME('''+ @v_site_id +''') AS CREATE_TIME ' + char(10)
                                SELECT @v_dSql1 += '     ,'''+ @v_user_id +''' AS UPDATE_ID, dbo.FN_SITE_TIME('''+ @v_site_id +''') AS UPDATE_TIME ' + char(10)
                                SELECT @v_dSql1 += '     ,CONVERT(DATETIME, '''+ @v_site_id +''') AS APPLY_DATE   ' + char(10)
                                SELECT @v_dSql1 += ' ) A                                                          ' + char(10)
                                SELECT @v_dSql1 += ' WHERE NOT EXISTS (                                           ' + char(10)
                                SELECT @v_dSql1 += '                  SELECT 1                                    ' + char(10)
                                SELECT @v_dSql1 += '                  FROM   SCM_ITEM_CONV_CALC_M AA WITH(NOLOCK) ' + char(10)
                                SELECT @v_dSql1 += '                  WHERE  A.COMPANY_ID = AA.COMPANY_ID         ' + char(10)
                                SELECT @v_dSql1 += '                  AND    A.FACTORY_ID = AA.FACTORY_ID         ' + char(10)
                                SELECT @v_dSql1 += '                  AND    A.MODEL_ID   = AA.MODEL_ID           ' + char(10)
                                SELECT @v_dSql1 += '                  AND    A.VERSION    = AA.VERSION            ' + char(10)
                                SELECT @v_dSql1 += '                  AND    A.OPERATION  = AA.OPERATION          ' + char(10)
                                SELECT @v_dSql1 += '                  AND    A.ITEM_ID    = AA.ITEM_ID            ' + char(10)
                                SELECT @v_dSql1 += '                  AND    A.CATEGORY   = AA.CATEGORY           ' + char(10)
                                SELECT @v_dSql1 += ' )                                                            ' + char(10)
								
								SELECT @v_dSql2 = ''
                                SELECT @v_dSql2 += ' INSERT INTO HIS_ITEM_CONV_CALC_M (                 ' + char(10)
                                SELECT @v_dSql2 += '       COMPANY_ID, FACTORY_ID, MODEL_ID             ' + char(10)
                                SELECT @v_dSql2 += '     , PJT_CODE,VERSION, OPERATION                  ' + char(10)
                                SELECT @v_dSql2 += '     , ITEM_ID, ELECTRODE_TYPE, CATEGORY            ' + char(10)
                                SELECT @v_dSql2 += '     , VALUE, MARK, PROD_VERSION_TYPE               ' + char(10)
                                SELECT @v_dSql2 += '     , VERSION_TYPE, CREATE_ID, CREATE_TIME         ' + char(10)
                                SELECT @v_dSql2 += '     , UPDATE_ID, UPDATE_TIME, JOB_USER_ID          ' + char(10)
                                SELECT @v_dSql2 += '     , JOB_TIME, JOB_TYPE                           ' + char(10)
                                SELECT @v_dSql2 += ' )                                                  ' + char(10)
                                SELECT @v_dSql2 += ' SELECT COMPANY_ID, FACTORY_ID, MODEL_ID            ' + char(10)
                                SELECT @v_dSql2 += '     , PJT_CODE, VERSION, OPERATION                 ' + char(10)
                                SELECT @v_dSql2 += '     , ITEM_ID, ELECTRODE_TYPE, CATEGORY            ' + char(10)
                                SELECT @v_dSql2 += '     , VALUE, MARK, PROD_VERSION_TYPE               ' + char(10)
                                SELECT @v_dSql2 += '     , VERSION_TYPE, CREATE_ID, CREATE_TIME         ' + char(10)
                                SELECT @v_dSql2 += '     , UPDATE_ID, UPDATE_TIME, '''+ @v_user_id +''' ' + char(10)
                                SELECT @v_dSql2 += '     , GETDATE(), ''MERGE''                         ' + char(10)
                                SELECT @v_dSql2 += ' FROM  SCM_ITEM_CONV_CALC_M A WITH(NOLOCK)          ' + char(10)
                                SELECT @v_dSql2 += ' WHERE FACTORY_ID = '''+ @v_factory_id +'''         ' + char(10)
                                SELECT @v_dSql2 += ' AND  MODEL_ID    = '''+ @v_model_id +'''           ' + char(10)
                                SELECT @v_dSql2 += ' AND  VERSION     =                                 ' + char(10)
								SELECT @v_dSql2 += '     ( CASE WHEN CHARINDEX(''.'','''+ @v_version +''',1) > 0 THEN                                                                    ' + char(10)
                                SELECT @v_dSql2 += '          ISNULL(REPLICATE(''0'', 3 - LEN(SUBSTRING('''+ @v_version +''', 1, ABS(CHARINDEX(''.'','''+ @v_version +''',1)-1)))),'''') ' + char(10)
                                SELECT @v_dSql2 += '          + SUBSTRING('''+ @v_version +''', 1, ABS(CHARINDEX(''.'','''+ @v_version +''',1)-1)   ) + ''.''  ' + char(10)
                                SELECT @v_dSql2 += '          + SUBSTRING('''+ @v_version +''', CHARINDEX(''.'','''+ @v_version +''',1)+1,10)                  ' + char(10)
                                SELECT @v_dSql2 += '       ELSE ISNULL(REPLICATE(''0'', 3 - LEN('''+ @v_version +''')),'''') + '''+ @v_version +'''              ' + char(10)
                                SELECT @v_dSql2 += '       END )                             ' + char(10)
                                SELECT @v_dSql2 += ' AND  OPERATION         = '''+ @v_operation_id +'''  ' + char(10)
                                SELECT @v_dSql2 += ' AND  ITEM_ID           = '''+ @v_item_id +'''       ' + char(10)
                                SELECT @v_dSql2 += ' AND  CATEGORY          = '''+ @v_category_id +'''   ' + char(10)
                                SELECT @v_dSql2 += ' AND  VERSION_TYPE      = '''+ @v_version_type +'''  ' + char(10)
                                SELECT @v_dSql2 += ' AND  PROD_VERSION_TYPE = '''+ @v_prod_ver_type +''' ' + char(10)

								SELECT @v_dSql = @v_dSql1 + @v_dSql2

						   END --'D'
					  
					
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

