// 공용 CRUD 사이클 — <ID>.crud.spec.ts 와 <ID>.authcrud.spec.ts 가 같은 절차를 쓴다(계정만 다름).
//   2026-10-20 사용자 지시: 접속된 Oracle(사내 ZIOUI1)에 **실제 저장**한다.
//   · Insert/Delete 가 있는 화면: 마커 행(E2E_xxx) Insert → Save → 재조회 → 수정 Save → Delete → Save → 재조회(부재). 끝에 반드시 정리
//   · Insert 가 없는 셀 편집 저장형 화면: 편집 가능 셀 값을 바꿔 Save → 재조회로 반영 확인 → **원래 값으로 복원 Save** → 재조회로 복원 확인
import type { TestInfo } from '@playwright/test';
import type { Nscm } from './nscm';
import * as fs from 'fs';
import * as path from 'path';
import { probe, parseCsv } from './probe';
import { typeCell } from './saveprobe';

export type CrudPlan = { keyColumns?: string[]; sample?: { div?: string } };
export type CrudOutcome = {
  mode: 'insert' | 'edit-save' | 'no-save';
  saveVisible: boolean; insertVisible: boolean; deleteVisible: boolean;
  editable: boolean | null;          // 셀 편집기 열림/값 변경 가능 여부(판정 불가 null)
  inserted: boolean; saved: boolean; found: boolean; updated: boolean; cleaned: boolean; restored: boolean;
  saveCalls: number; saveErrors: string[]; notes: string[];
};

const ERR = /ORA-|PLS-|Exception|실패|fail|error|오류/i;

// 셀 표시값 → 바꿔 볼 값(숫자 +1 · Y/N 토글 · 그 외 뒤에 X) 과 복원 입력값
function nextValue(orig: string): { next: string; restore: string } {
  const t = orig.trim();
  if (/^-?[\d,]+(\.\d+)?$/.test(t) && t !== '') { const n = Number(t.replace(/,/g, '')); const next = String(Number.isInteger(n) ? n + 1 : Math.round((n + 1) * 1000) / 1000); return { next, restore: String(n) }; }
  if (t === '') return { next: '1', restore: '' };
  if (/^[YN]$/i.test(t)) return { next: t.toUpperCase() === 'Y' ? 'N' : 'Y', restore: t };
  return { next: t + 'X', restore: t };
}

