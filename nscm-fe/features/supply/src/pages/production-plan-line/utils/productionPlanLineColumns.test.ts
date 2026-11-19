import { describe, expect, it } from 'vitest';

import { BUCKET_TYPE } from '../production-plan-line.constants';

import { buildPivotColumns } from './productionPlanLineColumns';
import { EMPTY_DRILLDOWN, toggleDrilldown } from './productionPlanLineDrilldown';

// 태그 형식(PKG_SCP0013 실측): M_yyyymm · W_(BASIS_YYYYMM+ISO_WEEK) · D_yyyymmdd.
// 2026-09: ISO_WEEK 37=09-07~09-13, 38=09-14~09-20. 2026-10: ISO_WEEK 41=10-05~10-11, 42=10-12~10-18.
const SEP_KEYS = [
  'M_202609',
  'W_20260937',
  'W_20260938',
  'D_20260907',
  'D_20260908',
  'D_20260909',
  'D_20260910',
  'D_20260911',
  'D_20260912',
  'D_20260913',
  'D_20260914',
  'D_20260915',
  'D_20260916',
  'D_20260917',
  'D_20260918',
  'D_20260919',
  'D_20260920',
];

const makeRow = (keys: readonly string[]): Record<string, unknown> =>
  Object.fromEntries(keys.map(k => [k, 0]));

// 주 그룹 라벨(월 그룹 아래 2단) 추출.
const weekHeaders = (monthGroup: unknown): string[] => {
  const g = monthGroup as { columns?: { header?: string }[] };
  return (g.columns ?? []).map(c => c.header ?? '');
};

describe('buildPivotColumns — 드릴다운 후 주/월 그룹 순서', () => {
  it('Weekly+SUM 에서 W38 을 펼쳐도 W37 이 W38 보다 앞에 온다', () => {
    const keys = SEP_KEYS;
    const drilldown = toggleDrilldown(
      EMPTY_DRILLDOWN,
      'W_20260938',
      keys,
      BUCKET_TYPE.WEEKLY,
      true,
      true
    );
    const cols = buildPivotColumns([makeRow(keys)], BUCKET_TYPE.WEEKLY, true, drilldown);

    expect(cols).toHaveLength(1);
    expect((cols[0] as { header?: string }).header).toBe('2026-09');
    // 월SUM('SUM') 먼저, 그다음 주차 오름차순 — 펼친 W38 이 W37 앞으로 튀면 안 된다.
    expect(weekHeaders(cols[0])).toEqual(['SUM', 'W37', 'W38']);
  });

  it('W1~W9(한자리 주차) 는 일(D_)·주SUM(W_) 라벨이 2자리 W01 로 일치해 쪼개지지 않는다', () => {
    // 2026-01: ISO_WEEK 01=…~01-04(목), 02=01-05(월)~. D_ 는 isoWeek 숫자(1,2)라 종전 'W1'/'W2' 로
    //   W_ 바인딩의 'W01'/'W02' 와 달라 그룹이 쪼개져 주 SUM 이 주차 뒤로 분리됐다 → zero-pad 로 일치.
    const keys = ['M_202601', 'W_20260101', 'W_20260102', 'D_20260101', 'D_20260102', 'D_20260105'];
    const cols = buildPivotColumns([makeRow(keys)], BUCKET_TYPE.DAILY, true, EMPTY_DRILLDOWN);
    expect((cols[0] as { header?: string }).header).toBe('2026-01');
    // 'W1'/'W01' 로 분리되지 않고 2자리 'W01','W02' 로 일치(월SUM 먼저, 각 주 안에서 SUM 이 일자 앞).
    expect(weekHeaders(cols[0])).toEqual(['SUM', 'W01', 'W02']);
  });

  it('늦은 달의 주를 펼쳐도 월 그룹이 연-월 오름차순을 유지한다', () => {
    const keys = [
      'M_202609',
      'W_20260937',
      'W_20260938',
      'M_202610',
      'W_20261041',
      'W_20261042',
      'D_20261012',
      'D_20261013',
      'D_20261014',
      'D_20261015',
      'D_20261016',
      'D_20261017',
      'D_20261018',
    ];
    const drilldown = toggleDrilldown(
      EMPTY_DRILLDOWN,
      'W_20261042',
      keys,
      BUCKET_TYPE.WEEKLY,
      true,
      true
    );
    const cols = buildPivotColumns([makeRow(keys)], BUCKET_TYPE.WEEKLY, true, drilldown);

    expect(cols.map(c => (c as { header?: string }).header)).toEqual(['2026-09', '2026-10']);
  });
});
