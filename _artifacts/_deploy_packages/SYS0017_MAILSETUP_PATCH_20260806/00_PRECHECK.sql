-- =============================================================================
-- 00_PRECHECK.sql — SYS0017 Mail Setup 증분 패치(20260806) 적용 전 선판정
--                   (read-only, SCM_MGR 로 실행 — QA / DEV 각각 실행)
-- 전제: 본 패키지는 SYS0017_MAILSETUP_20260729 패키지 "선행 적용" 을 전제로 한
--       증분 패치다. [A] 섹션이 하나라도 기대값 미달이면 본 패치를 적용하지 말고
--       선행 패키지(SYS0017_MAILSETUP_20260729)를 먼저 적용할 것.
-- 기대값 근거: 사내 OCGSCMD_P01 실측 2026-08-06 22:40 (패치 기적용 상태).
-- =============================================================================
SET PAGESIZE 200 LINESIZE 200 TRIMSPOOL ON
COLUMN K FORMAT A22
COLUMN NAME FORMAT A38
COLUMN STATUS FORMAT A10

PROMPT === [A-1] 선행 패키지 적용 판정 — PKG_SYS0017 (기대: SPEC+BODY 2행, 둘 다 VALID) ===
SELECT OBJECT_TYPE, OBJECT_NAME NAME, STATUS
  FROM ALL_OBJECTS
 WHERE OWNER = 'SCM_MGR' AND OBJECT_NAME = 'PKG_SYS0017'
 ORDER BY OBJECT_TYPE;

PROMPT === [A-2] 선행 패키지 적용 판정 — 메타 카운트 ===
PROMPT     기대(사내 실측): MNU_M 1 / API_M 9 / BTN_MPG 14 / PROC_M 67(9 SP)
PROMPT                      / SHEET_COL 32 / AUTH_MNU 2그룹 / AUTH_BTN 28(2그룹x14)
SELECT 'MNU_M' K,        COUNT(*) CNT FROM SCM_ADM_MNU_M              WHERE MNU_ID = 'SYS0017'
UNION ALL SELECT 'API_M',     COUNT(*) FROM SCM_ADM_API_M             WHERE API_ID LIKE 'SYS0017%'
UNION ALL SELECT 'BTN_MPG',   COUNT(*) FROM SCM_ADM_MNU_BTN_MPG_M    WHERE MNU_ID = 'SYS0017'
UNION ALL SELECT 'PROC_M',    COUNT(*) FROM SCM_ADM_PROC_M           WHERE PROC_NM LIKE 'PKG_SYS0017.%'
UNION ALL SELECT 'SHEET_COL', COUNT(*) FROM SCM_MST_SHEET_COLUMNS    WHERE PROGRAM_ID = 'SYS0017'
UNION ALL SELECT 'AUTH_MNU',  COUNT(*) FROM SCM_ADM_USER_GR_MNU_MPG_M     WHERE MNU_ID = 'SYS0017'
UNION ALL SELECT 'AUTH_BTN',  COUNT(*) FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID = 'SYS0017';

PROMPT === [A-3] 선행 패키지 적용 판정 — SHEET_COLUMNS 시트별 (기대: allReceiver 6 / main 11 / message 6 / selReceiver 9 = 32) ===
SELECT SHEET_NAME NAME, COUNT(*) CNT
  FROM SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = 'SYS0017'
 GROUP BY SHEET_NAME ORDER BY 1;

PROMPT === [A-4] 선행 패키지 적용 판정 — CMBO 6종 ===
PROMPT     기대: SCM_ADM_CMBO_SQL_M 6행 (MailModule/MailSubModule/MailSendCycle
PROMPT           /MailSendCycleDetail/MailLanguage = 선행 패키지 5종 + YesOrNo = 공용 기존재)
PROMPT     ⚠ YesOrNo 는 공용 콤보 — 0 이면 선행 패키지 문제가 아니라 공용 메타 결손 (별도 보고)
SELECT SQL_ID NAME, USE_YN STATUS
  FROM SCM_ADM_CMBO_SQL_M
 WHERE SQL_ID IN ('MailModule','MailSubModule','MailSendCycle',
                  'MailSendCycleDetail','MailLanguage','YesOrNo')
 ORDER BY 1;

PROMPT === [A-5] SHEET_COLUMNS 가 참조하는 콤보 등록명 무결 (기대: 0행 — 미등록 참조 없음) ===
SELECT DISTINCT SC.CELL_COMBO_DATA_TYPE NAME
  FROM SCM_MST_SHEET_COLUMNS SC
 WHERE SC.PROGRAM_ID = 'SYS0017'
   AND SC.CELL_COMBO_DATA_TYPE IS NOT NULL
   AND NOT EXISTS (SELECT 1 FROM SCM_ADM_CMBO_SQL_M C WHERE C.SQL_ID = SC.CELL_COMBO_DATA_TYPE);

PROMPT === [B-1] 본 패치(01_META) 기적용 판정 — 콤보 CTRL 코드 ===
PROMPT     CTRL_C = 8 이면 미적용(01_META 실행 필요) / CTRL_C = 0 + FPComboBox = 8 이면 기적용(skip)
SELECT 'CTRL_C' K, COUNT(*) CNT FROM SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = 'SYS0017' AND CELL_CONTROL_OBJECT_TYPE_CODE = 'C'
UNION ALL
SELECT 'CTRL_FPComboBox', COUNT(*) FROM SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = 'SYS0017' AND CELL_CONTROL_OBJECT_TYPE_CODE = 'FPComboBox';

PROMPT === [B-2] 본 패치(01_META) 기적용 판정 — INPUT_TP_CD 분포 ===
PROMPT     미적용(선행 패키지 원본): 전 32행 IM
PROMPT     기적용(목표): main IM 3 / M 2 / O 4 / S 2  |  message IM 1 / M 2 / S 3
PROMPT                   |  selReceiver S 9  |  allReceiver S 6
SELECT SHEET_NAME NAME, INPUT_TP_CD, COUNT(*) CNT
  FROM SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = 'SYS0017'
 GROUP BY SHEET_NAME, INPUT_TP_CD
 ORDER BY 1, 2;

PROMPT === 판독 ===
PROMPT [A-1]~[A-5] 기대값 미달 → 본 패치 중단, 선행 SYS0017_MAILSETUP_20260729 먼저 적용
PROMPT [B-1] CTRL_C=8 / [B-2] IM 32 → 01_META/SYS0017_META_FEEDBACK_FIX_20260806.sql 실행
PROMPT [B-1] CTRL_C=0 & [B-2] 목표 분포 → 01_META 는 재실행해도 0행 갱신(차이가드 멱등) — skip 가능
PROMPT 02_FE 는 판정과 무관하게 전체 폴더 덮어쓰기(17파일) — 부분 파일 복사 금지
PROMPT ⭐ 클라우드 적용은 QA(SCMQ_APP)·DEV(SCMP_APP) 2 DB 동시 적용 의무
