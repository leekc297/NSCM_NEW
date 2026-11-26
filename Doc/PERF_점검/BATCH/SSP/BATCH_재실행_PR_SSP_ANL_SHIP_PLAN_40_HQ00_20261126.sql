-- ==============================================================================================================
-- PR_SSP_ANL_SHIP_PLAN_40('40', 'HQ00') 클라우드 재실행, 소요 측정 · 실행 계정 SCM_MGR
-- 순서 : [V0] 패키지 적용 확인 → [R0] 사전 확인 → [R1] 재실행(익명 블록) → [R2] [R3] 단계별 소요(재실행 직후, 같은 날)
-- DBeaver : 출력 창(Show server output, Ctrl+Shift+O)을 켠 뒤 블록마다 커서를 두고 Ctrl+Enter. [R1] 은 블록 전체를 선택해 Ctrl+Enter
-- 재실행 조건(SP 원문 191 ~ 232줄)
--   가드 1 : 오늘 HQ00 SHIP_CONFIRM 행이 있으면 SP 가 바로 RETURN. [R1] 이 이 행만 지운 뒤 SP 를 부름(커밋 안 한 상태)
--   가드 2 : IF_STOCK_CHECK(PLAN_40, 40, HQ00) 오늘 I/F 수신이 다 Y 가 아니면 SP 가 바로 RETURN. 이때 [R1] 이 ROLLBACK 해서 지운 행을 되돌림
--   SP 3단계가 오늘 HQ00 사이트 행 전체를 지우고 다시 만듦. 성공 시 SP 안 COMMIT(3490줄) 1번, 오류 시 SP 가 ROLLBACK 해서 [R1] 의 삭제도 되돌아감
-- 1-1 단계 OWMS CUTOFF 생성(최근 CUTOFF 조회 83wgypmy3wyvu 포함)은 오늘 HQ00 SSP_ANL_OWMS_STOCK_C 가 없을 때만 실행됨
--   1-1 까지 다시 재려면 [R1] 의 C_OWMS_RERUN = 'Y'. 오늘 HQ00 SSP_ANL_OWMS_STOCK_C 행을 커밋 안 한 채 지우고 SP 가 다시 만듦(SP 오류, 가드 RETURN 이면 되돌림)
--   C_OWMS_RERUN = 'Y' 이면 그 사이 들어온 OWMS I/F 가 있을 때 오늘 OWMS 재고가 새 I/F 기준으로 바뀜
-- 1-6(awr2c30u4h31c), 2-14(aj7nw6qjt4tjv), 3(cy0a8kvgd0cw7) 단계는 조건 없이 매번 실행됨
-- 같은 JOB 의 BALANCE, CONFIRM_BATCH_40, MAIL 은 다시 실행하지 않음. SHIP_PLAN_40 결과만 오늘 기준으로 다시 만들어짐
-- ==============================================================================================================

ALTER SESSION SET CURRENT_SCHEMA = SCM_MGR;

-- ==============================================================================================================
-- [V0] 패키지 적용 확인 : STATUS VALID, ERR_CNT 0, LINE_CNT 3592(PERF3 적용 뒤), M_DS2, M_OWMSMAX, M_AGINGCUT, M_WHSTKHD, M_POSTSS 각 1
-- ==============================================================================================================
SELECT O.OBJECT_NAME
     , O.STATUS
     , TO_CHAR(O.LAST_DDL_TIME, 'YYYY-MM-DD HH24:MI:SS') AS LAST_DDL_TIME
     , (SELECT COUNT(*) FROM ALL_ERRORS E WHERE E.OWNER = 'SCM_MGR' AND E.NAME = O.OBJECT_NAME) AS ERR_CNT
     , S.LINE_CNT
     , S.M_DS2
     , S.M_OWMSMAX
     , S.M_AGINGCUT
     , S.M_WHSTKHD
     , S.M_POSTSS
  FROM ALL_OBJECTS O
     , (SELECT COUNT(*) AS LINE_CNT
             , COUNT(CASE WHEN INSTR(TEXT, 'E20261126-DS2') > 0 THEN 1 END) AS M_DS2
             , COUNT(CASE WHEN INSTR(TEXT, 'E20261126-OWMSMAX') > 0 THEN 1 END) AS M_OWMSMAX
             , COUNT(CASE WHEN INSTR(TEXT, 'E20261126-AGINGCUT') > 0 THEN 1 END) AS M_AGINGCUT
             , COUNT(CASE WHEN INSTR(TEXT, 'E20261126-WHSTKHD') > 0 THEN 1 END) AS M_WHSTKHD
             , COUNT(CASE WHEN INSTR(TEXT, 'E20261126-POSTSS') > 0 THEN 1 END) AS M_POSTSS
          FROM ALL_SOURCE
         WHERE OWNER = 'SCM_MGR' AND NAME = 'PR_SSP_ANL_SHIP_PLAN_40' AND TYPE = 'PROCEDURE') S
 WHERE O.OWNER = 'SCM_MGR'
   AND O.OBJECT_NAME = 'PR_SSP_ANL_SHIP_PLAN_40'
   AND O.OBJECT_TYPE = 'PROCEDURE';

