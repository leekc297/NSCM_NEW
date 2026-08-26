// ⭐ DMF0044 — SAVE payload 구성 (Data Type 이원화 — AS-IS SaveData L502~968 1:1):
//   · ETC(2)  : 2행 Measure 세트 루프(i+=2), Red(변경) 셀만 → PKG..._SAVE_SALES_PLAN_REPORT_C
//               '^' bulk 20키 (21 IN − P_CREATED_BY BE주입). CELL_MODEL_INFO/CELL_MODEL = 세트 파트너 행 값.
//   · Cutoff(1): 1행 루프 Action=='M' 만, Red 셀만 → ..._C_CF '^' bulk 22키 (23 IN − createdBy).
//   · 공통: 빈 수량 → '0' (spdMain_Changed L1295~1302 파리티), P_CUTOFF_YYYYMMDD = 행값 그대로
//     (⭐ 정책① 2026-07-22 — AS-IS 활성 경로에서 항상 '' = 빈값 파리티. 제약매트릭스 V-9 L115).
//   · Department 공란 → MSG00429 {Department} (AS-IS L572/L778 MSG00002 용법 재매핑).
import { DATA_TYPE, MSG } from '../sales-reports.constants';
import type { SalesReportRow, ValidationResult } from '../sales-reports.types';

import { dynKindOf } from './sales-reports.editLock';

type Rec = Record<string, unknown>;

const str = (v: unknown): string =>
  typeof v === 'string' ? v.trim() : typeof v === 'number' ? String(v) : '';

const qtyOf = (v: unknown): string => {
  if (v == null || v === '') return '0';
  const n = typeof v === 'number' ? v : Number(str(v).replace(/,/g, ''));
  return Number.isFinite(n) ? String(n) : '0';
};

// SAVE 한 행(= 행 × 변경 M_ 셀) — ETC 20키 (PROC_M COL_NM camelCase positional)
export interface EtcSaveRow {
  activeFlag: string;
  divisionId: string;
  versionNo: string;
  cutoffType: string;
  cutoffYyyymmdd: string; // 정책① — 빈값 파리티
  departmentId: string;
  departmentName: string;
  deptId: string;
  deptName: string;
  endCustReport: string;
  custReport: string;
  productGroup: string;
  itemId: string;
  measure: string;
  yyyymmdd: string; // M_yyyymm → yyyymm (AS-IS GetColumnTag Replace('M_','') L604)
  currency: string;
  companyId: string;
  qty: string;
  cellModelInfo: string; // 2행 세트 파트너 행 정보 (AS-IS 21p 말미 2키)
  cellModel: string;
}

// Cutoff 22키 — 1~15 ETC 동일, 16~22 = currency/qty/scmSiteId/projectCode/companyId/fcstType/incoterms
export interface CutoffSaveRow {
  activeFlag: string;
  divisionId: string;
  versionNo: string;
  cutoffType: string;
  cutoffYyyymmdd: string;
  departmentId: string;
  departmentName: string;
  deptId: string;
  deptName: string;
  endCustReport: string;
  custReport: string;
  productGroup: string;
  itemId: string;
  measure: string;
  yyyymmdd: string;
  currency: string;
  qty: string;
  scmSiteId: string;
  projectCode: string;
  companyId: string;
  fcstType: string;
  incoterms: string;
}

export interface SaveBuildResult<T> {
  rows: T[];
  error?: ValidationResult;
}

// 행 identity 공통부 (AS-IS SaveData 필드 수집 1:1 — 컬럼 부재 시 '' 안전)
const identityOf = (row: Rec) => ({
  divisionId: str(row.DIVISION_ID),
  cutoffType: str(row.CUTOFF_TYPE),
  cutoffYyyymmdd: str(row.CUTOFF_YYYYMMDD), // 활성 경로 = 항상 '' (정책① 파리티)
  departmentId: str(row.DEPARTMENT_ID),
  departmentName: str(row.DEPARTMENT_NAME),
  deptId: str(row.DEPT_ID),
  deptName: str(row.DEPT_NAME),
  endCustReport: str(row.END_CUST_REPORT),
  custReport: str(row.CUST_REPORT),
  productGroup: str(row.PRODUCT_GROUP),
  itemId: str(row.ITEM_ID),
  measure: str(row.MEASURE),
  currency: str(row.CURRENCY),
  companyId: str(row.COMPANY_ID),
});

