import { describe, expect, it } from 'vitest';

import {
  isPackerCellEditable,
  isPlantCellEditable,
  packerInsertDefaults,
} from './lineMasterEditLock';

// design 03_grid-columns §3.2 (lock 9건, cs:335~337/444/517/571~573) 의 편집가부를 검증 축으로 삼는다.
//   Plant 시트 = 조회 전용 전열 잠금(cs:444) / Packer 신규행('I') = SCM_SITE_ID+LINE_ID+LINE_NAME+VALID_YN+RACK_YN+SCS_PROD_AMEND /
//   Packer 기존행(편집) = LINE_NAME/VALID_YN/SCS_PROD_AMEND 만(키·OPERATION_ID·RACK_YN 재잠금 cs:335~337).

const newRow = (patch: WijmoRowItem = {}): WijmoRowItem => ({ CRUD_TYPE: 'I', ...patch });
const existingRow = (patch: WijmoRowItem = {}): WijmoRowItem => ({ ...patch });

describe('isPlantCellEditable — Plant 시트 전열 잠금 (design 03 §3.2 #16, cs:444)', () => {
  it('어떤 컬럼도 편집 불가 (조회 전용)', () => {
    expect(isPlantCellEditable()).toBe(false);
  });
});

describe('isPackerCellEditable — 신규행 화이트리스트 (design 03 §3.2)', () => {
  it('신규행은 SCM_SITE_ID/LINE_ID/LINE_NAME/VALID_YN/RACK_YN/SCS_PROD_AMEND 편집 가능', () => {
    for (const binding of [
      'SCM_SITE_ID',
      'LINE_ID',
      'LINE_NAME',
      'VALID_YN',
      'RACK_YN',
      'SCS_PROD_AMEND',
    ]) {
      expect(isPackerCellEditable(binding, newRow())).toBe(true);
    }
  });

  it('신규행이어도 DIVISION_ID/SITE_DESCRIPTION/OPERATION_ID 는 잠금 (파생·조회조건, cs:571~573)', () => {
    for (const binding of ['DIVISION_ID', 'SITE_DESCRIPTION', 'OPERATION_ID']) {
      expect(isPackerCellEditable(binding, newRow())).toBe(false);
    }
  });
});

describe('isPackerCellEditable — 기존행 화이트리스트 (design 03 §3.2, cs:335~337)', () => {
  it('기존행은 LINE_NAME/VALID_YN/SCS_PROD_AMEND 만 편집 가능', () => {
    for (const binding of ['LINE_NAME', 'VALID_YN', 'SCS_PROD_AMEND']) {
      expect(isPackerCellEditable(binding, existingRow())).toBe(true);
    }
  });

  it('기존행은 키·OPERATION_ID·RACK_YN 재잠금 (cs:335~337)', () => {
    for (const binding of ['SCM_SITE_ID', 'LINE_ID', 'OPERATION_ID', 'RACK_YN', 'DIVISION_ID']) {
      expect(isPackerCellEditable(binding, existingRow())).toBe(false);
    }
  });

  it('CRUD_TYPE 이 M 인 행도 기존행 규칙을 따른다', () => {
    expect(isPackerCellEditable('LINE_NAME', existingRow({ CRUD_TYPE: 'M' }))).toBe(true);
    expect(isPackerCellEditable('RACK_YN', existingRow({ CRUD_TYPE: 'M' }))).toBe(false);
  });

  it('row 가 없으면 기존행으로 취급 (신규 아님)', () => {
    expect(isPackerCellEditable('LINE_NAME', undefined)).toBe(true);
    expect(isPackerCellEditable('RACK_YN', undefined)).toBe(false);
  });
});

describe('packerInsertDefaults — 신규행 기본값 (design 03 §3.1 #1, cs:569)', () => {
  it('DIVISION_ID 는 조회 사업부, VALID_YN=Y / RACK_YN=N / SCS_PROD_AMEND=N', () => {
    const row = packerInsertDefaults('81');
    expect(row.DIVISION_ID).toBe('81');
    expect(row.VALID_YN).toBe('Y');
    expect(row.RACK_YN).toBe('N');
    expect(row.SCS_PROD_AMEND).toBe('N');
  });

  it('나머지 입력·파생 컬럼은 빈 값으로 시작한다 — 임의 폴백 금지', () => {
    const row = packerInsertDefaults('81');
    expect(row.SCM_SITE_ID).toBe('');
    expect(row.SITE_DESCRIPTION).toBe('');
    expect(row.LINE_ID).toBe('');
    expect(row.LINE_NAME).toBe('');
    expect(row.OPERATION_ID).toBe('');
  });
});
