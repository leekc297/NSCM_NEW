-- ============================================================================
-- SYS0013_META_AGGREGATE_CTRL_FIX_20260807.sql
-- SYS0017 근본원인 감사(2026-08-06 §5) 후속 P3-2 — SYS0013 columns/AGGREGATE 메타 정정.
--
-- 결함: CELL_CONTROL_OBJECT_TYPE_CODE='S'(비표준) + CELL_COMBO_DATA_TYPE='sysAggregateOptions'
--       + 편집가능('O') → 콤보 dataMap 자동 배선 불발 = SYS0017 결함 #5 와 동일 실패 모드.
-- 선행 실측 (2026-08-07, ora.py):
--   ① 대상 행 현재값: CTRL='S' / CELL_COMBO_DATA_TYPE='sysAggregateOptions' / INPUT_TP_CD='O'
--   ② SCM_ADM_CMBO_SQL_M SQL_ID='sysAggregateOptions' (MDU_DIVS_CD='SYS', USE_YN='Y') 실존
--      → dataMap 원천 확보 = FPComboBox 전환 유효.
-- DDL: SCM_MST_SHEET_COLUMNS (ora.py desc 2026-08-07) — CELL_CONTROL_OBJECT_TYPE_CODE VARCHAR2(200) NULL,
--      LAST_UPDATED_BY VARCHAR2(600) NOT NULL, LAST_UPDATE_DATE DATE NULL.
-- 멱등: 차이가드 — 이미 'FPComboBox' 면 0 row update.
-- 감사: 'admin' (feedback_meta_audit_column_admin_only).
-- 적용 후 검증(값 단언): 아래 SELECT 로 CELL_CONTROL_OBJECT_TYPE_CODE='FPComboBox' 1행 확인
--   SELECT PROGRAM_ID, SHEET_NAME, COLUMN_NAME, CELL_CONTROL_OBJECT_TYPE_CODE,
--          CELL_COMBO_DATA_TYPE, INPUT_TP_CD, LAST_UPDATED_BY, LAST_UPDATE_DATE
--     FROM SCM_MST_SHEET_COLUMNS
--    WHERE PROGRAM_ID='SYS0013' AND SHEET_NAME='columns' AND COLUMN_NAME='AGGREGATE'
-- 적용 실적: 2026-08-07 06:45:53 사내 적용 완료 (1 row → 'FPComboBox'/'admin' 재조회 단언 PASS)
-- ============================================================================

UPDATE SCM_MST_SHEET_COLUMNS
   SET CELL_CONTROL_OBJECT_TYPE_CODE = 'FPComboBox',
       LAST_UPDATED_BY               = 'admin',
       LAST_UPDATE_DATE              = SYSDATE
 WHERE PROGRAM_ID  = 'SYS0013'
   AND SHEET_NAME  = 'columns'
   AND COLUMN_NAME = 'AGGREGATE'
   AND CELL_CONTROL_OBJECT_TYPE_CODE <> 'FPComboBox';

COMMIT;
