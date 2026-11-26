/**
 * DMF0082 — 참고값 컬럼(LAST_UPDATED_BY · LAST_UPDATE_DATE)은 병합 키가 아니다 (사용자 요청 2026-10-27).
 *
 * 화면 셀 병합(FcstHeaderMergeManager)과 신규행 위치용 그룹 판정(groupKeyBindings)이 같은 기준이어야 한다 —
 *   두 컬럼이 키에 끼면 그 오른쪽 컬럼(SENDER_NAME · CELL_PROD_SITE_ID · CURRENCY …)의 블록이 수정일·수정자 차이로 갈린다.
 */
import { describe, expect, it } from 'vitest';

import { compareForecastRows, groupKeyBindings, type GroupKeyColumn } from '../components/ForecastPriceGridUtils';
import { REFERENCE_ONLY_BINDINGS } from '../forecast-price.constants';

const col = (binding: string, visible = true): GroupKeyColumn => ({ binding, visible });

/** 메타 기본 순서(SORT_ORDER_NO) 축약 — 340/350 의 두 참고값 컬럼 오른쪽에 키 컬럼이 이어진다. */
const COLUMNS: GroupKeyColumn[] = [
  col('DIVISION_ID'),
  col('SCM_SITE_ID'),
  col('ITEM_ID'),
  col('LAST_UPDATE_DATE'),
  col('LAST_UPDATED_BY'),
  col('SENDER_NAME'),
  col('CELL_PROD_SITE_ID'),
  col('CURRENCY'),
  col('MEASURE'),
  col('D_20261026'),
];

describe('REFERENCE_ONLY_BINDINGS', () => {
  it('두 컬럼만 담는다', () => {
    expect([...REFERENCE_ONLY_BINDINGS].sort()).toEqual(['LAST_UPDATED_BY', 'LAST_UPDATE_DATE']);
  });
});

describe('compareForecastRows — 참고값 컬럼은 정렬 키가 아니다', () => {
  const SORT_COLS = ['DIVISION_ID', 'ITEM_ID', 'LAST_UPDATE_DATE', 'LAST_UPDATED_BY', 'CURRENCY', 'MEASURE'];
  const order = new Map<string, number>([['MKT_FCST', 0], ['LOC', 1]]);
  // 수정일이 늦은 쪽이 CURRENCY 는 앞선다 → 두 컬럼을 키로 쓰면 순서가 뒤집힌다
  const a = { DIVISION_ID: '81', ITEM_ID: 'X1', LAST_UPDATE_DATE: '2026-10-27 10:00:00', LAST_UPDATED_BY: 'zz', CURRENCY: 'EUR', MEASURE: 'MKT_FCST' };
  const b = { DIVISION_ID: '81', ITEM_ID: 'X1', LAST_UPDATE_DATE: '2026-01-01 00:00:00', LAST_UPDATED_BY: 'aa', CURRENCY: 'USD', MEASURE: 'MKT_FCST' };

  it('두 컬럼 값과 무관하게 다음 키(CURRENCY)로 정한다', () => {
    expect(compareForecastRows(a, b, SORT_COLS, order)).toBeLessThan(0);
    expect(compareForecastRows(b, a, SORT_COLS, order)).toBeGreaterThan(0);
  });

  it('두 컬럼을 표시하든 안 하든 정렬 결과가 같다', () => {
    const plain = SORT_COLS.filter(c => !REFERENCE_ONLY_BINDINGS.has(c));
    expect(Math.sign(compareForecastRows(a, b, SORT_COLS, order))).toBe(Math.sign(compareForecastRows(a, b, plain, order)));
  });

  it('키가 모두 같으면 Measure 팝업 순서로 정한다 (두 컬럼 차이 무시)', () => {
    const c = { ...a, CURRENCY: 'USD', MEASURE: 'LOC' };
    expect(compareForecastRows(b, c, SORT_COLS, order)).toBeLessThan(0);
  });
});

describe('groupKeyBindings — 참고값 컬럼 제외', () => {
  it('오른쪽 컬럼을 누르면 키에 두 컬럼이 들어가지 않는다', () => {
    expect(groupKeyBindings(COLUMNS, COLUMNS.findIndex(c => c.binding === 'CURRENCY'))).toEqual([
      'DIVISION_ID',
      'SCM_SITE_ID',
      'ITEM_ID',
      'SENDER_NAME',
      'CELL_PROD_SITE_ID',
      'CURRENCY',
    ]);
  });

  it('참고값 컬럼 자체를 누르면 병합 축이 아니므로 MEASURE 직전까지로 폴백한다 (두 컬럼 제외)', () => {
    expect(groupKeyBindings(COLUMNS, COLUMNS.findIndex(c => c.binding === 'LAST_UPDATED_BY'))).toEqual([
      'DIVISION_ID',
      'SCM_SITE_ID',
      'ITEM_ID',
      'SENDER_NAME',
      'CELL_PROD_SITE_ID',
      'CURRENCY',
    ]);
  });

  it('MEASURE 폴백도 두 컬럼을 뺀다', () => {
    expect(groupKeyBindings(COLUMNS, -1)).toEqual(['DIVISION_ID', 'SCM_SITE_ID', 'ITEM_ID', 'SENDER_NAME', 'CELL_PROD_SITE_ID', 'CURRENCY']);
  });

  it('두 컬럼이 없으면 종전과 같다', () => {
    const plain = COLUMNS.filter(c => !REFERENCE_ONLY_BINDINGS.has(c.binding));
    expect(groupKeyBindings(plain, plain.findIndex(c => c.binding === 'CURRENCY'))).toEqual([
      'DIVISION_ID',
      'SCM_SITE_ID',
      'ITEM_ID',
      'SENDER_NAME',
      'CELL_PROD_SITE_ID',
      'CURRENCY',
    ]);
  });
});
