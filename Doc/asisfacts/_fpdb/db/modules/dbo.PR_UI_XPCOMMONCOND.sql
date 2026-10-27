CREATE PROCEDURE [dbo].[PR_UI_XPCOMMONCOND]
  @p_sys_type			nvarchar(MAX),  
  @p_sys_flag			nvarchar(MAX),
  @p_sys_gubun			nvarchar(MAX), 
  @p_user_id			nvarchar(MAX),
  @p_procedure_name     nvarchar(MAX),

  @in_columns nvarchar(MAX),
  @in_row nvarchar(MAX),

  @opt_none nvarchar(5) = 'N'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_UI_XPCOMMONCOND_FINDAMENDINSTANCELIST_COMMON                                                            **/
/** 프로그램 명   : Procedure PR_UI_XPCOMMONCOND_FINDAMENDINSTANCELIST_COMMON                                                                          **/
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
/** 2021-02-15     XPDbToProcedure      Auto Generated With Initial Setting                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_UI_XPCOMMONCOND_FINDAMENDINSTANCELIST_COMMON
*/

BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
  SET NOCOUNT ON; 
  SET XACT_ABORT ON;
  
  

END
