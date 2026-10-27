CREATE PROCEDURE [dbo].[PR_UI_PRODUCTIONRESULT_FIND_PRODUCTIONRESULT]
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
/** 프로그램 ID   : PR_UI_PRODUCTIONRESULT_FIND_PRODUCTIONRESULT                                                            **/
/** 프로그램 명   : Procedure PR_UI_PRODUCTIONRESULT_FIND_PRODUCTIONRESULT                                                                          **/
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
/** 2021-05-11     XPDbToProcedure      Auto Generated With Initial Setting  
    2023-11-16     LJS                  version 추가
 **/
/***********************************************************************************************/
/*
  EXEC PR_UI_PRODUCTIONRESULT_FIND_PRODUCTIONRESULT
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_PRODUCTIONRESULT_FIND_PRODUCTIONRESULT'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  DECLARE @p_due_from_date nvarchar(max) = ''
  DECLARE @p_due_to_date nvarchar(max) = ''
  DECLARE @p_site_id nvarchar(max) = ''
  DECLARE @p_operation_id nvarchar(max) = ''
  DECLARE @p_line_id nvarchar(max) = ''
  DECLARE @p_item_id nvarchar(max) = ''
  DECLARE @p_nick_name nvarchar(max) = ''
  DECLARE @p_division_id nvarchar(max) = ''
  DECLARE @p_plant_id nvarchar(max) = ''
  DECLARE @p_factory_id nvarchar(max) = ''
  DECLARE @p_param nvarchar(max) = ''
  DECLARE @p_queryset1 nvarchar(max) = ''


  DECLARE @v_due_from_date nvarchar(max)
  DECLARE @v_due_to_date nvarchar(max)
  DECLARE @v_user_id nvarchar(max)
  DECLARE @v_site_id nvarchar(max)
  DECLARE @v_operation_id nvarchar(max)
  DECLARE @v_line_id nvarchar(max)
  DECLARE @v_item_id nvarchar(max)
  DECLARE @v_nick_name nvarchar(max)
  DECLARE @v_division_lt nvarchar(max)
  DECLARE @v_plant_lt nvarchar(max)
  DECLARE @v_factory_lt nvarchar(max)
  DECLARE @v_param nvarchar(max)
  DECLARE @v_queryset1 nvarchar(max)

  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START
  DECLARE @opt_0site_id nvarchar(max)
  DECLARE @opt_1operation_id nvarchar(max)
  DECLARE @opt_2line_id nvarchar(max)
  DECLARE @opt_3item_id nvarchar(max)
  DECLARE @opt_4nick_name nvarchar(max)
  DECLARE @opt_5site_id nvarchar(max)
  DECLARE @opt_6operation_id nvarchar(max)
  DECLARE @opt_7line_id nvarchar(max)
  DECLARE @opt_8item_id nvarchar(max)
  DECLARE @opt_9nick_name nvarchar(max)

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
    END ELSE IF @tmp_column = 'DUE_FROM_DATE' BEGIN
      SET @p_due_from_date =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'DUE_TO_DATE' BEGIN
      SET @p_due_to_date =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'SITE_ID' BEGIN
      SET @p_site_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'OPERATION_ID' BEGIN
      SET @p_operation_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'LINE_ID' BEGIN
      SET @p_line_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'ITEM_ID' BEGIN
      SET @p_item_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'NICK_NAME' BEGIN
      SET @p_nick_name =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'DIVISION_ID' BEGIN
      SET @p_division_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLANT_ID' BEGIN
      SET @p_plant_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'FACTORY_ID' BEGIN
      SET @p_factory_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PARAM' BEGIN
      SET @p_param =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'QUERYSET1' BEGIN
      SET @p_queryset1 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
		SET @tmp_column =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END
  END
  
  SET @v_due_from_date ='''' + @p_due_from_date + ''''
  SET @v_due_to_date ='''' + @p_due_to_date + ''''
  SET @v_user_id ='''' + @p_user_id + ''''
  SET @v_site_id ='''' + @p_site_id + ''''
  SET @v_operation_id ='''' + @p_operation_id + ''''
  SET @v_line_id ='''' + @p_line_id + ''''
  SET @v_item_id ='''' + @p_item_id + ''''
  SET @v_nick_name ='''' + @p_nick_name + ''''
  SET @v_division_lt ='''' + @p_division_id + ''''
  SET @v_plant_lt ='''' + @p_plant_id + ''''
  SET @v_factory_lt ='''' + @p_factory_id + ''''
  SET @v_param ='''' + @p_param + ''''
  SET @v_queryset1 ='''' + @p_queryset1 + ''''

  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_0site_id = ''
  END ELSE BEGIN
    SET @opt_0site_id = 'AND    A.SITE_ID = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_operation_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_1operation_id = ''
  END ELSE BEGIN
    SET @opt_1operation_id = 'AND    A.OPERATION_ID = ' + @v_operation_id+''
  END
  SET @STRLEN = LEN(@p_line_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_2line_id = ''
  END ELSE BEGIN
    SET @opt_2line_id = 'AND    A.LINE_ID = ' + @v_line_id+''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_3item_id = ''
  END ELSE BEGIN
    SET @opt_3item_id = 'AND    UPPER(A.ITEM_ID) LIKE ''%'' + UPPER(' + @v_item_id+') + ''%'''
  END
  SET @STRLEN = LEN(@p_nick_name)
  IF @STRLEN< 1  BEGIN
    SET @opt_4nick_name = ''
  END ELSE BEGIN
    SET @opt_4nick_name = 'AND    UPPER(PD.NICK_NAME) LIKE ''%'' + UPPER(' + @v_nick_name+') + ''%'''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_5site_id = ''
  END ELSE BEGIN
    SET @opt_5site_id = 'AND    A.SITE_ID = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_operation_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_6operation_id = ''
  END ELSE BEGIN
    SET @opt_6operation_id = 'AND    A.OPERATION_ID = ' + @v_operation_id+''
  END
  SET @STRLEN = LEN(@p_line_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_7line_id = ''
  END ELSE BEGIN
    SET @opt_7line_id = 'AND    A.LINE_ID = ' + @v_line_id+''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_8item_id = ''
  END ELSE BEGIN
    SET @opt_8item_id = 'AND    UPPER(A.ITEM_ID) LIKE ''%'' + UPPER(' + @v_item_id+') + ''%'''
  END
  SET @STRLEN = LEN(@p_nick_name)
  IF @STRLEN< 1  BEGIN
    SET @opt_9nick_name = ''
  END ELSE BEGIN
    SET @opt_9nick_name = 'AND    UPPER(PD.NICK_NAME) LIKE ''%'' + UPPER(' + @v_nick_name+') + ''%'''
  END


  -- productionResult find_productionResult  
  SET @v_dSql = ''
  SET @v_dSql += '      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID,'+char(10)
  SET @v_dSql += '             A.ITEM_ID,'+char(10)
  SET @v_dSql += '             A.IN_QTY,'+char(10)
  SET @v_dSql += '             A.QTY, A.QTY_LANE,'+char(10)
  SET @v_dSql += '             A.DFCT_QTY2, A.LOSS_QTY2, A.PRDT_REQ_QTY2, A.TOP_COATING_QTY2, A.WIPQTY2_ENGINE,'+char(10)
  SET @v_dSql += '             ISNULL(PD.NICK_NAME,''-'') AS NICK_NAME,'+char(10)
  SET @v_dSql += '             A.PRODUCT_DATE,'+char(10)
  SET @v_dSql += '             A.LINE_ID, A.OPERATION_ID,'+char(10)
  SET @v_dSql += '             A.UPDATE_ID, A.UPDATE_TIME,'+char(10)
  SET @v_dSql += '             (SELECT TOP 1 X.LINE_NAME'+char(10)
  SET @v_dSql += '               FROM   SCM_LINE_M  X WITH(NOLOCK)'+char(10)
  SET @v_dSql += '               WHERE  X.COMPANY_ID   = A.COMPANY_ID'+char(10)
  SET @v_dSql += '               AND    X.DIVISION_ID  = A.DIVISION_ID'+char(10)
  SET @v_dSql += '               AND    X.SITE_ID      = A.SITE_ID'+char(10)
  SET @v_dSql += '               AND    X.PLANT_ID     = A.PLANT_ID'+char(10)
  SET @v_dSql += '               AND    X.FACTORY_ID   = A.FACTORY_ID'+char(10)
  SET @v_dSql += '               AND    X.LINE_ID      = A.LINE_ID'+char(10)
  SET @v_dSql += '               AND    X.OPERATION_ID = A.OPERATION_ID'+char(10)
  SET @v_dSql += '               ORDER BY X.OPERATION_ID DESC) AS LINE_NAME,'+char(10)
  SET @v_dSql += '             A.PRODUCTION_TYPE, A.MARKET'+char(10)
  SET @v_dSql += '             , A.WORK_REQUEST_MODEL_ID '+char(10) -- version 추가... 20231116
  --SET @v_dSql += '             , CASE WHEN V.INSTANCE_ID LIKE ''%CELL%'' THEN A.PLM_EC_NO '+char(10)
  --SET @v_dSql += '                    WHEN V.INSTANCE_ID LIKE ''%E_PRE%'' THEN A.VERSION '+char(10)
  --SET @v_dSql += '                    ELSE A.VERSION END AS VERSION '+char(10)
  SET @v_dSql += '             , A.VERSION, A.PLM_EC_NO '+char(10) -- PDS 2차 고도화
  SET @v_dSql += '      FROM   ( SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID,'+char(10)
  SET @v_dSql += '                      A.ITEM_ID, SUM(ISNULL(A.QTY_LANE,0) + ISNULL(A.DFCT_QTY2,0) + ISNULL(A.YIELD_LOSS_QTY,0) + ISNULL(A.PRDT_REQ_QTY2,0)) AS IN_QTY,'+char(10)
  SET @v_dSql += '                      SUM(A.QTY) AS QTY, SUM(A.QTY_LANE) AS QTY_LANE,'+char(10)
  SET @v_dSql += '                      SUM(A.DFCT_QTY2) AS DFCT_QTY2, SUM(A.LOSS_QTY2) AS LOSS_QTY2, SUM(A.PRDT_REQ_QTY2) AS PRDT_REQ_QTY2, SUM(A.TOP_COATING_QTY2) AS TOP_COATING_QTY2, SUM(ACTUAL_GOOD_QTY) AS WIPQTY2_ENGINE,'+char(10)
  SET @v_dSql += '                      CONVERT(VARCHAR, A.PLAN_DATE, 120) AS PRODUCT_DATE,'+char(10)
  SET @v_dSql += '                      A.LINE_ID, A.OPERATION_ID,'+char(10)
  SET @v_dSql += '                      MAX(A.UPDATE_ID) AS UPDATE_ID, MAX(CONVERT(VARCHAR, A.UPDATE_TIME, 120)) AS UPDATE_TIME'+char(10)
  SET @v_dSql += '                     --,A.PRODUCTION_TYPE'+char(10)
  SET @v_dSql += '                     , A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE'+char(10)
  SET @v_dSql += '                     , A.MARKET'+char(10)
  SET @v_dSql += '                     , A.PLM_EC_NO, A.VERSION, A.WORK_REQUEST_MODEL_ID '+char(10) -- version 추가... 20231116
  SET @v_dSql += '               FROM   SCM_DAILY_PRODUCT_RESULT_H A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '               WHERE  CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN'+char(10)
  SET @v_dSql += '' + @v_due_from_date+''+char(10)
  SET @v_dSql += ' AND'+char(10)
  SET @v_dSql += '' + @v_due_to_date+''+char(10)
  SET @v_dSql += '               AND    EXISTS ('+char(10)
  SET @v_dSql += '                      SELECT 1'+char(10)
  SET @v_dSql += '                      FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)'+char(10)
  SET @v_dSql += '                      WHERE  A.COMPANY_ID   = B.COMPANY_ID'+char(10)
  SET @v_dSql += '                      AND    A.DIVISION_ID  = B.DIVISION_ID'+char(10)
  SET @v_dSql += '                      AND    A.SITE_ID      = B.SITE_ID'+char(10)
  SET @v_dSql += '                      AND    A.PLANT_ID     = B.PLANT_ID'+char(10)
  SET @v_dSql += '                      AND    A.FACTORY_ID   = B.FACTORY_ID'+char(10)
  SET @v_dSql += '                      AND    A.OPERATION_ID = B.OPERATION_ID'+char(10)
  SET @v_dSql += '                      AND    A.LINE_ID      = B.LINE_ID'+char(10)
  SET @v_dSql += '                      AND    B.USER_ID      ='+char(10)
  SET @v_dSql += '' + @v_user_id+''+char(10)
  SET @v_dSql += '               )'+char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)

  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --                  var sql = "";
  --                  if($data.DIVISION_LT != null && $data.DIVISION_LT != ""){
  --                    sql+= "AND    A.DIVISION_ID IN (" + $data.DIVISION_LT + ")\r\n";
  --                  }
  --                  sql;
  --               }

  --'
  --SET @v_dSql += ' ' +@opt_0site_id +' '+''+char(10)--AND    A.SITE_ID = #SITE_ID#
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --                  var sql = "";
  --                  if($data.PLANT_LT != null && $data.PLANT_LT != ""){
  --                    sql+= "AND    A.PLANT_ID IN (" + $data.PLANT_LT + ")\r\n";
  --                  }
  --                  sql;
  --               }

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --                  var sql = "";
  --                  if($data.FACTORY_LT != null && $data.FACTORY_LT != ""){
  --                    sql+= "AND    A.FACTORY_ID IN (" + $data.FACTORY_LT + ")\r\n";
  --                  }
  --                  sql;
  --               }

  ----'
  --SET @v_dSql += ' ' +@opt_1operation_id +' '+''+char(10)--AND    A.OPERATION_ID = #OPERATION_ID#
  --SET @v_dSql += ' ' +@opt_2line_id +' '+''+char(10)--AND    A.LINE_ID = #LINE_ID#
  SET @v_dSql += ' ' +@opt_3item_id +' '+''+char(10)--AND    UPPER(A.ITEM_ID) LIKE '%' + UPPER(#ITEM_ID#) + '%'
  SET @v_dSql += '               GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID,'+char(10)
  SET @v_dSql += '                        A.ITEM_ID, A.PLAN_DATE,A.LINE_ID, A.OPERATION_ID, A.FP_PRODUCTION_TYPE, A.MARKET'+char(10)
  SET @v_dSql += '                        , A.PLM_EC_NO, A.VERSION, A.WORK_REQUEST_MODEL_ID '+char(10) -- version 추가... 20231116
  SET @v_dSql += '      ) A'+char(10)
  SET @v_dSql += '      INNER JOIN SCM_ITEM_M PD WITH(NOLOCK)'+char(10)
  SET @v_dSql += '      ON     A.COMPANY_ID   = PD.COMPANY_ID'+char(10)
  SET @v_dSql += '      AND    A.DIVISION_ID  = PD.DIVISION_ID'+char(10)
  SET @v_dSql += '      AND    A.SITE_ID      = PD.SITE_ID'+char(10)
  SET @v_dSql += '      AND    A.ITEM_ID      = PD.ITEM_ID'+char(10)
  SET @v_dSql += '      LEFT OUTER JOIN ( '+char(10) -- version 추가... 20231116
  SET @v_dSql += '      	SELECT V.COMPANY_ID, V.DIVISION_ID, V.SITE_ID, V.PLANT_ID, V.FACTORY_ID, V.OPERATION_ID, V.LINE_ID, MAX(V.INSTANCE_ID) AS INSTANCE_ID '+char(10)
  SET @v_dSql += '      	FROM   FP_INSTANCE_LINE_V V WITH(NOLOCK) '+char(10)
  SET @v_dSql += '      	WHERE  1=1 '+char(10)
  SET @v_dSql += '      	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('V.DIVISION_ID' , 'EQ', @p_division_id))
  SET @v_dSql += '      	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('V.PLANT_ID' , 'EQ', @p_plant_id)) 
  SET @v_dSql += '      	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('V.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
  SET @v_dSql += '      	GROUP BY V.COMPANY_ID, V.DIVISION_ID, V.SITE_ID, V.PLANT_ID, V.FACTORY_ID, V.OPERATION_ID, V.LINE_ID '+char(10)
  SET @v_dSql += '      ) V '+char(10)
  SET @v_dSql += '      ON  A.COMPANY_ID   = V.COMPANY_ID '+char(10)
  SET @v_dSql += '      AND A.DIVISION_ID  = V.DIVISION_ID '+char(10)
  SET @v_dSql += '      AND A.SITE_ID      = V.SITE_ID '+char(10)
  SET @v_dSql += '      AND A.PLANT_ID     = V.PLANT_ID '+char(10)
  SET @v_dSql += '      AND A.FACTORY_ID   = V.FACTORY_ID '+char(10)
  SET @v_dSql += '      AND A.OPERATION_ID = V.OPERATION_ID '+char(10)
  SET @v_dSql += '      AND A.LINE_ID      = V.LINE_ID '+char(10)
  SET @v_dSql += '      WHERE  PD.ACTIVE_FLAG = ''Y'''+char(10)
  SET @v_dSql += ' ' +@opt_4nick_name +' '+''+char(10)--AND    UPPER(PD.NICK_NAME) LIKE '%' + UPPER(#NICK_NAME#) + '%'
  SET @v_dSql += '      ORDER BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.LINE_ID, A.PRODUCTION_TYPE, A.MARKET'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --        $data.querySet1 = $jdbc.queryList("productionResult","find_productionResult",param);
  --
  --}

  --'


  IF @p_sys_type = 'SQL'
  BEGIN
    -- return SQL Query Source
    select @v_dSql as [QUERY_VALUE]
  END ELSE BEGIN
    SET @runstart = GetDate()

    --BEGIN TRY
      --BEGIN TRAN
      --  -- run dynamic sql
        exec sp_executesql @v_dSql
    --  COMMIT TRAN
    --END TRY
    --BEGIN CATCH
    --  ROLLBACK
    --  SET @runend = GetDate()
    --  exec PR_UI_SQL_LOG 'PR_UI_PRODUCTIONRESULT_FIND_PRODUCTIONRESULT',  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    --END CATCH

    SET @runend = GetDate()
    -- Record sql query
    --exec PR_UI_SQL_LOG 'PR_UI_PRODUCTIONRESULT_FIND_PRODUCTIONRESULT',  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
