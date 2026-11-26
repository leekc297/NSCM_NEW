import * as fs from 'fs';
import * as path from 'path';
// 저장 세부 프로브(2026-10-31 엔진 갭 E05 · EG186 컬럼별 왕복 · EG181/EG221 0·빈값 · EG182/EG225 2행 동시) — 기존행을 실제로 고쳐 저장·재조회하고 원복한다
//   안전 규칙: 행은 행 전체 값(rowIdentity)으로만 찾는다. 1건이 아니면 그 자리에서 멈추고 수동 원복 정보를 남긴다
import type { Nscm } from './nscm';
import { probe } from './probe';
import { identExclude, linkedCols, emptyLike, sameRestore } from './rowlink';  // T534 연동 칸(USER_ID → USER_NAME) · T555 빈 값 표시 원복

/** Save 뒤 요청이 없을 때 사유 — 변경 인식 실패(결함) · 업무 검증 차단(입력값 문제 · 결함 아님) · 사유 불명(측정 실패) */
export function classifyNoCall(msg: string): 'NOCHANGE' | 'VALIDATION' | 'UNKNOWN' { if (!msg.trim() || /성공|success/i.test(msg)) return 'UNKNOWN'; if (/수정한 내용|변경.*없|No change|nothing/i.test(msg)) return 'NOCHANGE'; return 'VALIDATION'; }
export type Trip = { ms?: number; msg?: string; blankAs?: string; rowBad?: boolean; blocked?: 'NOCHANGE' | 'VALIDATION' | 'UNKNOWN'; inputFail?: boolean; keyLinked?: string; b: string; row: number; orig: string; next: string; called: boolean; ok: boolean; got: string; restored: boolean; note: string };
const norm = (s: string) => String(s ?? '').replace(/,/g, '').trim();
const same = (a: string, b: string) => norm(a) === norm(b) || (norm(a) !== '' && norm(b) !== '' && !isNaN(Number(norm(a))) && Number(norm(a)) === Number(norm(b)));

