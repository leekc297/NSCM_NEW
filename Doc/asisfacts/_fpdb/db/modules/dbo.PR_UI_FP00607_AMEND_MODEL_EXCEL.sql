CREATE PROCEDURE [dbo].[PR_UI_FP00607_AMEND_MODEL_EXCEL]
  @p_sys_type			nvarchar(MAX),  
  @p_sys_flag			nvarchar(MAX),
  @p_sys_gubun			nvarchar(MAX),  
  @p_user_id			nvarchar(MAX),
  @in_columns           nvarchar(MAX),  --keys (상위구분자 ^, 하위구분자: |)
  @in_row               nvarchar(MAX),  --value(상위구분자 ^, 하위구분자: |)
  @opt_none             nvarchar(5) = 'N'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_UI_FP00607_AMEND_MODEL_EXCEL                                           **/
/** 프로그램 명   : Procedure PR_UI_FP00607_AMEND_MODEL_EXCEL                                 **/
/** 설 명         :                                                                           **/
/** Version       : 1.5.0(Auto)                                                               **/
/** Argument                                                                                  **/
/** [검색 조건]                                                                               **/
/** [Biz Logic]                                                                               **/
/**-------------------------------------------------------------------------------------------**/
/** 작 성 일 자    작 성 자      사     유                                                    **/
/**===========================================================================================**/
/** 2021-09-27     XPDbToProcedure      Auto Generated With Initial Setting                   **/
/***********************************************************************************************/

BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
  SET NOCOUNT ON; 
  SET XACT_ABORT ON;
  
  --DECLARE BASE PARAMETER START

  DECLARE @v_dSql               NVARCHAR(max)
  DECLARE @v_dSql1              NVARCHAR(max)
  DECLARE @v_dSql2              NVARCHAR(max)
  DECLARE @v_dSql3              NVARCHAR(max)
  DECLARE @v_tmp                NVARCHAR(MAX) = '' 

  DECLARE @v_Err                NVARCHAR(max)
  DECLARE @v_log_message        NVARCHAR(max) 
  DECLARE @v_proc_name          NVARCHAR(100) = 'PR_UI_FP00607_AMEND_MODEL_EXCEL'

  DECLARE @p_instance_id        NVARCHAR(max) = ''
  DECLARE @p_plan_date          NVARCHAR(max) = ''
  DECLARE @p_plan_id            NVARCHAR(max) = ''
  DECLARE @p_company_id         NVARCHAR(max) = ''
  DECLARE @p_division_id        NVARCHAR(max) = ''
  DECLARE @p_site_id            NVARCHAR(max) = ''
  DECLARE @p_plant_id           NVARCHAR(max) = ''
  DECLARE @p_factory_id         NVARCHAR(max) = ''
  DECLARE @p_line_id            NVARCHAR(max) = '' 
  DECLARE @p_operation_id       NVARCHAR(max) = ''
  DECLARE @p_top_item_id        NVARCHAR(max) = ''
  DECLARE @p_item_id            NVARCHAR(max) = ''
  DECLARE @p_item_type          NVARCHAR(max) = ''
  DECLARE @p_nick_name          NVARCHAR(max) = ''
  DECLARE @p_prod_type          NVARCHAR(max) = ''
  DECLARE @p_location           NVARCHAR(max) = ''
  DECLARE @p_market             NVARCHAR(max) = ''
  DECLARE @p_electrode_type     NVARCHAR(max) = ''
  DECLARE @p_cell_qty           NVARCHAR(max) = ''
  DECLARE @p_qty                NVARCHAR(max) = ''
  DECLARE @p_new_seq_no         NVARCHAR(max) = ''
  DECLARE @p_bucket_from        NVARCHAR(max) = ''
  DECLARE @p_bucket_to          NVARCHAR(max) = ''
  DECLARE @p_bucket             NVARCHAR(max) = ''
  DECLARE @p_day_info           NVARCHAR(max) = ''
  DECLARE @p_mpp_wpp            NVARCHAR(max) = ''
  DECLARE @p_cell_group_code    NVARCHAR(max) = ''

  DECLARE @v_instance_id        NVARCHAR(max)
  DECLARE @v_plan_date          NVARCHAR(max)
  DECLARE @v_plan_id            NVARCHAR(max)
  DECLARE @v_fp_plan_id         NVARCHAR(max)
  DECLARE @v_company_id         NVARCHAR(max)
  DECLARE @v_division_id        NVARCHAR(max)
  DECLARE @v_site_id            NVARCHAR(max)
  DECLARE @v_plant_id           NVARCHAR(max)
  DECLARE @v_factory_id         NVARCHAR(max)
  DECLARE @v_line_id            NVARCHAR(max)
  DECLARE @v_operation_id       NVARCHAR(max)
  DECLARE @v_top_item_id        NVARCHAR(max)
  DECLARE @v_item_id            NVARCHAR(max)
  DECLARE @v_item_type          NVARCHAR(max)
  DECLARE @v_nick_name          NVARCHAR(max)
  DECLARE @v_prod_type          NVARCHAR(max)
  DECLARE @v_location           NVARCHAR(max)
  DECLARE @v_market             NVARCHAR(max)
  DECLARE @v_electrode_type     NVARCHAR(max)
  DECLARE @v_cell_qty           NVARCHAR(max)
  DECLARE @v_qty                NVARCHAR(max)
  DECLARE @v_new_seq_no         NVARCHAR(max)
  DECLARE @v_bucket_from        NVARCHAR(max)
  DECLARE @v_bucket_to          NVARCHAR(max)
  DECLARE @v_bucket             NVARCHAR(max)
  DECLARE @v_day_info           NVARCHAR(max)
  DECLARE @v_mpp_wpp            NVARCHAR(max)
  DECLARE @v_cell_group_code    NVARCHAR(max)


  DECLARE @tmp_column           NVARCHAR(MAX) = ''
  DECLARE @v_param              NVARCHAR(max)
  DECLARE @v_queryset1          NVARCHAR(max)

  DECLARE @runstart             datetime
  DECLARE @runend               datetime
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  DECLARE @v_delimiter          NVARCHAR(2)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  DECLARE @sub_mst_loop_cnt     INTEGER = 0
  DECLARE @sub_max_loop_cnt     INTEGER = 0
  DECLARE @sub_v_delimiter      NVARCHAR(2) = '|'
  DECLARE @sub_tmp_column       NVARCHAR(MAX) = ''
  DECLARE @v_seq_no             INTEGER = 0
  DECLARE @v_cnt	            INTEGER = 0

  SET @v_delimiter            = '^'  -- 데이터 구분자
  SET @sub_v_delimiter        = '|'  -- SUB 데이터 구분자
  SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@in_columns, @v_delimiter) -- 프로시저 LOOP 길이를 판단--'^' 데이터 구분자로 @in_column(key)정보갯수 구하기
  
  --'^'  -- 데이터 구분자로 @in_row(value)정보 셋팅
  WHILE @mst_loop_cnt < @max_loop_cnt
       BEGIN 
            SET @mst_loop_cnt   = @mst_loop_cnt + 1;	-- @mst_loop_cnt 1증가
            SET @tmp_column		= [dbo].[SCM_ARR_SPL_VAL]( @in_columns, @v_delimiter, @mst_loop_cnt);

	        IF @tmp_column = 'INSTANCE_ID' 
			    BEGIN
                  SET @p_instance_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row		,@v_delimiter, @mst_loop_cnt);
                END 
			ELSE IF @tmp_column = 'PLAN_DATE' 
			    BEGIN
                  SET @p_plan_date =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			,@v_delimiter, @mst_loop_cnt);
                END 
			ELSE IF @tmp_column = 'PLAN_ID' 
			    BEGIN
                  SET @p_plan_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			,@v_delimiter, @mst_loop_cnt);
                END 
			ELSE IF @tmp_column = 'DIVISION_ID' 
			    BEGIN
                  SET @p_division_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row		,@v_delimiter, @mst_loop_cnt);
                END 
			ELSE IF @tmp_column = 'SITE_ID' 
			    BEGIN
                  SET @p_site_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			,@v_delimiter, @mst_loop_cnt);
                END
			ELSE IF @tmp_column = 'PLANT_ID' 
			    BEGIN
                  SET @p_plant_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			,@v_delimiter, @mst_loop_cnt);
                END 
			ELSE IF @tmp_column = 'FACTORY_ID' 
			    BEGIN
                  SET @p_factory_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			,@v_delimiter, @mst_loop_cnt);
                END 
			ELSE IF @tmp_column = 'LINE_ID' 
			    BEGIN
                  SET @p_line_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			,@v_delimiter, @mst_loop_cnt);
                END 
			ELSE IF @tmp_column = 'OPERATION_ID' 
			    BEGIN
                  SET @p_operation_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row		,@v_delimiter, @mst_loop_cnt);
                END 
			ELSE IF @tmp_column = 'TOP_ITEM_ID' 
			    BEGIN
                  SET @p_top_item_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row		,@v_delimiter, @mst_loop_cnt);
                END 
			ELSE IF @tmp_column = 'ITEM_ID' 
			    BEGIN
                  SET @p_item_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			,@v_delimiter, @mst_loop_cnt);
                END 
			ELSE IF @tmp_column = 'NICK_NAME' 
			    BEGIN
                  SET @p_nick_name =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			,@v_delimiter, @mst_loop_cnt);
                END 
			ELSE IF @tmp_column = 'PROD_TYPE' 
			    BEGIN
                  SET @p_prod_type =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			,@v_delimiter, @mst_loop_cnt);
                END 
			ELSE IF @tmp_column = 'LOCATION' 
			    BEGIN
                  SET @p_location =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			,@v_delimiter, @mst_loop_cnt);
                END 
            ELSE IF @tmp_column = 'MARKET' 
			    BEGIN
                  SET @p_market =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			,@v_delimiter, @mst_loop_cnt);
                END 
            ELSE IF @tmp_column = 'ELECTRODE_TYPE' 
			    BEGIN
                  SET @p_electrode_type =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			,@v_delimiter, @mst_loop_cnt);
                END 	
            ELSE IF @tmp_column = 'QTY' 
			    BEGIN
                  SET @p_qty =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			,@v_delimiter, @mst_loop_cnt);
                END 	
            ELSE IF @tmp_column = 'CELL_QTY' 
			    BEGIN
                  SET @p_cell_qty =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			,@v_delimiter, @mst_loop_cnt);
                END 	
            ELSE IF @tmp_column = 'NEW_SEQ' 
			    BEGIN
                  SET @p_new_seq_no =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			,@v_delimiter, @mst_loop_cnt);
                END 
			ELSE IF @tmp_column = 'BUCKET_FROM' 
			    BEGIN
                  SET @p_bucket_from =  [dbo].[SCM_ARR_SPL_VAL]( @in_row		,@v_delimiter, @mst_loop_cnt);
                END 
			ELSE IF @tmp_column = 'BUCKET_TO' 
			    BEGIN
                  SET @p_bucket_to =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			,@v_delimiter, @mst_loop_cnt);
                END 
			ELSE IF @tmp_column = 'BUCKET' 
			    BEGIN
                  SET @p_bucket =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
                END 
			ELSE IF @tmp_column = 'DAY_INFO' 
			    BEGIN
                  SET @p_day_info =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			,@v_delimiter, @mst_loop_cnt);
	            END 
			ELSE IF @tmp_column = 'MPP_WPP' 
			    BEGIN
                  SET @p_mpp_wpp =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			,@v_delimiter, @mst_loop_cnt);
	            END 
			ELSE IF @tmp_column = 'CELL_GROUP_CODE' 
			    BEGIN
                  SET @p_cell_group_code =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			,@v_delimiter, @mst_loop_cnt);
	            END 

       END --END( WHILE)

       --SELECT @v_instance_id = @p_instance_id,  @v_plan_id      = @p_plan_id,      @v_bucket_from  = @p_bucket_from, @v_bucket_to   = @p_bucket_to
       --     , @v_site_id     = @p_site_id,      @v_operation_id = @p_operation_id, @v_top_item_id  = @p_top_item_id, @v_nick_name   = @p_nick_name
       --     , @v_prod_type   = @p_prod_type,    @v_bucket       = @p_bucket

     /************************************************************************************************/
     /* SELECT인경우 :SELECT_IMPORT_COLUMN  Excel Import COLUMN TYPE인경우 SELECT                    */
     /************************************************************************************************/
    IF(@p_sys_flag = 'SELECT_IMPORT_COLUMN')
        BEGIN
            --find_ExcelImport
			SELECT @v_dSql  = ''
            SELECT @v_dSql += ' SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
            SELECT @v_dSql += '     , A.TOP_ITEM_ID, A.ITEM_ID, C.ITEM_TYPE, ISNULL(C.NICK_NAME,''-'') AS NICK_NAME ' + char(10)
            SELECT @v_dSql += '     , A.OPERATION_ID                                    ' + char(10)
            SELECT @v_dSql += '     , A.MARKET, A.PRODUCTION_TYPE                       ' + char(10)
            SELECT @v_dSql += '     , A.CUSTOMER_ID                                     ' + char(10)
            SELECT @v_dSql += '     , A.FACTORY_ID, A.LOCATION                          ' + char(10)
            SELECT @v_dSql += '     , A.LINE_ID, ISNULL(D.LINE_NAME,''-'') AS LINE_NAME ' + char(10)
            SELECT @v_dSql += '     , A.ELECTRODE_TYPE                                  ' + char(10)
            SELECT @v_dSql += '     , A.CELL_GROUP_CODE                                 ' + char(10)


            IF ISNULL(@p_day_info,'') <> '' 
        	    BEGIN
                    SET @sub_mst_loop_cnt      = 0
                    SET @sub_v_delimiter       = '|' -- 데이터 구분자
                    SET @sub_max_loop_cnt      = 0
                    SET @sub_max_loop_cnt      = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @sub_v_delimiter) -- 프로시저 LOOP 길이를 판단

                    WHILE LEN(@p_day_info) > 0 AND @sub_mst_loop_cnt < @sub_max_loop_cnt
                        BEGIN
                            SELECT @sub_mst_loop_cnt = @sub_mst_loop_cnt + 1
                            SELECT @v_day_info = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@sub_v_delimiter, @sub_mst_loop_cnt)
                            SELECT @v_dSql += '    , SUM(CONVERT(NUMERIC, CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)=''' + @v_day_info + ''' THEN A.OUT_QTY ELSE NULL END)) AS D' + TRY_CONVERT(NVARCHAR,@sub_mst_loop_cnt-1) +'_CELL' + char(10)
                        END 
                END
            SELECT @v_dSql += ' FROM   FP_AMEND_PLAN_FORM_R A WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += ' LEFT OUTER JOIN (                          ' + char(10)
            SELECT @v_dSql += '     SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, ' + char(10)
            SELECT @v_dSql += '            A.ITEM_ID,                                       ' + char(10)
            SELECT @v_dSql += '            (CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME ' + char(10)
            SELECT @v_dSql += '            	     WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'') ' + char(10)
            SELECT @v_dSql += '            	     ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE, ' + char(10)
            SELECT @v_dSql += '            ISNULL(A.NICK_NAME,''-'') AS NICK_NAME  ' + char(10)
            SELECT @v_dSql += '     FROM	 SCM_ITEM_M A WITH(NOLOCK),            ' + char(10)
            SELECT @v_dSql += '       		 SCM_ITEM_CLASS_M C WITH(NOLOCK)       ' + char(10)
            SELECT @v_dSql += '     WHERE	 A.ITEM_CLASS  = C.CLASS_ID            ' + char(10)
            SELECT @v_dSql += ' ) C                                                ' + char(10)
            SELECT @v_dSql += ' ON     A.COMPANY_ID     = C.COMPANY_ID             ' + char(10)
            SELECT @v_dSql += ' AND    A.DIVISION_ID    = C.DIVISION_ID            ' + char(10)
            SELECT @v_dSql += ' AND    A.SITE_ID        = C.SITE_ID                ' + char(10)
            SELECT @v_dSql += ' AND    A.ITEM_ID        = C.ITEM_ID                ' + char(10)
            SELECT @v_dSql += ' LEFT OUTER JOIN SCM_LINE_M D WITH(NOLOCK)          ' + char(10)
            SELECT @v_dSql += ' ON     A.COMPANY_ID     = D.COMPANY_ID             ' + char(10)
            SELECT @v_dSql += ' AND    A.DIVISION_ID    = D.DIVISION_ID            ' + char(10)
            SELECT @v_dSql += ' AND    A.SITE_ID        = D.SITE_ID                ' + char(10)
            SELECT @v_dSql += ' AND    A.PLANT_ID       = D.PLANT_ID               ' + char(10)
            SELECT @v_dSql += ' AND    A.FACTORY_ID     = D.FACTORY_ID             ' + char(10)
            SELECT @v_dSql += ' AND    A.OPERATION_ID   = D.OPERATION_ID           ' + char(10)
            SELECT @v_dSql += ' AND    A.LINE_ID        = D.LINE_ID                ' + char(10)
            SELECT @v_dSql += ' AND    A.ELECTRODE_TYPE = D.ELECTRODE_TYPE         ' + char(10)
            SELECT @v_dSql += ' WHERE  A.INSTANCE_ID    = '''+ @p_instance_id +''' ' + char(10)
            SELECT @v_dSql += ' AND    A.FP_PLAN_ID     = '''+ @p_plan_id +'''     ' + char(10)
            SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
			IF LEN(@p_site_id) > 0 																			                
        	    BEGIN																						                
                    SELECT @v_dSql += ' AND  A.SITE_ID  = '''+ @p_site_id +''' ' + char(10)
        	    END	

            SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))          + char(10)
            SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))      + char(10)
            SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))  + char(10)
            SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))            + char(10)
																							           
        	IF LEN(@p_item_id) > 0 																			                           
        	    BEGIN																						                           
                    SELECT @v_dSql += ' AND  A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%''                           ' + char(10)
        	    END		
        	IF LEN(@p_nick_name) > 0 																			                           
        	    BEGIN
				    
					SELECT @v_cnt = CHARINDEX(',', @p_nick_name)
					
					IF @v_cnt > 0
					    BEGIN
				            SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.NICK_NAME' , 'EQ', @p_nick_name))      + char(10)
						END
					ELSE
					    BEGIN
						    SELECT @v_dSql += ' AND  C.NICK_NAME LIKE ''%'' + '''+ @p_nick_name +''' + ''%''                       ' + char(10)
						END
        	    END	

            SELECT @v_dSql += ' GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID               ' + char(10)
            SELECT @v_dSql += '        , A.TOP_ITEM_ID, A.ITEM_ID, C.ITEM_TYPE, ISNULL(C.NICK_NAME,''-'') ' + char(10)
            SELECT @v_dSql += '        , A.OPERATION_ID                       ' + char(10)
            SELECT @v_dSql += '        , A.MARKET, A.PRODUCTION_TYPE          ' + char(10)
            SELECT @v_dSql += '        , A.CUSTOMER_ID                        ' + char(10)
            SELECT @v_dSql += '        , A.FACTORY_ID, A.LOCATION             ' + char(10)
            SELECT @v_dSql += '        , A.LINE_ID, ISNULL(D.LINE_NAME,''-'') ' + char(10)
            SELECT @v_dSql += '        , A.ELECTRODE_TYPE                     ' + char(10)
            SELECT @v_dSql += '        , A.CELL_GROUP_CODE                    ' + char(10)
            SELECT @v_dSql += ' ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID       ' + char(10)
            SELECT @v_dSql += '        , A.CELL_GROUP_CODE, A.TOP_ITEM_ID, A.ITEM_ID, C.ITEM_TYPE ' + char(10)
            SELECT @v_dSql += '        , A.OPERATION_ID              ' + char(10)
            SELECT @v_dSql += '        , A.MARKET, A.PRODUCTION_TYPE ' + char(10)
            SELECT @v_dSql += '        , A.CUSTOMER_ID               ' + char(10)
            SELECT @v_dSql += '        , A.FACTORY_ID, A.LOCATION    ' + char(10)
            SELECT @v_dSql += '        , A.LINE_ID                   ' + char(10)
            SELECT @v_dSql += '        , A.ELECTRODE_TYPE            ' + char(10)          
			
			IF @p_sys_type = 'SQL'
				BEGIN
					--EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
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
	/* SELECT인경우 :SELECT_IMPORT_ROW : Excel Import ROW TYPE인경우 SELECT                         */
	/************************************************************************************************/
    ELSE IF(@p_sys_flag ='SELECT_IMPORT_ROW')
		BEGIN --IF(START)
            SELECT @v_dSql = ''
            
            SELECT @v_dSql += 'SELECT A.INSTANCE_ID, A.FP_PLAN_ID                         ' + char(10)  
            SELECT @v_dSql += '      , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)  
            SELECT @v_dSql += '      , A.ITEM_ID, ISNULL(B.NICK_NAME,''-'') AS NICK_NAME, ISNULL(B.ITEM_TYPE,''-'') AS ITEM_TYPE ' + char(10)  
            SELECT @v_dSql += '      , A.OPERATION_ID, A.FACTORY_ID, A.LOCATION                            ' + char(10)  
            SELECT @v_dSql += '      , A.PRODUCTION_TYPE, A.MARKET                                         ' + char(10)  
            SELECT @v_dSql += '      , A.LINE_ID, ISNULL(C.LINE_NAME,''-'') AS LINE_NAME, A.ELECTRODE_TYPE ' + char(10)  
            SELECT @v_dSql += '      , A.CUSTOMER_ID, CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE        ' + char(10)  
            SELECT @v_dSql += '      , A.TOP_ITEM_ID, A.CELL_GROUP_CODE                        ' + char(10)  
            SELECT @v_dSql += '      , A.OUT_QTY AS QTY                                        ' + char(10)  
            SELECT @v_dSql += ' FROM   FP_AMEND_PLAN_FORM_R A WITH(NOLOCK)                     ' + char(10)  
            SELECT @v_dSql += ' INNER JOIN (                                                   ' + char(10)  
            SELECT @v_dSql += '        SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, ' + char(10)  
            SELECT @v_dSql += '               A.ITEM_ID,                                       ' + char(10)  
            SELECT @v_dSql += '               (CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME ' + char(10)  
            SELECT @v_dSql += '               	     WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'') ' + char(10)  
            SELECT @v_dSql += '               	     ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE, ' + char(10)  
            SELECT @v_dSql += '               ISNULL(A.NICK_NAME,''-'') AS NICK_NAME        ' + char(10)  
            SELECT @v_dSql += '        FROM	 SCM_ITEM_M A WITH(NOLOCK),                     ' + char(10)  
            SELECT @v_dSql += '          		 SCM_ITEM_CLASS_M C WITH(NOLOCK)            ' + char(10)  
            SELECT @v_dSql += '        WHERE	 A.ITEM_CLASS  = C.CLASS_ID                 ' + char(10)  
            SELECT @v_dSql += ' ) B                                                ' + char(10)  
            SELECT @v_dSql += ' ON  A.COMPANY_ID  = B.COMPANY_ID                   ' + char(10)  
            SELECT @v_dSql += ' AND A.DIVISION_ID = B.DIVISION_ID                  ' + char(10)  
            SELECT @v_dSql += ' AND A.SITE_ID     = B.SITE_ID                      ' + char(10)  
            SELECT @v_dSql += ' AND A.ITEM_ID     = B.ITEM_ID                      ' + char(10)  
            SELECT @v_dSql += ' LEFT OUTER JOIN SCM_LINE_M C WITH(NOLOCK)          ' + char(10)  
            SELECT @v_dSql += ' ON     A.COMPANY_ID     = C.COMPANY_ID             ' + char(10)  
            SELECT @v_dSql += ' AND    A.DIVISION_ID    = C.DIVISION_ID            ' + char(10)  
            SELECT @v_dSql += ' AND    A.SITE_ID        = C.SITE_ID                ' + char(10)  
            SELECT @v_dSql += ' AND    A.PLANT_ID       = C.PLANT_ID               ' + char(10)  
            SELECT @v_dSql += ' AND    A.FACTORY_ID     = C.FACTORY_ID             ' + char(10)  
            SELECT @v_dSql += ' AND    A.OPERATION_ID   = C.OPERATION_ID           ' + char(10)  
            SELECT @v_dSql += ' AND    A.LINE_ID        = C.LINE_ID                ' + char(10)  
            SELECT @v_dSql += ' AND    A.ELECTRODE_TYPE = C.ELECTRODE_TYPE         ' + char(10)  
            SELECT @v_dSql += ' WHERE  A.INSTANCE_ID    = '''+ @p_instance_id +''' ' + char(10)  
            SELECT @v_dSql += ' AND    A.FP_PLAN_ID     = '''+ @p_plan_id +'''     ' + char(10)  
            SELECT @v_dSql += ' AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +''' ' + char(10)  
            SELECT @v_dSql += ' AND    A.OUT_QTY > 0                                                               ' + char(10)  
            SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
			IF LEN(@p_site_id) > 0 																			                
        	    BEGIN																						                
                    SELECT @v_dSql += ' AND  A.SITE_ID  = '''+ @p_site_id +''' ' + char(10)
        	    END	

            SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))          + char(10)
            SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))      + char(10)
            SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))  + char(10)
            SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))            + char(10)
        	
			--IF LEN(@p_cell_group_code) > 0 																			                           
   --     	    BEGIN																						                           
   --                 SELECT @v_dSql += ' AND  A.CELL_GROUP_CODE LIKE ''%'' + '''+  @p_cell_group_code +''' + ''%''          ' + char(10)
   --     	    END																									           
        	IF LEN(@p_item_id) > 0 																			                           
        	    BEGIN																						                           
                    SELECT @v_dSql += ' AND  A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%''                           ' + char(10)
        	    END		
        	IF LEN(@p_nick_name) > 0 																			                           
        	    BEGIN
				    
					SELECT @v_cnt = CHARINDEX(',', @p_nick_name)
					
					IF @v_cnt > 0
					    BEGIN
				            SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.NICK_NAME' , 'EQ', @p_nick_name)) + char(10)
						END
					ELSE
					    BEGIN
						    SELECT @v_dSql += ' AND  B.NICK_NAME LIKE ''%'' + '''+ @p_nick_name +''' + ''%''                  ' + char(10)
						END
        	    END					

            SELECT @v_dSql += ' ORDER BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.TOP_ITEM_ID, A.ITEM_ID, A.OPERATION_ID ' + char(10)
            SELECT @v_dSql += '        , A.MARKET, A.PRODUCTION_TYPE, A.CUSTOMER_ID, A.FACTORY_ID, A.LINE_ID, PLAN_DATE ' + char(10)

			IF @p_sys_type = 'SQL'
				BEGIN
					--EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
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

	ELSE
	    SELECT @v_dSql = 'SQL Statement is null. p_sys_flag value is error.!'
	    BEGIN
	    	--EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
	    	SELECT @v_dSql as [QUERY_VALUE]
	    
	    END  

END
