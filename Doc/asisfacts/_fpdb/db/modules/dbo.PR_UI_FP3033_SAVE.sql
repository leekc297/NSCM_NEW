


/*
 * Program ID   : [PR_UI_FP3033_SAVE]
 * Description  : Model Measure Conversion - line assign 별 환산자 버전 사용여부 저장 관리
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022/11/07   LJS				Initial Release UI통합
 */

--CREATE
CREATE
PROCEDURE [dbo].[PR_UI_FP3033_SAVE]
	@p_sys_type				NVARCHAR(MAX),
	@p_sys_flag				NVARCHAR(MAX),
	@p_sys_gubun			NVARCHAR(MAX),
	@p_user_id				NVARCHAR(MAX),
	@p_company_id			NVARCHAR(MAX),
	@p_division_id			NVARCHAR(MAX),
	@p_site_id				NVARCHAR(MAX),
	@p_plant_id				NVARCHAR(MAX),
	@p_factory_id			NVARCHAR(MAX),
	@p_operation_id			NVARCHAR(MAX),
	@p_model_id		        NVARCHAR(MAX),
	@p_item_id			    NVARCHAR(MAX),
	@p_line_id				NVARCHAR(MAX),
	@p_electrode_type		NVARCHAR(MAX),
	@p_version	    		NVARCHAR(MAX),
	@p_active_flag			NVARCHAR(MAX),
	@p_description			NVARCHAR(MAX),
	@p_attb_1				NVARCHAR(MAX),
	@p_attb_2				NVARCHAR(MAX),
	@p_attb_3				NVARCHAR(MAX),
	@p_attb_4				NVARCHAR(MAX),
	@p_attb_5				NVARCHAR(MAX)

