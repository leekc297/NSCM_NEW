// 화면 정합검증(@verify) — Doc/verify/<ID>/verify_ledger.csv 의 E2E 행을 실행해 결과를 Doc/verify/<ID>/e2e_results.json 에 쓴다(2026-10-23).
//   생성기(gen-e2e.js) 산출 스펙이 아니라 원장 구동 범용 스펙이다. 화면 = 환경변수 VERIFY_ID (없으면 전체 skip).
//   저장(Save)은 하지 않는다 — 입력 프로브 값은 화면을 닫으면 버려진다(사내 DB 무변경).
//   판정: 기대값은 원장(AS-IS 근거)에서 읽는다. 기대가 '조건부'·'판정필요'면 실측만 남기고 판정필요로 둔다(추측 PASS 금지).
import { execFileSync } from 'node:child_process';
import * as fs from 'node:fs';
import * as path from 'node:path';

import { test } from '../../../tools/E2E/fixtures/test';
import { dropdownOptions, parseCsv, probe } from '../../../tools/E2E/lib/probe';

const ID = (process.env.VERIFY_ID || '').toUpperCase();
const ROOT = path.resolve(__dirname, '..', '..', '..');
const DIR = path.join(ROOT, 'Doc', 'verify', ID);
const LEDGER = path.join(DIR, 'verify_ledger.csv');
const OUT = path.join(DIR, 'e2e_results.json');

type Res = { row_id: string; result: 'PASS' | 'FAIL' | '판정필요' | 'ERROR' | 'NA'; evidence: string; tobe_ref?: string };
const results: Res[] = [];
const rows = ID && fs.existsSync(LEDGER) ? parseCsv(fs.readFileSync(LEDGER, 'utf8')) : [];
const flush = () => {
  const prev: Res[] = fs.existsSync(OUT) ? JSON.parse(fs.readFileSync(OUT, 'utf8')) : [];
  // 정밀 검증 엔진(_trace.spec @trace)이 이미 판정한 행은 범용 @verify 가 덮지 않는다 — Playwright 가 파일을 알파벳 순(_trace → _verify)으로 돌려 엔진 결과가 되돌아가던 결함(2026-10-27)
  const m = new Map(prev.map(r => [r.row_id, r])); for (const r of results) { const ex = m.get(r.row_id); if (ex && (ex.tobe_ref || '').startsWith('E2E @trace')) continue; m.set(r.row_id, r); }
  fs.writeFileSync(OUT, JSON.stringify([...m.values()], null, 1), 'utf8');
};
// W1(2026-10-24): 콤보 후보 실측 덤프 — combo_oracle.py 가 AS-IS 원천 실행 결과와 비교(B4 집합·B3 순서)
const RT_P = path.join(DIR, 'combo_runtime.json');
const RT: { at: string; search: Record<string, unknown>; grid: Record<string, unknown>; combos: unknown[] } = { at: new Date().toISOString(), search: {}, grid: {}, combos: [] };
// CRUD 실제 저장 안전장치(2026-10-24) — cleanup_spec.json keyset 정의 화면은 저장 전 빈 키 확인(ledger_guard.py check) · 스냅샷 기록(record)
const KEYSPEC: { keys: string[]; vary?: string[]; prefer?: Record<string, string> } | null = (() => {
  try { const j = JSON.parse(fs.readFileSync(path.join(ROOT, 'tools', 'Harness', 'verify', 'cleanup_spec.json'), 'utf8'))[ID]; return j && j.mode === 'keyset' ? j : null; } catch { return null; }
})();
// 마지막으로 기록(record)한 저장 키 — 저장 후 화면 자동 재조회로 신규행 자리가 다른 행이 되므로 재조회 판정은 이 값으로 찾는다(2026-10-25)
let lastRecordedKeys: Record<string, string> = {};
const guard = (mode: 'check' | 'record' | 'suggest', vals: Record<string, string>): { ok: boolean; free?: boolean; why?: string } => {
  if (mode === 'record') lastRecordedKeys = { ...vals };
  try { return JSON.parse(execFileSync('python', [path.join(ROOT, 'tools', 'Harness', 'verify', 'ledger_guard.py'), mode, ID, JSON.stringify(vals)], { encoding: 'utf8', timeout: 60_000 })); }
  catch (e) { return { ok: false, free: false, why: `가드 실행 실패 ${String(e).slice(0, 120)}` }; }
};
const addCombos = (list: { body: string }[]) => { const seen = new Set((RT.combos as { body: string }[]).map(c => c.body)); for (const c of list) if (!seen.has(c.body)) { seen.add(c.body); RT.combos.push(c); } };
const flushRt = () => {
  if (!ID) return;
  const prev = fs.existsSync(RT_P) ? JSON.parse(fs.readFileSync(RT_P, 'utf8')) : { search: {}, grid: {}, combos: [] };
  // 이번 실행에서 채운 구역은 통째로 교체(이전 실행의 낡은 항목이 섞이지 않게 — 2026-10-24 Sales Site 잔존), 비어 있는 구역만 이전 값 유지(--grep 부분 실행)
  const pick2 = <T,>(cur: T, old: T) => (cur && Object.keys(cur as object).length ? cur : old);
  fs.writeFileSync(RT_P, JSON.stringify({ at: RT.at, search: pick2(RT.search, prev.search), grid: pick2(RT.grid, prev.grid), combos: RT.combos.length ? RT.combos : prev.combos }, null, 1), 'utf8');
};
const put = (row_id: string, result: Res['result'], evidence: string, tobe_ref = 'E2E @verify') => results.push({ row_id, result, evidence: evidence.slice(0, 900), tobe_ref });
const binding = (target: string) => (/^[^.]+\.([A-Z0-9_]+)/.exec(target) || [])[1] || '';
const pick = (pred: (r: Record<string, string>) => boolean) => rows.filter(pred);
const searchedDiv = (body?: string) => { try { const j = JSON.parse(body || '{}'); const v = j.divisionId ?? j.data?.divisionId; return v == null ? '' : String(v); } catch { return ''; } };
// AS-IS 액션(guard·지역 변수 추적용) — 원장과 같은 화면 ID 의 Fact Pack
const ACTS_P = path.join(ROOT, 'Doc', 'asisfacts', 'screens', ID, 'actions.csv');
const ACTS = ID && fs.existsSync(ACTS_P) ? parseCsv(fs.readFileSync(ACTS_P, 'utf8')) : [];
const methodOf = (asisRef: string) => (/\.(\w+)(?:\s|$)/.exec(asisRef.split('·')[0].trim()) || [])[1] || '';
/**
 * 연쇄·cascade 의 원천 컬럼 — ① guard 체인('▸')의 가장 안쪽 'e.Column == …DefColumns.X' (바깥 'else of' 제외)
 *  ② 임의 변수와 컬럼 인덱스 비교 'i == …GetColumnIndex(DefColumns.X)' ③ guard 의 지역 변수(strX)를 같은 메서드에서 GetText/GetValue(…DefColumns.X) 로 세팅한 경우
 */
function resolveSrc(condition: string, asisRef: string): string {
  const segs = condition.split('▸').map(s => s.trim());
  const inner = segs.filter(s => /e\.Column\s*==/.test(s) && !/^else of/.test(s)).pop() || '';
  const m1 = /e\.Column\s*==\s*\w+\.GetColumnIndex\(\s*DefColumns\.([A-Z0-9_]+)/.exec(inner); if (m1) return m1[1];
  const m2 = /\b\w+\s*==\s*\w+\.GetColumnIndex\(\s*DefColumns\.([A-Z0-9_]+)/.exec(segs.filter(s => !/^else of/.test(s)).join(' ')); if (m2) return m2[1];
  const meth = methodOf(asisRef);
  for (const v of new Set(condition.match(/\bstr[A-Z_][A-Za-z0-9_]*\b/g) || [])) {
    const a = ACTS.find(x => x.method === meth && x.target === v && /DefColumns\.[A-Z0-9_]+/.test(x.value + x.raw));
    const m3 = a && /DefColumns\.([A-Z0-9_]+)/.exec(a.value + a.raw); if (m3) return m3[1];
  }
  return '';
}
/**
 * 조회조건 라벨 → 그 항목의 콤보박스(2026-10-24 W1). 라벨은 정확 일치 → 접두 일치('Div' ↔ 'Division', 3자 이상) 순.
 * 라벨과 콤보가 같은 입력 항목인지 확인 — 가장 가까운 공통 조상에 콤보가 1개뿐이어야 한다(텍스트/팝업형 라벨이 옆 항목 콤보를 집던 오인 방지)
 */
async function findSearchBox(nscm: { visibleFirst: (l: import('@playwright/test').Locator, max?: number) => Promise<import('@playwright/test').Locator | null> }, p: import('@playwright/test').Page, name: string) {
  const area = (await nscm.visibleFirst(p.locator('[class*="searchArea"], [class*="SearchArea"]'))) || p.locator('body');
  const esc = name.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  let lab = await nscm.visibleFirst(area.getByText(new RegExp(`^\\s*\\*?\\s*${esc}\\s*\\.?\\s*\\*?\\s*$`, 'i')));
  let labText = name;
  if (!lab) {
    const n0 = name.toLowerCase().replace(/[^a-z0-9]/g, '');
    const texts = (await area.locator('label, span, div, p').evaluateAll(els => els.filter(e => e.children.length === 0 && (e as HTMLElement).offsetParent !== null)
      .map(e => (e.textContent || '').trim()).filter(t => t && t.length <= 40))).filter((t, i, a) => a.indexOf(t) === i);
    const hit = texts.find(t => { const n1 = t.toLowerCase().replace(/[^a-z0-9]/g, ''); return n1.length >= 3 && (n0.startsWith(n1) || n1.startsWith(n0)); });
    if (hit) { labText = hit; lab = await nscm.visibleFirst(area.getByText(hit, { exact: true })); }
  }
  if (!lab) return { box: null, labText, why: `조회조건 라벨 '${name}' 를 조회조건 영역에서 못 찾음 — 명칭 차이는 H5 행에서 판정` };
  const holder = lab.locator('xpath=ancestor::*[.//*[@role="combobox"]][1]');
  const n = await holder.locator('[role="combobox"]').count().catch(() => 0);
  if (n !== 1) return { box: null, labText, why: `'${labText}' 항목에 콤보 없음(텍스트/팝업형 — 가장 가까운 콤보가 다른 항목 소속 ${n}개)` };
  return { box: holder.locator('[role="combobox"]').first(), labText, why: '' };
}

/** 콤보의 현재 선택 표시(칩·입력값) — AS-IS 실행 상태(앞 조건 선택값) 재현용 */
async function selectedOf(box: import('@playwright/test').Locator): Promise<string[]> {
  return box.evaluate(el => {
    const root = el.closest('.MuiAutocomplete-root') || el.parentElement || el;
    const clean = (t: string) => t.replace(/[​ ]/g, ' ').trim(); // 미선택(ALL) 표시는 제로폭 공백
    const chips = [...root.querySelectorAll('.MuiChip-label')].map(x => clean(x.textContent || '')).filter(Boolean);
    if (chips.length) return chips;
    const v = (el as HTMLInputElement).value ?? '';
    return clean(v) ? [clean(v)] : [clean((root as HTMLElement).innerText)].filter(Boolean);
  }).catch(() => [] as string[]);
}

/**
 * AS-IS 조건부 잠금 기대 평가 — 기대문 '잠금 when <guard> | 해제 when <guard> …' 중 그리드 행 값으로 계산 가능한 절만 평가한다.
 *  평가 가능: GetText/GetValue(<행>, …DefColumns.X)…(==|!=) "V"  ·  'else of (…)' = 부정. 그 밖(지역 변수·룩업 dr[…])은 평가하지 않는다(추측 금지)
 *  반환: { locked, by } — 평가 가능한 절이 서로 모순이면 null
 */
async function evalCondLock(expected: string, rowVal: (col: string) => Promise<string>): Promise<{ locked: boolean; by: string } | null> {
  const clauses = expected.replace(/^조건부\s*—\s*/, '').split(' | ').map(s => s.trim());
  const res: { locked: boolean; by: string }[] = [];
  for (const cl of clauses) {
    const m = /^(잠금|해제) when (.*)$/.exec(cl); if (!m) continue;
    const neg = /^else of/.test(m[2]);
    const g = /Get(?:Text|Value)\(\s*[\w.+\s-]+,\s*\w+\.GetColumnIndex\(\s*DefColumns\.([A-Z0-9_]+)\s*\)\s*\)(?:\.ToString\(\))?\s*(==|!=)\s*"([^"]*)"/.exec(m[2]);
    if (!g) continue;
    const v = (await rowVal(g[1])).trim();
    let hold = g[2] === '==' ? v === g[3] : v !== g[3]; if (neg) hold = !hold;
    if (hold) res.push({ locked: m[1] === '잠금', by: `${g[1]}='${v}' ${neg ? 'not ' : ''}${g[2]} '${g[3]}'` });
  }
  if (!res.length) return null;
  return res.every(r => r.locked === res[0].locked) ? res[0] : null;
}

