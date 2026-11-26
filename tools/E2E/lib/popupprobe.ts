// 팝업 프로브(E02 · 2026-10-31) — 화면 고유값 없이 '열린 팝업 하나'를 측정·조작한다.
//   대상 표지: [data-e2e-pop="<tag>"] (열린 대화상자 중 가장 위) · 그리드 컨트롤은 그 안의 .wj-flexgrid 에서만 찾는다(메인 그리드와 분리).
//   측정 실패는 null/빈값으로 돌려준다 — FAIL 로 해석하는 것은 호출부(근거 있을 때만)의 책임이다.
import type { Locator, Page } from '@playwright/test';

import type { Nscm } from './nscm';

const J = (v: unknown) => JSON.stringify(v);

export type NetRec = { url: string; sheet: string; btn: string; body: string; status: number; rows: Record<string, unknown>[] | null; at: number };
export type PopCol = { binding: string; header: string; visible: boolean; width: number; readOnly: boolean; allowMerging: number; dataType: number; hasMap: boolean };
export type PopGrid = { rows: number; cols: PopCol[]; selectionMode: number; isReadOnly: boolean; allowSorting: number | boolean; allowMerging: number; corner: string[]; rowHeaderCols: number; rowHeaderW: number; hasCheck: boolean; frozen: number };
export type PopCond = { pc: number; label: string; kind: 'text' | 'combo' | 'period' | 'check' | 'radio' | 'other'; disabled: boolean; readOnly: boolean; values: string[]; rect: Rect; n: number; multi: boolean };
export type Rect = { x: number; y: number; w: number; h: number };
export type PopBtn = { text: string; disabled: boolean; rect: Rect };
export type PopMeasure = {
  title: string; rect: Rect; vw: number; vh: number; closeIcon: Rect | null; buttons: PopBtn[];
  scroll: { paperV: boolean; paperH: boolean; dH: number; bodyV: { sel: string; sh: number; ch: number }[] };
  lines: { y: number; w: number; color: string; cls: string; side: string; box: boolean }[]; grids: PopGrid[]; conds: PopCond[];
  countText: string; rawText: string; underscore: string[]; codes: string[]; headH: number; sectionTitles: { text: string; insideBorder: boolean }[];
};

