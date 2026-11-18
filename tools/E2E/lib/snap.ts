// 스냅샷 형상 검사 헬퍼(2026-11-06 플랜 Phase 3) — Playwright 내장 aria 스냅샷·텍스트 스냅샷·화면샷으로 라벨/순서/헤더/버튼/팝업 '형상' 을 비교한다.
//   골든 = Doc/verify/<ID>/snap/golden/<key>.(aria.yml|txt|png) · 수신 = snap/received/ · 차이 = snap/diff/ · 결과 = snap/results.json
//   첫 골든은 사람이 승인한다(tools/Harness/verify/snap_approve.py — AS-IS 유래 기대(plan.json/search_cond)와 snap_validate.py 로 대조한 뒤). --update-snapshots 는 쓰지 않는다(승인 게이트 우회).
import * as fs from 'node:fs';
import * as path from 'node:path';
import type { Locator, Page } from '@playwright/test';

export type SnapKind = '조회조건' | '버튼' | '헤더' | '팝업' | '화면샷';
export type SnapResult = { key: string; kind: SnapKind; scope: string; status: 'NEW' | 'MATCH' | 'DIFF' | 'ERROR'; golden: string; received: string; diff: string; lines: number; detail: string; at: string };

export const ROOT = path.resolve(__dirname, '..', '..', '..');
export function snapDir(id: string) { return path.join(ROOT, 'Doc', 'verify', id.toUpperCase(), 'snap'); }
export function ensureDirs(id: string) { for (const d of ['golden', 'received', 'diff']) fs.mkdirSync(path.join(snapDir(id), d), { recursive: true }); }
export function safeKey(s: string) { return s.replace(/[^A-Za-z0-9가-힣._-]+/g, '_').replace(/^_+|_+$/g, '').slice(0, 80); }
export function keyOf(kind: SnapKind, scope: string) { return safeKey(`${kind}_${scope}`); }

/** 동적 값 정규화 — 기간·주차·건수·시각은 형상이 아니다 */
export function normDynamic(t: string): string {
  return t
    .replace(/\b20\d{2}(0[1-9]|1[0-2])(0[1-9]|[12]\d|3[01])\b/g, '{YMD}')
    .replace(/\b20\d{2}(0[1-9]|1[0-2])\b/g, '{YM}')
    .replace(/\b20\d{2}-(0[1-9]|1[0-2])(-(0[1-9]|[12]\d|3[01]))?\b/g, '{DATE}')
    .replace(/\bW\s?\d{1,2}\b/g, '{W}')
    .replace(/\b(Total|총)\s*[:：]?\s*[\d,]+(\s*건)?/gi, '{TOTAL}')
    .replace(/\b\d{1,3}(,\d{3})+\b/g, '{N}')
    .replace(/총\s*[:：]?\s*([\d,]+|\{N\})\s*건/g, '{TOTAL}');  // 2026-11-18: '총' 앞 \b 는 한글에 걸리지 않는다(SCP0111 팝업 '총9,616건')
}

/** aria 스냅샷 텍스트(YAML) — 값(value)·건수는 정규화. Playwright ≥1.49 locator.ariaSnapshot() */
export async function ariaOf(loc: Locator): Promise<string> {
  const raw = await loc.ariaSnapshot({ timeout: 10_000 });
  return collapseGridRows(normDynamic(raw).replace(/\r/g, '')).trimEnd() + '\n';
}

/** 2026-11-18 SCP0111 사용자 판정(V-f5114028 팝업 스냅샷 'TO-BE RULE'): 그리드 본문 데이터 행(gridcell 을 가진 row)은 조회 시점·데이터에 따라 바뀌어 형상이 아니다 —
 *  연속한 데이터 행을 한 줄 '- row {데이터 행}' 으로 접는다(머리글 columnheader 행은 그대로) */
