FUNCTION FN_GET_DIVISION_NAME
(
  P_DIVISION_ID IN VARCHAR2
)
RETURN VARCHAR2
/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * FUNCTION NAME : FN_GET_DIVISION_NAME
  * DESCRIPTION   : DIVISION NAME를 반환한다.
  *
  * INPUT         : @str1 : DIVISION ID
  * OUTPUT        : DIVISION NAME
  * USAGE         : SELECT DBO.FN_GET_DIVISION_NAME('40')
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2017-01-17   kth        INITIAL
  * 2026.07.05   ZIONEX   [PJ202650304] NextSCM Migration
  ****************************************************************************/
IS
  V_RETVAL VARCHAR2(4000 CHAR);
BEGIN

  SELECT DIVISION_NAME
    INTO V_RETVAL
    FROM (
          SELECT DIVISION_NAME
            FROM SCM_MST_DIVISION
           WHERE DIVISION_ID = P_DIVISION_ID
         )
   WHERE ROWNUM = 1;

  RETURN V_RETVAL;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
       RETURN NULL;
END;