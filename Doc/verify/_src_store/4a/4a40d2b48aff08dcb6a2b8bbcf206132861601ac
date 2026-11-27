import { describe, expect, it } from 'vitest';

import type { BusinessPlanRow } from '../business-plan.types';

import { buildSavePayload, buildUnfoldRows, type SaveUnfoldRow } from './business-plan.save';

// P_DMF0042_SAVE_DM_PLN_BP_FCST 선언 순서 (주석 처리된 p_DOM_EXP·CELL_PER_* 제외, OUT 제외).
//   SP 는 positional 매핑이라 이 키 집합이 곧 계약이다.
const SP_IN_KEYS = [
  'activeFlag',
  'divisionId',
  'projectCode',
  'projectName',
  'scmSiteId',
  'plantSiteId',
  'itemId',
  'fcstType',
  'incoterms',
  'itemUse',
  'unitEnergy',
  'measure',
  'yyyymm',
  'qty',
  'currency',
  'deptId',
  'endCustomer',
  'bizType',
  'cellProdSite',
  'createdBy',
  'lastUpdatedBy',
];

const row = (over: Partial<SaveUnfoldRow> = {}): SaveUnfoldRow => ({
  activeFlag: 'M',
  divisionId: '40',
  projectCode: '',
  projectName: '',
  scmSiteId: 'SITE1',
  plantSiteId: '',
  itemId: 'ITEM1',
  fcstType: 'Mass',
  incoterms: 'DAP',
  itemUse: '',
  unitEnergy: '0',
  measure: 'Business_Plan',
  yyyymm: '202608',
  qty: '100',
  currency: 'USD',
  deptId: 'DEPT1',
  endCustomer: 'EC1',
  bizType: '',
  cellProdSite: 'NJ',
  ...over,
});

describe('buildSavePayload', () => {
  it('SP IN 파라미터 21개를 모두 싣는다 (감사 2키 포함)', () => {
    const payload = buildSavePayload([row()], 'youngeun') ?? {};

    expect(Object.keys(payload).sort()).toEqual([...SP_IN_KEYS].sort());
  });

  // BE call-proc 은 요청에 없는 COL_NM 을 null 로 바인딩한다(자동 주입은 sesUserId/sesLangCd 뿐).
  //   감사 2키를 빼면 CREATED_BY/LAST_UPDATED_BY 가 빈 채로 저장된다 (2026-08-25 리포트).
  it('감사 2키 = 세션 userId, 행 수만큼 반복 (bulk SP 가 모든 IN 을 ^ split 한다)', () => {
    const payload = buildSavePayload([row(), row({ yyyymm: '202609' })], 'youngeun') ?? {};

    expect(payload.createdBy).toBe('youngeun^youngeun');
    expect(payload.lastUpdatedBy).toBe('youngeun^youngeun');
    // 다른 키와 토큰 수가 같아야 SP 의 row 별 매핑이 어긋나지 않는다
    expect(payload.createdBy.split('^')).toHaveLength(payload.qty.split('^').length);
  });

  it('세션 userId 가 없으면 빈 토큰으로 자리를 지킨다 (토큰 수 유지)', () => {
    const payload = buildSavePayload([row(), row()], '') ?? {};

    expect(payload.createdBy).toBe('^');
    expect(payload.createdBy.split('^')).toHaveLength(2);
  });

  it('40 신규행 — Energy(WH) 가 unitEnergy 슬롯(P_UNIT_ENERGY)으로 나간다', () => {
    const payload =
      buildSavePayload([{ ...row(), unitEnergy: '0.096' }], 'youngeun') ?? {};

    expect(payload.unitEnergy).toBe('0.096');
  });

  it('저장 대상 0건이면 null', () => {
    expect(buildSavePayload([], 'youngeun')).toBeNull();
  });
});

// ============================================================================
// buildUnfoldRows — 변경된 셀만 담는다 (행 단위).
//   금지: 수량↔단가(LOC) 짝 전송. 저장 SP 가 2026-08-24 자로 서버에서 보완한다
//     (P_DMF0042_SAVE_DM_PLN_BP_FCST L612~623 — Business_Plan 만 오면 원장 LOC 를 임시테이블에
//      채워 넣고, NOT EXISTS 로 화면이 이미 보낸 LOC 는 건드리지 않는다).
//     FE 가 짝을 다시 보내면 공란 LOC 가 `qty '0' → activeFlag 'D'` 에 걸려 원장 단가를 지운다.
// ============================================================================
const MSG = { duplicateKey: 'MSG00043' } as const;

