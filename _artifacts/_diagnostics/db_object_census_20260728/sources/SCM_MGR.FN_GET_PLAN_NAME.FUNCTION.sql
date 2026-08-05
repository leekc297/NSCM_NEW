FUNCTION FN_GET_PLAN_NAME
(
    P_DIVISION_ID  IN VARCHAR2
  , P_PLAN_ID      IN VARCHAR2
  , P_PLAN_CYCLE   IN VARCHAR2
)
RETURN VARCHAR2
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
  * 2026-07-03   ZIONEX  [PJ202650304]  NextSCM Migration
  ****************************************************************************/
AS

    V_RETVAL VARCHAR2(100 CHAR);

BEGIN

    BEGIN
        SELECT M.PLAN_NAME
          INTO V_RETVAL
          FROM SCM_MST_PLAN M
         WHERE 1 = 1
           AND M.DIVISION_ID = P_DIVISION_ID
           AND M.PLAN_CYCLE  = P_PLAN_CYCLE
           AND M.PLAN_ID     = P_PLAN_ID;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_RETVAL := NULL;
    END;

    RETURN V_RETVAL;

END;