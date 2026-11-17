// authprobe — Division·권한 순회 측정(E03 · 2026-10-31). 화면 독립: 라벨·컬럼·그룹은 facts_auth.py 산출물(AS-IS 원문·사내 DB)과 화면 DOM 에서만 온다.
//   계정 ID 는 결과에 쓰지 않는다(key = 영역/Div/역할). 측정 실패 = ERROR · FAIL 은 기대·실측·AS-IS 근거(파일:라인)가 있을 때만.
import * as fs from 'node:fs';
import * as path from 'node:path';
import type { Page } from '@playwright/test';
import { evalExpr } from './condeval';
import type { Nscm } from './nscm';

const ROOT = path.resolve(__dirname, '..', '..', '..');
export type Verdict = 'PASS' | 'FAIL' | 'NA' | 'ERROR' | '판정필요';
export type EgRes = { eg: string; screen: string; target: string; ctx: string; result: Verdict; expected: string; actual: string; asis: string; note?: string };
export type AsisState = { ctl: string; prop: 'enabled' | 'visible'; val: boolean; cond: string; phase: 'load' | 'change' | 'other'; method: string; stmt: number; ref: string; labels: string[]; isButton: boolean };
export type Account = { key: string; keys: string[]; groups: string[]; menuGroups: string[]; divsAll: string[]; divsMenu: string[]; menus: string[]; titleset: number };
export type Facts = {
  id: string; at: string;
  asis: null | { mainClass: string; divControls: string[]; changeMethods: string[]; loadMethods: string[]; insertStmts: { kind: string; raw: string; ref: string; method: string }[]; headerSpan: { raw: string; ref: string; method: string }[]; planExcluded: string[]; editRules: { column: string; cond: string; ref: string }[]; states: AsisState[]; defaults: { target: string; raw: string; cond: string; phase: string; ref: string; labels: string[] }[]; insertGuards: { kind: string; raw: string; cond: string; value: string; ref: string }[]; hasMerge: boolean };
  db: { menu: Record<string, string>; menuGroups: { user_gr_id: string; use_yn: string }[]; btnAuth: { user_gr_id: string; sht_nm: string; mnu_btn_cd: string; use_yn: string }[]; columns: Record<string, string>[]; measures: Record<string, string>[]; lookupMeasure: Record<string, string>[]; lookupAdmin: Record<string, string>[]; now: { now_: string; dow: string; hm: string } };
  accounts: Account[];
  btnDiv: Record<string, Record<string, string[]>>;
};

export function loadFacts(id: string): Facts | null {
  try { return JSON.parse(fs.readFileSync(path.join(ROOT, 'Doc', 'verify', '_parallel', 'E03', 'facts', `${id}.json`), 'utf8')); } catch { return null; }
}
/** 명부 key(영역/Div/역할) → 로그인 ID. 결과·로그에 ID 를 쓰지 말 것 */
export function accountId(key: string): string | null {
  try {
    const uj = JSON.parse(fs.readFileSync(path.join(ROOT, 'tools', 'E2E', 'users.json'), 'utf8').replace(/^﻿/, ''));
    const [area, dv, ...rest] = key.split('/'); return uj.areas[area]?.divisions?.[dv]?.[rest.join('/')] || null;
  } catch { return null; }
}
/** 그룹이 다른 계정 한 명씩(화면 권한 차이를 재는 최소 표본이 아니라 '메뉴 권한 그룹 조합'별 전수) */
export function distinctAccounts(f: Facts): Account[] {
  const seen = new Set<string>(); const out: Account[] = [];
  for (const a of f.accounts) { const k = `${a.groups.join('|')}#${a.divsMenu.join('|')}`; if (seen.has(k)) continue; seen.add(k); out.push(a); }
  return out;
}

const nrm = (s: string) => (s || '').replace(/[​ ]/g, ' ').replace(/\s+/g, ' ').trim();
export const labelKey = (s: string) => nrm(s).toLowerCase().replace(/[^a-z0-9가-힣]/g, '');

