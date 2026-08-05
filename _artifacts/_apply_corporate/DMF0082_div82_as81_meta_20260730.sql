-- ============================================================================================
-- DMF0082 — Division 82 를 81 과 동일 동작으로 편입 (메타 정정)
-- 2026-07-30  사용자 지시: "40은 현재와 같이 유지, 81·82 는 현재의 81 과 같이 수행"
--
-- 대상 = 81 계열 토큰만 있고 82 가 빠진 행 (실측 근거):
--   SCM_MST_SHEET_COLUMNS  FcstNPrice           SENDER_NAME    '40,81,81_UC,81_HM,81_ST,81_HD,81_HG'  1행
--   SCM_MST_SHEET_COLUMNS  Sales Price Save All PLANT_SITE_ID  '81,81_UC,81_HM,81_ST,81_HD,81_HG'     1행
--   SCM_MST_SHEET_MEASURE  FcstNPrice           (10 measure)   '40,81,81_UC,81_HM,81_ST,81_HD,81_HG' 10행
--     └ 실측: SHEET_MEASURE 에 82 토큰이 전무 → 현재 82 사용자는 measure 0개 (그리드 미동작)
-- 비대상 = DIVISION_ID='40' 단독 행 (81 도 미노출 → 82 도 미노출이 정합)
-- 멱등: 이미 82 포함 행은 NOT LIKE 가드로 skip
-- 감사컬럼 = 'admin' (룰 feedback_meta_audit_column_admin_only)
-- ============================================================================================

UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET DIVISION_ID      = DIVISION_ID || ',82'
     , LAST_UPDATED_BY  = 'admin'
     , LAST_UPDATE_DATE = SYSDATE
 WHERE PROGRAM_ID  = 'DMF0082'
   AND DIVISION_ID LIKE '%81%'
   AND ',' || DIVISION_ID || ',' NOT LIKE '%,82,%'
;

UPDATE SCM_MGR.SCM_MST_SHEET_MEASURE
   SET DIVISION_ID      = DIVISION_ID || ',82'
     , LAST_UPDATED_BY  = 'admin'
     , LAST_UPDATE_DATE = SYSDATE
 WHERE PROGRAM_ID  = 'DMF0082'
   AND DIVISION_ID LIKE '%81%'
   AND ',' || DIVISION_ID || ',' NOT LIKE '%,82,%'
;

COMMIT;
