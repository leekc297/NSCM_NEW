// 상위 셀 변경 → 하위 셀 값 초기화 판정(2026-11-01 엔진 갭 EG085). 순수 함수 — cellclear.selftest.js
export type J = { result: 'PASS' | 'FAIL' | 'ERROR'; why: string };

/** before 원천 변경 전 대상 값 · after 변경 뒤 대상 값 · cond AS-IS 초기화가 조건부(조건 식은 평가하지 않음) · refilled AS-IS 가 같은 분기에서 대상을 다시 채움 */
export function judgeCellClear(s: { src: string; tgt: string; v1: string; v2: string; before: string; after: string; cond: string; refilled: boolean; why: string }): J {
  const ctx = `${s.src} '${s.v1}'→'${s.v2}' · ${s.tgt} '${s.before}'→'${s.after}'`;
  if (s.why) return { result: 'ERROR', why: `[측정 경로 없음] ${s.why}` };
  if (!s.before.trim()) return { result: 'ERROR', why: `[측정 경로 없음] 변경 전 대상 값이 비어 초기화 여부를 알 수 없음 · ${ctx}` };
  if (s.v1 === s.v2) return { result: 'ERROR', why: `[측정 경로 없음] 원천 값이 바뀌지 않음 · ${ctx}` };
  if (!s.after.trim()) return { result: 'PASS', why: `초기화됨 · ${ctx}` };
  if (s.after !== s.before) return s.refilled ? { result: 'PASS', why: `새 값으로 교체됨(AS-IS 도 같은 분기에서 다시 채움) · ${ctx}` } : { result: 'ERROR', why: `[확인 대상] AS-IS 는 비우는데 다른 값으로 바뀜 · ${ctx}` };
  if (s.cond) return { result: 'ERROR', why: `[확인 대상] 값 유지 — AS-IS 초기화가 조건부이고 조건 평가 안 함(${s.cond.slice(0, 120)}) · ${ctx}` };
  return { result: 'FAIL', why: `상위 값을 바꿔도 하위 값 유지 — AS-IS 는 비움 · ${ctx}` };
}

/** 상위 조회조건 변경 → AS-IS 가 비우는 하위 조건(VALUE_CLEAR · EG084). stale = 값이 그대로 남은 하위 이름 */
export function staleKids(kids: { name: string; before: string; after: string; asisClears: boolean }[]): string[] {
  const blank = (v: string) => !String(v || '').replace(/[\u200b\u00a0]/g, '').trim(); const isAll = (v: string) => /^(all|전체)$/i.test(v.trim());
  return kids.filter(k => k.asisClears && !blank(k.before) && !isAll(k.before) && k.after === k.before).map(k => k.name);
}

/** 재조회 뒤 하위 그리드 — before 재조회 전 행수 · after 재조회 뒤 행수 · autoLoad 재조회 뒤 하위 요청 건수(EG019) */
export function judgeSubClear(s: { before: number[]; after: number[]; autoLoad: number; why?: string }): J {
  if (s.why) return { result: 'ERROR', why: `[측정 경로 없음] ${s.why}` };
  if (!s.before.some(n => n > 0)) return { result: 'ERROR', why: `[측정 경로 없음] 재조회 전 하위 행 0(${s.before.join('/')}) — 초기화를 관찰할 수 없음` };
  if (s.after.every(n => n <= 0)) return { result: 'PASS', why: `하위 행 ${s.before.join('/')}→${s.after.join('/')}` };
  if (s.autoLoad > 0) return { result: 'PASS', why: `하위 행 ${s.before.join('/')}→${s.after.join('/')} · 재조회 뒤 하위 요청 ${s.autoLoad}건(자동 재조회)` };
  return { result: 'FAIL', why: `재조회 뒤 하위 행 남음 ${s.before.join('/')}→${s.after.join('/')} · 하위 요청 0건` };
}
