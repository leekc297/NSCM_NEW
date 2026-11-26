// BOD Master 팝업 선택 결과로 메인그리드에 행을 삽입하고(AS-IS InsertRow, SCP0009 .cs:2037-2296),
//   삽입 행을 저장 행으로 바꾼다(AS-IS Save Daily 'I' 분기, .cs:2779-2824, 2936-3126).
//   AS-IS 는 FarPoint 시트에 행을 끼워 넣지만, TO-BE 는 행 배열을 새로 만들어 itemsSource 로 교체한다.
import type { BodMasterPick } from 'features/supply/src/components';

import { CRUD_TYPE } from '@foundation/constants';

import { MEASURE, MSG, QTY_MAX } from '../shipment-plan-fg.constants';

import { dynColKindOf } from './shipment-plan-fg.editLock';
import type { SaveCellRow } from './shipment-plan-fg.save';

type Row = Record<string, unknown>;

const s = (v: unknown): string => (typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '');

export const isInsertedRow = (r: Row): boolean => r.CRUD_TYPE === CRUD_TYPE.INSERT;

// 셀 클릭으로 BOD 팝업을 여는 조건(.cs:1185-1209) 중 행 단위 조건. 시트 잠금·Bucket·편집가능 여부는 호출부가 본다.
export const BOD_CLICK_COLUMNS = new Set(['TRANSPORT_MODE', 'FROM_SITE_NAME']);
export const canOpenBodPopup = (row: Row, binding: string): boolean =>
  BOD_CLICK_COLUMNS.has(binding) &&
  s(row.TRANSPORT_MODE).length > 2 &&
  s(row.FROM_SITE_NAME).length > 2 &&
  s(row[binding]).length > 2 &&
  !isInsertedRow(row) &&
  s(row.CRUD_TYPE) !== CRUD_TYPE.DELETE;

// AS-IS 팝업 잠금 키(SCM0002_GetBODPopup.cs:331) — 호출 행 각각의 division+from+to+trans+bod.
export const bodCallerKeys = (callerRows: Row[]): string[] =>
  callerRows.map(r => `${s(r.DIVISION_ID)}${s(r.FROM_SITE)}${s(r.TO_SITE)}${s(r.TRANSPORT_MODE)}${s(r.BOD_ID)}`);

export const callerRowsOf = (rows: Row[], clicked: Row): Row[] => rows.filter(r => s(r.KEY_IDX) === s(clicked.KEY_IDX));

// GetNewInsertRowIndex(.cs:2584-2636). 시트 끝 다음 행은 빈 값으로 읽힌다(FarPoint GetText 동작).
export const getNewInsertRowIndex = (rows: Row[], selectedIdx: number, mode: 'S' | 'T'): number => {
  const at = (i: number, key: string): string => s(rows[i]?.[key]);
  const fromSite = at(selectedIdx, 'FROM_SITE');
  let retIndex = selectedIdx;
  for (let r = selectedIdx; r <= rows.length; r++) {
    const curFromSite = at(r, 'FROM_SITE');
    const transMode = at(r, 'TRANSPORT_MODE').trim();
    retIndex = r;
    if (fromSite !== curFromSite && (transMode.length <= 1 || transMode === '-')) break;
  }
  if (mode === 'S') {
    for (let r2 = retIndex; r2 < rows.length; r2++) {
      if (at(r2, 'FROM_SITE').trim() === '-') {
        retIndex = r2 - 1;
        break;
      }
      if (r2 === rows.length - 1) retIndex = r2;
    }
  }
  return retIndex;
};

// 원본 행에서 그대로 옮기는 값(AS-IS defaultData 의 dr[...] 항목). 동적 D_/W_/M_ 값은 옮기지 않는다(새 행은 빈 값).
const SOURCE_KEYS = [
  'DIVISION_ID',
  'BIZ_TYPE_NAME',
  'ITEM_ID',
  'NICK_NAME',
  'ELECTRODE_TYPE',
  'ORIGIN_TO_DIVISION_ID',
  'BOH',
  'PROJECT_CODE',
  'ORIGIN_FROM_DIVISION_ID',
  'MEASURE_LABEL',
  'MEASURE',
  'KEY_IDX',
  'BIZ_TYPE',
  'MEASURE_ORDER_NO',
  'PLAN_START_YYYYMMDD',
  'PLAN_TYPE',
  'SEQ',
  'TO_YYYYMMDD',
] as const;

