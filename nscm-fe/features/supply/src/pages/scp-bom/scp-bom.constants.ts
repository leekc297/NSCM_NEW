// AS-IS GSCM.SCP.Master.UIL SCP0053_SCPBOM (단일 그리드 마스터, UPDATE 전용, pivot 없음):
//   설계 근거: .atlas/gscm-design/SCP0053/design/00_checklist.md ~ 03_grid-columns.md · convert-flow/{goal,plan}.md
//   - GET  SP : PKG_SCP0053.P_SCP0053_GET_SCP_BOM  (IN 7, 커서 o_rc 20필드) — 배포 VALID
//   - SAVE SP : PKG_SCP0053.P_SCP0053_SAVE_SCP_BOM (IN 15, '^' bulk 파싱, 'S'/'F' + 에러행) — 배포 VALID
//   - Division 은 OnShown 강제 '81'(Automotive Battery) + disabled 고정(design 01 R7)
//   - 편집 3컬럼(SCP_PLAN_YN/SI_ALT_PRIORITY/SI_SCP_YN, INPUT_TP_CD='M') 외 잠금. SCP_PLAN_YN 이 'Y'/'N'
//     아닌 행은 행 전체 편집 차단 + Gray(design 03 §3 W6/W7). INSERT/DELETE 는 노출 + NO-OP(R4/R5).
export const MENU_ID = 'SCP0053' as const;
export type MENU_ID = typeof MENU_ID;

// BE 프로시저 라우팅 키(SCM_ADM_MNU_BTN_MPG_M.SHT_NM) = 'SCP BOM'(DB 실측 2026-09-26).
//   AS-IS SpdSheet 상수·컬럼메타 SHEET_NAME 과 동일 단일 시트.
export enum SHEETS {
  MAIN = 'SCP BOM',
}

// 커서 읽기키 — PROC_M COL_NM 실측 'o_rc'(SORT 100, OUT). NSCM 일반 표준 'o_rc1' 아님에 주의
//   (memory proc-cursor-key-colnm-vs-fe-read — FE 읽기키가 COL_NM 과 불일치하면 빈 그리드).
export const RESPONSE_KEY = 'o_rc' as const;

// admin UI Category Setup(SCM_MST_SHEET_COLUMNS) SHEET_NAME — AS-IS 원본명 그대로(design 03 §1, 실측 27행).
export const ADMIN_SHEET_NAME: Record<SHEETS, string> = {
  [SHEETS.MAIN]: 'SCP BOM',
};

// 조회조건 콤보 SQL_ID (design 02 §2 — DB 실측 USE_YN='Y' 확인 2026-09-26). 이름 유사 재사용 아님:
//   MyDivision = EE제외 + VALID + unit 권한 + @mnuId 게이트 SQL 내장(화면 재구현 불요).
//   PlantByDivisionAll_SCP = @divisionId 콤마 다중(NULL=전체), OSP 제외(osp_yn='N') 내장.
export const COMBO = {
  DIVISION: 'MyDivision',
  PLANT_SITE: 'PlantByDivisionAll_SCP',
} as const;

// Division 고정값 — AS-IS OnShown SelectCombo(cboDivision,"CODE","81") + Enabled=false(design 01 R7, cs:736).
//   '81' = Automotive Battery (ora 실측 2026-09-26). 후보에 '81' 없으면(권한 없음) 조회 차단(R8).
export const DEFAULT_DIVISION = '81';

// 편집 컬럼(INPUT_TP_CD='M', design 03 §1.1 SORT16~18). 상수 이식이 아니라 잠금행 판정용 참조.
export const EDITABLE_COLUMNS = ['SCP_PLAN_YN', 'SI_ALT_PRIORITY', 'SI_SCP_YN'] as const;

// 행 편집잠금 기준 컬럼 — 이 값이 'Y'/'N'(대소문자 무관) 아니면 행 전체 잠금 + Gray(design 03 §3 W6/W7).
export const ROW_LOCK_COLUMN = 'SCP_PLAN_YN';

// 세로 계층 병합 대상 = 표시 잠금 컬럼(SORT1~15). 편집 3컬럼(M)은 병합 제외(편집 UX 보존, design 03 §3.4).
export const MERGE_COLUMNS: ReadonlySet<string> = new Set([
  'DIVISION_ID',
  'PLANT_ID',
  'MODEL_ID',
  'MODEL_NAME',
  'NLEVEL',
  'PARENT_ITEM_ID',
  'PARENT_ITEM_NAME',
  'CHILD_ITEM_ID',
  'CHILD_ITEM_NAME',
  'COMMON_CELL_YN',
  'ALT_ID',
  'ALT_PRIORITY',
  'EFF_START_DATE',
  'EFF_END_DATE',
  'ECO_CODE',
]);

// 셀 잠금행 배경색 — hook #95 grid-cell-backcolor-standard(잠금행 Gray).
export const ROW_LOCK_BG = '#f0f0f0';

// 다국어 LABEL (design 02 §4.5 — 전건 SCM_ADM_MSG_M 존재, 신규 등록 0. AS-IS 번호 임의 재사용 금지 #114).
export const LBL = {
  SEARCH: 'LBL00112', // Search (표준 LBL00112)
  DIVISION: 'LBL00001', // Div.
  PLANT_SITE: 'LBL00005', // Plant Site
  MODEL: 'LBL00618', // Model/Nickname
  PARENT_ITEM: 'LBL00033', // Parent Item
  CHILD_ITEM: 'LBL00034', // Child Item
  ALTER_BOM: 'LBL01051', // Alter BOM
} as const;

// AS-IS MSG 를 문구 기준 SCM_ADM_MSG_M 역조회한 TO-BE 코드(design 01 §2.6 / 02 §4.5, hook #114).
//   AS-IS MSG00333/334/335/336 동번호는 TO-BE 에서 의미가 달라 재사용 금지 → 등가 MSG01329~1332 사용.
export const MSG = {
  REQUIRE_ONE_ITEM: 'MSG01329', // Plese input at least one of Model ID, Parent ID, Child ID (V1)
  MODEL_NOT_PACK: 'MSG01330', // Inputed Model ID is not Pack Type (V2)
  PARENT_NOT_PACK: 'MSG01331', // Inputed Parent ID is not Pack Type (V3)
  CHILD_NOT_CELL: 'MSG01332', // Inputed Child ID is not Cell Type (V4)
  REQUIRE_DIVISION: 'MSG00097', // Please select Division. (R8 권한 0건 게이트)
  SAVE_SUCCESS: 'MSG00672', // {0}개의 데이터가 저장되었습니다. (AS-IS MSG00004 등가 — 저장 건수 V6)
  SAVE_FAIL: 'MSG00006', // Failed to save. (AS-IS MSG00006 등가 — 저장 실패 V7)
  NO_CHANGE: 'MSG00004', // No changes to save. (저장 대상 0건)
} as const;
