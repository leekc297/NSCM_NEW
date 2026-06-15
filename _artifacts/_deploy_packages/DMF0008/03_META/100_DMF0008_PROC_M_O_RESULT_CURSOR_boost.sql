--==============================================================================
-- 100_DMF0008_PROC_M_O_RESULT_CURSOR_boost.sql
--
-- 목적:
--   2026-06-09 이후 DMF0008_GET_EDI_MST_SUMMARY / REPAIR / SALES_SITE_PROJECT_MODEL
--   SP body 가 dual-cursor (O_RC1 + O_RESULT_CURSOR) 또는 triple-cursor (O_RC1 + O_RC3 + O_RESULT_CURSOR)
--   패턴으로 변환되었으나, SCM_ADM_PROC_M 메타에 마지막 OUT cursor (O_RESULT_CURSOR) 가 누락되어
--   BE 동적 SP 호출이 (N-1) parameter 로 실행 → ORA-06550 PLS-00306 (인수 갯수/유형 불일치).
--
-- 진단 결과 (2026-06-10):
--   DMF0008_GET_EDI_MST_SUMMARY : SP 5 IN + 3 OUT (O_RC1, O_RC3, O_RESULT_CURSOR)
--                                 PROC_M 7 rows (O_RESULT_CURSOR 누락) → 8 rows 로 보강
--   DMF0008_GET_EDI_MST_REPAIR  : SP 7 IN + 2 OUT (O_RC1, O_RESULT_CURSOR)
--                                 PROC_M 8 rows (O_RESULT_CURSOR 누락) → 9 rows 로 보강
--   DMF0008_GET_SALES_SITE_PROJECT_MODEL : SP 5 IN + 2 OUT (O_RC1, O_RESULT_CURSOR)
--                                 PROC_M 6 rows (O_RESULT_CURSOR 누락) → 7 rows 로 보강
--
-- 적용 패턴: NOT EXISTS 멱등 INSERT (재실행 안전)
-- 메모리: feedback_proc_meta_must_match_sp_signature.md / feedback_sp_dual_out_cursor_pattern.md
-- 룰: _rules_v2/hooks/sp-dual-cursor-pattern.md / proc-meta-signature-match.md
--==============================================================================

INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, SORT_ORD, DATA_TP_CD)
SELECT 'DMF0008_GET_EDI_MST_SUMMARY', 'O_RESULT_CURSOR', 'OUT', 8, 'CURSOR' FROM DUAL
WHERE NOT EXISTS (
  SELECT 1 FROM SCM_ADM_PROC_M
   WHERE PROC_NM = 'DMF0008_GET_EDI_MST_SUMMARY'
     AND COL_NM  = 'O_RESULT_CURSOR'
     AND COL_TP_CD = 'OUT'
);

INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, SORT_ORD, DATA_TP_CD)
SELECT 'DMF0008_GET_EDI_MST_REPAIR', 'O_RESULT_CURSOR', 'OUT', 9, 'CURSOR' FROM DUAL
WHERE NOT EXISTS (
  SELECT 1 FROM SCM_ADM_PROC_M
   WHERE PROC_NM = 'DMF0008_GET_EDI_MST_REPAIR'
     AND COL_NM  = 'O_RESULT_CURSOR'
     AND COL_TP_CD = 'OUT'
);

INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, SORT_ORD, DATA_TP_CD)
SELECT 'DMF0008_GET_SALES_SITE_PROJECT_MODEL', 'O_RESULT_CURSOR', 'OUT', 7, 'CURSOR' FROM DUAL
WHERE NOT EXISTS (
  SELECT 1 FROM SCM_ADM_PROC_M
   WHERE PROC_NM = 'DMF0008_GET_SALES_SITE_PROJECT_MODEL'
     AND COL_NM  = 'O_RESULT_CURSOR'
     AND COL_TP_CD = 'OUT'
);

COMMIT;

-- Verify (expected: SUMMARY=8 / REPAIR=9 / SSPM=7 rows total)
PROMPT === VERIFY ===
SELECT PROC_NM, COUNT(*) AS rows_meta,
       SUM(CASE WHEN COL_NM='O_RESULT_CURSOR' AND COL_TP_CD='OUT' THEN 1 ELSE 0 END) AS has_result_cursor
  FROM SCM_ADM_PROC_M
 WHERE PROC_NM IN ('DMF0008_GET_EDI_MST_SUMMARY','DMF0008_GET_EDI_MST_REPAIR','DMF0008_GET_SALES_SITE_PROJECT_MODEL')
 GROUP BY PROC_NM
 ORDER BY PROC_NM;
