export const MENU_ID = 'SCP0133' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SCP.Master.UIL SCP0133_WarehouseCapacity (spdMain 2시트: Warehouse Capacity / Warehouse Item Mapping):
//   설계 근거: .atlas/gscm-design/SCP0133/design/00_checklist.md ~ 03_grid-columns.md
//   격리 세션 — GSCM 원본 `.cs`/`.Designer.cs` 미확보 + AS-IS MSSQL 접속 실패(design 00~03 3중 ERROR).
//   GET  main(WhCapa)      : SCP.SCP0133_GET_WAREHOUSE_CAPACITY — TO-BE PKG_SCP0133 미배포(convert-sp 후속)
//   Warehouse Item Mapping : 전용 GET SP 없음(design 03 §6-9 확인 필요) — 이 activity 는 조회 배선하지 않는다
//   SAVE main(WhCapa)      : SCP.SCP0133_SAVE_WAREHOUSE_CAPACITY
//   SAVE itemMapping       : SCP.SCP0133_SAVE_WAREHOUSE_ITEM_MAPPING
//   조회조건: Division(콤보 SQL_ID 확인필요) -> PlanGroup/Site/Stage/Warehouse cascade(전부 확인필요,
//     design 02 §7) + Valid(확정 YesOrNo) + Period(From/To) + Item ID(팝업 MaterialByDivisionModal, 확정)
//   편집: EditButton "수정 모드" 토글 어포던스는 TO-BE 미이식(전 화면 공통 결정,
//     `.atlas/memory/editbutton-toggle-not-ported.md`) — 조회 직후에도 화이트리스트 외 컬럼은
//     바로 편집 가능(`utils/warehouseCapacityEditLock.ts`).
export enum SHEETS {
  MAIN = 'main', // spdMain 시트1 "Warehouse Capacity" (SCM_MST_SHEET_COLUMNS SHEET_NAME, 15컬럼)
  // Warehouse Item Mapping 시트는 전용 GET SP 가 없어(design 03 §6-9 확인 필요) 이번 회차는
  // procedures.d.ts 계약을 만들지 않는다 — SHEETS 에도 아직 추가하지 않는다(§2.3 메타 임의생성 금지와
  // 같은 원칙: 존재하지 않는 SP 계약을 추측으로 먼저 만들지 않는다).
}

// NSCM 단일 cursor 표준 'o_rc1'
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// admin UI Category Setup(SCM_MST_SHEET_COLUMNS) SHEET_NAME — AS-IS SpdSheet 상수 그대로(design 03 §0).
//   컬럼 메타 DB 등록 확인: PROGRAM_ID='SCP0133' 31행(15+16) 실측 완료(design 03 §1 대사 일치).
export const ADMIN_SHEET_NAME = {
  MAIN: 'Warehouse Capacity',
  ITEM_MAPPING: 'Warehouse Item Mapping',
} as const;

// 조회조건 콤보 ID — design 02 §2/§5 실측. Division/PlanGroup/Site/Stage/Warehouse 5개 전부
//   "강한 후보" 또는 "확인 필요" 상태다(GSCM 원본·AS-IS DB 이중 차단, design 02 §7 15건).
//   여기 상수로 배선하되, 실제 조회 결과가 AS-IS 와 다를 수 있음을 화면 주석에도 남긴다.
export const COMBO = {
  // 확인 필요(design 02 §2.2) — Division/Division_SCP/MyDivision 3후보 중 미확정.
  //   EE 제외(ATTRIBUTE3<>'EE') 여부가 후보마다 다르므로 임의 채택 금지 — 권한필터 있는
  //   Division_SCP 를 기본값으로 쓰지 않는다(convert-core §2.6 경고 그대로).
  //   확정 전까지는 EE 제외 없는 'Division_SCP'(권한필터만 적용)로 보수적으로 배선한다 —
  //   더 넓은 후보(Division, 권한필터도 없음)보다는 안전하나, 이 값 자체가 확인 필요다.
  DIVISION: 'Division_SCP',
  // 강한 후보(design 02 §2.3) — SQL_ID 존재 확인(ora.py). Division 컬럼 반환 → FE 클라 필터.
  PLAN_GROUP: 'PlanGroup_SCP_ALL',
  // 확인 필요, 근거 약함(design 02 §2.5) — SiteMasterAll_SCP 는 @siteType 고정값 미상.
  SITE: 'SiteMasterAll_SCP',
} as const;

