/**
 * nscm.ts — NSCM To-Be 화면 E2E 공통 헬퍼 (Playwright)
 *  로그인: FE 와 동일하게 POST {BE}/user/login {userId} (비밀번호 없음) — /sso/dev-login 은 BE Security 가 401 로 막아 fallback 으로만
 *  화면 열기: FE /view/<MENU_ID> (MDI 딥링크)
 *  셀렉터 규약: SearchArea 조회 버튼 = text /조회|Search/ · SubTitle 버튼 = buttonLabel 'Save(F7)' 'Insert(F8)' 'Delete(F9)' 'Search(F5)'
 *              그리드 = Wijmo FlexGrid (.wj-flexgrid / .wj-colheaders .wj-cell / .wj-cells .wj-row)
 *  call-proc 응답은 page.on('response') 로 수집해 (menu, sheet, btn, status, rows) 를 남긴다.
 */
import { expect, type Page, type Locator, type Response } from '@playwright/test';
import * as fs from 'node:fs';
import * as path from 'node:path';

export const CFG = JSON.parse(fs.readFileSync(path.join(__dirname, '..', 'e2e.config.json'), 'utf8').replace(/^﻿/, ''));
export const FE: string = process.env.E2E_FE || CFG.feUrl;
export const BE: string = process.env.E2E_BE || CFG.beUrl;

export type ProcCall = { url: string; menu: string; sheet: string; btn: string; status: number; rows: number | null; ms: number };

export class Nscm {
  calls: ProcCall[] = [];
  constructor(public page: Page) {
    page.on('response', async (res: Response) => {
      const u = res.url();
      const m = u.match(/\/([^/]+)\/([^/]+)\/([^/]+)\/call-proc(?:-stream)?(?:\?|$)/);
      if (!m) return;
      // 응답 헤더 시점에 먼저 기록(동기) — json 파싱을 기다린 뒤 push 하면 search() 가 calls 를 자른 뒤에 들어가 '호출 0' 으로 오판한다(2026-10-20)
      const rec: ProcCall = { url: u, menu: decodeURIComponent(m[1]), sheet: decodeURIComponent(m[2]), btn: decodeURIComponent(m[3]), status: res.status(), rows: null, ms: 0 };
      this.calls.push(rec);
      try {
        const ct = res.headers()['content-type'] || '';
        if (/json/.test(ct) && res.status() === 200) {
          const j = await res.json();
          const arr = Array.isArray(j) ? j : (j?.data ?? j?.result ?? j?.rows ?? null);
          rec.rows = Array.isArray(arr) ? arr.length : (arr && typeof arr === 'object' ? Object.values(arr).reduce((n: number, v: unknown) => n + (Array.isArray(v) ? v.length : 0), 0) : null);
        }
      } catch { /* 스트리밍/비JSON */ }
    });
  }

  /**
   * 로그인 = FE 와 동일한 경로: FE 페이지 origin 에서 `POST {BE}/user/login {userId}` (JsonLoginFilter · CustomAuthenticationProvider = 비밀번호 미사용).
   *  2026-10-20: 기존 `/sso/dev-login` 은 SsoDevController 에 @AuthCheck(NONE) 이 없어 CustomAuthorizationManager 가 401 로 막는다(BE 미수정).
   *  /user/login 은 useSessionStore.ts 가 실제로 쓰는 엔드포인트라 FE 쿠키 동작(SameSite/credentials)까지 그대로 재현된다. 실패 시에만 dev-login 으로 한 번 더 시도.
   */
  async loginAs(userId: string) {
    // FE 는 BE 를 직접 부르지 않고 vite 프록시(FE/api → BE)를 거친다(axios baseURL '/api') → 세션 쿠키는 FE origin 에 있어야 한다.
    // BE(localhost:8080) 에 직접 로그인하면 쿠키가 다른 호스트에 남아 FE 는 로그인 화면을 보여준다(2026-10-20 실측 스크린샷).
    const api = `${FE}${CFG.feApiPrefix ?? '/api'}`;
    await this.page.goto(FE, { waitUntil: 'domcontentloaded' });
    const r = await this.page.evaluate(async ({ api, id }) => {
      try {
        const res = await fetch(`${api}/user/login`, { method: 'POST', credentials: 'include', headers: { 'content-type': 'application/json' }, body: JSON.stringify({ userId: id }) });
        return { status: res.status, text: (await res.text()).slice(0, 300) };
      } catch (e) { return { status: 0, text: String(e) }; }
    }, { api, id: userId });
    if (r.status < 200 || r.status >= 300) {
      const res = await this.page.goto(`${BE}/sso/dev-login?id=${encodeURIComponent(userId)}`, { waitUntil: 'domcontentloaded' });
      if (!res || res.status() >= 400) throw new Error(`로그인 실패: POST ${api}/user/login HTTP ${r.status} ${r.text} · dev-login HTTP ${res ? res.status() : '-'} — '${userId}' 가 SCM_ADM_USER_M/PR_GET_NSCM_USER 에 없거나 BE/FE 미기동. tools/E2E/probe-accounts.js 로 가능 계정 확인`);
    }
    await this.page.goto(FE, { waitUntil: 'domcontentloaded' });
    await this.page.waitForLoadState('networkidle').catch(() => undefined);
    // FE 스토어가 세션을 복원하지 못해 로그인 폼이 남아 있으면 사용자와 같은 방법(아이디 입력 → Login)으로 마무리
    const loginBtn = this.page.getByRole('button', { name: /^(Login|로그인)$/i }).first();
    if (await loginBtn.isVisible({ timeout: 3_000 }).catch(() => false)) {
      const box = this.page.getByRole('textbox').first();
      await box.fill(userId); await loginBtn.click();
      await loginBtn.waitFor({ state: 'hidden', timeout: 30_000 }).catch(() => undefined);
      await this.page.waitForLoadState('networkidle').catch(() => undefined);
    }
    if (await loginBtn.isVisible({ timeout: 1_000 }).catch(() => false)) throw new Error(`로그인 후에도 FE 로그인 화면이 남아 있음 — ${api}/user/session 확인`);
    await this.dismissNotices();
  }

