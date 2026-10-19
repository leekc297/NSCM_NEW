import { describe, expect, it } from 'vitest';

import {
  applyBodPick,
  applyCellChange,
  buildNewCheckArgs,
  buildNewSaveArgs,
  buildSavedItemIds,
  createClonedRow,
  createEmptyRow,
  findMissingRequired,
  getRequiredColumns,
  hasDuplicateRows,
  isCellEditable,
  isColumnVisible,
  isNewPlanBlocked,
  isPlanTypeLocked,
  isSaveSuccess,
  judgeCheckResult,
  type BodPick,
  type NewPlanContext,
  type NewPlanRow,
} from './newPlan';

const ctx = (extra: Partial<NewPlanContext> = {}): NewPlanContext => ({
  divisionId: '40',
  operationGroupId: 'P',
  planStartYyyymmdd: '2026-10-05',
  planType: 'WP',
  planSeq: '3',
  programId: 'FG',
  ...extra,
});

const pick = (extra: Partial<BodPick> = {}): BodPick => ({
  fromSite: 'F1',
  toSite: 'T1',
  bodId: 'B1',
  incoterms: 'FOB',
  transportMode: 'SEA',
  voyageMon: '1',
  voyageTue: '',
  voyageWed: '',
  voyageThu: '',
  voyageFri: '',
  voyageSat: '',
  voyageSun: '',
  ltDay: '7',
  fromYyyymmdd: '20260101',
  toYyyymmdd: '20261231',
  ...extra,
});

const filled = (c: NewPlanContext, itemId: string, extra: Partial<NewPlanRow> = {}): NewPlanRow => ({
  ...applyBodPick({ ...createEmptyRow(c), itemId }, pick()),
  projectCode: 'PJ',
  ...extra,
});

describe('호출 가드', () => {
  it('EE+A 차단은 FG 에서만 적용한다', () => {
    expect(isNewPlanBlocked(ctx({ divisionId: 'EE', operationGroupId: 'A' }))).toBe(true);
    expect(isNewPlanBlocked(ctx({ divisionId: 'EE', operationGroupId: 'A', programId: 'SEMI' }))).toBe(false);
    expect(isNewPlanBlocked(ctx({ divisionId: 'EE', operationGroupId: 'E' }))).toBe(false);
    expect(isNewPlanBlocked(ctx({ divisionId: '40', operationGroupId: 'A' }))).toBe(false);
  });

  it('FN Plan Type 만 수정 불가다', () => {
    expect(isPlanTypeLocked('FN')).toBe(true);
    expect(isPlanTypeLocked('WP')).toBe(false);
  });
});

describe('행 생성', () => {
  it('비EE 는 Origin From/To Div 를 division 으로 채운다', () => {
    const row = createEmptyRow(ctx());
    expect(row.originFromDivisionId).toBe('40');
    expect(row.originToDivisionId).toBe('40');
  });

  it('EE 는 Origin Div 를 비워 둔다', () => {
    const row = createEmptyRow(ctx({ divisionId: 'EE' }));
    expect(row.originFromDivisionId).toBe('');
    expect(row.originToDivisionId).toBe('');
  });

  it('복제 행은 Origin Div 와 Model 만 복사하고 Electrode Type 은 비운다', () => {
    const c = ctx({ divisionId: 'EE', operationGroupId: 'E' });
    const parent: NewPlanRow = filled(c, 'M1', {
      originFromDivisionId: '81',
      originToDivisionId: '40',
      electrodeType: 'C',
    });
    const clone = createClonedRow(c, parent);
    expect(clone.originFromDivisionId).toBe('81');
    expect(clone.originToDivisionId).toBe('40');
    expect(clone.itemId).toBe('M1');
    expect(clone.electrodeType).toBe('');
    expect(clone.bodId).toBe('');
    expect(clone.rowKey).not.toBe(parent.rowKey);
  });
});

