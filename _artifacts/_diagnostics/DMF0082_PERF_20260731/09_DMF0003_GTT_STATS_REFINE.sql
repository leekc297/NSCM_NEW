-- =============================================================================
-- 09_DMF0003_GTT_STATS_REFINE.sql — 08 보정 (컬럼 통계 추가 + 대상 GTT 확대)
--
--  08 결과 평가 (fquabykr25nyy)
--    PHV 3515833160 → 2281909711 (계획 변경 ✅)
--    BUFFER_GETS 1,345,472 → 101,320  (**13배 감소** ✅)
--    Cost 313 → 2,554  (사내 3,503 에 근접 ✅ — 오추정 해소)
--    소요 14.33초 → 10.16초 (개선폭이 BG 대비 작음 △)
--    ⚠ 부작용: `3xmpd6ma2bz01`(GT_DMF0003_MKT_FCST_RESULT INSERT) 1회가 크게 느려짐
--
--  ⭐ 08 의 한계 = **테이블 통계만 설정하고 컬럼 통계(NDV)를 안 넣었다**
--     계획의 GT_DMF0003_SITE_ITEM E-Rows 가 20,000 이 아니라 **2** 로 나온 이유:
--       NUM_ROWS 20,000 에 `DIVISION_ID=:B1` + `ITEM_VALID_YN='Y'` 두 등치조건이 걸리는데
--       컬럼 통계가 없으면 Oracle 이 **조건당 기본 선택도 1%** 를 적용
--       → 20,000 × 0.01 × 0.01 = **2**
--     이 GTT 는 **단일 division 분만 적재**되므로 DIVISION_ID 의 실제 NDV 는 **1** 이다.
--       → NDV 를 명시하면 20,000 × 1 × (1/2) = 10,000 으로 현실화된다.
--
--  또한 08 이 놓친 대용량 GTT (실측 10만 행대) 를 추가한다 —
--  이들의 추정이 1 로 남아 있으면 병목이 그쪽으로 옮겨간다(3xmpd6ma2bz01 회귀의 원인 추정).
--
--  변경 대상: 옵티마이저 통계만. 데이터·구조·소스 변경 없음. 완전 원복 가능(§4).
-- =============================================================================
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 200
SET PAGESIZE 200
SET TIMING ON

SPOOL DMF0003_GTT_STATS_REFINE.txt

PROMPT ############################################################
PROMPT [1] 대상 GTT 전체에 테이블 통계 설정 (클라우드 실측 행수 기준)
PROMPT ############################################################
-- 근거: 클라우드 V$SQL 의 ROWS_PROCESSED / EXECUTIONS 실측 (07 [3] 출력)
--   GT_DMF0003_ITEM_SINGLE_ORI  825,671/7 = 117,953   ← 08 에서 누락됐던 대용량
--   GT_DMF0003_ITEM_SINGLE_A    717,731/7 = 102,533   ← 〃
--   GT_DMF0003_ITEM_SINGLE_V    717,731/7 = 102,533   ← 〃
--   GT_DMF0003_ITEM_SINGLE_B    601,020/7 =  85,860   ← 〃
--   GT_DMF0003_SITE_ITEM(_ALL)  14,888/회
--   GT_DMF0003_LAST_DATA_SETUP   1,348/회
--   GT_DMF0003_MKT_FCST_RESULT   7,462/7 = 1,066
--   GT_DMF0003_MKT_FCST_DATA     158~200

DECLARE
  TYPE T_REC IS RECORD (TAB VARCHAR2(64), NROWS NUMBER, RLEN NUMBER);
  TYPE T_LIST IS TABLE OF T_REC;
  V_L T_LIST := T_LIST(
    T_REC('GT_DMF0003_SITE_ITEM',        15000, 1200),
    T_REC('GT_DMF0003_SITE_ITEM_ALL',    15000, 1200),
    T_REC('GT_DMF0003_ITEM_SINGLE_ORI', 118000,  200),
    T_REC('GT_DMF0003_ITEM_SINGLE_A',   103000,  200),
    T_REC('GT_DMF0003_ITEM_SINGLE_V',   103000,  200),
    T_REC('GT_DMF0003_ITEM_SINGLE_B',    86000,  200),
    T_REC('GT_DMF0003_LAST_DATA_SETUP',   1300,  520),
    T_REC('GT_DMF0003_MKT_FCST_RESULT',   1100,  600),
    T_REC('GT_DMF0003_MKT_FCST_DATA',      200,  900),
    T_REC('GT_DMF0003_SELECT_MEASURE',      10,  600),
    T_REC('GT_DMF0003_EDI_SENDER',           5,  600)
  );
  V_BLK NUMBER;