export type CondSnap = { label: string; key: string; visible: boolean; disabled: boolean; value: string; kinds: string; inputs: number };
/** 조회영역 칸 스냅샷 — 크기 0 = 비노출 · 입력 전부 disabled = 비활성 */
export function condSnapshot(p: Page): Promise<CondSnap[]> {
  return p.evaluate(() => Array.from(document.querySelectorAll('[class*="_formItem_"]')).filter(e => !e.closest('.wj-flexgrid, [role="dialog"], .MuiDialog-root')).map(e => {
    const h = e as HTMLElement; const b = h.getBoundingClientRect();
    const lab = (h.querySelector('label') as HTMLElement | null)?.innerText || h.innerText || '';
    const ins = Array.from(h.querySelectorAll('input:not([type="hidden"]), [role="combobox"]')) as HTMLInputElement[];
    const dis = ins.filter(i => i.disabled || i.getAttribute('aria-disabled') === 'true' || !!i.closest('.Mui-disabled'));
    const vals = ins.map(i => i.type === 'checkbox' || i.type === 'radio' ? (i.checked ? 'Y' : 'N') : String(i.value ?? ''));
    const label = lab.replace(/[​ ]/g, ' ').replace(/\s+/g, ' ').trim();
    return { label, key: label.toLowerCase().replace(/[^a-z0-9가-힣]/g, ''), visible: b.width > 0 && b.height > 0 && h.offsetParent !== null, disabled: ins.length > 0 && dis.length === ins.length, value: vals.join('|').slice(0, 120), kinds: ins.map(i => i.type || i.getAttribute('role') || '').join(','), inputs: ins.length };
  }));
}
export type BtnSnap = { name: string; disabled: boolean };
export function buttonSnapshot(p: Page): Promise<BtnSnap[]> {
  return p.evaluate(() => [...document.querySelectorAll('button')].filter(b => (b as HTMLElement).offsetParent !== null && !b.closest('.wj-flexgrid, [class*="_formItem_"], [class*="_tab_"], nav')).map(b => {
    const t = ((b as HTMLElement).innerText || '').replace(/\s+/g, ' ').trim(); const own = b.getAttribute('aria-label') || b.getAttribute('title');
    const anc = b.parentElement ? b.parentElement.closest('[aria-label],[title]') : null;
    return { name: t || (own || '').trim() || (anc ? (anc.getAttribute('aria-label') || anc.getAttribute('title') || '').trim() : ''), disabled: (b as HTMLButtonElement).disabled };
  }).filter(x => x.name));
}
export const isDivLabel = (k: string) => /^(div|division|사업부)$/.test(k);
/** Division 칸: 값·콤보 후보(코드). 후보 텍스트 앞 토큰이 코드(FE 표기 '81 Automotive …') */
export async function divState(nscm: Nscm): Promise<{ value: string; code: string; options: string[]; found: boolean; multiAll?: boolean }> {
  const p = nscm.page; const snap = await condSnapshot(p); const it = snap.find(c => isDivLabel(c.key));
  if (!it) return { value: '', code: '', options: [], found: false };
  const code = (it.value.trim().split(/\s+/)[0] || '').replace(/[^A-Za-z0-9_]/g, '');
  const box = p.locator('[class*="_formItem_"]').filter({ has: p.locator('label', { hasText: new RegExp(`^\\s*${it.label.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}\\s*$`) }) }).first();
  await box.locator('[role="combobox"], input').first().click({ timeout: 5_000 }).catch(() => undefined);
  await p.getByRole('option').first().waitFor({ state: 'visible', timeout: 5_000 }).catch(() => undefined);
  const raw = await p.getByRole('option').allInnerTexts().catch(() => [] as string[]);
  await p.keyboard.press('Escape').catch(() => undefined); await p.waitForTimeout(150);
  // 2026-11-06(SCP0084 EG366 허위 FAIL 10건): 다중선택 콤보의 전체 선택 항목('Select All')을 앞 토큰 'SELECT' 로 잘라 Division 코드로 셌다
  //   → 문구 전체가 전체 선택 항목이면 토큰화 전에 뺀다(condOptions 와 같은 규칙)
  // multiAll = 다중선택 콤보(전체 선택 항목 'SELECT ALL' 이 있음)이고 선택값이 비어 있음 = 공용 CustomDropdown 의 'ALL' sentinel(필터 없음 = 후보 전부 · 칩 미표시)
  const multiAll = raw.some(t => /^select\s*all$/i.test(t.trim())) && !code;
  return { value: it.value, code, multiAll, options: raw.map(t => t.trim()).filter(t => t && !/^(select\s*)?all$|^전체$|^전체\s*선택$/i.test(t)).map(t => (t.split(/\s+/)[0] || '').replace(/[^A-Za-z0-9_]/g, '')).filter(t => t && !/^all$/i.test(t)), found: true };
}
/** Division 선택 후 표시값이 그 코드인지까지 확인(선택 실패를 측정값으로 쓰지 않는다) */
export async function selectDiv(nscm: Nscm, code: string): Promise<boolean> {
  const p = nscm.page; const snap = await condSnapshot(p); const it = snap.find(c => isDivLabel(c.key)); if (!it) return false;
  const box = p.locator('[class*="_formItem_"]').filter({ has: p.locator('label', { hasText: new RegExp(`^\\s*${it.label.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}\\s*$`) }) }).first();
  await box.locator('[role="combobox"], input').first().click({ timeout: 5_000 }).catch(() => undefined);
  const opt = p.getByRole('option', { name: new RegExp(`^\\s*${code.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}(\\s|$)`) }).first();
  if (!(await opt.isVisible({ timeout: 4_000 }).catch(() => false))) { await p.keyboard.press('Escape').catch(() => undefined); return false; }
  await opt.click({ timeout: 3_000 }).catch(() => undefined);
  await p.waitForLoadState('networkidle', { timeout: 15_000 }).catch(() => undefined); await p.waitForTimeout(400);
  const after = (await condSnapshot(p)).find(c => isDivLabel(c.key));
  return !!after && (after.value.trim().split(/\s+/)[0] || '') === code;
}

