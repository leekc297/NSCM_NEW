-- =============================================================================
-- 08_DMF0003_GTT_STATS_FIX.sql — GTT 카디널리티 고정 (SCM_MGR 권한만으로 실행)
--
--  ⚠ 왜 이 방법인가
--    07 결과: FIRST_LOAD 가 2026-07-31/00:29:05 그대로 · PHV 3515833160 그대로
--            → **06 의 DBMS_SHARED_POOL.PURGE 가 실패했다.**
--            원인 = SCM_MGR 에 DBMS_SHARED_POOL EXECUTE 권한 없음(사내 실측 0건).
--            (스크립트가 예외를 잡아 조용히 넘어갔음 — 제 설계 미비)
--
--    → SCM_MGR 이 **자기 소유 GTT 에 통계를 SET** 하면
--       ① 카디널리티가 결정적으로 고정되고(근본 원인 해소)
--       ② NO_INVALIDATE=>FALSE 로 **의존 커서가 무효화**되어 재파싱된다(PURGE 대체)
--       두 문제를 한 번에 해결한다. DBA 권한 불요.
--
--  변경 대상: 옵티마이저 통계만. 데이터·구조·소스 변경 없음. 완전 원복 가능(§4).
-- =============================================================================
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 200
SET PAGESIZE 100
SET TIMING ON

SPOOL DMF0003_GTT_STATS_FIX.txt

PROMPT ############################################################
PROMPT [0] 사전 확인 — 현재 상태
PROMPT ############################################################
SELECT SQL_ID, PLAN_HASH_VALUE PHV, TO_CHAR(FIRST_LOAD_TIME) FIRST_LOAD,
       EXECUTIONS EX, ROUND(ELAPSED_TIME/1e6/GREATEST(EXECUTIONS,1),2) S_PER_EX, BUFFER_GETS BG
  FROM V$SQL WHERE SQL_ID IN ('fquabykr25nyy','8kfydzds35fy2') ORDER BY SQL_ID;

SELECT TABLE_NAME,
       DBMS_STATS.GET_PREFS('GLOBAL_TEMP_TABLE_STATS','SCM_MGR',TABLE_NAME) PREF,
       NUM_ROWS, BLOCKS
  FROM USER_TABLES
 WHERE TABLE_NAME IN ('GT_DMF0003_SITE_ITEM','GT_DMF0003_SITE_ITEM_ALL',
                      'GT_DMF0003_LAST_DATA_SETUP','GT_DMF0003_SELECT_MEASURE',
                      'GT_DMF0003_EDI_SENDER')
 ORDER BY TABLE_NAME;
-- 기대(적용 전): PREF=SESSION / NUM_ROWS 전부 NULL(통계 없음)

PROMPT ############################################################
PROMPT [1] GTT 통계를 SHARED 로 전환 + 실측 기반 카디널리티 고정
PROMPT ############################################################
-- 설정값 근거 (양쪽 V$SQL 의 ROWS_PROCESSED / 실행횟수 실측)
--   GT_DMF0003_SITE_ITEM      : 사내 21,620/회 · 클라우드 14,888/회   → 20,000
--   GT_DMF0003_SITE_ITEM_ALL  : 사내 14,806~32,978/회 · 클라우드 14,888/회 → 20,000
--   GT_DMF0003_LAST_DATA_SETUP: 사내 374/회 · 클라우드 1,348/회        → 1,000
--   GT_DMF0003_SELECT_MEASURE : 사내 계획 E-Rows 7 (클라우드는 8,168 로 과대추정) → 10
--   GT_DMF0003_EDI_SENDER     : 사내 계획 E-Rows 2                     → 5
-- ⭐ 정확한 값일 필요는 없다. **자릿수만 맞으면** 옵티마이저가 CARTESIAN 대신
--    HASH JOIN 을 고른다(사내가 30,651 로 추정해 HASH JOIN 을 고른 것과 동일 효과).

DECLARE
  TYPE T_REC IS RECORD (TAB VARCHAR2(64), NROWS NUMBER, RLEN NUMBER);
  TYPE T_LIST IS TABLE OF T_REC;
  V_L T_LIST := T_LIST(
    T_REC('GT_DMF0003_SITE_ITEM',        20000, 1200),
    T_REC('GT_DMF0003_SITE_ITEM_ALL',    20000, 1200),
    T_REC('GT_DMF0003_LAST_DATA_SETUP',   1000,  520),
    T_REC('GT_DMF0003_SELECT_MEASURE',      10,  600),
    T_REC('GT_DMF0003_EDI_SENDER',           5,  600)
  );
  V_BLK NUMBER;
