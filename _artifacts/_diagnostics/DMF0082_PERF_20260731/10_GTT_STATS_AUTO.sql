-- =============================================================================
-- 10_GTT_STATS_AUTO.sql — GTT 통계 자동 측정·설정 (DMF0082 / DMF0021 / DMF0020)
--
--   DMF0003 에서 20초 → 3~4초를 만든 조치를 3개 화면에 적용합니다.
--   ⭐ 제가 행수를 임의로 넣지 않고, **클라우드에서 스스로 측정**해 설정합니다.
--      (사내 행수는 클라우드와 다르므로 하드코딩하면 오히려 해가 됩니다)
--
--   측정 원리: GTT 는 내용을 직접 셀 수 없으므로
--              `V$SQL` 의 `INSERT INTO <GTT>` 문에서 ROWS_PROCESSED/EXECUTIONS 를 읽습니다.
--              → **반드시 아래 §0 선행조건을 지켜야** 측정이 됩니다.
--
--   변경 대상: 옵티마이저 통계만. 데이터·구조·SP 변경 없음. §5 로 완전 원복.
--   계정: SCM_MGR
-- =============================================================================

-- ##########################################################################
-- §0 ⛔ 선행조건 (안 지키면 대부분 'V$SQL 근거 없음' 으로 건너뜁니다)
--    ① 이 스크립트를 돌리기 **직전에** 세 화면을 각각 1회 이상 조회하십시오.
--       DMF0082 / DMF0021 / DMF0020 — **실제로 느렸던 조회조건**으로.
--    ② 조회 직후 바로 이 스크립트를 실행 (V$SQL 커서가 살아 있어야 함)
--    ③ 여러 division 을 쓰는 화면은 **데이터가 가장 많은 division** 으로 조회하는 것이
--       안전합니다(고정값이 과소추정되면 다시 느려지므로, 큰 쪽에 맞추는 편이 낫습니다)
-- ##########################################################################

SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 220
SET PAGESIZE 400
SET TIMING ON

SPOOL GTT_STATS_AUTO_RESULT.txt

PROMPT ############################################################
PROMPT [1] 대상 GTT 수집 + V$SQL 실측 (설정 전 미리보기 — 변경 없음)
PROMPT ############################################################
WITH TOK AS (
  SELECT DISTINCT T FROM (
    SELECT REGEXP_SUBSTR(UPPER(TEXT),'GTT?_[A-Z0-9_]+',1,1) T FROM USER_SOURCE
     WHERE TYPE='PACKAGE BODY' AND NAME IN ('PKG_DMF0082','PKG_DMF0021','PKG_DMF0020')
       AND TRIM(TEXT) NOT LIKE '--%'
    UNION ALL
    SELECT REGEXP_SUBSTR(UPPER(TEXT),'GTT?_[A-Z0-9_]+',1,2) FROM USER_SOURCE
     WHERE TYPE='PACKAGE BODY' AND NAME IN ('PKG_DMF0082','PKG_DMF0021','PKG_DMF0020')
       AND TRIM(TEXT) NOT LIKE '--%'
    UNION ALL
    SELECT REGEXP_SUBSTR(UPPER(TEXT),'GTT?_[A-Z0-9_]+',1,3) FROM USER_SOURCE
     WHERE TYPE='PACKAGE BODY' AND NAME IN ('PKG_DMF0082','PKG_DMF0021','PKG_DMF0020')
       AND TRIM(TEXT) NOT LIKE '--%'
  ) WHERE T IS NOT NULL
), G AS (
  SELECT t.T TAB FROM TOK t
   WHERE EXISTS (SELECT 1 FROM USER_TABLES u WHERE u.TABLE_NAME=t.T AND u.TEMPORARY='Y')
)
SELECT g.TAB,
       (SELECT MAX(CEIL(s.ROWS_PROCESSED/GREATEST(s.EXECUTIONS,1)))
          FROM V$SQL s
         WHERE s.EXECUTIONS > 0
           AND REGEXP_LIKE(s.SQL_TEXT,'INSERT\s+(/\*.*?\*/\s*)?INTO\s+(SCM_MGR\.)?'||g.TAB||'[^A-Z0-9_$]','i')
       ) MEASURED_ROWS,
       (SELECT COUNT(DISTINCT NAME) FROM USER_SOURCE
         WHERE TYPE='PACKAGE BODY' AND REGEXP_LIKE(TEXT,'[^A-Z0-9_$]'||g.TAB||'[^A-Z0-9_$]','i')
           AND TRIM(TEXT) NOT LIKE '--%') USED_BY_PKGS,
       (SELECT COUNT(*) FROM USER_TAB_COLUMNS c
         WHERE c.TABLE_NAME=g.TAB AND c.COLUMN_NAME='DIVISION_ID') HAS_DIV,
       (SELECT NUM_ROWS FROM USER_TABLES u WHERE u.TABLE_NAME=g.TAB) CUR_STAT
  FROM G g ORDER BY MEASURED_ROWS DESC NULLS LAST, g.TAB;
