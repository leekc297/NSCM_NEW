// Excel 다운로드 내용 판정(2026-11-02 엔진 갭 EG013·EG345·EG343·EG346·EG350). 순수 함수 — exceldl.selftest.js
export type J = { result: 'PASS' | 'FAIL' | 'ERROR' | 'NA'; why: string };
const nm = (v: string) => v.replace(/[*\s]/g, '').toLowerCase();

/** 머리글 = 화면 표시 컬럼(순서 무관 집합) */
export function judgeHeaders(s: { file: string[]; screen: string[] }): J {
  if (!s.file.length) return { result: 'ERROR', why: '[측정 경로 없음] 파일 머리글 0' };
  if (!s.screen.length) return { result: 'ERROR', why: '[측정 경로 없음] 화면 컬럼 0' };
  const F = new Set(s.file.map(nm)), S = new Set(s.screen.map(nm));
  const miss = s.screen.filter(x => !F.has(nm(x))), extra = s.file.filter(x => !S.has(nm(x)));
  if (miss.length || extra.length) return { result: 'FAIL', why: `Excel 컬럼 ≠ 화면 — 파일에 없음 ${miss.slice(0, 6).join(', ') || '0'} · 화면에 없음 ${extra.slice(0, 6).join(', ') || '0'}` };
  return { result: 'PASS', why: `Excel 머리글 ${s.file.length}개 = 화면 컬럼` };
}

/** 콤보 칸이 코드가 아니라 Name 인지 — pairs: 칸별 파일 값 · 화면 표시값 · 코드 */
export function judgeCodeName(pairs: { col: string; file: string; disp: string; raw: string }[]): J {
  const use = pairs.filter(p => p.raw && p.disp && p.raw !== p.disp);
  if (!use.length) return { result: 'NA', why: '코드·표시값이 다른 콤보 칸 없음' };
  const bad = use.filter(p => p.file === p.raw);
  if (bad.length) return { result: 'FAIL', why: `Excel 에 코드 출력 ${bad.length}/${use.length}: ${bad.slice(0, 4).map(p => `${p.col} '${p.raw}'(화면 '${p.disp}')`).join(', ')}` };
  return { result: 'PASS', why: `콤보 ${use.length}칸 Excel = Name` };
}

/** 틀 고정 — freeze 파일 틀 고정 위치(A2 등) · 머리글 행은 고정돼야 한다 */
export function judgeFreeze(s: { freeze: string | null }): J {
  return s.freeze ? { result: 'PASS', why: `틀 고정 ${s.freeze}` } : { result: 'FAIL', why: 'Excel 틀 고정 없음' };
}

/** 숫자 서식 — 숫자 칸 중 일반(General) 서식 수 */
export function judgeNumFmt(s: { numCells: number; general: number; samples: string[] }): J {
  if (!s.numCells) return { result: 'NA', why: '숫자 칸 없음' };
  if (s.general === s.numCells) return { result: 'FAIL', why: `숫자 칸 ${s.numCells}개 전부 General 서식` };
  return { result: 'PASS', why: `숫자 칸 ${s.numCells}개 · General ${s.general} · 서식 ${s.samples.slice(0, 3).join(' / ')}` };
}
