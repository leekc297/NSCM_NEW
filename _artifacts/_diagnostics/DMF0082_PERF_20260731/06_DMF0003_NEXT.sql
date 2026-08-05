-- =============================================================================
-- 06_DMF0003_NEXT.sql  (v2 — 순서 교정판)
--   ⚠ v1 결함: [A-2] 에서 커서를 PURGE 한 뒤 [B] 에서 그 커서의 계획을 조회하도록
--      되어 있어 **계획이 나올 수 없었습니다**(+ SPOOL 누락으로 출력 파일도 없었음).
--      → v2 는 **계획을 먼저 뜨고, 그 다음 PURGE** 합니다.
--
--   범인: SQL_ID fquabykr25nyy (INSERT INTO GT_DMF0003_MKT_FCST_DATA)
--         14.48초/회 × 2회 / BUFFER_GETS 1,345,665 (사내 21,865 = 61배) / DISK_READS 0
--
--   ⭐ 실행 순서
--      ① 이 파일(06) 실행           → 현재 계획 캡처 + 커서 제거
--      ② **화면에서 DMF0003 조회 재실행**
--      ③ 07_DMF0003_AFTER.sql 실행  → 새 계획 캡처 + 전후 비교
-- =============================================================================
SET LINESIZE 300
SET PAGESIZE 5000
SET LONG 500000
SET LONGCHUNKSIZE 500000
SET TRIMSPOOL ON
SET SERVEROUTPUT ON
SET FEEDBACK ON

SPOOL DMF0003_NEXT_BEFORE.txt

PROMPT ############################################################
PROMPT [1] 현재 커서 상태 (PURGE 전)
PROMPT ############################################################
SELECT SQL_ID, CHILD_NUMBER CH, PLAN_HASH_VALUE PHV,
       TO_CHAR(FIRST_LOAD_TIME) FIRST_LOAD,
       TO_CHAR(LAST_ACTIVE_TIME,'MM-DD HH24:MI:SS') LAST_ACT,
       EXECUTIONS EX, ROUND(ELAPSED_TIME/1e6/GREATEST(EXECUTIONS,1),2) S_PER_EX,
       BUFFER_GETS BG, DISK_READS DR, ROWS_PROCESSED RP,
       IS_BIND_SENSITIVE BS, IS_BIND_AWARE BA
  FROM V$SQL WHERE SQL_ID='fquabykr25nyy' ORDER BY CHILD_NUMBER;
-- ⭐ FIRST_LOAD_TIME 이 optimizer_dynamic_sampling 을 2 로 바꾼 시각보다 **이전**이면
--    옛 계획이 재사용되고 있는 것 → [3] PURGE 가 효과 있을 가능성이 높다.
-- (사내 PHV = 1590849756 / 직전 클라우드 PHV = 3515833160)

PROMPT ############################################################
PROMPT [2] ⭐⭐ 실행계획 캡처 — **PURGE 전에 반드시 확보** (원인 확정의 핵심)
PROMPT ############################################################
PROMPT --- [2-A] 커서 기준 (실측 A-Rows 포함)
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR('fquabykr25nyy', NULL,
       'ALLSTATS LAST +COST +BYTES +PREDICATE'));

PROMPT --- [2-B] 위가 비면(커서 소실) AWR 에서 조회
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_AWR('fquabykr25nyy'));

PROMPT --- [2-C] 위 둘 다 비면 원시 플랜 테이블에서 직접
SELECT ID, PARENT_ID, LPAD(' ',DEPTH)||OPERATION||' '||OPTIONS AS OPERATION,
       OBJECT_NAME, CARDINALITY, COST, ACCESS_PREDICATES, FILTER_PREDICATES
  FROM V$SQL_PLAN WHERE SQL_ID='fquabykr25nyy'
 ORDER BY CHILD_NUMBER, ID;

PROMPT ############################################################
PROMPT [3] 커서 제거 — [2] 캡처가 끝난 뒤에만 실행
PROMPT     (SHARED_POOL 전체 FLUSH 불필요, 해당 SQL 만 제거)
PROMPT ############################################################
DECLARE
  V VARCHAR2(100);
  N NUMBER := 0;
BEGIN
  FOR R IN (SELECT ADDRESS, HASH_VALUE FROM V$SQLAREA WHERE SQL_ID='fquabykr25nyy') LOOP
    V := R.ADDRESS||','||R.HASH_VALUE;
    BEGIN
      DBMS_SHARED_POOL.PURGE(V,'C');
      N := N + 1;
    EXCEPTION WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('PURGE 실패: '||SQLERRM);
    END;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('PURGE 완료 — 커서 '||N||'건 제거');
  IF N = 0 THEN
    DBMS_OUTPUT.PUT_LINE('※ 0건 = 이미 제거되었거나 커서가 없음 (정상일 수 있음)');
  END IF;
END;
/

PROMPT ############################################################
PROMPT [4] 참고 — 현재 옵티마이저 설정 (재파싱 시 적용될 값)
PROMPT ############################################################
SELECT NAME, VALUE FROM V$PARAMETER
 WHERE NAME IN ('optimizer_dynamic_sampling','optimizer_adaptive_plans',
                'optimizer_index_cost_adj','cursor_sharing');
-- 사내: dynamic_sampling 2 / adaptive_plans TRUE / index_cost_adj 100 / cursor_sharing EXACT

SPOOL OFF

PROMPT
PROMPT =============================================================
PROMPT 06 완료 — 출력 파일: DMF0003_NEXT_BEFORE.txt
PROMPT
PROMPT  ⭐ 다음 순서
PROMPT   ① 화면에서 **DMF0003 조회를 다시 실행**
PROMPT   ② 07_DMF0003_AFTER.sql 실행
PROMPT   ③ DMF0003_NEXT_BEFORE.txt + DMF0003_NEXT_AFTER.txt 2개 파일 회신
PROMPT =============================================================
