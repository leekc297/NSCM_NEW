import { describe, expect, test } from 'vitest';

import { mapKpi } from './kpiSummary.map';

// 실제 o_rc1 컬럼(P_DMD0001_GET_KPI, DB 실측): KPI_KEY·KPI_VALUE·UNIT·DELTA_VALUE·DELTA_DIR.
//   라벨/아이콘/accent 는 FE 고정(KPI_KEY 로 조인). deltaLabel='전월대비' 고정.
const ROWS = [
  { KPI_KEY: 'managed', KPI_VALUE: '4', UNIT: 'EA', DELTA_VALUE: null, DELTA_DIR: 'none' },
  { KPI_KEY: 'asValue', KPI_VALUE: '28.6', UNIT: '억원', DELTA_VALUE: '+2.1억원 (▲ 7.9%)', DELTA_DIR: 'up' },
];

describe('mapKpi', () => {
  test('KPI_KEY 로 FE 메타(labelCode/icon/accent) 조인 + 값/단위/증감 매핑, null delta → —', () => {
    const cards = mapKpi(ROWS);
    expect(cards).toHaveLength(2);
    expect(cards[0]).toEqual({
      key: 'managed',
      labelCode: 'LBL01282',
      labelFallback: '_관리 대상 품목',
      value: '4',
      unit: 'EA',
      icon: 'product',
      accent: 'blue',
      deltaValue: '—',
      deltaDir: 'none',
    });
    expect(cards[1].accent).toBe('green');
    expect(cards[1].deltaValue).toBe('+2.1억원 (▲ 7.9%)');
  });

  test('미지 KPI_KEY 는 건너뛴다(FE 메타 없음)', () => {
    expect(
      mapKpi([{ KPI_KEY: 'zzz', KPI_VALUE: '1', UNIT: 'x', DELTA_VALUE: null, DELTA_DIR: 'none' }])
    ).toEqual([]);
  });
});
