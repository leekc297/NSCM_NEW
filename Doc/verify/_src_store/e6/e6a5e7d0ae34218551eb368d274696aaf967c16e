// 개인화 색 선택 팔레트/hex 유틸 (ColorPickerButton 전용).

// 테마 색 기준 행 (Office 유사 10색) — 각 열마다 명도(tint/shade) 변형을 생성한다.
export const THEME_COLORS: string[] = [
  '#FFFFFF',
  '#000000',
  '#E7E6E6',
  '#44546A',
  '#4472C4',
  '#ED7D31',
  '#A5A5A5',
  '#FFC000',
  '#5B9BD5',
  '#70AD47',
];

// 표준 색 (엑셀 "표준 색" 행).
export const STANDARD_COLORS: string[] = [
  '#C00000',
  '#FF0000',
  '#FFC000',
  '#FFFF00',
  '#92D050',
  '#00B050',
  '#00B0F0',
  '#0070C0',
  '#002060',
  '#7030A0',
];

// 테마색 그리드 명도 레벨. 0 = 기준행, +값 = tint(밝게), -값 = shade(어둡게).
export const VARIANT_LEVELS: number[] = [0, 0.8, 0.6, 0.4, -0.25, -0.5];

const HEX_RE = /^#([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$/;

export const isValidHex = (s: string): boolean => HEX_RE.test(s.trim());

export const normalizeHex = (s: string): string => {
  const t = s.trim();
  if (!isValidHex(t)) return '';
  const hex = t.slice(1);
  const full =
    hex.length === 3
      ? hex
          .split('')
          .map(c => c + c)
          .join('')
      : hex;
  return `#${full.toUpperCase()}`;
};

export interface Rgb {
  r: number;
  g: number;
  b: number;
}

export const hexToRgb = (hex: string): Rgb => {
  const h = (normalizeHex(hex) || '#000000').slice(1);
  return {
    r: parseInt(h.slice(0, 2), 16),
    g: parseInt(h.slice(2, 4), 16),
    b: parseInt(h.slice(4, 6), 16),
  };
};

const toHex2 = (v: number): string =>
  Math.max(0, Math.min(255, Math.round(v)))
    .toString(16)
    .padStart(2, '0');

export const rgbToHex = (r: number, g: number, b: number): string =>
  `#${toHex2(r)}${toHex2(g)}${toHex2(b)}`.toUpperCase();

// 흰색과 factor(0..1) 비율로 섞어 밝게.
export const tint = (hex: string, factor: number): string => {
  const { r, g, b } = hexToRgb(hex);
  return rgbToHex(r + (255 - r) * factor, g + (255 - g) * factor, b + (255 - b) * factor);
};

// 검정과 factor(0..1) 비율로 섞어 어둡게.
export const shade = (hex: string, factor: number): string => {
  const { r, g, b } = hexToRgb(hex);
  return rgbToHex(r * (1 - factor), g * (1 - factor), b * (1 - factor));
};

export const applyLevel = (hex: string, level: number): string => {
  if (level > 0) return tint(hex, level);
  if (level < 0) return shade(hex, -level);
  const { r, g, b } = hexToRgb(hex);
  return rgbToHex(r, g, b);
};

// 테마색 그리드 (행 = 명도 레벨, 열 = 기준색).
export const buildThemeGrid = (): string[][] =>
  VARIANT_LEVELS.map(level => THEME_COLORS.map(base => applyLevel(base, level)));
