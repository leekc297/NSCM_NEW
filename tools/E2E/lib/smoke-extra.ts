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
import { probe } from './probe';

export type Verdict = 'OK' | 'FAIL' | 'WARN' | 'NA' | 'ERROR';
export type Item = { name: string; kind: string; verdict: Verdict; note: string };
type Field = { label: string; labels?: string[]; component?: string; kind?: string; excluded?: boolean; excludedWhy?: string; asis?: string; popup?: boolean; required?: boolean; key?: string };
export type SmokePlan = { menuId?: string; fields: Field[]; sample?: { div?: string; item?: string; project?: string; site?: string }; condOrder?: string[]; condGone?: Array<{ name: string; usage: string }>; condNotUse?: Array<{ asis: string; key: string; labels: string[] }> };

/**
 * 남아 있는 다이얼로그를 '저장 없이' 닫는다 (2026-11-05 T57). 닫기 수단 우선순위:
 *   ① Cancel/취소/Close/닫기 버튼 → ② 머리의 X(CustomDialogContent 의 ControlCloseIcon — button 이 아니라 onClick 달린 SVG, cursor:pointer, 다이얼로그 상단 우측)
 *   → ③ 버튼이 Confirm/확인/OK 하나뿐인 알림이면 그 버튼 → ④ Escape.
 *   Save/저장/Default/OK(다른 버튼과 함께 있을 때) 는 절대 누르지 않는다 — Column Setting 모달에서 nscm.closeAlert('ok') 가 'Save' 를 눌러 사용자 컬럼 설정을 덮어쓸 수 있다.
 * 반환: 닫은 수단('Cancel'|'X'|'Confirm'|'Escape' · 여러 개면 '+' 연결), 아무것도 없었으면 '', 끝까지 남으면 '열림: <머리글>'.
 * reportOnly=true 면 닫기 시도 후 남은 다이얼로그를 '열림: …' 로 보고(Search Area 단계의 가림 요소 판정용).
 */
export async function closeDialogSafely(nscm: Nscm, page: import('@playwright/test').Page, reportOnly = false): Promise<string> {
  const used: string[] = [];
  const visibleDlg = () => page.locator('[role="dialog"]:visible, [role="alertdialog"]:visible, .MuiDialog-paper:visible').last();
  for (let k = 0; k < 3; k++) {
    const dlg = visibleDlg();
    if (!(await dlg.isVisible({ timeout: 300 }).catch(() => false))) break;
    const title = ((await dlg.innerText().catch(() => '')).trim().split('\n')[0] || '').slice(0, 40);
    const cancel = dlg.getByRole('button', { name: /^(Cancel|취소|Close|닫기)$/i }).first();
    let how = '';
    if (await cancel.isVisible().catch(() => false)) { await cancel.click({ timeout: 3_000 }).catch(() => undefined); how = 'Cancel'; }
    else {
      // ② 머리 X: 다이얼로그 상단 56px 안에서 cursor:pointer 인 svg 중 가장 오른쪽 — React 위임 리스너라 네이티브 click 이벤트로 닿는다
      const hit = await dlg.evaluate(d => {
        const r = d.getBoundingClientRect(); const svgs = Array.from(d.querySelectorAll('svg')) as SVGElement[];
        const cand = svgs.filter(s => { const b = s.getBoundingClientRect(); return b.width > 0 && b.top < r.top + 56 && getComputedStyle(s).cursor === 'pointer'; })
          .sort((a, b) => b.getBoundingClientRect().right - a.getBoundingClientRect().right)[0];
        if (!cand) return false; cand.dispatchEvent(new MouseEvent('click', { bubbles: true, cancelable: true, view: window })); return true;
      }).catch(() => false);
      if (hit) how = 'X';
      else {
        const btns = dlg.getByRole('button'); const n = await btns.count().catch(() => 0);
        const only = n === 1 ? btns.first() : null;
        if (only && /^(Confirm|확인|OK|Yes|예)$/i.test(((await only.innerText().catch(() => '')) || '').trim())) { await only.click({ timeout: 3_000 }).catch(() => undefined); how = 'Confirm'; }
        else { await page.keyboard.press('Escape'); how = 'Escape'; }
      }
    }
    await page.waitForTimeout(600);
    if (await dlg.isVisible({ timeout: 300 }).catch(() => false)) {
      if (how === 'Escape' || k === 2) return `열림: '${title}' (${[...used, how].join('+')} 무반응)`;
      // X/Cancel 이 안 먹으면 다음 루프에서 다른 수단을 시도하지 않고 바로 보고 — 같은 다이얼로그에 Save 류를 누르는 일이 없도록
      return `열림: '${title}' (${[...used, how].join('+')} 무반응)`;
    }
    used.push(how);
  }
  if (!used.length) return reportOnly ? '' : '';
  return used.join('+');
}

/** 조회조건 칸의 현재 표시값(입력값·선택 칩·라디오) — Condition 저장 복원·Reset 화면값 유지 판정용(2026-10-30 G3). 못 찾으면 null */
async function condSnapshot(nscm: Nscm, plan: SmokePlan, tag: string): Promise<Map<string, string>> {
  const out = new Map<string, string>(); let k = 0;
  for (const f of plan.fields || []) {
    if (f.excluded) continue;
    const labels = (f.labels && f.labels.length ? f.labels : [f.label]).filter(Boolean);
    const c = await findCond(nscm, labels, `${tag}${k++}`).catch(() => null);
    if (!c) continue;
    const v = await c.root.evaluate((root: HTMLElement) => {
      const clean = (s: string) => (s || '').replace(/[​ ]/g, '').trim();
      const chips = [...root.querySelectorAll('.MuiChip-label, [class*="chip"], [class*="Chip"]')].map(e => clean((e as HTMLElement).innerText)).filter(Boolean);
      if (chips.length) return chips.join('|');
      const ins = [...root.querySelectorAll('input:not([type="hidden"]), textarea')] as HTMLInputElement[];
      const checked = ins.filter(i => (i.type === 'radio' || i.type === 'checkbox') && i.checked).map(i => i.value || i.id || 'on');
      if (checked.length) return checked.join('|');
      return ins.map(i => clean(i.value)).filter(Boolean).join('|');
    }).catch(() => '');
    out.set(f.key || f.label, v);
  }
  return out;
}
const nk = (s: string) => (s || '').toLowerCase().replace(/[^a-z0-9]/g, '');

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
    const alias: Record<string, string> = { div: 'division', division: 'div' };  // 'Div.'↔'Division' 라벨 별칭(2026-10-29 SCP0041 '상위 조회조건 [Division] 칸 없음' 허위 FAIL)
    const want = labels.flatMap(l => { const n = nrm(l); return alias[n] ? [n, alias[n]] : [n]; }).filter(Boolean);
    const vis = (e: Element) => { const r = (e as HTMLElement).getBoundingClientRect(); return r.width > 0 && r.height > 0 && (e as HTMLElement).offsetParent !== null; };
    const outside = (e: Element) => !e.closest('.wj-flexgrid, [role="dialog"], [role="alertdialog"], .MuiDialog-root, header, nav, [class*="_tab_"]');
    const items = Array.from(document.querySelectorAll('[class*="_formItem_"], [class*="formItem"]')).filter(e => e.children.length >= 2 && vis(e) && outside(e) && !e.parentElement?.closest('[class*="_formItem_"]'));
    // 후보 우선순위대로(기준표 To-Be 명칭 → LBL 문구 → As-is 라벨) — 같은 화면에 비슷한 이름(라디오 'Search Mode' vs 콤보 'Search Level')이 있을 때 앞 후보가 이긴다
    let ordered = want.flatMap(w => items.filter(b => nrm(((b.firstElementChild as HTMLElement).innerText) || '') === w && !b.hasAttribute('data-e2e-cond')));
    // 앞선 탐색이 남긴 표시 때문에 같은 칸을 못 찾으면 '칸 없음' 허위 FAIL 이 된다(2026-11-01 SCP0028 Valid·Model) — 표시된 칸도 다시 쓴다
    if (!ordered.length) ordered = want.flatMap(w => items.filter(b => nrm(((b.firstElementChild as HTMLElement).innerText) || '') === w));
    for (const box of ordered) {
      const labTrack = box.firstElementChild as HTMLElement;
      const ctlPart = box.children[1] as HTMLElement; const ctl = ctlPart.querySelector('[role="combobox"], input[type="checkbox"], input[type="radio"], input:not([type="hidden"]), textarea');
      const calOnly = !ctl && !!ctlPart.querySelector('[aria-label*="calendar" i], [class*="dateBox" i]');  // 2026-11-06 T110: 달력 전용 기간 칸(PeriodRangePicker textInputEnabled=false — input 없음)
      if (!ctl && !calOnly) continue;
      const radios = ctlPart.querySelectorAll('input[type="radio"]').length; const checks = ctlPart.querySelectorAll('input[type="checkbox"]').length; const combos = ctlPart.querySelectorAll('[role="combobox"]').length;
      const inputs = Array.from(ctlPart.querySelectorAll('input:not([type="hidden"]):not([type="checkbox"]):not([type="radio"])'));
      const kind = calOnly ? 'period' : radios ? 'radio' : combos ? 'combo' : checks && !inputs.length ? 'checkbox' : inputs.length >= 2 || inputs.some(i => /YYYY|yyyy/.test((i as HTMLInputElement).placeholder || '')) ? 'period' : ctlPart.querySelector('button, svg[cursor="pointer"], [class*="SearchIcon"]') ? 'popup' : 'text';
      (box as HTMLElement).setAttribute('data-e2e-cond', tag);
      const labEl = (labTrack.querySelector('label, span') as HTMLElement) || labTrack; const lr = labEl.getBoundingClientRect();
      const target = (ctlPart.querySelector('input[type="checkbox"], input[type="radio"]') || ctl) as HTMLElement;
      const tr = ((target.closest('.MuiCheckbox-root, .MuiRadio-root, .MuiInputBase-root, .MuiAutocomplete-root') as HTMLElement) || target).getBoundingClientRect();
      return { kind, label: (labTrack.innerText || '').replace(/[​\n]/g, ' ').trim(), labelRight: Math.round(lr.right), ctlLeft: Math.round(tr.left), top: Math.round(lr.top), left: Math.round(lr.left) };
    }
    // 라벨 없는 체크박스/라디오 칸(hook #154: 왼쪽 라벨 열 + 컨트롤 · FormItem 1자식) — 컨트롤 라벨(MuiFormControlLabel) 텍스트로 찾는다(2026-10-29 SCP0100 Cell Qty·A/S '칸 없음')
    for (const w of want) {
      const lab = Array.from(document.querySelectorAll('label')).find(l => !l.closest('.wj-flexgrid, [role="dialog"], .MuiDialog-root') && vis(l) && nrm((l as HTMLElement).innerText || '') === w && !!l.querySelector('input[type="checkbox"], input[type="radio"]') && !l.hasAttribute('data-e2e-cond'));
      if (lab) {
        lab.setAttribute('data-e2e-cond', tag);
        const inp = lab.querySelector('input') as HTMLElement; const lr = lab.getBoundingClientRect(); const tr = inp.getBoundingClientRect();
        return { kind: inp.getAttribute('type') === 'radio' ? 'radio' : 'checkbox', label: ((lab as HTMLElement).innerText || '').trim(), labelRight: Math.round(lr.right), ctlLeft: Math.round(tr.left), top: Math.round(lr.top), left: Math.round(lr.left) };
      }
    }
    return null;
  }, { labels, tag }).then(r => (r ? Object.assign(r, { root: page.locator(`[data-e2e-cond="${tag}"]`).first() }) : null)).catch(() => null);
}

