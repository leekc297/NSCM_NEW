import type { FlexGrid } from '@mescius/wijmo.grid';
import { describe, expect, it } from 'vitest';

import { buildUnfixPayload } from './productionPlanFixSave';

// SCM_SYS_CALENDAR_M 실측: 9/28~30 = (202609, 40), 10/1~4 = (202610, 40), 12/29~31 = (202512, 01), 1/1~4 = (202601, 01).
//   GET SP 는 (BASIS_YYYYMM, ISO_WEEK) 별로 W_ 컬럼을 만들어 월에 걸친 주는 W_ 가 둘로 갈린다.
const BINDINGS = [
  'W_20260940',
  'D_20260928',
  'D_20260929',
  'D_20260930',
  'W_20261040',
  'D_20261001',
  'D_20261002',
  'D_20261003',
  'D_20261004',
  'W_20251201',
  'D_20251229',
  'D_20251230',
  'D_20251231',
  'W_20260101',
  'D_20260101',
  'D_20260102',
];

const row: Record<string, unknown> = {
  MEASURE: 'Prod Plan',
  DIVISION_ID: 'D1',
  OPERATION_GROUP: 'A',
  SCM_SITE_ID: 'S1',
  ITEM_ID: 'I1',
  LINE_ID: 'L1',
  OPERATION_ID: 'O1',
};
BINDINGS.forEach(b => {
  row[b] = '10';
});

const gridSelecting = (binding: string): FlexGrid => {
  const col = BINDINGS.indexOf(binding);
  const range = { row: 0, col, topRow: 0, bottomRow: 0, leftCol: col, rightCol: col };
  return {
    selectedRanges: [range],
    selection: range,
    rows: [{ dataItem: row }],
    columns: BINDINGS.map(b => ({ binding: b })),
  } as unknown as FlexGrid;
};

const datesOf = (binding: string): string[] =>
  buildUnfixPayload(gridSelecting(binding)).map(e => e.YYYYMMDD).sort();

describe('buildUnfixPayload W_ 확장', () => {
  it('월에 걸친 주는 선택한 W_ 의 월 쪽 일자만 수집한다', () => {
    expect(datesOf('W_20260940')).toEqual(['20260928', '20260929', '20260930']);
    expect(datesOf('W_20261040')).toEqual(['20261001', '20261002', '20261003', '20261004']);
  });

  it('연말·연초 주도 선택한 W_ 의 월 쪽 일자만 수집한다', () => {
    expect(datesOf('W_20251201')).toEqual(['20251229', '20251230', '20251231']);
    expect(datesOf('W_20260101')).toEqual(['20260101', '20260102']);
  });

  it('D_ 셀 선택은 해당 일자 한 건만 수집한다', () => {
    expect(datesOf('D_20261002')).toEqual(['20261002']);
  });

  it('BUCKET_TYPE 은 AS-IS 처럼 빈값으로 보낸다', () => {
    const entries = buildUnfixPayload(gridSelecting('D_20261002'));
    expect(entries.map(e => e.BUCKET_TYPE)).toEqual(['']);
  });

  it('M_/수량 없는 셀은 대상이 아니다', () => {
    row.D_20260928 = '';
    expect(datesOf('W_20260940')).toEqual(['20260929', '20260930']);
    row.D_20260928 = '10';
  });
});
