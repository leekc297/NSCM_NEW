import * as fs from 'node:fs';
import * as path from 'node:path';
// AS-IS 잠금 규칙 정규형(facts_lockrules.py v2 · edit_expect.csv '*_cond' = 'RULES:[{g, lock, ref}]') 평가기 — 2026-10-30 SCP0111 D1 UNKNOWN 계기
//   원자: GROUP=="X" · DIV=="X" · COL(NAME)=="X" · COL(NAME)[a:b]!="X" · COL(SELF)=="" · TRUE/FALSE · RAW(...)(평가 불가)
//   연산: && · || · !( ) · ( )
//   규칙 목록은 AS-IS 원문 순서대로 적용한 마지막 상태가 정답(기본 = 편집 가능). 한 규칙이라도 RAW 를 평가해야 결론이 갈리면 '평가 불가'.
//   화면 리터럴 없음 — GROUP 은 계정 속성(plan.json accounts: admin·groups·tobeGroups), DIV 는 조회 요청의 divisionId, COL 은 그 행의 dataItem.
export type Rule = { g: string; lock: 'Y' | 'N'; ref: string };
export type CondCtx = { group: string[]; admin: boolean; div: string; col: (name: string) => string | null; self: string; /** 2026-11-12 T264: 이 계정이 이 화면의 편집 권한자인가(모르면 생략 → AUTH 는 평가 불가) */ auth?: boolean; /** 지금 재는 그리드의 시트 이름(모르면 생략 → SHEET 는 평가 불가) */ sheet?: string };
export type EvalResult = { editable: boolean; by: string } | { error: string };

const nrm = (s: string) => s.toLowerCase().replace(/[^a-z0-9]/g, '');

export function parseRules(cond: string): Rule[] | null {
  const m = /RULES:(\[.*\])\s*$/s.exec(cond || '');
  if (!m) return null;
  try { return JSON.parse(m[1]) as Rule[]; } catch { return null; }
}

class Unknown extends Error { }

function evalAtom(a: string, ctx: CondCtx): boolean {
  a = a.trim();
  if (a === 'TRUE') return true;
  if (a === 'FALSE') return false;
  if (/^RAW\(/.test(a)) throw new Unknown(a);
  // 2026-11-12 T264: AUTH = AS-IS 편집 권한 플래그(bEdit_Auth) — 문맥에 권한 여부가 있을 때만 평가
  if (a === 'AUTH') { if (ctx.auth === undefined) throw new Unknown('AUTH(계정 편집 권한 문맥 없음)'); return ctx.auth; }
  // SHEET=="이름" = AS-IS 다중 시트 컨트롤의 활성 시트 조건 — 지금 재는 시트를 알 때만 평가(공백·기호 무시 비교)
  const msh = /^SHEET\s*(==|!=)\s*"([^"]*)"$/.exec(a);
  if (msh) { if (ctx.sheet === undefined || ctx.sheet === '') throw new Unknown(`SHEET(${msh[2]}) — 재는 시트 문맥 없음`); const same = nrm(ctx.sheet) === nrm(msh[2]); return msh[1] === '==' ? same : !same; }
  // SELF~"regex" — 지금 평가 중인 동적 binding(ctx.self) 이 정규식에 맞는가(AS-IS GetColumnTag(iCol).IndexOf("M_")==0 · 2026-10-31)
  const ms = /^SELF~"([^"]+)"$/.exec(a);
  if (ms) { try { return new RegExp(ms[1]).test(ctx.self || ''); } catch { throw new Unknown(a); } }
  const m = /^(GROUP|DIV|COL\((\w+)\))(?:\[(\d+):(\d+)\])?\s*(==|!=)\s*("([^"]*)"|-?\d+)$/.exec(a);
  if (!m) throw new Unknown(a);
  const lit = m[7] !== undefined ? m[7] : m[6];
  const slice = (v: string) => (m[3] !== undefined ? v.slice(Number(m[3]), Number(m[4])) : v);
  let hold: boolean;
  if (m[1] === 'GROUP') {
    // AS-IS 그룹 ID 'ADMIN' = TO-BE 관리자(admin) · 그 외는 계정 그룹명과 정규화 비교
    const want = nrm(lit);
    const has = (want === 'admin' && ctx.admin) || ctx.group.some(g => nrm(g) === want);
    hold = has;
  } else if (m[1] === 'DIV') {
    hold = slice(ctx.div) === lit || ctx.div.split(',').map(s => s.trim()).some(d => slice(d) === lit);
  } else {
    const name = m[2] === 'SELF' ? ctx.self : m[2];
    const v = ctx.col(name);
    if (v == null) throw new Unknown(`COL(${name}) 없음`);
    hold = slice(v) === lit;
  }
  return m[5] === '==' ? hold : !hold;
}