/** 조회조건 칸 콤보 후보 표시 문구 — 콤보가 아니면 null */
export async function condOptions(nscm: Nscm, label: string): Promise<string[] | null> {
  const p = nscm.page; const box = p.locator('[class*="_formItem_"]').filter({ has: p.locator('label', { hasText: new RegExp(`^\\s*${label.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}\\s*$`) }) }).first();
  const cb = box.locator('[role="combobox"]').first(); if (!(await cb.isVisible({ timeout: 800 }).catch(() => false))) return null;
  await cb.click({ timeout: 3_000 }).catch(() => undefined);
  await p.getByRole('option').first().waitFor({ state: 'visible', timeout: 2_500 }).catch(() => undefined);
  const raw = await p.getByRole('option').allInnerTexts().catch(() => [] as string[]);
  await p.keyboard.press('Escape').catch(() => undefined); await p.waitForTimeout(120);
  return raw.map(t => t.trim()).filter(t => t && !/^(select\s*)?all$|^전체$/i.test(t));
}
export type GroupCtx = { group: string[]; admin: boolean };
export const ctxOf = (a: { groups: string[] }): GroupCtx => ({ group: a.groups, admin: a.groups.some(g => /^ADMIN$/i.test(g)) });
export type StateExpect = { val: boolean | null; ref: string; by: string; err?: string };
/** AS-IS 컨트롤 상태 기대 — 변경 이벤트 문장 → 로드 문장 순. 마지막으로 참인 문장이 정답. 평가 불가 문장이 결론에 영향을 주면 err */
export function expectState(stmts: AsisState[], div: string, initialDiv: string, g: GroupCtx, ctl: Record<string, string> = {}): StateExpect {
  const ev = (cond: string, d: string): boolean | { err: string } => {
    if (!cond) return true;
    const c = cond.replace(/CTL\((\w+)\)\s*(==|!=)\s*"([^"]*)"/g, (_m, n: string, op: string, v: string) => { if (!(n in ctl)) return `RAW(CTL ${n})`; const hold = ctl[n] === v; return (op === '==' ? hold : !hold) ? 'TRUE' : 'FALSE'; });
    try { return evalExpr(c, { group: g.group, admin: g.admin, div, col: () => null, self: '' }); } catch (e) { return { err: `평가 불가 ${String((e as Error).message).slice(0, 80)}` }; }
  };
  const run = (list: AsisState[], d: string): StateExpect | null => {
    let cur: StateExpect | null = null;
    for (const s of [...list].sort((a, b) => a.stmt - b.stmt)) {
      const v = ev(s.cond, d);
      if (typeof v === 'object') return { val: null, ref: s.ref, by: s.cond, err: v.err };
      if (v) cur = { val: s.val, ref: s.ref, by: s.cond || '(무조건)' };
    }
    return cur;
  };
  const chg = stmts.filter(s => s.phase === 'change');
  const lod = stmts.filter(s => s.phase === 'load');
  if (chg.length) { const r = run(chg, div); if (r) return r; }
  // 변경 이벤트가 이 컨트롤을 건드리지 않으면 AS-IS 상태는 로드 시점 Div 기준으로 남는다
  const r2 = run(lod, chg.length ? div : initialDiv);
  if (r2) return { ...r2, by: chg.length ? r2.by : `${r2.by} (로드 시점 Div ${initialDiv})` };
  return { val: null, ref: stmts[0]?.ref || '', by: '', err: '이 Div·그룹에 해당 문장 없음(디자이너 기본값)' };
}
/** (컨트롤, 속성) 별 문장 묶음. 라벨 후보 없으면 labels 빈 값 */
export function groupStates(f: Facts): { ctl: string; prop: 'enabled' | 'visible'; labels: string[]; isButton: boolean; stmts: AsisState[] }[] {
  const m = new Map<string, { ctl: string; prop: 'enabled' | 'visible'; labels: string[]; isButton: boolean; stmts: AsisState[] }>();
  for (const s of f.asis?.states || []) { const k = `${s.ctl}|${s.prop}`; if (!m.has(k)) m.set(k, { ctl: s.ctl, prop: s.prop, labels: [], isButton: s.isButton, stmts: [] }); const e = m.get(k)!; e.stmts.push(s); for (const l of s.labels) if (!e.labels.includes(l) && !/\./.test(l)) e.labels.push(l); }
  return [...m.values()];
}

