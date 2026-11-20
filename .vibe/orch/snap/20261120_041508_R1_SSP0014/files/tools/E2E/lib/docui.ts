// 문서가 조건별로 정한 버튼·컬럼 노출 판정(2026-11-02 엔진 갭 EG409·EG026 · 기준 Doc/verify/doc_ui_expect.csv). 순수 함수 — docui.selftest.js
export type J = { result: 'PASS' | 'FAIL' | 'ERROR'; why: string };

export function judgeDocUi(s: { kind: string; name: string; cond: string; applied: boolean; found: boolean; enabled: boolean; near?: string[]; why?: string }): J {
  if (s.why) return { result: 'ERROR', why: `[측정 경로 없음] ${s.why}` };
  if (!s.applied) return { result: 'ERROR', why: `[측정 경로 없음] 조건 '${s.cond}' 을 못 맞춤` };
  const what = `'${s.name}'(${s.cond})`;
  if (s.kind === 'btn_hidden' || s.kind === 'col_hidden') return s.found ? { result: 'FAIL', why: `${what} 숨겨야 하는데 보임` } : { result: 'PASS', why: `${what} 숨김` };
  if (s.kind === 'btn_shown' || s.kind === 'col_shown') return s.found ? { result: 'PASS', why: `${what} 보임` } : s.near && s.near.length ? { result: 'ERROR', why: `[확인 대상] ${what} 정확히 같은 칸은 없고 비슷한 칸 ${s.near.slice(0, 4).join(', ')}` } : { result: 'FAIL', why: `${what} 보여야 하는데 없음` };
  if (s.kind === 'btn_enabled') return !s.found ? { result: 'FAIL', why: `${what} 버튼 없음` } : s.enabled ? { result: 'PASS', why: `${what} 활성` } : { result: 'FAIL', why: `${what} 비활성` };
  return { result: 'ERROR', why: `[측정 경로 없음] 모르는 기대 종류 ${s.kind}` };
}