-- ==============================================================================================================
-- [R0] 사전 확인 : GUARD_STOCK = 0, RUNNING_CNT = 0, MARK_DS2 = 1 이면 [R1] 진행
--   GUARD_PLAN > 0 이면 오늘 결과가 있는 상태. [R1] 의 C_RERUN = 'Y' 로 실행
-- ==============================================================================================================
SELECT (SELECT COUNT(*)
          FROM SSP_ANL_SHIP_PLAN_40
         WHERE DIVISION_ID         = '40'
           AND PLAN_START_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD')
           AND MEASURE             = 'SHIP_CONFIRM'
           AND ATTRIBUTE10         = 'HQ00') AS GUARD_PLAN
     , (SELECT CASE WHEN A.TOT_CNT <> B.PASS_CNT THEN 1 ELSE 0 END
          FROM (SELECT COUNT(*) AS TOT_CNT
                  FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                 WHERE LOOKUP_TYPE = 'IF_STOCK_CHECK' AND VALID_YN = 'Y' AND SEGMENT1 = 'PLAN_40' AND SEGMENT3 = '40' AND SEGMENT4 = 'HQ00') A
             , (SELECT COUNT(*) AS PASS_CNT
                  FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                 WHERE LOOKUP_TYPE = 'IF_STOCK_CHECK' AND VALID_YN = 'Y' AND SEGMENT1 = 'PLAN_40' AND SEGMENT3 = '40' AND SEGMENT4 = 'HQ00'
                   AND SEGMENT5 = TO_CHAR(SYSDATE, 'YYYYMMDD') AND ATTRIBUTE1 = 'Y') B) AS GUARD_STOCK
     , (SELECT COUNT(*)
          FROM SSP_ANL_SHIP_PLAN_40 P
         WHERE P.DIVISION_ID         = '40'
           AND P.PLAN_START_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD')
           AND P.ATTRIBUTE10         = 'HQ00') AS TODAY_HQ00_ROWS
     , (SELECT COUNT(*)
          FROM GV$SESSION S
          JOIN ALL_OBJECTS O
            ON O.OBJECT_ID = S.PLSQL_ENTRY_OBJECT_ID
         WHERE O.OWNER = 'SCM_MGR'
           AND O.OBJECT_NAME IN ('PR_SSP_ANL_SHIP_PLAN_40', 'PR_SSP_ANL_SHIP_PLAN_40_BALANCE', 'PR_SSP_MAIL_SHIP_REQ_MINUS_BALANCE_40')) AS RUNNING_CNT
     , (SELECT COUNT(*)
          FROM ALL_SOURCE C
         WHERE C.OWNER = 'SCM_MGR'
           AND C.NAME  = 'PR_SSP_ANL_SHIP_PLAN_40'
           AND C.TYPE  = 'PROCEDURE'
           AND C.TEXT LIKE '%E20261126-DS2%') AS MARK_DS2
     , (SELECT O.STATUS || ' ' || TO_CHAR(O.LAST_DDL_TIME, 'YYYY-MM-DD HH24:MI:SS')
          FROM ALL_OBJECTS O
         WHERE O.OWNER = 'SCM_MGR'
           AND O.OBJECT_NAME = 'PR_SSP_ANL_SHIP_PLAN_40'
           AND O.OBJECT_TYPE = 'PROCEDURE') AS SP_STATUS
     , (SELECT COUNT(*)
          FROM SSP_ANL_OWMS_STOCK_C A
          JOIN SCM_MST_SITE B
            ON B.DIVISION_ID = '40'
           AND NVL(B.COMPANY_ID, '-') = 'HQ00'
           AND B.DIVISION_ID = A.DIVISION_ID
           AND B.SCM_SITE_ID = A.FROM_SITE
         WHERE A.DIVISION_ID         = '40'
           AND A.PLAN_START_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD')
           AND A.PLAN_TYPE           = 'SP'
           AND A.SEQ                 = 1) AS TODAY_HQ00_OWMS_ROWS
     , TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') AS DB_SYSDATE
  FROM DUAL;

