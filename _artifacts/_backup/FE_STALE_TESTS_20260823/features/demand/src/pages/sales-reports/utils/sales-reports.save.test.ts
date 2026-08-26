import { describe, expect, it } from 'vitest';

import { DATA_TYPE, MSG } from '../sales-reports.constants';
import type { SalesReportRow } from '../sales-reports.types';

import {
  buildBulkPayload,
  buildCutoffSaveRows,
  buildEtcInsertRows,
  buildEtcSaveRows,
  isEtc,
} from './sales-reports.save';

const baseRow = (over: Partial<SalesReportRow> = {}): SalesReportRow => ({
  DIVISION_ID: '40',
  DEPARTMENT_ID: 'D1',
  DEPARTMENT_NAME: 'Dept1',
  MEASURE: 'LOC',
  ...over,
});

describe('buildEtcInsertRows', () => {
  it('2행 세트 생성 즉시 상대 Measure를 CELL_MODEL_INFO에 세팅한다', () => {
    const rows = buildEtcInsertRows({
      measures: ['SalesAmt_KRW', 'SalesAmt_LOC'],
      divisionId: '40',
      groupId: 'I_1',
    });

    expect(rows).toHaveLength(2);
    expect(rows[0]).toMatchObject({
      CRUD_TYPE: 'I',
      INSERT_GROUP_ID: 'I_1',
      MEASURE: 'SalesAmt_KRW',
      CELL_MODEL_INFO: 'SalesAmt_LOC',
      CELL_MODEL: '',
    });
    expect(rows[1]).toMatchObject({
      MEASURE: 'SalesAmt_LOC',
      CELL_MODEL_INFO: 'SalesAmt_KRW',
      CELL_MODEL: '',
    });
  });
});

// TC-DMF0044-F 저장 이원화 — ETC(2)=2행 세트 20키 bulk, Cutoff(1)='M' 행만 22키 bulk.
describe('buildEtcSaveRows', () => {
  it('변경된 M_ 셀만 대상으로 20키 행을 만든다 (짝 행 값은 cellModelInfo/cellModel)', () => {
    const row = baseRow({ M_202607: 100 });
    const pair = baseRow({ MEASURE: 'RTF_SYS_RP', M_202607: 999 });
    const result = buildEtcSaveRows({
      targets: [{ row, changes: { M_202607: 0 }, pair }],
      versionNo: 'V1',
    });

    expect(result.error).toBeUndefined();
    expect(result.rows).toHaveLength(1);
    expect(result.rows[0]).toMatchObject({
      activeFlag: 'M',
      yyyymmdd: '202607',
      qty: '100',
      cellModelInfo: 'RTF_SYS_RP',
      cellModel: '999',
      versionNo: 'V1',
    });
  });

  it('신규 삽입행(CRUD_TYPE=I) 은 값이 있는 M_ 셀 전부를 저장 대상으로 삼는다', () => {
    const row = baseRow({ CRUD_TYPE: 'I', M_202607: 50, M_202608: '', M_202609: 30 });
    const result = buildEtcSaveRows({ targets: [{ row }], versionNo: 'V1' });

    expect(result.rows.map(r => r.yyyymmdd).sort()).toStrictEqual(['202607', '202609']);
    expect(result.rows.every(r => r.activeFlag === 'I')).toBe(true);
  });

  it('빈 값 셀은 qty=0 으로 치환된다', () => {
    const row = baseRow({ M_202607: '' });
    const result = buildEtcSaveRows({
      targets: [{ row, changes: { M_202607: 0 } }],
      versionNo: 'V1',
    });
    expect(result.rows[0]?.qty).toBe('0');
  });

  it('Department 미입력(ID·NAME 모두 공란) 은 MSG00429 로 즉시 중단된다', () => {
    const row = baseRow({ DEPARTMENT_ID: '', DEPARTMENT_NAME: '' });
    const result = buildEtcSaveRows({
      targets: [{ row, changes: { M_202607: 0 } }],
      versionNo: 'V1',
    });

    expect(result.rows).toStrictEqual([]);
    expect(result.error).toStrictEqual({
      ok: false,
      msgId: MSG.REQUIRED_FIELD,
      detail: 'Department',
    });
  });
});

describe('buildCutoffSaveRows', () => {
  it('신규 삽입행(CRUD_TYPE=I) 은 Cutoff 저장 대상에서 제외된다 (Insert=ETC 전용)', () => {
    const row = baseRow({ CRUD_TYPE: 'I', M_202607: 10 });
    const result = buildCutoffSaveRows({
      targets: [{ row, changes: { M_202607: 0 } }],
      versionNo: 'V1',
    });
    expect(result.rows).toStrictEqual([]);
  });

  it('수정행(변경 셀 존재)은 22키 행으로 변환된다', () => {
    const row = baseRow({ M_202607: 200, SCM_SITE_ID: 'S1', PROJECT_CODE: 'P1', FCST_TYPE: 'RMA' });
    const result = buildCutoffSaveRows({
      targets: [{ row, changes: { M_202607: 0 } }],
      versionNo: 'V1',
    });

    expect(result.error).toBeUndefined();
    expect(result.rows[0]).toMatchObject({
      activeFlag: 'M',
      yyyymmdd: '202607',
      qty: '200',
      scmSiteId: 'S1',
      projectCode: 'P1',
      fcstType: 'RMA',
    });
  });

  it('Department 미입력은 MSG00429 로 중단된다', () => {
    const row = baseRow({ DEPARTMENT_ID: '', DEPARTMENT_NAME: '', M_202607: 1 });
    const result = buildCutoffSaveRows({
      targets: [{ row, changes: { M_202607: 0 } }],
      versionNo: 'V1',
    });
    expect(result.error).toStrictEqual({
      ok: false,
      msgId: MSG.REQUIRED_FIELD,
      detail: 'Department',
    });
  });
});

describe('buildBulkPayload', () => {
  it('행이 없으면 null', () => {
    expect(buildBulkPayload([])).toBeNull();
  });

  it("'^' 구분으로 컬럼별 값을 join 한다", () => {
    const payload = buildBulkPayload([
      { a: '1', b: 'x' },
      { a: '2', b: 'y' },
    ]);
    expect(payload).toStrictEqual({ a: '1^2', b: 'x^y' });
  });
});

describe('isEtc', () => {
  it('Data Type=2(ETC) 만 true', () => {
    expect(isEtc(DATA_TYPE.ETC)).toBe(true);
    expect(isEtc(DATA_TYPE.CUTOFF)).toBe(false);
    expect(isEtc(DATA_TYPE.ALL)).toBe(false);
  });
});
