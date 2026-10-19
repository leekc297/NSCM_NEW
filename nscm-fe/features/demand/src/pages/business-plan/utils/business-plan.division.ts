// ⭐ DMF0042 — Division 40/81*/82 분기 단일 진실원 (AS-IS DMF0042_1_BizPlan.cs 3,477줄 정본 1:1).
//   근거(라인 = AS-IS 정본):
//     · 81 계열 판정   : `Substring(0, 2) == "81"` (.cs 전반 — 81/81_UC/81_HM/81_ST/81_HD/81_HG).
//       ⚠ startsWith('81') 의무 — '===' 비교 금지 (메모리 규칙).
//     · 40 분기        : Project/PlantSite 비활성 (InitControls L259~261), END_CUSTOMER40/SCM_SITE_ID40/
//       ITEM_ID40/DEPT_ID40/CELL_PROD_SITE 키 (SaveData L897~1057), p_PROJECT_CODE 슬롯 = END_CUSTOMER40 값.
//     · 81 분기        : PROJECT_CODE/SCM_SITE_ID81/DEPT_ID/END_CUSTOMER/PLANT_SITE_ID 키 +
//       CELL_PER_CAR/MODULE_PER_CAR 파생(잠금 — SP 산출).
//     · 82 분기        : PROJECT_CODE82/SCM_SITE_ID82/DEPT_ID/UNIT_ENERGY/ITEM_USE 키.
//   anti-simplification: 필수값은 division 분기 전수 — MinColumnChk L3299~3360 + SaveData L887~1057.
import { DIVISION } from '../business-plan.constants';

export type DivisionKind = 'D40' | 'D81' | 'D82';

export const divisionKindOf = (divisionId: string): DivisionKind => {
  const d = (divisionId ?? '').trim();
  if (d.startsWith('81')) return 'D81';
  if (d === DIVISION.ESS) return 'D82';
  return 'D40';
};

export const isDiv40 = (divisionId: string): boolean => divisionKindOf(divisionId) === 'D40';
export const isDiv81 = (divisionId: string): boolean => divisionKindOf(divisionId) === 'D81';
export const isDiv82 = (divisionId: string): boolean => divisionKindOf(divisionId) === 'D82';

// 타입 안전 string 변환 — string/number 만 (객체는 ''). no-base-to-string 회피.
const str = (v: unknown): string =>
  typeof v === 'string' ? v.trim() : typeof v === 'number' ? String(v) : '';

type Rec = Record<string, unknown>;

// ============================================================================
// SAVE 파라미터 division 슬롯 — AS-IS SaveData L897~1057 3분기 1:1:
//   40: p_PROJECT_CODE=END_CUSTOMER40 / SCM_SITE_ID40 / ITEM_ID40 / DEPT_ID40 / BIZ_TYPE_NAME40 / CELL_PROD_SITE
//   81: PROJECT_CODE / SCM_SITE_ID81 / ITEM_ID / DEPT_ID / END_CUSTOMER / PLANT_SITE_ID / BIZ_TYPE_NAME81
//   82: PROJECT_CODE82 / SCM_SITE_ID82 / ITEM_ID / DEPT_ID / UNIT_ENERGY / ITEM_USE / BIZ_TYPE_NAME82(부재 시 81 fallback)
// ============================================================================
export const readProjectSlot = (row: Rec, divisionId: string): string => {
  if (isDiv40(divisionId)) return str(row.END_CUSTOMER40); // 40 = END_CUSTOMER40 값 (AS-IS L912 계보)
  if (isDiv82(divisionId)) return str(row.PROJECT_CODE82) || str(row.PROJECT_CODE);
  return str(row.PROJECT_CODE);
};

export const readScmSiteSlot = (row: Rec, divisionId: string): string => {
  if (isDiv40(divisionId)) return str(row.SCM_SITE_ID40);
  if (isDiv82(divisionId)) return str(row.SCM_SITE_ID82) || str(row.SCM_SITE_ID81);
  return str(row.SCM_SITE_ID81);
};

export const readItemSlot = (row: Rec, divisionId: string): string =>
  isDiv40(divisionId) ? str(row.ITEM_ID40) : str(row.ITEM_ID);

