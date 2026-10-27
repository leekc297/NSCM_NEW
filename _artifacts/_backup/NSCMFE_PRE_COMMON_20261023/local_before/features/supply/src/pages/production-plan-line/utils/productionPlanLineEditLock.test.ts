import { describe, expect, it } from 'vitest';

import { BUCKET_TYPE } from '../production-plan-line.constants';

import {
  buildFixKey,
  canFixUnfixNew,
  type EditInfoMap,
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

// EDIT_INFO 맵 fixture — CP_KEY→엔트리 (M4c). NEW_EDIT_MODE 는 SP 상수 'Y'(비소비).
const editInfo: EditInfoMap = new Map([
  ['CP1', { isEditable: 'Y', newEditMode: 'Y', editStartDate: '' }],
  ['CP0', { isEditable: 'N', newEditMode: 'Y', editStartDate: '' }],
]);

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

  it('buildFixKey — 8필드 concat + origin/electrode NVL 공백→"-" (M4a)', () => {
    // O_RC2 가 origin/electrode 를 NVL "-" 하므로 그리드행 공백도 "-" 로 정규화해 매칭.
    expect(
      buildFixKey({
        DIVISION_ID: '81',
        OPERATION_GROUP: 'A',
        SCM_SITE_ID: 'S1',
        ITEM_ID: 'I1',
        LINE_ID: 'L1',
        OPERATION_ID: 'O1',
        ORIGIN_DIVISION_ID: '',
        ELECTRODE_TYPE: '',
      })
    ).toBe('81AS1I1L1O1--');
    expect(
      buildFixKey({
        DIVISION_ID: 'EE01',
        OPERATION_GROUP: 'E',
        SCM_SITE_ID: 'S2',
        ITEM_ID: 'I2',
        LINE_ID: 'L2',
        OPERATION_ID: 'O2',
        ORIGIN_DIVISION_ID: '40',
        ELECTRODE_TYPE: 'ANODE',
      })
    ).toBe('EE01ES2I2L2O240ANODE');
  });

  it('isRowEditable — EDIT_INFO(CP_KEY) is_editable + 화면 3규칙 (design 01 F2 / M4c)', () => {
    const ctx = { lastPlanType: 'MA', hasFn: false };
    // AMEND + is_editable=Y(CP1) + 마지막 PlanType(MA) → Y
    expect(isRowEditable({ MEASURE: 'PROD_PLAN_AMEND', PLAN_TYPE: 'MA', CP_KEY: 'CP1' }, ctx, editInfo)).toBe(true);
    // 비 AMEND measure → N
    expect(isRowEditable({ MEASURE: 'PROD_PLAN_ENGINE', PLAN_TYPE: 'MA', CP_KEY: 'CP1' }, ctx, editInfo)).toBe(false);
    // EDIT_INFO 미반환(CP 없음) → N (서버 is_editable 원천 없음)
    expect(isRowEditable({ MEASURE: 'PROD_PLAN_AMEND', PLAN_TYPE: 'MA', CP_KEY: 'ZZZ' }, ctx, editInfo)).toBe(false);
    // (a) 마지막 PlanType 아님 → N
    expect(isRowEditable({ MEASURE: 'PROD_PLAN_AMEND', PLAN_TYPE: 'PR', CP_KEY: 'CP1' }, ctx, editInfo)).toBe(false);
    // (b) FN 존재 → N
    expect(
      isRowEditable({ MEASURE: 'PROD_PLAN_AMEND', PLAN_TYPE: 'MA', CP_KEY: 'CP1' }, { lastPlanType: 'MA', hasFn: true }, editInfo)
    ).toBe(false);
    // is_editable=N(CP0) → N (NEW_EDIT_MODE 상수 'Y' 는 비소비 — IS_EDITABLE 게이트 유지)
    expect(isRowEditable({ MEASURE: 'PROD_PLAN_AMEND', PLAN_TYPE: 'MA', CP_KEY: 'CP0' }, ctx, editInfo)).toBe(false);
    // (d) TE → N
    expect(
      isRowEditable({ MEASURE: 'PROD_PLAN_AMEND', PLAN_TYPE: 'TE', CP_KEY: 'CP1' }, { lastPlanType: 'TE', hasFn: false }, editInfo)
    ).toBe(false);
  });

  it('isPivotCellEditable — 종합 판정', () => {
    const ctx = { lastPlanType: 'MA', hasFn: false };
    const row = { MEASURE: 'PROD_PLAN_AMEND', PLAN_TYPE: 'MA', CP_KEY: 'CP1' };
    // Weekly: W_ 미래 셀 + 편집가능 행 → true
    expect(isPivotCellEditable('W_209901', row, BUCKET_TYPE.WEEKLY, ctx, '20260105', editInfo)).toBe(true);
    // Weekly 인데 M_(SUM) → 잠금
    expect(isPivotCellEditable('M_209901', row, BUCKET_TYPE.WEEKLY, ctx, '20260105', editInfo)).toBe(false);
    // 과거 셀 → 잠금
    expect(isPivotCellEditable('W_202001', row, BUCKET_TYPE.WEEKLY, ctx, '20260105', editInfo)).toBe(false);
    // 고정 컬럼 → 잠금
    expect(isPivotCellEditable('LINE_ID', row, BUCKET_TYPE.WEEKLY, ctx, '20260105', editInfo)).toBe(false);
  });

  it('isPivotCellEditable — 서버 EDIT_START_DATE 로 편집시작 전 셀 잠금 (L8 / design 03 §3.6 #33)', () => {
    const ctx = { lastPlanType: 'MA', hasFn: false };
    const row = { MEASURE: 'PROD_PLAN_AMEND', PLAN_TYPE: 'MA', CP_KEY: 'CP2' };
    // 서버 편집시작일 20260201 — 전역 cutoff(20260101)보다 뒤.
    const info: EditInfoMap = new Map([
      ['CP2', { isEditable: 'Y', newEditMode: 'Y', editStartDate: '20260201' }],
    ]);
    // cutoff 이후지만 서버 편집시작일 전 → 잠금(max(cutoff, editStartDate) 적용)
    expect(isPivotCellEditable('D_20260115', row, BUCKET_TYPE.DAILY, ctx, '20260101', info)).toBe(false);
    // 서버 편집시작일 이후 → 편집가능
    expect(isPivotCellEditable('D_20260215', row, BUCKET_TYPE.DAILY, ctx, '20260101', info)).toBe(true);
  });

  it('isFixedColumnVisible — opGroup 조건만 (division 은 SCM_MST_SHEET_COLUMNS 서버 필터로 이동)', () => {
    // division 기반 컬럼(ORIGIN_DIVISION_ID/EXTRA_SPEC 등)은 더 이상 FE 에서 가리지 않는다 —
    //   DIVISION_ID(PR_GET_SHEET_COLUMN_LIST) 서버 필터가 담당하므로 이 함수는 항상 true.
    expect(isFixedColumnVisible('ORIGIN_DIVISION_ID', { division: '40', operationGroup: 'A' })).toBe(true);
    expect(isFixedColumnVisible('EXTRA_SPEC', { division: '81', operationGroup: 'A' })).toBe(true);
    // CELL_ID/UNIT: Operation Group=Electrode 일 때만 (EE 계열 조건은 서버 DIVISION_ID 필터).
    expect(isFixedColumnVisible('CELL_ID', { division: 'EE01', operationGroup: 'E' })).toBe(true);
    expect(isFixedColumnVisible('CELL_ID', { division: 'EE01', operationGroup: 'A' })).toBe(false);
    expect(isFixedColumnVisible('UNIT', { division: '81', operationGroup: 'E' })).toBe(true);
    // MODEL_ID: AS-IS SetColumnModelVisible 가 cs:373 주석 처리로 미호출되는 dead code 라 opGroup 무관
    //   항상 표시(div 40·81·82 는 서버 DIVISION_ID 메타로 노출). opGroup=P 여도 가려지지 않는다.
    expect(isFixedColumnVisible('MODEL_ID', { division: '81', operationGroup: 'A' })).toBe(true);
    expect(isFixedColumnVisible('MODEL_ID', { division: '81', operationGroup: 'P' })).toBe(true);
    // 일반 컬럼은 항상 표시.
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
