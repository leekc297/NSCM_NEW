// ⭐ DMF0042 — SAVE payload 구성 ('^' bulk 19키, AS-IS SaveData L801~1148 1:1 → TO-BE PKG 판 21 IN 중
//   감사 2(createdBy/lastUpdatedBy — BE 세션 주입) 제외 19키. 사용자 확정 F-2 ①).
//   근거(라인 = AS-IS DMF0042_1_BizPlan.cs):
//     · 수집 단위       : (Measure 블록 행 × M_ 기간셀) flat — SaveData 는 항상 M_ 컬럼 순회(L872,
//       Q_/Y_ 입력은 배분 엔진이 M_ 로 환산 완료 상태). 값 존재/변경(Red) 셀만.
//     · 대상 Measure    : Business_Plan / LOC / MKT_FCST 외 continue (L866 — 파생 행 수집 제외).
//     · 공란 치환       : INCOTERMS/FCST_TYPE 공란→' ' / UNIT_ENERGY 공란→'0' (ParameterString L3081).
//     · 저장 대상 0건   : MSG00676(AS-IS 00275 L1087) / 중복 키: MSG00043 (fnValidation L3138~3277).
//   19키 = PKG PROC_M COL_NM positional 1:1. '^' bulk 다건 = apiClient.post 직접
//   (memory feedback_save_sp_bulk_payload_apiclient_post).
import type { MSG } from '../business-plan.constants';
import { EDIT_MEASURE } from '../business-plan.constants';
import type { BusinessPlanRow } from '../business-plan.types';

import {
  readBizTypeSlot,
  readDeptSlot,
  readEndCustomerSlot,
  readIncotermsSlot,
  readItemSlot,
  readProjectSlot,
  readScmSiteSlot,
} from './business-plan.division';
import { dynKindOf } from './business-plan.editLock';

// SAVE 한 row(= 행 × 기간셀) 의 원시 값 — 모든 키는 PKG SP positional 매핑 (19키).
export interface SaveUnfoldRow {
  activeFlag: string; // 'I'(신규) / 'M'(수정) / 'D'(0값 — 셀 단위 삭제 전환)
  divisionId: string;
  projectCode: string; // 40=END_CUSTOMER40 값 / 81=PROJECT_CODE / 82=PROJECT_CODE82
  projectName: string;
  scmSiteId: string; // division별 SCM_SITE_ID40/81/82
  plantSiteId: string;
  itemId: string; // 40=ITEM_ID40 / 81·82=ITEM_ID
  fcstType: string; // 공란 ' ' 치환
  incoterms: string; // 공란 ' ' 치환 (82=INCOTERMS82)
  itemUse: string; // 82 전용
  unitEnergy: string; // 82 전용 — 공란 '0' 치환
  measure: string;
  yyyymm: string; // M_yyyymm → yyyymm
  qty: string;
  currency: string;
  deptId: string; // 40=DEPT_ID40 / 81·82=DEPT_ID
  endCustomer: string; // 40=END_CUSTOMER40 / 81·82=END_CUSTOMER
  bizType: string; // division별 BIZ_TYPE_NAME40/81(82 fallback)
  cellProdSite: string; // 40 전용
}

export interface SaveBuildError {
  msgId: (typeof MSG)[keyof typeof MSG];
  param?: string;
}

export interface SaveBuildResult {
  rows: SaveUnfoldRow[];
  error?: SaveBuildError;
}

type Rec = Record<string, unknown>;

const str = (v: unknown): string =>
  typeof v === 'string' ? v.trim() : typeof v === 'number' ? String(v) : '';

// 수량 정규화 — 빈값 '0', 콤마 제거, 숫자 아님 '0' (LOC 소수 보존).
const qtyOf = (v: unknown): string => {
  if (v == null || v === '') return '0';
  const n = typeof v === 'number' ? v : Number(str(v).replace(/,/g, ''));
  return Number.isFinite(n) ? String(n) : '0';
};

// 수집 대상 Measure — AS-IS L866: Business_Plan / LOC / MKT_FCST 외 continue.
const SAVE_MEASURES = new Set<string>([
  EDIT_MEASURE.BUSINESS_PLAN,
  EDIT_MEASURE.LOC,
  'MKT_FCST',
]);

// 행 identity — 기간/수량 무관 16키 (division 슬롯 분기 — AS-IS SaveData L897~1057 1:1).
const identityOf = (
  row: Rec,
  divisionId: string
): Omit<SaveUnfoldRow, 'activeFlag' | 'yyyymm' | 'qty'> => ({
  divisionId: str(row.DIVISION_ID) || divisionId,
  projectCode: readProjectSlot(row, divisionId),
  projectName: str(row.PROJECT_NAME),
  scmSiteId: readScmSiteSlot(row, divisionId),
  plantSiteId: str(row.PLANT_SITE_ID),
  itemId: readItemSlot(row, divisionId),
  fcstType: str(row.FCST_TYPE) || ' ', // 공란 ' ' (ParameterString L3081)
  incoterms: readIncotermsSlot(row, divisionId) || ' ',
  itemUse: str(row.ITEM_USE),
  unitEnergy: str(row.UNIT_ENERGY) || '0', // 공란 '0'
  measure: str(row.MEASURE),
  currency: str(row.CURRENCY),
  deptId: readDeptSlot(row, divisionId),
  endCustomer: readEndCustomerSlot(row, divisionId),
  bizType: readBizTypeSlot(row, divisionId),
  cellProdSite: str(row.CELL_PROD_SITE),
});

