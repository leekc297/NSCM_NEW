FUNCTION FN_SCM_SYS_NVL
(
    P_COL_VALUE    IN VARCHAR2
  , P_REPLACE_ARG  IN VARCHAR2
)
RETURN VARCHAR2
/*
 * Program ID   : FN_SCM_SYS_NVL
 * Description  : 오라클의 NVL과 같은 기능을 한다.
 *        컬럼 값이 NULL인경우 다음 지정 한 값으로 대체 한다.
 *        공백도 NULL로 간주하여 처리한다.
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017.11.22   Kim jaejung     Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2026-07-03   ZIONEX  [PJ202650304]  NextSCM Migration
 *
 */
AS

    V_RET_VALUE VARCHAR2(4000 CHAR);

BEGIN

    IF (RTRIM(P_COL_VALUE) IS NULL) THEN
        V_RET_VALUE := P_REPLACE_ARG;
    ELSE
        V_RET_VALUE := P_COL_VALUE;
    END IF;

    RETURN V_RET_VALUE;

END;