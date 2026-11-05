import { describe, expect, it } from 'vitest';

import type { DynColMeta } from './waterfall.columns';
import { buildPeriodMembership, derivePeriodSums } from './waterfall.derive';
import type { DynKind } from './waterfall.periods';

// design 03 §3 R6~R8 / §2.2 파생 합산을 검증 축으로 삼는다.
//   R6 월합(M_)=ΣD_ / R7 주합(W_)=ΣD_ / R8 BALANCE 예외 = 해당 기간 마지막(최신) D_ 값(합 아님).
//   AS-IS Set_SumValues(cs:938) 소속 규칙 = 한 달 안에서 M_ → W_ → D_ 인터리브(헤더가 하위 일자 앞).

// 한 달(202601) + 2주 + 4일의 정렬 순서 메타(SORT_ORDER_NO 순). 파생은 binding/kind 만 소비.
const meta = (binding: string, kind: DynKind): DynColMeta => ({
  binding,
  kind,
  large: '',
  small: '',
  leaf: '',
  dayCode: '',
  sort: 0,
  seq: 0,
});

const METAS: DynColMeta[] = [
  meta('M_202601', 'M'),
  meta('W_20260101', 'W'), // week A
  meta('D_20260101', 'D'),
  meta('D_20260102', 'D'),
  meta('W_20260105', 'W'), // week B
  meta('D_20260105', 'D'),
  meta('D_20260106', 'D'),
];

describe('buildPeriodMembership — 컬럼 인접 순서로 D_ 를 직전 W_/M_ 에 귀속', () => {
  it('각 주는 자기 D_ 만, 월은 전체 D_ 를 소속으로 가진다', () => {
    const { weekOf, monthOf } = buildPeriodMembership(METAS);
    expect(weekOf.get('W_20260101')).toEqual(['D_20260101', 'D_20260102']);
    expect(weekOf.get('W_20260105')).toEqual(['D_20260105', 'D_20260106']);
    expect(monthOf.get('M_202601')).toEqual([
      'D_20260101',
      'D_20260102',
      'D_20260105',
      'D_20260106',
    ]);
  });
});

describe('derivePeriodSums — W_/M_ FE 재합산 (R6/R7)', () => {
  it('measure != BALANCE 는 소속 D_ 의 합으로 W_/M_ 를 채운다', () => {
    const [row] = derivePeriodSums(
      [
        {
          MEASURE: 'SHIP_PLAN',
          D_20260101: 10,
          D_20260102: 20,
          D_20260105: 5,
          D_20260106: 7,
        },
      ],
      METAS
    );
    expect(row.W_20260101).toBe(30);
    expect(row.W_20260105).toBe(12);
    expect(row.M_202601).toBe(42);
  });

  it('서버가 채운 잘못된 W_/M_ 값을 FE 재합산으로 덮어쓴다(design 03 §2.2)', () => {
    const [row] = derivePeriodSums(
      [{ MEASURE: 'SHIP_PLAN', D_20260101: 10, D_20260102: 20, W_20260101: 999, M_202601: 999 }],
      METAS
    );
    expect(row.W_20260101).toBe(30);
    expect(row.M_202601).toBe(30);
  });
});

describe('derivePeriodSums — BALANCE 예외 (R8)', () => {
  it('BALANCE 는 합이 아니라 해당 기간 마지막(최신) D_ 값을 쓴다', () => {
    const [row] = derivePeriodSums(
      [
        {
          MEASURE: 'BALANCE',
          D_20260101: 100,
          D_20260102: 110,
          D_20260105: 120,
          D_20260106: 130,
        },
      ],
      METAS
    );
    expect(row.W_20260101).toBe(110); // week A 마지막 = D_20260102
    expect(row.W_20260105).toBe(130); // week B 마지막 = D_20260106
    expect(row.M_202601).toBe(130); // 월 마지막 = D_20260106 (합 42 아님)
  });
});

describe('derivePeriodSums — 소속 D_ 가 없으면 서버값 유지(ISO 주 등)', () => {
  it('D_ 없는 W_ 는 재합산하지 않고 서버 반환값을 그대로 둔다', () => {
    const isoMetas: DynColMeta[] = [meta('W_202601W01_ISO', 'W')];
    const [row] = derivePeriodSums([{ MEASURE: 'SHIP_PLAN', W_202601W01_ISO: 55 }], isoMetas);
    expect(row.W_202601W01_ISO).toBe(55);
  });
});
