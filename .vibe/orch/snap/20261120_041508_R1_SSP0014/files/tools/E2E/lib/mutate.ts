// CheckList 자기검증(변이 시험) — 2026-10-28 사용자 요청: "다른 화면도 CheckList 를 돌릴 때마다 누락 여부를 확인할 수 없다 →
//   검사기가 오류를 실제로 잡는지 기계적으로 증명". 화면 소스는 건드리지 않고, 실행 중 브라우저 안에서만 오류 상태를 흉내 낸다.
//   CL_MUTATE=A5,H5,D1,H3,G1  (쉼표)  — 지정한 종류만 주입. 비어 있으면 아무것도 안 함(평소 실행 무영향)
//   주입 기록 = window.__clMutLog(그리드) + REQ_LOG(요청) → CL_MUTLOG 파일(JSON 배열)에 누적 → tools/Harness/verify/checklist_selftest.py 가 대조
//
//   종류          주입                                                   기대(이 요소의 해당 규칙 행이 FAIL)
//   A5  표시 컬럼 1개 숨김(col.visible=false)                             A5 COLUMN/TRACE 행(그 binding) FAIL
//   H5  표시 컬럼 1개 헤더 문구 변경                                       H5 행(그 binding) FAIL
//   D1  기존행 편집 가능 컬럼 1개 잠금(col.isReadOnly=true)                 D1 기존행(그 binding) FAIL
//   H3  그리드 셀 병합 끔(allowMerging=None)                               H3 행(병합 컬럼) FAIL
//   G1  조회 요청의 조회조건 값을 전부 'ALL' 로 바꿔 보냄(필터 미적용 흉내)   G1 행(멀티선택 1개 선택 조회) FAIL
//   G5  셀 더블클릭 팝업 조회 요청의 인자를 비움(행 값 전달 누락 흉내)         G5 행 FAIL
//   C2  콤보 후보를 원천 값과 무관하게 고정(연쇄 후보 미적용 흉내)              C2 행 FAIL
import * as fs from 'fs';
import type { Page } from '@playwright/test';

export const MUT = (process.env.CL_MUTATE || '').split(',').map(s => s.trim().toUpperCase()).filter(Boolean);
const LOG = process.env.CL_MUTLOG || '';
const REQ_LOG: { kind: string; target: string; detail: string }[] = [];

