import type { BodMasterPick } from 'features/supply/src/components';
import { describe, expect, it } from 'vitest';

import { MSG } from '../shipment-plan-fg.constants';

import {
  bodCallerKeys,
  buildInsertedRows,
  buildInsertSaveRows,
  canOpenBodPopup,
  getNewInsertRowIndex,
  isInsertedRow,
} from './shipment-plan-fg.insert';

type Row = Record<string, unknown>;

const pick = (over: Partial<BodMasterPick> = {}): BodMasterPick => ({
  bodId: 'BOD9',
  firstSite: 'TS1',
  firstSiteName: 'To Site 1',
  secondSite: 'FS9',
  secondSiteName: 'From Site 9',
  incoterms: 'FOB',
  transportMode: 'SEA',
  ltTotal: '30',
  shipFrozen: '20261201',
  bodFromYyyymmdd: '20261101',
  bodToYyyymmdd: '20271231',
  ...over,
});

// KEY_IDX K1 묶음: FS1/AIR 출하 2행 + 비출하 1행('-'), 이어서 다른 묶음 K2.
const sample = (): Row[] => [
  { KEY_IDX: 'K1', MEASURE: 'SHIP_PLAN', FROM_SITE: 'FS1', FROM_SITE_NAME: 'Site One', TRANSPORT_MODE: 'AIR', LT_DAY: 5, DIVISION_ID: '40', TO_SITE: 'TS1', BOD_ID: 'B1' },
  { KEY_IDX: 'K1', MEASURE: 'SHIP_PLAN_AMEND', FROM_SITE: 'FS1', FROM_SITE_NAME: 'Site One', TRANSPORT_MODE: 'AIR', LT_DAY: 5, DIVISION_ID: '40', TO_SITE: 'TS1', BOD_ID: 'B1' },
  { KEY_IDX: 'K1', MEASURE: 'INV', FROM_SITE: '-', FROM_SITE_NAME: '-', TRANSPORT_MODE: '-', LT_DAY: 0 },
  { KEY_IDX: 'K2', MEASURE: 'SHIP_PLAN', FROM_SITE: 'FS2', FROM_SITE_NAME: 'Site Two', TRANSPORT_MODE: 'SEA', LT_DAY: 9 },
];

describe('canOpenBodPopup', () => {
  it('Trans Mode/From Site 셀이고 값이 3자 이상인 기존 행만 연다', () => {
    const [r0, , r2] = sample();
    expect(canOpenBodPopup(r0, 'TRANSPORT_MODE')).toBe(true);
    expect(canOpenBodPopup(r0, 'FROM_SITE_NAME')).toBe(true);
    expect(canOpenBodPopup(r0, 'ITEM_ID')).toBe(false);
    expect(canOpenBodPopup(r2, 'TRANSPORT_MODE')).toBe(false);
    expect(canOpenBodPopup({ ...r0, CRUD_TYPE: 'I' }, 'TRANSPORT_MODE')).toBe(false);
  });
});

describe('bodCallerKeys', () => {
  it('division+from+to+trans+bod 를 이어 붙인다', () => {
    expect(bodCallerKeys([sample()[0]])).toEqual(['40FS1TS1AIRB1']);
  });
});

describe('getNewInsertRowIndex', () => {
  it('T 모드는 같은 From Site 가 끝나고 Trans Mode 가 비거나 - 인 첫 행 위치', () => {
    expect(getNewInsertRowIndex(sample(), 0, 'T')).toBe(2);
  });
  it('S 모드는 From Site 가 - 인 행 바로 앞(삽입은 그 다음 위치)', () => {
    expect(getNewInsertRowIndex(sample(), 0, 'S')).toBe(1);
  });
});

describe('buildInsertedRows', () => {
  it('T 모드(클릭 From Site == BOD second site): 같은 조건의 SHIP_ 행만 복제해 묶음 끝에 넣는다', () => {
    const rows = sample();
    const out = buildInsertedRows(rows, rows[0], [pick({ secondSite: 'FS1', secondSiteName: 'Site One' })]);
    expect(out).toHaveLength(6);
    expect(rows).toHaveLength(4); // 입력 배열은 그대로
    const ins = out.filter(isInsertedRow);
    expect(ins.map(r => r.MEASURE)).toEqual(['SHIP_PLAN', 'SHIP_PLAN_AMEND']);
    expect(out.indexOf(ins[0])).toBe(2);
    expect(ins[0]).toMatchObject({ FROM_SITE: 'FS1', TRANSPORT_MODE: 'SEA', BOD_ID: 'BOD9', TO_SITE: 'TS1', LT_DAY: '30' });
  });

  it('S 모드: 새 From Site 묶음을 넣고 출하가 아닌 행은 - 로 채운다', () => {
    const rows = sample();
    const out = buildInsertedRows(rows, rows[0], [pick()]);
    const ins = out.filter(isInsertedRow);
    expect(ins.length).toBeGreaterThan(0);
    ins.forEach(r => expect(r.KEY_IDX).toBe('K1'));
    expect(out.indexOf(ins[0])).toBe(2);
    const ship = ins.find(r => r.MEASURE === 'SHIP_PLAN_AMEND');
    expect(ship).toMatchObject({ FROM_SITE: 'FS9', TRANSPORT_MODE: 'SEA', BOD_ID: 'BOD9' });
  });
});

describe('buildInsertSaveRows', () => {
  const ctx = {
    userId: 'U',
    timeZone: '',
    bucketType: 'DAILY',
    planStartYyyymmdd: '20261116',
    planType: 'PR',
    seq: '1',
    dynBindings: ['D_20261116', 'D_20261117', 'M_202611'],
  };
  const ins = (over: Row): Row => ({ CRUD_TYPE: 'I', MEASURE: 'SHIP_PLAN_AMEND', FROM_SITE: 'FS9', ...over });

  it('AMEND 삽입 행은 값이 있는 셀마다 I 한 건', () => {
    const res = buildInsertSaveRows([ins({ D_20261117: '1,200' })], ctx);
    expect(res.ok).toBe(true);
    if (!res.ok) return;
    expect(res.rows).toHaveLength(1);
    expect(res.rows[0]).toMatchObject({ activeFlag: 'I', yyyymmdd: '20261117', qty: '1200', bucketType: 'DAILY' });
  });

  it('AMEND 가 아닌 삽입 행은 첫 동적 컬럼에 수량 0', () => {
    const res = buildInsertSaveRows([ins({ MEASURE: 'SHIP_PLAN' })], ctx);
    expect(res.ok && res.rows[0]).toMatchObject({ yyyymmdd: '20261116', qty: '0' });
  });

  it('값이 하나도 없으면 MSG01243, 음수면 MSG00225', () => {
    expect(buildInsertSaveRows([ins({})], ctx)).toEqual({ ok: false, msg: MSG.INSERT_ROW_NO_VALUE });
    expect(buildInsertSaveRows([ins({ D_20261116: -1 })], ctx)).toEqual({ ok: false, msg: MSG.QTY_NEGATIVE });
  });

  it('삽입 행이 아니면 무시한다', () => {
    expect(buildInsertSaveRows([{ MEASURE: 'SHIP_PLAN_AMEND' }], ctx)).toEqual({ ok: true, rows: [] });
  });
});
