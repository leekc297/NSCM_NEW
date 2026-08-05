import { describe, expect, it } from 'vitest';

import {
  buildThemeGrid,
  hexToRgb,
  isValidHex,
  normalizeHex,
  rgbToHex,
  shade,
  STANDARD_COLORS,
  THEME_COLORS,
  tint,
  VARIANT_LEVELS,
} from './colorUtils';

describe('colorUtils', () => {
  it('THEME_COLORS / STANDARD_COLORS 는 유효한 hex 들만 포함한다', () => {
    expect(THEME_COLORS.length).toBeGreaterThan(0);
    [...THEME_COLORS, ...STANDARD_COLORS].forEach(c => expect(isValidHex(c)).toBe(true));
  });

  it('isValidHex 는 3/6자리 hex 를 허용하고 그 외는 거부한다', () => {
    expect(isValidHex('#fff')).toBe(true);
    expect(isValidHex('#FFAA00')).toBe(true);
    expect(isValidHex('  #abc  ')).toBe(true);
    expect(isValidHex('fff')).toBe(false);
    expect(isValidHex('#gg0000')).toBe(false);
    expect(isValidHex('')).toBe(false);
  });

  it('normalizeHex 는 3자리를 6자리 대문자로 확장하고, 무효값은 빈문자열', () => {
    expect(normalizeHex('#abc')).toBe('#AABBCC');
    expect(normalizeHex('#ffaa00')).toBe('#FFAA00');
    expect(normalizeHex('nope')).toBe('');
  });

  it('hexToRgb / rgbToHex 왕복 변환', () => {
    expect(hexToRgb('#FFFFFF')).toEqual({ r: 255, g: 255, b: 255 });
    expect(hexToRgb('#000000')).toEqual({ r: 0, g: 0, b: 0 });
    expect(rgbToHex(255, 255, 255)).toBe('#FFFFFF');
    expect(rgbToHex(0, 128, 255)).toBe('#0080FF');
  });

  it('tint 는 흰색 쪽으로, shade 는 검정 쪽으로 이동한다', () => {
    expect(tint('#000000', 1)).toBe('#FFFFFF');
    expect(tint('#FF0000', 0.5)).toBe('#FF8080');
    expect(shade('#FFFFFF', 1)).toBe('#000000');
    expect(shade('#FFFFFF', 0.5)).toBe('#808080');
  });

  it('buildThemeGrid 는 (레벨 수 x 기준색 수) 그리드를 만든다', () => {
    const grid = buildThemeGrid();
    expect(grid).toHaveLength(VARIANT_LEVELS.length);
    grid.forEach(row => expect(row).toHaveLength(THEME_COLORS.length));
    // 레벨 0 행은 기준색 그대로(대문자 정규화)
    expect(grid[0]).toEqual(THEME_COLORS.map(c => normalizeHex(c)));
  });
});
