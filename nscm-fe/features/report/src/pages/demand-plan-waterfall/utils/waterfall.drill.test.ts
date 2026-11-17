import { describe, expect, it } from 'vitest';

import { BUCKET_TYPE, BUCKET2_TYPE, GUBUN } from '../demand-plan-waterfall.constants';

import { resolveBizHeaderBinding, walkHeaderDrill } from './waterfall.drill';

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

  it('DAILY + Sum OFF: 더 펼 단계가 없어 W_ 더블클릭해도 아무것도 바꾸지 않는다', () => {
    const patch = walkHeaderDrill({
      gubun: GUBUN.MKT_FCST,
      bucket: BUCKET_TYPE.DAILY,
      dynBindings: MKT_BINDINGS,
      isVisible: visibility(Object.fromEntries(MKT_BINDINGS.map(b => [b, true]))),
      clicked: 'W_20260936',
      isSumChecked: false,
    });
    expect(patch.size).toBe(0);
  });

  it('DAILY + Sum ON: M_ 더블클릭 → W_·D_ 접혀 M_ 합계만, W_ 더블클릭 → 그 주 D_ 접기/펼치기', () => {
    const allOn = visibility(Object.fromEntries(MKT_BINDINGS.map(b => [b, true])));
    const byMonth = walkHeaderDrill({
      gubun: GUBUN.MKT_FCST,
      bucket: BUCKET_TYPE.DAILY,
      dynBindings: MKT_BINDINGS,
      isVisible: allOn,
      clicked: 'M_202609',
      isSumChecked: true,
    });
    expect(byMonth.get('W_20260936')).toBe(false);
    expect(byMonth.get('D_20260901')).toBe(false);
    expect(byMonth.has('M_202609')).toBe(false);
    const byWeek = walkHeaderDrill({
      gubun: GUBUN.MKT_FCST,
      bucket: BUCKET_TYPE.DAILY,
      dynBindings: MKT_BINDINGS,
      isVisible: allOn,
      clicked: 'W_20260936',
      isSumChecked: true,
    });
    expect(byWeek.get('D_20260901')).toBe(false);
    expect(byWeek.get('D_20260902')).toBe(false);
    expect(byWeek.has('D_20260908')).toBe(false);
  });

  it('WEEKLY 에서 M_ 더블클릭: W_ 는 그대로, 펼쳐 둔 D_ 만 접는다', () => {
    const patch = walkHeaderDrill({
      gubun: GUBUN.SALES_PLAN,
      bucket: BUCKET_TYPE.WEEKLY,
      dynBindings: MKT_BINDINGS,
      isVisible: visibility({ M_202609: true, W_20260936: true, W_20260937: true, D_20260901: true }),
      clicked: 'M_202609',
    });
    expect(patch.has('W_20260936')).toBe(false);
    expect(patch.has('M_202609')).toBe(false);
    expect(patch.get('D_20260901')).toBe(false);
  });

  it('[ALLBUCKET] MONTHLY 에서도 D_ 가 있으면 W_ 더블클릭으로 그 주의 D_ 를 펼친다', () => {
    const patch = walkHeaderDrill({
      gubun: GUBUN.SALES_PLAN,
      bucket: BUCKET_TYPE.MONTHLY,
      dynBindings: MKT_BINDINGS,
      isVisible: visibility({ M_202609: true, W_20260936: true, W_20260937: true }),
      clicked: 'W_20260936',
    });
    expect(patch.get('D_20260901')).toBe(true);
    expect(patch.get('D_20260902')).toBe(true);
    expect(patch.has('D_20260908')).toBe(false);
  });

  it('[ALLBUCKET] MONTHLY 에서 M_ 다시 더블클릭: W_ 접기 + 펼쳐 둔 D_ 도 접는다', () => {
    const patch = walkHeaderDrill({
      gubun: GUBUN.SALES_PLAN,
      bucket: BUCKET_TYPE.MONTHLY,
      dynBindings: MKT_BINDINGS,
      isVisible: visibility({
        M_202609: true,
        W_20260936: true,
        W_20260937: true,
        D_20260901: true,
        D_20260902: true,
      }),
      clicked: 'M_202609',
    });
    expect(patch.get('W_20260936')).toBe(false);
    expect(patch.get('W_20260937')).toBe(false);
    expect(patch.get('D_20260901')).toBe(false);
    expect(patch.get('D_20260902')).toBe(false);
    expect(patch.has('M_202609')).toBe(false);
  });

  it('D_ 컬럼이 없으면(기간 초과·MKT) W_ 더블클릭은 아무것도 바꾸지 않는다', () => {
    const patch = walkHeaderDrill({
      gubun: GUBUN.SALES_PLAN,
      bucket: BUCKET_TYPE.WEEKLY,
      dynBindings: MKT_BINDINGS.filter(b => !b.startsWith('D_')),
      isVisible: visibility({}),
      clicked: 'W_20260936',
    });
    expect(patch.size).toBe(0);
  });
});

/** BIZ 실제 TITLE SP 순서 (PKG_DMF0051 2026-11-10 실측, 2026.11~2027.04 Monthly) — 합계가 자기 묶음 앞 */
const BIZ_BINDINGS = [
  'Y_2026',
  'Q_2026_4',
  'M_202611',
  'M_202612',
  'Y_2027',
  'Q_2027_1',
  'M_202701',
  'M_202702',
  'M_202703',
  'Q_2027_2',
  'M_202704',
];

