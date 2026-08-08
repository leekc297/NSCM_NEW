-- ============================================================================
-- SYS0017 Mail Setup — 검증 피드백 13건 중 메타 결함(S2) 정정 (2026-08-06)
-- 대상: SCM_MGR.SCM_MST_SHEET_COLUMNS (PROGRAM_ID='SYS0017', 32행)
-- 근거:
--   [실측 1] FE 코드 INPUT_TP_CD 인식 값 (packages/foundation/src/constants/column-config.ts
--            CELL_INPUT_EDIT_TYPE + gridUtils.ts L58~68):
--            'M'(MANDATORY)/'O'(OPTIONAL) = EDIT_FLAG!=='N' 이면 편집,
--            'IM'/'IO' = CRUD_TYPE==='I'(신규 행)에서만 편집,
--            'S'(SEARCH_ONLY)/기타 = 항상 읽기전용.
--   [실측 2] CELL_CONTROL_OBJECT_TYPE_CODE 콤보 표준 = 'FPComboBox'
--            (CELL_CONTROL_TYPE.COMBO — 'C' 는 미인식 → dataMap 자동 배선 불발).
--   [실측 3] 적용 전 상태: 32행 전부 INPUT_TP_CD='IM' / 콤보 8행 CTRL='C'
--            / CELL_COMBO_DATA_TYPE 는 8행 모두 올바른 CMBO 등록명 기보유(보정 불요).
--   [AS-IS] SCM0006 제약매트릭스 D1~D10 (Doc/화면분석서/SYS0017_MailSetup_제약매트릭스_상세.md)
-- 멱등: 차이가드(현재값<>목표값) UPDATE — 재실행 시 0행. 감사컬럼 'admin'.
-- ============================================================================

-- [1] 콤보 8컬럼 CTRL 'C' -> 'FPComboBox'
--     main: MODULE_CODE/SUB_MODULE_CODE/ACTIVE_FLAG/CYCLE_CLASS_CODE/DETAIL_CLASS_CODE
--           /SEND_TIME_TEXT/SEND_MIN_TIME_TEXT, message: LANGUAGE_CODE
UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET CELL_CONTROL_OBJECT_TYPE_CODE = 'FPComboBox',
       LAST_UPDATED_BY = 'admin',
       LAST_UPDATE_DATE = SYSDATE
 WHERE PROGRAM_ID = 'SYS0017'
   AND ( (SHEET_NAME = 'main' AND COLUMN_NAME IN
            ('MODULE_CODE','SUB_MODULE_CODE','ACTIVE_FLAG','CYCLE_CLASS_CODE',
             'DETAIL_CLASS_CODE','SEND_TIME_TEXT','SEND_MIN_TIME_TEXT'))
      OR (SHEET_NAME = 'message' AND COLUMN_NAME = 'LANGUAGE_CODE') )
   AND CELL_CONTROL_OBJECT_TYPE_CODE = 'C';

-- [2] main 시트 INPUT_TP_CD — 편집가능(필수) 'M': CATEGORY_DESC(라벨 'Category *')
--     / CYCLE_CLASS_CODE(라벨 'Main *' — A2 필수)
UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET INPUT_TP_CD = 'M',
       LAST_UPDATED_BY = 'admin',
       LAST_UPDATE_DATE = SYSDATE
 WHERE PROGRAM_ID = 'SYS0017'
   AND SHEET_NAME = 'main'
   AND COLUMN_NAME IN ('CATEGORY_DESC','CYCLE_CLASS_CODE')
   AND INPUT_TP_CD <> 'M';

