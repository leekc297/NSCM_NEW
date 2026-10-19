import { describe, expect, it } from 'vitest';

import { isMainCellEditable } from './shipment-plan-auto-ess.editLock';

// SSP0021 Main(PSI) 셀 편집 판정 — **확정구간 조회전용** 규칙을 못 박는다.
//
// 이 판정은 AS-IS·design 과 **의도적으로 반대**다. AS-IS EditButton 과 design 03 §1.2/§2.3 은
//   `curPlanDate <= 일자 <= CONFIRM_DAY` 창을 **편집창**으로 적었지만, 확정(frozen)된 구간을 편집
//   표면으로 두는 셈이라 사용자가 반대로 확정했다(자매 SSP0060 과 통일).
//   확정구간은 잠그고, 편집은 그 구간을 지난 일자에서만 허용한다.
//
// 방향이 다시 뒤집히면 ERP 로 나가는 확정 수량이 편집 가능해지므로 테스트로 고정한다.

const CUR = '20260701';

const row = (over: Record<string, unknown> = {}): Record<string, unknown> => ({
  MEASURE: 'SHIP_PLAN', // SSP0021 의 편집 대상 measure (SSP0060 은 SHIP_PLAN_DETAIL — 화면별로 다르다)
  CONFIRM_DAY: '20260715',
  ...over,
});

describe('isMainCellEditable — 확정구간(CONFIRM_DAY) 조회전용', () => {
  it('확정구간 안(일자 < CONFIRM_DAY)은 편집 불가다', () => {
    expect(isMainCellEditable(row(), 'D_20260710', true, CUR)).toBe(false);
  });

  it('CONFIRM_DAY 당일(경계)도 편집 불가다 — 확정구간에 포함된다', () => {
    expect(isMainCellEditable(row(), 'D_20260715', true, CUR)).toBe(false);
  });

  it('확정구간을 지난 일자(> CONFIRM_DAY)는 편집 가능하다', () => {
    expect(isMainCellEditable(row(), 'D_20260716', true, CUR)).toBe(true);
  });

  it('AS-IS/design 방향(확정구간이 편집창)으로 되돌아가지 않았다', () => {
    // 종전 구현은 이 둘이 정반대였다 — 뒤집히면 여기서 깨진다.
    expect(isMainCellEditable(row(), 'D_20260710', true, CUR)).toBe(false);
    expect(isMainCellEditable(row(), 'D_20260801', true, CUR)).toBe(true);
  });

  it('CONFIRM_DAY 가 공백·null 이면 확정구간이 없다 — curPlanDate 이후 전 일자 편집 허용', () => {
    for (const confirmDay of ['', '   ', null, undefined]) {
      expect(isMainCellEditable(row({ CONFIRM_DAY: confirmDay }), 'D_20260710', true, CUR), String(confirmDay)).toBe(true);
    }
  });

  it('curPlanDate 이전 일자는 여전히 편집 불가다(하한은 그대로)', () => {
    expect(isMainCellEditable(row(), 'D_20260630', true, CUR)).toBe(false);
  });
});

describe('isMainCellEditable — 기존 축은 그대로', () => {
  it('canEdit=false 면 전면 잠금이다(R7a 비SSP 사용자 포함)', () => {
    expect(isMainCellEditable(row(), 'D_20260801', false, CUR)).toBe(false);
  });

  it('행이 없으면 잠금이다', () => {
    expect(isMainCellEditable(undefined, 'D_20260801', true, CUR)).toBe(false);
  });

  it('D_ 가 아닌 컬럼은 잠금이다 — W_/M_(Sum) 은 항상 읽기전용', () => {
    expect(isMainCellEditable(row(), 'W_20260801', true, CUR)).toBe(false);
    expect(isMainCellEditable(row(), 'M_202608', true, CUR)).toBe(false);
    expect(isMainCellEditable(row(), 'BOH_QTY', true, CUR)).toBe(false);
  });

  it('MEASURE 가 SHIP_PLAN 이 아니면 잠금이다', () => {
    expect(isMainCellEditable(row({ MEASURE: 'SHIP_RESULT' }), 'D_20260801', true, CUR)).toBe(false);
  });
});
