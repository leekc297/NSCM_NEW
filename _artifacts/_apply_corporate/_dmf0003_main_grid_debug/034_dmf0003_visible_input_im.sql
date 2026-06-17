-- 2026-06-16 — 신규 Row Edit 가능 보장:
--   사용자 명시: Division 이외 모든 visible column 은 신규 row 시 editable 의무
--   현재 DB: visible='Y' 13 column 중 7 column 이 INPUT_TP_CD='S' (read-only) — Insert 후 editor 진입 차단
--   처리: DIVISION_ID / DIVISION_ID40 제외 모든 'S' → 'IM' (Mandatory Insert)

UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET INPUT_TP_CD     = 'IM',
       LAST_UPDATED_BY = 'system',
       LAST_UPDATE_DATE = SYSDATE
 WHERE PROGRAM_ID = 'DMF0003'
   AND SHEET_NAME = 'main'
   AND VISIBLE_FLAG = 'Y'
   AND INPUT_TP_CD = 'S'
   AND COLUMN_NAME NOT IN ('DIVISION_ID', 'DIVISION_ID40');

COMMIT;