export function collapseGridRows(y: string): string {
  const L = y.split('\n'); const out: string[] = []; const ind = (s: string) => s.length - s.trimStart().length;
  for (let i = 0; i < L.length; i++) {
    const m = /^(\s*)- row\b/.exec(L[i]);
    if (m && i + 1 < L.length && /^\s*- gridcell\b/.test(L[i + 1])) {
      const d = ind(L[i]); let j = i + 1; while (j < L.length && (ind(L[j]) > d || !L[j].trim())) j++;
      const ph = `${m[1]}- row {데이터 행}`; if (out[out.length - 1] !== ph) out.push(ph);
      i = j - 1; continue;
    }
    out.push(L[i]);
  }
  return out.join('\n');
}

/** Wijmo 그리드 헤더 텍스트(가상화 무관 · $WJ-CTRL 모델) — 줄 = 헤더 행, 칸 = ' | ' 구분. 동적 토큰 정규화 */
export async function headerTextOf(grid: Locator): Promise<string | null> {
  const t = await grid.evaluate((el: Element) => {
    type Col = { binding?: string; header?: string; visible?: boolean; index?: number };
    type Ctl = { columns?: ArrayLike<Col>; columnHeaders?: { rows: { length: number }; getCellData: (r: number, c: number, fmt: boolean) => unknown } };
    const host = el as unknown as Record<string, unknown>;
    let ctl = host['$WJ-CTRL'] as Ctl | undefined;
    if (!ctl || !ctl.columns) for (const k of Object.getOwnPropertyNames(host)) { const v = host[k] as Ctl | undefined; if (v && typeof v === 'object' && v.columns && typeof (v.columns as ArrayLike<Col>).length === 'number') { ctl = v; break; } }
    if (!ctl || !ctl.columns || !ctl.columnHeaders) return null;
    const rows = ctl.columnHeaders.rows.length; const out: string[] = [];
    for (let r = 0; r < rows; r++) {
      const cells: string[] = [];
      for (let c = 0; c < ctl.columns.length; c++) { const col = ctl.columns[c]; if (!col || col.visible === false) continue; let v = ''; try { v = String(ctl.columnHeaders.getCellData(r, c, true) ?? ''); } catch { v = ''; } cells.push(v.replace(/\s+/g, ' ').trim()); }
      out.push(cells.join(' | '));
    }
    return out.join('\n');
  }).catch(() => null);
  return t == null ? null : normDynamic(t) + '\n';
}

export function readGolden(id: string, key: string, ext: string): string | null {
  const p = path.join(snapDir(id), 'golden', `${key}.${ext}`);
  return fs.existsSync(p) ? fs.readFileSync(p, 'utf8') : null;
}
export function writeReceived(id: string, key: string, ext: string, text: string): string {
  const p = path.join(snapDir(id), 'received', `${key}.${ext}`); fs.writeFileSync(p, text, 'utf8'); return path.relative(ROOT, p);
}
/** 줄 단위 차이(간단 diff: 골든에만/수신에만 · 순서 위치 포함) */
export function lineDiff(golden: string, received: string): { text: string; lines: number } {
  const g = golden.replace(/\r/g, '').split('\n').map(s => s.trimEnd()).filter(s => s.length); const r = received.replace(/\r/g, '').split('\n').map(s => s.trimEnd()).filter(s => s.length);
  const gs = new Map<string, number>(); g.forEach((s, i) => { if (!gs.has(s)) gs.set(s, i); });
  const rs = new Map<string, number>(); r.forEach((s, i) => { if (!rs.has(s)) rs.set(s, i); });
  const out: string[] = [];
  g.forEach((s, i) => { if (!rs.has(s)) out.push(`- [골든 ${i + 1}] ${s}`); });
  r.forEach((s, i) => { if (!gs.has(s)) out.push(`+ [수신 ${i + 1}] ${s}`); });
  // 순서 차이(같은 줄 집합인데 상대 순서가 다름)
  const common = g.filter(s => rs.has(s)); const commonR = r.filter(s => gs.has(s));
  let orderDiff = 0; for (let i = 0; i < Math.min(common.length, commonR.length); i++) if (common[i] !== commonR[i]) { orderDiff++; if (orderDiff <= 5) out.push(`~ [순서 ${i + 1}] 골든 '${common[i].slice(0, 60)}' ↔ 수신 '${commonR[i].slice(0, 60)}'`); }
  return { text: out.join('\n') + (out.length ? '\n' : ''), lines: out.length };
}
export function writeDiff(id: string, key: string, text: string): string {
  const p = path.join(snapDir(id), 'diff', `${key}.txt`); fs.writeFileSync(p, text, 'utf8'); return path.relative(ROOT, p);
}

