CREATE PROCEDURE [dbo].[PR_UI_FP00820_FIND_FP00820]
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
/** 프로그램 ID   : PR_UI_FP00820_FIND_FP00820                                                            **/
/** 프로그램 명   : Procedure PR_UI_FP00820_FIND_FP00820                                                                          **/
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
/** 2021-05-11     XPDbToProcedure      Auto Generated With Initial Setting                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP00820_FIND_FP00820
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP00820_FIND_FP00820'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  DECLARE @p_site_id nvarchar(max) = ''
  DECLARE @p_start_date nvarchar(max) = ''
  DECLARE @p_item_id nvarchar(max) = ''
  DECLARE @p_vendor nvarchar(max) = ''
  DECLARE @p_division_id nvarchar(max) = ''
  DECLARE @p_plant_id nvarchar(max) = ''
  DECLARE @p_factory_id nvarchar(max) = ''
  DECLARE @p_param nvarchar(max) = ''
  DECLARE @p_queryset1 nvarchar(max) = ''


  DECLARE @v_user_id nvarchar(max)
  DECLARE @v_site_id nvarchar(max)
  DECLARE @v_start_date nvarchar(max)
  DECLARE @v_item_id nvarchar(max)
  DECLARE @v_vendor nvarchar(max)
  DECLARE @v_division_lt nvarchar(max)
  DECLARE @v_plant_lt nvarchar(max)
  DECLARE @v_factory_lt nvarchar(max)
  DECLARE @v_param nvarchar(max)
  DECLARE @v_queryset1 nvarchar(max)

  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START
  DECLARE @opt_0site_id nvarchar(max)
  DECLARE @opt_1item_id nvarchar(max)
  DECLARE @opt_2vendor nvarchar(max)
  DECLARE @opt_3site_id nvarchar(max)
  DECLARE @opt_4item_id nvarchar(max)
  DECLARE @opt_5vendor nvarchar(max)

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
    END ELSE IF @tmp_column = 'SITE_ID' BEGIN
      SET @p_site_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'START_DATE' BEGIN
      SET @p_start_date =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'ITEM_ID' BEGIN
      SET @p_item_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'VENDOR' BEGIN
      SET @p_vendor =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
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
  
  SET @v_user_id ='''' + @p_user_id + ''''
  SET @v_site_id ='''' + @p_site_id + ''''
  SET @v_start_date ='''' + @p_start_date + ''''
  SET @v_item_id ='''' + @p_item_id + ''''
  SET @v_vendor ='''' + @p_vendor + ''''
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
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_1item_id = ''
  END ELSE BEGIN
    SET @opt_1item_id = 'AND   UPPER(A.ITEM_ID) LIKE ''%'' + UPPER(' + @v_item_id+') + ''%'''
  END
  SET @STRLEN = LEN(@p_vendor)
  IF @STRLEN< 1  BEGIN
    SET @opt_2vendor = ''
  END ELSE BEGIN
    SET @opt_2vendor = 'AND   UPPER(A.PLANT_ID) LIKE ''%'' + UPPER(' + @v_vendor+') + ''%'''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_3site_id = ''
  END ELSE BEGIN
    SET @opt_3site_id = 'AND    A.SITE_ID = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_4item_id = ''
  END ELSE BEGIN
    SET @opt_4item_id = 'AND   UPPER(A.ITEM_ID) LIKE ''%'' + UPPER(' + @v_item_id+') + ''%'''
  END
  SET @STRLEN = LEN(@p_vendor)
  IF @STRLEN< 1  BEGIN
    SET @opt_5vendor = ''
  END ELSE BEGIN
    SET @opt_5vendor = 'AND   UPPER(A.PLANT_ID) LIKE ''%'' + UPPER(' + @v_vendor+') + ''%'''
  END

  
  -- FP00820 find_FP00820  
  SET @v_dSql = ''
  SET @v_dSql += 'SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID,'+char(10)
  SET @v_dSql += '       CONVERT(VARCHAR, A.CUTOFF_DATE, 112) AS CUTOFF_DATE, A.SEQ, A.ITEM_ID, A.QTY, ISNULL(B.NICK_NAME, ''-'') AS NICK_NAME,'+char(10)
  SET @v_dSql += '       CONVERT(VARCHAR, A.PRODUCT_DATE, 112) AS RECEIVING_DATE,'+char(10)
  SET @v_dSql += '       A.UPDATE_ID, CONVERT(VARCHAR, A.UPDATE_TIME, 120) AS UPDATE_TIME'+char(10)
  SET @v_dSql += 'FROM   SCM_PRODUCT_RESULT_H A(NOLOCK), SCM_ITEM_M B(NOLOCK)'+char(10)
  SET @v_dSql += 'WHERE  1 = dbo.fn_chk_factory('+char(10)
  SET @v_dSql += '' + @v_user_id+''+char(10)
  SET @v_dSql += ', A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, '''', '''', ''3'')'+char(10)
  SET @v_dSql += 'AND    A.COMPANY_ID = B.COMPANY_ID'+char(10)
  SET @v_dSql += 'AND    A.DIVISION_ID = B.DIVISION_ID'+char(10)
  SET @v_dSql += 'AND    A.SITE_ID = B.SITE_ID'+char(10)
  SET @v_dSql += 'AND    A.ITEM_ID = B.ITEM_ID'+char(10)
  SET @v_dSql += 'AND    B.ACTIVE_FLAG = ''Y'''+char(10)
  SET @v_dSql += ' ' +@opt_0site_id +' '+''+char(10)--AND    A.SITE_ID = #SITE_ID#
  SET @v_dSql += 'AND   CONVERT(VARCHAR, A.CUTOFF_DATE, 112) >='+char(10)
  SET @v_dSql += '' + @v_start_date+''+char(10)
  SET @v_dSql += ' ' +@opt_1item_id +' '+''+char(10)--AND   UPPER(A.ITEM_ID) LIKE '%' + UPPER(#ITEM_ID#) + '%'
  SET @v_dSql += ' ' +@opt_2vendor +' '+''+char(10)--AND   UPPER(A.PLANT_ID) LIKE '%' + UPPER(#VENDOR#) + '%'

---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
  --SET @v_dSql += '
  --{
  --	var sql = "";
  --	if($data.DIVISION_LT != null && $data.DIVISION_LT != ""){
  --		sql+= "AND A.DIVISION_ID IN (" + $data.DIVISION_LT + ")\r\n";
  --	}
  --	sql;
  --}

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --	var sql = "";
  --	if($data.PLANT_LT != null && $data.PLANT_LT != ""){
  --		sql+= "AND A.PLANT_ID IN (" + $data.PLANT_LT + ")\r\n";
  --	}
  --	sql;
  --}

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --	var sql = "";
  --	if($data.FACTORY_LT != null && $data.FACTORY_LT != ""){
  --		sql+= "AND A.FACTORY_ID IN (" + $data.FACTORY_LT + ")\r\n";
  --	}
  --	sql;
  --}

  --'
  SET @v_dSql += 'order by division_id, site_id, plant_id, item_id, CUTOFF_DATE'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --			var param = $data.param;
  --			$data.querySet1 = $jdbc.queryList("FP00820","find_FP00820",param);
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
      exec PR_UI_SQL_LOG 'PR_UI_FP00820_FIND_FP00820',  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG 'PR_UI_FP00820_FIND_FP00820',  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
