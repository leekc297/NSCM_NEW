CREATE PROCEDURE [dbo].[PR_UI_PLANAMENDMEMOP_FIND_PLANAMENDMEMOP]
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
/** 프로그램 ID   : PR_UI_PLANAMENDMEMOP_FIND_PLANAMENDMEMOP                                                            **/
/** 프로그램 명   : Procedure PR_UI_PLANAMENDMEMOP_FIND_PLANAMENDMEMOP                                                                          **/
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
/** 2021-04-22     XPDbToProcedure      Auto Generated With Initial Setting                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_UI_PLANAMENDMEMOP_FIND_PLANAMENDMEMOP
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_PLANAMENDMEMOP_FIND_PLANAMENDMEMOP'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  DECLARE @p_bucket_from nvarchar(max) = ''
  DECLARE @p_bucket_to nvarchar(max) = ''
  DECLARE @p_master_id nvarchar(max) = ''
  DECLARE @p_site_id nvarchar(max) = ''
	DECLARE @p_prod_type	NVARCHAR(MAX);
  DECLARE @p_model_id nvarchar(max) = ''
  DECLARE @p_item_id nvarchar(max) = ''
  DECLARE @p_division_id nvarchar(max) = ''
  DECLARE @p_plant_id nvarchar(max) = ''
  DECLARE @p_factory_id nvarchar(max) = ''
  DECLARE @p_operation_id nvarchar(max) = ''
  DECLARE @p_line_id nvarchar(max) = ''
  DECLARE @p_param nvarchar(max) = ''
  DECLARE @p_queryset1 nvarchar(max) = ''


  DECLARE @v_bucket_from nvarchar(max)
  DECLARE @v_bucket_to nvarchar(max)
  DECLARE @v_master_id nvarchar(max)
  DECLARE @v_site_id nvarchar(max)
  DECLARE @v_model_id nvarchar(max)
  DECLARE @v_item_id nvarchar(max)
  DECLARE @v_division_lt nvarchar(max)
  DECLARE @v_plant_lt nvarchar(max)
  DECLARE @v_factory_lt nvarchar(max)
  DECLARE @v_operation_lt nvarchar(max)
  DECLARE @v_line_lt nvarchar(max)
  DECLARE @v_param nvarchar(max)
  DECLARE @v_queryset1 nvarchar(max)

  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START
  DECLARE @opt_0site_id nvarchar(max)
  DECLARE @opt_1model_id nvarchar(max)
  DECLARE @opt_2item_id nvarchar(max)
  DECLARE @opt_3site_id nvarchar(max)
  DECLARE @opt_4model_id nvarchar(max)
  DECLARE @opt_5item_id nvarchar(max)

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
    END ELSE IF @tmp_column = 'BUCKET_FROM' BEGIN
      SET @p_bucket_from =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'BUCKET_TO' BEGIN
      SET @p_bucket_to =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'MASTER_ID' BEGIN
      SET @p_master_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'SITE_ID' BEGIN
      SET @p_site_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'MODEL_ID' BEGIN
      SET @p_model_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'ITEM_ID' BEGIN
      SET @p_item_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'DIVISION_ID' BEGIN
      SET @p_division_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLANT_ID' BEGIN
      SET @p_plant_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'FACTORY_ID' BEGIN
      SET @p_factory_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'OPERATION_ID' BEGIN
      SET @p_operation_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'LINE_ID' BEGIN
      SET @p_line_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PROD_TYPE' BEGIN
      SET @p_prod_type =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PARAM' BEGIN
      SET @p_param =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'QUERYSET1' BEGIN
      SET @p_queryset1 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
		SET @tmp_column =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END
  END
  
  SET @v_bucket_from ='''' + @p_bucket_from + ''''
  SET @v_bucket_to ='''' + @p_bucket_to + ''''
  SET @v_master_id ='''' + @p_master_id + ''''
  SET @v_site_id ='''' + @p_site_id + ''''
  SET @v_model_id ='''' + @p_model_id + ''''
  SET @v_item_id ='''' + @p_item_id + ''''
  SET @v_division_lt ='''' + @p_division_id + ''''
  SET @v_plant_lt ='''' + @p_plant_id + ''''
  SET @v_factory_lt ='''' + @p_factory_id + ''''
  SET @v_operation_lt ='''' + @p_operation_id + ''''
  SET @v_line_lt ='''' + @p_line_id + ''''
  SET @v_param ='''' + @p_param + ''''
  SET @v_queryset1 ='''' + @p_queryset1 + ''''

  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_0site_id = ''
  END ELSE BEGIN
    SET @opt_0site_id = 'AND   A.SITE_ID = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_model_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_1model_id = ''
  END ELSE BEGIN
    SET @opt_1model_id = 'AND   A.TOP_ITEM_ID LIKE ''%'' + RTRIM(LTRIM(' + @v_model_id+'))'
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_2item_id = ''
  END ELSE BEGIN
    SET @opt_2item_id = 'AND   A.ITEM_ID LIKE ''%'' + RTRIM(LTRIM(' + @v_item_id+'))'
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_3site_id = ''
  END ELSE BEGIN
    SET @opt_3site_id = 'AND   A.SITE_ID = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_model_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_4model_id = ''
  END ELSE BEGIN
    SET @opt_4model_id = 'AND   A.TOP_ITEM_ID LIKE ''%'' + RTRIM(LTRIM(' + @v_model_id+'))'
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_5item_id = ''
  END ELSE BEGIN
    SET @opt_5item_id = 'AND   A.ITEM_ID LIKE ''%'' + RTRIM(LTRIM(' + @v_item_id+'))'
  END


  -- planAmendMemoP find_planAmendMemoP  
  SET @v_dSql = ''
  SET @v_dSql += '      SELECT A.INSTANCE_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
  SET @v_dSql += '           , A.OPERATION_ID, A.LINE_ID, ISNULL(B.LINE_NAME,''-'') AS LINE_NAME, A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '           , A.EQUIPMENT_ID, CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE'+char(10)
  SET @v_dSql += '           , A.MARKET, A.PRODUCTION_TYPE'+char(10)
  SET @v_dSql += '           , A.TOP_ITEM_ID, A.ITEM_ID, ISNULL(C.NICK_NAME,''-'') AS NICK_NAME'+char(10)
  SET @v_dSql += '           , A.MEMO, A.ALARM_TIME'+char(10)
  SET @v_dSql += '           , A.PIC_REF'+char(10)
  SET @v_dSql += '           , A.INSERT_ID, CONVERT(VARCHAR,A.INSERT_TIME,20) AS INSERT_TIME'+char(10)
  SET @v_dSql += '           , A.UPDATE_ID, CONVERT(VARCHAR,A.UPDATE_TIME,20) AS UPDATE_TIME'+char(10)
  SET @v_dSql += '      FROM   FP_AMEND_MEMO_M A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '      LEFT OUTER JOIN SCM_LINE_M B WITH(NOLOCK)'+char(10)
  SET @v_dSql += '      ON  A.COMPANY_ID      = B.COMPANY_ID'+char(10)
  SET @v_dSql += '      AND A.DIVISION_ID     = B.DIVISION_ID'+char(10)
  SET @v_dSql += '      AND A.SITE_ID         = B.SITE_ID'+char(10)
  SET @v_dSql += '      AND A.PLANT_ID        = B.PLANT_ID'+char(10)
  SET @v_dSql += '      AND A.FACTORY_ID      = B.FACTORY_ID'+char(10)
  SET @v_dSql += '      AND A.OPERATION_ID    = B.OPERATION_ID'+char(10)
  SET @v_dSql += '      AND A.LINE_ID         = B.LINE_ID'+char(10)
  SET @v_dSql += '      AND A.ELECTRODE_TYPE  = B.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '      LEFT OUTER JOIN SCM_ITEM_M C WITH(NOLOCK)'+char(10)
  SET @v_dSql += '      ON  A.COMPANY_ID      = C.COMPANY_ID'+char(10)
  SET @v_dSql += '      AND A.DIVISION_ID     = C.DIVISION_ID'+char(10)
  SET @v_dSql += '      AND A.SITE_ID         = C.SITE_ID'+char(10)
  SET @v_dSql += '      AND A.TOP_ITEM_ID     = C.ITEM_ID'+char(10)
  SET @v_dSql += '      WHERE CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN'+char(10)
  SET @v_dSql += '' + @v_bucket_from+''+char(10)
  SET @v_dSql += ' AND'+char(10)
  SET @v_dSql += '' + @v_bucket_to+''+char(10)
  SET @v_dSql += '      AND   A.INSTANCE_ID ='+char(10)
  SET @v_dSql += '' + @v_master_id+''+char(10)
  SET @v_dSql += '      AND   A.MEMO_TYPE   = ''DPP'''+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  SET @v_dSql += (SELECT [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  SET @v_dSql += (SELECT [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
  SET @v_dSql += (SELECT [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
  SET @v_dSql += (SELECT [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
  SET @v_dSql += (SELECT [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
  SET @v_dSql += (SELECT [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
  SET @v_dSql += ' AND (A.TOP_ITEM_ID = N''-'' OR (ISNULL(A.TOP_ITEM_ID,''-'')<> ''-''' +(SELECT [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_model_id)) +'))'+  char(10)
  SET @v_dSql += ' AND (A.ITEM_ID = N''-'' OR (ISNULL(A.ITEM_ID,''-'')<> ''-''' + (SELECT [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id)) + '))'+ char(10)
  SET @v_dSql += ' AND (A.PRODUCTION_TYPE = N''-'' OR (ISNULL(A.PRODUCTION_TYPE,''-'')<> ''-''' + (SELECT [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + '))'+ char(10)

  --SET @v_dSql += '
  --{
  --        var sql="";
  --        var sDiv = $data.DIVISION_LT;
  --        var sPlt = $data.PLANT_LT;
  --        var sFac = $data.FACTORY_LT;
  --        var sOpr = $data.OPERATION_LT;
  --        var sLin = $data.LINE_LT;
  --
  --        if(sDiv!=null && sDiv!="") {
  --          sql+="AND   A.DIVISION_ID IN (" + sDiv + ")\r\n";
  --        }
  --        if(sPlt!=null && sPlt!="") {
  --          sql+="      AND   A.PLANT_ID IN (" + sPlt + ")\r\n";
  --        }
  --        if(sFac!=null && sFac!="") {
  --          sql+="      AND   A.FACTORY_ID IN (" + sFac + ")\r\n";
  --        }
  --        if(sOpr!=null && sOpr!="") {
  --          sql+="      AND   A.OPERATION_ID IN (" + sOpr + ")\r\n";
  --        }
  --        if(sLin!=null && sLin!="") {
  --          sql+="      AND   A.LINE_ID IN (" + sLin + ")\r\n";
  --        }
  --
  --        sql;
  --      }

  --'
  --SET @v_dSql += ' ' +@opt_0site_id +' '+''+char(10)--AND   A.SITE_ID = #SITE_ID#
  --SET @v_dSql += ' ' +@opt_1model_id +' '+''+char(10)--AND   A.TOP_ITEM_ID LIKE '%' + RTRIM(LTRIM(#MODEL_ID#))
  --SET @v_dSql += ' ' +@opt_2item_id +' '+''+char(10)--AND   A.ITEM_ID LIKE '%' + RTRIM(LTRIM(#ITEM_ID#))
  SET @v_dSql += '      AND	A.MEMO IS NOT NULL'+char(10)
  SET @v_dSql += '      ORDER BY A.INSTANCE_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
  SET @v_dSql += '             , A.LINE_ID, A.OPERATION_ID DESC, A.MARKET, A.PRODUCTION_TYPE'+char(10)
  SET @v_dSql += '             , A.TOP_ITEM_ID, A.ITEM_ID, A.PLAN_DATE DESC'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --  		var param = $data.param;
  --  		$data.querySet1 = $jdbc.queryList("planAmendMemoP","find_planAmendMemoP",param);
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
      exec PR_UI_SQL_LOG 'PR_UI_PLANAMENDMEMOP_FIND_PLANAMENDMEMOP',  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG 'PR_UI_PLANAMENDMEMOP_FIND_PLANAMENDMEMOP',  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