const copySource = (src: Row): Row => {
  const out: Row = {};
  SOURCE_KEYS.forEach(k => {
    if (k in src) out[k] = src[k];
  });
  return out;
};

const newRow = (src: Row, bod: BodMasterPick, overrides: Row): Row => ({
  ...copySource(src),
  TO_SITE_NAME: bod.firstSiteName,
  INCOTERMS: bod.incoterms,
  TO_SITE: bod.firstSite,
  SHIP_FROZEN: bod.shipFrozen,
  BOD_FROM_YYYYMMDD: bod.bodFromYyyymmdd,
  BOD_TO_YYYYMMDD: bod.bodToYyyymmdd,
  ...overrides,
  CRUD_TYPE: CRUD_TYPE.INSERT,
});

// 선택한 BOD 마다 클릭 행 기준으로 행 묶음을 삽입한 새 배열을 돌려준다(입력 배열은 바꾸지 않는다).
//   클릭 행 FROM_SITE == BOD second_site → T 모드(같은 From Site 의 Trans Mode 추가: SHIP_ 행만 복제),
//   아니면 S 모드(새 From Site 묶음: SHIP_/WH_IN 등 복제, SHIP 이 아닌 행은 '-' 처리).
export const buildInsertedRows = (rows: Row[], clicked: Row, picks: BodMasterPick[]): Row[] => {
  const out = [...rows];
  const callers = callerRowsOf(rows, clicked);
  const sFromSite = s(clicked.FROM_SITE);
  const sTransMode = s(clicked.TRANSPORT_MODE);
  const sLtDay = s(clicked.LT_DAY);

  picks.forEach(bod => {
    const selectedIdx = out.indexOf(clicked);
    if (selectedIdx < 0) return;

    if (sFromSite === bod.secondSite) {
      let idx = getNewInsertRowIndex(out, selectedIdx, 'T');
      callers
        .filter(
          c =>
            s(c.MEASURE).includes('SHIP_') &&
            s(c.FROM_SITE) === sFromSite &&
            s(c.TRANSPORT_MODE) === sTransMode &&
            s(c.LT_DAY) === sLtDay
        )
        .forEach(c => {
          out.splice(
            idx++,
            0,
            newRow(c, bod, {
              FROM_SITE_NAME: bod.secondSiteName,
              FROM_SITE: bod.secondSite,
              TRANSPORT_MODE: bod.transportMode,
              LT_DAY: bod.ltTotal,
              BOD_ID: bod.bodId,
            })
          );
        });
      return;
    }

    let idx = getNewInsertRowIndex(out, selectedIdx, 'S') + 1;
    callers
      .filter(
        c =>
          s(c.MEASURE).includes('SHIP_') ||
          s(c.MEASURE) === 'WH_IN' ||
          (s(c.FROM_SITE) === sFromSite && s(c.TRANSPORT_MODE) === sTransMode && s(c.LT_DAY) === sLtDay)
      )
      .forEach(c => {
        const measure = s(c.MEASURE);
        if (measure !== 'WH_IN' && s(c.TRANSPORT_MODE) !== sTransMode && s(c.LT_DAY) !== sLtDay) return;
        const isShip = measure.includes('SHIP');
        const hasFromSite = isShip || measure === 'WH_IN';
        out.splice(
          Math.min(idx++, out.length),
          0,
          newRow(c, bod, {
            FROM_SITE_NAME: hasFromSite ? bod.secondSiteName : '-',
            FROM_SITE: hasFromSite ? bod.secondSite : '-',
            TRANSPORT_MODE: isShip ? bod.transportMode : '-',
            LT_DAY: isShip ? bod.ltTotal : 0,
            BOD_ID: isShip ? bod.bodId : '-',
          })
        );
      });
  });
  return out;
};

