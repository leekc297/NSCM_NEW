// 스모크 추가 사이클 — <ID>.smoke.spec.ts 의 '조회조건 동작' · '공통 기능' 테스트가 쓴다 (2026-10-23 사용자 지시:
//   "E2E SMOKE 에 조회조건이 각각 정상 동작하는지, 공통버전의 기능이 정상 동작하는지" — 기존 smoke/crud/auth/authcrud 어느 단계에도 없던 검사).
//
//  ① conditionCycle — 조회조건마다: 라벨로 칸을 찾고 → 유형(콤보/체크박스/라디오/팝업/텍스트/기간)별로 값을 실제로 바꾸고 → 조회
//     → call-proc HTTP<400 · 오류 알림(ORA-/Exception) 없음 · 콘솔 치명 오류 없음 · 조회 인자(요청 본문) 변화 여부 기록.
//     + 기준표 순서(rules/search_cond.csv — 화면 좌→우·위→아래 배치) · Checkbox/Radio 디자인(hook #154 v2: 컨트롤 왼쪽 x = 같은 열 입력박스 왼쪽 x).
//  ② commonCycle — 공통(SubTitle·MainTitle) 기능: Search(F5) 버튼·F5 단축키 · Sort(F3) · Filter(F4) · Condition(F6) 저장 · Reset Condition(F10)
//     · Excel 다운로드(.xlsx 파일 생성) · Columns(컬럼 설정 모달 열림/닫힘) · Search Area 스위치(조회영역 접기/펼치기) · Manual(F1).
//     화면에 없는 버튼(hotkeyConfig=false)은 '해당없음'(NA) — 노출 여부 자체의 기대는 auth/authcrud 스펙이 본다.
//  판정 값: OK · FAIL(동작 오류) · WARN(동작은 됐으나 확인 필요 — 예: 조회 인자 변화 없음) · NA(해당없음) · ERROR(판정 불가 — 컨트롤을 못 찾음 등)
//  결과는 test.info().annotations 에 cond:/common: 한 줄씩 + condsum:/commonsum: 요약(report.js · recon.js 가 대조표 열로 집계)
import * as fs from 'node:fs';
import type { Locator, TestInfo } from '@playwright/test';
import type { Nscm, ProcCall } from './nscm';
import { CFG, FE } from './nscm';

export type Verdict = 'OK' | 'FAIL' | 'WARN' | 'NA' | 'ERROR';
export type Item = { name: string; kind: string; verdict: Verdict; note: string };
type Field = { label: string; labels?: string[]; component?: string; kind?: string; excluded?: boolean; excludedWhy?: string; asis?: string; popup?: boolean; required?: boolean };
export type SmokePlan = { menuId?: string; fields: Field[]; sample?: { div?: string; item?: string; project?: string; site?: string }; condOrder?: string[]; condGone?: Array<{ name: string; usage: string }> };

const ERR = /ORA-|PLS-|Exception|오류|error|실패|fail/i;
const FATAL = /Assertion failed|Uncaught|is not a function|Cannot read propert|Unknown property/i;
const norm = (s: string) => String(s || '').toLowerCase().replace(/[^a-z0-9가-힣]/g, '');

/** 조회 1회 + 결과 판정(HTTP·알림·콘솔). 반환: 판정 · 이번 조회 call-proc · 메모 */
export async function searchAndJudge(nscm: Nscm, consoleFrom: number): Promise<{ ok: boolean; calls: ProcCall[]; why: string }> {
  // 조건별 조회 대기 상한 45초 — 90초로 두면 조회가 안 나가는 조건이 몇 개만 있어도 테스트 제한(15분)을 넘는다(SCP0100 실측 15.7분)
  const calls = await nscm.search({ timeout: 45_000 });
  const why: string[] = [];
  if (!calls.length) why.push('조회 call-proc 없음');
  const bad = calls.filter(c => c.status >= 400); if (bad.length) why.push(`HTTP ${bad.map(c => `${c.sheet}/${c.btn}=${c.status}`).join(',')}`);
  const alert = await waitAlert(nscm, 1_500); if (alert) { if (ERR.test(alert)) why.push(`알림: ${alert.replace(/\s+/g, ' ').slice(0, 120)}`); await closeVisibleDialogs(nscm); }
  const fatal = nscm.consoleErrors.slice(consoleFrom).filter(e => FATAL.test(e)); if (fatal.length) why.push(`콘솔: ${fatal[0].slice(0, 120)}`);
  return { ok: !why.length, calls, why: why.join(' · ') };
}
const bodyOf = (calls: ProcCall[]) => calls.filter(c => !/SAVE|INS|UPD|DEL/i.test(c.btn)).map(c => `${c.sheet}/${c.btn}:${c.body || ''}`).join('\n');

/**
 * 조회조건 칸 찾기 — 조회영역(그리드·대화상자 밖)에서 라벨 글자가 정확히 같은 보이는 요소 → 위로 올라가며 컨트롤이 든 가장 가까운 칸.
 * 칸에 data-e2e-cond 속성을 달아 Locator 로 돌려준다. kind: combo · checkbox · radio · popup · period · text
 */