/** 클릭을 연속 적용하는 시뮬레이터 (그리드 drillVisRef 누적과 동일) */
const runClicks = (
  bucket: string,
  init: Record<string, boolean>,
  clicks: string[],
  isSumChecked = false
) => {
  const state = new Map(Object.entries(init));
  clicks.forEach(clicked => {
    walkHeaderDrill({
      gubun: GUBUN.BIZ_PLAN,
      bucket,
      dynBindings: BIZ_BINDINGS,
      isVisible: b => state.get(b) ?? false,
      clicked,
      isSumChecked,
    }).forEach((v, b) => state.set(b, v));
  });
  return (b: string) => state.get(b) ?? false;
};
const onlyKinds = (...prefixes: string[]) =>
  Object.fromEntries(BIZ_BINDINGS.filter(b => prefixes.some(p => b.startsWith(p))).map(b => [b, true]));

describe('walkHeaderDrill — BIZ (Business Plan 동작 + 조회 bucket 보다 세부 단계만)', () => {
  it('MONTHLY + Sum OFF: 더 펼 단계가 없어 Y_/Q_ 더블클릭해도 아무것도 바뀌지 않는다', () => {
    const init = onlyKinds('M_');
    const vis = runClicks(BUCKET2_TYPE.MONTHLY, init, ['Y_2026', 'Q_2027_1', 'Y_2027']);
    expect(BIZ_BINDINGS.filter(b => b.startsWith('M_')).every(vis)).toBe(true);
  });

  it('MONTHLY + Sum ON: Y_ 접기 → Y_ 합계만, 다시 → Q_, Q_ → 월까지 복구 (Business Plan 동작)', () => {
    const init = onlyKinds('Y_', 'Q_', 'M_');
    let vis = runClicks(BUCKET2_TYPE.MONTHLY, init, ['Y_2026'], true);
    expect(vis('Q_2026_4') || vis('M_202611') || vis('M_202612')).toBe(false);
    expect(vis('Y_2026') && vis('M_202701')).toBe(true);
    vis = runClicks(BUCKET2_TYPE.MONTHLY, init, ['Y_2026', 'Y_2026', 'Q_2026_4'], true);
    expect(vis('Q_2026_4') && vis('M_202611') && vis('M_202612')).toBe(true);
  });

  it('YEARLY: Y_ → Q_ 펼침, Q_ → M_ 펼침, Y_ 다시 → Q_·M_ 접힘, Y_ 는 남는다', () => {
    const init = onlyKinds('Y_');
    let vis = runClicks(BUCKET2_TYPE.YEARLY, init, ['Y_2027']);
    expect(vis('Q_2027_1') && vis('Q_2027_2')).toBe(true);
    expect(vis('Q_2026_4')).toBe(false);
    vis = runClicks(BUCKET2_TYPE.YEARLY, init, ['Y_2027', 'Q_2027_1']);
    expect(['M_202701', 'M_202702', 'M_202703'].every(vis)).toBe(true);
    expect(vis('M_202704')).toBe(false);
    vis = runClicks(BUCKET2_TYPE.YEARLY, init, ['Y_2027', 'Q_2027_1', 'Y_2027']);
    expect(['Q_2027_1', 'Q_2027_2', 'M_202701', 'M_202702', 'M_202703'].some(vis)).toBe(false);
    expect(vis('Y_2027')).toBe(true);
  });

  it('QUARTERLY: Q_ → M_ 펼침, Y_ 더블클릭은 Q_ 는 그대로 두고 펼친 M_ 만 접는다', () => {
    const init = onlyKinds('Y_', 'Q_'); // Sum ON
    let vis = runClicks(BUCKET2_TYPE.QUARTERLY, init, ['Q_2027_1']);
    expect(['M_202701', 'M_202702', 'M_202703'].every(vis)).toBe(true);
    vis = runClicks(BUCKET2_TYPE.QUARTERLY, init, ['Q_2027_1', 'Y_2027']);
    expect(['M_202701', 'M_202702', 'M_202703'].some(vis)).toBe(false);
    expect(vis('Q_2027_1') && vis('Q_2027_2') && vis('Y_2027')).toBe(true);
  });

  it('M_ 더블클릭은 아무것도 바꾸지 않는다', () => {
    const patch = walkHeaderDrill({
      gubun: GUBUN.BIZ_PLAN,
      bucket: BUCKET2_TYPE.YEARLY,
      dynBindings: BIZ_BINDINGS,
      isVisible: visibility(onlyKinds('Y_', 'Q_', 'M_')),
      clicked: 'M_202611',
    });
    expect(patch.size).toBe(0);
  });
});

describe('resolveBizHeaderBinding — 묶음 헤더 클릭 복원', () => {
  it('1단은 연도 Y_, 2단은 소속 분기 Q_, leaf 는 물리 컬럼', () => {
    expect(resolveBizHeaderBinding('M_202702', 0, 2, BIZ_BINDINGS)).toBe('Y_2027');
    expect(resolveBizHeaderBinding('M_202702', 1, 2, BIZ_BINDINGS)).toBe('Q_2027_1');
    expect(resolveBizHeaderBinding('M_202704', 1, 2, BIZ_BINDINGS)).toBe('Q_2027_2');
    expect(resolveBizHeaderBinding('Y_2026', 1, 2, BIZ_BINDINGS)).toBe('Y_2026');
    expect(resolveBizHeaderBinding('M_202702', 2, 2, BIZ_BINDINGS)).toBe('M_202702');
  });
});
