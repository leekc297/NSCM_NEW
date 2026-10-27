// SCP0023 편집잠금 white-list + Daily Capacity 하한 보정 (design 03 §1/§3).
//   유일한 사용자 편집 셀 = daily_capa_qty (그 외 division~nick_name·감사 4열·capa_order·valid_yn 잠금).
//   AS-IS 편집제어(SwitchLock 뷰/편집 토글)는 TO-BE 상시편집 + 셀 화이트리스트로 재현(NSCM 표준, tact-time 동일).

import { DAILY_CAPA_MIN } from '../outsourcing-capacity.constants';

// 편집 가능 셀 = daily_capa_qty 단일 (design 03 §1 편집셀 / §3 #3·#4 lock). SHEET_COLUMNS 는 lowercase colNm.
export const EDITABLE_BINDING = 'daily_capa_qty';

// beginningEdit 화이트리스트 판정 — daily_capa_qty 만 편집 개방, 그 외 전부 잠금.
//   metadata INPUT_TP_CD 정비(05_register.sql daily_capa_qty='O')와 별개로, 셀 잠금을 코드에서도
//   결정적으로 보장한다(design 03 §1.1 함정 방어 — 'S' 잔존 시에도 편집 개방 / 다른 셀 오개방 차단).
export const isCellEditable = (binding: string): boolean => binding === EDITABLE_BINDING;

const toNum = (v: unknown): number | null => {
  if (typeof v === 'number') return Number.isFinite(v) ? v : null;
  if (typeof v === 'string' && v.trim() !== '') {
    const n = Number(v);
    return Number.isFinite(n) ? n : null;
  }
  return null;
};

// Daily Capacity 하한 보정 (design 03 §3 #6 / 07 §1.5) — 정수, 1 미만/비숫자면 DAILY_CAPA_MIN 강제.
//   AS-IS CheckDigitValueEntered(cs:453-461): float<1 또는 파싱실패 → SetValue(1) + MSG00085.
export const coerceDailyCapa = (value: unknown): { value: number; coerced: boolean } => {
  const n = toNum(value);
  if (n === null) return { value: DAILY_CAPA_MIN, coerced: true };
  const intVal = Math.trunc(n);
  if (intVal < DAILY_CAPA_MIN) return { value: DAILY_CAPA_MIN, coerced: true };
  return { value: intVal, coerced: intVal !== n };
};
