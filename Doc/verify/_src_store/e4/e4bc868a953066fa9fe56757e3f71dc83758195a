// 2026-11-20 T496·T498 팝업 그리드 K3 측정 · 조회조건 팝업 인자(G5) 측정 · 브라우저 조작부(판정은 popk3.ts 순수 함수).
//   팝업 찾기(화면 고유값 없음):
//     ① 조회조건 팝업 칸 = 조회영역 FormItem 중 콤보가 아니고 버튼·아이콘이 있는 칸(popupprobe.mainPopupConds)
//     ② 팝업 버튼 = AS-IS 사실(Doc/verify/_parallel/E02/facts/<ID>.json calls trigger.kind 'BTN')이 팝업을 연다고 한 버튼만. 모르는 버튼은 누르지 않는다
//   저장 금지: 측정 동안 쓰기 요청(call-proc SAVE·INS·UPD·DEL · 이름에 save/delete/insert/update/merge/upload 가 든 요청)은 서버로 보내지 않고 끊는다.
//     팝업은 Close/Cancel/X 로만 닫는다(OK 는 조건 팝업의 값 고르기에서만 · 버튼 팝업은 OK 를 누르지 않음).
import * as fs from 'node:fs';
import * as path from 'node:path';
import type { Locator, Page } from '@playwright/test';

import type { Nscm } from './nscm';
import type { PopK3 } from './popk3';
import { closeDialogSafely } from './smoke-extra';
import { labelVariants } from './labeltrans';
import { cellPoint, dialogCount, filterByF4, mainPopRoot, mainPopTrigger, mainPopupConds, measure, PopNet, pickRows, popRows, popSearch, settle, sortByF3, waitPopRows, waitPopup } from './popupprobe';
import { parseCsv } from './probe';

const ROOT = path.resolve(__dirname, '..', '..', '..');
const J = (v: unknown) => JSON.stringify(v);
const nrm = (s: string) => String(s || '').toLowerCase().replace(/[^a-z0-9가-힣]/g, '');
const esc = (s: string) => s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
const PG = (tag: string) => `(() => { const root = document.querySelector('[data-e2e-pop=${J(tag)}]'); if (!root) return null; for (const el of root.querySelectorAll('.wj-flexgrid')) { if (el.offsetParent === null) continue; let c = el['$WJ-CTRL']; if (!c || !c.columns) for (const k of Object.getOwnPropertyNames(el)) { const v = el[k]; if (v && typeof v === 'object' && v.columns && typeof v.columns.length === 'number') { c = v; break; } } if (c) return c; } return null; })()`;

export type AsisPopCall = { cls: string; method: string; kind: string; control: string; input: string; button: string; cond: string };
/** AS-IS 팝업 호출 사실(E02 facts). 없으면 빈 목록 */
export function asisPopCalls(id: string): AsisPopCall[] {
  try {
    const f = JSON.parse(fs.readFileSync(path.join(ROOT, 'Doc', 'verify', '_parallel', 'E02', 'facts', `${id.toUpperCase()}.json`), 'utf8')) as { calls?: { cls: string; method: string; trigger: { kind: string; control: string; input?: string; button_text?: string; cond_label?: string } }[] };
    return (f.calls || []).filter(Boolean).map(c => ({ cls: c.cls, method: c.method, kind: c.trigger.kind, control: c.trigger.control || '', input: c.trigger.input || '', button: c.trigger.button_text || '', cond: c.trigger.cond_label || '' }));
  } catch { return []; }
}

