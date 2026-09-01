CREATE OR REPLACE FUNCTION FN_MULTY_TIME
(
    P_TIME_ZONE  IN  VARCHAR2
)
RETURN DATE
/*
 * Program ID   : FN_MULTY_TIME
 * Description  : 멀티 타임
 * 사용방법: SELECT DBO.FN_MULTY_TIME('EU042')		;
 * 부가설명: 매월 주차는 1일 기준으로 돌아오는 같은주 이전 일까지를 1주차로 본다
 * 입력방법: ATTRIBUTE1(국가), ATTRIBUTE2(OFFSET), ATTRIBUTE3(써머타입 적용여부), LOOKUP_CODE(기준코드)
 * 			 시작: ATTRIBUTE4(월), ATTRIBUTE5(주차), ATTRIBUTE6 (요일),ATTRIBUTE7 (시간)
 *           종료: ATTRIBUTE8(월), ATTRIBUTE9(주차), ATTRIBUTE10(요일),ATTRIBUTE11(시간)
 *           ATTRIBUTE5(주차), ATTRIBUTE9(주차) : -1 일 경우 마지막 주차의 요일을 가져온다.
 *			 Summer Time 적용 기준
 *           - 월   : 1 ~ 12
 *           - 주차 : 1 (1주차), 2 (2주차), 3 (3주차), -1 (마지막주차)  -> 1주차 기준 : 해당 월의 일자가 첫번째 일요일인 경우 1주차 ( ex- 3일이 일요일인 경우 3일 주차가 1주차)
 *           - 요일 : 1 (일), 2 (월), 3 (화), 4 (수), 5 (목), 6 (금), 7 (토)
 *           - 시간 : 0 ~ 23
 * Program History
 *===================================================================================================
 *   Date          In Charge      Description
 *===================================================================================================
 * 2017. 11. 27    정원식         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018. 03. 21    ygkim
 * - 입력방법 수정, LOOKUP 테이블 변경, 프로시저 신규 작성, 시작, 종료 일자 가져오는 FN_WEEKOFDAY_DATE 함수 추가
 * 2026.07.06   ZIONEX   [PJ202650304] NextSCM Migration
 */
IS
    L_TZ            VARCHAR2(600 CHAR) := NVL(P_TIME_ZONE, 'AS054');

    L_OFFSET_HOUR   NUMBER;
    L_SUMMERTIME    VARCHAR2(600 CHAR);

    L_START_MONTH   VARCHAR2(6 CHAR);
    L_START_WEEK    VARCHAR2(600 CHAR);
    L_START_DAY     VARCHAR2(600 CHAR);
    L_START_TIME    VARCHAR2(600 CHAR);

    L_END_MONTH     VARCHAR2(6 CHAR);
    L_END_WEEK      VARCHAR2(600 CHAR);
    L_END_DAY       VARCHAR2(600 CHAR);
    L_END_TIME      VARCHAR2(600 CHAR);

    L_UTC_NOW       DATE := CAST(SYS_EXTRACT_UTC(SYSTIMESTAMP) AS DATE);
    L_UTCTIME       DATE;

    L_YEAR          VARCHAR2(4 CHAR);
    L_SRT_YYYYMM    VARCHAR2(10 CHAR);
    L_END_YYYYMM    VARCHAR2(10 CHAR);

    L_START_DAY_STR VARCHAR2(10 CHAR);
    L_END_DAY_STR   VARCHAR2(10 CHAR);

    L_START_DATE    DATE;
    L_END_DATE      DATE;

    L_SUMMER_ZONE   DATE;
    L_RESULT        DATE;
BEGIN
    SELECT TO_NUMBER(A.ATTRIBUTE2)
         , A.ATTRIBUTE3
         , LPAD(A.ATTRIBUTE4, 2, '0')
         , A.ATTRIBUTE5
         , A.ATTRIBUTE6
         , A.ATTRIBUTE7
         , LPAD(A.ATTRIBUTE8, 2, '0')
         , A.ATTRIBUTE9
         , A.ATTRIBUTE10
         , A.ATTRIBUTE11
      INTO L_OFFSET_HOUR
         , L_SUMMERTIME
         , L_START_MONTH
         , L_START_WEEK
         , L_START_DAY
         , L_START_TIME
         , L_END_MONTH
         , L_END_WEEK
         , L_END_DAY
         , L_END_TIME
      FROM SCM_ADM_LOOKUP_MASTER_DETAIL A
     WHERE A.SEGMENT1    = L_TZ
       AND A.LOOKUP_TYPE = 'TIME_ZONE'
       AND A.VALID_YN    = 'Y';

    L_UTCTIME := L_UTC_NOW + (L_OFFSET_HOUR / 24);

    L_YEAR := TO_CHAR(L_UTC_NOW, 'YYYY');

    L_SRT_YYYYMM := L_YEAR || L_START_MONTH;
    L_END_YYYYMM := L_YEAR || L_END_MONTH;

    IF L_SUMMERTIME = 'Y' THEN
        L_START_DAY_STR := FN_WEEKOFDAY_DATE(L_SRT_YYYYMM, L_START_WEEK, L_START_DAY);
        L_END_DAY_STR   := FN_WEEKOFDAY_DATE(L_END_YYYYMM, L_END_WEEK, L_END_DAY);

        L_START_DATE := TO_DATE(L_START_DAY_STR || ' ' || LPAD(L_START_TIME, 2, '0') || ':00:00', 'YYYY-MM-DD HH24:MI:SS');
        L_END_DATE   := TO_DATE(L_END_DAY_STR   || ' ' || LPAD(L_END_TIME,   2, '0') || ':00:00', 'YYYY-MM-DD HH24:MI:SS');
    ELSE
        L_START_DATE := NULL;
        L_END_DATE   := NULL;
    END IF;

    IF L_SUMMERTIME = 'Y' AND L_UTCTIME >= L_START_DATE THEN
        L_SUMMER_ZONE := L_UTCTIME + (1 / 24);
    ELSE
        L_SUMMER_ZONE := L_UTCTIME;
    END IF;

    IF L_SUMMERTIME = 'Y' AND L_SUMMER_ZONE > L_END_DATE THEN
        L_RESULT := L_SUMMER_ZONE - (1 / 24);
    ELSE
        L_RESULT := L_SUMMER_ZONE;
    END IF;

    RETURN L_RESULT;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    WHEN OTHERS THEN
        RETURN NULL;
END FN_MULTY_TIME;
/
