FUNCTION FN_NEXT_DAY
(
    P_DATEVAL  IN DATE
  , P_WEEK     IN VARCHAR2
)
RETURN DATE
/*
 * Program ID   : FN_NEXT_DAY
 * Description  : 특정 일자 이후 요일 일자 찾기
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017.11.22   Kim SungGi     Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2026-07-03   ZIONEX  [PJ202650304]  NextSCM Migration
 *
 */
AS

    V_DAYVAL     PLS_INTEGER;
    V_RESULTDAY  DATE;
    V_DW         PLS_INTEGER;

BEGIN

    IF P_WEEK = 'SUN' THEN /* OR @week = '일' */
        V_DAYVAL := 1;
    ELSIF P_WEEK = 'MON' THEN /* OR @week = '월' */
        V_DAYVAL := 2;
    ELSIF P_WEEK = 'TUE' THEN /* OR @week = '화' */
        V_DAYVAL := 3;
    ELSIF P_WEEK = 'WED' THEN /* OR @week = '수' */
        V_DAYVAL := 4;
    ELSIF P_WEEK = 'THU' THEN /* OR @week = '목' */
        V_DAYVAL := 5;
    ELSIF P_WEEK = 'FRI' THEN /* OR @week = '금' */
        V_DAYVAL := 6;
    ELSIF P_WEEK = 'SAT' THEN /* OR @week = '토' */
        V_DAYVAL := 7;
    ELSE
        V_DAYVAL := 0;
        RETURN NULL;
    END IF;

    /* datepart(dw): MSSQL @@DATEFIRST 기본(7)=일요일1 기준. NLS_TERRITORY 비의존 위해 ISO주(월요일 시작) 기반 산출. */
    V_DW := MOD(TRUNC(P_DATEVAL) - TRUNC(P_DATEVAL, 'IW') + 1, 7) + 1;

    V_RESULTDAY := P_DATEVAL + 7;
    V_RESULTDAY := V_RESULTDAY - V_DW;
    V_RESULTDAY := V_RESULTDAY + V_DAYVAL;

    IF V_DW < V_DAYVAL THEN
        V_RESULTDAY := V_RESULTDAY - 7;
    END IF;

    RETURN V_RESULTDAY;

END;