-- ==============================================================================================================
-- [R1] 재실행 : 출력 창에 SID, 시작, 종료, 소요 초, 로그 결과를 찍음. 이 출력 전체를 회신
--   MODULE = PERF_RERUN_SHIP40 으로 표시해서 [R2] [R3] 가 이 실행분만 집계함
-- ==============================================================================================================
DECLARE
    C_RERUN     CONSTANT VARCHAR2(1) := 'Y';   /* Y = 오늘 HQ00 SHIP_CONFIRM 행을 지우고 다시 만듦. N = 지우지 않음(가드 1 에 걸리면 SP 가 바로 끝남) */
    C_OWMS_RERUN CONSTANT VARCHAR2(1) := 'N';  /* Y = 오늘 HQ00 SSP_ANL_OWMS_STOCK_C 도 지워 1-1 단계까지 다시 실행. N = 1-1 단계 건너뜀 */
    N_DEL_OWMS  NUMBER := 0;
    D_CALL      DATE;
    T_START     TIMESTAMP;
    T_END       TIMESTAMP;
    N_DEL       NUMBER := 0;
    N_START     NUMBER := 0;
    N_ROWS      NUMBER := 0;
    V_END_TYPE  VARCHAR2(30);
    V_END_DESC  VARCHAR2(4000);
    V_END_MSG   VARCHAR2(4000);
    V_DS        VARCHAR2(100);
