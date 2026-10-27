CREATE PROCEDURE [dbo].[PR_UI_FP00180_FINDITEMTYPE]
  @p_sys_type			nvarchar(MAX),  
  @p_sys_flag			nvarchar(MAX),
  @p_sys_gubun			nvarchar(MAX),  
  @p_user_id			nvarchar(MAX),
  @p_company_id nvarchar(max) = '',
  @p_division_id nvarchar(max) = '',
  @p_site_id nvarchar(max) = '',
  @p_operation_id nvarchar(max) = '',
  @p_item_class nvarchar(max) = '',
  @p_item_id nvarchar(max) = '',
  @p_division_lt nvarchar(max) = '',
  @p_site_lt nvarchar(max) = '',

  @opt_none nvarchar(5) = 'N'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : [PR_UI_FP00180_FINDITEMTYPE]                                                            **/
/** 프로그램 명   : Procedure [PR_UI_FP00180_FINDITEMTYPE]                                                                          **/
/** 설 명         :                                                                           **/
/** Version       : 1.0.0(Auto)                                                                     **/
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
/** 2021-02-03     XPDbToProcedure      Auto Generated With Initial Setting                                                      **/
/***********************************************************************************************/
/*
  EXEC [PR_UI_FP00180_FINDITEMTYPE]
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
  DECLARE @v_company_id nvarchar(max)
  DECLARE @v_division_id nvarchar(max)
  DECLARE @v_site_id nvarchar(max)
  DECLARE @v_operation_id nvarchar(max)
  DECLARE @v_item_class nvarchar(max)
  DECLARE @v_item_id nvarchar(max)
  DECLARE @v_division_lt nvarchar(max)
  DECLARE @v_site_lt nvarchar(max)

  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START
  DECLARE @opt_0company_id nvarchar(max)
  DECLARE @opt_1division_id nvarchar(max)
  DECLARE @opt_2site_id nvarchar(max)
  DECLARE @opt_3operation_id nvarchar(max)
  DECLARE @opt_4item_class nvarchar(max)
  DECLARE @opt_5item_id nvarchar(max)


  --Optional Parameter Part END

  
  SET @v_company_id ='''' + @p_company_id + ''''
  SET @v_division_id ='''' + @p_division_id + ''''
  SET @v_site_id ='''' + @p_site_id + ''''
  SET @v_operation_id ='''' + @p_operation_id + ''''
  SET @v_item_class ='''' + @p_item_class + ''''
  SET @v_item_id ='''' + @p_item_id + ''''
  SET @v_division_lt ='''' + @p_division_lt + ''''
  SET @v_site_lt ='''' + @p_site_lt + ''''

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
 
  -- FP00180 findItemType select select
  SET @v_dSql = ''
  SET @v_dSql += '      select distinct b.segment1 as code, ''(''+b.segment1+'')''+b.segment2 as name'+char(10)
  SET @v_dSql += '      from   scm_item_m a(NOLOCK), scm_sys_lookup_value b(NOLOCK), scm_item_class_m c(NOLOCK)'+char(10)
  SET @v_dSql += '      where  a.item_type = b.segment1'+char(10)
  SET @v_dSql += '      and    a.item_class = c.class_id'+char(10)
  SET @v_dSql += '      and    a.item_type != '''''+char(10)
  SET @v_dSql += '      and    b.lookup_type_code  = ''ITEM_TYPE'''+char(10)
  SET @v_dSql += '      and    c.use_flag = ''Y'''+char(10)
  SET @v_dSql += ' ' +@opt_0company_id +' '+''+char(10)--and    a.company_id=#COMPANY_ID#
  SET @v_dSql += ' ' +@opt_1division_id +' '+''+char(10)--and    a.division_id=#DIVISION_ID#
  SET @v_dSql += ' ' +@opt_2site_id +' '+''+char(10)--and    a.site_id=#SITE_ID#
  SET @v_dSql += ' ' +@opt_3operation_id +' '+''+char(10)--and    a.operation_id=#OPERATION_ID#
  SET @v_dSql += ' ' +@opt_4item_class +' '+''+char(10)--and    a.item_class=#ITEM_CLASS#
  SET @v_dSql += ' ' +@opt_5item_id +' '+''+char(10)--and    a.item_id=#ITEM_ID#
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --  	IF (isnull(@p_division_lt,'')<>'') OR (isnull(@p_division_lt,'')<>'')
		--BEGIN
		--	SET @v_dSql += 'AND DIVISION_ID IN (' + @v_division_lt + ')'+char(10);
		--END
SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('DIVISION_ID' , 'EQ', @p_division_lt)) + char(10);
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
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('SITE_ID' , 'EQ', @p_site_lt)) + char(10);
  --  	IF (isnull(@p_site_lt,'')<>'') OR (isnull(@p_site_lt,'')<>'')
		--BEGIN
		--	SET @v_dSql += 'AND SITE_ID IN (' + @v_site_lt + ')'+char(10);
		--END
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
      exec PR_UI_SQL_LOG 'PR_UI_FP00180_FINDITEMTYPE',  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG 'PR_UI_FP00180_FINDITEMTYPE',  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
