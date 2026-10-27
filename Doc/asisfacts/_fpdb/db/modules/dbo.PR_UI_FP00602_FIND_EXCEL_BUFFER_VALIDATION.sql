CREATE PROCEDURE [dbo].[PR_UI_FP00602_FIND_EXCEL_BUFFER_VALIDATION]
  @p_sys_type			nvarchar(MAX),  
  @p_sys_flag			nvarchar(MAX),
  @p_sys_gubun			nvarchar(MAX),  
  @p_user_id			nvarchar(MAX),
  @in_columns nvarchar(MAX),
  @in_row nvarchar(MAX),
  @opt_none nvarchar(5) = 'N'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_UI_FP00602_FIND_EXCEL_BUFFER_VALIDATION                                                            **/
/** 프로그램 명   : Procedure PR_UI_FP00602_FIND_EXCEL_BUFFER_VALIDATION                                                                          **/
/** 설 명         :                                                                           **/
/** Version       : 1.5.0(Auto)                                                                     **/
/**                                                                                           **/
/** Argument                                                                                  **/
/**                                                                                           **/
/** [검색 조건]                                                                              **/
/**                                                                                           **/
/** [Biz Logic]                                                                               **/
/**                                                                                           **/
/**-------------------------------------------------------------------------------------------**/
/** 작 성 일 자    작 성 자      사     유                                                    **/
/**===========================================================================================**/
/** 2021-04-05     XPDbToProcedure      Auto Generated With Initial Setting                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP00602_FIND_EXCEL_BUFFER_VALIDATION
*/

BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
  SET NOCOUNT ON; 
  SET XACT_ABORT ON;
  
  --DECLARE BASE PARAMETER START
  DECLARE @STRLEN nvarchar(max)
  DECLARE @runstart datetime
  DECLARE @runend datetime
  DECLARE @v_dSql nvarchar(max)
  DECLARE @v_Err nvarchar(max)
  DECLARE @v_Log nvarchar(max) 
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP00602_FIND_EXCEL_BUFFER_VALIDATION'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  DECLARE @p_master_id nvarchar(max) = ''
  DECLARE @p_plan_id nvarchar(max) = ''
  DECLARE @p_instance_id nvarchar(max) = ''
  DECLARE @p_param nvarchar(max) = ''
  DECLARE @p_queryset1 nvarchar(max) = ''


  DECLARE @v_user_id nvarchar(max)
  DECLARE @v_master_id nvarchar(max)
  DECLARE @v_plan_id nvarchar(max)
  DECLARE @v_instance_id nvarchar(max)
  DECLARE @v_param nvarchar(max)
  DECLARE @v_queryset1 nvarchar(max)

  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START
  DECLARE @opt_0user_id nvarchar(max)
  DECLARE @opt_1user_id nvarchar(max)

  --Optional Parameter Part END

  SET @v_delimiter            = '^'  -- 데이터 구분자
  SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@in_columns, @v_delimiter) -- 프로시저 LOOP 길이를 판단
  DECLARE @tmp_column nvarchar(MAX) = ''
  WHILE @mst_loop_cnt < @max_loop_cnt
  BEGIN -- 각 컬럼들에 대한 스플릿처리로직 스타트	
	SET @mst_loop_cnt = @mst_loop_cnt + 1;	-- @mst_loop_cnt 1증가

	SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @in_columns			    ,@v_delimiter, @mst_loop_cnt);
	IF @tmp_column = '_SAVE_AUTH' BEGIN
		SET @tmp_column =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'MASTER_ID' BEGIN
      SET @p_master_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLAN_ID' BEGIN
      SET @p_plan_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'INSTANCE_ID' BEGIN
      SET @p_instance_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PARAM' BEGIN
      SET @p_param =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'QUERYSET1' BEGIN
      SET @p_queryset1 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
		SET @tmp_column =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END
  END
  
  SET @v_user_id ='''' + @p_user_id + ''''
  SET @v_master_id ='''' + @p_master_id + ''''
  SET @v_plan_id ='''' + @p_plan_id + ''''
  SET @v_instance_id ='''' + @p_instance_id + ''''
  SET @v_param ='''' + @p_param + ''''
  SET @v_queryset1 ='''' + @p_queryset1 + ''''

  SET @STRLEN = LEN(@p_user_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_0user_id = ''
  END ELSE BEGIN
    SET @opt_0user_id = 'There are two or more operation of data.'
  END
  SET @STRLEN = LEN(@p_user_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_1user_id = ''
  END ELSE BEGIN
    SET @opt_1user_id = 'There are two or more operation of data.'
  END


  -- FP00602 find_Excel_buffer_validation  
  SET @v_dSql = ''
  SET @v_dSql += '      SELECT A.*'+char(10)
  SET @v_dSql += '            ,CASE WHEN __MSG = '' Not Found'' THEN (CASE WHEN MSG99 = '''' THEN '''' ELSE MSG99 END)'+char(10)
  SET @v_dSql += '                  ELSE (CASE WHEN MSG99 = '''' THEN __MSG ELSE __MSG + '' AND '' + MSG99 END)'+char(10)
  SET @v_dSql += '                  END AS _MSG'+char(10)
  SET @v_dSql += '            ,CASE WHEN __MSG = '' Not Found'' AND MSG99 = '''' THEN ''Y'' ELSE ''N'' END AS _VALID'+char(10)
  SET @v_dSql += '      FROM ('+char(10)
  SET @v_dSql += '          SELECT TT.*'+char(10)
  SET @v_dSql += '                ,MSG1'+char(10)
  SET @v_dSql += '                +(CASE WHEN (MSG1 = '''')                                                                                                                                 THEN MSG2 ELSE (CASE WHEN MSG2 = '''' THEN '''' ELSE '','' + MSG2 END) END)'+char(10)
  SET @v_dSql += '                +(CASE WHEN (MSG1 = '''' AND MSG2 = '''')                                                                                                                   THEN MSG3 ELSE (CASE WHEN MSG3 = '''' THEN '''' ELSE '','' + MSG3 END) END)'+char(10)
  SET @v_dSql += '                +(CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''')                                                                                                     THEN MSG4 ELSE (CASE WHEN MSG4 = '''' THEN '''' ELSE '','' + MSG4 END) END)'+char(10)
  SET @v_dSql += '                +(CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''' AND MSG4 = '''')                                                                                       THEN MSG5 ELSE (CASE WHEN MSG5 = '''' THEN '''' ELSE '','' + MSG5 END) END)'+char(10)
  SET @v_dSql += '                +(CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''' AND MSG4 = '''' AND MSG5 = '''')                                                                         THEN MSG6 ELSE (CASE WHEN MSG6 = '''' THEN '''' ELSE '','' + MSG6 END) END)'+char(10)
  SET @v_dSql += '                +(CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''' AND MSG4 = '''' AND MSG5 = '''' AND MSG6 = '''')                                                           THEN MSG7 ELSE (CASE WHEN MSG7 = '''' THEN '''' ELSE '','' + MSG7 END) END)'+char(10)
  SET @v_dSql += '                +(CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''' AND MSG4 = '''' AND MSG5 = '''' AND MSG6 = '''' AND MSG7 = '''')                                             THEN MSG8 ELSE (CASE WHEN MSG8 = '''' THEN '''' ELSE '','' + MSG8 END) END)'+char(10)
  SET @v_dSql += '                +(CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''' AND MSG4 = '''' AND MSG5 = '''' AND MSG6 = '''' AND MSG7 = '''' AND MSG8 = '''')                               THEN MSG9 ELSE (CASE WHEN MSG9 = '''' THEN '''' ELSE '','' + MSG9 END) END)'+char(10)
  SET @v_dSql += '                +(CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''' AND MSG4 = '''' AND MSG5 = '''' AND MSG6 = '''' AND MSG7 = '''' AND MSG8 = '''' AND MSG9 = '''')                 THEN MSG10 ELSE (CASE WHEN MSG10 = '''' THEN '''' ELSE '','' + MSG10 END) END)'+char(10)
  SET @v_dSql += '                +(CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''' AND MSG4 = '''' AND MSG5 = '''' AND MSG6 = '''' AND MSG7 = '''' AND MSG8 = '''' AND MSG9 = '''' AND MSG10 = '''')  THEN MSG11 ELSE (CASE WHEN MSG11 = '''' THEN '''' ELSE '','' + MSG11 END) END)'+char(10)
  SET @v_dSql += '                + '' Not Found'' AS __MSG'+char(10)
  SET @v_dSql += '          FROM ('+char(10)
  SET @v_dSql += '              SELECT DISTINCT'+char(10)
  SET @v_dSql += '                     A.INSTANCE_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '                    ,A.ITEM_ID, B.NICK_NAME, B.ITEM_TYPE, A.TOP_ITEM_ID'+char(10)
  SET @v_dSql += '                    ,A.OPERATION_ID, A.FACTORY_ID'+char(10)
  SET @v_dSql += '                    ,A.PRODUCTION_TYPE, A.MARKET'+char(10)
  SET @v_dSql += '                    ,A.LINE_ID, A.ELECTRODE_TYPE, A.LOCATION'+char(10)
  SET @v_dSql += '                    ,A.PLAN_DATE, A.QTY'+char(10)
  SET @v_dSql += '                    ,A.JOB_USER_ID, A.JOB_TIME, A.JOB_TYPE, A.JOB_ORDER'+char(10)
  SET @v_dSql += '                    ,CASE WHEN A.COMPANY_ID IS NULL THEN ''Building'' ELSE '''' END AS MSG1'+char(10)
  SET @v_dSql += '                    ,CASE WHEN B.ITEM_ID IS NULL THEN ''Material'' ELSE '''' END AS MSG2'+char(10)
  SET @v_dSql += '                    ,CASE WHEN C.OPERATION_ID IS NULL THEN ''Operation'' ELSE '''' END AS MSG3'+char(10)
  SET @v_dSql += '                    ,CASE WHEN D.LINE_ID IS NULL THEN ''Line - Electrode Type - Location'' ELSE '''' END AS MSG4'+char(10)
  SET @v_dSql += '                    ,CASE WHEN E.CODE_ID IS NULL THEN ''Production Type'' ELSE '''' END AS MSG5'+char(10)
  SET @v_dSql += '                    ,CASE WHEN F.CODE_ID IS NULL THEN ''Market'' ELSE '''' END AS MSG6'+char(10)
  SET @v_dSql += '                    --,CASE WHEN DENSE_RANK() OVER(ORDER BY A.OPERATION_ID)>1 THEN '''+char(10)
  --SET @v_dSql += ' ' +@opt_0user_id +' '+''+char(10)--There are two or more operation of data.
  --SET @v_dSql += ''' ELSE '''' END MSG7'+char(10)
  SET @v_dSql += '                    ,'''' AS MSG7'+char(10)
  SET @v_dSql += '                    ,'''' AS MSG8'+char(10)
  SET @v_dSql += '                		,CASE WHEN A.QTY > 0 THEN (CASE WHEN (A.OPERATION_ID IN (''A3000'',''A9000'',''P5500'',''P9500'') AND A.PRODUCTION_TYPE = ''TEST'') THEN ''SCP or Test Target-Market'''+char(10)
  SET @v_dSql += '                                                    WHEN L.DIVISION_ID IS NOT NULL THEN '''''+char(10)
  SET @v_dSql += '                                                    WHEN (A.OPERATION_ID IN (''A3000'',''A9000'') AND H.MARKET IS NULL AND (A.INSTANCE_ID <> ''KR_CELL_A2'')) THEN ''SCP or Test Target-Market'''+char(10)
  SET @v_dSql += '                                                    ELSE '''' END) ELSE '''' END AS MSG9'+char(10)
  SET @v_dSql += '                    ,CASE WHEN A.QTY > 0 THEN ( CASE WHEN I.LINE_ID IS NULL THEN ''Line Assign'' ELSE '''' END ) ELSE '''' END AS MSG10'+char(10)
  SET @v_dSql += '                    ,CASE WHEN A.QTY > 0 THEN ( CASE WHEN K.KEY_VALUE = ''DAILY_CAPA'' THEN (CASE WHEN (J.DAILY_CAPA IS NULL OR J.DAILY_CAPA = 0) THEN ''Daily Capa'' ELSE '''' END)'+char(10)
  SET @v_dSql += '                                                     ELSE (CASE WHEN (J.TACT_TIME IS NULL OR J.TACT_TIME = 0) THEN ''Tact Time'' ELSE '''' END) END ) ELSE '''' END AS MSG11'+char(10)
  SET @v_dSql += '                    ,CASE WHEN ROW_NUMBER() OVER(PARTITION BY A.FACTORY_ID, A.ITEM_ID, A.TOP_ITEM_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.LOCATION, A.PRODUCTION_TYPE, A.MARKET, A.PLAN_DATE'+char(10)
  SET @v_dSql += '            				                             ORDER BY     A.FACTORY_ID, A.ITEM_ID, A.TOP_ITEM_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.LOCATION, A.PRODUCTION_TYPE, A.MARKET, A.PLAN_DATE)>1 THEN ''Data Overlap'''+char(10)
  SET @v_dSql += '            				      ELSE '''' END AS MSG99'+char(10)
  SET @v_dSql += '              FROM ('+char(10)
  SET @v_dSql += '                  SELECT A.INSTANCE_ID, ISNULL(B.COMPANY_ID,''-'') AS COMPANY_ID, ISNULL(B.DIVISION_ID,''-'') AS DIVISION_ID, ISNULL(B.SITE_ID,''-'') AS SITE_ID, ISNULL(B.PLANT_ID,''-'') AS PLANT_ID'+char(10)
  SET @v_dSql += '                       , A.ITEM_ID, A.OPERATION_ID, A.FACTORY_ID, A.LOCATION'+char(10)
  SET @v_dSql += '                       , A.PRODUCTION_TYPE, A.MARKET'+char(10)
  SET @v_dSql += '                       , A.LINE_ID, A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '                       , A.TOP_ITEM_ID, A.ITEM_TYPE'+char(10)
  SET @v_dSql += '                       , CONVERT(VARCHAR, A.PLAN_DATE, 112) AS PLAN_DATE, A.OUT_QTY AS QTY'+char(10)
  SET @v_dSql += '                       , A.JOB_USER_ID, A.JOB_TIME, A.JOB_TYPE, A.JOB_ORDER'+char(10)
  SET @v_dSql += '                  FROM   BUF_AMEND_PLAN_CELL_R A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '                  LEFT OUTER JOIN SCM_FACTORY_M B WITH(NOLOCK)'+char(10)
  SET @v_dSql += '                  ON    A.DIVISION_ID = B.DIVISION_ID'+char(10)
  SET @v_dSql += '                  AND   A.SITE_ID     = B.SITE_ID'+char(10)
  SET @v_dSql += '                  AND   A.PLANT_ID    = B.PLANT_ID'+char(10)
  SET @v_dSql += '                  AND 	A.FACTORY_ID  = B.FACTORY_ID'+char(10)
  SET @v_dSql += '                  AND   B.ACTIVE_FLAG = ''Y'''+char(10)
  SET @v_dSql += '                  WHERE A.JOB_USER_ID ='+char(10)
  SET @v_dSql += '' + @v_user_id+''+char(10)
  SET @v_dSql += '              ) A'+char(10)
  SET @v_dSql += '              LEFT OUTER JOIN ('+char(10)
  SET @v_dSql += '                  SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, B.PLANT_ID, B.MODEL_ID, A.ITEM_ID'+char(10)
  SET @v_dSql += '                        --, CONVERT(VARCHAR, B.EFF_START_DATE,112) AS EFF_START_DATE, CONVERT(VARCHAR, B.EFF_END_DATE,112) AS EFF_END_DATE'+char(10)
  SET @v_dSql += '                        , ISNULL(A.NICK_NAME,''-'') AS NICK_NAME,'+char(10)
  SET @v_dSql += '                         (CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME'+char(10)
  SET @v_dSql += '                         	     WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'')'+char(10)
  SET @v_dSql += '                         	     ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE'+char(10)
  SET @v_dSql += '                  FROM	 SCM_ITEM_M A WITH(NOLOCK),'+char(10)
  SET @v_dSql += '                    		 SCM_MODEL_COMP_EFFECTIVE_DATE B WITH(NOLOCK),'+char(10)
  SET @v_dSql += '                    		 SCM_ITEM_CLASS_M C WITH(NOLOCK),'+char(10)
  SET @v_dSql += '                         ('+char(10)
  SET @v_dSql += '                            SELECT DISTINCT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.OPERATION_ID'+char(10)
  SET @v_dSql += '                            FROM   FP_INSTANCE_OPERATION_V A WITH(NOLOCK), SCM_OPERATION_M B WITH(NOLOCK)'+char(10)
  SET @v_dSql += '                            WHERE  A.COMPANY_ID   = B.COMPANY_ID'+char(10)
  SET @v_dSql += '                            AND    A.DIVISION_ID  = B.DIVISION_ID'+char(10)
  SET @v_dSql += '                            AND    A.SITE_ID      = B.SITE_ID'+char(10)
  SET @v_dSql += '                            AND    A.OPERATION_ID = B.OPERATION_ID'+char(10)
  SET @v_dSql += '                            AND    A.INSTANCE_ID  ='+char(10)
  SET @v_dSql += '' + @v_master_id+''+char(10)
  SET @v_dSql += '                            AND    A.AMEND_FLAG   = ''Y'''+char(10)
  SET @v_dSql += '                            AND    B.ACTIVE_FLAG  = ''Y'''+char(10)
  SET @v_dSql += '                         ) D'+char(10)
  SET @v_dSql += '                  WHERE	 A.COMPANY_ID  = B.COMPANY_ID'+char(10)
  SET @v_dSql += '                  AND	 A.DIVISION_ID = B.DIVISION_ID'+char(10)
  SET @v_dSql += '                  AND	 A.SITE_ID     = B.SITE_ID'+char(10)
  SET @v_dSql += '                  AND	 A.ITEM_ID     = B.CHILD_ITEM_ID'+char(10)
  SET @v_dSql += '                  AND	 A.ITEM_CLASS  = C.CLASS_ID'+char(10)
  SET @v_dSql += '                  AND    A.COMPANY_ID  = D.COMPANY_ID'+char(10)
  SET @v_dSql += '                  AND    A.DIVISION_ID = D.DIVISION_ID'+char(10)
  SET @v_dSql += '                  AND    A.SITE_ID     = D.SITE_ID'+char(10)
  SET @v_dSql += '                  AND    A.FLOW_ID LIKE ''%'' + D.OPERATION_ID + ''%'''+char(10)
  SET @v_dSql += '                  AND    A.ACTIVE_FLAG = ''Y'''+char(10)
  SET @v_dSql += '                  AND    C.USE_FLAG = ''Y'''+char(10)
  SET @v_dSql += '                  AND    B.EFF_END_DATE >= GETDATE()'+char(10)
  SET @v_dSql += '              ) B'+char(10)
  SET @v_dSql += '              ON  A.COMPANY_ID      = B.COMPANY_ID'+char(10)
  SET @v_dSql += '              AND A.DIVISION_ID     = B.DIVISION_ID'+char(10)
  SET @v_dSql += '              AND A.SITE_ID         = B.SITE_ID'+char(10)
  SET @v_dSql += '              AND A.PLANT_ID        = B.PLANT_ID'+char(10)
  SET @v_dSql += '              AND A.TOP_ITEM_ID     = B.MODEL_ID'+char(10)
  SET @v_dSql += '              AND A.ITEM_ID         = B.ITEM_ID'+char(10)
  SET @v_dSql += '              --AND A.PLAN_DATE >= B.EFF_START_DATE AND A.PLAN_DATE < B.EFF_END_DATE'+char(10)
  SET @v_dSql += '              LEFT OUTER JOIN SCM_OPERATION_M C WITH(NOLOCK)'+char(10)
  SET @v_dSql += '              ON  A.COMPANY_ID      = C.COMPANY_ID'+char(10)
  SET @v_dSql += '              AND A.DIVISION_ID     = C.DIVISION_ID'+char(10)
  SET @v_dSql += '              AND A.SITE_ID         = C.SITE_ID'+char(10)
  SET @v_dSql += '              AND A.OPERATION_ID    = C.OPERATION_ID'+char(10)
  SET @v_dSql += '              AND C.ACTIVE_FLAG     = ''Y'''+char(10)
  SET @v_dSql += '              LEFT OUTER JOIN SCM_LINE_M D WITH(NOLOCK)'+char(10)
  SET @v_dSql += '              ON  A.COMPANY_ID      = D.COMPANY_ID'+char(10)
  SET @v_dSql += '              AND A.DIVISION_ID     = D.DIVISION_ID'+char(10)
  SET @v_dSql += '              AND A.SITE_ID         = D.SITE_ID'+char(10)
  SET @v_dSql += '              AND A.PLANT_ID        = D.PLANT_ID'+char(10)
  SET @v_dSql += '              AND A.FACTORY_ID      = D.FACTORY_ID'+char(10)
  SET @v_dSql += '              AND A.OPERATION_ID    = D.OPERATION_ID'+char(10)
  SET @v_dSql += '              AND A.LINE_ID         = D.LINE_ID'+char(10)
  SET @v_dSql += '              AND A.LOCATION        = ISNULL(D.LOCATION,''-'')'+char(10)
  SET @v_dSql += '              AND A.ELECTRODE_TYPE  = D.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '              AND D.ACTIVE_FLAG     = ''Y'''+char(10)
  SET @v_dSql += '              LEFT OUTER JOIN ('+char(10)
  SET @v_dSql += '                  SELECT DISTINCT  A.SEGMENT1, A.ATTRIBUTE2 AS CODE_ID'+char(10)
  SET @v_dSql += '                  FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '                  WHERE  A.LOOKUP_TYPE_CODE = ''DIVISION_DEMAND_TYPE'''+char(10)
  SET @v_dSql += '                  AND    A.ACTIVE_FLAG = ''Y'''+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  IF @p_instance_id = 'KR_CELL' BEGIN
  SET @v_dSql += 'UNION ALL '+char(10)
  SET @v_dSql += 'SELECT DISTINCT A.DIVISION_ID AS SEGMENT1, ''M/C'' AS CODE_ID '+char(10)
  SET @v_dSql += 'FROM   SCM_FACTORY_M A(NOLOCK) INNER JOIN FP_INSTANCE_FACTORY_M B(NOLOCK) '+char(10)
  SET @v_dSql += 'ON     A.FACTORY_ID=B.FACTORY_ID '+char(10)
  SET @v_dSql += 'AND	   B.ACTIVE_FLAG = ''Y'' '+char(10)
  SET @v_dSql += 'WHERE  1=1 '+char(10)
  SET @v_dSql += 'AND	   A.ACTIVE_FLAG = ''Y'' '+char(10)
  SET @v_dSql += 'AND    B.INSTANCE_ID = ''KR_CELL'' '+char(10)  
  END
  --SET @v_dSql += '
  --{
  --                    var sql = "";
  --                    var sMst = $data.INSTANCE_ID;
  --
  --                    if(sMst == "KR_CELL") {
  --                    	sql += "UNION ALL \r\n";
  --						sql += "SELECT DISTINCT A.DIVISION_ID AS SEGMENT1, ''''M/C'''' AS CODE_ID \r\n";
  --						sql += "FROM   SCM_FACTORY_M A(NOLOCK) INNER JOIN FP_INSTANCE_FACTORY_M B(NOLOCK) \r\n";
  --						sql += "ON     A.FACTORY_ID=B.FACTORY_ID \r\n";
  --						sql += "AND	   B.ACTIVE_FLAG = ''''Y'''' \r\n";
  --						sql += "WHERE  1=1 \r\n";
  --						sql += "AND	   A.ACTIVE_FLAG = ''''Y'''' \r\n";
  --						sql += "AND    B.INSTANCE_ID = ''''KR_CELL'''' \r\n";
  --                    }
  --
  --                    sql;
  --                  }

  --'
  SET @v_dSql += '              ) E'+char(10)
  SET @v_dSql += '              ON  A.PRODUCTION_TYPE = E.CODE_ID'+char(10)
  SET @v_dSql += '              AND A.DIVISION_ID = E.SEGMENT1'+char(10)
  SET @v_dSql += '              AND (CASE WHEN A.SITE_ID <> ''A004'' AND A.PRODUCTION_TYPE IN (''E-TEST'',''D-TEST'') THEN ''XX'' ELSE A.PRODUCTION_TYPE END ) = E.CODE_ID'+char(10)
  SET @v_dSql += '              LEFT OUTER JOIN ('+char(10)
  SET @v_dSql += '                  SELECT A.SEGMENT1 AS CODE_ID'+char(10)
  SET @v_dSql += '                  FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '                  WHERE  A.LOOKUP_TYPE_CODE = ''DEMAND_MARKET_TYPE'''+char(10)
  SET @v_dSql += '                  AND    A.ACTIVE_FLAG = ''Y'''+char(10)
  SET @v_dSql += '              ) F'+char(10)
  SET @v_dSql += '              ON  A.MARKET = F.CODE_ID'+char(10)
  SET @v_dSql += '              LEFT OUTER JOIN ('+char(10)
  SET @v_dSql += '                  SELECT DISTINCT H.*'+char(10)
  SET @v_dSql += '                  FROM ('+char(10)
  SET @v_dSql += '                      SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.MARKET, A.ITEM_ID, (CASE WHEN A.PRODUCTION_TYPE = ''TEST'' THEN ''S-TEST'' ELSE A.PRODUCTION_TYPE END) AS PRODUCTION_TYPE'+char(10)
  SET @v_dSql += '											FROM   FP_WEEKLY_DEMAND_PRODUCT_H A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '											WHERE  (A.DIVISION_ID+A.SHOP_GROUP_ID+A.SCP_PLAN_ID) IN (SELECT A.DIVISION_ID+A.SHOP_GROUP_ID+MAX(SCP_PLAN_ID) AS SCP_PLAN_ID FROM FP_WEEKLY_DEMAND_PRODUCT_H A WITH(NOLOCK) GROUP BY A.DIVISION_ID, A.SHOP_GROUP_ID)'+char(10)
  SET @v_dSql += '											UNION ALL'+char(10)
  SET @v_dSql += '											SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, ISNULL(A.MARKET,''D'') AS MARKET, A.ITEM_ID, A.PRODUCTION_TYPE'+char(10)
  SET @v_dSql += '											FROM   FP_WEEKLY_DEMAND_PRODUCT_TEST_H A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '											WHERE  A.DUE_DATE >= (SELECT CONVERT(DATETIME,CONVERT(VARCHAR,PLAN_START_TIME,112))'+char(10)
  SET @v_dSql += '											                      FROM   SCM_FP_PLAN_H'+char(10)
  SET @v_dSql += '											                      WHERE  PLAN_ID ='+char(10)
  SET @v_dSql += '' + @v_plan_id+''+char(10)
  SET @v_dSql += ' )'+char(10)
  SET @v_dSql += '                  ) H'+char(10)
  SET @v_dSql += '              ) H'+char(10)
  SET @v_dSql += '              ON  A.COMPANY_ID  = H.COMPANY_ID'+char(10)
  SET @v_dSql += '              AND A.DIVISION_ID = H.DIVISION_ID'+char(10)
  SET @v_dSql += '              AND A.SITE_ID     = H.SITE_ID'+char(10)
  SET @v_dSql += '              AND A.PLANT_ID    = H.PLANT_ID'+char(10)
  SET @v_dSql += '              AND A.MARKET      = H.MARKET'+char(10)
  SET @v_dSql += '              AND A.TOP_ITEM_ID = H.ITEM_ID'+char(10)
  SET @v_dSql += '              AND A.PRODUCTION_TYPE = H.PRODUCTION_TYPE'+char(10)
  SET @v_dSql += '              LEFT OUTER JOIN SCM_ITEM_LINE_ASSIGN_M I WITH(NOLOCK)'+char(10)
  SET @v_dSql += '              ON  A.COMPANY_ID     = I.COMPANY_ID'+char(10)
  SET @v_dSql += '              AND A.DIVISION_ID    = I.DIVISION_ID'+char(10)
  SET @v_dSql += '              AND A.SITE_ID        = I.SITE_ID'+char(10)
  SET @v_dSql += '              AND A.PLANT_ID       = I.PLANT_ID'+char(10)
  SET @v_dSql += '              AND A.FACTORY_ID     = I.FACTORY_ID'+char(10)
  SET @v_dSql += '              AND A.ITEM_ID        = I.ITEM_ID'+char(10)
  SET @v_dSql += '              AND A.OPERATION_ID   = I.OPERATION_ID'+char(10)
  SET @v_dSql += '              AND A.LINE_ID        = I.LINE_ID'+char(10)
  SET @v_dSql += '              AND A.ELECTRODE_TYPE = I.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '              AND SUBSTRING(A.PLAN_DATE,1,6) = I.MONTH'+char(10)
  SET @v_dSql += '              AND I.ACTIVE_FLAG    = ''Y'''+char(10)
  SET @v_dSql += '              AND I.PRIORITY NOT IN (''0'',''9'')'+char(10)
  SET @v_dSql += '              LEFT OUTER JOIN SCM_TACT_TIME_M J WITH(NOLOCK)'+char(10)
  SET @v_dSql += '              ON  A.COMPANY_ID      = J.COMPANY_ID'+char(10)
  SET @v_dSql += '              AND A.DIVISION_ID     = J.DIVISION_ID'+char(10)
  SET @v_dSql += '              AND A.SITE_ID         = J.SITE_ID'+char(10)
  SET @v_dSql += '              AND A.PLANT_ID        = J.PLANT_ID'+char(10)
  SET @v_dSql += '              AND A.FACTORY_ID      = J.FACTORY_ID'+char(10)
  SET @v_dSql += '              AND A.ITEM_ID         = J.ITEM_ID'+char(10)
  SET @v_dSql += '              AND A.OPERATION_ID    = J.OPERATION_ID'+char(10)
  SET @v_dSql += '              AND A.LINE_ID         = J.LINE_ID'+char(10)
  SET @v_dSql += '              AND A.ELECTRODE_TYPE  = J.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '              AND SUBSTRING(A.PLAN_DATE,1,6) = J.MONTH'+char(10)
  SET @v_dSql += '              LEFT OUTER JOIN FP_INSTANCE_CONFIG_M K WITH(NOLOCK)'+char(10)
  SET @v_dSql += '              ON  A.INSTANCE_ID     = K.INSTANCE_ID'+char(10)
  SET @v_dSql += '              AND K.KEY_ID          = ''FINAL_OP_CAPA'''+char(10)
  SET @v_dSql += '          	  LEFT OUTER JOIN ('+char(10)
  SET @v_dSql += '            			SELECT DISTINCT A.SEGMENT1 AS INSTANCE_ID, A.SEGMENT2 AS DIVISION_ID, A.SEGMENT3 AS SITE_ID, A.SEGMENT4 AS PLANT_ID, A.SEGMENT5 AS MODEL_ID'+char(10)
  SET @v_dSql += '            			FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '            			WHERE  A.LOOKUP_TYPE_CODE = ''AMEND_VALIDATION_EXCEPTION'''+char(10)
  SET @v_dSql += '            			AND    A.ACTIVE_FLAG      = ''Y'''+char(10)
  SET @v_dSql += '            			AND    A.SEGMENT1         ='+char(10)
  SET @v_dSql += '' + @v_master_id+''+char(10)
  SET @v_dSql += '          	  ) L'+char(10)
  SET @v_dSql += '          	  ON  A.DIVISION_ID = L.DIVISION_ID'+char(10)
  SET @v_dSql += '          	  AND A.SITE_ID     = L.SITE_ID'+char(10)
  SET @v_dSql += '          	  AND A.PLANT_ID    = L.PLANT_ID'+char(10)
  SET @v_dSql += '          	  AND A.TOP_ITEM_ID = L.MODEL_ID'+char(10)
  SET @v_dSql += '          ) TT'+char(10)
  SET @v_dSql += '      ) A'+char(10)
  SET @v_dSql += '      ORDER BY A.JOB_ORDER'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --        $data.querySet1 = $jdbc.queryList("FP00602","find_Excel_buffer_validation",param);
  --
  --}

  --'


  IF @p_sys_type = 'SQL'
  BEGIN
    -- return SQL Query Source
    select @v_dSql as [QUERY_VALUE]
  END ELSE BEGIN
    SET @runstart = GetDate()

    BEGIN TRY
      BEGIN TRAN
        -- run dynamic sql
        exec sp_executesql @v_dSql
      COMMIT TRAN
    END TRY
    BEGIN CATCH
      ROLLBACK
      SET @runend = GetDate()
      exec PR_UI_SQL_LOG 'PR_UI_FP00602_FIND_EXCEL_BUFFER_VALIDATION',  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG 'PR_UI_FP00602_FIND_EXCEL_BUFFER_VALIDATION',  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
