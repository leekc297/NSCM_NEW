import { describe, expect, it } from 'vitest';

import { BUCKET_TYPE } from '../production-plan-line.constants';

import {
  canFixUnfixNew,
  editablePivotKindForBucket,
  isEeDivision,
  isElectrodeEnabled,
  isFixedColumnVisible,
  isCellTypeExtraSpecEnabled,
  isPastPivot,
  isPivotCellEditable,
  isPivotColumn,
  isPivotVisible,
  isRowEditable,
  pivotKind,
} from './productionPlanLineEditLock';

describe('productionPlanLineEditLock', () => {
  it('pivotKind / isPivotColumn — D_/W_/M_/B_ 분류', () => {
    expect(pivotKind('D_20260105')).toBe('D');
    expect(pivotKind('W_202601')).toBe('W');
    expect(pivotKind('M_202601')).toBe('M');
    expect(pivotKind('B_202601')).toBe('B');
    expect(pivotKind('LINE_ID')).toBeNull();
    expect(isPivotColumn('D_20260105')).toBe(true);
    expect(isPivotColumn('LINE_ID')).toBe(false);
  });

  it('isPivotVisible — bucket × chkSum 매트릭스 (design 03 §2.4)', () => {
    // Daily: D_ 항상 / W_,M_ = chkSum
    expect(isPivotVisible('D_20260105', BUCKET_TYPE.DAILY, false)).toBe(true);
    expect(isPivotVisible('W_202601', BUCKET_TYPE.DAILY, false)).toBe(false);
    expect(isPivotVisible('W_202601', BUCKET_TYPE.DAILY, true)).toBe(true);
    // Weekly: D_ 숨김 / W_ 표시 / M_ = chkSum
    expect(isPivotVisible('D_20260105', BUCKET_TYPE.WEEKLY, true)).toBe(false);
    expect(isPivotVisible('W_202601', BUCKET_TYPE.WEEKLY, false)).toBe(true);
    expect(isPivotVisible('M_202601', BUCKET_TYPE.WEEKLY, true)).toBe(true);
    expect(isPivotVisible('M_202601', BUCKET_TYPE.WEEKLY, false)).toBe(false);
    // Monthly: M_ 만
    expect(isPivotVisible('M_202601', BUCKET_TYPE.MONTHLY, false)).toBe(true);
    expect(isPivotVisible('W_202601', BUCKET_TYPE.MONTHLY, true)).toBe(false);
    // B_ 항상 숨김
    expect(isPivotVisible('B_202601', BUCKET_TYPE.DAILY, true)).toBe(false);
  });

  it('editablePivotKindForBucket — SUM 컬럼 잠금 규칙', () => {
    expect(editablePivotKindForBucket(BUCKET_TYPE.DAILY)).toBe('D');
    expect(editablePivotKindForBucket(BUCKET_TYPE.WEEKLY)).toBe('W');
    expect(editablePivotKindForBucket(BUCKET_TYPE.MONTHLY)).toBe('M');
  });

  it('isPastPivot — 이번 주 월요일 cutoff', () => {
    expect(isPastPivot('D_20200101', '20260105')).toBe(true);
    expect(isPastPivot('D_20990101', '20260105')).toBe(false);
    expect(isPastPivot('M_202001', '20260105')).toBe(true);
    expect(isPastPivot('M_202999', '20260105')).toBe(false);
    expect(isPastPivot('LINE_ID', '20260105')).toBe(false);
  });

  it('isRowEditable — 서버 is_editable + 화면 4규칙 순차 (design 01 F2)', () => {
    const ctx = { lastPlanType: 'MA', hasFn: false };
    // AMEND + is_editable=Y + 마지막 PlanType(MA) → Y
    expect(isRowEditable({ MEASURE: 'PROD_PLAN_AMEND', PLAN_TYPE: 'MA', IS_EDITABLE: 'Y' }, ctx)).toBe(true);
    // 비 AMEND measure → N
    expect(isRowEditable({ MEASURE: 'PROD_PLAN_ENGINE', PLAN_TYPE: 'MA', IS_EDITABLE: 'Y' }, ctx)).toBe(false);
    // (a) 마지막 PlanType 아님 → N
    expect(isRowEditable({ MEASURE: 'PROD_PLAN_AMEND', PLAN_TYPE: 'PR', IS_EDITABLE: 'Y' }, ctx)).toBe(false);
    // (b) FN 존재 → N
    expect(
      isRowEditable({ MEASURE: 'PROD_PLAN_AMEND', PLAN_TYPE: 'MA', IS_EDITABLE: 'Y' }, { lastPlanType: 'MA', hasFn: true })
    ).toBe(false);
    // (c) new_edit_mode=Y → Y (서버 N override)
    expect(
      isRowEditable({ MEASURE: 'PROD_PLAN_AMEND', PLAN_TYPE: 'MA', IS_EDITABLE: 'N', NEW_EDIT_MODE: 'Y' }, ctx)
    ).toBe(true);
    // (d) TE → N (new_edit_mode Y 여도 최종 N)
    expect(
      isRowEditable({ MEASURE: 'PROD_PLAN_AMEND', PLAN_TYPE: 'TE', IS_EDITABLE: 'Y', NEW_EDIT_MODE: 'Y' }, { lastPlanType: 'TE', hasFn: false })
    ).toBe(false);
  });

  it('isPivotCellEditable — 종합 판정', () => {
    const ctx = { lastPlanType: 'MA', hasFn: false };
    const row = { MEASURE: 'PROD_PLAN_AMEND', PLAN_TYPE: 'MA', IS_EDITABLE: 'Y' };
    // Weekly: W_ 미래 셀 + 편집가능 행 → true
    expect(isPivotCellEditable('W_209901', row, BUCKET_TYPE.WEEKLY, ctx, '20260105')).toBe(true);
    // Weekly 인데 M_(SUM) → 잠금
    expect(isPivotCellEditable('M_209901', row, BUCKET_TYPE.WEEKLY, ctx, '20260105')).toBe(false);
    // 과거 셀 → 잠금
    expect(isPivotCellEditable('W_202001', row, BUCKET_TYPE.WEEKLY, ctx, '20260105')).toBe(false);
    // 고정 컬럼 → 잠금
    expect(isPivotCellEditable('LINE_ID', row, BUCKET_TYPE.WEEKLY, ctx, '20260105')).toBe(false);
  });

  it('isFixedColumnVisible — div/opGroup 조건 가시성 (design 03 §1)', () => {
    // EE div 만: ORIGIN_DIVISION_ID
    expect(isFixedColumnVisible('ORIGIN_DIVISION_ID', { division: 'EE01', operationGroup: 'A' })).toBe(true);
    expect(isFixedColumnVisible('ORIGIN_DIVISION_ID', { division: '40', operationGroup: 'A' })).toBe(false);
    // div=40 만: EXTRA_SPEC
    expect(isFixedColumnVisible('EXTRA_SPEC', { division: '40', operationGroup: 'A' })).toBe(true);
    expect(isFixedColumnVisible('EXTRA_SPEC', { division: '81', operationGroup: 'A' })).toBe(false);
    // EE + OpGr=E 만: CELL_ID
    expect(isFixedColumnVisible('CELL_ID', { division: 'EE01', operationGroup: 'E' })).toBe(true);
    expect(isFixedColumnVisible('CELL_ID', { division: 'EE01', operationGroup: 'A' })).toBe(false);
    // OpGr=A(Cell) 만: MODEL_ID
    expect(isFixedColumnVisible('MODEL_ID', { division: '81', operationGroup: 'A' })).toBe(true);
    expect(isFixedColumnVisible('MODEL_ID', { division: '81', operationGroup: 'P' })).toBe(false);
    // 일반 컬럼은 항상 표시
    expect(isFixedColumnVisible('LINE_ID', { division: '81', operationGroup: 'P' })).toBe(true);
  });

  it('enable 규칙 — div=40 CellTypeGr/ExtraSpec, opGroup A/P Electrode', () => {
    expect(isCellTypeExtraSpecEnabled('40')).toBe(true);
    expect(isCellTypeExtraSpecEnabled('81')).toBe(false);
    expect(isElectrodeEnabled('A')).toBe(false);
    expect(isElectrodeEnabled('P')).toBe(false);
    expect(isElectrodeEnabled('E')).toBe(true);
    expect(isEeDivision('EE01')).toBe(true);
    expect(isEeDivision('40')).toBe(false);
  });

  it('canFixUnfixNew — 마지막 주차/SEQ + FN/TE 제외 (design 01 D1)', () => {
    const base = {
      planStartYyyymmdd: '20260105',
      planType: 'MA',
      planSeq: '3',
      latestPlanStart: '20260105',
      latestPlanSeq: '3',
    };
    expect(canFixUnfixNew(base)).toBe(true);
    expect(canFixUnfixNew({ ...base, planType: 'FN' })).toBe(false);
    expect(canFixUnfixNew({ ...base, planType: 'TE' })).toBe(false);
    expect(canFixUnfixNew({ ...base, planStartYyyymmdd: '20251201' })).toBe(false); // 마지막 주차 아님
    expect(canFixUnfixNew({ ...base, planSeq: '2' })).toBe(false); // 마지막 SEQ 아님
    expect(canFixUnfixNew({ ...base, planType: '' })).toBe(false); // 미선택
  });
});