/** 텍스트 종류 스냅샷 1건 판정(aria·헤더 공통) — 골든 없음 NEW / 같음 MATCH / 다름 DIFF */
export function judgeText(id: string, kind: SnapKind, scope: string, ext: 'aria.yml' | 'txt', received: string, detail = ''): SnapResult {
  const key = keyOf(kind, scope); const at = new Date().toISOString();
  const rp = writeReceived(id, key, ext, received);
  const golden = readGolden(id, key, ext);
  const gp = path.relative(ROOT, path.join(snapDir(id), 'golden', `${key}.${ext}`));
  if (golden == null) return { key, kind, scope, status: 'NEW', golden: '', received: rp, diff: '', lines: received.split('\n').filter(Boolean).length, detail: `골든 없음 — 수신본 ${rp} 를 snap_validate.py 로 AS-IS 기대와 대조한 뒤 snap_approve.py 로 승인 · ${detail}`, at };
  const norm = (s: string) => s.replace(/\r/g, '').split('\n').map(x => x.trimEnd()).filter(Boolean).join('\n');
  if (norm(golden) === norm(received)) return { key, kind, scope, status: 'MATCH', golden: gp, received: rp, diff: '', lines: 0, detail: `골든 ${gp} 와 일치 · ${detail}`, at };
  const d = lineDiff(golden, received); const dp = writeDiff(id, key, d.text);
  return { key, kind, scope, status: 'DIFF', golden: gp, received: rp, diff: dp, lines: d.lines, detail: `골든 ${gp} 와 ${d.lines}줄 다름(${dp}) — 첫 차이: ${d.text.split('\n')[0]?.slice(0, 140) || ''} · ${detail}`, at };
}

export function saveResults(id: string, results: SnapResult[]) {
  const p = path.join(snapDir(id), 'results.json');
  const prev: SnapResult[] = fs.existsSync(p) ? JSON.parse(fs.readFileSync(p, 'utf8')) : [];
  const m = new Map(prev.map(r => [r.key, r])); for (const r of results) m.set(r.key, r);
  fs.writeFileSync(p, JSON.stringify([...m.values()], null, 1), 'utf8');
  // 사람 검토용 요약
  const lines = [`# 스냅샷 검토 ${id} — ${new Date().toISOString().slice(0, 16).replace('T', ' ')}`, '', '| 키 | 종류 | 범위 | 상태 | 골든 | 수신 | 차이 | 설명 |', '|---|---|---|---|---|---|---|---|'];
  for (const r of [...m.values()]) lines.push(`| ${r.key} | ${r.kind} | ${r.scope} | ${r.status} | ${r.golden} | ${r.received} | ${r.diff} | ${r.detail.replace(/\|/g, '／').slice(0, 160)} |`);
  lines.push('', '승인: `python tools/Harness/verify/snap_expect.py <ID>` → `snap_validate.py <ID>`(불일치 0 확인) → `snap_approve.py <ID> [--item 키] --by 이름 --opinion 사유`');
  fs.writeFileSync(path.join(snapDir(id), '_review.md'), lines.join('\n') + '\n', 'utf8');
}