const GRID_SRC = (kinds: string[]) => `(() => {
  const el = [...document.querySelectorAll('.wj-flexgrid')].find(e => e.offsetParent !== null); if (!el) return [];
  let c = el['$WJ-CTRL']; if (!c || !c.columns) for (const k of Object.getOwnPropertyNames(el)) { const v = el[k]; if (v && typeof v === 'object' && v.columns && typeof v.columns.length === 'number') { c = v; break; } }
  if (!c) return [];
  const st = window.__clMutTarget = window.__clMutTarget || {}; const log = window.__clMutLog = window.__clMutLog || [];
  const kinds = ${JSON.stringify(kinds)}; const out = [];
  const skip = b => !b || /^(CRUD_TYPE|_|ROW_?NUM|NO$|CHK)/i.test(b);
  const vis = []; for (let i = 0; i < c.columns.length; i++) { const x = c.columns[i]; if (x.visible !== false && !skip(x.binding)) vis.push(x); }
  const pick = (k, cond) => { if (st[k]) return c.columns.getColumn(st[k]); const x = vis.find(cond); if (x) st[k] = x.binding; return x; };
  for (const k of kinds) { try {
    if (k === 'A5') { const x = pick('A5', (x, i) => vis.indexOf(x) >= 2 && x.binding !== st.H5 && x.binding !== st.D1); if (x) { x.visible = false; out.push({ kind: 'A5', target: x.binding, detail: '표시 컬럼 숨김' }); } }
    if (k === 'H5') { const x = pick('H5', x => vis.indexOf(x) >= 3 && x.binding !== st.A5 && x.binding !== st.D1); if (x && !String(x.header).startsWith('MUT_')) { x.header = 'MUT_' + x.header; } if (x) out.push({ kind: 'H5', target: x.binding, detail: '헤더 문구 변경' }); }
    if (k === 'D1') {
      // 2026-10-28 1차 자기검증 미검출 원인: ① 원래 잠금인 컬럼(기존행 DIVISION_ID)을 골라 변화 없음 ② col.isReadOnly 는 화면 재렌더(Insert 등)로 초기화
      //   → 기존행에서 실제로 편집되는 컬럼을 고르고, 컬럼 속성 대신 그리드 beginningEdit 이벤트를 막는다(컨트롤은 재렌더에도 유지)
      if (!st.D1 && c.rows.length) {
        let r = -1; for (let i = 0; i < c.rows.length; i++) { const d = c.rows[i].dataItem; if (d && d.CRUD_TYPE !== 'I') { r = i; break; } }
        if (r >= 0) for (const y of vis) { if (y.binding === st.A5 || y.binding === st.H5 || y.isReadOnly || c.isReadOnly) continue; const ok = c.startEditing(true, r, y.index); if (ok) { c.finishEditing(true); st.D1 = y.binding; break; } }
      }
      if (st.D1 && !c.__clMutD1 && c.beginningEdit) {
        c.__clMutD1 = true; const tgt = st.D1;  // 표시는 컨트롤에 — 그리드를 새로 만들면 다시 주입
        c.beginningEdit.addHandler((s, e) => { const col = s.columns[e.col]; if (col && col.binding === tgt) e.cancel = true; });
      }
      if (st.D1) out.push({ kind: 'D1', target: st.D1, detail: '기존행 편집 가능 컬럼의 편집 시작 차단(beginningEdit cancel — 기존행·신규행)' });
    }
    if (k === 'C2') {
      // 콤보 후보를 원천 값과 무관하게 고정(연쇄 후보 미적용 흉내) — 인스턴스와 DataMap 프로토타입 둘 다(화면이 연쇄 때 DataMap 을 새로 만들어도 유지)
      const fix = dm => { if (!dm || dm.__clMutC2) return; const full = (dm.collectionView && dm.collectionView.sourceCollection ? dm.collectionView.sourceCollection : []).map(i => dm.displayMemberPath ? i[dm.displayMemberPath] : i);
        const cut = full.slice(1); dm.getDisplayValues = () => cut.slice(); dm.__clMutC2 = true; };  // 고정 + 첫 후보 1개 누락(분기 후보 집합 불일치 흉내)
      let n = 0; for (let i = 0; i < c.columns.length; i++) { const dm = c.columns[i].dataMap; if (dm) { fix(dm); n++;
        const proto = Object.getPrototypeOf(dm); if (proto && !proto.__clMutC2) { proto.__clMutC2 = true; const o = proto.getDisplayValues; proto.getDisplayValues = function () { const cv = this.collectionView; return cv && cv.sourceCollection ? cv.sourceCollection.map(i => this.displayMemberPath ? i[this.displayMemberPath] : i).slice(1) : o.apply(this, arguments); }; } } }
      // 공용 DataGrid 가 신규행 편집 때 DataMap 을 새로 만들어 끼운다(columnMapping insertComboId/getDataMap) → 컬럼 dataMap 설정 순간을 가로채 새 객체에도 적용
      if (c.columns.length && !window.__clMutC2Col) {
        let pr = Object.getPrototypeOf(c.columns[0]); let d = null;
        while (pr && !(d = Object.getOwnPropertyDescriptor(pr, 'dataMap'))) pr = Object.getPrototypeOf(pr);
        if (d && d.set) { window.__clMutC2Col = true; Object.defineProperty(pr, 'dataMap', { configurable: true, enumerable: d.enumerable, get: d.get, set(v) { try { fix(v); } catch (e) {} d.set.call(this, v); } }); n++; }
      }
      if (n) out.push({ kind: 'C2', target: '*', detail: '콤보 후보 고정+첫 후보 누락(원천 값에 따른 후보 재구성 안 함) — dataMap ' + n + '개' });
    }
    if (k === 'H3') { if (c.allowMerging) { st.H3 = String(c.allowMerging); c.allowMerging = 0; } out.push({ kind: 'H3', target: '*', detail: '셀 병합 끔(원래 allowMerging=' + (st.H3 || '?') + ')' }); }
  } catch (err) { out.push({ kind: k, target: 'ERR', detail: '주입 예외: ' + String(err).slice(0, 120) }); } }
  c.invalidate && c.invalidate();
  for (const o of out) if (!log.some(l => l.kind === o.kind && l.target === o.target)) log.push(o);
  return out;
})()`;

/** 조회가 끝날 때마다 호출 — 그리드 변이 주입(같은 대상 유지). 변이가 없으면 아무것도 안 함 */
export async function applyGridMutations(page: Page) {
  const kinds = MUT.filter(k => ['A5', 'H5', 'D1', 'H3', 'C2'].includes(k));
  if (!kinds.length) return [];
  // 행이 필요한 변이(D1 기존행 편집 컬럼 · C2 후보)는 그리드에 행이 찰 때까지 기다린다 — 조회 응답 직후엔 0행일 수 있다(2026-10-28 D1 미주입 원인)
  if (kinds.some(k => k === 'D1' || k === 'C2')) {
    await page.waitForFunction(`(() => { const el = [...document.querySelectorAll('.wj-flexgrid')].find(e => e.offsetParent !== null); const c = el && el['$WJ-CTRL']; return !!(c && c.rows && c.rows.length > 0); })()`, null, { timeout: 120_000 }).catch(() => undefined);
  }
  return (await page.evaluate(GRID_SRC(kinds)).catch(() => [])) as { kind: string; target: string; detail: string }[];
}