  /**
   * 로그인 직후 뜨는 공지/안내 팝업(예: "[COMMON] 등록된 내용이 없습니다" · 등록 일시 · 오늘 하루 열지 않기 · 이전/다음)을 닫는다.
   * 2026-10-20 실측: 이 팝업이 화면을 덮어 조회조건 탐색·조회 클릭이 전부 막혔다(좌측 메뉴 글자 'Plant Site' 만 오탐으로 통과).
   * 닫기 순서: '오늘 하루 열지 않기' 체크(재노출 방지) → × / 닫기 버튼 → Escape. 최대 5개.
   */
  async dismissNotices(appearWaitMs = 4_000) {
    // 팝업은 Home 이 마운트된 뒤 공지 조회가 끝나야 뜬다(수백 ms~수 초) → 첫 판정은 appearWaitMs 까지 기다린다.
    for (let i = 0; i < 5; i++) {
      const dlg = this.page.locator('[role="dialog"], [role="alertdialog"], .MuiDialog-root, [class*="Modal"], [class*="modal"]').filter({ hasText: /등록된 내용|등록 일시|오늘 하루|공지|Notice/i }).last();
      if (!(await dlg.isVisible({ timeout: i === 0 ? appearWaitMs : 1_500 }).catch(() => false))) return i;
      // '오늘 하루 열지 않기' 체크 → 같은 브라우저 컨텍스트에서 Home 재마운트 시 재노출 방지 (MUI Checkbox: input 을 직접 체크)
      const todayBox = dlg.locator('label:has-text("오늘 하루"), label:has-text("Do not show")').locator('input[type="checkbox"]').first();
      if (await todayBox.isVisible().catch(() => false)) { if (!(await todayBox.isChecked().catch(() => true))) await todayBox.check({ force: true }).catch(() => undefined); }
      // 주의: 공지 팝업의 backdrop 도 <button aria-label="Close"> 라서 aria-label 로 먼저 잡으면 창에 가려 클릭이 영원히 재시도된다(실측 30s×5).
      //       텍스트가 있는 × / 닫기 / Close 버튼을 우선, 그다음 backdrop 이 아닌 aria-label close, 마지막 Escape. 클릭 대기는 5초로 제한.
      const close = dlg.locator('button').filter({ hasText: /^\s*[×✕Xx]\s*$|닫기|^Close$/ }).first();
      const close2 = dlg.locator('button[aria-label*="close" i]:not([class*="backdrop" i])').first();
      if (await close.isVisible().catch(() => false)) await close.click({ timeout: 5_000 }).catch(() => undefined);
      else if (await close2.isVisible().catch(() => false)) await close2.click({ timeout: 5_000, force: true }).catch(() => undefined);
      else await this.page.keyboard.press('Escape');
      await dlg.waitFor({ state: 'hidden', timeout: 5_000 }).catch(() => undefined);
    }
    return 5;
  }