/** 조회조건 칸 찾기 + 모드 전환: 기본 모드에서 안 보이는 조건(SCP0100 'Search Mode' 라디오 = Search Level / Detail 전용 칸)은 조회영역 라디오를 바꿔 가며 다시 찾는다(2026-10-29).
 *  드러나지 않은 토글은 원래 선택으로 되돌린다(다른 조건 측정에 영향 없게). */
export async function findCondAny(nscm: Nscm, labels: string[], tag: string): Promise<Awaited<ReturnType<typeof findCond>>> {
  const first = await findCond(nscm, labels, tag); if (first) return first;
  const page = nscm.page;
  const radios = page.locator('[class*="_formItem_"] input[type="radio"], [class*="formItem"] input[type="radio"]');
  const n = Math.min(await radios.count().catch(() => 0), 16);
  for (let i = 0; i < n; i++) {
    const r = radios.nth(i);
    if (await r.isChecked().catch(() => true)) continue;
    if (await r.evaluate(e => !!e.closest('.wj-flexgrid, [role="dialog"], .MuiDialog-root')).catch(() => true)) continue;
    const grp = await r.getAttribute('name').catch(() => null);
    const prev = grp ? page.locator(`input[type="radio"][name="${grp}"]:checked`).first() : null;
    await r.click({ timeout: 3_000, force: true }).catch(() => undefined); await page.waitForTimeout(400);
    const box = await findCond(nscm, labels, tag); if (box) return box;
    if (prev && await prev.count().catch(() => 0)) { await prev.click({ timeout: 3_000, force: true }).catch(() => undefined); await page.waitForTimeout(200); }
  }
  return null;
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
        const dsearch = dlg.getByRole('button', { name: /^(조회|Search)(\(F5\))?$/ }).first(); if (await dsearch.isVisible().catch(() => false)) { await dsearch.click({ timeout: 5_000 }).catch(() => undefined); await page.waitForTimeout(1_500); }
        const row = dlg.locator('.wj-cells .wj-row').first();
        if (await row.isVisible({ timeout: 8_000 }).catch(() => false)) {
          const rowChk = row.locator('input[type="checkbox"]').first(); // 다중 선택 팝업 = 행 체크박스 + OK
          if (await rowChk.isVisible().catch(() => false)) await rowChk.check({ force: true, timeout: 5_000 }).catch(() => undefined);
          else await row.locator('.wj-cell').nth(1).dblclick({ timeout: 5_000 }).catch(() => undefined);
          await page.waitForTimeout(500);
        }
        if (await dlg.isVisible().catch(() => false)) { const okb = dlg.getByRole('button', { name: /^(확인|OK|Confirm|Select|선택|Apply|적용)$/i }).first(); if (await okb.isVisible().catch(() => false) && await okb.isEnabled().catch(() => false)) await okb.click({ timeout: 5_000 }).catch(() => undefined)  /* 2026-11-06 T103: 팝업 행 0건이면 확인 버튼이 비활성 — timeout 없는 click 이 활성화를 영원히 기다려 20분 타임아웃(SCP0131 2일 연속) */; }
        const closed = !(await dlg.isVisible({ timeout: 3_000 }).catch(() => false));
        if (!closed) { const cb = dlg.getByRole('button', { name: /^(Close|닫기|Cancel|취소)$/i }).first(); if (await cb.isVisible().catch(() => false)) await cb.click({ timeout: 5_000 }).catch(() => undefined); else await page.keyboard.press('Escape').catch(() => undefined); }
        const val = await c.root.locator('input').first().inputValue().catch(() => '');
        changed = !!val; action = `팝업 열림 · ${closed ? '선택 후 닫힘' : '닫히지 않음(Esc)'} · 값 '${val.slice(0, 30)}'`;
        if (!val) { items.push({ name, kind: c.kind, verdict: 'WARN', note: `${action} — 팝업 행 선택이 칸에 채워지지 않음(데이터 0건이면 정상)` }); continue; }
      } else if (c.kind === 'period') {
        const ins = c.root.locator('input:not([type="hidden"])'); const nIn = await ins.count().catch(() => 0); let v1 = nIn ? await ins.nth(0).inputValue().catch(() => '') : ''; let v2 = nIn > 1 ? await ins.nth(1).inputValue().catch(() => '') : '';
        if (!nIn) { const ds = ((await c.root.innerText().catch(() => '')) as string).match(/\d{4}[.\-\/]?\d{2}[.\-\/]?\d{2}/g) || []; v1 = ds[0] || ''; v2 = ds[1] || ''; }  // T110 달력 전용: 표시 글자에서 날짜
        action = `기간 '${v1}' ~ '${v2}'`; changed = false;
        if (!v1 || (nIn > 1 || !nIn) && !v2) { items.push({ name, kind: c.kind, verdict: 'FAIL', note: `${action} — 초기 기간 빈값(DoD B24: As-is Form_Load 초기값)` }); continue; }
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
    // 2026-11-09 CR-098(사용자 지시 · SCP0084): 조회조건 순서는 판정 대상 제외 — 실측은 참고로만 기록(verdict NA · 문구 형식 '화면 … / 기준 …' 유지 → judge 참고 증거)
    items.push({ name: '(기준표 순서)', kind: 'order', verdict: 'NA', note: want.length < 2 ? '비교 대상 2개 미만' : `[판정 제외·참고 CR-098] ${okOrder ? '일치 ' + want.join(' → ') : `화면 ${seq.join(' → ')} / 기준 ${want.join(' → ')}`}` });
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
  const snapBefore = await condSnapshot(nscm, plan, 'cs0_');  // 저장 직전 화면 조건값(복원·Reset 유지 판정 기준)
  { const b = await nscm.visibleFirst(page.getByRole('button', { name: /^Condition(\(F6\))?$/i }));
    if (!b) add('Condition(F6) 조회조건 저장', 'NA', '버튼 없음');
    else { await b.click({ timeout: 5_000 }).catch(() => undefined); const a = await waitAlert(nscm); await closeVisibleDialogs(nscm);
      const n = await savedCount(); // 저장 결과를 DB 에서 다시 읽어 확인(알림만 믿지 않음)
      add('Condition(F6) 조회조건 저장', !a || /실패|fail|error|오류/i.test(a) ? 'FAIL' : n === 0 ? 'WARN' : 'OK', `${a ? `알림 '${a.replace(/\s+/g, ' ').slice(0, 60)}'` : '저장 결과 알림 없음'} · 저장 행 ${n < 0 ? '조회 실패' : n}`); } }
      // 2026-10-30 SSP45 공통요건 11 · CR-029: Condition 저장에 기간(Period·From/To Date 등) 조건은 저장되지 않아야 한다 — 저장된 paramNm 을 DB 에서 다시 읽어 기간 키 유무로 판정(judge: 'condition' 이름 → G3)
      const savedKeys = await page.evaluate(async u => { try { const r = await fetch(u, { credentials: 'include' }); if (!r.ok) return null; const j = await r.json(); const arr = Array.isArray(j) ? j : (j && typeof j === 'object' ? (Object.values(j as Record<string, unknown>).find(v => Array.isArray(v)) as unknown[] | undefined) : undefined); return (arr || []).map(x => String((x as Record<string, unknown>).paramNm ?? (x as Record<string, unknown>).PARAM_NM ?? (x as Record<string, unknown>).param_nm ?? '')); } catch { return null; } }, condApi);
      const PERIOD_RX = /period|from.?(dt|date)$|to.?(dt|date)$|start.?(dt|date)|end.?(dt|date)|ymd|yyyymm|yyyyww|week|month|plan.?date|cutoff/i;
      if (savedKeys) { const per = savedKeys.filter(k => PERIOD_RX.test(k));
        // 2026-11-09(사용자 판정 SCP0131 1번 '기간은 Condition 저장 대상 제외 → 조치 필요 아님'): 저장 키에 기간 키가 들어 있는 것만으로는 결함 아님 → OK(참고 문구 · WARN 은 judge 에서 판정필요로 반입되므로 쓰지 않음) · 기간 조건은 복원 비교 대상에서도 뺀다(아래 PERIOD_RX)
        //   (ConditionNotUseList 와 같은 처리 — 2026-11-06 SCP0016 1번 · 검사기 결함 T96 · CR-029)
        add('Condition(F6) Period 비저장(기간 조건 제외)', per.length ? 'OK' : savedKeys.length ? 'OK' : 'WARN', per.length ? `[참고·결함 아님] 기간 키가 저장 데이터에 있음: ${per.slice(0, 5).join(', ')} — 기간 조건은 Condition 저장 대상 제외(CR-029)이며 복원 비교에서도 제외(사용자 판정 2026-11-09 SCP0131)` : savedKeys.length ? `저장 키 ${savedKeys.length}개 중 기간 키 0 (${savedKeys.slice(0, 6).join(', ')})` : '저장 키 없음 — 판정 재료 없음');
        // 2026-10-30 G3: AS-IS ConditionNotUseList(화면이 저장에서 뺀 조건 — SCP0111 PlanDate·PlanType) 가 TO-BE 저장 키에 있으면 FAIL
        const notUse = plan.condNotUse || [];
        if (notUse.length) {
          const hit = notUse.filter(n => { const keys = [n.key, ...(n.labels || []), n.asis.replace(/^(cbo|clb|txt|chk|dt|usr)/, '')].map(nk).filter(Boolean); return savedKeys.some(k => keys.some(x => nk(k) === x || nk(k).includes(x) || x.includes(nk(k)))); });
          // 2026-11-06(SCP0016 1번): AS-IS BaseForm 은 ConditionNotUseList 를 복원(InitPanel)에서만 빼고 저장(SavePanelCondition)은 한다 → '저장됨' 은 결함 아님(WARN 기록) · 복원 여부는 아래 재진입 비교에서 본다
          add('Condition(F6) 제외 조건 비저장(AS-IS ConditionNotUseList)', hit.length ? 'WARN' : 'OK', hit.length ? `AS-IS 가 저장에서 제외한 조건이 저장됨: ${hit.map(h => h.asis + (h.key ? '→' + h.key : '')).join(', ')} (BaseForm OnClickConditionButton ConditionNotUseList) — TO-BE SubTitle hotkeyConfig.condition/personalizeCondition 저장 대상에서 제외 필요` : `제외 조건 ${notUse.map(n => n.asis).join(', ')} 저장 키에 없음(저장 키 ${savedKeys.length})`);
        }
        // 2026-10-30 G3: 저장 → 화면 재진입 → 저장 키에 해당하는 조건값이 복원되는지(AS-IS Form_Load 개인 조회조건 복원)
        if (savedKeys.length && plan.menuId) {
          await nscm.openScreen(plan.menuId).catch(() => undefined); await page.waitForTimeout(1_500); await closeVisibleDialogs(nscm);
          const snapAfter = await condSnapshot(nscm, plan, 'cs1_');
          const diffs: string[] = []; let compared = 0;
          for (const [key, v0] of snapBefore) {
            if (!v0) continue; if (PERIOD_RX.test(key)) continue;  // 2026-11-09: 기간 조건은 Condition 저장·복원 대상 제외(CR-029 · SCP0131 사용자 판정) — 복원 비교하지 않음
            if (!savedKeys.some(k => !PERIOD_RX.test(k) && (nk(k) === nk(key) || nk(k).includes(nk(key)) || nk(key).includes(nk(k))))) continue;
            compared++; const v1 = snapAfter.get(key) ?? ''; if (v1 !== v0) diffs.push(`${key}: '${v0.slice(0, 30)}' → '${v1.slice(0, 30)}'`);
          }
          add('Condition(F6) 저장 복원(재진입)', !compared ? 'WARN' : diffs.length ? 'FAIL' : 'OK', !compared ? `저장 키(${savedKeys.slice(0, 5).join(', ')})에 대응하는 화면 조건값을 찾지 못해 복원 비교 불가` : diffs.length ? `재진입 후 복원 안 됨: ${diffs.slice(0, 4).join(' · ')} (FE 조회조건 복원 effect·conditionsRestored 플래그 확인)` : `저장 조건 ${compared}개 재진입 후 그대로 복원`);
        }
      }
  // 5) Reset Condition(F10) → 확인(Confirm) → 초기화 알림 → 저장 행 0
  await nscm.expandSearchArea(true).catch(() => undefined); const snapBase = await condSnapshot(nscm, plan, 'rb_');  // Reset 직전 화면값(2026-11-06)
  { const b = await nscm.visibleFirst(page.getByRole('button', { name: /^Reset Condition(\(F10\))?$/i }));
    if (!b) add('Reset Condition(F10) 조회조건 초기화', 'NA', '버튼 없음');
    else { await b.click({ timeout: 5_000 }).catch(() => undefined); const q = await waitAlert(nscm);
      const dq = await nscm.visibleFirst(page.locator('[role="dialog"], [role="alertdialog"]'), 20);
      if (dq) { const ok = dq.getByRole('button', { name: /^(Confirm|확인|OK|Yes|예)$/i }).first(); await ok.click({ timeout: 5_000 }).catch(() => undefined); await page.waitForTimeout(500); }
      const a = await waitAlert(nscm); await closeVisibleDialogs(nscm); const n = await savedCount();
      add('Reset Condition(F10) 조회조건 초기화', !q || (a && /실패|fail|error|오류/i.test(a)) ? 'FAIL' : n > 0 ? 'FAIL' : 'OK', `확인 '${(q || '').replace(/\s+/g, ' ').slice(0, 40)}' → 결과 '${(a || '').replace(/\s+/g, ' ').slice(0, 40)}' · 남은 저장 행 ${n < 0 ? '조회 실패' : n}`);
      // 2026-10-30 G3(사용자 결정 AS-IS 대로): Reset 은 서버 저장본만 삭제(BaseForm ResetPanelCondition) — 화면 입력값·Division 이 지워지면 FAIL
      // 2026-11-06(SCP0016 1번 허위 FAIL): 기준은 Reset 직전 스냅숏(재진입 뒤 접힌 칸 포함 → 펼친 뒤) · 스냅숏에 없는 칸(못 찾음)은 '지워짐' 이 아니라 미측정
      await nscm.expandSearchArea(true).catch(() => undefined); const snapR = await condSnapshot(nscm, plan, 'rs_');
      const wiped = [...snapBase].filter(([key, v0]) => v0 && snapR.has(key) && (snapR.get(key) ?? '') === '').map(([key, v0]) => `${key}('${v0.slice(0, 24)}')`);
      const unseen = [...snapBase].filter(([key, v0]) => v0 && !snapR.has(key)).map(([key]) => key);
      add('Reset Condition(F10) 화면값 유지(AS-IS 서버 저장본만 삭제)', wiped.length ? 'FAIL' : snapBase.size ? 'OK' : 'WARN', wiped.length ? `Reset 뒤 화면 조건값이 지워짐: ${wiped.slice(0, 5).join(', ')} — AS-IS ResetPanelCondition 은 저장본만 삭제(화면값 유지) · TO-BE handleResetCondition/resetConditionValues 가 화면 상태까지 초기화` : snapBase.size ? (unseen.length ? `미측정 칸 ${unseen.slice(0, 4).join(',')}(Reset 뒤 못 찾음) · ` : '') + `화면 조건값 ${snapBefore.size}개 유지` : '비교할 조건값 없음'); } }
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
      // 2026-11-05 T57: 다운로드 대신 알림(0건 가드 '조회된 데이터가 없습니다' 등)이 뜨면 그 문구를 근거로 남기고 닫는다 — 열린 채 두면 뒤 Search Area 클릭이 백드롭에 막혀 ERROR(SCP0084 11-05 05:38 실측)
      if (!d) { const at = await nscm.alertText(); if (at) { add('Excel 다운로드', 'FAIL', `다운로드 없음 — 알림 '${at.replace(/\s+/g, ' ').slice(0, 80)}'`); await closeDialogSafely(nscm, page); } else add('Excel 다운로드', 'FAIL', '60초 안에 파일 다운로드 없음'); }
      else { const fn = d.suggestedFilename(); const p = await d.path().catch(() => null); let size = 0; try { size = p ? fs.statSync(p).size : 0; } catch { size = 0; }
        add('Excel 다운로드', /\.xlsx$/i.test(fn) && size > 0 ? 'OK' : 'FAIL', `'${fn}' ${size}B`);
        await d.delete().catch(() => undefined); } } } // 받은 xlsx(zip) 는 판정 후 삭제 — 남겨 두면 결과 첨부 단계에서 zip 판독 오류가 났다(2026-10-23 실측)
  // 7) Columns(컬럼 설정) — 모달 열림 → 닫기
  { const b = await nscm.visibleFirst(page.getByRole('button', { name: /^(Columns?|Column Setting|컬럼\s*설정)$/i }));
    if (!b) add('Columns 컬럼 설정', 'NA', '버튼 없음');
    else { await b.click({ timeout: 5_000 }).catch(() => undefined); let dlg: Locator | null = null; const until = Date.now() + 6_000; while (!dlg && Date.now() < until) { dlg = await nscm.visibleFirst(page.locator('[role="dialog"], .MuiDialog-paper, [role="presentation"] .MuiPaper-root'), 20); if (!dlg) await page.waitForTimeout(300); }
      const open = !!dlg; const txt = dlg ? (await dlg.innerText().catch(() => '')).slice(0, 4000) : '';
      const noCol = /No Column/i.test(txt);
      // 2026-11-05 T57: Column Setting 모달(CustomDialog)은 Cancel 버튼이 없고 Escape 로도 안 닫힌다 — 머리의 X(onClick 달린 SVG, button 아님)를 눌러 닫고 닫힘을 확인한다. Save/OK 는 절대 누르지 않는다(사용자 컬럼 설정 덮어쓰기 금지)
      const closed = dlg ? await closeDialogSafely(nscm, page) : '';
      add('Columns 컬럼 설정', !open ? 'FAIL' : noCol ? 'FAIL' : 'OK', !open ? '클릭 후 설정 창이 열리지 않음' : noCol ? "설정 창 목록 'No Column'(fallbackColumns 누락 — check.js H02)" : `설정 창 열림·닫힘(${closed || '닫기 실패 — 뒤 단계 가림'})`); } }
  // 8) Search Area 스위치(MainTitle) — 끄면 조회영역 숨김 · 켜면 다시 보임
  // MainTitle(titleAreaWrapper) 의 MUI Switch(label 'Search Area' = LBL00324) — 2026-10-23 DOM 실측
  { const sw = (await nscm.visibleFirst(page.locator('[class*="titleAreaWrapper"] .MuiSwitch-root'))) || (await nscm.visibleFirst(page.getByRole('switch', { name: /Search Area|조회\s*영역/i }))) || (await nscm.visibleFirst(page.getByLabel(/^\s*_?(Search Area|조회\s*영역)\s*$/i))) || (await nscm.visibleFirst(page.locator('label').filter({ hasText: /Search Area|조회\s*영역/i }).locator('input[type="checkbox"]')));
    if (!sw) add('Search Area 조회영역 토글', 'NA', '스위치 없음');
    // SearchArea 는 isHidden 이어도 언마운트하지 않고 MUI Collapse 로 접는다 → 표시 = 조회조건 칸을 감싼 Collapse 들의 높이가 모두 > 5px
    else { const shown = async () => page.evaluate(() => { const fi = Array.from(document.querySelectorAll('[class*="_formItem_"]')).find(e => !e.closest('[role="dialog"], .wj-flexgrid') && (e as HTMLElement).offsetParent !== null); if (!fi) return false; for (let p = fi.parentElement; p; p = p.parentElement) if (p.classList.contains('MuiCollapse-root') && p.getBoundingClientRect().height <= 5) return false; return true; }).catch(() => false);
      // 2026-11-05 T57: 앞 단계가 남긴 다이얼로그(Excel 0건 알림 · Column Setting 모달)가 있으면 force 클릭이 백드롭에 떨어져 '변화 없음' ERROR 가 났다(SCP0084·DMF0082·SCP0100 실측).
      //   → 먼저 남은 다이얼로그를 X/Cancel 로만 닫고(Save·OK 금지), 그래도 남으면 가림 요소를 명시한 ERROR. 클릭은 스위치 input 에 직접 하고 checked 변화를 함께 기록해 '스위치 무반응' 과 '접힘 무반응(화면 결함)' 을 가른다.
      const blocker = await closeDialogSafely(nscm, page, true);
      if (blocker.startsWith('열림:')) add('Search Area 조회영역 토글', 'ERROR', `가림 요소 — ${blocker} (닫기 실패) · 스위치 미측정`);
      else { const inp = sw.locator('input[type="checkbox"]').first(); const tgt = (await inp.count().catch(() => 0)) ? inp : sw;
        const checked = async () => tgt.evaluate(e => (e as HTMLInputElement).checked ?? (e.getAttribute('aria-checked') === 'true')).catch(() => null);
        const c0 = await checked(); const vis0 = await shown(); await tgt.click({ force: true, timeout: 5_000 }).catch(() => undefined); await page.waitForTimeout(900);
        let c1 = await checked(); let vis1 = await shown();
        // 2026-11-17 SSP0020(13회차·스모크 재실행 2회 true→true→false · 12회차 PASS): 첫 클릭이 앞 단계 잔여(알림·포커스)에 먹히면 스위치가 그대로다 —
        //   남은 대화상자를 닫고 한 번만 다시 누른다. 스위치 자체가 무반응이면 두 번째에도 그대로라 결함은 그대로 잡힌다
        if (c1 === c0) { await nscm.clearDialogs().catch(() => undefined); await page.keyboard.press('Escape').catch(() => undefined); await page.waitForTimeout(400); await tgt.click({ force: true, timeout: 5_000 }).catch(() => undefined); await page.waitForTimeout(900); c1 = await checked(); vis1 = await shown(); }
        await tgt.click({ force: true, timeout: 5_000 }).catch(() => undefined); await page.waitForTimeout(900);
        const c2 = await checked(); const vis2 = await shown();
        const swMoved = c0 !== c1; const sw3 = `스위치 ${c0}→${c1}→${c2}`;
        add('Search Area 조회영역 토글', vis0 && !vis1 && vis2 ? 'OK' : !swMoved ? 'ERROR' : 'FAIL',
          vis0 && !vis1 && vis2 ? `조회영역(조회조건 칸) 표시 ${vis0}→${vis1}→${vis2} · ${sw3}`
            : !swMoved ? `스위치 클릭에 상태 변화 없음(${sw3}) — 가림/포커스 문제 의심 · 조회영역 ${vis0}→${vis1}→${vis2}`
            : `스위치는 바뀌었으나(${sw3}) 조회영역이 접히지/펼쳐지지 않음 ${vis0}→${vis1}→${vis2} — isHidden 배선 결함 의심`); } } }
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

