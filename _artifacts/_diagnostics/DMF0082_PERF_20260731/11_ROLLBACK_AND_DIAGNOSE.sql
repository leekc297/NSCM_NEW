-- =============================================================================
-- 11_ROLLBACK_AND_DIAGNOSE.sql
--   ⛔ DMF0082 조회 SQL ERROR 대응 — **원복 먼저, 진단 나중**
--
--   10_GTT_STATS_AUTO.sql 적용 직후 DMF0082 조회가 실패했으므로
--   해당 조치가 원인일 가능성이 높습니다. 우선 되돌려 화면을 복구합니다.
--
--   ⭐ 안전장치
--     · **DMF0003 분(GT_DMF0003%)은 보존** — 20초→3~4초 효과 유지
--     · 10 실행 **이전부터 통계가 있던 GTT 는 건드리지 않음**
--       (LAST_ANALYZED 가 최근 N시간 이내인 것만 되돌림)
--   계정: SCM_MGR
-- =============================================================================
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 240
SET PAGESIZE 400

SPOOL DMF0082_ROLLBACK_DIAG.txt

PROMPT ############################################################
PROMPT [0] ⭐ 먼저 실제 오류 메시지 확보 (원복 전에 남겨둘 것)
PROMPT ############################################################
PROMPT --- [0-A] 최근 시스템 로그의 실제 ORA 오류
SELECT * FROM (
  SELECT * FROM SCM_COM_SYS_LOG ORDER BY 1 DESC
) WHERE ROWNUM <= 10;
-- ⚠ 컬럼 구성이 환경마다 다를 수 있습니다. 오류가 나면 아래로 대체:
--   SELECT COLUMN_NAME FROM USER_TAB_COLUMNS WHERE TABLE_NAME='SCM_COM_SYS_LOG' ORDER BY COLUMN_ID;

PROMPT --- [0-B] DMF0082 관련 커서에 기록된 오류
SELECT SQL_ID, PLAN_HASH_VALUE PHV, EXECUTIONS EX, ROWS_PROCESSED RP,
       TO_CHAR(LAST_ACTIVE_TIME,'MM-DD HH24:MI:SS') LAST_ACT,
       SUBSTR(REGEXP_REPLACE(SQL_TEXT,'\s+',' '),1,70) T
  FROM V$SQL
 WHERE LAST_ACTIVE_TIME > SYSDATE - 1/24
   AND (UPPER(SQL_TEXT) LIKE '%GT_DMF0082%' OR UPPER(SQL_TEXT) LIKE '%GTT_MF_SP%'
     OR UPPER(SQL_TEXT) LIKE '%GT_PRDM1%' OR UPPER(SQL_TEXT) LIKE '%GT_FTPR%')
 ORDER BY LAST_ACTIVE_TIME DESC FETCH FIRST 15 ROWS ONLY;

PROMPT --- [0-C] 이번에 통계를 넣은 GTT 목록 (원복 대상 확인용)
SELECT TABLE_NAME, NUM_ROWS, BLOCKS, AVG_ROW_LEN,
       TO_CHAR(LAST_ANALYZED,'MM-DD HH24:MI:SS') ANZ,
       (SELECT COUNT(*) FROM USER_TAB_COL_STATISTICS c
         WHERE c.TABLE_NAME=u.TABLE_NAME AND c.COLUMN_NAME='DIVISION_ID'
           AND c.NUM_DISTINCT=1) DIV_NDV1
  FROM USER_TABLES u
 WHERE TEMPORARY='Y' AND NUM_ROWS IS NOT NULL
 ORDER BY LAST_ANALYZED DESC;

PROMPT ############################################################
PROMPT [1-A] ⭐⭐ 즉시 복구 — 전 GTT 통계 잠금 해제 (이것이 사고의 직접 원인)
PROMPT ############################################################
-- 【확정된 원인】
--   PKG_DMF0082 는 본문에서 **스스로 DBMS_STATS.GATHER_TABLE_STATS 를 40회 호출**한다
--   (대상 GTT 37본 — 사내 소스 실측). PKG_DMF0020 11회 / PKG_DMF0003 5회 / PKG_DMF0021 2회.
--   그런데 10_GTT_STATS_AUTO.sql 이 그 GTT 들에 LOCK_TABLE_STATS 를 걸었으므로
--   SP 의 GATHER 호출이 **ORA-20005 (object statistics are locked)** 로 실패한다.
--   → 이 UNLOCK 만으로 DMF0082 조회가 복구될 것으로 예상됩니다.
--
--   ⛔ 제 설계 결함입니다: SP 가 스스로 통계를 수집하는지 확인하지 않고 LOCK 을 걸었습니다.
DECLARE
  V_N NUMBER := 0;
