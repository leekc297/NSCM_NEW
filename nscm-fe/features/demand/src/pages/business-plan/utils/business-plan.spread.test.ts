import { describe, expect, it } from 'vitest';

import { applyCellChange } from './business-plan.spread';

// 조회기간 2026.12 ~ 2027.02 의 실제 컬럼 구성 (2027 Q1 = 01·02 — 03 은 기간 밖이라 컬럼 없음).
const DYN = ['Y_2026', 'Q_2026_4', 'M_202612', 'Y_2027', 'Q_2027_1', 'M_202701', 'M_202702'];
const THIS_MONTH = '202612';

const run = (params: {
  row: Record<string, unknown>;
  binding: string;
  value: unknown;
  measure: string;
}) =>
  applyCellChange({
    rowValues: params.row,
    binding: params.binding,
    value: params.value,
    measure: params.measure,
    dynBindings: DYN,
    thisMonth: THIS_MONTH,
  });

describe('applyCellChange — Business_Plan (합산 measure)', () => {
  it('월 입력 → 소속 Q_·Y_ 가 월 합으로 롤업된다', () => {
    const row = { Y_2027: 300, Q_2027_1: 300, M_202701: 100, M_202702: 200 };
    const { patches } = run({ row, binding: 'M_202701', value: 150, measure: 'Business_Plan' });

    expect(patches.M_202701).toBe(150);
    expect(patches.Q_2027_1).toBe(350);
    expect(patches.Y_2027).toBe(350);
  });

  it('연 입력 → 하위 월 배분 후 Q_ 재계산', () => {
    const row = { Y_2027: 300, Q_2027_1: 300, M_202701: 100, M_202702: 200 };
    const { patches } = run({ row, binding: 'Y_2027', value: 500, measure: 'Business_Plan' });

    expect(patches.M_202701).toBe(250);
    expect(patches.M_202702).toBe(250);
    expect(patches.Q_2027_1).toBe(500);
  });
});

// 가격류(LOC 등) 는 합산이 무의미해 상위 SUM 을 편집값 그대로 copy 한다.
//   금지 2종 (둘 다 2026-08-25 실측 사고) —
//     · 0 기입  : 편집 즉시 연 SUM 이 0.000 으로 깨지고, 되돌려도 0 이 다시 쓰여 수정(M) 이 안 풀림.
//     · 반올림  : 1.27 단가가 1 로 깨짐 — 값을 바꾸지 않고 편집만 해도 발생.
describe('applyCellChange — LOC (가격 measure)', () => {
  it('월 입력 → Q_·Y_ 가 편집값 그대로 따라온다 (합산 아님)', () => {
    const row = { Y_2027: 1270, Q_2027_1: 1270, M_202701: 1270, M_202702: 1270 };
    const { patches } = run({ row, binding: 'M_202701', value: 999, measure: 'LOC' });

    expect(patches.M_202701).toBe(999);
    expect(patches.Q_2027_1).toBe(999);
    expect(patches.Y_2027).toBe(999);
  });

  it('소수 단가 — 반올림하지 않는다 (1.27 이 1 이 되면 안 된다)', () => {
    const row = { Y_2027: 1.27, Q_2027_1: 1.27, M_202701: 1.27, M_202702: 1.27 };
    const { patches } = run({ row, binding: 'M_202701', value: 1.27, measure: 'LOC' });

    // 값을 바꾸지 않고 편집만 하고 나온 경우 — 조회값과 같아야 한다 (2026-08-25 리포트)
    expect(patches.M_202701).toBe(1.27);
    expect(patches.Q_2027_1).toBe(1.27);
    expect(patches.Y_2027).toBe(1.27);
  });

  it('0 입력 → 상위 SUM 도 0 을 따라간다 (편집값 copy)', () => {
    const row = { Y_2027: 1.27, Q_2027_1: 1.27, M_202701: 1.27, M_202702: 1.27 };
    const { patches } = run({ row, binding: 'M_202701', value: 0, measure: 'LOC' });

    expect(patches.Q_2027_1).toBe(0);
    expect(patches.Y_2027).toBe(0);
  });

  it('연 입력 → 하위 월·분기 모두 동일값 copy', () => {
    const row = { Y_2027: 1.27, Q_2027_1: 1.27, M_202701: 1.27, M_202702: 1.27 };
    const { patches } = run({ row, binding: 'Y_2027', value: 5.5, measure: 'LOC' });

    expect(patches.M_202701).toBe(5.5);
    expect(patches.M_202702).toBe(5.5);
    expect(patches.Q_2027_1).toBe(5.5);
  });

  it('되돌림 — 같은 값을 다시 넣으면 행이 조회 시점과 같아진다', () => {
    const original = { Y_2027: 1.27, Q_2027_1: 1.27, M_202701: 1.27, M_202702: 1.27 };

    // 변경
    const changed = { ...original };
    const first = run({ row: changed, binding: 'M_202701', value: 0, measure: 'LOC' });
    Object.assign(changed, first.patches);
    expect(changed.Q_2027_1).toBe(0); // 바꾸면 SUM 도 따라간다

    // 원복
    const second = run({ row: changed, binding: 'M_202701', value: 1.27, measure: 'LOC' });
    Object.assign(changed, second.patches);

    expect(changed).toEqual(original); // EditTracker 가 수정(M) 을 풀 수 있는 조건
  });
});