/** 조회조건 팝업 칸(돋보기) 값 고르기 — 팝업 그리드에서 조건에 맞는 첫 행 더블클릭. skipRe 에 맞는 행은 건너뛴다(예 Current) · 고른 행 글자를 돌려준다(2026-11-03 Version 조건) */
export async function pickFromPopup(nscm: Nscm, label: string, skipRe = ''): Promise<string> {
  const p = nscm.page; const it = p.locator('[class*="_formItem_"]').filter({ hasText: new RegExp(`^\\*?\\s*(?:[A-Za-z]+\\s+)?${label}`, 'i') }).first();
  if (!(await it.count().catch(() => 0))) { if (process.env.E2E_RESULTS) await p.screenshot({ path: `${process.env.E2E_RESULTS}/pop_noitem_${label.replace(/\W/g, '')}.png` }).catch(() => undefined); return ''; }
  const btn = it.locator('button').last(); await btn.click({ timeout: 5_000 }).catch(() => undefined); await p.waitForTimeout(1_200);
  const dlg = p.locator('[role="dialog"]:visible').last(); if (!(await dlg.count().catch(() => 0))) { if (process.env.E2E_RESULTS) await p.screenshot({ path: `${process.env.E2E_RESULTS}/pop_nodlg_${label.replace(/\W/g, '')}.png` }).catch(() => undefined); return ''; }
  const srch = dlg.getByRole('button', { name: /^Search/i }).first(); if (await srch.isVisible().catch(() => false)) { await srch.click({ timeout: 3_000 }).catch(() => undefined); await p.waitForLoadState('networkidle', { timeout: 30_000 }).catch(() => undefined); await p.waitForTimeout(800); }
  const findRow = () => p.evaluate(`(() => { const el = [...document.querySelectorAll('[role="dialog"] .wj-flexgrid')].filter(e => e.offsetParent !== null).pop(); const c = el && el['$WJ-CTRL']; if (!c) return null; const skip = ${JSON.stringify(skipRe)} ? new RegExp(${JSON.stringify(skipRe)}, 'i') : null; for (let r = 0; r < Math.min(c.rows.length, 50); r++) { let t = ''; for (let i = 0; i < c.columns.length; i++) if (c.columns[i].visible !== false) t += String(c.getCellData(r, i, true) ?? '') + ' '; if (skip && skip.test(t)) continue; for (let i = 0; i < c.columns.length; i++) { const e2 = c.cells.getCellElement(r, i); if (e2 && c.columns[i].visible !== false && c.columns[i].binding) { const q = e2.getBoundingClientRect(); if (q.width > 10) return { x: q.left + q.width / 2, y: q.top + q.height / 2, t: t.trim().slice(0, 60) }; } } } return null; })()`).catch(() => null) as Promise<{ x: number; y: number; t: string } | null>;
  let tgt = await findRow();
  if (!tgt && skipRe) { const inp = dlg.locator('input:not([type="hidden"])').filter({ hasNot: p.locator('[role="combobox"]') }); const n = await inp.count().catch(() => 0); for (let k = 0; k < n; k++) { const q = inp.nth(k); const v = await q.inputValue().catch(() => ''); const m = /^(\d{4})([.\-\/]?)(\d{2})(.*)$/.exec(v); if (!m) continue; await q.fill(`${+m[1] - 1}${m[2]}${m[3]}${m[4]}`, { timeout: 3_000 }).catch(() => undefined); await q.press('Tab').catch(() => undefined); break; } if (await srch.isVisible().catch(() => false)) { await srch.click({ timeout: 3_000 }).catch(() => undefined); await p.waitForLoadState('networkidle', { timeout: 30_000 }).catch(() => undefined); await p.waitForTimeout(800); } tgt = await findRow(); }
  if (!tgt) { if (process.env.E2E_RESULTS) await p.screenshot({ path: `${process.env.E2E_RESULTS}/pop_fail_${label.replace(/\W/g, '')}.png` }).catch(() => undefined); await p.keyboard.press('Escape').catch(() => undefined); return ''; }
  await p.mouse.dblclick(tgt.x, tgt.y); await p.waitForTimeout(700);
  if (await p.locator('[role="dialog"]:visible .wj-flexgrid').count().catch(() => 0)) { const ok = p.locator('[role="dialog"]:visible').last().getByRole('button', { name: /^(OK|확인|Select|선택|Apply|적용)$/i }).first(); if (await ok.isVisible().catch(() => false)) { await ok.click({ timeout: 3_000 }).catch(() => undefined); await p.waitForTimeout(600); } }
  return tgt.t;
}

