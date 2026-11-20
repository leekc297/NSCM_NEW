// 없어야 할 공통 버튼 판정(2026-11-02 엔진 갭 EG410). 순수 함수 — extrabtn.selftest.js
const FUNCS = ['Insert', 'Delete', 'Save', 'Edit'];

/** visible 보이는 버튼 · want AS-IS 버튼(대조표) · excluded 확정 규칙으로 뺀 버튼 → AS-IS 에 없는데 보이는 기능 버튼 */
export function extraButtons(visible: string[], want: string[], excluded: string[]): string[] {
  const has = (list: string[], b: string) => list.some(v => new RegExp(`^${b}(\\s*\\(F\\d+\\))?$`, 'i').test(v.trim()));
  return FUNCS.filter(b => has(visible, b) && !has(want, b) && !has(excluded, b));
}

/** 화면 전용 버튼 클릭 결과 — 쓰기 요청은 시험이 전부 막는다. writes 확인 없이 나간 쓰기 · dialog 뜬 창 · reads 읽기 요청 (EG428) */
export function judgeBtnClick(s: { name: string; writes: number; dialog: string; reads: number; dl: boolean }): { result: 'PASS' | 'FAIL' | 'ERROR'; why: string } {
  if (s.writes > 0) return { result: 'FAIL', why: `'${s.name}' 클릭만으로 쓰기 요청 ${s.writes}건 — 확인창 없음${s.dialog ? ` · 창 '${s.dialog.slice(0, 40)}'` : ''}` };
  if (s.dialog) return { result: 'PASS', why: `'${s.name}' → 창 '${s.dialog.slice(0, 50)}' · 쓰기 없음` };
  if (s.dl) return { result: 'PASS', why: `'${s.name}' → 파일 다운로드 · 쓰기 없음` };
  if (s.reads > 0) return { result: 'PASS', why: `'${s.name}' → 읽기 요청 ${s.reads}건 · 쓰기 없음` };
  return { result: 'ERROR', why: `[확인 대상] '${s.name}' 클릭 무반응 — 창·요청·다운로드 없음(전제 조건 필요 여부 확인)` };
}
