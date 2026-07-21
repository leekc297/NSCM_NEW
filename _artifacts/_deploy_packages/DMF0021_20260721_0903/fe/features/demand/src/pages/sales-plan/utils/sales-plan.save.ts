// ⭐ DMF0021 — SAVE payload 구성 ('^' bulk 16키, AS-IS SaveData L1922~2828 1:1).
//   근거(라인 = AS-IS DMF0021_SalesPlan.cs):
//     · 수집 단위       : (행 × 변경 기간셀) flat. I=값 존재 전량 / M=활성 버킷 Red(변경) 셀만 (L2514~2537
//       — D_ 컬럼 / 비Red 셀 / 버킷 불일치(W_↔M_) 셀 수집 제외 = silent skip).
//     · 빈값→'0' 치환   : [E20251125-000694] + 값 '0' & action≠D → 셀 action 'D' 전환 (L2553~2572).
//     · Catch_Up 음수   : 40 && Catch_Up && Price<0 → MSG00085 {0} (L2587).
//     · 변경 0건 행     : iDateCount==0 → MSG00146 {line} (L2666).
//     · p_project_code  : 40 = END_CUSTOMER40 값 (L2355) / p_text: 81=TEXT, 40·82=TEXT4082.
//   16키 = PROC_M COL_NM (createdBy/lastUpdatedBy 감사 2 는 BE 세션 자동주입 — payload 제외).
//   '^' bulk 다건 = apiClient.post 직접 (useProcMutation array unfold 회피 표준 —
//   memory feedback_save_sp_bulk_payload_apiclient_post).
import type { MSG } from '../sales-plan.constants';
import { BUCKET_TYPE, EDIT_MEASURE } from '../sales-plan.constants';
import type { SalesPlanRow } from '../sales-plan.types';

import { isDiv40, isDiv81, readProjectSlot, readTextSlot } from './sales-plan.division';
import { dynKindOf, parseWeekTag } from './sales-plan.editLock';

