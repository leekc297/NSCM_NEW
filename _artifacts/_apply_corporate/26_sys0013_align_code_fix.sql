-- =====================================================================================
-- SYS0013 SHEET_COLUMNS HORIZONTAL_ALIGN_CODE 표준 교정 (2026-06-28 사용자 요구)
--   증상: Query ID(main.DQ_ID) UI Category Setup = Center 인데 화면 우정렬.
--   원인: SYS0013 메타가 전체단어("Center"/"Left"/"Right") 사용 — 비표준 아웃라이어.
--         FE columnMapping.alignMap = {L,R,C} 단일문자만 매핑 → alignMap['Center']=undefined
--         → 정렬 미적용 → 숫자 컬럼 Wijmo 기본 우정렬.
--   표준: 단일문자 C/L/R (전사 318+ 화면). → SYS0013 전 sheet 를 단일문자로 교정.
--   멱등: 이미 C/L/R 이면 0 row update. 적용: ora.py exec 26_sys0013_align_code_fix.sql
-- =====================================================================================
UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET HORIZONTAL_ALIGN_CODE = 'C'
 WHERE PROGRAM_ID = 'SYS0013' AND HORIZONTAL_ALIGN_CODE = 'Center';

UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET HORIZONTAL_ALIGN_CODE = 'L'
 WHERE PROGRAM_ID = 'SYS0013' AND HORIZONTAL_ALIGN_CODE = 'Left';

UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET HORIZONTAL_ALIGN_CODE = 'R'
 WHERE PROGRAM_ID = 'SYS0013' AND HORIZONTAL_ALIGN_CODE = 'Right';

COMMIT;
