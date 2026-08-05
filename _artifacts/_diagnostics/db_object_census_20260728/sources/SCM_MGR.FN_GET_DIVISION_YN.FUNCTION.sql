FUNCTION FN_GET_DIVISION_YN
(
    P_ATTRIBUTE1   IN VARCHAR2   /* '40,81,82' */
  , P_DIVISION_ID  IN VARCHAR2   /* '40' */
)
RETURN VARCHAR2
/*
 * PROJECT       : LG CHEM SCP PRJ.
 * FUNCTION NAME : FN_GET_DEPT_LIST
 * DESCRIPTION   :
 * INPUT         : P_CREATED_BY
 * OUTPUT        : NVARCHAR
 * PROGRAM HISTORY
 *--------------------------------------------------------------
   DATE      IN CHARGE           DESCRIPTION
 *--------------------------------------------------------------
 * 2018-05-24     JYE      DEPT LIST RETURN
 * 2026-07-03   ZIONEX  [PJ202650304]  NextSCM Migration
 *
 */
AS

    V_RET VARCHAR2(10 CHAR) := 'N';
    V_CNT PLS_INTEGER;

BEGIN

    SELECT COUNT(TOKEN)
      INTO V_CNT
      FROM (
            SELECT REGEXP_SUBSTR(P_ATTRIBUTE1, '[^,]+', 1, LEVEL) AS TOKEN
              FROM DUAL
           CONNECT BY REGEXP_SUBSTR(P_ATTRIBUTE1, '[^,]+', 1, LEVEL) IS NOT NULL
           )
     WHERE TOKEN = P_DIVISION_ID;

    IF (V_CNT <> 0) THEN
        V_RET := 'Y';
    END IF;

    RETURN V_RET;

END;