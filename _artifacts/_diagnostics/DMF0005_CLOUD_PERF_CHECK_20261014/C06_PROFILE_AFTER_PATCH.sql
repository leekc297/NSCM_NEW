-- =============================================================================
-- C06_PROFILE_AFTER_PATCH.sql — DMF0005 조회 속도 점검 ⑥ NOPUSH 패치 적용 뒤 병목 실측 (READ-ONLY, 전체 F5 · 값 입력 없음)
--   계정: SCM_MGR · QA 에서 10_APPLY_NOPUSH_PATCH 적용 + 화면에서 DMF0005 를 몇 번 조회한 뒤 실행
--   [P0] 패치 적용 여부 (마커 1 이어야 한다 — 0 이면 이 파일 결과는 무의미)
--   [P1] ⭐ 조회 프로시저 직접 실행 — 82 · 81 · 40 각 3회
--        1 · 2회차 = 보통 실행 시간(2회차가 판단 기준) · 3회차 = 계획 줄별 실측(statistics_level = ALL) → 계획 표 출력
--        표의 A-Time(줄별 누적 시간) · Starts(반복 횟수) · A-Rows(실제 행) 로 병목 줄을 고른다
--   [P2] ⭐ 화면 호출 이력 — 최근 3시간 (DB 구간 · BE 후처리 · 전체). 2초 넘는 호출만 튜닝 대상
--   [P3] BE SQL 로그 크기 — 조회 결과까지 로그에 쓰고 있는지 (PARAMS 가 수 MB 면 BE 로그 결함)
--   변경 없음: 조회 프로시저 호출(조회조건 임시 테이블만 비움, ROLLBACK)과 SELECT 만 수행
--   ⚠ 출력이 길다(계획 표 3개). 생성된 C06_PROFILE_AFTER_PATCH_OUT.txt 파일을 C:\TRANFILE\RECEIVE\ 로 전달
-- =============================================================================
SET SERVEROUTPUT ON SIZE UNLIMITED FORMAT WRAPPED
SET LINESIZE 400
SET PAGESIZE 500
SET TRIMSPOOL ON
SET VERIFY OFF
SET FEEDBACK OFF
COLUMN JUDGE FORMAT A40
COLUMN SHT_NM FORMAT A12
COLUMN USR FORMAT A14
COLUMN DIV FORMAT A6
COLUMN FILTERS FORMAT A50
SPOOL C06_PROFILE_AFTER_PATCH_OUT.txt

