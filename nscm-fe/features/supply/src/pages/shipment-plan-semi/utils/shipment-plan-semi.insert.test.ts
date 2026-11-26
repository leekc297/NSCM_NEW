import type { BodMasterPick } from 'features/supply/src/components';
import { describe, expect, it } from 'vitest';

import { CRUD_TYPE } from '@foundation/constants';

import { MEASURE, MSG } from '../shipment-plan-semi.constants';

import {
  buildInsertedRows,
  buildInsertSaveRows,
  canOpenBodPopup,
  getNewInsertRowIndex,
} from './shipment-plan-semi.insert';

type Row = Record<string, unknown>;

const row = (over: Row = {}): Row => ({
  DIVISION_ID: '40',
  OPERATION_GROUP: 'A',
  ITEM_ID: 'ITEM1',
  FROM_SITE: 'S1',
  TO_SITE: 'S2',
  TRANSPORT_MODE: 'TRUCK',
  T0_SITE_DESCRIPTION: 'Site Two',
  MEASURE: MEASURE.SHIP_PLAN_AMEND,
  FROM_YYYYMMDD: '20261123',
  ...over,
});

const pick = (over: Partial<BodMasterPick> = {}): BodMasterPick =>
  ({
    firstSite: 'S1',
    firstSiteName: 'Site One',
    secondSite: 'S3',
    secondSiteName: 'Site Three',
    transportMode: 'SEA',
    ltTotal: '3',
    bodId: 'BOD9',
    shipFrozen: '20261130',
    bodFromYyyymmdd: '20260101',
    bodToYyyymmdd: '20271231',
    ...over,
  }) as BodMasterPick;

describe('canOpenBodPopup', () => {
  it('opens only on TRANSPORT_MODE / T0_SITE_DESCRIPTION with value longer than 2', () => {
    expect(canOpenBodPopup(row(), 'TRANSPORT_MODE')).toBe(true);
    expect(canOpenBodPopup(row(), 'T0_SITE_DESCRIPTION')).toBe(true);
    expect(canOpenBodPopup(row(), 'ITEM_ID')).toBe(false);
    expect(canOpenBodPopup(row({ TRANSPORT_MODE: '-' }), 'TRANSPORT_MODE')).toBe(false);
  });
  it('rejects inserted / deleted rows', () => {
    expect(canOpenBodPopup(row({ CRUD_TYPE: CRUD_TYPE.INSERT }), 'TRANSPORT_MODE')).toBe(false);
    expect(canOpenBodPopup(row({ CRUD_TYPE: CRUD_TYPE.DELETE }), 'TRANSPORT_MODE')).toBe(false);
  });
});

describe('getNewInsertRowIndex', () => {
  it('S mode stops before next from-site group after a separator row', () => {
    const rows = [
      row({ FROM_SITE: 'S1' }),
      row({ FROM_SITE: 'S1' }),
      row({ FROM_SITE: 'X', TRANSPORT_MODE: '' }),
      row({ FROM_SITE: 'S9' }),
    ];
    expect(getNewInsertRowIndex(rows, 0, 'S')).toBe(2);
  });
  it('S mode returns last row index when group runs to end', () => {
    const rows = [row(), row()];
    expect(getNewInsertRowIndex(rows, 0, 'S')).toBe(1);
  });
  it('T mode stops before TOTAL row', () => {
    const rows = [row({ TO_SITE: 'S1' }), row({ TO_SITE: 'S1' }), row({ TO_SITE: 'Z', TRANSPORT_MODE: 'TOTAL' })];
    expect(getNewInsertRowIndex(rows, 0, 'T')).toBe(1);
  });
  it('T mode reaches past-end index when nothing breaks', () => {
    const rows = [row({ TO_SITE: 'S1' })];
    expect(getNewInsertRowIndex(rows, 0, 'T')).toBe(1);
  });
});

describe('buildInsertedRows', () => {
  it('copies SHIP measure rows of the clicked group after it with BOD values', () => {
    const clicked = row();
    const inv = row({ MEASURE: 'INVENTORY' });
    const other = row({ ITEM_ID: 'ITEM2' });
    const rows = [clicked, inv, other];
    const out = buildInsertedRows(rows, clicked, [pick()]);
    expect(out).toHaveLength(4);
    expect(rows).toHaveLength(3);
    const ins = out.find(r => r.CRUD_TYPE === CRUD_TYPE.INSERT);
    expect(ins).toMatchObject({
      ITEM_ID: 'ITEM1',
      FROM_SITE: 'S1',
      TO_SITE: 'S3',
      BOD_ID: 'BOD9',
      TRANSPORT_MODE: 'SEA',
      T0_SITE_DESCRIPTION: 'Site Three',
      SHIP_FROZEN: '20261130',
      MEASURE: MEASURE.SHIP_PLAN_AMEND,
    });
  });
});

describe('buildInsertSaveRows', () => {
  const ctx = { userId: 'U1', timeZone: 'Asia/Seoul', planType: 'MA', seq: '1', weekly: false };
  const dyn = ['D_20261123', 'D_20261124', 'W_20261123'];

  it('daily AMEND row saves entered D_ cells only', () => {
    const r = row({ CRUD_TYPE: CRUD_TYPE.INSERT, D_20261124: '1,000' });
    const res = buildInsertSaveRows([r], { ...ctx, dynBindings: dyn });
    expect(res.ok).toBe(true);
    if (!res.ok) return;
    expect(res.rows).toHaveLength(1);
    expect(res.rows[0]).toMatchObject({ activeFlag: 'I', yyyymmdd: '20261124', qty: '1000', bucketType: 'DAILY' });
  });
  it('daily AMEND row without value is rejected', () => {
    const r = row({ CRUD_TYPE: CRUD_TYPE.INSERT });
    expect(buildInsertSaveRows([r], { ...ctx, dynBindings: dyn })).toEqual({
      ok: false,
      msg: MSG.INSERT_ROW_NO_VALUE,
    });
  });
  it('daily non-AMEND row saves one zero record on first D_ date', () => {
    const r = row({ CRUD_TYPE: CRUD_TYPE.INSERT, MEASURE: 'SHIP_PLAN' });
    const res = buildInsertSaveRows([r], { ...ctx, dynBindings: dyn });
    expect(res.ok && res.rows).toEqual([expect.objectContaining({ yyyymmdd: '20261123', qty: '0' })]);
  });
  it('weekly saves every W_ column with 0 default', () => {
    const r = row({ CRUD_TYPE: CRUD_TYPE.INSERT });
    const res = buildInsertSaveRows([r], { ...ctx, weekly: true, dynBindings: [...dyn, 'W_20261130'] });
    expect(res.ok && res.rows.map(x => [x.yyyymmdd, x.qty, x.bucketType])).toEqual([
      ['20261123', '0', 'WEEKLY'],
      ['20261130', '0', 'WEEKLY'],
    ]);
  });
  it('rejects negative qty', () => {
    const r = row({ CRUD_TYPE: CRUD_TYPE.INSERT, D_20261123: '-1' });
    expect(buildInsertSaveRows([r], { ...ctx, dynBindings: dyn })).toEqual({ ok: false, msg: MSG.QTY_NEGATIVE });
  });
  it('ignores non-inserted rows', () => {
    const res = buildInsertSaveRows([row()], { ...ctx, dynBindings: dyn });
    expect(res).toEqual({ ok: true, rows: [] });
  });
});
