import { describe, expect, it } from 'vitest';

import { BUCKET_TYPE } from '../shipment-plan-semi.constants';

import { computePlanEditable, isMainCellEditable, type MainEditContext } from './shipment-plan-semi.editLock';

const rc2 = (planType: string, seq: string, extra: Record<string, unknown> = {}) => ({
  IS_EDITABLE: 'Y',
  PLAN_START_YYYYMMDD: '20261116',
  PLAN_TYPE: planType,
  PLAN_SEQ: seq,
  PLAN_STATUS: '1',
  CONFIRM_YN: 'N',
  PLAN_TYPE_SEQ: { PR: '0', MA: '1', SE: '2', FN: '3' }[planType] ?? '',
  ...extra,
});

describe('computePlanEditable (AS-IS GetIsEditable)', () => {
  it('o_rc2 가 비면 잠금', () => {
    expect(computePlanEditable([], '20261116', 'PR', '1')).toBe(false);
  });
  it('IS_EDITABLE=N(과거주) 이면 잠금', () => {
    expect(computePlanEditable([rc2('PR', '1', { IS_EDITABLE: 'N' })], '20261116', 'PR', '1')).toBe(false);
  });
  it('FN/TE 는 잠금', () => {
    expect(computePlanEditable([rc2('FN', '1')], '20261116', 'FN', '1')).toBe(false);
    expect(computePlanEditable([rc2('PR', '1')], '20261116', 'TE', '1')).toBe(false);
  });
  it('PR: MA 없으면 편집, 있으면 PLAN_STATUS 무관 잠금', () => {
    expect(computePlanEditable([rc2('PR', '1')], '20261116', 'PR', '1')).toBe(true);
    expect(computePlanEditable([rc2('PR', '1'), rc2('MA', '1')], '20261116', 'PR', '1')).toBe(false);
    expect(
      computePlanEditable([rc2('PR', '1'), rc2('MA', '1', { PLAN_STATUS: '-1' })], '20261116', 'PR', '1')
    ).toBe(false);
  });
  it('MA: SE 없고 자기 플랜 CONFIRM_YN=Y 일 때만 편집', () => {
    expect(computePlanEditable([rc2('MA', '2', { CONFIRM_YN: 'Y' })], '20261116', 'MA', '2')).toBe(true);
    expect(computePlanEditable([rc2('MA', '2')], '20261116', 'MA', '2')).toBe(false);
    expect(computePlanEditable([rc2('MA', '1', { CONFIRM_YN: 'Y' }), rc2('MA', '2')], '20261116', 'MA', '2')).toBe(
      false
    );
    expect(
      computePlanEditable([rc2('MA', '2', { CONFIRM_YN: 'Y' }), rc2('SE', '1')], '20261116', 'MA', '2')
    ).toBe(false);
  });
  it('SE: FN 없으면 편집, 있으면 잠금', () => {
    expect(computePlanEditable([rc2('SE', '1')], '20261116', 'SE', '1')).toBe(true);
    expect(computePlanEditable([rc2('SE', '1'), rc2('FN', '1')], '20261116', 'SE', '1')).toBe(false);
  });
  it('소문자 키도 읽는다', () => {
    expect(computePlanEditable([{ is_editable: 'Y', plan_type_seq: '1' }], '20261116', 'PR', '1')).toBe(false);
  });
});

describe('isMainCellEditable TO_SITE 게이트', () => {
  const ctx: MainEditContext = {
    bucketType: BUCKET_TYPE.DAILY,
    division: '40',
    planStartYyyymmdd: '20261116',
    queryToYyyymmdd: '20261231',
    planEditable: true,
    weekOrMonthStart: new Map(),
  };
  const row = (toSite: unknown) => ({ MEASURE: 'SHIP_PLAN_AMEND', TO_SITE: toSite, SHIP_FROZEN: '2026-11-20' });

  it('To Site 가 있으면 편집 가능', () => {
    expect(isMainCellEditable('D_20261120', row('S1'), ctx)).toBe(true);
  });
  it('To Site 가 NULL 이거나 \'-\' 면 잠금', () => {
    expect(isMainCellEditable('D_20261120', row(null), ctx)).toBe(false);
    expect(isMainCellEditable('D_20261120', row('-'), ctx)).toBe(false);
  });
  it('planEditable=false 면 잠금', () => {
    expect(isMainCellEditable('D_20261120', row('S1'), { ...ctx, planEditable: false })).toBe(false);
  });
});