// SAVE 한 row(= 행 × 기간셀) 의 원시 값 — 모든 키는 SP positional 매핑 (16키).
export interface SaveUnfoldRow {
  activeFlag: string; // 'I'(신규) / 'M'(수정) / 'D'(0값 — 셀 단위 삭제 전환)
  divisionId: string;
  projectCode: string; // 40=END_CUSTOMER40 값 / 81·82=PROJECT_CODE
  scmSiteId: string;
  plantSiteId: string;
  itemId: string;
  domExp: string;
  fcstType: string;
  incoterms: string;
  measure: string;
  yyyymmdd: string; // M_yyyymm→yyyymm01 / W_yyyymm+ww→해당 ISO주 월요일(월경계 clamp) / D_→그대로
  qty: string;
  currency: string;
  text: string; // 81=TEXT / 40·82=TEXT4082
  deptId: string;
  cellProdSiteId: string;
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

// 수량 정규화 — 빈값 '0' 치환([E20251125-000694]), 콤마 제거, 숫자 아님 '0'. 소수 보존(SalesAmt_LOC 소수3).
const qtyOf = (v: unknown): string => {
  if (v == null || v === '') return '0';
  const n = typeof v === 'number' ? v : Number(str(v).replace(/,/g, ''));
  return Number.isFinite(n) ? String(n) : '0';
};

// ISO 주차(년, 주) → 해당 주 월요일 yyyymmdd (UTC 산술 — 시차 오차 배제)
const mondayOfIsoWeek = (year: number, week: number): string => {
  // 1/4 이 항상 ISO 1주차 — 그 주 월요일 기준 + (week-1)*7
  const jan4 = new Date(Date.UTC(year, 0, 4));
  const day = jan4.getUTCDay() || 7;
  const monday = new Date(jan4);
  monday.setUTCDate(jan4.getUTCDate() - (day - 1) + (week - 1) * 7);
  return `${monday.getUTCFullYear()}${String(monday.getUTCMonth() + 1).padStart(2, '0')}${String(
    monday.getUTCDate()
  ).padStart(2, '0')}`;
};

// 기간 binding → 저장 기준일 yyyymmdd.
//   M_yyyymm → 월 1일 / W_yyyymm+ww → ISO주 월요일 (월경계 분할 주는 월 1일로 clamp —
//   GET_SPREAD_TITLE 이 월경계에서 주를 분할하므로 셀의 월 컨텍스트 보존) / D_yyyymmdd → 그대로.
export const bindingToYyyymmdd = (binding: string): string | null => {
  const kind = dynKindOf(binding);
  if (kind === 'M') return `${binding.slice(2)}01`;
  if (kind === 'D') return binding.slice(2);
  if (kind === 'W') {
    const w = parseWeekTag(binding);
    if (!w) return null;
    // ISO 주차의 소속 연도 — 1월의 52/53주는 전년도, 12월의 1주는 익년도
    let year = Number(w.ym.slice(0, 4));
    const month = Number(w.ym.slice(4, 6));
    if (month === 1 && w.wk >= 52) year -= 1;
    if (month === 12 && w.wk === 1) year += 1;
    const monday = mondayOfIsoWeek(year, w.wk);
    const monthStart = `${w.ym}01`;
    return monday < monthStart ? monthStart : monday;
  }
  return null;
};

// 행 identity 16키 중 기간 무관 13키 추출 (division 분기 — AS-IS SaveData 필드값 추출 1:1).
const identityOf = (
  row: Rec,
  divisionId: string
): Omit<SaveUnfoldRow, 'activeFlag' | 'yyyymmdd' | 'qty'> => ({
  divisionId: str(row.DIVISION_ID) || divisionId,
  projectCode: readProjectSlot(row, divisionId),
  scmSiteId: str(row.SCM_SITE_ID),
  plantSiteId: str(row.PLANT_SITE_ID),
  itemId: str(row.ITEM_ID),
  domExp: str(row.DOM_EXP),
  fcstType: str(row.FCST_TYPE),
  incoterms: str(row.INCOTERMS),
  measure: str(row.MEASURE),
  currency: str(row.CURRENCY),
  text: readTextSlot(row, divisionId),
  deptId: str(row.DEPT_ID),
  // ⭐ [E20260512-000502] p_cell_prod_site_id 슬롯 = 81 → FROM_SITE_ID / 40 → CELL_PROD_SITE_ID
  //   (AS-IS SaveData L2466~2475: FromSiteId 컬럼 존재[=81] 시 sCellProdSiteId 를 FROM_SITE_ID 값으로 덮어씀).
  //   미치환 시 81 저장이 빈 CELL_PROD_SITE_ID 로 저장되는 손상.
  cellProdSiteId: isDiv81(divisionId) ? str(row.FROM_SITE_ID) : str(row.CELL_PROD_SITE_ID),
});

/**
 * 변경된 모든 행/셀 → SaveUnfoldRow 목록 (+ 조립 단계 검증 — Catch_Up 음수 / 라인 변경 0건).
 *   - 신규 행(insertedRows): 활성 버킷 kind 의 값 존재 셀 전량 → 'I' (0값 → 'D').
 *   - 수정 행(editedChanges): EditTracker 추적 셀 중 활성 버킷 kind 만 → 'M' (빈값→'0'→'D').
 *   - 버킷 불일치 셀(silent skip)·D_ 셀 제외 — AS-IS L2514~2537.
 */
export const buildUnfoldRows = (params: {
  insertedRows: SalesPlanRow[];
  editedChanges: Map<SalesPlanRow, Record<string, unknown>>;
  divisionId: string;
  bucketType: BUCKET_TYPE;
  msg: { catchupMinZero: SaveBuildError['msgId']; lineNoChange: SaveBuildError['msgId'] };
}): SaveBuildResult => {
  const { insertedRows, editedChanges, divisionId, bucketType, msg } = params;
  const out: SaveUnfoldRow[] = [];
  const activeKind = bucketType === BUCKET_TYPE.MONTHLY ? 'M' : 'W'; // Daily 는 편집 자체 차단 (R2)
  const d40 = isDiv40(divisionId);

  const pushCell = (
    row: Rec,
    binding: string,
    rowFlag: 'I' | 'M',
    lineNo: number
  ): SaveBuildError | null => {
    const yyyymmdd = bindingToYyyymmdd(binding);
    if (!yyyymmdd) return null;
    const qty = qtyOf(row[binding]);
    const identity = identityOf(row, divisionId);
    // 40 + Catch_Up 음수 차단 (AS-IS L2587 — MSG00085 {0}=0)
    if (d40 && identity.measure === EDIT_MEASURE.CATCH_UP && Number(qty) < 0) {
      return { msgId: msg.catchupMinZero, param: '0' };
    }
    out.push({
      activeFlag: qty === '0' ? 'D' : rowFlag, // 값 '0' → 'D' 전환 (L2571)
      ...identity,
      yyyymmdd,
      qty,
    });
    void lineNo;
    return null;
  };

  let lineNo = 0;

  // (1) 신규 행 — 활성 버킷 kind 의 값 존재 셀 전량
  for (const row of insertedRows) {
    lineNo += 1;
    let cellCount = 0;
    for (const key of Object.keys(row)) {
      if (dynKindOf(key) !== activeKind) continue;
      const v = (row as Rec)[key];
      if (v == null || v === '') continue; // 신규는 입력분만
      const err = pushCell(row as Rec, key, 'I', lineNo);
      if (err) return { rows: [], error: err };
      cellCount += 1;
    }
    // 라인 변경 0건 (AS-IS L2666 — MSG00146 {line})
    if (cellCount === 0) {
      return { rows: [], error: { msgId: msg.lineNoChange, param: String(lineNo) } };
    }
  }

  // (2) 수정 행 — EditTracker 변경 셀 중 활성 버킷 kind 만 (현재 값 전송 — 빈 셀 '0'→'D' 포함)
  for (const [row, changedBindings] of editedChanges) {
    if (row.CRUD_TYPE === 'I') continue; // 신규는 (1) 에서 처리
    lineNo += 1;
    let cellCount = 0;
    for (const key of Object.keys(changedBindings)) {
      if (dynKindOf(key) !== activeKind) continue; // 버킷 불일치 silent skip (L2514~2537)
      const err = pushCell(row as Rec, key, 'M', lineNo);
      if (err) return { rows: [], error: err };
      cellCount += 1;
    }
    if (cellCount === 0) {
      return { rows: [], error: { msgId: msg.lineNoChange, param: String(lineNo) } };
    }
  }

  return { rows: out };
};

// SaveUnfoldRow[] → 16키 '^'delim payload (camelCase = SCM_ADM_PROC_M COL_NM. 감사 2키 BE주입 제외).
export const buildSavePayload = (rows: SaveUnfoldRow[]): Record<string, string> | null => {
  if (rows.length === 0) return null;
  const join = (sel: (r: SaveUnfoldRow) => string): string => rows.map(sel).join('^');
  return {
    activeFlag: join(r => r.activeFlag),
    divisionId: join(r => r.divisionId),
    projectCode: join(r => r.projectCode),
    scmSiteId: join(r => r.scmSiteId),
    plantSiteId: join(r => r.plantSiteId),
    itemId: join(r => r.itemId),
    domExp: join(r => r.domExp),
    fcstType: join(r => r.fcstType),
    incoterms: join(r => r.incoterms),
    measure: join(r => r.measure),
    yyyymmdd: join(r => r.yyyymmdd),
    qty: join(r => r.qty),
    currency: join(r => r.currency),
    text: join(r => r.text),
    deptId: join(r => r.deptId),
    cellProdSiteId: join(r => r.cellProdSiteId),
  };
};