/**
 * 변경된 모든 행/셀 → SaveUnfoldRow 목록 (+ 조립 단계 검증 — 중복 키 MSG00043).
 *   - 신규 행(insertedRows): M_ 값 존재 셀 전량 → 'I' (0값 → 'D').
 *   - 수정 행(editedChanges): EditTracker 추적 셀 중 M_ 만 → 'M' (배분 엔진이 Q_/Y_ 입력을 M_ 로 환산 완료).
 */
export const buildUnfoldRows = (params: {
  insertedRows: BusinessPlanRow[];
  editedChanges: Map<BusinessPlanRow, Record<string, unknown>>;
  divisionId: string;
  msg: { duplicateKey: SaveBuildError['msgId'] };
}): SaveBuildResult => {
  const { insertedRows, editedChanges, divisionId, msg } = params;
  const out: SaveUnfoldRow[] = [];

  const pushCell = (row: Rec, binding: string, rowFlag: 'I' | 'M'): void => {
    const yyyymm = binding.slice(2);
    const qty = qtyOf(row[binding]);
    out.push({
      activeFlag: qty === '0' ? 'D' : rowFlag, // 값 '0' → 'D' 전환 (셀 단위 삭제)
      ...identityOf(row, divisionId),
      yyyymm,
      qty,
    });
  };

  // (1) 신규 행 — M_ 값 존재 셀 전량 (수집 대상 measure 만)
  for (const row of insertedRows) {
    const rec = row as Rec;
    if (!SAVE_MEASURES.has(str(rec.MEASURE))) continue; // 파생 행 수집 제외 (L866)
    for (const key of Object.keys(rec)) {
      if (dynKindOf(key) !== 'M') continue;
      const v = rec[key];
      if (v == null || v === '') continue; // 신규는 입력분만
      pushCell(rec, key, 'I');
    }
  }

  // (2) 수정 행 — EditTracker 변경 셀 중 M_ 만 (현재 값 전송 — 빈 셀 '0'→'D' 포함)
  for (const [row, changedBindings] of editedChanges) {
    if (row.CRUD_TYPE === 'I') continue; // 신규는 (1) 에서 처리
    const rec = row as Rec;
    if (!SAVE_MEASURES.has(str(rec.MEASURE))) continue;
    for (const key of Object.keys(changedBindings)) {
      if (dynKindOf(key) !== 'M') continue; // Q_/Y_ 입력분은 배분 엔진이 M_ 로 이미 환산
      pushCell(rec, key, 'M');
    }
  }

  // 중복 키 검증 — identity + yyyymm 튜플 중복 = MSG00043 (AS-IS fnValidation L3138~3277 1:1 취지)
  const seen = new Set<string>();
  for (const r of out) {
    const key = [
      r.divisionId,
      r.projectCode,
      r.scmSiteId,
      r.plantSiteId,
      r.itemId,
      r.measure,
      r.deptId,
      r.endCustomer,
      r.currency,
      r.yyyymm,
    ].join('|');
    if (seen.has(key)) {
      return { rows: [], error: { msgId: msg.duplicateKey, param: ` (${r.yyyymm})` } };
    }
    seen.add(key);
  }

  return { rows: out };
};

// SaveUnfoldRow[] → 19키 '^'delim payload (camelCase = PKG PROC_M COL_NM. 감사 2키 BE주입 제외).
export const buildSavePayload = (rows: SaveUnfoldRow[]): Record<string, string> | null => {
  if (rows.length === 0) return null;
  const join = (sel: (r: SaveUnfoldRow) => string): string => rows.map(sel).join('^');
  return {
    activeFlag: join(r => r.activeFlag),
    divisionId: join(r => r.divisionId),
    projectCode: join(r => r.projectCode),
    projectName: join(r => r.projectName),
    scmSiteId: join(r => r.scmSiteId),
    plantSiteId: join(r => r.plantSiteId),
    itemId: join(r => r.itemId),
    fcstType: join(r => r.fcstType),
    incoterms: join(r => r.incoterms),
    itemUse: join(r => r.itemUse),
    unitEnergy: join(r => r.unitEnergy),
    measure: join(r => r.measure),
    yyyymm: join(r => r.yyyymm),
    qty: join(r => r.qty),
    currency: join(r => r.currency),
    deptId: join(r => r.deptId),
    endCustomer: join(r => r.endCustomer),
    bizType: join(r => r.bizType),
    cellProdSite: join(r => r.cellProdSite),
  };
};