/** 응답 상태 수집기 — 401/403/5xx */
export function watchStatus(p: Page): { all: { url: string; status: number; at: number }[]; stop: () => void } {
  const all: { url: string; status: number; at: number }[] = [];
  const h = (r: { status: () => number; url: () => string }) => { const st = r.status(); if (st === 401 || st === 403 || st >= 500) all.push({ url: r.url().replace(/^.*\/api\//, '').slice(0, 80), status: st, at: Date.now() }); };
  p.on('response', h);
  return { all, stop: () => p.off('response', h) };
}

/** 세션 API — 메뉴 트리 전개 · 세션 사용자 */
export async function sessionMenus(p: Page): Promise<{ status: number; menus: string[]; raw: Record<string, unknown> | null }> {
  return p.evaluate(async () => {
    const r = await fetch('/api/user/session', { credentials: 'include' }).catch(() => null); if (!r) return { status: 0, menus: [], raw: null };
    const j = await r.json().catch(() => null) as { result?: { menus?: unknown[] } } | null; const out: string[] = [];
    const walk = (a: unknown[]) => { for (const m of a as { mnuId: string; children?: unknown[] }[]) { out.push(m.mnuId); if (m.children) walk(m.children); } };
    walk(j?.result?.menus || []); const { menus: _m, ...rest } = (j?.result || {}) as Record<string, unknown>;
    return { status: r.status, menus: out, raw: Object.fromEntries(Object.keys(rest).map(k => [k, typeof rest[k] === 'string' || Array.isArray(rest[k]) ? '(값 생략)' : typeof rest[k]])) };
  });
}

/** 보이는 첫 그리드의 숨김 포함 바인딩/헤더 */
export const GRID = `(() => { const el = [...document.querySelectorAll('.wj-flexgrid')].find(e => e.offsetParent !== null); if (!el) return null; let c = el['$WJ-CTRL']; if (!c || !c.columns) for (const k of Object.getOwnPropertyNames(el)) { const v = el[k]; if (v && typeof v === 'object' && v.columns && typeof v.columns.length === 'number') { c = v; break; } } return c || null; })()`;
export function gridState(p: Page): Promise<{ visible: string[]; rows: number; hdrRows: number; sort: string[]; merge: boolean } | null> {
  return p.evaluate(`(() => { const c = ${GRID}; if (!c) return null; const vis = []; for (let i = 0; i < c.columns.length; i++) { const x = c.columns[i]; if (x.binding && x.visible !== false) vis.push(String(x.binding)); }
    const cv = c.collectionView; return { visible: vis, rows: c.rows.length, hdrRows: c.columnHeaders ? c.columnHeaders.rows.length : 0, sort: cv && cv.sortDescriptions ? Array.from(cv.sortDescriptions).map(s => s.property + (s.ascending ? ' asc' : ' desc')) : [], merge: !!c.allowMerging }; })()`) as Promise<{ visible: string[]; rows: number; hdrRows: number; sort: string[]; merge: boolean } | null>;
}
/** 병합 범위 찾기 — 데이터 영역에서 row 범위가 2행 이상인 첫 셀 */
export function findMerged(p: Page, maxRows = 200): Promise<{ row: number; col: number; top: number; bottom: number; binding: string } | null> {
  return p.evaluate(`(() => { const c = ${GRID}; if (!c || !c.getMergedRange) return null; const n = Math.min(c.rows.length, ${maxRows}); for (let col = 0; col < c.columns.length; col++) { if (c.columns[col].visible === false) continue; for (let r = 0; r < n; r++) { const g = c.getMergedRange(c.cells, r, col, false); if (g && g.bottomRow > g.topRow && g.leftCol === g.rightCol) return { row: g.topRow + 1 <= g.bottomRow ? g.topRow + 1 : g.topRow, col, top: g.topRow, bottom: g.bottomRow, binding: String(c.columns[col].binding || '') }; } } return null; })()`) as Promise<{ row: number; col: number; top: number; bottom: number; binding: string } | null>;
}