  /**
   * MDI 딥링크 보정 — 2026-10-20 실측: 새 세션에서 `/view/<ID>` 로 들어가면 탭은 열리지만 활성 탭은 Home 으로 남는다
   * (RouterSync 의 "활성 탭 → URL 미러" 효과가 "URL → 탭 활성화" 효과보다 먼저 돌아 URL 을 Home 으로 되돌림). 화면 컴포넌트는 숨은 채 마운트돼
   * 초기 dayRange 조회만 나가고, 조회조건·그리드·조회 버튼은 보이지 않는다. 사용자가 탭을 클릭하는 것과 같은 보정을 한다:
   *  ① 그리드/타이틀이 보이면 끝 ② 같은 URL 로 한 번 더 이동(탭이 이미 있으면 setActiveTab 경로) ③ 탭 스트립에서 Home 이 아닌 탭 클릭.
   */
  async activateScreenTab(menuId: string) {
    // 활성 판정 = URL 이 /view/<ID> 로 미러링됐고(RouterSync) 그리드 또는 SearchArea 가 보임.
    //  ⚠ SubTitle 류 셀렉터는 Home 의 즐겨찾기 카드(subTitle)에도 걸려 오판했다(2026-10-20 trace) → 제외.
    const body = async () => {
      const seen = await Promise.race([
        this.page.locator('.wj-flexgrid').first().waitFor({ state: 'visible', timeout: 8_000 }).then(() => true),
        this.page.locator('[class*="SearchArea"], [class*="searchArea"]').first().waitFor({ state: 'visible', timeout: 8_000 }).then(() => true),
      ]).catch(() => false);
      return seen && new URL(this.page.url()).pathname.toUpperCase().endsWith(`/VIEW/${menuId.toUpperCase()}`);
    };
    if (await body()) return 'direct';
    // URL 이 /view/home 으로 되돌아가며 Home 이 재마운트 → 공지 팝업이 다시 뜬다. 한 번 더 닫고(오늘 하루 체크 포함) 탭을 클릭한다.
    for (let round = 0; round < 3; round++) {
      await this.dismissNotices(round === 0 ? 4_000 : 1_500);
      // 탭 스트립의 화면 탭: <button class="_tab_…"><span>이름</span><div class="_closeBtn_…">…</div></button> — Home 탭은 닫기 버튼이 없다
      const tabs = this.page.locator('button[class*="_tab_"]').filter({ has: this.page.locator('[class*="closeBtn"], [class*="_close"]') });
      const n = await tabs.count();
      if (n) {
        const t = tabs.nth(n - 1);
        await t.click({ timeout: 5_000 }).catch(() => undefined);
        if (await body()) return 'tabclick';
      }
      // 탭 자체가 없으면(딥링크가 탭도 못 열었을 때) 같은 URL 로 재진입
      await this.page.goto(`${FE}/view/${menuId}`, { waitUntil: 'domcontentloaded' });
      if (await body()) return 'regoto';
    }
    return 'none';
  }

  /** MDI 딥링크로 화면을 연다. 반환: authorized(권한 안내가 뜨지 않음), notFound */
  async openScreen(menuId: string) {
    this.calls = [];
    await this.page.goto(`${FE}/view/${menuId}`, { waitUntil: 'domcontentloaded' });
    await this.dismissNotices();
    await this.activateScreenTab(menuId);
    const notFound = await this.page.getByText(/404|Not Found|페이지를 찾을 수 없/i).first().isVisible({ timeout: 3_000 }).catch(() => false);
    const guest = await this.page.getByText(/not authorized|권한이 없|권한신청|Apply for permission/i).first().isVisible({ timeout: 3_000 }).catch(() => false);
    if (guest) await this.closeAlert();
    // 화면 본문(제목 영역 또는 그리드) 대기
    await Promise.race([
      this.page.locator('.wj-flexgrid').first().waitFor({ state: 'visible', timeout: 30_000 }),
      this.page.locator('[class*="SubTitle"], [class*="subTitle"], [class*="MainTitle"], [class*="TitleArea"]').first().waitFor({ state: 'visible', timeout: 30_000 }),
    ]).catch(() => undefined);
    return { authorized: !guest, notFound };
  }

  /** 알림/확인 다이얼로그 닫기 (확인 우선) */
  async closeAlert(prefer: 'ok' | 'cancel' = 'ok') {
    const dlg = this.page.locator('[role="dialog"], [role="alertdialog"], .MuiDialog-root').last();
    if (!(await dlg.isVisible({ timeout: 1_000 }).catch(() => false))) return false;
    const names = prefer === 'ok' ? [/^(확인|OK|Yes|예|닫기|Close)$/i, /./] : [/^(취소|Cancel|No|아니오)$/i, /^(확인|OK|닫기|Close)$/i];
    for (const n of names) { const b = dlg.getByRole('button', { name: n }).first(); if (await b.isVisible().catch(() => false)) { await b.click(); return true; } }
    await this.page.keyboard.press('Escape'); return true;
  }