BEGIN
  FOR I IN 1 .. V_L.COUNT LOOP
    BEGIN
      -- ① 세션 전용이 아니라 전 세션 공용 통계로 전환
      DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', V_L(I).TAB, 'GLOBAL_TEMP_TABLE_STATS', 'SHARED');

      -- ② 블록수는 행수×행길이 기준으로 산출 (8K 블록, 85% 사용 가정)
      V_BLK := GREATEST(CEIL(V_L(I).NROWS * V_L(I).RLEN / (8192 * 0.85)), 1);

      -- ③ 통계 고정 + 의존 커서 무효화(= PURGE 대체)
      DBMS_STATS.SET_TABLE_STATS(
        OWNNAME       => 'SCM_MGR',
        TABNAME       => V_L(I).TAB,
        NUMROWS       => V_L(I).NROWS,
        NUMBLKS       => V_BLK,
        AVGRLEN       => V_L(I).RLEN,
        NO_INVALIDATE => FALSE);

      -- ④ 자동 통계수집이 덮어쓰지 않도록 잠금
      BEGIN DBMS_STATS.LOCK_TABLE_STATS('SCM_MGR', V_L(I).TAB);
      EXCEPTION WHEN OTHERS THEN NULL; END;

      DBMS_OUTPUT.PUT_LINE('OK   '||RPAD(V_L(I).TAB,30)||' rows='||V_L(I).NROWS||' blks='||V_BLK);
    EXCEPTION WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('FAIL '||V_L(I).TAB||' : '||SQLERRM);
    END;
  END LOOP;
END;
/

PROMPT ############################################################
PROMPT [2] 적용 확인
PROMPT ############################################################
SELECT TABLE_NAME,
       DBMS_STATS.GET_PREFS('GLOBAL_TEMP_TABLE_STATS','SCM_MGR',TABLE_NAME) PREF,
       NUM_ROWS, BLOCKS, AVG_ROW_LEN,
       TO_CHAR(LAST_ANALYZED,'YYYY-MM-DD HH24:MI:SS') ANZ
  FROM USER_TABLES
 WHERE TABLE_NAME IN ('GT_DMF0003_SITE_ITEM','GT_DMF0003_SITE_ITEM_ALL',
                      'GT_DMF0003_LAST_DATA_SETUP','GT_DMF0003_SELECT_MEASURE',
                      'GT_DMF0003_EDI_SENDER')
 ORDER BY TABLE_NAME;
-- 기대: PREF=SHARED / NUM_ROWS 가 위 설정값 / LAST_ANALYZED 가 방금 시각

PROMPT --- 커서가 무효화되었는지 (기대: fquabykr25nyy 가 사라졌거나 INVALIDATIONS 증가)
SELECT SQL_ID, PLAN_HASH_VALUE PHV, TO_CHAR(FIRST_LOAD_TIME) FIRST_LOAD, INVALIDATIONS INV
  FROM V$SQL WHERE SQL_ID IN ('fquabykr25nyy','8kfydzds35fy2') ORDER BY SQL_ID;

SPOOL OFF

PROMPT
PROMPT =============================================================
PROMPT [3] 다음 순서
PROMPT   ① 화면에서 **DMF0003 조회를 다시 실행** (이전과 같은 조회조건으로)
PROMPT   ② 07_DMF0003_AFTER.sql 재실행
PROMPT   ⭐ 판정: PHV 가 3515833160 에서 **바뀌고**
PROMPT           계획에서 GT_DMF0003_SITE_ITEM 의 E-Rows 가 20000 으로,
PROMPT           MERGE JOIN CARTESIAN 이 HASH JOIN 으로 바뀌면 성공
PROMPT =============================================================

-- =============================================================================
-- [4] 원복 (효과가 없거나 부작용이 있을 때)
-- =============================================================================
-- DECLARE
--   TYPE T IS TABLE OF VARCHAR2(64);
--   L T := T('GT_DMF0003_SITE_ITEM','GT_DMF0003_SITE_ITEM_ALL',
--            'GT_DMF0003_LAST_DATA_SETUP','GT_DMF0003_SELECT_MEASURE',
--            'GT_DMF0003_EDI_SENDER');
-- BEGIN
--   FOR I IN 1..L.COUNT LOOP
--     BEGIN DBMS_STATS.UNLOCK_TABLE_STATS('SCM_MGR', L(I)); EXCEPTION WHEN OTHERS THEN NULL; END;
--     DBMS_STATS.DELETE_TABLE_STATS('SCM_MGR', L(I), NO_INVALIDATE => FALSE);
--     DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', L(I), 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');
--     DBMS_OUTPUT.PUT_LINE('원복 '||L(I));
--   END LOOP;
-- END;
-- /
