// insertpre — AS-IS Insert 전제 시트(2026-11-10 T190). SSP0015·SSP0023·SSP0060 은 AS-IS Insert 가
//   'siDetail.IsLock(...) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail' 안에서만 행을 만들고(SSP0023 cs:1902),
//   TO-BE 도 같은 전제(ShipmentPlanElectrode.tsx:593 activeDetailSheet === PLAN_DETAIL)다. 검사기가 그 시트를 고르지 않고 Insert 해
//   신규 행이 없었고, 그 결과가 수백 건 FAIL 로 퍼졌다. Insert 문장이 있는 그 파일의 원문에서 문장 위쪽 시트 조건을 읽고,
//   같은 파일의 상수값으로 시트 이름을 푼다(actions.csv guard 는 잘려 있고 · 화면 전 파일에서 찾으면 팝업의 같은 이름 상수를 집는다 — SSP0024 'Project').
import * as fs from 'fs';
import * as path from 'path';
import { parseCsv } from './probe';
import { asisDeleteStmts, asisInsertRowConds } from './newrow';

const ROOT = path.join(__dirname, '..', '..', '..');
const INS_RX = /\.(Insert|AddRow|AddNew|AddNewRow|InsertRow)$/;

/** AS-IS Insert 가 요구하는 활성 시트 이름(원문 상수값) — 없거나 못 풀면 sheet='' */
export function asisInsertSheet(id: string): { sheet: string; ref: string } {
  try {
    const acts = parseCsv(fs.readFileSync(path.join(ROOT, 'Doc', 'asisfacts', 'screens', id, 'actions.csv'), 'utf8').replace(/^\uFEFF/, ''));
    const st = asisDeleteStmts(acts, 'InsertButton', 6, INS_RX); if (!st.length) return { sheet: '', ref: '' };
    const a = st[0].a; const file = String(a.file || '').replace(/\\/g, '/'); const line = Number(a.line || 0);
    const fp = ['GSCM', 'GSCM_20260512'].map(b => path.join(ROOT, b, file)).find(x => fs.existsSync(x)); if (!fp || !line) return { sheet: '', ref: '' };
    const src = fs.readFileSync(fp, 'utf8').split(/\r?\n/);
    let cname = '';
    for (let i = line - 1; i >= Math.max(0, line - 80) && !cname; i--) { const m = /SheetName\s*==\s*(?:\w+\.)*(\w+)/.exec(src[i] || ''); if (m) cname = m[1]; if (/\b(private|protected|public)\b[^;]*\(/.test(src[i] || '') && i < line - 1) break; }
    if (!cname) return { sheet: '', ref: '' };
    const v = new RegExp(`\\b${cname}\\s*=\\s*"([^"]+)"`).exec(src.join('\n'));
    return v ? { sheet: v[1], ref: `${a.method}:${line} · ${cname}="${v[1]}"` } : { sheet: '', ref: `${a.method}:${line} · ${cname}(상수값 미해석)` };
  } catch { return { sheet: '', ref: '' }; }
}

/** 2026-11-13 T303: 원문 줄 배열에서 line(1부터) 위쪽 80줄 안의 'SheetName == 상수' 상수 이름. 메서드 선언을 만나면 멈춘다. 없으면 '' */
export function sheetConstAbove(src: string[], line: number): string {
  for (let i = line - 1; i >= Math.max(0, line - 400); i--) { /* T310: 80 → 400줄(SSP0060 2641행의 조건은 2558행) */ const m = /SheetName\s*==\s*(?:\w+\.)*(\w+)/.exec(src[i] || ''); if (m) return m[1]; if (/\b(private|protected|public)\b[^;]*\(/.test(src[i] || '') && i < line - 1) break; }
  return '';
}

/** 2026-11-13 T303: Insert 문장 줄 번호들 → 시트 이름 목록(문장 순서, 중복 제거, 상수값을 못 푼 것은 제외) */
export function sheetsOfLines(src: string[], lines: number[]): string[] {
  const out: string[] = []; const all = src.join('\n');
  for (const ln of lines) { const c = sheetConstAbove(src, ln); if (!c) continue; const v = new RegExp(`\\b${c}\\s*=\\s*"([^"]+)"`).exec(all); if (v && !out.includes(v[1])) out.push(v[1]); }
  return out;
}

/** 2026-11-13 T303: AS-IS Insert 문장 전부의 활성 시트 이름(분기 순서). SSP0021 = ['Hold stock', 'Shipment Plan Detail'] 꼴. 못 풀면 [] */
export function asisInsertSheets(id: string): string[] {
  try {
    const acts = parseCsv(fs.readFileSync(path.join(ROOT, 'Doc', 'asisfacts', 'screens', id, 'actions.csv'), 'utf8').replace(/^\uFEFF/, ''));
    const st = asisDeleteStmts(acts, 'InsertButton', 6, INS_RX); if (!st.length) return [];
    const file = String(st[0].a.file || '').replace(/\\/g, '/');
    const fp = ['GSCM', 'GSCM_20260512'].map(b => path.join(ROOT, b, file)).find(x => fs.existsSync(x)); if (!fp) return [];
    const src = fs.readFileSync(fp, 'utf8').split(/\r?\n/);
    return sheetsOfLines(src, st.filter(x => String(x.a.file || '').replace(/\\/g, '/') === file).map(x => Number(x.a.line || 0)).filter(n => n > 0));
  } catch { return []; }
}

/** 2026-11-10 T197(SSP0060 F5·D6 4건): 신규 행 검사 말고도 Insert 를 누르는 모든 검사가 같은 전제를 맞추도록 — Insert 직전 호출.
 *  AS-IS 전제 시트가 있으면 탭을 열고 그 시트 컬럼을 가진 그리드를 고정한다. 반환 guard = AS-IS Insert 가 전제 guard 안에서만 동작하는지(신규 행 없음 판정 보류 근거) */
export async function prepInsert(nscm: { page: import('@playwright/test').Page }, id: string, clickTab: (n: never, name: string) => Promise<boolean>): Promise<{ sheet: string; guard: { guarded: boolean; guard: string; ref: string } }> {
  const { asisInsertGuard } = await import('./newrow');
  let guard = { guarded: false, guard: '', ref: '' };
  try { guard = asisInsertGuard(parseCsv(fs.readFileSync(path.join(ROOT, 'Doc', 'asisfacts', 'screens', id, 'actions.csv'), 'utf8').replace(/^﻿/, ''))); } catch { /* 사실 없음 */ }
  const sh = asisInsertSheet(id);
  // 탭만 연다 — 그리드 고정(pickGrid)은 시트 컬럼 목록을 아는 호출부가 한다
  const opened = !!sh.sheet && await clickTab(nscm as never, sh.sheet).catch(() => false);
  if (opened) await nscm.page.waitForTimeout(400);
  return { sheet: opened ? sh.sheet : '', guard };
}

/** 2026-11-10 T224(SSP0023 F1·F4 '수정한 내용이 없습니다' 허위 FAIL 다수): AS-IS Save 가 저장하는 시트.
 *  SSP0023 cs:2321 SaveButton → SaveData_Detail → 'siDetail.SheetName == SpdSheet.shtPlanDetail' 만 저장(메인 그리드 편집은 Save 대상 아님 — TO-BE 도 handleSave = PlanDetail 전용).
 *  SaveButton 본문 + 그 본문이 부르는 같은 파일 메서드(1단계)에서 'SheetName == 상수' 를 모아 하나로 정해질 때만 상수값으로 시트 이름을 푼다. 못 풀면 sheet='' */
export function asisSaveSheet(id: string): { sheet: string; ref: string } {
  try {
    const acts = parseCsv(fs.readFileSync(path.join(ROOT, 'Doc', 'asisfacts', 'screens', id, 'actions.csv'), 'utf8').replace(/^\uFEFF/, ''));
    const a = acts.find(x => x.method === 'SaveButton' && (x.variant || '') !== 'legacy' && x.file) || acts.find(x => x.method === 'SaveButton' && x.file);
    if (!a) return { sheet: '', ref: '' };
    const file = String(a.file || '').split(String.fromCharCode(92)).join('/');
    const fp = ['GSCM', 'GSCM_20260512'].map(b => path.join(ROOT, b, file)).find(x => fs.existsSync(x)); if (!fp) return { sheet: '', ref: '' };
    const src = fs.readFileSync(fp, 'utf8');
    const body = (name: string): string => { const m = new RegExp('(?:void|Task)\\s+' + name + '\\s*\\([^)]*\\)\\s*\\{').exec(src); if (!m) return ''; let d = 0; for (let i = m.index + m[0].length - 1; i < src.length; i++) { if (src[i] === '{') d++; else if (src[i] === '}') { d--; if (d === 0) return src.slice(m.index, i + 1); } } return ''; };
    const strip = (s: string) => s.replace(/\/\*[\s\S]*?\*\//g, '').replace(/\/\/[^\n]*/g, '');
    const sb = strip(body('SaveButton')); if (!sb) return { sheet: '', ref: '' };
    const calls = [...new Set([...sb.matchAll(/\b([A-Z]\w+)\s*\(/g)].map(m => m[1]).filter(n => n !== 'SaveButton'))];
    const texts = [sb, ...calls.map(n => strip(body(n))).filter(Boolean)];
    const names = new Set<string>(); for (const t of texts) for (const m of t.matchAll(/SheetName\s*==\s*(?:\w+\.)*(\w+)/g)) names.add(m[1]);
    if (names.size !== 1) return { sheet: '', ref: names.size ? `SaveButton 시트 조건 ${names.size}개(${[...names].join(',')}) — 하나로 정해지지 않음` : '' };
    const cname = [...names][0]; const v = new RegExp('(?<![A-Za-z0-9_])' + cname + '\\s*=\\s*"([^"]+)"').exec(src);
    return v ? { sheet: v[1], ref: `SaveButton→${calls.slice(0, 3).join('/')} · ${cname}="${v[1]}" (${path.basename(fp)})` } : { sheet: '', ref: `${cname}(상수값 미해석)` };
  } catch { return { sheet: '', ref: '' }; }
}

/** 2026-11-12 Y01(C1-01): Insert 를 눌렀는데 신규 행이 없을 때 — 보이는 그리드마다 행을 하나 선택(클릭)한 뒤 Insert 를 다시 눌러 본다.
 *  AS-IS 는 활성 행을 원본으로 쓰고(조회 직후 항상 있음) TO-BE 는 선택 행이 없으면 조용히 중단한다 → 검사기가 그 '활성 행' 을 만든다.
 *  AS-IS 가 활성 행 값 조건(asisInsertRowConds — 예 SHIPMENT_STATUS == "C")을 두면 그 값을 가진 행을 먼저 고른다(그 컬럼이 그리드에 있을 때만).
 *  어느 시도에서든 신규 행(CRUD_TYPE 'I')이 생기면 그 그리드의 시트 이름과 시도 내역을 돌려준다. 끝까지 없으면 made=false + 시도 내역(증거용).
 *  편집 버튼은 누르지 않는다(TO-BE 상시 편집 · CR-084·CR-093). 저장하지 않는다. */
async function retryInsertOnce(nscm: { page: import('@playwright/test').Page; subButton: (n: string) => import('@playwright/test').Locator; clearDialogs: () => Promise<unknown> }, id: string): Promise<{ made: boolean; sheet: string; trail: string[] }> {
  const p = nscm.page; const trail: string[] = []; let conds: { col: string; val: string; ref: string }[] = [];
  try { conds = asisInsertRowConds(parseCsv(fs.readFileSync(path.join(ROOT, 'Doc', 'asisfacts', 'screens', id, 'actions.csv'), 'utf8').replace(/^\uFEFF/, ''))); } catch { /* 사실 없음 */ }
  const SHEET = `const sheetOf = el => { let f = null; for (let n = el; n && !f; n = n.parentElement) { const k = Object.keys(n).find(z => z.startsWith('__reactFiber$')); if (k) f = n[k]; } for (let i = 0; f && i < 80; i++, f = f.return) { const pr = f.memoizedProps; if (pr && typeof pr === 'object') { const s = (pr.layoutKey && pr.layoutKey.sheetName) || pr.sheetName; if (typeof s === 'string' && s) return s; } } return ''; };`;
  const GRIDS = `[...document.querySelectorAll('.wj-flexgrid')].filter(e => e.offsetParent !== null).map(e => ({ e, c: e['$WJ-CTRL'] })).filter(x => x.c && x.c.columns)`;
  const hasNew = () => p.evaluate(`(() => { ${SHEET} for (const x of ${GRIDS}) { for (let r = 0; r < x.c.rows.length; r++) { const d = x.c.rows[r].dataItem; if (d && d.CRUD_TYPE === 'I') return { sheet: sheetOf(x.e), row: r }; } } return null; })()`).catch(() => null) as Promise<{ sheet: string; row: number } | null>;
  const plan = await p.evaluate(`(() => { ${SHEET} const conds = ${JSON.stringify(conds)}; const out = []; const gs = ${GRIDS}; for (let gi = 0; gi < gs.length; gi++) { const c = gs[gi].c; const n = c.rows.length; if (!n) continue; let col = -1; for (let i = 0; i < c.columns.length; i++) { const x = c.columns[i]; if (x.visible !== false && x.binding) { col = i; break; } } if (col < 0) continue; const rows = []; for (const k of conds) { const cc = c.columns.getColumn(k.col); if (!cc) continue; for (let r = 0; r < Math.min(n, 2000); r++) { const d = c.rows[r].dataItem; if (d && String(d[k.col] == null ? '' : d[k.col]).trim() === k.val) { rows.push({ row: r, why: k.col + '=' + k.val + '(' + k.ref + ')' }); break; } } } rows.push({ row: 0, why: '첫 행' }); out.push({ gi, sheet: sheetOf(gs[gi].e), col, rows }); } return out; })()`).catch(() => []) as { gi: number; sheet: string; col: number; rows: { row: number; why: string }[] }[];
  if (!plan.length) { trail.push('행이 있는 그리드 없음'); return { made: false, sheet: '', trail }; }
  for (const g of plan) for (const rr of g.rows) {
    const pt = await p.evaluate(`(() => { const x = ${GRIDS}[${g.gi}]; if (!x) return null; const c = x.c; c.scrollIntoView(${rr.row}, ${g.col}); c.select(${rr.row}, ${g.col}); const r = c.cells.getCellBoundingRect(${rr.row}, ${g.col}); return r ? { x: r.left + Math.min(r.width / 2, 20), y: r.top + r.height / 2 } : null; })()`).catch(() => null) as { x: number; y: number } | null;
    if (pt) { await p.mouse.click(pt.x, pt.y).catch(() => undefined); await p.waitForTimeout(250); }
    await nscm.subButton('Insert').click({ timeout: 10_000 }).catch(() => undefined); await p.waitForTimeout(900);
    const dlg = ((await p.locator('[role="dialog"], [role="alertdialog"]').first().innerText({ timeout: 400 }).catch(() => '')) || '').replace(/\s+/g, ' ').slice(0, 60); await nscm.clearDialogs().catch(() => undefined);
    const nw = await hasNew();
    trail.push(`'${g.sheet || '그리드 ' + g.gi}' ${rr.why} 선택 후 Insert → ${nw ? "신규 행 생김('" + (nw.sheet || '?') + "' r" + nw.row + ')' : '신규 행 없음' + (dlg ? ' · 알림 ' + dlg : '')}`);
    if (nw) return { made: true, sheet: nw.sheet, trail };
  }
  return { made: false, sheet: '', trail };
}

/** 2026-11-13 T303: 첫 시도에서 신규 행이 없고 AS-IS Insert 분기 시트가 둘 이상이면 분기 시트 탭을 하나씩 열어 같은 시도를 되풀이한다.
 *  TO-BE 가 분기 하나만 편집 시트로 둔 화면(SSP0021 = Plan Detail)에서 첫 분기 탭(Hold stock)만 눌러 보고 끝내지 않도록. 저장하지 않는다. */
export async function retryInsertWithRow(nscm: { page: import('@playwright/test').Page; subButton: (n: string) => import('@playwright/test').Locator; clearDialogs: () => Promise<unknown> }, id: string): Promise<{ made: boolean; sheet: string; trail: string[] }> {
  let r0 = await retryInsertOnce(nscm, id); if (r0.made) return r0;
  // 2026-11-14 T304: 행 선택으로 하위 그리드가 채워지는 화면(SSP0023 Plan Detail 은 그 그리드의 선택 행이 원본, ShipmentPlanElectrode.tsx:601)은 첫 시도 때 하위 그리드가 0행이라 대상에 없다. 행 수가 늘었으면 한 번 더 시도한다
  { const n0 = r0.trail.length; await nscm.page.waitForTimeout(1_500); const r1 = await retryInsertOnce(nscm, id); if (r1.made) return { made: true, sheet: r1.sheet, trail: [...r0.trail, '[2차 시도 T304]', ...r1.trail] }; if (r1.trail.length > n0) r0 = { made: false, sheet: '', trail: [...r0.trail, '[2차 시도 T304]', ...r1.trail] }; }
  /* 2026-11-14 T312: 실패 증거에 그리드 행 수와 탭 수를 남긴다(하위 그리드 0행 = 측정 전제 부족을 증거로 가름) */
  const pre = async (): Promise<string> => { const s = await nscm.page.evaluate(() => { const g = Array.from(document.querySelectorAll('.wj-flexgrid')).filter(e => (e as HTMLElement).offsetParent !== null).map(e => { const c = (e as unknown as Record<string, { rows?: { length: number } }>)['$WJ-CTRL']; return c && c.rows ? c.rows.length : -1; }); const tb = Array.from(document.querySelectorAll('[role="tab"]')).filter(e => (e as HTMLElement).offsetParent !== null).length; return { g, tb }; }).catch(() => null); return s ? `[전제 T312] 보이는 그리드 행 수 ${s.g.join(', ')} · 탭 ${s.tb}개` : '[전제 T312] 그리드 상태 읽기 실패'; };
  const sheets = asisInsertSheets(id); if (sheets.length < 2) { r0.trail.unshift(await pre()); return r0; }
  const trail = [...r0.trail]; const p = nscm.page;
  for (const s of sheets) {
    const rx = new RegExp(`^\\s*${s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}\\s*$`, 'i'); const tab = p.getByRole('tab', { name: rx }).first();
    if (!(await tab.isVisible({ timeout: 1_200 }).catch(() => false))) { trail.push(`AS-IS Insert 분기 시트 '${s}' 탭 없음(T303)`); continue; }
    await tab.click({ timeout: 3_000 }).catch(() => undefined); await p.waitForTimeout(800); trail.push(`AS-IS Insert 분기 시트 '${s}' 탭 선택(T303)`);
    const r = await retryInsertOnce(nscm, id); trail.push(...r.trail); if (r.made) return { made: true, sheet: r.sheet, trail };
  }
  trail.unshift(await pre());   // 앞에 둔다: 호출부(nscm.clickInsert)가 500자에서 자른다
  return { made: false, sheet: '', trail };
}