/** 2026-11-20 T372(SSP0014 F1·F6 'njlilian' USER_CHECK 0행 · 같은 값으로 저장 세부·CRUD·2행 저장이 모두 막힘): 저장 전 검증 호출이 통과시킨 값(ok)과 막힌 시험 값(bad) — 칸 이름과 무관하게 대문자 값으로 모은다(한 실행 안에서 유지) */
export const precheckHints = { ok: new Set<string>(), bad: new Set<string>() };
/** 저장 전 검증 호출(SAVE 류 아님) 응답에 든 문자열 값 — 예 USER_CHECK o_rc1 = 통과 사용자 목록 */
export function precheckValues(calls: { btn: string; pre?: string }[]): Set<string> {
  const out = new Set<string>(); const walk = (v: unknown) => { if (typeof v === 'string') { const t = v.trim(); if (t && t.length <= 100) out.add(t.toUpperCase()); } else if (Array.isArray(v)) v.forEach(walk); else if (v && typeof v === 'object') Object.values(v as Record<string, unknown>).forEach(walk); };
  for (const c of calls) { if (/SAVE|INS|UPD|DEL/i.test(c.btn) || !c.pre) continue; try { walk(JSON.parse(c.pre)); } catch { /* 본문 없음 */ } }
  return out;
}
/** 검증 차단 뒤 기록 — 시험 값이 통과 목록에 없으면 막힌 값으로 남긴다 */
// 2026-11-20 T377(SSP0014 라운드 4 V-9bcbf1f5·V-504dee98·V-5473aa5a 'User ID : guoxiaoliang'): 시험 값이 아니라 그 행에 이미 든 다른 칸 값이 검증에 막혔다 →
//   검증 알림 문구에 이름이 나온 행 값(통과 목록에 없는 것)도 막힌 값으로 남기고, 행 고르기(editableValueRow·rowHasBad)가 그런 행을 뺀다
export function notePrecheck(calls: { btn: string; pre?: string }[], tried: string, msg = '', item: Record<string, unknown> | null = null): void {
  const ok = precheckValues(calls); for (const v of ok) precheckHints.ok.add(v); if (tried && !ok.has(tried.trim().toUpperCase())) precheckHints.bad.add(tried.trim().toUpperCase());
  const toks = new Set(String(msg || '').toUpperCase().split(/[\s,:;'"()\[\]]+/).filter(Boolean));
  if (item) for (const v0 of Object.values(item)) { if (typeof v0 !== 'string') continue; const v = v0.trim().toUpperCase(); if (v && v.length <= 100 && toks.has(v) && !ok.has(v)) precheckHints.bad.add(v); }
}
/** T377: 행에 저장 전 검증에 막힌 값이 들어 있는가(except 칸 제외) — 그 행은 어떤 값을 넣어도 저장 전 검증에 막힌다 */
export async function rowHasBad(nscm: Nscm, row: number, except = ''): Promise<boolean> {
  if (!precheckHints.bad.size) return false; const it = (await probe.rowItem(nscm.page, row).catch(() => null)) as Record<string, unknown> | null; if (!it) return false;
  return Object.entries(it).some(([k, v]) => k !== except && typeof v === 'string' && precheckHints.bad.has(v.trim().toUpperCase()));
}

export async function nextOf(nscm: Nscm, row: number, b: string, cur: string): Promise<string | null> {
  // T349(2026-11-19 SSP0014): 팝업 입력 칸(FPModal·FPTextModal)은 등록된 값만 저장된다(SSP0014 USER_CHECK 미등록 차단) — '원값+X' 는 저장 검증에 막혀 저장 시험이 안 된다 → 같은 칸 다른 행의 실제 값
  //   T372: 저장 전 검증에 막힌 값은 빼고, 검증이 통과시킨 값을 먼저
  if (await probe.popupColumn(nscm.page, b)) { const ov = await probe.otherColumnValue(nscm.page, b, cur, 5000, [...precheckHints.bad], [...precheckHints.ok]); if (ov) return ov;
    // T377(TEAM_LEADER 'guoxiaoliang'→'guoxiaoliangX'): 팝업 칸은 '원값+X' 가 등록 값이 아니라 저장 전 검증에 막힌다 — 같은 칸 다른 값이 없으면 검증이 통과시킨 값 중 다른 칸에서 쓰이는 값, 그것도 없으면 바꿀 값 없음
    const okv = [...precheckHints.ok].filter(v => v !== cur.trim().toUpperCase() && !precheckHints.bad.has(v)); if (okv.length) { const hit = await nscm.page.evaluate(`(() => { const c = ${probe.CTL_SRC}; if (!c) return null; const want = new Set(${JSON.stringify(okv)}); for (let r = 0; r < Math.min(c.rows.length, 5000); r++) { const d = c.rows[r].dataItem; if (!d) continue; for (const v of Object.values(d)) { if (typeof v === 'string' && want.has(v.trim().toUpperCase())) return v.trim(); } } return null; })()`).catch(() => null) as string | null; if (hit) return hit; }
    if (precheckHints.bad.size || precheckHints.ok.size) return null; }
  const cands = await probe.candidates(nscm.page, row, b);
  if (cands && cands.length) return cands.find(v => v.trim() && !same(v, cur) && !same(v.split(/\s+/)[0], cur)) ?? null;
  const t = norm(cur);
  // 2026-11-18 미검증 해소(SCP0096 WORKING_TIME_DEFAULT 원값 7 → 8 입력 거부 · AS-IS 최대 7): AS-IS 셀 규칙(cell_rules.csv min·max) 범위 안에서 다른 값을 고른다
  let lo = -Infinity, hi = Infinity;
  try {
    const menu = String((nscm as unknown as { curMenu?: string }).curMenu || '').toUpperCase();
    const fp = path.join(__dirname, '..', '..', '..', 'Doc', 'asisfacts', 'screens', menu, 'cell_rules.csv');
    if (menu && fs.existsSync(fp)) {
      const lines = fs.readFileSync(fp, 'utf8').replace(/^﻿/, '').split(/\r?\n/); const hd = (lines[0] || '').split(',').map(x => x.replace(/"/g, ''));
      const iC = hd.indexOf('column'), iMin = hd.indexOf('min'), iMax = hd.indexOf('max');
      const hitLine = lines.slice(1).map(l => l.split(',')).find(c => (c[iC] || '').replace(/"/g, '') === b);
      if (hitLine) { const mn = Number((hitLine[iMin] || '').replace(/"/g, '')), mx = Number((hitLine[iMax] || '').replace(/"/g, '')); if ((hitLine[iMin] || '') !== '' && !isNaN(mn)) lo = mn; if ((hitLine[iMax] || '') !== '' && !isNaN(mx)) hi = mx; }
    }
  } catch { /* 규칙 없음 = 종전 동작 */ }
  if (t === '') return String(Math.max(lo === -Infinity ? 1 : lo, Math.min(1, hi)));
  if (!isNaN(Number(t))) { const n = Number(t); if (n + 1 <= hi) return String(n + 1); if (n - 1 >= lo) return String(n - 1); return null; }
  if (/^\d{4}[-./]\d{2}[-./]\d{2}/.test(t)) return null;  // 날짜 왕복은 E2 경로
  return t + 'X';
}

/** 실제 키보드 입력(결과 확인 없음) — 규칙 밖 값 거부 시험용 */
export async function typeRaw(nscm: Nscm, row: number, b: string, value: string): Promise<string> {
  const p = nscm.page; await probe.endEdit(p).catch(() => false); await p.waitForTimeout(150);
  // 더블클릭이 편집기를 열 때까지 좌표를 다시 잡아 재시도 — 스크롤 직후 그리기 전 좌표로 빗나간다(2026-10-31 SCP0096 포커스 BODY). 끝내 안 열리면 입력하지 않는다(화면에 잘못 타이핑 금지)
  let ed = '';
  for (let k = 0; k < 4; k++) {
    const pt = await probe.cellCenter(p, row, b); if (!pt) return '셀 위치 없음';
    await p.waitForTimeout(250 + k * 250); const pt2 = await probe.cellCenter(p, row, b); if (!pt2) return '셀 위치 없음';
    const dlgN = await p.locator('[role="dialog"]:visible').count().catch(() => 0);  // T350: 더블클릭 전 대화상자 수(사실 파일 없는 화면도 새로 열린 입력 팝업을 닫는다)
    await p.mouse.dblclick(pt2.x, pt2.y); await p.waitForTimeout(300);
    await nscm.dismissDblPopup(() => p.mouse.click(pt2.x, pt2.y), dlgN);  // 2026-11-16 SCP0104: 더블클릭이 선택 팝업도 여는 화면 — 닫고 F2
    ed = String(await p.evaluate('(() => { const a = document.activeElement; return a ? a.tagName + ":" + (a.value ?? "") : "" })()').catch(() => ''));
    if (/^(INPUT|TEXTAREA)/.test(ed)) break;
  }
  if (!/^(INPUT|TEXTAREA)/.test(ed)) return ed;
  await p.keyboard.press('Control+A').catch(() => undefined); if (value === '') await p.keyboard.press('Delete'); else await p.keyboard.type(value, { delay: 40 }); await p.keyboard.press('Enter'); await p.waitForTimeout(300); await nscm.clearDialogs(); return ed;
}

/** 셀에 값 넣기 — 편집기 값 주입 뒤 표시가 안 바뀌면 실제 키보드로 입력한다(숫자 편집기가 주입 값을 안 받는 화면 · 2026-10-31 SCP0096). 끝내 안 바뀌면 false = 입력 경로 실패(화면 결함 단정 금지) */
export async function typeCell(nscm: Nscm, row: number, b: string, value: string): Promise<{ ok: boolean; how: string }> {
  const p = nscm.page; const before = (await probe.displayText(p, row, b)) ?? '';
  const hit = async () => { const v = (await probe.displayText(p, row, b)) ?? ''; return same(v, value) || same(v.split(/\s+/)[0], value); };
  // 콤보 셀만 편집기 주입 — 그 외는 사용자와 같은 키보드 입력을 먼저 쓴다. 편집기 주입이 남긴 상태가 뒤이은 입력을 먹어 화면 결함처럼 보였다(2026-10-31 SCP0096 순수 키보드 진단으로 확인)
  const cands = await probe.candidates(p, row, b);
  if (cands && cands.length) { if (await probe.setByEditor(p, row, b, value)) { await p.waitForTimeout(250); if (await hit()) return { ok: true, how: '편집기' }; } }
  const ed = await typeRaw(nscm, row, b, value); if (await hit()) return { ok: true, how: '키보드' };
  if (!cands || !cands.length) { if (await probe.setByEditor(p, row, b, value)) { await p.waitForTimeout(250); if (await hit()) return { ok: true, how: '편집기' }; } }
  const v2 = (await probe.displayText(p, row, b)) ?? ''; return { ok: false, how: `입력 안 됨('${before}'→'${v2}' · 더블클릭 뒤 포커스 ${ed})` };
}

/** 2026-11-25 T555(SCP0005 V-4e4af2a4 'LT_TYPE r1103 '/'→'AVERAGE' 재조회 OK · 원복 입력 실패 · 이후 컬럼 중단'): 원값 '/'(TO-BE NOT NULL 빈 값 표시 · 과도기 '-')는 콤보 후보에 없어
 *  고르기(편집기·키보드)로는 되돌릴 수 없다. 사용자가 칸을 비우는 방식(편집기에서 지우기 → 셀 선택 뒤 Delete)으로 비우고, 저장 뒤 '/' 는 빈 값과 같은 것으로 본다(sameRestore).
 *  원값이 빈 값 계열이 아니거나 그 값이 콤보 후보에 있으면 종전 typeCell 결과 그대로(실패를 숨기지 않는다) */
export async function restoreCell(nscm: Nscm, row: number, b: string, orig: string): Promise<{ ok: boolean; how: string }> {
  const p = nscm.page; const r = await typeCell(nscm, row, b, orig); if (r.ok) return r;
  if (!emptyLike(orig)) return r;
  const cands = await probe.candidates(p, row, b).catch(() => null);
  if (cands && cands.some(v => v.trim() !== '' && same(v, orig))) return r;  // 빈 값 표시가 실제 후보인 칸 — 고르기 실패는 그대로 실패
  const shown = async () => (await probe.displayText(p, row, b).catch(() => null)) ?? '';
  const r2 = await typeCell(nscm, row, b, ''); if (r2.ok || emptyLike(await shown())) return { ok: true, how: `빈 값 표시 '${orig}' → 칸 비움(${r2.how})` };
  const pt = await probe.cellCenter(p, row, b).catch(() => null);
  // Delete 는 선택된 칸만 지운다 — 클릭이 다른 칸을 집었으면(다른 행 값 삭제 위험) 누르지 않는다
  const selOk = async () => !!(await p.evaluate(`(() => { const c = ${probe.CTL_SRC}; const col = c && c.columns.getColumn(${JSON.stringify(b)}); const s = c && c.selection; return !!(col && s && s.row === ${row} && s.row2 === ${row} && s.col === col.index && s.col2 === col.index); })()`).catch(() => false));
  if (pt) { await probe.endEdit(p).catch(() => false); await p.mouse.click(pt.x, pt.y); await p.waitForTimeout(200); if (!(await selOk())) return { ok: false, how: `${r.how} · 칸 비우기 실패(선택 칸 불일치 — Delete 안 누름)` }; await p.keyboard.press('Delete'); await p.waitForTimeout(300); await nscm.clearDialogs(); if (emptyLike(await shown())) return { ok: true, how: `빈 값 표시 '${orig}' → 셀 선택 뒤 Delete` }; }
  return { ok: false, how: `${r.how} · 칸 비우기 실패('${await shown()}')` };
}

/** 2026-11-25 T556: 원복을 끝내지 못해 DB 복원(restore_touched)에 맡긴 행의 ID 칸 값 — 이후 시험 행 고르기(editableValueRow)에서 뺀다.
 *  같은 행을 다시 고쳐 저장하면 touched_rows 에 '바뀐 값' 기록이 덧붙어 restore_touched 가 편집 전 값으로 되돌린 뒤 다시 덮을 수 있다 */
export const delegatedRows: { k: string; v: string }[] = [];
async function delegatedRowIdx(p: import('@playwright/test').Page): Promise<number[]> {
  if (!delegatedRows.length) return [];
  return p.evaluate(`(() => { const c = ${probe.CTL_SRC}; if (!c) return []; const ids = ${JSON.stringify(delegatedRows)}; const out = []; for (let r = 0; r < c.rows.length; r++) { const d = c.rows[r].dataItem; if (d && ids.some(x => String(d[x.k] ?? '') === x.v)) out.push(r); } return out; })()`).catch(() => []) as Promise<number[]>;
}

/** 이번 실행의 저장 요청 소요(ms) — 요청 시작~응답 끝 */
export const saveDurs: number[] = [];
async function saveReload(nscm: Nscm): Promise<{ called: boolean; err: string; msg: string; precheck: boolean; calls: { btn: string; pre?: string }[] }> {
  const s = await nscm.save({ timeout: 20_000 });
  // 2026-11-20 T372(SSP0014 V-9bcbf1f5 'USER_ID r20 → njlilian 재조회 njzhoumengwei NG'): 저장 전 검증 호출(USER_CHECK)만 나가고 검증 알림으로 멈춘 것을 '저장 요청 있음'으로 세어 값 불일치로 기록했다
  //   → SAVE 류 호출 없이 검증 호출만 있고 화면이 업무 검증 문구를 띄웠으면 저장 요청 없음(업무 검증 차단)으로 본다. 문구가 없으면 종전대로(저장 버튼 이름이 SAVE 류가 아닌 화면 보호)
  const precheck = !!s.preCheckOnly && classifyNoCall(s.message || '') === 'VALIDATION';
  const called = s.calls.length > 0 && !precheck;
  // 2026-11-17 SCP0104 Y_2031(진단 04:2x: called=true · msg=''): 저장 실패 알림이 save() 반환 뒤에 떠서 문구를 못 읽고, 이어지는 재조회가 알림을 닫았다 → 재조회 전에 2초 안에 뜨는 알림 문구를 읽는다
  if (called && !(s.message || '').trim()) {
    const loc = nscm.page.locator('[role="dialog"], [role="alertdialog"], [role="alert"], .MuiSnackbar-root, .Toastify__toast'); const end = Date.now() + 2_000;
    while (Date.now() < end) { const n = Math.min(await loc.count().catch(() => 0), 10); let got = ''; for (let i = 0; i < n; i++) { const e = loc.nth(i); if (await e.isVisible().catch(() => false)) { got = ((await e.innerText().catch(() => '')) || '').replace(/\s+/g, ' ').trim(); if (got) break; } } if (got) { s.message = got; break; } await nscm.page.waitForTimeout(200); }
  }
  // 2026-11-17 SCP0104 Y_2031(ORA-01840): 응답 본문이 기록되지 않는 호출이 있어 'ORA-' 만으로는 저장 실패를 못 잡았다 — 화면 실패 문구·RESULT_CODE F 도 저장 오류로 본다
  const bad = s.calls.filter(c => c.status >= 400).map(c => `HTTP ${c.status}`).join(',') || (/ORA-|PLS-|SQL Error|SQLException|저장에 실패|Failed to save|"RESULT_CO?DE?"\s*:\s*"F"/i.exec(`${s.message || ''} ${s.calls.map(c => c.res || '').join(' ')}`) || [''])[0];
  // 저장이 없으면 그리드에 수정이 남아 조회 버튼이 확인창을 띄운다 — 짧게 눌러 확인창을 닫고 조회를 기다린다(2026-10-31 차단 왕복 2분 24초 실측 · 재측정으로 효과 확인)
  if (called) await nscm.search(); else { await nscm.search({ timeout: 4_000 }); await nscm.clearDialogs(); await nscm.page.waitForLoadState('networkidle', { timeout: 8_000 }).catch(() => undefined); }
  await nscm.page.waitForTimeout(800); await probe.waitRows(nscm.page, 30_000).catch(() => undefined); await nscm.clearDialogs();
  saveDurs.push(...s.calls.filter(c => /SAVE|INS|UPD|DEL/i.test(c.btn) && c.dur != null).map(c => c.dur as number));
  return { called, err: bad, msg: (s.message || '').replace(/\s*(Confirm|확인|OK|Cancel|취소)\s*/g, ' ').replace(/\s+/g, ' ').trim(), precheck, calls: s.calls };
}

/** 한 셀 왕복: 값 변경 → 저장 → 재조회 대조 → 원복 → 저장 → 재조회 대조. stop=true 면 행을 잃은 것 — 호출부가 더 진행하면 안 된다 */
/** 저장 전 행을 기록 — 원복 실패·다른 칸 변경 때 restore_touched.py 가 DB 에서 되돌린다(T39) */
// 2026-11-25 T556: 기록했는지(이미 같은 기록이 있는 경우 포함)를 돌려준다 — false 면 체인 끝 DB 복원이 없으므로 원복 실패 때 반드시 멈춘다
export function recordTouched(item: Record<string, unknown>, at: string): boolean {
  const id = (process.env.VERIFY_ID || '').toUpperCase(); if (!id || process.env.CL_MUTATE) return false;
  const fp = path.join(__dirname, '..', '..', '..', 'Doc', 'verify', id, 'touched_rows.json');
  let cur: unknown[] = []; try { cur = JSON.parse(fs.readFileSync(fp, 'utf8')); } catch { cur = []; }
  const same0 = JSON.stringify(item); if ((cur as { item: unknown }[]).some(x => JSON.stringify(x.item) === same0)) return true; cur.push({ at, item });
  fs.mkdirSync(path.dirname(fp), { recursive: true }); fs.writeFileSync(fp, JSON.stringify(cur)); return true;  // 쓰기 실패는 종전처럼 예외(저장 전에 멈춤)
}

/** T452(2026-11-20 SCP0005 F1·F6 4행 '재조회 행 식별 0건'): 식별 문자열은 숫자 칸을 뺀다(ROUTE_ID 같은 숫자 키 제외). 시험 칸이 업무 키(FROM_COUNTRY)이면
 *  저장 뒤 같은 문자 칸 조합이 다른 행과 겹치거나 SP·재조회가 연동 칸(도시명 등)을 함께 바꿔 3칸 넘게 달라져 행을 잃는다.
 *  편집 전 그리드에서 값이 유일한 ID 칸(이름이 ID·_ID·_SEQ 로 끝나고 시험 칸·감사 칸이 아님)을 잡아 두고, 식별이 실패할 때만 그 칸 값으로 다시 찾는다 */
async function uniqueIdKey(p: import('@playwright/test').Page, row: number, b: string): Promise<{ k: string; v: string } | null> {
  return p.evaluate(`(() => { const c = ${probe.CTL_SRC}; const d = c && c.rows[${row}] && c.rows[${row}].dataItem; if (!d) return null; const ks = Object.keys(d).filter(k => k !== ${JSON.stringify(b)} && /(^|_)(ID|SEQ)$/i.test(k) && !/^(CRUD_TYPE|LAST_UPDATE|LAST_UPDATED|CREATION_DATE|CREATED_BY|__)/i.test(k) && d[k] != null && String(d[k]) !== ''); for (const k of ks) { const v = String(d[k]); let n = 0; for (let r = 0; r < c.rows.length && n < 2; r++) { const e = c.rows[r].dataItem; if (e && String(e[k] ?? '') === v) n++; } if (n === 1) return { k, v }; } return null; })()`).catch(() => null) as Promise<{ k: string; v: string } | null>;
}
/** T457: 편집 전 행 값(item0)과 지금 그 행 값의 차이 — 문자 칸만(rowIdentity 와 같은 범위) · 시험 칸과 그 파생 칸(<칸>_*) · 감사 칸 제외 */
async function sideDiff(p: import('@playwright/test').Page, row: number, item0: Record<string, unknown>, b: string): Promise<string[]> {
  const cur = await p.evaluate(`(() => { const c = ${probe.CTL_SRC}; const d = c && c.rows[${row}] && c.rows[${row}].dataItem; return d ? JSON.parse(JSON.stringify(d)) : null; })()`).catch(() => null) as Record<string, unknown> | null;
  if (!cur) return [];
  const out: string[] = []; const lk = linkedCols(b, Object.keys(item0));  // T534
  for (const k of Object.keys(item0).sort()) { const v0 = item0[k]; if (k === b || k.startsWith(`${b}_`) || lk.includes(k) || /^(CRUD_TYPE|LAST_UPDATE|LAST_UPDATED|CREATION_DATE|CREATED_BY|__)/i.test(k) || typeof v0 === 'number' || (v0 !== null && typeof v0 === 'object')) continue; if (String(v0 ?? '') !== String(cur[k] ?? '')) out.push(`${k} '${String(v0 ?? '')}'→'${String(cur[k] ?? '')}'`); }
  return out;
}

async function rowsById(p: import('@playwright/test').Page, id: { k: string; v: string } | null): Promise<number[]> {
  if (!id) return [];
  return p.evaluate(`(() => { const c = ${probe.CTL_SRC}; if (!c) return []; const out = []; for (let r = 0; r < c.rows.length; r++) { const e = c.rows[r].dataItem; if (e && String(e[${JSON.stringify(id.k)}] ?? '') === ${JSON.stringify(id.v)}) out.push(r); } return out; })()`).catch(() => []) as Promise<number[]>;
}

/** 2026-11-25 T597(SCP0005 V-be38da4d '경계값 99 저장 요청 없음 · 화면 메시지 Priority는 양의 정수입니다.'): 앞 단계(빈값 저장)가 입력 실패로 일찍 끝나며
 *  r360 PRIORITY 를 '0' 으로 바꾼 채(CRUD_TYPE 'M') 재조회 없이 돌아가, 다음 단계 저장이 그 행 검증(TO-BE useDistributionRouteValidation:31)에 막혔다.
 *  화면에 남은 수정 행(CRUD_TYPE I·M·U·D) 수 — 그리드가 없으면 -1 */
export async function dirtyRows(p: import('@playwright/test').Page): Promise<number> {
  return p.evaluate(`(() => { const c = ${probe.CTL_SRC}; if (!c) return -1; let n = 0; for (let r = 0; r < c.rows.length; r++) { const d = c.rows[r].dataItem; if (d && /^[IMUD]$/i.test(String(d.CRUD_TYPE ?? '').trim())) n++; } return n; })()`).catch(() => -1) as Promise<number>;
}
/** T597: 수정 행이 남아 있으면 재조회로 버린다(조회 확인창은 clearDialogs 가 닫음 · saveReload 차단 경로와 같은 절차). before = 버리기 전 수 · left = 버린 뒤 남은 수 */
export async function ensureClean(nscm: Nscm): Promise<{ before: number; left: number }> {
  const p = nscm.page; const before = await dirtyRows(p); if (before <= 0) return { before, left: Math.max(before, 0) };
  await probe.endEdit(p).catch(() => false);
  await nscm.search({ timeout: 4_000 }).catch(() => undefined); await nscm.clearDialogs(); await p.waitForLoadState('networkidle', { timeout: 8_000 }).catch(() => undefined);
  await p.waitForTimeout(500); await probe.waitRows(p, 30_000).catch(() => undefined); await nscm.clearDialogs();
  let left = await dirtyRows(p);
  if (left > 0) { await nscm.search().catch(() => undefined); await nscm.clearDialogs(); await probe.waitRows(p, 30_000).catch(() => undefined); left = await dirtyRows(p); }
  return { before, left };
}

export async function cellRoundTrip(nscm: Nscm, row: number, b: string, value?: string, hooks: { afterSave?: () => Promise<void>; guardKeys?: string[] } = {}): Promise<Trip & { stop: boolean; newRow: number }> {
  const p = nscm.page; const orig = (await probe.displayText(p, row, b)) ?? '';
  const keyBefore = hooks.guardKeys && hooks.guardKeys.length ? (await probe.rowItem(p, row).catch(() => null)) as Record<string, unknown> | null : null;  // T74
  const item0 = await p.evaluate(`(() => { const c = ${probe.CTL_SRC}; const d = c && c.rows[${row}] && c.rows[${row}].dataItem; return d ? JSON.parse(JSON.stringify(d)) : {}; })()`).catch(() => ({})) as Record<string, unknown>;
  const ex = identExclude(b, Object.keys(item0)); const ident = await probe.rowIdentity(p, row, ex);  // T534: 시험 칸과 함께 바뀌는 연동 칸(USER_NAME)은 행 식별에서 뺀다
  const localAt = new Date(Date.now() - 3_000 - new Date().getTimezoneOffset() * 60_000).toISOString().slice(0, 19);  // T152: 편집 전 값
  const t: Trip & { stop: boolean; newRow: number } = { b, row, orig, next: '', called: false, ok: false, got: '', restored: false, note: '', stop: false, newRow: row };
  const idKey = await uniqueIdKey(p, row, b);  // T452
  // 원값이 빈칸이면 DB 에 그 행이 없을 수 있다(조회가 외부 조인으로 만든 칸) — 저장하면 새 행이 생기고 원복이 안 된다(2026-10-31 SCP0028 LOT_SIZE 잔존 사고)
  // 2026-11-06 사용자 지시(SCP0084 MEMO 전 행 빈 값): 빈 칸도 저장 시험 대상 — 값 입력 → 저장 → 재조회 확인 → 지움 → 저장 → 재조회 확인(빈 값 저장 경로까지 측정)
  if (norm(orig) === '') t.note = '원값 빈칸 — 입력·저장 후 지워서 저장까지 왕복';
  const nv = value ?? await nextOf(nscm, row, b, orig);
  if (nv == null) { t.note = '바꿀 값 없음(후보 1개·날짜)'; t.restored = true; return t; }
  t.next = nv;
  const ti = await typeCell(nscm, row, b, nv);
  if (!ti.ok) {
    // 2026-11-25 T595(SCP0005 V-72fbb5b2 'PRIORITY r360 '4'→빈값 · [입력 경로 실패] · 칸 표시 '0''): 화면이 빈 숫자 칸을 0 으로 바꾸는 경우(TO-BE DistributionRouteGrid.tsx:134 clampIntRange 0~99 ·
    //   AS-IS 도 빈값을 "0" 으로 읽음 cs:1289) 입력 실패가 아니라 '빈값 → 0' 입력이다 → 저장까지 재고(차단 문구 수집) 판정은 호출부가 AS-IS 와 대조한다. 원값이 0·빈값이면 바뀐 것이 없으니 종전대로
    const shownNow = norm((await probe.displayText(p, row, b).catch(() => null)) ?? '');
    if (nv === '' && shownNow === '0' && norm(orig) !== '' && !isNaN(Number(norm(orig))) && Number(norm(orig)) !== 0) { t.blankAs = '0'; t.note = `빈값 입력 → 칸 '0' 표시(화면이 빈값을 0 으로 바꿈 · T595)`; }
    else {
      t.note = `입력 경로 실패: ${ti.how}`; t.inputFail = true; t.restored = true;
      // T597: 입력 실패라도 칸이 바뀌었으면(빈값 → 0 · 잘린 값) 화면에 수정 행이 남는다 → 버리고 돌아간다(다음 단계 저장 검증에 걸리지 않게)
      const dc = await ensureClean(nscm); if (dc.before > 0) t.note += ` · 남은 수정 ${dc.before}행 재조회로 버림${dc.left > 0 ? ` · ⚠ 그래도 ${dc.left}행 남음` : ''}(T597)`;
      return t;
    }
  }
  // 2026-11-06 T74(SCP0122 F6 허위 FAIL): 입력이 같은 행의 저장 키를 함께 바꾸는 연동 칸(OPMZ_ACTV_NAME → OPMZ_ACTV_CD)이면 저장하지 않는다 —
  //   키가 바뀐 실저장은 행 식별·DB 전후 대조·복원이 키를 따라가지 못한다(행 수 '삭제 1' 오판 · 원복 실패). 재조회로 입력을 버리고 제외로 돌려준다
  if (keyBefore && hooks.guardKeys) { const after = (await probe.rowItem(p, row).catch(() => null)) as Record<string, unknown> | null; const ch = after ? hooks.guardKeys.filter(k => k in keyBefore && String(keyBefore[k] ?? '') !== String(after[k] ?? '')) : []; if (ch.length) { t.keyLinked = ch.map(k => `${k} '${String(keyBefore[k] ?? '')}'→'${String(after![k] ?? '')}'`).join(', '); t.note = `[저장 키 연동] ${b} 입력이 저장 키를 바꿈(${t.keyLinked}) — 실저장 제외`; t.restored = true; await nscm.search().catch(() => undefined); await nscm.clearDialogs().catch(() => undefined); return t; } }
  // 2026-11-07 T152(SCP0037 F6): 기록 값은 '편집 전' 행이어야 한다 — 입력(typeCell) 뒤에 읽은 dataItem 은 이미 바뀐 값(LT_DAY 6 · 빈값 None)이라 restore_touched 가 편집 값으로 '복원'한다
  const rec = recordTouched(item0, localAt);  // 저장 직전(편집 전) 값 기준 — 왕복 원복이 성공해도 SP 가 다른 칸을 바꿨을 수 있다(2026-11-02 SALES_PLAN_ADJUST_YN)
  let s1 = await saveReload(nscm); t.called = s1.called;
  // T372: 팝업 입력 칸 시험 값이 저장 전 검증에 막히면(재조회로 입력이 버려짐) 검증이 통과시킨 값으로 최대 2번 다시 — 저장 경로 자체를 재기 위함. 값을 정해 넘긴 시험(value 지정)은 다시 고르지 않는다
  for (let k = 0; k < 2 && !s1.called && s1.precheck && value == null && await probe.popupColumn(p, b); k++) {
    notePrecheck(s1.calls, t.next, s1.msg, item0); const h0 = await probe.findRowsByIdentity(p, ident, ex); if (h0.length !== 1) break;
    if (await rowHasBad(nscm, h0[0], b)) { t.rowBad = true; t.note += `${t.note ? ' · ' : ''}행의 다른 칸 값이 저장 전 검증에 막힘(${s1.msg.slice(0, 60)})`; break; }  // T377: 값을 바꿔도 같은 행은 막힘
    const nv2 = await nextOf(nscm, h0[0], b, orig); if (nv2 == null || nv2 === t.next) break;
    t.note += `${t.note ? ' · ' : ''}저장 전 검증 차단 '${t.next}'(${s1.msg.slice(0, 60)}) → '${nv2}' 재시도`; t.next = nv2; row = h0[0]; t.row = row;
    const ti2 = await typeCell(nscm, row, b, nv2); if (!ti2.ok) break;
    s1 = await saveReload(nscm); t.called = s1.called;
  }
  if (!s1.called && s1.precheck) { notePrecheck(s1.calls, t.next, s1.msg, item0); if (!t.rowBad) t.rowBad = await rowHasBad(nscm, (await probe.findRowsByIdentity(p, ident, ex))[0] ?? row, b); }
  if (/^Y_|^M_/.test(b) && !orig) console.log(`[saveprobe 진단] ${b} r${row} 저장 called=${s1.called} err='${s1.err}' msg='${s1.msg.slice(0, 120)}'`);  // 2026-11-17 Y_2031 저장 실패 인식 진단
  if (!s1.called) { t.note = `${t.blankAs ? `${t.note} · ` : ''}${s1.msg ? `화면 메시지 '${s1.msg.slice(0, 80)}'` : '화면 메시지 없음'}`; t.msg = s1.msg; t.blocked = classifyNoCall(s1.msg); t.restored = true;
    // 2026-11-25 T597: 재조회가 확인창 때문에 끝나지 않으면 수정 행이 남는다 — 다시 버리고 남으면 증거에 남긴다(원복 OK 를 그대로 믿지 않음)
    const dc = await ensureClean(nscm); if (dc.before > 0) { t.note += ` · 남은 수정 ${dc.before}행 재조회로 버림(T597)`; if (dc.left > 0) { t.restored = false; t.note += ` · ⚠ 그래도 ${dc.left}행 남음`; } }
    return t; }  // 재조회로 입력이 버려졌으므로 DB 변화 없음  // 재조회로 입력이 버려졌으므로 DB 변화 없음
  if (hooks.afterSave) await hooks.afterSave();  // 저장 직후 DB 스냅샷(2026-11-01 EG235·EG237·EG240)
  if (s1.err) t.note = `저장 오류 ${s1.err}`;
  // 2026-11-17 SCP0104(Y_2031 저장 ORA-01840 뒤 '재조회 행 식별 0건'으로 중단 → 빈 값·0 값·2행 저장 3행 미검증): 저장이 DB 오류로 실패하면 SP 가 되돌려(ROLLBACK TO SAVEPOINT) DB 변화가 없다
  //   → 실패(ok=false)로 세고 원복 불필요로 돌려준다. 다음 칸 진행을 막지 않는다
  if (s1.err) { t.got = ''; t.ok = false; t.restored = true; t.note += ' · 저장 실패라 DB 변화 없음(원복 불필요)'; return t; }
  let h1 = await probe.findRowsByIdentity(p, ident, ex); let sideEffect = '';
  // T457(2026-11-20 SCP0005 재검 09:43 V-4e4af2a4): ID 칸이 있으면 '가장 비슷한 행'(findRowNear)보다 먼저 쓴다 — 비슷한 행 찾기가 다른 행(LT_TYPE 까지 다른 r359)을 집어 'FROM_CITY 재조회 NG'로 읽었다.
  //   다른 칸 변경은 편집 전 값과 그 행 값을 직접 비교하고, 시험 칸에서 파생된 칸(이름이 '<시험 칸>_' 로 시작 · TRANSPORT_MODE_NAME)은 변경으로 세지 않는다
  if (h1.length !== 1 && idKey) { const hid = await rowsById(p, idKey); if (hid.length === 1) { h1 = hid; t.note += ` · 행 식별 = ${idKey.k} '${idKey.v}'(T452)`; sideEffect = (await sideDiff(p, hid[0], item0, b)).join(', '); if (sideEffect) t.note += ` · ⚠ 저장이 다른 칸도 바꿈(restore_touched 가 DB 복원): ${sideEffect}`; } }
  if (h1.length !== 1) { const near = await probe.findRowNear(p, ident, ex); if (near) { h1 = [near.row]; sideEffect = near.diff.filter(d => !d.startsWith(`${b}_`)).join(', '); if (sideEffect) t.note += ` · ⚠ 저장이 다른 칸도 바꿈(restore_touched 가 DB 복원): ${sideEffect}`; } }
  // 2026-11-17 SCP0111: 행 식별이 1건이 아니면 t.got 은 초기값 '' 로 남아 판정이 "재조회 '' NG" 로 읽은 값처럼 찍혔다 — 판독 안 함으로 적고 후보 행들의 그 칸 값을 남긴다
  if (h1.length !== 1) { const cand = await Promise.all(h1.slice(0, 4).map(async r => `r${r}=${(await probe.displayText(p, r, b).catch(() => null)) ?? '?'}`)); t.got = '(판독 안 함)'; t.note += ` 재조회 행 식별 ${h1.length}건${cand.length ? ` — 후보 ${b} 값 ${cand.join(' · ')}` : ''}`;
    // 0건 = 행을 잃음(이후 칸도 같은 행을 못 찾음) → 중단. 2건 이상 = 저장이 행을 나눔(SCP0111 BOH 값별 조회 행 분리) → 이 칸만 판독 불가로 두고 다음 칸·다음 시험 계속(DB 는 체인 끝 restore_touched 가 복원 — 11-18 00:22 실측 잔존 0)
    t.stop = h1.length === 0; if (h1.length > 1) t.note += ' · 다음 칸 계속(DB 복원은 restore_touched)'; return t; }
  t.got = (await probe.displayText(p, h1[0], b)) ?? ''; t.ok = !s1.err && same(t.got, nv);
  if (same(t.got, orig)) { t.restored = true; t.newRow = h1[0]; return t; }  // 저장이 값을 바꾸지 않음 — 원복 불필요
  // 2026-11-25 T556(SCP0005 V-4e4af2a4 '원복 입력 실패 · 이후 컬럼 중단' → F1 31칸 중 1칸 · F6·2행 저장 3행 '[측정 중단]'): 원복을 끝내지 못해도
  //   (1) 편집 전 값이 touched_rows 에 기록됐고(rec) (2) 행을 다시 찾을 유일한 ID 칸(idKey)이 있으면 그 행은 체인 끝 restore_touched 가 DB 에서 되돌린다 →
  //   그 행을 이후 시험 행 고르기에서 빼고(delegatedRows) 남은 편집 입력은 재조회로 버린 뒤 다음 칸을 계속 잰다. 둘 중 하나라도 없으면 종전대로 멈춘다(VERIFY_NO_SAVE·CL_MUTATE·ID 칸 없는 화면)
  //   t.restored 는 false 로 남겨 증거에 '원복 NG' 가 그대로 찍힌다(판정 완화 없음)
  const delegate = async (why: string): Promise<typeof t> => {
    if (!rec || !idKey) { t.note += ` ${why}`; t.stop = true; return t; }
    delegatedRows.push(idKey); await nscm.search().catch(() => undefined); await nscm.clearDialogs().catch(() => undefined); await probe.waitRows(p, 30_000).catch(() => undefined);
    t.note += ` ${why} · [원복 DB 위임] ${idKey.k}=${idKey.v} 행은 restore_touched 가 편집 전 값(${localAt} 기록)으로 복원 · 이후 시험 행에서 제외 · 다음 칸 계속(T556)`; return t;
  };
  const rt = await restoreCell(nscm, h1[0], b, orig);  // T555: 원값 '/'·'-'·'' 이고 후보에 없으면 칸 비우기로 원복
  if (!rt.ok) return delegate(`원복 입력 실패(${rt.how.slice(0, 80)})`);
  if (rt.how.startsWith('빈 값 표시')) t.note += ` · 원복 ${rt.how}(T555)`;
  await saveReload(nscm);
  let h2 = await probe.findRowsByIdentity(p, ident, ex);
  if (h2.length !== 1 && idKey) { const hid2 = await rowsById(p, idKey); if (hid2.length === 1) h2 = hid2; }  // T452 · T457 ID 칸 먼저
  if (h2.length !== 1) { const near2 = await probe.findRowNear(p, ident, ex); if (near2) h2 = [near2.row]; }
  if (h2.length !== 1) { t.note += ` 원복 후 행 식별 ${h2.length}건`; t.stop = true; return t; }
  const back = (await probe.displayText(p, h2[0], b)) ?? '';
  t.restored = same(back, orig) || (emptyLike(orig) && sameRestore(back, orig)); t.newRow = h2[0];  // T555: 원값 '/' ↔ 재조회 ''·'-' 같음(빈 값 → '/' 저장 규칙)
  if (!t.restored) return delegate(`원복 불일치('${back}')`);
  // T546(2026-11-25 SCP0005 F1·F6 4행 '[측정 중단] 앞 단계 행 식별 실패'): FROM_COUNTRY 'CN'→'KR' 저장 뒤 조회가 (나라, 도시) 짝으로 붙여 오는 FROM_CITY_NAME 이 'NANJING'→'' 로 보였고
  //   원복('CN') 뒤에는 되돌아왔는데도 다른 칸 변경 1건만으로 중단해 31칸 중 2칸만 쟀다(e2e_results 00:56 run V-4e4af2a4). 원복 뒤 행을 편집 전 값과 다시 비교해 남은 변경이 있을 때만 중단한다
  if (sideEffect && t.restored) { const left = await sideDiff(p, h2[0], item0, b); if (left.length) { t.stop = true; t.note += ` · 원복 뒤에도 다른 칸 변경 남음: ${left.join(', ')}`; } else t.note += ' · 원복 뒤 다른 칸 편집 전 값으로 돌아옴(조회 파생 칸) — 다음 칸 계속'; }
  else if (sideEffect) t.stop = true;  // 다른 칸까지 바뀐 행은 사람이 되돌려야 한다 — 다음 칸으로 넘어가 더 바꾸지 않는다
  return t;
}

/** 2026-11-25 T635(SCP0005 V-26d2974c '저장 오류 저장에 실패 · r360·r361 행 식별 0건'): 2행 저장 시험 행 고르기 조건.
 *  시험 칸만 다른 형제 행(같은 행 식별 값 · 시험 칸 제외)이 화면에 있으면 그 칸을 바꿀 때 형제 행 값과 겹쳐 유일 키 충돌로 저장이 실패한다
 *  (SCP0005 ROUTE_ID 7303 AVERAGE · 7305 MAX · 같은 경로 MIN 1행 = LT_TYPE 3값 모두 사용 · UK_SCP_MST_DISTRIBUTION_ROUTE 에 LT_TYPE 포함) → 형제 행이 없는 행만 쓴다.
 *  돌려주는 값 = 행 식별 문자열(두 행 식별 값이 같은지 고르는 쪽에서 비교) · 형제 행이 있으면 null */
export async function soloIdentity(nscm: Nscm, r: number, b: string): Promise<string | null> {
  const p = nscm.page; const item = (await probe.rowItem(p, r).catch(() => null)) as Record<string, unknown> | null; const ex = identExclude(b, Object.keys(item || {}));
  const ident = String((await probe.rowIdentity(p, r, ex)) ?? ''); if (!ident) return null; const sib = await probe.findRowsByIdentity(p, ident, ex);
  return sib.length > 1 ? null : ident;
}

/** 2행 동시 저장 — 두 행의 같은 컬럼을 고쳐 Save 1회 → 두 행 대조 → 두 행 원복. 행은 행 전체 값으로만 찾는다 */
export async function twoRowSave(nscm: Nscm, rows: [number, number], b: string): Promise<{ result: 'PASS' | 'FAIL' | 'ERROR'; evidence: string; stop: boolean }> {
  const p = nscm.page; const items = [];
  const localAt = new Date(Date.now() - 3_000 - new Date().getTimezoneOffset() * 60_000).toISOString().slice(0, 19);  // T152 편집 전 값 기록 시각
  for (const r of rows) { const orig = (await probe.displayText(p, r, b)) ?? ''; if (norm(orig) === '') return { result: 'ERROR', evidence: `[측정 경로 없음] ${b} r${r}: 원값 빈칸 — DB 행이 없을 수 있어 제외`, stop: false }; const nv = await nextOf(nscm, r, b, orig); if (nv == null) return { result: 'ERROR', evidence: `[측정 경로 없음] ${b} r${r}: 바꿀 값 없음`, stop: false }; const item = (await probe.rowItem(p, r).catch(() => null)) as Record<string, unknown> | null; const ex = identExclude(b, Object.keys(item || {})); const raw0 = await p.evaluate(`(() => { const c = ${probe.CTL_SRC}; const d = c && c.rows[${r}] && c.rows[${r}].dataItem; return d ? JSON.parse(JSON.stringify(d)) : null; })()`).catch(() => null) as Record<string, unknown> | null; items.push({ r, orig, nv, ex, ident: await probe.rowIdentity(p, r, ex), item, raw0, idKey: await uniqueIdKey(p, r, b) }); }  // T534
  // 2026-11-25 T598(SCP0005 V-26d2974c '[측정 경로 없음] 두 행의 식별 값이 같음'): 행 식별 문자열은 숫자 칸을 뺀다(T452 · ROUTE_ID 제외) → 문자 칸이 모두 같고 숫자 칸(PRIORITY·ROUTE_ID)만 다른 두 경로가
  //   같은 식별 값이 됐다. 두 행 모두 값이 유일한 ID 칸(uniqueIdKey · ROUTE_ID)이 있고 값이 다르면 그 칸으로 찾는다. 없으면 종전대로 측정 경로 없음
  const dupIdent = items[0].ident === items[1].ident;
  if (dupIdent && !(items[0].idKey && items[1].idKey && !(items[0].idKey.k === items[1].idKey.k && items[0].idKey.v === items[1].idKey.v))) return { result: 'ERROR', evidence: `[측정 경로 없음] 두 행의 식별 값이 같음 · 유일한 ID 칸 ${items.map(it => it.idKey ? `${it.idKey.k}=${it.idKey.v}` : '없음').join(' / ')}`, stop: false };
  const locate = async (it: { ident: string; ex: string[]; idKey: { k: string; v: string } | null }): Promise<number[]> => { let h = dupIdent ? [] : await probe.findRowsByIdentity(p, it.ident, it.ex); if (h.length !== 1 && it.idKey) { const hid = await rowsById(p, it.idKey); if (hid.length === 1) h = hid; } return h; };
  const idNote = dupIdent ? ` · 행 식별 = ${items.map(it => `${it.idKey!.k} '${it.idKey!.v}'`).join(' · ')}(문자 칸 식별 값 같음 · T598)` : '';
  // T598: 2행 저장도 저장 직전(편집 전) 행을 기록한다 — 원복 실패 때 restore_touched 가 DB 에서 되돌린다(cellRoundTrip 과 같은 규칙)
  for (const it of items) if (it.raw0) recordTouched(it.raw0, localAt);
  for (const it of items) { const ti = await typeCell(nscm, it.r, b, it.nv); if (!ti.ok) { await nscm.search(); return { result: 'ERROR', evidence: `[입력 경로 실패] ${b} r${it.r}: ${ti.how}`, stop: false }; } }
  const s1 = await saveReload(nscm); if (!s1.called) { if (s1.precheck) for (const it of items) notePrecheck(s1.calls, it.nv, s1.msg, it.item ?? null);  /* T377 */ const k = classifyNoCall(s1.msg); return { result: k === 'NOCHANGE' ? 'FAIL' : 'ERROR', evidence: `${k === 'VALIDATION' ? '[업무 검증 차단] ' : k === 'UNKNOWN' ? '[사유 불명] ' : ''}${b} 두 행 수정 후 Save — 저장 요청 없음 · 메시지 '${s1.msg.slice(0, 100)}'`, stop: false }; }
  const ev: string[] = []; let bad = !!s1.err; let lost = false; const back: { r: number; orig: string; ident: string; ex: string[]; idKey: { k: string; v: string } | null }[] = [];
  for (const it of items) { const h = await locate(it); if (h.length !== 1) { lost = true; ev.push(`r${it.r} 행 식별 ${h.length}건 ⚠ 수동 원복 확인(원값 '${it.orig}')`); continue; } const v = (await probe.displayText(p, h[0], b)) ?? ''; const ok = same(v, it.nv); if (!ok) bad = true; ev.push(`r${it.r} '${it.orig}'→'${it.nv}' 재조회 '${v}' ${ok ? 'OK' : 'NG'}`); if (!same(v, it.orig)) back.push({ r: h[0], orig: it.orig, ident: it.ident, ex: it.ex, idKey: it.idKey }); }
  // 2026-11-25 T555: 원값 '/'·'-'·'' 이 콤보 후보에 없으면 칸 비우기로 원복 · 재조회 '/' ↔ '' 같음
  for (const b0 of back) { const ti = await restoreCell(nscm, b0.r, b, b0.orig); if (!ti.ok) { lost = true; ev.push(`r${b0.r} 원복 입력 실패 ⚠ 수동 원복 확인(원값 '${b0.orig}')`); } }
  if (back.length) { await saveReload(nscm); for (const b0 of back) { const h = await locate(b0); const v = h.length === 1 ? (await probe.displayText(p, h[0], b)) ?? '' : `(행 식별 ${h.length}건)`; const ok = h.length === 1 && (same(v, b0.orig) || (emptyLike(b0.orig) && sameRestore(v, b0.orig))); if (!ok) lost = true; ev.push(`원복 '${b0.orig}' ${ok ? 'OK' : `NG('${v}') ⚠ 수동 원복 확인`}`); } }
  return { result: lost ? 'ERROR' : bad ? 'FAIL' : 'PASS', evidence: `${b} 저장 1회 — ${ev.join(' · ')}${s1.err ? ` · 저장 오류 ${s1.err}` : ''}${idNote}`, stop: lost };
}

/** 값이 있고 편집 가능한 행(우선) — 없으면 빈 칸 행(2026-11-06 사용자 지시). skip 행 제외 · 없으면 -1 */
export async function editableValueRow(nscm: Nscm, b: string, skip: number[] = [], allCols: string[] = []): Promise<number> {
  // 다른 편집 칸이 빈 행은 DB 행이 없을 수 있다 — 기본값(Y/N)이 보이는 칸만 보면 DB 행 없는 행을 고르게 된다(2026-10-31 SCP0028 r0). 빈 편집 칸이 가장 적은 행부터 쓴다
  const p = nscm.page; const q = JSON.stringify(b); const cols = JSON.stringify(allCols.filter(c => c !== b)); const has = `d[${q}] != null && String(d[${q}]).trim() !== ''`;
  skip = [...skip, ...await delegatedRowIdx(p)];  // 2026-11-25 T556: 원복을 DB 복원에 맡긴 행은 다시 고치지 않는다
  const blanks = `${cols}.filter(c => d[c] == null || String(d[c]).trim() === '' || Number(d[c]) === 0).length`;
  // 2026-11-20 T377(SSP0014 MAIL_USER1~5 r0 '[User ID] 값은 필수'): 필수 칸이 빈 행·저장 전 검증에 막힌 값이 든 행은 저장 시험 행으로 쓰지 않는다
  const usable = async (r: number) => (await probe.requiredFilled(p, r)) && !(await rowHasBad(nscm, r, b));  // 0 도 같은 행의 업무 검증에 막힌다(2026-10-31 SCP0028 r3)
  for (let k = 0; k <= allCols.length; k++) {
    // 0 은 화면 업무 검증(0값·LOT<INC)에 막히기 쉬워 0 아닌 값을 먼저 쓴다(2026-10-31 SCP0028)
    const rs = [...await probe.findRowsByValue(p, `d => ${has} && ${blanks} === ${k} && Number(d[${q}]) !== 0`, 60), ...await probe.findRowsByValue(p, `d => ${has} && ${blanks} === ${k}`, 60)];
    for (const r of rs) { if (skip.includes(r)) continue; if (!(await usable(r))) continue; if (await probe.editable(p, r, b)) return r; }
    if (allCols.length === 0) break;
  }
  // 2026-11-06 사용자 지시: 값 있는 편집 행이 없으면 빈 칸 행도 쓴다(입력·저장 후 지워서 저장까지 왕복 — SCP0084 MEMO)
  for (const r of await probe.findRowsByValue(p, `d => !(${has})`, 60)) { if (skip.includes(r)) continue; if (!(await usable(r))) continue; if (await probe.editable(p, r, b)) return r; }
  return -1;
}