export async function findCond(nscm: Nscm, labels: string[], tag: string): Promise<{ root: Locator; kind: string; label: string; labelRight: number; ctlLeft: number; top: number; left: number } | null> {
  const page = nscm.page;
  // 2026-10-23 실측(SCP0100 DOM): FormItem = class 에 '_formItem_' (commonStyles.formItem) 이 붙은 칸 → 첫 자식 = 라벨 트랙(label>span), 둘째 자식 = 컨트롤.
  //   라벨 글자만으로 찾으면 라디오 선택지('Search Level')·콤보 표시값까지 걸려 옆 칸을 잡는다 → FormItem 칸의 '라벨 트랙' 글자로만 매칭한다.
  return page.evaluate(({ labels, tag }) => {
    const nrm = (s: string) => String(s || '').toLowerCase().replace(/[​ ]/g, '').replace(/^\s*\*+|\*+\s*$/g, '').replace(/[^a-z0-9가-힣]/g, '');
    const want = labels.map(nrm).filter(Boolean);
    const vis = (e: Element) => { const r = (e as HTMLElement).getBoundingClientRect(); return r.width > 0 && r.height > 0 && (e as HTMLElement).offsetParent !== null; };
    const outside = (e: Element) => !e.closest('.wj-flexgrid, [role="dialog"], [role="alertdialog"], .MuiDialog-root, header, nav, [class*="_tab_"]');
    const items = Array.from(document.querySelectorAll('[class*="_formItem_"], [class*="formItem"]')).filter(e => e.children.length >= 2 && vis(e) && outside(e) && !e.parentElement?.closest('[class*="_formItem_"]'));
    // 후보 우선순위대로(기준표 To-Be 명칭 → LBL 문구 → As-is 라벨) — 같은 화면에 비슷한 이름(라디오 'Search Mode' vs 콤보 'Search Level')이 있을 때 앞 후보가 이긴다
    const ordered = want.flatMap(w => items.filter(b => nrm(((b.firstElementChild as HTMLElement).innerText) || '') === w && !b.hasAttribute('data-e2e-cond')));
    for (const box of ordered) {
      const labTrack = box.firstElementChild as HTMLElement;
      const ctlPart = box.children[1] as HTMLElement; const ctl = ctlPart.querySelector('[role="combobox"], input[type="checkbox"], input[type="radio"], input:not([type="hidden"]), textarea');
      if (!ctl) continue;
      const radios = ctlPart.querySelectorAll('input[type="radio"]').length; const checks = ctlPart.querySelectorAll('input[type="checkbox"]').length; const combos = ctlPart.querySelectorAll('[role="combobox"]').length;
      const inputs = Array.from(ctlPart.querySelectorAll('input:not([type="hidden"]):not([type="checkbox"]):not([type="radio"])'));
      const kind = radios ? 'radio' : combos ? 'combo' : checks && !inputs.length ? 'checkbox' : inputs.length >= 2 || inputs.some(i => /YYYY|yyyy/.test((i as HTMLInputElement).placeholder || '')) ? 'period' : ctlPart.querySelector('button, svg[cursor="pointer"], [class*="SearchIcon"]') ? 'popup' : 'text';
      (box as HTMLElement).setAttribute('data-e2e-cond', tag);
      const labEl = (labTrack.querySelector('label, span') as HTMLElement) || labTrack; const lr = labEl.getBoundingClientRect();
      const target = (ctlPart.querySelector('input[type="checkbox"], input[type="radio"]') || ctl) as HTMLElement;
      const tr = ((target.closest('.MuiCheckbox-root, .MuiRadio-root, .MuiInputBase-root, .MuiAutocomplete-root') as HTMLElement) || target).getBoundingClientRect();
      return { kind, label: (labTrack.innerText || '').replace(/[​\n]/g, ' ').trim(), labelRight: Math.round(lr.right), ctlLeft: Math.round(tr.left), top: Math.round(lr.top), left: Math.round(lr.left) };
    }
    return null;
  }, { labels, tag }).then(r => (r ? Object.assign(r, { root: page.locator(`[data-e2e-cond="${tag}"]`).first() }) : null)).catch(() => null);
}

/** 콤보에서 현재 값과 다른 옵션 하나 선택(ALL/SELECT ALL 제외). 반환: 고른 옵션 글자('' = 못 고름) */
export async function pickComboOption(nscm: Nscm, root: Locator): Promise<string> {
  const page = nscm.page; const combo = root.locator('[role="combobox"]').first();
  const before = (await combo.inputValue().catch(() => '')) || (await root.innerText().catch(() => ''));
  await combo.click({ timeout: 5_000 }).catch(() => undefined);
  const opts = page.locator('.MuiAutocomplete-popper [role="option"], .MuiAutocomplete-popper li, [role="listbox"] [role="option"]');
  await opts.first().waitFor({ state: 'visible', timeout: 5_000 }).catch(() => undefined);
  const n = Math.min(await opts.count().catch(() => 0), 30); let picked = '';
  for (let i = 0; i < n; i++) {
    const t = (await opts.nth(i).innerText().catch(() => '')).trim();
    if (!t || /^(select\s*)?all$|^전체$/i.test(t) || norm(t) === norm(before)) continue;
    await opts.nth(i).click({ timeout: 5_000 }).catch(() => undefined); picked = t; break;
  }
  await page.keyboard.press('Escape').catch(() => undefined); await page.waitForTimeout(300);
  return picked;
}