/** 팝업 안 응답 기록 — 대상 URL 은 call-proc 뿐 아니라 /api/ POST 전부(공용 조회 API 도 팝업 조회일 수 있다) */
export class PopNet {
  recs: NetRec[] = [];
  pending = 0;
  constructor(private page: Page) {
    const isApi = (u: string) => /\/api\//.test(u) && !/\.(js|ts|css|png|svg)(\?|$)/.test(u);
    page.on('request', r => { if (isApi(r.url())) this.pending++; });
    page.on('requestfinished', r => { if (isApi(r.url())) this.pending = Math.max(0, this.pending - 1); });
    page.on('requestfailed', r => { if (isApi(r.url())) this.pending = Math.max(0, this.pending - 1); });
    page.on('response', async res => {
      const u = res.url(); if (!/\/api\//.test(u)) return;
      const req = res.request(); if (req.method() !== 'POST' && req.method() !== 'GET') return;
      if (/\/(user\/|notice|menu\/.*auth|i18n|messages?)\b/i.test(u)) return;
      const m = u.match(/\/([^/]+)\/([^/]+)\/([^/]+)\/call-proc(?:-stream)?(?:\?|$)/);
      const rec: NetRec = { url: u.replace(/^.*\/api\//, ''), sheet: m ? decodeURIComponent(m[2]) : '', btn: m ? decodeURIComponent(m[3]) : '', body: '', status: res.status(), rows: null, at: Date.now() };
      try { rec.body = (req.postData() || '').slice(0, 6000); } catch { /* 본문 없음 */ }
      this.recs.push(rec);
      try { const j = await res.json(); rec.rows = firstArray(j); } catch { /* 비JSON */ }
    });
  }
  mark() { return this.recs.length; }
  since(i: number) { return this.recs.slice(i); }
}

/** BE 응답에서 첫 행 배열 — BaseResponse{code,message,result:{o_rc1:[…]}} · result:[…] · data:[…] */
export function firstArray(j: unknown): Record<string, unknown>[] | null {
  if (!j || typeof j !== 'object') return null;
  if (Array.isArray(j)) return j as Record<string, unknown>[];
  const o = j as Record<string, unknown>;
  for (const k of ['result', 'data', 'rows']) {
    const v = o[k];
    if (Array.isArray(v)) return v as Record<string, unknown>[];
    if (v && typeof v === 'object') for (const x of Object.keys(v as object)) { const a = (v as Record<string, unknown>)[x]; if (Array.isArray(a) && !/columns/i.test(x)) return a as Record<string, unknown>[]; }
  }
  return null;
}

const CTLS = (tag: string) => `(() => { const root = document.querySelector('[data-e2e-pop=${J(tag)}]'); if (!root) return [];
  const out = []; for (const el of root.querySelectorAll('.wj-flexgrid')) { if (el.offsetParent === null) continue; let c = el['$WJ-CTRL']; if (!c || !c.columns) for (const k of Object.getOwnPropertyNames(el)) { const v = el[k]; if (v && typeof v === 'object' && v.columns && typeof v.columns.length === 'number') { c = v; break; } } if (c) out.push(c); } return out; })()`;

/** 열린 대화상자 중 가장 위를 표지. 없으면 null. 모달리스(role 없는 창)는 Close 버튼 조상으로 찾는다 */
export async function tagTop(page: Page, tag: string): Promise<Locator | null> {
  const ok = await page.evaluate(t => {
    const vis = (e: Element) => { const r = (e as HTMLElement).getBoundingClientRect(); return r.width > 200 && r.height > 80; };
    document.querySelectorAll(`[data-e2e-pop="${t}"]`).forEach(e => e.removeAttribute('data-e2e-pop'));
    const ds = Array.from(document.querySelectorAll('.MuiDialog-paper, [role="dialog"], .MuiPopover-paper')).filter(vis);
    const dlg = ds[ds.length - 1];
    if (dlg) { dlg.setAttribute('data-e2e-pop', t); return true; }
    for (const b of Array.from(document.querySelectorAll('button'))) {
      if (!vis(b.parentElement as Element) || !/^(Close|닫기)$/.test((b.innerText || '').trim())) continue;
      let p: Element | null = b.parentElement;
      for (let d = 0; p && d < 14; d++, p = p.parentElement) { if (p.querySelector('.wj-flexgrid') && vis(p)) { if (p === document.body) break; p.setAttribute('data-e2e-pop', t); return true; } }
    }
    return false;
  }, tag).catch(() => false);
  return ok ? page.locator(`[data-e2e-pop="${tag}"]`).first() : null;
}

export async function dialogCount(page: Page): Promise<number> {
  return page.evaluate(() => Array.from(document.querySelectorAll('.MuiDialog-paper, [role="dialog"], .MuiPopover-paper')).filter(e => { const r = (e as HTMLElement).getBoundingClientRect(); return r.width > 200 && r.height > 80; }).length).catch(() => -1);
}

/** 새 대화상자가 뜰 때까지(시간 상한) — 호출 전 dialogCount 를 넘겨야 뒤에 깔린 창을 새 팝업으로 오인하지 않는다 */
export async function waitPopup(page: Page, tag: string, before: number, ms = 12_000): Promise<Locator | null> {
  const t0 = Date.now();
  while (Date.now() - t0 < ms) {
    if ((await dialogCount(page)) > before) { const l = await tagTop(page, tag); if (l) { await page.waitForTimeout(300); return l; } }
    await page.waitForTimeout(250);
  }
  return null;
}

/** 팝업 전체 측정 — DOM·그리드 컨트롤·조건 칸. 조작 없음 */
export async function measure(page: Page, tag: string): Promise<PopMeasure | null> {
  return page.evaluate(`(() => {
    const root = document.querySelector('[data-e2e-pop=${J(tag)}]'); if (!root) return null;
    const R = e => { const r = e.getBoundingClientRect(); return { x: Math.round(r.left), y: Math.round(r.top), w: Math.round(r.width), h: Math.round(r.height) }; };
    const vis = e => { const r = e.getBoundingClientRect(); return r.width > 0 && r.height > 0 && getComputedStyle(e).visibility !== 'hidden'; };
    const head = root.querySelector('#draggable-dialog-title') || root.querySelector('h2, h1');
    const title = head ? ((head.querySelector('h2,h1') || head).innerText || '').trim() : '';
    const headRect = head ? head.getBoundingClientRect() : null;
    const svg = head ? [...head.querySelectorAll('svg')].filter(vis).pop() : null;
    const buttons = [...root.querySelectorAll('button')].filter(vis).filter(b => !b.closest('.wj-flexgrid')).map(b => ({ text: (b.innerText || b.getAttribute('aria-label') || b.getAttribute('title') || '').trim(), disabled: !!b.disabled, rect: R(b) })).filter(b => b.text);
    const paper = root;
    const ps = getComputedStyle(paper); // 실제 스크롤바 = overflow 허용 + 내용 초과(리사이즈 핸들의 작은 돌출은 스크롤바 폭이 생겨야 스크롤로 본다)
    const barV = paper.offsetWidth - paper.clientWidth - parseFloat(ps.borderLeftWidth) - parseFloat(ps.borderRightWidth) > 0, barH = paper.offsetHeight - paper.clientHeight - parseFloat(ps.borderTopWidth) - parseFloat(ps.borderBottomWidth) > 0;
    const scroll = { paperV: /(auto|scroll)/.test(ps.overflowY) && paper.scrollHeight > paper.clientHeight + 2 && barV, paperH: /(auto|scroll)/.test(ps.overflowX) && paper.scrollWidth > paper.clientWidth + 2 && barH, dH: paper.scrollHeight - paper.clientHeight, bodyV: [] };
    for (const e of root.querySelectorAll('*')) { if (e.closest('.wj-flexgrid')) continue; const s = getComputedStyle(e); if (/(auto|scroll)/.test(s.overflowY) && e.scrollHeight > e.clientHeight + 2 && e.clientHeight > 0) scroll.bodyV.push({ sel: String(e.className).slice(0, 60), sh: e.scrollHeight, ch: e.clientHeight }); }
    // 조건 칸 — FormItem(라벨 트랙 + 컨트롤)
    const conds = [];
    // ① 공용 FormItem(class formItem) ② MUI Box 형(label 의 조상 다음 형제에 입력) — 2026-10-31 실측: 공용 Item Popup 은 class 표지가 없다
    const pairs = [];
    for (const it of root.querySelectorAll('[class*="_formItem_"], [class*="formItem"]')) { if (!vis(it) || it.closest('.wj-flexgrid') || it.parentElement.closest('[class*="_formItem_"]')) continue; pairs.push({ item: it, lab: it.children.length >= 2 ? (it.firstElementChild.innerText || '') : '', part: it.children.length >= 2 ? it.children[1] : it }); }
    const inPair = e => pairs.some(x => x.item.contains(e));
    for (const l of root.querySelectorAll('label')) {
      if (!vis(l) || l.closest('.wj-flexgrid') || l.querySelector('input') || inPair(l)) continue;
      let up = l; for (let d = 0; up && up !== root && d < 5; d++, up = up.parentElement) { const nx = up.nextElementSibling; if (nx && vis(nx) && nx.querySelector('input:not([type="hidden"]), textarea, [role="combobox"]')) { pairs.push({ item: up.parentElement, lab: l.innerText || '', part: nx }); break; } }
    }
    const items = pairs.map(x => x.item);
    pairs.forEach((x, k) => {
      x.item.setAttribute('data-e2e-pc', String(k));
      const lab = x.lab.split(String.fromCharCode(10)).join(' ').split(String.fromCharCode(8203)).join(' ').split('*').join(' ').trim(); const part = x.part;
      const inputs = [...part.querySelectorAll('input:not([type="hidden"]), textarea')].filter(vis);
      const combos = [...part.querySelectorAll('[role="combobox"]')];
      const texts = inputs.filter(i => !['checkbox', 'radio'].includes(i.type) && !combos.includes(i));
      const radios = inputs.filter(i => i.type === 'radio').length, checks = inputs.filter(i => i.type === 'checkbox').length;
      const kind = radios ? 'radio' : combos.length ? 'combo' : checks && !texts.length ? 'check' : texts.length >= 2 || texts.some(i => /YYYY/i.test(i.placeholder || '')) ? 'period' : texts.length ? 'text' : 'other';
      const tgt = texts[0] || combos[0] || inputs[0];
      conds.push({ pc: k, label: lab, kind, disabled: !!(tgt ? tgt.disabled || tgt.closest('.Mui-disabled') : part.querySelector('.Mui-disabled')), readOnly: !!(tgt && tgt.readOnly), values: texts.map(i => i.value || '').concat(combos.map(c => (c.value !== undefined ? c.value : c.innerText) || '')), rect: R(x.item), n: inputs.length + combos.length, multi: !!part.querySelector('.MuiAutocomplete-tag, .MuiChip-root') });
    });
    // 머리 아래 ~ 첫 조건/그리드 위 사이 가로줄(팝업 상단 불필요 선)
    const contentTop = (() => { const c = [...items, ...root.querySelectorAll('.wj-flexgrid')].filter(vis).map(e => e.getBoundingClientRect().top); return c.length ? Math.min(...c) : Infinity; })();
    const lines = [];
    const W = root.getBoundingClientRect().width;
    if (headRect) for (const e of root.querySelectorAll('*')) {
      if (!vis(e) || e.closest('.wj-flexgrid') || (head && head.contains(e))) continue; const r = e.getBoundingClientRect(); if (r.width < W * 0.6) continue;
      const s = getComputedStyle(e);
      for (const [side, val, col, y] of [['top', s.borderTopWidth, s.borderTopColor, r.top], ['bottom', s.borderBottomWidth, s.borderBottomColor, r.bottom]]) {
        if (parseFloat(val) >= 1 && col !== 'rgba(0, 0, 0, 0)' && y >= headRect.top - 1 && y <= Math.min(contentTop + 2, headRect.bottom + 120)) lines.push({ y: Math.round(y - headRect.top), w: Math.round(r.width), color: col, cls: String(e.className).slice(0, 50), side, box: parseFloat(s.borderLeftWidth) >= 1 && parseFloat(s.borderRightWidth) >= 1 && parseFloat(s.borderTopWidth) >= 1 && parseFloat(s.borderBottomWidth) >= 1 });
      }
    }
    // 그리드
    const grids = [];
    for (const c of ${CTLS(tag)}) {
      const cols = []; for (let i = 0; i < c.columns.length; i++) { const x = c.columns[i]; cols.push({ binding: String(x.binding || ''), header: String(x.header || ''), visible: x.visible !== false, width: Math.round(x.renderWidth || x.width || 0), readOnly: !!x.isReadOnly, allowMerging: Number(x.allowMerging ? 1 : 0), dataType: Number(x.dataType || 0), hasMap: !!x.dataMap }); }
      const host = c.hostElement; const corner = host ? [...host.querySelectorAll('.wj-topleft .wj-cell')].map(e => (e.innerText || '').trim()).filter(Boolean) : [];
      grids.push({ rows: c.rows.length, cols, selectionMode: Number(c.selectionMode), isReadOnly: !!c.isReadOnly, allowSorting: c.allowSorting, allowMerging: Number(c.allowMerging || 0), corner, rowHeaderCols: c.rowHeaders ? c.rowHeaders.columns.length : 0, rowHeaderW: c.rowHeaders && c.rowHeaders.columns.length ? Math.round(c.rowHeaders.columns[0].renderWidth || 0) : 0, hasCheck: !!(host && host.querySelector('.wj-cells input[type="checkbox"], .wj-colheaders input[type="checkbox"], .wj-rowheaders input[type="checkbox"]')), frozen: Number(c.frozenColumns || 0) });
    }
    const rawText = (root.innerText || '');
    const noGrid = [...root.querySelectorAll('button, label, h1, h2, h3, h4, h5, span')].filter(e => !e.closest('.wj-flexgrid') && vis(e) && e.children.length === 0).map(e => (e.innerText || '').trim()).filter(Boolean);
    const underscore = [...new Set(noGrid.filter(t => /^_[^\\s_]/.test(t)))].slice(0, 12);
    const codes = [...new Set(noGrid.filter(t => /^(LBL|MSG|MNU)\\d{5}$/.test(t)))].slice(0, 12);
    const m = /(Total|총)\\s*[:：]?\\s*[\\d,]+|[\\d,]+\\s*(건|Rows?)\\b|\\(\\s*[\\d,]+\\s*\\/\\s*[\\d,]+\\s*\\)/i.exec(rawText);
    const sectionTitles = [...root.querySelectorAll('h3, h4, h5, [class*="sectionTitle"], [class*="subTitle"]')].filter(vis).map(e => { let p = e.parentElement, inside = false; for (let k = 0; p && p !== root && k < 4; k++, p = p.parentElement) { const s = getComputedStyle(p); if (parseFloat(s.borderTopWidth) >= 1 && parseFloat(s.borderLeftWidth) >= 1) { inside = true; break; } } return { text: (e.innerText || '').trim().slice(0, 60), insideBorder: inside }; });
    return { title, rect: R(root), vw: innerWidth, vh: innerHeight, closeIcon: svg ? R(svg) : null, buttons, scroll, lines, grids, conds, countText: m ? m[0] : '', rawText: rawText.slice(0, 800), underscore, codes, headH: headRect ? Math.round(headRect.height) : 0, sectionTitles };
  })()`) as Promise<PopMeasure | null>;
}

/** 팝업 그리드 행 — 표시 순서(collectionView 뷰 순서) · binding 전체 값 */
export async function popRows(page: Page, tag: string, max = 3000, gridIndex = 0): Promise<Record<string, string>[] | null> {
  return page.evaluate(`(() => { const c = ${CTLS(tag)}[${gridIndex}]; if (!c) return null; const o = []; for (let r = 0; r < c.rows.length && o.length < ${max}; r++) { const d = c.rows[r].dataItem; if (!d) continue; const x = {}; for (const k of Object.keys(d)) { const v = d[k]; if (v == null || typeof v === 'object' && !(v instanceof Date)) { x[k] = v == null ? '' : ''; continue; } x[k] = v instanceof Date ? v.toISOString() : String(v); } o.push(x); } return o; })()`) as Promise<Record<string, string>[] | null>;
}

export async function popRowCount(page: Page, tag: string, gridIndex = 0): Promise<number> {
  return page.evaluate(`(() => { const c = ${CTLS(tag)}[${gridIndex}]; return c ? c.rows.length : -1; })()`).catch(() => -1) as Promise<number>;
}

/** 표시 텍스트(첫 N행 · 보이는 컬럼 header→표시값) — dataMap·format 적용 후 */
export async function popDisplay(page: Page, tag: string, maxRows = 200, gridIndex = 0): Promise<{ headers: string[]; rows: string[][] } | null> {
  return page.evaluate(`(() => { const c = ${CTLS(tag)}[${gridIndex}]; if (!c) return null; const idx = []; const headers = []; for (let i = 0; i < c.columns.length; i++) { const x = c.columns[i]; if (x.visible !== false && x.binding) { idx.push(i); headers.push(String(x.header || x.binding)); } }
    const rows = []; for (let r = 0; r < c.rows.length && rows.length < ${maxRows}; r++) { rows.push(idx.map(i => { const v = c.getCellData(r, i, true); return v == null ? '' : String(v); })); } return { headers, rows }; })()`) as Promise<{ headers: string[]; rows: string[][] } | null>;
}

/** 팝업 안 조회 버튼. 없으면 false. 응답을 시간 상한까지 기다린다 */
export async function popSearch(page: Page, dlg: Locator, net: PopNet, ms = 45_000): Promise<{ clicked: boolean; recs: NetRec[]; timedOut: boolean }> {
  const b = dlg.getByRole('button', { name: /^(조회|Search)(\(F5\))?$/i }).first();
  if (!(await b.isVisible().catch(() => false))) return { clicked: false, recs: [], timedOut: false };
  const m = net.mark(); await b.click({ timeout: 5_000 }).catch(() => undefined);
  const r = await settle(page, net, m, ms);
  return { clicked: true, recs: r.recs, timedOut: r.timedOut };
}

/** 요청이 다 끝나고 quiet ms 동안 새 요청이 없을 때까지(시간 상한). 시간 초과는 timedOut=true — 부하 판단 재료(FAIL 재료 아님) */
export async function settle(page: Page, net: PopNet, from: number, ms = 45_000, quiet = 1_000): Promise<{ recs: NetRec[]; timedOut: boolean }> {
  const t0 = Date.now(); let last = Date.now(); let n = net.recs.length; let pend = net.pending;
  while (Date.now() - t0 < ms) {
    await page.waitForTimeout(150);
    if (net.recs.length !== n || net.pending !== pend) { n = net.recs.length; pend = net.pending; last = Date.now(); }
    if (net.pending === 0 && Date.now() - last > quiet) return { recs: net.since(from), timedOut: false };
  }
  return { recs: net.since(from), timedOut: true };
}

/** 그리드 행이 찰 때까지(시간 상한) — 응답 뒤 렌더 지연 */
export async function waitPopRows(page: Page, tag: string, ms = 5_000): Promise<number> {
  const t0 = Date.now(); let n = await popRowCount(page, tag);
  while (n <= 0 && Date.now() - t0 < ms) { await page.waitForTimeout(200); n = await popRowCount(page, tag); }
  return n;
}

/** 팝업 조건 칸 — 라벨 일치 칸의 Locator(첫 입력). 라벨 없으면 kind+순번 */
export async function condInput(dlg: Locator, cond: PopCond, idxAmongSame: number): Promise<Locator> {
  void idxAmongSame; const it = dlg.locator(`[data-e2e-pc="${cond.pc}"]`).first();
  return it.locator('input:not([type="hidden"]):not([type="checkbox"]):not([type="radio"]), textarea').first();
}

export async function setText(page: Page, loc: Locator, v: string): Promise<boolean> {
  try { await loc.click({ timeout: 3_000 }); await loc.fill(v, { timeout: 3_000 }); await page.waitForTimeout(150); return (await loc.inputValue().catch(() => '')) === v; } catch { return false; }
}

/** 팝업 행 고르기 — 'dbl' = 셀 더블클릭, 'ok' = 행 클릭(체크박스 있으면 체크) + 확인 버튼. rows = 0-base 행 */
export async function pickRows(page: Page, dlg: Locator, tag: string, rows: number[], how: 'dbl' | 'ok', opts: { ctrl?: boolean } = {}): Promise<{ picked: number; closed: boolean; okText: string; why: string }> {
  let picked = 0; let why = '';
  for (let k = 0; k < rows.length; k++) {
    const pt = await cellPoint(page, tag, rows[k]);
    if (!pt) { why = `행 ${rows[k]} 위치 확인 불가`; continue; }
    if (pt.check) { await page.mouse.click(pt.check.x, pt.check.y); picked++; await page.waitForTimeout(120); continue; }
    if (how === 'dbl') { await page.mouse.dblclick(pt.x, pt.y); picked++; }
    else { if (k > 0 && opts.ctrl) await page.keyboard.down('Control'); await page.mouse.click(pt.x, pt.y); if (k > 0 && opts.ctrl) await page.keyboard.up('Control'); picked++; }
    await page.waitForTimeout(120);
  }
  let okText = '';
  const hasCheckPick = await page.evaluate(`(() => { const c = ${CTLS(tag)}[0]; return !!(c && c.hostElement.querySelector('.wj-cells input[type="checkbox"], .wj-rowheaders input[type="checkbox"]')); })()`).catch(() => false);  /* 2026-11-20 T494(SCP0028 EG-ea38ffcb PICK_DBL): 공용 모달 체크박스는 행 머리(rowHeaders)에 있음(T148) · 측정 hasCheck 도 같음 */
  if (how === 'ok' || hasCheckPick) {
    const ok = dlg.getByRole('button', { name: /^(확인|OK|Confirm|Select|선택|Apply|적용)$/i }).first();
    if (await ok.isVisible().catch(() => false)) { okText = (await ok.innerText().catch(() => '')).trim(); await ok.click({ timeout: 5_000 }).catch(() => undefined); }
  }
  await page.waitForTimeout(800);
  const closed = !(await dlg.isVisible().catch(() => false));
  return { picked, closed, okText, why };
}

/** 행의 첫 보이는 데이터 셀 중심점 + 있으면 행 체크박스 — 그리드 hitTest 로 확인 */
export async function cellPoint(page: Page, tag: string, row: number): Promise<{ x: number; y: number; check: { x: number; y: number } | null } | null> {
  return page.evaluate(`(async () => { const c = ${CTLS(tag)}[0]; if (!c) return null; let colI = -1; for (let i = 0; i < c.columns.length; i++) { const x = c.columns[i]; if (x.visible !== false && x.binding && (x.dataType !== 3)) { colI = i; break; } } if (colI < 0) return null;
    c.scrollIntoView(${row}, colI); await new Promise(r => setTimeout(r, 200)); let el = c.cells.getCellElement(${row}, colI);
    /* 2026-11-26 R240(VMO 20261126153055_SELF_2): 스크롤 직후 셀이 아직 안 그려지면 null → 행 위치 확인 불가. probe.ts cellClasses 와 같이 최대 10회 다시 그린 뒤 읽음. 끝까지 없으면 null(호출부 why 유지) */
    for (let k = 0; k < 10 && !el; k++) { try { c.scrollIntoView(${row}, colI); c.refresh(false); } catch { /* 다시 그리기 실패는 다음 회차에서 */ } await new Promise(r => requestAnimationFrame(r)); await new Promise(r => setTimeout(r, 120)); el = c.cells.getCellElement(${row}, colI); }
    if (!el) return null; const r = el.getBoundingClientRect();
    let check = null; for (let i = 0; i < c.columns.length; i++) { const e2 = c.cells.getCellElement(${row}, i); const inp = e2 && e2.querySelector && e2.querySelector('input[type="checkbox"]'); if (inp) { const q = inp.getBoundingClientRect(); check = { x: q.left + q.width / 2, y: q.top + q.height / 2 }; break; } }
    /* 2026-11-07 T148: 공용 모달 multiCheckbox(useCheckbox) 는 체크박스를 행 헤더 패널(rowHeaders)에 그린다 — cells 만 보면 체크 없음으로 오인해 행 클릭+OK → 조건 칸 '' (SCP0131 COND:Model PICK_OK ERROR · 15:4x 단독 실측: rowheaders 체크 뒤 OK → 'AAEF1001I-A1-000' 반영) */
    if (!check && c.rowHeaders) { for (let i = 0; i < c.rowHeaders.columns.length; i++) { const e3 = c.rowHeaders.getCellElement(${row}, i); const inp = e3 && e3.querySelector && e3.querySelector('input[type="checkbox"]'); if (inp) { const q = inp.getBoundingClientRect(); check = { x: q.left + q.width / 2, y: q.top + q.height / 2 }; break; } } }
    return { x: r.left + r.width / 2, y: r.top + r.height / 2, check }; })()`).catch(() => null) as Promise<{ x: number; y: number; check: { x: number; y: number } | null } | null>;
}

export async function selectedRows(page: Page, tag: string): Promise<number> {
  return page.evaluate(`(() => { const c = ${CTLS(tag)}[0]; if (!c) return -1; let n = 0; for (let r = 0; r < c.rows.length; r++) if (c.rows[r].isSelected) n++; if (n) return n; const s = c.selectedRanges || []; const set = new Set(); for (const q of s) for (let r = q.topRow; r <= q.bottomRow; r++) set.add(r); return set.size; })()`).catch(() => -1) as Promise<number>;
}

/** 닫기 — Close/Cancel/X, 안 되면 Esc. 닫힘 여부 반환 */
export async function closePopup(page: Page, dlg: Locator): Promise<boolean> {
  const cb = dlg.getByRole('button', { name: /^(Close|닫기|Cancel|취소)$/i }).first();
  if (await cb.isVisible().catch(() => false)) await cb.click({ timeout: 3_000 }).catch(() => undefined);
  else { const x = dlg.locator('#draggable-dialog-title svg').last(); if (await x.isVisible().catch(() => false)) await x.click({ timeout: 3_000 }).catch(() => undefined); else await page.keyboard.press('Escape').catch(() => undefined); }
  await page.waitForTimeout(500);
  // 미저장 확인창
  if (await dlg.isVisible().catch(() => false)) { const yes = page.getByRole('button', { name: /^(확인|OK|Yes|예|Confirm)$/i }).last(); if (await yes.isVisible().catch(() => false)) await yes.click({ timeout: 2_000 }).catch(() => undefined); await page.waitForTimeout(300); }
  return !(await dlg.isVisible().catch(() => false));
}

/** 머리글 클릭 → 정렬 상태 · 첫 행 값 */
export async function clickPopHeader(page: Page, tag: string, binding: string): Promise<{ sort: string; first: string } | null> {
  const pt = await page.evaluate(`(async () => { const c = ${CTLS(tag)}[0]; if (!c) return null; const col = c.columns.getColumn(${J(binding)}); if (!col) return null; c.scrollIntoView(-1, col.index); await new Promise(r => setTimeout(r, 150)); const pn = c.columnHeaders; const el = pn.getCellElement(pn.rows.length - 1, col.index); if (!el) return null; const r = el.getBoundingClientRect(); return { x: r.left + r.width / 2, y: r.top + r.height / 2 }; })()`).catch(() => null) as { x: number; y: number } | null;
  if (!pt) return null;
  await page.mouse.click(pt.x, pt.y); await page.waitForTimeout(500);
  return page.evaluate(`(() => { const c = ${CTLS(tag)}[0]; const cv = c.collectionView; const d = cv && cv.sortDescriptions ? [...cv.sortDescriptions].map(s => s.property + (s.ascending ? ' ASC' : ' DESC')).join(',') : ''; const it = c.rows.length ? c.rows[0].dataItem : null; return { sort: d, first: it ? String(it[${J(binding)}] ?? '') : '' }; })()`).catch(() => null) as Promise<{ sort: string; first: string } | null>;
}

/** F3 정렬 스위치(선택 컬럼) + 머리글 클릭 2회 — 공용 DataGrid 팝업 규칙(DataGrid.tsx:1891 팝업만 F3/F4 자동 등록) */
export async function sortByF3(page: Page, tag: string, binding: string, row = 0): Promise<{ on: boolean; s1: string; s2: string; first1: string; first2: string } | null> {
  const pt = await page.evaluate(`(async () => { const c = ${CTLS(tag)}[0]; if (!c) return null; const col = c.columns.getColumn(${J(binding)}); if (!col) return null; c.scrollIntoView(${row}, col.index); await new Promise(r => setTimeout(r, 200)); let el = c.cells.getCellElement(${row}, col.index);
    for (let k = 0; k < 10 && !el; k++) { try { c.scrollIntoView(${row}, col.index); c.refresh(false); } catch { /* 2026-11-26 R240: 다시 그리기 실패는 다음 회차에서 */ } await new Promise(r => requestAnimationFrame(r)); await new Promise(r => setTimeout(r, 120)); el = c.cells.getCellElement(${row}, col.index); }
    if (!el) return null; const r = el.getBoundingClientRect(); return { x: r.left + r.width / 2, y: r.top + r.height / 2 }; })()`).catch(() => null) as { x: number; y: number } | null;
  if (!pt) return null;
  await page.mouse.click(pt.x, pt.y); await page.waitForTimeout(200); await page.keyboard.press('F3'); await page.waitForTimeout(400);
  const on = await page.evaluate(`(() => { const c = ${CTLS(tag)}[0]; const s = c && c._userSortEnabledBindings; return !!(s && s.has && s.has(${J(binding)})); })()`).catch(() => false) as boolean;
  const r1 = await clickPopHeader(page, tag, binding); const r2 = await clickPopHeader(page, tag, binding);
  return { on, s1: r1?.sort || '', s2: r2?.sort || '', first1: r1?.first || '', first2: r2?.first || '' };
}

/** F4 필터 — 아이콘 수 변화 · 첫 아이콘 편집기에서 값 1개만 선택 → 행수 · 건수 문구 · 해제. 측정 실패는 why */
export async function filterByF4(page: Page, dlg: Locator, tag: string): Promise<{ icons0: number; icons1: number; n0: number; n1: number; n2: number; count1: string; why: string }> {
  const icons = () => dlg.locator('.wj-elem-filter, .wj-glyph-filter').count().catch(() => 0);
  const n0 = await popRowCount(page, tag); const icons0 = await icons();
  await page.keyboard.press('F4'); await page.waitForTimeout(800);
  const icons1 = await icons(); const res = { icons0, icons1, n0, n1: -1, n2: -1, count1: '', why: '' };
  const act = icons1 > 0 ? icons1 : 0; if (!act) { res.why = 'F4 후 필터 아이콘 없음'; return res; }
  // 값 종류가 2개 이상인 컬럼의 아이콘을 찾는다(앞 컬럼 No 는 값이 전부 달라 부적합 — 두 번째 아이콘부터)
  // 보이는(그리드 영역 안) 아이콘 좌표 — 가상화·고정 컬럼으로 locator.click 이 막히는 경우가 있어 좌표 클릭(2026-10-31 실측 Timeout)
  const iconPts = await dlg.evaluate(e => { const g = e.querySelector('.wj-flexgrid') as HTMLElement | null; if (!g) return []; const gr = g.getBoundingClientRect(); return Array.from(e.querySelectorAll('.wj-elem-filter, .wj-glyph-filter')).map(i => { const r = (i as HTMLElement).getBoundingClientRect(); return { x: r.left + r.width / 2, y: r.top + r.height / 2, ok: r.width > 0 && r.left >= gr.left && r.right <= gr.right }; }).filter(q => q.ok); }).catch(() => [] as { x: number; y: number; ok: boolean }[]);
  if (!iconPts.length) { res.why = '보이는 필터 아이콘 좌표 없음'; return res; }
  const ip = iconPts[Math.min(1, iconPts.length - 1)];
  const icon = { click: async (_o?: unknown) => { await page.mouse.click(ip.x, ip.y); } };
  const editor = page.locator('.wj-columnfiltereditor').first();
  try {
    await icon.click({ timeout: 8_000 });
    // 편집기 생존 표본 — 열렸다 바로 닫히는지(대화상자 포커스 가두기 후보) 구분
    const seen: number[] = []; for (let k = 0; k < 16; k++) { seen.push(await editor.count().catch(() => 0)); if (seen[k] && k >= 5) break; await page.waitForTimeout(100); }
    if (!seen[seen.length - 1]) { res.why = `필터 편집기 ${seen.some(x => x) ? '열렸다 닫힘' : '안 열림'} 표본[${seen.join('')}] · 클릭점 (${Math.round(ip.x)},${Math.round(ip.y)}) · 지점 요소 ${await page.evaluate(([x, y]) => { const e = document.elementFromPoint(x, y); return e ? String(e.className || e.tagName).slice(0, 50) : ''; }, [ip.x, ip.y]).catch(() => '')}`; return res; }
    const items = editor.locator('.wj-listbox-item'); const cnt = await items.count();
    if (cnt < 2) { res.why = `필터 값 목록 ${cnt}개`; await page.keyboard.press('Escape'); return res; }
    const all = editor.locator('input[type="checkbox"]').first(); await all.click({ timeout: 3_000 }).catch(() => undefined); await page.waitForTimeout(150);
    // 전체 해제 상태에서 두 번째 값만
    const chk = items.nth(1).locator('input[type="checkbox"]').first(); await chk.click({ timeout: 3_000, force: true }).catch(() => undefined); await page.waitForTimeout(150);
    // 2026-11-16(SSP0020 EG-153fcc99 진단 18:4x · 값 목록 1,593개): 위 클릭이 시간 안에 안 되면 체크된 값이 0개라 Apply 가 비활성(wj-state-disabled)으로 남는다
    //   → 체크된 값이 없으면 목록에서 보이는 첫 값의 체크 칸을 요소 클릭으로 누른다(전체 해제 뒤 값 1개만 선택 — 원래 의도와 같음)
    if (!(await editor.locator('.wj-listbox-item input[type="checkbox"]:checked').count().catch(() => 0))) {
      await editor.evaluate(e => { const hb = e.getBoundingClientRect(); const boxes = Array.from(e.querySelectorAll('.wj-listbox-item input[type="checkbox"]')) as HTMLInputElement[]; const vis = boxes.filter(b => { const r = b.getBoundingClientRect(); return r.height > 0 && r.top >= hb.top && r.bottom <= hb.bottom; }); const t = vis[1] || vis[0] || boxes[0]; if (t) t.click(); }).catch(() => undefined);
      await page.waitForTimeout(300);
    }
    // 2026-11-16 SSP0020 EG-153fcc99(검사기 결함 · 진단 22:5x): 이 필터 편집기에는 '전체 선택' 칸이 따로 없어 첫 체크 칸 = 첫 값이다.
    //   위의 '전체 해제' 클릭이 실제로는 값 하나를 껐다 켜는 것이라 적용 직전 1,592/1,592 전부 선택 → 필터 무동작이었다.
    //   ListBox 컨트롤의 checkedItems 를 두 번째 값 1개로 맞춘다(사용자가 나머지를 모두 끄는 것과 같은 결과)
    await editor.evaluate(e => { const lb = e.querySelector('.wj-listbox') as unknown as Record<string, unknown> | null; if (!lb) return; let c = lb['$WJ-CTRL'] as Record<string, unknown> | undefined; if (!c) for (const k of Object.getOwnPropertyNames(lb)) { const v = lb[k] as Record<string, unknown>; if (v && typeof v === 'object' && 'checkedItems' in v) { c = v; break; } } const cv = c && (c.collectionView as Record<string, unknown> | undefined); const items = cv ? (cv.items as unknown[]) : []; if (c && items.length >= 2) c.checkedItems = [items[1]]; }).catch(() => undefined);
    await page.waitForTimeout(300);
    // 2026-11-16 진단(SSP0020 EG-153fcc99 적용 뒤 행 수 불변): 적용 직전 체크 상태·적용 뒤 필터 정의를 남긴다
    const chk0 = await editor.locator('.wj-listbox-item input[type="checkbox"]:checked').count().catch(() => -1); const allChk = await all.isChecked().catch(() => null);
    // 목록은 가상 스크롤 — 화면 밖 항목은 DOM 에 없으므로 ListBox 컨트롤의 checkedItems 로 실제 체크 수를 읽는다
    const lbChk = await editor.evaluate(e => { const lb = e.querySelector('.wj-listbox') as unknown as Record<string, unknown> | null; if (!lb) return 'no-lb'; let c = lb['$WJ-CTRL'] as Record<string, unknown> | undefined; if (!c) for (const k of Object.getOwnPropertyNames(lb)) { const v = lb[k] as Record<string, unknown>; if (v && typeof v === 'object' && 'checkedItems' in v) { c = v; break; } } if (!c) return 'no-ctrl'; const ci = c.checkedItems as unknown[] | undefined; const cv = c.collectionView as Record<string, unknown> | undefined; return `checked=${ci ? ci.length : '?'}/${cv ? (cv.items as unknown[]).length : '?'}`; }).catch(() => 'err');
    const allBox = await editor.evaluate(e => { const b = e.querySelector('input[type="checkbox"]') as HTMLInputElement | null; return b ? `${b.closest('.wj-listbox-item') ? 'item' : 'select-all'} checked=${b.checked} ind=${b.indeterminate}` : 'none'; }).catch(() => 'err');
    console.log(`[F4 진단-목록] ${tag} ${lbChk} · 첫 체크 칸 ${allBox}`);
    await editor.locator('a, button, [class*="wj-btn"]').filter({ hasText: /^\s*(Apply|적용|OK|확인)\s*$/i }).first().click({ timeout: 20_000 }); await page.waitForTimeout(700);  // 2026-11-16: 값 목록이 큰 컬럼은 체크 반영이 5초를 넘는다(SSP0020 8,060개)
    res.n1 = await popRowCount(page, tag);
    const fdef = await dlg.evaluate(e => { const g = e.querySelector('.wj-flexgrid') as unknown as Record<string, unknown> | null; if (!g) return ''; let c = g['$WJ-CTRL'] as Record<string, unknown> | undefined; if (!c) return 'no-ctrl'; const cv = c.collectionView as Record<string, unknown> | undefined; return `filter=${typeof (cv && cv.filter)} items=${cv && (cv.items as unknown[] | undefined)?.length} src=${cv && (cv.sourceCollection as unknown[] | undefined)?.length}`; }).catch(() => 'err');
    console.log(`[F4 진단] ${tag} 값 목록 ${cnt} · 적용 직전 체크 ${chk0} · 전체 칸 ${allChk} · 적용 뒤 행 ${res.n1} · ${fdef}`);
    res.count1 = await dlg.evaluate(e => { const m = /(Total|총)\s*[:：]?\s*[\d,]+(\s*\/\s*[\d,]+)?|\(\s*[\d,]+\s*\/\s*[\d,]+\s*\)|[\d,]+\s*\/\s*[\d,]+/i.exec((e as HTMLElement).innerText || ''); return m ? m[0] : ''; }).catch(() => '');
    await icon.click({ timeout: 8_000 }); await editor.waitFor({ state: 'visible', timeout: 10_000 });
    await editor.locator('a, button, [class*="wj-btn"]').filter({ hasText: /^\s*(Clear|지우기|초기화)\s*$/i }).first().click({ timeout: 5_000 }); await page.waitForTimeout(600);
    res.n2 = await popRowCount(page, tag);
  } catch (e) { res.why = String(e).replace(/\x1b\[[0-9;]*[A-Za-z]/g, '').replace(/\s+/g, ' ').slice(0, 160); // eslint-disable-line no-control-regex
    await page.keyboard.press('Escape').catch(() => undefined); }
  await page.keyboard.press('F4').catch(() => undefined); await page.waitForTimeout(300);
  return res;
}

/** 드래그(머리 잡기) 후 rect */
export async function dragPopup(page: Page, dlg: Locator, dx: number, dy: number): Promise<Rect | null> {
  const head = dlg.locator('#draggable-dialog-title').first(); const b = await head.boundingBox().catch(() => null); if (!b) return null;
  await page.mouse.move(b.x + b.width / 3, b.y + b.height / 2); await page.mouse.down();
  const steps = 12; for (let i = 1; i <= steps; i++) { await page.mouse.move(b.x + b.width / 3 + dx * i / steps, b.y + b.height / 2 + dy * i / steps); await page.waitForTimeout(25); }
  await page.mouse.up(); await page.waitForTimeout(200);
  const r = await dlg.boundingBox().catch(() => null); return r ? { x: Math.round(r.x), y: Math.round(r.y), w: Math.round(r.width), h: Math.round(r.height) } : null;
}

/** 오른쪽 아래 리사이즈 핸들 끌기 후 rect */
export async function resizePopup(page: Page, dlg: Locator, dx: number, dy: number): Promise<Rect | null> {
  const box = await dlg.boundingBox().catch(() => null); if (!box) return null;
  const hx = box.x + box.width - 4, hy = box.y + box.height - 4;
  const hit = await page.evaluate(([x, y]) => { const e = document.elementFromPoint(x as number, y as number); return e ? String((e as HTMLElement).className || '') : ''; }, [hx, hy]).catch(() => '');
  if (!/resize/i.test(hit)) return null;
  await page.mouse.move(hx, hy); await page.mouse.down();
  for (let i = 1; i <= 10; i++) { await page.mouse.move(hx + dx * i / 10, hy + dy * i / 10); await page.waitForTimeout(25); }
  await page.mouse.up(); await page.waitForTimeout(250);
  const r = await dlg.boundingBox().catch(() => null); return r ? { x: Math.round(r.x), y: Math.round(r.y), w: Math.round(r.width), h: Math.round(r.height) } : null;
}

/** 조회조건 FormItem 중 팝업형(텍스트 입력 + 아이콘/버튼) 칸 전수 — 메인 조회영역 */
export async function mainPopupConds(nscm: Nscm): Promise<{ label: string; value: string; idx: number; hasInput: boolean }[]> {
  await nscm.expandSearchArea(true).catch(() => undefined);
  return nscm.page.evaluate(() => {
    const vis = (e: Element) => { const r = (e as HTMLElement).getBoundingClientRect(); return r.width > 0 && r.height > 0 && (e as HTMLElement).offsetParent !== null; };
    const out: { label: string; value: string; idx: number; hasInput: boolean }[] = []; let k = 0;
    document.querySelectorAll('[data-e2e-mainpop]').forEach(e => e.removeAttribute('data-e2e-mainpop'));
    for (const it of Array.from(document.querySelectorAll('[class*="_formItem_"], [class*="formItem"]'))) {
      if (!vis(it) || it.closest('.wj-flexgrid, [role="dialog"], .MuiDialog-root') || it.parentElement?.closest('[class*="_formItem_"]') || it.children.length < 2) continue;
      const part = it.children[1]; const inp = part.querySelector('input:not([type="hidden"]):not([type="checkbox"]):not([type="radio"]), textarea') as HTMLInputElement | null;
      if (part.querySelector('[role="combobox"]')) continue;
      const trig = Array.from(part.querySelectorAll('button, [role="button"], svg')).filter(vis);
      if (!trig.length) continue;
      it.setAttribute('data-e2e-mainpop', String(k));
      out.push({ label: ((it.firstElementChild as HTMLElement).innerText || '').replace(/[​\n]/g, ' ').trim(), value: inp ? inp.value : '', idx: k++, hasInput: !!inp });
    }
    return out;
  }).catch(() => []);
}

export const mainPopRoot = (p: Page, idx: number) => p.locator(`[data-e2e-mainpop="${idx}"]`).first();

/** 팝업형 조회조건의 트리거 버튼(마지막 button/아이콘) */
export async function mainPopTrigger(p: Page, idx: number): Promise<Locator> {
  const root = mainPopRoot(p, idx);
  const b = root.locator('button, [role="button"]').last();
  if (await b.count().catch(() => 0)) return b;
  return root.locator('svg').last();
}

/** 메인 그리드(대화상자 밖 보이는 첫 그리드)의 표시 셀 값 */
export async function mainColumn(page: Page, binding: string, max = 3000): Promise<string[] | null> {
  return page.evaluate(`(() => { const el = [...document.querySelectorAll('.wj-flexgrid')].find(e => e.offsetParent !== null && !e.closest('.MuiDialog-root, [role="dialog"]')); if (!el) return null; let c = el['$WJ-CTRL']; if (!c || !c.columns) for (const k of Object.getOwnPropertyNames(el)) { const v = el[k]; if (v && typeof v === 'object' && v.columns && typeof v.columns.length === 'number') { c = v; break; } } if (!c) return null; const o = []; for (let r = 0; r < c.rows.length && o.length < ${max}; r++) { const d = c.rows[r].dataItem; o.push(d && d[${J(binding)}] != null ? String(d[${J(binding)}]) : ''); } return o; })()`) as Promise<string[] | null>;
}

/** 정렬 키 대조 — keys = 'A DESC, B' · 행은 dataItem. 값 비교 = 공백·특수문자 제외 대소문자 무시(SQL CI 정렬 근사). 키가 그리드에 없으면 unresolved 에 */
export function orderCheck(rows: Record<string, string>[], keysExpr: string): { checked: string[]; unresolved: string[]; violAt: number; viol: string } {
  const keys = keysExpr.split(',').map(s => s.trim()).filter(Boolean).map(k => { const desc = /\bDESC\b/i.test(k); const name = k.replace(/\b(ASC|DESC)\b/ig, '').replace(/^.*\./, '').replace(/[^A-Za-z0-9_]/g, '').toUpperCase(); return { name, desc }; });
  const norm = (v: string) => { const n = Number(v); return v !== '' && isFinite(n) ? n : String(v ?? '').toLowerCase().replace(/[^a-z0-9가-힣]/g, ''); };
  const have = new Set(rows.length ? Object.keys(rows[0]).map(k => k.toUpperCase()) : []);
  const res = { checked: [] as string[], unresolved: [] as string[], violAt: -1, viol: '' };
  const usable: { name: string; desc: boolean; real: string }[] = [];
  for (const k of keys) { if (!have.has(k.name)) { res.unresolved.push(k.name); break; } const real = Object.keys(rows[0]).find(x => x.toUpperCase() === k.name) as string; usable.push({ ...k, real }); res.checked.push(`${k.name}${k.desc ? ' DESC' : ''}`); }
  if (!usable.length) return res;
  for (let i = 1; i < rows.length; i++) {
    for (const k of usable) {
      const a = norm(rows[i - 1][k.real]); const b = norm(rows[i][k.real]);
      if (a === b) continue;
      if (a === '' || b === '') break;  // NULL/빈값 위치 차이(MSSQL 앞·Oracle 뒤)는 위반 아님(2026-10-28 판정 규칙)
      const cmp = typeof a === 'number' && typeof b === 'number' ? a - b : String(a) < String(b) ? -1 : 1;
      // 2026-11-20 T522(SCP0028 EG-017a5164): 위 norm 은 공백·기호를 지워 'Renault AS HQ_FR_RHE' → 'Renault AS_FR_FNS'(11번째 글자 공백 0x20 < 밑줄 0x5F, AS-IS·TO-BE 둘 다 이 순서)를
      //   'renaultashq…' > 'renaultasfr…' 로 보고 위반으로 판정했다. 공백·밑줄 등 기호는 DB 정렬에서 글자 앞에 오므로 기호를 남긴 비교(대소문자 무시 · '-'·''' 만 무시 = Windows 단어 정렬)도
      //   위반일 때만 위반으로 본다. 두 비교가 갈리는 행은 정렬 규칙(콜레이션) 차이라 위반 근거가 아니다
      if (typeof a !== 'number' || typeof b !== 'number') {
        const raw = (v: string) => String(v ?? '').toLowerCase().replace(/[-']/g, '');
        const ra = raw(rows[i - 1][k.real]); const rb = raw(rows[i][k.real]);
        const cmp2 = ra === rb ? 0 : ra < rb ? -1 : 1;
        if (cmp2 === 0 || (k.desc ? cmp2 > 0 : cmp2 < 0)) break;  // 기호를 남긴 비교로는 순서대로(또는 같음) — 위반 아님, 다음 행
      }
      if (k.desc ? cmp < 0 : cmp > 0) { res.violAt = i; res.viol = `${k.real}: ${i - 1}행 '${rows[i - 1][k.real]}' → ${i}행 '${rows[i][k.real]}'`; return res; }
      break;
    }
  }
  return res;
}

// ─── 변이(자기검증) — CL_POPMUT=kind,kind : 결함을 일부러 만들어 FAIL 검출을 확인한다. 평소 실행 무영향 ───
export const POPMUT = (process.env.CL_POPMUT || '').split(',').map(s => s.trim()).filter(Boolean);
export const hasMut = (k: string) => POPMUT.includes(k);

/** 요청·응답 변이 — popSheets 판정은 호출부가 켠 뒤(popupOpen=true)의 call-proc 만 대상 */
export async function installPopMutations(page: Page, state: { popup: boolean }): Promise<void> {
  if (!POPMUT.length) return;
  await page.route(/\/call-proc(?:-stream)?(?:\?|$)/, async route => {
    if (!state.popup || /\/(SAVE|INS|UPD|DEL)[^/]*\/call-proc/i.test(route.request().url())) return route.fallback();
    const req = route.request();
    let body = req.postData() || '';
    if (hasMut('nofilter')) { body = body.replace(/"(\w*(?:name|code|id|keyword|search|text|user|item|project|model|team|owner|version|desc)\w*)"\s*:\s*"(?!ALL|%)[^"]*"/gi, (m0, k: string) => /division|div|lang|menu|sheet|ses/i.test(k) ? m0 : `"${k}":"%"`); }
    if (hasMut('nofilter')) return route.continue({ postData: body });
    const res = await route.fetch();
    let j: unknown; try { j = await res.json(); } catch { return route.fulfill({ response: res }); }
    const arr = firstArray(j);
    if (arr && hasMut('reverse')) arr.reverse();
    if (arr && hasMut('empty')) arr.length = 0;
    // 조건 값에 소문자(대소문자 구별 DB 처럼) · 콤마(분해 안 함)이면 0행으로 응답
    if (arr && hasMut('casesens') && /"(itemId|projectCode|\w*(name|code|keyword|user)\w*)"\s*:\s*"[^"]*[a-z][^"]*"/i.test(body) && /"\w+"\s*:\s*"[^"]*[a-z]\d[^"]*"/.test(body)) arr.length = 0;
    if (arr && hasMut('commaoff') && /"\w+"\s*:\s*"[^"]+,[^"]+"/.test(body)) arr.length = 0;
    if (hasMut('http500')) return route.fulfill({ status: 500, contentType: 'application/json', body: '{"code":-1,"message":"mutated"}' });
    if (hasMut('nopermission')) return route.fulfill({ status: 200, contentType: 'application/json', body: '{"code":-1,"message":"No Permission"}' });
    return route.fulfill({ response: res, json: j as object });
  });
}

/** 열린 팝업 DOM·컨트롤 변이 */
export async function applyPopDomMutations(page: Page, tag: string): Promise<void> {
  if (!POPMUT.length) return;
  await page.evaluate(`(() => { const root = document.querySelector('[data-e2e-pop=${J(tag)}]'); if (!root) return; const M = ${J(POPMUT)};
    const h = root.querySelector('#draggable-dialog-title h2, h2'); if (M.includes('title_') && h) h.innerText = '_' + h.innerText;
    if (M.includes('titlewrong') && h) h.innerText = 'Zzz Wrong Popup';
    if (M.includes('btnorder')) { const bs = [...root.querySelectorAll('button')].filter(b => /^(OK|확인)$/i.test((b.innerText||'').trim()) || /^(Close|닫기|Cancel|취소)$/i.test((b.innerText||'').trim())); if (bs.length >= 2) bs[0].parentElement.insertBefore(bs[1], bs[0]); }
    if (M.includes('topline')) { const d = root.querySelector('#draggable-dialog-title'); if (d) { const n = document.createElement('div'); n.style.cssText = 'border-top:2px solid red;width:100%;height:1px'; d.after(n); } }
    if (M.includes('overflow')) { root.style.width = (innerWidth + 300) + 'px'; root.style.maxWidth = 'none'; root.style.height = (innerHeight + 300) + 'px'; root.style.maxHeight = 'none'; }
    if (M.includes('bodyscroll')) { const b = [...root.querySelectorAll('*')].find(e => (e.className || '').toString().includes('dialogCustomContentAreaWrapper')); if (b) { b.style.overflowY = 'auto'; b.style.maxHeight = '100px'; } }
    if (M.includes('nocorner')) { root.querySelectorAll('.wj-topleft .wj-cell').forEach(e => { e.innerText = 'Q'; }); for (const el of root.querySelectorAll('.wj-flexgrid')) { let c = el['$WJ-CTRL']; if (!c || !c.columns) for (const k of Object.getOwnPropertyNames(el)) { const v = el[k]; if (v && typeof v === 'object' && v.columns && typeof v.columns.length === 'number') { c = v; break; } } if (c) for (let i = 0; i < c.columns.length; i++) if (/^no\\.?$/i.test(String(c.columns[i].header || ''))) c.columns[i].header = 'Q'; } }
    if (M.includes('nocount')) { const re = /(Total|총)\\s*[:：]?\\s*[\\d,]+|[\\d,]+\\s*(건|Rows?)\\b|\\(\\s*[\\d,]+\\s*\\/\\s*[\\d,]+\\s*\\)/i; for (const e of [...root.querySelectorAll('*')].reverse()) { if (e.closest('.wj-flexgrid')) continue; if (re.test(e.innerText || '') && e.children.length <= 3 && (e.innerText || '').length < 30) { e.innerText = ''; } } }
    if (M.includes('undisable')) root.querySelectorAll('input:disabled').forEach(i => { i.disabled = false; });
    if (M.includes('disableall')) root.querySelectorAll('input:not([type="hidden"])').forEach(i => { i.disabled = true; });
    if (M.includes('multisel') || M.includes('singlesel')) { for (const el of root.querySelectorAll('.wj-flexgrid')) { let c = el['$WJ-CTRL']; if (!c || !c.columns) for (const k of Object.getOwnPropertyNames(el)) { const v = el[k]; if (v && typeof v === 'object' && v.columns && typeof v.columns.length === 'number') { c = v; break; } } if (c) c.selectionMode = M.includes('multisel') ? 5 : 3; } }
    if (M.includes('nomerge')) { for (const el of root.querySelectorAll('.wj-flexgrid')) { let c = el['$WJ-CTRL']; if (!c || !c.columns) for (const k of Object.getOwnPropertyNames(el)) { const v = el[k]; if (v && typeof v === 'object' && v.columns && typeof v.columns.length === 'number') { c = v; break; } } if (c) { c.allowMerging = 0; for (let i = 0; i < c.columns.length; i++) c.columns[i].allowMerging = false; } } }
    if (M.includes('editable')) { for (const el of root.querySelectorAll('.wj-flexgrid')) { let c = el['$WJ-CTRL']; if (!c || !c.columns) for (const k of Object.getOwnPropertyNames(el)) { const v = el[k]; if (v && typeof v === 'object' && v.columns && typeof v.columns.length === 'number') { c = v; break; } } if (c) { c.isReadOnly = false; for (let i = 0; i < c.columns.length; i++) c.columns[i].isReadOnly = false; } } }
    if (M.includes('sortoff')) { const stop = e => { if (e.target.closest && e.target.closest('.wj-colheaders')) { e.stopImmediatePropagation(); e.preventDefault(); } }; for (const t of ['mousedown', 'mouseup', 'click', 'pointerdown', 'pointerup']) root.addEventListener(t, stop, true); }
    if (M.includes('periodoff')) { const inp = [...root.querySelectorAll('input')].find(i => /^\\d{4}[.\\-\\/]?\\d{2}/.test(i.value || '')); if (inp) { const set = Object.getOwnPropertyDescriptor(HTMLInputElement.prototype, 'value').set; set.call(inp, '1999-01-01'); inp.dispatchEvent(new Event('input', { bubbles: true })); } }
  })()`).catch(() => undefined);
}
