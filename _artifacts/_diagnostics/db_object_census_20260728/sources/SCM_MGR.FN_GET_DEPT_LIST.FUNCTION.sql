FUNCTION FN_GET_DEPT_LIST
(
    P_CREATED_BY IN VARCHAR2
  , P_DEPT_ID    IN VARCHAR2
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

    SELECT COUNT(*)
      INTO V_CNT
      FROM (
            /* 매핑 데이터가 있는 경우 */
            SELECT LOOK.SEGMENT3
              FROM SCM_ADM_USER_M                USR
                 , SCM_ADM_LOOKUP_MASTER_DETAIL  LOOK
             WHERE USR.DEPT_ID = LOOK.SEGMENT1
               AND LOOK.LOOKUP_TYPE = 'PM_TEAM_MAPPING'
               AND LOOK.VALID_YN = 'Y'
               AND UPPER(USR.USER_ID) = UPPER(P_CREATED_BY)

            UNION ALL
            /* 매핑이 없는 경우 자기 부서 */
            SELECT DEPT_ID
              FROM SCM_ADM_USER_M
             WHERE UPPER(USER_ID) = UPPER(P_CREATED_BY)
           ) MA
     WHERE MA.SEGMENT3 = P_DEPT_ID;

    IF (V_CNT = 0) THEN
        V_RET := 'N';
    ELSE
        V_RET := 'Y';
    END IF;

    RETURN V_RET;

END;