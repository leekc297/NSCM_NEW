import { describe, expect, it } from 'vitest';

import type { Tab1Row } from '../project-master.types';

import {
  isCellEditableTab1,
  isCellEditableTab2,
  isDisableToggleable,
  isDpjtCodeValid,
  isEditableInputTp,
  isModRow,
} from './project-master.editLock';

// ⭐ SDM5010 편집/버튼/체크 잠금 매트릭스 전수 (제약매트릭스 P-05~P-08/P-12 + 계약 ⑥):
//   TAB1 = INPUT_TP_CD 편집형(IM/IO/M/O) × '수정'(MOD) 행 D-PJT Code 잠금(F-9) /
//   TAB2 = 메타 IO 2컬럼(개발현황·비활성)만 / DISABLE_YN = CHECKED/UNCHECKED 만 토글 /
//   승인 D-PJT Code = 6자리 FE 선검증(D12 허위성공 방어).

const row = (over: Record<string, unknown> = {}): Tab1Row =>
  ({
    DPJT_KEY: 'PJT001_000001',
    DPJT_REG_CAT: 'NEW',
    DPJT_CODE: 'MC2501',
    ...over,
  }) as unknown as Tab1Row;

const modRow = () => row({ DPJT_REG_CAT: 'MOD' });

describe('isModRow — P-05 행 색상/P-06 잠금 공용 술어 (DPJT_REG_CAT=MOD 확정)', () => {
  it('MOD 행 = true / 그 외·undefined = false', () => {
    expect(isModRow(modRow())).toBe(true);
    expect(isModRow(row())).toBe(false);
    expect(isModRow(undefined)).toBe(false);
  });
});

describe('isEditableInputTp — INPUT_TP_CD 메타 단일 원천', () => {
  it('IM/IO/M/O = true, S/미지정 = false', () => {
    expect(isEditableInputTp('IM')).toBe(true);
    expect(isEditableInputTp('IO')).toBe(true);
    expect(isEditableInputTp('M')).toBe(true);
    expect(isEditableInputTp('O')).toBe(true);
    expect(isEditableInputTp('S')).toBe(false);
    expect(isEditableInputTp(undefined)).toBe(false);
  });
});

describe('isCellEditableTab1 — P-06/P-07 (수정 항목 11종 = 메타 IM/IO 축)', () => {
  it('편집형 컬럼 = 편집 가능 (행 상태 게이트 없음 — TAB1 은 전 행 승인 대상)', () => {
    expect(isCellEditableTab1('IM', 'DIVISION_ID', row())).toBe(true);
    expect(isCellEditableTab1('IO', 'NOTE', modRow())).toBe(true);
  });

  it("P-06: '수정'(MOD) 행 D-PJT Code = 편집 불가 (F-9 — '신규' 행만)", () => {
    expect(isCellEditableTab1('IO', 'DPJT_CODE', modRow())).toBe(false);
    expect(isCellEditableTab1('IO', 'DPJT_CODE', row())).toBe(true);
  });

  it("'S'/미지정 컬럼·행 없음 = 불가", () => {
    expect(isCellEditableTab1('S', 'DPJT_NAME', row())).toBe(false);
    expect(isCellEditableTab1(undefined, 'DPJT_NAME', row())).toBe(false);
    expect(isCellEditableTab1('IO', 'NOTE', undefined)).toBe(false);
  });
});

describe('isCellEditableTab2 — P-12 (개발현황/비활성 IO 2컬럼만)', () => {
  it('IO = 가능 / S·미지정 = 불가', () => {
    expect(isCellEditableTab2('IO')).toBe(true);
    expect(isCellEditableTab2('S')).toBe(false);
    expect(isCellEditableTab2(undefined)).toBe(false);
  });
});

describe('isDisableToggleable — 계약 ⑥ (서버 문자열 CHECKED/UNCHECKED 만)', () => {
  it('CHECKED/UNCHECKED = 토글 가능', () => {
    expect(isDisableToggleable('CHECKED')).toBe(true);
    expect(isDisableToggleable('UNCHECKED')).toBe(true);
  });

  it('그 외 값(빈 값/NULL/임의) = 잠금 — FE 재파생 금지 축', () => {
    expect(isDisableToggleable('')).toBe(false);
    expect(isDisableToggleable(null)).toBe(false);
    expect(isDisableToggleable('Y')).toBe(false);
  });
});

describe('isDpjtCodeValid — P-08 6자리 FE 선검증 (SP WHERE LENGTH=6 가드 D12 허위성공 방어)', () => {
  it('정확 6자리 = true (trim 후 판정)', () => {
    expect(isDpjtCodeValid('MC2501')).toBe(true);
    expect(isDpjtCodeValid(' MC2501 ')).toBe(true);
  });

  it('6자리 외 = false', () => {
    expect(isDpjtCodeValid('MC251')).toBe(false);
    expect(isDpjtCodeValid('MC25011')).toBe(false);
    expect(isDpjtCodeValid('')).toBe(false);
    expect(isDpjtCodeValid(null)).toBe(false);
  });
});
