// BOD Master 팝업 선택 결과로 메인그리드에 행을 삽입하고(AS-IS InsertRow, SCP0010 .cs:3609-3838),
//   삽입 행을 저장 행으로 바꾼다(P_SCP0010_SAVE_SEMI_DATASET / _WEEKLY 는 P_ACTIVE_FLAG 'I' 를 'M' 과 같이 처리).
//   AS-IS 는 FarPoint 시트에 행을 끼워 넣지만, TO-BE 는 행 배열을 새로 만들어 itemsSource 로 교체한다(자매 FG 동일).
import type { BodMasterPick } from 'features/supply/src/components';

import { CRUD_TYPE } from '@foundation/constants';

import { MEASURE, MSG, QTY_MAX } from '../shipment-plan-semi.constants';

import { dynColKindOf, pickField } from './shipment-plan-semi.editLock';
import type { SaveCellRow } from './shipment-plan-semi.save';

type Row = Record<string, unknown>;

const s = (v: unknown): string => (typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '');
const pf = (r: Row | undefined, key: string): string => (r ? s(pickField(r, key)) : '');

export const isInsertedRow = (r: Row): boolean => r.CRUD_TYPE === CRUD_TYPE.INSERT;

// 셀 클릭으로 BOD 팝업을 여는 조건(.cs:4683-4706) 중 행 단위 조건. 시트 잠금·Bucket·편집모드·수정 행 여부는 호출부가 본다.
export const BOD_CLICK_COLUMNS = new Set(['TRANSPORT_MODE', 'T0_SITE_DESCRIPTION']);
export const canOpenBodPopup = (row: Row, binding: string): boolean =>
  BOD_CLICK_COLUMNS.has(binding) &&
  pf(row, binding).length > 2 &&
  !isInsertedRow(row) &&
  s(row.CRUD_TYPE) !== CRUD_TYPE.DELETE;

// AS-IS 팝업 잠금 키(SCM0002_GetBODPopup) — 호출 행 각각의 division+from+to+trans+bod.
export const bodCallerKeys = (callerRows: Row[]): string[] =>
  callerRows.map(
    r =>
      `${pf(r, 'DIVISION_ID')}${pf(r, 'FROM_SITE')}${pf(r, 'TO_SITE')}${pf(r, 'TRANSPORT_MODE')}${pf(r, 'BOD_ID')}`
  );

// dtCaller(.cs:3640-3660) — 클릭 행과 DIVISION_ID+OPERATION_GROUP+ITEM_ID+TO_SITE 가 같은 행.
export const callerRowsOf = (rows: Row[], clicked: Row): Row[] => {
  const key = (r: Row) =>
    [pf(r, 'DIVISION_ID'), pf(r, 'OPERATION_GROUP'), pf(r, 'ITEM_ID'), pf(r, 'TO_SITE')].join('|');
  const k = key(clicked);
  return rows.filter(r => key(r) === k);
};

// GetNewInsertRowIndex(.cs:3858-3928). 시트 끝 다음 행은 빈 값으로 읽힌다(FarPoint GetText 동작).
//   T 모드는 선택 행 FROM_SITE 를 각 행의 TO_SITE 와 비교한다 — AS-IS 그대로(파리티).
export const getNewInsertRowIndex = (rows: Row[], selectedIdx: number, mode: 'S' | 'T'): number => {
  const at = (i: number, key: string): string => pf(rows[i], key);
  const fromSite = at(selectedIdx, 'FROM_SITE');
  let retIndex = selectedIdx;
  if (mode === 'T') {
    for (let r = selectedIdx; r <= rows.length; r++) {
      const curSite = at(r, 'TO_SITE');
      const transMode = at(r, 'TRANSPORT_MODE');
      retIndex = r;
      if (fromSite !== curSite) {
        if (transMode.length <= 1) break;
        if (transMode.toUpperCase() === 'TOTAL') {
          retIndex--;
          break;
        }
      }
    }
    return retIndex;
  }
  let flagChanged = false;
  for (let r = selectedIdx; r < rows.length; r++) {
    const curSite = at(r, 'FROM_SITE');
    const transMode = at(r, 'TRANSPORT_MODE');
    if (fromSite !== curSite) {
      if (transMode.length <= 1) {
        flagChanged = true;
        retIndex = r;
      } else if (flagChanged) break;
    }
    if (r === rows.length - 1) retIndex = r;
  }
  return retIndex;
};

