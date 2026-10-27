CREATE PROCEDURE [dbo].[PR_UI_FP00180_FINDCLASS1]
  @p_sys_type			nvarchar(MAX),  
  @p_sys_flag			nvarchar(MAX),
  @p_sys_gubun			nvarchar(MAX),  
  @p_user_id			nvarchar(MAX),
 -- @p_param nvarchar(max) = '',
 -- @p_queryset3 nvarchar(max) = '',

  @opt_none nvarchar(5) = 'N'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_UI_FP00180_FINDCLASS2                                                            **/
/** 프로그램 명   : Procedure PR_UI_FP00180_FINDCLASS1                                                                          **/
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
/** 2021-02-02     XPDbToProcedure      Auto Generated With Initial Setting                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP00180_FINDCLASS2
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP00180_FINDCLASS2'
  --DECLARE @v_param nvarchar(max)
  --DECLARE @v_queryset3 nvarchar(max)
  
  --DECLARE BASE PARAMETER START END
  --Optional Parameter Part START
  

  --Optional Parameter Part END

  
  --SET @v_param ='''' + @p_param + ''''
  --SET @v_queryset3 ='''' + @p_queryset3 + ''''

  print @v_dSql

  --    
  SET @v_dSql = ''
  SET @v_dSql +='    select distinct '+char(10)
  SET @v_dSql +='           a.LEVEL_1_CODE as code'+char(10)
 SET @v_dSql +='            ,''('' + a.LEVEL_1_CODE + '')'' + a.LEVEL_1_NAME as name'+char(10)
 SET @v_dSql +='     from   scm_item_class_m a(NOLOCK)'+char(10)
 SET @v_dSql +='     where  a.use_flag=''Y'''+char(10)
 SET @v_dSql +='     order by code'+char(10)

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
      exec PR_UI_SQL_LOG 'PR_UI_FP00180_FINDCLASS1',  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG 'PR_UI_FP00180_FINDCLASS1',  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
