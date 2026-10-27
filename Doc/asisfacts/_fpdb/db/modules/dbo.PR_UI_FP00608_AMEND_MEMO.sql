 

/*
 * Program ID   : PR_UI_FP00608_AMEND_MEMO
 * Description  : Amend Memo
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/05/17   JYJ				Initial Release UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FP00608_AMEND_MEMO]
  @p_sys_type                   NVARCHAR(MAX)='',
  @p_sys_flag                   NVARCHAR(MAX)='',
  @p_sys_gubun                  NVARCHAR(MAX)='',
  @p_user_id                    NVARCHAR(MAX)='',
  @p_instance_id                NVARCHAR(MAX)='',
  @p_company_id                 NVARCHAR(MAX)='',
  @p_division_id                NVARCHAR(MAX)='',
  @p_site_id                    NVARCHAR(MAX)='',
  @p_plant_id                   NVARCHAR(MAX)='',
  @p_factory_id                 NVARCHAR(MAX)='',
  @p_operation_id               NVARCHAR(MAX)='',
  @p_line_id                    NVARCHAR(MAX)='',
  @p_electrode_type             NVARCHAR(MAX)='',
  @p_equipment_id               NVARCHAR(MAX)='',
  @p_market                     NVARCHAR(MAX)='',
  @p_production_type            NVARCHAR(MAX)='',
  @p_top_item_id                NVARCHAR(MAX)='',
  @p_item_id                    NVARCHAR(MAX)='',
  @p_nick_name                  NVARCHAR(MAX)='',
  @p_plan_date                  NVARCHAR(MAX)='',
  @p_memo                       NVARCHAR(MAX)='',
  @p_memo_type                  NVARCHAR(MAX)='',
  @p_attr1                       NVARCHAR(MAX)='',
  @p_attr2                       NVARCHAR(MAX)='',
  @p_start_date                 NVARCHAR(MAX)='',
  @p_end_date                   NVARCHAR(MAX)=''

AS 
BEGIN  --MAIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
    SET NOCOUNT ON                                                                                                                                                                                                                                             
      
	SET XACT_ABORT ON 

	DECLARE @v_sys_type                   NVARCHAR(MAX)  -- 값>> SELEC: SQL저장안함, SQL:SQL저장함
	DECLARE @v_sys_flag                   NVARCHAR(MAX)  -- 값>> I: Insert, M: Update, D: Delete, G: MERGE
	DECLARE @v_sys_gubun                  NVARCHAR(MAX) 
	DECLARE @v_user_id                    NVARCHAR(MAX)
    DECLARE @v_instance_id                NVARCHAR(MAX)
    DECLARE @v_company_id                 NVARCHAR(MAX)
    DECLARE @v_division_id                NVARCHAR(MAX)
    DECLARE @v_site_id                    NVARCHAR(MAX)
    DECLARE @v_plant_id                   NVARCHAR(MAX)
    DECLARE @v_factory_id                 NVARCHAR(MAX)
    DECLARE @v_operation_id               NVARCHAR(MAX)
    DECLARE @v_line_id                    NVARCHAR(MAX)
    DECLARE @v_electrode_type             NVARCHAR(MAX)
    DECLARE @v_equipment_id               NVARCHAR(MAX)
    DECLARE @v_market                     NVARCHAR(MAX)
    DECLARE @v_production_type            NVARCHAR(MAX)
    DECLARE @v_top_item_id                NVARCHAR(MAX)
    DECLARE @v_item_id                    NVARCHAR(MAX)
    DECLARE @v_nick_name                  NVARCHAR(MAX)
    DECLARE @v_plan_date                  NVARCHAR(MAX)
    DECLARE @v_memo                       NVARCHAR(MAX)
    DECLARE @v_memo_type                  NVARCHAR(MAX)
    DECLARE @v_start_date                 NVARCHAR(MAX)
    DECLARE @v_end_date                   NVARCHAR(MAX)
    DECLARE @v_attr1                   NVARCHAR(MAX)
    DECLARE @v_attr2                   NVARCHAR(MAX)

	DECLARE @recv_active_flag       NVARCHAR(MAX)				    
	DECLARE @v_proc_name	        NVARCHAR(100) = 'PR_UI_FP00608_AMEND_MEMO'
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
    SET @v_instance_id              = ''
    SET @v_company_id               = ''
    SET @v_division_id              = ''
    SET @v_site_id                  = ''
    SET @v_plant_id                 = ''
    SET @v_factory_id               = ''
    SET @v_operation_id             = ''
    SET @v_line_id                  = ''
    SET @v_electrode_type           = ''
    SET @v_equipment_id             = ''
    SET @v_market                   = ''
    SET @v_production_type          = ''
    SET @v_top_item_id              = ''
    SET @v_item_id                  = ''
    SET @v_nick_name                = ''
    SET @v_plan_date                = ''
    SET @v_memo                     = ''
    SET @v_memo_type                = ''
    SET @v_start_date               = ''
    SET @v_end_date                 = ''
    SET @v_attr1                 = ''
    SET @v_attr2                 = ''


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
	IF(@p_sys_flag ='SELECT')
		BEGIN --IF(START)
		    
			SELECT @v_dSql = ''

            SELECT @v_dSql += ' SELECT A.INSTANCE_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID           ' + char(10)
            SELECT @v_dSql += '      , A.OPERATION_ID, A.LINE_ID, ISNULL(B.LINE_NAME,''-'') AS LINE_NAME, A.ELECTRODE_TYPE       ' + char(10)
            SELECT @v_dSql += '      , A.EQUIPMENT_ID, A.MARKET, A.PRODUCTION_TYPE, A.TOP_ITEM_ID, A.ITEM_ID                     ' + char(10)
            SELECT @v_dSql += '      , ISNULL(C.NICK_NAME,''-'') AS NICK_NAME, CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE     ' + char(10)
			SELECT @v_dSql += '      ,  A.MEMO, A.MEMO_TYPE, A.INSERT_ID, CONVERT(VARCHAR,A.INSERT_TIME,120) AS INSERT_TIME      ' + char(10)
            SELECT @v_dSql += '      , A.ATTR1,A.ATTR2,''LINE'' AS MEMO_RANGE                            ' + char(10)
            SELECT @v_dSql += '      , A.UPDATE_ID, CONVERT(VARCHAR,A.UPDATE_TIME,120) AS UPDATE_TIME                            ' + char(10)
            SELECT @v_dSql += '      ,ISNULL(T.UI_DESC,'''') AS ATTR1_TXT ' + char(10)
            SELECT @v_dSql += ' FROM   FP_AMEND_MEMO_M A     WITH(NOLOCK)                                                        ' + char(10)
            SELECT @v_dSql += ' LEFT OUTER JOIN SCM_LINE_M B WITH(NOLOCK)                                                        ' + char(10)
            SELECT @v_dSql += ' ON  A.COMPANY_ID      = B.COMPANY_ID                                                             ' + char(10)
            SELECT @v_dSql += ' AND A.DIVISION_ID     = B.DIVISION_ID                                           
                 ' + char(10)
            SELECT @v_dSql += ' AND A.SITE_ID         = B.SITE_ID                                                                ' + char(10)
            SELECT @v_dSql += ' AND A.PLANT_ID        = B.PLANT_ID                                                               ' + char(10)
            SELECT @v_dSql += ' AND A.FACTORY_ID      = B.FACTORY_ID                                                             ' + char(10)
            SELECT @v_dSql += ' AND A.OPERATION_ID    = B.OPERATION_ID                                                           ' + char(10)
            SELECT @v_dSql += ' AND A.LINE_ID         = B.LINE_ID                                                                ' + char(10)
            SELECT @v_dSql += ' AND A.ELECTRODE_TYPE  = B.ELECTRODE_TYPE                                                         ' + char(10)
            SELECT @v_dSql += ' LEFT OUTER JOIN SCM_ITEM_M C WITH(NOLOCK)                                                        ' + char(10)
            SELECT @v_dSql += ' ON  A.COMPANY_ID      = C.COMPANY_ID                                                             ' + char(10)
            SELECT @v_dSql += ' AND A.DIVISION_ID     = C.DIVISION_ID                                                            ' + char(10)
            SELECT @v_dSql += ' AND A.SITE_ID         = C.SITE_ID                                                                ' + char(10)
            SELECT @v_dSql += ' AND A.TOP_ITEM_ID     = C.ITEM_ID                                                                ' + char(10)

			SELECT @v_dSql += '            LEFT OUTER JOIN' + char(10)
			SELECT @v_dSql += '(SELECT SEGMENT1     AS INSTANCE_ID ' + char(10)                     		
			SELECT @v_dSql += '                         , SEGMENT2     AS UI_PARAM    ' + char(10)                     		
			--SELECT @v_dSql += '                         --, SEGMENT3     AS UI_DEF   ' + char(10)                      	  	         													
			--SELECT @v_dSql += '                         --, SEGMENT4     AS UI_COLOR   ' + char(10)                     											
			SELECT @v_dSql += '                         , SEGMENT5     AS MEA_VALUE   ' + char(10)                    
			SELECT @v_dSql += '						 , ACTIVE_FLAG AS ACTIVE_FLAG' + char(10)
			--SELECT @v_dSql += '                         --, ATTRIBUTE1   AS TYPE   ' + char(10)                         
			SELECT @v_dSql += '                         , ATTRIBUTE2   AS UI_DESC     ' + char(10)                       
			--SELECT @v_dSql += '						 --,LOOKUP_TYPE_CODE' + char(10)
			SELECT @v_dSql += '                       FROM   	SCM_SYS_LOOKUP_VALUE B      ' + char(10)            
			SELECT @v_dSql += '                       WHERE  	B.LOOKUP_TYPE_CODE = ''UI_AMEND_COLOR'' ' + char(10)
			SELECT @v_dSql += '                       AND 	B.ACTIVE_FLAG = ''Y'') AS T                ' + char(10)
			SELECT @v_dSql += 'ON A.INSTANCE_ID = T.INSTANCE_ID' + char(10)
			SELECT @v_dSql += 'AND A.ATTR1 = UI_PARAM' + char(10)


            SELECT @v_dSql += ' WHERE CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_start_date +''' AND '''+ @p_end_date +''' ' + char(10)
            
			SELECT @v_dSql +=  (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))                      + char(10)
            SELECT @v_dSql +=  (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))                              + char(10)
            SELECT @v_dSql +=  (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))                            + char(10)
            SELECT @v_dSql +=  (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))                        + char(10)
            SELECT @v_dSql +=  (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))                    + char(10)
            SELECT @v_dSql +=  (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))                              + char(10)
            
			IF LEN(@p_top_item_id) > 0 																			                
                BEGIN																						                
                    SELECT @v_dSql += ' AND  A.TOP_ITEM_ID LIKE ''%'' + '''+ @p_top_item_id +''' + ''%''                       ' + char(10)
                END	
            IF LEN(@p_item_id) > 0 																			                
                BEGIN																						                
                    SELECT @v_dSql += ' AND  A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%''                               ' + char(10)
                END
            
			SELECT @v_dSql += ' AND   A.MEMO_TYPE = '''+ @p_memo_type +'''                                                      ' + char(10)
			
			
			
			SELECT @v_dSql += ' ORDER BY A.INSTANCE_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                    ' + char(10)
            SELECT @v_dSql += '     , A.FACTORY_ID, A.LINE_ID, A.OPERATION_ID DESC, A.MARKET                                    ' + char(10)
            SELECT @v_dSql += '     , A.PRODUCTION_TYPE, A.TOP_ITEM_ID, A.ITEM_ID, A.PLAN_DATE                                  ' + char(10)


			IF @p_sys_type = 'SQL'
				BEGIN
					--EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,',',@v_dSql,'select',@runstart, @runend
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

						SELECT @v_sys_type            = [dbo].[SCM_ARR_SPL_VAL](@p_sys_type ,@v_delimiter, @mst_loop_cnt)
						, @v_sys_flag                 = [dbo].[SCM_ARR_SPL_VAL](@p_sys_flag ,@v_delimiter, @mst_loop_cnt)
						, @v_sys_gubun                = [dbo].[SCM_ARR_SPL_VAL](@p_sys_gubun ,@v_delimiter, @mst_loop_cnt)
						, @v_user_id                  = [dbo].[SCM_ARR_SPL_VAL](@p_user_id ,@v_delimiter, @mst_loop_cnt)
						, @v_instance_id              = [dbo].[SCM_ARR_SPL_VAL](@p_instance_id ,@v_delimiter, @mst_loop_cnt)
						, @v_company_id               = [dbo].[SCM_ARR_SPL_VAL](@p_company_id ,@v_delimiter, @mst_loop_cnt)
						, @v_division_id              = [dbo].[SCM_ARR_SPL_VAL](@p_division_id ,@v_delimiter, @mst_loop_cnt)
						, @v_site_id                  = [dbo].[SCM_ARR_SPL_VAL](@p_site_id ,@v_delimiter, @mst_loop_cnt)
						, @v_plant_id                 = [dbo].[SCM_ARR_SPL_VAL](@p_plant_id ,@v_delimiter, @mst_loop_cnt)
						, @v_factory_id               = [dbo].[SCM_ARR_SPL_VAL](@p_factory_id ,@v_delimiter, @mst_loop_cnt)
						, @v_operation_id             = [dbo].[SCM_ARR_SPL_VAL](@p_operation_id ,@v_delimiter, @mst_loop_cnt)
						, @v_line_id                  = [dbo].[SCM_ARR_SPL_VAL](@p_line_id ,@v_delimiter, @mst_loop_cnt)
						, @v_electrode_type           = [dbo].[SCM_ARR_SPL_VAL](@p_electrode_type ,@v_delimiter, @mst_loop_cnt)
						, @v_equipment_id             = [dbo].[SCM_ARR_SPL_VAL](@p_equipment_id ,@v_delimiter, @mst_loop_cnt)
						, @v_market                   = [dbo].[SCM_ARR_SPL_VAL](@p_market ,@v_delimiter, @mst_loop_cnt)
						, @v_production_type          = [dbo].[SCM_ARR_SPL_VAL](@p_production_type ,@v_delimiter, @mst_loop_cnt)
						, @v_top_item_id              = [dbo].[SCM_ARR_SPL_VAL](@p_top_item_id ,@v_delimiter, @mst_loop_cnt)
						, @v_item_id                  = [dbo].[SCM_ARR_SPL_VAL](@p_item_id ,@v_delimiter, @mst_loop_cnt)
						, @v_nick_name                = [dbo].[SCM_ARR_SPL_VAL](@p_nick_name ,@v_delimiter, @mst_loop_cnt)
						, @v_plan_date                = [dbo].[SCM_ARR_SPL_VAL](@p_plan_date ,@v_delimiter, @mst_loop_cnt)
						, @v_memo                     = [dbo].[SCM_ARR_SPL_VAL](@p_memo ,@v_delimiter, @mst_loop_cnt)
						, @v_memo_type                = [dbo].[SCM_ARR_SPL_VAL](@p_memo_type ,@v_delimiter, @mst_loop_cnt)
						, @v_start_date               = [dbo].[SCM_ARR_SPL_VAL](@p_start_date ,@v_delimiter, @mst_loop_cnt)
						, @v_end_date                 = [dbo].[SCM_ARR_SPL_VAL](@p_end_date ,@v_delimiter, @mst_loop_cnt)
						, @v_attr1                 = [dbo].[SCM_ARR_SPL_VAL](@p_attr1 ,@v_delimiter, @mst_loop_cnt)
						, @v_attr2                 = [dbo].[SCM_ARR_SPL_VAL](@p_attr2 ,@v_delimiter, @mst_loop_cnt)
					   
					   /******************************************************************************/
					   /* INSERT/UPDATE/DELETE 경우 : 본화면                                         */
					   /******************************************************************************/
					   IF(@v_sys_flag ='INSERT' Or @v_sys_flag ='UPDATE' Or @v_sys_flag ='MERGE')  
							BEGIN
                                SELECT @v_dSql1 = ''
								--SELECT @v_dSql1 += + @p_attr1 + char(10) + @p_attr2 + char(10)
                                SELECT @v_dSql1 += ' MERGE INTO FP_AMEND_MEMO_M A                                                                                ' + char(10)
                                SELECT @v_dSql1 += ' USING ( SELECT '''+ @v_instance_id +''' AS INSTANCE_ID, ( SELECT MAX(KK.COMPANY_ID) AS COMPANY_ID           ' + char(10)
                                SELECT @v_dSql1 += '                      FROM SCM_FACTORY_M KK WITH(NOLOCK)                                                     ' + char(10)
                                SELECT @v_dSql1 += '                      WHERE KK.FACTORY_ID = '''+ @v_factory_id +''' ) AS COMPANY_ID                          ' + char(10)
                                SELECT @v_dSql1 += '           , '''+ @v_division_id +''' AS DIVISION_ID, '''+ @v_site_id +''' AS SITE_ID                        ' + char(10)
                                SELECT @v_dSql1 += '           , '''+ @v_plant_id +''' AS PLANT_ID, '''+ @v_factory_id +''' AS FACTORY_ID                        ' + char(10)
                                SELECT @v_dSql1 += '           , '''+ @v_operation_id +''' AS OPERATION_ID , '''+ @v_line_id +''' AS LINE_ID                     ' + char(10)
                                SELECT @v_dSql1 += '           , '''+ @v_electrode_type +''' AS ELECTRODE_TYPE , '''+ @v_equipment_id +''' AS EQUIPMENT_ID       ' + char(10)
                                SELECT @v_dSql1 += '           , CONVERT(DATETIME,'''+ @v_plan_date +''') AS PLAN_DATE , '''+ @v_market +''' AS MARKET           ' + char(10)
                                SELECT @v_dSql1 += '           , '''+ @v_production_type +''' AS PRODUCTION_TYPE , '''+ @v_top_item_id +''' AS TOP_ITEM_ID       ' + char(10)
                                SELECT @v_dSql1 += '           , '''+ @v_item_id +''' AS ITEM_ID, N'''+ @v_memo +''' AS MEMO,N'''+ @v_attr1 +''' AS ATTR1,N'''+ @v_attr2 +''' AS ATTR2, '''+ @v_memo_type +''' AS MEMO_TYPE ' + char(10)
                                SELECT @v_dSql1 += '           , '''+ @v_user_id +''' AS USER_ID, dbo.FN_SITE_TIME('''+ @v_site_id +''') AS USER_TIME ) B        ' + char(10)
                                SELECT @v_dSql1 += ' ON (      A.INSTANCE_ID    = B.INSTANCE_ID      AND A.COMPANY_ID = B.COMPANY_ID                             ' + char(10)
                                SELECT @v_dSql1 += '       AND A.DIVISION_ID    = B.DIVISION_ID      AND A.SITE_ID = B.SITE_ID                                   ' + char(10)
                                SELECT @v_dSql1 += '       AND A.PLANT_ID       = B.PLANT_ID         AND A.FACTORY_ID = B.FACTORY_ID                             ' + char(10)
                                SELECT @v_dSql1 += '       AND A.OPERATION_ID   = B.OPERATION_ID     AND A.LINE_ID = B.LINE_ID                                   ' + char(10)
                                SELECT @v_dSql1 += '       AND A.ELECTRODE_TYPE = B.ELECTRODE_TYPE   AND A.PLAN_DATE = B.PLAN_DATE                               ' + char(10)
                                SELECT @v_dSql1 += '       AND A.MARKET         = B.MARKET           AND A.PRODUCTION_TYPE = B.PRODUCTION_TYPE                   ' + char(10)
                                SELECT @v_dSql1 += '       AND A.TOP_ITEM_ID    = B.TOP_ITEM_ID      AND A.ITEM_ID = B.ITEM_ID ' + char(10)
                                SELECT @v_dSql1 += '       AND A.MEMO_TYPE      = B.MEMO_TYPE )                                ' + char(10)
                                SELECT @v_dSql1 += ' WHEN MATCHED THEN                                                         ' + char(10)
                                SELECT @v_dSql1 += '   UPDATE SET MEMO = B.MEMO,ATTR1=B.ATTR1,ATTR2=B.ATTR2                    ' + char(10)
                                SELECT @v_dSql1 += '       , UPDATE_ID = B.USER_ID, UPDATE_TIME = B.USER_TIME                  ' + char(10)
                                SELECT @v_dSql1 += ' WHEN NOT MATCHED THEN                                                     ' + char(10)
                                SELECT @v_dSql1 += ' INSERT (                                                                  ' + char(10)
                                SELECT @v_dSql1 += '    INSTANCE_ID, COMPANY_ID, DIVISION_ID, SITE_ID                          ' + char(10)
                                SELECT @v_dSql1 += '   , PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID                           ' + char(10)
                                SELECT @v_dSql1 += '   , ELECTRODE_TYPE, EQUIPMENT_ID, PLAN_DATE, MARKET                       ' + char(10)
                                SELECT @v_dSql1 += '   , PRODUCTION_TYPE, TOP_ITEM_ID, ITEM_ID, MEMO,ATTR1,ATTR2               ' + char(10)
                                SELECT @v_dSql1 += '   , MEMO_TYPE, INSERT_ID, INSERT_TIME, UPDATE_ID                          ' + char(10)
                                SELECT @v_dSql1 += '   , UPDATE_TIME                                                           ' + char(10)
                                SELECT @v_dSql1 += ' )                                                                         ' + char(10)
                                SELECT @v_dSql1 += ' VALUES (                                                                  ' + char(10)
                                SELECT @v_dSql1 += '    B.INSTANCE_ID, B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID                  ' + char(10)
                                SELECT @v_dSql1 += '   , B.PLANT_ID, B.FACTORY_ID, B.OPERATION_ID, B.LINE_ID                   ' + char(10)
                                SELECT @v_dSql1 += '   , B.ELECTRODE_TYPE, B.EQUIPMENT_ID, B.PLAN_DATE, B.MARKET               ' + char(10)
                                SELECT @v_dSql1 += '   , B.PRODUCTION_TYPE, B.TOP_ITEM_ID, B.ITEM_ID, B.MEMO ,B.ATTR1,B.ATTR2  ' + char(10)
                                SELECT @v_dSql1 += '   , B.MEMO_TYPE, B.USER_ID, B.USER_TIME, B.USER_ID                        ' + char(10)
                                SELECT @v_dSql1 += '   , B.USER_TIME                                       ' + char(10)
                                SELECT @v_dSql1 += ' ) ;                                                                       ' + char(10)
                                
                                SELECT @v_dSql2  = ''
                                SELECT @v_dSql2 += ' INSERT INTO HIS_AMEND_MEMO_M (                                            ' + char(10)
                                SELECT @v_dSql2 += '        INSTANCE_ID, COMPANY_ID, DIVISION_ID, SITE_ID                      ' + char(10)
                                SELECT @v_dSql2 += '       , PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID                       ' + char(10)
                                SELECT @v_dSql2 += '       , ELECTRODE_TYPE, EQUIPMENT_ID, PLAN_DATE, MARKET                   ' + char(10)
                                SELECT @v_dSql2 += ' 	  , PRODUCTION_TYPE, TOP_ITEM_ID, ITEM_ID, MEMO,ATTR1,ATTR2                        ' + char(10)
                                SELECT @v_dSql2 += '       , MEMO_TYPE, INSERT_ID, INSERT_TIME, UPDATE_ID                      ' + char(10)
                                SELECT @v_dSql2 += '       , UPDATE_TIME, JOB_USER_ID, JOB_TIME, JOB_TYPE                      ' + char(10)
                                SELECT @v_dSql2 += ' )                                                                         ' + char(10)
                                SELECT @v_dSql2 += ' SELECT INSTANCE_ID, COMPANY_ID, DIVISION_ID, SITE_ID                      ' + char(10)
                                SELECT @v_dSql2 += '       , PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID                       ' + char(10)
                                SELECT @v_dSql2 += '       , ELECTRODE_TYPE, EQUIPMENT_ID, PLAN_DATE, MARKET                   ' + char(10)
                                SELECT @v_dSql2 += ' 	  , PRODUCTION_TYPE, TOP_ITEM_ID, ITEM_ID, MEMO,ATTR1,ATTR2                        ' + char(10)
                                SELECT @v_dSql2 += '       , MEMO_TYPE, INSERT_ID, INSERT_TIME, UPDATE_ID                      ' + char(10)
                                SELECT @v_dSql2 += '       , UPDATE_TIME, '''+ @v_user_id +''', GETDATE(), ''UPDATE''          ' + char(10)
                                SELECT @v_dSql2 += ' FROM   FP_AMEND_MEMO_M A WITH(NOLOCK)                                     ' + char(10)
                                SELECT @v_dSql2 += ' WHERE  A.INSTANCE_ID      = '''+ @v_instance_id +'''                      ' + char(10)
                                SELECT @v_dSql2 += ' AND    A.DIVISION_ID      = '''+ @v_division_id +'''                      ' + char(10)
                                SELECT @v_dSql2 += ' AND    A.SITE_ID          = '''+ @v_site_id +'''                          ' + char(10)
                                SELECT @v_dSql2 += ' AND    A.PLANT_ID         = '''+ @v_plant_id +'''                         ' + char(10)
                                SELECT @v_dSql2 += ' AND    A.FACTORY_ID       = '''+ @v_factory_id +'''                       ' + char(10)
                                SELECT @v_dSql2 += ' AND    A.OPERATION_ID     = '''+ @v_operation_id +'''                     ' + char(10)
                                SELECT @v_dSql2 += ' AND    A.LINE_ID          = '''+ @v_line_id +'''                          ' + char(10)
                                SELECT @v_dSql2 += ' AND    A.ELECTRODE_TYPE   = '''+ @v_electrode_type +'''                   ' + char(10)
                                SELECT @v_dSql2 += ' AND    A.PLAN_DATE        = CONVERT(DATETIME,'''+ @v_plan_date +''')      ' + char(10)
                                SELECT @v_dSql2 += ' AND    A.MARKET           = '''+ @v_market +'''                           ' + char(10)
                                SELECT @v_dSql2 += ' AND    A.PRODUCTION_TYPE  = '''+ @v_production_type +'''                  ' + char(10)
SELECT @v_dSql2 += ' AND    A.TOP_ITEM_ID      = '''+ @v_top_item_id +'''                      ' + char(10)
                                SELECT @v_dSql2 += ' AND    A.ITEM_ID          = '''+ @v_item_id +'''                          ' + char(10)
                                SELECT @v_dSql2 += ' AND    A.MEMO_TYPE        = '''+ @v_memo_type +'''                        ' + char(10)

								SELECT @v_dSql = @v_dSql1 + @v_dSql2

						   END --'I'
					   /******************************************************************************/
					   /* INSERT 팝업경우 : INSERT(merge_createWPP)                                      */
					   /******************************************************************************/
					   ELSE IF(@v_sys_flag ='DELETE')  
							BEGIN
                                SELECT @v_dSql = ''
                                SELECT @v_dSql += ' INSERT INTO HIS_AMEND_MEMO_M ( ' + char(10)
                                SELECT @v_dSql += '        INSTANCE_ID             ' + char(10)
                                SELECT @v_dSql += '       ,COMPANY_ID              ' + char(10)
                                SELECT @v_dSql += '       ,DIVISION_ID             ' + char(10)
                                SELECT @v_dSql += '       ,SITE_ID                 ' + char(10)
                                SELECT @v_dSql += '       ,PLANT_ID                ' + char(10)
                                SELECT @v_dSql += '       ,FACTORY_ID              ' + char(10)
                                SELECT @v_dSql += '       ,OPERATION_ID            ' + char(10)
                                SELECT @v_dSql += '       ,LINE_ID                 ' + char(10)
                                SELECT @v_dSql += '       ,ELECTRODE_TYPE          ' + char(10)
                                SELECT @v_dSql += '       ,EQUIPMENT_ID            ' + char(10)
                                SELECT @v_dSql += '       ,PLAN_DATE               ' + char(10)
                                SELECT @v_dSql += '       ,MARKET                  ' + char(10)
                                SELECT @v_dSql += '       ,PRODUCTION_TYPE         ' + char(10)
                                SELECT @v_dSql += '       ,TOP_ITEM_ID             ' + char(10)
                                SELECT @v_dSql += '       ,ITEM_ID                 ' + char(10)
                                SELECT @v_dSql += '       ,MEMO                    ' + char(10)
                                SELECT @v_dSql += '       ,INSERT_ID, INSERT_TIME  ' + char(10)
                                SELECT @v_dSql += '       ,UPDATE_ID, UPDATE_TIME  ' + char(10)
                                SELECT @v_dSql += '       ,JOB_USER_ID, JOB_TIME   ' + char(10)
								SELECT @v_dSql += '       ,JOB_TYPE                ' + char(10)
                                SELECT @v_dSql += ' )                              ' + char(10)
                                SELECT @v_dSql += ' SELECT INSTANCE_ID             ' + char(10)
                                SELECT @v_dSql += '       ,COMPANY_ID              ' + char(10)
                                SELECT @v_dSql += '       ,DIVISION_ID             ' + char(10)
                                SELECT @v_dSql += '       ,SITE_ID                 ' + char(10)
                                SELECT @v_dSql += '       ,PLANT_ID                ' + char(10)
                                SELECT @v_dSql += '       ,FACTORY_ID              ' + char(10)
                                SELECT @v_dSql += '       ,OPERATION_ID            ' + char(10)
                                SELECT @v_dSql += '       ,LINE_ID                 ' + char(10)
                                SELECT @v_dSql += '       ,ELECTRODE_TYPE          ' + char(10)
                                SELECT @v_dSql += '       ,EQUIPMENT_ID            ' + char(10)
                                SELECT @v_dSql += '       ,PLAN_DATE    ' + char(10)
                                SELECT @v_dSql += '       ,MARKET                  ' + char(10)
                                SELECT @v_dSql += '       ,PRODUCTION_TYPE         ' + char(10)
                                SELECT @v_dSql += '       ,TOP_ITEM_ID             ' + char(10)
                                SELECT @v_dSql += '       ,ITEM_ID                 ' + char(10)
                                SELECT @v_dSql += '       ,MEMO                    ' + char(10)
                                SELECT @v_dSql += '       ,INSERT_ID, INSERT_TIME  ' + char(10)
                                SELECT @v_dSql += '       ,UPDATE_ID, UPDATE_TIME  ' + char(10)
                                SELECT @v_dSql += '       ,'''+ @v_user_id +''' , GETDATE()                              ' + char(10)
								SELECT @v_dSql += '       , ''DELETE'' AS JOB_TYPE                                       ' + char(10)
                                SELECT @v_dSql += ' FROM   FP_AMEND_MEMO_M A WITH(NOLOCK)                                ' + char(10)
                                SELECT @v_dSql += ' WHERE  A.INSTANCE_ID      = '''+ @v_instance_id +'''                 ' + char(10)
                                SELECT @v_dSql += ' AND    A.DIVISION_ID      = '''+ @v_division_id +'''                 ' + char(10)
                                SELECT @v_dSql += ' AND    A.SITE_ID          = '''+ @v_site_id +'''                     ' + char(10)
                                SELECT @v_dSql += ' AND    A.PLANT_ID         = '''+ @v_plant_id +'''                    ' + char(10)
                                SELECT @v_dSql += ' AND    A.FACTORY_ID       = '''+ @v_factory_id +'''                  ' + char(10)
                                SELECT @v_dSql += ' AND    A.OPERATION_ID     = '''+ @v_operation_id +'''                ' + char(10)
                                SELECT @v_dSql += ' AND    A.LINE_ID          = '''+ @v_line_id +'''                     ' + char(10)
                                SELECT @v_dSql += ' AND    A.ELECTRODE_TYPE   = '''+ @v_electrode_type +'''              ' + char(10)
                                SELECT @v_dSql += ' AND    A.PLAN_DATE        = CONVERT(DATETIME,'''+ @v_plan_date +''') ' + char(10)
                                SELECT @v_dSql += ' AND    A.MARKET           = '''+ @v_market +'''                      ' + char(10)
                                SELECT @v_dSql += ' AND    A.PRODUCTION_TYPE  = '''+ @v_production_type +'''             ' + char(10)
                                SELECT @v_dSql += ' AND    A.TOP_ITEM_ID      = '''+ @v_top_item_id +'''                 ' + char(10)
                                SELECT @v_dSql += ' AND    A.ITEM_ID          = '''+ @v_item_id +'''                     ' + char(10)
                                SELECT @v_dSql += ' '
                                SELECT @v_dSql += ' DELETE FROM FP_AMEND_MEMO_M ' + char(10)
                                SELECT @v_dSql += ' WHERE  A.INSTANCE_ID      = '''+ @v_instance_id +'''                 ' + char(10)
                                SELECT @v_dSql += ' AND    A.DIVISION_ID      = '''+ @v_division_id +'''                 ' + char(10)
                                SELECT @v_dSql += ' AND    A.SITE_ID          = '''+ @v_site_id +'''                     ' + char(10)
                                SELECT @v_dSql += ' AND    A.PLANT_ID         = '''+ @v_plant_id +'''                    ' + char(10)
                                SELECT @v_dSql += ' AND    A.FACTORY_ID       = '''+ @v_factory_id +'''                  ' + char(10)
                                SELECT @v_dSql += ' AND    A.OPERATION_ID     = '''+ @v_operation_id +'''                ' + char(10)
                                SELECT @v_dSql += ' AND    A.LINE_ID          = '''+ @v_line_id +'''                     ' + char(10)
                                SELECT @v_dSql += ' AND    A.ELECTRODE_TYPE   = '''+ @v_electrode_type +'''              ' + char(10)
                                SELECT @v_dSql += ' AND    A.PLAN_DATE        = CONVERT(DATETIME,'''+ @v_plan_date +''') ' + char(10)
                                SELECT @v_dSql += ' AND    A.MARKET           = '''+ @v_market +'''                      ' + char(10)
                                SELECT @v_dSql += ' AND    A.PRODUCTION_TYPE  = '''+ @v_production_type +'''             ' + char(10)
                                SELECT @v_dSql += ' AND    A.TOP_ITEM_ID      = '''+ @v_top_item_id +'''                 ' + char(10)
                                SELECT @v_dSql += ' AND    A.ITEM_ID          = '''+ @v_item_id +'''                     ' + char(10)

						   END --'I'

					IF @v_sys_type = 'SQL'
						BEGIN
							--EXEC PR_UI_SQL_LOG @v_proc_name,  @v_user_id,',',@v_dSql,'select',@runstart, @runend
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

 