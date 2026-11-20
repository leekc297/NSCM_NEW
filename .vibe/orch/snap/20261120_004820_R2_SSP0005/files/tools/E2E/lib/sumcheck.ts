// 합계 행 값 판정(2026-11-01 엔진 갭 EG018) — 합계 칸 = 구성 행 합. 순수 함수 — sumcheck.selftest.js
export type J = { result: 'PASS' | 'FAIL' | 'NA'; why: string };

/** sums: 컬럼별 구성 행 합 · shown: 합계 칸 표시 값 · kind: 합계 위치 */
export function judgeSum(s: { kind: string; shown: Record<string, number | null>; sums: Record<string, number>; rows: number; tol?: number }): J {
  const cols = Object.keys(s.shown); const tol = s.tol ?? 0.01;
  if (!cols.length) return { result: 'NA', why: '합계 행·합계 칸 없음(AS-IS 합계 유무 대조는 A3 원장 행)' };
  const bad: string[] = []; let n = 0;
  for (const c of cols) { const v = s.shown[c]; if (v == null) continue; n++; const want = s.sums[c] ?? 0; if (Math.abs(v - want) > tol) bad.push(`${c} 합계 ${v} ≠ 구성 행 합 ${want}`); }
  if (!n) return { result: 'NA', why: `${s.kind} 있으나 숫자 합계 칸 없음` };
  return bad.length ? { result: 'FAIL', why: `${s.kind} ${bad.length}/${n}칸 불일치 — ${bad.slice(0, 4).join(' · ')} (${s.rows}행 기준)` } : { result: 'PASS', why: `${s.kind} ${n}칸 = 구성 ${s.rows}행 합` };
}
