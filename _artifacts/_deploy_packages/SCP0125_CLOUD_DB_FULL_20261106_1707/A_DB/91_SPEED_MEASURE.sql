-- SOURCE-FRESH: SCM_MGR PKG_SCP0125 BODY (DB=ZIOUI1 SERVER_HOST=localhost) FETCHED=2026-11-06 15:42:00 · 사내 LAST_DDL 2026-11-04 14:48:44(내용 = 10-30 17:47:37 적용본과 동일, 차이 0줄)
/* 91_SPEED_MEASURE — SCP0125 Workbench Stock 탭 조회 속도 측정(클라우드 개발)
 * 읽기 전용: 조회 프로시저를 화면과 같은 인자로 실행 → 결과 커서 전량 읽기 → 시간 출력 → ROLLBACK(작업용 임시표만 사용, 업무 표 변경 없음)
 * 실행 계정 = SCM_MGR(다른 계정이면 SCM_MGR 객체 실행 권한 필요 — 객체명은 SCM_MGR. 으로 고정) · 파일 전체 F5 · 반복 실행 안전 · DBeaver 는 '서버 출력(Output)' 창을 켜고 실행(3번 결과가 DBMS_OUTPUT 으로 나옴)
 *
 * 사내(로컬) 실측 2026-11-06 15:43~15:52 (같은 프로시저 직접 실행):
 *   P_SCP0125_GET_STOCK_ADJ 82/20260824  1회차 6.90s → 반복 2.92s
 *   P_SCP0125_GET_STOCK_ADJ 81/20260824  1회차 19.08s(832행 SCM_DNM_STOCK 표 읽기 14.72s · 디스크 대기) → 반복 4.63~7.01s
 *   P_SCP0125_GET_STOCK_ADJ 40/20260824  1회차 8.41s(같은 문장 6.47s)
 *   반복 시 큰 구간 = 759행 GT_0125_OCV_EXCEPT 1.50s(SCM_MST_MODEL_BOM 전체 읽기 563만 행) · 1346행 SCM_DNM_INTRANSIT_V 1.33~2.48s(뷰 전체 계산 뒤 조건)
 * 이 파일 결과(1~4번)를 그대로 전달하면 사내 값과 비교한다.
 */
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

/* 1) 10-30 속도 보완 반영 여부 — FIX_LINES >= 1 · STATUS = VALID 이어야 함
 *    FIX_LINES = 0 이면 클라우드에 보완 전 본문이 있다 → 측정 결과는 '보완 전' 값 · 20_PKG_PKG_SCP0125.sql 이관 여부부터 결정 */
