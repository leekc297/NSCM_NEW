import { describe, expect, it } from 'vitest';

import type { PlanStatusRow } from '../shipment-plan-fg.types';

import {
  computeEditableRange,
  computeIsEditable,
  isMainCellEditable,
  type MainEditContext,
  toYyyymmdd,
} from './shipment-plan-fg.editLock';

const base = {
  division: 'EE1',
  shipFrozen: '20261010',
  bodFromYyyymmdd: '',
  bodToYyyymmdd: '',
  planStartYyyymmdd: '20261005',
  queryFromYyyymmdd: '20261005',
  queryToYyyymmdd: '20261231',
};

describe('toYyyymmdd', () => {
  it('하이픈 날짜와 8자리 날짜를 YYYYMMDD 로 통일하고 그 외는 빈 값으로 만든다', () => {
    expect(toYyyymmdd('2026-10-10')).toBe('20261010');
    expect(toYyyymmdd('20261010')).toBe('20261010');
    expect(toYyyymmdd('-')).toBe('');
    expect(toYyyymmdd('')).toBe('');
    expect(toYyyymmdd(undefined)).toBe('');
  });
});

describe('computeEditableRange', () => {
  it('SHIP_FROZEN 이 없으면 전체 잠금이다', () => {
    expect(computeEditableRange({ ...base, shipFrozen: '' })).toBeNull();
  });

  it('81 계열은 BOD 와 무관하게 플랜 시작일 ~ 조회 종료일이다', () => {
    expect(computeEditableRange({ ...base, division: '81_UC', bodToYyyymmdd: '20261015' })).toEqual({
      from: '20261005',
      to: '20261231',
    });
  });

  it('40 은 BOD 와 무관하게 플랜 시작일 ~ 조회 종료일이다', () => {
    expect(computeEditableRange({ ...base, division: '40' })).toEqual({ from: '20261005', to: '20261231' });
  });

  it('case 1: frozen >= bodTo 면 frozen ~ 조회 종료일이다', () => {
    expect(
      computeEditableRange({
        ...base,
        shipFrozen: '20261025',
        bodFromYyyymmdd: '20261001',
        bodToYyyymmdd: '20261020',
      })
    ).toEqual({ from: '20261025', to: '20261231' });
  });

  it('case 2: bodFrom >= frozen 이면 bodFrom ~ bodTo 이다', () => {
    expect(
      computeEditableRange({
        ...base,
        shipFrozen: '20260901',
        bodFromYyyymmdd: '20261001',
        bodToYyyymmdd: '20261020',
      })
    ).toEqual({ from: '20261001', to: '20261020' });
  });

  it('case 3: bodFrom < frozen < bodTo 면 frozen ~ bodTo 이다', () => {
    expect(
      computeEditableRange({
        ...base,
        shipFrozen: '20261010',
        bodFromYyyymmdd: '20261001',
        bodToYyyymmdd: '20261020',
      })
    ).toEqual({ from: '20261010', to: '20261020' });
  });

  it('BOD 가 없으면 bodFrom=플랜 시작일, bodTo=조회 종료일로 대체한다', () => {
    // frozen(1010) > 플랜 시작일(1005) → case 3, 구간 끝은 조회 종료일
    expect(computeEditableRange(base)).toEqual({ from: '20261010', to: '20261231' });
    // 플랜 시작일(1015) >= frozen(1010) → case 2, 시작은 플랜 시작일
    expect(computeEditableRange({ ...base, planStartYyyymmdd: '20261015' })).toEqual({
      from: '20261015',
      to: '20261231',
    });
  });

  it('bodTo 가 조회 기간 밖이면 조회 종료일까지로 넓힌다', () => {
    const range = { ...base, shipFrozen: '20261010', bodFromYyyymmdd: '20261001' };
    expect(computeEditableRange({ ...range, bodToYyyymmdd: '20270301' })).toEqual({
      from: '20261010',
      to: '20261231',
    });
    expect(computeEditableRange({ ...range, bodToYyyymmdd: '20261003', queryFromYyyymmdd: '20261005' })).toEqual({
      from: '20261010',
      to: '20261231',
    });
  });
});

