import dayjs from '@foundation/dayjs';
import type { ComboResponse } from '@foundation/models';

export interface ComboOption {
  label: string;
  value: string;
}

/** 콤보 응답 → {label,value}. CODE/NAME 별칭 규약(dev-manual 04). */
export const toComboOptions = (rows: ComboResponse[] | undefined): ComboOption[] =>
  (rows ?? []).map(r => ({ label: String(r.NAME ?? r.CODE ?? ''), value: String(r.CODE ?? '') }));

/**
 * Division 옵션 재정렬(02 §2 #1 — AS-IS 클라 후처리 cs:275-297): 81→1, 40→2, 기타→3 순.
 * SQL ORDER BY(ATTRIBUTE1)에 맡기지 않고 화면이 덮어쓴다 — 첫 항목(=기본선택)이 AS-IS 와 동일.
 */
export const sortDivisionOptions = (rows: ComboResponse[] | undefined): ComboOption[] => {
  const rank = (code: string): number => (code === '81' ? 1 : code === '40' ? 2 : 3);
  return toComboOptions(rows).sort((a, b) => rank(a.value) - rank(b.value));
};

/**
 * Period 월 옵션(YYYYMM) — floor(당월 또는 from 중 이른 달) ~ max(상한 당월+3년5개월). 라벨 = YYYY-MM.
 * 순수 정수 산술(dayjs customParseFormat 미의존).
 */
export const monthOptions = (fromYyyymm: string, maxYyyymm: string): ComboOption[] => {
  const toIndex = (yyyymm: string): number => {
    const y = Number(yyyymm.slice(0, 4));
    const m = Number(yyyymm.slice(4, 6));
    return y * 12 + (m - 1);
  };
  const nowIdx = (() => {
    const now = dayjs();
    return now.year() * 12 + now.month();
  })();
  const fromIdx = /^\d{6}$/.test(fromYyyymm) ? toIndex(fromYyyymm) : nowIdx;
  const maxIdx = /^\d{6}$/.test(maxYyyymm) ? toIndex(maxYyyymm) : nowIdx + 41;
  const floor = Math.min(nowIdx, fromIdx);
  const opts: ComboOption[] = [];
  for (let i = floor; i <= maxIdx && opts.length < 600; i++) {
    const y = Math.floor(i / 12);
    const m = (i % 12) + 1;
    const mm = String(m).padStart(2, '0');
    opts.push({ label: `${y}-${mm}`, value: `${y}${mm}` });
  }
  return opts;
};
