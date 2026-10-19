import { describe, expect, it } from 'vitest';

import { PACKER_COLUMNS } from '../line-master.constants';

import { packerInsertDefaults } from './lineMasterEditLock';

// 셀 편집 가부는 SCM_MST_SHEET_COLUMNS.INPUT_TP_CD 메타(및 미로드 시 폴백 PACKER_COLUMNS.inputTp)로 판정한다 —
//   공통 DataGrid isEditableCell 가 beginningEdit·pastingCell 을 가드(코드측 화이트리스트 없음).
//   아래는 AS-IS SCP0002_LineMaster.cs 편집규칙의 메타 등가를 폴백 상수로 고정 검증한다:
//     신규행 Insert_Row(538): DIVISION_ID/SITE_DESCRIPTION/OPERATION_ID 잠금 → 나머지 편집.
//     기존행 EditButton(320): DIVISION_ID~LINE_ID/OPERATION_ID/RACK_YN 잠금 → LINE_NAME/VALID_YN/SCS_PROD_AMEND 편집.
describe('PACKER_COLUMNS inputTp — AS-IS 편집규칙의 메타(INPUT_TP_CD) 등가', () => {
  const tp = (key: string) => PACKER_COLUMNS.find(c => c.key === key)?.inputTp;

  it('신규행만 편집(IM, 필수): SCM_SITE_ID / LINE_ID / RACK_YN', () => {
    expect(tp('SCM_SITE_ID')).toBe('IM');
    expect(tp('LINE_ID')).toBe('IM');
    expect(tp('RACK_YN')).toBe('IM');
  });

  it('상시 편집(M, 필수): LINE_NAME / VALID_YN', () => {
    expect(tp('LINE_NAME')).toBe('M');
    expect(tp('VALID_YN')).toBe('M');
  });

  it('상시 편집(O, 선택): SCS_PROD_AMEND', () => {
    expect(tp('SCS_PROD_AMEND')).toBe('O');
  });

  it('조회전용(S, 파생·키·잠금): DIVISION_ID / SITE_DESCRIPTION / OPERATION_ID', () => {
    expect(tp('DIVISION_ID')).toBe('S');
    expect(tp('SITE_DESCRIPTION')).toBe('S');
    expect(tp('OPERATION_ID')).toBe('S');
  });
});

describe('packerInsertDefaults — 신규행 기본값 (design 03 §3.1 #1, cs:565~567)', () => {
  it('AS-IS Insert_Row 가 설정하는 값만 채운다: DIVISION_ID=조회 사업부 / VALID_YN=Y / RACK_YN=N', () => {
    const row = packerInsertDefaults('81');
    expect(row.DIVISION_ID).toBe('81');
    expect(row.VALID_YN).toBe('Y');
    expect(row.RACK_YN).toBe('N');
  });

  it('AS-IS 미설정 컬럼(SCS_PROD_AMEND 포함)은 blank 로 시작한다 — 임의 선채움 금지', () => {
    const row = packerInsertDefaults('81');
    expect(row.SCM_SITE_ID).toBe('');
    expect(row.SITE_DESCRIPTION).toBe('');
    expect(row.LINE_ID).toBe('');
    expect(row.LINE_NAME).toBe('');
    expect(row.OPERATION_ID).toBe('');
    // AS-IS Insert_Row defaultData 에 SCS_PROD_AMEND 없음 → blank(저장 후 GET NVL 로 'N' 표시).
    expect(row.SCS_PROD_AMEND).toBe('');
  });
});