-- ⭐ 읽는 법
--   MEASURED_ROWS NULL  = V$SQL 근거 없음 → **건너뜁니다**(추측 설정 안 함). §0 을 다시 확인하십시오
--   USED_BY_PKGS  >1    = **여러 화면이 공유하는 GTT** → 다른 화면에도 영향. 아래 [2] 에서 별도 표시
--   CUR_STAT      NOT NULL = 이미 통계가 있는 GTT

PROMPT ############################################################
PROMPT [2] 통계 설정 실행
PROMPT ############################################################
DECLARE
  V_ROWS   NUMBER;
  V_RLEN   NUMBER;
  V_BLK    NUMBER;
  V_PKGS   NUMBER;
  V_DIV    NUMBER;
  V_OK     NUMBER := 0;
  V_SKIP   NUMBER := 0;
  V_SHARED NUMBER := 0;
BEGIN
  FOR R IN (
    WITH TOK AS (
      SELECT DISTINCT T FROM (
        SELECT REGEXP_SUBSTR(UPPER(TEXT),'GTT?_[A-Z0-9_]+',1,1) T FROM USER_SOURCE
         WHERE TYPE='PACKAGE BODY' AND NAME IN ('PKG_DMF0082','PKG_DMF0021','PKG_DMF0020')
           AND TRIM(TEXT) NOT LIKE '--%'
        UNION ALL
        SELECT REGEXP_SUBSTR(UPPER(TEXT),'GTT?_[A-Z0-9_]+',1,2) FROM USER_SOURCE
         WHERE TYPE='PACKAGE BODY' AND NAME IN ('PKG_DMF0082','PKG_DMF0021','PKG_DMF0020')
           AND TRIM(TEXT) NOT LIKE '--%'
        UNION ALL
        SELECT REGEXP_SUBSTR(UPPER(TEXT),'GTT?_[A-Z0-9_]+',1,3) FROM USER_SOURCE
         WHERE TYPE='PACKAGE BODY' AND NAME IN ('PKG_DMF0082','PKG_DMF0021','PKG_DMF0020')
           AND TRIM(TEXT) NOT LIKE '--%'
      ) WHERE T IS NOT NULL
    )
    SELECT t.T TAB FROM TOK t
     WHERE EXISTS (SELECT 1 FROM USER_TABLES u WHERE u.TABLE_NAME=t.T AND u.TEMPORARY='Y')
     ORDER BY t.T
  ) LOOP

    -- (a) V$SQL 실측 행수
    SELECT MAX(CEIL(s.ROWS_PROCESSED/GREATEST(s.EXECUTIONS,1))) INTO V_ROWS
      FROM V$SQL s
     WHERE s.EXECUTIONS > 0
       AND REGEXP_LIKE(s.SQL_TEXT,'INSERT\s+(/\*.*?\*/\s*)?INTO\s+(SCM_MGR\.)?'||R.TAB||'[^A-Z0-9_$]','i');

    IF V_ROWS IS NULL THEN
      V_SKIP := V_SKIP + 1;
      DBMS_OUTPUT.PUT_LINE('SKIP '||RPAD(R.TAB,34)||' V$SQL 근거 없음(조회 미실행 또는 미사용)');
      CONTINUE;
    END IF;
    V_ROWS := GREATEST(V_ROWS, 1);

    -- (b) 공유 GTT 경고
    SELECT COUNT(DISTINCT NAME) INTO V_PKGS FROM USER_SOURCE
     WHERE TYPE='PACKAGE BODY' AND TRIM(TEXT) NOT LIKE '--%'
       AND REGEXP_LIKE(TEXT,'[^A-Z0-9_$]'||R.TAB||'[^A-Z0-9_$]','i');

    -- (c) 평균 행길이 추정 (컬럼 정의 기반)
    SELECT LEAST(GREATEST(SUM(
             CASE WHEN DATA_TYPE LIKE '%CHAR%' THEN LEAST(DATA_LENGTH,30)
                  WHEN DATA_TYPE='NUMBER'      THEN 6
                  WHEN DATA_TYPE LIKE 'DATE%'  THEN 8
                  WHEN DATA_TYPE LIKE 'TIMESTAMP%' THEN 11
                  ELSE 10 END), 20), 4000)
      INTO V_RLEN FROM USER_TAB_COLUMNS WHERE TABLE_NAME = R.TAB;

    V_BLK := GREATEST(CEIL(V_ROWS * V_RLEN / (8192 * 0.85)), 1);

    BEGIN
      DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', R.TAB, 'GLOBAL_TEMP_TABLE_STATS', 'SHARED');
      BEGIN DBMS_STATS.UNLOCK_TABLE_STATS('SCM_MGR', R.TAB); EXCEPTION WHEN OTHERS THEN NULL; END;

      DBMS_STATS.SET_TABLE_STATS(
        OWNNAME => 'SCM_MGR', TABNAME => R.TAB,
        NUMROWS => V_ROWS, NUMBLKS => V_BLK, AVGRLEN => V_RLEN,
        NO_INVALIDATE => FALSE);

      -- (d) ⭐ 컬럼 통계 — DMF0003 에서 결정타였던 부분
      --     DIVISION_ID: 단일 division 만 적재되는 GTT 이므로 NDV=1
      SELECT COUNT(*) INTO V_DIV FROM USER_TAB_COLUMNS
       WHERE TABLE_NAME = R.TAB AND COLUMN_NAME = 'DIVISION_ID';
      IF V_DIV > 0 THEN
        BEGIN
          DBMS_STATS.SET_COLUMN_STATS('SCM_MGR', R.TAB, 'DIVISION_ID',
            DISTCNT => 1, NULLCNT => 0, AVGCLEN => 3, NO_INVALIDATE => FALSE);
        EXCEPTION WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('     └ DIVISION_ID 컬럼통계 실패: '||SQLERRM);
        END;
      END IF;

      --     _YN / _FLAG 계열: 2값 → NDV=2
      FOR C IN (SELECT COLUMN_NAME FROM USER_TAB_COLUMNS
                 WHERE TABLE_NAME = R.TAB
                   AND (COLUMN_NAME LIKE '%\_YN' ESCAPE '\' OR COLUMN_NAME LIKE '%\_FLAG' ESCAPE '\')
                   AND DATA_TYPE LIKE '%CHAR%' AND DATA_LENGTH <= 2) LOOP
        BEGIN
          DBMS_STATS.SET_COLUMN_STATS('SCM_MGR', R.TAB, C.COLUMN_NAME,
            DISTCNT => 2, NULLCNT => 0, AVGCLEN => 2, NO_INVALIDATE => FALSE);
        EXCEPTION WHEN OTHERS THEN NULL; END;
      END LOOP;

      BEGIN DBMS_STATS.LOCK_TABLE_STATS('SCM_MGR', R.TAB); EXCEPTION WHEN OTHERS THEN NULL; END;

      V_OK := V_OK + 1;
      IF V_PKGS > 1 THEN V_SHARED := V_SHARED + 1; END IF;
      DBMS_OUTPUT.PUT_LINE('OK   '||RPAD(R.TAB,34)||' rows='||LPAD(V_ROWS,8)
        ||' rlen='||LPAD(V_RLEN,5)||' blks='||LPAD(V_BLK,7)
        ||CASE WHEN V_DIV > 0 THEN ' +DIV_NDV1' ELSE '' END
        ||CASE WHEN V_PKGS > 1 THEN '  ⚠공유('||V_PKGS||'개 PKG)' ELSE '' END);

    EXCEPTION WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('FAIL '||RPAD(R.TAB,34)||SQLERRM);
    END;
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('==================================================');
  DBMS_OUTPUT.PUT_LINE('설정 '||V_OK||' 본 / 건너뜀 '||V_SKIP||' 본 / 그중 공유 GTT '||V_SHARED||' 본');
  IF V_SKIP > 0 THEN
    DBMS_OUTPUT.PUT_LINE('⚠ 건너뛴 것이 있으면 §0 대로 세 화면을 조회한 뒤 이 스크립트를 재실행하십시오.');
  END IF;
  IF V_SHARED > 0 THEN
    DBMS_OUTPUT.PUT_LINE('⚠ 공유 GTT 는 다른 화면 계획에도 영향을 줍니다 — 회귀 확인 필요.');
  END IF;
END;
/

PROMPT ############################################################
PROMPT [3] 적용 결과
PROMPT ############################################################
SELECT TABLE_NAME, NUM_ROWS, BLOCKS, AVG_ROW_LEN,
       TO_CHAR(LAST_ANALYZED,'HH24:MI:SS') ANZ
  FROM USER_TABLES
 WHERE TEMPORARY='Y' AND NUM_ROWS IS NOT NULL
 ORDER BY NUM_ROWS DESC;

SELECT TABLE_NAME, COLUMN_NAME, NUM_DISTINCT
  FROM USER_TAB_COL_STATISTICS
 WHERE COLUMN_NAME='DIVISION_ID'
   AND TABLE_NAME IN (SELECT TABLE_NAME FROM USER_TABLES WHERE TEMPORARY='Y')
 ORDER BY TABLE_NAME;
-- 기대: DIVISION_ID NUM_DISTINCT = 1

SPOOL OFF

PROMPT
PROMPT =============================================================
PROMPT [4] 다음 순서 — ⭐ **화면별 실제 소요시간(초)을 기록**해 주세요
PROMPT    DMF0082 : 적용 전 ____초 → 적용 후 ____초   (직전 실측 100초)
PROMPT    DMF0021 : 적용 전 ____초 → 적용 후 ____초
PROMPT    DMF0020 : 적용 전 ____초 → 적용 후 ____초
PROMPT    ⚠ 첫 조회는 재파싱이 일어나 조금 느릴 수 있습니다 — **2회째**를 측정하십시오
PROMPT    ⚠ 공유 GTT 경고가 있었다면 DMF0003 등 다른 화면도 회귀 확인 부탁드립니다
PROMPT =============================================================

-- =============================================================================
-- [5] 원복 — 이 스크립트로 설정한 GTT 통계 전부 제거
--     (DMF0003 분까지 함께 지워지니 주의: 필요하면 TABLE_NAME LIKE 조건을 좁히십시오)
-- =============================================================================
-- BEGIN
--   FOR R IN (SELECT TABLE_NAME FROM USER_TABLES
--              WHERE TEMPORARY='Y' AND NUM_ROWS IS NOT NULL
--                AND TABLE_NAME NOT LIKE 'GT_DMF0003%') LOOP   -- DMF0003 분은 보존
--     BEGIN DBMS_STATS.UNLOCK_TABLE_STATS('SCM_MGR', R.TABLE_NAME); EXCEPTION WHEN OTHERS THEN NULL; END;
--     DBMS_STATS.DELETE_TABLE_STATS('SCM_MGR', R.TABLE_NAME, NO_INVALIDATE => FALSE);
--     DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', R.TABLE_NAME, 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');
--     DBMS_OUTPUT.PUT_LINE('원복 '||R.TABLE_NAME);
--   END LOOP;
-- END;
-- /
