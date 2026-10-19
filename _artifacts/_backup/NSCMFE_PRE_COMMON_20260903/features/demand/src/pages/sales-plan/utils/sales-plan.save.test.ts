import { describe, expect, it } from 'vitest';

import { BUCKET_TYPE, EDIT_MEASURE } from '../sales-plan.constants';
import type { SalesPlanRow } from '../sales-plan.types';

import { bindingToSaveTag, buildUnfoldRows } from './sales-plan.save';

const buildMonthly = (row: Partial<SalesPlanRow>) =>
  buildUnfoldRows({
    insertedRows: [row as SalesPlanRow],
    editedChanges: new Map(),
    divisionId: typeof row.DIVISION_ID === 'string' ? row.DIVISION_ID : '',
    bucketType: BUCKET_TYPE.MONTHLY,
    msg: { catchupMinZero: 'MSG00085', lineNoChange: 'MSG00146' },
  });

describe('bindingToSaveTag', () => {
  it('keeps valid bucket bindings unchanged for the SAVE SP', () => {
    expect(bindingToSaveTag('M_202602')).toBe('M_202602');
    expect(bindingToSaveTag('W_20260101')).toBe('W_20260101');
    expect(bindingToSaveTag('D_20260721')).toBe('D_20260721');
    expect(bindingToSaveTag('SUM')).toBeNull();
  });
});

describe('monthly save distribution', () => {
  it('splits a monthly quantity into week tags and preserves the total', () => {
    const result = buildMonthly({
      CRUD_TYPE: 'I',
      DIVISION_ID: '81',
      FCST_TYPE: 'RMA',
      MEASURE: EDIT_MEASURE.RTF_SYS_RP,
      M_202602: 100,
    });

    expect(result.error).toBeUndefined();
    expect(result.rows.map(row => row.yyyymmdd)).toEqual([
      'W_20260205',
      'W_20260206',
      'W_20260207',
      'W_20260208',
      'W_20260209',
    ]);
    expect(result.rows.reduce((sum, row) => sum + Number(row.qty), 0)).toBe(100);
  });

  it('preserves SalesAmt_LOC totals at the 0.001 unit', () => {
    const result = buildMonthly({
      CRUD_TYPE: 'I',
      DIVISION_ID: '81',
      FCST_TYPE: 'RMA',
      MEASURE: EDIT_MEASURE.SALES_AMT_LOC,
      M_202602: 1.001,
    });

    expect(result.rows.reduce((sum, row) => sum + Number(row.qty), 0)).toBeCloseTo(1.001, 3);
  });

  it('keeps Division 40 ETC monthly values as one M tag', () => {
    const result = buildMonthly({
      CRUD_TYPE: 'I',
      DIVISION_ID: '40',
      FCST_TYPE: 'ETC',
      MEASURE: EDIT_MEASURE.SALES_AMT_LOC,
      M_202602: 123.456,
    });

    expect(result.rows).toHaveLength(1);
    expect(result.rows[0]).toMatchObject({ yyyymmdd: 'M_202602', qty: '123.456' });
  });
});