// Stage 콤보는 SCM_ADM_CMBO_SQL_M 이 아니라 lookup master 후보(design 02 §2.4, 확인 필요) —
//   OPMZ_STAGE_CD 가 강한 후보이나 SEGMENT1=division 외 계층 의미 미확정.
export const STAGE_LOOKUP_TYPE = 'OPMZ_STAGE_CD';

// Warehouse 콤보는 SCM_ADM_CMBO_SQL_M/LOOKUP_MASTER_DETAIL 어디에도 전용 SQL_ID 가 없다
//   (design 02 §2.6 — 확인 필요, 전용 마스터 없음 실측 확인). 이번 회차는 조회조건 Warehouse
//   다중선택을 위한 서버 콤보 원천이 없어 빈 옵션으로 남기고(§5 확인 필요 항목), 추측 등록하지 않는다.

// Valid — 확정(design 02 §2.1).
export const VALID_COMBO_ID = 'YesOrNo';

// 셀 콤보 SQL_ID(그리드 컬럼 CELL_COMBO_DATA_TYPE, design 03 §1) — PlanGroup 은 등록 확인(ora.py),
//   Site/Warehose(오탈자 그대로)/StorLoc 은 SCM_ADM_CMBO_SQL_M 0건(design 03 §6-1, 미등록).
//   등록 전까지 해당 셀 콤보는 빈 드롭다운이 정상이다 — 05_register.sql 이 신규 등록을 시도한다.
export const CELL_COMBO = {
  PLAN_GROUP: 'PlanGroup',
  SITE: 'Site',
  WAREHOUSE: 'Warehose', // 오탈자 그대로 등록된 DB 값(design 03 §1.2) — 신규 화면이라도 임의 교정 금지
  STOR_LOC: 'StorLoc',
} as const;

// 다국어 LABEL — SCM_ADM_MSG_M 실측(design 02 §4.5). Warehouse/Item ID 는 정확 일치 라벨이 없어
//   신규 등록 대상(05_register.sql) — 등록 전까지는 영문 defaultValue fallback 만 쓴다(Hook #114).
export const LBL = {
  DIVISION: 'LBL00001', // Division
  PLAN_GROUP: 'LBL00002', // Plan Group
  SITE: 'LBL00015', // Site
  STAGE: 'LBL00061', // Stage
  VALID: 'LBL00639', // Valid
  PERIOD: 'LBL00013', // Period
  ITEM_ID: 'LBL01142', // 근접 라벨 "Item" — "Item ID" 정확 일치 아님(design 02 §4.5, 확인 필요)
} as const;

// AS-IS MSG ID 는 TO-BE 그대로 재사용하지 않는다(Hook #114). design 02 §4 는 AS-IS 번호(MSG00001/
//   MSG00046/MSG00219)를 그대로 인용하지만, ora.py 로 TO-BE `SCM_ADM_MSG_M` 문구를 역조회한 결과
//   TO-BE MSG00001 = "Would you like to save it?"(저장 확인)로 AS-IS 의미(필수조건 공백)와 다르다 —
//   AS-IS 번호를 그대로 옮기면 엉뚱한 문구가 뜬다(2026-09-10 SCP0020 사고 재발 방지). 문구 기준으로
//   재매핑했다.
export const MSG = {
  NO_CHANGE: 'MSG00004', // No changes to save. (TO-BE 문구 확인, 자매 SCP0023 재사용)
  // 필수조건 공백(AS-IS MSG00001 의도) — TO-BE 문구 일치 확인(design 02 §4 FindButton 가드).
  REQUIRED_FIELD: 'MSG00013', // Please enter the required fields.
  // 편집중 재조회 차단(AS-IS MSG00046 의도) — TO-BE 문구 일치 확인(design 02 §4 FindButton 가드).
  UNSAVED_RESEARCH: 'MSG00703', // There are unsaved changes. Do you want to search again?
  // From>To 차단(AS-IS MSG00219) — TO-BE 문구 완전 일치 확인(design 03 §5 #9).
  INVALID_PERIOD: 'MSG00219', // Invalid period (start > end).
  // 숫자 하한/음수 클램프(AS-IS MSG00085) — TO-BE 문구 완전 일치 확인(design 03 §3 #27).
  NUMBER_NON_NEGATIVE: 'MSG00085', // Only values greater than or equal to {0} are allowed.
} as const;