export async function conditionCycle(nscm: Nscm, info: TestInfo, plan: SmokePlan): Promise<Item[]> {
  const items: Item[] = []; const page = nscm.page;
  await nscm.expandSearchArea();
  if (plan.sample && plan.sample.div) await nscm.setDivision(plan.sample.div);
  // 기준 조회 — 이후 조건별 조회 인자 변화의 비교 기준
  const base = await searchAndJudge(nscm, 0);
  items.push({ name: '(기준 조회)', kind: 'search', verdict: base.ok ? 'OK' : 'FAIL', note: base.why || `call-proc ${base.calls.length}` });
  let prevBody = bodyOf(base.calls);
  const found: Array<{ name: string; top: number; left: number; kind: string; labelRight: number; ctlLeft: number }> = [];
  let k = 0;
  for (const f of plan.fields) {
    const name = f.label.replace(/^\s*\*+|\*+\s*$/g, '').trim();
    if (f.excluded) { items.push({ name, kind: f.component || '', verdict: 'NA', note: `제외: ${f.excludedWhy || ''}`.slice(0, 160) }); continue; }
    // 앞 조건이 남긴 팝업·알림 정리(남아 있으면 이후 조건이 전부 ERROR 로 보였다 — SCP0100 2회차 실측)
    await closeVisibleDialogs(nscm); await page.keyboard.press('Escape').catch(() => undefined);
    const labs = f.labels && f.labels.length ? f.labels : [f.label];
    let c = await findCond(nscm, labs, `c${k++}`);
    if (!c) { await nscm.expandSearchArea(true); c = await findCond(nscm, labs, `c${k++}`); } // 접힌 조회영역(조회 후 접힘 등) 다시 펼쳐 1회 재시도
    if (!c) { items.push({ name, kind: f.component || '', verdict: 'ERROR', note: `라벨 [${labs.join(' | ')}] 칸을 찾지 못함 — 라벨 문구/다국어 확인` }); continue; }
    found.push({ name: c.label, top: c.top, left: c.left, kind: c.kind, labelRight: c.labelRight, ctlLeft: c.ctlLeft });
    const consoleFrom = nscm.consoleErrors.length; let action = ''; let changed = false;
    try {
      if (c.kind === 'checkbox') {
        const box = c.root.locator('input[type="checkbox"]').first(); const was = await box.isChecked().catch(() => false);
        await box.click({ timeout: 5_000, force: true }); changed = (await box.isChecked().catch(() => was)) !== was; action = `체크 ${was ? 'ON→OFF' : 'OFF→ON'}`;
      } else if (c.kind === 'radio') {
        const radios = c.root.locator('input[type="radio"]'); const n = await radios.count(); let idx = -1;
        for (let i = 0; i < n; i++) if (!(await radios.nth(i).isChecked().catch(() => true))) { idx = i; break; }
        if (idx >= 0) { await radios.nth(idx).click({ timeout: 5_000, force: true }); changed = await radios.nth(idx).isChecked().catch(() => false); action = `라디오 ${idx + 1}/${n} 선택`; } else action = '선택지 1개뿐';
      } else if (c.kind === 'combo') {
        const t = await pickComboOption(nscm, c.root); changed = !!t; action = t ? `옵션 '${t.slice(0, 30)}'` : '바꿀 옵션 없음(옵션 0 또는 ALL 만)';
      } else if (c.kind === 'popup') {
        // 팝업: 돋보기 → 모달 열림 → 첫 행 선택(더블클릭 또는 확인) → 칸 값 채워짐
        const icon = c.root.locator('button').last();
        const clickErr = await icon.click({ timeout: 5_000, force: true }).then(() => '').catch(e => String((e as Error).message || e).split('\n')[0].slice(0, 100));
        // 팝업 = 그리드를 품은 보이는 창. 공용 CustomDialog 모달리스(Project Popup 등)는 role=dialog 가 없다(2026-10-23 실측) → tagPopup 이 찾아 표지
        let dlg: Locator | null = null; const until = Date.now() + 10_000;
        while (!dlg && Date.now() < until) { dlg = await tagPopup(nscm, `p${k}`); if (!dlg) await page.waitForTimeout(300); }
        if (!dlg) { items.push({ name, kind: c.kind, verdict: clickErr ? 'FAIL' : 'ERROR', note: clickErr ? `돋보기 클릭 실패 — ${clickErr}` : '팝업 창을 자동 감지하지 못함 — 수동 확인 필요(SCP0100 Model 팝업은 수동 디버그에서 정상 열림 확인, 2026-10-23)' }); continue; }
        const dsearch = dlg.getByRole('button', { name: /^(조회|Search)(\(F5\))?$/ }).first(); if (await dsearch.isVisible().catch(() => false)) { await dsearch.click().catch(() => undefined); await page.waitForTimeout(1_500); }
        const row = dlg.locator('.wj-cells .wj-row').first();
        if (await row.isVisible({ timeout: 8_000 }).catch(() => false)) {
          const rowChk = row.locator('input[type="checkbox"]').first(); // 다중 선택 팝업 = 행 체크박스 + OK
          if (await rowChk.isVisible().catch(() => false)) await rowChk.check({ force: true, timeout: 5_000 }).catch(() => undefined);
          else await row.locator('.wj-cell').nth(1).dblclick({ timeout: 5_000 }).catch(() => undefined);
          await page.waitForTimeout(500);
        }
        if (await dlg.isVisible().catch(() => false)) { const okb = dlg.getByRole('button', { name: /^(확인|OK|Confirm|Select|선택|Apply|적용)$/i }).first(); if (await okb.isVisible().catch(() => false)) await okb.click().catch(() => undefined); }
        const closed = !(await dlg.isVisible({ timeout: 3_000 }).catch(() => false));
        if (!closed) { const cb = dlg.getByRole('button', { name: /^(Close|닫기|Cancel|취소)$/i }).first(); if (await cb.isVisible().catch(() => false)) await cb.click().catch(() => undefined); else await page.keyboard.press('Escape').catch(() => undefined); }
        const val = await c.root.locator('input').first().inputValue().catch(() => '');
        changed = !!val; action = `팝업 열림 · ${closed ? '선택 후 닫힘' : '닫히지 않음(Esc)'} · 값 '${val.slice(0, 30)}'`;
        if (!val) { items.push({ name, kind: c.kind, verdict: 'WARN', note: `${action} — 팝업 행 선택이 칸에 채워지지 않음(데이터 0건이면 정상)` }); continue; }
      } else if (c.kind === 'period') {
        const ins = c.root.locator('input:not([type="hidden"])'); const v1 = await ins.nth(0).inputValue().catch(() => ''); const v2 = await ins.nth(1).inputValue().catch(() => '');
        action = `기간 '${v1}' ~ '${v2}'`; changed = false;
        if (!v1 || (await ins.count()) > 1 && !v2) { items.push({ name, kind: c.kind, verdict: 'FAIL', note: `${action} — 초기 기간 빈값(DoD B24: As-is Form_Load 초기값)` }); continue; }
      } else {
        const inp = c.root.locator('input:not([type="hidden"]), textarea').first();
        const v = /model|nick|material|item/i.test(name) ? (plan.sample && plan.sample.item) || 'E2E_ZZZ' : /project|pjt/i.test(name) ? (plan.sample && plan.sample.project) || 'E2E_ZZZ' : 'E2E_ZZZ';
        await inp.fill(v, { timeout: 5_000 }); changed = (await inp.inputValue().catch(() => '')) === v; action = `입력 '${v}'`;
      }
    } catch (e) { items.push({ name, kind: c.kind, verdict: 'ERROR', note: `조작 실패: ${String((e as Error).message || e).split('\n')[0].slice(0, 140)}` }); await page.keyboard.press('Escape').catch(() => undefined); continue; }
    if (!changed && c.kind !== 'period') { items.push({ name, kind: c.kind, verdict: c.kind === 'combo' || c.kind === 'radio' ? 'WARN' : 'FAIL', note: `${action} — 값이 바뀌지 않음` }); continue; }
    const r = await searchAndJudge(nscm, consoleFrom); const body = bodyOf(r.calls);
    const argChanged = body !== prevBody; prevBody = body;
    const verdict: Verdict = !r.ok ? 'FAIL' : c.kind === 'period' || argChanged ? 'OK' : 'WARN';
    items.push({ name, kind: c.kind, verdict, note: `${action} → 조회 ${r.ok ? '정상' : '오류: ' + r.why}${r.ok && c.kind !== 'period' ? (argChanged ? ' · 조회 인자 변화 있음' : ' · 조회 인자 변화 없음(화면 표시용 조건이면 정상 — 배선 확인)') : ''}` });
    // 텍스트 조건은 다음 조건 조회에 영향이 없도록 비운다
    if (c.kind === 'text') await c.root.locator('input:not([type="hidden"]), textarea').first().fill('').catch(() => undefined);
  }
  // 기준표 순서(rules/search_cond.csv · 룰 E11) — 화면 배치 순서(위→아래 줄, 줄 안 왼→오른)와 기준표 순서 대조
  if (plan.condOrder && plan.condOrder.length) {
    const placed = [...found].sort((a, b) => (Math.abs(a.top - b.top) > 12 ? a.top - b.top : a.left - b.left)).map(x => norm(x.name));
    const want = plan.condOrder.map(norm).filter(w => placed.includes(w));
    const seq = placed.filter(p => want.includes(p));
    const okOrder = seq.join('|') === want.join('|');
    items.push({ name: '(기준표 순서)', kind: 'order', verdict: want.length < 2 ? 'NA' : okOrder ? 'OK' : 'FAIL', note: want.length < 2 ? '비교 대상 2개 미만' : okOrder ? want.join(' → ') : `화면 ${seq.join(' → ')} / 기준 ${want.join(' → ')}` });
  }
  // 기준표가 제외(삭제·Sun-Set·버튼영역 이동 등)한 조건이 화면에 남아 있는지
  for (const g of plan.condGone || []) {
    const hit = await findCond(nscm, [g.name], `g${k++}`);
    if (hit) items.push({ name: g.name, kind: 'gone', verdict: 'FAIL', note: `기준표 ${g.usage} 인데 조회조건에 남아 있음` });
  }
  // Checkbox/Radio 디자인(hook #154 v2) — 컨트롤 왼쪽 x 가 같은 열 다른 조건(콤보·입력)의 입력박스 왼쪽 x 와 같아야 한다(±6px)
  for (const t of found.filter(x => x.kind === 'checkbox' || x.kind === 'radio')) {
    const col = found.filter(x => x !== t && x.kind !== 'checkbox' && x.kind !== 'radio' && Math.abs(x.labelRight - t.labelRight) <= 8);
    if (!col.length) { items.push({ name: `${t.name}(디자인)`, kind: 'design', verdict: 'NA', note: '같은 열 비교 대상 없음' }); continue; }
    const d = Math.min(...col.map(x => Math.abs(x.ctlLeft - t.ctlLeft)));
    items.push({ name: `${t.name}(디자인)`, kind: 'design', verdict: d <= 6 ? 'OK' : 'FAIL', note: d <= 6 ? `라벨 열 조건명 · 컨트롤 x 일치(Δ${d}px)` : `컨트롤 x 가 같은 열 입력박스와 ${d}px 어긋남 — hook #154 v2(조건명=FormItem 라벨, 박스는 입력 열 시작선)` });
  }
  return items;
}

