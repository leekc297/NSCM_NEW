-- DMF0008 SP body + PROC_M 보완 (2026-06-10)
-- 사용자 요구: "DMF0008 PKG, SP 다시 보완 + source 데이터 As-Is 가져오기"
-- 사고 진단 (BE 로그 + SP body 분석):
--   1. SUMMARY: 메인 cursor 가 line 132 의 DUMMY OPEN 으로 덮어쓰기 (메모리 feedback_sp_cursor_reassignment_overwrite.md)
--   2. SUMMARY + REPAIR: NVL(EXCEPTION_FLAG, NULL) != 'Y' 안티 패턴 (NULL 비교 시 UNKNOWN → row 제외)
--      (메모리 feedback_isnull_to_nvl_null_handling.md)
--   3. SALES_SITE_PROJECT_MODEL: PROC_M O_RESULT_CURSOR 누락 (메모리 feedback_proc_meta_must_match_sp_signature.md)
--   4. source 데이터 부재 아님 (DM_DNM_EDI_CALLOFF_ITEM 37만 rows / div=81 STATUS=E 39,953 rows)
--
-- Fix 적용:
--   - _dmf0008_fix/_fixed_summary.sql : SUMMARY SP body 수정 후 CREATE OR REPLACE
--   - _dmf0008_fix/_fixed_repair.sql  : REPAIR SP body 수정 후 CREATE OR REPLACE
--   - 본 파일                          : SALES_SITE_PROJECT_MODEL PROC_M 보강 (NOT EXISTS 멱등)

INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, SORT_ORD, DATA_TP_CD)
SELECT 'DMF0008_GET_SALES_SITE_PROJECT_MODEL', 'O_RESULT_CURSOR', 'OUT', 7, 'CURSOR' FROM DUAL
WHERE NOT EXISTS (
  SELECT 1 FROM SCM_ADM_PROC_M
   WHERE PROC_NM = 'DMF0008_GET_SALES_SITE_PROJECT_MODEL'
     AND COL_NM  = 'O_RESULT_CURSOR'
     AND COL_TP_CD = 'OUT'
);

COMMIT;

PROMPT === VERIFY PROC_M (expected SALES_SITE_PROJECT_MODEL = 7 rows) ===
SELECT PROC_NM, COUNT(*) AS rows_meta
  FROM SCM_ADM_PROC_M
 WHERE PROC_NM = 'DMF0008_GET_SALES_SITE_PROJECT_MODEL'
 GROUP BY PROC_NM;