// 변경 M_ 셀 목록 (EditTracker changes + 신규행 값존재 셀)
const changedMonthBindings = (row: Rec, changes: Record<string, unknown> | undefined): string[] => {
  if (row.CRUD_TYPE === 'I') {
    return Object.keys(row).filter(k => dynKindOf(k) === 'M' && row[k] != null && row[k] !== '');
  }
  return Object.keys(changes ?? {}).filter(k => dynKindOf(k) === 'M');
};

export interface EtcSaveTarget {
  row: SalesReportRow;
  changes?: Record<string, unknown>;
  pair?: SalesReportRow;
  /** AS-IS 루프의 짝수행(i) 인가 — identity 공급원이 되는 세트 대표행 (L552 `i += 2`) */
  isSetHead?: boolean;
}

/**
 * ETC(Data Type=2) — 2행 Measure 세트 수집 (AS-IS SaveData L552~694 1:1).
 *
 * ⭐ AS-IS 원문 구조 (2026-08-10 `.cs` 직접 대조로 정정):
 *   · 루프는 **세트 단위**(`i += 2`)이고, 트리거는 `(i 셀 Red && 값≠'') || (i+1 셀 Red && 값≠'')`.
 *   · 한 셀 변경 → **2 엔트리**를 보낸다 (L601·L638):
 *       A) `p_measure = GetValue(i,   MEASURE)` · `p_qty = sQty`
 *       B) `p_measure = GetValue(i+1, MEASURE)` · `p_qty = sQty2`
 *     ⇒ 파트너 행 수량이 같이 안 가면 세트 한쪽이 **영구 미저장**된다.
 *   · identity(부서/고객/제품군/통화/회사/…)·activeFlag 는 **양쪽 모두 행 i 값**을 쓴다.
 *   · `p_cell_model_info` / `p_cell_model` = **행 i 의 CELL_MODEL_INFO / CELL_MODEL 컬럼**
 *     (L607·L608, L643·L644 모두 `GetValue(i, ...)`). 파트너 MEASURE·수량이 아니다.
 *     ⇒ SAVE SP 의 MERGE ON 이 `FORECAST_INFO_CELL_MODEL`/`ATTRIBUTE3` 를 키로 쓰므로
 *       (2026-08-09 3키 복원분) 잘못 넣으면 UPDATE 가 아니라 **중복 INSERT** 가 된다.
 */