/** 페이지 준비 시 1회 — 요청 변이. G1 = 네트워크 단계(결과만 보는 검사라 충분)
 *  G5 = 브라우저 요청 생성 단계(fetch·XHR): 검사기가 '요청 본문'을 보므로 네트워크 단계에서 고치면 원래 본문이 기록돼 시험이 성립하지 않는다.
 *       셀 더블클릭 뒤 3초 안에 나가는 SEARCH call-proc 의 문자열 인자를 비운다(팝업에 행 값 전달 누락 흉내) */
export async function installRequestMutations(page: Page) {
  if (MUT.includes('G5')) {
    await page.addInitScript(() => {
      const w = window as unknown as { __clDbl: number; __clMutLog: { kind: string; target: string; detail: string }[] };
      w.__clDbl = 0; document.addEventListener('dblclick', () => { w.__clDbl = Date.now(); }, true);
      const strip = (url: string, body: unknown) => {
        if (typeof body !== 'string' || !/\/SEARCH\/call-proc/i.test(url) || Date.now() - w.__clDbl > 3000) return body;
        try { const o = JSON.parse(body) as Record<string, unknown>; const ch: string[] = [];
          for (const k of Object.keys(o)) if (typeof o[k] === 'string' && o[k] && !/^(ses|mnu|sheet|lang|user|division|crud)/i.test(k)) { o[k] = ''; ch.push(k); }
          if (ch.length) { const t = url.replace(/^.*\/([^/]+\/[^/]+\/[^/]+)\/call-proc.*$/, '$1'); w.__clMutLog = w.__clMutLog || []; if (!w.__clMutLog.some(l => l.target === t)) w.__clMutLog.push({ kind: 'G5', target: t, detail: '더블클릭 팝업 조회 인자 비움: ' + ch.join(',') }); }
          return JSON.stringify(o); } catch { return body; } };
      const f0 = window.fetch; window.fetch = (input: RequestInfo | URL, init?: RequestInit) => { const u = String((input as Request).url || input); if (init && init.body) init = { ...init, body: strip(u, init.body) as BodyInit }; return f0(input, init); };
      const o0 = XMLHttpRequest.prototype.open, s0 = XMLHttpRequest.prototype.send;
      XMLHttpRequest.prototype.open = function (this: XMLHttpRequest & { __u?: string }, m: string, u: string | URL, ...r: unknown[]) { this.__u = String(u); return (o0 as (...a: unknown[]) => void).call(this, m, u, ...r); } as typeof o0;
      XMLHttpRequest.prototype.send = function (this: XMLHttpRequest & { __u?: string }, b?: Document | XMLHttpRequestBodyInit | null) { return s0.call(this, strip(this.__u || '', b) as XMLHttpRequestBodyInit); };
    });
  }
  if (!MUT.includes('G1')) return;
  await page.route(/\/call-proc/i, async route => {
    const req = route.request(); const url = req.url();
    if (req.method() !== 'POST' || /\/dayRange\//i.test(url) || !/\/SEARCH\//i.test(url)) return route.continue();
    let body: Record<string, unknown> | null = null; try { body = JSON.parse(req.postData() || ''); } catch { return route.continue(); }
    if (!body || typeof body !== 'object') return route.continue();
    const changed: string[] = [];
    for (const [k, v] of Object.entries(body)) {
      if (typeof v !== 'string' || !v || v === 'ALL' || /^(ses|mnu|sheet|lang|user|division)/i.test(k)) continue;
      if (/,/.test(v) || /^[A-Z0-9_\-]+$/i.test(v)) { (body as Record<string, unknown>)[k] = 'ALL'; changed.push(k); }
    }
    if (changed.length) { const t = url.replace(/^.*\/([^/]+\/[^/]+\/[^/]+)\/call-proc.*$/, '$1'); if (!REQ_LOG.some(l => l.target === t)) REQ_LOG.push({ kind: 'G1', target: t, detail: `조회조건 ${changed.join(',')} → ALL` }); }
    return route.continue({ postData: JSON.stringify(body) });
  });
}

/** 테스트 끝 — 주입 기록을 CL_MUTLOG 에 누적(같은 kind·target 은 1번) */
export async function flushMutationLog(page: Page, testTitle: string) {
  if (!MUT.length || !LOG) return;
  const grid = ((await page.evaluate('window.__clMutLog || []').catch(() => [])) || []) as { kind: string; target: string; detail: string }[];
  let prev: { kind: string; target: string; detail: string; test: string }[] = [];
  try { prev = JSON.parse(fs.readFileSync(LOG, 'utf8')); } catch { /* 첫 기록 */ }
  for (const o of [...grid, ...REQ_LOG]) if (!prev.some(p => p.kind === o.kind && p.target === o.target)) prev.push({ ...o, test: testTitle });
  fs.writeFileSync(LOG, JSON.stringify(prev, null, 1), 'utf8');
}
