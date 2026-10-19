// SCP0111 저장 payload 빌더 (design 03 §4-저장 cs:1233-1626). 변경셀(수정 M / 신규 I)만 셀 단위로
//   펼쳐(unfold) 19키 '^'delim CLOB 배열 payload 를 만든다 — SAVE SP 가 배열을 MERGE 하는 계약.
//   수정(M): preQty≠qty 인 월/BOH 셀만, modiQty=qty-preQty(가감값, cs:1560,1603). 신규(I): 조회기간 전 월
//   modiQty=절대값(ADMIN 은 전 개월 modiQty=0 삽입 후 값 반영 cs:1318,1364). 상수 이식 금지 — 규칙 재현.

import type { EditTracker } from '@foundation/utils';

import { OPERATION_GROUP_CODE } from '../integration-psi.constants';

type Row = Record<string, unknown>;

const s = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';
const num = (v: unknown): number => {
  if (v === undefined || v === null || v === '') return 0;
  const n =
    typeof v === 'number' ? v : typeof v === 'string' ? Number(v.replace(/,/g, '')) : NaN;
  return Number.isFinite(n) ? n : 0;
};

// OPERATION_GROUP 표시명(Pack/Cell/Electrode) → 저장 코드(P/A/E) 역변환 (design 03 §4 cs:1207-1219).
//   lookup 부재(매핑 불가)면 null 반환 → 호출부가 MSG00001 에러 처리(추측 코드 저장 금지).
export const operationGroupToCode = (displayName: string): string | null => {
  const key = displayName.trim() as keyof typeof OPERATION_GROUP_CODE;
  return key in OPERATION_GROUP_CODE ? OPERATION_GROUP_CODE[key] : null;
};

// 6자리 YYYYMM pivot 바인딩 판정 (integrationPsiColumns 와 동일 기준 — 고정열 제외 6자리 숫자).
const isYyyymm = (binding: string, fixedBindings: ReadonlySet<string>): boolean =>
  !fixedBindings.has(binding) && /^\d{6}$/.test(binding);

// 저장 셀 1건 (SAVE SP 19 배열 컬럼 + action). yyyymm='BOH' 이면 BOH_QTY 셀(measure=INV).
export interface SaveCell {
  action: 'I' | 'M';
  activeFlag: string;
  planType: string;
  divisionId: string;
  companyId: string;
  plantId: string;
  operationGroup: string; // 코드(P/A/E)
  seqFlag: string;
  cellitemId: string;
  itemId: string;
  measure: string;
  toSite: string;
  lineId: string;
  valuationType: string;
  toProduct: string;
  incoterms: string;
  yyyymm: string; // 월(YYYYMM) 또는 'BOH'
  modiQty: string; // 가감값(M) / 절대값(I)
  bohQty: string; // ADMIN 저장 전용(일반 저장은 미사용)
}

export interface UnfoldResult {
  cells: SaveCell[];
  // OPERATION_GROUP 코드 역변환 실패 행 존재 여부 (design 03 §4 lookup 부재 = MSG00001).
  opGroupLookupMissing: boolean;
  // 신규행에 LINE_ID 가 sentinel('-') 인 채 저장 시도 (design 03 §5 MSG00453 확인 대상).
  hasEmptyLineInsert: boolean;
}

// 행의 SP 배열 공통 컬럼 채우기 (measure/식별키). operationGroup 은 코드로 역변환.
const baseCell = (row: Row, opCode: string): Omit<SaveCell, 'action' | 'yyyymm' | 'modiQty'> => ({
  activeFlag: 'Y',
  planType: s(row.PLAN_TYPE),
  divisionId: s(row.DIVISION_ID),
  companyId: s(row.COMPANY_ID),
  plantId: s(row.PLANT_ID),
  operationGroup: opCode,
  seqFlag: s(row.SEQ_FLAG),
  cellitemId: s(row.CELL_ITEM_ID),
  itemId: s(row.ITEM_ID),
  measure: s(row.MEASURE),
  toSite: s(row.TO_SITE),
  lineId: s(row.LINE_ID),
  valuationType: s(row.VALUE_TYPE),
  toProduct: s(row.TO_PRODUCT),
  incoterms: s(row.INCOTERMS),
  bohQty: s(row.BOH_QTY),
});

