CREATE PROCEDURE [dbo].[PR_UI_FP00180_FINDCLASS]
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
    
  @p_item_class_level_1 nvarchar(max) = '',

  @opt_none nvarchar(5) = 'N'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : [PR_UI_FP00180_FINDCLASS]                                                            **/
/** 프로그램 명   : Procedure [PR_UI_FP00180_FINDCLASS]                                                                          **/
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
  EXEC [PR_UI_FP00180_FINDCLASS]
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

 DECLARE  @v_item_class_level_1 nvarchar(max) 

    DECLARE @v_sys_type nvarchar(max)
DECLARE @v_sys_flag nvarchar(max)
DECLARE @v_sys_gubun nvarchar(max)
DECLARE @v_user_id nvarchar(max)

  --Optional Parameter Part END

  SET @v_sys_type = @p_sys_type 
  SET @v_sys_flag =@p_sys_flag 
  SET @v_sys_gubun = @p_sys_gubun 
  SET @v_user_id = @p_user_id 
  
  SET @v_company_id = @p_company_id 
  SET @v_division_id = @p_division_id 
  SET @v_site_id = @p_site_id 
  SET @v_operation_id = @p_operation_id 
  SET @v_item_class = @p_item_class 
  SET @v_item_id =@p_item_id 
  SET @v_division_lt = @p_division_lt 
  SET @v_site_lt = @p_site_lt 
  SET @v_item_class_level_1 = @p_item_class_level_1 

  
  SET @v_dSql += ''
  print '----'

  --IF @p_sys_type = 'SQL'
  --BEGIN
    -- return SQL Query Source
  --  select @v_dSql as [QUERY_VALUE]
  --END ELSE BEGIN
 --   SET @runstart = GetDate()

    BEGIN TRY
    --  BEGIN TRAN
        -- run dynamic sql
        


		-- RUN FINDCLASS

	  -- RUN FINDCLASS2

	  -- RUN FINDITEM
	  --DECLARE	@return_value int
	  --print 'PR_UI_FP00180_FINDCLASS1'
	  	EXEC	[dbo].[PR_UI_FP00180_FINDCLASS1]
		@p_sys_type = @v_sys_type,
		@p_sys_flag = @v_sys_flag,
		@p_sys_gubun = @v_sys_gubun,
		@p_user_id = @v_user_id,
		@opt_none = ''
		
	  --print 'PR_UI_FP00180_FINDCLASS2'
	    EXEC	[dbo].[PR_UI_FP00180_FINDCLASS2]
		@p_sys_type = @v_sys_type,
		@p_sys_flag = @v_sys_flag,
		@p_sys_gubun = @v_sys_gubun,
		@p_user_id = @v_user_id,
		@p_item_class_level_1 = @v_item_class_level_1,
		@opt_none = ''
		--	  print '[PR_UI_FP00180_FINDITEMTYPE]'
		EXEC	[dbo].[PR_UI_FP00180_FINDITEMTYPE]
		@p_sys_type = @v_sys_type,
		@p_sys_flag = @v_sys_flag,
		@p_sys_gubun = @v_sys_gubun,
		@p_user_id = @v_user_id,
		@p_company_id = @v_company_id,
		@p_division_id = @v_division_id,
		@p_site_id = @v_site_id,
		@p_operation_id =@v_operation_id,
		@p_item_class =@v_item_class,
		@p_item_id =@v_item_id,
		@p_division_lt =@v_division_lt,
		@p_site_lt = @v_site_lt,
		@opt_none = ''

		--SELECT 'xxxxx' AS dbtest

    --  COMMIT TRAN
    END TRY
    BEGIN CATCH
    --  ROLLBACK
      SET @runend = GetDate()
      
	  

    END CATCH

 --   SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG 'PR_UI_FP00180_FINDITEMTYPE',  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
 -- END


END
