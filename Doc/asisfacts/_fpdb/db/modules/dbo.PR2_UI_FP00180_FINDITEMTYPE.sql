CREATE PROCEDURE [dbo].[PR2_UI_FP00180_FINDITEMTYPE]
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
/** 프로그램 ID   : PR_UI_FP00180_FINDITEMTYPE                                                            **/
/** 프로그램 명   : Procedure PR_UI_FP00180_FINDITEMTYPE                                                                          **/
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
/** 2021-06-30     XPDbToProcedure      Auto Generated With Initial Setting                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP00180_FINDITEMTYPE
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP00180_FINDITEMTYPE'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  DECLARE @p_company_id nvarchar(max) = ''
  DECLARE @p_division_id nvarchar(max) = ''
  DECLARE @p_site_id nvarchar(max) = ''
  DECLARE @p_operation_id nvarchar(max) = ''
  DECLARE @p_item_class nvarchar(max) = ''
  DECLARE @p_item_id nvarchar(max) = ''
  --DECLARE @p_division_lt nvarchar(max) = ''
  --DECLARE @p_site_lt nvarchar(max) = ''
  DECLARE @p_param nvarchar(max) = ''
  DECLARE @p_queryset1 nvarchar(max) = ''


  DECLARE @v_company_id nvarchar(max)
  DECLARE @v_division_id nvarchar(max)
  DECLARE @v_site_id nvarchar(max)
  DECLARE @v_operation_id nvarchar(max)
  DECLARE @v_item_class nvarchar(max)
  DECLARE @v_item_id nvarchar(max)
  --DECLARE @v_division_lt nvarchar(max)
  --DECLARE @v_site_lt nvarchar(max)
  DECLARE @v_param nvarchar(max)
  DECLARE @v_queryset1 nvarchar(max)

  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START
  DECLARE @opt_0company_id nvarchar(max)
  DECLARE @opt_1division_id nvarchar(max)
  DECLARE @opt_2site_id nvarchar(max)
  DECLARE @opt_3operation_id nvarchar(max)
  DECLARE @opt_4item_class nvarchar(max)
  DECLARE @opt_5item_id nvarchar(max)
  DECLARE @opt_6company_id nvarchar(max)
  DECLARE @opt_7division_id nvarchar(max)
  DECLARE @opt_8site_id nvarchar(max)
  DECLARE @opt_9operation_id nvarchar(max)
  DECLARE @opt_10item_class nvarchar(max)
  DECLARE @opt_11item_id nvarchar(max)

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
    END ELSE IF @tmp_column = 'COMPANY_ID' BEGIN
      SET @p_company_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'DIVISION_ID' BEGIN
      SET @p_division_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'SITE_ID' BEGIN
      SET @p_site_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'OPERATION_ID' BEGIN
      SET @p_operation_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'ITEM_CLASS' BEGIN
      SET @p_item_class =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'ITEM_ID' BEGIN
      SET @p_item_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    --END ELSE IF @tmp_column = 'DIVISION_LT' BEGIN
    --  SET @p_division_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    --END ELSE IF @tmp_column = 'SITE_LT' BEGIN
      --SET @p_site_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PARAM' BEGIN
      SET @p_param =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'QUERYSET1' BEGIN
      SET @p_queryset1 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
		SET @tmp_column =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END
  END
  --SET @p_user_id = dbo.FN_deCRYPT_AES128(@p_user_id)

  SET @v_company_id ='''' + @p_company_id + ''''
  SET @v_division_id ='''' + @p_division_id + ''''
  SET @v_site_id ='''' + @p_site_id + ''''
  SET @v_operation_id ='''' + @p_operation_id + ''''
  SET @v_item_class ='''' + @p_item_class + ''''
  SET @v_item_id ='''' + @p_item_id + ''''
  --SET @v_division_lt ='''' + @p_division_lt + ''''
  --SET @v_site_lt ='''' + @p_site_lt + ''''
  SET @v_param ='''' + @p_param + ''''
  SET @v_queryset1 ='''' + @p_queryset1 + ''''

  SET @STRLEN = LEN(@p_company_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_0company_id = ''
  END ELSE BEGIN
    SET @opt_0company_id = 'and    a.company_id=' + @v_company_id+''
  END
  SET @STRLEN = LEN(@p_division_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_1division_id = ''
  END ELSE BEGIN
    SET @opt_1division_id = 'and    a.division_id=' + @v_division_id+''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_2site_id = ''
  END ELSE BEGIN
    SET @opt_2site_id = 'and    a.site_id=' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_operation_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_3operation_id = ''
  END ELSE BEGIN
    SET @opt_3operation_id = 'and    a.operation_id=' + @v_operation_id+''
  END
  SET @STRLEN = LEN(@p_item_class)
  IF @STRLEN< 1  BEGIN
    SET @opt_4item_class = ''
  END ELSE BEGIN
    SET @opt_4item_class = 'and    a.item_class=' + @v_item_class+''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_5item_id = ''
  END ELSE BEGIN
    SET @opt_5item_id = 'and    a.item_id=' + @v_item_id+''
  END
  SET @STRLEN = LEN(@p_company_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_6company_id = ''
  END ELSE BEGIN
    SET @opt_6company_id = 'and    a.company_id=' + @v_company_id+''
  END
  SET @STRLEN = LEN(@p_division_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_7division_id = ''
  END ELSE BEGIN
    SET @opt_7division_id = 'and    a.division_id=' + @v_division_id+''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_8site_id = ''
  END ELSE BEGIN
    SET @opt_8site_id = 'and    a.site_id=' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_operation_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_9operation_id = ''
  END ELSE BEGIN
    SET @opt_9operation_id = 'and    a.operation_id=' + @v_operation_id+''
  END
  SET @STRLEN = LEN(@p_item_class)
  IF @STRLEN< 1  BEGIN
    SET @opt_10item_class = ''
  END ELSE BEGIN
    SET @opt_10item_class = 'and    a.item_class=' + @v_item_class+''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_11item_id = ''
  END ELSE BEGIN
    SET @opt_11item_id = 'and    a.item_id=' + @v_item_id+''
  END


  -- FP00180 findItemType  
  SET @v_dSql = ''
  SET @v_dSql += '      select distinct b.segment1 as code, ''(''+b.segment1+'')''+b.segment2 as name'+char(10)
  SET @v_dSql += '      from   scm_item_m a(NOLOCK), scm_sys_lookup_value b(NOLOCK), scm_item_class_m c(NOLOCK)'+char(10)
  SET @v_dSql += '      where  a.item_type = b.segment1'+char(10)
  SET @v_dSql += '      and    a.item_class = c.class_id'+char(10)
  SET @v_dSql += '      and    a.item_type != '''''+char(10)
  SET @v_dSql += '      and    b.lookup_type_code  = ''ITEM_TYPE'''+char(10)
  SET @v_dSql += '      and    c.use_flag = ''Y'''+char(10)
  SET @v_dSql += ' ' +@opt_0company_id +' '+''+char(10)--and    a.company_id=#COMPANY_ID#
  --SET @v_dSql += ' ' +@opt_1division_id +' '+''+char(10)--and    a.division_id=#DIVISION_ID#
  --SET @v_dSql += ' ' +@opt_2site_id +' '+''+char(10)--and    a.site_id=#SITE_ID#
  SET @v_dSql += ' ' +@opt_3operation_id +' '+''+char(10)--and    a.operation_id=#OPERATION_ID#
  SET @v_dSql += ' ' +@opt_4item_class +' '+''+char(10)--and    a.item_class=#ITEM_CLASS#
  SET @v_dSql += ' ' +@opt_5item_id +' '+''+char(10)--and    a.item_id=#ITEM_ID#
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('SITE_ID' , 'EQ', @p_site_id)) + char(10)
  --SET @v_dSql += '
  --{
  --      	var sql = "";
  --      	if($data.DIVISION_LT != null && $data.DIVISION_LT != ""){
  --      		sql+= "AND DIVISION_ID IN (" + $data.DIVISION_LT + ")\r\n";
  --      	}
  --      	sql;
  --      }

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --      	var sql = "";
  --      	if($data.SITE_LT != null && $data.SITE_LT != ""){
  --      		sql+= "AND SITE_ID IN (" + $data.SITE_LT + ")\r\n";
  --      	}
  --      	sql;
  --      }

  --'
  SET @v_dSql += '      order by code'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --        $data.querySet1 = $jdbc.queryList("FP00180","findItemType",param);
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
      exec PR_UI_SQL_LOG 'PR2_UI_FP00180_FINDITEMTYPE',  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG 'PR2_UI_FP00180_FINDITEMTYPE',  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