// dt2 distinct 키(.cs:3700-3715) — 원본 행에서 그대로 옮기는 값이기도 하다. 동적 D_/W_/M_ 값은 옮기지 않는다.
const SOURCE_KEYS = [
  'KEY_IDX',
  'DIVISION_ID',
  'DIVISION_NAME',
  'OPERATION_GROUP',
  'OPERATION_GROUP_DESC',
  'ITEM_ID',
  'NICK_NAME',
  'BOH',
  'MEASURE',
  'MEASURE_LABEL',
  'MEASURE_ORDER_NO',
  'FROM_YYYYMMDD',
  'TO_YYYYMMDD',
] as const;

// 첫 호출 행(dtCaller row 0)에서 옮기는 값.
const CALLER_KEYS = ['ELECTRODE_TYPE', 'ORIGIN_FROM_DIVISION_ID', 'ORIGIN_TO_DIVISION_ID'] as const;

const newRow = (src: Row, caller0: Row, bod: BodMasterPick): Row => {
  const out: Row = {};
  SOURCE_KEYS.forEach(k => {
    out[k] = pickField(src, k);
  });
  CALLER_KEYS.forEach(k => {
    out[k] = pickField(caller0, k);
  });
  return {
    ...out,
    FROM_SITE_DESCRIPTION: bod.firstSiteName,
    T0_SITE_DESCRIPTION: bod.secondSiteName,
    TRANSPORT_MODE: bod.transportMode,
    LT_DAY: bod.ltTotal,
    FROM_SITE: bod.firstSite,
    TO_SITE: bod.secondSite,
    BOD_ID: bod.bodId,
    SHIP_FROZEN: bod.shipFrozen,
    BOD_FROM_YYYYMMDD: bod.bodFromYyyymmdd,
    BOD_TO_YYYYMMDD: bod.bodToYyyymmdd,
    CRUD_TYPE: CRUD_TYPE.INSERT,
  };
};

// 선택한 BOD 마다 클릭 행 기준으로 SHIP 행 묶음을 삽입한 새 배열을 돌려준다(입력 배열은 바꾸지 않는다).
//   복제 원본 = 호출 행 중 FROM_SITE 도 같은 행(dtCaller2)의 SHIP measure 행(distinct).
//   클릭 행 TO_SITE == BOD second_site → T 모드(같은 묶음 끝), 아니면 S 모드(+1 위치).
export const buildInsertedRows = (rows: Row[], clicked: Row, picks: BodMasterPick[]): Row[] => {
  const out = [...rows];
  const callers = callerRowsOf(rows, clicked);
  const caller0 = callers[0] ?? clicked;
  const fromSite = pf(clicked, 'FROM_SITE');
  const toSite = pf(clicked, 'TO_SITE');

  const seen = new Set<string>();
  const templates = callers
    .filter(c => pf(c, 'FROM_SITE') === fromSite)
    .filter(c => {
      const k = SOURCE_KEYS.map(key => pf(c, key)).join('|');
      if (seen.has(k)) return false;
      seen.add(k);
      return true;
    })
    .filter(c => pf(c, 'MEASURE').includes('SHIP'));

  picks.forEach(bod => {
    const selectedIdx = out.indexOf(clicked);
    if (selectedIdx < 0) return;
    let idx =
      toSite === bod.secondSite
        ? getNewInsertRowIndex(out, selectedIdx, 'T')
        : getNewInsertRowIndex(out, selectedIdx, 'S') + 1;
    templates.forEach(t => {
      out.splice(Math.min(idx++, out.length), 0, newRow(t, caller0, bod));
    });
  });
  return out;
};

// 저장 키 정규화 — GET SP 가 NULL 을 '-'/'/' 로 채워 내린다(save.ts normBlankKey 와 동일).
const normBlankKey = (v: string): string => (v === '-' || v === '/' ? '' : v);