// AS-IS 는 길이 1 이하 값의 '-' 만 지운다(.cs:2972-2992).
const stripDash = (v: unknown): string => {
  const str = s(v);
  return str.length <= 1 ? str.replace('-', '') : str;
};

export interface InsertSaveContext {
  userId: string;
  timeZone: string;
  bucketType: string; // 조회조건 Bucket
  planStartYyyymmdd: string;
  planType: string;
  seq: string;
  dynBindings: string[]; // 그리드의 동적 컬럼 binding(표시 순서)
}

export type InsertSaveResult =
  | { ok: true; rows: SaveCellRow[] }
  | { ok: false; msg: typeof MSG.QTY_NEGATIVE | typeof MSG.QTY_MAX | typeof MSG.INSERT_ROW_NO_VALUE };

// 삽입 행 → 저장 행. 검증(.cs:2787-2824): SHIP_PLAN_AMEND 삽입 행은 값이 하나 이상 있어야 하고, 음수·최대치 초과 금지.
//   SHIP_PLAN_AMEND 가 아닌 삽입 행은 첫 동적 컬럼 일자에 수량 0 한 건(.cs:2936-3029).
//   SHIP_PLAN_AMEND 삽입 행은 값이 있는 셀마다 한 건(.cs:3031-3125). 동적 컬럼 종류(D_/W_)는 조회 Bucket 을 따른다.
export const buildInsertSaveRows = (rows: Row[], ctx: InsertSaveContext): InsertSaveResult => {
  const out: SaveCellRow[] = [];
  const firstDyn = ctx.dynBindings.find(b => dynColKindOf(b) && dynColKindOf(b) !== 'M');

  const base = (r: Row): Omit<SaveCellRow, 'yyyymmdd' | 'qty'> => ({
    a: 'I',
    activeFlag: 'I',
    divisionId: s(r.DIVISION_ID),
    planStartYyyymmdd: ctx.planStartYyyymmdd,
    planType: ctx.planType,
    seq: ctx.seq,
    bizType: s(r.BIZ_TYPE),
    projectCode: s(r.PROJECT_CODE),
    itemId: s(r.ITEM_ID),
    toSite: s(r.TO_SITE),
    incoterms: s(r.INCOTERMS),
    fromSite: s(r.FROM_SITE),
    bodId: s(r.BOD_ID),
    measure: s(r.MEASURE),
    originFromDivisionId: stripDash(r.ORIGIN_FROM_DIVISION_ID),
    originToDivisionId: stripDash(r.ORIGIN_TO_DIVISION_ID),
    electrodeType: stripDash(s(r.ELECTRODE_TYPE) === '/' ? '' : r.ELECTRODE_TYPE),
    fixReason: '',
    bucketType: ctx.bucketType,
    transMode: s(r.TRANSPORT_MODE),
    createdBy: ctx.userId,
    lastUpdatedBy: ctx.userId,
    timeZone: ctx.timeZone,
    debugMode: 'F',
  });

  for (const r of rows.filter(isInsertedRow)) {
    if (s(r.MEASURE) !== MEASURE.SHIP_PLAN_AMEND) {
      if (firstDyn) out.push({ ...base(r), yyyymmdd: firstDyn.slice(2, 10), qty: '0' });
      continue;
    }
    let entered = false;
    for (const b of ctx.dynBindings) {
      if (!dynColKindOf(b) || dynColKindOf(b) === 'M') continue;
      const raw = s(r[b]).replace(/,/g, '');
      if (raw === '') continue;
      const qty = Number(raw);
      if (qty < 0) return { ok: false, msg: MSG.QTY_NEGATIVE };
      if (Math.trunc(qty) > QTY_MAX) return { ok: false, msg: MSG.QTY_MAX };
      entered = true;
      out.push({ ...base(r), yyyymmdd: b.slice(2, 10), qty: raw });
    }
    if (!entered) return { ok: false, msg: MSG.INSERT_ROW_NO_VALUE };
  }
  return { ok: true, rows: out };
};
