// ⭐ DMF0003 Phase 2f — Division 40/81/82 분기 단일 진실원 (보강스펙 §6 + AS-IS 1:1).
//   근거(라인 = AS-IS DMF0003_MktFcst.cs, GSCM.DM.Plan.UIL):
//     · 키 컬럼      : fnValidation L4861~4881 / SaveData L1509~1522 — 40=Customer40/ScmSiteId40/ItemId40,
//                      81·82=Project/ScmSiteId/ItemId.
//     · PlantSite 필수: SetSaveData L4365 / ValidationCheck L5227 — 81 만 필수(40·82 해당없음).
//     · 중복검증 키  : fnValidation L4892~4956 — 81=+PlantSite, 82=PlantSite 제외, 40=Customer40 계열.
//     · SspSync      : SaveData L1610~1617 — Div40 & MKT_FCST_RP 만 동기화 결과 popup.
//     · VMI_YN/STD_DIO: 보강스펙 §6 / .cs L3056~3078 — 82 만 표시(컬럼 division allow 메타로 처리).
//   anti-simplification: 40/81/82 3 분기 전수. "81 시작" 판정은 Substring(0,2)=="81" (.cs 전반).
import { DIVISION } from '../mkt-fcst.constants';

export type DivisionKind = 'D40' | 'D81' | 'D82';

// AS-IS clbDivision.ControlValues 판정 — "81" 로 시작(81xx) 또는 "82" 또는 "40"(그 외 default).
//   .cs 전반: `clbDivision.ControlValues.Substring(0, 2) == "81"` / `== "82"` / else(40).
export const divisionKindOf = (divisionId: string): DivisionKind => {
  const d = (divisionId ?? '').trim();
  if (d.startsWith('81')) return 'D81';
  if (d === DIVISION.ESS) return 'D82';
  return 'D40';
};

// 81 시작 또는 82 = Project 계열 키 사용 (그 외 40 = Customer40 계열). AS-IS L1509/L4892 동치.
export const usesProjectKeys = (divisionId: string): boolean => {
  const k = divisionKindOf(divisionId);
  return k === 'D81' || k === 'D82';
};

// PlantSite 필수 여부 — Div81 만 (SetSaveData L4365 "40, 82은 해당없음", ValidationCheck L5227).
export const requiresPlantSite = (divisionId: string): boolean =>
  divisionKindOf(divisionId) === 'D81';

// SSP 동기화 대상 — Div40 & measure='MKT_FCST_RP' (SaveData L1610, CellDblClick L2628).
export const isSspSyncTarget = (divisionId: string, measure: string): boolean =>
  divisionKindOf(divisionId) === 'D40' && measure === 'MKT_FCST_RP';

// ⭐ 편집 가능 division 판정 — 편집가능 집합(메타 DM_EDITABLE_DIVISION_ALLOW → CMBO 'MktFcstEditableDivision')
//   멤버십 검사. 현행 업무규칙: 82 만 편집 가능. 40 / 81 / 81_HD·HG·HM·ST·UC / EE·EE_* = 편집제약
//   (셀 편집불가 + Insert/Delete/Save 버튼 미표시, 40·81 Insert 불가). 하드코딩 division 집합 금지 —
//   편집가능 집합은 메타에서 fetch 해 주입(메타 부재 시 호출측 fallback = {'82'}).
export const isEditableDivision = (divisionId: string, editableSet: ReadonlySet<string>): boolean =>
  editableSet.has((divisionId ?? '').trim());

// row 의 identity 키 컬럼명 묶음 (division 분기). SAVE payload·중복검증 공용.
//   project/scmSite/item 은 division 별 실 컬럼명(40=*_40)을 가리킨다.
export interface DivisionKeyColumns {
  project: string; // 40=CUSTOMER_40 / 81·82=PROJECT_CODE
  scmSite: string; // 40=SCM_SITE_ID_40 / 81·82=SCM_SITE_ID
  item: string; // 40=ITEM_ID_40 / 81·82=ITEM_ID
}

export const divisionKeyColumns = (divisionId: string): DivisionKeyColumns =>
  usesProjectKeys(divisionId)
    ? { project: 'PROJECT_CODE', scmSite: 'SCM_SITE_ID', item: 'ITEM_ID' }
    : { project: 'CUSTOMER_40', scmSite: 'SCM_SITE_ID_40', item: 'ITEM_ID_40' };