/** 조회조건 콤보를 라벨로 찾아 값 선택 — 라벨이 맞는 칸 우선, 없으면 다른 칸 후보에서 찾는다(문서 조건별 시험 공용) */
const COND_OPT = '.MuiAutocomplete-popper [role="option"], [role="listbox"] [role="option"]';
export async function setCondByLabel(nscm: Nscm, label: string, val: string): Promise<boolean> {
  const p = nscm.page; if (/^@pop/.test(val)) { const skip = val.split(':')[1] || ''; return !!(await pickFromPopup(nscm, label, skip)); }
  if (val === '@other') return setCondOther(nscm, label); /* 2026-11-04 W8-2 자동 시나리오: 그 라벨 조건을 현재와 다른 후보로 */
  const run = async () => { const items = p.locator('[class*="_formItem_"]'); const nI = await items.count().catch(() => 0); const re = new RegExp(`^\\s*${val.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}(\\s|$)`, 'i'); const lre = new RegExp(`^\\*?\\s*${label.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}`, 'i'); const order: number[] = []; for (let i = 0; i < nI; i++) { const t = ((await items.nth(i).innerText().catch(() => '')) || '').trim(); if (lre.test(t)) order.unshift(i); else order.push(i); } for (const i of order) { const cb = items.nth(i).locator('[role="combobox"]').first(); if (!(await cb.isVisible().catch(() => false))) continue; await cb.click({ timeout: 3_000 }).catch(() => undefined); await p.waitForTimeout(350); const o = p.locator(COND_OPT).filter({ hasText: re }).first(); if (await o.isVisible().catch(() => false)) { await o.click({ timeout: 3_000 }).catch(() => undefined); await p.waitForTimeout(700); await nscm.clearDialogs(); return true; } await p.keyboard.press('Escape').catch(() => undefined); await p.waitForTimeout(120); } const rd = p.locator('label, [role="radio"]').filter({ hasText: re }).first(); if (await rd.isVisible().catch(() => false)) { await rd.click({ timeout: 3_000 }).catch(() => undefined); await p.waitForTimeout(700); await nscm.clearDialogs(); return true; } return false; };
  return run();
}