PROMPT ################ [P0] 접속 DB · 패치 적용 여부 ################
SELECT SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, SYS_CONTEXT('USERENV','INSTANCE_NAME') INST, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') NOW,
       (SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0005' AND OBJECT_TYPE = 'PACKAGE BODY') BODY_DDL,
       (SELECT COUNT(*) FROM USER_SOURCE WHERE NAME = 'PKG_DMF0005' AND TYPE = 'PACKAGE BODY' AND TEXT LIKE '%E20261014-DMF0005NOPUSH%') NOPUSH_MARKER
  FROM DUAL;

PROMPT ################ [P1] ⭐ 조회 프로시저 직접 실행 + 계획 줄별 실측 (사내 QA 조건 모사 2회차: 82 1.5s · 81 1.7s · 40 1.0s) ################
DECLARE
    rc1 SYS_REFCURSOR; rcr SYS_REFCURSOR;
    t0 NUMBER; t1 NUMBER; n NUMBER; c INTEGER;
    v_sql VARCHAR2(13); v_ch NUMBER;
    TYPE t_v IS TABLE OF VARCHAR2(10);
    v t_v := t_v('82', '81', '40');
    PROCEDURE p(s VARCHAR2) IS BEGIN DBMS_OUTPUT.PUT_LINE(s); END;
BEGIN
    FOR i IN 1 .. v.COUNT LOOP
        FOR run IN 1 .. 3 LOOP
            IF run = 3 THEN EXECUTE IMMEDIATE 'ALTER SESSION SET statistics_level = ALL'; END IF;
            t0 := DBMS_UTILITY.GET_TIME;
            PKG_DMF0005.P_DMF0005_GET_SALES_SITE_MODEL_PRODUCTION(
                P_DIVISION_ID => v(i), P_DEPT_ID => 'ALL', P_END_CUSTOMER => 'ALL', P_SCM_SITE_ID => 'ALL',
                P_PROJECT_CODE => NULL, P_ITEM_ID => NULL, P_VALID_YN => 'ALL', P_OWNER => NULL, P_USER_ID => 'minyonglee1',
                O_RC1 => rc1, O_RESULT_CURSOR => rcr);
            t1 := DBMS_UTILITY.GET_TIME;
            c := DBMS_SQL.TO_CURSOR_NUMBER(rc1); n := 0;
            WHILE DBMS_SQL.FETCH_ROWS(c) > 0 LOOP n := n + 1; END LOOP;
            DBMS_SQL.CLOSE_CURSOR(c);
            CLOSE rcr;
            ROLLBACK;
            IF run = 3 THEN EXECUTE IMMEDIATE 'ALTER SESSION SET statistics_level = TYPICAL'; END IF;
            p('### div ' || v(i) || ' run' || run || CASE run WHEN 2 THEN ' (판단 기준)' WHEN 3 THEN ' (줄별 실측 켬 — 시간은 참고)' ELSE '' END
              || ' | 프로시저 ' || TO_CHAR((t1 - t0) / 100, 'FM99990.00') || 's + fetch ' || TO_CHAR((DBMS_UTILITY.GET_TIME - t1) / 100, 'FM99990.00')
              || 's = ' || TO_CHAR((DBMS_UTILITY.GET_TIME - t0) / 100, 'FM99990.00') || 's | ' || n || '행');
        END LOOP;
        SELECT SQL_ID, CHILD_NUMBER INTO v_sql, v_ch FROM (
            SELECT SQL_ID, CHILD_NUMBER FROM V$SQL
             WHERE SQL_TEXT LIKE 'WITH ITEM_AGG AS%' AND DBMS_LOB.INSTR(SQL_FULLTEXT, 'NO_PUSH_PRED') > 0
             ORDER BY LAST_ACTIVE_TIME DESC) WHERE ROWNUM = 1;
        p('    계획 줄별 실측 — ' || v_sql || ' child ' || v_ch);
        FOR r IN (SELECT PLAN_TABLE_OUTPUT L FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(v_sql, v_ch, 'ALLSTATS LAST -PREDICATE -NOTE'))) LOOP
            IF r.L LIKE '|%' OR r.L LIKE 'Plan hash%' OR r.L LIKE '-----%' THEN p('    ' || r.L); END IF;
        END LOOP;
    END LOOP;
EXCEPTION WHEN OTHERS THEN
    BEGIN EXECUTE IMMEDIATE 'ALTER SESSION SET statistics_level = TYPICAL'; EXCEPTION WHEN OTHERS THEN NULL; END;
    ROLLBACK;
    p('!!! 오류: ' || SQLERRM);
END;
/

