// E03 Division·권한 순회 검사(@eg-auth · 2026-10-31) — 공식 체인(_verify·_trace) 밖의 독립 스펙. 결과 = CL_RESULTS(eg_auth 결과 JSON, EgRes[]).
//   화면 = VERIFY_ID. 대상·기대 = Doc/verify/_parallel/E03/facts/<ID>.json(facts_auth.py: AS-IS 원문·사내 DB). 저장 없음(VERIFY_NO_SAVE=1 전제 — 없으면 시작하지 않는다).
//   변이 = EG_MUT=<종류>: 결함을 일부러 만든 상태에서 FAIL 이 나는지 확인. 계정 ID 는 결과·로그에 쓰지 않는다.
import { measurable } from '../../../tools/E2E/lib/precond';
import * as fs from 'node:fs';
import * as path from 'node:path';
import { test } from '../../../tools/E2E/fixtures/test';
import { evalRules, parseRules, type Rule } from '../../../tools/E2E/lib/condeval';
import { GRID, accountId, buttonSnapshot, condOptions, condSnapshot, ctxOf, distinctAccounts, divState, expectState, findMerged, gridState, groupStates, isDivLabel, labelKey, loadFacts, selectDiv, sessionMenus, watchStatus, type Account, type EgRes, type Facts, type Verdict } from '../../../tools/E2E/lib/authprobe';
import { parseCsv, probe } from '../../../tools/E2E/lib/probe';
import { CFG, type Nscm } from '../../../tools/E2E/lib/nscm';
import { ensureRows } from '../../../tools/E2E/lib/smoke-extra';

const ID = (process.env.VERIFY_ID || '').toUpperCase();
const MUT = process.env.EG_MUT || '';
const OUT = process.env.CL_RESULTS || '';
const F: Facts | null = ID ? loadFacts(ID) : null;
// 2026-11-06(SCP0084 EG366 허위 FAIL): AS-IS Division 콤보가 헬퍼 필터를 얹은 경우(BLUtils.GetDivisionWithoutEE = ATTRIBUTE3 <> 'EE' ·
//   GetDivisionESS = ATTRIBUTE3 = '82' — facts_combosrc.py 가 asisfacts/screens/<ID>/combo_src.csv filters 에 기록) 기대 후보도 같은 필터로 줄인다.
//   ATTRIBUTE3 = Doc/tobefacts/db/division.csv. 필터·원장이 없으면 종전대로(권한 Division 전체).
const DIV_FILTER: { note: string; keep: (d: string) => boolean } | null = (() => {
  try {
    const src = parseCsv(fs.readFileSync(path.join(__dirname, '..', '..', 'asisfacts', 'screens', ID, 'combo_src.csv'), 'utf8').replace(/^﻿/, ''));
    const row = src.find(r => r.target_kind === 'SEARCH' && /division/i.test(`${r.target} ${r.code}`) && /ATTRIBUTE3/i.test(r.filters || ''));
    const m = row && /ATTRIBUTE3\s*(<>|!=|=)\s*'([^']*)'/i.exec(row.filters || '');
    if (!m) return null;
    const attr = new Map(parseCsv(fs.readFileSync(path.join(__dirname, '..', '..', 'tobefacts', 'db', 'division.csv'), 'utf8').replace(/^﻿/, '')).map(d => [d.division_id, d.attribute3 || '']));
    const neg = m[1] !== '='; const v = m[2];
    return { note: `AS-IS 필터 ${row!.filters.split(' @')[0]}(${row!.ref || ''})`, keep: (d: string) => (attr.has(d) ? (neg ? attr.get(d) !== v : attr.get(d) === v) : true) };
  } catch { return null; }
})();
const results: EgRes[] = [];
// P1(2026-11-06 근본 보완): 측정 맥락 — 이 테스트에서 지금까지 나간 call-proc 수·조회 응답 최대 행·필수 조건 자동 채움 횟수. judge 가 '측정 전제 미충족' FAIL 을 ERROR 로 돌리는 근거
const CUR: { nscm: Nscm | null } = { nscm: null };
const mctxOf = () => { const n = CUR.nscm; if (!n) return undefined; const rows = n.calls.reduce((m, c) => Math.max(m, c.rows == null ? -1 : Number(c.rows)), -1); return { calls: n.calls.length, rows, req: (n as unknown as { requiredNotes?: string[] }).requiredNotes?.length || 0 }; };
const put = (eg: string, target: string, ctx: string, result: Verdict, expected: string, actual: string, asis = '', note = '') => { results.push({ eg, screen: ID, target, ctx, result, expected, actual, asis, note, mctx: mctxOf() } as EgRes); };
const flush = () => {
  if (!OUT) return; const prev: EgRes[] = fs.existsSync(OUT) ? JSON.parse(fs.readFileSync(OUT, 'utf8')) : [];
  fs.mkdirSync(path.dirname(OUT), { recursive: true }); fs.writeFileSync(OUT, JSON.stringify([...prev, ...results], null, 1), 'utf8'); results.length = 0;
};
const sum = () => { const c: Record<string, number> = {}; for (const r of results) { const k = `${r.eg} ${r.result}`; c[k] = (c[k] || 0) + 1; } console.log('[eg_auth]', ID, JSON.stringify(c)); for (const r of results.filter(x => x.result === 'FAIL' || x.result === 'ERROR').slice(0, 30)) console.log(`  ${r.eg} ${r.result} ${r.target} [${r.ctx}] 기대 ${r.expected.slice(0, 70)} · 실측 ${r.actual.slice(0, 90)} · ${r.asis} ${(r.note || '').slice(0, 80)}`); };