/** 그 라벨 조회조건을 현재 값과 다른 첫 후보로 바꾼다(콤보 · 라디오) — 생성기가 실제 후보 값을 모를 때(W8-2 · 2026-11-04). 바꿨으면 true */
export async function setCondOther(nscm: Nscm, label: string): Promise<boolean> {
  const p = nscm.page; const lre = new RegExp(`^\\*?\\s*${label.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}`, 'i');
  const items = p.locator('[class*="_formItem_"], [class*="formItem"]'); const nI = await items.count().catch(() => 0);
  for (let i = 0; i < nI; i++) {
    const it = items.nth(i); const t = ((await it.innerText().catch(() => '')) || '').trim(); if (!lre.test(t)) continue;
    const rads = it.locator('input[type="radio"]'); const nR = await rads.count().catch(() => 0);
    if (nR > 1) { for (let k = 0; k < nR; k++) { const r = rads.nth(k); if (!(await r.isChecked().catch(() => true))) { await r.check({ force: true, timeout: 3_000 }).catch(() => undefined); await p.waitForTimeout(700); await nscm.clearDialogs(); return true; } } return false; }
    const cb = it.locator('[role="combobox"]').first(); if (!(await cb.isVisible().catch(() => false))) continue;
    const cur = ((await cb.inputValue().catch(() => '')) || (await cb.innerText().catch(() => '')) || '').trim();
    await cb.click({ timeout: 3_000 }).catch(() => undefined); await p.waitForTimeout(350);
    const opts = p.locator(COND_OPT); const nO = await opts.count().catch(() => 0);
    for (let k = 0; k < nO; k++) { const o = opts.nth(k); const ot = ((await o.innerText().catch(() => '')) || '').trim(); if (ot && ot !== cur && !(await o.getAttribute('aria-selected').then(v => v === 'true').catch(() => false))) { await o.click({ timeout: 3_000 }).catch(() => undefined); await p.waitForTimeout(700); await nscm.clearDialogs(); return true; } }
    await p.keyboard.press('Escape').catch(() => undefined); return false;
  }
  return false;
}

