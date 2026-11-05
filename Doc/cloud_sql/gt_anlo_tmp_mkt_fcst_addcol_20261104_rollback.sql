-- 2026-11-04 사용자 지시로 gt_anlo_tmp_mkt_fcst_addcol_20261104.sql 원복(사내 ZIOUI1) — 추가했던 3칼럼 제거
-- 멱등: 없는 칼럼은 건너뜀 · 원복 후 PKG_DMF0003 BODY 는 다시 INVALID(ORA-00913) 상태로 돌아감
DECLARE
  PROCEDURE drop_col(p_tab VARCHAR2, p_col VARCHAR2) IS
    v_cnt NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_cnt FROM ALL_TAB_COLUMNS
     WHERE OWNER = 'SCM_MGR' AND TABLE_NAME = p_tab AND COLUMN_NAME = p_col;
    IF v_cnt > 0 THEN
      EXECUTE IMMEDIATE 'ALTER TABLE SCM_MGR.' || p_tab || ' DROP COLUMN ' || p_col;
    END IF;
  END;
BEGIN
  drop_col('GT_ANLO_TMP_DM_PLN_MKT_FCST_C',        'MDL_GR');
  drop_col('GT_ANLO_TMP_DM_PLN_MKT_FCST_C',        'PRDN_CTRY_OPT');
  drop_col('GT_ANLO_TMP_DM_PLN_MKT_FCST_C',        'PRDN_CTRY');
  drop_col('GT_ANLO_TMP_DM_PLN_MKT_FCST_RESULT_C', 'MDL_GR');
  drop_col('GT_ANLO_TMP_DM_PLN_MKT_FCST_RESULT_C', 'PRDN_CTRY_OPT');
  drop_col('GT_ANLO_TMP_DM_PLN_MKT_FCST_RESULT_C', 'PRDN_CTRY');
END;
/
