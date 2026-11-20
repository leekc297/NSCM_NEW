import * as fs from 'fs';
import * as path from 'path';
// 저장 세부 프로브(2026-10-31 엔진 갭 E05 · EG186 컬럼별 왕복 · EG181/EG221 0·빈값 · EG182/EG225 2행 동시) — 기존행을 실제로 고쳐 저장·재조회하고 원복한다
//   안전 규칙: 행은 행 전체 값(rowIdentity)으로만 찾는다. 1건이 아니면 그 자리에서 멈추고 수동 원복 정보를 남긴다
import type { Nscm } from './nscm';
import { probe } from './probe';

/** Save 뒤 요청이 없을 때 사유 — 변경 인식 실패(결함) · 업무 검증 차단(입력값 문제 · 결함 아님) · 사유 불명(측정 실패) */
export function classifyNoCall(msg: string): 'NOCHANGE' | 'VALIDATION' | 'UNKNOWN' { if (!msg.trim() || /성공|success/i.test(msg)) return 'UNKNOWN'; if (/수정한 내용|변경.*없|No change|nothing/i.test(msg)) return 'NOCHANGE'; return 'VALIDATION'; }
export type Trip = { ms?: number; blocked?: 'NOCHANGE' | 'VALIDATION' | 'UNKNOWN'; inputFail?: boolean; keyLinked?: string; b: string; row: number; orig: string; next: string; called: boolean; ok: boolean; got: string; restored: boolean; note: string };
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
export function notePrecheck(calls: { btn: string; pre?: string }[], tried: string): void { const ok = precheckValues(calls); for (const v of ok) precheckHints.ok.add(v); if (tried && !ok.has(tried.trim().toUpperCase())) precheckHints.bad.add(tried.trim().toUpperCase()); }