const KEY = {
  DIVISION_ID: '40',
  END_CUSTOMER40: 'BYD',
  SCM_SITE_ID40: 'SITE1',
  ITEM_ID40: 'MCSS22561',
  DEPT_ID40: 'DEPT1',
  CURRENCY: 'USD',
  FCST_TYPE: 'Mass',
  INCOTERMS: 'DAP',
  CELL_PROD_SITE: 'NJ',
};

/** 한 키셋의 measure 블록 (BP / LOC / SalesAmt 2종 — 화면 표시 순서). */
const block = (over: {
  bp?: Record<string, unknown>;
  loc?: Record<string, unknown>;
  crud?: 'I';
}): BusinessPlanRow[] => {
  const common = { ...KEY, ...(over.crud ? { CRUD_TYPE: over.crud } : {}) };
  return [
    { ...common, MEASURE: 'Business_Plan', ...(over.bp ?? {}) },
    { ...common, MEASURE: 'LOC', ...(over.loc ?? {}) },
    { ...common, MEASURE: 'SalesAmt_KRW', M_202701: 999 },
    { ...common, MEASURE: 'SalesAmt_USD', M_202701: 999 },
  ] as BusinessPlanRow[];
};

const runUnfold = (rows: BusinessPlanRow[], changes: Map<BusinessPlanRow, Record<string, unknown>>) =>
  buildUnfoldRows({
    insertedRows: rows.filter(r => r.CRUD_TYPE === 'I'),
    editedChanges: changes,
    divisionId: '40',
    msg: MSG,
  });

describe('buildUnfoldRows', () => {
  it('수량만 고치면 그 셀 1건만 나간다 — LOC 짝은 저장 SP 가 원장에서 보완한다', () => {
    const rows = block({ bp: { M_202701: 500 }, loc: { M_202701: 1.27 } });
    const changes = new Map([[rows[0], { M_202701: 300 }]]);

    const { rows: out } = runUnfold(rows, changes);

    expect(out).toHaveLength(1);
    expect([out[0].measure, out[0].yyyymm, out[0].qty, out[0].activeFlag]).toEqual([
      'Business_Plan',
      '202701',
      '500',
      'M',
    ]);
  });

  it('단가만 고치면 LOC 1건 — 금액은 SP 가 원장 수량과 곱해 만든다', () => {
    const rows = block({ bp: { M_202701: 500 }, loc: { M_202701: 1.27 } });
    const changes = new Map([[rows[1], { M_202701: 1 }]]);

    const { rows: out } = runUnfold(rows, changes);

    expect(out.map(r => r.measure)).toEqual(['LOC']);
    expect(out[0].qty).toBe('1.27');
  });

  it('값을 지운 셀은 0 → activeFlag D (셀 단위 삭제)', () => {
    const rows = block({ bp: { M_202701: '' }, loc: { M_202701: 1.27 } });
    const changes = new Map([[rows[0], { M_202701: 500 }]]);

    const { rows: out } = runUnfold(rows, changes);

    expect(out[0].activeFlag).toBe('D');
    expect(out[0].qty).toBe('0');
  });

  it('SalesAmt 등 파생 measure 는 변경돼도 전송하지 않는다 (SP 산출)', () => {
    const rows = block({ bp: { M_202701: 500 } });
    const changes = new Map([[rows[2], { M_202701: 1 }]]);

    const { rows: out } = runUnfold(rows, changes);

    expect(out).toHaveLength(0);
  });

  it('신규 블록 — 값 있는 M_ 셀 전량, activeFlag = I', () => {
    const rows = block({ bp: { M_202701: 100 }, loc: { M_202701: 1.27 }, crud: 'I' });

    const { rows: out } = runUnfold(rows, new Map());

    expect(out.map(r => r.measure).sort()).toEqual(['Business_Plan', 'LOC']);
    expect(out.every(r => r.activeFlag === 'I')).toBe(true);
  });

  it('변경 없으면 0건', () => {
    const rows = block({ bp: { M_202701: 500 }, loc: { M_202701: 1.27 } });

    expect(runUnfold(rows, new Map()).rows).toHaveLength(0);
  });
});