export const buildEtcSaveRows = (params: {
  targets: EtcSaveTarget[];
  versionNo: string;
  /**
   * 조회 연도 M_ 전체 — **삭제(D) 세트 전용**.
   *
   * SP 는 `ACTIVE_FLAG='D'` 행을 15키 identity + `SUBSTR(YYYYMMDD,1,6)` 로 매칭해 지운다
   * (`PKG_DMF0044` BODY (ETCWB-1)). 그래서 세트를 통째로 지우려면 전 월을 D 로 내보내야 한다 —
   * 변경 월만 보내면 그 월만 지워지고 나머지가 남는다.
   */
  monthBindings?: string[];
}): SaveBuildResult<EtcSaveRow> => {
  const { targets, versionNo, monthBindings = [] } = params;
  const out: EtcSaveRow[] = [];
  const changesOf = new Map<SalesReportRow, Record<string, unknown> | undefined>(
    targets.map(t => [t.row, t.changes])
  );
  const done = new Set<SalesReportRow>();

  for (const t of targets) {
    if (done.has(t.row)) continue; // 세트 파트너로 이미 처리됨 (AS-IS 는 세트당 1회 순회)
    // 세트 대표행(i) 결정 — 변경이 홀수행에서 났으면 짝 행이 대표
    const head = t.isSetHead === false && t.pair ? t.pair : t.row;
    const partner = head === t.row ? t.pair : t.row;
    done.add(head);
    if (partner) done.add(partner);

    const headRec = head as Rec;
    const identity = identityOf(headRec);
    // Department 필수 (AS-IS L570~575 — MSG00429 {0}=Department)
    if (identity.departmentId === '' && identity.departmentName === '') {
      return { rows: [], error: { ok: false, msgId: MSG.REQUIRED_FIELD, detail: 'Department' } };
    }
    // Delete(F9) 마킹 세트 = 'D' (공용 GridAction.removeRow 규약). SP 가 원장에서 지운다.
    const isDelete = headRec.CRUD_TYPE === 'D';
    const activeFlag = isDelete ? 'D' : headRec.CRUD_TYPE === 'I' ? 'I' : 'M';
    const cellModelInfo = str(headRec.CELL_MODEL_INFO);
    const cellModel = str(headRec.CELL_MODEL);
    // 트리거 셀 = 세트 양쪽 변경분의 합집합 (AS-IS OR 조건 파리티).
    //   삭제는 변경 셀이 없으므로 **전 월**을 내보낸다 (위 monthBindings 주석 참조).
    const bindings = isDelete
      ? [...monthBindings].sort()
      : [
          ...new Set([
            ...changedMonthBindings(headRec, changesOf.get(head)),
            ...(partner ? changedMonthBindings(partner as Rec, changesOf.get(partner)) : []),
          ]),
        ].sort();

    for (const binding of bindings) {
      const emit = (src: Rec) =>
        out.push({
          activeFlag,
          ...identity,
          measure: str(src.MEASURE), // ⭐ identity 중 MEASURE 만 엔트리별로 덮어쓴다
          versionNo,
          yyyymmdd: binding.slice(2),
          qty: qtyOf(src[binding]),
          cellModelInfo,
          cellModel,
        });
      emit(headRec);
      if (partner) emit(partner as Rec);
    }
  }
  return { rows: out };
};

/**
 * Cutoff(Data Type=1) — 1행 루프, Action=='M'(수정)만 (AS-IS L771~946: Red 셀 + 컬럼 존재확인).
 */
export const buildCutoffSaveRows = (params: {
  targets: { row: SalesReportRow; changes?: Record<string, unknown> }[];
  versionNo: string;
}): SaveBuildResult<CutoffSaveRow> => {
  const { targets, versionNo } = params;
  const out: CutoffSaveRow[] = [];
  for (const t of targets) {
    const row = t.row as Rec;
    if (row.CRUD_TYPE === 'I') continue; // Cutoff 는 신규행 없음 (Insert = ETC 전용, L973)
    const identity = identityOf(row);
    if (identity.departmentId === '' && identity.departmentName === '') {
      return { rows: [], error: { ok: false, msgId: MSG.REQUIRED_FIELD, detail: 'Department' } };
    }
    for (const binding of changedMonthBindings(row, t.changes)) {
      out.push({
        activeFlag: 'M',
        divisionId: identity.divisionId,
        versionNo,
        cutoffType: identity.cutoffType,
        cutoffYyyymmdd: identity.cutoffYyyymmdd,
        departmentId: identity.departmentId,
        departmentName: identity.departmentName,
        deptId: identity.deptId,
        deptName: identity.deptName,
        endCustReport: identity.endCustReport,
        custReport: identity.custReport,
        productGroup: identity.productGroup,
        itemId: identity.itemId,
        measure: identity.measure,
        yyyymmdd: binding.slice(2),
        currency: identity.currency,
        qty: qtyOf(row[binding]),
        scmSiteId: str(row.SCM_SITE_ID),
        projectCode: str(row.PROJECT_CODE),
        companyId: identity.companyId,
        fcstType: str(row.FCST_TYPE),
        incoterms: str(row.INCOTERMS),
      });
    }
  }
  return { rows: out };
};

// '^' bulk payload (키 = PROC_M COL_NM. createdBy = BE 세션 주입 제외)
export const buildBulkPayload = <T extends Record<string, string>>(
  rows: T[]
): Record<string, string> | null => {
  if (rows.length === 0) return null;
  const keys = Object.keys(rows[0]) as (keyof T)[];
  const payload: Record<string, string> = {};
  for (const k of keys) payload[k as string] = rows.map(r => r[k]).join('^');
  return payload;
};

// Data Type 라우팅 (호출측 — handleSave)
export const isEtc = (dataType: string): boolean => dataType === DATA_TYPE.ETC;