/** 보이는 조회영역에 data-e2e-snap="searcharea" 를 달고 그 속성 locator 를 돌려준다(findCond 와 같은 방식 · 2026-11-06 실측: 클래스 locator 는 keep-alive 숨은 요소와 섞여 ariaSnapshot 10s 타임아웃) */
export async function searchAreaTagged(page: Page): Promise<Locator | null> {
  const ok = await page.evaluate(() => {
    const vis = (e: Element) => { const r = (e as HTMLElement).getBoundingClientRect(); return r.width > 0 && r.height > 0 && (e as HTMLElement).offsetParent !== null; };
    for (const e of Array.from(document.querySelectorAll('[data-e2e-snap="searcharea"]'))) e.removeAttribute('data-e2e-snap');
    const cands = Array.from(document.querySelectorAll('[class*="SearchArea"], [class*="searchArea"]')).filter(e => vis(e) && !e.closest('[role="dialog"], .MuiDialog-root'));
    let best: Element | null = cands.find(e => e.querySelector('[class*="_formItem_"], [class*="formItem"], [role="combobox"], input')) || cands[0] || null;
    if (!best) {
      // 2026-11-06 실측(SCP0127): SearchArea 클래스·form 이 DOM 에 없다 → 보이는 조회조건 칸(_formItem_)들의 최소 공통 조상이 조회영역
      const items = Array.from(document.querySelectorAll('[class*="_formItem_"], [class*="formItem"]')).filter(e => vis(e) && !e.closest('.wj-flexgrid, [role="dialog"], .MuiDialog-root'));
      if (items.length) {
        let anc: Element | null = items[0];
        while (anc && !items.every(it => anc!.contains(it))) anc = anc.parentElement;
        best = anc;
      }
    }
    if (!best) return false;
    best.setAttribute('data-e2e-snap', 'searcharea'); return true;
  }).catch(() => false);
  return ok ? page.locator('[data-e2e-snap="searcharea"]').first() : null;
}

/** SubTitle 버튼 바 컨테이너(미확인 로케이터 — 실측 후 좁힌다): 핫키 버튼의 콤보 없는 조상 → 제목 영역 클래스 → Search 버튼의 조상 */
export async function buttonBar(page: Page): Promise<Locator | null> {
  // 2026-11-06 실측: SubTitle 공통 버튼은 'Save(F7)·Insert(F8)·Delete(F9)·Search(F5)' 핫키 표기 — 그 버튼들을 2개 이상 품은 가장 가까운 조상이 버튼 바
  const hot = page.getByRole('button', { name: /\((F\d+)\)\s*$/ });
  const hn = Math.min(await hot.count().catch(() => 0), 8);
  for (let i = 0; i < hn; i++) {
    const b = hot.nth(i); if (!(await b.isVisible().catch(() => false))) continue;
    // 콤보(조회조건)를 품지 않는 가장 가까운 조상 — Search(F5) 가 조회영역 안에 있으면 그 조상은 없으므로 다음 핫키 버튼(Save(F7) 등)에서 찾는다(2026-11-06 실측: 조회영역까지 포함되던 결함)
    const anc = b.locator('xpath=ancestor::*[count(.//button[contains(normalize-space(.), "(F")]) >= 2 and not(.//*[@role="combobox"])][1]').first();
    if ((await anc.count().catch(() => 0)) > 0) return anc;
  }
  const cand = page.locator('[class*="SubTitle"], [class*="subTitle"], [class*="TitleArea"], [class*="titleArea"]');
  const n = Math.min(await cand.count().catch(() => 0), 6);
  for (let i = 0; i < n; i++) { const l = cand.nth(i); if (await l.isVisible().catch(() => false) && (await l.getByRole('button').count().catch(() => 0)) > 0) return l; }
  const sb = page.getByRole('button', { name: /^(조회|Search)(\(F5\))?$/ });
  const m = Math.min(await sb.count().catch(() => 0), 6);
  for (let i = 0; i < m; i++) { const b = sb.nth(i); if (await b.isVisible().catch(() => false)) return b.locator('xpath=ancestor::div[.//button][2]').first(); }
  return null;
}