describe('isMainCellEditable', () => {
  const ctx: MainEditContext = {
    bucketType: 'DAILY',
    division: 'EE1',
    planStartYyyymmdd: '20261005',
    queryFromYyyymmdd: '20261005',
    queryToYyyymmdd: '20261231',
    weekOrMonthStart: new Map(),
    isEditable: true,
  };
  const row = (extra: Record<string, unknown> = {}) => ({
    MEASURE: 'SHIP_PLAN_AMEND',
    SHIP_FROZEN: '2026-10-10',
    BOD_FROM_YYYYMMDD: '-',
    BOD_TO_YYYYMMDD: '-',
    ...extra,
  });

  it('하이픈 SHIP_FROZEN 과 "-" BOD 행도 frozen 이후 일자만 편집 가능하다', () => {
    expect(isMainCellEditable('D_20261009', row(), ctx)).toBe(false);
    expect(isMainCellEditable('D_20261010', row(), ctx)).toBe(true);
    expect(isMainCellEditable('D_20261120', row(), ctx)).toBe(true);
  });

  it('SHIP_PLAN_AMEND 가 아닌 행은 잠긴다', () => {
    expect(isMainCellEditable('D_20261120', row({ MEASURE: 'SHIP_PLAN' }), ctx)).toBe(false);
  });
});

describe('computeIsEditable', () => {
  const statusRow = (extra: PlanStatusRow): PlanStatusRow => extra;

  it('O_RC2 가 비어있으면(Daily) 게이트 적용 대상이 아니라 통과한다', () => {
    expect(computeIsEditable([], 'PR', '1')).toBe(true);
  });

  it('FN/TE 는 다음 단계 존재 여부와 무관하게 항상 잠금', () => {
    const rows = [statusRow({ PLAN_TYPE: 'FN', PLAN_TYPE_SEQ: 3, PLAN_STATUS: 0 })];
    expect(computeIsEditable(rows, 'FN', '1')).toBe(false);
    expect(computeIsEditable(rows, 'TE', '1')).toBe(false);
  });

  it('PR: 다음 단계(MA) 미생성이면 Y', () => {
    expect(computeIsEditable([statusRow({ PLAN_TYPE: 'PR', PLAN_TYPE_SEQ: 0 })], 'PR', '1')).toBe(true);
  });

  it('PR: MA 가 생성돼 있고 PLAN_STATUS 가 실패(-1)가 아니면 N', () => {
    const rows = [
      statusRow({ PLAN_TYPE: 'PR', PLAN_TYPE_SEQ: 0 }),
      statusRow({ PLAN_TYPE: 'MA', PLAN_TYPE_SEQ: 1, PLAN_STATUS: 0 }),
    ];
    expect(computeIsEditable(rows, 'PR', '1')).toBe(false);
  });

  it('PR: MA 가 생성돼 있어도 전부 실패(-1)면 Y', () => {
    const rows = [
      statusRow({ PLAN_TYPE: 'PR', PLAN_TYPE_SEQ: 0 }),
      statusRow({ PLAN_TYPE: 'MA', PLAN_TYPE_SEQ: 1, PLAN_STATUS: -1 }),
    ];
    expect(computeIsEditable(rows, 'PR', '1')).toBe(true);
  });

  it('MA: SE 미생성이면 현재(MA) 행의 CONFIRM_YN 을 본다', () => {
    const current = statusRow({ PLAN_TYPE: 'MA', PLAN_TYPE_SEQ: 1, PLAN_SEQ: '2', CONFIRM_YN: 'Y' });
    expect(computeIsEditable([current], 'MA', '2')).toBe(true);
    expect(computeIsEditable([{ ...current, CONFIRM_YN: 'N' }], 'MA', '2')).toBe(false);
  });

  it('MA: SE 가 생성돼 있고 실패가 아니면 N(confirm_yn 무관)', () => {
    const rows = [
      statusRow({ PLAN_TYPE: 'MA', PLAN_TYPE_SEQ: 1, PLAN_SEQ: '2', CONFIRM_YN: 'Y' }),
      statusRow({ PLAN_TYPE: 'SE', PLAN_TYPE_SEQ: 2, PLAN_STATUS: 1 }),
    ];
    expect(computeIsEditable(rows, 'MA', '2')).toBe(false);
  });

  it('SE: FN 미생성이면 confirm_yn 과 무관하게 Y', () => {
    expect(computeIsEditable([statusRow({ PLAN_TYPE: 'SE', PLAN_TYPE_SEQ: 2 })], 'SE', '1')).toBe(true);
  });

  it('SE: FN 이 생성돼 있고 실패가 아니면 N', () => {
    const rows = [
      statusRow({ PLAN_TYPE: 'SE', PLAN_TYPE_SEQ: 2 }),
      statusRow({ PLAN_TYPE: 'FN', PLAN_TYPE_SEQ: 3, PLAN_STATUS: 0 }),
    ];
    expect(computeIsEditable(rows, 'SE', '1')).toBe(false);
  });
});