export async function nextOf(nscm: Nscm, row: number, b: string, cur: string): Promise<string | null> {
  // T349(2026-11-19 SSP0014): 팝업 입력 칸(FPModal·FPTextModal)은 등록된 값만 저장된다(SSP0014 USER_CHECK 미등록 차단) — '원값+X' 는 저장 검증에 막혀 저장 시험이 안 된다 → 같은 칸 다른 행의 실제 값
  //   T372: 저장 전 검증에 막힌 값은 빼고, 검증이 통과시킨 값을 먼저
  if (await probe.popupColumn(nscm.page, b)) { const ov = await probe.otherColumnValue(nscm.page, b, cur, 5000, [...precheckHints.bad], [...precheckHints.ok]); if (ov) return ov; }
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
export function recordTouched(item: Record<string, unknown>, at: string): void {
  const id = (process.env.VERIFY_ID || '').toUpperCase(); if (!id || process.env.CL_MUTATE) return;
  const fp = path.join(__dirname, '..', '..', '..', 'Doc', 'verify', id, 'touched_rows.json');
  let cur: unknown[] = []; try { cur = JSON.parse(fs.readFileSync(fp, 'utf8')); } catch { cur = []; }
  const same0 = JSON.stringify(item); if ((cur as { item: unknown }[]).some(x => JSON.stringify(x.item) === same0)) return; cur.push({ at, item }); fs.mkdirSync(path.dirname(fp), { recursive: true }); fs.writeFileSync(fp, JSON.stringify(cur));
}

/** T452(2026-11-20 SCP0005 F1·F6 4행 '재조회 행 식별 0건'): 식별 문자열은 숫자 칸을 뺀다(ROUTE_ID 같은 숫자 키 제외). 시험 칸이 업무 키(FROM_COUNTRY)이면
 *  저장 뒤 같은 문자 칸 조합이 다른 행과 겹치거나 SP·재조회가 연동 칸(도시명 등)을 함께 바꿔 3칸 넘게 달라져 행을 잃는다.
 *  편집 전 그리드에서 값이 유일한 ID 칸(이름이 ID·_ID·_SEQ 로 끝나고 시험 칸·감사 칸이 아님)을 잡아 두고, 식별이 실패할 때만 그 칸 값으로 다시 찾는다 */
async function uniqueIdKey(p: import('@playwright/test').Page, row: number, b: string): Promise<{ k: string; v: string } | null> {
  return p.evaluate(`(() => { const c = ${probe.CTL_SRC}; const d = c && c.rows[${row}] && c.rows[${row}].dataItem; if (!d) return null; const ks = Object.keys(d).filter(k => k !== ${JSON.stringify(b)} && /(^|_)(ID|SEQ)$/i.test(k) && !/^(CRUD_TYPE|LAST_UPDATE|LAST_UPDATED|CREATION_DATE|CREATED_BY|__)/i.test(k) && d[k] != null && String(d[k]) !== ''); for (const k of ks) { const v = String(d[k]); let n = 0; for (let r = 0; r < c.rows.length && n < 2; r++) { const e = c.rows[r].dataItem; if (e && String(e[k] ?? '') === v) n++; } if (n === 1) return { k, v }; } return null; })()`).catch(() => null) as Promise<{ k: string; v: string } | null>;
}
async function rowsById(p: import('@playwright/test').Page, id: { k: string; v: string } | null): Promise<number[]> {
  if (!id) return [];
  return p.evaluate(`(() => { const c = ${probe.CTL_SRC}; if (!c) return []; const out = []; for (let r = 0; r < c.rows.length; r++) { const e = c.rows[r].dataItem; if (e && String(e[${JSON.stringify(id.k)}] ?? '') === ${JSON.stringify(id.v)}) out.push(r); } return out; })()`).catch(() => []) as Promise<number[]>;
}

export async function cellRoundTrip(nscm: Nscm, row: number, b: string, value?: string, hooks: { afterSave?: () => Promise<void>; guardKeys?: string[] } = {}): Promise<Trip & { stop: boolean; newRow: number }> {
  const p = nscm.page; const ident = await probe.rowIdentity(p, row, [b]); const orig = (await probe.displayText(p, row, b)) ?? '';
  const keyBefore = hooks.guardKeys && hooks.guardKeys.length ? (await probe.rowItem(p, row).catch(() => null)) as Record<string, unknown> | null : null;  // T74
  const item0 = await p.evaluate(`(() => { const c = ${probe.CTL_SRC}; const d = c && c.rows[${row}] && c.rows[${row}].dataItem; return d ? JSON.parse(JSON.stringify(d)) : {}; })()`).catch(() => ({})) as Record<string, unknown>; const localAt = new Date(Date.now() - 3_000 - new Date().getTimezoneOffset() * 60_000).toISOString().slice(0, 19);  // T152: 편집 전 값
  const t: Trip & { stop: boolean; newRow: number } = { b, row, orig, next: '', called: false, ok: false, got: '', restored: false, note: '', stop: false, newRow: row };
  const idKey = await uniqueIdKey(p, row, b);  // T452
  // 원값이 빈칸이면 DB 에 그 행이 없을 수 있다(조회가 외부 조인으로 만든 칸) — 저장하면 새 행이 생기고 원복이 안 된다(2026-10-31 SCP0028 LOT_SIZE 잔존 사고)
  // 2026-11-06 사용자 지시(SCP0084 MEMO 전 행 빈 값): 빈 칸도 저장 시험 대상 — 값 입력 → 저장 → 재조회 확인 → 지움 → 저장 → 재조회 확인(빈 값 저장 경로까지 측정)
  if (norm(orig) === '') t.note = '원값 빈칸 — 입력·저장 후 지워서 저장까지 왕복';
  const nv = value ?? await nextOf(nscm, row, b, orig);
  if (nv == null) { t.note = '바꿀 값 없음(후보 1개·날짜)'; t.restored = true; return t; }
  t.next = nv;
  const ti = await typeCell(nscm, row, b, nv);
  if (!ti.ok) { t.note = `입력 경로 실패: ${ti.how}`; t.inputFail = true; t.restored = true; return t; }
  // 2026-11-06 T74(SCP0122 F6 허위 FAIL): 입력이 같은 행의 저장 키를 함께 바꾸는 연동 칸(OPMZ_ACTV_NAME → OPMZ_ACTV_CD)이면 저장하지 않는다 —
  //   키가 바뀐 실저장은 행 식별·DB 전후 대조·복원이 키를 따라가지 못한다(행 수 '삭제 1' 오판 · 원복 실패). 재조회로 입력을 버리고 제외로 돌려준다
  if (keyBefore && hooks.guardKeys) { const after = (await probe.rowItem(p, row).catch(() => null)) as Record<string, unknown> | null; const ch = after ? hooks.guardKeys.filter(k => k in keyBefore && String(keyBefore[k] ?? '') !== String(after[k] ?? '')) : []; if (ch.length) { t.keyLinked = ch.map(k => `${k} '${String(keyBefore[k] ?? '')}'→'${String(after![k] ?? '')}'`).join(', '); t.note = `[저장 키 연동] ${b} 입력이 저장 키를 바꿈(${t.keyLinked}) — 실저장 제외`; t.restored = true; await nscm.search().catch(() => undefined); await nscm.clearDialogs().catch(() => undefined); return t; } }
  // 2026-11-07 T152(SCP0037 F6): 기록 값은 '편집 전' 행이어야 한다 — 입력(typeCell) 뒤에 읽은 dataItem 은 이미 바뀐 값(LT_DAY 6 · 빈값 None)이라 restore_touched 가 편집 값으로 '복원'한다
  recordTouched(item0, localAt);  // 저장 직전(편집 전) 값 기준 — 왕복 원복이 성공해도 SP 가 다른 칸을 바꿨을 수 있다(2026-11-02 SALES_PLAN_ADJUST_YN)
  let s1 = await saveReload(nscm); t.called = s1.called;
  // T372: 팝업 입력 칸 시험 값이 저장 전 검증에 막히면(재조회로 입력이 버려짐) 검증이 통과시킨 값으로 최대 2번 다시 — 저장 경로 자체를 재기 위함. 값을 정해 넘긴 시험(value 지정)은 다시 고르지 않는다
  for (let k = 0; k < 2 && !s1.called && s1.precheck && value == null && await probe.popupColumn(p, b); k++) {
    notePrecheck(s1.calls, t.next); const h0 = await probe.findRowsByIdentity(p, ident, [b]); if (h0.length !== 1) break;
    const nv2 = await nextOf(nscm, h0[0], b, orig); if (nv2 == null || nv2 === t.next) break;
    t.note += `${t.note ? ' · ' : ''}저장 전 검증 차단 '${t.next}'(${s1.msg.slice(0, 60)}) → '${nv2}' 재시도`; t.next = nv2; row = h0[0]; t.row = row;
    const ti2 = await typeCell(nscm, row, b, nv2); if (!ti2.ok) break;
    s1 = await saveReload(nscm); t.called = s1.called;
  }
  if (!s1.called && s1.precheck) notePrecheck(s1.calls, t.next);
  if (/^Y_|^M_/.test(b) && !orig) console.log(`[saveprobe 진단] ${b} r${row} 저장 called=${s1.called} err='${s1.err}' msg='${s1.msg.slice(0, 120)}'`);  // 2026-11-17 Y_2031 저장 실패 인식 진단
  if (!s1.called) { t.note = s1.msg ? `화면 메시지 '${s1.msg.slice(0, 80)}'` : '화면 메시지 없음'; t.blocked = classifyNoCall(s1.msg); t.restored = true; return t; }  // 재조회로 입력이 버려졌으므로 DB 변화 없음
  if (hooks.afterSave) await hooks.afterSave();  // 저장 직후 DB 스냅샷(2026-11-01 EG235·EG237·EG240)
  if (s1.err) t.note = `저장 오류 ${s1.err}`;
  // 2026-11-17 SCP0104(Y_2031 저장 ORA-01840 뒤 '재조회 행 식별 0건'으로 중단 → 빈 값·0 값·2행 저장 3행 미검증): 저장이 DB 오류로 실패하면 SP 가 되돌려(ROLLBACK TO SAVEPOINT) DB 변화가 없다
  //   → 실패(ok=false)로 세고 원복 불필요로 돌려준다. 다음 칸 진행을 막지 않는다
  if (s1.err) { t.got = ''; t.ok = false; t.restored = true; t.note += ' · 저장 실패라 DB 변화 없음(원복 불필요)'; return t; }
  let h1 = await probe.findRowsByIdentity(p, ident, [b]); let sideEffect = '';
  if (h1.length !== 1) { const near = await probe.findRowNear(p, ident, [b]); if (near) { h1 = [near.row]; sideEffect = near.diff.join(', '); if (sideEffect) t.note += ` · ⚠ 저장이 다른 칸도 바꿈(restore_touched 가 DB 복원): ${sideEffect}`; } }
  if (h1.length !== 1 && idKey) { const hid = await rowsById(p, idKey); if (hid.length === 1) { h1 = hid; t.note += ` · 행 식별 = ${idKey.k} '${idKey.v}'(T452)`; } }
  // 2026-11-17 SCP0111: 행 식별이 1건이 아니면 t.got 은 초기값 '' 로 남아 판정이 "재조회 '' NG" 로 읽은 값처럼 찍혔다 — 판독 안 함으로 적고 후보 행들의 그 칸 값을 남긴다
  if (h1.length !== 1) { const cand = await Promise.all(h1.slice(0, 4).map(async r => `r${r}=${(await probe.displayText(p, r, b).catch(() => null)) ?? '?'}`)); t.got = '(판독 안 함)'; t.note += ` 재조회 행 식별 ${h1.length}건${cand.length ? ` — 후보 ${b} 값 ${cand.join(' · ')}` : ''}`;
    // 0건 = 행을 잃음(이후 칸도 같은 행을 못 찾음) → 중단. 2건 이상 = 저장이 행을 나눔(SCP0111 BOH 값별 조회 행 분리) → 이 칸만 판독 불가로 두고 다음 칸·다음 시험 계속(DB 는 체인 끝 restore_touched 가 복원 — 11-18 00:22 실측 잔존 0)
    t.stop = h1.length === 0; if (h1.length > 1) t.note += ' · 다음 칸 계속(DB 복원은 restore_touched)'; return t; }
  t.got = (await probe.displayText(p, h1[0], b)) ?? ''; t.ok = !s1.err && same(t.got, nv);
  if (same(t.got, orig)) { t.restored = true; t.newRow = h1[0]; return t; }  // 저장이 값을 바꾸지 않음 — 원복 불필요
  if (!(await typeCell(nscm, h1[0], b, orig)).ok) { t.note += ' 원복 입력 실패'; t.stop = true; return t; }
  await saveReload(nscm);
  let h2 = await probe.findRowsByIdentity(p, ident, [b]);
  if (h2.length !== 1) { const near2 = await probe.findRowNear(p, ident, [b]); if (near2) h2 = [near2.row]; }
  if (h2.length !== 1 && idKey) { const hid2 = await rowsById(p, idKey); if (hid2.length === 1) h2 = hid2; }  // T452
  if (h2.length !== 1) { t.note += ` 원복 후 행 식별 ${h2.length}건`; t.stop = true; return t; }
  t.restored = same((await probe.displayText(p, h2[0], b)) ?? '', orig); t.newRow = h2[0];
  if (!t.restored) { t.note += ' 원복 불일치'; t.stop = true; }
  if (sideEffect) t.stop = true;  // 다른 칸까지 바뀐 행은 사람이 되돌려야 한다 — 다음 칸으로 넘어가 더 바꾸지 않는다
  return t;
}

/** 2행 동시 저장 — 두 행의 같은 컬럼을 고쳐 Save 1회 → 두 행 대조 → 두 행 원복. 행은 행 전체 값으로만 찾는다 */
export async function twoRowSave(nscm: Nscm, rows: [number, number], b: string): Promise<{ result: 'PASS' | 'FAIL' | 'ERROR'; evidence: string; stop: boolean }> {
  const p = nscm.page; const items = [];
  for (const r of rows) { const orig = (await probe.displayText(p, r, b)) ?? ''; if (norm(orig) === '') return { result: 'ERROR', evidence: `[측정 경로 없음] ${b} r${r}: 원값 빈칸 — DB 행이 없을 수 있어 제외`, stop: false }; const nv = await nextOf(nscm, r, b, orig); if (nv == null) return { result: 'ERROR', evidence: `[측정 경로 없음] ${b} r${r}: 바꿀 값 없음`, stop: false }; items.push({ r, orig, nv, ident: await probe.rowIdentity(p, r, [b]) }); }
  if (items[0].ident === items[1].ident) return { result: 'ERROR', evidence: '[측정 경로 없음] 두 행의 식별 값이 같음', stop: false };
  for (const it of items) { const ti = await typeCell(nscm, it.r, b, it.nv); if (!ti.ok) { await nscm.search(); return { result: 'ERROR', evidence: `[입력 경로 실패] ${b} r${it.r}: ${ti.how}`, stop: false }; } }
  const s1 = await saveReload(nscm); if (!s1.called) { const k = classifyNoCall(s1.msg); return { result: k === 'NOCHANGE' ? 'FAIL' : 'ERROR', evidence: `${k === 'VALIDATION' ? '[업무 검증 차단] ' : k === 'UNKNOWN' ? '[사유 불명] ' : ''}${b} 두 행 수정 후 Save — 저장 요청 없음 · 메시지 '${s1.msg.slice(0, 100)}'`, stop: false }; }
  const ev: string[] = []; let bad = !!s1.err; let lost = false; const back: { r: number; orig: string; ident: string }[] = [];
  for (const it of items) { const h = await probe.findRowsByIdentity(p, it.ident, [b]); if (h.length !== 1) { lost = true; ev.push(`r${it.r} 행 식별 ${h.length}건 ⚠ 수동 원복 확인(원값 '${it.orig}')`); continue; } const v = (await probe.displayText(p, h[0], b)) ?? ''; const ok = same(v, it.nv); if (!ok) bad = true; ev.push(`r${it.r} '${it.orig}'→'${it.nv}' 재조회 '${v}' ${ok ? 'OK' : 'NG'}`); if (!same(v, it.orig)) back.push({ r: h[0], orig: it.orig, ident: it.ident }); }
  for (const b0 of back) { const ti = await typeCell(nscm, b0.r, b, b0.orig); if (!ti.ok) { lost = true; ev.push(`r${b0.r} 원복 입력 실패 ⚠ 수동 원복 확인(원값 '${b0.orig}')`); } }
  if (back.length) { await saveReload(nscm); for (const b0 of back) { const h = await probe.findRowsByIdentity(p, b0.ident, [b]); const v = h.length === 1 ? (await probe.displayText(p, h[0], b)) ?? '' : `(행 식별 ${h.length}건)`; const ok = same(v, b0.orig); if (!ok) lost = true; ev.push(`원복 '${b0.orig}' ${ok ? 'OK' : `NG('${v}') ⚠ 수동 원복 확인`}`); } }
  return { result: lost ? 'ERROR' : bad ? 'FAIL' : 'PASS', evidence: `${b} 저장 1회 — ${ev.join(' · ')}${s1.err ? ` · 저장 오류 ${s1.err}` : ''}`, stop: lost };
}

/** 값이 있고 편집 가능한 행(우선) — 없으면 빈 칸 행(2026-11-06 사용자 지시). skip 행 제외 · 없으면 -1 */
export async function editableValueRow(nscm: Nscm, b: string, skip: number[] = [], allCols: string[] = []): Promise<number> {
  // 다른 편집 칸이 빈 행은 DB 행이 없을 수 있다 — 기본값(Y/N)이 보이는 칸만 보면 DB 행 없는 행을 고르게 된다(2026-10-31 SCP0028 r0). 빈 편집 칸이 가장 적은 행부터 쓴다
  const p = nscm.page; const q = JSON.stringify(b); const cols = JSON.stringify(allCols.filter(c => c !== b)); const has = `d[${q}] != null && String(d[${q}]).trim() !== ''`;
  const blanks = `${cols}.filter(c => d[c] == null || String(d[c]).trim() === '' || Number(d[c]) === 0).length`;  // 0 도 같은 행의 업무 검증에 막힌다(2026-10-31 SCP0028 r3)
  for (let k = 0; k <= allCols.length; k++) {
    // 0 은 화면 업무 검증(0값·LOT<INC)에 막히기 쉬워 0 아닌 값을 먼저 쓴다(2026-10-31 SCP0028)
    const rs = [...await probe.findRowsByValue(p, `d => ${has} && ${blanks} === ${k} && Number(d[${q}]) !== 0`, 60), ...await probe.findRowsByValue(p, `d => ${has} && ${blanks} === ${k}`, 60)];
    for (const r of rs) { if (skip.includes(r)) continue; if (await probe.editable(p, r, b)) return r; }
    if (allCols.length === 0) break;
  }
  // 2026-11-06 사용자 지시: 값 있는 편집 행이 없으면 빈 칸 행도 쓴다(입력·저장 후 지워서 저장까지 왕복 — SCP0084 MEMO)
  for (const r of await probe.findRowsByValue(p, `d => !(${has})`, 60)) { if (skip.includes(r)) continue; if (await probe.editable(p, r, b)) return r; }
  return -1;
}