SELECT (SELECT STATUS FROM ALL_OBJECTS WHERE OWNER = 'SCM_MGR' AND OBJECT_NAME = 'PKG_SCP0125' AND OBJECT_TYPE = 'PACKAGE BODY') AS BODY_STATUS
     , (SELECT TO_CHAR(LAST_DDL_TIME, 'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER = 'SCM_MGR' AND OBJECT_NAME = 'PKG_SCP0125' AND OBJECT_TYPE = 'PACKAGE BODY') AS BODY_LAST_DDL
     , (SELECT COUNT(*) FROM ALL_SOURCE WHERE OWNER = 'SCM_MGR' AND NAME = 'PKG_SCP0125' AND TYPE = 'PACKAGE BODY' AND TEXT LIKE '%V_AGE_FROM_DATE%') AS FIX_LINES
     , (SELECT COUNT(*) FROM ALL_SOURCE WHERE OWNER = 'SCM_MGR' AND NAME = 'PKG_SCP0125' AND TYPE = 'PACKAGE BODY') AS BODY_LINES
  FROM DUAL;

/* 2) 측정 기준일 고르기 — 사업부별 재고 최근 마감일(인덱스 IDX01_SCM_DNM_STOCK 최댓값 조회)
 *    3번의 기준일(P_PLAN_START_YYYYMMDD)은 화면 Version 콤보의 계획 시작일(월요일)이다. 클라우드 데이터에 없는 날이면 0행이 나오니 이 결과와 화면 Version 을 보고 3번 목록을 고친다 */
/*    (CUTOFF_DATE = 문자형 'YYYYMMDD' — 날짜형 값과 비교하면 인덱스를 못 탄다) */
SELECT '81' AS DIVISION_ID, (SELECT MAX(CUTOFF_DATE) FROM SCM_MGR.SCM_DNM_STOCK WHERE DIVISION_ID = '81') AS LAST_CUTOFF FROM DUAL
UNION ALL SELECT '82', (SELECT MAX(CUTOFF_DATE) FROM SCM_MGR.SCM_DNM_STOCK WHERE DIVISION_ID = '82') FROM DUAL
UNION ALL SELECT '40', (SELECT MAX(CUTOFF_DATE) FROM SCM_MGR.SCM_DNM_STOCK WHERE DIVISION_ID = '40') FROM DUAL;

/* 3) 측정 — Stock 탭 시트별 조회 프로시저(화면과 같은 인자: Version·Nick·Item 빈 값)
 *    조건마다 2회: RUN 1 = 첫 조회(데이터 블록이 메모리에 없으면 디스크 읽기) · RUN 2 = 바로 반복(메모리)
 *    출력 열: 프로시저 | 사업부 | 기준일 | RUN | 실행초 | 결과읽기초 | 합계초 | 행수 | 결과코드 */
DECLARE
    TYPE T_CASE  IS RECORD (PROC VARCHAR2(60), DIV VARCHAR2(20), YMD VARCHAR2(8));
    TYPE T_CASES IS TABLE OF T_CASE;
    V_CASES  T_CASES := T_CASES();
    V_RC     SYS_REFCURSOR;
    V_CODE   VARCHAR2(100);
    V_MSG    VARCHAR2(4000);
    V_CUR    INTEGER;
    V_ROWS   PLS_INTEGER;
    V_T0     TIMESTAMP;
    V_T1     TIMESTAMP;
    V_T2     TIMESTAMP;

    PROCEDURE ADD_CASE(P_PROC VARCHAR2, P_DIV VARCHAR2, P_YMD VARCHAR2) IS
    BEGIN
        V_CASES.EXTEND;
        V_CASES(V_CASES.LAST).PROC := P_PROC;
        V_CASES(V_CASES.LAST).DIV  := P_DIV;
        V_CASES(V_CASES.LAST).YMD  := P_YMD;
    END;

    FUNCTION SECS(P_A TIMESTAMP, P_B TIMESTAMP) RETURN NUMBER IS
        V_D INTERVAL DAY(3) TO SECOND(6) := P_B - P_A;
    BEGIN
        RETURN ROUND(EXTRACT(DAY FROM V_D) * 86400 + EXTRACT(HOUR FROM V_D) * 3600 + EXTRACT(MINUTE FROM V_D) * 60 + EXTRACT(SECOND FROM V_D), 2);
    END;
BEGIN
    /* ▼ 측정 목록 — 클라우드 데이터에 맞게 기준일만 바꾸면 된다(사내 실측과 같은 값이 기본) */
    ADD_CASE('P_SCP0125_GET_STOCK_ADJ',        '81',    '20260824');
    ADD_CASE('P_SCP0125_GET_STOCK_ADJ',        '82',    '20260824');
    ADD_CASE('P_SCP0125_GET_STOCK_ADJ',        '40',    '20260824');
    ADD_CASE('P_SCP0125_GET_STOCK_ADJ_UC',     '81_UC', '20260907');
    ADD_CASE('P_SCP0125_GET_STOCK_ELEC_PLNT',  '81',    '20260824');
    ADD_CASE('P_SCP0125_GET_STOCK_ELEC_UC',    '81_UC', '20260907');
    ADD_CASE('P_SCP0125_GET_STOCK_SECOND_OCV', '81',    '20260824');
    /* ▲ */

    DBMS_OUTPUT.PUT_LINE('PROC | DIV | YMD | RUN | CALL_S | FETCH_S | TOTAL_S | ROWS | CODE');
    FOR I IN 1 .. V_CASES.COUNT LOOP
        FOR K IN 1 .. 2 LOOP
            V_CODE := NULL; V_MSG := NULL; V_ROWS := 0;
            V_T0 := SYSTIMESTAMP;
            IF    V_CASES(I).PROC = 'P_SCP0125_GET_STOCK_ADJ'        THEN SCM_MGR.PKG_SCP0125.P_SCP0125_GET_STOCK_ADJ       (V_CASES(I).DIV, V_CASES(I).YMD, '', '', '', V_RC, V_CODE, V_MSG);
            ELSIF V_CASES(I).PROC = 'P_SCP0125_GET_STOCK_ADJ_UC'     THEN SCM_MGR.PKG_SCP0125.P_SCP0125_GET_STOCK_ADJ_UC    (V_CASES(I).DIV, V_CASES(I).YMD, '', '', '', V_RC, V_CODE, V_MSG);
            ELSIF V_CASES(I).PROC = 'P_SCP0125_GET_STOCK_ELEC_PLNT'  THEN SCM_MGR.PKG_SCP0125.P_SCP0125_GET_STOCK_ELEC_PLNT (V_CASES(I).DIV, V_CASES(I).YMD, '', '', '', V_RC, V_CODE, V_MSG);
            ELSIF V_CASES(I).PROC = 'P_SCP0125_GET_STOCK_ELEC_UC'    THEN SCM_MGR.PKG_SCP0125.P_SCP0125_GET_STOCK_ELEC_UC   (V_CASES(I).DIV, V_CASES(I).YMD, '', '', '', V_RC, V_CODE, V_MSG);
            ELSIF V_CASES(I).PROC = 'P_SCP0125_GET_STOCK_SECOND_OCV' THEN SCM_MGR.PKG_SCP0125.P_SCP0125_GET_STOCK_SECOND_OCV(V_CASES(I).DIV, V_CASES(I).YMD, '', '', '', V_RC, V_CODE, V_MSG);
            END IF;
            V_T1 := SYSTIMESTAMP;
            /* 결과 커서 전량 읽기(화면이 받는 행 수 그대로) — 열 형식과 무관하게 행만 센다 */
            IF V_RC%ISOPEN THEN
                V_CUR := DBMS_SQL.TO_CURSOR_NUMBER(V_RC);
                WHILE DBMS_SQL.FETCH_ROWS(V_CUR) > 0 LOOP
                    V_ROWS := V_ROWS + 1;
                END LOOP;
                DBMS_SQL.CLOSE_CURSOR(V_CUR);
            END IF;
            V_T2 := SYSTIMESTAMP;
            ROLLBACK;  /* 작업용 임시표 정리 · 업무 표 변경 없음 */
            DBMS_OUTPUT.PUT_LINE(V_CASES(I).PROC || ' | ' || V_CASES(I).DIV || ' | ' || V_CASES(I).YMD || ' | ' || K
                || ' | ' || TO_CHAR(SECS(V_T0, V_T1), 'FM9990.00') || ' | ' || TO_CHAR(SECS(V_T1, V_T2), 'FM9990.00')
                || ' | ' || TO_CHAR(SECS(V_T0, V_T2), 'FM9990.00') || ' | ' || V_ROWS || ' | ' || V_CODE || CASE WHEN V_MSG IS NOT NULL THEN ' ' || SUBSTR(V_MSG, 1, 200) END);
        END LOOP;
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('[ERROR] ' || SQLERRM || ' — 이 줄 앞까지의 결과는 유효');
END;
/

/* 4) (선택) 문장별 시간 — V$SQL 조회 권한이 있을 때만(없으면 ORA-00942 · 1~3번만 전달해도 됨)
 *    3번 실행 직후 실행. ELA_S 큰 순 = 느린 문장 · IO_S 가 크면 디스크 읽기, CPU_S 가 크면 계산량 */
SELECT S.PROGRAM_LINE#                         AS PKG_LINE
     , S.EXECUTIONS                            AS EXECS
     , ROUND(S.ELAPSED_TIME / 1E6, 2)          AS ELA_S
     , ROUND(S.CPU_TIME / 1E6, 2)              AS CPU_S
     , ROUND(S.USER_IO_WAIT_TIME / 1E6, 2)     AS IO_S
     , S.DISK_READS
     , S.BUFFER_GETS
     , S.PLAN_HASH_VALUE
     , S.SQL_ID
     , SUBSTR(S.SQL_TEXT, 1, 70)               AS SQL_HEAD
  FROM V$SQL S
 WHERE S.PROGRAM_ID IN (SELECT OBJECT_ID FROM ALL_OBJECTS WHERE OWNER = 'SCM_MGR' AND OBJECT_NAME = 'PKG_SCP0125' AND OBJECT_TYPE = 'PACKAGE BODY')
   AND S.LAST_ACTIVE_TIME > SYSDATE - 1 / 24
 ORDER BY S.ELAPSED_TIME DESC
 FETCH FIRST 15 ROWS ONLY;
