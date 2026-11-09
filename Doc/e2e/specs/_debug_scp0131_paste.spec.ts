// 디버그(2026-11-09): SCP0131 Plan Group(OPMZ_PLAN_GR_ID) Copy & Paste 재현 — 사용자 보고 '붙이기 안됨'. 저장하지 않는다(쓰기 요청 차단)
//   실제 사용자 경로와 같게: 기존 행 셀 Copy(그리드 getClipString = Ctrl+C 결과) → 신규 행 셀 선택 → 'paste' 이벤트(clipboardData) 를 그리드 host 에 보낸다
//   (공용 DataGrid paste 리스너 → setClipString → pastingCell 게이트 → pastedCell 화면 핸들러 순서 그대로)
import { test } from '../../../tools/E2E/fixtures/test';
import { probe } from '../../../tools/E2E/lib/probe';

test('SCP0131 Plan Group 붙여넣기 재현 @dbgpaste', async ({ nscm }) => {
  test.setTimeout(400_000);
  const p = nscm.page;
  const writes: string[] = []; p.on('request', q => { if (q.method() !== 'GET' && /SAVE|DELETE|INSERT|UPDATE|MERGE/i.test(q.url() + (q.postData() || '').slice(0, 300))) writes.push(q.url().slice(-60)); });  // 저장 버튼을 누르지 않는다 — 쓰기 요청 수만 센다
  await nscm.openScreen('SCP0131');
  await nscm.search(); for (let k = 0; k < 240 && (await probe.rowCount(p)) <= 0; k++) await p.waitForTimeout(500);
  await nscm.clearDialogs();
  const CTL = `(() => { const el = [...document.querySelectorAll('.wj-flexgrid')].find(e => e.offsetParent !== null); return el && el['$WJ-CTRL']; })()`;
  // 1) 기존 행 Plan Group 셀: 원값·표시값·Ctrl+C 결과(getClipString)
  const src = await p.evaluate(`(() => { const c = ${CTL}; const k = c.columns.getColumn('OPMZ_PLAN_GR_ID'); const cr = new wijmo.grid.CellRange(0, k.index); let clip = ''; try { clip = c.getClipString(cr); } catch (e) { clip = 'ERR ' + e; } const d = c.rows[0].dataItem; const all = new wijmo.grid.CellRange(0, 0, 0, c.columns.length - 1); return { div: d.DIVISION_ID, raw: d.OPMZ_PLAN_GR_ID, disp: c.getCellData(0, k.index, true), clip, rowClip: c.getClipString(all), dmEditable: !!(k.dataMap && k.dataMap.isEditable), cols: c.columns.map(x => x.binding).join('|') }; })()`.replace(/wijmo\.grid\.CellRange/g, 'c.selection.constructor')).catch(e => ({ err: String(e) }));
  console.log('SRC', JSON.stringify(src));
  await nscm.subButton('Insert').click(); await p.waitForTimeout(1500); await nscm.clearDialogs();
  const nr = (await probe.findRow(p, 'new'))!;
  console.log('NEWROW', nr.row, 'div', await probe.value(p, nr.row, 'DIVISION_ID'));
  const cands = await p.evaluate(`(() => { const c = ${CTL}; const k = c.columns.getColumn('OPMZ_PLAN_GR_ID'); const d = c.rows[${nr.row}].dataItem; return k.dataMap ? k.dataMap.getDisplayValues(d).slice(0, 20).map(n => n + '=' + k.dataMap.getKeyValue(n)) : null; })()`);
  console.log('CANDS(before edit)', JSON.stringify(cands));
  const tryPaste = async (label: string, text: string) => {
    await p.evaluate(`(() => { const c = ${CTL}; c.rows[${nr.row}].dataItem.OPMZ_PLAN_GR_ID = ''; c.invalidate(); })()`);
    const r = await p.evaluate(`new Promise(res => { const c = ${CTL}; const k = c.columns.getColumn('OPMZ_PLAN_GR_ID'); const ev = []; const h1 = (s, e) => ev.push('pasting d=' + JSON.stringify(e.data) + ' cancel=' + !!e.cancel); const h2 = (s, e) => ev.push('pasted d=' + JSON.stringify(e.data) + ' item=' + JSON.stringify(c.rows[${nr.row}].dataItem.OPMZ_PLAN_GR_ID)); c.pastingCell.addHandler(h1); c.pastedCell.addHandler(h2); c.select(${nr.row}, k.index); c.focus(); const dt = new DataTransfer(); dt.setData('text/plain', ${JSON.stringify(text)}); const pe = new ClipboardEvent('paste', { clipboardData: dt, bubbles: true, cancelable: true }); c.hostElement.dispatchEvent(pe); setTimeout(() => { c.pastingCell.removeHandler(h1); c.pastedCell.removeHandler(h2); res({ ev, sel: [c.selection.row, c.selection.col, k.index], raw: c.rows[${nr.row}].dataItem.OPMZ_PLAN_GR_ID, disp: c.getCellData(${nr.row}, k.index, true), prevented: pe.defaultPrevented }); }, 1200); })`);
    console.log('PASTE', label, JSON.stringify(text).slice(0, 60), '→', JSON.stringify(r));
  };
  const clip = (src as { clip?: string }).clip || '';
  await tryPaste('A 기존행 셀 Copy 결과', clip);
  const firstName = Array.isArray(cands) && cands.length ? String(cands[0]).split('=')[0] : '';
  const firstCode = Array.isArray(cands) && cands.length ? String(cands[0]).split('=').slice(1).join('=') : '';
  await tryPaste('B 후보 표시명', firstName);
  await tryPaste('C 후보 코드', firstCode);
  await tryPaste('D 기존행 원값', String((src as { raw?: string }).raw || ''));
  // E·F: 유효(VALID_YN=Y) 그룹 행(PG0009 등)에서 셀 Copy / 행 전체 Copy → 신규 행 붙여넣기
  const vr = await p.evaluate(`(() => { const c = ${CTL}; const k = c.columns.getColumn('OPMZ_PLAN_GR_ID'); const ok = new Set(${JSON.stringify((Array.isArray(cands) ? cands : []).map(x => String(x).split('=').slice(1).join('=')))}); for (let i = 0; i < c.rows.length; i++) { const d = c.rows[i].dataItem; if (d && d.CRUD_TYPE !== 'I' && ok.has(String(d.OPMZ_PLAN_GR_ID))) { const CR = c.selection.constructor; return { i, code: d.OPMZ_PLAN_GR_ID, cell: c.getClipString(new CR(i, k.index)), row: c.getClipString(new CR(i, 0, i, c.columns.length - 1)) }; } } return null; })()`) as { i: number; code: string; cell: string; row: string } | null;
  console.log('VALIDROW', JSON.stringify(vr));
  if (vr) {
    await tryPaste('E 유효그룹 행 셀 Copy', vr.cell);
    // F: 행 전체 붙여넣기 — 신규 행 첫 칸(Division) 선택 후 paste
    await p.evaluate(`(() => { const c = ${CTL}; c.rows[${nr.row}].dataItem.OPMZ_PLAN_GR_ID = ''; c.invalidate(); })()`);
    const f = await p.evaluate(`new Promise(res => { const c = ${CTL}; const k = c.columns.getColumn('OPMZ_PLAN_GR_ID'); const ev = []; const h1 = (s, e) => { if (e.col === k.index) ev.push('pasting d=' + JSON.stringify(e.data) + ' cancel=' + !!e.cancel); }; c.pastingCell.addHandler(h1); c.select(${nr.row}, 0); c.focus(); const dt = new DataTransfer(); dt.setData('text/plain', ${JSON.stringify(vr.row)}); c.hostElement.dispatchEvent(new ClipboardEvent('paste', { clipboardData: dt, bubbles: true, cancelable: true })); setTimeout(() => { c.pastingCell.removeHandler(h1); const d = c.rows[${nr.row}].dataItem; res({ ev, plan: d.OPMZ_PLAN_GR_ID, site: d.SCM_SITE_ID, item: d.ITEM_ID, rank: d.PRIO_RANK }); }, 1500); })`);
    console.log('PASTE F 유효그룹 행 전체 Copy(Division 칸부터)', JSON.stringify(f));
  }
  console.log('WRITES', writes.length, JSON.stringify(writes.slice(0, 5)));
});