BEGIN
  FOR I IN 1 .. V_L.COUNT LOOP
    BEGIN
      DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', V_L(I).TAB, 'GLOBAL_TEMP_TABLE_STATS', 'SHARED');
      BEGIN DBMS_STATS.UNLOCK_TABLE_STATS('SCM_MGR', V_L(I).TAB);
      EXCEPTION WHEN OTHERS THEN NULL; END;

      V_BLK := GREATEST(CEIL(V_L(I).NROWS * V_L(I).RLEN / (8192 * 0.85)), 1);
      DBMS_STATS.SET_TABLE_STATS(
        OWNNAME => 'SCM_MGR', TABNAME => V_L(I).TAB,
        NUMROWS => V_L(I).NROWS, NUMBLKS => V_BLK, AVGRLEN => V_L(I).RLEN,
        NO_INVALIDATE => FALSE);

      DBMS_OUTPUT.PUT_LINE('TAB  '||RPAD(V_L(I).TAB,30)||' rows='||V_L(I).NROWS||' blks='||V_BLK);
    EXCEPTION WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('FAIL '||V_L(I).TAB||' : '||SQLERRM);
    END;
  END LOOP;
END;
/

PROMPT ############################################################
PROMPT [2] ⭐ 컬럼 통계(NDV) 설정 — 08 이 놓친 핵심
PROMPT ############################################################
-- DIVISION_ID: 이 GTT 들은 **조회한 단일 division 분만** 적재된다 → 실제 NDV = 1
--              (NDV 를 안 주면 기본 선택도 1% 가 적용되어 100배 과소추정된다)
-- ITEM_VALID_YN: 'Y'/'N' 2값 → NDV = 2
DECLARE
  TYPE T IS TABLE OF VARCHAR2(64);
  -- DIVISION_ID 를 가진 GTT (실측 확인)
  L_DIV T := T('GT_DMF0003_SITE_ITEM','GT_DMF0003_SITE_ITEM_ALL',
               'GT_DMF0003_ITEM_SINGLE_ORI','GT_DMF0003_ITEM_SINGLE_A',
               'GT_DMF0003_ITEM_SINGLE_V','GT_DMF0003_ITEM_SINGLE_B',
               'GT_DMF0003_LAST_DATA_SETUP','GT_DMF0003_MKT_FCST_RESULT',
               'GT_DMF0003_MKT_FCST_DATA');
  -- ITEM_VALID_YN 을 가진 GTT (실측 확인)
  L_VAL T := T('GT_DMF0003_SITE_ITEM','GT_DMF0003_SITE_ITEM_ALL');
  V_SREC DBMS_STATS.STATREC;
  V_DUMMY NUMBER;
BEGIN
  FOR I IN 1 .. L_DIV.COUNT LOOP
    BEGIN
      DBMS_STATS.SET_COLUMN_STATS(
        OWNNAME => 'SCM_MGR', TABNAME => L_DIV(I), COLNAME => 'DIVISION_ID',
        DISTCNT => 1,        -- 단일 division 적재 → NDV 1
        NULLCNT => 0,
        AVGCLEN => 3,
        NO_INVALIDATE => FALSE);
      DBMS_OUTPUT.PUT_LINE('COL  '||RPAD(L_DIV(I),30)||' DIVISION_ID NDV=1');
    EXCEPTION WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('FAIL '||L_DIV(I)||'.DIVISION_ID : '||SQLERRM);
    END;
  END LOOP;

  FOR I IN 1 .. L_VAL.COUNT LOOP
    BEGIN
      DBMS_STATS.SET_COLUMN_STATS(
        OWNNAME => 'SCM_MGR', TABNAME => L_VAL(I), COLNAME => 'ITEM_VALID_YN',
        DISTCNT => 2, NULLCNT => 0, AVGCLEN => 2, NO_INVALIDATE => FALSE);
      DBMS_OUTPUT.PUT_LINE('COL  '||RPAD(L_VAL(I),30)||' ITEM_VALID_YN NDV=2');
    EXCEPTION WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('FAIL '||L_VAL(I)||'.ITEM_VALID_YN : '||SQLERRM);
    END;
  END LOOP;
