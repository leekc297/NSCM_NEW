import { describe, expect, it } from 'vitest';

import { isMainCellEditable } from './shipment-plan.editLock';

// 확정구간 편집창 단위검증 (AS-IS 그대로 — 사용자 결정 2026-10-21, 종전 2026-10-12 반전을 되돌림).
//   편집창 = curPlanDate <= 일자 <= CONFIRM_DAY. CONFIRM_DAY 는 서버가 행별로 내려주는 확정구간
//   종료일이고 SCM_MST_SITE.SHIP_FROZEN 이 플랜트별로 달라 행마다 경계가 다르다 — 그 축을 함께 검증한다.
const PLAN_START = '20260901';

const mainRow = (confirmDay: string, extra?: Record<string, unknown>) => ({
  MEASURE: 'SHIP_PLAN_DETAIL',
  TO_SITE: 'S1',
  CONFIRM_DAY: confirmDay,
  ...extra,
});

describe('isMainCellEditable — 확정구간(curPlanDate~CONFIRM_DAY)만 편집 가능', () => {
  // SHIP_FROZEN=14 → CONFIRM_DAY = 20260901 + 14 - 1 = 20260914
  const row14 = mainRow('20260914');

  it('확정구간 종료일은 편집 가능(경계 포함)', () => {
    expect(isMainCellEditable(row14, 'D_20260914', true, PLAN_START)).toBe(true);
  });

  it('확정구간 내부 일자는 편집 가능', () => {
    expect(isMainCellEditable(row14, 'D_20260901', true, PLAN_START)).toBe(true);
    expect(isMainCellEditable(row14, 'D_20260908', true, PLAN_START)).toBe(true);
  });

  it('확정구간을 지난 일자는 편집 불가(조회전용 하늘색)', () => {
    expect(isMainCellEditable(row14, 'D_20260915', true, PLAN_START)).toBe(false);
    expect(isMainCellEditable(row14, 'D_20261001', true, PLAN_START)).toBe(false);
  });

  it('플랜트별 확정구간 차이가 경계를 가른다 — 같은 일자가 행마다 갈린다', () => {
    // SHIP_FROZEN=56 → CONFIRM_DAY=20261026 / =14 → 20260914. 실측값 기반.
    const row56 = mainRow('20261026');
    expect(isMainCellEditable(row14, 'D_20261001', true, PLAN_START)).toBe(false);
    expect(isMainCellEditable(row56, 'D_20261001', true, PLAN_START)).toBe(true);
  });

  it('CONFIRM_DAY 공백·null 이면 창이 성립 못 해 편집 불가', () => {
    expect(isMainCellEditable(mainRow(''), 'D_20260901', true, PLAN_START)).toBe(false);
    expect(
      isMainCellEditable({ ...mainRow(''), CONFIRM_DAY: null }, 'D_20260901', true, PLAN_START)
    ).toBe(false);
  });

  it('curPlanDate 이전 과거 일자는 확정구간 내여도 편집 불가', () => {
    expect(isMainCellEditable(row14, 'D_20260831', true, PLAN_START)).toBe(false);
  });
});

describe('isMainCellEditable — 편집창 외 기존 가드는 유지', () => {
  const row = mainRow('20260914');
  const inWindow = 'D_20260910'; // 확정구간 안 — 아래 각 가드가 유일한 차단 사유가 되도록

  it('권한(canEdit) 없으면 편집 불가', () => {
    expect(isMainCellEditable(row, inWindow, false, PLAN_START)).toBe(false);
  });

  it('D_ 가 아닌 컬럼(SUM W_/M_·base)은 편집 불가', () => {
    expect(isMainCellEditable(row, 'W_202609W3', true, PLAN_START)).toBe(false);
    expect(isMainCellEditable(row, 'M_202610', true, PLAN_START)).toBe(false);
    expect(isMainCellEditable(row, 'TO_SITE', true, PLAN_START)).toBe(false);
  });

  it('MEASURE 가 SHIP_PLAN_DETAIL 이 아니면 편집 불가', () => {
    expect(
      isMainCellEditable({ ...row, MEASURE: 'SHIP_PLAN' }, inWindow, true, PLAN_START)
    ).toBe(false);
  });

  it('TO_SITE 공백 행은 편집 불가', () => {
    expect(isMainCellEditable({ ...row, TO_SITE: '  ' }, inWindow, true, PLAN_START)).toBe(false);
  });

  it('행이 없으면 편집 불가', () => {
    expect(isMainCellEditable(undefined, inWindow, true, PLAN_START)).toBe(false);
  });
});
