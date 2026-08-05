FUNCTION FN_GET_DEPT_LIST2
(
    P_CREATED_BY   IN VARCHAR2
    /* @P_DEPT_ID  NVARCHAR(100) : 원본 주석처리(SCM_SITE_ID로 대체) */
  , P_SCM_SITE_ID  IN VARCHAR2
)
RETURN VARCHAR2
/*
 * PROJECT       : LG CHEM SCP PRJ.
 * FUNCTION NAME : FN_GET_DEPT_LIST2
 * DESCRIPTION   :
 * INPUT         : P_CREATED_BY
 * OUTPUT        : NVARCHAR
 * PROGRAM HISTORY
 *--------------------------------------------------------------
   DATE      IN CHARGE           DESCRIPTION
 *--------------------------------------------------------------
 * 2018-06-26     lsh      DEPT LIST RETURN
 select [dbo].[FN_GET_DEPT_LIST2]('kooht', '58520394')
 select [dbo].[FN_GET_DEPT_LIST2]('ztychoi', '58124984')
 * 2026-07-03   ZIONEX  [PJ202650304]  NextSCM Migration
 */
AS

    V_RET VARCHAR2(10 CHAR) := 'N';
    V_CNT PLS_INTEGER;

BEGIN

    SELECT COUNT(*)
      INTO V_CNT
      FROM (
            /*
                SELECT DISTINCT A.OWNER
                FROM SCM_MST_SITE_ITEM A, SCM_MST_SSO_USER_INFO B, SCM_MST_SSO_DEPT_INFO C
                WHERE A.OWNER = B.USER_ID
                AND B.DEPT_ID = C.DEPT_ID
                AND A.OWNER = @p_created_by
                AND B.DEPT_ID = @p_dept_id
            */
            SELECT DISTINCT A.OWNER
              FROM SCM_MST_SITE_ITEM A
                 , SCM_MST_SSO_USER_INFO B
                 , SCM_MST_SSO_USER_INFO C
             WHERE UPPER(A.OWNER) = UPPER(B.USER_ID)
               AND B.DEPT_ID = C.DEPT_ID
               AND UPPER(C.USER_ID) = UPPER(P_CREATED_BY)
               AND A.SCM_SITE_ID = P_SCM_SITE_ID
           ) T;

    IF (V_CNT = 0) THEN
        V_RET := 'N';
    ELSE
        V_RET := 'Y';
    END IF;

    RETURN V_RET;

END;