END;
/

PROMPT ############################################################
PROMPT [3] 통계 잠금 (자동 수집이 덮어쓰지 않도록)
PROMPT ############################################################
DECLARE
  TYPE T IS TABLE OF VARCHAR2(64);
  L T := T('GT_DMF0003_SITE_ITEM','GT_DMF0003_SITE_ITEM_ALL',
           'GT_DMF0003_ITEM_SINGLE_ORI','GT_DMF0003_ITEM_SINGLE_A',
           'GT_DMF0003_ITEM_SINGLE_V','GT_DMF0003_ITEM_SINGLE_B',
           'GT_DMF0003_LAST_DATA_SETUP','GT_DMF0003_MKT_FCST_RESULT',
           'GT_DMF0003_MKT_FCST_DATA','GT_DMF0003_SELECT_MEASURE','GT_DMF0003_EDI_SENDER');
BEGIN
  FOR I IN 1..L.COUNT LOOP
    BEGIN DBMS_STATS.LOCK_TABLE_STATS('SCM_MGR', L(I)); EXCEPTION WHEN OTHERS THEN NULL; END;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('통계 잠금 완료 '||L.COUNT||'본');
END;
/

PROMPT ############################################################
PROMPT [4] 적용 확인
PROMPT ############################################################
SELECT TABLE_NAME, NUM_ROWS, BLOCKS, AVG_ROW_LEN,
       TO_CHAR(LAST_ANALYZED,'HH24:MI:SS') ANZ
  FROM USER_TABLES WHERE TABLE_NAME LIKE 'GT_DMF0003%' AND NUM_ROWS IS NOT NULL
 ORDER BY NUM_ROWS DESC;

SELECT TABLE_NAME, COLUMN_NAME, NUM_DISTINCT, NUM_NULLS, AVG_COL_LEN
  FROM USER_TAB_COL_STATISTICS
 WHERE TABLE_NAME LIKE 'GT_DMF0003%' AND COLUMN_NAME IN ('DIVISION_ID','ITEM_VALID_YN')
 ORDER BY TABLE_NAME, COLUMN_NAME;
-- 기대: DIVISION_ID NUM_DISTINCT=1 / ITEM_VALID_YN=2

SPOOL OFF

PROMPT
PROMPT =============================================================
PROMPT [5] 다음 순서 — ⭐ **화면 실제 소요시간(초)을 꼭 기록**해 주세요
PROMPT   ① DMF0003 조회를 **처음 20초 걸렸던 것과 동일한 조회조건**으로 실행
PROMPT      → 스톱워치 기준 소요: ______ 초   (이것이 최종 판정 기준)
PROMPT   ② 07_DMF0003_AFTER.sql 재실행
PROMPT   ⭐ 기대: GT_DMF0003_SITE_ITEM E-Rows 가 2 가 아니라 **7,500 내외**
PROMPT           (15,000 × NDV1 × 1/2). CARTESIAN 이 더 줄어듦
PROMPT =============================================================

-- =============================================================================
-- [6] 원복 — 08+09 전부 되돌리기
-- =============================================================================
-- DECLARE
--   TYPE T IS TABLE OF VARCHAR2(64);
--   L T := T('GT_DMF0003_SITE_ITEM','GT_DMF0003_SITE_ITEM_ALL',
--            'GT_DMF0003_ITEM_SINGLE_ORI','GT_DMF0003_ITEM_SINGLE_A',
--            'GT_DMF0003_ITEM_SINGLE_V','GT_DMF0003_ITEM_SINGLE_B',
--            'GT_DMF0003_LAST_DATA_SETUP','GT_DMF0003_MKT_FCST_RESULT',
--            'GT_DMF0003_MKT_FCST_DATA','GT_DMF0003_SELECT_MEASURE','GT_DMF0003_EDI_SENDER');
-- BEGIN
--   FOR I IN 1..L.COUNT LOOP
--     BEGIN DBMS_STATS.UNLOCK_TABLE_STATS('SCM_MGR', L(I)); EXCEPTION WHEN OTHERS THEN NULL; END;
--     DBMS_STATS.DELETE_TABLE_STATS('SCM_MGR', L(I), NO_INVALIDATE => FALSE);
--     DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', L(I), 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');
--   END LOOP;
--   DBMS_OUTPUT.PUT_LINE('원복 완료');
-- END;
-- /
