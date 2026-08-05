FUNCTION FN_MULTY_TIME (

    P_TIME_ZONE IN VARCHAR2
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
 * 2026.03.06      jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발
 * - 입력방법 수정, LOOKUP 테이블 변경, 프로시저 신규 작성, 시작, 종료 일자 가져오는 FN_WEEKOFDAY_DATE 함수 추가
 */
IS
    L_TZ            VARCHAR2(100) := NVL(P_TIME_ZONE, 'AS054');

    L_OFFSET_HOUR   NUMBER;
    L_SUMMERTIME    VARCHAR2(1);

    L_START_MONTH   VARCHAR2(2);
    L_START_WEEK    NUMBER;
    L_START_DAY     NUMBER;
    L_START_TIME    NUMBER;

    L_END_MONTH     VARCHAR2(2);
    L_END_WEEK      NUMBER;
    L_END_DAY       NUMBER;
    L_END_TIME      NUMBER;

    L_UTC_NOW       DATE := CAST(SYSTIMESTAMP AT TIME ZONE 'utc' AS DATE);
    L_UTCTIME       DATE;

    L_YEAR          VARCHAR2(4);
    L_SRT_YYYYMM    VARCHAR2(6);
    L_END_YYYYMM    VARCHAR2(6);

    L_START_DAY_STR VARCHAR2(10);
    L_END_DAY_STR   VARCHAR2(10);

    L_START_DATE    DATE;
    L_END_DATE      DATE;

    L_SUMMER_ZONE   DATE;
    L_RESULT        DATE;
BEGIN
    SELECT TO_NUMBER(DECODE(A.ATTRIBUTE2,'-',0)),
           NVL(A.ATTRIBUTE3, 'N'),
           LPAD(A.ATTRIBUTE4, 2, '0'),
           TO_NUMBER(DECODE(A.ATTRIBUTE5,'-',0)),
           TO_NUMBER(DECODE(A.ATTRIBUTE6,'-',0)),
           TO_NUMBER(DECODE(A.ATTRIBUTE7,'-',0)),
           LPAD(A.ATTRIBUTE8, 2, '0'),
           TO_NUMBER(DECODE(A.ATTRIBUTE9,'-',0)),
           TO_NUMBER(DECODE(A.ATTRIBUTE10,'-',0)),
           TO_NUMBER(DECODE(A.ATTRIBUTE11,'-',0))
      INTO L_OFFSET_HOUR,
           L_SUMMERTIME,
           L_START_MONTH, L_START_WEEK, L_START_DAY, L_START_TIME,
           L_END_MONTH,   L_END_WEEK,   L_END_DAY,   L_END_TIME
      FROM SCM_ADM_LOOKUP_MASTER_DETAIL A
     WHERE A.SEGMENT1    = L_TZ
       AND A.LOOKUP_TYPE = 'TIME_ZONE'
       AND A.VALID_YN    = 'Y';

    -- dbms_output.put_line('l_utc_now:'||l_utc_now);

    L_UTCTIME := L_UTC_NOW + (NVL(L_OFFSET_HOUR,0) / 24);

    L_YEAR := TO_CHAR(L_UTC_NOW, 'yyyy');

    L_SRT_YYYYMM := L_YEAR || L_START_MONTH;
    L_END_YYYYMM := L_YEAR || L_END_MONTH;

    IF L_SUMMERTIME = 'Y' THEN
        L_START_DAY_STR := FN_WEEKOFDAY_DATE(L_SRT_YYYYMM, TO_CHAR(L_START_WEEK), TO_CHAR(L_START_DAY));
        L_END_DAY_STR   := FN_WEEKOFDAY_DATE(L_END_YYYYMM, TO_CHAR(L_END_WEEK),   TO_CHAR(L_END_DAY));

        L_START_DATE := TO_DATE(
            L_START_DAY_STR || ' ' || LPAD(L_START_TIME, 2, '0') || ':00:00',
            'yyyy-mm-dd hh24:mi:ss'
        );

        L_END_DATE := TO_DATE(
            L_END_DAY_STR   || ' ' || LPAD(L_END_TIME,   2, '0') || ':00:00',
            'yyyy-mm-dd hh24:mi:ss'
        );
    ELSE
        L_START_DATE := NULL;
        L_END_DATE   := NULL;
    END IF;

    -- dbms_output.put_line('l_utctime:'||l_utctime);

    IF L_SUMMERTIME = 'Y' AND L_UTCTIME >= L_START_DATE THEN
        L_SUMMER_ZONE := L_UTCTIME + (1/24);
    ELSE
        L_SUMMER_ZONE := L_UTCTIME;
    END IF;

    -- dbms_output.put_line('l_summer_zone:'||l_summer_zone);


    IF L_SUMMERTIME = 'Y' AND L_SUMMER_ZONE > L_END_DATE THEN
        L_RESULT := L_SUMMER_ZONE - (1/24);
    ELSE
        L_RESULT := L_SUMMER_ZONE;
    END IF;

    -- dbms_output.put_line('l_result:'||l_result);


    RETURN L_RESULT;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        --DBMS_OUTPUT.PUT_LINE('1.ERROR CODE : ' || SQLCODE);
        --DBMS_OUTPUT.PUT_LINE('1.ERROR MSG  : ' || SQLERRM);
        RETURN NULL;
    WHEN OTHERS THEN
        --DBMS_OUTPUT.PUT_LINE('2.ERROR CODE : ' || SQLCODE);
        --DBMS_OUTPUT.PUT_LINE('2.ERROR MSG  : ' || SQLERRM);
        RETURN NULL;
END FN_MULTY_TIME;
-- SELECT FN_MULTY_TIME('HQ05-82-AS-KR') FN_MULTY_TIME FROM dual;