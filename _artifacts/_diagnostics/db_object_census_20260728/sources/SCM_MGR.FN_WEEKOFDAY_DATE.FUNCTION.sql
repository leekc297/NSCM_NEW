FUNCTION FN_WEEKOFDAY_DATE
(
    P_DATE      IN CHAR,
    P_WEEK      IN VARCHAR2,
    P_WEEKOFDAY IN VARCHAR2
)
RETURN VARCHAR2
/*
 * Program ID   : FN_WEEKOFDAY_DATE
 * Description  : 특정 일자 주기, 요일을 가져온다.
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.03.19   ygkim     Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2026.07.05   ZIONEX   [PJ202650304] NextSCM Migration
 *
 */
IS
    V_RE_DATE   VARCHAR2(10 CHAR);
    V_MONTH_1ST DATE;
    V_NEXT_1ST  DATE;
BEGIN
    V_MONTH_1ST := TO_DATE(P_DATE || '01', 'YYYYMMDD');
    V_NEXT_1ST  := ADD_MONTHS(V_MONTH_1ST, 1);

    IF TO_NUMBER(P_WEEK) = -1 THEN
        SELECT TO_CHAR(MAX(DT), 'YYYY-MM-DD')
          INTO V_RE_DATE
          FROM (
                SELECT DT,
                       MOD(TRUNC(DT) - TRUNC(DT, 'IW') + 1, 7) + 1 AS DOW
                  FROM (
                        SELECT V_MONTH_1ST + (LEVEL - 1) AS DT
                          FROM DUAL
                        CONNECT BY V_MONTH_1ST + (LEVEL - 1) < V_NEXT_1ST
                       )
               )
         WHERE DOW = TO_NUMBER(P_WEEKOFDAY);
    ELSE
        SELECT TO_CHAR(MAX(DT), 'YYYY-MM-DD')
          INTO V_RE_DATE
          FROM (
                SELECT DT,
                       TRUNC((TO_NUMBER(TO_CHAR(DT, 'DD')) + 6) / 7) AS WK,
                       MOD(TRUNC(DT) - TRUNC(DT, 'IW') + 1, 7) + 1 AS DOW
                  FROM (
                        SELECT V_MONTH_1ST + (LEVEL - 1) AS DT
                          FROM DUAL
                        CONNECT BY V_MONTH_1ST + (LEVEL - 1) < V_NEXT_1ST
                       )
               )
         WHERE WK  = TO_NUMBER(P_WEEK)
           AND DOW = TO_NUMBER(P_WEEKOFDAY);
    END IF;

    RETURN V_RE_DATE;
END FN_WEEKOFDAY_DATE;