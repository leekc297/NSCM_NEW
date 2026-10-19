import { describe, expect, it } from 'vitest';

import { isDiv40, isPlantSiteDisabled } from './sales-monitoring.combos';

// [E20260901-COMMONSYNC] 공통소스 8f0b2a60 "salesplan 미사용 콤보 제거" 가 BIZ_TYPE_COMBO_ID /
//   bizTypeComboFilterOf export 를 제거했는데 자기 test 는 미정합(공통 HEAD 컴파일 불가 계보 — 3번째).
//   해당 describe 를 소스와 정합 삭제 — 잔여 유틸 2종 검증은 유지.

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