/** 쓰기 요청만 끊는다(읽기·팝업 조회는 보냄). off() 로 해제 */
export async function guardWrites(p: Page): Promise<{ st: { n: number; urls: string[] }; off: () => Promise<void> }> {
  const st = { n: 0, urls: [] as string[] };
  const isW = (m: string, u: string) => m !== 'GET' && /\/api\//.test(u) && (/\/call-proc(?:-stream)?(?:\?|$)/i.test(u) ? /\/(SAVE|INS|UPD|DEL)[^/]*\/call-proc/i.test(u) : /save|delete|insert|update|merge|upload/i.test(u.replace(/\?.*$/, '')));
  const h = async (route: import('@playwright/test').Route) => { const q = route.request(); if (isW(q.method(), q.url())) { st.n++; st.urls.push(q.url().replace(/^.*\/api\//, '').slice(0, 80)); await route.abort('blockedbyclient').catch(() => undefined); return; } await route.fallback().catch(() => undefined); };
  await p.route(/\/api\//, h);
  return { st, off: () => p.unroute(/\/api\//, h).catch(() => undefined) };
}

/** 팝업을 여는 경로 목록 · 조회조건 팝업 칸 + AS-IS 사실의 팝업 버튼 */
export async function popupTriggers(nscm: Nscm, id: string): Promise<{ name: string; kind: 'COND' | 'BTN'; idx?: number; btn?: Locator; label: string }[]> {
  const p = nscm.page; const out: { name: string; kind: 'COND' | 'BTN'; idx?: number; btn?: Locator; label: string }[] = [];
  for (const c of await mainPopupConds(nscm)) out.push({ name: `조건 '${c.label}' 아이콘`, kind: 'COND', idx: c.idx, label: c.label });
  const seen = new Set<string>();
  for (const c of asisPopCalls(id).filter(z => z.kind === 'BTN')) {
    const names = [c.button, c.control.replace(/^btn/i, '')].filter(Boolean);
    for (const n of [...names]) for (const v of labelVariants(n)) if (!names.includes(v)) names.push(v);
    let hit: Locator | null = null; let used = '';
    for (const n of names) {
      // 툴바 단추(단축키 붙은 'Delete(F9)')는 팝업 버튼이 아니다(T430) · 같은 이름의 화면 단추만
      const b = await nscm.visibleFirst(p.getByRole('button', { name: new RegExp(`^\\s*${esc(n).replace(/\s+/g, '\\s*')}\\s*$`, 'i') })).catch(() => null);
      if (b) { hit = b; used = n; break; }
    }
    if (!hit) { out.push({ name: `버튼 '${names[0] || c.control}'(AS-IS ${c.method})`, kind: 'BTN', label: names[0] || c.control }); continue; }
    if (seen.has(used)) continue; seen.add(used);
    out.push({ name: `버튼 '${used}'(AS-IS ${c.method})`, kind: 'BTN', btn: hit, label: used });
  }
  return out;
}

/** 팝업 위에 뜬 알림(팝업 아닌 대화상자) 글자 · 닫는다(알림은 단일 확인 버튼). 없으면 '' */
async function takePopAlert(p: Page, tag: string): Promise<string> {
  const ok = await p.evaluate(t => {
    document.querySelectorAll('[data-e2e-popalert]').forEach(e => e.removeAttribute('data-e2e-popalert'));
    const vis = (e: Element) => { const r = (e as HTMLElement).getBoundingClientRect(); return r.width > 0 && r.height > 0; };
    const ds = Array.from(document.querySelectorAll('[role="dialog"], [role="alertdialog"]')).filter(e => vis(e) && !e.closest(`[data-e2e-pop="${t}"]`) && !e.querySelector(`[data-e2e-pop="${t}"]`));
    const d = ds[ds.length - 1]; if (!d) return false; d.setAttribute('data-e2e-popalert', '1'); return true;
  }, tag).catch(() => false);
  if (!ok) return '';
  const al = p.locator('[data-e2e-popalert="1"]').first();
  const txt = ((await al.innerText({ timeout: 1_000 }).catch(() => '')) || '').replace(/\s+/g, ' ').trim();
  const b = al.getByRole('button', { name: /^(확인|OK|Close|닫기)$/i }).first();
  if (await b.isVisible().catch(() => false)) await b.click({ timeout: 3_000 }).catch(() => undefined); else await p.keyboard.press('Escape').catch(() => undefined);
  await p.waitForTimeout(400);
  return txt;
}

/** 팝업 그리드가 0행이면 Search → 필수 안내가 나오면 그 콤보(안내에 이름이 있는 칸 · 없으면 다중 콤보)에서 후보를 차례로 골라 다시 Search(최대 6개) */
async function fillPopRows(p: Page, dlg: Locator, tag: string, net: PopNet): Promise<{ rows: number; fill: string }> {
  let rows = await waitPopRows(p, tag, 3_000); if (rows > 0) return { rows, fill: '' };
  const trail: string[] = [];
  const s0 = await popSearch(p, dlg, net, 60_000); rows = await waitPopRows(p, tag, 6_000);
  const al = await takePopAlert(p, tag);
  trail.push(s0.clicked ? `Search → ${rows}행${al ? ` · 알림 '${al.slice(0, 60)}'` : ''}` : '팝업 Search 버튼 없음');
  if (rows > 0 || !s0.clicked) return { rows, fill: trail.join(' · ') };
  const m = await measure(p, tag); const combos = (m?.conds || []).filter(c => c.kind === 'combo' && !c.disabled);
  const named = combos.filter(c => c.label && nrm(al).includes(nrm(c.label)));
  const targets = named.length ? named : combos.filter(c => c.multi || !c.values.some(v => v && !/^all$/i.test(v)));
  if (!targets.length) { trail.push(`채울 콤보 없음(팝업 조건 ${(m?.conds || []).map(c => `${c.label}:${c.kind}`).join(',')})`); return { rows, fill: trail.join(' · ') }; }
  const c = targets[0]; const box = dlg.locator(`[data-e2e-pc="${c.pc}"] [role="combobox"]`).first();
  const lis = p.locator('.MuiAutocomplete-popper li[role="option"]');
  for (let i = 1; i <= 6 && rows <= 0; i++) {
    await box.click({ timeout: 3_000 }).catch(() => undefined); await p.waitForTimeout(400);
    const texts = (await lis.allInnerTexts().catch(() => [] as string[])).map(t => t.trim());
    if (!texts.length) { trail.push(`${c.label} 후보 목록 안 열림`); break; }
    // 'SELECT ALL' 이 있으면 먼저 전부 해제(일부·전체 체크 → SELECT ALL 클릭, 그래도 전체 체크면 한 번 더) 후 후보 1개만 체크
    const hasAll = /^(select all|all|전체)$/i.test(texts[0] || '');
    const nChk = () => p.evaluate(() => { const b = [...document.querySelectorAll('.MuiAutocomplete-popper li[role="option"] input[type="checkbox"]')] as HTMLInputElement[]; return { on: b.filter(x => x.checked).length, n: b.length }; }).catch(() => ({ on: 0, n: 0 }));
    if (hasAll) { let st = await nChk(); if (st.on) { await lis.first().click({ timeout: 3_000 }).catch(() => undefined); await p.waitForTimeout(250); st = await nChk(); if (st.on) { await lis.first().click({ timeout: 3_000 }).catch(() => undefined); await p.waitForTimeout(250); } } }
    const k = hasAll ? i : i - 1; if (k >= texts.length) break;
    await lis.nth(k).click({ timeout: 3_000 }).catch(() => undefined); await p.waitForTimeout(300);
    // 목록 닫기 · Escape 는 팝업까지 닫을 수 있어 팝업 머리를 누른다
    await dlg.locator('#draggable-dialog-title, h2').first().click({ timeout: 2_000, position: { x: 5, y: 5 } }).catch(() => undefined); await p.waitForTimeout(300);
    const s = await popSearch(p, dlg, net, 90_000); rows = await waitPopRows(p, tag, 8_000); const a2 = await takePopAlert(p, tag);
    trail.push(`${c.label} '${texts[k]}' 선택 → Search ${rows}행${s.timedOut ? '(응답 대기 초과)' : ''}${a2 ? ` · 알림 '${a2.slice(0, 50)}'` : ''}`);
  }
  return { rows, fill: trail.join(' · ') };
}

/** 열린 팝업 하나를 K3 항목으로 잰다. mainSheet = 메인 조회 시트(F5 가 팝업 조회인지 가르는 기준) */
async function measureOne(nscm: Nscm, dlg: Locator, tag: string, net: PopNet, openMark: number, want: Set<string>, mainSheet: string, rec: PopK3): Promise<void> {
  const p = nscm.page;
  const f = await fillPopRows(p, dlg, tag, net); rec.rows = f.rows; rec.fill = f.fill;
  const m = await measure(p, tag); if (!m) { rec.why = '팝업 측정 실패(표지 잃음)'; return; }
  rec.title = m.title; rec.grid = m.grids.length > 0; rec.hasSearch = m.buttons.some(b => /^(조회|Search)(\(F5\))?$/i.test(b.text));
  if (!rec.grid) return;
  rec.rows = m.grids[0].rows;
  const g = m.grids[0]; const vc = g.cols.filter(x => x.visible);
  rec.no = { corner: g.corner, firstHdr: vc[0]?.header || '', n: vc.filter(x => /^no\.?$/i.test(x.header.trim())).length + (g.corner.some(t => /^no\.?$/i.test(t)) ? 1 : 0) };
  rec.count = m.countText;
  if (rec.rows <= 0) return;
  const popSheets = new Set(net.since(openMark).map(r => r.sheet).filter(s => s && s !== mainSheet));
  if (want.has('ctrl') && rec.rows >= 3) {
    try {
      const tries: string[] = []; let ok = false;
      for (let t = 0; t < 2 && !ok; t++) {
        const a = await cellPoint(p, tag, 0); const b = await cellPoint(p, tag, 2); if (!a || !b) { rec.ctrl = { ok: false, rs: '', why: '팝업 셀 좌표 확인 불가' }; break; }
        await p.mouse.click(a.x, a.y); await p.waitForTimeout(250);
        await p.keyboard.down('Control'); await p.mouse.click(b.x, b.y); await p.keyboard.up('Control'); await p.waitForTimeout(350);
        const s = await p.evaluate(`(() => { const c = ${PG(tag)}; if (!c) return null; const rs = (c.selectedRanges && c.selectedRanges.length ? c.selectedRanges : [c.selection]).map(x => [x.topRow, x.bottomRow]); const has = r => rs.some(([t, b]) => r >= t && r <= b); return { rs, r0: has(0), r1: has(1), r2: has(2), mode: c.selectionMode }; })()`).catch(() => null) as { rs: number[][]; r0: boolean; r1: boolean; r2: boolean; mode: number } | null;
        if (!s) { rec.ctrl = { ok: false, rs: '', why: '팝업 그리드 컨트롤 못 읽음' }; break; }
        ok = s.r0 && s.r2 && !s.r1; tries.push(`시도${t + 1} ${J(s.rs)} · selectionMode=${s.mode}`);
        rec.ctrl = { ok, rs: tries.join(' / ') };
      }
    } catch (e) { rec.ctrl = { ok: false, rs: '', why: String(e).slice(0, 100) }; }
  }
  if (want.has('shift') && rec.rows >= 3) {
    try {
      const a = await cellPoint(p, tag, 0); const b = await cellPoint(p, tag, 2);
      if (!a || !b) rec.shift = { ok: false, rs: '', why: '팝업 셀 좌표 확인 불가' };
      else {
        await p.mouse.click(a.x, a.y); await p.waitForTimeout(250);
        await p.keyboard.down('Shift'); await p.mouse.click(b.x, b.y); await p.keyboard.up('Shift'); await p.waitForTimeout(350);
        const rd = () => p.evaluate(`(() => { const c = ${PG(tag)}; if (!c) return null; const rs = (c.selectedRanges && c.selectedRanges.length ? c.selectedRanges : [c.selection]).map(x => [x.topRow, x.bottomRow]); const has = r => rs.some(([t, b]) => r >= t && r <= b); return { rs, ok: has(0) && has(1) && has(2) }; })()`).catch(() => null) as Promise<{ rs: number[][]; ok: boolean } | null>;
        const s = await rd();
        // 드래그(마우스 누른 채 0행 → 2행)
        await p.mouse.click(a.x, a.y); await p.waitForTimeout(250); await p.mouse.move(a.x, a.y); await p.mouse.down(); await p.mouse.move(b.x, b.y, { steps: 8 }); await p.mouse.up(); await p.waitForTimeout(350);
        const d = await rd();
        rec.shift = s && d ? { ok: s.ok && d.ok, rs: `Shift ${J(s.rs)}${s.ok ? '' : '(연속 아님)'} · 드래그 ${J(d.rs)}${d.ok ? '' : '(연속 아님)'}` } : { ok: false, rs: '', why: '팝업 그리드 컨트롤 못 읽음' };
      }
    } catch (e) { rec.shift = { ok: false, rs: '', why: String(e).slice(0, 100) }; }
  }
  const pick2 = async () => { const r0 = await popRows(p, tag, 200); return vc.filter(x => !/^(row_?no|no)$/i.test(x.binding) && !/^no\.?$/i.test(x.header.trim()) && x.width > 20 && r0 && new Set(r0.map(r => r[x.binding])).size >= 2).sort((a, b) => new Set((r0 || []).map(r => r[a.binding])).size - new Set((r0 || []).map(r => r[b.binding])).size)[0]?.binding || ''; };
  if (want.has('sort') && rec.rows >= 2) {
    const b = await pick2(); if (!b) rec.sort = { on: false, s1: '', s2: '', why: '값이 2종 이상인 보이는 컬럼 없음' };
    else { const r = await sortByF3(p, tag, b).catch(() => null); rec.sort = r ? { on: r.on, s1: r.s1, s2: r.s2 } : { on: false, s1: '', s2: '', why: `${b} 셀 위치 확인 불가` }; }
  }
  if (want.has('filter') && rec.rows >= 2) {
    const b = await pick2();
    if (b) await p.evaluate(`(() => { const c = ${PG(tag)}; if (!c) return; const col = c.columns.getColumn(${J(b)}); c.select(0, col.index); c.focus(); })()`).catch(() => undefined);
    rec.filter = await filterByF4(p, dlg, tag).catch(e => ({ icons0: 0, icons1: 0, n0: -1, n1: -1, n2: -1, count1: '', why: String(e).slice(0, 100) }));
  }
  if (want.has('f5') && rec.hasSearch) {
    let nav = 0; const onNav = (fr: import('@playwright/test').Frame) => { if (fr === p.mainFrame()) nav++; }; p.on('framenavigated', onNav);
    try {
      const a = await cellPoint(p, tag, 0); if (a) { await p.mouse.click(a.x, a.y); await p.waitForTimeout(200); }
      const mk = net.mark(); await p.keyboard.press('F5'); const s = await settle(p, net, mk, 45_000); await p.waitForTimeout(400);
      const procs = s.recs.filter(r => /call-proc/.test(r.url));
      const isPop = (sh: string) => popSheets.size ? popSheets.has(sh) : sh !== mainSheet;
      rec.f5 = { pop: procs.filter(r => isPop(r.sheet)).length, main: procs.filter(r => r.sheet === mainSheet && /SEARCH|SEL|GET/i.test(r.btn)).length, nav, sheets: [...new Set(procs.map(r => `${r.sheet}/${r.btn}`))].slice(0, 3).join(',') };
      await takePopAlert(p, tag);
    } catch (e) { rec.f5 = { pop: 0, main: 0, nav, sheets: '', why: String(e).slice(0, 100) }; }
    p.off('framenavigated', onNav);
  }
}

/**
 * 화면의 팝업을 하나씩 열어 K3 항목을 잰다. want = 잴 항목(ctrl·f5·no·count·sort·filter·pickf5). 반환 pops = 팝업별 측정 · writes = 끊은 쓰기 요청 수
 *  pickf5: 조건 팝업에서 첫 행을 고르고(OK) 팝업이 닫힌 직후 메인 F5 → 메인 조회 호출 수. 고른 조건 값은 끝에 지운다
 */
export async function popK3Measure(nscm: Nscm, id: string, want: Set<string>, mainSheet: string): Promise<{ pops: PopK3[]; writes: number; why: string }> {
  const p = nscm.page; const pops: PopK3[] = []; const net = new PopNet(p);
  const g = await guardWrites(p);
  try {
    await nscm.expandSearchArea(true).catch(() => undefined);
    const trig = await popupTriggers(nscm, id);
    for (let i = 0; i < trig.length; i++) {
      const t = trig[i]; const tag = `k3pop${i}`;
      const rec: PopK3 = { name: t.name, title: '', opened: false, cond: t.kind === 'COND', grid: false, rows: 0 };
      if (t.kind === 'BTN' && !t.btn) { rec.why = '버튼 비노출(권한·이름 차이)'; pops.push(rec); continue; }
      const base = await dialogCount(p); const mk = net.mark();
      if (t.kind === 'COND') { await nscm.expandSearchArea(true).catch(() => undefined); await mainPopupConds(nscm); const tr = await mainPopTrigger(p, t.idx as number); await tr.click({ timeout: 5_000, force: true }).catch(() => undefined); }
      else await (t.btn as Locator).click({ timeout: 5_000 }).catch(() => undefined);
      const dlg = await waitPopup(p, tag, base, 10_000);
      if (!dlg) {
        const al = await nscm.alertText().catch(() => '');
        // 날짜 칸 달력 등 대화상자가 아닌 칸은 팝업 대상이 아니다(그리드 없음)
        rec.why = al ? `알림 '${al.slice(0, 80)}'` : '10초 안에 대화상자 없음';
        if (al) await closeDialogSafely(nscm, p);
        // AS-IS 사실에 팝업 조건으로 없는 칸(달력 등)이 대화상자를 안 열면 팝업 대상 아님(NA) · AS-IS 팝업 조건인데 안 열리면 ERROR(opened=false 유지)
        const asisCond = asisPopCalls(id).some(z => z.kind === 'COND' && [z.cond, z.input.replace(/^txt/i, '')].map(nrm).some(x => x && (nrm(t.label).includes(x) || x.includes(nrm(t.label)))));
        if (t.kind === 'COND' && !al && !asisCond) { rec.opened = true; rec.grid = false; rec.why = '대화상자 없음 · AS-IS 팝업 조건 아님(달력 등)'; }
        pops.push(rec); continue;
      }
      rec.opened = true;
      await settle(p, net, mk, 30_000);
      try { await measureOne(nscm, dlg, tag, net, mk, want, mainSheet, rec); } catch (e) { rec.why = `측정 중 예외 ${String(e).slice(0, 100)}`; }
      // 조건 팝업에서 값 고른 직후 메인 F5
      if (want.has('pickf5') && t.kind === 'COND' && rec.grid && rec.rows > 0) {
        try {
          const pr = await pickRows(p, dlg, tag, [0], 'ok'); await p.waitForTimeout(500);
          const closed = pr.closed || (await dialogCount(p)) <= base;
          if (!closed) rec.pickf5 = { picked: false, main: 0, nav: 0, why: `행 고른 뒤 팝업이 닫히지 않음(${pr.okText || 'OK 버튼 없음'}${pr.why ? ` · ${pr.why}` : ''})` };
          else {
            let nav = 0; const onNav = (fr: import('@playwright/test').Frame) => { if (fr === p.mainFrame()) nav++; }; p.on('framenavigated', onNav);
            const c0 = nscm.calls.length; await p.keyboard.press('F5'); for (let k = 0; k < 40 && !nscm.calls.slice(c0).some(c => /SEARCH|SEL|GET/i.test(c.btn)); k++) await p.waitForTimeout(250);
            await p.waitForTimeout(800); p.off('framenavigated', onNav);
            rec.pickf5 = { picked: true, main: nscm.calls.slice(c0).filter(c => /SEARCH|SEL|GET/i.test(c.btn) && (!mainSheet || c.sheet === mainSheet)).length, nav };
            await nscm.clearDialogs().catch(() => undefined);
            const inp = mainPopRoot(p, t.idx as number).locator('input:not([type="hidden"]):not([type="checkbox"]), textarea').first();
            if (await inp.isVisible().catch(() => false)) await inp.fill('').catch(() => undefined);
          }
        } catch (e) { rec.pickf5 = { picked: false, main: 0, nav: 0, why: String(e).slice(0, 100) }; }
      }
      if (await dlg.isVisible().catch(() => false)) { const how = await closeDialogSafely(nscm, p); if (/^열림/.test(how)) rec.why = `${rec.why ? `${rec.why} · ` : ''}팝업 닫기 실패 ${how}`; }
      pops.push(rec);
    }
    return { pops, writes: g.st.n, why: '' };
  } catch (e) { return { pops, writes: g.st.n, why: String(e).slice(0, 160) }; }
  finally { await g.off(); }
}

/**
 * T498 조회조건 팝업 인자(G5) · 조건 칸에 결과 값을 넣고 아이콘으로 팝업을 열어 팝업 조회 요청 본문을 AS-IS 인자 기대(popup_args.csv)와 대조한다.
 *  기대 = AS-IS 팝업 호출(E02 facts · 조건 라벨 일치) 의 인자 중 (a) Division 개념 → 메인 조회 Division (b) 출처가 그 조건 입력칸(trigger.input)인 인자 → 넣은 값
 */
export async function condPopupArgs(nscm: Nscm, id: string, name: string, typed: string, divV: string, mainSheet: string): Promise<{ result: 'PASS' | 'FAIL' | 'ERROR'; ev: string }> {
  const p = nscm.page; const parts = [name, ...name.split(/\s*\/\s*/)].map(nrm).filter(Boolean);
  const conds = await mainPopupConds(nscm);
  const hit = conds.find(c => parts.includes(nrm(c.label))) || conds.find(c => c.label.split(/\s*\/\s*/).map(nrm).some(x => parts.includes(x)));
  if (!hit) return { result: 'ERROR', ev: `[측정 경로 없음] 조회영역 팝업 칸 [${conds.map(c => c.label).join(', ')}] 중 '${name}' 없음` };
  const calls = asisPopCalls(id).filter(c => c.kind === 'COND' && [c.cond, c.input.replace(/^txt/i, '')].map(nrm).some(x => x && (parts.includes(x) || hit.label.split(/\s*\/\s*/).map(nrm).includes(x))));
  type Arg = { asis_method: string; asis_param: string; asis_source: string; concept: string; tobe_key: string; side: string; verdict: string };
  let args: Arg[] = [];
  try { args = (parseCsv(fs.readFileSync(path.join(ROOT, 'Doc', 'verify', id.toUpperCase(), 'popup_args.csv'), 'utf8').replace(/^﻿/, '')) as unknown as Arg[]).filter(a => a.side === 'ASIS' && calls.some(c => c.method === a.asis_method)); } catch { /* 사실 없음 */ }
  const inputCtl = calls.map(c => c.input).filter(Boolean);
  const inp = mainPopRoot(p, hit.idx).locator('input:not([type="hidden"]):not([type="checkbox"]):not([type="radio"]), textarea').first();
  const canType = typed && await inp.isVisible().catch(() => false) && await inp.isEditable().catch(() => false);
  const want: { k: string; v: string; why: string }[] = [];
  for (const a of args) {
    if (/^division/i.test(a.concept) && divV) want.push({ k: a.tobe_key, v: divV, why: `AS-IS ${a.asis_param}=${a.asis_source}` });
    else if (canType && inputCtl.some(ic => a.asis_source.startsWith(ic))) want.push({ k: a.tobe_key, v: typed, why: `AS-IS ${a.asis_param}=${a.asis_source}` });
  }
  if (!want.length && divV) want.push({ k: '', v: divV, why: 'AS-IS 인자 사실 없음 · 메인 Division 만 대조' });
  if (canType) { await inp.fill(typed).catch(() => undefined); await p.waitForTimeout(300); }
  const g = await guardWrites(p); const tag = 'g5cond'; const base = await dialogCount(p); const c0 = nscm.calls.length;
  try {
    await (await mainPopTrigger(p, hit.idx)).click({ timeout: 5_000, force: true }).catch(() => undefined);
    const dlg = await waitPopup(p, tag, base, 10_000);
    if (!dlg) return { result: 'ERROR', ev: `[측정 실패] '${hit.label}' 아이콘 → 팝업 안 열림` };
    await p.waitForTimeout(1_500);
    const popCalls = () => nscm.calls.slice(c0).filter(c => c.sheet && c.sheet !== mainSheet);
    let via = '열기 자동 조회';
    if (!popCalls().length) { const b = dlg.getByRole('button', { name: /^(조회|Search)(\(F5\))?$/i }).first(); if (await b.isVisible().catch(() => false)) { await b.click({ timeout: 5_000 }).catch(() => undefined); via = '팝업 Search 클릭'; for (let k = 0; k < 60 && !popCalls().length; k++) await p.waitForTimeout(500); } }
    const pc = popCalls(); const body = pc.map(c => c.body || '').join('\n');
    const rows = await waitPopRows(p, tag, 6_000); const prs = rows > 0 ? (await popRows(p, tag, 300)) || [] : [];
    const m = await measure(p, tag); const fixed = (m?.conds || []).filter(c => divV && c.values.some(v => v.includes(divV))).map(c => `${c.label}='${c.values.join('|')}' ${c.disabled || c.readOnly ? '수정 불가' : '수정 가능'}`);
    // 키·값 둘 다 맞으면 전달 · 값만 있으면 4자 이상일 때만 전달로 본다(짧은 값 '81' 은 다른 칸에도 나올 수 있어 판정 불가)
    const chk = want.map(w => { const kv = w.k ? new RegExp(`"${esc(w.k.replace(/^.*\./, ''))}"\\s*:\\s*"[^"]*${esc(w.v)}`, 'i').test(body) : false; const any = body.toLowerCase().includes(w.v.toLowerCase()); return { ...w, ok: kv || (any && w.v.length >= 4), any, weak: !kv && any && w.v.length < 4 }; });
    const filt = canType && prs.length ? prs.filter(r => Object.values(r).some(v => String(v).toLowerCase().includes(typed.toLowerCase()))).length : -1;
    const ev = `'${hit.label}' 에 ${canType ? `'${typed}' 입력 후 ` : '(입력 없이) '}아이콘 → 팝업 '${m?.title || ''}' · ${via} · 팝업 조회 요청 ${pc.length}건(${[...new Set(pc.map(c => `${c.sheet}/${c.btn}`))].slice(0, 2).join(',') || '-'})`
      + ` · 인자 ${chk.map(c => `${c.k || '(키 미상)'}='${c.v}' ${c.ok ? '전달' : c.any ? '값만 있음(키 다름)' : '없음'}(${c.why})`).join(' · ')}`
      + ` · 팝업 ${rows}행${filt >= 0 ? ` 중 '${typed}' 포함 ${filt}행` : ''}${fixed.length ? ` · 고정 조건 ${fixed.join(', ')}` : ''}${g.st.n ? ` · 쓰기 요청 ${g.st.n}건 차단` : ''}`;
    let result: 'PASS' | 'FAIL' | 'ERROR' = 'PASS';
    if (!pc.length) result = 'ERROR';
    else if (!want.length) result = 'ERROR';
    else if (chk.some(c => !c.ok && !c.any)) result = 'FAIL';
    else if (chk.some(c => c.weak)) result = 'ERROR';
    else if (filt === 0) result = 'FAIL';
    else if (typed && canType && rows <= 0) result = 'ERROR';
    const tail = result === 'ERROR' ? (!pc.length ? ' · [측정 실패] 팝업 조회 요청 없음(자동 조회·Search 둘 다)' : !want.length ? ' · [측정 경로 없음] 대조할 AS-IS 인자 기대 없음(popup_args.csv·E02 facts)' : chk.some(c => c.weak) ? ' · 짧은 값이 키 없이 보여 전달 판정 불가' : ' · 팝업 0행(결과 필터 대조 재료 없음)')
      : result === 'FAIL' ? (chk.some(c => !c.ok && !c.any) ? ' · AS-IS 가 넘기는 인자가 팝업 조회 요청에 없음' : ` · 팝업 결과가 넣은 값 '${typed}' 로 걸러지지 않음`) : ' · AS-IS 인자와 같은 값이 팝업 조건으로 전달됨';
    await closeDialogSafely(nscm, p);
    return { result, ev: ev + tail };
  } finally {
    await g.off();
    if (canType) await inp.fill('').catch(() => undefined);
  }
}