test.describe(`정합검증 ${ID} @verify`, () => {
  test.describe.configure({ retries: 0 }); // 테스트끼리 독립 — 한 테스트 실패가 다른 판정을 막지 않게(serial 금지)
  test.skip(!ID || !rows.length, `VERIFY_ID 없음 또는 원장 없음: ${LEDGER}`);
  test.afterAll(() => { flush(); flushRt(); });

  test('조회 전 버튼 전제조건(D4) · 화면 진입 다국어(I2)', async ({ nscm }) => {
    test.setTimeout(180_000);
    const p = nscm.page;
    const r = await nscm.openScreen(ID);
    if (!r.authorized) { for (const x of pick(x => x.method.includes('E2E'))) put(x.row_id, 'ERROR', '화면 권한 없음 — 판정 불가'); return; }
    await p.waitForTimeout(2_500);
    const untr = await nscm.untranslatedTexts();
    for (const x of pick(x => x.source === 'RULE_SCREEN' && x.rule_id === 'I2'))
      put(x.row_id, untr.length ? 'FAIL' : 'PASS', untr.length ? `진입 화면 '_' 폴백 노출 ${untr.length}건: ${untr.join(' / ')}` : '진입 화면 \'_\' 폴백 0');
    for (const x of pick(x => x.rule_id === 'D4' && x.condition === '조회 전 실행')) {
      const btn = (/^(\w+?)Button/.exec(x.target) || [])[1] || 'Insert';
      if (btn !== 'Insert') { put(x.row_id, '판정필요', `${btn} 조회 전 프로브 미구현`); continue; }
      const before = await probe.newRowCount(p);
      if (!(await nscm.subButtonVisible('Insert'))) { put(x.row_id, '판정필요', 'Insert 버튼 비노출(권한) — 계정 바꿔 재실행'); continue; }
      await nscm.subButton('Insert').click({ timeout: 10_000 }); await p.waitForTimeout(1_000);
      const alert = await nscm.alertText(); if (alert) await nscm.clearDialogs();
      const after = await probe.newRowCount(p);
      put(x.row_id, after > before ? 'FAIL' : 'PASS', `조회 전 Insert: 신규행 ${before}→${after}${alert ? ` · 알림 '${alert.slice(0, 80)}'` : ''} (기대: ${x.expected.slice(0, 120)})`);
    }
  });

  test('그리드 컬럼 프로브 — 표시(A5)·기존행/신규행 편집(D1)·입력 후 재편집·콤보 후보(B1·B2)·숫자(E1)·날짜(E2)·다국어(I2)', async ({ nscm }) => {
    test.setTimeout(480_000);
    const p = nscm.page;
    const r = await nscm.openScreen(ID);
    if (!r.authorized) return;
    const calls = await nscm.search();
    // search() 는 첫 call-proc 만 기다린다 — 보조 조회(예 countryCity)가 먼저 오면 본 조회 전이다. 그리드에 행이 찰 때까지(최대 120s) 대기
    for (let k = 0; k < 240 && (await probe.rowCount(p)) <= 0; k++) await p.waitForTimeout(500);
    await p.waitForLoadState('networkidle', { timeout: 15_000 }).catch(() => undefined);
    await nscm.clearDialogs();
    const div = searchedDiv(nscm.calls.find(c => /SEARCH/i.test(c.btn) && /divisionId/.test(c.body || ''))?.body ?? calls[0]?.body);
    const vis = (await probe.visibleBindings(p)) || [];
    for (const x of pick(x => x.source === 'COLUMN' && x.rule_id === 'A5')) {
      const b = binding(x.target); const wantHidden = /VISIBLE_FLAG 'N'/.test(x.expected);
      const shown = vis.includes(b);
      put(x.row_id, wantHidden === shown ? 'FAIL' : 'PASS', `${b} 화면 표시=${shown ? 'Y' : 'N'} (기대 ${x.expected.slice(0, 80)})`);
    }
    // 기존행 편집 — 편집 가능 여부는 H2(셀 색) 판정에 재사용
    let ex = await probe.findRow(p, 'existing');
    const editEx = new Map<string, boolean>(); const editNew = new Map<string, boolean>();
    for (const x of pick(x => x.source === 'COLUMN' && x.rule_id === 'D1' && x.condition === '기존행')) {
      const b = binding(x.target);
      if (!ex) { put(x.row_id, 'ERROR', `조회 결과 0행 — 기존행 프로브 불가 (조회 Div '${div}')`); continue; }
      const e = await probe.editable(p, ex.row, b);
      if (e != null) editEx.set(b, e);
      await judgeEdit(x, e, `기존행 r${ex.row}`, ex.row);
    }
    // 신규행
    if (!(await nscm.subButtonVisible('Insert'))) { for (const x of pick(x => x.condition === '신규행')) put(x.row_id, '판정필요', 'Insert 버튼 비노출 — 신규행 프로브 불가'); return; }
    await nscm.subButton('Insert').click({ timeout: 10_000 }); await p.waitForTimeout(1_000); await nscm.clearDialogs();
    const nr = await probe.findRow(p, 'new');
    // Insert 가 맨 위에 넣으면 기존행 인덱스가 밀린다 — '기존행' 은 CRUD_TYPE 로 다시 찾는다(2026-10-27: H2/F5 가 신규행을 기존행으로 읽어 허위 FAIL)
    ex = await probe.findRow(p, 'existing');
    // W1 덤프: 콤보 컬럼마다 기존행·신규행 후보(코드·표시값·표시 순서) + 그 행의 Division 등 상위 값(AS-IS 인자 해석용)
    if (nr) {
      const ctxCols = ['DIVISION_ID', 'DEPT_ID', 'TEAM_ID', 'END_CUSTOMER', 'SCM_SITE_ID', 'FROM_SITE_CODE', 'TO_SITE_CODE', 'ITEM_ID', 'PROJECT_CODE', 'SALES_COMPANY'];
      const rowCtx = async (row: number) => Object.fromEntries((await Promise.all(ctxCols.map(async k => [k, (await probe.value(p, row, k)) ?? ''] as const))).filter(([, v]) => v));
      for (const b of (await probe.allBindings(p)) || []) {
        const info = await probe.colInfo(p, b); if (!info || !info.hasMap) continue;
        // 편집을 연 상태에서 읽는다 — 화면이 beginningEdit 에서 후보 필터·행별 후보를 설치한다(닫힌 상태 = 누적 표시맵)
        const dumpAt = async (row: number) => {
          const opened = await probe.startEdit(p, row, b); if (opened) await p.waitForTimeout(700);
          const d0 = await probe.comboDump(p, row, b); await probe.cancelEdit(p); await p.waitForTimeout(150);
          return d0 ? { ...d0, editing: opened } : d0;
        };
        RT.grid[b] = { header: info.header, newRow: await dumpAt(nr.row), newCtx: await rowCtx(nr.row),
          existing: ex ? await dumpAt(ex.row) : null, exCtx: ex ? await rowCtx(ex.row) : null };
      }
      addCombos(nscm.combos);
    }
    if (!nr) { for (const x of pick(x => x.condition === '신규행')) put(x.row_id, 'FAIL', '조회 후 Insert 했으나 신규행 없음'); return; }
    for (const x of pick(x => x.source === 'COLUMN' && x.rule_id === 'D1' && x.condition === '신규행')) {
      const b = binding(x.target);
      const e = await probe.editable(p, nr.row, b);
      if (e != null) editNew.set(b, e);
      // 조건 'strSel_Division …Length==2' = 조회한 Division 이 단일(2자리)일 때만 잠금 — 조회 요청 본문으로 평가
      if (/조건부/.test(x.expected) && /strSel_Division[^|]*Length\s*==\s*2/.test(x.expected) && div) {
        const wantLocked = div.length === 2;
        put(x.row_id, e === !wantLocked ? 'PASS' : 'FAIL', `신규행 ${b} 편집=${e} · 조회 Div '${div}' → AS-IS ${wantLocked ? '잠금' : '편집 가능'}`);
      } else await judgeEdit(x, e, `신규행 r${nr.row}`, nr.row);
    }
    // 콤보 후보 품질 + 입력 후 재편집(AS-IS 행조건 잠금 근거 없으면 계속 편집 가능해야 함)
    // AS-IS 가 '행 조건'으로 잠그는 셀(D3)만 예외 — EditButton 일괄 LockColumn(D1)은 기존행 규칙이라 신규행 재편집 판정과 무관(2026-10-23 #18 누락 원인)
    const rowCondLock = new Set(pick(x => x.source === 'ASIS' && x.rule_id === 'D3').flatMap(x => x.target.split(',')));
    // 신규행 Division 을 조회 Division(단일)으로 먼저 채운다 — 실제 사용은 Division 단일이며, 비워 두면 전 Division 캐시가 겹쳐 사이트 후보가 '중복' 으로 보인다(2026-10-27 사용자: 실제 조회 시 이상 없음)
    const divOne = /^[A-Z0-9]{2}$/i.test(div) ? div : '';
    if (nr && !(await probe.value(p, nr.row, 'DIVISION_ID'))) {
      const dc = divOne || (((await probe.candidates(p, nr.row, 'DIVISION_ID')) || []).map(s => s.trim()).find(Boolean) ?? '');
      if (dc) { await probe.setByEditor(p, nr.row, 'DIVISION_ID', dc).catch(() => false); await p.waitForTimeout(600); }
    }
    const divNow = nr ? (await probe.value(p, nr.row, 'DIVISION_ID')) ?? '' : '';
    for (const x of pick(x => x.source === 'COLUMN' && (x.rule_id === 'B1' || x.rule_id === 'B2') && x.condition === '신규행')) {
      const b = binding(x.target);
      // 편집 중 후보(사용자가 보는 목록)로 판정 — 닫힌 상태의 dataMap 은 누적 표시맵일 수 있다(2026-10-24)
      const opened = await probe.startEdit(p, nr.row, b); if (opened) await p.waitForTimeout(500);
      const c = await probe.candidates(p, nr.row, b); await probe.cancelEdit(p);
      if (c == null) { put(x.row_id, '판정필요', `${b} 셀 콤보(dataMap) 없음 — 에디터 유형 확인(D5)`); continue; }
      const q = probe.comboQuality(c);
      if (x.rule_id === 'B1') put(x.row_id, q.count === 0 || q.blanks ? 'FAIL' : 'PASS', `${b} 후보 ${q.count}건 · 빈 항목 ${q.blanks}`);
      else put(x.row_id, q.dups.length ? 'FAIL' : 'PASS', `${b} 후보 ${q.count}건(신규행 Division='${divNow || '없음'}' 기준) · 중복 ${q.dups.length ? q.dups.slice(0, 8).join(', ') : '0'}${q.dups.length && !divNow ? ' — Division 미지정 상태라 전 Division 후보가 겹침(실사용 아님)' : ''}`);
    }
    for (const x of pick(x => x.source === 'COLUMN' && x.rule_id === 'D1' && x.condition === '신규행')) {
      const b = binding(x.target); const c = await probe.candidates(p, nr.row, b);
      if (!c || !c.length || !(await probe.editable(p, nr.row, b))) continue;
      const v = c.find(s => s.trim()) || ''; if (!(await probe.setByEditor(p, nr.row, b, v))) continue;
      await p.waitForTimeout(400);
      const again = await probe.editable(p, nr.row, b);
      if (again === false && !rowCondLock.has(b))
        results.push({ row_id: x.row_id, result: 'FAIL', evidence: `신규행 ${b} 에 '${v}' 입력 후 잠김 — AS-IS 에 이 셀의 행 조건 잠금 근거 없음(입력값으로 잠금 판정하는 결함 의심)`, tobe_ref: 'E2E @verify' });
    }
    // 숫자 규칙(E1)
    for (const x of pick(x => x.source === 'COLUMN' && x.rule_id === 'E1' && !/판정필요/.test(x.note))) {
      const b = binding(x.target);
      if (!(await probe.editable(p, nr.row, b))) { put(x.row_id, '판정필요', `${b} 신규행 편집 불가 — 입력 검증 프로브 불가(기존행 편집 경로에서 재확인)`); continue; }
      const dec = Number((/소수 (\d+)자리/.exec(x.expected) || [])[1] || 0);
      const mn = (/최소 (-?\d+)/.exec(x.expected) || [])[1]; const mx = (/최대 (-?\d+)/.exec(x.expected) || [])[1];
      const ev: string[] = []; let fail = false;
      const tryVal = async (input: string, ok: (v: string) => boolean, what: string) => {
        await probe.setByEditor(p, nr.row, b, input); const got = (await probe.value(p, nr.row, b)) ?? '';
        const good = ok(got); ev.push(`${what} 입력 '${input}' → 값 '${got}' ${good ? 'OK' : 'NG'}`); if (!good) fail = true;
      };
      const frac = '1.' + '5'.repeat(dec + 1);
      await tryVal(frac, v => !v.includes('.') || (v.split('.')[1] || '').replace(/0+$/, '').length <= dec, `소수 ${dec}자리 초과`);
      await tryVal('ab', v => v === '' || !isNaN(Number(v)), '문자(숫자 아님)');  // 2026-10-27 사용자: 숫자 셀에 문자가 들어가는 것이 실제 오류
      if (mn != null) await tryVal(String(Number(mn) - 1), v => v === '' || Number(v) >= Number(mn), `최소 ${mn} 미만`);
      if (mx != null && Number(mx) < 1e9) await tryVal(String(Number(mx) + 1), v => v === '' || Number(v) <= Number(mx), `최대 ${mx} 초과`);
      put(x.row_id, fail ? 'FAIL' : 'PASS', `${b}: ${ev.join(' · ')}`);
    }
    // 날짜 규칙(E2)
    for (const x of pick(x => x.source === 'COLUMN' && x.rule_id === 'E2')) {
      const b = binding(x.target);
      if (!(await probe.editable(p, nr.row, b))) { put(x.row_id, 'PASS', `${b} 신규행 편집 불가(입력 경로 없음) — 잘못된 날짜 입력 불가`); continue; }
      const before = (await probe.value(p, nr.row, b)) ?? '';
      await probe.setByEditor(p, nr.row, b, '2026-10-33'); const got = (await probe.value(p, nr.row, b)) ?? '';
      const stored = /2026-?10-?33/.test(got);
      put(x.row_id, stored ? 'FAIL' : 'PASS', `${b}: '2026-10-33' 입력 → 값 '${got}' (입력 전 '${before}')${stored ? ' — 존재하지 않는 날짜가 그대로 저장 대상' : ''}`);
    }
    // 연쇄 자동 채움(C3) — AS-IS 'e.Column == GetColumnIndex(DefColumns.<원천>)' 분기의 SetValue 대상이 원천 선택 후 채워지는지(신규행)
    const c3 = pick(x => x.source === 'ASIS' && x.rule_id === 'C3');
    for (const x of c3) {
      // 원천 = guard 체인('▸')에서 가장 안쪽의 'e.Column == …' 분기(‘else of’ 로 시작하는 바깥 분기 부정은 제외) — 2026-10-23 오탐: TO_SITE 분기 대상(TO_CITY)을 바깥 FROM_SITE 분기로 오인
      const src = resolveSrc(x.condition, x.asis_ref);
      const tgts = x.target.split(',').filter(t => /^[A-Z0-9_]+$/.test(t) && t !== src);
      if (!src || !tgts.length) { put(x.row_id, '판정필요', `원천 컬럼 분기 해석 불가 — 조건 '${x.condition.slice(0, 100)}'`); continue; }
      if (!(await probe.editable(p, nr.row, src))) { put(x.row_id, '판정필요', `원천 ${src} 신규행 편집 불가 — 연쇄 프로브 불가`); continue; }
      const prefer = (await probe.candidatesWithField(p, src, 'CITY')).concat((await probe.candidates(p, nr.row, src)) || []);
      const tried: string[] = []; let ok = false; let got = '';
      for (const v of [...new Set(prefer.filter(Boolean))].slice(0, 3)) {
        if (!(await probe.setByEditor(p, nr.row, src, v))) continue; await p.waitForTimeout(800);
        const vals = await Promise.all(tgts.map(async t => `${t}='${(await probe.value(p, nr.row, t)) ?? ''}'`));
        tried.push(`${src}='${v}' → ${vals.join(', ')}`); got = vals.join(', ');
        if (vals.every(s => !/=''$/.test(s))) { ok = true; break; }
      }
      if (!tried.length) { put(x.row_id, '판정필요', `신규행 연쇄 ${src} → ${tgts.join(',')}: 원천 ${src} 에 값을 입력하지 못함(후보 ${prefer.length}건) — 후보 없음이면 B1·B4 결함, 아니면 입력 경로 확인 (AS-IS ${x.asis_ref.slice(0, 60)})`); continue; }
      put(x.row_id, ok ? 'PASS' : 'FAIL', `신규행 연쇄 ${src} → ${tgts.join(',')}: ${tried.join(' | ')}${ok ? '' : ` — 원천 선택 후 대상 빈 값(${got})`} (AS-IS ${x.asis_ref.slice(0, 60)})`);
    }

    // 에디터 유형(D5) — AS-IS 셀 타입 ↔ TO-BE 컬럼 정의(dataMap·dataType·format). 콤보가 Key-in 으로 바뀐 회귀(DM-162) · 날짜가 문자열 칸(#23)
    const DT = ['Object', 'String', 'Number', 'Boolean', 'Date'];
    for (const x of pick(x => x.source === 'COLUMN' && x.rule_id === 'D5')) {
      const b = binding(x.target); const info = await probe.colInfo(p, b);
      if (!info) { put(x.row_id, 'NA', `${b} 현재 그리드에 없음 — 표시 여부는 A5`); continue; }
      const want = (/AS-IS (\w+)/.exec(x.expected) || [])[1] || '';
      const isNum = info.dataType === 2 || /^[nNcCpP]\d*$/.test(info.format);
      const isDate = info.dataType === 4 || /y{2,}|M{2}|d{2}/.test(info.format);
      let ok = true;
      if (want === 'COMBO') ok = info.hasMap || !!info.editor;
      else if (want === 'NUMBER') ok = isNum;
      else if (want === 'DATE' || want === 'DATETIME') ok = isDate;
      else if (want === 'CHECK') ok = info.dataType === 3 || info.hasMap;
      const desc = `dataType=${DT[info.dataType] || info.dataType} · dataMap=${info.hasMap ? 'Y' : 'N'}${info.editor ? ' · editor' : ''}${info.format ? ' · format=' + info.format : ''}`;
      put(x.row_id, ok ? 'PASS' : 'FAIL', `${b}: AS-IS ${want} ↔ TO-BE ${desc}${ok ? '' : ' — AS-IS ' + want + ' 에디터가 아님'}`);
    }
    // 편집 표시(H2) — 편집 가능 셀 = 노랑(wj-cell-editable) / 편집 불가 = 흰색(회색 wj-cell-non-editable 은 특수 경우만, hook #95)
    for (const x of pick(x => x.source === 'COLUMN' && x.rule_id === 'H2')) {
      const b = binding(x.target); const ev: string[] = []; let fail = false; let human = false; let probed = 0;
      const targets: Array<[string, { row: number } | null, Map<string, boolean>]> = [['기존행', ex, editEx], ['신규행', nr, editNew]];
      for (const [nm, ref, mp] of targets) {
        if (!ref) continue;
        const cls = await probe.cellClasses(p, ref.row, b); if (cls == null) continue;
        const popupCell = /CELL=FPModal/i.test(x.asis_ref || '') || /FPModal/.test(x.expected || '');  // 팝업 입력 셀 = 사용자가 값을 바꿀 수 있는 셀(더블클릭 팝업) → 노랑 정상(CR-072)
        const e0 = mp.has(b) ? mp.get(b) : await probe.editable(p, ref.row, b); if (e0 == null && !popupCell) continue;
        const e = popupCell ? true : e0;
        probed++; const yellow = /wj-cell-editable/.test(cls); const gray = /wj-cell-non-editable/.test(cls);
        if (e && !yellow) { fail = true; ev.push(`${nm} 편집 가능인데 노랑 아님`); }
        else if (!e && yellow) { fail = true; ev.push(`${nm} 편집 불가인데 노랑`); }
        else if (!e && gray) { human = true; ev.push(`${nm} 잠금 회색(특수 경우만 허용)`); }
        else ev.push(`${nm} 편집=${e}${popupCell ? '(팝업 입력 셀)' : ''} 표시 일치`);
      }
      if (!probed) { put(x.row_id, 'NA', `${b} 현재 그리드에 없음`); continue; }
      let res: Res['result'] = 'PASS'; if (fail) res = 'FAIL'; else if (human) res = '판정필요';
      put(x.row_id, res, `${b}: ${ev.join(' · ')}`);
    }
    // 코드→Name 표시(A2) — 기존행 원값이 dataMap 에 이름이 있는데 화면에 코드 그대로면 FAIL
    for (const x of pick(x => x.source === 'COLUMN' && x.rule_id === 'A2')) {
      const b = binding(x.target);
      if (!ex) { put(x.row_id, '판정필요', '조회 결과 0행'); continue; }
      const raw = (await probe.value(p, ex.row, b)) ?? '';
      if (!raw) { put(x.row_id, '판정필요', `${b} 기존행 값 공란 — 다른 행으로 확인`); continue; }
      const disp = (await probe.displayText(p, ex.row, b)) ?? ''; const nm = await probe.mapName(p, b, raw);
      if (nm == null) { put(x.row_id, '판정필요', `${b} dataMap 없음 — 에디터 유형(D5) 행 참고 · 표시 '${disp}'`); continue; }
      // 사용자 룰(2026-10-26): 코드/NAME 표시는 AS-IS 와 동일 — AS-IS 가 조회 시점(로드 경로)에 콤보(NAME)인 컬럼만 코드 표시를 FAIL. Insert/Edit 때만 콤보인 컬럼은 AS-IS 도 코드
      const asisName = pick(r => r.source === 'ASIS' && /SetCellTypeCombo/.test(r.expected || '') && /(FindData_Main|SetImageCell|Set_ValidTextColor|InitSpread|CreateSpread)/.test(r.asis_ref || '')).some(r => r.target.split(',').map(t => t.trim()).includes(b));
      const codeShown = disp === raw && nm !== raw && nm !== '';
      put(x.row_id, codeShown && asisName ? 'FAIL' : 'PASS', `${b}: 원값 '${raw}' → 표시 '${disp}' (이름 '${nm}') · AS-IS 조회 시점 ${asisName ? 'NAME(콤보)' : '코드(TextCell · 콤보는 Insert/Edit 때만)'}${codeShown && asisName ? ' — AS-IS 는 NAME 인데 코드 표시' : codeShown ? ' — 코드 표시 = AS-IS 동일' : ''}`);
    }
    // 셀 Cascade(C2) — AS-IS ComboSelChange 등에서 원천 셀 값에 따라 대상 셀 콤보를 바꿈 → 원천 값을 바꾸면 대상 후보가 달라져야 한다
    for (const x of pick(x => x.source === 'ASIS' && x.rule_id === 'C2')) {
      const src = resolveSrc(x.condition, x.asis_ref);
      const tgt = x.target.split(',').find(t => /^[A-Z0-9_]+$/.test(t) && t !== src) || '';
      if (!src || !tgt) { put(x.row_id, '판정필요', `원천/대상 해석 불가 — 조건 '${x.condition.slice(0, 100)}'`); continue; }
      if (!(await probe.editable(p, nr.row, src))) { put(x.row_id, '판정필요', `원천 ${src} 신규행 편집 불가`); continue; }
      const cands = [...new Set(((await probe.candidates(p, nr.row, src)) || []).filter(Boolean))];
      const sigs = new Map<string, string>(); const ev: string[] = [];
      // 대표값 = (코드 접미 × 원천 항목의 분기 속성 조합)별 1개 — AS-IS 분기는 접미('E'/'A')와 속성(OSP_YN 등)으로 갈린다.
      //   2026-10-24 SCP0007: 접미만으로 고르면 외주(OSP_YN='Y') From Site 가 빠져 PLANT 분기를 못 건드리고 '후보 동일' 판정필요가 났다
      const attrOf = new Map((await probe.candidateAttrs(p, src)).map(a => [a.v, a.attrs]));
      const groups = new Map<string, string>();
      for (const v of cands) { const g = (/[-_]([A-Za-z0-9]+)$/.exec(v) || [, ''])[1] + '|' + JSON.stringify(attrOf.get(v) || {}); if (!groups.has(g)) groups.set(g, v); }
      const tryVals = [...groups.values(), ...cands.filter(v => ![...groups.values()].includes(v))].slice(0, Math.max(5, Math.min(groups.size, 10)));
      for (const v of tryVals) {
        if (!(await probe.setByEditor(p, nr.row, src, v))) continue;
        await p.waitForTimeout(500);
        const tc = (await probe.candidates(p, nr.row, tgt)) || [];
        sigs.set(v, `${tc.length}:${[...tc].sort().join('|')}`); ev.push(`${src}='${v}' → ${tgt} 후보 ${tc.length}건`);
      }
      if (sigs.size < 2) { put(x.row_id, '판정필요', `원천 값 2개 이상 입력 불가(후보 ${cands.length}) — ${ev.join(' · ')}`); continue; }
      const distinct = new Set(sigs.values()).size >= 2;
      put(x.row_id, distinct ? 'PASS' : '판정필요', `${ev.join(' · ')}${distinct ? '' : ' — 원천 값과 무관하게 후보 동일(AS-IS 필터 분기 조건 확인 필요)'} (AS-IS ${x.asis_ref.slice(0, 60)})`);
    }

    const untr = await nscm.untranslatedTexts();
    for (const x of pick(x => x.source === 'RULE_SCREEN' && x.rule_id === 'I2'))
      if (untr.length) put(x.row_id, 'FAIL', `조회·Insert 후 '_' 폴백 노출: ${untr.join(' / ')}`);

    // 무변경 편집 종료 시 연쇄 미발동(C6) — 원천 셀을 더블클릭해 편집기를 열고 값 변경 없이 Esc → 대상 셀 값이 그대로여야 한다
    //   (2026-10-23 SCP0007 실측: From Site 더블클릭+Esc 만으로 To Site 가 지워짐 — AS-IS ComboSelChange 는 값 변경 때만 발동)
    const c6 = pick(x => x.source === 'ASIS' && x.rule_id === 'C6');
    const bySrc = new Map<string, Record<string, string>[]>();
    for (const x of c6) { const src = resolveSrc(x.condition, x.asis_ref); const k = src || '?'; bySrc.set(k, [...(bySrc.get(k) || []), x]); }
    for (const [src, xs] of bySrc) {
      if (src === '?') { for (const x of xs) put(x.row_id, '판정필요', `원천 컬럼 분기 해석 불가 — 조건 '${x.condition.slice(0, 100)}'`); continue; }
      if (!(await probe.editable(p, nr.row, src))) { for (const x of xs) put(x.row_id, '판정필요', `원천 ${src} 신규행 편집 불가`); continue; }
      // 원천에 값이 없으면 채운다
      if (!((await probe.value(p, nr.row, src)) ?? '')) { const c = (await probe.candidates(p, nr.row, src)) || []; const v = c.find(t => t.trim()); if (v) { await probe.setByEditor(p, nr.row, src, v); await p.waitForTimeout(600); } }
      // 대상(연쇄로 바뀌는 칸)들: 콤보면 값이 없을 때 후보로 채운다
      const tgts = [...new Set(xs.flatMap(x => x.target.split(',')).filter(t => /^[A-Z0-9_]+$/.test(t) && t !== src))];
      for (const t of tgts) {
        if ((await probe.value(p, nr.row, t)) ?? '') continue;
        const c = await probe.candidates(p, nr.row, t); const v = c && c.find(s2 => s2.trim());
        if (v) { await probe.setByEditor(p, nr.row, t, v); await p.waitForTimeout(400); }
      }
      const before = Object.fromEntries(await Promise.all(tgts.map(async t => [t, (await probe.value(p, nr.row, t)) ?? ''] as const)));
      const pt = await probe.cellCenter(p, nr.row, src);
      if (!pt) { for (const x of xs) put(x.row_id, 'ERROR', `${src} 셀 위치 확인 불가`); continue; }
      await p.mouse.dblclick(pt.x, pt.y); await p.waitForTimeout(500); await p.keyboard.press('Escape'); await p.waitForTimeout(800);
      const after = Object.fromEntries(await Promise.all(tgts.map(async t => [t, (await probe.value(p, nr.row, t)) ?? ''] as const)));
      const srcAfter = (await probe.value(p, nr.row, src)) ?? '';
      const lost = tgts.filter(t => before[t] && before[t] !== after[t]);
      const ev = `${src}='${srcAfter}' 더블클릭+Esc(값 변경 없음) → ${tgts.map(t => `${t} '${before[t]}'→'${after[t]}'`).join(', ')}`;
      for (const x of xs) put(x.row_id, lost.length ? 'FAIL' : (tgts.some(t => before[t]) ? 'PASS' : '판정필요'), lost.length ? `${ev} — 값 변경 없이 연쇄가 발동해 ${lost.join(',')} 초기화` : (tgts.some(t => before[t]) ? ev : `${ev} — 대상 값을 채우지 못해 판정 불가`));
    }

    // 후보 밖 값 입력 차단(E5) — 마지막(행 값을 오염시키므로). 콤보 셀에 목록에 없는 값을 넣으면 거부돼야 한다
    for (const x of pick(x => x.source === 'COLUMN' && x.rule_id === 'E5')) {
      const b = binding(x.target);
      if (!(await probe.editable(p, nr.row, b))) { put(x.row_id, 'PASS', `${b} 신규행 편집 불가 — 입력 경로 없음`); continue; }
      if ((await probe.candidates(p, nr.row, b)) == null) { put(x.row_id, '판정필요', `${b} 콤보(dataMap) 없음 — D5 행 참고`); continue; }
      const bad = 'ZZ_E2E_NOT_IN_LIST'; await probe.setByEditor(p, nr.row, b, bad); const got = (await probe.value(p, nr.row, b)) ?? '';
      put(x.row_id, got === bad ? 'FAIL' : 'PASS', `${b}: 목록 밖 '${bad}' 입력 → 값 '${got}'${got === bad ? ' — 후보 밖 값이 저장 대상' : ''}`);
    }

    async function judgeEdit(x: Record<string, string>, e: boolean | null, where: string, row: number) {
      const b = binding(x.target);
      // 조건부 기대 — 그 행의 실제 값으로 AS-IS guard 를 계산해 확정(계산 불가면 판정필요 유지)
      if (e != null && /^조건부/.test(x.expected)) {
        const ev = await evalCondLock(x.expected, async c => (await probe.value(p, row, c)) ?? '');
        if (ev) { put(x.row_id, e === !ev.locked ? 'PASS' : 'FAIL', `${where} ${b} 편집=${e} · AS-IS ${ev.locked ? '잠금' : '편집 가능'} (행 값 ${ev.by})`); return; }
      }
      // 그리드에 없는 컬럼 = 이 Division·개인화·다른 시트(탭)에서 미표시 — 도구 오류가 아니라 이 조건에서 해당없음(표시 여부는 A5 행이 판정)
      if (e == null) { put(x.row_id, 'NA', `${where} ${b}: 현재 그리드에 없음(Division·개인화·다른 시트) — 표시 여부는 A5 행에서 판정`); return; }
      if (/^팝업 입력/.test(x.expected)) put(x.row_id, e ? 'FAIL' : 'PASS', `${where} ${b} 직접 편집=${e} (AS-IS 직접 입력 차단·더블클릭 팝업으로만 입력 — 팝업 동작은 G5 행)`);
      else if (/^편집 가능/.test(x.expected)) put(x.row_id, e ? 'PASS' : 'FAIL', `${where} ${b} 편집=${e} (AS-IS 편집 가능)`);
      else if (/^잠금/.test(x.expected)) put(x.row_id, e ? 'FAIL' : 'PASS', `${where} ${b} 편집=${e} (AS-IS 잠금)`);
      else put(x.row_id, '판정필요', `${where} ${b} 편집=${e} — 기대: ${x.expected.slice(0, 160)}`);
    }
  });

  test('그리드 더블클릭 팝업 인자(G5) — AS-IS 가 팝업에 넘기는 셀 값이 TO-BE 팝업 조회 요청에 들어가는지', async ({ nscm }) => {
    test.setTimeout(240_000);
    const p = nscm.page;
    const g5 = pick(x => x.source === 'ASIS' && x.rule_id === 'G5' && /DoubleClick/.test(x.asis_ref));
    if (!g5.length) return;
    const actsP = path.join(ROOT, 'Doc', 'asisfacts', 'screens', ID, 'actions.csv');
    const acts = fs.existsSync(actsP) ? parseCsv(fs.readFileSync(actsP, 'utf8')) : [];
    const r = await nscm.openScreen(ID);
    if (!r.authorized) return;
    await nscm.search();
    for (let k = 0; k < 240 && (await probe.rowCount(p)) <= 0; k++) await p.waitForTimeout(500);
    await nscm.clearDialogs();
    const ex = await probe.findRow(p, 'existing');
    for (const x of g5) {
      const col = (/e\.Column\s*==\s*\w+\.GetColumnIndex\(\s*DefColumns\.([A-Z0-9_]+)/.exec(x.condition) || [])[1];
      const method = (/\.(\w*DoubleClick\w*)/.exec(x.asis_ref) || [])[1] || 'CellDoubleClick';
      // 팝업 인자 원천 = 같은 핸들러에서 GetText/GetValue(e.Row, …DefColumns.X) 로 읽는 셀
      const srcCols = [...new Set(acts.filter(a => a.method === method && /Get(Text|Value)\(\s*e\.Row/.test(a.value + a.raw)).flatMap(a => [...(a.value + a.raw).matchAll(/DefColumns\.([A-Z0-9_]+)/g)].map(m => m[1])))].filter(c => c !== col);
      if (!col || !ex) { put(x.row_id, '판정필요', `팝업 셀 해석 불가 또는 조회 0행 (col=${col || '-'})`); continue; }
      const vals = Object.fromEntries(await Promise.all(srcCols.map(async c => [c, (await probe.value(p, ex.row, c)) ?? ''] as const)));
      const before = nscm.calls.length;
      const pt = await probe.cellCenter(p, ex.row, col);
      if (!pt) {
        const all = (await probe.allBindings(p)) || [];
        put(x.row_id, all.includes(col) ? 'ERROR' : 'NA', all.includes(col) ? `${col} 셀 위치 확인 불가(컬럼은 있음 — 도구 확인 필요)` : `팝업 셀 ${col} 이 현재 그리드에 없음(Division·개인화·다른 시트)`); continue;
      }
      await p.mouse.dblclick(pt.x, pt.y); await p.waitForTimeout(2_500);
      const pop = nscm.calls.slice(before).filter(c => !/SAVE|INS|UPD|DEL/i.test(c.btn));
      const body = pop.map(c => c.body || '').join(' ');
      // 값이 그대로 없더라도 같은 이름의 요청 키(FROM_CITY → fromCity)가 비어 있지 않으면 전달된 것으로 본다 — 명칭→코드 환산(TRUCK→TRK) 허용(2026-10-23 오탐)
      const camel = (c: string) => c.toLowerCase().replace(/_([a-z])/g, (_, ch: string) => ch.toUpperCase());
      const keyFilled = (c: string) => [camel(c), camel(c).replace(/Name$/, '')].some(k => new RegExp(`"${k}"\\s*:\\s*"[^"]+"`).test(body));
      const missing = Object.entries(vals).filter(([c, v]) => v && !body.includes(v) && !keyFilled(c)).map(([c, v]) => `${c}='${v}'`);
      const filled = Object.entries(vals).filter(([, v]) => v).length;
      if (!pop.length) put(x.row_id, 'FAIL', `기존행 ${col} 더블클릭 후 팝업 조회 호출 없음 (AS-IS ${x.asis_ref.slice(0, 60)})`);
      else if (!filled) put(x.row_id, '판정필요', `원천 셀(${srcCols.join(',')}) 값이 모두 비어 인자 대조 불가 — 다른 행으로 재확인`);
      else put(x.row_id, missing.length ? 'FAIL' : 'PASS', `팝업 호출 ${pop.map(c => `${c.sheet}/${c.btn}`).join(',')} · AS-IS 인자 원천 ${srcCols.join(',')} · 요청에 없음: ${missing.join(', ') || '없음'} · 요청 ${body.slice(0, 200)}`);
      // 팝업 표준(H6) — 팝업이 열린 상태에서: 버튼 순서 OK→CLOSE · 그리드 No. 컬럼 · 건수 표시 (확정 규칙 CR-005 · C8)
      for (const h of pick(y => y.source === 'ASIS' && y.rule_id === 'H6' && y.target === x.target)) {
        if (!pop.length) { put(h.row_id, '판정필요', '팝업이 열리지 않아 표준 확인 불가(G5 행 참고)'); continue; }
        const d = await p.evaluate(() => {
          const dlg = [...document.querySelectorAll('[role="dialog"], .MuiDialog-root')].filter(e => (e as HTMLElement).getBoundingClientRect().height > 0).pop() as HTMLElement | undefined;
          if (!dlg) return null;
          const btns = [...dlg.querySelectorAll('button')].map(b => (b.innerText || b.getAttribute('aria-label') || '').trim()).filter(Boolean);
          // No. 는 좌상단 코너(.wj-topleft, 행 머리글 영역)에 있을 수 있다 — 컬럼 헤더만 보면 'Route Id' 를 첫 컬럼으로 오인(2026-10-23 H6 오탐 3건)
          const corner = [...dlg.querySelectorAll('.wj-topleft .wj-cell')].map(c => (c as HTMLElement).innerText.trim()).filter(Boolean);
          const hdr = [...corner, ...[...dlg.querySelectorAll('.wj-colheaders .wj-cell')].map(c => (c as HTMLElement).innerText.trim()).filter(Boolean)];
          const text = dlg.innerText || '';
          return { btns, firstHdr: hdr[0] || '', count: /(Total|총)\s*[:：]?\s*[\d,]+|[\d,]+\s*건/i.test(text) };
        });
        if (!d) { put(h.row_id, '판정필요', '팝업 대화상자 DOM 확인 불가'); continue; }
        const okI = d.btns.findIndex(t => /^(OK|확인|Apply|적용|Select|선택)$/i.test(t));
        const clI = d.btns.findIndex(t => /^(Close|닫기|Cancel|취소)$/i.test(t));
        const orderOk = okI >= 0 && clI >= 0 ? okI < clI : null;
        const noCol = /^No\.?$/i.test(d.firstHdr);
        const issues = [orderOk === false ? 'OK/CLOSE 순서 반대' : '', noCol ? '' : `첫 컬럼 '${d.firstHdr}'(No. 아님)`, d.count ? '' : '건수 표시 없음'].filter(Boolean);
        put(h.row_id, issues.length ? 'FAIL' : (orderOk == null ? '판정필요' : 'PASS'), `팝업 버튼 [${d.btns.slice(0, 8).join(', ')}] · 첫 컬럼 '${d.firstHdr}' · 건수 ${d.count ? 'Y' : 'N'}${issues.length ? ' — ' + issues.join(' · ') : ''}${orderOk == null ? ' · OK/CLOSE 버튼 식별 불가' : ''}`);
      }
      await nscm.clearDialogs(); await p.keyboard.press('Escape'); await p.waitForTimeout(500);
    }
  });


  test('CRUD — 필수 공란 실제 저장 시도(E3) → 필수 채워 실제 저장·재조회·값 보존·정리(F1·F2·F4·F6)', async ({ nscm }) => {
    const t0 = Date.now();
    // 사용자 지시(2026-10-23): CRUD 테스트에서 저장을 실제로 실행해 판정한다(요청 차단 없음).
    //   PASS = 저장 요청 없이 필수 안내로 차단, 또는 서버(SP) 검증이 사용자 메시지로 차단
    //   FAIL = 무반응 · SQL 오류(ORA-/SQL Error) 노출 · 필수 공란 행이 실제로 저장됨(→ 증거에 '정리 필요' 표시)
    const e3 = pick(x => x.rule_id === 'E3' && (x.source === 'RULE_SCREEN' || (x.source === 'ASIS' && /Spread/.test(x.target))));
    const fAny = pick(y => y.source === 'RULE_SCREEN' && /^F[1246]$/.test(y.rule_id));
    if (!e3.length && !fAny.length) return; // E3(필수 표시 컬럼) 없는 화면도 CRUD 실제 저장은 검사한다(2026-10-24 DMF0005 9.8초 종료)
    test.setTimeout(900_000);
    const p = nscm.page;
    const r = await nscm.openScreen(ID);
    if (!r.authorized) return;
    await nscm.search();
    for (let k = 0; k < 240 && (await probe.rowCount(p)) <= 0; k++) await p.waitForTimeout(500);
    await nscm.clearDialogs();
    if (!(await nscm.subButtonVisible('Insert')) || !(await nscm.subButtonVisible('Save'))) { for (const x of e3) put(x.row_id, '판정필요', 'Insert/Save 버튼 비노출 — 계정 권한 확인'); return; }
    const rowsBefore = await probe.rowCount(p);
    await nscm.subButton('Insert').click({ timeout: 10_000 }); await p.waitForTimeout(800); await nscm.clearDialogs();
    if (!(await probe.findRow(p, 'new'))) { for (const x of e3) put(x.row_id, 'FAIL', 'Insert 후 신규행 없음'); return; }
    const toasts: string[] = [];
    const grabToast = async () => { for (const t of await p.locator('.MuiSnackbar-root, [role="alert"], [role="status"], .Toastify__toast').allInnerTexts().catch(() => [] as string[])) { const v = t.replace(/\s+/g, ' ').trim(); if (v && !toasts.includes(v)) toasts.push(v); } };
    const tick = setInterval(() => { void grabToast(); }, 300);
    const before = nscm.calls.length; const dialogs: string[] = [];
    await nscm.subButton('Save').click({ timeout: 10_000 });
    for (let k = 0; k < 6; k++) {
      await p.waitForTimeout(1_000);
      const m = await nscm.alertText(); if (!m) { if (k >= 2) break; continue; }
      dialogs.push(m.replace(/\s+/g, ' ').slice(0, 160)); await nscm.closeAlert('ok');
    }
    await p.waitForLoadState('networkidle', { timeout: 15_000 }).catch(() => undefined);
    await p.waitForTimeout(1_000); await grabToast(); clearInterval(tick);
    const sv = { calls: nscm.calls.slice(before).filter(c => /SAVE|INS|UPD|DEL/i.test(c.btn)), message: dialogs.join(' / ') };
    const msg = [sv.message, ...toasts].filter(Boolean).join(' / ').replace(/\s+/g, ' ').slice(0, 240);
    const sent = sv.calls.length;
    const httpErr = sv.calls.some(c => c.status >= 400);
    const sqlErr = /ORA-\d+|SQL Error|SQLException|Exception/i.test(msg + ' ' + sv.calls.map(c => c.res || '').join(' '));
    const reqMsg = /필수|입력|required|mandatory|empty|누락|Please|하십시오|하세요|MSG\d{5}/i.test(msg);
    let saved = false;
    if (sent && !httpErr && !sqlErr && !reqMsg) {
      // 저장 성공처럼 보이면 재조회해서 행이 늘었는지 확인(필수 공란 행 생성 여부)
      await nscm.search(); for (let k = 0; k < 120 && (await probe.rowCount(p)) <= 0; k++) await p.waitForTimeout(500);
      saved = (await probe.rowCount(p)) > rowsBefore;
    }
    const req = sv.calls.map(c => `${c.sheet}/${c.btn}:${c.status}${c.req ? ' req=' + c.req.slice(0, 120) : ''}${c.res ? ' res=' + c.res.slice(0, 120) : ''}`).join(' | ');
    for (const x of e3) {
      if (!sent && reqMsg) put(x.row_id, 'PASS', `저장 요청 없이 차단 · 메시지 '${msg}'`);
      else if (!sent && !msg) put(x.row_id, 'FAIL', '필수 공란 저장 시 저장 요청도 메시지도 없음(무반응) — 필수 안내 누락(O3)');
      else if (!sent) put(x.row_id, '판정필요', `저장 요청 없음 · 필수 안내가 아닌 메시지 '${msg}'`);
      else if (sqlErr || httpErr) put(x.row_id, 'FAIL', `필수 공란 저장 → 서버 오류 노출 '${msg}' (${req}) — AS-IS 는 저장 전 차단(${x.asis_ref.slice(0, 80)})`);
      else if (saved) put(x.row_id, 'FAIL', `필수 공란 행이 실제로 저장됨(재조회 ${rowsBefore}→증가) — ⚠ 정리 필요 · ${req}`);
      else if (reqMsg) put(x.row_id, 'PASS', `서버(SP) 검증으로 차단 · 메시지 '${msg}' (AS-IS 는 화면에서 저장 전 차단 — 동작 결과는 같음) · ${req}`);
      else put(x.row_id, '판정필요', `저장 요청 ${sent}건 · 메시지 '${msg}' · 재조회 행 증가 없음 — 결과 확인 필요 · ${req}`);
    }
    // ── CRUD 실제 저장(F1·F2·F4·F6) — 사용자 지시 2026-10-23: CRUD 테스트에서 실제 저장 실행 ──
    //   필수 컬럼을 채우고(콤보=후보, 숫자=1, 날짜=기존 형식, 텍스트=마커) 저장 → 재조회로 마커 행 존재·값 보존 확인 → 삭제·저장으로 정리
    const fRows = (rid: string) => pick(y => y.source === 'RULE_SCREEN' && y.rule_id === rid);
    if (!fRows('F1').length && !fRows('F2').length) return;
    const nr2 = await probe.findRow(p, 'new');
    if (!nr2) { for (const rid of ['F1', 'F2', 'F4', 'F6']) for (const y of fRows(rid)) put(y.row_id, '판정필요', 'E3 이후 신규행 없음 — CRUD 저장 프로브 불가'); return; }
    const vis2 = (await probe.visibleBindings(p)) || [];
    const reqCols = vis2.filter(b => /\*$/.test(rows.find(y => y.source === 'COLUMN' && binding(y.target) === b)?.target.replace(/\)$/, '') || ''));
    const marker = `E2E_${new Date().toISOString().replace(/\D/g, '').slice(4, 12)}`;
    const filled: Record<string, string> = {};
    // 마커 칸 = 필수 아닌 편집 가능 텍스트 컬럼. 팝업 반환·연쇄 대상 칸은 제외(2026-10-23 실측: TRANSPORT_MODE 마커를 Route 팝업이 덮어써 F1 오탐), REMARKS 류 우선
    const asisCols = (re: RegExp) => new Set(pick(y => y.source === 'ASIS' && re.test(y.rule_id)).flatMap(y => [...y.target.split(','), ...[...y.condition.matchAll(/DefColumns\.([A-Z0-9_]+)/g)].map(m => m[1])]).filter(t => /^[A-Z0-9_]+$/.test(t)));
    const overwritten = new Set([...asisCols(/^(G5|H6|C3|C6|C2)$/)]);
    const markerCands: string[] = [];
    for (const b of vis2) {
      if (reqCols.includes(b) || overwritten.has(b)) continue;
      const info = await probe.colInfo(p, b); if (!info || info.hasMap || info.dataType === 2 || info.dataType === 4 || info.dataType === 3) continue;
      markerCands.push(b);
    }
    markerCands.sort((a, b) => Number(!/REMARK|COMMENT|DESC|NOTE|MEMO|RMK/.test(a)) - Number(!/REMARK|COMMENT|DESC|NOTE|MEMO|RMK/.test(b)));
    let markerCol = '';
    for (const b of markerCands) if (await probe.editable(p, nr2.row, b)) { markerCol = b; break; }
    // 값 원천 = 조회된 기존 행(실제로 유효한 조합 — 그 조합에 맞는 팝업 후보(Route 등)도 존재). 숫자 필수값은 키 중복을 피해 97
    const exRow = await probe.findRow(p, 'existing');
    const srcVal = async (b: string) => {
      if (!exRow) return '';
      const raw = (await probe.value(p, exRow.row, b)) ?? ''; if (!raw) return '';
      const nm = await probe.mapName(p, b, raw); return nm ?? raw;
    };
    const valueFor = async (b: string) => {
      const info = await probe.colInfo(p, b);
      if (info && (info.dataType === 2 || /^[nN]\d*$/.test(info.format))) return '97';
      const v = await srcVal(b); if (v) return v;
      const c = await probe.candidates(p, nr2.row, b);
      return (c && c.find(t => t.trim())) || (info && info.dataType === 4 ? new Date().toISOString().slice(0, 10) : marker);
    };
    for (let pass = 0; pass < 2; pass++) { // 연쇄로 다른 칸이 초기화될 수 있어 2회
      for (const b of reqCols) {
        if (!(await probe.editable(p, nr2.row, b))) continue;
        const cur = (await probe.value(p, nr2.row, b)) ?? ''; if (cur && pass === 1) continue;
        const v = await valueFor(b);
        if (v && (await probe.setByEditor(p, nr2.row, b, v))) { filled[b] = (await probe.value(p, nr2.row, b)) ?? ''; await p.waitForTimeout(400); }
      }
    }
    // 빈 필수 칸만 다시 채운다(키 변경 연쇄로 지워진 칸 · 필수 안내 메시지가 지목한 칸). 값이 있는 칸은 편집기를 열지 않는다(C6 결함 회피)
    const extraReq: string[] = [];
    const fillEmpty = async () => {
      for (const b of [...new Set([...reqCols, ...extraReq])]) {
        if ((await probe.value(p, nr2.row, b)) ?? '') continue;
        const v = await valueFor(b);
        if (v && (await probe.setByEditor(p, nr2.row, b, v)) && ((await probe.value(p, nr2.row, b)) ?? '')) { filled[b] = (await probe.value(p, nr2.row, b)) ?? ''; await p.waitForTimeout(400); continue; }
        // 기존 행 값이 이 행의 후보가 아니면(상위 변경 후) 편집 중 후보에서 실제 값(빈값·'-'·Common 제외)을 고른다
        const opened = await probe.startEdit(p, nr2.row, b); if (opened) await p.waitForTimeout(500);
        // 행 값으로 조회하는 콤보(DMF0005 Sales Plant = Sales Company 기준 SALES_PLANT_DM)는 후보가 늦게 온다 — 최대 6초 기다린다(2026-10-25)
        let cs: string[] = [];
        for (let k = 0; k < 12 && !cs.length; k++) { cs = ((await probe.candidates(p, nr2.row, b)) || []).filter(t => t && !/^(-|Common|ALL)$/i.test(t.trim())); if (!cs.length) await p.waitForTimeout(500); }
        await probe.cancelEdit(p);
        if (!cs.length) {
          // 콤보 목록이 없는 칸(DMF0005 Sales Company·Plant = dataMap 없음, 입력값을 화면 가드가 후보와 대조해 지운다 — 2026-10-25 실측)
          //   → 같은 행 값을 가장 많이 공유하는 기존 행(신규행 제외)의 값을 쓴다(실제로 쓰이는 조합 = 유효값)
          const sib = await p.evaluate(`(() => { const c = ${probe.CTL_SRC}; if (!c) return ''; const me = c.rows[${nr2.row}].dataItem; const ks = ['SCM_SITE_ID','SALES_COMPANY','DIVISION_ID','END_CUSTOMER','PROJECT_CODE'].filter(k => me[k]);
            let best = '', bs = -1; for (const r of c.rows) { const d = r.dataItem; if (!d || d === me || d[${JSON.stringify(b)}] == null || String(d[${JSON.stringify(b)}]) === '') continue;
              const s = ks.reduce((a, k) => a + (String(d[k]) === String(me[k]) ? (k === 'SCM_SITE_ID' ? 4 : k === 'SALES_COMPANY' ? 3 : 1) : 0), 0); if (s > bs) { bs = s; best = String(d[${JSON.stringify(b)}]); } } return best; })()`).catch(() => '') as string;
          const ok = !!sib && (await probe.setByEditor(p, nr2.row, b, sib)); await p.waitForTimeout(800);
          const got = (await probe.value(p, nr2.row, b)) ?? '';
          popNotes.push(`${b}: 편집 후보 없음(목록 없는 칸) → 기존 행 값 '${sib}' 입력 ${ok ? '' : '실패 '}→ '${got}'`);
          if (got) { filled[b] = got; continue; }
        }
        for (const c of cs.slice(0, 3)) if ((await probe.setByEditor(p, nr2.row, b, c)) && ((await probe.value(p, nr2.row, b)) ?? '')) { filled[b] = (await probe.value(p, nr2.row, b)) ?? ''; await p.waitForTimeout(400); break; }
      }
    };
    // 팝업으로만 입력하는 필수 칸(AS-IS CellDoubleClick 팝업) — 더블클릭 → 팝업 첫 행 선택 → OK. force = 값이 있어도 다시 고름(키 변경 후)
    const popNotes: string[] = [];
    let popEmpty = 0; // 이번 호출에서 후보 0행이던 팝업 수 — 키 변경 뒤 0행이면 이전 선택값(Route 등)이 낡은 채 남는다
    const fillPopups = async (force: boolean) => {
      popEmpty = 0;
      for (const b of [...new Set([...reqCols, ...extraReq])]) {
        // 팝업 경로가 있는 컬럼만 — 편집기를 열어 편집 가능 여부를 묻지 않는다(원천 편집 취소가 연쇄를 일으켜 값이 지워지는 C6 결함 회피)
        const viaPopup = pick(y => y.source === 'ASIS' && y.rule_id === 'G5' && new RegExp(String.raw`DefColumns\.${b}\b`).test(y.condition)).length > 0; // String.raw — 템플릿의 '\b' 는 백스페이스로 해석된다(2026-10-23 오탐)
        const cur = (await probe.value(p, nr2.row, b)) ?? '';
        // AS-IS 팝업 근거(G5)가 없어도 저장 키 칸(KEYSPEC)이 비어 있으면 팝업을 시도한다 — TO-BE FPTextModal(키인+팝업) 셀(DMF0082 Model, 2026-10-24)
        // 저장 키 칸 + 필수 안내가 지목한 칸(extraReq)은 G5 근거가 없어도 팝업을 시도 — DMF0005 Team(TeamModal 더블클릭, 2026-10-24)
        const keyCell = (!!KEYSPEC && KEYSPEC.keys.includes(b)) || extraReq.includes(b);
        if (!viaPopup && !(keyCell && !cur)) { if (!cur && !force) popNotes.push(`${b}: 값 없음 · 팝업 경로 없음`); continue; }
        if (!force && cur) continue;
        const pt = await probe.cellCenter(p, nr2.row, b); if (!pt) { popNotes.push(`${b}: 셀 위치 없음`); continue; }
        // 더블클릭 전 남은 대화상자·편집기를 닫는다 — 앞 팝업(Item 등)이 남아 있으면 그 팝업을 이 칸의 팝업으로 오인한다(DMF0005 Owner, 2026-10-25)
        const preDlg = await p.locator('[role="dialog"]:visible').count().catch(() => 0);
        if (preDlg) { await nscm.clearDialogs(); await p.keyboard.press('Escape').catch(() => undefined); await p.waitForTimeout(500); }
        await probe.cancelEdit(p).catch(() => undefined);
        await p.mouse.dblclick(pt.x, pt.y); await p.waitForTimeout(2_500);
        const dlg = p.locator('[role="dialog"]:visible').last(); // 보이는 것만(숨은 잔존 대화상자 오인 방지)
        const dlgTitle = ((await dlg.innerText({ timeout: 2_000 }).catch(() => '')) || '').split(/\r?\n/)[0].slice(0, 30);
        popNotes.push(`${b}: 더블클릭 전 대화상자 ${preDlg} · 열린 대화상자 '${dlgTitle}' 그리드 ${await dlg.locator('.wj-flexgrid').count().catch(() => 0)}`);
        const firstRow = dlg.locator('.wj-cells .wj-row').first();
        // 팝업 조회는 조건 반영 재조회가 늦게 온다(DMF0082 Item Popup 실측 14초 — 첫 요청은 빈 본문 {}). 행이 나올 때까지 최대 90초
        let nRows = 0;
        for (let k = 0; k < 180 && nRows === 0; k++) { nRows = await dlg.locator('.wj-cells .wj-row').count().catch(() => 0); if (!nRows) await p.waitForTimeout(500); }
        // 열자마자 목록을 안 채우는 팝업(DMF0082 Item Popup) — 팝업 안 Search 를 눌러 조회한 뒤 고른다(2026-10-24)
        if (nRows === 0) {
          const sb = dlg.getByRole('button', { name: /^(Search|조회)(\(F5\))?$/i }).first();
          if (await sb.isVisible().catch(() => false)) {
            await sb.click().catch(() => undefined);
            for (let k = 0; k < 40 && nRows === 0; k++) { await p.waitForTimeout(500); nRows = await dlg.locator('.wj-cells .wj-row').count().catch(() => 0); }
          }
        }
        if (nRows > 0 || (await firstRow.isVisible().catch(() => false))) { // 2단 팝업(Owner)은 첫 행 isVisible 이 거짓으로 나와 선택 단계를 통째로 건너뛰었다(2026-10-25) — 행 수로 판정
          // 2단 이동형 팝업(후보 그리드 → 선택 그리드, OK = 선택 그리드 확정 — DMF0005 OwnerModal.tsx handleSubmit, 2026-10-24 실측)
          //   후보 행 더블클릭 = 선택 그리드로 이동. 이동 후 후보 행을 다시 클릭+OK 하면 안 된다(선택은 그대로라 무해하지만 증거를 남긴다)
          const grids = dlg.locator('.wj-flexgrid');
          if ((await grids.count().catch(() => 0)) >= 2) {
            const cnt = async () => grids.evaluateAll(gs => gs.map(g => g.querySelectorAll('.wj-cells .wj-row').length)).catch(() => [] as number[]);
            const before = await cnt();
            await grids.nth(0).locator('.wj-cells .wj-row').first().locator('.wj-cell').nth(1).dblclick({ timeout: 3_000 }).catch(() => undefined);
            await p.waitForTimeout(800);
            const after = await cnt();
            const okB = dlg.getByRole('button', { name: /^(OK|확인)$/i }).first();
            if (await okB.isVisible().catch(() => false)) await okB.click().catch(() => undefined);
            await p.waitForTimeout(1_500);
            popNotes.push(`${b}: 2단 팝업 선택 그리드 ${before[1] ?? '?'}→${after[1] ?? '?'} · OK 후 대화상자 ${(await dlg.isVisible().catch(() => false)) ? '남음' : '닫힘'}`);
          }
          // 다중 선택(체크박스) 팝업 — 첫 행 체크 후 OK
          const chk = firstRow.locator('input[type="checkbox"]').first();
          if (await dlg.isVisible().catch(() => false) && await chk.isVisible().catch(() => false)) {
            await chk.check({ force: true }).catch(() => chk.click().catch(() => undefined)); await p.waitForTimeout(300);
            const okB = dlg.getByRole('button', { name: /^(OK|확인|Apply|적용|Select|선택)$/i }).first();
            if (await okB.isVisible().catch(() => false)) await okB.click().catch(() => undefined);
            await p.waitForTimeout(1_000);
          }
          // 행 더블클릭 = 적용(TO-BE 팝업 dblclick → handleApply). 남아 있으면 행 선택 후 OK
          if (await dlg.isVisible().catch(() => false)) { await firstRow.locator('.wj-cell').nth(1).dblclick({ timeout: 3_000 }).catch(() => undefined); await p.waitForTimeout(1_200); }
          if (await dlg.isVisible().catch(() => false)) {
            await firstRow.locator('.wj-cell').nth(1).click({ timeout: 3_000 }).catch(() => undefined); await p.waitForTimeout(300);
            const okBtn = dlg.getByRole('button', { name: /^(OK|확인|Apply|적용|Select|선택)$/i }).first();
            if (await okBtn.isVisible().catch(() => false)) await okBtn.click().catch(() => undefined);
            await p.waitForTimeout(1_200);
          }
        }
        // 후보 0행이면 OK 로 닫히지 않는다 — 그때만 Close 로 닫는다(2026-10-23 실측: 빈 Route 팝업이 Save 를 가림).
        //   행을 고른 뒤 남은 대화상자는 선택 확인일 수 있어 아래 clearDialogs(OK)로 받아들인다(Close 로 닫으면 선택이 취소됨)
        if (nRows === 0 && (await dlg.isVisible().catch(() => false))) {
          const closeBtn = dlg.getByRole('button', { name: /^(Close|닫기|Cancel|취소)$/i }).first();
          if (await closeBtn.isVisible().catch(() => false)) await closeBtn.click().catch(() => undefined); else await p.keyboard.press('Escape');
          await p.waitForTimeout(500);
        }
        await nscm.clearDialogs();
        if (nRows === 0) popEmpty++;
        const got = (await probe.value(p, nr2.row, b)) ?? ''; if (got) filled[b] = got;
        popNotes.push(`${b}: 팝업 행 ${nRows} → '${got}'`);
      }
    };
    // 재시도용 키 콤보 목록은 팝업 선택 '전에' 만든다 — 팝업 뒤에 편집기를 열었다 닫으면 연쇄 처리로 값이 비워졌다(2026-10-23 실측 To Site 공란)
    const keyCombos: string[] = [];
    for (const b of reqCols) { if (b === 'DIVISION_ID') continue; if (filled[b] && (await probe.candidates(p, nr2.row, b))) keyCombos.push(b); } // 편집기를 열지 않는다(C6 결함 회피 — 원천 편집 취소로 대상이 지워짐)
    await fillPopups(false);
    if (markerCol) { await probe.setByEditor(p, nr2.row, markerCol, marker); filled[markerCol] = marker; }
    const keyCol = markerCol || Object.keys(filled).find(b => filled[b] === marker) || '';
    // 저장 실행(실제 저장) — 대화상자는 읽은 뒤 닫는다
    // 저장 직전 그리드 값 = 실제 전송값(팝업·연쇄가 바꾼 칸 포함). F6 값 보존은 이 값과 비교한다(입력 시점 값과 비교하면 팝업이 채운 칸을 '변형'으로 오판)
    let preSave: Record<string, string> = {};
    // 저장 전 빈 키 확보 — 키가 원장에 있으면 vary 컬럼(Sales Site 등)을 다른 후보로 바꿔 빈 키를 찾는다. 못 찾으면 저장하지 않는다(기존 원장 보호)
    const keyVals = async () => Object.fromEntries(await Promise.all((KEYSPEC?.keys || []).map(async k => [k, (await probe.value(p, nr2.row, k)) ?? ''] as const)));
    let guardNote = '';
    // 팝업 전용 칸에 정해진 값 넣기 — 팝업 검색칸(Model 등)에 값을 입력하고 Search 로 좁혀 그 값의 행을 고른다(전체 목록 대기 회피)
    const popupPick = async (b: string, value: string) => {
      const pt = await probe.cellCenter(p, nr2.row, b); if (!pt) return `${b}: 셀 위치 없음`;
      // Esc 금지 — 직전 편집(Sales Site)을 취소해 값이 되돌아갔다(2026-10-24). 디버그에서 열린 방식 그대로 더블클릭만, 안 열리면 위치를 다시 구해 3회
      const dlg = p.locator('[role="dialog"]:visible').last();
      let opened = false;
      for (let tr = 0; tr < 3 && !opened; tr++) {
        const pp = (await probe.cellCenter(p, nr2.row, b)) || pt;
        await p.mouse.dblclick(pp.x, pp.y);
        for (let k = 0; k < 12 && !opened; k++) { opened = (await p.locator('[role="dialog"]:visible').count().catch(() => 0)) > 0; if (!opened) await p.waitForTimeout(500); }
      }
      if (!opened) {
        await p.screenshot({ path: path.join(DIR, `_popup_fail_${b}.png`) }).catch(() => undefined);
        const st = await p.evaluate(() => ({ active: (document.activeElement as HTMLElement | null)?.className?.toString().slice(0, 80), dialogs: document.querySelectorAll('[role="dialog"]').length }));
        return `${b}: 팝업 안 열림(3회 · 캡처 _popup_fail_${b}.png · ${JSON.stringify(st)})`;
      }
      const inputs = dlg.locator('input[type="text"]:not([disabled]):not([readonly])');
      const n = await inputs.count().catch(() => 0);
      if (n) { const box = inputs.nth(n - 1); await box.fill(value).catch(() => undefined); }
      const sb = dlg.getByRole('button', { name: /^(Search|조회)(\(F5\))?$/i }).first();
      if (await sb.isVisible().catch(() => false)) await sb.click().catch(() => undefined);
      const row = dlg.locator('.wj-cells .wj-row').filter({ hasText: value }).first();
      let ok = false; for (let k = 0; k < 120 && !ok; k++) { ok = await row.isVisible().catch(() => false); if (!ok) await p.waitForTimeout(500); }
      if (!ok) { const close = dlg.getByRole('button', { name: /^(Close|닫기|Cancel|취소)$/i }).first(); await close.click().catch(() => p.keyboard.press('Escape')); return `${b}: 팝업에 '${value}' 행 없음`; }
      await row.locator('.wj-cell').nth(1).click().catch(() => undefined); await p.waitForTimeout(300);
      const okBtn = dlg.getByRole('button', { name: /^(OK|확인|Apply|적용|Select|선택)$/i }).first();
      if (await okBtn.isVisible().catch(() => false)) await okBtn.click().catch(() => undefined); else await row.locator('.wj-cell').nth(1).dblclick().catch(() => undefined);
      await p.waitForTimeout(1_000); await nscm.clearDialogs();
      const got = (await probe.value(p, nr2.row, b)) ?? ''; if (got) filled[b] = got;
      return `${b}: 팝업 '${value}' → '${got}'`;
    };
    // 팝업 목록에서 '빈 키'인 행 고르기 — 팝업이 실제로 보여 준 후보(사용자가 고를 수 있는 값)만 쓴다.
    //   DB 추천(SITE_ITEM)과 팝업 후보 원천이 달라 추천 Model 이 팝업에 없던 사례(2026-10-24 DMF0082) 대응
    const popupPickFree = async (b: string, isFree: (code: string) => boolean) => {
      const pt = await probe.cellCenter(p, nr2.row, b); if (!pt) return `${b}: 셀 위치 없음`;
      const dlg = p.locator('[role="dialog"]:visible').last();
      let opened = false;
      for (let tr = 0; tr < 3 && !opened; tr++) {
        const pp = (await probe.cellCenter(p, nr2.row, b)) || pt; await p.mouse.dblclick(pp.x, pp.y);
        for (let k = 0; k < 12 && !opened; k++) { opened = (await p.locator('[role="dialog"]:visible').count().catch(() => 0)) > 0; if (!opened) await p.waitForTimeout(500); }
      }
      if (!opened) return `${b}: 팝업 안 열림`;
      let n = 0; for (let k = 0; k < 180 && !n; k++) { n = await dlg.locator('.wj-cells .wj-row').count().catch(() => 0); if (!n) await p.waitForTimeout(500); }
      const close = async () => { const c = dlg.getByRole('button', { name: /^(Close|닫기|Cancel|취소)$/i }).first(); if (await c.isVisible().catch(() => false)) await c.click().catch(() => undefined); await p.waitForTimeout(500); };
      if (!n) { await close(); return `${b}: 팝업 0행`; }
      const heads = (await dlg.locator('.wj-colheaders .wj-row').last().locator('.wj-cell').allInnerTexts().catch(() => [] as string[])).map(t => t.trim());
      const ci = heads.findIndex(h => /^(Model|Item|ITEM|모델|품목)/i.test(h));
      if (ci < 0) { await close(); return `${b}: 팝업 Model 컬럼 없음(헤더 ${heads.slice(0, 8).join('|')})`; }
      const rowsL = dlg.locator('.wj-cells .wj-row');
      const cnt = Math.min(await rowsL.count(), 40); let tested = 0;
      for (let r = 0; r < cnt; r++) {
        const code = ((await rowsL.nth(r).locator('.wj-cell').nth(ci).innerText().catch(() => '')) || '').trim();
        if (!code || code.startsWith('-')) continue; tested++; // '-' 로 시작 = 빈값 센티널 계열 코드는 고르지 않는다(2026-10-24 DMF0005 '-M01-M01…')
        if (!isFree(code)) continue;
        await rowsL.nth(r).locator('.wj-cell').nth(ci).click().catch(() => undefined); await p.waitForTimeout(300);
        const okBtn = dlg.getByRole('button', { name: /^(OK|확인|Apply|적용|Select|선택)$/i }).first();
        if (await okBtn.isVisible().catch(() => false)) await okBtn.click().catch(() => undefined); else await rowsL.nth(r).locator('.wj-cell').nth(ci).dblclick().catch(() => undefined);
        await p.waitForTimeout(1_000); await nscm.clearDialogs();
        const got = (await probe.value(p, nr2.row, b)) ?? ''; if (got) filled[b] = got;
        return `${b}: 팝업 ${n}행 중 ${tested}번째 '${code}' 빈 키 → '${got}'`;
      }
      await close();
      return `${b}: 팝업 ${n}행 중 ${tested}건 모두 기존 원장 있음`;
    };
    const ctxVals = async () => {
      const ks = [...new Set([...(KEYSPEC?.keys || []), 'END_CUSTOMER', 'DEPT_ID', 'PROJECT_CODE'])];
      return Object.fromEntries(await Promise.all(ks.map(async k => [k, (await probe.value(p, nr2.row, k)) ?? ''] as const)));
    };
    const ensureFreeKey = async (): Promise<boolean> => {
      if (!KEYSPEC) return true;
      let g = guard('check', await keyVals()); const seen: string[] = [`초기 ${JSON.stringify(await keyVals())}: ${g.why}`];
      if (!g.free) {
        // DB 가 추천한 빈 키(대상 테이블 전부 0건)를 화면에 넣는다 — 편집 가능 칸은 편집기, 팝업 전용 칸은 팝업 검색
        // 추천 조건 칸(End Customer 등)이 비어 있으면 기존 행 값으로 먼저 채운다(DMF0005 신규행 End Customer 공란 → 추천 0건, 2026-10-24)
        for (const k of ['END_CUSTOMER', 'DEPT_ID', 'PROJECT_CODE']) if (!((await probe.value(p, nr2.row, k)) ?? '') && !extraReq.includes(k) && (await probe.colInfo(p, k))) extraReq.push(k);
        await fillEmpty();
        const sg = guard('suggest', await ctxVals()) as { keys?: Record<string, string>[]; why?: string };
        seen.push(`추천 ${sg.keys?.length ?? 0}건`);
        // 편집 가능한 키(Sales Site)는 추천값으로, 팝업 전용 키(Model)는 팝업 목록에서 빈 키인 행으로 고른다
        const editKeys: string[] = []; const popKeys: string[] = [];
        for (const k of KEYSPEC.keys) { const opened = await probe.startEdit(p, nr2.row, k); await probe.cancelEdit(p); (opened ? editKeys : popKeys).push(k); }
        const seenCombo = new Set<string>();
        for (const key of (sg.keys || [])) {
          const combo = editKeys.map(k => String(key[k] ?? '')).join('|'); if (seenCombo.has(combo)) continue; seenCombo.add(combo);
          if (seenCombo.size > 4) break;
          const steps: string[] = [];
          for (const k of editKeys) {
            const want = String(key[k] ?? ''); if (!want || ((await probe.value(p, nr2.row, k)) ?? '') === want) continue;
            if (await probe.setByEditor(p, nr2.row, k, want)) { await p.waitForTimeout(600); steps.push(`${k}=편집 '${want}'`); }
          }
          for (const k of popKeys) {
            const base = await keyVals();
            steps.push(await popupPickFree(k, code => !!guard('check', { ...base, [k]: code }).free));
          }
          await fillEmpty();
          g = guard('check', await keyVals());
          seen.push(`${steps.join(', ')} → ${JSON.stringify(await keyVals()).slice(0, 100)}: ${String(g.why).slice(0, 40)}`);
          if (g.free) break;
        }
      }
      guardNote = seen.join(' · ').slice(0, 1500);
      if (!g.free) return false;
      const rec = guard('record', await keyVals());
      guardNote += rec.ok ? ' · 저장 전 키·스냅샷 기록' : ` · 기록 실패 ${rec.why}`;
      return !!rec.ok;
    };
    const doSave = async () => {
      if (markerCol && ((await probe.value(p, nr2.row, markerCol)) ?? '') !== marker) await probe.setByEditor(p, nr2.row, markerCol, marker);
      preSave = Object.fromEntries(await Promise.all(Object.keys(filled).map(async b => [b, (await probe.value(p, nr2.row, b)) ?? ''] as const)));
      const b0 = nscm.calls.length; const dlg: string[] = []; const ts: string[] = [];
      const grab = async () => { for (const t of await p.locator('.MuiSnackbar-root, [role="alert"], [role="status"], .Toastify__toast').allInnerTexts().catch(() => [] as string[])) { const v = t.replace(/\s+/g, ' ').trim(); if (v && !ts.includes(v)) ts.push(v); } };
      const tk = setInterval(() => { void grab(); }, 300);
      await nscm.subButton('Save').click({ timeout: 10_000 });
      for (let k = 0; k < 8; k++) { await p.waitForTimeout(1_000); const m = await nscm.alertText(); if (!m) { if (k >= 3) break; continue; } dlg.push(m.replace(/\s+/g, ' ').slice(0, 160)); await nscm.closeAlert('ok'); }
      await p.waitForLoadState('networkidle', { timeout: 30_000 }).catch(() => undefined); await p.waitForTimeout(1_000); await grab(); clearInterval(tk);
      return { saves: nscm.calls.slice(b0).filter(c => /SAVE|INS|UPD|DEL/i.test(c.btn)), msg: [...dlg, ...ts].join(' / ').slice(0, 300) };
    };
    // 키 중복(기간 중복 등 업무 검증)으로 거절되면 키 콤보 하나를 다른 후보로 바꾸고 팝업을 다시 골라 재저장(최대 4회). 거절된 저장은 DB 에 남지 않는다
    const tries: string[] = [`키 콤보 [${keyCombos.join(',')}]`];
    if (!(await ensureFreeKey())) {
      for (const rid of ['F1', 'F2', 'F4', 'F6']) for (const y of fRows(rid)) put(y.row_id, '판정필요', `빈 키 없음 — 기존 사내 원장 보호를 위해 저장 생략 · ${guardNote}`);
      return;
    }
    let att = await doSave();
    // 바꿀 순서 = 팝업 인자로 쓰이지 않는 키 먼저(Incoterms 등 — 바꿔도 팝업 후보(Route)가 유지된다) → 팝업 인자 키(두 번째부터 — 첫째 원천을 바꾸면 연쇄로 뒤 키가 지워진다) → 첫째.
    //   Y/N 류(후보 ≤2)는 키가 아닐 가능성이 커 제외. 2026-10-23 실측: To Site 만 바꾸면 Route 후보 0행이 반복돼 저장 불가
    const popArgs = new Set(pick(y => y.source === 'ASIS' && y.rule_id === 'G5').flatMap(y => [...y.condition.matchAll(/DefColumns\.([A-Z0-9_]+)/g)].map(m => m[1])));
    const order = [...keyCombos.slice(1), keyCombos[0]].filter(Boolean);
    const keyOrder: string[] = [];
    for (const b of order) if ((((await probe.candidates(p, nr2.row, b)) || []).length) > 2) keyOrder.push(b);
    keyOrder.sort((a, b) => Number(popArgs.has(a)) - Number(popArgs.has(b)));
    tries.push(`재시도 키 순서 [${keyOrder.join(',')}] (팝업 인자 ${[...popArgs].join(',') || '없음'})`);
    let nSaved = 0; let ki = 0; const used: Record<string, number> = {};
    // 필수·업무 검증 안내에서 컬럼 헤더 읽기 — '[X] value is required' · 'X* 를 Common으로 등록 할 수 없습니다'(DMF0082 Cell Prod Site, 2026-10-24)
    const reqNamed = (m: string) => [...[...m.matchAll(/\[([^\]]+)\]\s*(?:value is required|은\(는\) 필수|필수)/gi)].map(x => x[1].trim()),
      ...[...m.matchAll(/(?:^|[\s:/])([A-Za-z][\w .()/-]{1,40}?)\*\s*(?:를|을|는|가|is |must )/g)].map(x => x[1].trim())]; // JS 의 단어경계 는 한글 조사 뒤 경계를 못 잡아 조사로 끝을 정한다(2026-10-24)
    // 수량·금액 필요 안내(DMF0082 'Quantity or price must be entered for at least one day') → 신규행 숫자 칸(기간 버킷 우선) 하나에 1 입력
    const qtyFilled: string[] = [];
    const fillQty = async () => {
      const cand: string[] = [];
      for (const b of (await probe.visibleBindings(p)) || []) {
        if (filled[b] || qtyFilled.includes(b)) continue;
        const info = await probe.colInfo(p, b); if (!info || info.dataType !== 2) continue;
        cand.push(b);
      }
      cand.sort((x, y) => Number(!/\d{6,8}|^[DWM]_/.test(x)) - Number(!/\d{6,8}|^[DWM]_/.test(y)));
      for (const b of cand) { if (await probe.setByEditor(p, nr2.row, b, '1')) { qtyFilled.push(b); filled[b] = (await probe.value(p, nr2.row, b)) ?? '1'; return b; } }
      return '';
    };
    for (let a = 0; a < 16 && nSaved < 8; a++) { // 필수 안내가 칸마다 차례로 나온다(DMF0005 Team→Cust Group→Owner) — 재저장 8회까지
      const nrNow = await probe.findRow(p, 'new'); if (!nrNow) { tries.push('재시도 중단: 신규행 없음(저장 후 그리드 갱신)'); break; }
      nr2.row = nrNow.row;
      // 필수 안내로 거절 → 지목된 칸(헤더명 → 바인딩)을 채워 같은 키로 재저장(2026-10-23 실측: To Site 변경 연쇄로 SSP Incoterms 공란)
      const missing = reqNamed(att.msg);
      if (missing.length) {
        for (const h of missing) for (const b of await probe.bindingsByHeader(p, h)) if (!extraReq.includes(b)) extraReq.push(b); // 같은 헤더의 표시용·편집용 컬럼 모두
        await fillEmpty(); await fillPopups(false);
        tries.push(`시도${a + 1}: 필수 안내 [${missing.join(',')}] → 빈 칸 채워 재저장`);
        att = await doSave(); nSaved++; continue;
      }
      if (/quantity|수량|price|가격|at least one/i.test(att.msg) && !att.saves.length) {
        const qb = await fillQty();
        if (qb) { tries.push(`시도${a + 1}: 수량 안내 → ${qb}=1 입력 후 재저장`); att = await doSave(); nSaved++; continue; }
      }
      if (!/중복|duplicate/i.test(att.msg) || !keyOrder.length) break;
      if (ki >= keyOrder.length) { tries.push('재시도 중단: 바꿀 키 후보 소진'); break; }
      const kc = keyOrder[ki];
      const k = (used[kc] = (used[kc] ?? -1) + 1);
      if (k >= 2) ki++; // 키마다 후보 3개까지
      const prev = filled[kc] ?? '';
      const cands = [...new Set(((await probe.candidates(p, nr2.row, kc)) || []).filter(v => v && v !== prev))];
      const withCity = new Set(await probe.candidatesWithField(p, kc, 'CITY'));
      const pool = cands.filter(v => withCity.has(v)).length ? cands.filter(v => withCity.has(v)) : cands;
      const nv = pool[(k * 7 + 3) % Math.max(pool.length, 1)] || '';
      if (!nv || !(await probe.setByEditor(p, nr2.row, kc, nv))) { tries.push(`시도${a + 1}: ${kc} 새 값 입력 실패(후보 ${cands.length})`); continue; }
      filled[kc] = (await probe.value(p, nr2.row, kc)) ?? nv; await p.waitForTimeout(600);
      await fillPopups(true);
      // 바꾼 키 조합에 팝업 후보가 없으면 이전 선택값(낡은 Route 등)으로 저장하지 않는다 — 키를 원래 값으로 되돌리고 팝업을 다시 골라 다음 후보로(2026-10-23 실측: To Site 변경 후 Route 0행인데 740 으로 저장)
      if (popEmpty) {
        tries.push(`시도${a + 1}: ${kc}='${nv}' → 팝업 후보 0행 — 저장 생략·원래 값 '${prev}' 복원`);
        if (prev) { await probe.setByEditor(p, nr2.row, kc, prev); filled[kc] = (await probe.value(p, nr2.row, kc)) ?? prev; await p.waitForTimeout(600); await fillEmpty(); await fillPopups(true); }
        ki++; // 이 키는 바꾸면 팝업 후보가 사라진다 — 다음 키로
        continue;
      }
      await fillEmpty(); // 키 변경 연쇄로 지워진 필수 칸 복구
      if (KEYSPEC) {
        const g = guard('check', await keyVals());
        if (!g.free) { tries.push(`시도${a + 1}: ${kc}='${nv}' → 가드 거절(${g.why?.slice(0, 60)}) — 저장 생략`); continue; }
        guard('record', await keyVals());
      }
      tries.push(`시도${a + 1}: ${kc}='${nv}' 저장 (이전 '${att.msg.slice(0, 60)}')`);
      att = await doSave(); nSaved++;
    }
    const saves = att.saves;
    const msg2 = att.msg + (tries.length ? ` · ${tries.join(' · ')}` : '');
    const sqlErr2 = /ORA-\d+|SQL Error|SQLException|Exception/i.test(att.msg + ' ' + saves.map(c => c.res || '').join(' '));
    // 업무 검증 거부(RAISE_INVALID — DMF0005 '[모델] Invalid Item ID !', '…처리가 불가합니다')는 HTTP 200 이어도 실패다(2026-10-25 'Save 1회로 저장 성공' 오판).
    //   결과 커서 CODE 가 0 이 아니면 실패(메모리 call-proc 성공판정 = 결과커서 CODE)
    const resCodeFail = saves.some(c => /"(?:CODE|code)"\s*:\s*"?-?[1-9]\d*"?/.test(c.res || ''));
    const ok2 = saves.length > 0 && saves.every(c => c.status < 400) && !sqlErr2 && !resCodeFail && !/fail|실패|오류|error|중복|duplicate|없습니다|invalid|불가|않습니다|존재하지/i.test(att.msg);
    const changedPre = Object.keys(preSave).filter(k => preSave[k] !== filled[k]).map(k => `${k} '${filled[k]}'→'${preSave[k]}'`); // 입력 후 저장 전에 팝업·연쇄가 바꾼 칸(AS-IS 동작 여부는 asis 근거로 판단)
    const savedDesc = `${guardNote ? '[가드 ' + guardNote + '] ' : ''}전송값 ${Object.entries(preSave).map(([k, v]) => k + '=' + v).join(', ').slice(0, 260)}${changedPre.length ? ' · 입력 후 저장 전 변경 ' + changedPre.join(', ') : ''}${popNotes.length ? ' · 팝업 ' + popNotes.slice(-6).join(' / ') + (popNotes.length > 3 ? ` (외 ${popNotes.length - 3}회)` : '') : ''} · 저장 요청 ${saves.length}건 · 메시지 '${msg2}'`;
    for (const y of fRows('F4')) put(y.row_id, sqlErr2 ? 'FAIL' : (saves.length ? 'PASS' : '판정필요'), sqlErr2 ? `저장 중 SQL 오류 노출 — ${savedDesc}` : `SQL 오류 없음 — ${savedDesc}`);
    // 실패 사유를 문장으로(2026-10-27 사용자: 판정필요 금지 · 어떤 오류인지 읽히게) — HTTP 상태 / SQL 오류 / 결과 CODE / 오류성 메시지 / 응답 앞부분
    const failWhy = [saves.some(c => c.status >= 400) ? `저장 호출 HTTP ${saves.map(c => c.status).join('/')}` : '', sqlErr2 ? 'SQL 오류 노출' : '', resCodeFail ? '결과 커서 CODE≠0' : '', /fail|실패|오류|error|중복|duplicate|없습니다|invalid|불가|않습니다|존재하지/i.test(att.msg) ? `화면 메시지 '${att.msg.slice(0, 140)}'` : ''].filter(Boolean).join(' · ') || `저장 호출 ${saves.length}건 중 성공 판정 조건 미충족`;
    const resHead = saves.map(c => (c.res || '').replace(/\s+/g, ' ').slice(0, 220)).filter(Boolean).join(' | ');
    if (!saves.length) {
      for (const y of fRows('F2')) put(y.row_id, 'FAIL', `필수값을 채우고 Save 를 눌렀지만 저장 요청(call-proc)이 서버로 나가지 않음${att.msg ? ` — 화면 메시지 '${att.msg.slice(0, 160)}'` : ''} · ${savedDesc}`);
      for (const rid of ['F1', 'F6']) for (const y of fRows(rid)) put(y.row_id, 'FAIL', `저장 요청이 나가지 않아 DB 반영 확인 불가${att.msg ? ` — 화면 메시지 '${att.msg.slice(0, 160)}'` : ''} · ${savedDesc}`);
      return;
    }
    for (const y of fRows('F2')) put(y.row_id, ok2 ? 'PASS' : 'FAIL', ok2 ? `Save 1회로 저장 성공 — ${savedDesc}` : `저장 실패 — ${failWhy} · 응답: ${resHead || '(없음)'} · ${savedDesc}`);
    if (!ok2) { for (const rid of ['F1', 'F6']) for (const y of fRows(rid)) put(y.row_id, 'FAIL', `저장 실패(${failWhy})로 DB 반영 확인 불가 · 응답: ${resHead || '(없음)'} · ${savedDesc}`); return; }
    // 재조회 → 마커 행 존재(F1) · 값 보존(F6)
    const savedKeys = KEYSPEC ? lastRecordedKeys : {}; // 저장 직전 가드가 기록한 키 — 저장 뒤엔 신규행 자리가 다른 행이 된다
    await nscm.search(); for (let k = 0; k < 240 && (await probe.rowCount(p)) <= 0; k++) await p.waitForTimeout(500);
    await p.waitForLoadState('networkidle', { timeout: 20_000 }).catch(() => undefined); await p.waitForTimeout(1_000);
    // 행 번호는 c.rows 기준(probe.value 와 같은 번호)으로 찾는다 — columnValues 인덱스는 다른 행일 수 있다(2026-10-25)
    const markerHit = keyCol ? await probe.findRowBy(p, { [keyCol]: marker }) : -1;
    let hit = markerHit;
    let how = `마커 '${marker}'(${keyCol})`;
    if (hit < 0 && KEYSPEC) {
      // 저장 키(cleanup_spec keys — 가드가 빈 키로 확인한 값)로 먼저 찾는다. 필수 칸 전체 일치는 저장 후 표시가 바뀌는 칸
      //   (DMF0005 Team·Owner 등)에서 놓친다(2026-10-25 저장 성공·DB 2행 반영인데 '허위 성공 의심' 오판)
      const kv = savedKeys as Record<string, string>;
      const ks = KEYSPEC.keys.filter(k => kv[k]);
      if (ks.length) {
        const r = await probe.findRowBy(p, Object.fromEntries(ks.map(k => [k, kv[k]])));
        if (r >= 0) { hit = r; how = `저장 키 ${ks.map(k => k + '=' + kv[k]).join(', ')} 일치 행`; }
      }
    }
    if (hit < 0) {
      // 마커 칸이 없거나 덮어써졌으면 필수 키 값 전부가 일치하는 행으로 찾는다(마커 칸 제외)
      const keys = Object.keys(preSave).filter(b => b !== markerCol && reqCols.includes(b) && preSave[b]);
      const n = await probe.rowCount(p);
      for (let r = 0; r < n && keys.length; r++) { let all = true; for (const b of keys) if (((await probe.value(p, r, b)) ?? '') !== preSave[b]) { all = false; break; } if (all) { hit = r; how = `필수 키 ${keys.length}칸 일치 행(마커 칸 ${keyCol || '없음'} 미일치)`; break; } }
    }
    if (hit < 0) {
      for (const y of fRows('F1')) put(y.row_id, 'FAIL', `저장 성공 메시지 후 재조회에 마커 '${marker}'(${keyCol || '마커 칸 없음'})·필수 키 일치 행 모두 없음 — 허위 성공 의심 · ${savedDesc}`);
      for (const y of fRows('F6')) put(y.row_id, '판정필요', '저장 행을 찾지 못해 값 보존 확인 불가');
      return;
    }
    for (const y of fRows('F1')) put(y.row_id, 'PASS', `저장 후 재조회에 ${how} 행 존재 — DB 반영 확인`);
    // 값 보존 — 저장 직전 그리드 값(전송값) ↔ 재조회 값. 다르면 FAIL 이되, 저장 SP 가 AS-IS 에서도 바꾸는 칸인지는 사람 확인이 필요해 근거를 남긴다
    const diffs: string[] = [];
    for (const [b, v] of Object.entries(preSave)) { if (b === markerCol && hit !== markerHit) continue; const got = (await probe.value(p, hit, b)) ?? ''; if (got !== v) diffs.push(`${b}: 저장 직전 '${v}' → 재조회 '${got}'`); }
    for (const y of fRows('F6')) put(y.row_id, diffs.length ? 'FAIL' : 'PASS', diffs.length ? `저장 후 값 변형 — ${diffs.join(' · ')} (기준 = 저장 직전 그리드 값)` : `저장 직전 값 ${Object.keys(preSave).length}칸이 재조회에 그대로${changedPre.length ? ` (입력 후 저장 전 변경 ${changedPre.join(', ')} — 팝업·연쇄 결과, AS-IS 동일 여부는 ASIS 행 참조)` : ''}`);
    // 정리 — 저장된 마커 행 삭제(Delete → Save). 화면이 신규행만 삭제하면 '정리 필요'로 남긴다
    let cleaned = false;
    // 화면 삭제는 시간 여유가 있을 때만 — 저장 행을 화면에서 못 지우는 화면(BOD, AS-IS 도 신규행만 삭제)에서 테스트 제한시간을 다 써 끊겼다(2026-10-24).
    //   남은 행은 run_verify 의 cleanup_marker.py 가 사내 DB 에서 백업 후 정리한다
    if (Date.now() - t0 < 7 * 60_000 && await nscm.subButtonVisible('Delete')) {
      const pt = await probe.cellCenter(p, hit, keyCol); if (pt) await p.mouse.click(pt.x, pt.y);
      await nscm.subButton('Delete').click({ timeout: 10_000 }).catch(() => undefined); await p.waitForTimeout(800); await nscm.closeAlert('ok');
      await nscm.subButton('Save').click({ timeout: 10_000 }).catch(() => undefined);
      for (let k = 0; k < 6; k++) { await p.waitForTimeout(1_000); if (!(await nscm.closeAlert('ok')) && k >= 2) break; }
      await nscm.search(); for (let k = 0; k < 120 && (await probe.rowCount(p)) <= 0; k++) await p.waitForTimeout(500); await p.waitForTimeout(1_000);
      cleaned = !((await probe.columnValues(p, keyCol)) || []).includes(marker);
    }
    // 정리 결과는 F1 증거에 덧붙인다(원장에 없는 행 ID 로 남기면 판정기가 버린다)
    for (const y of fRows('F1')) { const r0 = results.filter(r => r.row_id === y.row_id).pop(); if (r0) r0.evidence = (r0.evidence + (cleaned ? ` · 정리 완료(마커 행 삭제·저장·재조회 부재 확인)` : ` · 화면 삭제 안 됨(저장 행 화면 삭제 불가·실패·시간 초과) — 마커 '${marker}'(${keyCol}) 행은 cleanup_marker.py 가 사내 DB 에서 정리`)).slice(0, 900); }
  });

  // K3 그리드 조작(2026-10-28) — 단위테스트 결함(공통 Ctrl+클릭 다중선택·헤더 클릭 열 선택 · DMF0020 Copy·Hide Column · DMF0035 F5 조회)의 같은 유형을 이 화면 메인 그리드에서 실측.
  //   기대 = 확정 요구(CONFIRMED K3: Ctrl+클릭 비연속 다중 선택 · 헤더 클릭 = 열 전체 선택) + 공용 DataGrid 사양(MultiRange · 우클릭 Copy/Hide Column · F5 = 조회, 새로고침 아님)
  //   항목별 행 매칭: 원장 K3 행의 대상·기대 문구 → Ctrl / 헤더 / Copy / Hide / F5. 그 외 문구(Sort/Filter 동적 컬럼·팝업 No. 컬럼·붙여넣기 Team 코드)는 이 테스트 판정 대상 아님
  test('그리드 조작(K3) — Ctrl+클릭 다중선택·헤더 클릭 열 선택·Copy(Ctrl+C·우클릭)·Hide Column·F5 조회', async ({ nscm }) => {
    test.setTimeout(240_000);
    const p = nscm.page;
    const k3 = pick(x => x.rule_id === 'K3');
    if (!k3.length) return;
    const r = await nscm.openScreen(ID);
    if (!r.authorized) { for (const x of k3) put(x.row_id, 'ERROR', '화면 권한 없음 — 판정 불가'); return; }
    await p.context().grantPermissions(['clipboard-read', 'clipboard-write']).catch(() => undefined);
    await nscm.search();
    for (let k = 0; k < 120 && (await probe.rowCount(p)) < 3; k++) await p.waitForTimeout(500);
    await nscm.clearDialogs();
    const n = await probe.rowCount(p);
    if (n < 3) { for (const x of k3) put(x.row_id, '판정필요', `조회 결과 ${n}행 — 다중 선택 시험에 3행 이상 필요(조회조건 바꿔 재실행)`); return; }
    const CTLX = probe.CTL_SRC;
    // 시험 열 = 보이는 binding 컬럼 중 상태(CRUD)·체크 열이 아니고 0~2행이 병합되지 않은 컬럼(병합 셀은 클릭이 병합 범위를 잡아 다중 선택 판정이 흐려진다 —
    //   2026-10-28 SCP0007 CUSTOMER = 병합 컬럼) · 고정 열이 아닌 것 우선
    const ci = await p.evaluate(`(() => { const c = ${CTLX}; const o = []; for (let i = 0; i < c.columns.length; i++) { const x = c.columns[i];
      if (!x.binding || x.visible === false || x.renderWidth <= 20 || /^(CRUD_TYPE|CHK|CHECK|SEL|ROW_STATUS)/i.test(x.binding)) continue;
      let merged = false; for (let r = 0; r < 3 && !merged; r++) { const m = c.getMergedRange(c.cells, r, i); merged = !!m && !m.isSingleCell; }
      if (!merged) o.push([i, i < c.frozenColumns ? 1 : 0]); }
      o.sort((a, b) => a[1] - b[1]); return o.length ? o[0][0] : -1; })()`) as number;
    if (ci < 0) { for (const x of k3) put(x.row_id, '판정필요', '시험할 보이는 컬럼 없음'); return; }
    const bnd = await p.evaluate(`(() => ${CTLX}.columns[${ci}].binding)()`) as string;
    // 클릭 좌표 = 실제 셀 DOM 의 화면 좌표(getCellElement · getBoundingClientRect). getCellBoundingRect 는 화면 좌표가 아니어서
    //   그리드 밖(MDI 컨테이너)을 눌러 '선택 안 됨' 허위 판정이 났다(2026-10-28 진단: elementFromPoint = _mdiContent). 클릭 지점이 그 셀인지 hitTest(행·열·패널)로 확인해 아니면 예외
    //   (고정 열은 셀이 두 겹으로 그려져 DOM 일치 비교가 안 된다)
    const cellPt = async (row: number, hdr = false) => {
      // 좌표 = 그리드 hitTest 가 (패널·행·열) 을 돌려주는 지점을 그리드 영역에서 찾는다 — 가상 스크롤이 재활용한 셀 DOM 위치는 다른 행일 수 있다(2026-10-28 실측 0행 요소 자리 = 14행)
      const r0 = await p.evaluate(`(async () => { const c = ${CTLX}; c.scrollIntoView(${hdr ? 0 : row}, ${ci}); await new Promise(r => setTimeout(r, 300));
        const pn = ${hdr} ? c.columnHeaders : c.cells; const rr = ${hdr} ? pn.rows.length - 1 : ${row}; const hb = c.hostElement.getBoundingClientRect();
        const ht = (x, y) => c.hitTest(x + window.pageXOffset, y + window.pageYOffset);
        let fy = -1, fx = -1;
        for (let y = hb.top + 2; y < hb.bottom - 2 && fy < 0; y += 3) { for (let x = hb.left + 2; x < hb.right - 2; x += 6) { const h = ht(x, y); if (h && h.panel === pn && h.row === rr && h.col === ${ci}) { fy = y; fx = x; break; } } }
        if (fy < 0) return { ok: false, at: '그리드 영역에 대상 셀 없음' };
        let x2 = fx; while (x2 + 3 < hb.right) { const h = ht(x2 + 3, fy); if (!h || h.col !== ${ci} || h.panel !== pn) break; x2 += 3; }
        let y2 = fy; while (y2 + 2 < hb.bottom) { const h = ht(fx, y2 + 2); if (!h || h.row !== rr || h.panel !== pn) break; y2 += 2; }
        const x = Math.round((fx + Math.min(x2, fx + 60)) / 2), y = Math.round((fy + y2) / 2); const hit = document.elementFromPoint(x, y);
        return { x, y, ok: !!hit && c.hostElement.contains(hit), at: hit ? String(hit.className || hit.tagName).slice(0, 40) : 'none' }; })()`) as { x: number; y: number; ok: boolean; at: string };
      if (!r0.ok) throw new Error(`셀 좌표 확인 실패(${hdr ? '헤더' : `${row}행`} · ${bnd}): ${r0.at}`);
      return { x: r0.x, y: r0.y };
    };
    const out: Record<string, { res: Res['result']; ev: string }> = {};
    // 검사기 변이 시험(K3_MUTATE=1 일 때만) — 다중 선택 끔(selectionMode=Cell) · F5 단계에서 조회 call-proc 차단(조회 미실행). 검사기가 FAIL 을 내는지 확인용(평소 실행 무영향)
    const MUT = process.env.K3_MUTATE === '1';
    if (MUT) await p.evaluate(`(() => { const c = ${CTLX}; c.selectionMode = 1; })()`);
    // 단계 하나가 예외(셀 좌표 확인 실패 등)로 끝나도 나머지 판정은 남긴다 — 실행 안 된 항목은 ERROR(PASS 로 넘기지 않음)
    const step = async (key: string, fn: () => Promise<void>) => { try { await fn(); } catch (e) { out[key] = { res: 'ERROR', ev: `실행 실패: ${String(e).slice(0, 200)}` }; } };
    // ③ Copy(먼저 실행 — 헤더 클릭의 열 전체 선택이 남으면 열 전체가 복사된다) — 셀 1개 선택 후 Ctrl+C / 우클릭 메뉴 Copy → 클립보드 = 셀 표시값
    await step('copy', async () => {
      const want = String(await p.evaluate(`(() => { const c = ${CTLX}; return c.getCellData(0, ${ci}, true); })()`) ?? '').trim();
      const clip = async () => String(await p.evaluate('navigator.clipboard.readText()').catch(e => `ERR ${String(e).slice(0, 60)}`)).trim();
      await p.evaluate("navigator.clipboard.writeText('__K3__')").catch(() => undefined);
      let a = await cellPt(0); await p.mouse.click(a.x, a.y); await p.waitForTimeout(200);
      const sel = await p.evaluate(`(() => { const c = ${CTLX}; const x = c.selection; return [x.topRow, x.leftCol, x.bottomRow, x.rightCol].join(','); })()`) as string;
      await p.keyboard.press('Control+C'); await p.waitForTimeout(400);
      const c1 = await clip();
      await p.evaluate("navigator.clipboard.writeText('__K3__')").catch(() => undefined);
      a = await cellPt(0); await p.mouse.click(a.x, a.y, { button: 'right' }); await p.waitForTimeout(400);
      const mi = p.getByRole('button', { name: /^Copy$/ }).or(p.locator('button', { hasText: /^Copy$/ })).first();
      const hasMenu = await mi.isVisible().catch(() => false);
      if (hasMenu) { await mi.click({ timeout: 3_000 }).catch(() => undefined); await p.waitForTimeout(400); }
      const c2 = hasMenu ? await clip() : '(우클릭 Copy 메뉴 없음)';
      await p.keyboard.press('Escape').catch(() => undefined);
      const okK = c1 === want && c1 !== '__K3__'; const okM = c2 === want && c2 !== '__K3__';
      out.copy = { res: c1.startsWith('ERR') ? 'ERROR' : okK && okM ? 'PASS' : 'FAIL',
        ev: `선택 ${sel} · 0행 ${bnd} 표시값 '${want.slice(0, 40)}' · Ctrl+C 클립보드 '${c1.replace(/\r?\n/g, '⏎').slice(0, 40)}'(${okK ? '일치' : '불일치'}) · 우클릭 Copy '${c2.replace(/\r?\n/g, '⏎').slice(0, 40)}'(${okM ? '일치' : '불일치'})` };
    });
    // ① Ctrl+클릭 비연속 다중 선택 — 0행 클릭 → Ctrl+2행 클릭 → selectedRanges 가 0·2행을 담고 1행은 제외
    //   앞 단계 우클릭 메뉴가 남아 첫 클릭을 삼키는 간섭(2026-10-28 실측: 순서에 따라 [[2,2]]) — 메뉴 닫기 후 시도 · 실패 시 1회 재시도(두 시도 모두 증거)
    await step('ctrl', async () => {
      const tries: string[] = []; let ok = false; let mode = -1;
      for (let t = 0; t < 2 && !ok; t++) {
        await p.keyboard.press('Escape').catch(() => undefined); await p.waitForTimeout(300);
        let a = await cellPt(0); await p.mouse.click(a.x, a.y); await p.waitForTimeout(300);
        a = await cellPt(2); await p.keyboard.down('Control'); await p.mouse.click(a.x, a.y); await p.keyboard.up('Control'); await p.waitForTimeout(400);
        const s = await p.evaluate(`(() => { const c = ${CTLX}; const rs = (c.selectedRanges && c.selectedRanges.length ? c.selectedRanges : [c.selection]).map(x => [x.topRow, x.bottomRow]);
          const has = r => rs.some(([t, b]) => r >= t && r <= b); return { mode: c.selectionMode, rs, r0: has(0), r1: has(1), r2: has(2) }; })()`) as { mode: number; rs: number[][]; r0: boolean; r1: boolean; r2: boolean };
        ok = s.r0 && s.r2 && !s.r1; mode = s.mode; tries.push(`시도${t + 1} ${JSON.stringify(s.rs)}`);
      }
      out.ctrl = { res: ok ? 'PASS' : 'FAIL', ev: `Ctrl+클릭 0행·2행(${bnd}) → 선택 범위 ${tries.join(' / ')} · selectionMode=${mode}${ok ? ' — 비연속 다중 선택' : ' — 비연속 다중 선택 안 됨'}` };
    });
    // ② 헤더 클릭 = 해당 열 전체 선택(확정 요구 유형1)
    await step('hdr', async () => {
      const a = await cellPt(0, true); await p.mouse.click(a.x, a.y); await p.waitForTimeout(400);
      const s = await p.evaluate(`(() => { const c = ${CTLX}; const x = c.selection; return { top: x.topRow, bottom: x.bottomRow, left: x.leftCol, right: x.rightCol, rows: c.rows.length, sorted: c.collectionView && c.collectionView.sortDescriptions ? c.collectionView.sortDescriptions.length : 0 }; })()`) as { top: number; bottom: number; left: number; right: number; rows: number; sorted: number };
      const ok = s.top === 0 && s.bottom === s.rows - 1 && s.left <= ci && s.right >= ci;
      out.hdr = { res: ok ? 'PASS' : 'FAIL', ev: `헤더(${bnd}) 클릭 → 선택 행 ${s.top}~${s.bottom}/${s.rows} · 열 ${s.left}~${s.right}(시험 열 ${ci})${s.sorted ? ` · 정렬 ${s.sorted}건 걸림` : ''}${ok ? ' — 열 전체 선택' : ' — 열 전체 선택 아님'}` };
    });
    // ④ Hide Column — 헤더 우클릭 → Hide Column → 그 컬럼 비표시 → Unhide All 로 복원
    await step('hide', async () => {
      const a = await cellPt(0, true); await p.mouse.click(a.x, a.y, { button: 'right' }); await p.waitForTimeout(400);
      const mi = p.locator('button', { hasText: /^Hide Column$/ }).first();
      if (!(await mi.isVisible().catch(() => false))) { await p.keyboard.press('Escape').catch(() => undefined); out.hide = { res: 'FAIL', ev: `헤더(${bnd}) 우클릭 메뉴에 Hide Column 없음` }; }
      else {
        await mi.click({ timeout: 3_000 }).catch(() => undefined); await p.waitForTimeout(600);
        const vis = (await probe.visibleBindings(p)) || [];
        const hidden = !vis.includes(bnd);
        const b2 = await cellPt(0, true).catch(() => null);
        if (b2) { await p.mouse.click(b2.x, b2.y, { button: 'right' }); await p.waitForTimeout(300); await p.locator('button', { hasText: /^Unhide All Columns$/ }).first().click({ timeout: 3_000 }).catch(() => p.keyboard.press('Escape')); }
        await p.waitForTimeout(500);
        let back = ((await probe.visibleBindings(p)) || []).includes(bnd);
        if (!back) { await p.reload(); await nscm.openScreen(ID); await nscm.search(); for (let k = 0; k < 120 && (await probe.rowCount(p)) < 3; k++) await p.waitForTimeout(500); await nscm.clearDialogs(); back = ((await probe.visibleBindings(p)) || []).includes(bnd); }
        out.hide = { res: hidden ? 'PASS' : 'FAIL', ev: `헤더(${bnd}) 우클릭 → Hide Column → ${hidden ? '컬럼 비표시' : '컬럼 여전히 표시'} · Unhide All ${back ? '복원' : '복원 안 됨(화면 재진입 후에도)'}` };
      }
    });
    // ⑤ F5 = 조회(브라우저 새로고침 아님) — 그리드에 포커스를 둔 채 F5 → 조회 call-proc 발생 · 페이지 이동 없음
    await step('f5', async () => {
      let nav = 0; const onNav = (f: import('@playwright/test').Frame) => { if (f === p.mainFrame()) nav++; }; p.on('framenavigated', onNav);
      const a = await cellPt(0); await p.mouse.click(a.x, a.y); await p.waitForTimeout(200);
      const before = nscm.calls.length;
      const w = p.waitForResponse(x => /call-proc/.test(x.url()) && !/\/dayRange\//i.test(x.url()) && !/\/(SAVE|INS|UPD|DEL)[^/]*\/call-proc/i.test(x.url()), { timeout: 60_000 }).catch(() => null);
      if (MUT) await p.route(/call-proc/, rt => rt.abort());
      await p.keyboard.press('F5'); const resp = await w; await p.waitForTimeout(800); p.off('framenavigated', onNav);
      await nscm.clearDialogs();
      const fired = nscm.calls.slice(before).filter(c => /SEARCH|SEL|GET/i.test(c.btn));
      const ok = !!resp && nav === 0;
      out.f5 = { res: ok ? 'PASS' : 'FAIL', ev: `F5 → 조회 호출 ${fired.length}건(${fired.map(c => c.btn).slice(0, 3).join(',') || '-'}) · 페이지 이동 ${nav}회${ok ? '' : nav ? ' — 브라우저 새로고침' : ' — 조회 미실행'}` };
    });
    const all = Object.entries(out).map(([k, v]) => `${k} ${v.res}: ${v.ev}`).join(' | ');
    const pickRes = (keys: string[]) => { const vs = keys.map(k => out[k] || { res: 'ERROR' as Res['result'], ev: `${k} 미실행` }); const res: Res['result'] = vs.some(v => v.res === 'FAIL') ? 'FAIL' : vs.some(v => v.res === 'ERROR') ? 'ERROR' : 'PASS'; return { res, ev: keys.map((k, i) => `${k} ${vs[i].res}: ${vs[i].ev}`).join(' | ') }; };
    for (const x of k3) {
      const t = `${x.target} ${x.expected}`;
      const keys = [/Ctrl/i.test(t) && 'ctrl', /헤더 클릭|열 전체/.test(t) && 'hdr', /Copy|복사/i.test(t) && !/붙여넣기 시 Team|병합 셀/.test(t) && 'copy', /Hide/i.test(t) && 'hide', /F5|단축키/.test(t) && 'f5'].filter(Boolean) as string[];
      if (x.source === 'RULE_SCREEN') { const v = pickRes(Object.keys(out)); put(x.row_id, v.res, v.ev); continue; }
      if (!keys.length) { put(x.row_id, '판정필요', `K3 조작 실측(이 행 문구는 Ctrl·헤더·Copy·Hide·F5 외 — Sort/Filter 동적 컬럼·팝업 No.·붙여넣기 등 별도 확인): ${all}`); continue; }
      // 이 시험이 안 다루는 측면(팝업 그리드 · Sort/Filter = K1 smoke · 동적 Bucket 컬럼)이 행 문구에 있으면 PASS 단정 금지 — FAIL 은 그대로
      const rest = [/팝업/.test(t) && '팝업 그리드(이 시험은 메인 그리드만)', /Sort|Filter|정렬 후/i.test(t) && 'Sort/Filter·정렬 후 동작(K1 smoke 행)', /동적|Bucket/i.test(t) && '동적 Bucket 컬럼'].filter(Boolean);
      const v = pickRes(keys); put(x.row_id, v.res === 'PASS' && rest.length ? '판정필요' : v.res, v.ev + (rest.length ? ` · 미포함: ${rest.join(', ')}` : ''));
    }
  });

  // E6 셀 키 입력(2026-10-28) — 단위테스트 결함 DMF0049(한글 첫 글자 영문 입력 · 콤보 자동완성 미동작)의 같은 유형을 이 화면 신규행에서 실측.
  //   ① 한글: 셀을 선택만 한 상태(편집기 닫힘)에서 IME 조합 입력 '한글' → 셀 값 '한글'. 모사 = CDP Input.imeSetComposition/insertText(+keydown 229 'Process').
  //      실제 OS IME 와 같지 않다(한계) — 다만 첫 타건 시점에 조합을 받을 입력칸이 없으면 OS 에서도 첫 글자가 조합되지 않는다(영문)는 원인 축은 같다.
  //   ② 자동완성: 콤보 셀에 후보 앞 2~3글자 입력 → 편집기 값이 그 후보로 채워짐(또는 Enter 후 셀 = 그 후보).
  //   저장하지 않는다 — 신규행은 화면 재진입으로 버려진다.
  test('셀 키 입력(E6) — 한글 IME 첫 글자·콤보 자동완성', async ({ nscm }) => {
    test.setTimeout(240_000);
    const p = nscm.page;
    const e6 = pick(x => x.rule_id === 'E6');
    if (!e6.length) return;
    const r = await nscm.openScreen(ID);
    if (!r.authorized) { for (const x of e6) put(x.row_id, 'ERROR', '화면 권한 없음 — 판정 불가'); return; }
    await nscm.search();
    for (let k = 0; k < 60 && (await probe.rowCount(p)) <= 0; k++) await p.waitForTimeout(500);
    await nscm.clearDialogs();
    if (!(await nscm.subButtonVisible('Insert'))) { for (const x of e6) put(x.row_id, 'NA', 'Insert 버튼 없음(입력 그리드 아님 또는 권한) — 셀 키 입력 대상 없음'); return; }
    await nscm.subButton('Insert').click({ timeout: 10_000 }); await p.waitForTimeout(1_000); await nscm.clearDialogs();
    const nr = await probe.findRow(p, 'new');
    if (!nr) { for (const x of e6) put(x.row_id, '판정필요', 'Insert 후 신규행 미발견'); return; }
    const CTLX = probe.CTL_SRC;
    const out: Record<string, { res: Res['result']; ev: string }> = {};
    const textCols: string[] = []; const comboCols: string[] = [];
    for (const b of (await probe.visibleBindings(p)) || []) {
      if (/^(CRUD_TYPE|CHK|CHECK|SEL|ROW_STATUS)/i.test(b)) continue;
      const info = await probe.colInfo(p, b); if (!info || info.readOnly || info.editor) continue;
      if (!(await probe.editable(p, nr.row, b))) continue;
      if (info.hasMap) comboCols.push(b); else if (info.dataType !== 2 && info.dataType !== 4 && info.dataType !== 3) textCols.push(b);
    }
    // 검사기 변이 시험(E6_MUTATE=1 일 때만) — IME 입력칸 켬(wijmo imeEnabled → ① PASS 로 바뀌어야) · 콤보 편집기 keypress·input 이벤트를 문서 캡처에서 끊음(자동완성 처리기 미실행 → ② FAIL 이어야).
    //   dataMap 제거 방식은 화면 재렌더가 되살려 변이가 안 걸렸다(2026-10-28). 평소 실행 무영향
    if (process.env.E6_MUTATE === '1') await p.evaluate(`(() => { const c = ${CTLX}; c.imeEnabled = true;
      const cut = e => { const t = e.target; const col = c.editRange ? c.columns[c.editRange.col] : null;
        if (t && t.classList && t.classList.contains('wj-grid-editor') && col && col.dataMap) e.stopImmediatePropagation(); };
      document.addEventListener('input', cut, true); document.addEventListener('keypress', cut, true); })()`);
    // ① 한글 IME
    if (!textCols.length) out.ime = { res: 'NA', ev: '신규행에 직접 입력하는 문자 컬럼 없음' };
    else {
      const b = textCols.find(x => /REMARK|COMMENT|DESC|NOTE|MEMO|RMK/i.test(x)) || textCols[0];
      const cdp = await p.context().newCDPSession(p);
      await p.evaluate(`(() => { const c = ${CTLX}; const col = c.columns.getColumn(${JSON.stringify(b)}); if (c.activeEditor) c.finishEditing(true); c.select(${nr.row}, col.index); c.focus(); })()`);
      await p.waitForTimeout(300);
      const key229 = () => cdp.send('Input.dispatchKeyEvent', { type: 'rawKeyDown', windowsVirtualKeyCode: 229, nativeVirtualKeyCode: 229, key: 'Process', code: '' });
      const syll = async (steps: string[], fin: string) => { for (const t of steps) { await key229(); await cdp.send('Input.imeSetComposition', { text: t, selectionStart: t.length, selectionEnd: t.length }); await p.waitForTimeout(120); } await cdp.send('Input.insertText', { text: fin }); await p.waitForTimeout(150); };
      const focus0 = await p.evaluate('(() => { const e = document.activeElement; return e ? e.tagName + (e.isContentEditable ? "[ce]" : "") + "." + String(e.className || "").slice(0, 30) : "none"; })()') as string;
      await syll(['ㅎ', '하', '한'], '한'); await syll(['ㄱ', '그', '글'], '글');
      const live = await p.evaluate(`(() => { const c = ${CTLX}; return c.activeEditor ? String(c.activeEditor.value) : null; })()`) as string | null;
      await p.keyboard.press('Enter'); await p.waitForTimeout(400);
      const v = (await probe.value(p, nr.row, b)) ?? '';
      // 대조군 — 편집기를 연 상태에서 같은 조합을 넣는다. 여기서 '한글' 이 안 되면 모사 자체가 무효(ERROR, 판정 안 함)
      await p.evaluate(`(() => { const c = ${CTLX}; const col = c.columns.getColumn(${JSON.stringify(b)}); c.select(${nr.row}, col.index); c.focus(); c.startEditing(true, ${nr.row}, col.index); if (c.activeEditor) c.activeEditor.value = ''; })()`);
      await p.waitForTimeout(300);
      await syll(['ㅎ', '하', '한'], '한'); await syll(['ㄱ', '그', '글'], '글');
      await p.keyboard.press('Enter'); await p.waitForTimeout(400);
      const vc = (await probe.value(p, nr.row, b)) ?? '';
      await cdp.detach().catch(() => undefined);
      const ok = v === '한글'; const ctrlOk = vc === '한글';
      out.ime = { res: !ctrlOk ? 'ERROR' : ok ? 'PASS' : 'FAIL',
        ev: `신규행 ${b} 선택(편집기 닫힘·포커스 ${focus0}) → IME 조합 '한글' → 편집기 '${live ?? '(안 열림)'}' · 셀 값 '${v}'${ok ? '' : ' — 첫 타건에 조합 받을 입력칸 없음(실제 OS IME 에선 첫 글자가 영문으로 들어가는 원인)'}`
          + ` · 대조군(편집기 연 뒤 같은 조합) '${vc}'${ctrlOk ? ' = 모사 유효' : ' — 모사 무효(판정 불가)'} (CDP IME 모사 — OS IME 와 동일하지 않음)` };
    }
    // ② 콤보 자동완성
    if (!comboCols.length) out.auto = { res: 'NA', ev: '신규행에 편집 가능한 콤보 컬럼 없음' };
    else {
      let done = false;
      for (const b of comboCols) {
        const opened = await probe.startEdit(p, nr.row, b); if (opened) await p.waitForTimeout(600);
        const cands = ((await probe.candidates(p, nr.row, b)) || []).filter(t => t && t.trim().length >= 3 && !/^(-|\/|ALL|Common)$/i.test(t.trim()));
        await probe.cancelEdit(p); await p.waitForTimeout(150);
        // 앞 글자가 후보 중 유일한 것 — 2글자 → 3글자 순
        let pickC = ''; let pre = '';
        for (const n of [2, 3]) { const c0 = cands.find(t => cands.filter(u => u.toLowerCase().startsWith(t.slice(0, n).toLowerCase())).length === 1 && t.length > n); if (c0) { pickC = c0; pre = c0.slice(0, n); break; } }
        if (!pickC) continue;
        await p.evaluate(`(() => { const c = ${CTLX}; const col = c.columns.getColumn(${JSON.stringify(b)}); c.select(${nr.row}, col.index); c.focus(); })()`);
        await p.waitForTimeout(200);
        await p.keyboard.type(pre, { delay: 120 }); await p.waitForTimeout(700);
        const live = await p.evaluate(`(() => { const c = ${CTLX}; return c.activeEditor ? String(c.activeEditor.value) : null; })()`) as string | null;
        await p.keyboard.press('Enter'); await p.waitForTimeout(400);
        const shown = await p.evaluate(`(() => { const c = ${CTLX}; const col = c.columns.getColumn(${JSON.stringify(b)}); return String(c.getCellData(${nr.row}, col.index, true) ?? ''); })()`) as string;
        // 자동완성 = 입력 도중 편집기에 후보가 채워지는 것(Enter 때 앞글자로 값을 찾아 넣는 확정 처리와 구별) — 편집기 실시간 값으로 판정
        const ok = live === pickC;
        out.auto = { res: ok ? 'PASS' : 'FAIL', ev: `신규행 ${b} 에 '${pre}' 입력 → 편집기 '${live ?? '(안 열림)'}' · Enter 후 셀 '${shown}' (기대 후보 '${pickC}')${ok ? '' : shown === pickC ? ' — 입력 중 자동완성 안 됨(Enter 확정 때만 후보로 바뀜)' : ' — 자동완성 안 됨'}` };
        done = true; break;
      }
      if (!done) out.auto = { res: 'NA', ev: `콤보 ${comboCols.join(',')} — 앞 2~3글자가 유일한 후보 없음(자동완성 판별 불가)` };
    }
    const all = Object.entries(out).map(([k, v]) => `${k} ${v.res}: ${v.ev}`).join(' | ');
    for (const x of e6) {
      const t = `${x.target} ${x.expected}`;
      const keys = [/한글|IME|첫 글자/.test(t) && 'ime', /자동완성|auto/i.test(t) && 'auto'].filter(Boolean) as string[];
      const use = keys.length && x.source !== 'RULE_SCREEN' ? keys : Object.keys(out);
      const vs = use.map(k => out[k] || { res: 'ERROR' as Res['result'], ev: `${k} 미실행` });
      let res: Res['result'] = vs.some(v => v.res === 'FAIL') ? 'FAIL' : vs.some(v => v.res === 'ERROR') ? 'ERROR' : vs.every(v => v.res === 'NA') ? 'NA' : 'PASS';
      const rest = [/복사|붙여넣기/.test(t) && '복사/붙여넣기(K3·F3 행)', /병합/.test(t) && '붙여넣기 병합 셀(H3 행)'].filter(Boolean);
      if (res === 'PASS' && rest.length && x.source !== 'RULE_SCREEN') res = '판정필요';
      put(x.row_id, res, use.map((k, i) => `${k} ${vs[i].res}: ${vs[i].ev}`).join(' | ') + (rest.length ? ` · 미포함: ${rest.join(', ')}` : '') + (x.source === 'RULE_SCREEN' ? '' : ` [전체: ${all.slice(0, 200)}]`));
    }
  });

  // B7 기준 데이터 변경 후 후보 갱신(2026-10-28) — 단위테스트 결함 DMF0004(저장한 Sales Site 가 조회조건에 안 보임)·DMF0005(Team 저장 후 재바인딩)·
  //   DMF0004 LOOKUP 신규 End Customer · DMF0082/DMF0003 SSPM DEPT 변경 재조회 의 같은 유형.
  //   (a) 자기 저장 → 콤보 = b7_check.py 정적 대조(Doc/verify/<ID>/b7_check.json) 결과를 그대로 싣는다
  //   (b) 외부 변경 → 재진입 = 탭을 닫고 SPA 안에서 다시 열 때 admin/combo 재조회 실측(캐시로만 그리면 그 사이 바뀐 마스터가 안 보인다)
  //       '재조회' 문구 행 = 조회 버튼 때 후보 재조회 여부도 실측 — 기대는 AS-IS 바인딩 시점(조회 메서드에서 재바인딩하면 조회 때도 받아야, 초기화만이면 재진입 기준)
  test('후보 갱신(B7) — 저장→콤보 원천 대조(a)·재진입/재조회 시 콤보 재조회(b)', async ({ nscm }) => {
    test.setTimeout(240_000);
    const p = nscm.page;
    const b7 = pick(x => x.rule_id === 'B7');
    if (!b7.length) return;
    const st = (() => { try { return JSON.parse(fs.readFileSync(path.join(DIR, 'b7_check.json'), 'utf8')).a as { verdict: Res['result'] | '판정필요'; note: string }; } catch { return null; } })();
    const SRC_P = path.join(ROOT, 'Doc', 'asisfacts', 'screens', ID, 'combo_src.csv');
    const srcRows = fs.existsSync(SRC_P) ? parseCsv(fs.readFileSync(SRC_P, 'utf8')) : [];
    const asisOnSearch = srcRows.filter(x => /Search|Find|Retrieve|Query/i.test(x.method || '') && !/^Init|Load/i.test(x.method || '')).map(x => `${x.target}@${x.method}`);
    const comboHits: string[] = [];
    p.on('response', rsp => { if (/\/admin\/combo/i.test(rsp.url())) comboHits.push(rsp.url()); });
    const r = await nscm.openScreen(ID);
    if (!r.authorized) { for (const x of b7) put(x.row_id, 'ERROR', '화면 권한 없음 — 판정 불가'); return; }
    await p.waitForTimeout(2_500);
    const nOpen = comboHits.length;
    // 재조회(조회 버튼) 때 콤보 재조회
    let k0 = comboHits.length; await nscm.search(); await p.waitForTimeout(1_500); await nscm.clearDialogs();
    const nSearch = comboHits.length - k0;
    // 재진입 — 이 화면 탭 닫기 → SPA 라우팅으로 다시 열기(page.goto 는 앱을 새로 띄워 메모리 캐시까지 버리므로 사용자 재진입과 다르다)
    const tab = p.locator('button[class*="_tab_"]').filter({ has: p.locator('[class*="closeBtn"], [class*="_close"]') }).last();
    const closeBtn = tab.locator('[class*="closeBtn"], [class*="_close"]').first();
    let reopenHow = '';
    if (process.env.B7_MUTATE === '1') await p.route(/\/admin\/combo/i, rt => rt.abort());  // 변이 시험: 재진입 콤보 요청 차단 → FAIL 이어야
    if (await closeBtn.isVisible().catch(() => false)) {
      await closeBtn.click({ timeout: 5_000 }).catch(() => undefined); await p.waitForTimeout(800); await nscm.clearDialogs();
      k0 = comboHits.length;
      await p.evaluate(`(() => { history.pushState({}, '', '/view/${ID}'); window.dispatchEvent(new PopStateEvent('popstate')); })()`);
      let navs = 0; const onNav = (f: import('@playwright/test').Frame) => { if (f === p.mainFrame()) navs++; }; p.on('framenavigated', onNav);
      const how = await nscm.activateScreenTab(ID); await p.waitForTimeout(2_500); p.off('framenavigated', onNav);
      // 'regoto' = 같은 URL 로 페이지를 다시 띄움(앱 재시작 → 메모리 캐시 소멸) — 사용자 재진입과 달라 증거로 쓰지 않는다
      reopenHow = how === 'regoto' ? 'goto 재로딩(SPA 재진입 아님)' : `SPA 재진입(${how})`;
    }
    const nReopen = reopenHow ? comboHits.length - k0 : -1;
    const bRes: Res['result'] = nReopen < 0 || /재로딩/.test(reopenHow) ? '판정필요' : nReopen > 0 ? 'PASS' : 'FAIL';
    const bEv = nReopen < 0 ? '탭 닫기 버튼 없음 — 재진입 실측 불가' : `탭 닫고 ${reopenHow} → admin/combo ${nReopen}건${nReopen > 0 ? ' 재조회(새 마스터 반영 경로 있음)' : ' — 캐시로만 그림(그 사이 바뀐 마스터 미반영)'} · 최초 진입 ${nOpen}건`;
    const sNeed = asisOnSearch.length > 0;
    const sRes: Res['result'] = sNeed ? (nSearch > 0 ? 'PASS' : 'FAIL') : bRes;
    const sEv = `조회 버튼 → admin/combo ${nSearch}건 · AS-IS 조회 때 재바인딩 ${sNeed ? asisOnSearch.slice(0, 4).join(',') : '없음(초기화 때만 바인딩 — 재진입 기준으로 판정)'}`;
    const aRes = (st?.verdict || '판정필요') as Res['result']; const aEv = `(a) ${st ? st.note : 'b7_check.json 없음 — 정적 대조 미실행'}`;
    for (const x of b7) {
      const t = `${x.target} ${x.condition} ${x.expected}`;
      const parts: { res: Res['result']; ev: string }[] = [];
      if (/저장/.test(t) || (x.source === 'SEARCH' && st && st.verdict !== 'NA')) parts.push({ res: aRes, ev: aEv });  // 조회조건 행 = 저장이 원천을 바꾸는 화면이면 (a) 도 함께
      if (/재조회/.test(t)) parts.push({ res: sRes, ev: `(b-재조회) ${sEv}` });
      if (/재오픈|재진입|LOOKUP|신규 등록|변경 후|SSPM/i.test(t) || !parts.length) parts.push({ res: bRes, ev: `(b-재진입) ${bEv}` });
      const live = parts.filter(v => v.res !== 'NA');
      const res: Res['result'] = !live.length ? 'NA' : live.some(v => v.res === 'FAIL') ? 'FAIL' : live.some(v => v.res === 'ERROR') ? 'ERROR' : live.some(v => v.res === '판정필요') ? '판정필요' : 'PASS';
      put(x.row_id, res, parts.map(v => `${v.res}: ${v.ev}`).join(' | '));
    }
  });

  test('조회조건 콤보 후보 품질(B1·B2)', async ({ nscm }) => {
    test.setTimeout(900_000); // G1 이 조건마다 화면을 새로 열고 2회 조회한다
    const p = nscm.page;
    const r = await nscm.openScreen(ID);
    if (!r.authorized) return;
    await nscm.expandSearchArea();
    // 조건별로 한 번만 열어 B1·B2·G2 를 함께 판정(같은 칸을 다시 찾다가 SELECT ALL 이후 상태 변화로 실패하던 문제)
    const seenTarget = new Set<string>();
    for (const x0 of pick(x => x.source === 'SEARCH' && x.rule_id === 'B1')) {
      if (seenTarget.has(x0.target)) continue; seenTarget.add(x0.target);
      const b2 = pick(y => y.source === 'SEARCH' && y.rule_id === 'B2' && y.target === x0.target)[0];
      const x = x0;
      const name = x.target.replace(/^조회조건\s*/, '');
      // 라벨은 끝의 '.'·'*' 를 허용(예 기준 'Div' ↔ 화면 'Div.') — 조회조건 영역(SearchArea) 안에서만 찾는다(그리드 헤더 오인 방지)
      const fb = await findSearchBox(nscm, p, name);
      if (!fb.box) { put(x.row_id, '판정필요', fb.why); continue; }
      const box = fb.box;
      if (!(await box.isVisible().catch(() => false))) { put(x.row_id, '판정필요', `'${name}' 콤보박스 아님(텍스트/팝업형)`); continue; }
      const sel = await selectedOf(box); // 열기 전 선택 표시(초기 상태)
      const popper = p.locator('.MuiAutocomplete-popper');
      await p.keyboard.press('Escape'); await popper.first().waitFor({ state: 'hidden', timeout: 3_000 }).catch(() => undefined);
      await box.click({ timeout: 5_000 }).catch(() => undefined); await popper.first().waitFor({ state: 'visible', timeout: 5_000 }).catch(() => undefined); await p.waitForTimeout(400);
      const raw = await dropdownOptions(p);
      // 다중선택 여부는 목록이 열려 있을 때 읽는다(닫은 뒤 세면 항상 false — 2026-10-23 B6 오탐 8건)
      const isMultiOpen = await p.evaluate(() => [...document.querySelectorAll('.MuiAutocomplete-popper li[role="option"] input[type="checkbox"]')].length > 0);
      await p.keyboard.press('Escape'); await popper.first().waitFor({ state: 'hidden', timeout: 3_000 }).catch(() => undefined);
      if (raw == null) { put(x.row_id, 'ERROR', `'${name}' 드롭다운 목록이 열리지 않음 — 판정 불가`); continue; }
      const opts = raw.map(s => s.trim());
      RT.search[name] = { label: fb.labText, opts, multi: isMultiOpen, sel }; // W1 덤프(표시 순서 그대로 · 열기 전 선택 표시)
      addCombos(nscm.combos);
      // ALL·다중선택 사양(B6) — 기준: SCP·SSP 기준표 '선택/다중·ALL버튼' 또는 AS-IS 컨트롤(UsrCheckedList=다중 · UsrCombo=단일)
      const b6 = pick(y => y.source === 'SEARCH' && y.rule_id === 'B6' && y.target === x0.target)[0];
      if (b6) {
        const isMulti = isMultiOpen;
        const hasAll = opts.some(o => /^(SELECT ALL|ALL|전체)$/i.test(o));
        const tag = (/\[순서[^\]]*\]/.exec(b6.expected) || [''])[0];           // SCP·SSP 기준표 표기
        const ctl = (/\((Usr\w+)\)/.exec(b6.asis_ref) || [])[1] || '';             // DM: AS-IS 조회조건 패널 컨트롤
        const wantMulti = /\/다중/.test(tag) || ctl === 'UsrCheckedList' ? true : (/\/단일/.test(tag) || ctl === 'UsrCombo' ? false : null);
        const wantAll = /ALL/.test(tag) || ctl === 'UsrCheckedList';
        if (wantMulti == null) put(b6.row_id, '판정필요', `조회조건 ${name} 사양 기준 없음 — 화면 다중=${isMulti} · ALL=${hasAll}`);
        else put(b6.row_id, isMulti === wantMulti && (!wantAll || hasAll) ? 'PASS' : 'FAIL', `조회조건 ${name}: 다중선택 기대 ${wantMulti}/화면 ${isMulti} · ALL 기대 ${wantAll}/화면 ${hasAll}`);
      }
      // Select ALL 로 전체 선택 상태에 도달 가능한지(G2, 고객 #20) — 다중선택(체크박스) 콤보만. 최대 2회 클릭(전체→해제→전체)
      const g2 = pick(y => y.source === 'SEARCH' && y.rule_id === 'G2' && y.target === x.target)[0];
      if (g2 && opts.some(o => /^SELECT ALL$/i.test(o))) {
        await box.click({ timeout: 5_000 }).catch(() => undefined); await popper.first().waitFor({ state: 'visible', timeout: 5_000 }).catch(() => undefined);
        const state = () => p.evaluate(() => { const lis = [...document.querySelectorAll('.MuiAutocomplete-popper li[role="option"]')].filter(e => (e as HTMLElement).getBoundingClientRect().height > 0);
          const items = lis.filter(e => !/^SELECT ALL$/i.test((e as HTMLElement).innerText.trim())); return { n: items.length, on: items.filter(e => (e.querySelector('input[type="checkbox"]') as HTMLInputElement | null)?.checked).length }; });
        const seq: string[] = []; let all = false;
        for (let k = 0; k < 2 && !all; k++) {
          await p.locator('.MuiAutocomplete-popper li[role="option"]').filter({ hasText: /^\s*SELECT ALL\s*$/i }).first().click({ timeout: 3_000 }).catch(() => undefined);
          await p.waitForTimeout(400); const s = await state(); seq.push(`클릭${k + 1}: ${s.on}/${s.n} 선택`); all = s.n > 0 && s.on === s.n;
        }
        put(g2.row_id, all ? 'PASS' : 'FAIL', `조회조건 ${name} SELECT ALL — ${seq.join(' → ')}${all ? '' : ' — 전체 선택 상태에 도달 못함'}`);
        await p.keyboard.press('Escape'); await popper.first().waitFor({ state: 'hidden', timeout: 3_000 }).catch(() => undefined);
      }
      const q = probe.comboQuality(opts.filter(o => !/^(ALL|Select All|전체)$/i.test(o)));
      put(x.row_id, q.count === 0 || q.blanks ? 'FAIL' : 'PASS', `조회조건 ${name} 후보 ${q.count}건 · 빈 항목 ${q.blanks}`);
      if (b2) put(b2.row_id, q.dups.length ? 'FAIL' : 'PASS', `조회조건 ${name} 후보 ${q.count}건 · 중복 ${q.dups.length ? q.dups.slice(0, 8).join(', ') : '0'}`);
    }
    // 조회조건 결과 반영(G1) — 다중선택 조건에서 '기본 조회 결과에 실제로 있는 값' 1개만 고르고 조회 → 같은 이름 컬럼 값이 모두 그 값이어야 한다
    //   (첫 항목을 고르면 0건이 잦았다 — 2026-10-23). 조건마다 화면을 새로 열어 서로 영향이 없게 한다
    for (const x of pick(y => y.source === 'SEARCH' && y.rule_id === 'G1').slice(0, 6)) {
      const name = x.target.replace(/^조회조건\s*/, '');
      const esc = name.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
      await nscm.openScreen(ID); await nscm.expandSearchArea();
      await nscm.search(); for (let k = 0; k < 240 && (await probe.rowCount(p)) <= 0; k++) await p.waitForTimeout(500); await nscm.clearDialogs();
      await p.waitForLoadState('networkidle', { timeout: 20_000 }).catch(() => undefined);
      // 본 조회 시트 = 기본 조회 응답 중 행이 가장 많은 시트(보조 조회와 구분)
      const mainSheet = [...nscm.calls].filter(c => /SEARCH/i.test(c.btn)).sort((a, c) => (c.rows || 0) - (a.rows || 0))[0]?.sheet || '';
      const b = await probe.bindingByHeader(p, name);
      if (!b) { put(x.row_id, '판정필요', `'${name}' 과 같은 이름의 결과 컬럼 없음 — 조건 ↔ 컬럼 대응 확인 필요`); continue; }
      const base = ((await probe.columnValues(p, b)) || []).filter(Boolean);
      if (!base.length) { put(x.row_id, '판정필요', `기본 조회 결과 0행 또는 '${b}' 값 없음`); continue; }
      const freq = new Map<string, number>(); for (const v of base) freq.set(v, (freq.get(v) || 0) + 1);
      const target = [...freq.entries()].sort((a, c) => a[1] - c[1])[0][0]; // 가장 적은 값 = 다른 값과 섞여 있으면 거르는지 드러남
      const area = (await nscm.visibleFirst(p.locator('[class*="searchArea"], [class*="SearchArea"]'))) || p.locator('body');
      const lab = await nscm.visibleFirst(area.getByText(new RegExp(`^\\s*\\*?\\s*${esc}\\s*\\.?\\s*\\*?\\s*$`, 'i')));
      const box = lab ? lab.locator('xpath=ancestor::*[.//*[@role="combobox"]][1]').locator('[role="combobox"]').first() : null;
      if (!box || !(await box.isVisible().catch(() => false))) { put(x.row_id, '판정필요', `조회조건 '${name}' 콤보 아님 또는 미발견 — 텍스트·팝업 조건 프로브 필요`); continue; }
      const popper = p.locator('.MuiAutocomplete-popper');
      await box.click({ timeout: 5_000 }).catch(() => undefined); await popper.first().waitFor({ state: 'visible', timeout: 5_000 }).catch(() => undefined); await p.waitForTimeout(300);
      const isMulti = await p.evaluate(() => [...document.querySelectorAll('.MuiAutocomplete-popper li[role="option"] input[type="checkbox"]')].length > 0);
      if (!isMulti) { await p.keyboard.press('Escape'); put(x.row_id, '판정필요', `'${name}' 단일선택 콤보 — 단일 조건 프로브 미구현`); continue; }
      // 검색창(data-dropdown-search)에 값을 넣어 항목을 좁힌 뒤 고른다(가상 목록이라 스크롤 없이 찾기 위함)
      const search = p.locator('.MuiAutocomplete-popper [data-dropdown-search]');
      const lis = p.locator('.MuiAutocomplete-popper li[role="option"]');
      const allChecked = await p.evaluate(() => { const c = [...document.querySelectorAll('.MuiAutocomplete-popper li[role="option"] input[type="checkbox"]')] as HTMLInputElement[]; return c.length > 0 && c.every(i => i.checked); });
      if (allChecked && /^SELECT ALL$/i.test(((await lis.first().innerText().catch(() => '')) || '').trim())) { await lis.first().click({ timeout: 3_000 }).catch(() => undefined); await p.waitForTimeout(300); }
      if (await search.isVisible().catch(() => false)) { await search.fill(target); await p.waitForTimeout(500); }
      const texts = (await lis.allInnerTexts().catch(() => [] as string[])).map(t => t.trim());
      const idx = texts.findIndex(t => t === target || t.split(/\s+/)[0] === target || t.startsWith(target + ' '));
      if (idx < 0) { await p.keyboard.press('Escape'); put(x.row_id, 'FAIL', `결과에 있는 '${b}'='${target}' 이 조회조건 '${name}' 후보에 없음 — 조건 후보와 결과 불일치`); continue; }
      const optText = texts[idx];
      await lis.nth(idx).click({ timeout: 3_000 }).catch(() => undefined); await p.waitForTimeout(400);
      const checked = await p.evaluate(() => [...document.querySelectorAll('.MuiAutocomplete-popper li[role="option"]')]
        .filter(li => (li.querySelector('input[type="checkbox"]') as HTMLInputElement | null)?.checked).map(li => (li as HTMLElement).innerText.trim()));
      await p.keyboard.press('Escape'); await popper.first().waitFor({ state: 'hidden', timeout: 3_000 }).catch(() => undefined);
      const before = nscm.calls.length;
      await nscm.search();
      // 보조 조회(예 countryCity)가 먼저 응답한다 — 선택값이 담긴 조회 요청의 응답이 올 때까지(최대 120s) 기다린다(2026-10-23 오탐: 보조 응답 직후 결과를 읽음)
      const hasSel = () => nscm.calls.slice(before).some(c => (mainSheet && c.sheet === mainSheet) || `${c.body || ''} ${decodeURIComponent(c.url || '')}`.includes(target));
      for (let k = 0; k < 240 && !hasSel(); k++) await p.waitForTimeout(500);
      await p.waitForLoadState('networkidle', { timeout: 20_000 }).catch(() => undefined);
      // 호출 기록은 응답 헤더 시점 — 그리드가 다시 그려질 때까지(행 >0, 최대 60s) 기다린 뒤 읽는다. 진짜 0건이면 60s 후 0 으로 판정
      for (let k = 0; k < 120 && (await probe.rowCount(p)) <= 0; k++) await p.waitForTimeout(500);
      await p.waitForTimeout(800); await nscm.clearDialogs();
      const vals = ((await probe.columnValues(p, b)) || []);
      const body = nscm.calls.slice(before).map(c => `${c.body || ''} ${decodeURIComponent(c.url || '')}`).join(' ');
      // 선택 확인 = 체크된 항목이 정확히 그 1개 + 본 조회 요청이 실제로 나감(값이 코드로 환산돼 문구가 요청에 없을 수 있음 — RAIL→코드)
      const mainSent = nscm.calls.slice(before).some(c => mainSheet && c.sheet === mainSheet);
      const selOk = checked.length === 1 && checked[0] === optText && (body.includes(target) || mainSent);
      if (!selOk) { put(x.row_id, '판정필요', `선택 확인 실패(도구) — 체크된 항목 [${checked.slice(0, 4).join(', ')}] · 조회 요청에 '${target}' ${body.includes(target) ? '있음' : '없음'} · 결과 ${vals.length}행 · 요청 ${nscm.calls.slice(before).map(c => c.sheet + '/' + c.btn + ' ' + (c.body || '').slice(0, 120)).join(' | ') || '(캡처 없음)'}`); continue; }
      if (!vals.length) { put(x.row_id, 'FAIL', `'${name}'='${optText}' 만 선택(요청 본문 확인)해 조회했는데 0행 — 기본 조회에는 이 값 ${freq.get(target)}행이 있었음`); continue; }
      const ok = (v: string) => v === target || v === optText || optText.startsWith(v + ' ');
      const bad = [...new Set(vals.filter(v => !ok(v)))];
      put(x.row_id, bad.length ? 'FAIL' : 'PASS', `'${name}'='${optText}' 조회 → ${b} ${vals.length}행${bad.length ? ` 중 조건 밖 값 ${bad.length}종: ${bad.slice(0, 6).join(', ')} — 조회조건이 결과에 반영되지 않음` : ' 전부 조건 일치'} (기본 조회 ${freq.get(target)}행)`);
    }
  });
});
