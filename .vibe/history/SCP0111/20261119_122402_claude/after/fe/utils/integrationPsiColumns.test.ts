import { describe, expect, it } from 'vitest';

import { buildPivotColumns, periodMonthRange } from './integrationPsiColumns';

// AS-IS SetCalendar(SCP0111_IntegrationPSI.cs:340~356)가 CalendarMonth 로 열거하는 From~To 월 구간.
describe('periodMonthRange', () => {
  it('같은 해 구간을 연속 월로 열거한다', () => {
    expect(periodMonthRange('202609', '202612')).toEqual([
      '202609',
      '202610',
      '202611',
      '202612',
    ]);
  });

  it('연도 경계를 넘어간다(12월 → 익년 1월)', () => {
    expect(periodMonthRange('202611', '202702')).toEqual([
      '202611',
      '202612',
      '202701',
      '202702',
    ]);
  });

  it('From == To 면 1개월', () => {
    expect(periodMonthRange('202609', '202609')).toEqual(['202609']);
  });

  it('AS-IS 기본 조회기간 6개월(시작월 + 5)을 재현한다', () => {
    expect(periodMonthRange('202609', '202702')).toHaveLength(6);
  });

  it('From > To / 형식 불량 / 빈 값은 빈 배열(컬럼 미생성)', () => {
    expect(periodMonthRange('202612', '202609')).toEqual([]);
    expect(periodMonthRange('2026-09', '2026-12')).toEqual([]);
    expect(periodMonthRange('', '')).toEqual([]);
    expect(periodMonthRange('202613', '202614')).toEqual([]); // 월 범위 밖
  });
});

describe('buildPivotColumns', () => {
  const fixed = new Set(['ITEM_ID', 'MEASURE', 'PLANT_ID']);

  it('조회 전(행 0건)에도 조회기간 월을 컬럼으로 만든다 — AS-IS Form_Load SetCalendar', () => {
    const cols = buildPivotColumns([], fixed, ['202609', '202610']);
    expect(cols.map(c => c.binding)).toEqual(['202609', '202610']);
    expect(cols.map(c => c.header)).toEqual(['2026-09', '2026-10']);
  });

  it('기간과 조회결과 월을 union 한다 — 기간을 좁혀도 응답 데이터가 숨지 않는다', () => {
    const rows = [{ ITEM_ID: 'A', '202611': 10, '202612': 20 }];
    const cols = buildPivotColumns(rows, fixed, ['202609', '202610']);
    expect(cols.map(c => c.binding)).toEqual(['202609', '202610', '202611', '202612']);
  });

  it('고정 컬럼명과 6자리 아닌 키는 pivot 으로 만들지 않는다', () => {
    const rows = [{ ITEM_ID: 'A', MEASURE: 'PSI', CRUD_TYPE: 'I', '202609': 1 }];
    expect(buildPivotColumns(rows, fixed, []).map(c => c.binding)).toEqual(['202609']);
  });

  it('기간도 행도 없으면 빈 배열 — 그리드는 고정 컬럼만 렌더', () => {
    expect(buildPivotColumns([], fixed, [])).toEqual([]);
  });
});