/** 조회조건 기간 시작일을 months 개월 앞으로(키 입력) — 지난 기간 칸이 필요한 시험용. 바꾼 칸 수를 돌려준다(2026-11-03 EG310) */
export async function widenFrom(p: Nscm['page'], months: number): Promise<number> {
  const n = await p.evaluate(() => {
    document.querySelectorAll('[data-e2e-from]').forEach(e => e.removeAttribute('data-e2e-from')); let k = 0;
    for (const it of Array.from(document.querySelectorAll('[class*="formItem"]')) as HTMLElement[]) {
      if (it.offsetParent === null || it.closest('[role="dialog"], .wj-flexgrid')) continue;
      const ins = Array.from(it.querySelectorAll('input:not([type="hidden"])')) as HTMLInputElement[];
      if (ins.length >= 2 && /^\d{4}[.\-\/]?\d{2}/.test(ins[0].value || '')) it.setAttribute('data-e2e-from', String(k++));
    }
    return k;
  }).catch(() => 0);
  let done = 0;
  for (let k = 0; k < n; k++) {
    const inp = p.locator(`[data-e2e-from="${k}"]`).first().locator('input:not([type="hidden"])').nth(0);
    const v = await inp.inputValue().catch(() => ''); const m = /^(\d{4})([.\-\/]?)(\d{2})(.*)$/.exec(v); if (!m) continue;
    const t = +m[1] * 12 + (+m[3] - 1) - months; const nv = `${Math.floor(t / 12)}${m[2]}${String(t % 12 + 1).padStart(2, '0')}${m[4]}`;
    await inp.fill(nv, { timeout: 3_000 }).catch(() => undefined); await inp.press('Tab').catch(() => undefined); done++;
  }
  return done;
}

/** 기본 조회가 0행이면 실제 화면 후보로 대안 조회를 시도한다 — ① Division 후보 순회 ② 기간(period) 시작 2년 앞으로. 행이 생기는 첫 조건에서 멈춘다(2026-10-31 SCP0041 기본 조회 0행 → 전 검사 ERROR).
 *  사전 데이터셋을 쓰지 않는다(화면 콤보 후보·실데이터만). 결과 via 는 증거용 경로 설명 */
const ENSURE_MEMO = new Map<string, { via: string; years?: number; div?: string; none?: boolean; req?: { label: string; idx: number } }>();
export async function ensureRows(nscm: Nscm, maxDiv = 3, key = 'default'): Promise<{ rows: number; via: string }> {
  const p = nscm.page;
  let rows = await probe.rowCount(p);
  if (rows > 0) return { rows, via: '기본 조회' };
  const searchCount = async () => { const b0 = nscm.calls.length; await nscm.search().catch(() => undefined); await probe.waitRows(p, 25_000).catch(() => undefined); await nscm.clearDialogs().catch(() => undefined); const n = await probe.rowCount(p); const body = (nscm.calls.slice(b0).find(c => /SEARCH/i.test(c.btn))?.body || '').replace(/\s+/g, '').slice(0, 140); console.log(`[ensureRows] 시도 → ${n}행 · 본문 ${body}`); return n; };  // 25s: Div 40 7,849행이 12s 안에 안 차서 0행으로 읽었다(2026-10-31 r8 진단)
  // 기간 칸 = 입력 2개 이상 + 첫 입력값이 날짜인 FormItem 전부(Hold 기간·Cutoff 기간처럼 여러 개일 수 있다 — 2026-10-31 SCP0041 Pack Hold 는 Cutoff 까지 넓혀야 행이 나온다)
  const widenAll = async (years: number): Promise<string[]> => {
    const n = await p.evaluate(() => {
      document.querySelectorAll('[data-e2e-period]').forEach(e => e.removeAttribute('data-e2e-period'));
      let k = 0;
      for (const it of Array.from(document.querySelectorAll('[class*="_formItem_"], [class*="formItem"]')) as HTMLElement[]) {
        if (it.offsetParent === null || it.closest('[role="dialog"], .wj-flexgrid')) continue;
        const ins = Array.from(it.querySelectorAll('input:not([type="hidden"])')) as HTMLInputElement[];
        if (ins.length >= 2 && /^\d{4}[.\-\/]?\d{2}[.\-\/]?\d{2}/.test(ins[0].value || '')) it.setAttribute('data-e2e-period', String(k++));
      }
      return k;
    }).catch(() => 0);
    const done: string[] = [];
    for (let k = 0; k < n; k++) {
      const ins = p.locator(`[data-e2e-period="${k}"]`).first().locator('input:not([type="hidden"])');
      const v1 = await ins.nth(0).inputValue().catch(() => ''); const m = /^(\d{4})/.exec(v1); if (!m) continue;
      const nv = String(new Date().getFullYear() - years) + v1.slice(4);
      await ins.nth(0).fill(nv, { timeout: 3_000 }).catch(() => undefined); await ins.nth(0).press('Tab').catch(() => undefined);
      done.push(nv);
    }
    return done;
  };
  // 메모 — 같은 화면에서 이미 찾은 조건은 바로 재적용 · 못 찾았으면 재시도 생략(테스트마다 3~4분 낭비 방지)
  // 메모 키 = 화면 + 현재 시트(마지막 조회 sheet) — 다른 탭에서 '대안 없음' 을 기록해 이 탭의 재시도까지 막던 결함(2026-10-31 SCP0041 trace 전 테스트 0행)
  const curSheet = [...nscm.calls].reverse().find(c => /SEARCH/i.test(c.btn))?.sheet || '';
  key = `${key}|${curSheet}`;
  const memo = ENSURE_MEMO.get(key);
  if (memo) {
    if (memo.none) return { rows, via: `기본 조회 0행 · 대안 전부 0행(이전 시도 ${memo.via} · 재시도 생략)` };
    if (memo.years) await widenAll(memo.years);
    if (memo.div) await nscm.setDivision(memo.div).catch(() => false);
    if (memo.req) await nscm.fillRequired(memo.req.label, memo.req.idx).catch(() => '');  // T59 필수 후보 재적용
    rows = await searchCount();
    return { rows, via: `${memo.via} (메모 재적용 → ${rows}행)` };
  }
  const tried: string[] = [];
  // ⓪ 2026-11-17 시트별 데이터 조건(Doc/verify/<ID>/sheet_data_cond.json · tools/Harness/verify/sheet_data_cond.py 가 조회 SP 재실행으로 센 결과):
  //    이 시트에서 행이 나온 Division 을 먼저 시도한다(SCP0104 SOP_ELTR·SOP_ASSEMBLY = 81_HG·81_ST 에만 행)
  for (const code of sheetDataDivs(key.split('|')[0] === 'default' ? (process.env.VERIFY_ID || nscm.curMenu || '') : key.split('|')[0], curSheet)) {
    if (!(await nscm.setDivision(code).catch(() => false))) { tried.push(`데이터 조건 Div ${code}:선택 실패`); continue; }
    rows = await searchCount(); tried.push(`데이터 조건 Div ${code}:${rows}행`);
    if (rows > 0) { const via = `시트 데이터 조건 Division '${code}' 조회(sheet_data_cond.json · ${tried.join(' · ')})`; ENSURE_MEMO.set(key, { via, div: code }); return { rows, via }; }
  }
  // ① 모든 기간 칸의 시작을 2년 → 5년 앞으로(현재 Division 유지)
  let widened = 0;
  for (const years of [2, 5]) {
    const did = await widenAll(years).catch(() => [] as string[]);
    if (!did.length) break;
    widened = years; rows = await searchCount(); tried.push(`기간 ${years}년 확대(${did.join(',')}~):${rows}행`);
    if (rows > 0) { const via = `기간 ${years}년 확대 대안 조회(${tried.join(' · ')})`; ENSURE_MEMO.set(key, { via, years }); return { rows, via }; }
  }
  // ② Division 후보 순회(확대된 기간 유지)
  try {
    const combo = await nscm.visibleFirst(p.getByRole('combobox'));
    if (combo) {
      await combo.click({ timeout: 3_000 }).catch(() => undefined);
      const opts = await p.getByRole('option').allInnerTexts().catch(() => [] as string[]);
      await p.keyboard.press('Escape').catch(() => undefined);
      // 2026-11-17 사용자 지적(SCP0104 SOP 탭 오류 내역 없음 = 0행 미측정): 앞 maxDiv 개가 전부 0행이면 나머지 후보도 순회한다.
      //   SOP 탭은 Div 81_ST·81_HG(후보 4번째 이후)에만 데이터가 있어 종전 3개 제한으로 측정하지 못했다. 찾으면 메모해 같은 시트 재시도 없음.
      for (const o of opts) {
        const code = (o.trim().split(/\s+/)[0] || '').replace(/[^A-Za-z0-9_]/g, '');
        if (!code || /^all$/i.test(code)) continue;
        if (!(await nscm.setDivision(code))) continue;
        if (widened) await widenAll(widened);  // Division 변경이 기간을 기본값으로 되돌리는 화면(C1 연쇄) — 확대 기간 재적용(2026-10-31 SCP0041 r7)
        rows = await searchCount(); tried.push(`Div ${code}${widened ? '+기간' : ''}:${rows}행`);
        if (rows > 0) { const via = `Division '${code}'${widened ? ` + 기간 ${widened}년 확대` : ''} 대안 조회(${tried.join(' · ')})`; ENSURE_MEMO.set(key, { via, years: widened || undefined, div: code }); return { rows, via }; }
      }
    }
  } catch { /* Division 순회 실패 */ }
  // ③ 2026-11-06 T59: 필수 조회조건을 search() 가 첫 후보로 채웠는데 0행 — 같은 칸의 다음 화면 후보 2개(다중선택이면 추가 체크)
  for (const label of [...nscm.requiredFilled]) {
    for (const idx of [1, 2]) {
      const note = await nscm.fillRequired(label, idx).catch(() => '');
      if (!note.startsWith('선택')) break;
      rows = await searchCount(); tried.push(`필수 ${label} ${idx + 1}번째 후보:${rows}행`);
      if (rows > 0) { const via = `필수 조건 '${label}' ${idx + 1}번째 후보 대안 조회(${tried.join(' · ')})`; ENSURE_MEMO.set(key, { via, req: { label, idx } }); return { rows, via }; }
    }
  }
  const via = `기본 조회 0행 · 대안 ${tried.join(' · ') || '없음'} 전부 0행${nscm.requiredNotes.length ? ` · 필수 조건 ${nscm.requiredNotes.slice(-2).join(' / ')}` : ''}`;
  ENSURE_MEMO.set(key, { via, none: true });
  return { rows, via };
}

