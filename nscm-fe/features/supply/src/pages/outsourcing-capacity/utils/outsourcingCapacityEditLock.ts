// SCP0023 편집잠금 white-list + Daily Capacity 하한 보정 (design 03 §1/§3).
//   유일한 사용자 편집 셀 = DAILY_CAPA_QTY (그 외 DIVISION_ID~NICK_NAME·감사 4열·CAPA_ORDER·VALID_YN 잠금).
//   AS-IS 편집제어(SwitchLock 뷰/편집 토글)는 TO-BE 상시편집 + 셀 화이트리스트로 재현(NSCM 표준, tact-time 동일).

import { DAILY_CAPA_MAX, DAILY_CAPA_MIN } from '../outsourcing-capacity.constants';

// 편집 가능 셀 = DAILY_CAPA_QTY 단일 (design 03 §1 편집셀 / §3 #3·#4 lock). SHEET_COLUMNS COLUMN_NAME 은
//   대문자(2026-10-14 ora.py 실측 — PROGRAM_ID='SCP0023' 13행 전부 대문자. 05_register.sql 의 lowercase 가정은 오류).
export const EDITABLE_BINDING = 'DAILY_CAPA_QTY';

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

// Daily Capacity 하한/상한 보정 (design 03 §3 #6 / 07 §1.5) — 정수, 1 미만/비숫자면 DAILY_CAPA_MIN 강제.
//   AS-IS CheckDigitValueEntered(cs:453-461): float<1 또는 파싱실패 → SetValue(1) + MSG00085.
//   상한(DAILY_CAPA_MAX=8자리)은 AS-IS에 없는 TO-BE 보강 — distribution-route clampIntRange 선례처럼
//   알림 없이 조용히 clamp(reason='max'), 하한만 MSG00085 alert 대상(reason='min').
export const coerceDailyCapa = (
  value: unknown
): { value: number; coerced: boolean; reason: 'min' | 'max' | 'none' } => {
  const n = toNum(value);
  if (n === null) return { value: DAILY_CAPA_MIN, coerced: true, reason: 'min' };
  const intVal = Math.trunc(n);
  if (intVal < DAILY_CAPA_MIN) return { value: DAILY_CAPA_MIN, coerced: true, reason: 'min' };
  if (intVal > DAILY_CAPA_MAX) return { value: DAILY_CAPA_MAX, coerced: true, reason: 'max' };
  return { value: intVal, coerced: intVal !== n, reason: 'none' };
};
