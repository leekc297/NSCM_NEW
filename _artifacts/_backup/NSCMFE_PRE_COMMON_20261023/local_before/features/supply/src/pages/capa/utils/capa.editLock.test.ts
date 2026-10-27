import { describe, expect, it } from 'vitest';

import type { ComboResponse, RawFlexGridColumnConfig } from '@foundation/models';
import { buildLeafColumnDataMap } from '@foundation/utils';

import type { CapaRow } from '../capa.types';

import { type EditContext, isCellEditable } from './capa.editLock';

// AS-IS EditButton(cs:578-598): LINE ASSIGN 행은 LaneQtyOfLineAssign 콤보를 7키로 좁혀 후보가 있을 때만 LANE_QTY 를 연다.

const LANE_ATTRIBUTE2 =
  'DIVISION_ID:DIVISION_ID,COMPANY_ID:COMPANY_ID,SITE_ID:SITE_ID,LINE_ID:LINE_ID,OPERATION_ID:OPERATION_ID,ELECTRODE_TYPE:ELECTRODE_TYPE,ITEM_ID:ITEM_ID';

const key = (patch: Record<string, string> = {}) => ({
  DIVISION_ID: '81',
  COMPANY_ID: 'C1',
  SITE_ID: 'S1',
  LINE_ID: 'L1',
  OPERATION_ID: 'E2000',
  ELECTRODE_TYPE: 'A',
  ITEM_ID: 'I1',
  ...patch,
});

const COMBO_ROWS: ComboResponse[] = [
  { CODE: '1', NAME: '1', ...key() },
  { CODE: '2', NAME: '2', ...key() },
  { CODE: '3', NAME: '3', ...key({ ITEM_ID: 'I2' }) },
];

const laneRow = (patch: Record<string, unknown> = {}): CapaRow =>
  ({
    ...key(),
    EDITORBLE_YN: 'Y',
    LOSS_CODE: 'LA001',
    CATEGORY_ID: 'LINE ASSIGN',
    USER_ID_1: 'u1',
    ...patch,
  }) as unknown as CapaRow;

const ctxWith = (count: number): EditContext => ({
  isCurrentVersion: true,
  userId: 'u1',
  groupId: 'X',
  laneQtyCandidateCountOf: () => count,
});

describe('isCellEditable — LANE_QTY 후보 수 게이트', () => {
  it('후보 0건이면 권한 행이어도 잠금', () => {
    expect(isCellEditable(laneRow(), 'LANE_QTY', ctxWith(0))).toBe(false);
  });

  it('후보 1건 이상이면 개방', () => {
    expect(isCellEditable(laneRow(), 'LANE_QTY', ctxWith(1))).toBe(true);
  });

  it('LINE ASSIGN 이 아닌 행은 후보가 있어도 잠금', () => {
    expect(isCellEditable(laneRow({ CATEGORY_ID: 'YIELD' }), 'LANE_QTY', ctxWith(3))).toBe(false);
  });

  it('권한이 없으면 후보가 있어도 잠금', () => {
    expect(isCellEditable(laneRow({ USER_ID_1: 'other' }), 'LANE_QTY', ctxWith(3))).toBe(false);
  });
});

describe('LANE_QTY 후보 수 원천 — 컬럼 dataMap(ATTRIBUTE2 7키)', () => {
  const column: RawFlexGridColumnConfig = {
    colNm: 'LANE_QTY',
    colLblNm: 'Lane',
    display: true,
    dataMap: COMBO_ROWS,
    attribute2: LANE_ATTRIBUTE2,
  };
  const countOf = (row: CapaRow): number =>
    buildLeafColumnDataMap(column)?.getDisplayValues(row).length ?? 0;

  it('7키가 일치하는 행만 센다(AS-IS DataTable.Select 와 동일)', () => {
    expect(countOf(laneRow())).toBe(2);
    expect(countOf(laneRow({ ITEM_ID: 'I2' }))).toBe(1);
  });

  it('키가 하나라도 다르면 0건', () => {
    expect(countOf(laneRow({ ITEM_ID: 'NONE' }))).toBe(0);
    expect(countOf(laneRow({ OPERATION_ID: 'E1000' }))).toBe(0);
  });

  it('콤보 응답이 비어 있으면 dataMap 이 없어 0건', () => {
    expect(buildLeafColumnDataMap({ ...column, dataMap: [] })).toBeUndefined();
  });
});