// 타입 안전 string 변환 — string/number 만 (객체는 ''). no-base-to-string 회피.
const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// row 에서 division 별 identity 값 추출. fallback: *_40 미존재 시 기본 컬럼 (조회 응답 alias 차이 대비).
export const readIdentity = (
  row: Record<string, unknown>,
  divisionId: string
): { project: string; scmSite: string; item: string } => {
  const cols = divisionKeyColumns(divisionId);
  if (usesProjectKeys(divisionId)) {
    return {
      project: str(row[cols.project]),
      scmSite: str(row[cols.scmSite]),
      item: str(row[cols.item]),
    };
  }
  // Div40 — *_40 우선, 없으면 기본 키로 fallback.
  return {
    project: str(row[cols.project] ?? row.PROJECT_CODE),
    scmSite: str(row[cols.scmSite] ?? row.SCM_SITE_ID),
    item: str(row[cols.item] ?? row.ITEM_ID),
  };
};

// ⭐ 중복검증 키 — division 별 PK 묶음 (AS-IS fnValidation L4892~4956 의 비교 컬럼셋 1:1).
//   공통: Division/Project/ScmSite/Item/DomExp/FcstType/Incoterms/Measure
//   81  : + PlantSiteId
//   82  : (PlantSite 제외 — 위 공통만)
//   40  : Customer40/ScmSiteId40/ItemId40 계열(readIdentity 가 흡수) — PlantSite 제외.
export const buildDuplicateKey = (row: Record<string, unknown>, divisionId: string): string => {
  const id = readIdentity(row, divisionId);
  const parts = [
    str(row.DIVISION_ID) || divisionId,
    id.project,
    id.scmSite,
    id.item,
    str(row.DOM_EXP),
    str(row.FCST_TYPE),
    str(row.INCOTERMS),
    str(row.MEASURE),
  ];
  // 81 만 PlantSite 를 키에 포함 (AS-IS L4907). 82·40 은 제외 (L4913~4956).
  if (divisionKindOf(divisionId) === 'D81') {
    parts.push(str(row.PLANT_SITE_ID));
  }
  // AS-IS [C20220328-000205] AS_FROM_SITE 도 비교 컬럼 (존재 시) — SetSaveData L4432/L5043.
  const asFromSite = str(row.AS_FROM_SITE);
  if (asFromSite !== '') parts.push(asFromSite);
  return parts.join('|');
};

// 신규 행의 필수 입력 컬럼 묶음 (division 분기, SetSaveData L4347~4409 1:1).
//   각 [columnKey, labelKey(LBL)] — labelKey 는 i18n REQUIRED_FIELD(MSG00631) {0} 치환용.
export type RequiredField = [columnKey: string, labelKey: string];

// 컬럼 라벨 i18n 키 — 사내 SCM_ADM_MSG_M 정합 (2026-06-28 실측). 정확 텍스트 일치만 재사용.
//   재사용: SalesSite/PlantSite/EndCustomer/Incoterms/Measure (사내 기존 LBL 정확 일치).
//   신규(LBL00679+): Model / FCST Type / Customs Handbook (사내 미존재 → 정식 채번).
const LBL = {
  SALES_SITE: 'LBL00011', // 사내 'Sales Site' 정확 일치
  MODEL: 'LBL00669', // 공용 'Model' (타화면 공유 — locale 기존) 재사용
  PLANT_SITE: 'LBL00005', // 사내 'Plant Site' 정확 일치
  END_CUSTOMER: 'LBL00080', // 사내 'End Customer' 정확 일치
  INCOTERMS: 'LBL00024', // 사내 'Incoterms' 정확 일치
  FCST_TYPE: 'LBL00679', // 신규 'FCST Type' (사내 미존재 → 정식 채번)
  CUSTOMS_HANDBOOK: 'LBL00680', // 신규 'Customs Handbook'
  MEASURE: 'LBL00310', // 사내 'Measure' 정확 일치
} as const;

export const requiredFieldsFor = (divisionId: string): RequiredField[] => {
  const fields: RequiredField[] = [];
  const cols = divisionKeyColumns(divisionId);
  if (usesProjectKeys(divisionId)) {
    // 81·82 — SalesSite/Model 필수, 81 만 PlantSite 추가 (L4355~4369).
    fields.push([cols.scmSite, LBL.SALES_SITE]);
    fields.push([cols.item, LBL.MODEL]);
    if (requiresPlantSite(divisionId)) fields.push(['PLANT_SITE_ID', LBL.PLANT_SITE]);
  } else {
    // 40 — EndCustomer40/SalesSite40/Model40 필수 (L4373~4387).
    fields.push([cols.project, LBL.END_CUSTOMER]);
    fields.push([cols.scmSite, LBL.SALES_SITE]);
    fields.push([cols.item, LBL.MODEL]);
  }
  // 공통 필수 — Incoterms/FcstType/DomExp/Measure (L4390~4409).
  fields.push(['INCOTERMS', LBL.INCOTERMS]);
  fields.push(['FCST_TYPE', LBL.FCST_TYPE]);
  fields.push(['DOM_EXP', LBL.CUSTOMS_HANDBOOK]);
  fields.push(['MEASURE', LBL.MEASURE]);
  return fields;
};