  /** 열려 있는 에러/경고 알림 텍스트(없으면 '') */
  async alertText() {
    const dlg = this.page.locator('[role="dialog"], [role="alertdialog"], .MuiDialog-root').last();
    return (await dlg.isVisible({ timeout: 500 }).catch(() => false)) ? (await dlg.innerText()).trim() : '';
  }

  searchArea(): Locator { return this.page.locator('[class*="SearchArea"], [class*="searchArea"], form').first(); }

  /** 라벨 텍스트로 조회조건 입력 컨트롤을 찾는다(FormItem 라벨 → 형제 input/combobox) */
  /**
   * 보이는 첫 요소 — MDI 는 keep-alive 라 Home 등 비활성 탭의 DOM 이 숨은 채 남아 있다(Home 의 'Division' 표 헤더 등).
   * `.first()` 가 숨은 요소를 집으면 isVisible=false 로 오판 → 앞에서부터 보이는 것을 찾는다(Playwright 1.49 는 filter({visible}) 미지원).
   */
  async visibleFirst(loc: Locator, max = 12): Promise<Locator | null> {
    const n = Math.min(await loc.count().catch(() => 0), max);
    for (let i = 0; i < n; i++) { const l = loc.nth(i); if (await l.isVisible().catch(() => false)) return l; }
    return null;
  }

  fieldByLabel(label: string): Locator {
    const lab = this.page.getByText(new RegExp(`^\\s*${escapeRe(label)}\\s*\\*?\\s*$`, 'i')).first();
    return lab.locator('xpath=ancestor::*[self::div or self::label][1]/following-sibling::*[1]//input | ancestor::*[self::div][2]//input').first();
  }

  async fieldExists(label: string) {
    const loc = this.page.getByText(new RegExp(`^\\s*${escapeRe(label)}\\s*\\*?\\s*$`, 'i'));
    const deadline = Date.now() + 5_000;
    do { if (await this.visibleFirst(loc)) return true; await this.page.waitForTimeout(250); } while (Date.now() < deadline);
    return false;
  }

  /** Division 선택 — DivisionField(콤보) 가 있으면 옵션 선택 */
  async setDivision(code: string) {
    const combo = await this.visibleFirst(this.page.getByRole('combobox'));
    if (!combo) return false;
    await combo.click();
    const opt = this.page.getByRole('option', { name: new RegExp(`^\\s*${escapeRe(code)}(\\s|$|\\b)`) }).first();
    if (await opt.isVisible({ timeout: 3_000 }).catch(() => false)) { await opt.click(); return true; }
    await this.page.keyboard.press('Escape'); return false;
  }

