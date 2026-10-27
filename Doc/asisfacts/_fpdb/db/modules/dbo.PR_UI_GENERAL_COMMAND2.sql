CREATE PROCEDURE [dbo].[PR_UI_GENERAL_COMMAND2]
  @p_sys_type			nvarchar(MAX),  
  @p_sys_flag			nvarchar(MAX),
  @p_sys_gubun			nvarchar(MAX), 
  @p_user_id			nvarchar(MAX),
  @p_proc_name          nvarchar(MAX),

  @in_columns nvarchar(MAX),
  @in_row nvarchar(MAX),
  @in_row1 nvarchar(MAX)='',
  @in_row2 nvarchar(MAX)='',
  @in_row3 nvarchar(MAX)='',
  @in_row4 nvarchar(MAX)='',
  @in_row5 nvarchar(MAX)='',
  @in_row6 nvarchar(MAX)='',
  @in_row7 nvarchar(MAX)='',
  @in_row8 nvarchar(MAX)='',
  @in_row9 nvarchar(MAX)='',
  @opt_none             nvarchar(5) = 'N'

WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_UI_GENERAL_COMMAND                                                            **/
/** 프로그램 명   : Procedure PR_UI_GENERAL_COMMAND                                                                          **/
/** 설 명         :                                                                           **/
/** Version       : 1.0.0(Auto)                                                                     **/
/**                                                                                           **/
/** Argument                                                                                  **/
/** 
    p_sys_type : SQL 이면 SQL 문을 리턴한다            
	p_sys_flag : Insert, Delete, Update, Select를 지정한다. 1Row 입력 데이터만을 대상으로 한다. 
	p_sys_gubun : 각 프로시저별의 실행 조건을 지정한다
	p_user_id : 사용자ID를 지정한다 ( in_column에 USER_ID가 있는 경우 p_user_id 값을 덮어쓴다
	p_proc_name : 실행할 프로시저명
	in_columns : ^ 구분된 column명이다
	in_row : ^ 구분된 1줄 데이터이다
	opt_name : 사용하지 않는다 (END OF COMMAND의미로 사용한다)
**/
/** [검색 조건]                                                                              **/
/**                                                                                           **/
/** [Biz Logic]                                                                               **/
/**                                                                                           **/
/**-------------------------------------------------------------------------------------------**/
/** 작 성 일 자    작 성 자      사     유                                                    **/
/**===========================================================================================**/
/** 2021-02-15     XPDbToProcedure      Auto Generated With Initial Setting                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_UI_GENERAL_COMMAND
*/

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 
	SET XACT_ABORT ON;
  
	DECLARE @v_dSql NVARCHAR(MAX) = ''
	DECLARE @v_dParam NVARCHAR(MAX) = ''
	DECLARE @v_dValue NVARCHAR(MAX) = ''
	DECLARE @rtn int = -1
	DECLARE @v_in_row NVARCHAR(MAX) = ''

	SET @v_dSql = ''
	SET @v_dSql += 'EXEC	@return = [dbo].[' + @p_proc_name + '] '
	SET @v_dSql += ' @p_sys_type,'
	SET @v_dSql += ' @p_sys_flag,'
	SET @v_dSql += ' @p_sys_gubun,'
	SET @v_dSql += ' @p_user_id,'
	SET @v_dSql += ' @in_columns,'
	SET @v_dSql += ' @in_row,'

	SET @v_dSql += ' @opt_none'

	SET @v_dParam = ''
	SET @v_dParam += '@p_sys_type NVARCHAR(MAX),'
	SET @v_dParam += '@p_sys_flag NVARCHAR(MAX),'
	SET @v_dParam += '@p_sys_gubun NVARCHAR(MAX),'
	SET @v_dParam += '@p_user_id NVARCHAR(MAX),'
	SET @v_dParam += '@in_columns NVARCHAR(MAX),'
	SET @v_dParam += '@in_row NVARCHAR(MAX),'
	SET @v_dParam += '@return int OUTPUT,'
	SET @v_dParam += '@opt_none NVARCHAR(MAX)'

	SET @v_in_row += @in_row
	SET @v_in_row += @in_row1
	SET @v_in_row += @in_row2
	SET @v_in_row += @in_row3
	SET @v_in_row += @in_row4
	SET @v_in_row += @in_row5
	SET @v_in_row += @in_row6
	SET @v_in_row += @in_row7
	SET @v_in_row += @in_row8
	SET @v_in_row += @in_row9
	
	--SELECT PATINDEX('%:%',@v_in_row)
	--RETURN

	EXECUTE sp_executesql @v_dSql, @v_dParam,
		@p_sys_type=@p_sys_type,
		@p_sys_flag=@p_sys_flag,
		@p_sys_gubun=@p_sys_gubun,
		@p_user_id=@p_user_id,
		@in_columns=@in_columns,
		@in_row=@v_in_row,
		@return=@rtn OUTPUT,
		@opt_none=@opt_none

	--SELECT @v_dParam	
	return @rtn
END
