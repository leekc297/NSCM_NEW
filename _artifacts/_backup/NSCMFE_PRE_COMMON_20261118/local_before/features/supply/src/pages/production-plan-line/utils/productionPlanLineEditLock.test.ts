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
  isStageEditableFor,
  pivotKind,
} from './productionPlanLineEditLock';

// EDIT_INFO 맵 fixture — CP_KEY→엔트리 (M4c). NEW_EDIT_MODE='Y' 는 server IS_EDITABLE/(a)(b) override(c).
const editInfo: EditInfoMap = new Map([
  ['CP1', { isEditable: 'Y', newEditMode: 'Y', editStartDate: '' }], // 서버 Y + override Y
  ['CP0', { isEditable: 'N', newEditMode: 'Y', editStartDate: '' }], // 서버 N 이지만 new_edit_mode='Y'(SP 상수) → 편집가능
  ['CPNN', { isEditable: 'N', newEditMode: 'N', editStartDate: '' }], // 둘 다 N → 편집불가(override 없음)
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

  it('isStageEditableFor — FN 또는 콤보에 다음 단계 존재 시 잠금 (순서 TE→PR→MA→SE→FN, 테스터 2026-11-05)', () => {
    // 순서 TE<PR<MA<SE<FN. 선택보다 '뒤(later)' 단계가 옵션에 있으면 잠금 + FN 은 그 자체로 잠금.
    // {PR,MA,FN}: FN 이 최후 → PR·MA 는 뒤 단계 존재로 잠금.
    expect(isStageEditableFor('PR', ['PR', 'MA', 'FN'])).toBe(false); // 뒤 단계 MA/FN 존재
    expect(isStageEditableFor('MA', ['PR', 'MA', 'FN'])).toBe(false); // 뒤 단계 FN 존재
    expect(isStageEditableFor('FN', ['PR', 'MA', 'FN'])).toBe(false); // (1) FN 조회
    // {TE,PR,MA,FN}: FN 이 최후 → TE·PR 잠금.
    expect(isStageEditableFor('TE', ['TE', 'PR', 'MA', 'FN'])).toBe(false); // 뒤 단계 PR/MA/FN 존재
    expect(isStageEditableFor('PR', ['TE', 'PR', 'MA', 'FN'])).toBe(false); // 뒤 단계 MA/FN 존재
    // 테스터 시나리오: SE 가 있으면 MA·PR 잠금, SE 는 (최후면) 편집가능.
    expect(isStageEditableFor('PR', ['PR', 'MA', 'SE'])).toBe(false); // 뒤 단계 MA/SE
    expect(isStageEditableFor('MA', ['PR', 'MA', 'SE'])).toBe(false); // 뒤 단계 SE
    expect(isStageEditableFor('SE', ['PR', 'MA', 'SE'])).toBe(true); // SE 가 최후 → 편집가능
    // 테스터 시나리오: MA 가 있으면 PR 잠금, MA 는 최후면 편집가능.
    expect(isStageEditableFor('PR', ['PR', 'MA'])).toBe(false); // 뒤 단계 MA 존재
    expect(isStageEditableFor('MA', ['PR', 'MA'])).toBe(true); // MA 가 최후(PR 은 앞) → 편집가능
    // 단일 비-FN 최후 → 편집가능.
    expect(isStageEditableFor('MA', ['MA'])).toBe(true);
    // 단일 FN(최종 단계) → 잠금.
    expect(isStageEditableFor('FN', ['FN'])).toBe(false);
    // 빈 선택/순서 미등록 type → false.
    expect(isStageEditableFor('', ['PR', 'MA'])).toBe(false);
    expect(isStageEditableFor('ZZ', ['ZZ'])).toBe(false);
  });

  it('editablePivotKindForBucket — SUM 컬럼 잠금 규칙 (Monthly=읽기전용, AS-IS cs:1155)', () => {
    expect(editablePivotKindForBucket(BUCKET_TYPE.DAILY)).toBe('D');
    expect(editablePivotKindForBucket(BUCKET_TYPE.WEEKLY)).toBe('W');
    // Monthly 는 M_(월SUM)이 항상 잠겨 편집 가능한 kind 가 없다 → null (AS-IS 전 bucket M_ 잠금).
    expect(editablePivotKindForBucket(BUCKET_TYPE.MONTHLY)).toBeNull();
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

  it('isRowEditable — EDIT_INFO + new_edit_mode override + 화면규칙 (AS-IS EditButton cs:715~741)', () => {
    const ctx = { lastPlanType: 'MA', hasFn: false, isStageEditable: true };
    // AMEND + is_editable=Y(CP1) + 마지막 PlanType(MA) → Y
    expect(isRowEditable({ MEASURE: 'PROD_PLAN_AMEND', PLAN_TYPE: 'MA', CP_KEY: 'CP1' }, ctx, editInfo)).toBe(true);
    // 비 AMEND measure → N (measure 게이트)
    expect(isRowEditable({ MEASURE: 'PROD_PLAN_ENGINE', PLAN_TYPE: 'MA', CP_KEY: 'CP1' }, ctx, editInfo)).toBe(false);
    // EDIT_INFO 미반환(CP 없음) → N (서버 원천 없음, AS-IS drs.Length==0 continue)
    expect(isRowEditable({ MEASURE: 'PROD_PLAN_AMEND', PLAN_TYPE: 'MA', CP_KEY: 'ZZZ' }, ctx, editInfo)).toBe(false);
    // 서버 IS_EDITABLE='N'(CP0) 이라도 new_edit_mode='Y'(SP 상수) → Y (AS-IS cs:731~735 override) — 사용자신고 2026-10-14 회귀가드
    expect(isRowEditable({ MEASURE: 'PROD_PLAN_AMEND', PLAN_TYPE: 'MA', CP_KEY: 'CP0' }, ctx, editInfo)).toBe(true);
    // (a) 마지막 PlanType 아님(PR≠MA) 이라도 new_edit_mode='Y' 가 (a)를 덮어 → Y
    expect(isRowEditable({ MEASURE: 'PROD_PLAN_AMEND', PLAN_TYPE: 'PR', CP_KEY: 'CP1' }, ctx, editInfo)).toBe(true);
    // (b) FN 존재해도 new_edit_mode='Y' 가 (b)를 덮어 → Y (다음단계 저장차단은 SAVE_YN 담당)
    expect(
      isRowEditable({ MEASURE: 'PROD_PLAN_AMEND', PLAN_TYPE: 'MA', CP_KEY: 'CP1' }, { lastPlanType: 'MA', hasFn: true, isStageEditable: true }, editInfo)
    ).toBe(true);
    // new_edit_mode='N' + 서버 N(CPNN) → N (override 없음)
    expect(isRowEditable({ MEASURE: 'PROD_PLAN_AMEND', PLAN_TYPE: 'MA', CP_KEY: 'CPNN' }, ctx, editInfo)).toBe(false);
    // (d) TE → N (new_edit_mode='Y' 여도 TE 가 최종 override)
    expect(
      isRowEditable({ MEASURE: 'PROD_PLAN_AMEND', PLAN_TYPE: 'TE', CP_KEY: 'CP1' }, { lastPlanType: 'TE', hasFn: false, isStageEditable: true }, editInfo)
    ).toBe(false);
  });

  it('isRowEditable — stage 잠금(isStageEditable=false) 면 전건 잠금 (FN·다음단계 존재, 사용자 지시 2026-11-04)', () => {
    // isStageEditable=false(FN 조회 또는 콤보에 다음 단계 존재) → new_edit_mode='Y' 여도 편집 불가.
    const lockedCtx = { lastPlanType: 'MA', hasFn: false, isStageEditable: false };
    expect(isRowEditable({ MEASURE: 'PROD_PLAN_AMEND', PLAN_TYPE: 'MA', CP_KEY: 'CP1' }, lockedCtx, editInfo)).toBe(false);
    // isPivotCellEditable 도 동일하게 전건 잠금(셀 컬러/beginningEdit 게이트 공유).
    expect(
      isPivotCellEditable('W_209901', { MEASURE: 'PROD_PLAN_AMEND', PLAN_TYPE: 'MA', CP_KEY: 'CP1' }, BUCKET_TYPE.WEEKLY, lockedCtx, '20260105', editInfo)
    ).toBe(false);
  });

  it('isPivotCellEditable — 종합 판정', () => {
    const ctx = { lastPlanType: 'MA', hasFn: false, isStageEditable: true };
    const row = { MEASURE: 'PROD_PLAN_AMEND', PLAN_TYPE: 'MA', CP_KEY: 'CP1' };
    // Weekly: W_ 미래 셀 + 편집가능 행 → true
    expect(isPivotCellEditable('W_209901', row, BUCKET_TYPE.WEEKLY, ctx, '20260105', editInfo)).toBe(true);
    // Weekly 인데 M_(SUM) → 잠금
    expect(isPivotCellEditable('M_209901', row, BUCKET_TYPE.WEEKLY, ctx, '20260105', editInfo)).toBe(false);
    // 과거 셀 → 잠금
    expect(isPivotCellEditable('W_202001', row, BUCKET_TYPE.WEEKLY, ctx, '20260105', editInfo)).toBe(false);
    // 고정 컬럼 → 잠금
    expect(isPivotCellEditable('LINE_ID', row, BUCKET_TYPE.WEEKLY, ctx, '20260105', editInfo)).toBe(false);
    // Monthly: 보이는 M_(월SUM)도 편집불가 — Monthly 는 집계 조회 전용(AS-IS cs:1155 전 bucket M_ 잠금).
    expect(isPivotCellEditable('M_209901', row, BUCKET_TYPE.MONTHLY, ctx, '20260105', editInfo)).toBe(false);
  });

  it('isPivotCellEditable — 서버 EDIT_START_DATE 로 편집시작 전 셀 잠금 (L8 / design 03 §3.6 #33)', () => {
    const ctx = { lastPlanType: 'MA', hasFn: false, isStageEditable: true };
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