export interface InsertSaveContext {
  userId: string;
  timeZone: string;
  planType: string;
  seq: string;
  weekly: boolean; // 81 계열 Weekly 저장(SAVE_WEEKLY) 여부
  dynBindings: string[]; // 그리드의 동적 컬럼 binding(표시 순서)
}

export type InsertSaveResult =
  | { ok: true; rows: SaveCellRow[] }
  | { ok: false; msg: typeof MSG.QTY_NEGATIVE | typeof MSG.QTY_MAX | typeof MSG.INSERT_ROW_NO_VALUE };

// 삽입 행 → 저장 행. 검증: 음수·최대치 초과 금지, Daily 의 SHIP_PLAN_AMEND 삽입 행은 값이 하나 이상 있어야 한다.
//   Daily: SHIP_PLAN_AMEND 가 아닌 삽입 행은 첫 D_ 일자에 수량 0 한 건, SHIP_PLAN_AMEND 는 값이 있는 D_ 셀마다 한 건.
//   Weekly(81 계열): 삽입 행의 W_ 전 컬럼을 값(없으면 0)으로 한 건씩.
export const buildInsertSaveRows = (rows: Row[], ctx: InsertSaveContext): InsertSaveResult => {
  const out: SaveCellRow[] = [];
  const kind = ctx.weekly ? 'W' : 'D';
  const bindings = ctx.dynBindings.filter(b => dynColKindOf(b) === kind);

  const base = (r: Row): Omit<SaveCellRow, 'yyyymmdd' | 'qty'> => ({
    a: '',
    activeFlag: 'I',
    divisionId: pf(r, 'DIVISION_ID'),
    planStartYyyymmdd: pf(r, 'FROM_YYYYMMDD'),
    planType: ctx.planType,
    seq: ctx.seq,
    bizType: pf(r, 'OPERATION_GROUP'),
    operationGroup: pf(r, 'OPERATION_GROUP'),
    itemId: pf(r, 'ITEM_ID'),
    fromSite: pf(r, 'FROM_SITE'),
    bodId: pf(r, 'BOD_ID'),
    measure: pf(r, 'MEASURE'),
    toSite: pf(r, 'TO_SITE'),
    originFromDivisionId: normBlankKey(pf(r, 'ORIGIN_FROM_DIVISION_ID')),
    originToDivisionId: normBlankKey(pf(r, 'ORIGIN_TO_DIVISION_ID')),
    electrodeType: normBlankKey(pf(r, 'ELECTRODE_TYPE')),
    fixReason: '',
    createdBy: ctx.userId,
    lastUpdatedBy: ctx.userId,
    timeZone: ctx.timeZone,
    bucketType: ctx.weekly ? 'WEEKLY' : 'DAILY',
    transMode: pf(r, 'TRANSPORT_MODE'),
    debugMode: 'F',
  });

  const checkQty = (raw: string): InsertSaveResult | null => {
    const qty = Number(raw);
    if (qty < 0) return { ok: false, msg: MSG.QTY_NEGATIVE };
    if (Math.trunc(qty) > QTY_MAX) return { ok: false, msg: MSG.QTY_MAX };
    return null;
  };

  for (const r of rows.filter(isInsertedRow)) {
    if (ctx.weekly) {
      for (const b of bindings) {
        const raw = s(r[b]).replace(/,/g, '') || '0';
        const err = checkQty(raw);
        if (err) return err;
        out.push({ ...base(r), yyyymmdd: b.slice(2), qty: raw });
      }
      continue;
    }
    if (pf(r, 'MEASURE') !== MEASURE.SHIP_PLAN_AMEND) {
      if (bindings[0]) out.push({ ...base(r), yyyymmdd: bindings[0].slice(2, 10), qty: '0' });
      continue;
    }
    let entered = false;
    for (const b of bindings) {
      const raw = s(r[b]).replace(/,/g, '');
      if (raw === '') continue;
      const err = checkQty(raw);
      if (err) return err;
      entered = true;
      out.push({ ...base(r), yyyymmdd: b.slice(2, 10), qty: raw });
    }
    if (!entered) return { ok: false, msg: MSG.INSERT_ROW_NO_VALUE };
  }
  return { ok: true, rows: out };
};
