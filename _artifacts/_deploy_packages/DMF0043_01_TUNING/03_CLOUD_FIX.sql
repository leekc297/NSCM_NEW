-- =====================================================================
-- 03_CLOUD_FIX.sql
--
-- Phase B-1 (cloud 전용 — 향후 운영 cloud 이관용 보관):
--   FIX 1: FP_MGR.SCM_ITEM_M 함수기반 인덱스 (DIVISION_ID + SUBSTR(ITEM_ID, 1, 12))
--   FIX 2: stats gather DEGREE=4
--
-- ⚠️ 로컬 Docker 환경에서 본 script 실행 금지 (FP_MGR 스키마 미존재 / PARALLEL 미지원).
-- 본 script 는 cloud Oracle Enterprise Edition 에서만 적용.
--
-- 실행: sqlplus scm_mgr/PASS@//<cloud-host>:<port>/<service> @03_CLOUD_FIX.sql
-- =====================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 250
WHENEVER SQLERROR CONTINUE

PROMPT === [B-1.C.1] FP_MGR.SCM_ITEM_M function-based 인덱스 ===
-- DM_MST_ITEM_SINGLE_V view 자가 JOIN cost 17717 → 7794 (50% 단축)
-- 효과: 본 SP 안 LEFT JOIN DM_MST_ITEM_SINGLE_V C ON A.ITEM_ID = C.ITEM_ID (L2746~2748)
DECLARE
  v_exists NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_exists FROM DBA_INDEXES
   WHERE OWNER='FP_MGR' AND INDEX_NAME='IDX_SCM_ITEM_M_DIV_SUB12';
  IF v_exists = 0 THEN
    EXECUTE IMMEDIATE 'CREATE INDEX FP_MGR.IDX_SCM_ITEM_M_DIV_SUB12
                       ON FP_MGR.SCM_ITEM_M(DIVISION_ID, SUBSTR(ITEM_ID, 1, 12))
                       PARALLEL 4 ONLINE';
    EXECUTE IMMEDIATE 'ALTER INDEX FP_MGR.IDX_SCM_ITEM_M_DIV_SUB12 NOPARALLEL';
    DBMS_OUTPUT.PUT_LINE('[FIX 1] index IDX_SCM_ITEM_M_DIV_SUB12 created');
  ELSE
    DBMS_OUTPUT.PUT_LINE('[FIX 1] index IDX_SCM_ITEM_M_DIV_SUB12 already exists — skip');
  END IF;
END;
/

PROMPT === [B-1.C.2] stats gather DEGREE=4 ===
BEGIN
  DBMS_STATS.GATHER_TABLE_STATS('FP_MGR', 'SCM_ITEM_M', CASCADE => TRUE, DEGREE => 4);
  DBMS_STATS.GATHER_TABLE_STATS('SCM_MGR', 'SCM_MST_SITE_ITEM', CASCADE => TRUE, DEGREE => 4);
  DBMS_STATS.GATHER_TABLE_STATS('SCM_MGR', 'DM_PLN_SALES_PLAN_REPORT_C', CASCADE => TRUE, DEGREE => 4);
  DBMS_STATS.GATHER_TABLE_STATS('SCM_MGR', 'DM_MST_CONTRIBUTE_RATIO_MST', CASCADE => TRUE, DEGREE => 4);
  DBMS_STATS.GATHER_TABLE_STATS('SCM_MGR', 'DM_MST_CONTRIBUTE_RATIO_DTL', CASCADE => TRUE, DEGREE => 4);
  DBMS_OUTPUT.PUT_LINE('[FIX 2] cloud stats 재수집 완료');
END;
/

PROMPT === [B-1.C.3] 검증 ===
SELECT INDEX_NAME, STATUS FROM DBA_INDEXES
 WHERE OWNER='FP_MGR' AND INDEX_NAME='IDX_SCM_ITEM_M_DIV_SUB12';
