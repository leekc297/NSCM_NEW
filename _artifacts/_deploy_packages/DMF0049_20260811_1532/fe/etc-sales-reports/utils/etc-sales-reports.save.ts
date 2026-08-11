// ⭐ DMF0049 — SAVE payload 구성 (단일 SP — AS-IS SaveData L633~915 1:1):
//   `DMF0049_SAVE_SALES_ETC_REPORT_C` 36 IN — FE 35키 '^' bulk (P_CREATED_BY[36번] BE주입 제외).
//   ⚠⚠ 키 바인딩 = PROC_M SORT_ORD = **DB POSITION 정본** (…31 cellModelInfo, 32 cellModel,
//   33 measure, 34 yyyymmdd, 35 qty). 분석서 이벤트 L150(L849) 꼬리 5개 순서(32 measure…36 cell_model)는
//   오기로 확정(ALL_ARGUMENTS 실측 2026-07-22) — 그 순서로 PROC_M 등록 시 값 전부 밀리는 치명 결함.
//   '^' 병렬 문자열이라 payload 객체 키 순서 자체는 무관 — PROC_M COL_NM(camelCase) 매칭이 전부.
//   저장 채택 3분기 (AS-IS L739~744): ①Red(변경) M_ 셀 ②40+M행+cnt≥2 → 전 월 ③82+M행 → 전 월.
//   행 emit = 세트 × 채택월 × 세트내 measure 행 (p_measure/p_qty = k 행 값, identity = 세트 첫 행).
import { MSG, measureCntOf } from '../etc-sales-reports.constants';
import type { EtcSalesReportRow, ValidationResult } from '../etc-sales-reports.types';

import { dynKindOf } from './etc-sales-reports.editLock';

type Rec = Record<string, unknown>;

const str = (v: unknown): string =>
  typeof v === 'string' ? v.trim() : typeof v === 'number' ? String(v) : '';

const qtyOf = (v: unknown): string => {
  if (v == null || v === '') return '0';
  const n = typeof v === 'number' ? v : Number(str(v).replace(/,/g, ''));
  return Number.isFinite(n) ? String(n) : '0';
};

// SAVE 한 행 — 35키 (PROC_M COL_NM camelCase. sesUserId 제외)
export interface EtcReportSaveRow {
  activeFlag: string;
  resultMonth: string; // 2 — Result 조회 시 전월 스냅샷 / Plan '' (store resultMonth)
  divisionId: string;
  versionNo: string;
  dataSeq: string; // 5 — 행값 (I 행 '')
  departmentId: string;
  departmentEditFlag: string; // 7 — DEPARTMENT_ID 변경(Red)/신규 입력 시 'true' (AS-IS L766~773)
  departmentName: string;
  deptId: string;
  custReport: string;
  endCustReport: string;
  soldtoCode: string;
  soldtoCustReport: string;
  productGroup: string;
  itemId: string;
  productDetails: string;
  currency: string;
  companyId: string;
  bizType: string;
  applicationGr: string;
  application: string;
  countryCode: string;
  projectCode: string;
  scmSiteId: string;
  fcstType: string;
  itemUse: string;
  soldtoCountry: string;
  shiptoCountry: string;
  endCustomer: string;
  etcDescr: string;
  cellModelInfo: string; // 31
  cellModel: string; // 32
  measure: string; // 33 — 세트내 k 행 값
  yyyymmdd: string; // 34 — M_yyyymm → yyyymm
  qty: string; // 35 — k 행 해당 월 값
}

export interface SaveBuildResult {
  rows: EtcReportSaveRow[];
  error?: ValidationResult;
}

// 세트 첫 행 identity (AS-IS 세트 대표행 필드 수집 — 컬럼 부재 시 '')
const identityOf = (row: Rec) => ({
  divisionId: str(row.DIVISION_ID),
  dataSeq: str(row.DATA_SEQ),
  departmentId: str(row.DEPARTMENT_ID),
  departmentName: str(row.DEPARTMENT_NAME),
  deptId: str(row.DEPT_ID),
  custReport: str(row.CUST_REPORT),
  endCustReport: str(row.END_CUST_REPORT),
  soldtoCode: str(row.SOLDTO_CODE),
  soldtoCustReport: str(row.SOLDTO_CUST_REPORT),
  productGroup: str(row.PRODUCT_GROUP),
  itemId: str(row.ITEM_ID),
  productDetails: str(row.PRODUCT_DETAILS),
  currency: str(row.CURRENCY),
  companyId: str(row.COMPANY_ID),
  bizType: str(row.BIZ_TYPE),
  applicationGr: str(row.APPLICATION_GR),
  application: str(row.APPLICATION),
  countryCode: str(row.COUNTRY_CODE),
  projectCode: str(row.PROJECT_CODE),
  scmSiteId: str(row.SCM_SITE_ID),
  fcstType: str(row.FCST_TYPE),
  itemUse: str(row.ITEM_USE),
  soldtoCountry: str(row.SOLDTO_COUNTRY),
  shiptoCountry: str(row.SHIPTO_COUNTRY),
  endCustomer: str(row.END_CUSTOMER),
  etcDescr: str(row.ETC_DESCR),
  cellModelInfo: str(row.CELL_MODEL_INFO),
  cellModel: str(row.CELL_MODEL),
});