export async function commonCycle(nscm: Nscm, info: TestInfo, plan: SmokePlan): Promise<Item[]> {
  const items: Item[] = []; const page = nscm.page;
  const add = (name: string, verdict: Verdict, note: string) => items.push({ name, kind: 'common', verdict, note });
  if (plan.sample && plan.sample.div) await nscm.setDivision(plan.sample.div);
  // 1) Search 버튼(SearchArea) — 데이터가 있어야 Excel·Sort·Filter 판정이 의미 있다
  { const from = nscm.consoleErrors.length; const r = await searchAndJudge(nscm, from); add('Search(조회 버튼)', r.ok ? 'OK' : 'FAIL', r.ok ? `call-proc ${r.calls.length} · 행 ${r.calls.map(c => c.rows ?? '?').join('/')}` : r.why); }
  const grid = nscm.grid(0); const hasGrid = await grid.isVisible({ timeout: 3_000 }).catch(() => false);
  // 2) F5 단축키 — 그리드에 포커스 후 F5 → 조회 call-proc
  if (hasGrid) {
    await grid.locator('.wj-cells .wj-cell').first().click({ timeout: 3_000 }).catch(() => undefined);
    const before = nscm.calls.length;
    const w = page.waitForResponse(r => /call-proc/.test(r.url()) && !/\/(SAVE|INS|UPD|DEL)[^/]*\/call-proc/i.test(r.url()), { timeout: 60_000 }).catch(() => undefined);
    await page.keyboard.press('F5'); await w; await page.waitForTimeout(500); await nscm.clearDialogs();
    const n = nscm.calls.length - before; add('F5 단축키(조회)', n > 0 ? 'OK' : 'FAIL', n > 0 ? `call-proc ${n}` : '그리드 포커스 후 F5 → 조회 호출 없음');
  } else add('F5 단축키(조회)', 'NA', '그리드 없음');
  // 3) Sort(F3) · Filter(F4) — 클릭 후 콘솔 치명 오류 없음 · Filter 는 헤더 필터 아이콘 표시
  for (const [nm, re, check] of [['Sort(F3)', /^Sort(\(F3\))?$/i, ''], ['Filter(F4)', /^Filter(\(F4\))?$/i, '.wj-elem-filter, .wj-glyph-filter']] as const) {
    const b = await nscm.visibleFirst(page.getByRole('button', { name: re }));
    if (!b) { add(nm, 'NA', '버튼 없음(hotkeyConfig=false)'); continue; }
    // 사용자처럼 데이터 셀 하나를 선택한 뒤 누른다(헤더 그룹 셀 선택 상태에서는 컬럼 binding 이 없을 수 있음)
    if (hasGrid) await grid.locator('.wj-cells .wj-row').first().locator('.wj-cell').nth(2).click({ timeout: 3_000 }).catch(() => undefined);
    const from = nscm.consoleErrors.length; await b.click({ timeout: 5_000 }).catch(() => undefined); await page.waitForTimeout(600);
    const fatal = nscm.consoleErrors.slice(from).filter(e => FATAL.test(e)); const alert = await waitAlert(nscm, 800); if (alert) await closeVisibleDialogs(nscm);
    let extra = ''; if (check && hasGrid) { const icons = await grid.locator(check).count().catch(() => 0); extra = ` · 필터 아이콘 ${icons}`; }
    add(nm, fatal.length || (alert && ERR.test(alert)) ? 'FAIL' : 'OK', fatal.length ? `콘솔: ${fatal[0].slice(0, 120)}` : alert && ERR.test(alert) ? `알림: ${alert.slice(0, 100)}` : `클릭 정상${extra}`);
    if (check) { await b.click({ timeout: 5_000 }).catch(() => undefined); await page.waitForTimeout(300); } // 필터 원복
  }
  // 4·5 전처리 — Condition 저장 / Reset Condition 은 사내 DB 의 '테스트 계정 개인 저장 조회조건'(USER_ID×MNU_ID)을 바꾼다.
  //   기존 저장분을 GET 으로 떠 두고 4·5 가 끝나면 그대로 다시 저장해 복원한다(사용자 저장값 보호 · 사내 원장 비파괴 원칙).
  const condApi = `${FE}${CFG.feApiPrefix ?? '/api'}/admin/menu/${encodeURIComponent(plan.menuId || '')}/search-conditions`;
  // 응답 모양 = BaseResponse({ data: [...] } 등) — 첫 배열 값을 행 목록으로 본다
  const savedCount = async () => page.evaluate(async u => { try { const r = await fetch(u, { credentials: 'include' }); if (!r.ok) return -1; const j = await r.json(); if (Array.isArray(j)) return j.length; const arr = j && typeof j === 'object' ? Object.values(j as Record<string, unknown>).find(v => Array.isArray(v)) : null; return Array.isArray(arr) ? arr.length : (j && j.data == null ? 0 : -1); } catch { return -1; } }, condApi);
  const backup = plan.menuId ? await page.evaluate(async u => { try { const r = await fetch(u, { credentials: 'include' }); if (!r.ok) return { ok: false, rows: [] as Array<{ paramNm: string; paramCtn: string }> }; const j = await r.json(); const d = Array.isArray(j) ? j : (j && typeof j === 'object' ? Object.values(j as Record<string, unknown>).find(v => Array.isArray(v)) : null) || []; return { ok: true, rows: (d as Array<Record<string, unknown>>).map(x => ({ paramNm: String(x.paramNm ?? ''), paramCtn: String(x.paramCtn ?? '') })).filter(x => x.paramNm) }; } catch { return { ok: false, rows: [] as Array<{ paramNm: string; paramCtn: string }> }; } }, condApi) : { ok: false, rows: [] };
  // 4) Condition(F6) 저장 → '조회 조건이 저장되었습니다' 알림(실패 문구면 FAIL)
  { const b = await nscm.visibleFirst(page.getByRole('button', { name: /^Condition(\(F6\))?$/i }));
    if (!b) add('Condition(F6) 조회조건 저장', 'NA', '버튼 없음');
    else { await b.click({ timeout: 5_000 }).catch(() => undefined); const a = await waitAlert(nscm); await closeVisibleDialogs(nscm);
      const n = await savedCount(); // 저장 결과를 DB 에서 다시 읽어 확인(알림만 믿지 않음)
      add('Condition(F6) 조회조건 저장', !a || /실패|fail|error|오류/i.test(a) ? 'FAIL' : n === 0 ? 'WARN' : 'OK', `${a ? `알림 '${a.replace(/\s+/g, ' ').slice(0, 60)}'` : '저장 결과 알림 없음'} · 저장 행 ${n < 0 ? '조회 실패' : n}`); } }
  // 5) Reset Condition(F10) → 확인(Confirm) → 초기화 알림 → 저장 행 0
  { const b = await nscm.visibleFirst(page.getByRole('button', { name: /^Reset Condition(\(F10\))?$/i }));
    if (!b) add('Reset Condition(F10) 조회조건 초기화', 'NA', '버튼 없음');
    else { await b.click({ timeout: 5_000 }).catch(() => undefined); const q = await waitAlert(nscm);
      const dq = await nscm.visibleFirst(page.locator('[role="dialog"], [role="alertdialog"]'), 20);
      if (dq) { const ok = dq.getByRole('button', { name: /^(Confirm|확인|OK|Yes|예)$/i }).first(); await ok.click({ timeout: 5_000 }).catch(() => undefined); await page.waitForTimeout(500); }
      const a = await waitAlert(nscm); await closeVisibleDialogs(nscm); const n = await savedCount();
      add('Reset Condition(F10) 조회조건 초기화', !q || (a && /실패|fail|error|오류/i.test(a)) ? 'FAIL' : n > 0 ? 'FAIL' : 'OK', `확인 '${(q || '').replace(/\s+/g, ' ').slice(0, 40)}' → 결과 '${(a || '').replace(/\s+/g, ' ').slice(0, 40)}' · 남은 저장 행 ${n < 0 ? '조회 실패' : n}`); } }
  // 4·5 후처리 — 기존 저장 조회조건 복원(있었던 경우만). 실패하면 ERROR 로 남겨 사람이 복원하게 한다
  if (backup.ok && backup.rows.length) {
    const st = await page.evaluate(async ({ u, rows }) => { try { const r = await fetch(u, { method: 'POST', credentials: 'include', headers: { 'content-type': 'application/json' }, body: JSON.stringify(rows) }); return r.status; } catch { return 0; } }, { u: condApi, rows: backup.rows });
    add('(저장 조회조건 복원)', st >= 200 && st < 300 ? 'OK' : 'ERROR', `테스트 전 저장값 ${backup.rows.length}건 재저장 HTTP ${st}${st >= 200 && st < 300 ? '' : ' — 수동 복원 필요: ' + JSON.stringify(backup.rows).slice(0, 200)}`);
  } else if (!backup.ok) add('(저장 조회조건 백업)', 'WARN', '테스트 전 저장값 조회 실패 — Condition/Reset 후 복원 생략(저장값이 없었다면 영향 없음)');
  // 6) Excel 다운로드 — Tooltip(aria-label='Excel') 아이콘 버튼 → download 이벤트 · .xlsx · 0바이트 아님
  { const holder = await nscm.visibleFirst(page.locator('[aria-label="Excel"] button, [title="Excel"] button, button[aria-label="Excel"]'));
    if (!holder) add('Excel 다운로드', 'NA', '버튼 없음');
    else if (!hasGrid) add('Excel 다운로드', 'NA', '그리드 없음');
    else { const dl = page.waitForEvent('download', { timeout: 60_000 }).catch(() => null); await holder.click({ timeout: 5_000 }).catch(() => undefined); const d = await dl;
      if (!d) add('Excel 다운로드', 'FAIL', '60초 안에 파일 다운로드 없음');
      else { const fn = d.suggestedFilename(); const p = await d.path().catch(() => null); let size = 0; try { size = p ? fs.statSync(p).size : 0; } catch { size = 0; }
        add('Excel 다운로드', /\.xlsx$/i.test(fn) && size > 0 ? 'OK' : 'FAIL', `'${fn}' ${size}B`);
        await d.delete().catch(() => undefined); } } } // 받은 xlsx(zip) 는 판정 후 삭제 — 남겨 두면 결과 첨부 단계에서 zip 판독 오류가 났다(2026-10-23 실측)
  // 7) Columns(컬럼 설정) — 모달 열림 → 닫기
  { const b = await nscm.visibleFirst(page.getByRole('button', { name: /^(Columns?|Column Setting|컬럼\s*설정)$/i }));
    if (!b) add('Columns 컬럼 설정', 'NA', '버튼 없음');
    else { await b.click({ timeout: 5_000 }).catch(() => undefined); let dlg: Locator | null = null; const until = Date.now() + 6_000; while (!dlg && Date.now() < until) { dlg = await nscm.visibleFirst(page.locator('[role="dialog"], .MuiDialog-paper, [role="presentation"] .MuiPaper-root'), 20); if (!dlg) await page.waitForTimeout(300); }
      const open = !!dlg; const txt = dlg ? (await dlg.innerText().catch(() => '')).slice(0, 4000) : '';
      const noCol = /No Column/i.test(txt);
      if (dlg) { const cancel = dlg.getByRole('button', { name: /^(Cancel|취소|Close|닫기)$/i }).first(); if (await cancel.isVisible().catch(() => false)) await cancel.click().catch(() => undefined); else await page.keyboard.press('Escape'); }
      add('Columns 컬럼 설정', !open ? 'FAIL' : noCol ? 'FAIL' : 'OK', !open ? '클릭 후 설정 창이 열리지 않음' : noCol ? "설정 창 목록 'No Column'(fallbackColumns 누락 — check.js H02)" : '설정 창 열림·닫힘'); } }
  // 8) Search Area 스위치(MainTitle) — 끄면 조회영역 숨김 · 켜면 다시 보임
  // MainTitle(titleAreaWrapper) 의 MUI Switch(label 'Search Area' = LBL00324) — 2026-10-23 DOM 실측
  { const sw = (await nscm.visibleFirst(page.locator('[class*="titleAreaWrapper"] .MuiSwitch-root'))) || (await nscm.visibleFirst(page.getByRole('switch', { name: /Search Area|조회\s*영역/i }))) || (await nscm.visibleFirst(page.getByLabel(/^\s*_?(Search Area|조회\s*영역)\s*$/i))) || (await nscm.visibleFirst(page.locator('label').filter({ hasText: /Search Area|조회\s*영역/i }).locator('input[type="checkbox"]')));
    if (!sw) add('Search Area 조회영역 토글', 'NA', '스위치 없음');
    // SearchArea 는 isHidden 이어도 언마운트하지 않고 MUI Collapse 로 접는다 → 표시 = 조회조건 칸을 감싼 Collapse 들의 높이가 모두 > 5px
    else { const shown = async () => page.evaluate(() => { const fi = Array.from(document.querySelectorAll('[class*="_formItem_"]')).find(e => !e.closest('[role="dialog"], .wj-flexgrid') && (e as HTMLElement).offsetParent !== null); if (!fi) return false; for (let p = fi.parentElement; p; p = p.parentElement) if (p.classList.contains('MuiCollapse-root') && p.getBoundingClientRect().height <= 5) return false; return true; }).catch(() => false);
      const vis0 = await shown(); await sw.click({ force: true, timeout: 5_000 }).catch(() => undefined); await page.waitForTimeout(900);
      const vis1 = await shown(); await sw.click({ force: true, timeout: 5_000 }).catch(() => undefined); await page.waitForTimeout(900);
      const vis2 = await shown();
      add('Search Area 조회영역 토글', vis0 && !vis1 && vis2 ? 'OK' : vis0 === vis1 ? 'ERROR' : 'FAIL', vis0 === vis1 ? `스위치 클릭 후 조회영역 변화 감지 못함(${vis0}→${vis1}→${vis2}) — 자동 판정 불가, 수동 확인 필요` : `조회영역(조회조건 칸) 표시 ${vis0}→${vis1}→${vis2}`); } }
  // 9) Manual(F1) — 공통 GridAction.getManual 은 현재 TODO(console.error 자리표시) → 동작 없음을 그대로 기록(화면 결함 아님)
  { const b = await nscm.visibleFirst(page.getByRole('button', { name: /^Manual(\(F1\))?$/i }));
    if (!b) add('Manual(F1)', 'NA', '버튼 없음');
    else { const pop = page.context().waitForEvent('page', { timeout: 5_000 }).catch(() => null); const from = nscm.consoleErrors.length; await b.click({ timeout: 5_000 }).catch(() => undefined); const np = await pop;
      const dlg = await page.locator('[role="dialog"], .MuiDialog-root').last().isVisible({ timeout: 1_000 }).catch(() => false);
      if (np) { add('Manual(F1)', 'OK', `새 창 ${np.url().slice(0, 80)}`); await np.close().catch(() => undefined); }
      else if (dlg) { add('Manual(F1)', 'OK', '매뉴얼 창 열림'); await nscm.clearDialogs(); }
      else add('Manual(F1)', 'WARN', `열림 없음 — 공통 GridAction.getManual 미구현(TODO, console.error ${nscm.consoleErrors.length - from}건). 화면 결함 아님`); } }
  void info;
  return items;
}

