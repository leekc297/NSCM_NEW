import { describe, expect, it } from 'vitest';

import { isDiv40, isPlantSiteDisabled } from './sales-monitoring.combos';

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

// Biz Type 은 2026-08-22 콤보 통일로 division 별 원천 스왑(bizTypeComboFilterOf /
//   BIZ_TYPE_COMBO_ID)이 폐지됐다. FilterBizType(#3) 하나가 두 갈래를 UNION 으로 내려주므로
//   화면이 DIVISION_ID 축으로만 좁힌다 - 판정 함수 자체가 없어 여기서 검증할 대상도 없다.

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
