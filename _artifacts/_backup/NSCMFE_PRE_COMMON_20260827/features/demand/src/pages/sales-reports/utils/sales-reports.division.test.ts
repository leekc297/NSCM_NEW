import { describe, expect, it } from 'vitest';

import { isDiv40, isDiv82 } from './sales-reports.division';

// TC-DMF0044 Division 시트(40/81/82) 분기 전제 — isDiv40/isDiv82 는 editLock·gridCombos 매트릭스의 입력값.
describe('isDiv40 / isDiv82', () => {
  it('40 = Mobility (편집 완화 대상)', () => {
    expect(isDiv40('40')).toBe(true);
    expect(isDiv82('40')).toBe(false);
  });

  it('82 = ESS (Textbox 노출 대상)', () => {
    expect(isDiv40('82')).toBe(false);
    expect(isDiv82('82')).toBe(true);
  });

  it('81 = 두 분기 모두 해당 없음 (제약매트릭스 §1 — 81 계열 분기 없음)', () => {
    expect(isDiv40('81')).toBe(false);
    expect(isDiv82('81')).toBe(false);
  });
});
