CREATE PROCEDURE [dbo].[PR_UI_EMPTY_TEST0]
  @p_sys_type			nvarchar(MAX)='',  
  @p_sys_flag			nvarchar(MAX)='',
  @p_sys_gubun			nvarchar(MAX)='',  
  @p_xxxx			nvarchar(MAX)='',
  @ooooo_uuuuu nvarchar(MAX)='',
  @in_row nvarchar(MAX)='',
  @opt_none nvarchar(5) = 'N'
WITH EXEC AS CALLER
AS


BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
  SET NOCOUNT ON; 
  SET XACT_ABORT ON;
  
  SELECT '3333' AS SUCCESS

  WAITFOR DELAY '00:02:00'
  --exec sp_executesql 'UNPARSE sele'
  print 'done'
    SELECT '3333' AS SUCCESS
  RETURN 0
END
