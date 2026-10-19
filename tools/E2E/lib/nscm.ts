/**
 * nscm.ts — NSCM To-Be 화면 E2E 공통 헬퍼 (Playwright)
 *  로그인: BE /sso/dev-login?id=<USER_ID> (local/dev 프로파일 전용, 비밀번호 없음)
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
      let rows: number | null = null;
      try {
        const ct = res.headers()['content-type'] || '';
        if (/json/.test(ct) && res.status() === 200) {
          const j = await res.json();
          const arr = Array.isArray(j) ? j : (j?.data ?? j?.result ?? j?.rows ?? null);
          rows = Array.isArray(arr) ? arr.length : (arr && typeof arr === 'object' ? Object.values(arr).reduce((n: number, v: unknown) => n + (Array.isArray(v) ? v.length : 0), 0) : null);
        }
      } catch { /* 스트리밍/비JSON */ }
      this.calls.push({ url: u, menu: decodeURIComponent(m[1]), sheet: decodeURIComponent(m[2]), btn: decodeURIComponent(m[3]), status: res.status(), rows, ms: 0 });
    });
  }

  /** dev-login 으로 세션 생성 후 FE 로 이동 */
  async loginAs(userId: string) {
    const res = await this.page.goto(`${BE}/sso/dev-login?id=${encodeURIComponent(userId)}`, { waitUntil: 'domcontentloaded' });
    if (res && res.status() === 401) throw new Error(`dev-login 실패(401): PKG_NSCM_UI_COM_USER.PR_GET_NSCM_USER 가 '${userId}' 를 돌려주지 않음(SCM_ADM_USER_M 행 존재와 별개 — 그룹/권한 매핑 확인). tools/E2E/probe-accounts.js 로 가능 계정 확인`);
    await this.page.waitForURL(u => u.toString().startsWith(FE), { timeout: 30_000 }).catch(() => this.page.goto(FE));
    await this.page.waitForLoadState('networkidle').catch(() => undefined);
  }

  /** MDI 딥링크로 화면을 연다. 반환: authorized(권한 안내가 뜨지 않음), notFound */
  async openScreen(menuId: string) {
    this.calls = [];
    await this.page.goto(`${FE}/view/${menuId}`, { waitUntil: 'domcontentloaded' });
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
  fieldByLabel(label: string): Locator {
    const lab = this.page.getByText(new RegExp(`^\\s*${escapeRe(label)}\\s*\\*?\\s*$`, 'i')).first();
    return lab.locator('xpath=ancestor::*[self::div or self::label][1]/following-sibling::*[1]//input | ancestor::*[self::div][2]//input').first();
  }

  async fieldExists(label: string) {
    return this.page.getByText(new RegExp(`^\\s*${escapeRe(label)}\\s*\\*?\\s*$`, 'i')).first().isVisible({ timeout: 5_000 }).catch(() => false);
  }

  /** Division 선택 — DivisionField(콤보) 가 있으면 옵션 선택 */
  async setDivision(code: string) {
    const combo = this.page.getByRole('combobox').first();
    if (!(await combo.isVisible({ timeout: 3_000 }).catch(() => false))) return false;
    await combo.click();
    const opt = this.page.getByRole('option', { name: new RegExp(`^\\s*${escapeRe(code)}(\\s|$|\\b)`) }).first();
    if (await opt.isVisible({ timeout: 3_000 }).catch(() => false)) { await opt.click(); return true; }
    await this.page.keyboard.press('Escape'); return false;
  }

  /** 조회 실행 — SearchArea 조회 버튼 → call-proc(SEARCH 류) 응답 대기 */
  async search(opts: { timeout?: number } = {}) {
    const before = this.calls.length;
    const btn = this.page.getByRole('button', { name: /^(조회|Search)(\(F5\))?$/ }).first();
    if (await btn.isVisible({ timeout: 5_000 }).catch(() => false)) await btn.click(); else await this.page.keyboard.press('F5');
    const t0 = Date.now();
    await this.page.waitForResponse(r => /call-proc/.test(r.url()), { timeout: opts.timeout ?? CFG.searchTimeoutMs }).catch(() => undefined);
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
