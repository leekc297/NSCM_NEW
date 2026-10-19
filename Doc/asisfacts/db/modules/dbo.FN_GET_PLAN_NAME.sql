CREATE FUNCTION [dbo].[FN_GET_PLAN_NAME]
(@P_DIVISION_ID NVARCHAR(30)
,@P_PLAN_ID NVARCHAR(30)
,@P_PLAN_CYCLE NVARCHAR(30))
RETURNS NVARCHAR(100)
WITH EXEC AS CALLER
AS
/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * FUNCTION NAME : FN_GET_PLAN_NAME
  * DESCRIPTION   : PLAN NAME를 반환한다. 
  *
  * INPUT         : @str1 : DIVISION ID
  * OUTPUT        : PLAN NAME
  * USAGE         : SELECT DBO.FN_GET_PLAN_NAME('81','1013','WEEKLY')
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2017-02-20   LTW        INITIAL
  ****************************************************************************/
BEGIN
DECLARE @retVal nvarchar(max);

	set @retVal = (
    SELECT M.PLAN_NAME
    FROM SCM_MST_PLAN AS M 
    WHERE 1=1
      AND M.DIVISION_ID = @P_DIVISION_ID AND M.PLAN_CYCLE = @P_PLAN_CYCLE AND M.PLAN_ID = @P_PLAN_ID

  )

	RETURN ISNULL(@retVal,'');
END