// 알림 = 보이는 대화상자(role=dialog — 확인 버튼형) 또는 토스트(role=alert — MuiAlert). 숨은 keep-alive 대화상자가 .last() 로 잡히던 문제(2026-10-23 실측) → 보이는 것만
export async function waitAlert(nscm: Nscm, ms = 8_000): Promise<string> {
  // 보이는 것 중 글자가 있는 첫 요소 — 빈 토스트(role=alert, 글자 없음)가 먼저 잡혀 대화상자 글자를 못 읽던 문제(2026-10-23 실측)
  const end = Date.now() + ms; const loc = nscm.page.locator('[role="dialog"], [role="alertdialog"], [role="alert"]');
  while (Date.now() < end) {
    const n = Math.min(await loc.count().catch(() => 0), 30);
    for (let i = 0; i < n; i++) { const e = loc.nth(i); if (!(await e.isVisible().catch(() => false))) continue; const t = (await e.innerText().catch(() => '')).trim(); if (t) return t; }
    await nscm.page.waitForTimeout(250);
  }
  return '';
}
export async function closeVisibleDialogs(nscm: Nscm) {
  for (let k = 0; k < 4; k++) { const d = await nscm.visibleFirst(nscm.page.locator('[role="dialog"], [role="alertdialog"]'), 20); if (!d) break; const b = d.getByRole('button', { name: /^(확인|OK|Confirm|Yes|예|닫기|Close)$/i }).first(); if (await b.isVisible().catch(() => false)) await b.click().catch(() => undefined); else await nscm.page.keyboard.press('Escape'); await nscm.page.waitForTimeout(300); }
  // role 없는 모달리스 팝업(그리드 + Close 버튼)도 닫는다
  for (let k = 0; k < 3; k++) { const p = await tagPopup(nscm, `close${k}`); if (!p) return; const b = p.getByRole('button', { name: /^(Close|닫기|Cancel|취소)$/i }).first(); if (await b.isVisible().catch(() => false)) await b.click().catch(() => undefined); else await nscm.page.keyboard.press('Escape'); await nscm.page.waitForTimeout(400); }
}
/** 보이는 팝업 창 찾기 — 'Close/닫기' 버튼에서 위로 올라가 그리드(.wj-flexgrid)를 함께 품은 가장 가까운 요소. MDI 탭의 'Close others/All' 은 제외(정확히 Close) */
export async function tagPopup(nscm: Nscm, tag: string): Promise<Locator | null> {
  const ok = await nscm.page.evaluate(t => {
    const vis = (e: Element) => { const r = (e as HTMLElement).getBoundingClientRect(); return r.width > 0 && r.height > 0; };
    // ① 보이는 role=dialog(모달 — 조회 전이라 그리드가 아직 없을 수 있음: Material by Division 실측) ② role 없는 모달리스 = Close 버튼에서 위로 그리드를 품은 조상
    const dlg = Array.from(document.querySelectorAll('[role="dialog"]')).find(e => { const r = (e as HTMLElement).getBoundingClientRect(); return r.width > 200 && r.height > 100; });
    if (dlg) { (dlg as HTMLElement).setAttribute('data-e2e-pop', t); return true; }
    for (const b of Array.from(document.querySelectorAll('button'))) {
      if (!vis(b) || !/^(Close|닫기)$/.test((b.innerText || '').trim())) continue;
      let p: Element | null = b.parentElement;
      for (let d = 0; p && d < 14; d++, p = p.parentElement) { if (p.querySelector('.wj-flexgrid') && vis(p)) { if (p === document.body) break; (p as HTMLElement).setAttribute('data-e2e-pop', t); return true; } }
    }
    return false;
  }, tag).catch(() => false);
  return ok ? nscm.page.locator(`[data-e2e-pop="${tag}"]`).first() : null;
}

/** 결과 기록 — 한 줄씩 cond:/common: 어노테이션 + 요약(condsum/commonsum: OK/전체 · FAIL n · WARN n · ERROR n) */
export function record(info: TestInfo, type: 'cond' | 'common', items: Item[]) {
  for (const it of items) info.annotations.push({ type, description: `[${it.verdict}] ${it.name}(${it.kind}) — ${it.note}`.slice(0, 400) });
  const judged = items.filter(i => i.verdict !== 'NA');
  const c = (v: Verdict) => items.filter(i => i.verdict === v).length;
  info.annotations.push({ type: `${type}sum`, description: `${c('OK')}/${judged.length} OK · FAIL ${c('FAIL')} · WARN ${c('WARN')} · ERROR ${c('ERROR')} · NA ${c('NA')}` });
  return { ok: c('OK'), total: judged.length, fail: c('FAIL'), warn: c('WARN'), error: c('ERROR') };
}