describe('편집 가능 여부와 컬럼 표시', () => {
  it('BOD 가 채우는 구간과 Site 는 항상 잠긴다', () => {
    const row = createEmptyRow(ctx());
    (['fromSite', 'toSite', 'incoterms', 'transportMode', 'ltDay', 'fromYyyymmdd'] as const).forEach(k =>
      expect(isCellEditable(ctx(), row, k)).toBe(false)
    );
  });

  it('비EE 는 Model 이 처음부터 열리고 Origin Div 는 잠긴다', () => {
    const row = createEmptyRow(ctx());
    expect(isCellEditable(ctx(), row, 'itemId')).toBe(true);
    expect(isCellEditable(ctx(), row, 'originFromDivisionId')).toBe(false);
  });

  it('EE 는 Origin 쌍을 고른 뒤에야 Model 이 열린다', () => {
    const c = ctx({ divisionId: 'EE' });
    const row = createEmptyRow(c);
    expect(isCellEditable(c, row, 'itemId')).toBe(false);
    expect(isCellEditable(c, { ...row, originFromDivisionId: '81', originToDivisionId: '40' }, 'itemId')).toBe(true);
  });

  it('Project Code 는 FG 에서 BOD 선택 뒤에만 열린다', () => {
    const row = createEmptyRow(ctx());
    expect(isCellEditable(ctx(), row, 'projectCode')).toBe(false);
    expect(isCellEditable(ctx(), { ...row, bodId: 'B1' }, 'projectCode')).toBe(true);
    expect(isCellEditable(ctx({ programId: 'SEMI' }), { ...row, bodId: 'B1' }, 'projectCode')).toBe(false);
  });

  it('Electrode Type 은 EE 이면 Operation Group 과 무관하게 열리고 비EE 는 닫힌다', () => {
    const row = createEmptyRow(ctx());
    expect(isCellEditable(ctx({ divisionId: 'EE', operationGroupId: 'E' }), row, 'electrodeType')).toBe(true);
    expect(isCellEditable(ctx({ divisionId: 'EE', operationGroupId: 'P' }), row, 'electrodeType')).toBe(true);
    expect(isCellEditable(ctx({ operationGroupId: 'E' }), row, 'electrodeType')).toBe(false);
  });

  it('Project 이름은 EE 에서 Model 을 바꾸기 전까지만 열리고 비EE 는 항상 닫힌다', () => {
    const ee = ctx({ divisionId: 'EE' });
    const row = createEmptyRow(ee);
    expect(isCellEditable(ee, row, 'projectName')).toBe(true);
    expect(isCellEditable(ee, createClonedRow(ee, row), 'projectName')).toBe(true);
    const afterModel = applyCellChange(row, 'itemId', 'M1');
    expect(afterModel.projectName).toBe('');
    expect(isCellEditable(ee, afterModel, 'projectName')).toBe(false);
    expect(isCellEditable(ctx(), createEmptyRow(ctx()), 'projectName')).toBe(false);
  });

  it('비EE 는 Origin Div 두 컬럼과 Electrode Type 을 숨기고 SEMI 는 Project Code 를 숨긴다', () => {
    expect(isColumnVisible(ctx(), 'originFromDivisionId')).toBe(false);
    expect(isColumnVisible(ctx(), 'electrodeType')).toBe(false);
    expect(isColumnVisible(ctx({ divisionId: 'EE' }), 'originToDivisionId')).toBe(true);
    expect(isColumnVisible(ctx({ programId: 'SEMI' }), 'projectCode')).toBe(false);
    expect(isColumnVisible(ctx(), 'projectCode')).toBe(true);
  });
});