-- [3] main 시트 INPUT_TP_CD — 편집가능(선택) 'O': ACTIVE_FLAG/DETAIL_CLASS_CODE
--     /SEND_TIME_TEXT/SEND_MIN_TIME_TEXT (조건부 차단 C3~C5 는 FE beginningEdit 담당)
UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET INPUT_TP_CD = 'O',
       LAST_UPDATED_BY = 'admin',
       LAST_UPDATE_DATE = SYSDATE
 WHERE PROGRAM_ID = 'SYS0017'
   AND SHEET_NAME = 'main'
   AND COLUMN_NAME IN ('ACTIVE_FLAG','DETAIL_CLASS_CODE','SEND_TIME_TEXT','SEND_MIN_TIME_TEXT')
   AND INPUT_TP_CD <> 'O';

-- [4] main 시트 INPUT_TP_CD — 읽기전용 'S': USE_TYPE_CODE(고정 'MAIL')/VIEW(SQL VIEW 더블클릭 전용)
--     ※ MODULE_CODE/SUB_MODULE_CODE/CATEGORY_ID 는 'IM' 유지 (신규 행만 입력 — D4 키 보호)
UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET INPUT_TP_CD = 'S',
       LAST_UPDATED_BY = 'admin',
       LAST_UPDATE_DATE = SYSDATE
 WHERE PROGRAM_ID = 'SYS0017'
   AND SHEET_NAME = 'main'
   AND COLUMN_NAME IN ('USE_TYPE_CODE','VIEW')
   AND INPUT_TP_CD <> 'S';

-- [5] message 시트 INPUT_TP_CD — 편집가능(필수) 'M': MAIL_TITLE/MESSAGE_CONTENT
--     ※ LANGUAGE_CODE 는 'IM' 유지 (신규 행만 언어 선택 — D5/D10)
UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET INPUT_TP_CD = 'M',
       LAST_UPDATED_BY = 'admin',
       LAST_UPDATE_DATE = SYSDATE
 WHERE PROGRAM_ID = 'SYS0017'
   AND SHEET_NAME = 'message'
   AND COLUMN_NAME IN ('MAIL_TITLE','MESSAGE_CONTENT')
   AND INPUT_TP_CD <> 'M';

-- [6] message 시트 INPUT_TP_CD — 읽기전용 'S': CATEGORY_DESC(마스터 승계값 — D8/D10)
--     + 숨김 키 USE_TYPE_CODE/CATEGORY_ID (D5 잠금 정합 — 스펙 명시 외 보완, 보고 명기)
UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET INPUT_TP_CD = 'S',
       LAST_UPDATED_BY = 'admin',
       LAST_UPDATE_DATE = SYSDATE
 WHERE PROGRAM_ID = 'SYS0017'
   AND SHEET_NAME = 'message'
   AND COLUMN_NAME IN ('CATEGORY_DESC','USE_TYPE_CODE','CATEGORY_ID')
   AND INPUT_TP_CD <> 'S';

-- [7] selReceiver 시트 전 9컬럼 'S' — 수신자는 ▶/◀ 이동으로만 추가/제거, 셀 직접 편집 금지
--     (D6: CATEGORY_ID~LANGUAGE 잠금 + D9: 추가된 행 USE_TYPE~LANGUAGE 잠금 — 행 전체가 승계값.
--      'IM' 잔존 시 이동 직후 'I' 행의 사용자 정보가 편집 가능해져 D9 위반 → 보완, 보고 명기)
UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET INPUT_TP_CD = 'S',
       LAST_UPDATED_BY = 'admin',
       LAST_UPDATE_DATE = SYSDATE
 WHERE PROGRAM_ID = 'SYS0017'
   AND SHEET_NAME = 'selReceiver'
   AND INPUT_TP_CD <> 'S';

-- [8] allReceiver 시트 전 6컬럼 'S' — 항상 조회 전용 (D2. FE 그리드 isReadOnly 와 이중 방어)
UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET INPUT_TP_CD = 'S',
       LAST_UPDATED_BY = 'admin',
       LAST_UPDATE_DATE = SYSDATE
 WHERE PROGRAM_ID = 'SYS0017'
   AND SHEET_NAME = 'allReceiver'
   AND INPUT_TP_CD <> 'S';

COMMIT;
