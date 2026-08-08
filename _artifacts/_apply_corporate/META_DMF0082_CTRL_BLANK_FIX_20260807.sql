-- =====================================================================
-- DMF0082 — SHEET_COLUMNS CTRL 공백(' ') 정정 (2026-08-07)
-- 근거: AS-IS(MSSQL) 실측 = 빈 문자열(제어 없음) 26행 — 이관 시 ' '(공백) 치환 잔재.
--       Oracle 정본 = NULL (''=NULL, hook #119 계보). check-meta-sql 화이트리스트(FP*+NULL+'S') 정합.
-- 대상: DMF0082 전 시트(FcstNPrice 34 + Sales Price Save All 14 = 48행 실측)
-- 기능 영향: 없음 — FE columnMapping 은 ' ' 를 어떤 에디터에도 매칭하지 않음(표시 전용 동일)
-- =====================================================================

UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
SET    CELL_CONTROL_OBJECT_TYPE_CODE = NULL
     , LAST_UPDATED_BY  = 'admin'
     , LAST_UPDATE_DATE = SYSDATE
WHERE  PROGRAM_ID = 'DMF0082'
AND    CELL_CONTROL_OBJECT_TYPE_CODE = ' ';

COMMIT;

-- [검증] 기대 0행
SELECT SHEET_NAME, COUNT(*) BLANK_CTRL FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
WHERE  PROGRAM_ID='DMF0082' AND CELL_CONTROL_OBJECT_TYPE_CODE=' '
GROUP BY SHEET_NAME;