describe('cascade', () => {
  it('Model 이 바뀌면 Project/Site/BOD 구간을 비운다', () => {
    const c = ctx();
    const row = filled(c, 'M1');
    const next = applyCellChange(row, 'itemId', 'M2');
    expect(next.itemId).toBe('M2');
    expect(next.projectCode).toBe('');
    expect(next.fromSite).toBe('');
    expect(next.bodId).toBe('');
    expect(next.voyageMon).toBe('');
    expect(next.originFromDivisionId).toBe('40');
  });

  it('Origin Div 한쪽이 비면 Model 까지 비운다', () => {
    const c = ctx({ divisionId: 'EE' });
    const row = filled(c, 'M1', { originFromDivisionId: '81', originToDivisionId: '40' });
    const next = applyCellChange(row, 'originToDivisionId', '', { itemStillValid: true });
    expect(next.itemId).toBe('');
    expect(next.bodId).toBe('');
  });

  it('Origin Div 둘이 있고 Model 이 새 후보에 남아 있으면 Model 을 유지한다', () => {
    const c = ctx({ divisionId: 'EE' });
    const row = filled(c, 'M1', { originFromDivisionId: '81', originToDivisionId: '40' });
    expect(applyCellChange(row, 'originFromDivisionId', '82', { itemStillValid: true }).itemId).toBe('M1');
    expect(applyCellChange(row, 'originFromDivisionId', '82', { itemStillValid: false }).itemId).toBe('');
    expect(applyCellChange(row, 'originFromDivisionId', '82', { itemStillValid: true }).bodId).toBe('');
  });

  it('Origin Div 변경은 Project 이름 잠금을 바꾸지 않는다', () => {
    const c = ctx({ divisionId: 'EE' });
    const row = filled(c, 'M1', { originFromDivisionId: '81', originToDivisionId: '40' });
    expect(applyCellChange(row, 'originFromDivisionId', '82').projectNameLocked).toBeUndefined();
  });

  it('Origin Div 변경은 Project 이름(projectName)을 유지한다(AS-IS .cs:739-805)', () => {
    const c = ctx({ divisionId: 'EE' });
    const row = filled(c, 'M1', { originFromDivisionId: '81', originToDivisionId: '40', projectName: 'Proj X' });
    expect(applyCellChange(row, 'originFromDivisionId', '82', { itemStillValid: true }).projectName).toBe('Proj X');
    expect(applyCellChange(row, 'originToDivisionId', '', { itemStillValid: true }).projectName).toBe('Proj X');
  });

  it('Project Code 선택 시 Project 이름을 채운다', () => {
    const row = createEmptyRow(ctx());
    expect(applyCellChange(row, 'projectCode', 'PJ', { projectName: 'Project A' }).projectName).toBe('Project A');
  });
});

describe('필수값', () => {
  it('FG 는 Project Code 가 필수고 SEMI 는 아니다', () => {
    expect(getRequiredColumns(ctx())).toContain('projectCode');
    expect(getRequiredColumns(ctx({ programId: 'SEMI' }))).not.toContain('projectCode');
  });

  it('Electrode Type 은 EE 이고 Operation Group E 일 때만 필수다', () => {
    expect(getRequiredColumns(ctx({ divisionId: 'EE', operationGroupId: 'E' }))).toContain('electrodeType');
    expect(getRequiredColumns(ctx({ divisionId: 'EE', operationGroupId: 'P' }))).not.toContain('electrodeType');
    expect(getRequiredColumns(ctx({ operationGroupId: 'E' }))).not.toContain('electrodeType');
  });

  it('첫 누락 위치를 돌려주고 모두 채워지면 null 이다', () => {
    const c = ctx();
    expect(findMissingRequired(c, [filled(c, 'M1')])).toBeNull();
    expect(findMissingRequired(c, [filled(c, 'M1'), createEmptyRow(c)])).toEqual({ rowIndex: 1, column: 'itemId' });
    expect(findMissingRequired(c, [filled(c, 'M1', { incoterms: '  ' })])).toEqual({ rowIndex: 0, column: 'incoterms' });
  });
});

describe('중복 검사', () => {
  it('9개 키가 모두 같으면 중복이다', () => {
    const c = ctx();
    expect(hasDuplicateRows([filled(c, 'M1'), filled(c, 'M1')])).toBe(true);
  });

  it('하나라도 다르면 중복이 아니다', () => {
    const c = ctx();
    expect(hasDuplicateRows([filled(c, 'M1'), filled(c, 'M2')])).toBe(false);
    expect(hasDuplicateRows([filled(c, 'M1'), filled(c, 'M1', { bodId: 'B2' })])).toBe(false);
    expect(hasDuplicateRows([filled(c, 'M1'), filled(c, 'M1', { electrodeType: 'A' })])).toBe(false);
  });

  it('Project 이름과 voyage 는 중복 키가 아니다', () => {
    const c = ctx();
    expect(hasDuplicateRows([filled(c, 'M1'), filled(c, 'M1', { projectName: 'x', voyageMon: '9' })])).toBe(true);
  });
});

