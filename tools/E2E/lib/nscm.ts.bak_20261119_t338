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
import * as net from 'node:net';
import { applyGridMutations } from './mutate';  // CheckList 자기검증(변이 시험, 2026-10-28) — CL_MUTATE 없으면 무동작
import { waitLangFree, pendingLangRestore, langRestored, acquireLang, releaseLang } from './langlock';
import { retryInsertWithRow } from './insertpre';  // 2026-11-12 Y01(T259)  // 2026-11-10 T189 — 다른 실행의 언어 전환(서버 사용자 설정) 중에는 화면을 열지 않는다

export const CFG = JSON.parse(fs.readFileSync(path.join(__dirname, '..', 'e2e.config.json'), 'utf8').replace(/^﻿/, ''));
export const FE: string = process.env.E2E_FE || CFG.feUrl;
export const BE: string = process.env.E2E_BE || CFG.beUrl;
/** 2026-11-12 T256: BE 포트가 열려 있나(TCP 연결 2초) */
export function bePortOpen(): Promise<boolean> {
  return new Promise(res => { let u: URL; try { u = new URL(BE); } catch { res(true); return; } const s = net.connect({ host: u.hostname, port: Number(u.port || (u.protocol === 'https:' ? 443 : 80)) });
    const done = (ok: boolean) => { s.destroy(); res(ok); }; s.setTimeout(2_000, () => done(false)); s.once('connect', () => done(true)); s.once('error', () => done(false)); });
}
/** BE 포트가 닫혀 있으면(재기동 중) 열릴 때까지 기다린다 — 최대 maxMs. 반환 = 기다린 ms(처음부터 열려 있으면 0 · 끝내 안 열리면 -1) */
export async function waitBeUp(tag: string, maxMs = Number(process.env.E2E_BE_WAIT_MS || 300_000)): Promise<number> {
  if (await bePortOpen()) return 0;
  const t0 = Date.now(); console.log(`[BE 대기] ${tag}: BE(${BE}) 포트가 닫혀 있음(재기동 중으로 판단) — 열릴 때까지 최대 ${Math.round(maxMs / 1000)}초 대기`);
  while (Date.now() - t0 < maxMs) { await new Promise(r => setTimeout(r, 5_000)); if (await bePortOpen()) { await new Promise(r => setTimeout(r, 10_000)); /* 포트가 열린 직후는 아직 초기화 중일 수 있다 */ console.log(`[BE 대기] ${tag}: ${Math.round((Date.now() - t0) / 1000)}초 뒤 BE 응답 — 이어서 진행`); return Date.now() - t0; } }
  console.log(`[BE 대기] ${tag}: ${Math.round(maxMs / 1000)}초 안에 BE 가 뜨지 않음`); return -1;
}

export type ProcCall = { url: string; menu: string; sheet: string; btn: string; status: number; rows: number | null; ms: number; req?: string; res?: string; body?: string; dur?: number; sets?: Record<string, Record<string, unknown>[]>; at?: string };

