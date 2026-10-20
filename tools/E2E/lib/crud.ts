// 공용 CRUD 사이클 — <ID>.crud.spec.ts 와 <ID>.authcrud.spec.ts 가 같은 절차를 쓴다(계정만 다름).
//   2026-10-20 사용자 지시: 접속된 Oracle(사내 ZIOUI1)에 **실제 저장**한다.
//   · Insert/Delete 가 있는 화면: 마커 행(E2E_xxx) Insert → Save → 재조회 → 수정 Save → Delete → Save → 재조회(부재). 끝에 반드시 정리
//   · Insert 가 없는 셀 편집 저장형 화면: 편집 가능 셀 값을 바꿔 Save → 재조회로 반영 확인 → **원래 값으로 복원 Save** → 재조회로 복원 확인
import type { TestInfo } from '@playwright/test';
import type { Nscm } from './nscm';

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

export async function crudCycle(nscm: Nscm, info: TestInfo, plan: CrudPlan, mark: string): Promise<CrudOutcome> {
  const out: CrudOutcome = { mode: 'no-save', saveVisible: false, insertVisible: false, deleteVisible: false, editable: null, inserted: false, saved: false, found: false, updated: false, cleaned: true, restored: true, saveCalls: 0, saveErrors: [], notes: [] };
  out.saveVisible = await nscm.subButtonVisible('Save');
  out.insertVisible = await nscm.subButtonVisible('Insert');
  out.deleteVisible = await nscm.subButtonVisible('Delete');
  const callsBefore = nscm.calls.length;
  const countSave = () => { const c = nscm.calls.slice(callsBefore).filter(x => /SAVE|INS|UPD|DEL/i.test(x.btn)); out.saveCalls = c.length; return c; };
  const rows = await nscm.gridRowCount(0);

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
    if (!ecs.length) { const meta = await nscm.gridColumnsMeta(0); const cols = meta ? meta.map((m, i) => (m.readOnly ? -1 : i)).filter(i => i >= 0).slice(0, 8) : [1, 2, 3]; const rl = nscm.grid(0).locator('.wj-cells .wj-row'); const n = Math.min(await rl.count(), 20); for (let r = 0; r < n; r++) { const t = (await rl.nth(r).locator('.wj-cell').allInnerTexts().catch(() => [] as string[])).map(s => s.trim()); for (const c of cols) ecs.push({ row: r, col: c, text: t[c] ?? '' }); } out.notes.push('wj-cell-editable 없음 → 컬럼 정의 기준 후보'); }
    const ordered = ecs.filter(c => c.text !== '').concat(ecs.filter(c => c.text === '')).slice(0, 24);
    if (!ordered.length) { out.editable = false; out.notes.push('편집 가능 셀 없음'); countSave(); annotate(info, out); return out; }
    const S: { col: number; row: number; orig: string; nv: { next: string; restore: string } | null; key: string } = { col: -1, row: -1, orig: '', nv: null, key: '' };
    for (const c of ordered) {
      const cand = nextValue(c.text);
      try { await nscm.setCell(c.row, c.col, cand.next, 0); } catch { await nscm.page.keyboard.press('Escape').catch(() => undefined); continue; }
      const after = (await (await nscm.gridCell(c.row, c.col, 0)).innerText().catch(() => '')).trim();
      if (after !== c.text && after !== '') { S.col = c.col; S.row = c.row; S.orig = c.text; S.nv = cand; S.key = await nscm.rowKey(c.row); break; }
      await nscm.page.keyboard.press('Escape').catch(() => undefined);
    }
    const col = S.col, row = S.row, orig = S.orig, nv = S.nv, key = S.key;
    out.editable = col >= 0;
    if (col < 0 || !nv) { out.notes.push(`편집 가능 셀 ${ordered.length}개 시도 — 값이 바뀌는 셀 없음`); countSave(); annotate(info, out); return out; }
    const metaN = await nscm.gridColumnsMeta(0); const colName = (metaN && metaN[col] ? (metaN[col].binding || metaN[col].header) : '') || headers[col] || String(col); const t0 = Date.now(); const T = (m: string) => out.notes.push(`[${Math.round((Date.now() - t0) / 1000)}s] ${m}`);
    const cellOf = async (r: number) => ((await nscm.grid(0).locator('.wj-cells .wj-row').nth(r).locator('.wj-cell').allInnerTexts().catch(() => [] as string[]))[col] ?? '').trim();
    const same = (a: string, b: string) => a === b || a.replace(/,/g, '') === b.replace(/,/g, '');
    // 재조회 직후 그리드가 아직 다시 그려지기 전이면 셀이 '' 로 읽힌다(2026-10-20 실측) → 키 행이 나타나고 값이 채워질 때까지 최대 15s 폴링
    const readAfterSearch = async (fallbackRow: number) => { for (let k = 0; k < 30; k++) { const r = await nscm.findRowByKey(key); if (r >= 0) { const v = await cellOf(r); if (v !== '') return { r, v }; } await nscm.page.waitForTimeout(500); } const r = Math.max(await nscm.findRowByKey(key), fallbackRow); return { r, v: await cellOf(r) }; };
    try {
      // 2) 저장 → 재조회 → 같은 행(키 셀 3개)에서 반영 확인
      T('수정 입력 완료'); const s1 = await nscm.save(); T('저장 응답 ' + (s1.calls.length ? s1.calls.map(c => c.btn + ':' + c.status + (c.req ? ' 요청=' + c.req.replace(/\s+/g, ' ').slice(0, 180) : '') + (c.res ? ' 응답=' + c.res.slice(0, 120) : '')).join(' | ') : 'call-proc 없음') + (s1.message ? ' 알림=' + s1.message.slice(0, 80) : ''));
      out.saved = !ERR.test(s1.message || '') && s1.calls.every(c => c.status < 400) && s1.calls.length > 0;
      if (!out.saved) out.saveErrors.push(`SAVE: ${s1.message || (s1.calls.length ? s1.calls.map(c => `${c.btn} HTTP ${c.status}`).join(',') : 'SAVE call-proc 없음')}`);
      await nscm.search(); T('재조회');
      const a1 = await readAfterSearch(row); const r1 = a1.r; T('행 찾기 ' + r1);
      const v1 = a1.v; out.found = same(v1, nv.next); out.updated = out.found;
      out.notes.push(`행 [${key}] ${colName}: '${orig}' → '${nv.next}' 저장 ${out.saved ? '성공' : '실패'} · 재조회 값 '${v1}' ${out.found ? '반영 확인' : '미반영'}`);
      // 3) 원복 저장 → 재조회 → 복원 확인
      await nscm.setCell(r1, col, nv.restore, 0); T('원복 입력');
      const s2 = await nscm.save(); T('원복 저장 응답'); const ok2 = !ERR.test(s2.message || '') && s2.calls.every(c => c.status < 400) && s2.calls.length > 0;
      if (!ok2) out.saveErrors.push(`RESTORE: ${s2.message || 'SAVE call-proc 없음'}`);
      await nscm.search();
      const a2 = await readAfterSearch(r1); const v2 = a2.v; out.restored = same(v2, orig);
      out.notes.push(`원복 '${orig}' 저장 ${ok2 ? '성공' : '실패'} · 재조회 값 '${v2}' ${out.restored ? '복원 확인' : '미복원 — 수동 확인 필요'}`);
    } catch (e) {
      out.notes.push(`예외: ${String(e).split('\n')[0].slice(0, 160)}`); out.restored = false;
      // 저장은 됐는데 복원 전에 끊긴 경우 — 복원 1회 재시도(재조회 → 행 찾기 → 원복 입력 → 저장 → 재조회 확인)
      if (out.saved && !out.restored) {
        try { await nscm.search(); let rr = await nscm.findRowByKey(key); if (rr < 0) rr = row; await nscm.setCell(rr, col, nv.restore, 0); const s3 = await nscm.save(); await nscm.search(); let r3 = await nscm.findRowByKey(key); if (r3 < 0) r3 = rr; out.restored = same(await cellOf(r3), orig); out.notes.push(`복원 재시도 ${out.restored ? '성공' : '실패'}${s3.message ? ' (' + s3.message + ')' : ''}`); }
        catch (e2) { out.notes.push(`복원 재시도 예외: ${String(e2).split('\n')[0].slice(0, 120)}`); }
      }
    }
    countSave(); annotate(info, out); return out;
  }

  // Insert 가 있는 화면: 마커 행 C → R → U → D, 어떤 경우에도 마커 행 정리
  out.mode = 'insert';
  const grid = nscm.grid(0);
  const rowsLoc = () => grid.locator('.wj-cells .wj-row');
  const findMark = async (m: string) => { const n = await rowsLoc().count(); for (let i = 0; i < n; i++) if ((await rowsLoc().nth(i).innerText().catch(() => '')).includes(m)) return i; return -1; };
  const headers = await nscm.gridHeaders(0);
  const keyCols: string[] = plan.keyColumns || [];
  const targetCol = Math.max(keyCols.length ? headers.findIndex(h => h.toLowerCase() === keyCols[0].toLowerCase()) : 0, 0);
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
      await nscm.setCell(ri, targetCol, mark);
      for (const kc of keyCols.slice(1)) { const ci = headers.findIndex(h => h.toLowerCase() === kc.toLowerCase()); if (ci >= 0) await nscm.setCell(ri, ci, mark); }
      const s1 = await nscm.save();
      out.saved = !ERR.test(s1.message || '') && s1.calls.every(c => c.status < 400);
      if (!out.saved) out.saveErrors.push(`SAVE: ${s1.message || s1.calls.map(c => `${c.btn} HTTP ${c.status}`).join(',')}`);
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