/** 화면 안 탭(시트) 클릭 — role=tab → button → 텍스트 순. 전환 못 하면 false(측정 경로 없음 → 호출부가 ERROR) */
/** 화면별 시트 이동 사실(Doc/verify/<ID>/sheet_nav.json — 2026-11-16 SCP0104) — AS-IS 시트 이름이 TO-BE 탭 이름과 다르거나 조회조건 값·여러 단 탭으로 시트가 정해지는 화면용.
 *  { sheets: { <AS-IS 시트>: { cond?: { 라벨: 값 }, tabs?: [바깥 탭, 안쪽 탭…], popup?: 이름 } } } · 없으면 null(종전 동작) */
type SheetNav = { cond?: Record<string, string>; tabs?: string[]; popup?: string; base?: string; open?: string; cell?: string };
const _NAV: Record<string, Record<string, SheetNav> | null> = {};
/** 시트별 데이터 조건(Doc/verify/<ID>/sheet_data_cond.json — 2026-11-17): 그 시트 조회 SP 를 DB 에서 다시 실행해 행이 나온 Division 목록.
 *  AS-IS·TO-BE 양쪽에 행이 있는 Division(both)을 먼저, 없으면 TO-BE 행 있는 Division(divs). 파일·시트가 없으면 [] */
const _DATA: Record<string, Record<string, { both?: string[]; divs?: string[] }> | null> = {};
export function sheetDataDivs(menuId: string, sheet: string): string[] {
  const id = (menuId || '').toUpperCase(); if (!id || !sheet) return [];
  if (!(id in _DATA)) { try { const j = JSON.parse(fs.readFileSync(`${__dirname}/../../../Doc/verify/${id}/sheet_data_cond.json`, 'utf8').replace(/^﻿/, '')) as { sheets?: Record<string, { both?: string[]; divs?: string[] }> }; _DATA[id] = j.sheets || null; } catch { _DATA[id] = null; } }
  const m = _DATA[id]; if (!m) return []; const nz = (t: string) => String(t || '').toLowerCase().replace(/[^a-z0-9]/g, '');
  const k = Object.keys(m).find(x => nz(x) === nz(sheet)); if (!k) return [];
  const both = m[k].both || []; return [...both, ...(m[k].divs || []).filter(d => !both.includes(d))];
}
export function sheetNav(menuId: string, sheet: string): SheetNav | null {
  const id = (menuId || '').toUpperCase(); if (!id) return null;
  if (!(id in _NAV)) { try { const j = JSON.parse(fs.readFileSync(`${__dirname}/../../../Doc/verify/${id}/sheet_nav.json`, 'utf8').replace(/^﻿/, '')) as { sheets?: Record<string, SheetNav> }; _NAV[id] = j.sheets || null; } catch { _NAV[id] = null; } }
  const m = _NAV[id]; if (!m) return null; const nz = (t: string) => String(t || '').toLowerCase().replace(/[^a-z0-9가-힣]/g, '');
  const k = Object.keys(m).find(x => nz(x) === nz(sheet)); return k ? m[k] : null;
}
/** 팝업 안 그리드 시트 열기(sheet_nav.json popup + base + open · 2026-11-16 SCP0104 LINE·SOP_MODEL_*):
 *  바탕 시트(base)로 간 뒤 open = 'insert'(Insert 버튼) 또는 'dblclick'(조회 뒤 cell 컬럼 첫 행 더블클릭)으로 팝업을 열고, 팝업 그리드가 0행이면 팝업의 Search 를 누른다 */
