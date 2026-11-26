// rowlink.ts — 저장 시험 칸과 함께 바뀌는 연동 칸(2026-11-25 T534 · SSP0014 F1·F6 5행 '재조회 행 식별 0건')
//   실측: USER_ID 'eunjin.choi'→'luping' 저장 뒤 조회 SP 가 USER_ID 로 조인해 가져오는 USER_NAME 도 '이련'→'육평' 으로 바뀌어
//   행 식별 문자열(rowIdentity)의 정확 일치가 0건, 근접 일치는 ITEM_ID 만 다른 이웃 행(MAMM9314U0A1-016 ↔ -018)과 차이 수 1로 동률이 되어 행을 잃었다.
//   시험 칸 b 의 연동 칸 = 이름이 '<b>_' 로 시작하는 칸(T457 과 같은 규칙) + b 에서 끝의 _ID·_CD·_CODE 를 뺀 이름에 _NAME·_NM·_DESC 가 붙은 칸.
//   행 식별·다른 칸 변경(sideDiff) 판단에서만 뺀다. 시험 칸 값 대조에는 쓰지 않는다.
export function linkedCols(b: string, keys: string[]): string[] {
  const B = String(b || '').toUpperCase(); if (!B) return [];
  const stem = B.replace(/_(ID|CD|CODE)$/, '');
  return keys.filter(k => { const K = String(k).toUpperCase(); if (K === B) return false; if (K.startsWith(`${B}_`)) return true; return stem !== B && (K === `${stem}_NAME` || K === `${stem}_NM` || K === `${stem}_DESC`); });
}

/** 행 식별 제외 목록 = 시험 칸 + 연동 칸 */
export function identExclude(b: string, keys: string[]): string[] {
  return [b, ...linkedCols(b, keys)];
}

// ---- 2026-11-25 SCP0005 U4a(T555~T558) 순수 함수 — saveprobe.ts·crud.ts 가 쓴다. 자체 시험 rowlink.u4.selftest.js
/** T555: TO-BE NOT NULL 빈 값 표시('/' · 과도기 '-')와 빈 값 — 원값이 이 셋 중 하나면 콤보 후보에 없는 값이라 고르기로 원복할 수 없다(SCP0005 LT_TYPE '/' 1,685행) */
export function emptyLike(s: unknown): boolean { const t = String(s ?? '').replace(/,/g, '').trim(); return t === '' || t === '/' || t === '-'; }
/** T555: 원복 대조 — 같은 값이거나 둘 다 빈 값 계열이면 같은 것으로 본다(저장 SP 가 빈 값을 NVL(x,'/') 로 바꿔 넣는다) */
export function sameRestore(a: unknown, b: unknown): boolean {
  const n = (s: unknown) => String(s ?? '').replace(/,/g, '').trim(); const x = n(a), y = n(b);
  return x === y || (x !== '' && y !== '' && !isNaN(Number(x)) && Number(x) === Number(y)) || (emptyLike(x) && emptyLike(y));
}
/** T557: 화면 메타(sheet_columns.csv) 한 프로그램의 행들 중 그리드 칸 목록과 가장 많이 겹치는 시트(겹침/합집합 최대 · 같으면 앞 시트) — 팝업 시트(SCP0005 'route' 전부 'S')가 본 그리드 칸을 'S' 로 덮지 않게 */
export function sheetOfGrid(rows: Record<string, string>[], bindings: string[]): string {
  const g = new Set(bindings.filter(Boolean).map(b => b.toUpperCase())); const by = new Map<string, Set<string>>();
  for (const r of rows) { const s = r.sheet_name || ''; if (!by.has(s)) by.set(s, new Set()); by.get(s)!.add(String(r.column_name || '').toUpperCase()); }
  let best = '', bs = -1; for (const [s, cs] of by) { let hit = 0; for (const c of cs) if (g.has(c)) hit++; const uni = new Set([...cs, ...g]).size || 1; const sc = hit / uni; if (sc > bs) { bs = sc; best = s; } }
  return best;
}
/** T557: 그 시트에서 input_tp_cd 가 code 인 칸 이름 — 시트를 못 고르면 빈 집합 */
export function sheetCols(rows: Record<string, string>[], bindings: string[], code: string): Set<string> {
  const sh = sheetOfGrid(rows, bindings); if (!rows.length) return new Set();
  return new Set(rows.filter(r => (r.sheet_name || '') === sh && (r.input_tp_cd || '').toUpperCase() === code.toUpperCase()).map(r => r.column_name));
}
/** T558: AS-IS 셀 규칙(cell_rules.csv 행들)에서 칸 규칙 — 칸 이름 대소문자 무시(ONE_SEGMENT_COST ↔ One_SEGMENT_COST) */
export function cellRuleOf(rows: Record<string, string>[], binding: string): { min: number | null; max: number | null; maxLength: number | null } {
  const r = rows.find(x => String(x.column || '').toUpperCase() === String(binding || '').toUpperCase());
  const num = (v?: string) => (v ?? '').trim() !== '' && !isNaN(Number(v)) ? Number(v) : null;
  return { min: num(r?.min), max: num(r?.max), maxLength: num(r?.max_length) };
}
/** T558: 필수 숫자 칸 신규 값 — [max(lo,1), hi] 안에서 used 에 없는 가장 작은 정수. 범위가 없으면 최대+1. 다 쓰였으면 null(호출부가 종전 값) */
export function pickFreeInt(used: number[], lo: number | null, hi: number | null): number | null {
  const u = new Set(used.filter(n => Number.isFinite(n)).map(n => Math.trunc(n)));
  if (hi == null) return (u.size ? Math.max(...u) : 0) + 1;
  for (let n = Math.max(lo ?? 1, 1); n <= hi; n++) if (!u.has(n)) return n;
  return null;
}

