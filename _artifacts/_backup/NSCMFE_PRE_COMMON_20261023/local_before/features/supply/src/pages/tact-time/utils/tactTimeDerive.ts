// SCP0020 파생 Auto-Sync 산식 (design 03 §3.3 — cs:2639/2680/2717 등).
//   순수 함수로 분리해 단위 테스트로 산식을 검증한다(그리드 핸들러가 이 함수를 호출).

import { MIN_TACT_TIME } from '../tact-time.constants';

// 숫자 파싱 — 공백/빈값/파싱실패 = null.
export const toNum = (v: unknown): number | null => {
  if (v === undefined || v === null || v === '') return null;
  const n = typeof v === 'number' ? v : typeof v === 'string' ? Number(v.replace(/,/g, '')) : NaN;
  return Number.isFinite(n) ? n : null;
};

// 소수 5자리 반올림 (AS-IS round(x, 5)).
export const round5 = (n: number): number => Math.round(n * 1e5) / 1e5;

// 전극(E) JUMBO_MIN 파생 — 공백이면 0, else round5(TACT_TIME * LANE_QTY * 60) (design 03 §3.3 #69/70).
export const deriveJumboMin = (tactTime: unknown, laneQty: unknown): number => {
  const t = toNum(tactTime);
  const l = toNum(laneQty);
  if (t === null || l === null) return 0;
  return round5(t * l * 60);
};

// TACT_TIME 파생 — DAILY_CAPACITY 변경 시 공백이면 0, else round5(86400 / DAILY_CAPACITY)
//   (design 03 §3.3 #71~74, Except/Packer 공용).
export const deriveTactTimeFromDaily = (dailyCapacity: unknown): number => {
  const d = toNum(dailyCapacity);
  if (d === null || d === 0) return 0;
  return round5(86400 / d);
};

// TACT_TIME 셀입력 clamp — [MIN_TACT_TIME, max] 벗어나면 MIN_TACT_TIME 으로 보정 (design 03 §3.3 #76/77).
//   AS-IS: nVal>max or nVal<0.01 or 파싱실패 -> nMinTactTime + MSG00203.
export const clampTactTime = (value: unknown, max: number): { value: number; clamped: boolean } => {
  const n = toNum(value);
  if (n === null || n > max || n < MIN_TACT_TIME) {
    return { value: MIN_TACT_TIME, clamped: true };
  }
  return { value: n, clamped: false };
};