describe('SP 인자 조립', () => {
  const c = ctx({ divisionId: 'EE', operationGroupId: 'E' });
  const rows = [
    filled(c, 'M1', { originFromDivisionId: '81', originToDivisionId: '40', electrodeType: 'C', projectCode: 'PA' }),
    filled(c, 'M2', {
      originFromDivisionId: '82',
      originToDivisionId: '40',
      electrodeType: '',
      projectCode: ' PB ',
      bodId: 'B2',
    }),
  ];

  it('NEW_CHECK 는 스칼라 5개, `^` 연결 7개, prgramId 순서와 키를 지킨다', () => {
    const args = buildNewCheckArgs(c, rows);
    expect(Object.keys(args)).toEqual([
      'divisionId',
      'planStartYyyymmdd',
      'planType',
      'seq',
      'operationGroup',
      'projectCode',
      'itemId',
      'toSite',
      'incoterms',
      'fromSite',
      'bodId',
      'transportMode',
      'prgramId',
    ]);
    expect(args.planStartYyyymmdd).toBe('20261005');
    expect(args.seq).toBe('3');
    expect(args.operationGroup).toBe('E');
    expect(args.projectCode).toBe('PA^PB');
    expect(args.itemId).toBe('M1^M2');
    expect(args.bodId).toBe('B1^B2');
    expect(args.prgramId).toBe('FG');
  });

  it('SAVE 는 transportMode 가 없고 Origin Div/Electrode Type 이 있으며 sesUserId 를 보내지 않는다', () => {
    const args = buildNewSaveArgs(c, rows);
    expect(Object.keys(args)).toEqual([
      'divisionId',
      'planStartYyyymmdd',
      'planType',
      'seq',
      'operationGroup',
      'projectCode',
      'itemId',
      'toSite',
      'incoterms',
      'fromSite',
      'bodId',
      'originFromDivisionId',
      'originToDivisionId',
      'electrodeType',
      'prgramId',
    ]);
    expect(args.originFromDivisionId).toBe('81^82');
    expect(args.originToDivisionId).toBe('40^40');
    // 빈 값은 빈 토큰으로 남아 위치가 어긋나지 않는다.
    expect(args.electrodeType).toBe('C^');
  });

  it('SEMI 는 programId 를 SEMI 로 보낸다', () => {
    expect(buildNewSaveArgs(ctx({ programId: 'SEMI' }), rows).prgramId).toBe('SEMI');
  });

  it('하이픈 없는 날짜는 그대로 쓴다', () => {
    expect(buildNewCheckArgs(ctx({ planStartYyyymmdd: '20261005' }), rows).planStartYyyymmdd).toBe('20261005');
  });
});

describe('저장 후 처리와 결과 판정', () => {
  it('저장 Item 목록은 중복을 제거하지 않는다', () => {
    const c = ctx();
    expect(buildSavedItemIds([filled(c, 'M1'), filled(c, 'M1', { bodId: 'B2' }), filled(c, ' M2 ')])).toEqual([
      'M1',
      'M1',
      'M2',
    ]);
  });

  it('NEW_CHECK 결과 S/D/그 외를 구분한다', () => {
    expect(judgeCheckResult({ RESULT_CODE: 'S', MSG: '' })).toEqual({ status: 'OK', detail: '' });
    expect(judgeCheckResult({ RESULT_CODE: 'D', MSG: 'M1 / F1' })).toEqual({ status: 'DUPLICATE', detail: 'M1 / F1' });
    expect(judgeCheckResult({ RESULT_CODE: 'X' }).status).toBe('ERROR');
    expect(judgeCheckResult(undefined).status).toBe('ERROR');
  });

  it('SAVE 결과는 S 만 성공이다', () => {
    expect(isSaveSuccess({ RESULT_CODE: 'S' })).toBe(true);
    expect(isSaveSuccess({ RESULT_CODE: 'F', ERR_MESSAGE: 'x' })).toBe(false);
    expect(isSaveSuccess(undefined)).toBe(false);
  });
});