BEGIN
    DBMS_APPLICATION_INFO.SET_MODULE('PERF_RERUN_SHIP40', 'HQ00');

    IF C_RERUN = 'Y' THEN
        DELETE FROM SSP_ANL_SHIP_PLAN_40
         WHERE DIVISION_ID         = '40'
           AND PLAN_START_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD')
           AND MEASURE             = 'SHIP_CONFIRM'
           AND ATTRIBUTE10         = 'HQ00';
        N_DEL := SQL%ROWCOUNT;
    END IF;

    IF C_OWMS_RERUN = 'Y' THEN
        DELETE FROM SSP_ANL_OWMS_STOCK_C A
         WHERE A.DIVISION_ID         = '40'
           AND A.PLAN_START_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD')
           AND A.PLAN_TYPE           = 'SP'
           AND A.SEQ                 = 1
           AND EXISTS ( SELECT 1
                          FROM SCM_MST_SITE B
                         WHERE B.DIVISION_ID = '40'
                           AND NVL(B.COMPANY_ID, '-') = 'HQ00'
                           AND B.DIVISION_ID = A.DIVISION_ID
                           AND B.SCM_SITE_ID = A.FROM_SITE );
        N_DEL_OWMS := SQL%ROWCOUNT;
    END IF;

    D_CALL  := SYSDATE;
    T_START := SYSTIMESTAMP;

    PR_SSP_ANL_SHIP_PLAN_40('40', 'HQ00');

    T_END := SYSTIMESTAMP;

    SELECT COUNT(*)
      INTO N_START
      FROM SCM_SYS_LOG_BATCH
     WHERE PROGRAM_NAME = 'PR_SSP_ANL_SHIP_PLAN_40'
       AND LOG_TYPE     = 'START'
       AND EVENT_DATE  >= D_CALL;

    IF N_START = 0 THEN
        ROLLBACK;   /* 가드로 바로 끝남. 지운 SHIP_CONFIRM 행을 되돌림 */
        DBMS_OUTPUT.PUT_LINE('[R1] SP 가 START 로그 없이 끝남(가드 RETURN). 지운 ' || N_DEL || '행, OWMS ' || N_DEL_OWMS || '행 ROLLBACK. [R0] GUARD_STOCK 확인');
    ELSE
        SELECT MAX(L.LOG_TYPE)    KEEP (DENSE_RANK LAST ORDER BY L.EVENT_DATE)
             , MAX(L.DESCRIPTION) KEEP (DENSE_RANK LAST ORDER BY L.EVENT_DATE)
             , MAX(L.LOG_MESSAGE) KEEP (DENSE_RANK LAST ORDER BY L.EVENT_DATE)
          INTO V_END_TYPE, V_END_DESC, V_END_MSG
          FROM SCM_SYS_LOG_BATCH L
         WHERE L.PROGRAM_NAME = 'PR_SSP_ANL_SHIP_PLAN_40'
           AND L.LOG_TYPE    IN ('END', 'ERROR')
           AND L.EVENT_DATE  >= D_CALL;

        SELECT COUNT(*)
          INTO N_ROWS
          FROM SSP_ANL_SHIP_PLAN_40
         WHERE DIVISION_ID         = '40'
           AND PLAN_START_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD')
           AND ATTRIBUTE10         = 'HQ00';

        DBMS_OUTPUT.PUT_LINE('[R1] 로그 마지막 = ' || V_END_TYPE || ' · ' || SUBSTR(V_END_DESC, 1, 300) || ' · ' || SUBSTR(V_END_MSG, 1, 300));
        DBMS_OUTPUT.PUT_LINE('[R1] 오늘 HQ00 결과 행 = ' || N_ROWS || ' · 실행 전 지운 SHIP_CONFIRM 행 = ' || N_DEL || ' · 지운 OWMS 행 = ' || N_DEL_OWMS);
    END IF;

    SELECT MAX(P.VALUE) INTO V_DS FROM V$PARAMETER P WHERE P.NAME = 'optimizer_dynamic_sampling';

    DBMS_OUTPUT.PUT_LINE('[R1] SID = ' || SYS_CONTEXT('USERENV', 'SID') || ' · 세션 dynamic_sampling(실행 뒤) = ' || V_DS);
    DBMS_OUTPUT.PUT_LINE('[R1] 시작 = ' || TO_CHAR(T_START, 'YYYY-MM-DD HH24:MI:SS') || ' · 종료 = ' || TO_CHAR(T_END, 'YYYY-MM-DD HH24:MI:SS')
                      || ' · 소요 = ' || ROUND(EXTRACT(DAY FROM (T_END - T_START)) * 86400 + EXTRACT(HOUR FROM (T_END - T_START)) * 3600
                                            + EXTRACT(MINUTE FROM (T_END - T_START)) * 60 + EXTRACT(SECOND FROM (T_END - T_START)), 1) || '초');

    DBMS_APPLICATION_INFO.SET_MODULE(NULL, NULL);
END;
/