BEGIN
  FOR R IN (SELECT TABLE_NAME FROM USER_TABLES WHERE TEMPORARY='Y') LOOP
    BEGIN
      DBMS_STATS.UNLOCK_TABLE_STATS('SCM_MGR', R.TABLE_NAME);
      V_N := V_N + 1;
    EXCEPTION WHEN OTHERS THEN NULL; END;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('UNLOCK 시도 완료 — GTT '||V_N||' 본');
END;
/

PROMPT --- 잠금 잔존 확인 (기대: 0행)
SELECT TABLE_NAME, STATTYPE_LOCKED FROM USER_TAB_STATISTICS
 WHERE STATTYPE_LOCKED IS NOT NULL
   AND TABLE_NAME IN (SELECT TABLE_NAME FROM USER_TABLES WHERE TEMPORARY='Y');

PROMPT ############################################################
PROMPT ⭐ 여기서 **DMF0082 조회를 한 번 해보십시오.**
PROMPT    정상 복구되면 [1-B] 는 건너뛰어도 됩니다(통계값 자체는 무해).
PROMPT    여전히 오류면 [1-B] 로 통계까지 제거하십시오.
PROMPT ############################################################

PROMPT ############################################################
PROMPT [1-B] 통계값까지 원복 — 최근 3시간 내 설정분만 제거 (DMF0003 보존)
PROMPT ############################################################
DECLARE
  V_N NUMBER := 0;
  V_KEEP NUMBER := 0;
BEGIN
  FOR R IN (SELECT TABLE_NAME, LAST_ANALYZED FROM USER_TABLES
             WHERE TEMPORARY='Y' AND NUM_ROWS IS NOT NULL
             ORDER BY TABLE_NAME) LOOP

    -- ① DMF0003 분은 보존 (효과 확인된 조치)
    IF R.TABLE_NAME LIKE 'GT\_DMF0003%' ESCAPE '\' THEN
      V_KEEP := V_KEEP + 1;
      CONTINUE;
    END IF;

    -- ② 10 실행 이전부터 있던 통계는 보존 (내가 만든 것이 아님)
    IF R.LAST_ANALYZED IS NULL OR R.LAST_ANALYZED < SYSDATE - 3/24 THEN
      V_KEEP := V_KEEP + 1;
      CONTINUE;
    END IF;

    BEGIN
      BEGIN DBMS_STATS.UNLOCK_TABLE_STATS('SCM_MGR', R.TABLE_NAME);
      EXCEPTION WHEN OTHERS THEN NULL; END;

      DBMS_STATS.DELETE_TABLE_STATS('SCM_MGR', R.TABLE_NAME, NO_INVALIDATE => FALSE);
      DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', R.TABLE_NAME, 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');

      V_N := V_N + 1;
      DBMS_OUTPUT.PUT_LINE('원복 '||R.TABLE_NAME);
    EXCEPTION WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('실패 '||R.TABLE_NAME||' : '||SQLERRM);
    END;
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('==================================================');
  DBMS_OUTPUT.PUT_LINE('원복 '||V_N||' 본 / 보존 '||V_KEEP||' 본(DMF0003 + 기존 통계)');
END;
/

PROMPT ############################################################
PROMPT [2] 원복 확인
PROMPT ############################################################
SELECT TABLE_NAME, NUM_ROWS,
       DBMS_STATS.GET_PREFS('GLOBAL_TEMP_TABLE_STATS','SCM_MGR',TABLE_NAME) PREF,
       TO_CHAR(LAST_ANALYZED,'MM-DD HH24:MI') ANZ
  FROM USER_TABLES WHERE TEMPORARY='Y' AND NUM_ROWS IS NOT NULL
 ORDER BY TABLE_NAME;
-- 기대: GT_DMF0003_* 만 남아 있어야 함 (+ 원래부터 통계가 있던 것)

SPOOL OFF

PROMPT
PROMPT =============================================================
PROMPT [3] 확인 부탁드립니다
PROMPT   ① **DMF0082 조회가 정상 복구되었는지**
PROMPT   ② DMF0003 이 여전히 3~4초인지 (보존했으므로 유지되어야 함)
PROMPT   ③ ⭐ **실제 오류 메시지 전문** — 화면 토스트 문구 또는 BE 콘솔의 `Caused by`
PROMPT      (BE 래퍼가 -9994 로 감싸면 진짜 원인이 안 보입니다 — 콘솔 원문이 필요합니다)
PROMPT   ④ [0-A] 시스템 로그 출력
PROMPT =============================================================
