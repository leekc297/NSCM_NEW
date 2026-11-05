// 셀 편집 표시·값 유지 판정(2026-11-02 엔진 갭 EG012·EG227). 순수 함수 — celledit.selftest.js
export type J = { result: 'PASS' | 'FAIL' | 'ERROR'; why: string };

/** 콤보 셀 편집기 — samples: 값(코드)·표시값·편집기 입력값. 코드와 표시값이 다른 칸만 판정 재료 */
export function judgeEditorText(samples: { b: string; raw: string; disp: string; editor: string | null }[]): J {
  const use = samples.filter(s => s.editor != null && s.raw && s.disp && s.raw !== s.disp);
  if (!use.length) return { result: 'ERROR', why: `[측정 경로 없음] 코드·표시값이 다른 편집 가능 콤보 칸 없음(시도 ${samples.length})` };
  const bad = use.filter(s => s.editor === s.raw);
  if (bad.length) return { result: 'FAIL', why: `편집기에 코드 노출 ${bad.length}/${use.length}: ${bad.slice(0, 4).map(s => `${s.b} '${s.raw}'(표시 '${s.disp}')`).join(', ')}` };
  return { result: 'PASS', why: `편집기 표시 ${use.length}칸 코드 비노출: ${use.slice(0, 4).map(s => `${s.b} '${s.editor}'`).join(', ')}` };
}

/** 수량 입력 뒤 다른 셀 편집 — typed 넣은 값 · after 다른 셀 편집 뒤 값 · other 편집한 칸 */
export function judgeKeepQty(s: { qty: string; typed: string; before: string; after: string; other: string; why?: string }): J {
  if (s.why) return { result: 'ERROR', why: `[측정 경로 없음] ${s.why}` };
  const n = (v: string) => { const x = Number(String(v).replace(/,/g, '')); return Number.isNaN(x) ? v : x; };
  if (n(s.before) !== n(s.typed)) return { result: 'ERROR', why: `[측정 경로 없음] ${s.qty} 입력이 반영 안 됨 '${s.typed}'→'${s.before}'` };
  if (n(s.after) !== n(s.typed)) return { result: 'FAIL', why: `${s.other} 편집 뒤 ${s.qty} 값 바뀜 '${s.before}'→'${s.after}'` };
  return { result: 'PASS', why: `${s.other} 편집 뒤 ${s.qty} '${s.after}' 유지` };
}

/** 월 Bucket 입력 → Daily 합계 보존(EG187). 월 안 일자 칸이 일부만 보이면 합계를 알 수 없다 */
export function judgeMonthSum(s: { month: string; want: number; days: { d: string; v: number }[]; daysInMonth: number; why?: string }): J {
  if (s.why) return { result: 'ERROR', why: `[측정 경로 없음] ${s.why}` };
  if (s.days.length < s.daysInMonth) return { result: 'ERROR', why: `[측정 경로 없음] ${s.month} 일자 칸 ${s.days.length}/${s.daysInMonth} 만 있어 합계 판정 불가` };
  const sum = s.days.reduce((a, x) => a + x.v, 0); const nz = s.days.filter(x => x.v !== 0).map(x => `${x.d.slice(6)}=${x.v}`).slice(0, 8).join(' ');
  return Math.abs(sum - s.want) < 0.001 ? { result: 'PASS', why: `${s.month} 입력 ${s.want} = 일자 합계 ${sum}(${nz})` } : { result: 'FAIL', why: `${s.month} 입력 ${s.want} ≠ 일자 합계 ${sum}(${nz})` };
}