/** 식 평가 — 괄호·!·&&·|| */
export function evalExpr(expr: string, ctx: CondCtx): boolean {
  const s = expr.trim();
  if (!s) return true;
  // 바깥 괄호 벗기기
  const strip = (t: string): string => { while (t.startsWith('(') && t.endsWith(')') && balanced(t.slice(1, -1))) t = t.slice(1, -1).trim(); return t; };
  const t = strip(s);
  const parts = split(t, '||');
  if (parts.length > 1) {
    let err: Unknown | null = null;
    for (const p of parts) { try { if (evalExpr(p, ctx)) return true; } catch (e) { if (e instanceof Unknown) err = e; else throw e; } }
    if (err) throw err; return false;
  }
  const ands = split(t, '&&');
  if (ands.length > 1) {
    let err: Unknown | null = null;
    for (const p of ands) { try { if (!evalExpr(p, ctx)) return false; } catch (e) { if (e instanceof Unknown) err = e; else throw e; } }
    if (err) throw err; return true;
  }
  if (t.startsWith('!') && !t.startsWith('!=')) return !evalExpr(t.slice(1), ctx);
  return evalAtom(t, ctx);
}

function balanced(s: string): boolean { let d = 0; for (const ch of s) { if (ch === '(') d++; else if (ch === ')') { d--; if (d < 0) return false; } } return d === 0; }
function split(s: string, op: string): string[] {
  const out: string[] = []; let d = 0, cur = '', i = 0;
  while (i < s.length) {
    const ch = s[i];
    if (ch === '(') d++; else if (ch === ')') d--;
    if (d === 0 && s.startsWith(op, i)) { out.push(cur); cur = ''; i += op.length; continue; }
    cur += ch; i++;
  }
  out.push(cur);
  return out.filter(x => x.trim());
}

/** 규칙 목록 → 그 행·계정·Division 에서의 편집 가능 여부. 결론에 영향을 주는 규칙의 RAW 는 error */
/** 2026-11-13 T301(CR-102): 그룹이 둘 이상인 계정은 그룹 하나씩 평가해 합집합(어느 그룹에서라도 편집 가능이면 편집 가능) */
export function evalRules(rules: Rule[], ctx: CondCtx, defaultEditable = true): EvalResult {
  const gs = [...new Set((ctx.group || []).filter(Boolean))];
  const variants: { group: string[]; admin: boolean }[] = gs.map(g => ({ group: [g], admin: nrm(g) === 'admin' }));
  if (ctx.admin && !variants.some(v => v.admin)) variants.push({ group: ['ADMIN'], admin: true });
  if (variants.length < 2) return evalRulesOne(rules, ctx, defaultEditable);
  let firstLock: EvalResult | null = null; let firstErr: EvalResult | null = null;
  for (const v of variants) {
    const r = evalRulesOne(rules, { ...ctx, group: v.group, admin: v.admin }, defaultEditable);
    if ('error' in r) { firstErr = firstErr || r; continue; }
    if (r.editable) return { editable: true, by: `${r.by} [그룹 ${v.group[0]} 기준, 보유 그룹 합집합 CR-102]` };
    firstLock = firstLock || r;
  }
  if (firstErr) return firstErr;
  return firstLock as EvalResult;
}