// opt.mode='edit-save'(2026-10-30 WP3): Insert 가 보여도 기존행 수정 저장 경로를 강제한다(정합검증 @verify 가 신규행 경로 실패 시 폴백)
export async function crudCycle(nscm: Nscm, info: TestInfo, plan: CrudPlan, mark: string, opt: { mode?: 'edit-save'; onBeforeSave?: (dataRow: number) => Promise<void>; onAfterSave?: (saved: boolean) => Promise<void>; excludeBindings?: string[] } = {}): Promise<CrudOutcome> {
  const out: CrudOutcome = { mode: 'no-save', saveVisible: false, insertVisible: false, deleteVisible: false, editable: null, inserted: false, saved: false, found: false, updated: false, cleaned: true, restored: true, saveCalls: 0, saveErrors: [], notes: [] };
  out.saveVisible = await nscm.subButtonVisible('Save');
  out.insertVisible = opt.mode === 'edit-save' ? false : await nscm.subButtonVisible('Insert');
  if (opt.mode === 'edit-save') out.notes.push('수정 저장 경로 강제(edit-save)');
  out.deleteVisible = await nscm.subButtonVisible('Delete');
  const callsBefore = nscm.calls.length;
  const countSave = () => { const c = nscm.calls.slice(callsBefore).filter(x => /SAVE|INS|UPD|DEL/i.test(x.btn)); out.saveCalls = c.length; return c; };
  // 2026-11-07 T154(SCP0122 authcrud): nscm.save() 의 calls 는 저장 구간의 모든 call-proc(SEARCH 포함) — 길이>0 으로 '저장 성공' 을 판정하면 SAVE 없이 SEARCH 만 있어도 saved=Y
  //   (사내 SCM_COM_SQL_LOG 18:56~19:10 SAVE 0건인데 saved=Y found=N → 'J2 재조회 후 신규 행 존재' 허위). SAVE 계열만 센다
  const saveOf = (cs: { btn: string; status: number }[]) => cs.filter(c => /SAVE|INS|UPD|DEL/i.test(c.btn));
  // 2026-11-06: DOM 행 수만 보면 가상화 그리드가 아직 안 그려졌을 때 0(SCP0084 '조회 행 0' — 같은 실행의 다른 테스트는 10,274행) → 컨트롤 행 수와 큰 값
  const rows = Math.max(await nscm.gridRowCount(0), await probe.rowCount(nscm.page).catch(() => 0));

  if (!out.saveVisible) {
    out.mode = 'no-save';
    if (rows > 0) out.editable = await nscm.cellEditable(0);
    out.notes.push(`Save 비노출 · 편집기 ${out.editable == null ? '판정불가' : out.editable ? '열림' : '안 열림'}`);
    countSave(); annotate(info, out); return out;
  }

  if (!out.insertVisible) {
    // 셀 편집 저장형 — 값 변경 → Save → 재조회 확인 → 원복 Save → 재조회 확인(2026-10-20 사용자 승인: 접속 DB 에 수정 저장 후 원복)
    out.mode = 'edit-save';
    if (rows === 0) { out.notes.push('조회 행 0 — 편집/저장 검증 불가'); countSave(); annotate(info, out); return out; }
    // 편집 후보 = 화면이 편집 가능으로 표시한 셀(.wj-cell-editable). SCP0096 처럼 컬럼 정의 isReadOnly 가 전부 false 인 화면에서는 이것만이 신호다.
    //   값이 있는 셀 우선(빈 행은 입력이 막힌 화면이 많다), 같은 컬럼이면 위 행 우선. 없으면 컬럼 정의(readOnly 아님)로 보조
    const headers = await nscm.gridHeaders(0);
    let ecs = await nscm.editableCells(0, 40);
    // 2026-11-06(SCP0084 조치 필요 1·2·3·16번 허위 FAIL 원인 실측): 편집 칸(MEMO)이 그리드 오른쪽 끝이라 가로 가상화로 DOM 에 안 그려져 후보 0개 →
    //   '컬럼 정의 기준 후보' 앞 8칸(편집 불가 LONG_TERM_TYPE 포함)을 저장 시험했다(실측 14:58 editable MEMO=true · LONG_TERM_TYPE=false).
    //   → 컬럼 정의 순서대로 실제 편집 개시(beginningEdit 통과)되는 첫 칸을 찾아 그 칸이 보이게 스크롤한 뒤 화면 편집 표시 셀을 다시 모은다
    if (!ecs.length) {
      const metaS = await nscm.gridColumnsMeta(0);
      for (const m of metaS || []) {
        if (m.readOnly || !m.binding) continue;
        if ((await probe.editable(nscm.page, 0, m.binding).catch(() => null)) !== true) continue;
        await probe.cellClasses(nscm.page, 0, m.binding).catch(() => null);  // scrollIntoView
        await nscm.page.waitForTimeout(300);
        ecs = await nscm.editableCells(0, 40);
        if (ecs.length) out.notes.push(`편집 표시 셀이 화면 밖 → 편집 개시되는 첫 칸 ${m.binding} 로 스크롤 후 후보 ${ecs.length}셀`);
        break;
      }
    }
    const byMeta = !ecs.length;  // 2026-11-06: 편집 표시 없이 컬럼 정의로 고른 후보 — 아래에서 실제 편집 개시(beginningEdit)로 한 번 더 거른다
    if (!ecs.length) { const meta = await nscm.gridColumnsMeta(0); const cols = meta ? meta.map((m, i) => (m.readOnly ? -1 : i)).filter(i => i >= 0).slice(0, 8) : [1, 2, 3]; const rl = nscm.grid(0).locator('.wj-cells .wj-row'); const n = Math.min(await rl.count(), 20); for (let r = 0; r < n; r++) { const t = (await rl.nth(r).locator('.wj-cell').allInnerTexts().catch(() => [] as string[])).map(s => s.trim()); for (const c of cols) ecs.push({ row: r, col: c, text: t[c] ?? '' }); } out.notes.push('wj-cell-editable 없음 → 컬럼 정의 기준 후보'); }
    // 2026-11-06 T64: 저장 키 컬럼(cleanup_spec keys)은 편집 대상에서 뺀다 — 키를 바꾸면 업무 중복 검증에 막히거나 복원기가 못 따라가 사내 DB 에 남는다
    const exK = new Set((opt.excludeBindings || []).map(s => s.toUpperCase()));
    // 2026-11-07 T131: 컬럼 메타 조회는 DOM 순번(c.col)이 아니라 실제 컬럼 인덱스(c.colIdx · 가로 가상화)로 — SCP0084 MEMO 를 LEVEL_2_NAME 으로 오인한 허위 FAIL·원복 실패
    const mi = (c: { col: number; colIdx?: number }) => (typeof c.colIdx === 'number' && c.colIdx >= 0 ? c.colIdx : c.col);
    if (exK.size) { const metaK = await nscm.gridColumnsMeta(0); const before = ecs.length; ecs = ecs.filter(c => !exK.has(String((metaK && metaK[mi(c)] ? metaK[mi(c)].binding : '') || '').toUpperCase())); if (ecs.length < before) out.notes.push(`저장 키 컬럼 제외 ${before - ecs.length}셀`); }
    // 값 있는 칸 우선 · 없으면 빈 칸도(2026-11-06 사용자 지시 — 입력·저장 후 지워서 저장까지 왕복. 종전 2026-10-31 SCP0028 빈칸 제외 규칙 대체)
    const valued = ecs.filter(c => c.text !== ''); const ordered = (valued.length ? valued : ecs).slice(0, 24); if (!valued.length && ecs.length) out.notes.push('값 있는 편집 칸 없음 — 빈 칸 왕복');
    if (!ordered.length) { out.editable = false; out.notes.push('편집 가능 셀 없음'); countSave(); annotate(info, out); return out; }
    const S: { col: number; colIdx: number; row: number; orig: string; nv: { next: string; restore: string } | null; key: string; binding: string } = { col: -1, colIdx: -1, row: -1, orig: '', nv: null, key: '', binding: '' };
    const metaB = byMeta ? await nscm.gridColumnsMeta(0) : null;
    for (const c of ordered) {
      // 2026-11-06(SCP0084 조치 필요 1·2·3·16번 허위 FAIL): 컬럼 정의 후보는 화면 beginningEdit 가 막는 칸(공용 DataGrid INPUT_TP_CD='S' 잠금)일 수 있다 —
      //   그 칸에 글자를 넣어도 저장 대상(CRUD_TYPE)이 되지 않아 '수정한 내용이 없습니다' 로 끝나 저장 FAIL 로 오판했다 → 실제 편집 개시가 안 되는 칸은 건너뛴다
      if (byMeta && metaB && metaB[mi(c)]?.binding) {
        const vr0 = await nscm.page.evaluate(`(() => { const el = [...document.querySelectorAll('.wj-flexgrid')].find(e => e.offsetParent !== null); const g = el && el['$WJ-CTRL']; const vr = g && g.viewRange; return vr && vr.row > 0 ? vr.row : 0; })()`).catch(() => 0) as number;
        const ed = await probe.editable(nscm.page, vr0 + c.row, metaB[mi(c)].binding).catch(() => null);
        if (ed === false) { out.notes.push(`편집 개시 안 됨 제외 ${metaB[mi(c)].binding}`); continue; }
      }
      const cand = nextValue(c.text);
      // T74 · 2026-11-07 T143: 행 데이터(dataItem)를 입력 전후로 항상 읽어, 실제로 바뀐 binding 으로 편집 컬럼을 확정한다 — chain6b SCP0084 F1 은 MEMO 에 입력·저장(요청 memo:"1")했는데
      //   메타 순번으로 고른 이름이 PIC 이어서 '재조회 미반영' 허위 FAIL + 원복 입력 실패(PIC) → MEMO '1' 이 사내 DB 에 남았다(14:11 실측 UPDATE 093139)
      const kb = (await probe.rowItem(nscm.page, c.row).catch(() => null)) as Record<string, unknown> | null;
      try { await nscm.setCell(c.row, c.col, cand.next, 0); } catch { await nscm.page.keyboard.press('Escape').catch(() => undefined); continue; }
      // 2026-11-06 T74: 이 칸 입력이 같은 행의 저장 키를 바꾸면(연동 칸) 실저장하지 않는다 — 재조회로 입력을 버리고 다음 후보
      let bindHit = '';
      if (kb) { const ka = (await probe.rowItem(nscm.page, c.row).catch(() => null)) as Record<string, unknown> | null; const chAll = ka ? Object.keys(ka).filter(k => !/^(CRUD_TYPE|_SEL|ROW_STATUS|STATUS|_ROW_INDEX)$/i.test(k) && String(kb[k] ?? '') !== String(ka[k] ?? '')) : []; const ch = chAll.filter(k => exK.size && exK.has(k.toUpperCase())); if (ch.length) { out.notes.push(`저장 키 연동 칸 제외(${ch.join(',')})`); await nscm.search().catch(() => undefined); await nscm.clearDialogs().catch(() => undefined); continue; } if (chAll.length === 1) bindHit = chAll[0]; }
      const after = (await (await nscm.gridCell(c.row, c.col, 0)).innerText().catch(() => '')).trim();
      if (after !== c.text && after !== '') { S.col = c.col; S.colIdx = mi(c); S.row = c.row; S.orig = c.text; S.nv = cand; S.key = await nscm.rowKey(c.row); S.binding = bindHit; break; }
      await nscm.page.keyboard.press('Escape').catch(() => undefined);
    }
    const col = S.col, row = S.row, orig = S.orig, nv = S.nv, key = S.key;
    out.editable = col >= 0;
    if (col < 0 || !nv) { out.notes.push(`편집 가능 셀 ${ordered.length}개 시도 — 값이 바뀌는 셀 없음`); countSave(); annotate(info, out); return out; }
    const colIdx = S.colIdx >= 0 ? S.colIdx : col;  // T131: 메타 조회는 실제 컬럼 인덱스로
    const metaN = await nscm.gridColumnsMeta(0); const metaName = (metaN && metaN[colIdx] ? (metaN[colIdx].binding || metaN[colIdx].header) : '') || headers[colIdx] || String(col);
    const colName = S.binding || metaName;  // T143: 입력으로 실제 바뀐 binding 이 정본 — 메타 순번 이름과 다르면 기록
    if (S.binding && S.binding !== metaName) out.notes.push(`편집 컬럼 = 행 데이터 변화로 확정 ${S.binding}(메타 순번 이름 ${metaName} 아님 · T143)`);
    const t0 = Date.now(); const T = (m: string) => out.notes.push(`[${Math.round((Date.now() - t0) / 1000)}s] ${m}`);
    const cellOf = async (r: number) => ((await nscm.grid(0).locator('.wj-cells .wj-row').nth(r).locator('.wj-cell').allInnerTexts().catch(() => [] as string[]))[col] ?? '').trim();
    const same = (a: string, b: string) => a === b || a.replace(/,/g, '') === b.replace(/,/g, '');
    // 재조회 직후 그리드가 아직 다시 그려지기 전이면 셀이 '' 로 읽힌다(2026-10-20 실측) → 키 행이 나타나고 값이 채워질 때까지 최대 15s 폴링
    const readAfterSearch = async (fallbackRow: number) => { for (let k = 0; k < 30; k++) { const r = await nscm.findRowByKey(key); if (r >= 0) { const v = await cellOf(r); if (v !== '') return { r, v }; } await nscm.page.waitForTimeout(500); } const r = Math.max(await nscm.findRowByKey(key), fallbackRow); return { r, v: await cellOf(r) }; };
    try {
      // 2) 저장 → 재조회 → 같은 행(키 셀 3개)에서 반영 확인
      // 저장 전에 행 전체 값으로 식별 문자열을 잡는다(수정 컬럼 제외)
      const identEx = [colName]; const dataRow = await nscm.page.evaluate(`(() => { const el = [...document.querySelectorAll('.wj-flexgrid')].find(e => e.offsetParent !== null); const c = el && el['$WJ-CTRL']; if (!c) return ${row}; const vr = c.viewRange; return (vr && vr.row > 0 ? vr.row : 0) + ${row}; })()`) as number;
      const identity = await probe.rowIdentity(nscm.page, dataRow, identEx);
      if (opt.onBeforeSave) await opt.onBeforeSave(dataRow);  // 저장 전 DB 스냅샷(원복 전 비교용 · 2026-10-31)
      T('수정 입력 완료'); const s1 = await nscm.save(); T('저장 응답 ' + (s1.calls.length ? s1.calls.map(c => c.btn + ':' + c.status + (c.req ? ' 요청=' + c.req.replace(/\s+/g, ' ').slice(0, 180) : '') + (c.res ? ' 응답=' + c.res.slice(0, 120) : '')).join(' | ') : 'call-proc 없음') + (s1.message ? ' 알림=' + s1.message.slice(0, 80) : ''));
      { const sc = saveOf(s1.calls); out.saved = !ERR.test(s1.message || '') && sc.every(c => c.status < 400) && sc.length > 0;
      if (!out.saved) out.saveErrors.push(`SAVE: ${s1.message || (sc.length ? sc.map(c => `${c.btn} HTTP ${c.status}`).join(',') : 'SAVE call-proc 없음')}`); }
      if (opt.onAfterSave) await opt.onAfterSave(out.saved);
      await nscm.search(); T('재조회');
      // 행 전체 값으로 같은 행을 찾는다 — 유일하지 않으면 원복하지 않는다(다른 행 덮어쓰기 방지, 2026-10-31)
      await nscm.page.waitForTimeout(800); await probe.waitRows(nscm.page, 30_000).catch(() => undefined);
      const hits1 = identity ? await probe.findRowsByIdentity(nscm.page, identity, identEx) : [];
      if (hits1.length !== 1) { out.notes.push(`행 식별 ${hits1.length}건(1건이어야 함) — 재조회 대조·원복 중단${out.saved ? ' · ⚠ 저장은 됨: 수동 원복 필요 [' + colName + ' 원값 ' + orig + ']' : ''}`); out.found = false; out.restored = !out.saved; countSave(); annotate(info, out); return out; }
      const r1 = hits1[0]; T('행 찾기 ' + r1);
      const v1 = (await probe.displayText(nscm.page, r1, colName)) ?? ''; out.found = same(v1, nv.next); out.updated = out.found;
      out.notes.push(`행 [${key}] ${colName}: '${orig}' → '${nv.next}' 저장 ${out.saved ? '성공' : '실패'} · 재조회 값 '${v1}' ${out.found ? '반영 확인' : '미반영'}`);
      // 3) 원복 저장 → 재조회 → 복원 확인
      if (!out.saved) { out.restored = same(v1, orig); out.notes.push(`저장 요청 없음/실패 — 원복 저장 생략 · 재조회 값 '${v1}' ${out.restored ? '원값 그대로' : '⚠ 원값과 다름'}`); countSave(); annotate(info, out); return out; }
      // 2026-11-07 T157(SCP0127 F6 'RESTORE: _수정한 내용이 없습니다.'): 수정은 키보드(setCell)로 넣고 원복만 편집기 주입(setByEditor)으로 넣어 화면이 변경으로 인식하지 못했다(저장 수집 0건) →
      //   원복도 사용자와 같은 키보드 입력(typeCell · 콤보만 편집기)을 먼저, 편집기 주입은 대체 경로. T156: 날짜 칸 InputDate 'Date expected' 도 같은 대체로 흡수
      if (!(await typeCell(nscm, r1, colName, nv.restore)).ok && !(await probe.setByEditor(nscm.page, r1, colName, nv.restore))) throw new Error(`원복 입력 실패 r${r1} ${colName}`); T('원복 입력');
      const s2 = await nscm.save(); T('원복 저장 응답'); const sc2 = saveOf(s2.calls); const ok2 = !ERR.test(s2.message || '') && sc2.every(c => c.status < 400) && sc2.length > 0;
      if (!ok2) out.saveErrors.push(`RESTORE: ${s2.message || 'SAVE call-proc 없음'}`);
      await nscm.search();
      await nscm.page.waitForTimeout(800); await probe.waitRows(nscm.page, 30_000).catch(() => undefined);
      const hits2 = await probe.findRowsByIdentity(nscm.page, identity, identEx);
      const v2 = hits2.length === 1 ? (await probe.displayText(nscm.page, hits2[0], colName)) ?? '' : `(행 식별 ${hits2.length}건)`; out.restored = hits2.length === 1 && same(v2, orig);
      out.notes.push(`원복 '${orig}' 저장 ${ok2 ? '성공' : '실패'} · 재조회 값 '${v2}' ${out.restored ? '복원 확인' : '미복원 — 수동 확인 필요'}`);
    } catch (e) {
      out.notes.push(`예외: ${String(e).split('\n')[0].slice(0, 160)}`); out.restored = false;
      // 저장은 됐는데 복원 전에 끊긴 경우 — 앞 칸 키로 찾아 넣으면 다른 행을 덮어쓸 수 있어 자동 재시도하지 않는다(2026-10-31). 원값을 보고해 수동 원복
      if (out.saved && !out.restored) out.notes.push(`⚠ 수동 원복 필요 — 행 [${key}] ${colName} 원값 '${orig}'`);
    }
    countSave(); annotate(info, out); return out;
  }

  // Insert 가 있는 화면: 마커 행 C → R → U → D, 어떤 경우에도 마커 행 정리
  out.mode = 'insert';
  const grid = nscm.grid(0);
  const rowsLoc = () => grid.locator('.wj-cells .wj-row');
  // 2026-11-08 T168(SCP0122 4차 실측): 마커 텍스트가 비영속 칸에 들어가면 저장 뒤 재조회에서 행을 못 찾아(found=N) 정리(Delete)도 못 해 사내 DB 잔존(PG0014/A001/8) →
  //   채운 필수 칸 값들(이름·순번 …)을 시그니처로 보조 식별한다: 마커 텍스트 → 없으면 시그니처 값이 전부 들어 있는 행(2개 이상 값일 때만 · 숫자 하나로는 식별하지 않는다)
  const sig: string[] = [];
  const findMark = async (m: string) => {
    const n = await rowsLoc().count(); const texts: string[] = [];
    for (let i = 0; i < n; i++) { const t = await rowsLoc().nth(i).innerText().catch(() => ''); texts.push(t); if (t.includes(m)) return i; }
    const sg = sig.filter(s => s && s.trim());
    if (sg.length >= 2) for (let i = 0; i < texts.length; i++) if (sg.every(s => texts[i].includes(s))) return i;
    return -1;
  };
  const headers = await nscm.gridHeaders(0);
  const keyCols: string[] = plan.keyColumns || [];
  // 마커 컬럼: plan.keyColumns → 없으면 Remark/Comment/Desc 류 텍스트 컬럼 → 없으면 메타상 편집 가능한 첫 컬럼 → 0
  //   (2026-10-26 SCP0007: 0번 컬럼 DIVISION_ID 가 Division 단일 조회 시 신규행에서 자동세팅+잠금이라 더블클릭이 5초 타임아웃 — 허위 FAIL)
  const metaCols = await nscm.gridColumnsMeta(0);
  const remarkCol = headers.findIndex(h => /remark|comment|desc|memo|비고/i.test(h));
  const firstEditable = metaCols ? metaCols.findIndex(m => !m.readOnly) : -1;
  const targetCol = Math.max(keyCols.length ? headers.findIndex(h => h.toLowerCase() === keyCols[0].toLowerCase()) : remarkCol >= 0 ? remarkCol : firstEditable, 0);
  try {
    const before = await rowsLoc().count();
    await nscm.subButton('Insert').click();
    await nscm.page.waitForFunction((n: number) => document.querySelectorAll('.wj-flexgrid .wj-cells .wj-row').length > n, before, { timeout: 10_000 }).catch(() => undefined);
    out.inserted = (await rowsLoc().count()) > before;
    if (!out.inserted) { out.notes.push('Insert 후 행 증가 없음'); }
    else {
      // 신규 행 = 맨 위 또는 맨 아래 — 비어 있는 행을 찾는다
      const n = await rowsLoc().count(); let ri = 0;
      for (const cand of [0, n - 1]) { const t = (await rowsLoc().nth(cand).innerText().catch(() => '')).replace(/\s+/g, ''); if (!t) { ri = cand; break; } }
      // 2026-11-08 T166(SCP0122 J2 실측 '[Act. Seq] 값은 필수 입력 항목입니다.' → 17:4x 2차 실측 '신규 입력 데이터 중 중복된 데이터' — 연동 콤보(OPMZ_ACTV_NAME→CD)가 키를 기존 값으로 바꿈 → 필수 칸을 먼저 채우고 마커(키)는 마지막에 넣어 덮는다): 마커 행이 keyColumns 만 채워 필수(M) 컬럼 화면 검증에 막혀 허용 계정 CRUD 를 재지 못했다 →
      //   TO-BE 메타(sheet_columns.csv input_tp_cd=M)와 그리드 바인딩을 대조해 비어 있는 필수 칸을 채운다: 콤보 = 첫 후보 · 숫자 = '1' · 날짜 = 오늘 YYYYMMDD · 문자 = 마커. 채운 칸은 노트에 남긴다
      try {
        const menuId = ((plan as { menuId?: string }).menuId || process.env.VERIFY_ID || '').toUpperCase();
        const metaFile = path.join(__dirname, '..', '..', '..', 'Doc', 'tobefacts', 'db', 'sheet_columns.csv');
        const req = new Set(menuId && fs.existsSync(metaFile) ? parseCsv(fs.readFileSync(metaFile, 'utf8')).filter(r => (r.program_id || '').toUpperCase() === menuId && (r.input_tp_cd || '').toUpperCase() === 'M').map(r => r.column_name) : []);
        const targetBinding = metaCols && metaCols[targetCol] ? metaCols[targetCol].binding : '';
        const filled: string[] = [];
        for (const m of metaCols || []) {
          if (!m.binding || m.readOnly || !req.has(m.binding) || m.binding === targetBinding) continue;
          const cur = (await probe.displayText(nscm.page, ri, m.binding).catch(() => '')) || '';
          if (cur.trim()) continue;
          let v = mark;
          if (m.hasMap) {
            // 17:5x 2차 실측 '신규 입력 데이터 중 중복된 데이터' — 연동 콤보(OPMZ_ACTV_NAME→OPMZ_ACTV_CD)가 고른 후보가 이미 있는 행과 키 중복 → 현재 그리드 같은 열에 없는 후보를 먼저 고른다
            const c = ((await probe.candidates(nscm.page, ri, m.binding).catch(() => null)) || []).filter(x => x && x.trim());
            const used = new Set((((await probe.columnValues(nscm.page, m.binding).catch(() => null)) || []) as string[]).map(x => String(x ?? '').trim()));
            v = c.find(x => !used.has(x.trim())) || c[0] || '';
            if (!v) { filled.push(`${m.binding}(콤보 후보 없음)`); continue; }
            if (used.has(v.trim())) filled.push(`${m.binding}(미사용 후보 없음 → 첫 후보)`);
          }
          else if (m.dataType === 2) {
            // 18:1x 3차 실측: SCP0122 FE 가 (PRS_CD+PLAN_GR_ID+ACTV_SEQ) 중복을 선차단 → 그리드 같은 열의 최대 숫자 + 1(없으면 1)
            const nums = (((await probe.columnValues(nscm.page, m.binding).catch(() => null)) || []) as unknown[]).map(x => Number(String(x ?? '').replace(/,/g, ''))).filter(n => Number.isFinite(n));
            v = String((nums.length ? Math.max(...nums) : 0) + 1);
          }
          else if (m.dataType === 4) { const d = new Date(); v = `${d.getFullYear()}${String(d.getMonth() + 1).padStart(2, '0')}${String(d.getDate()).padStart(2, '0')}`; }
          const r = await typeCell(nscm, ri, m.binding, v);
          filled.push(`${m.binding}=${v}${r.ok ? '' : '(입력 실패: ' + r.how.slice(0, 40) + ')'}`);
          if (r.ok) sig.push(v);  // T168: 재조회·정리 때 행을 찾는 보조 시그니처
        }
        if (filled.length) out.notes.push(`필수 칸 채움(T166): ${filled.join(', ')}`);
      } catch (e) { out.notes.push(`필수 칸 채움 예외: ${String(e).split('\n')[0].slice(0, 120)}`); }
      await nscm.setCell(ri, targetCol, mark);
      for (const kc of keyCols.slice(1)) { const ci = headers.findIndex(h => h.toLowerCase() === kc.toLowerCase()); if (ci >= 0) await nscm.setCell(ri, ci, mark); }
      const s1 = await nscm.save();
      // 2026-10-22: 저장 call-proc 0건(화면이 '변경 없음' 으로 저장을 건너뜀)은 저장 성공이 아니다 — edit-save 모드와 같은 기준(SCP0122 saved=Y 오판)
      { const sc = saveOf(s1.calls); out.saved = !ERR.test(s1.message || '') && sc.every(c => c.status < 400) && sc.length > 0;  // T154: SAVE 계열만
      // 2026-11-08 계측: 마커 저장의 실제 호출 목록·알림을 남긴다 — 'saved=Y 인데 사내 SQL 로그에 SAVE 0건'(SCP0122 J2) 원인 확정용(edit-save 경로의 T('저장 응답') 와 같은 정보)
      out.notes.push(`마커 저장 응답: ${s1.calls.length ? s1.calls.map(c => `${c.sheet}/${c.btn}:${c.status}${c.req ? ' 요청=' + c.req.replace(/\s+/g, ' ').slice(0, 120) : ''}${c.res ? ' 응답=' + c.res.slice(0, 100) : ''}`).join(' | ') : 'call-proc 없음'}${s1.message ? ' 알림=' + s1.message.slice(0, 80) : ''}`);
      if (!out.saved) out.saveErrors.push(`SAVE: ${s1.message || (sc.length ? sc.map(c => `${c.btn} HTTP ${c.status}`).join(',') : 'SAVE call-proc 없음')}`); }
      await nscm.search();
      out.found = (await findMark(mark)) >= 0;
      // U
      if (out.found && headers.length > targetCol + 1) {
        const ri2 = await findMark(mark);
        await nscm.setCell(ri2, targetCol + 1, mark + '_U');
        const s2 = await nscm.save(); const ok2 = !ERR.test(s2.message || '') && s2.calls.every(c => c.status < 400);
        if (!ok2) out.saveErrors.push(`UPDATE: ${s2.message}`);
        await nscm.search(); out.updated = (await findMark(mark + '_U')) >= 0;
      }
    }
  } catch (e) { out.notes.push(`예외: ${String(e).split('\n')[0].slice(0, 160)}`); }
  finally {
    // D — 마커 행 정리(저장 성공 여부와 무관하게 시도). 재조회 후 마커가 남아 있으면 cleaned=false
    try {
      if (out.deleteVisible) {
        let ri = await findMark(mark);
        if (ri < 0) { await nscm.search(); ri = await findMark(mark); }
        if (ri >= 0) {
          await rowsLoc().nth(ri).locator('.wj-cell').first().click();
          await nscm.subButton('Delete').click(); await nscm.closeAlert('ok');
          const d = await nscm.save(); if (ERR.test(d.message || '')) out.saveErrors.push(`DELETE: ${d.message}`);
          await nscm.search();
        }
      } else if (out.saved) out.notes.push('Delete(F9) 버튼 없음 — 마커 행 수동 정리 필요');
      out.cleaned = (await findMark(mark)) < 0;
    } catch (e) { out.cleaned = false; out.notes.push(`정리 예외: ${String(e).split('\n')[0].slice(0, 120)}`); }
  }
  countSave(); annotate(info, out); return out;
}

function annotate(info: TestInfo, o: CrudOutcome) {
  info.annotations.push({ type: 'crud', description: `mode=${o.mode} save=${o.saveVisible ? 'Y' : 'N'} insert=${o.insertVisible ? 'Y' : 'N'} delete=${o.deleteVisible ? 'Y' : 'N'} editable=${o.editable == null ? '-' : o.editable ? 'Y' : 'N'} inserted=${o.inserted ? 'Y' : 'N'} saved=${o.saved ? 'Y' : 'N'} found=${o.found ? 'Y' : 'N'} updated=${o.updated ? 'Y' : 'N'} cleaned=${o.cleaned ? 'Y' : 'N'} restored=${o.restored ? 'Y' : 'N'} saveCalls=${o.saveCalls}${o.saveErrors.length ? ' errors=' + o.saveErrors.join(' / ') : ''}${o.notes.length ? ' · ' + o.notes.join(' · ') : ''}` });
}
