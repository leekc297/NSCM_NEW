import { describe, expect, it } from 'vitest';

import {
  BIZ_TYPE_COMBO_ID,
  bizTypeComboFilterOf,
  isDiv40,
  isPlantSiteDisabled,
} from './sales-monitoring.combos';

// 콤보 파라미터는 홑따옴표로 감싸 나간다 (BE makeComboQuery raw 치환).
const quoted = (v: string): string => `'${v}'`;

describe('isDiv40', () => {
  it('40 만 true, 그 외 division 은 false', () => {
    expect(isDiv40('40')).toBe(true);
    expect(isDiv40(' 40 ')).toBe(true);
    expect(isDiv40('81')).toBe(false);
    expect(isDiv40('82')).toBe(false);
    expect(isDiv40('')).toBe(false);
    expect(isDiv40(undefined)).toBe(false);
  });
});

// AS-IS DMF0048 InitControls L338 sDivision=="40" 분기 1:1
describe('bizTypeComboFilterOf', () => {
  it('division 40 = 전역 BizType (divisionId 미전달)', () => {
    expect(bizTypeComboFilterOf('40')).toEqual({ comboId: BIZ_TYPE_COMBO_ID.D40 });
  });

  it('division 40 외 = BizTypeByDivision + divisionId 바인드', () => {
    expect(bizTypeComboFilterOf('81')).toEqual({
      comboId: BIZ_TYPE_COMBO_ID.BY_DIVISION,
      divisionId: quoted('81'),
    });
    expect(bizTypeComboFilterOf('82')).toEqual({
      comboId: BIZ_TYPE_COMBO_ID.BY_DIVISION,
      divisionId: quoted('82'),
    });
  });

  it('division 미선택 = BizTypeByDivision + ALL', () => {
    expect(bizTypeComboFilterOf('')).toEqual({
      comboId: BIZ_TYPE_COMBO_ID.BY_DIVISION,
      divisionId: quoted('ALL'),
    });
    expect(bizTypeComboFilterOf(undefined)).toEqual({
      comboId: BIZ_TYPE_COMBO_ID.BY_DIVISION,
      divisionId: quoted('ALL'),
    });
  });

  it('division 이 바뀌면 콤보 필터도 바뀐다 - react-query 키 재생성 근거', () => {
    expect(bizTypeComboFilterOf('40')).not.toEqual(bizTypeComboFilterOf('81'));
  });
});

// 이슈 2026-08-20 — 82 Div 에서 Plant Site 가 비활성. AS-IS 는 40 만 비활성.
describe('isPlantSiteDisabled', () => {
  it('40 만 비활성', () => {
    expect(isPlantSiteDisabled('40')).toBe(true);
  });

  it('81 계열과 82 는 활성', () => {
    expect(isPlantSiteDisabled('81')).toBe(false);
    expect(isPlantSiteDisabled('81_UC')).toBe(false);
    expect(isPlantSiteDisabled('81_JV')).toBe(false);
    expect(isPlantSiteDisabled('82')).toBe(false);
  });
});

// 2026-08-22 콤보 통일 — Plant Site 는 카탈로그 기본 'PlantSitebyEndCustomer' 를 쓴다.
//   화면이 comboId 를 넘기지 않으므로 상수 자체가 사라졌다.