AS 
BEGIN  --MAIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
    SET NOCOUNT ON                                                                                                                                                                                                                                                   
	SET XACT_ABORT ON 

	DECLARE @v_sys_type             NVARCHAR(MAX)  -- 값>> SELEC: SQL저장안함, SQL:SQL저장함
	DECLARE @v_sys_flag             NVARCHAR(MAX)  -- 값>> I: Insert, M: Update, D: Delete, G: MERGE
	DECLARE @v_sys_gubun            NVARCHAR(MAX) 
	DECLARE @v_user_id              NVARCHAR(MAX)

    DECLARE @v_company_id           NVARCHAR(MAX)
    DECLARE @v_division_id          NVARCHAR(MAX)
    DECLARE @v_site_id              NVARCHAR(MAX)
    DECLARE @v_plant_id             NVARCHAR(MAX)
	DECLARE @v_factory_id           NVARCHAR(MAX)
	DECLARE @v_operation_id         NVARCHAR(MAX)
	DECLARE @v_model_id             NVARCHAR(MAX)
	DECLARE @v_item_id              NVARCHAR(MAX)
	DECLARE @v_line_id		        NVARCHAR(MAX)
    DECLARE @v_electrode_type       NVARCHAR(MAX)
	DECLARE @v_version				NVARCHAR(MAX)
	DECLARE @v_active_flag          NVARCHAR(MAX)
	DECLARE @v_description          NVARCHAR(MAX)

	DECLARE @v_attb_1				NVARCHAR(MAX)
	DECLARE @v_attb_2				NVARCHAR(MAX)
	DECLARE @v_attb_3				NVARCHAR(MAX)
	DECLARE @v_attb_4				NVARCHAR(MAX)
	DECLARE @v_attb_5				NVARCHAR(MAX)

	DECLARE @recv_active_flag       NVARCHAR(MAX)				    
	DECLARE @v_proc_name	        NVARCHAR(100) = 'PR_UI_FP3033_SAVE'
	DECLARE @v_log_type             NVARCHAR(100) = ''
	DECLARE @v_log_message          NVARCHAR(MAX) = ''
	DECLARE @v_error_description    NVARCHAR(MAX) = ''
	DECLARE @v_delimiter            NVARCHAR(1)
	DECLARE @max_loop_cnt	        INTEGER = 0
	DECLARE @mst_loop_cnt	        INTEGER = 0
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

    DECLARE @pSql                   NVARCHAR(MAX)=''
    DECLARE @sSql                   NVARCHAR(MAX)=''
    DECLARE @iSql                   NVARCHAR(MAX)=''

	DECLARE @v_tmp1                 NVARCHAR(MAX)=''
	DECLARE @v_tmp2                 NVARCHAR(MAX)=''
	DECLARE @v_tmp3                 NVARCHAR(MAX)=''

    SET @v_company_id           = ''
    SET @v_division_id          = ''
    SET @v_site_id              = ''
    SET @v_plant_id             = ''
	SET @v_factory_id           = ''
	SET @v_operation_id         = ''
	SET @v_model_id             = ''
	SET @v_item_id              = ''
	SET @v_line_id		        = ''
    SET @v_electrode_type       = ''
	SET @v_version				= ''
	SET @v_active_flag          = ''
	SET @v_description          = ''

	SET @p_attb_1				= ''
	SET @p_attb_2				= ''
	SET @p_attb_3				= ''
	SET @p_attb_4				= ''
	SET @p_attb_5				= ''

	SET @recv_active_flag       = NULL	
	SET @recv_active_flag       = @p_sys_flag
	SET @v_delimiter            = '|'             -- 데이터 구분자
	SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_sys_flag, @v_delimiter) -- 프로시저 LOOP 길이를 판단  

	SET	@v_dSql                 = ''
	SET	@v_dSql1                = ''
	SET	@v_dSql2                = ''
	SET	@v_dSql3                = ''
	SET	@v_dSql4                = ''
	SET	@v_dSql5                = ''

	SET	@pSql					= ''
	SET	@sSql					= ''
	SET	@iSql					= ''

    SET	@v_tmp1                 = ''
	SET	@v_tmp2                 = ''
	SET	@v_tmp3                 = ''

	/************************************************************************************************/
	/* SELECT인경우 :SELECT(SELECT)                                                                      */
	/************************************************************************************************/
    IF(@p_sys_flag ='EXEC_PSICALCUL')
    BEGIN
		    SET @runstart = GETDATE()
			--SELECT @v_dSql = '[dbo].[PR_SCM_OF_INSTANCE_CALL_DAILY_AMEND_UI] '''+ @p_instance_id +''', '''+ @p_plan_id +''' '
		    EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id, @p_sys_flag,'', @v_dSql,'SELECT(ST)',@runstart, @runend
			
			--실제수행
			--EXEC  @rtnCount = [dbo].[PR_SCM_OF_INSTANCE_CALL_DAILY_AMEND_UI] '', ''

			SET @runend = GETDATE()
			EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id, @p_sys_flag,'', @v_dSql,'SELECT(ED)',@runstart, @runend

			SELECT	'Result' = @rtnCount

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

					SELECT @v_sys_type				   = [dbo].[SCM_ARR_SPL_VAL](@p_sys_type ,             @v_delimiter,  @mst_loop_cnt)
						 , @v_sys_flag                 = [dbo].[SCM_ARR_SPL_VAL](@p_sys_flag ,             @v_delimiter,  @mst_loop_cnt)
						 , @v_sys_gubun                = [dbo].[SCM_ARR_SPL_VAL](@p_sys_gubun ,            @v_delimiter,  @mst_loop_cnt)
						 , @v_user_id                  = [dbo].[SCM_ARR_SPL_VAL](@p_user_id ,              @v_delimiter,  @mst_loop_cnt)
                         , @v_company_id               = [dbo].[SCM_ARR_SPL_VAL](@p_company_id ,           @v_delimiter,  @mst_loop_cnt)
                         , @v_division_id              = [dbo].[SCM_ARR_SPL_VAL](@p_division_id ,          @v_delimiter,  @mst_loop_cnt)
                         , @v_site_id                  = [dbo].[SCM_ARR_SPL_VAL](@p_site_id ,              @v_delimiter,  @mst_loop_cnt)
                         , @v_plant_id                 = [dbo].[SCM_ARR_SPL_VAL](@p_plant_id ,             @v_delimiter,  @mst_loop_cnt)
						 , @v_factory_id               = [dbo].[SCM_ARR_SPL_VAL](@p_factory_id ,           @v_delimiter,  @mst_loop_cnt)
						 , @v_operation_id             = [dbo].[SCM_ARR_SPL_VAL](@p_operation_id ,         @v_delimiter,  @mst_loop_cnt)
						 , @v_model_id                 = [dbo].[SCM_ARR_SPL_VAL](@p_model_id ,             @v_delimiter,  @mst_loop_cnt)
						 , @v_item_id                  = [dbo].[SCM_ARR_SPL_VAL](@p_item_id ,              @v_delimiter,  @mst_loop_cnt)
						 , @v_line_id                  = [dbo].[SCM_ARR_SPL_VAL](@p_line_id ,              @v_delimiter,  @mst_loop_cnt)
						 , @v_electrode_type           = [dbo].[SCM_ARR_SPL_VAL](@p_electrode_type ,       @v_delimiter,  @mst_loop_cnt)
						 , @v_version				   = [dbo].[SCM_ARR_SPL_VAL](@p_version ,              @v_delimiter,  @mst_loop_cnt)
						 , @v_active_flag			   = [dbo].[SCM_ARR_SPL_VAL](@p_active_flag ,          @v_delimiter,  @mst_loop_cnt)
						 , @v_description			   = [dbo].[SCM_ARR_SPL_VAL](@p_description ,          @v_delimiter,  @mst_loop_cnt)
						 , @v_attb_1				   = [dbo].[SCM_ARR_SPL_VAL](@p_attb_1 ,               @v_delimiter,  @mst_loop_cnt)
						 , @v_attb_2				   = [dbo].[SCM_ARR_SPL_VAL](@p_attb_2 ,               @v_delimiter,  @mst_loop_cnt)
						 , @v_attb_3				   = [dbo].[SCM_ARR_SPL_VAL](@p_attb_3 ,               @v_delimiter,  @mst_loop_cnt)
						 , @v_attb_4				   = [dbo].[SCM_ARR_SPL_VAL](@p_attb_4 ,               @v_delimiter,  @mst_loop_cnt)
						 , @v_attb_5				   = [dbo].[SCM_ARR_SPL_VAL](@p_attb_5 ,               @v_delimiter,  @mst_loop_cnt)


					/******************************************************************************/
					/* MERGE_DATA 경우 : (saveAll_data)                                           */
					/******************************************************************************/
					IF(@v_sys_flag ='MERGE_DATA')  
					BEGIN
                                SELECT @v_dSql = ''

								SELECT @v_dSql1 = '' + char(10)
								SELECT @v_dSql1 += N'MERGE INTO SCM_ITEM_CONV_CALC_USE_M AS A ' + char(10)
								SELECT @v_dSql1 += N'USING ( ' + char(10)
								SELECT @v_dSql1 += N'	SELECT ''' + @v_company_id + ''' AS COMPANY_ID, ''' + @v_division_id + ''' AS DIVISION_ID, ''' + @v_site_id + ''' AS SITE_ID, ''' + @v_plant_id + ''' AS PLANT_ID, ''' + @v_factory_id + ''' AS FACTORY_ID ' + char(10)
								SELECT @v_dSql1 += N'        			, ''' + @v_operation_id + ''' AS OPERATION_ID, ''' + @v_model_id + ''' AS MODEL_ID, ''' + @v_item_id + ''' AS ITEM_ID ' + char(10)
								SELECT @v_dSql1 += N'        			, ''' + @v_line_id + ''' AS LINE_ID, ''' + @v_electrode_type + ''' AS ELECTRODE_TYPE ' + char(10)
								SELECT @v_dSql1 += N'        			, ''' + @v_version + ''' AS VERSION, ''' + @v_active_flag + ''' AS ACTIVE_FLAG ' + char(10)
								SELECT @v_dSql1 += N'        			, N''' + @v_description + ''' AS DESCRIPTION ' + char(10)
								SELECT @v_dSql1 += N'        			, ''' + @v_user_id + ''' AS USER_ID, dbo.FN_SITE_TIME(''' + @v_site_id + ''') AS USER_TIME ' + char(10)
								SELECT @v_dSql1 += N') AS B ' + char(10)
								SELECT @v_dSql1 += N'ON  A.FACTORY_ID     = B.FACTORY_ID ' + char(10)
								SELECT @v_dSql1 += N'AND A.MODEL_ID       = B.MODEL_ID ' + char(10)
								SELECT @v_dSql1 += N'AND A.ITEM_ID        = B.ITEM_ID ' + char(10)
								SELECT @v_dSql1 += N'AND A.LINE_ID        = B.LINE_ID ' + char(10)
								SELECT @v_dSql1 += N'AND A.ELECTRODE_TYPE = B.ELECTRODE_TYPE ' + char(10)
								SELECT @v_dSql1 += N'AND A.VERSION        = B.VERSION ' + char(10)
								SELECT @v_dSql1 += N'WHEN MATCHED THEN ' + char(10)
								SELECT @v_dSql1 += N'	UPDATE SET ACTIVE_FLAG = B.ACTIVE_FLAG ' + char(10)
								SELECT @v_dSql1 += N'				, DESCRIPTION = B.DESCRIPTION ' + char(10)
								SELECT @v_dSql1 += N'				, UPDATE_ID   = B.USER_ID ' + char(10)
								SELECT @v_dSql1 += N'				, UPDATE_TIME = B.USER_TIME ' + char(10)
								SELECT @v_dSql1 += N'WHEN NOT MATCHED BY TARGET THEN ' + char(10)
								SELECT @v_dSql1 += N'	INSERT ( ' + char(10)
								SELECT @v_dSql1 += N'    		  COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID ' + char(10)
								SELECT @v_dSql1 += N'    		, MODEL_ID, ITEM_ID ' + char(10)
								SELECT @v_dSql1 += N'    		, LINE_ID, ELECTRODE_TYPE ' + char(10)
								SELECT @v_dSql1 += N'    		, VERSION ' + char(10)
								SELECT @v_dSql1 += N'    		, ACTIVE_FLAG, DESCRIPTION ' + char(10)
								SELECT @v_dSql1 += N'    		, INSERT_ID, INSERT_TIME ' + char(10)
								SELECT @v_dSql1 += N'    		, UPDATE_ID, UPDATE_TIME ' + char(10)
								SELECT @v_dSql1 += N'	) ' + char(10)
								SELECT @v_dSql1 += N'	VALUES ( ' + char(10)
								SELECT @v_dSql1 += N'    		  B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, B.FACTORY_ID, B.OPERATION_ID ' + char(10)
								SELECT @v_dSql1 += N'    		, B.MODEL_ID, B.ITEM_ID ' + char(10)
								SELECT @v_dSql1 += N'    		, B.LINE_ID, B.ELECTRODE_TYPE ' + char(10)
								SELECT @v_dSql1 += N'    		, B.VERSION ' + char(10)
								SELECT @v_dSql1 += N'    		, B.ACTIVE_FLAG, B.DESCRIPTION ' + char(10)
								SELECT @v_dSql1 += N'    		, B.USER_ID, B.USER_TIME ' + char(10)
								SELECT @v_dSql1 += N'    		, B.USER_ID, B.USER_TIME ' + char(10)
								SELECT @v_dSql1 += N'	) ' + char(10)
								SELECT @v_dSql1 += N'	; ' + char(10)+ char(10)

								SELECT @v_dSql2 = '' + char(10)
								SELECT @v_dSql2 += N'INSERT INTO HIS_ITEM_CONV_CALC_USE_M ( ' + char(10)
								SELECT @v_dSql2 += N'	  COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID ' + char(10)
								SELECT @v_dSql2 += N'	, MODEL_ID, ITEM_ID ' + char(10)
								SELECT @v_dSql2 += N'	, LINE_ID, ELECTRODE_TYPE ' + char(10)
								SELECT @v_dSql2 += N'	, VERSION ' + char(10)
								SELECT @v_dSql2 += N'	, ACTIVE_FLAG, DESCRIPTION ' + char(10)
								SELECT @v_dSql2 += N'	, INSERT_ID, INSERT_TIME ' + char(10)
								SELECT @v_dSql2 += N'	, UPDATE_ID, UPDATE_TIME ' + char(10)
								SELECT @v_dSql2 += N'	, JOB_USER_ID, JOB_TIME, JOB_TYPE ' + char(10)
								SELECT @v_dSql2 += N') ' + char(10)
								SELECT @v_dSql2 += N'SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID ' + char(10)
								SELECT @v_dSql2 += N'	, MODEL_ID, ITEM_ID ' + char(10)
								SELECT @v_dSql2 += N'	, LINE_ID, ELECTRODE_TYPE ' + char(10)
								SELECT @v_dSql2 += N'	, VERSION ' + char(10)
								SELECT @v_dSql2 += N'	, ACTIVE_FLAG, DESCRIPTION ' + char(10)
								SELECT @v_dSql2 += N'	, INSERT_ID, INSERT_TIME ' + char(10)
								SELECT @v_dSql2 += N'	, UPDATE_ID, UPDATE_TIME ' + char(10)
								SELECT @v_dSql2 += N'	, ''' + @v_user_id +  ''' AS JOB_USER_ID, GETDATE() AS JOB_TIME, ''MERGE'' AS JOB_TYPE ' + char(10)
								SELECT @v_dSql2 += N'FROM   SCM_ITEM_CONV_CALC_USE_M A WITH(NOLOCK) ' + char(10)
								SELECT @v_dSql2 += N'WHERE 1=1 ' + char(10)
								SELECT @v_dSql2 += N'AND   A.FACTORY_ID     = ''' + @v_factory_id  + ''' ' + char(10)
								SELECT @v_dSql2 += N'AND   A.MODEL_ID       = ''' + @v_model_id + ''' ' + char(10)
								SELECT @v_dSql2 += N'AND   A.ITEM_ID        = ''' + @v_item_id + ''' ' + char(10)
								SELECT @v_dSql2 += N'AND   A.LINE_ID        = ''' + @v_line_id + '''' + char(10)
								SELECT @v_dSql2 += N'AND   A.ELECTRODE_TYPE = ''' + @v_electrode_type + ''' ' + char(10)
								SELECT @v_dSql2 += N'AND   A.VERSION        = ''' + @v_version + ''' ' + char(10)
								SELECT @v_dSql2 += N'; ' + char(10)

								SELECT @v_dSql = @v_dSql1 + @v_dSql2

					END --'I'

					-- 1. delete buffer data
					IF(@v_sys_flag ='DELETE_EXCEL_SUB_BUFFER')
					BEGIN

						SELECT @v_dSql = ''
						SELECT @v_dSql += ' DELETE FROM BUF_ITEM_CONV_CALC_USE_M ' + char(10)
						SELECT @v_dSql += ' WHERE JOB_USER_ID = '''+ @v_user_id +''' ' + char(10)

					END --'D'
					-- 2. insert buffer data
					ELSE IF(@v_sys_flag ='INSERT_EXCEL_SUB_BUFFER')
					BEGIN
						
						SELECT @v_seq_no += 1
						
						SELECT @v_dSql = ''
						SELECT @v_dSql += N'INSERT INTO BUF_ITEM_CONV_CALC_USE_M ( ' + char(10)
						SELECT @v_dSql += N'	  COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID ' + char(10)
						SELECT @v_dSql += N'	, OPERATION_ID, MODEL_ID, ITEM_ID ' + char(10)
						SELECT @v_dSql += N'	, LINE_ID, ELECTRODE_TYPE ' + char(10)
						SELECT @v_dSql += N'	, VERSION, ACTIVE_FLAG, DESCRIPTION ' + char(10)
						SELECT @v_dSql += N'	, INSERT_ID, INSERT_TIME ' + char(10)
						SELECT @v_dSql += N'	, UPDATE_ID, UPDATE_TIME ' + char(10)
						SELECT @v_dSql += N'	, JOB_USER_ID, JOB_TIME, JOB_TYPE, JOB_ORDER ' + char(10)
						SELECT @v_dSql += N') ' + char(10)
						SELECT @v_dSql += N'VALUES ( ' + char(10)
						SELECT @v_dSql += N'	  ''-'', ''-'', ''-'', ''-'', UPPER(RTRIM(LTRIM(''' + @v_factory_id + '''))) ' + char(10)
						SELECT @v_dSql += N'	, UPPER(RTRIM(LTRIM(''' + @v_operation_id + '''))), UPPER(RTRIM(LTRIM(''' + @v_model_id + '''))), UPPER(RTRIM(LTRIM(''' + @v_item_id + '''))) ' + char(10)
						SELECT @v_dSql += N'	, UPPER(RTRIM(LTRIM(''' + @v_line_id + '''))), UPPER(RTRIM(LTRIM(''' + @v_electrode_type + '''))) ' + char(10)
						SELECT @v_dSql += N'	, UPPER(RTRIM(LTRIM(''' + @v_version + '''))), UPPER(RTRIM(LTRIM(''' + @v_active_flag + '''))), UPPER(RTRIM(LTRIM( N''' + @v_description + '''))) ' + char(10)
						SELECT @v_dSql += N'	, ''' + @v_user_id + ''', GETDATE() ' + char(10)
						SELECT @v_dSql += N'	, ''' + @v_user_id + ''', GETDATE() ' + char(10)
						SELECT @v_dSql += N'	, ''' + @v_user_id + ''', GETDATE(), ''EXCEL'', ' + CONVERT(VARCHAR, @v_seq_no) + ' ' + char(10)
						--SELECT @v_dSql += N'	, ''' + @v_user_id + ''', GETDATE(), ''EXCEL'', 0 ' + char(10)
						SELECT @v_dSql += N') ' + char(10)

					END --'D'
					-- 3. buffer validation
					ELSE IF (@v_sys_flag ='SELECT_EXCEL_SUB_BUFFER')  
					BEGIN
						SELECT @v_dSql = ''
						SELECT @v_dSql += N''
						SELECT @v_dSql += N'SELECT A.* ' + char(10)
						SELECT @v_dSql += N'	, CASE WHEN __MSG = '' Not Found'' THEN (CASE WHEN MSG99 = '''' THEN '''' ELSE MSG99 END) ' + char(10)
						SELECT @v_dSql += N'	       ELSE (CASE WHEN MSG99 = '''' THEN __MSG ELSE __MSG + '' AND '' + MSG99 END) ' + char(10)
						SELECT @v_dSql += N'	       END AS _MSG ' + char(10)
						SELECT @v_dSql += N'	, CASE WHEN __MSG = '' Not Found'' AND MSG99 = '''' THEN ''Y'' ELSE ''N'' END AS _VALID ' + char(10)
						SELECT @v_dSql += N'FROM ( ' + char(10)
						SELECT @v_dSql += N'	SELECT TT.* ' + char(10)
						SELECT @v_dSql += N'		, MSG1 ' + char(10)
						SELECT @v_dSql += N'		+ (CASE WHEN (MSG1 = '''')                                                                        THEN MSG2 ELSE (CASE WHEN MSG2 = '''' THEN '''' ELSE '' ,'' + MSG2 END) END) ' + char(10)
						SELECT @v_dSql += N'		+ (CASE WHEN (MSG1 = '''' AND MSG2 = '''')                                                          THEN MSG3 ELSE (CASE WHEN MSG3 = '''' THEN '''' ELSE '' ,'' + MSG3 END) END) ' + char(10)
						SELECT @v_dSql += N'		+ (CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''')                                            THEN MSG4 ELSE (CASE WHEN MSG4 = '''' THEN '''' ELSE '' ,'' + MSG4 END) END) ' + char(10)
						SELECT @v_dSql += N'		+ (CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''' AND MSG4 = '''')                              THEN MSG5 ELSE (CASE WHEN MSG5 = '''' THEN '''' ELSE '' ,'' + MSG5 END) END) ' + char(10)
						SELECT @v_dSql += N'		+ (CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''' AND MSG4 = '''' AND MSG5 = '''')                THEN MSG6 ELSE (CASE WHEN MSG6 = '''' THEN '''' ELSE '' ,'' + MSG6 END) END) ' + char(10)
						SELECT @v_dSql += N'		+ (CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''' AND MSG4 = '''' AND MSG5 = ''''  AND MSG6 = '''') THEN MSG7 ELSE (CASE WHEN MSG7 = '''' THEN '''' ELSE '' ,'' + MSG7 END) END) ' + char(10)
						SELECT @v_dSql += N'		+ '' Not Found'' AS __MSG ' + char(10)
						SELECT @v_dSql += N'	FROM ( ' + char(10)
						SELECT @v_dSql += N'		SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
						SELECT @v_dSql += N'			 , A.LINE_ID, F.LINE_NAME , A.ELECTRODE_TYPE ' + char(10)
						SELECT @v_dSql += N'			 , A.MODEL_ID, D.NICK_NAME ' + char(10)
						SELECT @v_dSql += N'			 , C.VERSION_TYPE, A.VERSION ' + char(10)
						SELECT @v_dSql += N'			 , A.OPERATION_ID, A.ITEM_ID ' + char(10)
						SELECT @v_dSql += N'			 , ISNULL(E.ACTIVE_FLAG, ''Y'') AS ACTIVE_FLAG ' + char(10)
						SELECT @v_dSql += N'			 , C.PROD_VERSION_TYPE, C.MAX_VER_FLAG, A.DESCRIPTION ' + char(10)
						SELECT @v_dSql += N'			 , '''' AS UPDATE_ID, '''' AS UPDATE_TIME ' + char(10)
						SELECT @v_dSql += N'			 , A.JOB_USER_ID, A.JOB_TIME, A.JOB_TYPE, A.JOB_ORDER ' + char(10)
						SELECT @v_dSql += N'			 , CASE WHEN A.COMPANY_ID IS NULL THEN ''Building'' ELSE '''' END AS MSG1 ' + char(10)
						SELECT @v_dSql += N'			 , CASE WHEN B.LINE_ID IS NULL THEN ''Line Assign'' ELSE '''' END AS MSG2 ' + char(10)
						SELECT @v_dSql += N'			 , CASE WHEN C.VERSION IS NULL THEN ''Version info.'' ELSE '''' END AS MSG3 ' + char(10)
						SELECT @v_dSql += N'			 , CASE WHEN D.ITEM_ID IS NULL THEN ''Model'' ELSE '''' END AS MSG4 ' + char(10)
						SELECT @v_dSql += N'			 , CASE WHEN E.ITEM_ID IS NULL THEN ''Material'' ELSE '''' END AS MSG5 ' + char(10)
						SELECT @v_dSql += N'			 , CASE WHEN F.LINE_ID IS NULL THEN ''Line-Elec.Type'' ELSE '''' END AS MSG6 ' + char(10)
						SELECT @v_dSql += N'			 , CASE WHEN G.YN IS NULL AND (E.ACTIVE_FLAG IS NOT NULL AND E.ACTIVE_FLAG != '''') THEN ''Use Y/N'' ELSE '''' END AS MSG7 ' + char(10)
						SELECT @v_dSql += N'			 , CASE WHEN ROW_NUMBER() OVER(PARTITION BY A.FACTORY_ID, A.OPERATION_ID, A.MODEL_ID, A.ITEM_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.VERSION ' + char(10)
						SELECT @v_dSql += N'            							   ORDER BY     A.FACTORY_ID, A.OPERATION_ID, A.MODEL_ID, A.ITEM_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.VERSION)>1 THEN ''Data Overlap'' ' + char(10)
						SELECT @v_dSql += N'            							   ELSE '''' END AS MSG99 ' + char(10)
						SELECT @v_dSql += N'		FROM ( ' + char(10)
						SELECT @v_dSql += N'			SELECT ISNULL(B.COMPANY_ID, ''-'') AS COMPANY_ID, ISNULL(B.DIVISION_ID, ''-'') AS DIVISION_ID, ISNULL(B.SITE_ID, ''-'') AS SITE_ID, ISNULL(B.PLANT_ID, ''-'') AS PLANT_ID ' + char(10)
						SELECT @v_dSql += N'				 , A.FACTORY_ID, A.OPERATION_ID, A.MODEL_ID, A.ITEM_ID ' + char(10)
						SELECT @v_dSql += N'				 , A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
						SELECT @v_dSql += N'				 , A.VERSION, A.ACTIVE_FLAG, A.DESCRIPTION ' + char(10)
						SELECT @v_dSql += N'				 , A.INSERT_ID, A.INSERT_TIME ' + char(10)
						SELECT @v_dSql += N'				 , A.UPDATE_ID, A.UPDATE_TIME ' + char(10)
						SELECT @v_dSql += N'				 , A.JOB_USER_ID, A.JOB_TIME, A.JOB_TYPE, A.JOB_ORDER ' + char(10)
						SELECT @v_dSql += N'			FROM   BUF_ITEM_CONV_CALC_USE_M A WITH(NOLOCK) ' + char(10)
						SELECT @v_dSql += N'			LEFT OUTER JOIN SCM_FACTORY_M B WITH(NOLOCK) ' + char(10)
						SELECT @v_dSql += N'			ON  A.FACTORY_ID = B.FACTORY_ID ' + char(10)
						SELECT @v_dSql += N'			WHERE  1=1 ' + char(10)
						SELECT @v_dSql += N'			AND    JOB_USER_ID = ''' + @v_user_id + ''' ' + char(10)
						SELECT @v_dSql += N'		) A ' + char(10)
						SELECT @v_dSql += N'		LEFT OUTER HASH JOIN ( ' + char(10)
						SELECT @v_dSql += N'			SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.ITEM_ID, A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
						SELECT @v_dSql += N'			FROM   SCM_ITEM_LINE_ASSIGN_M A WITH(NOLOCK) ' + char(10)
						SELECT @v_dSql += N'			WHERE  1=1 ' + char(10)
						SELECT @v_dSql += N'			AND    A.OPERATION_ID = ''E2000'' ' + char(10)
						SELECT @v_dSql += N'			AND    A.MONTH = CONVERT(VARCHAR(6), GETDATE(), 112) ' + char(10)
						SELECT @v_dSql += N'			AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
						SELECT @v_dSql += N'			AND    A.PRIORITY IN (1,2,3,4,5,6,7,8) ' + char(10)
						SELECT @v_dSql += N'		) B ' + char(10)
						SELECT @v_dSql += N'		ON  A.COMPANY_ID     = B.COMPANY_ID ' + char(10)
						SELECT @v_dSql += N'		AND A.DIVISION_ID    = B.DIVISION_ID ' + char(10)
						SELECT @v_dSql += N'		AND A.SITE_ID        = B.SITE_ID ' + char(10)
						SELECT @v_dSql += N'		AND A.PLANT_ID       = B.PLANT_ID ' + char(10)
						SELECT @v_dSql += N'		AND A.FACTORY_ID     = B.FACTORY_ID ' + char(10)
						SELECT @v_dSql += N'		AND A.OPERATION_ID   = B.OPERATION_ID ' + char(10)
						SELECT @v_dSql += N'		AND A.ITEM_ID        = B.ITEM_ID ' + char(10)
						SELECT @v_dSql += N'		AND A.LINE_ID        = B.LINE_ID ' + char(10)
						SELECT @v_dSql += N'		AND A.ELECTRODE_TYPE = B.ELECTRODE_TYPE ' + char(10)
						SELECT @v_dSql += N'		LEFT OUTER HASH JOIN ( ' + char(10)
						SELECT @v_dSql += N'			SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION AS OPERATION_ID ' + char(10)
						SELECT @v_dSql += N'				 , A.MODEL_ID, A.ITEM_ID, A.VERSION, A.PROD_VERSION_TYPE, A.MAX_VER_FLAG, A.VERSION_TYPE ' + char(10)
						SELECT @v_dSql += N'			FROM   SCM_ITEM_CONV_CALC_M A WITH(NOLOCK) ' + char(10)
						SELECT @v_dSql += N'			WHERE 1=1 ' + char(10)
						SELECT @v_dSql += N'			AND   A.OPERATION = ''E2000'' ' + char(10)
						SELECT @v_dSql += N'			AND   A.CATEGORY IN ( ''cell/batch'', ''Jumbo Roll (cell/m)'', ''Jumbo Roll (m/batch)'', ''Lane Number'', ''Pancake (cell/m)'', ''Pancake (m/batch)'' ) ' + char(10)
						SELECT @v_dSql += N'		) C ' + char(10)
						SELECT @v_dSql += N'		ON  1=1 ' + char(10)
						SELECT @v_dSql += N'		AND A.COMPANY_ID   = C.COMPANY_ID ' + char(10)
						SELECT @v_dSql += N'		AND A.DIVISION_ID  = C.DIVISION_ID ' + char(10)
						SELECT @v_dSql += N'		AND A.SITE_ID      = C.SITE_ID ' + char(10)
						SELECT @v_dSql += N'		AND A.PLANT_ID     = C.PLANT_ID ' + char(10)
						SELECT @v_dSql += N'		AND A.FACTORY_ID   = C.FACTORY_ID ' + char(10)
						SELECT @v_dSql += N'		AND A.OPERATION_ID = C.OPERATION_ID ' + char(10)
						SELECT @v_dSql += N'		AND A.MODEL_ID     = C.MODEL_ID ' + char(10)
						SELECT @v_dSql += N'		AND A.ITEM_ID      = C.ITEM_ID ' + char(10)
						SELECT @v_dSql += N'		AND A.VERSION      = C.VERSION ' + char(10)
						SELECT @v_dSql += N'		LEFT OUTER JOIN SCM_ITEM_M D WITH(NOLOCK) ' + char(10)
						SELECT @v_dSql += N'		ON  1=1 ' + char(10)
						SELECT @v_dSql += N'		AND A.COMPANY_ID   = D.COMPANY_ID ' + char(10)
						SELECT @v_dSql += N'		AND A.DIVISION_ID  = D.DIVISION_ID ' + char(10)
						SELECT @v_dSql += N'		AND A.SITE_ID      = D.SITE_ID ' + char(10)
						SELECT @v_dSql += N'		AND A.MODEL_ID     = D.ITEM_ID ' + char(10)
						SELECT @v_dSql += N'		AND D.ACTIVE_FLAG  = ''Y'' ' + char(10)
						SELECT @v_dSql += N'		LEFT OUTER JOIN SCM_ITEM_M E WITH(NOLOCK) ' + char(10)
						SELECT @v_dSql += N'		ON  1=1 ' + char(10)
						SELECT @v_dSql += N'		AND A.COMPANY_ID   = E.COMPANY_ID ' + char(10)
						SELECT @v_dSql += N'		AND A.DIVISION_ID  = E.DIVISION_ID ' + char(10)
						SELECT @v_dSql += N'		AND A.SITE_ID      = E.SITE_ID ' + char(10)
						SELECT @v_dSql += N'		AND A.ITEM_ID      = E.ITEM_ID ' + char(10)
						SELECT @v_dSql += N'		AND E.ACTIVE_FLAG  = ''Y'' ' + char(10)
						SELECT @v_dSql += N'		LEFT OUTER JOIN SCM_LINE_M F WITH(NOLOCK) ' + char(10)
						SELECT @v_dSql += N'		ON  1=1 ' + char(10)
						SELECT @v_dSql += N'		AND A.COMPANY_ID        = F.COMPANY_ID ' + char(10)
						SELECT @v_dSql += N'		AND A.DIVISION_ID       = F.DIVISION_ID ' + char(10)
						SELECT @v_dSql += N'		AND A.SITE_ID           = F.SITE_ID ' + char(10)
						SELECT @v_dSql += N'		AND A.PLANT_ID          = F.PLANT_ID ' + char(10)
						SELECT @v_dSql += N'		AND A.FACTORY_ID        = F.FACTORY_ID ' + char(10)
						SELECT @v_dSql += N'		AND A.OPERATION_ID      = F.OPERATION_ID ' + char(10)
						SELECT @v_dSql += N'		AND A.LINE_ID           = F.LINE_ID ' + char(10)
						SELECT @v_dSql += N'		AND A.ELECTRODE_TYPE    = F.ELECTRODE_TYPE ' + char(10)
						SELECT @v_dSql += N'		LEFT OUTER JOIN ( ' + char(10)
						SELECT @v_dSql += N'		    SELECT ''Y'' AS YN ' + char(10)
						SELECT @v_dSql += N'		    UNION ALL ' + char(10)
						SELECT @v_dSql += N'		    SELECT ''N'' AS YN ' + char(10)
						SELECT @v_dSql += N'		) G ' + char(10)
						SELECT @v_dSql += N'		ON  1=1 ' + char(10)
						SELECT @v_dSql += N'		AND A.ACTIVE_FLAG        = G.YN ' + char(10)
						SELECT @v_dSql += N'	) TT ' + char(10)
						SELECT @v_dSql += N') A ' + char(10)
						SELECT @v_dSql += N'ORDER BY A.JOB_ORDER ' + char(10)

					END

					IF(@v_sys_flag ='MERGE_EXCEL_SUB')  
					BEGIN
                        SELECT @v_dSql = ''

						SELECT @v_dSql1 = '' + char(10)
                        SELECT @v_dSql1 += 'MERGE INTO SCM_ITEM_CONV_CALC_USE_M AS A ' + char(10)
                        SELECT @v_dSql1 += 'USING ( ' + char(10)
                        SELECT @v_dSql1 += '		SELECT *, ''' + @v_user_id + ''' AS USER_ID, GETDATE() AS USER_TIME ' + char(10)
                        SELECT @v_dSql1 += '		FROM   BUF_ITEM_CONV_CALC_USE_M A WITH(NOLOCK) ' + char(10)
                        SELECT @v_dSql1 += '		, ( ' + char(10)
                        SELECT @v_dSql1 += '			SELECT DISTINCT SEGMENT1 AS ELEC_TYPE ' + char(10)
                        SELECT @v_dSql1 += '			FROM   SCM_SYS_LOOKUP_VALUE B WITH(NOLOCK) ' + char(10)
                        SELECT @v_dSql1 += '			WHERE  1=1 ' + char(10)
                        SELECT @v_dSql1 += '			AND    LOOKUP_TYPE_CODE = ''ELECTRODE_TYPE'' ' + char(10)
                        SELECT @v_dSql1 += '			AND    ACTIVE_FLAG = ''Y'' ' + char(10)
                        SELECT @v_dSql1 += '		) B ' + char(10)
                        SELECT @v_dSql1 += '		WHERE  A.JOB_USER_ID    = ''' + @v_user_id + ''' ' + char(10)
						SELECT @v_dSql1 += '		AND    A.ELECTRODE_TYPE = B.ELEC_TYPE ' + char(10)
                        SELECT @v_dSql1 += ') AS B ' + char(10)
                        SELECT @v_dSql1 += 'ON  A.FACTORY_ID     = B.FACTORY_ID ' + char(10)
                        SELECT @v_dSql1 += 'AND A.MODEL_ID       = B.MODEL_ID ' + char(10)
                        SELECT @v_dSql1 += 'AND A.ITEM_ID        = B.ITEM_ID ' + char(10)
                        SELECT @v_dSql1 += 'AND A.LINE_ID        = B.LINE_ID ' + char(10)
                        SELECT @v_dSql1 += 'AND A.ELECTRODE_TYPE = B.ELECTRODE_TYPE ' + char(10)
                        SELECT @v_dSql1 += 'AND A.VERSION        = B.VERSION ' + char(10)
                        SELECT @v_dSql1 += 'WHEN MATCHED THEN ' + char(10)
                        SELECT @v_dSql1 += '	UPDATE SET ACTIVE_FLAG = B.ACTIVE_FLAG ' + char(10)
                        SELECT @v_dSql1 += '				, DESCRIPTION = B.DESCRIPTION ' + char(10)
                        SELECT @v_dSql1 += '				, UPDATE_ID   = B.USER_ID ' + char(10)
                        SELECT @v_dSql1 += '				, UPDATE_TIME = B.USER_TIME ' + char(10)
                        SELECT @v_dSql1 += 'WHEN NOT MATCHED BY TARGET THEN ' + char(10)
                        SELECT @v_dSql1 += '	INSERT ( ' + char(10)
                        SELECT @v_dSql1 += '    		  COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID ' + char(10)
                        SELECT @v_dSql1 += '    		, MODEL_ID, ITEM_ID ' + char(10)
                        SELECT @v_dSql1 += '    		, LINE_ID, ELECTRODE_TYPE ' + char(10)
                        SELECT @v_dSql1 += '    		, VERSION ' + char(10)
                        SELECT @v_dSql1 += '    		, ACTIVE_FLAG, DESCRIPTION ' + char(10)
                        SELECT @v_dSql1 += '    		, INSERT_ID, INSERT_TIME ' + char(10)
                        SELECT @v_dSql1 += '    		, UPDATE_ID, UPDATE_TIME ' + char(10)
                        SELECT @v_dSql1 += '	) ' + char(10)
                        SELECT @v_dSql1 += '	VALUES ( ' + char(10)
                        SELECT @v_dSql1 += '    		  B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, B.FACTORY_ID, B.OPERATION_ID ' + char(10)
                        SELECT @v_dSql1 += '    		, B.MODEL_ID, B.ITEM_ID ' + char(10)
                        SELECT @v_dSql1 += '    		, B.LINE_ID, B.ELEC_TYPE ' + char(10)
                        SELECT @v_dSql1 += '    		, B.VERSION ' + char(10)
                        SELECT @v_dSql1 += '    		, B.ACTIVE_FLAG, B.DESCRIPTION ' + char(10)
                        SELECT @v_dSql1 += '    		, B.USER_ID, B.USER_TIME ' + char(10)
                        SELECT @v_dSql1 += '    		, B.USER_ID, B.USER_TIME ' + char(10)
                        SELECT @v_dSql1 += '	) ' + char(10)
                        SELECT @v_dSql1 += '; ' + char(10) + char(10)

						SELECT @v_dSql2 = '' + char(10)
                        SELECT @v_dSql2 += 'INSERT INTO HIS_ITEM_CONV_CALC_USE_M ( ' + char(10)
                        SELECT @v_dSql2 += '	  COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID ' + char(10)
                        SELECT @v_dSql2 += '	, MODEL_ID, ITEM_ID ' + char(10)
                        SELECT @v_dSql2 += '	, LINE_ID, ELECTRODE_TYPE ' + char(10)
                        SELECT @v_dSql2 += '	, VERSION ' + char(10)
                        SELECT @v_dSql2 += '	, ACTIVE_FLAG, DESCRIPTION ' + char(10)
                        SELECT @v_dSql2 += '	, INSERT_ID, INSERT_TIME ' + char(10)
                        SELECT @v_dSql2 += '	, UPDATE_ID, UPDATE_TIME ' + char(10)
                        SELECT @v_dSql2 += '	, JOB_USER_ID, JOB_TIME, JOB_TYPE ' + char(10)
                        SELECT @v_dSql2 += ') ' + char(10)
                        SELECT @v_dSql2 += 'SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID ' + char(10)
                        SELECT @v_dSql2 += '	 , A.MODEL_ID, A.ITEM_ID ' + char(10)
                        SELECT @v_dSql2 += '	 , A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
                        SELECT @v_dSql2 += '	 , A.VERSION ' + char(10)
                        SELECT @v_dSql2 += '	 , A.ACTIVE_FLAG, A.DESCRIPTION ' + char(10)
                        SELECT @v_dSql2 += '	 , A.INSERT_ID, A.INSERT_TIME ' + char(10)
                        SELECT @v_dSql2 += '	 , A.UPDATE_ID, A.UPDATE_TIME ' + char(10)
                        SELECT @v_dSql2 += '	 , ''' + @v_user_id + ''' AS JOB_USER_ID, GETDATE() AS JOB_TIME, ''MERGE'' AS JOB_TYPE ' + char(10)
                        SELECT @v_dSql2 += 'FROM   SCM_ITEM_CONV_CALC_USE_M A WITH(NOLOCK), BUF_ITEM_CONV_CALC_USE_M B WITH(NOLOCK) ' + char(10)
                        SELECT @v_dSql2 += 'WHERE  1=1 ' + char(10)
                        SELECT @v_dSql2 += 'AND    A.FACTORY_ID     = B.FACTORY_ID ' + char(10)
                        SELECT @v_dSql2 += 'AND    A.MODEL_ID       = B.MODEL_ID ' + char(10)
                        SELECT @v_dSql2 += 'AND    A.ITEM_ID        = B.ITEM_ID ' + char(10)
                        SELECT @v_dSql2 += 'AND    A.LINE_ID        = B.LINE_ID ' + char(10)
                        SELECT @v_dSql2 += 'AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE ' + char(10)
                        SELECT @v_dSql2 += 'AND    A.VERSION        = B.VERSION ' + char(10)
                        SELECT @v_dSql2 += 'AND    B.JOB_USER_ID    = ''' + @v_user_id + ''' ' + char(10)
                        SELECT @v_dSql2 += '; ' + char(10)

						SELECT @v_dSql = @v_dSql1 + @v_dSql2

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
							EXEC PR_UI_SQL_LOG  @v_proc_name,  @v_user_id, @v_sys_flag,'', @v_dSql,'SELECT',@runstart, @runend
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