export const readDeptSlot = (row: Rec, divisionId: string): string =>
  isDiv40(divisionId) ? str(row.DEPT_ID40) : str(row.DEPT_ID);

export const readEndCustomerSlot = (row: Rec, divisionId: string): string =>
  isDiv40(divisionId) ? str(row.END_CUSTOMER40) : str(row.END_CUSTOMER);

export const readBizTypeSlot = (row: Rec, divisionId: string): string => {
  if (isDiv40(divisionId)) return str(row.BIZ_TYPE_NAME40);
  // 82 전용 BIZ_TYPE_NAME82 는 TO-BE SHEET_COLUMNS 미등재 (실측 2026-07-15) — 81 컬럼 fallback
  return str(row.BIZ_TYPE_NAME82) || str(row.BIZ_TYPE_NAME81);
};

export const readIncotermsSlot = (row: Rec, divisionId: string): string =>
  isDiv82(divisionId) ? str(row.INCOTERMS82) || str(row.INCOTERMS) : str(row.INCOTERMS);

/**
 * Energy 저장 슬롯 — SP 에 에너지 파라미터는 `P_UNIT_ENERGY` 하나뿐이다.
 *   40 화면 컬럼은 `ENERGE_WH`, 82 는 `UNIT_ENERGY` 로 이름이 갈리므로 여기서 합친다.
 *
 * 금지: 40 기존행까지 ENERGE_WH 를 싣기. `UNIT_ENERGY` 는 저장 SP 의 **키 컬럼**이다
 *   (P_DMF0042_SAVE_DM_PLN_BP_FCST L830~868 삭제 조인 · L940~962 중복제거 조인이
 *   `A.UNIT_ENERGY = NVL(B.UNIT_ENERGY, 0)` 로 매칭). ENERGE_WH 는 품목 마스터 파생값이라
 *   원장의 UNIT_ENERGY 와 다를 수 있고(AS-IS 40 은 p_UNIT_ENERGY 를 보낸 적이 없어 원장이 0),
 *   기존행에 그 값을 실으면 키가 어긋나 update 가 아니라 **중복 행**이 생긴다.
 *   신규행은 그 행이 원장에 처음 들어가는 순간이라 안전하다.
 */
export const readUnitEnergySlot = (row: Rec, divisionId: string): string =>
  isDiv40(divisionId) && str(row.CRUD_TYPE) === 'I'
    ? str(row.ENERGE_WH) || str(row.UNIT_ENERGY)
    : str(row.UNIT_ENERGY);

// ============================================================================
// 셀 팝업(Model/Project) 사전 검색조건 — 더블클릭한 **그 신규행의 값**을 팝업 조회조건으로 올린다.
//   팝업은 preSearchParams 를 열리자마자 조회 filters 로 그대로 쓴다(enabled: open) — 별도 조회 트리거 없음.
//   행 값이 없는 칸은 'ALL'(Project 는 공란) — 팝업이 조건 미지정으로 해석하는 값이다.
//   주의: 조회조건(Search Area) 값은 쓰지 않는다. 사용자가 그 행에서 고른 값이 기준이다 (2026-08-25 확정).
// ============================================================================
export interface CellPopupSearch {
  divisionId: string;
  deptId: string;
  endCustomer: string;
  salesSite: string;
  projectCode: string;
  // ITEM 팝업 전용 — 모델 검색어. 팝업을 열 때는 항상 공란(직전 검색어가 따라붙지 않게).
  itemId?: string;
  // PROJECT 팝업 전용 — AS-IS 호출 파라미터 고정값.
  etc?: string;
}

export const buildCellPopupSearch = (
  row: Rec,
  divisionId: string,
  target: 'ITEM' | 'PROJECT'
): CellPopupSearch => {
  // Project — 팝업에서 고를 값 자신이므로 PROJECT 호출에는 싣지 않는다.
  //   40 은 Project 조건 자체가 없다(팝업도 40 이면 숨긴다). readProjectSlot 의 40 슬롯은
  //   END_CUSTOMER40 값(저장 payload 규약)이라 조회조건으로 쓰면 엉뚱하게 좁힌다.
  const projectCode =
    target === 'PROJECT' || isDiv40(divisionId) ? '' : readProjectSlot(row, divisionId);
  const base: CellPopupSearch = {
    divisionId,
    deptId: readDeptSlot(row, divisionId) || 'ALL',
    endCustomer: readEndCustomerSlot(row, divisionId) || 'ALL',
    salesSite: readScmSiteSlot(row, divisionId) || 'ALL',
    projectCode,
  };
  return target === 'ITEM' ? { ...base, itemId: '' } : { ...base, etc: 'N' };
};