// 세트(연속 measure 행 그룹) 단위 target
export interface SaveTarget {
  setRows: { row: EtcSalesReportRow; changes?: Record<string, unknown> }[]; // 세트 전 행 (첫 행 = identity)
  isInsert: boolean;
}

/**
 * 저장 행 조립 — 세트 × 채택월 × 세트내 행.
 *   채택월 (L739~744): Red 변경 월 ∪ (40&&M&&cnt≥2 → 전 월) ∪ (82&&M → 전 월). I 세트 = 값 존재 월.
 */
export const buildEtcReportSaveRows = (params: {
  targets: SaveTarget[];
  versionNo: string;
  resultMonth: string; // Result 조회 시 전월 yyyymm / Plan ''
  monthBindings: string[]; // 조회 연도 M_ 전체 (전 월 수집용)
}): SaveBuildResult => {
  const { targets, versionNo, resultMonth, monthBindings } = params;
  const out: EtcReportSaveRow[] = [];

  for (const t of targets) {
    const first = t.setRows[0];
    if (!first) continue;
    const firstRec = first.row as Rec;
    const identity = identityOf(firstRec);
    // Department 필수 (L748 — MSG00429 {Department})
    if (identity.departmentId === '' && identity.departmentName === '') {
      return { rows: [], error: { ok: false, msgId: MSG.REQUIRED_FIELD, detail: 'Department' } };
    }
    const divisionId = identity.divisionId;
    const cnt = measureCntOf(divisionId || '82');
    // departmentEditFlag — DEPARTMENT_ID 가 변경(Red)됐거나 신규 세트에서 입력됨 (AS-IS L766~773)
    const deptEdited =
      t.setRows.some(r => r.changes && 'DEPARTMENT_ID' in (r.changes ?? {})) ||
      (t.isInsert && identity.departmentId !== '');

    // 채택월 산출
    const changedMonths = new Set<string>();
    for (const r of t.setRows) {
      if (t.isInsert) {
        for (const k of Object.keys(r.row)) {
          if (dynKindOf(k) === 'M' && r.row[k] != null && r.row[k] !== '') changedMonths.add(k);
        }
      } else {
        for (const k of Object.keys(r.changes ?? {})) {
          if (dynKindOf(k) === 'M') changedMonths.add(k);
        }
      }
    }
    if (changedMonths.size === 0) continue;
    // 전 월 수집 분기 — 40+M+cnt≥2 / 82+M (L741~744)
    const allMonths =
      !t.isInsert && ((divisionId === '40' && cnt >= 2) || divisionId === '82')
        ? monthBindings
        : [...changedMonths].sort();

    for (const binding of allMonths) {
      for (const r of t.setRows) {
        const kRec = r.row as Rec;
        out.push({
          activeFlag: t.isInsert ? 'I' : 'M',
          resultMonth,
          ...identity,
          versionNo,
          departmentEditFlag: deptEdited ? 'true' : 'false',
          measure: str(kRec.MEASURE), // k 행 measure
          yyyymmdd: binding.slice(2),
          qty: qtyOf(kRec[binding]), // k 행 해당 월 값
        });
      }
    }
  }
  return { rows: out };
};

// '^' bulk payload (키 = PROC_M COL_NM)
export const buildBulkPayload = (rows: EtcReportSaveRow[]): Record<string, string> | null => {
  if (rows.length === 0) return null;
  const keys = Object.keys(rows[0]) as (keyof EtcReportSaveRow)[];
  const payload: Record<string, string> = {};
  for (const k of keys) payload[k as string] = rows.map(r => r[k]).join('^');
  return payload;
};
