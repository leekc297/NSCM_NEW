import { describe, expect, it } from 'vitest';

import { BUCKET_TYPE, EDIT_MEASURE, MSG } from '../sales-plan.constants';
import type { SalesPlanRow } from '../sales-plan.types';

import { bindingToSaveTag, buildUnfoldRows } from './sales-plan.save';

const buildMonthly = (row: Partial<SalesPlanRow>) =>
  buildUnfoldRows({
    insertedRows: [row as SalesPlanRow],
    editedChanges: new Map(),
    divisionId: typeof row.DIVISION_ID === 'string' ? row.DIVISION_ID : '',
    bucketType: BUCKET_TYPE.MONTHLY,
    msg: { catchupMinZero: MSG.CATCHUP_MIN_ZERO, lineNoChange: MSG.LINE_NO_CHANGE },
  });

describe('bindingToSaveTag', () => {
  it('keeps valid bucket bindings unchanged for the SAVE SP', () => {
    expect(bindingToSaveTag('M_202602')).toBe('M_202602');
    expect(bindingToSaveTag('W_20260101')).toBe('W_20260101');
    expect(bindingToSaveTag('D_20260721')).toBe('D_20260721');
    expect(bindingToSaveTag('SUM')).toBeNull();
  });
});

describe('monthly save — one M tag per cell (AS-IS SaveData / TO-BE SP: 태그당 1행, 월→주 분할 없음)', () => {
  it('keeps a Division 81 monthly value as a single M tag', () => {
    const result = buildMonthly({
      CRUD_TYPE: 'I',
      DIVISION_ID: '81',
      FCST_TYPE: 'RMA',
      MEASURE: EDIT_MEASURE.RTF_SYS_RP,
      M_202602: 100,
    });

    expect(result.error).toBeUndefined();
    expect(result.rows).toHaveLength(1);
    expect(result.rows[0]).toMatchObject({ yyyymmdd: 'M_202602', qty: '100' });
  });

  it('keeps a Division 82 SalesAmt_LOC monthly value as a single M tag', () => {
    const result = buildMonthly({
      CRUD_TYPE: 'I',
      DIVISION_ID: '82',
      FCST_TYPE: 'RMA',
      MEASURE: EDIT_MEASURE.SALES_AMT_LOC,
      M_202602: 1.001,
    });

    expect(result.rows).toHaveLength(1);
    expect(result.rows[0]).toMatchObject({ yyyymmdd: 'M_202602', qty: '1.001' });
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