  /** 조회 실행 — SearchArea 조회 버튼 → call-proc(SEARCH 류) 응답 대기 */
  async search(opts: { timeout?: number } = {}) {
    const before = this.calls.length;
    const btn = await this.visibleFirst(this.page.getByRole('button', { name: /^(조회|Search)(\(F5\))?$/ }));
    if (btn) await btn.click(); else await this.page.keyboard.press('F5');
    const t0 = Date.now();
    // 메인 조회(call-proc) 응답을 기다린다 — 초기기간 조회(dayRange)는 조회 버튼과 무관하므로 제외
    await this.page.waitForResponse(r => /call-proc/.test(r.url()) && !/\/dayRange\//i.test(r.url()), { timeout: opts.timeout ?? CFG.searchTimeoutMs }).catch(() => undefined);
    await this.page.waitForLoadState('networkidle', { timeout: 30_000 }).catch(() => undefined);
    const mine = this.calls.slice(before); mine.forEach(c => (c.ms = Date.now() - t0));
    return mine;
  }

  grids(): Locator { return this.page.locator('.wj-flexgrid'); }
  grid(i = 0): Locator { return this.grids().nth(i); }
  async gridHeaders(i = 0): Promise<string[]> {
    const g = this.grid(i); await g.waitFor({ state: 'visible', timeout: 20_000 }).catch(() => undefined);
    const cells = await g.locator('.wj-colheaders .wj-cell').allInnerTexts();
    return cells.map(s => s.replace(/\s+/g, ' ').trim()).filter(Boolean);
  }
  /**
   * 그리드 컬럼 정의 binding 전부(가상화 무관) — DOM 헤더(gridHeaders)는 화면에 보이는 열만 있어 동적 기간 컬럼 수를 셀 수 없다.
   *  Wijmo 는 호스트 엘리먼트에 컨트롤 인스턴스를 '$WJ-CTRL' 키로 보관한다. 키가 없으면 columns 를 가진 속성을 탐색, 그래도 없으면 null(판정 불가).
   *  (2026-10-20 SCP0096: 기간 컬럼 0 인데 헤더 6/기대 6 PASS 이던 구멍 — 동적 컬럼 판정용)
   */
  async gridBindings(i = 0): Promise<string[] | null> {
    const g = this.grid(i); await g.waitFor({ state: 'visible', timeout: 20_000 }).catch(() => undefined);
    return g.evaluate((el: Element) => {
      type Col = { binding?: string; visible?: boolean };
      type Ctl = { columns?: ArrayLike<Col> };
      const host = el as unknown as Record<string, unknown>;
      let ctl = host['$WJ-CTRL'] as Ctl | undefined;
      if (!ctl || !ctl.columns) for (const k of Object.getOwnPropertyNames(host)) { const v = host[k] as Ctl | undefined; if (v && typeof v === 'object' && v.columns && typeof (v.columns as ArrayLike<Col>).length === 'number') { ctl = v; break; } }
      if (!ctl || !ctl.columns) return null;
      const out: string[] = []; for (let j = 0; j < ctl.columns.length; j++) { const c = ctl.columns[j]; if (c && c.binding && c.visible !== false) out.push(String(c.binding)); }
      return out;
    }).catch(() => null);
  }
  async gridRowCount(i = 0): Promise<number> {
    const g = this.grid(i);
    // Wijmo 는 가상화 — 표시 행만 DOM 에 있다. SubTitle 의 Total 카운트가 있으면 우선 사용
    const total = await this.page.getByText(/Total\s*[:：]?\s*[\d,]+|총\s*[\d,]+\s*건/i).first().innerText({ timeout: 1_000 }).catch(() => '');
    const m = total.match(/([\d,]+)/); if (m) return Number(m[1].replace(/,/g, ''));
    return g.locator('.wj-cells .wj-row').count();
  }
  async gridColumnValues(colHeader: string, i = 0): Promise<string[]> {
    const headers = await this.gridHeaders(i); const ci = headers.findIndex(h => h.toLowerCase() === colHeader.toLowerCase());
    if (ci < 0) return [];
    const rows = this.grid(i).locator('.wj-cells .wj-row'); const n = await rows.count(); const out: string[] = [];
    for (let r = 0; r < n; r++) out.push((await rows.nth(r).locator('.wj-cell').nth(ci).innerText().catch(() => '')).trim());
    return out;
  }
  async gridCell(r: number, c: number, i = 0): Promise<Locator> { return this.grid(i).locator('.wj-cells .wj-row').nth(r).locator('.wj-cell').nth(c); }
  async setCell(r: number, c: number, value: string, i = 0) {
    const cell = await this.gridCell(r, c, i); await cell.dblclick(); await this.page.keyboard.press('Control+A'); await this.page.keyboard.type(value); await this.page.keyboard.press('Enter');
  }

  subButton(name: 'Save' | 'Insert' | 'Delete' | 'Search' | 'Sort' | 'Filter' | 'Excel Upload' | string): Locator {
    return this.page.getByRole('button', { name: new RegExp(`^${escapeRe(name)}(\\(F\\d+\\))?$`, 'i') }).first();
  }
  async subButtonVisible(name: string) { return this.subButton(name).isVisible({ timeout: 3_000 }).catch(() => false); }
  async visibleButtons(): Promise<string[]> {
    const names = await this.page.getByRole('button').allInnerTexts();
    return [...new Set(names.map(s => s.replace(/\s+/g, ' ').trim()).filter(Boolean))];
  }

  /** 저장 — Save(F7) 클릭 → SAVE call-proc 응답/알림 확인. 확인 다이얼로그는 OK */
  async save() {
    const before = this.calls.length;
    await this.subButton('Save').click();
    await this.closeAlert('ok');
    await this.page.waitForResponse(r => /call-proc/.test(r.url()), { timeout: 60_000 }).catch(() => undefined);
    await this.page.waitForLoadState('networkidle', { timeout: 30_000 }).catch(() => undefined);
    const msg = await this.alertText(); if (msg) await this.closeAlert('ok');
    return { calls: this.calls.slice(before), message: msg };
  }

  snapshot(name: string) { return this.page.screenshot({ path: path.join(process.env.E2E_RESULTS || CFG.resultsDir, 'shots', `${name}.png`), fullPage: false }).catch(() => undefined); }
}

export function escapeRe(s: string) { return s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'); }
export const soft = expect.soft;
