// AS-IS GSCM.SCP.Master.UIL SCP0097_SCP_BOM_Elec (단일 그리드 마스터, UPDATE 전용, pivot 없음):
//   설계 근거: .atlas/gscm-design/SCP0097/design/00_checklist.md ~ 03_grid-columns.md · convert-flow/{goal,plan}.md
//   - GET  SP : PKG_SCP0097.P_SCP0097_GET_SCP_BOM_ELEC  (IN 4, 커서 O_RC1 13필드) — 배포 VALID
//   - SAVE SP : PKG_SCP0097.P_SCP0097_SAVE_SCP_BOM_ELEC (IN 8, '^' bulk 파싱, 'S'/'F' 상태커서) — 배포 VALID
//   - Division 은 선택 가능(자매 SCP0053 과 달리 disabled 아님). 기본값 '81'(Automotive Battery) 존재 시
//     선택, 미존재 시 마지막 항목(design 01 R6b — AS-IS SelectCombo 등가). Plant Site/Alter BOM/모달 없음.
//   - 편집 2컬럼(SCP_YN/STOCK_SUM, INPUT_TP_CD='M') 외 잠금. SCP_YN 이 'Y'/'N' 아닌 행은 행 전체 편집
//     차단 + Gray(design 03 §3 W7/W8). INSERT/DELETE 는 노출 + NO-OP(design 01 R4, base 빈 본문).
export const MENU_ID = 'SCP0097' as const;
export type MENU_ID = typeof MENU_ID;

// BE 프로시저 라우팅 키(SCM_ADM_MNU_BTN_MPG_M.SHT_NM) = 'SCP BOM Elec'.
//   AS-IS SpdSheet 상수(cs:53 shtMain)·컬럼메타 SHEET_NAME(DB 실측 13행)과 동일 단일 시트.
export enum SHEETS {
  MAIN = 'SCP BOM Elec',
}

// 커서 읽기키 = SCM_ADM_PROC_M OUT 데이터커서 COL_NM (memory proc-cursor-key-colnm-vs-fe-read — FE 읽기키는
//   COL_NM 정본, SP argument_name/고정 'o_rc1' 아님). iter-2 에서 PROC_M 등록 완료(05_register.sql (h)):
//   GET 데이터커서 COL_NM='o_rc1'(소문자 — 자매 SCP0053 'o_rc' 계열 규약) 실측 확정 → 여기와 문자 일치.
//   추가 방어: ScpBomElec.tsx 의 rows 읽기가 대소문자 변형까지 흡수(COL_NM casing 재변경 시 빈 그리드 방지).
export const RESPONSE_KEY = 'o_rc1' as const;

// admin UI Category Setup(SCM_MST_SHEET_COLUMNS) SHEET_NAME — AS-IS 원본명 그대로(design 03 §1, 실측 13행).
export const ADMIN_SHEET_NAME: Record<SHEETS, string> = {
  [SHEETS.MAIN]: 'SCP BOM Elec',
};

// 조회조건 콤보 SQL_ID (design 02 §2 — DB 실측 USE_YN='Y' 확인). 이름 유사 재사용 아님:
//   MyDivision = EE제외(ATTRIBUTE3<>'EE') + VALID + unit 권한 + @mnuId 게이트 SQL 내장(화면 재구현 불요).
export const COMBO = {
  DIVISION: 'MyDivision',
} as const;

// Division 기본값 — AS-IS OnShown SelectCombo(cboDivision,"CODE","81")(design 01 R6b, cs:513~519).
//   '81' = Automotive Battery(ora 실측). 후보에 '81' 존재 시 선택, 미존재 시 마지막 항목(자매와 달리 선택 가능).
export const DEFAULT_DIVISION = '81';

// 편집 컬럼(INPUT_TP_CD='M', design 03 §1.3 SORT 42~43). 상수 이식이 아니라 잠금행 판정용 참조.
export const EDITABLE_COLUMNS = ['SCP_YN', 'STOCK_SUM'] as const;

// 행 편집잠금 기준 컬럼 — 이 값이 'Y'/'N'(대소문자 무관) 아니면 행 전체 잠금 + Gray(design 03 §3 W7/W8).
export const ROW_LOCK_COLUMN = 'SCP_YN';

// 세로 계층 병합 대상 = 표시 잠금 컬럼(design 03 §3.4 확정 4컬럼). Child Item(BOM leaf)에서 병합 중단,
//   편집 2컬럼(M)은 병합 제외(편집 UX 보존). 서버 ORDER BY 정본 — FE 재정렬 금지.
export const MERGE_COLUMNS: ReadonlySet<string> = new Set([
  'DIVISION_ID',
  'PARENT_ITEM_ID',
  'PARENT_ITEM_NAME',
  'ELECTRODE_TYPE',
]);

// 셀 잠금행 배경색 — hook #95 grid-cell-backcolor-standard(잠금행 Gray).
export const ROW_LOCK_BG = '#f0f0f0';

// 다국어 LABEL (design 02 §4.5 — 전건 SCM_ADM_MSG_M 존재, 신규 등록 0. AS-IS 번호 임의 재사용 금지 #114).
export const LBL = {
  DIVISION: 'LBL00001', // Div.
  PARENT_ITEM: 'LBL00033', // Parent Item
  CHILD_ITEM: 'LBL00034', // Child Item
  SEARCH: 'LBL00112', // Search (표준 LBL00112)
} as const;

// AS-IS MSG 를 문구 기준 SCM_ADM_MSG_M 역조회한 TO-BE 코드(design 01 §2.6 / 02 §4.5, hook #114).
//   AS-IS 동번호(MSG00002 저장성공문구·MSG00004 문구불일치)는 의미가 달라 재사용 금지 → 등가 코드 사용.
export const MSG = {
  REQUIRE_DIVISION: 'MSG00097', // Please select Division. (R1 Division 필수 + R6a 권한 0건 게이트)
  SAVE_SUCCESS: 'MSG00606', // 저장되었습니다. (건수 미표시 — 사용자 지시 2026-10-13)
  SAVE_FAIL: 'MSG00006', // Failed to save. (V3 — AS-IS MSG00006 의미 일치)
  NO_CHANGE: 'MSG00004', // No changes to save. (저장 대상 0건)
} as const;