// 변경셀 unfold — 수정(M): EditTracker 원본값으로 modiQty=qty-preQty 산출, 변경된 월/BOH 셀만.
//   신규(I): CRUD_TYPE='I' 행의 조회기간 전 월 + BOH 를 절대값으로 삽입.
//   design 03 §4-저장: 미변경 셀은 제외(preQty==qty skip cs:1293-1368).
export const unfoldSaveCells = (params: {
  source: Row[];
  tracker: EditTracker | undefined;
  fixedBindings: ReadonlySet<string>;
  periodMonths: string[]; // 조회기간 YYYYMM 목록(신규행 삽입 대상 월)
}): UnfoldResult => {
  const { source, tracker, fixedBindings, periodMonths } = params;
  const cells: SaveCell[] = [];
  let opGroupLookupMissing = false;
  let hasEmptyLineInsert = false;

  const originals = tracker?.getOriginalValues();

  for (const row of source) {
    const crud = s(row.CRUD_TYPE);
    if (crud !== 'I' && crud !== 'M') continue;

    const opCode = operationGroupToCode(s(row.OPERATION_GROUP));
    if (opCode === null) {
      opGroupLookupMissing = true;
      continue; // lookup 실패 행은 저장 대상 제외(호출부가 MSG00001 로 차단)
    }
    const base = baseCell(row, opCode);

    if (crud === 'I') {
      // 신규행 — LINE_ID sentinel 확인(MSG00453 대상). 조회기간 전 월 절대값 삽입.
      if (s(row.LINE_ID).trim() === '-' || s(row.LINE_ID).trim() === '') {
        hasEmptyLineInsert = true;
      }
      for (const ym of periodMonths) {
        cells.push({ ...base, action: 'I', yyyymm: ym, modiQty: String(num(row[ym])) });
      }
      // BOH(INV) 신규 절대값.
      cells.push({ ...base, action: 'I', yyyymm: 'BOH', modiQty: String(num(row.BOH_QTY)) });
      continue;
    }

    // 수정행(M) — EditTracker 가 기록한 변경 셀만 modiQty=qty-preQty 가감값으로.
    const changed = originals?.get(row as never);
    if (!changed) continue;
    for (const binding of Object.keys(changed)) {
      const isBoh = binding === 'BOH_QTY';
      if (!isBoh && !isYyyymm(binding, fixedBindings)) continue; // 수량셀(월/BOH)만 저장 대상
      const pre = num(changed[binding]);
      const now = num(row[binding]);
      if (pre === now) continue; // 실변경 없음
      cells.push({
        ...base,
        action: 'M',
        yyyymm: isBoh ? 'BOH' : binding,
        modiQty: String(now - pre), // 가감값
      });
    }
  }

  return { cells, opGroupLookupMissing, hasEmptyLineInsert };
};

// SaveCell[] → 일반 저장 payload (P_SCP0111_SAVE_INTEGRATION_PSI 19 CLOB 배열 + planStartYyyymmdd/userId).
//   키명 = SCM_ADM_PROC_M COL_NM camelCase 가정(자매 sales-plan buildSavePayload 규약). 확인필요: SCP0111
//   procedures.d.ts 미등재라 실제 파라미터 key 매핑은 05_register + 타입 등록 후 검증(design 03 §6).
export const buildGeneralPayload = (
  cells: SaveCell[],
  planStartYyyymmdd: string,
  userId: string
): Record<string, string> | null => {
  if (cells.length === 0) return null;
  const join = (sel: (c: SaveCell) => string): string => cells.map(sel).join('^');
  return {
    activeFlag: join(c => c.activeFlag),
    planType: join(c => c.planType),
    divisionId: join(c => c.divisionId),
    companyId: join(c => c.companyId),
    plantId: join(c => c.plantId),
    operationGroup: join(c => c.operationGroup),
    seqFlag: join(c => c.seqFlag),
    cellitemId: join(c => c.cellitemId),
    itemId: join(c => c.itemId),
    measure: join(c => c.measure),
    toSite: join(c => c.toSite),
    lineId: join(c => c.lineId),
    valuationType: join(c => c.valuationType),
    toProduct: join(c => c.toProduct),
    incoterms: join(c => c.incoterms),
    yyyymm: join(c => c.yyyymm),
    modiQty: join(c => c.modiQty),
    planStartYyyymmdd,
    userId,
  };
};

// ADMIN 저장 payload (P_SCP0111_SAVE_PSI_ADMIN — 일반 19 + p_boh_qty). BOH_QTY 를 절대값으로 함께 전송.
export const buildAdminPayload = (
  cells: SaveCell[],
  planStartYyyymmdd: string,
  userId: string
): Record<string, string> | null => {
  const general = buildGeneralPayload(cells, planStartYyyymmdd, userId);
  if (general === null) return null;
  return { ...general, bohQty: cells.map(c => c.bohQty).join('^') };
};
