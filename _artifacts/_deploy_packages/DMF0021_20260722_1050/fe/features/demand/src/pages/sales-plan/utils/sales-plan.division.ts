// ⭐ DMF0021 — Division 40/81*/82 분기 단일 진실원 (AS-IS DMF0021_SalesPlan.cs 1:1).
//   근거(라인 = AS-IS 5,599줄 정본):
//     · 81 계열 판정   : `Substring(0, 2) == "81"` (.cs 전반 — 81/81_UC/81_HM/81_ST/81_HD/81_HG).
//       ⚠ startsWith('81') 의무 — '===' 비교 금지 (메모리 규칙).
//     · 40 분기        : Project/PlantSite 비활성 (InitControls L455~460), END_CUSTOMER40/DEPT_ID/
//       CELL_PROD_SITE_ID 필수 (EditButton L703~716), PROJECT_CODE 슬롯 = END_CUSTOMER40 값 (SaveData L2355).
//     · 81 분기        : TEXT 필수 (L709/2013), PLANT_SITE_ID unlock (ComboSelChange L4543~4546).
//   anti-simplification: 40/81/82 3 분기 전수 — 필수 13종은 division×measure 분기 (SaveData L2198~2234).
import { DIVISION, EDIT_MEASURE } from '../sales-plan.constants';

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

// 81 시작 또는 82 = Project 계열 키 사용 (40 = END_CUSTOMER40 계열). AS-IS L2344/2355 동치.
export const usesProjectKeys = (divisionId: string): boolean => !isDiv40(divisionId);

// 타입 안전 string 변환 — string/number 만 (객체는 ''). no-base-to-string 회피.
const str = (v: unknown): string =>
  typeof v === 'string' ? v.trim() : typeof v === 'number' ? String(v) : '';

// SAVE p_project_code 슬롯 — 비40=PROJECT_CODE / 40=END_CUSTOMER40 값 (AS-IS SaveData L2355).
export const readProjectSlot = (row: Record<string, unknown>, divisionId: string): string =>
  usesProjectKeys(divisionId) ? str(row.PROJECT_CODE) : str(row.END_CUSTOMER40);

// SAVE p_text 슬롯 — 81=TEXT / 40·82=TEXT4082 (SHEET_COLUMNS division 분리 컬럼. TEXT 우선 fallback).
export const readTextSlot = (row: Record<string, unknown>, divisionId: string): string =>
  isDiv81(divisionId) ? str(row.TEXT) || str(row.TEXT4082) : str(row.TEXT4082) || str(row.TEXT);

// ============================================================================
// 저장 필수 13종 — division × measure 분기 (AS-IS SaveData L2198~2234 + UI분석서 시트 6 #12 전수):
//   ① Division ② Project(≠40) ③ EndCustomer40(40) ④ Team(40 & ≠Catch_Up) ⑤ TEXT(81)
//   ⑥ Sales Site ⑦ Model ⑧ Measure ⑨ Currency
//   ⑩ DomExp(40+Catch_Up) ⑪ FcstType(40+Catch_Up) ⑫ Incoterms(40+Catch_Up) ⑬ CellProdSite(40)
//   labelKey 는 MSG00429 {0} 치환용 — 사내 기존 LBL 정확 일치분만 재사용, 그 외 영문 리터럴 fallback
//   (신규 LBL 채번 금지 — 2026-07-14 사용자 확정).
// ============================================================================
export interface RequiredField {
  col: string;
  lblKey?: string;
  fallback: string;
  // 값 추출 커스텀 (Project 슬롯 등) — 미지정 시 row[col]
  read?: (row: Record<string, unknown>) => string;
}

export const requiredFieldsFor = (divisionId: string, measure: string): RequiredField[] => {
  const d40 = isDiv40(divisionId);
  const d81 = isDiv81(divisionId);
  const catchUp = measure === EDIT_MEASURE.CATCH_UP;
  const fields: RequiredField[] = [];
  fields.push({ col: 'DIVISION_ID', fallback: 'Division' });
  if (!d40) fields.push({ col: 'PROJECT_CODE', fallback: 'Project' });
  if (d40) fields.push({ col: 'END_CUSTOMER40', lblKey: 'LBL00080', fallback: 'End Customer' });
  if (d40 && !catchUp) fields.push({ col: 'DEPT_ID', fallback: 'Team' });
  if (d81)
    fields.push({ col: 'TEXT', fallback: 'Text', read: r => readTextSlot(r, divisionId) });
  // ⚠️ [E20260512-000502] FROM_SITE_ID / PLANT_SITE_ID 는 값-필수 아님 — AS-IS 활성 SaveData 루프(L2225+)는
  //   FROM_SITE_ID 미검사, PLANT_SITE_ID 는 `//p_plant_site_id == ""` 주석처리. L723/L2043 은 컬럼-존재
  //   체크(MSG00113)로 메타(#5 SHEET_COLUMNS 81 등록)로 충족. 값-필수 13종은 현행 그대로.
  fields.push({ col: 'SCM_SITE_ID', lblKey: 'LBL00011', fallback: 'Sales Site' });
  fields.push({ col: 'ITEM_ID', lblKey: 'LBL00669', fallback: 'Model' });
  fields.push({ col: 'MEASURE', lblKey: 'LBL00310', fallback: 'Measure' });
  fields.push({ col: 'CURRENCY', fallback: 'Currency' });
  if (d40 && catchUp) {
    fields.push({ col: 'DOM_EXP', fallback: 'Customs Handbook' });
    fields.push({ col: 'FCST_TYPE', fallback: 'FcstType' });
    fields.push({ col: 'INCOTERMS', lblKey: 'LBL00024', fallback: 'Incoterms' });
  }
  if (d40) fields.push({ col: 'CELL_PROD_SITE_ID', fallback: 'CellProdSiteID' });
  return fields;
};

export { str as readCellStr };
