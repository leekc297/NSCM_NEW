// 필터 유지 재조회 판정(2026-11-01 엔진 갭 EG383 · 공용 그리드 보존 필터). 순수 함수 — filterkeep.selftest.js
export type J = { result: 'PASS' | 'FAIL' | 'ERROR'; why: string };

/** n0 필터 전 · n1 필터 후 · n2 필터 유지 재조회 후 · n3 필터 해제 후 · label 재조회 후 건수 표시 */
export function judgeFilterKeep(s: { n0: number; n1: number; n2: number; n3: number; label: string; why: string }): J {
  if (s.why) return { result: 'ERROR', why: `[측정 경로 없음] ${s.why}` };
  if (s.n1 <= 0 || s.n1 >= s.n0) return { result: 'ERROR', why: `[측정 경로 없음] 필터가 행을 줄이지 못함 ${s.n0}→${s.n1}` };
  if (s.n2 !== s.n1) return { result: 'FAIL', why: `필터 ${s.n0}→${s.n1}행 뒤 재조회 ${s.n2}행 — 필터가 유지되지 않음` };
  const nums = (s.label.match(/[\d,]+/g) || []).map(x => Number(x.replace(/,/g, '')));
  if (s.label && !nums.includes(s.n2)) return { result: 'FAIL', why: `재조회 ${s.n2}행인데 건수 표시 '${s.label}'` };
  if (s.n3 !== s.n0) return { result: 'FAIL', why: `필터 해제 뒤 ${s.n3}행 — 전체 ${s.n0}행으로 복원 안 됨` };
  return { result: 'PASS', why: `필터 ${s.n0}→${s.n1}행 · 재조회 ${s.n2}행 유지${s.label ? ` · 건수 표시 '${s.label}'` : ' · 건수 표시 미발견'} · 해제 ${s.n3}행 복원` };
}
