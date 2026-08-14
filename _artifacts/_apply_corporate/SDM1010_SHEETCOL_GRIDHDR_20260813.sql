-- ============================================================================
-- SDM1010 SHEET_COLUMNS 2단 헤더 그룹 + D-PJT Code 위치 보정 (2026-08-13)
-- 근거: 설계서 TAB1_GRID / TAB2_GRID 목업 (Doc/화면설계서_SDM/SDM1010_ProjectReg_화면설계서_20260806.xlsx)
--   - TAB1: [권한 등록: 등록|상태] / [프로젝트 관리자: 부서|성명] 2단 헤더
--   - TAB2: [프로젝트 관리자: 부서|성명] 2단 헤더, D-PJT Code = SOP Site 뒤 (목업 열 순서)
-- FE 소비: packages/foundation/src/utils/columnMapping.ts getColumnDepth —
--   SMALL=LARGE=그룹라벨(그룹 컬럼) + 나머지 공란 = TWO_DEPTH (사내 관례: DMF0003 carFcst 등 실측)
-- 재실행 안전(멱등): 동일 값 재-UPDATE 무해
-- ============================================================================

-- [TAB1] 권한 등록 그룹 — 등록(링크)/상태
UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET COLUMN_LABEL_NAME = 'Registration',
       SMALL_CLASS_LABEL_NAME = 'Auth Management',
       LARGE_CLASS_LABEL_NAME = 'Auth Management',
       LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
 WHERE PROGRAM_ID = 'SDM1010' AND SHEET_NAME = 'TAB1' AND COLUMN_NAME = 'DPJT_AUTH_REG_STR';

UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET COLUMN_LABEL_NAME = 'Status',
       SMALL_CLASS_LABEL_NAME = 'Auth Management',
       LARGE_CLASS_LABEL_NAME = 'Auth Management',
       LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
 WHERE PROGRAM_ID = 'SDM1010' AND SHEET_NAME = 'TAB1' AND COLUMN_NAME = 'DPJT_AUTH_REG_STATUS';

-- [TAB1+TAB2] 프로젝트 관리자 그룹 — 부서/성명 (숨김 CODE 페어 포함: visible 전환 시 그룹 유지)
UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET SMALL_CLASS_LABEL_NAME = 'Project Manager',
       LARGE_CLASS_LABEL_NAME = 'Project Manager',
       LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
 WHERE PROGRAM_ID = 'SDM1010' AND SHEET_NAME IN ('TAB1', 'TAB2')
   AND COLUMN_NAME IN ('DEPT_ID', 'DEPT_NAME', 'MGMT_USER_ID', 'USER_NAME');

-- [TAB2] D-PJT Code — 목업 열 순서 (SOP Site 180 뒤, 프로젝트 관리자 190 앞)
UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET SORT_ORDER_NO = 185,
       LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
 WHERE PROGRAM_ID = 'SDM1010' AND SHEET_NAME = 'TAB2' AND COLUMN_NAME = 'DPJT_CODE';

-- [TAB1] Division = Insert 시 필수입력 (2026-08-13 사용자 지시 — 조회조건 TAB2 전용화에 따른 후속)
--   IM(신규행 전용 편집+필수 MSG00113) + MyDivision 셀 콤보. 편집 게이트·필수 검증·빨간점은
--   FE 메타 주도 경로가 자동 소비. NAME 이 '81 Automotive Battery' 형식이라 폭 30→120.
UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET INPUT_TP_CD = 'IM',
       CELL_CONTROL_OBJECT_TYPE_CODE = 'FPComboBox',
       CELL_COMBO_DATA_TYPE = 'MyDivision',
       COLUMN_WIDTH = 120,
       LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
 WHERE PROGRAM_ID = 'SDM1010' AND SHEET_NAME = 'TAB1' AND COLUMN_NAME = 'DIVISION_NAME';

-- [전 시트] DEFAULT_FLAG='Y' (2026-08-13 — "컬럼이 다 안 보임" 실사고 정정)
--   PR_GET_SHEET_COLUMN_LIST: SDM1010 은 SHEET_PRSL_YN 미등록(비개인화) → DISPLAY_FLAG=DEFAULT_FLAG 직결.
--   설계서 UI컬럼 정의 'Default' 열은 대부분 'N'(목업 전 컬럼 표시와 모순 — 정오표 부기) → 그대로 등재돼
--   visible 컬럼이 FE display 필터에서 탈락(TAB1 15→2 / TAB2 17→1 재현 실측).
--   비개인화 화면 관례 = 전 행 'Y' (DMF0044 실측: 62/62 'Y').
UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET DEFAULT_FLAG = 'Y',
       LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
 WHERE PROGRAM_ID = 'SDM1010' AND DEFAULT_FLAG <> 'Y';