// ---- 2026-11-25 SCP0005 U5(T595~T599) 순수 함수 — saveprobe.ts·crud.ts·_verify.spec.ts 저장 세부가 쓴다. 자체 시험 rowlink.u5.selftest.js
/** T596: AS-IS 메시지 행의 막는 조건(guard 의 마지막 '▸' 조각)이 메서드 본문 지역 변수 대입을 거쳐 그 칸(DefColumns.<칸> · "<칸>")을 읽는지.
 *  예) SCP0005 CheckValid cs:1293 'if (intPRIORITY < 1)' ← Int64.Parse(strPRIORITY) ← siMain.GetValue(i, nPriorityIdx1) ← GetColumnIndex(DefColumns.PRIORITY).
 *  반환 = 대입 경로 문자열(직접이면 'direct') · 못 닿으면 '' */
export function guardReaches(body: string, guard: string, binding: string): string {
  const esc = String(binding || '').replace(/[.*+?^${}()|[\]\\]/g, '\\$&'); if (!esc) return '';
  const colRe = new RegExp(`(?:[.]${esc}\\b|"${esc}")`);
  const cond = String(guard || '').split('▸').pop() || '';
  if (colRe.test(cond)) return 'direct';
  const asg = new Map<string, string[]>(); const re = /([A-Za-z_]\w*)\s*(?:[-+*|&?]{1,2})?=(?!=)\s*([^;]+);/g; let m: RegExpExecArray | null;  // T596: '+=' 누적 대입도 대입(SCP0005 SaveData cs:684 strDAYS_MON += ... DefColumns.DAYS_MON)
  const code = String(body || '').replace(/\/\/[^\n]*/g, '');  // 주석 안 대입은 사실 아님
  while ((m = re.exec(code))) { const k = m[1]; if (!asg.has(k)) asg.set(k, []); asg.get(k)!.push(m[2]); }
  const KW = new Set(['if', 'else', 'for', 'while', 'return', 'new', 'null', 'true', 'false', 'string', 'int', 'var', 'bool', 'this', 'break', 'continue']);
  const ids = (s: string) => (s.replace(/"[^"]*"/g, ' ').match(/[A-Za-z_]\w*/g) || []).filter(x => !KW.has(x));
  const seen = new Set<string>(); let q: { v: string; path: string[] }[] = ids(cond).map(v => ({ v, path: [v] }));
  for (let depth = 0; depth < 8 && q.length; depth++) {
    const nq: typeof q = [];
    for (const it of q) { if (seen.has(it.v)) continue; seen.add(it.v);
      for (const rhs of asg.get(it.v) || []) { if (colRe.test(rhs)) return `${it.path.join(' ← ')} = ${(colRe.exec(rhs) || [''])[0].replace(/^[.]/, '')}`; for (const v of ids(rhs)) if (!seen.has(v)) nq.push({ v, path: [...it.path, v] }); } }
    q = nq;
  }
  return '';
}
/** T596: 메시지 행 value('("MSG00107", null)')의 메시지 코드 */
export function msgCodeOf(value: string): string { return (/"(MSG\d+)"/i.exec(String(value || '')) || [])[1] || ''; }
/** T595·T596: 화면 메시지가 AS-IS 메시지 문구(한·영·중 중 하나)와 같은지 — 공백·문장부호 무시 · '{0}' 자리는 앞뒤 조각이 모두 들어 있으면 같음 */
export function sameMsg(screen: string, texts: string[]): boolean {
  const n = (s: string) => String(s ?? '').toLowerCase().replace(/[\s.,!?'"·:;()[\]_-]+/g, '');
  const sc = n(screen); if (!sc) return false;
  return texts.filter(t => String(t || '').trim()).some(t => { const parts = String(t).split(/\{\d+\}/).map(n).filter(x => x.length >= 2); return parts.length > 0 && parts.every(x => sc.includes(x)); });
}
/** T599: 저장 차단 문구의 '[항목]' 이름 — 없으면 '' */
export function msgLabelOf(msg: string): string { return ((/\[([^\]]+)\]/.exec(String(msg || '')) || [])[1] || '').trim(); }
/** T599: 머리글 여러 줄 그리드에서 label 이 묶음 머리글(맨 아래 줄 제외)인 칸들. heads = 그 칸의 머리글 줄(위 → 아래). 칸 자기 머리글만 같으면 묶음 아님 */
export function groupMembers(cols: { binding: string; heads: string[] }[], label: string): string[] {
  const n = (s: string) => String(s ?? '').replace(/\*/g, '').replace(/\s+/g, ' ').trim().toLowerCase(); const L = n(label); if (!L) return [];
  const hit = cols.filter(c => c.binding && c.heads.length > 1 && c.heads.slice(0, -1).some(h => n(h) === L) && n(c.heads[c.heads.length - 1]) !== L).map(c => c.binding);
  return hit.length >= 2 ? hit : [];
}
/** T599: 묶음 첫 칸에 넣을 값 — 'Y' 후보가 있으면 'Y', 없으면 빈 값·'N' 이 아닌 첫 후보 · 없으면 '' */
export function groupFillValue(cands: string[]): string {
  const c = (cands || []).map(x => String(x ?? '').trim()).filter(Boolean);
  return c.find(x => x.toUpperCase() === 'Y') || c.find(x => !/^(N|NO|-|\/)$/i.test(x)) || '';
}
/** 2026-11-25 T636(SCP0005 ES-836708a8 '[Working Days] 값은 필수' 뒤 T599 무기록): 저장 차단 문구의 '[항목]' 이 그리드 머리글이 아닌 고정 글자인 화면
 *  (TO-BE useDistributionRouteValidation.ts:41 '[Working Days]' · 요일 칸 머리글 메타와 무관) → 머리글 묶음 후보 전부를 돌려준다.
 *  묶음 = 같은 윗줄 머리글(맨 아래 줄 제외)을 가진 칸 2개 이상. score = 문구 이름과 윗줄 머리글이 겹치는 낱말 수(3자 이상).
 *  고르는 쪽(crud.ts)이 새 행에서 칸이 모두 비고 'Y' 후보가 있는 묶음만 쓴다. 낱말 겹침이 없으면 그런 묶음이 하나일 때만 쓴다 */
export function groupCandidates(cols: { binding: string; heads: string[] }[], label: string): { head: string; members: string[]; score: number }[] {
  const n = (s: string) => String(s ?? '').replace(/\*/g, '').replace(/\s+/g, ' ').trim().toLowerCase();
  const words = (s: string) => n(s).split(/[^a-z0-9가-힣]+/).filter(w => w.length >= 3);
  const lw = new Set(words(label)); const by = new Map<string, string[]>();
  for (const c of cols) { if (!c.binding || c.heads.length < 2) continue; const last = n(c.heads[c.heads.length - 1]); for (const h of c.heads.slice(0, -1)) { const k = n(h); if (!k || k === last) continue; if (!by.has(k)) by.set(k, []); const a = by.get(k)!; if (!a.includes(c.binding)) a.push(c.binding); } }
  return [...by.entries()].filter(([, m]) => m.length >= 2).map(([head, members]) => ({ head, members, score: words(head).filter(w => lw.has(w)).length })).sort((a, b) => b.score - a.score || a.members.length - b.members.length);
}