function evalRulesOne(rules: Rule[], ctx: CondCtx, defaultEditable = true): EvalResult {
  let editable = defaultEditable; let by = defaultEditable ? '기본(편집 모드 전체 해제)' : '기본(잠금)';
  for (const r of rules) {
    let hit: boolean;
    try { hit = evalExpr(r.g, ctx); }
    catch (e) { return { error: `규칙 ${r.ref} 조건 평가 불가: ${(e as Error).message.slice(0, 120)}` }; }
    if (hit) { editable = r.lock !== 'Y'; by = `${r.ref} ${r.g || '(무조건)'} → ${r.lock === 'Y' ? '잠금' : '해제'}`; }
  }
  return { editable, by };
}

/** 규칙 조건에 등장하는 행 컬럼 이름(행 고르기용) */
export function ruleColumns(rules: Rule[]): string[] {
  const s = new Set<string>();
  for (const r of rules) for (const m of r.g.matchAll(/COL\((\w+)\)/g)) if (m[1] !== 'SELF') s.add(m[1]);
  return [...s];
}

/** plan.json 계정 → GROUP 컨텍스트(화면 리터럴 없음) */
export function groupCtx(acc: { admin?: boolean; groups?: string[]; tobeGroups?: string[]; roleNote?: string } | undefined): { group: string[]; admin: boolean } {
  if (!acc) return { group: [], admin: false };
  return { group: [...(acc.groups || []), ...(acc.tobeGroups || [])], admin: !!acc.admin };
}

/** 로그인 계정의 그룹 컨텍스트(화면 리터럴 없음 · 2026-10-30) — plan.accounts → tools/E2E/accounts.json 풀 → TO-BE 메타 Doc/tobefacts/db/user_group_user.csv 순.
 *  어디서도 못 찾으면 unknown=true: GROUP 조건 평가는 ERROR(PASS/FAIL 오판 금지). SCP0111 v12 에서 기본 계정이 plan.accounts(표본 1계정) 에 없어 admin=false 로 D1 PASS 오판한 결함(T16) */
export function loadAccountCtx(id: string, account?: string): { group: string[]; admin: boolean; unknown?: boolean; src: string; account: string } {
  const ROOT = path.resolve(__dirname, '..', '..', '..');
  const rd = (f: string) => { try { return JSON.parse(fs.readFileSync(f, 'utf8')); } catch { return null; } };
  const cfg = rd(path.join(ROOT, 'tools', 'E2E', 'e2e.config.json')) || {};
  const acct = String(account || process.env.E2E_ACCOUNT || cfg.defaultAccount || '').toLowerCase();
  const plan = rd(path.join(ROOT, 'Doc', 'e2e', 'specs', `${id}.plan.json`)) || {};
  let acc = (plan.accounts || []).find((a: { id?: string }) => String(a.id || '').toLowerCase() === acct);
  if (acc) return { ...groupCtx(acc), src: 'plan.accounts', account: acct };
  const pool = rd(path.join(ROOT, 'tools', 'E2E', 'accounts.json')) || {};
  acc = (pool.accounts || []).find((a: { id?: string }) => String(a.id || '').toLowerCase() === acct);
  if (acc) { const g = groupCtx(acc); return { group: g.group, admin: g.admin || g.group.some(x => /^ADMIN$/i.test(x)), src: 'accounts.json', account: acct }; }
  try {
    const lines = fs.readFileSync(path.join(ROOT, 'Doc', 'tobefacts', 'db', 'user_group_user.csv'), 'utf8').replace(/^\uFEFF/, '').split(/\r?\n/).filter(Boolean);
    const hd = lines[0].split(','); const iu = hd.indexOf('user_id'); const ig = hd.indexOf('user_gr_id'); const iy = hd.indexOf('use_yn');
    const grp = lines.slice(1).map(l => l.split(',')).filter(cc => iu >= 0 && String(cc[iu] || '').toLowerCase() === acct && (iy < 0 || cc[iy] === 'Y')).map(cc => cc[ig]);
    if (grp.length) return { group: grp, admin: grp.some(x => /^ADMIN$/i.test(x)), src: 'user_group_user.csv', account: acct };
  } catch { /* 메타 사실 없음 */ }
  return { group: [], admin: false, unknown: true, src: '미확인', account: acct };
}