export async function openSheetPopup(nscm: Nscm, name: string): Promise<{ ok: boolean; how: string }> {
  const p = nscm.page; const nav = sheetNav(process.env.VERIFY_ID || (nscm as unknown as { curMenu?: string }).curMenu || '', name);
  if (!nav || !nav.popup || !nav.base || !nav.open) return { ok: false, how: '시트 이동 사실에 팝업 여는 방법(base·open) 없음' };
  if (!(await clickSheetTab(nscm, nav.base))) return { ok: false, how: `바탕 시트 '${nav.base}' 전환 실패` };
  const rowsIn = () => p.evaluate(`(() => { const d = [...document.querySelectorAll('[role="dialog"]')].filter(e => e.getClientRects().length).pop(); if (!d) return -1; const g = d.querySelector('.wj-flexgrid'); const c = g && g['$WJ-CTRL']; return c && c.rows ? c.rows.length : -1; })()`).catch(() => -1) as Promise<number>;
  if (nav.open === 'insert') await p.locator('button', { hasText: /^\s*Insert/ }).first().click({ timeout: 10_000 }).catch(() => undefined);
  else {
    await nscm.search().catch(() => undefined);
    const MAIN = `[...document.querySelectorAll('.wj-flexgrid')].find(e => e.offsetParent !== null && !e.closest('[role="dialog"]'))`;
    for (let k = 0; k < 60; k++) { const n = await p.evaluate(`(() => { const e = ${MAIN}; const c = e && e['$WJ-CTRL']; return c && c.rows ? c.rows.length : 0; })()`).catch(() => 0) as number; if (n > 0) break; await p.waitForTimeout(500); }
    await nscm.clearDialogs().catch(() => undefined);
    const COL = `(() => { const e = ${MAIN}; const c = e && e['$WJ-CTRL']; if (!c || !c.rows.length) return null; const want = ${JSON.stringify(nav.cell || '')}; let col = want ? c.columns.getColumn(want) : null; if (!col || col.visible === false) { col = null; for (let i = 0; i < c.columns.length; i++) { if (c.columns[i].visible !== false) { col = c.columns[i]; break; } } } return col ? { c, col } : null; })()`;
    const sc = await p.evaluate(`(() => { const x = ${COL}; if (!x) return false; x.c.scrollIntoView(0, x.col.index); return true; })()`).catch(() => false);
    if (!sc) return { ok: false, how: `바탕 시트 '${nav.base}' 조회 0행 — 셀 더블클릭 불가` };
    await p.waitForTimeout(400);
    const pt = await p.evaluate(`(() => { const x = ${COL}; if (!x) return null; const r = x.c.getCellBoundingRect(0, x.col.index); return { x: r.left + r.width / 2, y: r.top + r.height / 2 }; })()`).catch(() => null) as { x: number; y: number } | null;
    if (!pt) return { ok: false, how: `바탕 시트 '${nav.base}' 셀 좌표 없음` };
    await p.mouse.click(pt.x, pt.y, { clickCount: 2 });
  }
  let n = -1; for (let k = 0; k < 25 && n < 0; k++) { await p.waitForTimeout(400); n = await rowsIn(); }
  if (n < 0) return { ok: false, how: `${nav.open === 'insert' ? 'Insert' : '셀 더블클릭'} 뒤 팝업 그리드 없음` };
  if (n === 0) { await p.locator('[role="dialog"]:visible').last().getByRole('button', { name: /^Search/i }).first().click({ timeout: 3_000 }).catch(() => undefined); for (let k = 0; k < 40 && n <= 0; k++) { await p.waitForTimeout(500); n = await rowsIn(); } }
  return { ok: true, how: `바탕 시트 ${nav.base} · ${nav.open === 'insert' ? 'Insert' : (nav.cell || '첫 칸') + ' 더블클릭'} · 팝업 그리드 ${n}행` };
}
export async function clickSheetTab(nscm: Nscm, name: string): Promise<boolean> {
  const p = nscm.page; const rx = new RegExp(`^\\s*${name.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}\\s*$`, 'i');
  // 시트 이동 사실이 있으면 그대로 따른다: 조회조건 값 → 탭을 바깥부터 차례로. 팝업 안 그리드(popup)는 탭으로 갈 수 없어 false(호출부가 측정 경로 없음으로 남김)
  const nav = sheetNav(process.env.VERIFY_ID || (nscm as unknown as { curMenu?: string }).curMenu || '', name);
  if (nav) {
    if (nav.popup && !(nav.tabs || []).length) return false;
    // 2026-11-17: 시트 이동 사실에 Division 조건이 없고 시트 데이터 조건(sheet_data_cond.json)이 있으면 그 첫 Division 을 먼저 고른다
    if (!Object.keys(nav.cond || {}).some(l => /^(div\.?|division)$/i.test(l.trim()))) { const dd = sheetDataDivs(process.env.VERIFY_ID || (nscm as unknown as { curMenu?: string }).curMenu || '', name); const curDiv = dd.length ? ((await p.locator('[class*="_formItem_"], [class*="formItem"]').filter({ has: p.locator(':scope > :first-child', { hasText: /^\s*\*?\s*(Div\.?|Division)\s*\*?\s*$/i }) }).first().locator('[role="combobox"]').first().inputValue({ timeout: 2_000 }).catch(() => '')) || '').trim().split(/\s+/)[0] : ''; /* 현재 Division 에 이 시트 행이 있으면 그대로 둔다(계정·Division 별 시험이 고른 Division 을 바꾸지 않음) */ if (dd.length && !dd.includes(curDiv) && await nscm.setDivision(dd[0]).catch(() => false)) { console.log(`[sheetNav] ${name}: 데이터 조건 Division ${dd[0]}`); await nscm.clearDialogs().catch(() => undefined); } }
    if (nav.cond && Object.keys(nav.cond).length) {
      await nscm.expandSearchArea().catch(() => undefined);
      for (const [label, value] of Object.entries(nav.cond)) {
        const it = p.locator('[class*="_formItem_"], [class*="formItem"]').filter({ has: p.locator(':scope > :first-child', { hasText: new RegExp(`^\\s*\\*?\\s*${label.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}\\s*\\*?\\s*$`, 'i') }) }).first();
        const combo = it.locator('[role="combobox"]').first(); if (!(await combo.count().catch(() => 0))) { console.log(`[sheetNav] ${name}: 조회조건 '${label}' 칸 없음`); return false; }
        if (((await combo.inputValue().catch(() => '')) || '').trim() === value) continue;
        await combo.click({ timeout: 5_000 }).catch(() => undefined);
        let opt = p.getByRole('option', { name: new RegExp(`^\\s*${value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}\\s*$`, 'i') }).first();
        if (!(await opt.isVisible({ timeout: 3_000 }).catch(() => false))) { await it.locator('button[aria-label="Open"]').first().click({ timeout: 3_000, force: true }).catch(() => undefined); opt = p.getByRole('option', { name: new RegExp(`^\\s*${value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}\\s*$`, 'i') }).first(); }
        if (!(await opt.isVisible({ timeout: 3_000 }).catch(() => false))) { await p.keyboard.press('Escape').catch(() => undefined); console.log(`[sheetNav] ${name}: '${label}' 후보에 '${value}' 없음`); return false; }
        await opt.click({ timeout: 5_000 }).catch(() => undefined); await p.waitForTimeout(1_200); await nscm.clearDialogs().catch(() => undefined);
      }
    }
    for (const tab of nav.tabs || []) {
      const trx = new RegExp(`^\\s*${tab.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}\\s*$`, 'i'); let hit = false;
      for (const loc of [p.getByRole('tab', { name: trx }), p.getByRole('button', { name: trx })]) {
        const n = await loc.count().catch(() => 0);
        for (let i = n - 1; i >= 0 && !hit; i--) { const e = loc.nth(i); if (await e.isVisible().catch(() => false)) { await e.click({ timeout: 5_000 }).catch(() => undefined); await p.waitForTimeout(800); hit = true; } }
        if (hit) break;
      }
      if (!hit) { console.log(`[sheetNav] ${name}: 탭 '${tab}' 없음`); return false; }
    }
    return true;
  }
  for (const el of [p.getByRole('tab', { name: rx }).first(), p.getByRole('button', { name: rx }).first(), p.getByText(rx).first()]) {
    if (await el.isVisible({ timeout: 1_200 }).catch(() => false)) { await el.click({ timeout: 3_000 }).catch(() => undefined); await p.waitForTimeout(800); return true; }
  }
  // 탭이 아니라 체크박스로 여는 하단 그리드(DMF0005 Detail → Purchase · 2026-11-02 172행 미측정) — 켜서 보이는 그리드가 늘면 그 시트로 본다
  const grids = () => p.evaluate(() => [...document.querySelectorAll('.wj-flexgrid')].filter(e => (e as HTMLElement).offsetParent !== null).length).catch(() => 0) as Promise<number>;
  const g0 = await grids(); if (g0 >= 2) return true; /* 탭 없이 이미 열린 하단 그리드 — 호출부가 pickGrid 로 그 시트 컬럼을 가진 그리드를 고른다(DMF0005 Purchase · 2026-11-02) */ const boxes = p.locator('[class*="_formItem_"] input[type="checkbox"], [class*="SubTitle" i] input[type="checkbox"], [class*="subTitle" i] input[type="checkbox"]'); const nb = await boxes.count().catch(() => 0);
  for (let k = 0; k < nb; k++) { const b = boxes.nth(k); if (!(await b.isVisible().catch(() => false)) || await b.isChecked().catch(() => true)) continue; await b.click({ timeout: 3_000 }).catch(() => undefined); await p.waitForTimeout(1_000); if ((await grids()) > g0) return true; await b.click({ timeout: 3_000 }).catch(() => undefined); await p.waitForTimeout(400); }
  return false;
}
