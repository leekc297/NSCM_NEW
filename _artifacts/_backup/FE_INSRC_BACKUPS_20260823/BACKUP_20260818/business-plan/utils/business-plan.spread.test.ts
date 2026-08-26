import { describe, expect, it } from 'vitest';

import { applyCellChange } from './business-plan.spread';

// ⭐ DMF0042 배분·롤업 엔진 — AS-IS spdMain_Changed L1800~2723 산식 1:1 값 검증.
//   시나리오 축: BP Monthly 롤업 / Quarterly 균등분할+나머지 끝 / Yearly 실적월 스킵 분모 /
//   LOC copy·상위 Q=반올림 copy·Y=0 / 소수 절삭(MSG00679 계보).
const DYN = [
  'Y_2026',
  'Q_2026_1',
  'Q_2026_2',
  'M_202601',
  'M_202602',
  'M_202603',
  'M_202604',
  'M_202605',
  'M_202606',
] as const;

const THIS_MONTH = '202603'; // 금주 월요일 yyyymm — 202601~02 = 실적(잠금) 구간

describe('applyCellChange — Business_Plan (정수 배분·롤업)', () => {
  it('M_ 입력 = 상향 롤업만 (소속 Q_ = 분기합, Y_ = 연합 — L1862~1918)', () => {
    const { patches, truncated } = applyCellChange({
      rowValues: { M_202601: 10, M_202602: 20, M_202604: 5 },
      binding: 'M_202603',
      value: 30,
      measure: 'Business_Plan',
      dynBindings: DYN,
      thisMonth: THIS_MONTH,
    });
    expect(truncated).toBe(false);
    expect(patches.M_202603).toBe(30);
    expect(patches.Q_2026_1).toBe(10 + 20 + 30); // 분기 내 M_ 합
    expect(patches.Y_2026).toBe(10 + 20 + 30 + 5); // 연 내 M_ 합
  });

  it('Q_ 입력 = 하위 M_ 균등분할 + 나머지 마지막 칸 (L1987~2003)', () => {
    const { patches } = applyCellChange({
      rowValues: {},
      binding: 'Q_2026_1',
      value: 100,
      measure: 'Business_Plan',
      dynBindings: DYN,
      thisMonth: THIS_MONTH,
    });
    // 100 / 3 = 몫 33, 나머지 1 → 마지막 칸(M_202603) 가산
    expect(patches.M_202601).toBe(33);
    expect(patches.M_202602).toBe(33);
    expect(patches.M_202603).toBe(34);
    expect(patches.Y_2026).toBe(100); // 롤업 = 배분 합
  });

  it('Y_ 입력 = 실적구간(금주 월요일 이전 M_) 분모 제외 배분 (L2206/2232 continue)', () => {
    const { patches } = applyCellChange({
      rowValues: { M_202601: 7, M_202602: 8 },
      binding: 'Y_2026',
      value: 100,
      measure: 'Business_Plan',
      dynBindings: DYN,
      thisMonth: THIS_MONTH,
    });
    // 배분 대상 = 202603~202606 4개월 — 실적월(01/02)은 기입 스킵(기존값 보존)
    expect(patches.M_202601).toBeUndefined();
    expect(patches.M_202602).toBeUndefined();
    expect(patches.M_202603).toBe(25);
    expect(patches.M_202606).toBe(25);
    // Q_ 롤업 재계산 — Q1 = 실적 7+8 + 신규 25 / Q2 = 25×3
    expect(patches.Q_2026_1).toBe(7 + 8 + 25);
    expect(patches.Q_2026_2).toBe(75);
  });

  it('소수 입력 = 소수부 절삭 + truncated 플래그 (L1843~1855 → MSG00679)', () => {
    const { patches, truncated } = applyCellChange({
      rowValues: {},
      binding: 'M_202604',
      value: 12.7,
      measure: 'Business_Plan',
      dynBindings: DYN,
      thisMonth: THIS_MONTH,
    });
    expect(truncated).toBe(true);
    expect(patches.M_202604).toBe(12); // Math.trunc — 반올림 아님
  });

  it('콤마 문자열 입력 정규화 ("1,234" → 1234)', () => {
    const { patches } = applyCellChange({
      rowValues: {},
      binding: 'M_202605',
      value: '1,234',
      measure: 'Business_Plan',
      dynBindings: DYN,
      thisMonth: THIS_MONTH,
    });
    expect(patches.M_202605).toBe(1234);
  });
});

describe('applyCellChange — LOC (배분 아닌 copy — L2289~2720)', () => {
  it('Q_ 입력 = 하위 M_ 동일값 copy + Y_ = 0 유지 (L2394~2403 / L2341·2503)', () => {
    const { patches } = applyCellChange({
      rowValues: {},
      binding: 'Q_2026_1',
      value: 3.5,
      measure: 'LOC',
      dynBindings: DYN,
      thisMonth: THIS_MONTH,
    });
    expect(patches.M_202601).toBe(3.5); // 균등분할 아닌 동일값
    expect(patches.M_202602).toBe(3.5);
    expect(patches.M_202603).toBe(3.5);
    expect(patches.Y_2026).toBe(0); // 가격 상위 SUM 무의미 = 0
  });

  it('M_ 입력 = Q_ 는 편집 셀값 반올림 copy(합산 아님 — G4 신정본 L2371~2376), Y_ = 0', () => {
    const { patches, truncated } = applyCellChange({
      rowValues: { M_202601: 5, M_202602: 5 },
      binding: 'M_202603',
      value: 2.6,
      measure: 'LOC',
      dynBindings: DYN,
      thisMonth: THIS_MONTH,
    });
    expect(truncated).toBe(false); // LOC 는 실수 허용 — 절삭 없음
    expect(patches.M_202603).toBe(2.6);
    expect(patches.Q_2026_1).toBe(3); // Math.round(2.6) — 합산(12.6) 아님
    expect(patches.Y_2026).toBe(0);
  });

  it('Y_ 입력 = 실적월 스킵 copy + 전 분기 Q_ = 0', () => {
    const { patches } = applyCellChange({
      rowValues: {},
      binding: 'Y_2026',
      value: 9.9,
      measure: 'LOC',
      dynBindings: DYN,
      thisMonth: THIS_MONTH,
    });
    expect(patches.M_202601).toBeUndefined(); // 실적월 스킵
    expect(patches.M_202603).toBe(9.9);
    expect(patches.Q_2026_1).toBe(0); // LOC Y_ 경로의 Q_ 재계산 = 0
    expect(patches.Q_2026_2).toBe(0);
  });
});

describe('applyCellChange — 경계', () => {
  it('비 동적 binding = 빈 patch', () => {
    const { patches } = applyCellChange({
      rowValues: {},
      binding: 'DEPT_ID',
      value: 5,
      measure: 'Business_Plan',
      dynBindings: DYN,
      thisMonth: THIS_MONTH,
    });
    expect(Object.keys(patches)).toHaveLength(0);
  });

  it('빈 값/문자 입력 = 0 처리', () => {
    const { patches } = applyCellChange({
      rowValues: { M_202601: 10 },
      binding: 'M_202604',
      value: '',
      measure: 'Business_Plan',
      dynBindings: DYN,
      thisMonth: THIS_MONTH,
    });
    expect(patches.M_202604).toBe(0);
    expect(patches.Y_2026).toBe(10); // 기존값 + 0
  });
});