export class Nscm {
  calls: ProcCall[] = [];
  /** 2026-11-06 플랜 2-1: 이 page 가 보낸 모든 call-proc(openScreen 이 비우지 않음) — 픽스처가 테스트 끝에 Doc/verify/<ID>/calls/*.json 으로 남겨 diff_verify.py(차등 검증)가 AS-IS 재실행 인자로 쓴다 */
  allCalls: ProcCall[] = [];
  /** 2026-10-24 W1: 콤보 API(admin/combo·combo-muti) 요청 본문·응답 건수 — AS-IS 원천 비교의 TO-BE 인자 증거 */
  combos: { url: string; body: string; status: number; n: number | null; keys: string[]; rows?: { c: string; v: string }[]; user?: string }[] = [];
  /** 현재 로그인 계정(loginAs 가 갱신) — 콤보 수집·세션 축 검사기(combo_live_check)가 쓴다(2026-11-03) */
  curUser = '';
  /** 2026-10-21: 화면 콘솔 오류·페이지 예외 — 공용 그리드 생성이 Wijmo 단언으로 죽어도(SCP0100 "Unknown property inner") 라벨 누락으로만 보였던 사고. smoke 가 어노테이션 `console` 로 남기고 FAIL 로 세운다 */
  consoleErrors: string[] = [];
  /** 2026-10-26: 이 화면 요청 중 HTTP 5xx(모든 /api/ — 콤보·call-proc·메타) — BE 로그 DB 오류를 이 테스트에 귀속하는 근거 */
  serverErrors: { url: string; status: number; body?: string }[] = [];
  /** 2026-10-31 사용자 지정 조회조건(users.json screens[<ID>].conds: 라벨 → 값) — openScreen 때 읽고 첫 search() 직전에 1회 적용(SCP0111 Plan Date 20260907 = 데이터 있는 조건) */
  userConds: Record<string, string> = {};
  private userCondsApplied = false;
  userCondsNote = '';
  /** 2026-11-06 속도 개선 ① 계측: 로그인·화면 열기 내부 구간(ms 누적)과 요청 수(FE 정적 모듈 vs /api) — 픽스처 timingProbe 가 테스트 끝에 기록. 동작 영향 없음 */
  tparts: Record<string, number> = {};
  reqs = { fe: 0, api: 0 };
  private tp(k: string, t0: number) { this.tparts[k] = (this.tparts[k] || 0) + (Date.now() - t0); }
  constructor(public page: Page) {
    page.on('request', (rq) => { if (/\/api\//.test(rq.url())) this.reqs.api++; else this.reqs.fe++; });
    page.on('response', (res: Response) => { if (res.status() >= 500 && /\/api\//.test(res.url())) { const rec = { url: res.url().slice(0, 200), status: res.status(), body: '' }; this.serverErrors.push(rec); res.text().then(t => { rec.body = String(t || '').slice(0, 600); }).catch(() => undefined); } });  // 본문(ORA 코드)으로 '이 화면의' DB 오류인지 가린다(2026-10-29)
    page.on('pageerror', err => { this.consoleErrors.push(`pageerror: ${String(err && err.message || err).slice(0, 300)}`); });
    page.on('console', msg => { if (msg.type() === 'error') { const t = msg.text(); if (!/favicon|net::ERR_|Failed to load resource|\[vite\]|React DevTools|Download the React/i.test(t)) this.consoleErrors.push(`console.error: ${t.slice(0, 300)}`); } });
    page.on('response', async (res: Response) => {
      const u = res.url();
      if (/\/admin\/combo(?:-muti)?(?:\?|$)/.test(u)) {
        const rec = { url: u, body: '', status: res.status(), n: null as number | null, keys: [] as string[], rows: [] as { c: string; v: string }[], user: this.curUser };
        this.combos.push(rec);
        try { rec.body = (res.request().postData() || '').slice(0, 2000); } catch { /* no body */ }
        try {
          const j = await res.json(); const d = j?.result ?? j?.data; // BaseResponse = {code, message, result}
          // 코드·명칭 쌍 — 화면 표시 문구를 코드로 환산(세션 언어와 무관하게 AS-IS 코드와 비교 · 2026-10-24 DMF0005 Team KO/EN 불일치)
          const pairs = (arr: Record<string, unknown>[]) => { const ks = Object.keys(arr[0] || {}); const kc = ks.find(k => /^code$/i.test(k)) || ks[0]; const kv = ks.find(k => /^name$/i.test(k)) || ks[1] || kc;
            return arr.slice(0, 6000).map(r => ({ c: String(r[kc] ?? ''), v: String(r[kv] ?? '') })); };
          if (Array.isArray(d)) { rec.n = d.length; rec.keys = Object.keys(d[0] || {}); rec.rows = pairs(d); }
          else if (d && typeof d === 'object') { rec.keys = Object.keys(d); rec.n = Object.values(d).reduce((s: number, v: unknown) => s + (Array.isArray(v) ? v.length : 0), 0); }
        } catch { /* 비JSON */ }
        return;
      }
      const m = u.match(/\/([^/]+)\/([^/]+)\/([^/]+)\/call-proc(?:-stream)?(?:\?|$)/);
      if (!m) return;
      // 응답 헤더 시점에 먼저 기록(동기) — json 파싱을 기다린 뒤 push 하면 search() 가 calls 를 자른 뒤에 들어가 '호출 0' 으로 오판한다(2026-10-20)
      const rec: ProcCall = { url: u, menu: decodeURIComponent(m[1]), sheet: decodeURIComponent(m[2]), btn: decodeURIComponent(m[3]), status: res.status(), rows: null, ms: 0, at: new Date().toISOString() };
      this.calls.push(rec); this.allCalls.push(rec);
      res.finished().then(() => { const tm = res.request().timing(); if (tm && tm.responseEnd > 0) rec.dur = Math.round(tm.responseEnd); }).catch(() => undefined);  // 요청 시작~응답 끝(EG415 · Node 왕복 제외)
      // 2026-10-23 조회조건 동작 검사: 조회 요청 본문(조건 인자) — 조건을 바꾼 뒤 인자가 달라졌는지 비교한다(최대 4000자)
      // 2026-11-06 플랜 2-1: GET 류는 무절단(차등 검증이 전체 인자를 다시 보낸다 — 다중 선택 목록이 4000자에서 잘리던 한계) · SAVE 류만 종전 4000자
      try { const pd = res.request().postData() || ''; rec.body = /SAVE|INS|UPD|DEL/i.test(rec.btn) && pd.length > 4000 ? pd.slice(0, 4000) : pd; } catch { /* no body */ }
      try {
        // SAVE 류는 요청 본문(보낸 행 수)·응답 요약을 남긴다 — "HTTP 200 인데 DB 미반영"(silent no-op) 을 가려내기 위해(2026-10-20 SCP0096)
        if (/SAVE|INS|UPD|DEL/i.test(rec.btn)) { try { const pd = res.request().postData() || ''; rec.req = pd.length > 400 ? pd.slice(0, 400) + `…(+${pd.length - 400})` : pd; } catch { /* no body */ } }
        const ct = res.headers()['content-type'] || '';
        if (/json/.test(ct) && res.status() === 200) {
          const j = await res.json();
          if (rec.req != null) { try { rec.res = JSON.stringify(j).slice(0, 300); } catch { /* ignore */ } }
          const arr = Array.isArray(j) ? j : (j?.data ?? j?.result ?? j?.rows ?? null);
          rec.rows = Array.isArray(arr) ? arr.length : (arr && typeof arr === 'object' ? Object.values(arr).reduce((n: number, v: unknown) => n + (Array.isArray(v) ? v.length : 0), 0) : null);
          // 2026-11-03 부가 결과셋(기준월·컷오프 등 작은 셋)을 남긴다 — 시나리오 dynlock 이 화면 자신의 응답값(AS-IS ds.Tables[1] 과 같은 원천)으로 경계를 정한다
          { const sets: Record<string, Record<string, unknown>[]> = {}; const scan = (o: unknown) => { if (!o || typeof o !== 'object' || Array.isArray(o)) return; for (const [k, v] of Object.entries(o as Record<string, unknown>)) { if (v === arr) continue; if (Array.isArray(v) && v.length > 0 && v.length <= 2000 && v[0] && typeof v[0] === 'object') sets[k] = (v as Record<string, unknown>[]).slice(0, 3); } }; scan(j); scan((j as { result?: unknown })?.result); scan((j as { data?: unknown })?.data); scan(arr); if (Object.keys(sets).length) rec.sets = sets; }
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
    this.curUser = userId;
    // FE 는 BE 를 직접 부르지 않고 vite 프록시(FE/api → BE)를 거친다(axios baseURL '/api') → 세션 쿠키는 FE origin 에 있어야 한다.
    // BE(localhost:8080) 에 직접 로그인하면 쿠키가 다른 호스트에 남아 FE 는 로그인 화면을 보여준다(2026-10-20 실측 스크린샷).
    const api = `${FE}${CFG.feApiPrefix ?? '/api'}`;
    let t0 = Date.now();
    await this.page.goto(FE, { waitUntil: 'domcontentloaded' });
    this.tp('login.goto1', t0); t0 = Date.now();
    const post = () => this.page.evaluate(async ({ api, id }) => {
      try {
        const res = await fetch(`${api}/user/login`, { method: 'POST', credentials: 'include', headers: { 'content-type': 'application/json' }, body: JSON.stringify({ userId: id }) });
        return { status: res.status, text: (await res.text()).slice(0, 300) };
      } catch (e) { return { status: 0, text: String(e) }; }
    }, { api, id: userId });
    // 2026-10-29: 로그인 401/5xx/무응답 = 계정 문제만이 아니다 — BE 커넥션 풀(HikariPool maxPoolSize) 고갈이면 PR_GET_NSCM_USER 가 60초 대기 후 SqlException → UsernameNotFound → 401(-9998).
    //   실측: 5화면 동시 CheckList(21:18) 중 21:24~21:26 풀 고갈(BE 로그 'Connection is not available … total=10, active=10, waiting=22') → SCP0020·SCP0096·SCP0111 의 @trace 1개씩이 같은 분에 로그인 실패.
    //   일시 장애라 간격을 두고 재시도한다(최대 LOGIN_TRIES회 · LOGIN_WAIT_MS 간격 · 픽스처 timeout 360s 안). 그래도 실패면 dev-login 폴백 뒤 사유(풀 고갈 가능)를 붙여 던진다.
    const LOGIN_TRIES = Number(process.env.E2E_LOGIN_TRIES || CFG.loginTries || 4), LOGIN_WAIT_MS = Number(process.env.E2E_LOGIN_WAIT_MS || CFG.loginWaitMs || 15_000);
    let r = await post(); const hist: string[] = [];
    if (r.status < 200 || r.status >= 300) { const w = await waitBeUp(`로그인 ${userId}`); if (w !== 0) { hist.push(w > 0 ? `BE 재기동 대기 ${Math.round(w / 1000)}초` : 'BE 미기동'); if (w > 0) { await this.page.goto(FE, { waitUntil: 'domcontentloaded' }).catch(() => undefined); r = await post(); } } }  // T256
    this.tp('login.post', t0); t0 = Date.now();
    for (let i = 1; (r.status < 200 || r.status >= 300) && i < LOGIN_TRIES; i++) {
      hist.push(`${i}회 HTTP ${r.status}`);
      await this.page.waitForTimeout(LOGIN_WAIT_MS);
      await this.page.goto(FE, { waitUntil: 'domcontentloaded' }).catch(() => undefined);
      r = await post();
    }
    if (r.status < 200 || r.status >= 300) {
      const res = await this.page.goto(`${BE}/sso/dev-login?id=${encodeURIComponent(userId)}`, { waitUntil: 'domcontentloaded' });
      if (!res || res.status() >= 400) throw new Error(`로그인 실패(${LOGIN_TRIES}회 시도${hist.length ? ' · ' + hist.join('·') : ''}): POST ${api}/user/login HTTP ${r.status} ${r.text} · dev-login HTTP ${res ? res.status() : '-'} — '${userId}' 가 SCM_ADM_USER_M/PR_GET_NSCM_USER 에 없거나 BE/FE 미기동, 또는 BE 커넥션 풀 고갈(동시 E2E 과다 — BE 로그 'Connection is not available' · config-local.yml maxPoolSize 확인). tools/E2E/probe-accounts.js 로 가능 계정 확인`);
    }
    this.tp('login.retry', t0); t0 = Date.now();
    await this.page.goto(FE, { waitUntil: 'domcontentloaded' });
    this.tp('login.goto2', t0); t0 = Date.now();
    await this.page.waitForLoadState('networkidle').catch(() => undefined);
    this.tp('login.idle', t0); t0 = Date.now();
    // FE 스토어가 세션을 복원하지 못해 로그인 폼이 남아 있으면 사용자와 같은 방법(아이디 입력 → Login)으로 마무리
    const loginBtn = this.page.getByRole('button', { name: /^(Login|로그인)$/i }).first();
    if (await loginBtn.isVisible({ timeout: 3_000 }).catch(() => false)) {
      const box = this.page.getByRole('textbox').first();
      await box.fill(userId); await loginBtn.click();
      await loginBtn.waitFor({ state: 'hidden', timeout: 30_000 }).catch(() => undefined);
      await this.page.waitForLoadState('networkidle').catch(() => undefined);
    }
    this.tp('login.form', t0); t0 = Date.now();
    if (await loginBtn.isVisible({ timeout: 1_000 }).catch(() => false)) throw new Error(`로그인 후에도 FE 로그인 화면이 남아 있음 — ${api}/user/session 확인`);
    await this.dismissNotices();
    this.tp('login.notice', t0);
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
    // 2026-11-06(속도 개선): 첫 판정을 8초 시간초과로 끝까지 기다리던 것 → 짧게 반복 확인. 실측(SCP0127 smoke 4건 13:36~13:39):
    //   딥링크가 Home 으로 되돌아가는 경우 매번 8.2초를 기다린 뒤에야 탭 클릭으로 넘어갔다(open.activate.tabclick 8158~8200ms).
    //   화면이 보이고 URL 이 맞으면 'direct'(종전과 같음) · URL 이 /view/<ID> 가 아닌 상태가 1초 이상 유지되면(= Home 으로 되돌아감) 바로 탭 클릭 보정으로 간다.
    //   보정 경로(탭 클릭·재진입·3회)는 그대로 — 판정 기준 변경 없음, 기다리는 시간만 줄인다.
    {
      const want = `/VIEW/${menuId.toUpperCase()}`;
      const deadline = Date.now() + 8_000; let offSince = 0;
      while (Date.now() < deadline) {
        const urlOk = new URL(this.page.url()).pathname.toUpperCase().endsWith(want);
        if (urlOk) {
          offSince = 0;
          const vis = await this.page.locator('.wj-flexgrid').first().isVisible().catch(() => false)
            || await this.page.locator('[class*="SearchArea"], [class*="searchArea"]').first().isVisible().catch(() => false);
          if (vis) return 'direct';
        } else if (!offSince) offSince = Date.now();
        else if (Date.now() - offSince >= 1_000) break;
        await this.page.waitForTimeout(200);
      }
    }
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

  /** 2026-11-12 T251: 끊긴 언어 전환(시간 초과로 원복 못 한 채 죽은 시험)이 남긴 계정 언어를 원래대로 되돌린다 — 기록(langlock journal)이 있고 주인이 죽었을 때만.
   *  되돌리는 동안 언어 잠금을 잡아 다른 실행이 그 사이 화면을 열지 않게 한다. 실패하면 기록을 남겨 다음 화면 열기가 다시 시도한다(측정은 계속 — 로그에 남김). */
  private async restoreBrokenLang(menuId: string): Promise<void> {
    const j = pendingLangRestore(); if (!j) return;
    const btn = this.page.locator('header button, [class*="header" i] button').filter({ hasText: /^(KOR|ENG|CHN)$/ }).first();
    const cur = ((await btn.innerText({ timeout: 5_000 }).catch(() => '')) || '').trim();
    if (!cur) { console.log(`[언어 복구] ${menuId}: 머리글 언어 버튼을 읽지 못함 — 끊긴 전환 기록(${j.tag} · 원래 ${j.name}) 유지`); return; }
    if (cur === j.name) { langRestored(cur); console.log(`[언어 복구] ${menuId}: 끊긴 전환 기록(${j.tag}) 확인 — 계정 언어는 이미 ${cur}`); return; }
    if ((await acquireLang(`${menuId} 언어 복구`, 60_000)) < 0) { console.log(`[언어 복구] ${menuId}: 언어 잠금을 얻지 못함 — 다음 화면 열기에서 재시도`); return; }
    try {
      const it = this.page.locator(`button[id="${j.code}"]`).first();
      for (let k = 0; k < 4 && !(await it.isVisible().catch(() => false)); k++) { await btn.evaluate(b => (b as HTMLElement).click()).catch(() => undefined); await it.waitFor({ state: 'visible', timeout: 3_000 }).catch(() => undefined); }
      await it.evaluate(b => (b as HTMLElement).click(), undefined, { timeout: 5_000 }).catch(() => undefined);
      for (let k = 0; k < 30 && ((await btn.innerText().catch(() => '')) || '').trim() !== j.name; k++) await this.page.waitForTimeout(300);
      await this.page.waitForLoadState('networkidle', { timeout: 15_000 }).catch(() => undefined);
      const now = ((await btn.innerText().catch(() => '')) || '').trim();
      if (langRestored(now)) console.log(`[언어 복구] ${menuId}: 끊긴 언어 전환(${j.tag} · pid ${j.pid}) 뒤 계정 언어 ${cur} → ${now} 로 되돌림`);
      else console.log(`[언어 복구 실패] ${menuId}: ${cur} → ${now}(원래 ${j.name}) — 이 화면의 측정은 ${now} 화면 기준일 수 있음`);
    } finally { releaseLang(); }
  }

  /** MDI 딥링크로 화면을 연다. 반환: authorized(권한 안내가 뜨지 않음), notFound */
  async openScreen(menuId: string) {
    this.calls = []; this.searchExpanded = false; this.consoleErrors = [];
    this.curMenu = menuId;
    this.userConds = {}; this.userCondsApplied = false; this.userCondsNote = '';
    try { const uj = JSON.parse(fs.readFileSync(path.join(__dirname, '..', 'users.json'), 'utf8').replace(/^\uFEFF/, '')); const sc = (uj.screens || {})[menuId.toUpperCase()] || {};
      // condsValidUntil(ISO) 이 지났으면 무시 — '이번만 한정' 조건(2026-10-31 사용자: SCP0111 Plan Date 20260907 은 이번 실행만)
      const until = sc.condsValidUntil ? Date.parse(sc.condsValidUntil) : NaN;
      if (sc.conds && typeof sc.conds === 'object' && !(isFinite(until) && Date.now() > until)) this.userConds = sc.conds;
      else if (sc.conds && isFinite(until)) console.log(`[userConds] ${menuId}: 지정 조건 유효기간(${sc.condsValidUntil}) 경과 — 기본 조건으로 조회`); } catch { /* 명부 없음 */ }
    let t0 = Date.now();
    await waitLangFree();
    await this.page.goto(`${FE}/view/${menuId}`, { waitUntil: 'domcontentloaded' });
    this.tp('open.goto', t0); t0 = Date.now();
    await this.dismissNotices();
    this.tp('open.notice', t0); t0 = Date.now();
    await this.restoreBrokenLang(menuId);
    const how = await this.activateScreenTab(menuId);
    this.tp('open.activate.' + how, t0); t0 = Date.now();
    const notFound = await this.page.getByText(/404|Not Found|페이지를 찾을 수 없/i).first().isVisible({ timeout: 3_000 }).catch(() => false);
    const guest = await this.page.getByText(/not authorized|권한이 없|권한신청|Apply for permission/i).first().isVisible({ timeout: 3_000 }).catch(() => false);
    if (guest) await this.closeAlert();
    this.tp('open.check', t0); t0 = Date.now();
    // 화면 본문(제목 영역 또는 그리드) 대기
    await Promise.race([
      this.page.locator('.wj-flexgrid').first().waitFor({ state: 'visible', timeout: 30_000 }),
      this.page.locator('[class*="SubTitle"], [class*="subTitle"], [class*="MainTitle"], [class*="TitleArea"]').first().waitFor({ state: 'visible', timeout: 30_000 }),
    ]).catch(() => undefined);
    this.tp('open.body', t0);
    // 2026-11-17 SCP0104 EG032(dana.robot · SCP Planner): 메뉴 트리에 화면이 없는 계정은 주소로 열어도 /view/home 에 남고 조회조건 0개인데
    //   '권한 없음' 문구가 없어 authorized=true 로 잡혔다 → 화면 ID 없는 Home 에 남으면 진입 실패(권한 없음)로 본다
    // 2026-11-17 사용자 확인(SSP0020 3번 EG-f6eeda7b): SSP Viewer 가 주소로 열면 화면이 열리지 않고 Home 으로 돌아가는데, Home 이동이 본문 대기 뒤에 일어나
    //   그 전에 읽은 주소(/view/SSP0020)로 authorized=true 가 됐다(09:5x 단독 캡처: 8초 뒤 /view/home · 그리드 0). → 주소를 최대 8초 동안 다시 읽어 Home 이동을 잡는다
    let u = this.page.url();
    for (let k = 0; k < 16 && !/\/view\/home\b/i.test(u); k++) {
      const hasGrid = await this.page.locator('.wj-flexgrid').first().isVisible().catch(() => false);
      if (hasGrid && k >= 4) break;   // 화면 그리드가 2초 이상 유지되면 진입 완료
      await this.page.waitForTimeout(500); u = this.page.url();
    }
    const landedHome = /\/view\/home\b/i.test(u) && !u.toUpperCase().includes(menuId.toUpperCase());
    if (process.env.E2E_DEBUG_OPEN) console.log(`[openScreen 진단] ${menuId} user=${this.curUser} url=${u} grid=${await this.page.locator('.wj-flexgrid').first().isVisible().catch(() => false)} guest=${guest} home=${landedHome}`);
    if (landedHome) console.log(`[openScreen] ${menuId}: 주소 진입 뒤 Home 에 남음(${u}) — 화면 진입 실패로 처리`);
    return { authorized: !guest && !landedHome, notFound };
  }

  /** 알림/확인 다이얼로그 닫기 (확인 우선) */
  async closeAlert(prefer: 'ok' | 'cancel' = 'ok') {
    // 보이는 대화상자만(닫힌 요소 잔존 오인 방지). 확인 쪽 = Confirm 포함 — 'Cancel·Confirm' 확인창에서 /./ 대체 규칙이 첫 버튼 Cancel 을 눌러
    //   저장이 취소되던 사고(2026-10-24 DMF0082 'Would you like to save it?'). 해당 버튼이 없으면 마지막 버튼(주 동작)
    const dlg = this.page.locator('[role="dialog"]:visible, [role="alertdialog"]:visible, .MuiDialog-root:visible').last();
    if (!(await dlg.isVisible({ timeout: 1_000 }).catch(() => false))) return false;
    const names = prefer === 'ok' ? [/^(확인|OK|Yes|예|Confirm|저장|Save|닫기|Close)$/i] : [/^(취소|Cancel|No|아니오)$/i, /^(확인|OK|닫기|Close)$/i];
    for (const n of names) { const b = dlg.getByRole('button', { name: n }).first(); if (await b.isVisible().catch(() => false)) { await b.click({ timeout: 5_000 }).catch(() => undefined); return true; } }
    if (prefer === 'ok') { const last = dlg.getByRole('button').last(); if (await last.isVisible().catch(() => false)) { await last.click({ timeout: 5_000 }).catch(() => undefined); return true; } }
    await this.page.keyboard.press('Escape'); return true;
  }

  /** 열려 있는 에러/경고 알림 텍스트(없으면 '') */
  async alertText() {
    const dlg = this.page.locator('[role="dialog"], [role="alertdialog"], .MuiDialog-root').last();
    return (await dlg.isVisible({ timeout: 500 }).catch(() => false)) ? (await dlg.innerText({ timeout: 2_000 }).catch(() => '')).trim() : '';  // 닫히는 중인 대화상자(W9 저장 직후) 예외 방지 2026-10-27
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

  /**
   * 조회조건 라벨 존재. 2026-10-21(SCP0100): As-is 라벨의 필수표시 '*'(Plan date*) 는 To-Be 에서 라벨 밖 별도 요소라 떼고 비교 —
   *   앞/뒤 '*' 허용, 'Unit (Qty)'·'From (YYYYMMDD)' 처럼 괄호 접미는 허용(라벨 'From' 으로도 매칭), 대소문자 무시.
   */
  async fieldExists(label: string, waitMs = 5_000) {
    const core = String(label).replace(/^\s*\*+\s*|\s*\*+\s*$/g, '').trim(); if (!core) return false;
    const loc = this.page.getByText(new RegExp(`^\\s*\\*?\\s*${escapeRe(core)}(\\s*\\([^)]*\\))?\\s*\\*?\\s*$`, 'i'));
    const deadline = Date.now() + waitMs;
    do { if (await this.visibleFirst(loc)) return true; await this.page.waitForTimeout(250); } while (Date.now() < deadline);
    return false;
  }
  /** 후보 라벨 중 하나라도 보이면 그 라벨(없으면 ''). 첫 후보만 기본 대기, 나머지는 짧게 */
  async fieldExistsAny(labels: string[]) {
    const list = [...new Set(labels.map(s => String(s || '').trim()).filter(Boolean))];
    for (let i = 0; i < list.length; i++) if (await this.fieldExists(list[i], i === 0 ? 4_000 : 1_000)) return list[i];
    return '';
  }

  /**
   * 조회조건 펼치기 — 공용 SearchArea 는 extraConditions(2행 이후)를 접어 두고 Search 버튼 오른쪽의 화살표(텍스트 없는 버튼)로 펼친다.
   * 2026-10-21 SCP0100: 접힌 조건(Search Mode·Display·Plan Type·Cell Qty…)을 라벨 검사가 못 찾아 smoke FAIL → 라벨 검사 전에 한 번 펼친다.
   * 화면당 1회(openScreen 이 플래그 초기화). 화살표가 없으면(extraConditions 없음) false.
   */
  async expandSearchArea(force = false) {
    // force(2026-10-23 조회조건 동작 검사): 플래그와 무관하게 '지금 접혀 있으면' 다시 펼친다 — 접힘 판정 = 보이는 조회영역 안 MUI Collapse 가 hidden
    if (force) {
      const collapsed = await this.page.evaluate(() => Array.from(document.querySelectorAll('.MuiCollapse-hidden')).some(e => !!(e as HTMLElement).closest('form, [class*="SearchArea"], [class*="searchArea"]'))).catch(() => false);
      // 2026-10-29(SCP0100): MuiCollapse 가 아니라 자체 토글(_toggleButton_)로 두 번째 줄을 숨기는 조회영역 — 크기 0 인 formItem 이 있으면 접힌 것으로 본다
      const hiddenItems = await this.hiddenFormItems();
      if (!collapsed && !hiddenItems) return true;
      this.searchExpanded = false;
      if (!collapsed && hiddenItems) { if (await this.clickSearchToggle(hiddenItems)) { this.searchExpanded = true; return true; } }
    }
    if (this.searchExpanded) return true;
    const searchBtn = await this.visibleFirst(this.page.getByRole('button', { name: /^(조회|Search)(\(F5\))?$/ }));
    if (!searchBtn) return false;
    const arrow = searchBtn.locator('xpath=following-sibling::button[1]').first();
    if (!(await arrow.isVisible({ timeout: 1_000 }).catch(() => false))) return false;
    if ((await arrow.innerText().catch(() => '')).trim()) return false; // 텍스트가 있으면 펼침 화살표가 아니다
    await arrow.click({ timeout: 5_000 }).catch(() => undefined);
    await this.page.waitForTimeout(600); // Collapse 애니메이션
    this.searchExpanded = true; return true;
  }
  private searchExpanded = false;
  /** 크기 0(숨김) 인 조회조건 칸 수 */
  private async hiddenFormItems(): Promise<number> {
    return this.page.evaluate(() => Array.from(document.querySelectorAll('[class*="_formItem_"]')).filter(e => !e.closest('.wj-flexgrid, [role="dialog"], .MuiDialog-root')).filter(e => { const b = (e as HTMLElement).getBoundingClientRect(); return b.width === 0 || b.height === 0; }).length).catch(() => 0);
  }
  /** 조회영역 토글 버튼(_toggleButton_ · 텍스트 없는 아이콘 버튼)을 눌러 숨은 칸이 줄면 성공, 아니면 되돌린다 */
  private async clickSearchToggle(before: number): Promise<boolean> {
    const btn = this.page.locator('[class*="_toggleButton_"], [class*="toggleButton"]').filter({ hasNot: this.page.locator('.wj-flexgrid') }).first();
    if (!(await btn.isVisible({ timeout: 1_000 }).catch(() => false))) return false;
    await btn.click({ timeout: 3_000 }).catch(() => undefined); await this.page.waitForTimeout(600);
    const after = await this.hiddenFormItems();
    if (after < before) return true;
    await btn.click({ timeout: 3_000 }).catch(() => undefined); await this.page.waitForTimeout(400);
    return false;
  }

  /** Division 선택 — DivisionField(콤보) 가 있으면 옵션 선택 */
  async setDivision(code: string) {
    // 2026-11-16(SSP0020 smoke 3건 20초 시간 초과): '보이는 첫 콤보'가 Division 이 아닐 수 있다(Delegatee·Div·Period 순서 화면에서 날짜 입력칸을 눌렀다).
    //   라벨이 Div·Div.·Division 인 조회영역 칸의 콤보를 먼저 찾고, 없을 때만 종전대로 보이는 첫 콤보를 쓴다.
    //   다중 선택 칸(지우기 버튼이 있고 이미 값이 골라져 있음)은 먼저 비운 뒤 고른다 — 그대로 누르면 골라져 있던 값이 해제된다.
    const item = await this.visibleFirst(this.page.locator('[class*="_formItem_"], [class*="formItem"]').filter({ has: this.page.locator(':scope > :first-child', { hasText: /^\s*\*?\s*(Div\.?|Division)\s*\*?\s*$/i }) }), 6).catch(() => null);
    const inItem = item ? item.locator('[role="combobox"]').first() : null;
    const combo = inItem && (await inItem.count().catch(() => 0)) ? inItem : await this.visibleFirst(this.page.getByRole('combobox'));
    if (!combo) return false;
    const optRx = new RegExp(`^\\s*${escapeRe(code)}(\\s|$|\\b)`);
    const clr = item ? item.locator('button[aria-label="Clear"]').first() : null;
    const multi = !!clr && (await clr.count().catch(() => 0)) > 0 && (await item!.locator('.MuiChip-root, [class*="MuiAutocomplete-tag"]').count().catch(() => 0)) > 0;
    if (multi) { await item!.hover().catch(() => undefined); await clr!.click({ timeout: 3_000, force: true }).catch(() => undefined); await this.page.waitForTimeout(300); }
    await combo.click({ timeout: 5_000 }).catch(() => undefined);
    let opt = this.page.getByRole('option', { name: optRx }).first();
    if (!(await opt.isVisible({ timeout: 3_000 }).catch(() => false)) && item) {
      const ob = item.locator('button[aria-label="Open"]').first();
      if (await ob.count().catch(() => 0)) { await ob.click({ timeout: 3_000, force: true }).catch(() => undefined); opt = this.page.getByRole('option', { name: optRx }).first(); }
    }
    if (await opt.isVisible({ timeout: 3_000 }).catch(() => false)) { await opt.click({ timeout: 5_000 }).catch(() => undefined); if (multi) await this.page.keyboard.press('Escape').catch(() => undefined); return true; }
    await this.page.keyboard.press('Escape'); return false;
  }

  /** 조회 실행 — SearchArea 조회 버튼 → call-proc(SEARCH 류) 응답 대기 */
  /** 사용자 지정 조회조건 적용 — 라벨 트랙 글자로 FormItem 칸을 찾아 콤보면 값(숫자만 비교)이 들어있는 옵션을, 아니면 첫 입력칸에 값을 넣는다. 적용 결과는 userCondsNote 에 남긴다 */
  async applyUserConds(): Promise<string> {
    const notes: string[] = [];
    for (const [label, value] of Object.entries(this.userConds || {})) {
      try {
        await this.expandSearchArea().catch(() => undefined);
        const nrm = (s: string) => String(s || '').toLowerCase().replace(/[^a-z0-9가-힣]/g, '');
        const item = this.page.locator('[class*="_formItem_"], [class*="formItem"]').filter({ has: this.page.locator(':scope > :first-child', { hasText: new RegExp(label.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'), 'i') }) }).first();
        if (!(await item.isVisible({ timeout: 3_000 }).catch(() => false))) { notes.push(`${label}: 칸 없음`); continue; }
        const combo = item.locator('[role="combobox"]').first();
        if (await combo.count()) {
          await combo.click({ timeout: 3_000 }).catch(() => undefined);
          const opts = this.page.locator('.MuiAutocomplete-popper [role="option"], [role="listbox"] [role="option"]');
          await opts.first().waitFor({ state: 'visible', timeout: 4_000 }).catch(() => undefined);
          const texts = await opts.allInnerTexts().catch(() => [] as string[]);
          const digits = value.replace(/\D/g, '');
          let idx = texts.findIndex(t => nrm(t) === nrm(value) || (digits.length >= 6 && t.replace(/\D/g, '').includes(digits)) || nrm(t).includes(nrm(value)));
          if (idx >= 0) { await opts.nth(idx).click({ timeout: 3_000 }).catch(() => undefined); notes.push(`${label}='${texts[idx].trim().slice(0, 30)}'`); }
          else { await this.page.keyboard.press('Escape').catch(() => undefined); notes.push(`${label}: 옵션 '${value}' 없음(후보 ${texts.length})`); }
        } else {
          const inp = item.locator('input:not([type="hidden"]), textarea').first();
          if (await inp.count()) { await inp.fill(value, { timeout: 3_000 }).catch(() => undefined); await inp.press('Tab').catch(() => undefined); notes.push(`${label}='${value}'`); } else notes.push(`${label}: 입력칸 없음`);
        }
      } catch (e) { notes.push(`${label}: 적용 실패 ${String((e as Error).message || e).slice(0, 60)}`); }
    }
    this.userCondsNote = notes.join(' · ');
    if (notes.length) console.log(`[userConds] ${this.userCondsNote}`);
    return this.userCondsNote;
  }
  /** 2026-11-06 T59: 필수 알림이 가리킨 조회조건 칸을 화면 콤보 후보(ALL·빈 값 제외 첫 후보)로 채운다 — 사전 데이터셋 아님(화면 후보만).
   *  반환 '선택 …' = 채움 · 그 밖 = 실패 사유. 다중선택은 첫 후보 1개만 체크한다(index 로 다른 후보 지정 가능) */
  requiredNotes: string[] = [];
  requiredFilled: string[] = [];
  async fillRequired(label: string, index = 0): Promise<string> {
    await this.expandSearchArea().catch(() => undefined);
    const core = label.replace(/^\s*\*+\s*|\s*\*+\s*$/g, '').trim(); if (!core) return '항목명 없음';
    const item = this.page.locator('[class*="_formItem_"], [class*="formItem"]').filter({ has: this.page.locator(':scope > :first-child', { hasText: new RegExp(`^\\s*\\*?\\s*${escapeRe(core)}\\s*\\*?\\s*$`, 'i') }) }).first();
    if (!(await item.isVisible({ timeout: 3_000 }).catch(() => false))) return `칸 없음(${core})`;
    const combo = item.locator('[role="combobox"]').first();
    if (!(await combo.count())) return '콤보 아님(입력값을 만들 근거 없음 — 채우지 않음)';
    await combo.click({ timeout: 3_000 }).catch(() => undefined);
    const opts = this.page.locator('.MuiAutocomplete-popper [role="option"], [role="listbox"] [role="option"]');
    await opts.first().waitFor({ state: 'visible', timeout: 6_000 }).catch(() => undefined);
    const texts = (await opts.allInnerTexts().catch(() => [] as string[])).map(s => s.replace(/\s+/g, ' ').trim());
    const cand = texts.map((t, i) => ({ t, i })).filter(x => x.t && !/^\(?(all|전체|select|선택|select all|전체\s*선택|모두\s*선택)\)?$/i.test(x.t));  // 전체 선택 항목 제외(11-06 실측 'SELECT ALL')
    if (!cand.length) { await this.page.keyboard.press('Escape').catch(() => undefined); return `후보 없음(목록 ${texts.length}개)`; }
    const pick = cand[Math.min(index, cand.length - 1)];
    await opts.nth(pick.i).click({ timeout: 3_000 }).catch(() => undefined);
    await this.page.keyboard.press('Escape').catch(() => undefined); await this.page.waitForTimeout(500);
    if (!this.requiredFilled.includes(core)) this.requiredFilled.push(core);
    return `선택 '${pick.t.slice(0, 40)}'(후보 ${cand.length}개 중 ${Math.min(index, cand.length - 1) + 1}번째)`;
  }
  async search(opts: { timeout?: number } = {}) {
    await this.clearDialogs();
    if (!this.userCondsApplied && Object.keys(this.userConds || {}).length) { this.userCondsApplied = true; await this.applyUserConds(); }
    const before = this.calls.length;
    const btn = await this.visibleFirst(this.page.getByRole('button', { name: /^(조회|Search)(\(F5\))?$/ }));
    const t0 = Date.now();
    // 메인 조회(call-proc) 응답을 기다린다 — 초기기간 조회(dayRange)는 조회 버튼과 무관하므로 제외.
    // 2026-10-20: 감시를 클릭 '전에' 걸어 빠른 응답을 놓치지 않는다(실측: 뒤에 걸면 재조회 121s). 조회 버튼이 없는 계정은 F5 도 무동작 → 10s 만
    const waitSearch = this.page.waitForResponse(r => /call-proc/.test(r.url()) && !/\/dayRange\//i.test(r.url()) && !/\/(SAVE|INS|UPD|DEL)[^/]*\/call-proc/i.test(r.url()), { timeout: btn ? (opts.timeout ?? CFG.searchTimeoutMs) : 10_000 }).catch(() => undefined);
    // 2026-11-10 T207(SSP0023 G1·G8 허위 FAIL 4건): 조회 버튼 1회에 call-proc 이 여러 개 나가는 화면(SSP0023 main 30~37s + calendar 0.2s)에서
    //   waitSearch 는 먼저 끝난 calendar 응답으로 풀려 main 응답 전에 빈(로딩 중) 그리드를 읽었다 — 서버는 22행. 클릭 뒤 시작된 조회 call-proc 이 모두 끝날 때까지 기다린다.
    const pend = new Set<import('@playwright/test').Request>(); const isQ = (u: string) => /call-proc/.test(u) && !/\/dayRange\//i.test(u) && !/\/(SAVE|INS|UPD|DEL)[^/]*\/call-proc/i.test(u);
    const onReq = (r: import('@playwright/test').Request) => { if (isQ(r.url())) pend.add(r); }; const onDone = (r: import('@playwright/test').Request) => { pend.delete(r); };
    this.page.on('request', onReq); this.page.on('requestfinished', onDone); this.page.on('requestfailed', onDone);
    if (btn) await btn.click({ timeout: 10_000 }).catch(() => undefined); else await this.page.keyboard.press('F5');
    // 2026-11-06 T59(SCP0016): 필수 조회조건이 비어 화면이 '… 필수 입력 항목입니다' 알림으로 조회를 막으면 call-proc 이 안 나가
    //   응답 대기(searchTimeoutMs 120s)를 다 쓰고 0행으로 끝났다(테스트당 8~15분 · 7시간). 알림을 감시해 그 칸을 화면 콤보 후보로 채우고 재조회한다.
    let got = false; void waitSearch.then(r => { if (r) got = true; });
    for (let fill = 0; fill < 4; fill++) {
      let req = '';
      for (const t1 = Date.now(); !got && Date.now() - t1 < 12_000;) { const m = await this.alertText().catch(() => ''); if (m && REQUIRED_RX.test(m)) { req = m; break; } await this.page.waitForTimeout(400); }
      if (!req || got) break;
      const label = requiredLabelOf(req);
      await this.clearDialogs();
      const note = label ? await this.fillRequired(label) : '';
      this.requiredNotes.push(`${label || '(항목명 해석 불가)'}: ${note || '채우기 실패'} ← '${req.replace(/\s+/g, ' ').slice(0, 60)}'`);
      console.log(`[required] ${this.requiredNotes[this.requiredNotes.length - 1]}`);
      if (!note.startsWith('선택')) { this.page.off('request', onReq); this.page.off('requestfinished', onDone); this.page.off('requestfailed', onDone); return this.calls.slice(before); }  // 채우지 못함 — 응답 대기 없이 반환(호출부는 0행 처리)
      const ws2 = this.page.waitForResponse(r => /call-proc/.test(r.url()) && !/\/dayRange\//i.test(r.url()) && !/\/(SAVE|INS|UPD|DEL)[^/]*\/call-proc/i.test(r.url()), { timeout: opts.timeout ?? CFG.searchTimeoutMs }).catch(() => undefined);
      void ws2.then(r => { if (r) got = true; });
      if (btn) await btn.click({ timeout: 10_000 }).catch(() => undefined); else await this.page.keyboard.press('F5');
      await Promise.race([ws2, this.page.waitForTimeout(12_500)]);
      if (got) break;
    }
    if (!got) await waitSearch;
    { const lim = opts.timeout ?? CFG.searchTimeoutMs; const t2 = Date.now(); await this.page.waitForTimeout(300); while (pend.size && Date.now() - t2 < lim) await this.page.waitForTimeout(300);
      if (pend.size) console.log(`[search] 조회 요청 ${pend.size}건이 ${Math.round(lim / 1000)}s 안에 끝나지 않음: ${[...pend].map(r => r.url().replace(/^.*\/api\//, '')).join(', ')}`); }
    this.page.off('request', onReq); this.page.off('requestfinished', onDone); this.page.off('requestfailed', onDone);
    await this.page.waitForLoadState('networkidle', { timeout: 8_000 }).catch(() => undefined);
    const mine = this.calls.slice(before); mine.forEach(c => (c.ms = Date.now() - t0));
    await applyGridMutations(this.page);  // 조회 직후 그리드 변이 주입(CL_MUTATE 지정 시만)
    return mine;
  }

  // 2026-10-20: 보이는 그리드만 — Home keep-alive 등 숨은 .wj-flexgrid 가 첫 번째로 잡히면 dblclick 이 테스트 타임아웃까지 대기한다(crud/authcrud 180s 초과 원인)
  grids(): Locator { return this.page.locator('.wj-flexgrid:visible'); }
  /** 2026-11-10 T224: 기본 그리드 지정 — 저장 시험이 AS-IS Save 대상 시트 그리드를 편집하도록(i=0 요청을 이 인덱스로) · null = 보이는 첫 그리드 */
  forceGrid: number | null = null;
  grid(i = 0): Locator { return this.grids().nth(i === 0 && this.forceGrid != null ? this.forceGrid : i); }
  /** 보이는 그리드 중 이 컬럼(binding)을 모두 가진 첫 그리드의 인덱스(-1 = 없음) */
  async indexOfGridWith(cols: string[]): Promise<number> {
    return this.page.evaluate((want: string[]) => { const els = [...document.querySelectorAll('.wj-flexgrid')].filter(e => (e as HTMLElement).offsetParent !== null); for (let k = 0; k < els.length; k++) { const c = (els[k] as unknown as { ['$WJ-CTRL']?: { columns: { getColumn: (b: string) => unknown } } })['$WJ-CTRL']; if (c && want.every(b => !!c.columns.getColumn(b))) return k; } return -1; }, cols).catch(() => -1);
  }
  async gridHeaders(i = 0): Promise<string[]> {
    const g = this.grid(i); await g.waitFor({ state: 'visible', timeout: 20_000 }).catch(() => undefined);
    const cells = await g.locator('.wj-colheaders .wj-cell').allInnerTexts();
    return cells.map(s => s.replace(/\s+/g, ' ').trim()).filter(Boolean);
  }
  /** 2026-11-07 T162: 컬럼 대사용 전체 헤더 — DOM 헤더 셀은 가로 가상화로 보이는 열만 있다(SCP0084 46열 중 16개 → '누락 24' 허위 FAIL 어노테이션).
   *  Wijmo 컨트롤의 보이는 컬럼 header/binding 을 합쳐 돌려준다(그룹 헤더는 DOM 에서, 리프 헤더는 컨트롤에서). 인덱스 기반 호출부는 기존 gridHeaders 를 그대로 쓴다 */
  async gridHeadersAll(i = 0): Promise<string[]> {
    const dom = await this.gridHeaders(i);
    type Col = { visible?: boolean; header?: string; binding?: string };
    const ctl = await this.grid(i).evaluate((el: Element) => {
      const c = (el as unknown as { ['$WJ-CTRL']?: { columns: Col[] } })['$WJ-CTRL']; if (!c) return [] as string[];
      const out: string[] = []; for (const col of c.columns) { if (col.visible === false) continue; const h = String(col.header ?? col.binding ?? '').replace(/\s+/g, ' ').trim(); if (h) out.push(h); } return out;
    }).catch(() => [] as string[]);
    return [...new Set([...dom, ...ctl])];
  }
  /** 헤더 행 구성 — 보이는 헤더 셀을 top 좌표로 묶어 행 수·행 높이·글자를 돌려준다(병합 셀은 자기 top 에 한 번). 2026-10-21 헤더 사양 대조용 */
  async gridHeaderRows(i = 0): Promise<{ height: number; rows: { top: number; h: number; n: number; cells: string[]; texts: string[] }[] }> {
    const g = this.grid(i); await g.waitFor({ state: 'visible', timeout: 20_000 }).catch(() => undefined);
    return g.evaluate(el => {
      const hdr = el.querySelector('.wj-colheaders'); if (!hdr) return { height: 0, rows: [] };
      // 2026-10-21 측정 정정(🩹 수선 2 지적): 행 높이 = 그 top 의 **가장 낮은** 셀(고정 컬럼은 전 행을 세로 병합해 그 top 의 첫 셀이 되면 행 높이가 과대) · 총 높이 = 셀 top 최소~bottom 최대 실측(.wj-colheaders 의 rect 가 0 인 경우 대비)
      const map: Record<string, { top: number; h: number; n: number; cells: string[]; texts: string[] }> = {}; let minTop = Infinity, maxBottom = -Infinity;
      for (const c of Array.from(hdr.querySelectorAll('.wj-cell')) as HTMLElement[]) { const r = c.getBoundingClientRect(); if (r.height <= 0) continue; minTop = Math.min(minTop, r.top); maxBottom = Math.max(maxBottom, r.bottom); const k = String(Math.round(r.top)); (map[k] = map[k] || { top: Math.round(r.top), h: Math.round(r.height), n: 0, cells: [], texts: [] }); map[k].h = Math.min(map[k].h, Math.round(r.height)); const t = (c.innerText || '').replace(/\s+/g, ' ').trim(); map[k].n++; if (map[k].cells.length < 200) map[k].cells.push(t); if (t && !map[k].texts.includes(t)) map[k].texts.push(t); }
      const rows = Object.values(map).sort((a, b) => a.top - b.top).map(r => ({ top: r.top, h: r.h, n: r.n, cells: r.cells, texts: r.texts.slice(0, 40) }));
      const extent = isFinite(minTop) && isFinite(maxBottom) ? Math.round(maxBottom - minTop) : 0;
      return { height: extent || Math.round((hdr as HTMLElement).getBoundingClientRect().height) || rows.reduce((s, r) => s + r.h, 0), rows };
    });
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
    // 2026-10-20: 더블클릭 시간 상한(기본은 테스트 타임아웃까지 대기 — 비편집 셀에서 182s 매달림)
    const cell = await this.gridCell(r, c, i);
    try { await cell.dblclick({ timeout: 5_000 }); await this.dismissDblPopup(() => cell.click({ timeout: 3_000 })); }
    catch { await cell.scrollIntoViewIfNeeded({ timeout: 3_000 }).catch(() => undefined); await cell.click({ timeout: 5_000 }); await this.page.keyboard.press('F2'); } // 재조회 직후 더블클릭이 안정화 대기에 걸리면 클릭 + F2 로 편집기 열기
    await this.page.keyboard.press('Control+A'); if (value === '') await this.page.keyboard.press('Delete'); else await this.page.keyboard.type(value); await this.page.keyboard.press('Enter');  // 2026-11-06 빈 값 = 지우기(빈 칸 왕복 원복)
  }
  /** 화면이 편집 가능으로 표시한 셀(.wj-cell-editable) 목록 — {row, col, text}. 컬럼 정의 isReadOnly 가 전부 false 인 화면(SCP0096)에서는 이것이 유일한 편집 가능 신호 */
  async editableCells(i = 0, maxRows = 40): Promise<Array<{ row: number; col: number; text: string; colIdx?: number }>> {
    const g = this.grid(i);
    return g.evaluate((el: Element, mr: number) => {
      const out: Array<{ row: number; col: number; text: string; colIdx?: number }> = [];
      const rows = Array.from(el.querySelectorAll('.wj-cells .wj-row')).slice(0, mr);
      // 2026-11-06(SCP0084 조치 필요 1·2·3·16번 허위 FAIL): 편집 셀을 클래스 대신 인라인 표준 노랑(#fff8cd = rgb(255,248,205))으로 칠하는 화면(MEMO)은
      //   후보가 0개가 되어 '컬럼 정의 기준 후보' 로 넘어가 편집 불가 칸(LONG_TERM_TYPE)을 저장 시험했다 → 인라인 표준 노랑도 편집 표시로 센다
      const yellowBg = (c: Element) => /^rgb\(255,\s*248,\s*205\)$/i.test(((c as HTMLElement).style && (c as HTMLElement).style.backgroundColor) || '');
      // 2026-11-07 T131(SCP0084 F1 허위 FAIL·DB 잔존): 가로 가상화로 그려진 셀만 DOM 에 있어 DOM 순번(col)≠컬럼 인덱스 — 가로 스크롤 뒤 MEMO 칸을 LEVEL_2_NAME 으로 오인해
      //   '재조회 값 미반영' FAIL + 원복 실패(MEMO 'testX' 사내 DB 잔존). 실제 컬럼 인덱스(colIdx)는 Wijmo hitTest(셀 요소) → 없으면 셀 offsetLeft = column.pos 로 구한다
      type Ctl = { hitTest?: (x: unknown) => { col?: number } | null; columns?: ArrayLike<{ pos?: number }> };
      const ctl = (el as unknown as Record<string, unknown>)['$WJ-CTRL'] as Ctl | undefined;
      const colOf = (c: Element): number | undefined => {
        try { const h = ctl && ctl.hitTest ? ctl.hitTest(c) : null; if (h && typeof h.col === 'number' && h.col >= 0) return h.col; } catch { /* hitTest 미지원 */ }
        try { const L = (c as HTMLElement).offsetLeft; const cols = ctl && ctl.columns; if (cols) for (let k = 0; k < cols.length; k++) if (cols[k] && cols[k].pos === L) return k; } catch { /* 무시 */ }
        return undefined;
      };
      rows.forEach((row, ri) => { const cells = Array.from(row.querySelectorAll('.wj-cell')); cells.forEach((c, ci) => { if (c.classList.contains('wj-cell-editable') || yellowBg(c)) out.push({ row: ri, col: ci, text: (c.textContent || '').trim(), colIdx: colOf(c) }); }); });
      return out;
    }, maxRows).catch(() => []);
  }
  /** 행 식별 키 = 앞 k개 셀 텍스트(재조회 뒤 같은 행 찾기용) */
  async rowKey(r: number, k = 3, i = 0): Promise<string> { const t = await this.grid(i).locator('.wj-cells .wj-row').nth(r).locator('.wj-cell').allInnerTexts().catch(() => [] as string[]); return t.slice(0, k).map(s => s.trim()).join('|'); }
  async findRowByKey(key: string, k = 3, i = 0, max = 200): Promise<number> { const rl = this.grid(i).locator('.wj-cells .wj-row'); const n = Math.min(await rl.count(), max); for (let r = 0; r < n; r++) if ((await this.rowKey(r, k, i)) === key) return r; return -1; }
  /** 셀 편집 가능 여부 — 더블클릭해 Wijmo 편집기(input/textarea/select)가 열리는지 보고 Esc 로 취소(값 변경 없음). 셀이 없으면 null */
  /** Wijmo 컬럼 정의(보이는 순서): binding · readOnly(그리드 isReadOnly 포함). 판독 불가면 null */
  async gridColumnsMeta(i = 0): Promise<Array<{ binding: string; readOnly: boolean; header: string; dataType: number; hasMap: boolean; cellTemplate: boolean }> | null> {
    const g = this.grid(i); await g.waitFor({ state: 'visible', timeout: 20_000 }).catch(() => undefined);
    return g.evaluate((el: Element) => {
      type Col = { binding?: string; visible?: boolean; isReadOnly?: boolean; header?: string; dataType?: number; dataMap?: unknown; cellTemplate?: unknown; editor?: unknown };
      type Ctl = { columns?: ArrayLike<Col>; isReadOnly?: boolean };
      const host = el as unknown as Record<string, unknown>;
      let ctl = host['$WJ-CTRL'] as Ctl | undefined;
      if (!ctl || !ctl.columns) for (const k of Object.getOwnPropertyNames(host)) { const v = host[k] as Ctl | undefined; if (v && typeof v === 'object' && v.columns && typeof (v.columns as ArrayLike<Col>).length === 'number') { ctl = v; break; } }
      if (!ctl || !ctl.columns) return null;
      const out: Array<{ binding: string; readOnly: boolean; header: string; dataType: number; hasMap: boolean; cellTemplate: boolean }> = [];
      // dataType: Wijmo DataType — 0 Object · 1 String · 2 Number · 3 Boolean · 4 Date · 5 Array
      for (let j = 0; j < ctl.columns.length; j++) { const c = ctl.columns[j]; if (c && c.visible !== false) out.push({ binding: String(c.binding || ''), readOnly: !!ctl.isReadOnly || !!c.isReadOnly, header: String(c.header || c.binding || ''), dataType: Number(c.dataType || 0), hasMap: !!c.dataMap || !!c.editor, cellTemplate: !!c.cellTemplate }); }
      return out;
    }).catch(() => null);
  }
  /**
   * 셀 편집 가능 여부 — 컬럼 지정이 없으면 Wijmo 컬럼 정의에서 readOnly 가 아닌 첫 컬럼들(최대 20개)을 차례로 더블클릭해 편집기(input/textarea/select)가 열리는지 본다. Esc 로 취소(값 변경 없음).
   *  2026-10-20: 고정 (0,1) 셀은 키 컬럼이라 항상 '안 열림' 이었다(SCP0096 허용 계정 7건 오탐). 편집 가능 컬럼 정의가 하나도 없으면 false, 판정 불가면 null
   */
  async cellEditable(r = 0, c?: number, i = 0): Promise<boolean | null> {
    const meta = c == null ? await this.gridColumnsMeta(i) : null;
    let cands: number[];
    if (c != null) cands = [c];
    else if (meta) { cands = meta.map((m, idx) => (m.readOnly ? -1 : idx)).filter(x => x >= 0).slice(0, 20); if (!cands.length) return false; }
    else cands = [1, 2, 3, 4, 5];
    let sawCell = false;
    for (const ci of cands) {
      const cell = await this.gridCell(r, ci, i);
      if (!(await cell.isVisible({ timeout: 1_000 }).catch(() => false))) continue;
      sawCell = true;
      try { await cell.dblclick({ timeout: 5_000 }); } catch { try { await cell.dblclick({ timeout: 3_000, force: true }); } catch { continue; } }
      await this.dismissDblPopup(() => cell.click({ timeout: 3_000 }));
      const ed = this.grid(i).locator('input.wj-grid-editor, .wj-cell input, .wj-cell textarea, .wj-cell select, .wj-cell [contenteditable="true"]').first();
      const on = await ed.isVisible({ timeout: 1_500 }).catch(() => false);
      await this.page.keyboard.press('Escape');
      if (on) return true;
    }
    return sawCell ? false : null;
  }

  subButton(name: 'Save' | 'Insert' | 'Delete' | 'Search' | 'Sort' | 'Filter' | 'Excel Upload' | string): Locator {
    return this.page.getByRole('button', { name: new RegExp(`^${escapeRe(name)}(\\(F\\d+\\))?$`, 'i') }).first();
  }
  async subButtonVisible(name: string) { return this.subButton(name).isVisible({ timeout: 3_000 }).catch(() => false); }
  /** 지금 연 화면 ID(openScreen 이 기록) — clickInsert 가 AS-IS 사실을 찾는 데 쓴다 */
  curMenu = '';
  /** 가장 최근 clickInsert 의 행 선택 재시도 내역(없으면 '') — 호출부가 증거에 붙일 수 있다 */
  lastInsertTrail = '';
  /** 2026-11-12 Y01(T259 · C1-01): Insert 버튼 클릭 + 전제 맞추기. 클릭 뒤 대화상자도 신규 행(CRUD_TYPE 'I' 증가)도 없으면
   *  TO-BE 가 원본으로 쓰는 선택 행이 없는 것일 수 있으므로 행을 선택한 뒤 다시 누른다(insertpre.retryInsertWithRow — AS-IS 활성 행 대응).
   *  대화상자가 떴으면 건드리지 않는다(호출부가 문구를 읽는다). 클릭 자체의 오류는 종전 subButton('Insert').click 과 같이 던진다. */
  /** 화면별 시트 이동 사실(Doc/verify/<ID>/sheet_nav.json)의 최상위 값 — 없으면 '' (2026-11-16 SCP0104) */
  private _navFact: Record<string, unknown> | null | undefined;
  navFact(key: string): string {
    if (this._navFact === undefined) { try { const id = (process.env.VERIFY_ID || this.curMenu || '').toUpperCase(); this._navFact = id ? JSON.parse(fs.readFileSync(`${__dirname}/../../../Doc/verify/${id}/sheet_nav.json`, 'utf8').replace(/^\uFEFF/, '')) as Record<string, unknown> : null; } catch { this._navFact = null; } }
    const v = this._navFact ? this._navFact[key] : ''; return typeof v === 'string' ? v : '';
  }
  /** 셀 더블클릭이 선택 팝업도 여는 화면(sheet_nav.json cell_dblclick_popup = 팝업 제목 · SCP0104 'CAPA Line Search' — AS-IS spdAssign_CellDoubleClick 과 같은 동작):
   *  편집하려고 더블클릭한 뒤 그 팝업이 뜨면 Close 로 닫고 셀을 다시 눌러 F2 로 편집기를 연다. 닫았으면 true */
  async dismissDblPopup(refocus?: () => Promise<unknown>): Promise<boolean> {
    const t = this.navFact('cell_dblclick_popup'); if (!t) return false;
    const dlg = this.page.locator('[role="dialog"]:visible').filter({ hasText: t }).last();
    if (!(await dlg.isVisible({ timeout: 800 }).catch(() => false))) return false;
    await dlg.getByRole('button', { name: /^(Close|닫기)$/i }).first().click({ timeout: 3_000 }).catch(() => undefined);
    await this.page.waitForTimeout(400);
    if (await dlg.isVisible({ timeout: 300 }).catch(() => false)) { await this.page.keyboard.press('Escape').catch(() => undefined); await this.page.waitForTimeout(300); }
    if (refocus) await refocus().catch(() => undefined);
    await this.page.keyboard.press('F2').catch(() => undefined); await this.page.waitForTimeout(250);
    return true;
  }
  /** Insert 가 선택 팝업(그리드 + OK 버튼)을 여는 화면(SCP0104 SOP 탭 — AS-IS btnSopNew → InsertSop): 팝업 그리드에서 앞 행 max 개를 체크하고 OK → 신규 행이 생긴다. 처리했으면 팝업 제목 */
  async pickFromInsertPopup(max = 3, altCond = -1): Promise<string> {
    const p = this.page; const dlg = p.locator('[role="dialog"]:visible').last();
    if (!(await dlg.isVisible({ timeout: 500 }).catch(() => false))) return '';
    const grid = dlg.locator('.wj-flexgrid').first(); if (!(await grid.count().catch(() => 0))) return '';
    const ok = dlg.getByRole('button', { name: /^(OK|확인)$/i }).first(); if (!(await ok.isVisible().catch(() => false))) return '';
    // altCond ≥ 0: 팝업 첫 조회조건(콤보)의 altCond 번째 후보로 바꿔 팝업 Search — 기본 조건의 후보가 전부 화면에 이미 있는 키라 신규 행이 안 생길 때(SCP0104 SOP · Div 81_HG 후보 27행 = 화면 27행)
    if (altCond >= 0) {
      const combo = dlg.locator('[role="combobox"]').first();
      if (await combo.isVisible().catch(() => false)) {
        await combo.click({ timeout: 3_000 }).catch(() => undefined); await p.waitForTimeout(400);
        let opts = p.getByRole('option'); if (!(await opts.count().catch(() => 0))) { await dlg.locator('button[aria-label="Open"]').first().click({ timeout: 3_000, force: true }).catch(() => undefined); await p.waitForTimeout(400); opts = p.getByRole('option'); }
        const no = await opts.count().catch(() => 0);
        if (altCond < no) { const txt = ((await opts.nth(altCond).innerText().catch(() => '')) || '').trim(); await opts.nth(altCond).click({ timeout: 3_000 }).catch(() => undefined); await p.waitForTimeout(1_000); await dlg.getByRole('button', { name: /^Search/i }).first().click({ timeout: 3_000 }).catch(() => undefined); await p.waitForTimeout(3_000); console.log(`[Insert 팝업] 팝업 조건 '${txt}' 로 다시 조회`); }
        else { await p.keyboard.press('Escape').catch(() => undefined); await dlg.getByRole('button', { name: /^(Close|닫기)$/i }).first().click({ timeout: 3_000 }).catch(() => undefined); return ''; }
      }
    }
    const ttl = ((await dlg.locator('h1, h2, h3, [class*="title" i]').first().innerText({ timeout: 1_000 }).catch(() => '')) || '').replace(/\s+/g, ' ').trim().slice(0, 60) || '(제목 없음)';
    const rowsN = () => grid.evaluate(e => { const c = (e as unknown as Record<string, { rows?: { length: number } }>)['$WJ-CTRL']; return c && c.rows ? c.rows.length : 0; }).catch(() => 0);
    for (let k = 0; k < 24 && !(await rowsN()); k++) { if (k === 0 || k === 10) await dlg.getByRole('button', { name: /^Search/i }).first().click({ timeout: 3_000 }).catch(() => undefined); await p.waitForTimeout(500); }
    if (!(await rowsN())) { console.log(`[Insert 팝업] '${ttl}' 그리드 0행 — 선택 불가`); return ''; }
    let boxes = grid.locator('.wj-cells .wj-row .wj-cell input[type="checkbox"]'); if (!(await boxes.count().catch(() => 0))) boxes = grid.locator('.wj-rowheaders input[type="checkbox"]');
    const nb = Math.min(await boxes.count().catch(() => 0), max); let picked = 0;
    for (let i = 0; i < nb; i++) { await boxes.nth(i).click({ timeout: 3_000, force: true }).then(() => { picked++; }).catch(() => undefined); await p.waitForTimeout(150); }
    if (!picked) { console.log(`[Insert 팝업] '${ttl}' 체크 칸 없음 — 선택 불가`); return ''; }
    // 앞 행이 이미 화면에 있는 키면 화면이 중복으로 건너뛴다(SCP0104 handleSopModelConfirm 8키 중복 제외) — 끝 쪽 3행도 같이 체크한다(그리드 값 지정 · CHK 컬럼)
    await grid.evaluate(e => { const c = (e as unknown as Record<string, { rows: { length: number }; columns: { getColumn: (b: string) => { index: number } | null }; setCellData: (r: number, c: number, v: unknown) => void; invalidate: () => void }>)['$WJ-CTRL']; const col = c && c.columns.getColumn('CHK'); if (!c || !col) return; for (let r = c.rows.length - 1; r >= Math.max(3, c.rows.length - 3); r--) c.setCellData(r, col.index, true); c.invalidate(); }).catch(() => undefined);
    await ok.click({ timeout: 5_000 }).catch(() => undefined); await p.waitForTimeout(1_200);
    if (await dlg.isVisible({ timeout: 300 }).catch(() => false)) { await dlg.getByRole('button', { name: /^(Close|닫기)$/i }).first().click({ timeout: 3_000 }).catch(() => undefined); await p.waitForTimeout(500); }
    console.log(`[Insert 팝업] '${ttl}' ${picked}행 선택 후 OK`);
    return ttl;
  }
  async clickInsert(opts: Parameters<Locator['click']>[0] = {}): Promise<void> {
    this.lastInsertTrail = '';
    const cnt = () => this.page.evaluate(() => { let n = 0; for (const e of Array.from(document.querySelectorAll('.wj-flexgrid'))) { if ((e as HTMLElement).offsetParent === null) continue; const c = (e as unknown as Record<string, { rows?: { length: number; [i: number]: { dataItem?: { CRUD_TYPE?: string } } } }>)['$WJ-CTRL']; if (!c || !c.rows) continue; for (let r = 0; r < c.rows.length; r++) { const d = c.rows[r].dataItem; if (d && d.CRUD_TYPE === 'I') n++; } } return n; }).catch(() => -1);
    const n0 = await cnt();
    await this.subButton('Insert').click({ timeout: 10_000, ...(opts || {}) });
    if (n0 < 0 || !this.curMenu) return;
    await this.page.waitForTimeout(700);
    const dlg = await this.page.locator('[role="dialog"], [role="alertdialog"]').first().isVisible({ timeout: 300 }).catch(() => false);
    if (dlg) {
      // 선택 팝업: 앞 행을 골라 OK. 신규 행이 안 생기면(전부 중복 키) Insert 를 다시 눌러 팝업 조건의 다른 후보로 최대 3번 더 시도
      let t = await this.pickFromInsertPopup().catch(() => '');
      for (let k = 0; t && k < 3; k++) { const n1 = await cnt(); if (n1 < 0 || n1 > n0) break; await this.subButton('Insert').click({ timeout: 10_000 }).catch(() => undefined); await this.page.waitForTimeout(1_200); t = await this.pickFromInsertPopup(3, k).catch(() => ''); }
      return;
    }
    const n1 = await cnt(); if (n1 < 0 || n1 > n0) return;
    const rt = await retryInsertWithRow(this as never, this.curMenu).catch(e => ({ made: false, sheet: '', trail: [`재시도 실패: ${String(e).slice(0, 80)}`] }));
    this.lastInsertTrail = rt.trail.join(' / ').slice(0, 500);
    console.log(`[Insert 전제] ${this.curMenu} 신규 행 없음 → 행 선택 후 재시도 — ${this.lastInsertTrail}`);
  }
  /**
   * 보이는 버튼의 이름 목록. 2026-10-21(SCP0100 auth): SubTitle 의 Excel 다운로드는 아이콘 전용(텍스트 없음)이고 이름은 MUI Tooltip 이
   *   감싼 상위 div 의 aria-label('Excel') 에만 있다 → innerText → aria-label → title → 가장 가까운 상위 [aria-label]/[title] 순으로 이름을 잡는다.
   *   (Column Setting/Measure 는 title, Sort/Filter 는 텍스트+상위 aria-label)
   */
  async visibleButtons(): Promise<string[]> {
    const names: string[] = await this.page.evaluate(() => [...document.querySelectorAll('button')].filter(b => (b as HTMLElement).offsetParent !== null).map(b => {
      const t = ((b as HTMLElement).innerText || '').replace(/\s+/g, ' ').trim(); if (t) return t;
      const own = b.getAttribute('aria-label') || b.getAttribute('title'); if (own) return own.trim();
      const anc = b.parentElement ? b.parentElement.closest('[aria-label],[title]') : null;
      return anc ? (anc.getAttribute('aria-label') || anc.getAttribute('title') || '').trim() : '';
    }));
    return [...new Set(names.filter(Boolean))];
  }

  /** 저장 — Save(F7) 클릭 → SAVE call-proc 응답/알림 확인. 확인 다이얼로그는 OK */
  async save(opts: { timeout?: number; quickBlock?: boolean } = {}) {
    const before = this.calls.length;
    // 2026-10-20: 응답 감시를 클릭 '전에' 건다 — 뒤에 걸면 빠른 응답을 놓쳐 60s 를 그대로 소모했다(실측: 저장 61s). SAVE 류 call-proc 만 기다린다
    const waitSave = this.page.waitForResponse(r => /call-proc/.test(r.url()) && /\/(SAVE|INS|UPD|DEL)[^/]*\/call-proc/i.test(r.url()), { timeout: opts.timeout ?? 60_000 }).catch(() => undefined);
    // 클릭 전에 떠 있던 토스트는 이번 저장의 결과가 아니다(2026-10-31 SCP0028 지난 성공 토스트를 검증 차단 사유로 오기록)
    const staleToast = new Set((await this.page.locator('.MuiSnackbar-root, [role="alert"], .Toastify__toast').allInnerTexts().catch(() => [] as string[])).map(t => t.replace(/\s+/g, ' ').trim()));
    // 2026-11-07 T151(SCP0037 F6 '0 값 저장'): 셀 편집 확정 때 화면 사전검증 알림('0보다 큰 정수를 입력하십시오.')이 이미 떠 있으면 Save 클릭이 모달에 막혀 10초 타임아웃 →
    //   테스트 전체 중단(2행 ERROR·나머지 컬럼 미측정). 클릭 전 알림 = 이번 입력에 대한 화면 거부 → 취소 버튼 없는 알림이면 닫고 '저장 요청 없음 + 메시지' 로 돌려준다
    //   (호출부 classifyNoCall → VALIDATION 경로). 취소 버튼이 있는 확인창은 취소로 닫고 저장을 계속한다(이전엔 두 경우 모두 예외로 죽었다)
    const preEdit = await this.alertText().catch(() => '');
    const dlg0 = this.page.locator('[role="dialog"]:visible, [role="alertdialog"]:visible, .MuiDialog-root:visible').last();
    // 알림만(짧은 문구 · 그리드 없는 대화상자) — 팝업 화면(그리드 포함)은 알림이 아니므로 종전대로 Save 클릭
    const isAlert = !!preEdit && preEdit.length < 400 && (await dlg0.locator('.wj-flexgrid').count().catch(() => 1)) === 0;
    if (isAlert) {
      const hasCancel = await dlg0.getByRole('button', { name: /^(취소|Cancel|No|아니오)$/i }).first().isVisible().catch(() => false);
      if (!hasCancel) {
        await this.closeAlert('ok'); await this.page.waitForTimeout(300);
        const clean0 = (t: string) => t.replace(/(^|[ ]|[\r\n])+(Confirm|확인|OK|Cancel|취소)([ ]|[\r\n])*$/g, '').trim();
        return { calls: [] as ProcCall[], message: clean0(preEdit) };
      }
      await this.closeAlert('cancel'); await this.page.waitForTimeout(300);
    }
    // 2026-11-13 점검(SCP0104·SSP0014·SSP0025 '저장 세부'·'저장 경로'·'신규행 검증' — "locator.click: Timeout 10000ms … waiting for Save" · 화면샷 = Insert 가 연 선택 팝업 'CAPA Line Search' 가 떠 있음):
    //   그리드가 있는 팝업이 화면을 덮고 있으면 Save 버튼은 접근성 트리에서 빠져 10초를 다 쓰고 원인 없는 시간 초과로 끝났다. 이유를 문구로 남기고 바로 끝낸다(판정은 종전과 같은 미검증 — 사유만 분명해진다).
    if (!isAlert && (await dlg0.isVisible().catch(() => false)) && !(await this.subButton('Save').isVisible({ timeout: 1_000 }).catch(() => false))) {
      const ttl = ((await dlg0.locator('h1, h2, h3, [class*="title" i]').first().innerText({ timeout: 1_000 }).catch(() => '')) || '').replace(/\s+/g, ' ').trim().slice(0, 60);
      throw new Error(`[측정 경로 없음] Save 를 누를 수 없음 — 팝업 '${ttl || '(제목 없음)'}' 이 열려 있어 화면 Save 버튼이 가려짐(Insert·셀 조작이 선택 팝업을 여는 화면 · 검사기가 팝업을 처리하지 못함)`);
    }
    await this.subButton('Save').click({ timeout: 10_000 });
    // 2026-11-10 T223(SSP0060 '저장 세부' 실패 20:4x · 화면 실측: Save 뒤 'Request' 팝업 — Change Reason* 콤보·Reason Detail* 텍스트·OK 필수):
    //   저장 입력 팝업을 처리하지 못해 다음 Save 가 팝업에 막혀 10초 타임아웃 → '원복 저장 후 복원되지 않음' 허위 FAIL. 필수(*) 칸을 채우고 OK — 생긴 요청 행은 restore_touched 가 지운다
    { const note = await this.fillSaveInputPopup().catch(() => ''); if (note) { this.requiredNotes.push(note); console.log(`[save] ${note}`); } }
    // 저장 전 토스트·알림(업무 검증·변경 없음)은 닫기 전에 읽는다 — closeAlert 뒤에는 내용이 없다
    await this.page.waitForTimeout(500); let toast = ''; for (const t of await this.page.locator('.MuiSnackbar-root, [role="alert"], .Toastify__toast').allInnerTexts().catch(() => [] as string[])) { const v = t.replace(/\s+/g, ' ').trim(); if (v && !staleToast.has(v)) { toast = v; break; } }
    const preAlert = await this.alertText().catch(() => '');
    const preCancel = !!preAlert && await this.page.locator('[role="dialog"]:visible, [role="alertdialog"]:visible, .MuiDialog-root:visible').last().getByRole('button', { name: /^(취소|Cancel|No|아니오)$/i }).first().isVisible().catch(() => false);
    await this.closeAlert('ok');
    // quickBlock: 취소 버튼 없는 알림 = 저장 전 차단 — 응답을 기다리지 않는다(저장 구간을 가짜 응답으로 끊는 시험 전용)
    if (!(opts.quickBlock && preAlert && !preCancel)) await waitSave;
    await this.page.waitForLoadState('networkidle', { timeout: 8_000 }).catch(() => undefined);
    // 결과 알림(성공/ORA 오류)은 닫힐 때까지 최대 3회 — 남아 있으면 다음 클릭(조회·셀 편집)이 전부 막힌다(2026-10-20 실측)
    let msg = ''; for (let k = 0; k < 3; k++) { const m = await this.alertText(); if (!m) break; msg = msg || m; await this.closeAlert('ok'); await this.page.waitForTimeout(300); }
    // 결과 커서의 ERR_CODE(call-proc 성공 판정 = 결과 커서 CODE) 도 메시지에 반영
    const calls = this.calls.slice(before); for (const c of calls) { const m2 = /"ERR_CODE":\s*(-?\d+)[^}]*"ERR_MESSAGE":\s*"([^"]{0,200})/.exec(c.res || ''); if (m2 && m2[1] !== '0' && !msg) msg = m2[2]; }
    const clean = (t: string) => t.replace(/(^|[ ]|[\r\n])+(Confirm|확인|OK|Cancel|취소)([ ]|[\r\n])*$/g, '').trim(); return { calls, message: clean(msg || (calls.length ? toast : (preAlert || toast))) };
  }
  /**
   * 다국어 미적용 노출 — 2026-10-23 사용자 지시: t(코드, '_기본문구') 의 코드가 SCM_ADM_MSG_M 에 없으면 '_기본문구' 가 그대로 보인다 → 오류.
   *  보이는 글자 노드(라벨·버튼·그리드 헤더·알림) + aria-label/title/placeholder 중 '_' 로 시작하는 단어 덩어리를 모은다(입력값·그리드 데이터 셀 제외).
   */
  async untranslatedTexts(): Promise<string[]> {
    return this.page.evaluate(() => {
      const out = new Set<string>();
      const vis = (e: Element | null) => { if (!e) return false; const r = (e as HTMLElement).getBoundingClientRect(); return r.width > 0 && r.height > 0 && (e as HTMLElement).offsetParent !== null; };
      const skip = (e: Element | null) => !e || !!e.closest('.wj-cells, input, textarea, [contenteditable="true"], script, style');
      const walker = document.createTreeWalker(document.body, NodeFilter.SHOW_TEXT);
      for (let n = walker.nextNode(); n; n = walker.nextNode()) { const p = n.parentElement; const t = (n.textContent || '').trim(); if (!t || skip(p) || !vis(p)) continue; if (/^_[A-Za-z가-힣0-9]/.test(t)) out.add(t.slice(0, 60)); }
      for (const e of Array.from(document.querySelectorAll('[aria-label], [title], [placeholder]'))) { if (!vis(e) || e.closest('.wj-cells')) continue; for (const a of ['aria-label', 'title', 'placeholder']) { const v = (e.getAttribute(a) || '').trim(); if (/^_[A-Za-z가-힣0-9]/.test(v)) out.add(`${a}=${v.slice(0, 60)}`); } }
      return [...out];
    }).catch(() => [] as string[]);
  }
  /** 열린 대화상자가 있으면 전부 닫는다(최대 3개) — 조회/편집 전에 호출 */
  /** T223: Save 뒤 뜨는 저장 입력 팝업(필수 '*' 칸 + OK) — 콤보는 첫 실값 후보, 텍스트는 'E2E 시험' 으로 채우고 OK. 처리했으면 근거 문구, 아니면 '' */
  async fillSaveInputPopup(): Promise<string> {
    await this.page.waitForTimeout(600);
    const dlg = this.page.locator('[role="dialog"]:visible, .MuiDialog-root:visible').last();
    if (!(await dlg.isVisible().catch(() => false))) return '';
    const ok = dlg.getByRole('button', { name: /^(OK|확인|Confirm)$/i }).first();
    if (!(await ok.isVisible().catch(() => false))) return '';
    const labs = dlg.locator('label, span, div, p').filter({ hasText: /^[^*]{1,40}\*\s*$/ });
    const n = Math.min(await labs.count().catch(() => 0), 12); if (!n) return '';
    const title = ((await dlg.locator('h1, h2, h3, h4, [class*="title" i], [class*="Title"]').first().innerText({ timeout: 500 }).catch(() => '')) || '').replace(/\s+/g, ' ').trim().slice(0, 30);
    const done: string[] = []; const seen = new Set<string>();
    for (let i = 0; i < n; i++) {
      const lab = labs.nth(i); const name = ((await lab.innerText({ timeout: 500 }).catch(() => '')) || '').replace(/\s+/g, ' ').trim(); if (!name || seen.has(name)) continue; seen.add(name);
      const ctl = lab.locator('xpath=following::*[@role="combobox" or (self::input and not(@type="hidden") and not(@type="checkbox") and not(@readonly)) or self::textarea][1]');
      if (!(await ctl.isVisible().catch(() => false))) continue;
      const role = await ctl.getAttribute('role').catch(() => null);
      if (role === 'combobox') {
        await ctl.click({ timeout: 3_000 }).catch(() => undefined);
        const opt = this.page.locator('[role="listbox"] [role="option"], .MuiAutocomplete-popper [role="option"], .MuiMenu-list [role="option"], ul[role="listbox"] li');
        await opt.first().waitFor({ state: 'visible', timeout: 3_000 }).catch(() => undefined);
        const texts = (await opt.allInnerTexts().catch(() => [] as string[])).map(s => s.trim()); const k = texts.findIndex(s => s && !/^(all|select|선택|전체|-)$/i.test(s));
        if (k >= 0) { await opt.nth(k).click({ timeout: 3_000 }).catch(() => undefined); done.push(`${name} '${texts[k].slice(0, 20)}'`); } else await this.page.keyboard.press('Escape').catch(() => undefined);
      } else {
        const cur = await ctl.inputValue().catch(() => ''); if (!cur) { await ctl.fill('E2E 시험').catch(() => undefined); done.push(`${name} 'E2E 시험'`); }
      }
      await this.page.waitForTimeout(250);
    }
    if (!done.length) return '';
    // 2026-11-10 T223 보강(21:3x 실측: 필수 칸 채움 뒤 OK → 팝업 그대로 · FE ShipmentRequestModal.handleSave = 변경 행마다 CHANGE_REASON_CODE·DETAIL 필수 → '…Please enter Change_Reason.' 알림):
    //   상단 칸은 'Auto Set' 으로 변경 행에 일괄 적용된다(AS-IS 와 같은 흐름) — Auto Set 버튼이 있으면 OK 전에 누른다 · OK 뒤 알림은 읽고 닫는다 · 그래도 남으면 Close 로 닫아 다음 동작을 막지 않는다
    const auto = dlg.getByRole('button', { name: /^(Auto\s*Set|자동\s*설정)$/i }).first();
    let autoNote = ''; if (await auto.isVisible().catch(() => false)) { await auto.click({ timeout: 3_000 }).catch(() => undefined); await this.page.waitForTimeout(400); autoNote = ' → Auto Set'; }
    await ok.click({ timeout: 5_000 }).catch(() => undefined); await this.page.waitForTimeout(800);
    let alertNote = ''; for (let k = 0; k < 3; k++) { const a = (await this.alertText().catch(() => '')) || ''; if (!a || a.length > 400) break; alertNote = alertNote || a.replace(/\s+/g, ' ').slice(0, 120); await this.closeAlert('ok'); await this.page.waitForTimeout(400); }
    let stuck = ''; if (await dlg.isVisible().catch(() => false) && await ok.isVisible().catch(() => false)) { const cl = dlg.getByRole('button', { name: /^(Close|닫기|Cancel|취소)$/i }).first(); await cl.click({ timeout: 3_000 }).catch(() => undefined); await this.page.waitForTimeout(400); stuck = ' · 팝업이 닫히지 않아 Close(저장 미완 — 측정 경로 실패)'; }
    return `저장 입력 팝업 '${title || '(제목 없음)'}' 필수 ${done.length}칸 채움(${done.join(' · ')})${autoNote} → OK${alertNote ? ` · 알림 '${alertNote}'` : ''}${stuck}(T223)`;
  }

  async clearDialogs() { for (let k = 0; k < 3; k++) { if (!(await this.closeAlert('ok'))) break; await this.page.waitForTimeout(200); } }

  snapshot(name: string) { return this.page.screenshot({ path: path.join(process.env.E2E_RESULTS || CFG.resultsDir, 'shots', `${name}.png`), fullPage: false }).catch(() => undefined); }
}

/**
 * BE 로그 DB 오류 — 2026-10-26 사용자 지시 "시노님이 없어서 오류가 발생하는 것도 오류로 검출".
 *  사내 BE 계정 SCMP_APP 에 시노님·권한이 없으면 BE 는 HTTP 500 'Sql Error' 만 돌려주고 원인(ORA-00942 "SCMP_APP"."X")은 nscm.log 에만 남는다.
 *  beLogMark() 로 시작 위치를 잡고 beLogErrors() 로 그 뒤에 추가된 ORA-/PLS- 를 모은다(자정 로테이션으로 파일이 줄면 처음부터).
 *  분류 SYN = 시노님·권한·객체 해석(ORA-00942·ORA-04043·PLS-00201·ORA-01031·ORA-00980·ORA-04063·ORA-06508) / DB = 그 밖의 ORA·PLS.
 */
export const BE_LOG: string = process.env.E2E_BE_LOG || CFG.beLogFile || path.join(__dirname, '..', '..', '..', 'nscm-be', 'logs', 'nscm.log');
export type DbErr = { code: string; cls: 'SYN' | 'OBJ' | 'META' | 'DB'; object: string; msg: string };  // 2026-10-29 CR-076: OBJ = DB 객체 없음·컴파일·인자 불일치, META = PROC_M/API_M 누락
export function beLogMark(): { size: number } { try { return { size: fs.statSync(BE_LOG).size }; } catch { return { size: -1 }; } }
export function beLogErrors(mark: { size: number }): DbErr[] {
  try {
    if (mark.size < 0) return [];
    const st = fs.statSync(BE_LOG); const from = st.size >= mark.size ? mark.size : 0; const len = Math.min(st.size - from, 64 * 1024 * 1024);
    if (len <= 0) return [];
    const fd = fs.openSync(BE_LOG, 'r'); const buf = Buffer.alloc(len); fs.readSync(fd, buf, 0, len, from); fs.closeSync(fd);
    const out = new Map<string, DbErr>();
    const txt = buf.toString('utf8');
    for (const m of txt.matchAll(/(NullPointerException[^\r\n]{0,160}(?:makeProcedure|callProc|procParam|PROC_M)|프로시저 정보 없음[^\r\n]{0,120}|PROC_M[^\r\n]{0,40}(?:없음|not found|empty)[^\r\n]{0,80}|API_M[^\r\n]{0,40}(?:없음|not found)[^\r\n]{0,80})/g)) {
      const k = `META|${m[1].slice(0, 80)}`; if (!out.has(k)) out.set(k, { code: 'META', cls: 'META', object: (/(PROC_M|API_M)/.exec(m[1]) || ['메타'])[0], msg: m[1].slice(0, 200) });
    }
    for (const m of txt.matchAll(/\b((?:ORA|PLS)-\d{5}):?([^\r\n]{0,240})/g)) {
      const code = m[1]; const msg = m[2].trim(); const obj = (/"([A-Z0-9_$#]+)"\."([A-Z0-9_$#]+)"/.exec(msg) || [])[0] || '';
      const cls: DbErr['cls'] = /ORA-00942|ORA-04043|ORA-01031|ORA-00980|ORA-04063|ORA-06508/.test(code) ? 'SYN' : /PLS-00201|PLS-00306|PLS-00302|ORA-00904|ORA-04068|ORA-04061|ORA-06575/.test(code) ? 'OBJ' : 'DB';
      if (/ORA-06512|ORA-06550/.test(code)) continue; // 스택 위치·PL/SQL 래퍼 줄 — 원인 코드가 따로 있다
      const k = `${code}|${obj}|${msg.slice(0, 60)}`; if (!out.has(k)) out.set(k, { code, cls, object: obj, msg: msg.slice(0, 200) });
    }
    return [...out.values()];
  } catch { return []; }
}

export function escapeRe(s: string) { return s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'); }
/** 2026-11-06 T59: 조회 차단 필수 알림 — 'Ver. 값은 필수 입력 항목입니다.' · 'X 을(를) 선택하세요' · 'Please select X' · 'X is required' */
export const REQUIRED_RX = /필수\s*(입력|선택)?\s*항목|값은\s*필수|(을|를)\s*(선택|입력)\s*(하세요|해\s*주세요|하십시오)|please\s+(select|enter|input)\b|\b(is|are)\s+(required|mandatory)\b/i;
/** 알림 문구에서 항목명 추출(못 찾으면 '') — 순수 함수 · nscm.required.selftest.js */
export function requiredLabelOf(msg: string): string {
  const line = String(msg || '').split(/\r?\n/).map(s => s.trim()).find(s => REQUIRED_RX.test(s)) || '';
  const pats = [/^(.+?)\s*값은\s*필수/, /^\[?(.+?)\]?\s*(?:은|는|이|가)?\s*필수\s*(?:입력|선택)?\s*항목/, /^\[?(.+?)\]?\s*(?:을|를)\s*(?:선택|입력)/, /please\s+(?:select|enter|input)\s+(?:the\s+|a\s+)?(.+?)[.!]?$/i, /^(.+?)\s+(?:is|are)\s+(?:required|mandatory)/i];
  for (const re of pats) { const m = re.exec(line); if (m && m[1]) return m[1].replace(/^['"“‘「\[(]+|['"”’」\])]+$/g, '').trim(); }
  return '';
}
export const soft = expect.soft;
