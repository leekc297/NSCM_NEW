// 임시(2026-11-17): SCP0104 사용자의견 6번(붙여넣기)·7번(Dummy) 실제 키 입력 측정. 저장 없음. 측정 뒤 파일 삭제.
import { test } from '../../../tools/E2E/fixtures/test';
import { probe } from '../../../tools/E2E/lib/probe';

const COLS = ['DIVISION_ID', 'SITE_ID', 'SITE_NAME', 'COMPANY_ID', 'COMPANY_NAME', 'PLANT_ID', 'PLANT_NAME', 'FACTORY_ID', 'FACTORY_NAME', 'LINE_ID', 'LINE_NAME', 'NICK_NAME', 'ITEM_ID', 'DUMMY_YN', 'CRUD_TYPE'];
const G = `const els = [...document.querySelectorAll('.wj-flexgrid')].filter(e => e.offsetParent !== null); const g = els.map(e => e['$WJ-CTRL']).find(c => c && c.columns.some(x => x.binding === 'SITE_ID') && c.rows.length > 1);`;

test('SCP0104 op6 op7', async ({ nscm }) => {
  test.setTimeout(300_000);
  const p = nscm.page;
  await p.context().grantPermissions(['clipboard-read', 'clipboard-write']).catch(() => undefined);
  await nscm.openScreen('SCP0104');
  await nscm.search().catch(() => undefined); await probe.waitRows(p, 60_000).catch(() => undefined);
  const insRow = async () => { await p.getByRole('button', { name: /^Insert/ }).first().click(); await p.waitForTimeout(2000); return await p.evaluate(`(() => { ${G} for (let i = 0; i < g.rows.length; i++) { const it = g.rows[i].dataItem; if (it && it.CRUD_TYPE === 'I' && !it.SITE_ID && !it.SITE_NAME && !it.NICK_NAME && (!it.ITEM_ID || it.ITEM_ID === '-')) return i; } return -1; })()`) as number; };
  const snap = (r: number) => p.evaluate(`(() => { ${G} const it = g.rows[${r}].dataItem; return Object.fromEntries(${JSON.stringify(COLS)}.map(c => [c, it[c]])); })()`);
  const srcOf = async () => await p.evaluate(`(() => { ${G} for (let i = 0; i < g.rows.length; i++) { const it = g.rows[i].dataItem; if (it && it.CRUD_TYPE !== 'I' && it.SITE_ID && it.LINE_ID) return i; } return -1; })()`) as number;
  const sheet = await p.evaluate(`(() => { ${G} return g.columns.filter(c => c.binding && c.visible !== false).map(c => c.binding).join(','); })()`);
  console.log('[SHEET COLS]', sheet);
  // 6-a 단일 셀 Ctrl+C → Ctrl+V (Site Name)
  const copyPaste = async (_f: number, c0: string, c1: string, toR: number) => {
    const fromR = await srcOf(); console.log('[SRC]', fromR, JSON.stringify(await snap(fromR)));
    await p.evaluate(`(() => { ${G} const a = g.columns.findIndex(x => x.binding === '${c0}'), b = g.columns.findIndex(x => x.binding === '${c1}'); g.focus(); const CR = g.selection.constructor; g.select(new CR(${fromR}, a, ${fromR}, b)); })()`);
    await p.keyboard.press('Control+C'); await p.waitForTimeout(500);
    await p.evaluate(`(() => { ${G} const a = g.columns.findIndex(x => x.binding === '${c0}'); g.focus(); g.select(${toR}, a); })()`);
    await p.keyboard.press('Control+V'); await p.waitForTimeout(1500);
  };
  const r1 = await insRow();
  await copyPaste(0, 'SITE_NAME', 'SITE_NAME', r1);
  console.log('[6a 단일셀 SITE_NAME Ctrl+V]', r1, JSON.stringify(await snap(r1)));
  const r2 = await insRow();
  await copyPaste(0, 'SITE_ID', 'LINE_NAME', r2 >= 0 ? r2 : r1);
  console.log('[6b 범위 SITE_ID~LINE_NAME Ctrl+V]', r2, JSON.stringify(await snap(r2 >= 0 ? r2 : r1)));
  // 7 목록 밖 이름 직접 입력
  const nameCol = /NICK_NAME/.test(String(sheet)) && !/ITEM_ID/.test(String(sheet).split('NICK_NAME')[0] || '') ? 'NICK_NAME' : 'ITEM_ID';
  const r3 = await insRow(); const c0 = nscm.calls.length;
  for (const col of ['NICK_NAME', 'ITEM_ID']) {
    const ok = await probe.setByEditor(p, r3, col, 'E2EDUMMY1117').catch(e => String(e)); await p.waitForTimeout(3000);
    const calls = nscm.calls.slice(c0).map(c => `${c.sheet}/${c.btn}`);
    console.log(`[7 ${col} 직접 입력]`, r3, ok, JSON.stringify(await snap(r3)), 'calls', JSON.stringify(calls));
  }
  console.log('[nameCol]', nameCol);
});