PROMPT ################ [P2] ⭐ 화면 호출 이력 — 최근 3시간 DMF0005 (DB_S = 프로시저+fetch · BE_POST_S = DB 뒤 BE 처리 · TOTAL_S = 화면 왕복) ################
SELECT TO_CHAR(L.TRNM_ST_DTM,'MM-DD HH24:MI:SS') ST, L.SHT_NM, L.MNU_BTN_CD ACT, L.CREATED_BY USR,
       REGEXP_SUBSTR(L.SYS_LOG_MSG_CTN,'"divisionId":"([^"]*)"',1,1,NULL,1) DIV,
       RTRIM(CASE WHEN REGEXP_SUBSTR(L.SYS_LOG_MSG_CTN,'"deptId":"([^"]*)"',1,1,NULL,1) <> 'ALL' THEN 'dept ' END
          || CASE WHEN REGEXP_SUBSTR(L.SYS_LOG_MSG_CTN,'"endCustomer":"([^"]*)"',1,1,NULL,1) <> 'ALL' THEN 'cust ' END
          || CASE WHEN REGEXP_SUBSTR(L.SYS_LOG_MSG_CTN,'"salesSite":"([^"]*)"',1,1,NULL,1) <> 'ALL' THEN 'site ' END
          || CASE WHEN REGEXP_SUBSTR(L.SYS_LOG_MSG_CTN,'"projectCode":"([^"]*)"',1,1,NULL,1) IS NOT NULL THEN 'pjt ' END
          || CASE WHEN REGEXP_SUBSTR(L.SYS_LOG_MSG_CTN,'"itemId":"([^"]*)"',1,1,NULL,1) IS NOT NULL THEN 'item ' END
          || CASE WHEN REGEXP_SUBSTR(L.SYS_LOG_MSG_CTN,'"owner":"([^"]*)"',1,1,NULL,1) IS NOT NULL THEN 'owner ' END
          || CASE WHEN REGEXP_SUBSTR(L.SYS_LOG_MSG_CTN,'"activeFlag":"([^"]*)"',1,1,NULL,1) <> 'ALL' THEN 'active' END) FILTERS,
       ROUND((CAST(L.DB_TRNM_END_DTM AS DATE) - CAST(L.DB_TRNM_ST_DTM AS DATE))*86400, 1) DB_S,
       ROUND((CAST(L.TRNM_END_DTM AS DATE) - CAST(L.DB_TRNM_END_DTM AS DATE))*86400, 1) BE_POST_S,
       ROUND((CAST(L.LOG_END_DTM AS DATE) - CAST(L.LOG_ST_DTM AS DATE))*86400, 1) TOTAL_S,
       CASE WHEN L.DB_TRNM_END_DTM IS NULL THEN '❌ NO_END' WHEN L.EXCT_MSG_CTN IS NOT NULL THEN '❌ ERR'
            WHEN (CAST(L.DB_TRNM_END_DTM AS DATE) - CAST(L.DB_TRNM_ST_DTM AS DATE))*86400 >= 2 THEN '⭐ DB 구간 >=2s'
            WHEN (CAST(L.TRNM_END_DTM AS DATE) - CAST(L.DB_TRNM_END_DTM AS DATE))*86400 >= 2 THEN '⭐ BE 후처리 >=2s'
            ELSE '-' END JUDGE
  FROM SCM_COM_SYS_LOG L
 WHERE L.MNU_ID = 'DMF0005' AND L.CREATION_DATE >= SYSDATE - 3/24
 ORDER BY L.TRNM_ST_DTM DESC FETCH FIRST 80 ROWS ONLY;

PROMPT ################ [P3] BE SQL 로그 크기 — 최근 3시간 DMF0005 조회 (PARAMS 가 수 MB 면 결과까지 로그에 쓰는 결함 · 정상 = 수천 바이트 이하) ################
SELECT TO_CHAR(CREATE_DATE,'MM-DD HH24:MI:SS') T, ELAPSED_MS, RESULT_COUNT, DBMS_LOB.GETLENGTH(PARAMS) PARAMS_LEN
  FROM SCM_COM_SQL_LOG
 WHERE CREATE_DATE >= SYSDATE - 3/24 AND DBMS_LOB.INSTR(SQL_TEXT, 'P_DMF0005_GET_SALES_SITE_MODEL') > 0
 ORDER BY CREATE_DATE DESC FETCH FIRST 20 ROWS ONLY;

SPOOL OFF
SET FEEDBACK ON
PROMPT =============================================================================
PROMPT  C06 완료 → C06_PROFILE_AFTER_PATCH_OUT.txt 파일을 C:\TRANFILE\RECEIVE\ 로 전달
PROMPT =============================================================================
