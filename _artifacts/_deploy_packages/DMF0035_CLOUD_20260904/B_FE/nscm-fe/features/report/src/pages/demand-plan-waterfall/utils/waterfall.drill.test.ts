import { describe, expect, it } from 'vitest';

import { BUCKET_TYPE, BUCKET2_TYPE, GUBUN } from '../demand-plan-waterfall.constants';

import { walkHeaderDrill } from './waterfall.drill';

/** AS-IS 스프레드 컬럼 순서 (M → W → D interleave) — 2개월 구간 */
const MKT_BINDINGS = [
  'M_202609',
  'W_20260936',
  'D_20260901',
  'D_20260902',
  'W_20260937',
  'D_20260908',
  'M_202610',
  'W_20261040',
  'D_20261001',
];

const visibility = (init: Record<string, boolean>) => (b: string) => init[b] ?? false;

describe('walkHeaderDrill — MKT/SALES (AS-IS 0035 .cs:1632-1680)', () => {
  it('M_ 더블클릭: 그 달의 W_ 만 토글하고 다음 M_ 에서 멈춘다 (MONTHLY)', () => {
    const patch = walkHeaderDrill({
      gubun: GUBUN.MKT_FCST,
      bucket: BUCKET_TYPE.MONTHLY,
      dynBindings: MKT_BINDINGS,
      isVisible: visibility({ M_202609: true, M_202610: true }),
      clicked: 'M_202609',
    });
    expect(patch.get('W_20260936')).toBe(true);
    expect(patch.get('W_20260937')).toBe(true);
    // 다음 달 컬럼은 건드리지 않는다
    expect(patch.has('W_20261040')).toBe(false);
    expect(patch.has('D_20261001')).toBe(false);
  });

  it('DAILY 에서 M_ 더블클릭: W_ 토글 + 보이는 D_ 는 접기만 한다', () => {
    const patch = walkHeaderDrill({
      gubun: GUBUN.MKT_FCST,
      bucket: BUCKET_TYPE.DAILY,
      dynBindings: MKT_BINDINGS,
      isVisible: visibility({ D_20260901: true, D_20260902: true, D_20260908: true }),
      clicked: 'M_202609',
    });
    expect(patch.get('W_20260936')).toBe(true);
    expect(patch.get('D_20260901')).toBe(false);
    expect(patch.get('D_20260902')).toBe(false);
    expect(patch.get('D_20260908')).toBe(false);
  });

  it('DAILY 에서 W_ 더블클릭: 그 주의 D_ 만 토글하고 다음 W_ 에서 멈춘다', () => {
    const patch = walkHeaderDrill({
      gubun: GUBUN.MKT_FCST,
      bucket: BUCKET_TYPE.DAILY,
      dynBindings: MKT_BINDINGS,
      isVisible: visibility({}),
      clicked: 'W_20260936',
    });
    expect(patch.get('D_20260901')).toBe(true);
    expect(patch.get('D_20260902')).toBe(true);
    expect(patch.has('D_20260908')).toBe(false);
  });

  it('DAILY 가 아니면 W_ 더블클릭은 아무것도 바꾸지 않는다', () => {
    const patch = walkHeaderDrill({
      gubun: GUBUN.SALES_PLAN,
      bucket: BUCKET_TYPE.WEEKLY,
      dynBindings: MKT_BINDINGS,
      isVisible: visibility({}),
      clicked: 'W_20260936',
    });
    expect(patch.size).toBe(0);
  });
});

/** BIZ 는 계층 배열이 반대(월 … 분기 … 연)라 walk 도 위로 올라간다 (0051 .cs:1019-1060) */
const BIZ_BINDINGS = ['M_202601', 'M_202602', 'M_202603', 'Q_2026_1', 'M_202604', 'Q_2026_2', 'Y_2026'];

describe('walkHeaderDrill — BIZ (AS-IS 0051 .cs:1019-1060)', () => {
  it('MONTHLY 에서 M_ 더블클릭: Q_ 토글 + 보이는 M_ 접기, 다음이 Y_ 면 중단', () => {
    const patch = walkHeaderDrill({
      gubun: GUBUN.BIZ_PLAN,
      bucket: BUCKET2_TYPE.MONTHLY,
      dynBindings: BIZ_BINDINGS,
      isVisible: visibility({
        M_202601: true,
        M_202602: true,
        M_202603: true,
        M_202604: true,
      }),
      clicked: 'M_202601',
    });
    expect(patch.get('M_202601')).toBe(false);
    expect(patch.get('Q_2026_1')).toBe(true);
    expect(patch.get('Q_2026_2')).toBe(true);
    expect(patch.has('Y_2026')).toBe(false);
  });

  it('MONTHLY 에서 Q_ 더블클릭: M_ 토글하고 다음 Q_ 에서 멈춘다', () => {
    const patch = walkHeaderDrill({
      gubun: GUBUN.BIZ_PLAN,
      bucket: BUCKET2_TYPE.MONTHLY,
      dynBindings: BIZ_BINDINGS,
      isVisible: visibility({ M_202604: false }),
      clicked: 'Q_2026_1',
    });
    expect(patch.get('M_202604')).toBe(true);
    expect(patch.has('M_202601')).toBe(false);
  });

  it('QUARTERLY 에서 M_ 더블클릭: Q_ 토글 + 숨은 Y_ 펼침', () => {
    const patch = walkHeaderDrill({
      gubun: GUBUN.BIZ_PLAN,
      bucket: BUCKET2_TYPE.QUARTERLY,
      dynBindings: BIZ_BINDINGS,
      isVisible: visibility({ Q_2026_1: true, Q_2026_2: true }),
      clicked: 'M_202601',
    });
    expect(patch.get('Q_2026_1')).toBe(false);
    expect(patch.get('Q_2026_2')).toBe(false);
    expect(patch.has('Y_2026')).toBe(false);
  });
});
