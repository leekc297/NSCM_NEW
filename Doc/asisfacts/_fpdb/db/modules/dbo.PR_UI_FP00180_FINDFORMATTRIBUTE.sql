CREATE PROCEDURE [dbo].[PR_UI_FP00180_FINDFORMATTRIBUTE]
  @p_sys_type			nvarchar(MAX),  
  @p_sys_flag			nvarchar(MAX),
  @p_sys_gubun			nvarchar(MAX),  
  @p_user_id			nvarchar(MAX),
  @p_lookup_type_code nvarchar(max) = '',

  @opt_none nvarchar(5) = 'N'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_UI_FP00180_FINDFORMATTRIBUTE                                                            **/
/** 프로그램 명   : Procedure PR_UI_FP00180_FINDFORMATTRIBUTE                                                                          **/
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
/** 2021-02-01     XPDbToProcedure      Auto Generated With Initial Setting                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP00180_FINDFORMATTRIBUTE
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP00180_FINDFORMATTRIBUTE'
  DECLARE @v_user_id nvarchar(max)
  DECLARE @v_lookup_type_code nvarchar(max)

  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START

    DECLARE @opt_lookup_type_code nvarchar(max)
	SET @v_lookup_type_code ='''' + @p_lookup_type_code + ''''

    SET @STRLEN = LEN(@p_lookup_type_code)
  IF @STRLEN< 1  BEGIN
    SET @opt_lookup_type_code = ''
  END ELSE BEGIN
    SET @opt_lookup_type_code = ' A.LOOKUP_TYPE_CODE = ' + @v_lookup_type_code+' AND'
  END
  --Optional Parameter Part END
   

  SET @v_dSql = ''
  SET @v_dSql += '      SELECT A.SEGMENT1 AS DIVISION_ID' + char(10)
  SET @v_dSql += '            ,A.SEGMENT2 AS SITE_ID' + char(10)
  SET @v_dSql += '            ,A.SEGMENT3 AS ITEM_CLASS_LEVEL_2' + char(10)
  SET @v_dSql += '            ,A.SEGMENT5 AS CODE' + char(10)
  SET @v_dSql += '            ,A.SEGMENT5 AS NAME' + char(10)
  SET @v_dSql += '      FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)' + char(10)

  SET @v_dSql += '      WHERE  ' +@opt_lookup_type_code + char(10)
  SET @v_dSql += '      A.ACTIVE_FLAG = ''Y''' + char(10)
  SET @v_dSql += '      ORDER BY A.SEGMENT1, A.SEGMENT2, A.SEGMENT3, A.SEGMENT4, A.SEGMENT5, A.SORT_ORDER' + char(10)
  print @v_dSql
  
    	print '===22'
		print @v_dSql
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
      exec PR_UI_SQL_LOG 'PR_UI_FP00180_FINDFORMATTRIBUTE',  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG 'PR_UI_FP00180_FINDFORMATTRIBUTE',  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
