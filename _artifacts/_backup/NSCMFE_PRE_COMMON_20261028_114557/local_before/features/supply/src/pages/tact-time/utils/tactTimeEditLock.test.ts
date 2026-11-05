import { describe, expect, it } from 'vitest';

import { TACT_MODE } from '../tact-time.constants';

import {
  exceptInsertDefaults,
  isExceptCellEditable,
  isPackerCellEditable,
  isPlantCellEditable,
  packerInsertDefaults,
  plantInsertDefaults,
} from './tactTimeEditLock';

describe('tactTimeEditLock — Plant', () => {
  const base = {
    DIVISION_ID: '81',
    INPUT_STATUS: 'I',
    MODEL_SITE: 'M1',
    OPERATION_GROUP_ID: 'E',
  };

  it('key/audit columns never editable', () => {
    expect(isPlantCellEditable('DIVISION_ID', base)).toBe(false);
    expect(isPlantCellEditable('CREATED_BY', base)).toBe(false);
  });

  it('PRIORITY editable in normal case', () => {
    expect(isPlantCellEditable('PRIORITY', base)).toBe(true);
  });

  it('LINE_ID editable only on new rows', () => {
    // 신규행(INPUT_STATUS='I' 또는 CRUD_TYPE='I') 만 편집
    expect(isPlantCellEditable('LINE_ID', base)).toBe(true); // base INPUT_STATUS='I'
    expect(isPlantCellEditable('LINE_ID', { ...base, INPUT_STATUS: '', CRUD_TYPE: 'I' })).toBe(true);
    // 기존행(조회건) — INPUT_STATUS 가 'M' 이든 공백이든 잠금
    expect(isPlantCellEditable('LINE_ID', { ...base, INPUT_STATUS: 'M' })).toBe(false);
    expect(isPlantCellEditable('LINE_ID', { ...base, INPUT_STATUS: '' })).toBe(false);
  });

  it('MODEL_SITE blank locks LINE_ID~LANE_QTY', () => {
    const blank = { ...base, MODEL_SITE: '' };
    expect(isPlantCellEditable('PRIORITY', blank)).toBe(false);
    expect(isPlantCellEditable('LANE_QTY', blank)).toBe(false);
  });

  it('OPERATION_GROUP != E locks LANE_QTY', () => {
    expect(isPlantCellEditable('LANE_QTY', { ...base, OPERATION_GROUP_ID: 'N' })).toBe(false);
    expect(isPlantCellEditable('LANE_QTY', base)).toBe(true);
  });

  it('division 42/44 locks TACT_TIME/ITEM_UOM', () => {
    expect(isPlantCellEditable('TACT_TIME', { ...base, DIVISION_ID: '42' })).toBe(false);
    expect(isPlantCellEditable('ITEM_UOM', { ...base, DIVISION_ID: '44' })).toBe(false);
  });
});

describe('tactTimeEditLock — Packer', () => {
  it('OSP_YN != Y locks whole row', () => {
    expect(isPackerCellEditable('PRIORITY', { OSP_YN: 'N', INPUT_STATUS: 'I' })).toBe(false);
  });
  it('editable base with OSP_YN=Y', () => {
    expect(isPackerCellEditable('DAILY_CAPACITY', { OSP_YN: 'Y', INPUT_STATUS: 'I' })).toBe(true);
    expect(isPackerCellEditable('LINE_ID', { OSP_YN: 'Y', INPUT_STATUS: 'I' })).toBe(true);
  });
  it('LINE_ID editable only on new rows', () => {
    // 신규행만 편집
    expect(isPackerCellEditable('LINE_ID', { OSP_YN: 'Y', INPUT_STATUS: 'I' })).toBe(true);
    expect(isPackerCellEditable('LINE_ID', { OSP_YN: 'Y', INPUT_STATUS: '', CRUD_TYPE: 'I' })).toBe(
      true
    );
    // 기존행(조회건) — 'M' 이든 공백이든 잠금
    expect(isPackerCellEditable('LINE_ID', { OSP_YN: 'Y', INPUT_STATUS: 'M' })).toBe(false);
    expect(isPackerCellEditable('LINE_ID', { OSP_YN: 'Y', INPUT_STATUS: '' })).toBe(false);
  });
});

describe('tactTimeEditLock — Except', () => {
  it('Plant parent locks DAILY_CAPACITY', () => {
    expect(isExceptCellEditable('DAILY_CAPACITY', TACT_MODE.PLANT)).toBe(false);
    expect(isExceptCellEditable('TACT_TIME', TACT_MODE.PLANT)).toBe(true);
  });
  it('Packer parent locks TACT_TIME', () => {
    expect(isExceptCellEditable('TACT_TIME', TACT_MODE.PACKER)).toBe(false);
    expect(isExceptCellEditable('DAILY_CAPACITY', TACT_MODE.PACKER)).toBe(true);
  });
});

describe('tactTimeEditLock — Insert defaults', () => {
  const src = {
    DIVISION_ID: '81',
    PLANT_SITE_ID: 'P1',
    ITEM_ID: 'I1',
    OPERATION_ID: 'O1',
    NICK_NAME: 'N1',
  };
  it('plant defaults set VALID_YN=Y + INPUT_STATUS=I', () => {
    const d = plantInsertDefaults(src);
    expect(d.VALID_YN).toBe('Y');
    expect(d.INPUT_STATUS).toBe('I');
    expect(d.DIVISION_ID).toBe('81');
  });
  it('packer defaults set OSP_YN=Y / EXCEPT_YN=N / INPUT_STATUS=I', () => {
    const d = packerInsertDefaults(src);
    expect(d.OSP_YN).toBe('Y');
    expect(d.EXCEPT_YN).toBe('N');
    expect(d.INPUT_STATUS).toBe('I');
  });
  it('except defaults set USE_YN=Y + ORG snapshot', () => {
    const d = exceptInsertDefaults(src);
    expect(d.USE_YN).toBe('Y');
    expect(d.ORG_DIVISION_ID).toBe('81');
  });
});