// ============================================================================
// 저장 필수값 — division 분기 전수 (AS-IS MinColumnChk L3299~3360 컬럼셋 + SaveData L887~1057 값검증 +
//   상세동작 §4.3: 40=고객/사이트/모델/인코텀즈/예측유형/통화/셀생산지 · 81=프로젝트/사이트/공장/모델/부서/고객/통화
//   · 82=부서/에너지/통화(+프로젝트/사이트/모델)).
//   labelKey 는 MSG00429 {0} 치환용 — 기존 LBL 정확 일치분만 재사용, 그 외 영문 리터럴 fallback
//   (신규 LBL 채번 금지 — DMF0021 2026-07-14 사용자 확정 승계).
// ============================================================================
export interface RequiredField {
  col: string;
  lblKey?: string;
  fallback: string;
  read?: (row: Rec) => string;
}

export const requiredFieldsFor = (divisionId: string): RequiredField[] => {
  const d40 = isDiv40(divisionId);
  const d81 = isDiv81(divisionId);
  const fields: RequiredField[] = [];
  fields.push({ col: 'DIVISION_ID', fallback: 'Division' });
  if (d40) {
    fields.push({ col: 'END_CUSTOMER40', lblKey: 'LBL00080', fallback: 'End Customer' });
    fields.push({ col: 'SCM_SITE_ID40', lblKey: 'LBL00011', fallback: 'Sales Site' });
    fields.push({ col: 'ITEM_ID40', lblKey: 'LBL00669', fallback: 'Model' });
    fields.push({ col: 'INCOTERMS', lblKey: 'LBL00024', fallback: 'Incoterms' });
    fields.push({ col: 'FCST_TYPE', fallback: 'FcstType' });
    fields.push({ col: 'CELL_PROD_SITE', fallback: 'Cell Prod Site' });
  } else if (d81) {
    fields.push({ col: 'PROJECT_CODE', fallback: 'Project' });
    fields.push({ col: 'SCM_SITE_ID81', lblKey: 'LBL00011', fallback: 'Sales Site' });
    fields.push({ col: 'PLANT_SITE_ID', lblKey: 'LBL00005', fallback: 'Plant Site' });
    fields.push({ col: 'ITEM_ID', lblKey: 'LBL00669', fallback: 'Model' });
    fields.push({ col: 'DEPT_ID', fallback: 'Team' });
    fields.push({ col: 'END_CUSTOMER', lblKey: 'LBL00080', fallback: 'End Customer' });
    // ⭐ 2026-07-21 G8 교정 — 신정본 SaveData L997~998: 81 도 FCST_TYPE/INCOTERMS 필수 (구정본 승계 누락분)
    fields.push({ col: 'FCST_TYPE', fallback: 'FcstType' });
    fields.push({ col: 'INCOTERMS', lblKey: 'LBL00024', fallback: 'Incoterms' });
  } else {
    // 82 — ⭐ 2026-07-21 G8 교정: 신정본 SaveData L1024~1026 = DEPT_ID/CURRENCY/UNIT_ENERGY 만.
    //   PROJECT_CODE82 는 저장 슬롯일 뿐 필수 아님 (구현이 필수로 요구하던 과잉 제거 — AS-IS 는 공란 저장 허용).
    fields.push({ col: 'DEPT_ID', fallback: 'Team' });
    fields.push({ col: 'UNIT_ENERGY', fallback: 'Unit Energy' });
  }
  fields.push({ col: 'MEASURE', lblKey: 'LBL00310', fallback: 'Measure' });
  fields.push({ col: 'CURRENCY', fallback: 'Currency' });
  return fields;
};

export { str as readCellStr };