// ── 변이: 라우트·XHR 은 화면 진입 전에, DOM 은 측정 직전에 ─────────────────────────────
async function installMut(nscm: Nscm) {
  const p = nscm.page;
  if (MUT === 'div_param') await p.addInitScript(() => { const s = XMLHttpRequest.prototype.send; XMLHttpRequest.prototype.send = function (b?: Document | XMLHttpRequestBodyInit | null) { if (typeof b === 'string' && /division/i.test(b)) b = b.replace(/("division(?:Id)?"\s*:\s*")[^"]*/i, '$1ZZ_MUT'); return s.call(this, b as never); }; });
  if (MUT === 'div_leak') await p.route(/\/admin\/combo(\?|$)/, async r => { const body = r.request().postData() || ''; const res = await r.fetch(); if (!/"comboId"\s*:\s*"\w*Division/i.test(body)) return r.fulfill({ response: res }); const j = await res.json().catch(() => null); const key = j?.result ? 'result' : 'data'; const a = j?.[key]; if (Array.isArray(a) && a[0]) { const k = Object.keys(a[0]); const row: Record<string, string> = {}; for (const x of k) row[x] = /name/i.test(x) ? 'ZZ_MUT Leak' : 'ZZ_MUT'; a.push(row); } return r.fulfill({ response: res, json: j }); });
  if (MUT === 'menu_leak') await p.route(/\/user\/session/, async r => { const res = await r.fetch(); const j = await res.json().catch(() => null); if (j?.result?.menus?.[0]) { const m0 = j.result.menus[0]; (m0.children = m0.children || []).push({ mnuId: 'ZZ_MUT_MENU', upprMnuId: m0.mnuId, mnuUrl: 'zz', routePath: 'zz', mnuMsgId: '', mnuDesc: 'zz', sortOrd: 99, favorite: false }); } return r.fulfill({ response: res, json: j }); });
}
async function mutDom(nscm: Nscm, stage: string, arg: { label?: string; binding?: string } = {}) {
  const p = nscm.page;
  if (MUT === 'cond_enable' && stage === 'snap') await p.evaluate(() => { for (const i of Array.from(document.querySelectorAll('[class*="_formItem_"] input[disabled], [class*="_formItem_"] button[disabled]')) as HTMLInputElement[]) { i.disabled = false; i.closest('.Mui-disabled')?.classList.remove('Mui-disabled'); i.classList.remove('Mui-disabled'); } });
  if (MUT === 'cond_disable' && stage === 'snap') await p.evaluate(() => { for (const i of Array.from(document.querySelectorAll('[class*="_formItem_"] input')) as HTMLInputElement[]) if (!/div/i.test(i.closest('[class*="_formItem_"]')?.textContent || '')) i.disabled = true; });
  if (MUT === 'cond_hide' && stage === 'snap') await p.evaluate(() => { const a = Array.from(document.querySelectorAll('[class*="_formItem_"]')) as HTMLElement[]; for (const e of a) if (!/^\s*div/i.test(e.innerText)) e.style.display = 'none'; });
  if (MUT === 'btn_hide' && stage === 'snap') await p.evaluate(() => { for (const b of Array.from(document.querySelectorAll('button')) as HTMLElement[]) if (!b.closest('nav, .wj-flexgrid, [class*="_formItem_"], [class*="_tab_"]') && !/search|조회/i.test(b.innerText)) b.style.display = 'none'; });
  if (MUT === 'col_drop' && stage === 'back') await p.evaluate(`(() => { const el = [...document.querySelectorAll('.wj-flexgrid')].find(e => e.offsetParent !== null); let c = el && el['$WJ-CTRL']; if (!c && el) for (const k of Object.getOwnPropertyNames(el)) { const v = el[k]; if (v && v.columns) { c = v; break; } } if (c) for (let i = c.columns.length - 1; i >= 0; i--) if (c.columns[i].binding && c.columns[i].visible !== false) { c.columns[i].visible = false; break; } })()`);
  if (MUT === 'auth401' && stage === 'walk-start') await p.route(/\/admin\/combo(\?|$)/, r => r.fulfill({ status: 401, contentType: 'application/json', body: '{"code":"-9998","message":"mut"}' }));
  if (MUT === 'auth401' && stage === 'walk-end') await p.unroute(/\/admin\/combo(\?|$)/).catch(() => undefined);
  if (MUT === 'btn_show' && stage === 'snap') { const labels = [...new Set(groupStates(F as Facts).filter(g => g.isButton && g.prop === 'visible').flatMap(g => g.labels))]; await p.evaluate((ls: string[]) => { document.querySelectorAll('[data-eg-mut]').forEach(e => e.remove()); const host = document.querySelector('[class*="SubTitle"], [class*="subTitle"]') || document.body; for (const l of ls) { const b = document.createElement('button'); b.textContent = l; b.setAttribute('data-eg-mut', '1'); host.appendChild(b); } }, labels); }
  if (MUT === 'div_stale' && stage === 'acct-open') await p.evaluate(() => { for (const e of Array.from(document.querySelectorAll('[class*="_formItem_"]')) as HTMLElement[]) { if (/^\s*div/i.test(e.innerText)) { const i = e.querySelector('input') as HTMLInputElement | null; if (i) { const set = Object.getOwnPropertyDescriptor(HTMLInputElement.prototype, 'value')?.set; set?.call(i, 'ZZ_MUT Residue'); i.setAttribute('value', 'ZZ_MUT Residue'); } } } });
  if (MUT === 'btn_late' && stage === 'acct-open') await p.evaluate(() => { for (const b of Array.from(document.querySelectorAll('button')) as HTMLElement[]) if (/^(Save|Insert|Delete)/i.test(b.innerText)) { b.setAttribute('data-eg-hid', '1'); b.style.display = 'none'; } });
  if (MUT === 'btn_late' && stage === 'acct-after') await p.evaluate(() => { for (const b of Array.from(document.querySelectorAll('[data-eg-hid]')) as HTMLElement[]) b.style.display = ''; });
  if (MUT === 'row_div' && stage === 'rows') await p.evaluate(`(() => { const c = ${GRID}; if (c && c.rows[0] && c.rows[0].dataItem) { const d = c.rows[0].dataItem; for (const k of Object.keys(d)) if (/^DIVISION(_ID)?$/i.test(k)) d[k] = 'ZZ_MUT'; } })()`);
  if (MUT === 'edit_lock' && stage === 'edit') await p.evaluate(`(() => { const c = ${GRID}; if (c) c.isReadOnly = true; })()`);
  if (MUT === 'sort_lost' && stage === 'after-insert') await p.evaluate(`(() => { const c = ${GRID}; if (c && c.collectionView) c.collectionView.sortDescriptions.clear(); })()`);
  if (MUT === 'ins_bottom' && stage === 'after-insert') await p.evaluate(`(() => { const c = ${GRID}; const cv = c && c.collectionView; if (!cv) return; const a = cv.sourceCollection; const i = a.findIndex(x => x && x.CRUD_TYPE === 'I'); if (i >= 0) { const [x] = a.splice(i, 1); a.push(x); cv.refresh(); } })()`);
  if (MUT === 'hdr_flat' && stage === 'hdr') await p.evaluate(`(() => { const c = ${GRID}; if (c) c.allowMerging = 0; })()`);
  if (MUT === 'sort_shuffle' && stage === 'sort') await p.evaluate(`(() => { const c = ${GRID}; const cv = c && c.collectionView; if (cv && cv.sourceCollection && cv.sourceCollection.length > 3) { const a = cv.sourceCollection; const x = a.splice(0, 1)[0]; a.splice(2, 0, x); const y = a.pop(); a.splice(1, 0, y); cv.refresh(); } })()`);
  void arg;
}

/** edit_expect RULES 의 RAW 중 의미가 확정된 형태만 COL/TRUE 로 — EditFlag 는 행 값 · Action 공란 = 기존행 */
const rewriteRaw = (c: string) => c.replace(/RAW\(si\w+\.GetValue\(iRow, si\w+\.GetColumnIndex\(DefColumns\.(\w+)\)\)\.ToString\(\) == CAppSetting\.StringY\)/g, (_m, n: string) => `COL(${n.replace(/([a-z])([A-Z0-9])/g, '$1_$2').toUpperCase()})==\\"Y\\"`).replace(/RAW\(String\.IsNullOrEmpty\(si\w+\.GetText\(iRow, si\w+\.GetColumnIndex\(CAppSetting\.StringAction\)\)\) == true\)/g, 'TRUE');
const listHas = (lst: string, d: string) => { const v = (lst || '').trim(); return !v || v.split(',').map(s => s.trim()).includes(d); };
/** 메타 기대 컬럼 — Div 해당·VALID·VISIBLE·DEFAULT. 시트 = 지금 보이는 바인딩과 가장 많이 겹치는 시트 */
function metaSheet(f: Facts, visible: string[]): string {
  const up = new Set(visible.map(v => v.toUpperCase())); const score = new Map<string, number>();
  for (const c of f.db.columns) if (up.has((c.column_name || '').toUpperCase())) score.set(c.sheet_name, (score.get(c.sheet_name) || 0) + 1);
  return [...score.entries()].sort((a, b) => b[1] - a[1])[0]?.[0] || '';
}
function metaCols(f: Facts, sheet: string, d: string): string[] {
  return f.db.columns.filter(c => c.sheet_name === sheet && c.valid_yn === 'Y' && c.visible_flag === 'Y' && c.default_flag === 'Y' && listHas(c.division_id, d)).map(c => c.column_name.toUpperCase());
}

test.describe(`E03 Division·권한 ${ID} @eg-auth`, () => {
  test.beforeEach(({ nscm }) => { CUR.nscm = nscm; });
  test.describe.configure({ retries: 0 });
  test.skip(!ID || !F, 'VERIFY_ID 또는 facts 없음(facts_auth.py 선행)');
  test.skip(!process.env.VERIFY_NO_SAVE, 'VERIFY_NO_SAVE=1 전제 — 이 스펙은 저장하지 않는다');
  test.afterEach(() => { sum(); flush(); });

  test('Div 순회 — 조건 활성·노출 · 버튼 · 헤더 재구성 · 조회 파라미터 · 401 · 기본값', async ({ nscm }) => {
    test.setTimeout(900_000);
    const f = F as Facts; const p = nscm.page; const ADMIN = { group: ['ADMIN'], admin: true };
    await installMut(nscm);
    const st = watchStatus(p);
    const r = await nscm.openScreen(ID);
    if (!r.authorized || r.notFound) { put('EG271', ID, '기본 계정', 'ERROR', '화면 진입', `authorized=${r.authorized} notFound=${r.notFound}`); return; }
    await nscm.expandSearchArea();
    const d0 = await divState(nscm);
    const initial = d0.code;
    if (!d0.found) { for (const eg of ['EG271', 'EG275', 'EG257', 'EG024', 'EG212', 'EG369', 'EG294']) put(eg, ID, 'Div 칸', 'NA', 'Division 조회조건', '조회영역에 Division 칸 없음 — Div 순회 대상 아님', '', 'Div 칸 없음은 화면 사실(AS-IS 분기 문장 유무로 교차 확인 필요)'); return; }
    const groups = groupStates(f);
    const conds = groups.filter(g => !g.isButton); const btns = groups.filter(g => g.isButton);
    const seenCond = new Set<string>(); const seenBtn = new Set<string>();
    const perDiv: Record<string, { conds: ReturnType<typeof condSnapshot> extends Promise<infer T> ? T : never; btns: Awaited<ReturnType<typeof buttonSnapshot>>; vis: string[] | null }> = {};
    await mutDom(nscm, 'walk-start');
    const order = [...new Set([initial, ...d0.options])];
    const failSel: string[] = [];
    for (const d of order) {
      const ok = d === initial ? true : await selectDiv(nscm, d);
      if (!ok) { failSel.push(d); continue; }
      await nscm.clearDialogs().catch(() => undefined);
      await mutDom(nscm, 'snap');
      const cs = await condSnapshot(p); const bs = await buttonSnapshot(p); const g = await gridState(p);
      perDiv[d] = { conds: cs, btns: bs, vis: g?.visible || null };
      for (const c of cs) if (c.visible) seenCond.add(c.key);
      for (const b of bs) seenBtn.add(labelKey(b.name));
    }
    await mutDom(nscm, 'walk-end');
    if (failSel.length) put('EG271', 'Div 선택', failSel.join(','), 'ERROR', '후보 Div 선택 후 표시값=코드', '선택 실패', '', '측정 경로 실패 — 해당 Div 판정 없음');
    // EG271·EG275·EG369: AS-IS 분기 문장 ↔ Div 별 실측
    const noLabelSeen = new Set<string>(); const dedup = new Set<string>(); const planEx = new Set(f.asis?.planExcluded || []);
    const stateCheck = (g: typeof groups[number], d: string, snap: typeof perDiv[string]) => {
      if (planEx.has(g.ctl)) { if (!noLabelSeen.has(g.ctl)) { noLabelSeen.add(g.ctl); put(g.isButton ? 'EG369' : g.prop === 'enabled' ? 'EG271' : 'EG275', `${g.ctl}.${g.prop}`, '전체 Div', 'NA', 'AS-IS 분기 있음', '대조표 제외 결정(plan.fields.excluded)', g.stmts[0]?.ref || ''); } return; }
      const dk = `${g.labels.join('/')}|${g.prop}|${d}`; if (g.labels.length) { if (dedup.has(dk)) return; dedup.add(dk); } else { if (noLabelSeen.has(g.ctl + g.prop)) return; noLabelSeen.add(g.ctl + g.prop); }
      const e = expectState(g.stmts, d, initial, ADMIN);
      const tag = `${g.ctl}.${g.prop}`; const eg = g.isButton ? 'EG369' : g.prop === 'enabled' ? 'EG271' : 'EG275'; const lab = g.labels.join('/') || '(라벨 없음)';
      if (!g.labels.length) { put(eg, tag, '전체 Div', 'ERROR', `AS-IS Div 분기 있음(${g.stmts.length}문장)`, '컨트롤 라벨 미식별 — TO-BE 칸과 대응 못함(plan.fields·디자이너 Text 없음)', e.ref || g.stmts[0]?.ref || ''); return; }
      if (e.val === null) { if (e.err && !/디자이너/.test(e.err)) put(eg, tag, `Div ${d}`, 'ERROR', 'AS-IS 조건 평가', e.err, e.ref); return; }
      const keys = g.labels.map(labelKey);
      if (g.isButton) {
        const hit = snap.btns.filter(b => keys.some(k => labelKey(b.name) === k || labelKey(b.name).includes(k)));
        const everSeen = [...seenBtn].some(n => keys.some(k => n === k || n.includes(k)));
        if (g.prop === 'visible') {
          if (e.val && !hit.length) put(eg, lab, `Div ${d}`, everSeen ? 'FAIL' : 'ERROR', `AS-IS Div ${d} 보임(${e.by})`, everSeen ? '이 Div 에서 비노출' : '어느 Div 에서도 해당 라벨 버튼 없음 — 라벨 불일치 또는 미구현(CR-070 권한·기능 게이트 확인 필요)', e.ref);
          else if (!e.val && hit.length) put(eg, lab, `Div ${d}`, 'FAIL', `AS-IS Div ${d} 숨김(${e.by})`, `버튼 노출(${hit.map(h => h.name).join(',')})`, e.ref);
          else put(eg, lab, `Div ${d}`, 'PASS', `AS-IS ${e.val ? '보임' : '숨김'}`, hit.length ? '노출' : '비노출', e.ref);
        } else {
          if (!hit.length) { if (e.val && everSeen) put(eg, lab, `Div ${d}`, 'ERROR', `AS-IS 활성(${e.by})`, '버튼 비노출로 활성 측정 불가', e.ref); return; }
          const dis = hit.every(h => h.disabled);
          put(eg, lab, `Div ${d}`, dis === !e.val ? 'PASS' : 'FAIL', `AS-IS ${e.val ? '활성' : '비활성'}(${e.by})`, dis ? '비활성' : '활성', e.ref);
        }
        return;
      }
      const hit = snap.conds.find(c => keys.includes(c.key));
      const ever = keys.some(k => seenCond.has(k));
      if (g.prop === 'visible') {
        const shown = !!hit && hit.visible;
        if (e.val && !shown) put(eg, lab, `Div ${d}`, ever ? 'FAIL' : 'ERROR', `AS-IS 보임(${e.by})`, ever ? '이 Div 에서 비노출' : '어느 Div 에서도 칸 없음 — 라벨 불일치 또는 설계 제외(대조표 확인 필요)', e.ref);
        else if (!e.val && shown) put(eg, lab, `Div ${d}`, 'FAIL', `AS-IS 숨김(${e.by})`, '칸 노출', e.ref);
        else put(eg, lab, `Div ${d}`, 'PASS', `AS-IS ${e.val ? '보임' : '숨김'}`, shown ? '노출' : '비노출', e.ref);
      } else {
        if (!hit || !hit.visible) { put(eg, lab, `Div ${d}`, ever ? 'FAIL' : 'ERROR', `AS-IS ${e.val ? '활성' : '비활성(표시+disabled)'}(${e.by})`, ever ? '이 Div 에서 칸 비노출' : '어느 Div 에서도 칸 없음 — 라벨 불일치 또는 설계 제외', e.ref); return; }
        if (!hit.inputs) { put(eg, lab, `Div ${d}`, 'ERROR', `AS-IS ${e.val}`, '입력 요소 없음 — 활성 측정 불가', e.ref); return; }
        put(eg, lab, `Div ${d}`, hit.disabled === !e.val ? 'PASS' : 'FAIL', `AS-IS ${e.val ? '활성' : '비활성'}(${e.by})`, hit.disabled ? '비활성' : '활성', e.ref);
      }
    };
    for (const d of Object.keys(perDiv)) for (const g of [...conds, ...btns]) stateCheck(g, d, perDiv[d]);
    if (!groups.length) for (const eg of ['EG271', 'EG275', 'EG369']) put(eg, ID, '전체 Div', 'NA', 'AS-IS Div·GROUP 분기 문장', `없음(살아있는 메서드 전체 상태 문장 ${(f.asis as { stateCountAll?: number } | null)?.stateCountAll ?? 0}건 중 분기 0)`, 'facts_auth');
    // Div 후보 간 조건 집합 차이(참고 기록): 분기 문장 없는데 칸 집합이 달라지면 AS-IS 근거 없는 차이
    const setOf = (d: string) => perDiv[d].conds.filter(c => c.visible).map(c => c.key).sort().join(',');
    const uniq = new Set(Object.keys(perDiv).map(setOf));
    if (uniq.size > 1) put('EG275', '조건 집합', Object.keys(perDiv).join(','), groups.some(g => g.prop === 'visible' && !g.isButton) ? 'PASS' : '판정필요', 'AS-IS 분기 문장으로 설명', `Div 별 칸 집합 ${uniq.size}종`, 'facts_auth');

    // EG369(CR-070): Div 별 공통버튼 = PR_GET_MNU_BTN_AUTH_DIV(기본 계정) — 코드 없는데 노출 = FAIL · 있는데 비노출 = 화면 기능 유무 미구분이라 판정필요
    { const codeRe: Record<string, RegExp> = { SAVE: /^Save/i, INSERT: /^Insert/i, DELETE: /^Delete/i };
      for (const d of Object.keys(perDiv)) { const codes = f.btnDiv?.__default__?.[d]; if (!codes) { put('EG369', 'CR-070 공통버튼', `Div ${d}`, 'ERROR', '권한 프로시저 결과', 'facts 에 이 Div 없음'); continue; }
        for (const [code, re] of Object.entries(codeRe)) { const vis = perDiv[d].btns.some(b => re.test(b.name)); const has = codes.includes(code); put('EG369', `${code} 버튼 CR-070`, `Div ${d} · 조회 전`, !has && vis ? 'FAIL' : has && !vis ? '판정필요' : 'PASS', `Div 권한 ${has ? '있음 → 기능 있으면 노출' : '없음 → 비노출'}`, vis ? '노출' : '비노출', 'PKG_NSCM_UI_COM_AUTH.PR_GET_MNU_BTN_AUTH_DIV · CR-070'); } } }
    // EG212: Div 전환 구간 401/403
    const bad401 = st.all.filter(x => x.status === 401 || x.status === 403);
    put('EG212', 'Division 전환', `후보 ${order.length}개 순회`, bad401.length ? 'FAIL' : 'PASS', 'Division 전환 중 세션 오류(401/403) 0 — DM-163', bad401.length ? `${bad401.length}건 (${[...new Set(bad401.map(x => `${x.status} ${x.url}`))].slice(0, 3).join(' | ')})` : `0건(5xx ${st.all.length}건 별도)`);

    // EG024·EG257: 복귀 포함 헤더 · 조회 파라미터
    const base = order[0]; const others = order.slice(1);
    const meta = async (d: string, stage: string) => { const v0 = (await gridState(p))?.visible || []; const sh = metaSheet(f, v0); return { sh, exp: sh ? metaCols(f, sh, d) : [], vis: v0.map(x => x.toUpperCase()), stage }; };
    let other = '';
    { // 메타 차이가 가장 큰 Div 를 전환 대상으로(화면 독립)
      const v0 = perDiv[base]?.vis || []; const sh = metaSheet(f, v0); let best = -1;
      for (const d of others) { if (!perDiv[d]) continue; const a = new Set(metaCols(f, sh, base)); const b = new Set(metaCols(f, sh, d)); const diff = [...a].filter(x => !b.has(x)).length + [...b].filter(x => !a.has(x)).length; if (diff > best) { best = diff; other = d; } }
    }
    if (!other) { put('EG024', ID, 'Div 전환', 'NA', 'Div 2개 이상', `선택 가능 Div ${order.length}개 — 전환 시나리오 없음(계정 권한 ${order.join(',')})`); put('EG257', ID, 'Div 전환', 'NA', 'Div 2개 이상', `선택 가능 Div ${order.length}개`); return; }
    const searchDiv = async (d: string): Promise<{ sent: string; rows: number; hdr: string[] }> => {
      const before = nscm.calls.length; await nscm.search().catch(() => undefined); await probe.waitRows(p, 30_000).catch(() => undefined); await nscm.clearDialogs().catch(() => undefined);
      const c = nscm.calls.slice(before).filter(x => /SEARCH/i.test(x.btn) && x.body); const m = c.map(x => /"(?:\w*division\w*)"\s*:\s*"([^"]*)"/i.exec(x.body || '')).find(Boolean);
      return { sent: m ? m[1] : (c.length ? '(본문에 Division 키 없음)' : '(조회 호출 없음)'), rows: await probe.rowCount(p), hdr: ((await gridState(p))?.visible || []).map(x => x.toUpperCase()) };
    };
    const seq = [base, other, base];
    const hist: { d: string; beforeSearch: string[]; afterSearch: string[]; sent: string; rows: number }[] = [];
    for (let i = 0; i < seq.length; i++) {
      const d = seq[i];
      if (!(await selectDiv(nscm, d))) { put('EG024', ID, `→ ${d}`, 'ERROR', 'Div 전환', '선택 실패', '', '측정 경로 실패'); return; }
      await nscm.clearDialogs().catch(() => undefined);
      if (i === 2) await mutDom(nscm, 'back');
      const beforeSearch = ((await gridState(p))?.visible || []).map(x => x.toUpperCase());
      const r1 = await searchDiv(d);
      if (i === 2) await mutDom(nscm, 'back');
      const after = i === 2 ? ((await gridState(p))?.visible || []).map(x => x.toUpperCase()) : r1.hdr;
      hist.push({ d, beforeSearch, afterSearch: after, sent: r1.sent, rows: r1.rows });
      const expSent = d;
      if (/^\(/.test(r1.sent)) put('EG257', '조회 본문 Division', `Div ${d}`, 'ERROR', `본문 Division=${expSent}`, r1.sent, '', '측정 경로 — 본문 키 미식별');
      else put('EG257', '조회 본문 Division', `Div ${d}`, r1.sent.split(/[,^]/).includes(expSent) ? 'PASS' : 'FAIL', `본문 Division=${expSent} — DM-85`, r1.sent, 'AS-IS: 조회 인자 = 선택 Division');
    }
    const [A1, B, A2] = hist;
    const sh = metaSheet(f, A1.afterSearch); const expA = new Set(metaCols(f, sh, A1.d)); const expB = new Set(metaCols(f, sh, B.d));
    const onlyA = [...expA].filter(x => !expB.has(x)); const onlyB = [...expB].filter(x => !expA.has(x));
    // ① 복귀 일치(메타와 무관한 불변식)
    const mis = (x: string[], y: string[]) => [...x.filter(a => !y.includes(a)), ...y.filter(a => !x.includes(a))];
    const back = mis(A1.afterSearch, A2.afterSearch);
    const dyn = (s: string) => /^\d|^[DWM]_|\d{6}/.test(s);  // 조회 기간에 달린 동적 컬럼은 복귀 비교 제외(기간 동일이어도 시점 컬럼)
    const backStatic = back.filter(x => !dyn(x));
    put('EG024', '복귀 헤더', `${A1.d}→${B.d}→${A2.d}`, backStatic.length ? 'FAIL' : 'PASS', '원래 Div 복귀 시 처음 헤더와 동일 — DM-P60', backStatic.length ? `차이 ${backStatic.slice(0, 8).join(',')}` : `동일(정적 ${A1.afterSearch.filter(x => !dyn(x)).length}컬럼)`, '');
    // ② Div 전용 컬럼: 메타 차이가 실제로 반영되는가
    if (!sh) put('EG024', 'Div 전용 컬럼', `${A1.d}/${B.d}`, 'ERROR', '메타 시트 대응', '보이는 바인딩과 겹치는 SHEET_COLUMNS 시트 없음', 'facts_auth');
    else if (!onlyA.length && !onlyB.length) put('EG024', 'Div 전용 컬럼', `${A1.d}/${B.d}`, 'NA', 'Div 별 DEFAULT 컬럼 차이', `메타(${sh}) 차이 0 — 재구성 대상 컬럼 없음`, 'SCM_MST_SHEET_COLUMNS');
    else {
      const leak = onlyA.filter(x => B.afterSearch.includes(x)); const missB = onlyB.filter(x => !B.afterSearch.includes(x)); const missA = onlyA.filter(x => !A1.afterSearch.includes(x));
      put('EG024', 'Div 전용 컬럼', `${A1.d}→${B.d}`, leak.length || missB.length ? 'FAIL' : 'PASS', `메타(${sh}) ${A1.d} 전용 ${onlyA.length}·${B.d} 전용 ${onlyB.length} 재구성`, leak.length || missB.length ? `이전 Div 전용 잔존 ${leak.slice(0, 6).join(',') || '-'} · 이 Div 전용 누락 ${missB.slice(0, 6).join(',') || '-'}` : '재구성 일치', 'SCM_MST_SHEET_COLUMNS DIVISION_ID', '개인화(TITLESET_USER) 보유 계정이면 DEFAULT 와 다를 수 있음 — 같은 계정의 Div 간 차이만 비교');
      if (missA.length) put('EG024', 'Div 전용 컬럼', `${A1.d} 기준`, '판정필요', `${A1.d} 전용 컬럼 표시`, `없음 ${missA.slice(0, 6).join(',')}`, '', '개인화로 뺐을 수 있어 FAIL 로 세우지 않음');
    }
    // ③ 조회 전 재구성(AS-IS 변경 이벤트가 InitSpread 를 부르는 경우)
    const asisRebuild = (f.asis?.changeMethods || []).some(m => /InitSpread|SetSpreadColumn|GetSpdTitle|SetGridHeader|CreateSpread/i.test(m));
    if (onlyA.length || onlyB.length) {
      const leakBefore = onlyA.filter(x => B.beforeSearch.includes(x)); const rebuilt = !leakBefore.length && onlyB.every(x => B.beforeSearch.includes(x));
      put('EG257', '헤더 재구성 시점', `${A1.d}→${B.d} 조회 전`, rebuilt ? 'PASS' : asisRebuild ? 'FAIL' : '판정필요', `AS-IS Div 변경 이벤트 ${asisRebuild ? '가 헤더 재구성(InitSpread 류)' : '에 헤더 재구성 문장 없음'}`, rebuilt ? '조회 전 재구성' : `조회 전 미재구성(잔존 ${leakBefore.slice(0, 5).join(',') || '-'})`, (f.asis?.changeMethods || []).filter(m => /Spread|Header/i.test(m)).join(','));
    }
    void meta;
    // EG294: 기본값 — AS-IS 식 평가
    const defs = (f.asis?.defaults || []).filter(x => /year|ver|연도|버전/i.test(`${x.target} ${(x.labels || []).join(' ')}`)); let measured = 0;
    for (const x of defs) {
      const keys = (x.labels || []).map(labelKey); const yearFix = /DateTime\.Now\.Year/.test(x.raw) && !/AddYears|AddMonths|AddDays/.test(x.raw);
      if (!keys.length) continue;
      for (const d of Object.keys(perDiv)) {
        const e = !x.cond ? true : (() => { try { return expectState([{ ctl: '', prop: 'visible', val: true, cond: x.cond, phase: 'change', method: '', stmt: 0, ref: x.ref, labels: [], isButton: false }], d, initial, ADMIN).val === true; } catch { return null; } })();
        if (e !== true) continue;
        const c = perDiv[d].conds.find(y => keys.includes(y.key)); if (!c) continue;
        measured++;
        const emptyLit = /=\s*""/.test(x.raw) || /SelectedIndex\s*=\s*-1/.test(x.raw);
        if (yearFix) put('EG294', c.label, `Div ${d}`, c.value.includes(String(new Date().getFullYear())) ? 'PASS' : 'FAIL', `현재 연도 ${new Date().getFullYear()}(${x.raw.slice(0, 60)})`, c.value.slice(0, 40), x.ref);
        else if (emptyLit) put('EG294', c.label, `Div ${d}`, /^\|*\s*$/.test(c.value) ? 'PASS' : 'FAIL', `빈값(${x.raw.slice(0, 60)})`, c.value.slice(0, 40), x.ref);
        else put('EG294', c.label, `Div ${d}`, '판정필요', x.raw.slice(0, 70), c.value.slice(0, 40), x.ref, '식 평가 경로 없음(후보 첫 값 등)');
      }
    }
    if (!defs.length) put('EG294', ID, '전체', 'NA', 'Year·Version 초기값 문장', 'AS-IS 로드·변경 경로에 해당 문장 없음', 'facts_auth');
    else if (!measured) put('EG294', ID, '전체', 'ERROR', `초기값 문장 ${defs.length}건`, '대응 칸 없음·라벨 없음으로 측정 0', defs[0].ref);
    st.stop();
  });

  test('계정 순회 — 메뉴 트리 · 직접 접근 · Div 후보·자동 선택 · 조회 전 버튼 · 행 범위', async ({ nscm }) => {
    test.setTimeout(1_500_000);
    const f = F as Facts; const p = nscm.page;
    await installMut(nscm);
    const list = distinctAccounts(f).slice(0, Number(process.env.EG_ACCT_MAX || 99));
    if (!list.length) { put('EG366', ID, '계정 풀', 'ERROR', '명부 계정', 'users.json 해당 영역 계정 없음'); return; }
    const measuredDiv: Record<string, string> = {};
    let prevDiv = ''; let prevKey = '';
    for (const a of list) {
      const uid = accountId(a.key); if (!uid) { put('EG366', a.key, '계정', 'ERROR', '명부 조회', 'ID 없음'); continue; }
      const t0 = Date.now();
      try { await nscm.loginAs(uid); } catch (e) { put('EG366', a.key, '로그인', 'ERROR', '로그인', String(e).slice(0, 120), '', '부하 신호 확인 — 측정 중단'); console.log(`[LOAD?] 로그인 실패 ${a.key}`); break; }
      // EG382: 세션 메뉴 트리 ↔ 그룹×메뉴 권한
      const s = await sessionMenus(p);
      const inTree = s.menus.includes(ID); const wantMenu = a.menuGroups.length > 0 && f.db.menu.use_yn === 'Y';
      if (s.status !== 200) put('EG382', a.key, '세션 API', 'ERROR', '200', String(s.status));
      else put('EG382', '메뉴 트리', a.key, inTree === wantMenu ? 'PASS' : 'FAIL', `그룹 ${a.groups.length}개 중 메뉴 권한 ${a.menuGroups.length}개 → ${wantMenu ? '노출' : '비노출'}`, inTree ? '트리에 있음' : '트리에 없음', 'SCM_ADM_USER_GR_MNU_MPG_M');
      if (MUT === 'menu_leak' && s.menus.includes('ZZ_MUT_MENU')) put('EG382', '메뉴 트리 전체', a.key, 'FAIL', '권한 메뉴만', '권한 밖 메뉴 ZZ_MUT_MENU 노출', 'SCM_ADM_USER_GR_MNU_MPG_M');
      const r = await nscm.openScreen(ID);
      if (!wantMenu) {
        put('EG382', '직접 접근', a.key, (!r.authorized || r.notFound) ? 'PASS' : '판정필요', '메뉴 권한 없는 계정의 URL 직접 접근 차단(문서 GAPSELF-22·DM-65)', `authorized=${r.authorized} notFound=${r.notFound}`, 'SCM_ADM_USER_GR_MNU_MPG_M', '라우트 가드 부재는 기존 기록(authcrud gap) — AS-IS 근거(메뉴에 없으면 못 연다)로 FAIL 승격 여부는 사용자 결정 필요');
        if (!r.authorized || r.notFound) continue;
      } else if (!r.authorized || r.notFound) { put('EG382', '직접 접근', a.key, 'FAIL', '메뉴 권한 있음 → 접근', `authorized=${r.authorized} notFound=${r.notFound}`, 'SCM_ADM_USER_GR_MNU_MPG_M'); continue; }
      await nscm.expandSearchArea();
      await p.waitForLoadState('networkidle', { timeout: 15_000 }).catch(() => undefined);
      await mutDom(nscm, 'acct-open');
      // EG374·EG411: 조회 전 버튼(진입 직후) ↔ 자동 선택 Div 의 권한
      const bs = await buttonSnapshot(p); const before = bs.map(b => b.name);
      const ds = await divState(nscm);
      // EG365·EG366: Div 후보·자동 선택
      if (!ds.found) { put('EG366', 'Division 칸', a.key, 'NA', 'Division 칸', '조회영역에 Division 칸 없음'); }
      else {
        const divsWant = DIV_FILTER ? a.divsMenu.filter(DIV_FILTER.keep) : a.divsMenu;
        const opts = [...new Set(ds.options)]; const want = new Set(divsWant);
        // 2026-11-06 T73(SCP0122 EG365 허위 FAIL): 콤보 후보를 0개 읽음 = 측정 실패 — '후보 안의 값()' 에 선택값이 없다고 FAIL 하지 않는다(EG366 도 같은 값을 씀)
        const v = ds.code; measuredDiv[a.key] = v;  // T73: 아래 '이전 세션 잔존' 판정도 쓰므로 분기 앞에서
        if (!opts.length) { const why = `[측정 경로 없음] Division 콤보 후보를 읽지 못함(0개) · 선택값 '${ds.code || ''}'`; put('EG366', 'Division 후보', a.key, 'ERROR', `후보 = 메뉴 권한 그룹의 부문 권한 ${a.divsMenu.join(',') || '(없음)'}`, why); put('EG365', '자동 선택', a.key, 'ERROR', '후보 안의 값', why, 'DM-65'); measuredDiv[a.key] = ds.code; }
        else {
        const leak = opts.filter(o => !want.has(o)); const miss = divsWant.filter(o => !opts.includes(o));
        put('EG366', 'Division 후보', a.key, leak.length ? 'FAIL' : miss.length ? '판정필요' : 'PASS', `후보 = 메뉴 권한 그룹의 부문 권한(USE_YN Y) ${divsWant.join(',') || '(없음)'}${DIV_FILTER && divsWant.length !== a.divsMenu.length ? ` · ${DIV_FILTER.note} 로 ${a.divsMenu.filter(d => !divsWant.includes(d)).join(',')} 제외` : ''}`,`후보 ${opts.join(',')}${leak.length ? ` · 권한 밖 ${leak.join(',')}` : ''}${miss.length ? ` · 권한 있는데 없음 ${miss.join(',')}` : ''}`, 'SCM_ADM_USER_GR_UNIT_AUTH_MPG_M×MNU_MPG_M', miss.length ? 'Division 원장 유효값 밖 코드일 수 있어 누락은 판정필요' : '');
        // 자동 선택
        // 2026-11-06(SCP0084 재측정): 다중선택 Division 의 초기값 'ALL'(공용 CustomDropdown sentinel = 필터 없음 = 권한 후보 전부 · 칩 미표시)은
        //   후보가 1개면 그 1개로 조회되는 것과 같다(FE store 가 ALL 을 권한 코드로 펼쳐 전송 · AS-IS GetCheckedListValue 'ALL' → dtMyDivision 열거) → 자동 선택 충족
        if (!v && ds.multiAll) put('EG365', '자동 선택', a.key, 'PASS', opts.length === 1 ? `후보 1개 → 자동 선택 ${opts[0]}` : '후보 다수 — 기본 선택', `다중선택 초기값 ALL(필터 없음 = 후보 ${opts.join(',')} 전부)`, 'DM-65');
        else if (!v) put('EG365', '자동 선택', a.key, opts.length === 1 ? 'FAIL' : '판정필요', opts.length === 1 ? `후보 1개 → 자동 선택 ${opts[0]}` : '후보 다수 — 기본 선택', '빈값', 'DM-65');
        else put('EG365', '자동 선택', a.key, opts.includes(v) ? (opts.length === 1 && opts[0] !== v ? 'FAIL' : 'PASS') : 'FAIL', opts.length === 1 ? `단일 권한 → ${opts[0]}` : `후보 안의 값(${opts.join(',')})`, v, 'DM-65');
        }  // T73 후보 읽기 성공 분기 끝
        // 이전 세션 잔존
        if (prevKey && prevDiv && prevDiv !== v && !opts.includes(prevDiv)) put('EG365', '이전 세션 잔존', `${prevKey}→${a.key}`, 'PASS', '이전 계정 Div 잔존 0', `이전 ${prevDiv} · 이번 ${v}`);
        if (prevKey && prevDiv && prevDiv === v && !want.has(prevDiv)) put('EG365', '이전 세션 잔존', `${prevKey}→${a.key}`, 'FAIL', '권한 밖 Div 잔존 0', `이전 계정 Div ${prevDiv} 그대로`);
        prevDiv = v; prevKey = a.key;
      }
      // 조회 전 버튼 ↔ btn_auth(그룹 합집합) · CR-070: 사용자·선택 Division 권한 — 버튼 코드만 비교
      const codeRe: Record<string, RegExp> = { SAVE: /^Save/i, INSERT: /^Insert/i, DELETE: /^Delete/i };
      // 2026-11-06(SCP0084 EG374·EG411 허위 FAIL 6건): Division 이 ALL·복수·빈값이면 FE 는 Division 축 없이 사용자 그룹 합집합으로 버튼을 낸다
      //   (useTabBtnPermissions.ts:31-57 — divisionId 미지정/'ALL'/'a,b' → PR_GET_MNU_BTN_AUTH_DIV 에 Division 을 보내지 않음). 종전엔 빈 Div 로 Div 별 권한을 찾아
      //   '권한 없음 → 비노출' 을 기대했다 → 그 경우 기대 = btn_auth 의 계정 그룹 합집합(USE_YN Y).
      const divAxis = !!ds.code && !/^all$/i.test(ds.code) && !ds.code.includes(',');
      const auth = new Set(divAxis ? ((f.btnDiv?.[a.key] || {})[ds.code] || [])
        : f.db.btnAuth.filter(b => (b.use_yn || 'Y') === 'Y' && a.groups.includes(b.user_gr_id)).map(b => b.mnu_btn_cd));
      const judgeBtn = async () => {
        await mutDom(nscm, 'acct-after');
        const after = (await buttonSnapshot(p)).map(b => b.name);
        for (const [code, re] of Object.entries(codeRe)) {
          const b4 = before.some(n => re.test(n)); const af = after.some(n => re.test(n)); const has = auth.has(code); const egs = ['EG374', 'EG411'];
          const res: Verdict = !has ? (b4 || af ? 'FAIL' : 'PASS') : b4 ? 'PASS' : af ? 'FAIL' : '판정필요';
          for (const eg of egs) put(eg, `${code} 버튼 조회 전`, a.key, res, !has ? `${divAxis ? `PR_GET_MNU_BTN_AUTH_DIV(Div ${ds.code})` : '계정 그룹 버튼 권한 합집합(Division ALL·복수·미지정 — useTabBtnPermissions)'} ${code} 없음 → 비노출(CR-070)` : `${divAxis ? `PR_GET_MNU_BTN_AUTH_DIV(Div ${ds.code})` : '계정 그룹 버튼 권한 합집합(Division ALL·복수·미지정 — useTabBtnPermissions)'} ${code} 있음 → 진입 직후 자동 Div 권한으로 노출(GAPPI-15·CR-070)`, `조회 전 ${b4 ? '노출' : '비노출'} · 조회 후 ${af ? '노출' : '비노출'}`, 'PKG_NSCM_UI_COM_AUTH.PR_GET_MNU_BTN_AUTH_DIV · CR-070', res === '판정필요' ? '조회 전후 모두 비노출 — 화면 기능 없음(hotkeyConfig)·Div 단위 권한 구분은 공용 K4/J2 대조표 필요' : '');
        }
      };
      // EG369: GROUP guard 버튼·조건(계정 그룹)
      const groups = groupStates(f).filter(g => g.stmts.some(s => /GROUP/.test(s.cond)));
      const cur = ds.code; const cs = await condSnapshot(p);
      for (const g of groups) {
        const e = expectState(g.stmts, cur, cur, ctxOf(a)); if (e.val === null || !g.labels.length) continue;
        const keys = g.labels.map(labelKey); const eg = g.isButton ? 'EG369' : 'EG275';
        if (g.prop !== 'visible') continue;
        const shown = g.isButton ? bs.some(b => keys.some(k => labelKey(b.name) === k || labelKey(b.name).includes(k))) : !!cs.find(c => keys.includes(c.key) && c.visible);
        put(eg, `${g.labels.join('/')} (그룹 조건)`, a.key, shown === e.val ? 'PASS' : e.val ? '판정필요' : 'FAIL', `AS-IS ${e.val ? '보임' : '숨김'}(${e.by.slice(0, 70)})`, shown ? '노출' : '비노출', e.ref, e.val && !shown ? 'CR-070 권한·기능 게이트로 숨었을 수 있음' : '');
      }
      // EG367·EG061: 계정·Div 별 조회조건 콤보 후보 덤프 → facts_auth_combo.py 가 같은 계정·그룹으로 AS-IS 원천 실행해 대조
      { const snapC = await condSnapshot(p); const dump: { key: string; div: string; label: string; codes: string[]; texts: number; full: boolean }[] = [];
        for (const c of snapC.filter(x => x.visible && !x.disabled && /combobox|text/.test(x.kinds))) {
          const tx = await condOptions(nscm, c.label); if (tx == null) continue;
          // DOM 후보는 가상 스크롤로 일부만 렌더된다(r7 실측 12~13건) — 표시 문구가 전부 든 마지막 콤보 응답 전체를 후보로 쓴다. 못 찾으면 full=false(판정 안 함)
          const pool = [...nscm.combos].reverse().find(k => (k.rows || []).length > 0 && tx.every(t => (k.rows || []).some(rw => rw.v === t)));
          dump.push({ key: a.key, div: ds.code, label: c.label, codes: pool ? (pool.rows || []).map(rw => rw.c) : [], texts: tx.length, full: !!pool });
        }
        if (MUT === 'combo_leak' && dump[0]) dump[0].codes.push('ZZ_MUT');
        const fp = process.env.E2E_RESULTS ? path.join(process.env.E2E_RESULTS, 'eg_combos.json') : ''; if (fp) { const pv = fs.existsSync(fp) ? JSON.parse(fs.readFileSync(fp, 'utf8')) : []; fs.writeFileSync(fp, JSON.stringify([...pv, ...dump], null, 0), 'utf8'); }
      }
      // EG368·EG007: 행 범위 — 그 Div 조회 결과의 Division 값 ⊆ 권한
      if (ds.found && cur) {
        const c0 = nscm.calls.length; await nscm.search().catch(() => undefined); await probe.waitRows(p, 30_000).catch(() => undefined); await nscm.clearDialogs().catch(() => undefined);
        const n = await probe.rowCount(p); const calls = nscm.calls.slice(c0);
        if (n <= 0) { const er = await ensureRows(nscm, 2, `eg-${a.key}`); put('EG368', '조회 행 범위', a.key, 'NA', '권한 Div 행', `기본 조회 0행 · ${er.via.slice(0, 80)} → ${er.rows}행`, '', '0행은 행 범위 판정 대상 아님'); }
        const rows = await probe.rowCount(p);
        if (rows > 0) {
          await mutDom(nscm, 'rows');
          const scan = await p.evaluate(`(() => { const el = [...document.querySelectorAll('.wj-flexgrid')].find(e => e.offsetParent !== null); let c = el && el['$WJ-CTRL']; if (!c && el) for (const k of Object.getOwnPropertyNames(el)) { const v = el[k]; if (v && v.columns) { c = v; break; } } if (!c) return null; const s = {}; let key = null; for (let r = 0; r < Math.min(c.rows.length, 500); r++) { const d = c.rows[r].dataItem; if (!d) continue; if (key === null) key = Object.keys(d).find(k => /^DIVISION(_ID)?$/i.test(k)) || ''; if (key) s[String(d[key])] = (s[String(d[key])] || 0) + 1; } return { key, s }; })()`) as { key: string; s: Record<string, number> } | null;
          if (!scan || !scan.key) put('EG368', '조회 행 범위', a.key, 'ERROR', '행 Division 값', '행 데이터에 Division 컬럼 없음 — DB 건수 대조 필요(메인 세션 PROC 실행)', '', `${rows}행`);
          else { const vals = Object.keys(scan.s).filter(v => v && v !== 'null' && v !== 'undefined'); const out = vals.filter(v => !a.divsMenu.includes(v) && !a.divsMenu.some(d => v === d)); put('EG368', '조회 행 범위', a.key, out.length ? 'FAIL' : vals.length ? 'PASS' : 'ERROR', `행 Division ⊆ 권한 ${a.divsMenu.join(',')}`, `${rows}행 Division ${vals.join(',') || '(값 없음)'}${out.length ? ` · 권한 밖 ${out.join(',')}` : ''}`, 'SCM_ADM_USER_GR_UNIT_AUTH_MPG_M'); put('EG007', '권한 범위 조회', a.key, out.length ? 'FAIL' : vals.length ? 'PASS' : 'ERROR', `조회 결과 = 권한 Div 범위(${a.divsMenu.join(',')})`, `${rows}행 · Division ${vals.join(',')}`, 'SCM_ADM_USER_GR_UNIT_AUTH_MPG_M', '건수 = 원장 대조는 facts_auth_db 후처리'); }
        }
        void calls;
      }
      await judgeBtn();
      console.log(`[eg_auth] ${a.key} ${Math.round((Date.now() - t0) / 1000)}s`);
      sum(); flush();
    }
    void measuredDiv; void isDivLabel;
    void ({} as Account);
  });

  // ── Measure·Column 설정 후보 × Div ─────────────────────────────────────────────────
  test('개인화 후보 Div 순회 — Measure 후보·컬럼 필수 표시 = UI Category(Div 별)', async ({ nscm }) => {
    test.setTimeout(1_200_000);
    const f = F as Facts; const p = nscm.page; await installMut(nscm);
    const r = await nscm.openScreen(ID); if (!r.authorized || r.notFound) { put('EG022', ID, '기본 계정', 'ERROR', '화면 진입', `authorized=${r.authorized}`); return; }
    await nscm.expandSearchArea(); await p.waitForLoadState('networkidle', { timeout: 15_000 }).catch(() => undefined);
    const ds = await divState(nscm); const divs = ds.found ? [...new Set([ds.code, ...ds.options])] : [''];
    const readDlg = async (re: RegExp) => {
      const b = await nscm.visibleFirst(p.getByRole('button', { name: re })); if (!b) return null;
      await b.click({ timeout: 5_000 }).catch(() => undefined);
      const dlg = p.locator('[role="dialog"], .MuiDialog-paper').filter({ has: p.locator('[class*="_dualListContainer_"]') }).last();
      await dlg.waitFor({ state: 'visible', timeout: 20_000 }).catch(() => undefined);
      await p.waitForFunction(() => { const d = document.querySelector('[class*="_dualListContainer_"]'); return !!d && d.querySelectorAll('tbody tr').length > 0; }, undefined, { timeout: 15_000 }).catch(() => undefined);
      if (MUT === 'measure_leak') await p.evaluate(() => { const t = document.querySelector('[class*="_dualListContainer_"] tbody'); if (t) { const tr = t.querySelector('tr')?.cloneNode(true) as HTMLElement; if (tr) { const tds = tr.querySelectorAll('td'); tds[2].textContent = 'ZZ_MUT Measure'; t.appendChild(tr); } } });
      if (MUT === 'req_star' && /Column/.test(re.source)) await p.evaluate(() => { const c = Array.from(document.querySelectorAll('[class*="_dualListContainer_"] td')).find(e => /\*$/.test((e as HTMLElement).innerText.trim())) as HTMLElement | undefined; if (c) c.innerText = c.innerText.replace('*', ''); });
      const items = await p.evaluate(() => Array.from(document.querySelectorAll('[class*="_dualListContainer_"] [class*="_sideTable_"]')).map(s => ({ title: ((s.querySelector('[class*="_dualTitle_"]') as HTMLElement | null)?.innerText || '').trim(), rows: Array.from(s.querySelectorAll('tbody tr')).map(tr => { const tds = Array.from(tr.querySelectorAll('td')) as HTMLElement[]; return (tds[2]?.innerText || '').trim(); }).filter(Boolean) })));
      const cancel = dlg.getByRole('button', { name: /^(Cancel|취소|Close|닫기)$/i }).first();
      if (await cancel.isVisible({ timeout: 800 }).catch(() => false)) await cancel.click({ timeout: 3_000 }).catch(() => undefined); else await p.keyboard.press('Escape').catch(() => undefined);
      await p.waitForTimeout(400); await nscm.clearDialogs().catch(() => undefined);
      return items;
    };
    const sheetOf = (rows: Record<string, string>[], lbls: string[]) => { const m = new Map<string, number>(); const keys = new Set(lbls.map(labelKey)); for (const c of rows) if (keys.has(labelKey(c.column_label_name))) m.set(c.sheet_name, (m.get(c.sheet_name) || 0) + 1); return [...m.entries()].sort((a, b) => b[1] - a[1])[0]?.[0] || ''; };
    let anyMeasure = false, anyCol = false;
    for (const d of divs) {
      if (d && d !== ds.code && !(await selectDiv(nscm, d))) { put('EG022', 'Div 선택', d, 'ERROR', '선택', '실패', '', '측정 경로 실패'); continue; }
      const ctx = `Div ${d || '(없음)'}`;
      let mea = await readDlg(/^Measure$/i); let retryNote = '';
      if (mea && mea.length) {
        const calc = (m: NonNullable<typeof mea>) => { const sh0 = [...new Set(m.flatMap(x => x.rows))]; const sheet = sheetOf(f.db.measures, sh0); const w = new Set(f.db.measures.filter(x => x.sheet_name === sheet && x.valid_yn === 'Y' /* 2026-11-06(SCP0016 EG022 14건 허위 FAIL): USER_SELECTABLE_FLAG=N 행도 공용 MeasureSelectModal·AS-IS TitleSetForm 목록에 나온다(이동만 금지) → 기대 = 유효 전체 */ && listHas(x.division_id, d)).map(x => labelKey(x.column_label_name))); const k = new Set(sh0.map(labelKey)); return [...w].filter(x => !k.has(x)).length + [...k].filter(x => !w.has(x)).length; };
        if (calc(mea) > 0 && !MUT) { const first = mea.flatMap(x => x.rows).sort().join('|'); await p.waitForLoadState('networkidle', { timeout: 15_000 }).catch(() => undefined); await p.waitForTimeout(3_000); const again = await readDlg(/^Measure$/i); if (again && again.length) { retryNote = again.flatMap(x => x.rows).sort().join('|') === first ? ' · 재측정 동일' : ' · 첫 측정과 달라 재측정값 사용(전환 직후 이전 Div 후보 표시 가능성 — 부하 시 관찰)'; mea = again; } }
        anyMeasure = true; const shown = [...new Set(mea.flatMap(s => s.rows))]; const sh = sheetOf(f.db.measures, shown);
        const want = f.db.measures.filter(m => m.sheet_name === sh && m.valid_yn === 'Y' && listHas(m.division_id, d)).map(m => m.column_label_name);
        const wantK = new Set(want.map(labelKey)); const shK = new Set(shown.map(labelKey));
        const extra = shown.filter(x => !wantK.has(labelKey(x))); const miss = want.filter(x => !shK.has(labelKey(x)));
        for (const eg of ['EG022', 'EG402']) put(eg, `Measure 후보(${sh})`, ctx, !sh ? 'ERROR' : extra.length || miss.length ? 'FAIL' : 'PASS', `SCM_MST_SHEET_MEASURE Div ${d} 유효 ${want.length}개`, !sh ? '메타 시트 대응 실패' : extra.length || miss.length ? `실제 ${shown.length}개 · 메타 밖 ${extra.slice(0, 6).join(', ') || '-'} · 누락 ${miss.slice(0, 6).join(', ') || '-'}` : `일치 ${shown.length}개${retryNote}`, 'TO-BE UI Category(AS-IS 대조 = facts_auth_db)', retryNote);
      }
      const col = await readDlg(/^(Column Setting|Columns?|컬럼\s*설정)$/i);
      if (col && col.length) {
        anyCol = true; const shown = [...new Set(col.flatMap(s => s.rows))]; const sh = sheetOf(f.db.columns, shown.map(x => x.replace(/\*$/, '')));
        const req = shown.filter(x => /\*$/.test(x)).map(x => x.replace(/\*$/, ''));
        const want = f.db.columns.filter(c => c.sheet_name === sh && c.valid_yn === 'Y' && c.visible_flag === 'Y' && c.user_selectable_flag === 'N' && listHas(c.division_id, d)).map(c => c.column_label_name);
        const wantK = new Set(want.map(labelKey)); const reqK = new Set(req.map(labelKey));
        const allK = new Set(shown.map(x => labelKey(x))); const extra = req.filter(x => !wantK.has(labelKey(x))); const miss = want.filter(x => !reqK.has(labelKey(x)) && allK.has(labelKey(x))); const absent = want.filter(x => !allK.has(labelKey(x)));
        if (absent.length) put('EG160', `메타 필수인데 설정 창 목록에 없음(${sh})`, ctx, '판정필요', `메타 필수 ${want.length}개`, absent.slice(0, 6).join(', '), 'SCM_MST_SHEET_COLUMNS', '고정 컬럼·Measure 축일 수 있어 FAIL 아님');
        put('EG160', `필수 표시 = USER_SELECTABLE_FLAG N(${sh})`, ctx, !sh ? 'ERROR' : extra.length || miss.length ? 'FAIL' : 'PASS', `메타 필수 ${want.length}개`, !sh ? '메타 시트 대응 실패' : extra.length || miss.length ? `표시 ${req.length}개 · 메타 밖 ${extra.slice(0, 6).join(', ') || '-'} · 표시 누락 ${miss.slice(0, 6).join(', ') || '-'}` : `일치 ${req.length}개`, 'SCM_MST_SHEET_COLUMNS', '공란 저장 검증 집합 3자 대조는 실저장 경로 — integration.md');
      }
    }
    if (!anyMeasure) { put('EG022', 'Measure 버튼', '전체 Div', 'NA', 'Measure 버튼', '버튼·설정 창 없음'); put('EG402', 'Measure 버튼', '전체 Div', 'NA', 'Measure 버튼', '버튼·설정 창 없음'); }
    if (!anyCol) put('EG160', 'Column 버튼', '전체 Div', 'NA', 'Column Setting 버튼', '버튼·설정 창 없음');
  });

  // ── Insert — 권한 차단·위치·정렬 유지(저장 없음) ───────────────────────────────────────
  test('Insert — 그룹 차단 · Sort 유지 · 선택 행 위 · 병합 그룹 위', async ({ nscm }) => {
    test.setTimeout(900_000);
    const f = F as Facts; const p = nscm.page;
    const clickInsert = async (): Promise<{ clicked: boolean; msg: string; newRows: number; firstNew: number }> => {
      const b = await nscm.visibleFirst(p.getByRole('button', { name: /^Insert(\(F\d+\))?$/i })); if (!b) return { clicked: false, msg: '', newRows: -1, firstNew: -1 };
      const n0 = await probe.newRowCount(p); await b.click({ timeout: 5_000 }).catch(() => undefined);
      let msg = ''; let n1 = n0; let dlg = false;
      for (const t0 = Date.now(); Date.now() - t0 < 10_000;) { await p.waitForTimeout(400); msg = (await nscm.alertText().catch(() => '')) || ''; n1 = await probe.newRowCount(p); dlg = await p.locator('[role="dialog"]:visible, .MuiDialog-paper:visible').count().then(c => c > 0).catch(() => false); if (msg || n1 > n0 || dlg) break; }
      if (msg) await nscm.closeAlert().catch(() => undefined); const fr = await probe.findRow(p, 'new');
      if (!msg && dlg && n1 <= n0) { msg = '(설정·입력 창 열림)'; await p.keyboard.press('Escape').catch(() => undefined); }
      return { clicked: true, msg: msg.slice(0, 120), newRows: n1 - n0, firstNew: fr ? fr.row : -1 };
    };
    // EG109·EG373: AS-IS InsertButton GROUP guard ↔ 계정별 실측
    const guards = f.asis?.insertGuards || [];
    const msgG = guards.filter(g => g.kind === 'MESSAGE');
    if (!msgG.length) { put('EG109', 'Insert 그룹 차단', ID, 'NA', 'AS-IS Insert GROUP 분기', 'InsertButton·InsertRow 경로에 GROUP guard MESSAGE 없음', 'facts_auth'); put('EG373', 'Insert 차단 메시지', ID, 'NA', 'AS-IS Insert GROUP 분기', 'GROUP guard MESSAGE 없음', 'facts_auth'); }
    else {
      for (const a of distinctAccounts(f).filter(x => x.menuGroups.length)) {
        const uid = accountId(a.key); if (!uid) continue;
        try { await nscm.loginAs(uid); } catch (e) { put('EG109', a.key, '로그인', 'ERROR', '로그인', String(e).slice(0, 100), '', '부하 신호 확인'); break; }
        const r = await nscm.openScreen(ID); if (!r.authorized || r.notFound) continue;
        await nscm.expandSearchArea(); await nscm.search().catch(() => undefined); await probe.waitRows(p, 30_000).catch(() => undefined); await nscm.clearDialogs().catch(() => undefined);
        const ctx = ctxOf(a); const expBlocked = msgG.some(g => { try { return expectState([{ ctl: '', prop: 'visible', val: true, cond: g.cond, phase: 'change', method: '', stmt: 0, ref: g.ref, labels: [], isButton: false }], '', '', ctx).val === true; } catch { return false; } });
        // AS-IS 는 NowGroupID 1개, TO-BE 는 합집합: 차단 그룹만 가진 계정 = 차단 / 다른 그룹도 보유 = 차단 아님(합집합 판정 확정 AUTHUNION)
        const onlyBlocked = expBlocked && a.menuGroups.every(g => msgG.some(m => m.cond.includes(`"${g}"`)));
        const ins = await clickInsert();
        const ctxS = `${a.key} 메뉴그룹 ${a.menuGroups.join('/')}`;
        if (!ins.clicked) { put('EG109', 'Insert', ctxS, onlyBlocked ? 'PASS' : '판정필요', onlyBlocked ? '차단(CR-070: 권한 없음 → 버튼 숨김 허용)' : '허용', '버튼 비노출', msgG[0].ref); put('EG373', 'Insert 차단 메시지', ctxS, onlyBlocked ? 'NA' : '판정필요', 'AS-IS MSG 안내', '버튼 비노출 — 메시지 대상 아님(CR-070)', msgG[0].ref); continue; }
        if (onlyBlocked) { put('EG109', 'Insert', ctxS, ins.newRows > 0 ? 'FAIL' : 'PASS', `AS-IS 차단(${msgG[0].cond})`, `신규행 ${ins.newRows}`, msgG[0].ref); put('EG373', 'Insert 차단 메시지', ctxS, ins.msg ? 'PASS' : 'FAIL', `AS-IS 안내 ${msgG[0].value.slice(0, 40)}`, ins.msg || '안내 없음', msgG[0].ref); }
        else put('EG109', 'Insert', ctxS, ins.newRows > 0 || ins.msg === '(설정·입력 창 열림)' ? 'PASS' : ins.msg ? '판정필요' : 'FAIL', '차단 그룹 아님 → 신규행(또는 입력 창)', `신규행 ${ins.newRows} · 메시지 ${ins.msg || '-'}`, msgG[0].ref);
      }
      await nscm.loginAs(process.env.E2E_ACCOUNT || 'minyonglee1').catch(() => undefined);  // 기본 계정(fixture 와 동일)
    }
    // EG126·EG140·EG319: 위치
    const r0 = await nscm.openScreen(ID); if (!r0.authorized) return;
    await nscm.expandSearchArea(); await nscm.search().catch(() => undefined); await probe.waitRows(p, 40_000).catch(() => undefined); await nscm.clearDialogs().catch(() => undefined);
    const er = await ensureRows(nscm, 3, 'eg-ins'); await nscm.clearDialogs().catch(() => undefined);
    const stmts = f.asis?.insertStmts || []; const aboveAsIs = stmts.some(s => /ActiveRow|GetSelection/.test(s.raw));
    const insDiv = Object.entries(f.btnDiv?.__default__ || {}).filter(([, v]) => v.includes('INSERT')).map(([k]) => k);
    const dsI = await divState(nscm); const curHas = !dsI.found || insDiv.includes(dsI.code); const toDiv = curHas ? dsI.code : dsI.options.find(o => insDiv.includes(o)) || '';
    if (dsI.found && !toDiv) { for (const eg of ['EG126', 'EG140', 'EG319']) put(eg, 'Insert', ID, 'NA', 'Insert 권한 Div', `기본 계정 PR_GET_MNU_BTN_AUTH_DIV 에 INSERT 있는 Div 없음(후보 ${dsI.options.join(',')})`, 'CR-070'); return; }
    if (!curHas) { await selectDiv(nscm, toDiv); await nscm.search().catch(() => undefined); await probe.waitRows(p, 40_000).catch(() => undefined); await nscm.clearDialogs().catch(() => undefined); await ensureRows(nscm, 1, `eg-ins-${toDiv}`); await nscm.clearDialogs().catch(() => undefined); }
    const insBtn = await nscm.visibleFirst(p.getByRole('button', { name: /^Insert(\(F\d+\))?$/i }));
    if (!insBtn) { for (const eg of ['EG126', 'EG140', 'EG319']) put(eg, 'Insert', `Div ${toDiv}`, 'ERROR', 'Insert 권한 있는 Div 에서 버튼', '권한 코드는 있으나 버튼 비노출 — 이 조건에서 측정 불가(화면 기능·모드 확인 필요 · 노출 판정은 EG369)', 'CR-070'); return; }
    if (er.rows <= 0) { for (const eg of ['EG126', 'EG140', 'EG319']) put(eg, 'Insert', ID, 'ERROR', '조회 행 ≥1', `0행(${er.via.slice(0, 80)})`); return; }
    // 병합 — 중간 행 선택 후 Insert → 신규행 ≤ 그룹 맨 위
    const mg = await findMerged(p);
    if (!mg) {
      const hasM = await p.evaluate(`(() => { const c = ${GRID}; return c ? String(c.allowMerging) : ''; })()`) as string;
      for (const eg of ['EG140', 'EG319']) put(eg, '병합 그룹 위 삽입', ID, f.asis?.hasMerge ? 'ERROR' : 'NA', 'AS-IS 병합 있으면 그룹 위 삽입', `TO-BE 표시 행 안 병합 범위 없음(allowMerging=${hasM})`, f.asis?.hasMerge ? 'AS-IS 병합 문장 있음' : 'AS-IS 병합 문장 없음');
    } else {
      await p.evaluate(`(() => { const c = ${GRID}; c.select(${mg.row}, ${mg.col}); })()`); await p.waitForTimeout(200);
      const ins0 = await clickInsert(); await mutDom(nscm, 'after-insert'); const fr0 = await probe.findRow(p, 'new'); const ins = { ...ins0, firstNew: fr0 ? fr0.row : ins0.firstNew };
      const ok = ins.firstNew >= 0 && ins.firstNew <= mg.top;
      for (const eg of ['EG140', 'EG319']) put(eg, '병합 그룹 위 삽입', `병합 ${mg.binding} r${mg.top}~${mg.bottom} · 선택 r${mg.row}`, ins.firstNew < 0 ? 'ERROR' : ok ? 'PASS' : 'FAIL', `신규행 ≤ 그룹 맨 위 r${mg.top} — GAPSELF-15`, `신규행 r${ins.firstNew} · 메시지 ${ins.msg || '-'}`, stmts[0]?.ref || 'DM 문서 GAPSELF-15');
    }
    // Sort 유지 — 재진입 후 정렬 상태에서 Insert
    const r1 = await nscm.openScreen(ID); if (!r1.authorized) return;
    await nscm.expandSearchArea(); await nscm.search().catch(() => undefined); await probe.waitRows(p, 40_000).catch(() => undefined); await nscm.clearDialogs().catch(() => undefined); if (!curHas) { await selectDiv(nscm, toDiv); await nscm.search().catch(() => undefined); await probe.waitRows(p, 40_000).catch(() => undefined); await nscm.clearDialogs().catch(() => undefined); } await ensureRows(nscm, 1, `eg-ins-${toDiv}`);
    const heads = p.locator('.wj-flexgrid:visible .wj-colheaders .wj-cell'); const nh = await heads.count(); let col: { binding: string } | null = null;
    for (let h = 1; h < Math.min(nh, 12) && !col; h++) { await heads.nth(h).click({ timeout: 3_000 }).catch(() => undefined); await p.waitForTimeout(500); const st0 = await gridState(p); if (st0?.sort.length) col = { binding: st0.sort[0] }; }
    if (!col) { put('EG126', 'Sort 상태 Insert', ID, 'ERROR', '헤더 클릭 정렬', `헤더 ${nh}칸 클릭 후 정렬 상태 없음 — 측정 경로 없음`); return; }
    const before = await gridState(p); const pickRow = Math.min(2, Math.max(0, (before?.rows || 1) - 1));
    await p.evaluate(`(() => { const c = ${GRID}; c.select(${pickRow}, 0); })()`); await p.waitForTimeout(200);
    const ins = await clickInsert(); await mutDom(nscm, 'after-insert'); const after = await gridState(p);
    const keptSort = (after?.sort || []).join() === (before?.sort || []).join();
    put('EG126', 'Sort 유지 Insert', `정렬 ${col.binding} · 선택 r${pickRow}`, ins.firstNew < 0 ? 'ERROR' : keptSort ? 'PASS' : 'FAIL', 'Insert 후 정렬 유지 — DM-32', `정렬 전 ${(before?.sort || []).join()} → 후 ${(after?.sort || []).join()} · 신규행 r${ins.firstNew}`, stmts[0]?.ref || '');
    if (ins.firstNew >= 0) put('EG126', '선택 행 위 Insert', `선택 r${pickRow}`, aboveAsIs ? (ins.firstNew <= pickRow ? 'PASS' : 'FAIL') : '판정필요', aboveAsIs ? `AS-IS 선택 행 기준 삽입 → 신규행 ≤ r${pickRow}` : 'AS-IS 삽입 위치 문장 미식별', `신규행 r${ins.firstNew}`, stmts.map(s => s.ref).slice(0, 2).join(','));
  });

  // ── 잠금 규칙·룩업 × 계정 ──────────────────────────────────────────────────────────
  test('편집 — AS-IS 규칙(GROUP·행 값)·룩업 시간창 × 계정', async ({ nscm }) => {
    test.setTimeout(1_800_000);
    const f = F as Facts; const p = nscm.page;
    if (MUT === 'edit_flip') await p.route(/\/call-proc/, async r => { const res = await r.fetch(); const t = await res.text(); return r.fulfill({ response: res, body: t.replace(/"EDIT_AUTH_YN":"Y"/g, '"EDIT_AUTH_YN":"§"').replace(/"EDIT_AUTH_YN":"[NT]"/g, '"EDIT_AUTH_YN":"Y"').replace(/"EDIT_AUTH_YN":"§"/g, '"EDIT_AUTH_YN":"N"') }); });
    const rulesAll = (f.asis?.editRules || []).map(e => ({ column: e.column, rules: parseRules(rewriteRaw(e.cond)) })).filter(e => e.rules && e.rules.length) as { column: string; rules: Rule[] }[];
    const grpRules = rulesAll.filter(e => e.rules.some(x => /\b(GROUP|COL)\b/.test(x.g)));
    const lk = (f.db.lookupMeasure || []).filter(x => x.valid_yn === 'Y');
    const now = f.db.now; const accounts = distinctAccounts(f).filter(a => a.menuGroups.length).slice(0, Number(process.env.EG_ACCT_MAX || 99));
    if (!grpRules.length) { for (const eg of ['EG377', 'EG378', 'EG124', 'EG123']) put(eg, ID, '전체', 'NA', 'AS-IS GROUP·행 값 잠금 규칙', `edit_expect 규칙 ${rulesAll.length}건 중 GROUP·COL 조건 없음`, 'edit_expect.csv'); }
    if (!lk.length) { for (const eg of ['EG113', 'EG376', 'EG067']) put(eg, ID, '전체', 'NA', 'GET_ADMIN_GROUP_MEASURE 행', `이 메뉴 룩업 0행(SEGMENT2=${ID})`, 'SCM_ADM_LOOKUP_MASTER_DETAIL'); }
    if (!grpRules.length && !lk.length) return;
    let firstLoginDone = false;
    for (const a of accounts) {
      const uid = accountId(a.key); if (!uid) continue;
      try { await nscm.loginAs(uid); firstLoginDone = true; } catch (e) { put('EG377', a.key, '로그인', 'ERROR', '로그인', String(e).slice(0, 100), '', '부하 신호 확인'); break; }
      const r = await nscm.openScreen(ID); if (!r.authorized || r.notFound) continue;
      await nscm.expandSearchArea(); await p.waitForLoadState('networkidle', { timeout: 15_000 }).catch(() => undefined);
      const ds = await divState(nscm); const divs = ds.found ? [...new Set(lk.length ? [ds.code, ...a.divsMenu.filter(d => lk.some(l => l.segment3 === d))] : [ds.code])].slice(0, 4) : [''];
      for (const d of divs) {
        if (d && d !== ds.code && !(await selectDiv(nscm, d))) { put('EG376', a.key, `Div ${d}`, 'ERROR', '선택', '실패', '', '측정 경로 실패'); continue; }
        await nscm.search().catch(() => undefined); await probe.waitRows(p, 60_000).catch(() => undefined); await nscm.clearDialogs().catch(() => undefined);
        const n = await probe.rowCount(p);
        if (n <= 0) { put('EG376', a.key, `Div ${d}`, 'ERROR', '조회 행', '0행 — 측정 불가(사전 데이터 금지)', ''); continue; }
        const bindings = (await gridState(p))?.visible || [];
        const editBtn = await nscm.visibleFirst(p.getByRole('button', { name: /^(Edit|편집)(\(F\d+\))?$/i })); if (editBtn) { await editBtn.click({ timeout: 3_000 }).catch(() => undefined); await p.waitForTimeout(400); await nscm.clearDialogs().catch(() => undefined); }
        const items: Record<string, string>[] = [];
        for (let i = 0; i < Math.min(n, 40); i++) { const it = await probe.rowItem(p, i); items.push(it || {}); }
        await mutDom(nscm, 'edit');
        // ① AS-IS 규칙 — 그룹 합집합·행 값(COL)
        const g = ctxOf(a); let cmp = 0, bad = 0, unk = 0; const ev: string[] = []; const hitCols: Record<string, number> = {};
        for (const e of grpRules) {
          const b = bindings.find(x => x.toUpperCase() === e.column.toUpperCase()); if (!b) continue;
          let done = 0;
          for (let row = 0; row < items.length && done < 3; row++) {
            const it = items[row]; if (it.CRUD_TYPE === 'I') continue;
            const res = evalRules(e.rules, { group: g.group, admin: g.admin, div: d, self: b, col: (nm: string) => { const k = Object.keys(it).find(x => x.toUpperCase() === nm.toUpperCase()); return k ? String(it[k] ?? '') : null; } });
            if ('error' in res) { unk++; break; }
            const on = await probe.editable(p, row, b); if (on == null) break;
            done++; cmp++; if (on !== res.editable) { bad++; ev.push(`${b} r${row} 편집=${on}/AS-IS ${res.editable ? '가능' : '잠금'}(${res.by.slice(0, 60)})`); }
            hitCols[b] = (hitCols[b] || 0) + 1;
          }
        }
        if (grpRules.length) for (const eg of ['EG377', 'EG124', 'EG378', 'EG123']) put(eg, '행·칸 편집 = AS-IS 규칙(그룹 합집합·행 값)', `${a.key} · Div ${d}`, !cmp ? 'ERROR' : bad ? 'FAIL' : 'PASS', `규칙 ${grpRules.length}컬럼 · 평가 불가 ${unk}`, cmp ? `대조 ${cmp}셀 · 불일치 ${bad}${ev.length ? ` · ${ev.slice(0, 3).join(' ; ')}` : ''}` : '대조 0셀(규칙 평가 불가·컬럼 없음)', 'edit_expect.csv');
        // ② 룩업 시간창 — 메뉴 룩업 기대(요일·시각·LIMIT) ↔ 그 Measure 행의 입력 칸 편집
        const rowsLk = lk.filter(l => l.segment3 === d);
        if (rowsLk.length) {
          const measures = [...new Set(rowsLk.map(l => l.segment4))];
          const mkey = Object.keys(items[0] || {}).find(k => items.some(it => measures.includes(String(it[k])))) || '';
          if (!mkey) { put('EG376', `룩업 Measure 칸(${measures.slice(0, 3).join(',')})`, `${a.key} · Div ${d}`, 'ERROR', '행에 Measure 값', '행 데이터에서 Measure 컬럼 미식별 또는 이 조회에 해당 Measure 행 없음(Measure 설정에서 제외)', 'SCM_ADM_LOOKUP_MASTER_DETAIL'); continue; }
          const dyn = bindings.filter(b => /^\d|^[DWM]_|\d{6}/.test(b));
          const inWin = (l: Record<string, string>) => { const days = (l.attribute1 || '').split(',').map(s => s.trim()).filter(Boolean); return (!days.length || days.includes('ALL') || days.includes(now.dow)) && (!(l.attribute2 || '').trim() || l.attribute2 <= now.hm) && (!(l.attribute3 || '').trim() || l.attribute3 >= now.hm); };
          const mine = rowsLk.filter(l => a.groups.includes(l.segment1)); const live = mine.filter(inWin);
          const limited = new Set(live.flatMap(l => (l.attribute4 || '').split(',').map(s => s.trim()).filter(Boolean)));
          for (const m of measures) {
            const row = items.findIndex(it => String(it[mkey]) === m && it.CRUD_TYPE !== 'I');
            if (row < 0) { put('EG376', `${m} 편집`, `${a.key} · Div ${d}`, 'NA', `룩업 대상 Measure`, '조회 결과에 이 Measure 행 없음(개인화·Measure 설정)', 'SCM_ADM_LOOKUP_MASTER_DETAIL'); continue; }
            const want = mine.some(l => l.segment4 === m) ? live.some(l => l.segment4 === m) && !limited.has(m) : false;
            let anyEdit = false, tried = 0; for (const b of dyn.slice(0, 16)) { const on = await probe.editable(p, row, b); if (on == null) continue; tried++; if (on) { anyEdit = true; break; } }
            if (!tried) { put('EG376', `${m} 편집`, `${a.key} · Div ${d}`, 'ERROR', `기대 ${want ? '가능' : '잠금'}`, '동적 입력 칸 측정 0', 'SCM_ADM_LOOKUP_MASTER_DETAIL'); continue; }
            const res: Verdict = !want ? (anyEdit ? 'FAIL' : 'PASS') : (anyEdit ? 'PASS' : '판정필요');
            for (const eg of ['EG376', 'EG113', 'EG067']) put(eg, `${m} 편집(룩업 시간창)`, `${a.key} · Div ${d} · ${now.dow} ${now.hm}`, res, `그룹 ${a.groups.filter(x => mine.some(l => l.segment1 === x)).join('/') || '(행 없음)'} 창 안 ${live.filter(l => l.segment4 === m).length}행 · LIMIT ${limited.has(m)} → ${want ? '가능' : '잠금'}`, anyEdit ? '편집 가능 칸 있음' : `칸 ${tried}개 전부 잠금`, 'SCM_ADM_LOOKUP_MASTER_DETAIL GET_ADMIN_GROUP_MEASURE', '시간창 반대 구간은 현재 시각으로 미측정(SYSDATE 고정 불가)' + (want && !anyEdit ? ' · 다른 잠금 규칙과 구분 못함' : ''));
          }
        }
      }
      sum(); flush();
    }
    void firstLoginDone;
  });

  // ── 헤더 병합 ──────────────────────────────────────────────────────────────────────
  test('헤더 병합 — AS-IS ColumnHeaderSpan ↔ TO-BE 병합 헤더', async ({ nscm }) => {
    test.setTimeout(420_000);
    const f = F as Facts; const p = nscm.page;
    const r = await nscm.openScreen(ID); if (!r.authorized) { put('EG315', ID, '기본 계정', 'ERROR', '화면 진입', '권한 없음'); return; }
    await nscm.expandSearchArea(); await nscm.search().catch(() => undefined); await probe.waitRows(p, 40_000).catch(() => undefined); await nscm.clearDialogs().catch(() => undefined);
    await mutDom(nscm, 'hdr');
    const hs = f.asis?.headerSpan || [];
    const got = await p.evaluate(`(() => { const c = ${GRID}; if (!c) return null; const h = c.columnHeaders; let spans = 0; const smp = []; for (let row = 0; row < h.rows.length; row++) for (let col = 0; col < c.columns.length && col < 400; col++) { const g = c.getMergedRange(h, row, col, false); if (g && (g.columnSpan > 1 || g.rowSpan > 1) && g.topRow === row && g.leftCol === col) { spans++; if (smp.length < 5) smp.push(String(h.getCellData(row, col, true)).slice(0, 20)); } } return { rows: h.rows.length, spans, smp }; })()`).catch(() => null) as { rows: number; spans: number; smp: string[] } | null;
    if (!got) { put('EG315', '헤더 병합', ID, 'ERROR', '그리드', '그리드 컨트롤 없음'); return; }
    // 2026-11-06(SCP0016 38번): 조회 결과·동적 컬럼이 반영되기 전(헤더 1행·행 0)에 재면 병합 0 은 측정 실패 — FAIL 이 아니라 ERROR
    if (hs.length && !got.spans) { const pre = await measurable(nscm, { rows: true, headerRows: 2 }); if (!pre.ok) { put('EG315', '헤더 병합', `AS-IS 문장 ${hs.length}건`, 'ERROR', `AS-IS 헤더 병합 (${hs[0].raw.slice(0, 60)})`, `${pre.why} · TO-BE 헤더 ${got.rows}행 병합 ${got.spans}개`, hs[0].ref); return; } }
    if (!hs.length) put('EG315', '헤더 병합', ID, got.spans ? 'NA' : 'NA', 'AS-IS ColumnHeaderSpan 문장', `없음 · TO-BE 헤더 ${got.rows}행 병합 ${got.spans}개`, 'facts_auth');
    else put('EG315', '헤더 병합', `AS-IS 문장 ${hs.length}건`, got.spans ? 'PASS' : 'FAIL', `AS-IS 헤더 병합 (${hs[0].raw.slice(0, 60)})`, `TO-BE 헤더 ${got.rows}행 병합 ${got.spans}개 ${got.smp.join('|')}`, hs[0].ref);
  });

  // ── 개인화 계정쌍 정렬 · 저장 후 비움 · 무권한 기본 화면 ─────────────────────────────
  test('개인화 — 칸 설정 보유/미보유 계정 정렬(EG032)', async ({ nscm }) => {
    test.setTimeout(480_000);
    const f = F as Facts; const p = nscm.page;
    const withTs = f.accounts.find(a => a.titleset > 0 && a.menuGroups.length); const noTs = f.accounts.find(a => a.titleset === 0 && a.menuGroups.length && (!withTs || a.divsMenu.some(d => withTs.divsMenu.includes(d))));
    if (!withTs || !noTs) { put('EG032', ID, '계정쌍', 'ERROR', 'TITLESET_USER 보유·미보유 계정쌍', `명부에 쌍 없음(보유 ${withTs ? 'Y' : 'N'} · 미보유 ${noTs ? 'Y' : 'N'})`, 'SCM_MST_TITLESET_USER'); return; }
    const div = noTs.divsMenu.find(d => withTs.divsMenu.includes(d)) || '';
    let rules: { keys: string; line: string; depth: string }[] = [];
    try { rules = parseCsv(fs.readFileSync(path.join(__dirname, '..', '..', 'asisfacts', 'screens', ID, 'sort_rules.csv'), 'utf8')).filter(r => r.kind === 'SQL' && r.depth === '0' && r.keys).map(r => ({ keys: r.keys, line: `${r.sp}:${r.line}`, depth: r.depth })); } catch { /* 사실 없음 */ }
    const last = rules[rules.length - 1];
    const order: Record<string, string[]> = {};
    for (const [lab, a] of [['보유', withTs], ['미보유', noTs]] as const) {
      const uid = accountId(a.key); if (!uid) continue; await nscm.loginAs(uid);
      const r = await nscm.openScreen(ID); if (!r.authorized) { put('EG032', a.key, lab, 'ERROR', '화면 진입', '권한 없음'); return; }
      await nscm.expandSearchArea(); await p.waitForLoadState('networkidle', { timeout: 15_000 }).catch(() => undefined);
      if (div && !(await selectDiv(nscm, div))) { put('EG032', a.key, lab, 'ERROR', `Div ${div}`, '선택 실패'); return; }
      await nscm.search().catch(() => undefined); await probe.waitRows(p, 60_000).catch(() => undefined); await nscm.clearDialogs().catch(() => undefined);
      const er = await ensureRows(nscm, 1, `eg-sort-${a.key}`); await nscm.clearDialogs().catch(() => undefined);
      if (er.rows <= 0) { put('EG032', a.key, lab, 'ERROR', '조회 행', `0행(${er.via.slice(0, 60)})`); return; }
      await mutDom(nscm, 'sort');
      const items: Record<string, string>[] = []; for (let i = 0; i < Math.min(er.rows, 30); i++) items.push((await probe.rowItem(p, i)) || {});
      const key = (last?.keys || '').split(/[,\s]+/)[0]; const k2 = Object.keys(items[0] || {}).find(x => x.toUpperCase() === key.toUpperCase());
      order[lab] = items.map(it => (k2 ? String(it[k2] ?? '') : ''));
      if (!last) { put('EG032', a.key, lab, 'ERROR', 'AS-IS 정렬 사실', 'sort_rules.csv 정적 ORDER BY 없음'); continue; }
      if (!k2) { put('EG032', `정렬 키 ${key}`, `${lab} ${a.key}`, 'ERROR', `AS-IS ${last.line}`, '행 데이터에 정렬 키 없음 — 측정 불가', last.line); continue; }
      const nums = order[lab].map(Number); const isNum = nums.every(n => Number.isFinite(n)); const seq = isNum ? nums : order[lab];
      const asc = seq.every((v, i) => i === 0 || (v as never) >= (seq[i - 1] as never)); const desc = seq.every((v, i) => i === 0 || (v as never) <= (seq[i - 1] as never));
      put('EG032', `정렬 키 ${key}`, `${lab} ${a.key} · Div ${div}`, asc || desc ? 'PASS' : 'FAIL', `AS-IS ORDER BY ${last.keys}(${last.line})`, `${seq.length}행 ${asc ? '오름' : desc ? '내림' : '단조 아님'} · 처음 ${order[lab].slice(0, 4).join(',')}`, last.line, '혼합 정렬(입력일+SORT_ORDER_NO) 동적 규칙은 원문 동적 SQL 해석 전 — 키 단조 여부만');
    }
  });

  test('개인화 저장 후 동작(EG395) — 저장 요청을 서버로 보내지 않고 화면 반응만', async ({ nscm }) => {
    test.setTimeout(300_000);
    const p = nscm.page;
    const r = await nscm.openScreen(ID); if (!r.authorized) { put('EG395', ID, '기본 계정', 'ERROR', '화면 진입', '권한 없음'); return; }
    await nscm.expandSearchArea(); await nscm.search().catch(() => undefined); await probe.waitRows(p, 60_000).catch(() => undefined); await nscm.clearDialogs().catch(() => undefined);
    const er = await ensureRows(nscm, 2, 'eg-395'); await nscm.clearDialogs().catch(() => undefined);
    if (er.rows <= 0) { put('EG395', ID, '저장 후 비움', 'ERROR', '조회 행', `0행(${er.via.slice(0, 80)})`); return; }
    const b = await nscm.visibleFirst(p.getByRole('button', { name: /^(Column Setting|Columns?|컬럼\s*설정)$/i }));
    if (!b) { put('EG395', ID, '저장 후 비움', 'NA', 'Column 버튼', '버튼 없음'); return; }
    await b.click({ timeout: 5_000 }).catch(() => undefined); await p.waitForSelector('[class*="_dualListContainer_"]', { timeout: 15_000 }).catch(() => undefined);
    const save = await nscm.visibleFirst(p.locator('[role="dialog"], .MuiDialog-paper').last().getByRole('button', { name: /^(Save|OK|저장|확인)$/i }));
    if (!save) { put('EG395', ID, '저장 후 비움', 'ERROR', '저장 버튼', '설정 창에 저장 버튼 없음'); return; }
    { const moved = await p.evaluate(() => { const sides = Array.from(document.querySelectorAll('[class*="_dualListContainer_"] [class*="_sideTable_"]')); for (const side of sides) { const cb = side.querySelector('tbody input[type="checkbox"]') as HTMLInputElement | null; const name = ((side.querySelector('tbody tr td:nth-child(3)') as HTMLElement | null)?.innerText || '').trim(); if (cb && name && !/\*$/.test(name)) { cb.click(); return { side: ((side.querySelector('[class*="_dualTitle_"]') as HTMLElement | null)?.innerText || '').trim(), name }; } } return null; });
      if (moved) { const arrow = p.getByRole('button', { name: /invisible/i.test(moved.side) ? /^▶$/ : /^◀$/ }).first(); await arrow.click({ timeout: 3_000 }).catch(() => undefined); await p.waitForTimeout(300); } }
    // 안전: 이 구간 POST 전부 서버 미전송(실저장 금지) — 요청 본문만 기록
    const blocked: string[] = []; const h = (route: import('@playwright/test').Route) => { const q = route.request(); if (q.method() === 'GET') return route.continue(); blocked.push(q.url().replace(/^.*\/api\//, '').slice(0, 70)); return route.fulfill({ status: 200, contentType: 'application/json', body: JSON.stringify({ code: '0', message: 'success', result: {}, data: [] }) }); };
    await p.route(/\/api\//, h);
    await save.click({ timeout: 5_000 }).catch(() => undefined); await p.waitForTimeout(1_500);
    for (let k = 0; k < 2; k++) { const a = await nscm.closeAlert('ok').catch(() => false); if (!a) break; await p.waitForTimeout(500); }
    await p.waitForTimeout(800);
    const n = await probe.rowCount(p);
    await p.unroute(/\/api\//, h);
    put('EG395', '설정 저장 직후 그리드', `조회 ${er.rows}행`, blocked.length ? (n <= 0 ? 'PASS' : 'FAIL') : 'ERROR', '저장 직후 그리드 비움 → 재조회로 구성 적용 — GAP-356', `저장 요청 ${blocked.length}건(서버 미전송: ${blocked.slice(0, 2).join(',')}) · 직후 행 ${n}`, 'GAP-356(문서 확정 2026-08-05)', '실제 저장 구성대로 표시·복원은 실저장 필요 — integration.md');
  });

  test('무권한 기본 화면(EG380) — 세션 메뉴 없음 상태의 FE 첫 화면', async ({ nscm }) => {
    test.setTimeout(180_000);
    const p = nscm.page; const f = F as Facts;
    const guestOnly = f.accounts.filter(a => a.groups.every(g => /^GUEST$/i.test(g)));
    const realNote = guestOnly.length ? `명부 GUEST 전용 계정 ${guestOnly.length}` : '명부에 GUEST 전용 계정 없음 → 세션 응답 변조로 FE 만 측정(BE 판정 미측정)';
    if (!guestOnly.length) { put('EG380', '무권한 첫 화면', '실계정 없음', 'ERROR', 'Auth Request(권한 신청) 화면 메인 — DM-247', realNote, 'DM-247·GAP-475', '메뉴 0건 세션 변조는 BE 로그인 판정을 대신하지 못해 판정하지 않음 — users.json 에 GUEST 전용 계정 필요'); return; }
    const uid = accountId(guestOnly[0].key); if (!uid) { put('EG380', '무권한 첫 화면', guestOnly[0].key, 'ERROR', '명부', 'ID 없음'); return; }
    await nscm.loginAs(uid); await p.goto(new URL('/', process.env.E2E_FE || CFG.feUrl).toString(), { waitUntil: 'domcontentloaded' }); await p.waitForLoadState('networkidle', { timeout: 20_000 }).catch(() => undefined); await p.waitForTimeout(1_500);
    if (MUT === 'guest_home') await p.evaluate(() => { document.body.innerHTML = '<div>home</div>'; });
    const t = await p.evaluate(() => document.body.innerText.replace(/\s+/g, ' ').slice(0, 600));
    const url = p.url(); const shows = /auth(ority)?\s*request|권한\s*신청|request\s*auth/i.test(t) || /sys0011|sys0012|auth/i.test(url);
    put('EG380', '무권한 첫 화면', guestOnly[0].key, shows ? 'PASS' : 'FAIL', 'Auth Request(권한 신청) 화면 메인 — DM-247', `URL ${url.replace(/^https?:\/\/[^/]+/, '')} · 본문 ${t.slice(0, 90)}`, 'DM-247·GAP-475', realNote);
  });
});