-- ==============================================================================================================
-- [R2] 재실행분 단계별 소요(메모리 ASH, 1표본 약 1초) : [R1] 끝난 뒤 같은 날 실행. 마지막 START 로그 이후 표본만(2026-11-26 16:20 변경)
--   STEP_NAME = SP 안 /* n-n. */ 단계. CALL_OBJECT 가 FN_* 면 함수 안 SQL. HARD_PARSE_SEC = 하드 파스(동적 샘플링 포함) 표본 초
-- ==============================================================================================================
WITH STEP AS (
SELECT /*+ MATERIALIZE */ C.LINE AS FROM_LINE
     , NVL(LEAD(C.LINE) OVER (ORDER BY C.LINE) - 1, 999999) AS TO_LINE
     , RTRIM(LTRIM(C.TEXT), ' ' || CHR(9) || CHR(10) || CHR(13)) AS STEP_NAME
  FROM ALL_SOURCE C
 WHERE C.OWNER = 'SCM_MGR'
   AND C.NAME  = 'PR_SSP_ANL_SHIP_PLAN_40'
   AND C.TYPE  = 'PROCEDURE'
   AND REGEXP_LIKE(C.TEXT, '^\s*/\*\s*[0-9](-[0-9]+)*(\.|\s)')
)
, SQLSRC AS (
SELECT /*+ MATERIALIZE */ Q.SQL_ID
     , MAX(Q.PROGRAM_LINE#) AS SRC_LINE
  FROM GV$SQL Q
 WHERE Q.PROGRAM_ID = (SELECT O.OBJECT_ID FROM ALL_OBJECTS O WHERE O.OWNER = 'SCM_MGR' AND O.OBJECT_NAME = 'PR_SSP_ANL_SHIP_PLAN_40' AND O.OBJECT_TYPE = 'PROCEDURE')
 GROUP BY Q.SQL_ID
)
, A AS (
SELECT A.SQL_ID
     , A.PLSQL_OBJECT_ID
     , A.IN_HARD_PARSE
  FROM GV$ACTIVE_SESSION_HISTORY A
 WHERE A.MODULE = 'PERF_RERUN_SHIP40'
   AND A.SAMPLE_TIME >= (SELECT CAST(MAX(L.EVENT_DATE) AS TIMESTAMP) FROM SCM_SYS_LOG_BATCH L
                          WHERE L.PROGRAM_NAME = 'PR_SSP_ANL_SHIP_PLAN_40' AND L.LOG_TYPE = 'START')   /* 마지막 재실행 회차만 */
)
, B AS (
SELECT (SELECT MAX(ST.STEP_NAME) FROM STEP ST WHERE SS.SRC_LINE BETWEEN ST.FROM_LINE AND ST.TO_LINE) AS STEP_NAME
     , NVL((SELECT MAX(O.OBJECT_NAME) FROM ALL_OBJECTS O WHERE O.OBJECT_ID = A.PLSQL_OBJECT_ID), '(SP 본문 SQL)') AS CALL_OBJECT
     , A.IN_HARD_PARSE
  FROM A
  LEFT JOIN SQLSRC SS
    ON SS.SQL_ID = A.SQL_ID
)
SELECT B.STEP_NAME
     , B.CALL_OBJECT
     , COUNT(*) AS EST_SEC
     , SUM(CASE WHEN B.IN_HARD_PARSE = 'Y' THEN 1 ELSE 0 END) AS HARD_PARSE_SEC
  FROM B
 GROUP BY B.STEP_NAME
        , B.CALL_OBJECT
 ORDER BY EST_SEC DESC;

-- ==============================================================================================================
-- [R3] 재실행분 문장별 소요, 계획, 대기(메모리 ASH) : 상위 40개
-- ==============================================================================================================
WITH SQLSRC AS (
SELECT /*+ MATERIALIZE */ Q.SQL_ID
     , MAX(Q.PROGRAM_LINE#) AS SRC_LINE
     , MAX(SUBSTR(Q.SQL_TEXT, 1, 120)) AS SQL_TEXT
  FROM GV$SQL Q
 GROUP BY Q.SQL_ID
)
SELECT A.SQL_ID
     , SS.SRC_LINE
     , A.SQL_PLAN_HASH_VALUE
     , NVL(A.EVENT, 'ON CPU') AS EVENT
     , A.IN_HARD_PARSE
     , COUNT(*) AS EST_SEC
     , MIN(A.SAMPLE_TIME) AS FIRST_SAMPLE
     , MAX(A.SAMPLE_TIME) AS LAST_SAMPLE
     , SS.SQL_TEXT
  FROM GV$ACTIVE_SESSION_HISTORY A
  LEFT JOIN SQLSRC SS
    ON SS.SQL_ID = A.SQL_ID
 WHERE A.MODULE = 'PERF_RERUN_SHIP40'
   AND A.SAMPLE_TIME >= (SELECT CAST(MAX(L.EVENT_DATE) AS TIMESTAMP) FROM SCM_SYS_LOG_BATCH L
                          WHERE L.PROGRAM_NAME = 'PR_SSP_ANL_SHIP_PLAN_40' AND L.LOG_TYPE = 'START')   /* 마지막 재실행 회차만 */
 GROUP BY A.SQL_ID
        , SS.SRC_LINE
        , A.SQL_PLAN_HASH_VALUE
        , NVL(A.EVENT, 'ON CPU')
        , A.IN_HARD_PARSE
        , SS.SQL_TEXT
 ORDER BY EST_SEC DESC
 FETCH FIRST 40 ROWS ONLY;
